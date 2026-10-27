import { describe, expect, it } from 'vitest';

import { SAVE_STATUS, SUB_COL } from '../shipment-change-request-confirm-ssp0003.constants';

import {
  buildConfirmPayload,
  buildDeConfirmPayload,
} from './shipmentChangeRequestConfirmSsp0003Save';

// SSP0003 승인 저장 payload 계약 테스트 — 지키는 것은 **다행 CLOB 인자의 행 구분자**다.
//
// PKG_SSP0003 BODY 16 `C_DELIMITER CONSTANT VARCHAR2(1 CHAR) := '^'` 이고 F_SPL_CNT/P_SPL_ARR 가
//   그 문자로만 토큰을 자른다. 쉼표로 이으면 "C1,C2" 가 토큰 1개가 되어
//     P_SSP0003_SAVE_REQ_DE_CONFIRM 의 DE UPDATE 0건
//     → P_SSP0003_SAVE_REQ_CONFIRM(_40) 에서 ATTRIBUTE2='A' 건수 0 → V_CHANGE_STATUS:='R'(BODY 893~935)
//   즉 **화면은 "저장 완료" 인데 헤더가 반려로 저장되고 XIF 에는 승인행이 쌓인다**(2026-10-26 결함).
//   1행 승인은 구분자가 없어 이 결함을 타지 않았다 — 그래서 런타임 1행 확인으로는 못 잡는다.
// AS-IS 근거는 CString.AppendString 기본 delimiter "^"
//   (GSCM/01.Framework/GSCM.Windows.Forms/Utility/CString.cs:617,
//    SSP0003_ShipmentChangeRequestConfirm.cs L879~884 가 이 함수로 조립).
//
// DB 쪽 판정 쿼리(조회만). XIF 테이블은 `XIF_ERP_SHIP_PLAN_CONFIRM_S_SN` 으로 접근한다 —
//   SCM_MGR 시노님(2026-10-09)이고 실체는 INF_MGR.XIF_ERP_SHIP_PLAN_CONFIRM_S 다.
//   필수: XIF 조인에 `AND x.ATTRIBUTE1 = h.CHANGE_REQ_NO` 를 건다. 같은 CONFIRM_ID 가 여러
//   변경요청에 걸쳐 전송행을 남기므로(실측: 한 CONFIRM_ID 가 요청 4건·행 6건) 이 조건이 없으면
//   과거 요청의 행을 끌어와 오판한다.
//     SELECT h.CHANGE_REQ_NO, h.CHANGE_REQ_STATUS hdr, d.CONFIRM_ID, d.ATTRIBUTE2,
//            TO_CHAR(d.LAST_UPDATE_DATE,'HH24:MI') de_upd, x.SHIPMENT_STATUS xif
//       FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ h
//       JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE d ON d.CHANGE_REQ_NO = h.CHANGE_REQ_NO
//       LEFT JOIN XIF_ERP_SHIP_PLAN_CONFIRM_S_SN x
//              ON x.CONFIRM_ID = d.CONFIRM_ID AND x.ATTRIBUTE1 = h.CHANGE_REQ_NO
//      WHERE h.CHANGE_REQ_NO = :reqNo ORDER BY d.CONFIRM_ID;
//   기대값 — 2행 전체승인: hdr='A', ATTRIBUTE2='A' 2행, de_upd 가 승인시각, xif='A' /
//            2행 중 1행만: hdr='P', A·R 각 1행 / 반려: hdr='R', xif='D'.

/** ALL_ARGUMENTS 실측(ora.py 2026-10-26) — P_SSP0003_SAVE_REQ_DE_CONFIRM 7 IN 중 CLOB(=행 결합) 3건. */
const DE_CLOB_PARAMS = ['confirmId', 'newConfirmId', 'statusDetail'] as const;

/** 같은 SP 의 VARCHAR2 스칼라 4건 — 행 수와 무관하게 결합하지 않는다. */
const DE_SCALAR_PARAMS = [
  'changeRequestNo',
  'changeStatus',
  'rejectReason',
  'lastUpdatedBy',
] as const;

/**
 * ALL_ARGUMENTS 실측 — P_SSP0003_SAVE_REQ_CONFIRM(_40) 36 IN 중 CLOB 25건.
 *   position 4(P_DIVISION_ID), 8~25, 29~31, 34~36.
 */
const CONFIRM_CLOB_PARAMS = [
  'divisionId',
  'confirmId',
  'newConfirmId',
  'newEtdDate',
  'newEtaDate',
  'newQty',
  'newShipDate',
  'newYn',
  'newBodId',
  'newRouteId',
  'newIncoterms',
  'newDContry',
  'newDPortCode',
  'newACountry',
  'newAPortCode',
  'newToCountry',
  'newToCity',
  'newLtDay',
  'newTransportMode',
  'remarks',
  'remarks2',
  'remarks3',
  'erpAttr1',
  'erpAttr2',
  'erpAttr3',
] as const;

/**
 * 같은 SP 의 VARCHAR2 스칼라 11건 — p_item_id/p_from_site/p_yyyymmdd 는 행0 단일값이고
 *   감사·세션 인자도 행 단위가 아니다. 여기에 '^' 가 섞이면 SP 가 값을 그대로 컬럼에 넣어 오염된다.
 */
const CONFIRM_SCALAR_PARAMS = [
  'changeRequestNo',
  'changeStatus',
  'rejectReason',
  'itemId',
  'fromSite',
  'yyyymmdd',
  'lastUpdatedBy',
  'timeZone',
  'changeType',
  'delegatee',
  'delegateeDept',
] as const;

const DE_CTX = { changeReqNo: 'R20261026000001', rejectReason: '', userId: 'U1' };

const CONFIRM_CTX = {
  changeReqNo: 'R20261026000001',
  rejectReason: '',
  changeType: 'C',
  delegatee: 'U9',
  delegateeDept: 'D9',
  userId: 'U1',
  timeZone: 'KST',
};

/** NEW_* 편집 컬럼이 모두 채워진 디테일 행. 테스트마다 필요한 값만 덮어쓴다. */
const row = (over: Record<string, unknown> = {}): Record<string, unknown> => ({
  [SUB_COL.CONFIRM_ID]: 'C001',
  [SUB_COL.NEW_BASE_CONFIRM_YN]: 'N',
  [SUB_COL.DIVISION_ID]: '10',
  [SUB_COL.ITEM_ID]: 'IT1',
  [SUB_COL.FROM_SITE]: 'FS1',
  [SUB_COL.STATUS_DETAIL]: 'Q',
  [SUB_COL.NEW_ETD]: '20261101',
  [SUB_COL.NEW_ETA]: '20261120',
  [SUB_COL.NEW_SHIPMENT_CONFIRM_QTY]: '100',
  [SUB_COL.NEW_SHIPMENT_DATE]: '20261030',
  [SUB_COL.NEW_YN]: 'Y',
  [SUB_COL.NEW_BOD_ID]: 'B1',
  [SUB_COL.NEW_ROUTE]: 'RT1',
  [SUB_COL.NEW_INCOTERMS]: 'FOB',
  [SUB_COL.NEW_D_COUNTRY]: 'KR',
  [SUB_COL.NEW_D_PORT_CODE]: 'KRPUS',
  [SUB_COL.NEW_A_COUNTRY]: 'US',
  [SUB_COL.NEW_A_PORT_CODE]: 'USLAX',
  [SUB_COL.NEW_TO_COUNTRY]: 'US',
  [SUB_COL.NEW_TO_CITY]: 'LA',
  [SUB_COL.NEW_LT_DAY]: '7',
  [SUB_COL.NEW_TRANSPORT_MODE]: 'SEA',
  [SUB_COL.REMARKS]: 'R1',
  [SUB_COL.REMARKS2]: 'R2',
  [SUB_COL.REMARKS3]: 'R3',
  [SUB_COL.ERP_ATTR1]: 'A1',
  [SUB_COL.ERP_ATTR2]: 'A2',
  [SUB_COL.ERP_ATTR3]: 'A3',
  ...over,
});

const tokens = (payload: Record<string, string>, key: string): string[] =>
  payload[key].split('^');

/** 승인 2행: base 행(C001) + 추가행(C002). 전행 체크. */
const twoRows = [
  row({ [SUB_COL.CONFIRM_ID]: 'C001', [SUB_COL.NEW_BASE_CONFIRM_YN]: 'Y' }),
  row({ [SUB_COL.CONFIRM_ID]: 'C002' }),
];
const allChecked = new Set(['C001', 'C002']);

describe('buildDeConfirmPayload — 다행 구분자', () => {
  it('2행이면 CLOB 인자를 ^ 로 잇고 쉼표를 쓰지 않는다', () => {
    const payload = buildDeConfirmPayload(twoRows, allChecked, SAVE_STATUS.APPROVED, 'A', DE_CTX);
    for (const key of DE_CLOB_PARAMS) {
      expect(payload[key], key).toContain('^');
      expect(payload[key], key).not.toContain(',');
      expect(tokens(payload, key).length, `${key} 토큰 수`).toBe(2);
    }
  });

  it('부분승인 statusDetail 이 A^R 이다 — 이게 쉼표면 헤더가 반려로 저장된다', () => {
    const payload = buildDeConfirmPayload(
      twoRows,
      new Set(['C001']), // C002 미체크 → R
      SAVE_STATUS.APPROVED,
      'P',
      DE_CTX
    );
    expect(payload.statusDetail).toBe('A^R');
  });

  it('전행 승인이면 statusDetail 이 A^A 다', () => {
    const payload = buildDeConfirmPayload(twoRows, allChecked, SAVE_STATUS.APPROVED, 'A', DE_CTX);
    expect(payload.statusDetail).toBe('A^A');
    expect(payload.newConfirmId).toBe('C001^C002');
    expect(payload.confirmId).toBe('C001^C001'); // base 를 전행 반복(AS-IS L840-846)
  });

  it('1행이면 구분자가 없다', () => {
    const payload = buildDeConfirmPayload(
      [row({ [SUB_COL.NEW_BASE_CONFIRM_YN]: 'Y' })],
      new Set(['C001']),
      SAVE_STATUS.APPROVED,
      'A',
      DE_CTX
    );
    for (const key of DE_CLOB_PARAMS) {
      expect(payload[key], key).not.toContain('^');
    }
    expect(payload.statusDetail).toBe('A');
  });

  it('스칼라 4건은 행 수와 무관하게 결합되지 않는다', () => {
    const payload = buildDeConfirmPayload(twoRows, allChecked, SAVE_STATUS.APPROVED, 'A', DE_CTX);
    for (const key of DE_SCALAR_PARAMS) {
      expect(payload[key], key).not.toContain('^');
    }
  });
});

describe('buildConfirmPayload — 다행 구분자', () => {
  it('승인 2행이면 CLOB 25건을 ^ 로 잇고 쉼표를 쓰지 않는다', () => {
    const { payload } = buildConfirmPayload(
      twoRows,
      allChecked,
      SAVE_STATUS.APPROVED,
      'A',
      CONFIRM_CTX
    );
    for (const key of CONFIRM_CLOB_PARAMS) {
      expect(payload[key], key).not.toContain(',');
      expect(tokens(payload, key).length, `${key} 토큰 수`).toBe(2);
    }
    expect(payload.newConfirmId).toBe('C001^C002');
    expect(payload.divisionId).toBe('10^10');
  });

  it('1행 승인이면 CLOB 인자에 구분자가 없다', () => {
    const { payload } = buildConfirmPayload(
      [row({ [SUB_COL.NEW_BASE_CONFIRM_YN]: 'Y' })],
      new Set(['C001']),
      SAVE_STATUS.APPROVED,
      'A',
      CONFIRM_CTX
    );
    for (const key of CONFIRM_CLOB_PARAMS) {
      expect(payload[key], key).not.toContain('^');
    }
    expect(payload.newConfirmId).toBe('C001');
  });

  it('미체크 행은 승인 payload 에 들어오지 않는다(토큰 수 = 체크행 수, L1070-1072)', () => {
    const { payload } = buildConfirmPayload(
      twoRows,
      new Set(['C001']),
      SAVE_STATUS.APPROVED,
      'P',
      CONFIRM_CTX
    );
    for (const key of CONFIRM_CLOB_PARAMS) {
      expect(payload[key], key).not.toContain('^');
    }
    expect(payload.newConfirmId).toBe('C001');
  });

  it('스칼라 11건은 행 수와 무관하게 결합되지 않는다', () => {
    const { payload } = buildConfirmPayload(
      twoRows,
      allChecked,
      SAVE_STATUS.APPROVED,
      'A',
      CONFIRM_CTX
    );
    for (const key of CONFIRM_SCALAR_PARAMS) {
      expect(payload[key], key).not.toContain('^');
    }
    expect(payload.itemId).toBe('IT1');
    expect(payload.yyyymmdd).toBe('20261030');
  });

  it('행 순서와 값 정렬이 유지된다 — 밀림이 없다', () => {
    const { payload } = buildConfirmPayload(
      [
        row({
          [SUB_COL.CONFIRM_ID]: 'CA',
          [SUB_COL.NEW_BASE_CONFIRM_YN]: 'Y',
          [SUB_COL.NEW_SHIPMENT_DATE]: '20261030',
        }),
        row({ [SUB_COL.CONFIRM_ID]: 'CB', [SUB_COL.NEW_SHIPMENT_DATE]: '20261111' }),
      ],
      new Set(['CA', 'CB']),
      SAVE_STATUS.APPROVED,
      'A',
      CONFIRM_CTX
    );
    expect(tokens(payload, 'newConfirmId')).toEqual(['CA', 'CB']);
    expect(tokens(payload, 'newShipDate')).toEqual(['20261030', '20261111']);
    expect(tokens(payload, 'confirmId')).toEqual(['CA', 'CA']); // base 반복
  });

  it('반려(R)는 NEW_* 를 비우고 division 은 행0 단일이다 — 구분자가 생기지 않는다', () => {
    const { payload, is40 } = buildConfirmPayload(twoRows, new Set(), SAVE_STATUS.REJECT, 'R', {
      ...CONFIRM_CTX,
      rejectReason: 'no stock',
    });
    for (const key of CONFIRM_CLOB_PARAMS) {
      expect(payload[key], key).not.toContain('^');
    }
    expect(payload.divisionId).toBe('10');
    expect(payload.newConfirmId).toBe('');
    expect(is40).toBe(false);
  });

  it('40 사업부 라우팅은 ^ 결합 후에도 앞2자리로 판정된다', () => {
    const { is40 } = buildConfirmPayload(
      [
        row({ [SUB_COL.CONFIRM_ID]: 'C001', [SUB_COL.NEW_BASE_CONFIRM_YN]: 'Y', [SUB_COL.DIVISION_ID]: '40' }),
        row({ [SUB_COL.CONFIRM_ID]: 'C002', [SUB_COL.DIVISION_ID]: '40' }),
      ],
      allChecked,
      SAVE_STATUS.APPROVED,
      'A',
      CONFIRM_CTX
    );
    expect(is40).toBe(true);
  });
});
