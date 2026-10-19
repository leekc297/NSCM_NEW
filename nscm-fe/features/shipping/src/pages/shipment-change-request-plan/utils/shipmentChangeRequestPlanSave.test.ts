import { describe, expect, it } from 'vitest';

import { ADMIN_SHEET_NAME, COLUMN, SHEETS } from '../shipment-change-request-plan.constants';

import type { GridRowData } from './shipmentChangeRequestPlanDerive';
import {
  buildDraftingModifyPayload,
  draftingModifyGroups,
} from './shipmentChangeRequestPlanSave';

// SSP0200 수정저장(Save) payload 계약 테스트.
//
// 이 파일이 지키는 것은 **ERP 전송 데이터의 정합성**이다. 저장 SP 는
//   `V_MAX_LOOP_CNT := F_SPL_CNT(P_ACTIVE_FLAG)` (PKG_SSP0200 body 1310)로 루프 수를 정하고
//   34개 CLOB 인자를 전부 그 수로 split 한다 — 한 인자의 토큰 수만 어긋나도 값이 행 경계를 넘어
//   밀려서 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN 에 **잘못된 출하일·수량이 적재된다**.
//   AS-IS 가 실제로 그 버그를 갖고 있어(cs:4407~4408 이중 append) 교정했고, 그 교정이 살아 있는지를
//   여기서 못 박는다. 상세 근거: design/10_modify-save-parity.md §5 D-1.
//
// 런타임 E2E 로는 이 검증을 할 수 없다 — `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW` 본문 1649행이
//   `COMMIT;` 이라 한 번 호출하면 공유 DB 에 ERP 전송행이 영구 적재되고 정리 경로가 없다.

/** SCM_ADM_PROC_M 실측(ora.py 2026-10-03) 39개 IN 파라미터명. 순서는 SORT_ORD. */
const PROC_IN_PARAMS = [
  'activeFlag', 'changeType', 'divisionId', 'confirmId', 'shipmentQty', 'shipmentDate',
  'fromSite', 'newBodId', 'newRouteId', 'newEtdDate', 'newEtaDate', 'newIncoterms',
  'newTransportMode', 'newDContry', 'newDPortCode', 'newACountry', 'newAPortCode',
  'newCustomerLt', 'newToCountry', 'newToCity', 'editMain', 'editRemark', 'userId',
  'userDeptId', 'electrodeYn', 'electrodeType', 'originFromDivisionId', 'origionToDivisionId',
  'remarks', 'remarks2', 'remarks3', 'changeReqNo', 'changeReasonCode', 'changeReasonDetail',
  'title', 'programId', 'erpAttr1', 'erpAttr2', 'erpAttr3',
] as const;

/** ALL_ARGUMENTS 실측 VARCHAR2 5건 = 행 단위가 아닌 스칼라. 나머지 34건이 CLOB('^' 결합). */
const SCALAR_PARAMS = ['changeType', 'userId', 'userDeptId', 'changeReqNo', 'programId'] as const;

const ROW_PARAMS = PROC_IN_PARAMS.filter(
  p => !(SCALAR_PARAMS as readonly string[]).includes(p)
);

const SESSION = { userId: 'U1', userDeptId: 'D1', changeReqNo: 'R20261003000001' };

/** 모든 편집 컬럼이 채워진 수정행. 테스트마다 필요한 값만 덮어쓴다. */
const row = (over: Partial<Record<string, unknown>> = {}): GridRowData =>
  ({
    CRUD_TYPE: 'M',
    [COLUMN.CHANGE_TYPE]: 'C',
    [COLUMN.DIVISION_ID]: '10',
    [COLUMN.CONFIRM_ID]: 'C001',
    [COLUMN.ERP_SO_NO]: '',
    [COLUMN.SHIPMENT_CONFIRM_QTY]: '100',
    [COLUMN.SHIPMENT_DATE]: '2026-10-05',
    [COLUMN.FROM_SITE]: 'FS1',
    [COLUMN.NEW_BOD_ID]: 'B1',
    [COLUMN.NEW_ROUTE_ID]: 'RT1',
    [COLUMN.NEW_ETD]: '2026-10-06',
    [COLUMN.NEW_ETA]: '2026-10-20',
    [COLUMN.INCOTERMS]: 'FOB',
    [COLUMN.NEW_INCOTERMS]: 'CIF-DO-NOT-USE',
    [COLUMN.TRANSPORT_MODE]: 'SEA',
    [COLUMN.NEW_TRANSPORT_MODE]: 'AIR-DO-NOT-USE',
    [COLUMN.NEW_D_COUNTRY]: 'KR',
    [COLUMN.NEW_D_PORT_CODE]: 'KRPUS',
    [COLUMN.NEW_A_COUNTRY]: 'US',
    [COLUMN.NEW_A_PORT_CODE]: 'USLAX',
    [COLUMN.NEW_CUSTOMER_LT]: '7',
    [COLUMN.NEW_TO_COUNTRY]: 'US',
    [COLUMN.NEW_TO_CITY]: 'LA',
    [COLUMN.EDIT_MAIN]: 'Y',
    [COLUMN.EDIT_REMARKS]: 'ER',
    [COLUMN.ELECTRODE_YN]: 'N',
    [COLUMN.ELECTRODE_TYPE]: '',
    [COLUMN.ORIGIN_FROM_DIVISION_ID]: '10',
    [COLUMN.ORIGIN_TO_DIVISION_ID]: '20',
    [COLUMN.REMARKS]: 'R1',
    [COLUMN.REMARKS2]: 'R2',
    [COLUMN.REMARKS3]: 'R3',
    [COLUMN.CHANGE_REASON_CODE]: 'T07',
    [COLUMN.CHANGE_REASON_DETAIL]: 'detail',
    [COLUMN.ERP_ATTR1]: 'A1',
    [COLUMN.ERP_ATTR2]: 'A2',
    [COLUMN.ERP_ATTR3]: 'A3',
    ...over,
  }) as GridRowData;

const tokens = (payload: Record<string, string>, key: string): string[] =>
  payload[key].split('^');

describe('buildDraftingModifyPayload — SP 계약', () => {
  it('39개 IN 파라미터를 하나도 빠뜨리거나 더하지 않는다', () => {
    const payload = buildDraftingModifyPayload([row()], SESSION);
    expect(Object.keys(payload).sort()).toEqual([...PROC_IN_PARAMS].sort());
  });

  it('SP 실명의 오타 파라미터를 교정하지 않고 그대로 보낸다(고치면 NULL 바인딩된다)', () => {
    const payload = buildDraftingModifyPayload([row()], SESSION);
    expect(payload).toHaveProperty('newDContry');
    expect(payload).toHaveProperty('origionToDivisionId');
    expect(payload).not.toHaveProperty('newDCountry');
    expect(payload).not.toHaveProperty('originToDivisionId');
  });

  it('스칼라 5건은 행 수와 무관하게 결합되지 않는다', () => {
    const payload = buildDraftingModifyPayload([row(), row({ CONFIRM_ID: 'C002' })], SESSION);
    for (const key of SCALAR_PARAMS) {
      expect(payload[key], key).not.toContain('^');
    }
    expect(payload.changeType).toBe('C'); // cs:4461 / 4221 고정
    expect(payload.userId).toBe('U1');
    expect(payload.userDeptId).toBe('D1');
    expect(payload.changeReqNo).toBe('R20261003000001');
    expect(payload.programId).toBe('SSP0200');
  });
});

describe('buildDraftingModifyPayload — 토큰 정렬(AS-IS cs:4407 버그 교정, D-1)', () => {
  it.each([[1], [2], [3], [5]])('%s행이면 34개 행단위 인자가 모두 그만큼의 토큰이다', n => {
    const rows = Array.from({ length: n }, (_, i) =>
      row({ [COLUMN.CONFIRM_ID]: `C00${i}` })
    );
    const payload = buildDraftingModifyPayload(rows, SESSION);
    for (const key of ROW_PARAMS) {
      expect(tokens(payload, key).length, `${key} 토큰 수`).toBe(n);
    }
  });

  it('특히 shipmentDate 는 2행에서 3토큰이 되지 않는다(AS-IS 이중 append 미복제)', () => {
    const payload = buildDraftingModifyPayload([row(), row()], SESSION);
    expect(tokens(payload, 'shipmentDate')).toEqual(['20261005', '20261005']);
  });

  it('행 순서와 값 정렬이 유지된다 — 밀림이 없다', () => {
    const payload = buildDraftingModifyPayload(
      [
        row({ [COLUMN.CONFIRM_ID]: 'CA', [COLUMN.SHIPMENT_DATE]: '2026-10-05' }),
        row({ [COLUMN.CONFIRM_ID]: 'CB', [COLUMN.SHIPMENT_DATE]: '2026-11-11' }),
      ],
      SESSION
    );
    expect(tokens(payload, 'confirmId')).toEqual(['CA', 'CB']);
    expect(tokens(payload, 'shipmentDate')).toEqual(['20261005', '20261111']);
  });
});

describe('buildDraftingModifyPayload — 원천 컬럼(신규 2단계와 다른 축)', () => {
  it('newIncoterms/newTransportMode 는 NEW_* 가 아니라 INCOTERMS/TRANSPORT_MODE 에서 온다', () => {
    const payload = buildDraftingModifyPayload([row()], SESSION);
    expect(payload.newIncoterms).toBe('FOB');
    expect(payload.newTransportMode).toBe('SEA');
  });

  it('activeFlag 는 행의 CRUD_TYPE 이다 — 신규처럼 I 로 고정하지 않는다', () => {
    const payload = buildDraftingModifyPayload(
      [row({ CRUD_TYPE: 'M' }), row({ CRUD_TYPE: 'D' })],
      SESSION
    );
    expect(tokens(payload, 'activeFlag')).toEqual(['M', 'D']);
  });

  it('editMain 은 행 값이다 — 신규처럼 Y 로 고정하지 않는다', () => {
    const payload = buildDraftingModifyPayload([row({ [COLUMN.EDIT_MAIN]: 'N' })], SESSION);
    expect(payload.editMain).toBe('N');
  });

  it('changeReasonCode 는 콤보 더미 하이픈을 제거한다(cs:4434)', () => {
    const payload = buildDraftingModifyPayload(
      [row({ [COLUMN.CHANGE_REASON_CODE]: '-' })],
      SESSION
    );
    expect(payload.changeReasonCode).toBe('');
  });

  it('날짜 3종은 8자리 숫자로 보낸다(이관 SP 가 8자리 VARCHAR 와 직접 비교)', () => {
    const payload = buildDraftingModifyPayload([row()], SESSION);
    expect(payload.shipmentDate).toBe('20261005');
    expect(payload.newEtdDate).toBe('20261006');
    expect(payload.newEtaDate).toBe('20261020');
  });

  it('title 은 행마다 시트명을 싣는다(cs:4436)', () => {
    const payload = buildDraftingModifyPayload([row(), row()], SESSION);
    const sheet = ADMIN_SHEET_NAME[SHEETS.MAIN];
    expect(tokens(payload, 'title')).toEqual([sheet, sheet]);
  });
});

describe('draftingModifyGroups — 호출 단위(AS-IS SoNo/NonSoNo)', () => {
  it('ERP_SO_NO 가 없는 수정행은 행마다 1묶음이다(NonSoNo 는 단일행)', () => {
    const groups = draftingModifyGroups([
      row({ [COLUMN.CONFIRM_ID]: 'C1' }),
      row({ [COLUMN.CONFIRM_ID]: 'C2' }),
    ]);
    expect(groups).toHaveLength(2);
    expect(groups.every(g => g.length === 1)).toBe(true);
  });

  it('같은 ERP_SO_NO 는 한 묶음으로 합친다(SoNo 중복 가드)', () => {
    const groups = draftingModifyGroups([
      row({ [COLUMN.ERP_SO_NO]: 'SO1', [COLUMN.CONFIRM_ID]: 'C1' }),
      row({ [COLUMN.ERP_SO_NO]: 'SO1', [COLUMN.CONFIRM_ID]: 'C2' }),
    ]);
    expect(groups).toHaveLength(1);
    expect(groups[0]).toHaveLength(2);
  });

  it('서로 다른 SO 2건은 둘 다 저장된다(AS-IS iCallChk 누락 버그 미복제, D-2)', () => {
    const groups = draftingModifyGroups([
      row({ [COLUMN.ERP_SO_NO]: 'SO1' }),
      row({ [COLUMN.ERP_SO_NO]: 'SO2' }),
    ]);
    expect(groups).toHaveLength(2);
  });

  it('같은 SO 의 미변경 행은 묶음에 넣지 않는다(action I/M/D 만 — cs:4388)', () => {
    const groups = draftingModifyGroups([
      row({ [COLUMN.ERP_SO_NO]: 'SO1', [COLUMN.CONFIRM_ID]: 'C1' }),
      row({ [COLUMN.ERP_SO_NO]: 'SO1', [COLUMN.CONFIRM_ID]: 'C2', CRUD_TYPE: '' }),
    ]);
    expect(groups).toHaveLength(1);
    expect(groups[0].map(r => r[COLUMN.CONFIRM_ID])).toEqual(['C1']);
  });

  it('같은 SO 의 신규행은 묶음에 함께 싣는다(cs:4388 이 I 도 멤버로 본다)', () => {
    const groups = draftingModifyGroups([
      row({ [COLUMN.ERP_SO_NO]: 'SO1', [COLUMN.CONFIRM_ID]: 'C1', CRUD_TYPE: 'M' }),
      row({ [COLUMN.ERP_SO_NO]: 'SO1', [COLUMN.CONFIRM_ID]: 'C2', CRUD_TYPE: 'I' }),
    ]);
    expect(groups).toHaveLength(1);
    expect(groups[0]).toHaveLength(2);
  });

  it('신규행만 있으면 수정 묶음은 0건이다(저장은 CONFIRM_NEW 소관)', () => {
    expect(draftingModifyGroups([row({ CRUD_TYPE: 'I' })])).toHaveLength(0);
  });

  it('CHANGE_TYPE=P 행은 제외한다(cs:3602 / cs:4393)', () => {
    expect(draftingModifyGroups([row({ [COLUMN.CHANGE_TYPE]: 'P' })])).toHaveLength(0);
    const groups = draftingModifyGroups([
      row({ [COLUMN.ERP_SO_NO]: 'SO1', [COLUMN.CONFIRM_ID]: 'C1' }),
      row({ [COLUMN.ERP_SO_NO]: 'SO1', [COLUMN.CONFIRM_ID]: 'C2', [COLUMN.CHANGE_TYPE]: 'P' }),
    ]);
    expect(groups[0].map(r => r[COLUMN.CONFIRM_ID])).toEqual(['C1']);
  });

  it('변경이 전혀 없으면 0묶음이다', () => {
    expect(draftingModifyGroups([row({ CRUD_TYPE: '' })])).toHaveLength(0);
  });
});
