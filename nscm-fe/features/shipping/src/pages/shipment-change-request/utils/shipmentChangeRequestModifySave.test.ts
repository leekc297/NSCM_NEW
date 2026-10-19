import { describe, expect, it } from 'vitest';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from '../shipment-change-request.constants';

import {
  buildDraftingModifyPayload,
  draftingModifyGroups,
} from './shipmentChangeRequestModifySave';

// SSP0201 기존행(수정) 저장 payload 계약 테스트.
//
// 이 파일이 지키는 것은 두 가지다.
//
//   1. **평탄 객체로 나가는지.** 종전엔 공용 `useProcMutation` 으로 `{ data: [행…] }` 을 보냈는데
//      DRAFTING SP 의 PROC_M 에 `JVARCHAR` 가 없어 37 인자가 전부 NULL 로 바인딩됐다. SP 는 NULL
//      입력으로도 예외 없이 끝나 `RESULT_CODE='S'` 를 돌려주므로 **저장 0건인데 성공 토스트**가 떴다.
//      그래서 `data` 키가 없고 37키가 평탄하게 있는지를 여기서 못 박는다.
//
//   2. **토큰 정렬.** SP 가 `F_SPL_CNT(P_ACTIVE_FLAG)` 로 루프 수를 정하고 32개 CLOB 를 모두 그 수로
//      split 한다 — 한 인자의 토큰 수만 어긋나도 값이 행 경계를 넘어 밀려서 ERP 전송행
//      (XIF_ERP_SHIP_PLAN_CONFIRM_S_SN)에 잘못된 출하일·수량이 적재된다.
//
// 런타임 E2E 로는 검증할 수 없다 — DRAFTING 은 공유 DB 에 ERP 전송행을 영구 적재하고 정리 경로가 없다.

/** PROC_M 실측 37 IN 파라미터. 신규행 경로(submitNewDrafting)와 **같은 집합**이다. */
const PROC_IN_PARAMS = [
  'activeFlag', 'changeType', 'divisionId', 'confirmId', 'shipmentQty', 'shipmentDate',
  'fromSite', 'newBodId', 'newRouteId', 'newEtdDate', 'newEtaDate', 'newIncoterms',
  'newTransportMode', 'newDContry', 'newDPortCode', 'newACountry', 'newAPortCode',
  'newCustomerLt', 'newToCountry', 'newToCity', 'editMain', 'editRemark', 'userId',
  'userDeptId', 'electrodeYn', 'electrodeType', 'originFromDivisionId', 'origionToDivisionId',
  'remarks', 'remarks2', 'remarks3', 'changeReqNo', 'changeReasonCode', 'changeReasonDetail',
  'title', 'programId', 'shiptoCode',
] as const;

/** ALL_ARGUMENTS 실측 VARCHAR2 5건 = 행 단위가 아닌 스칼라. 나머지 32건이 CLOB('^' 결합). */
const SCALAR_PARAMS = ['changeType', 'userId', 'userDeptId', 'changeReqNo', 'programId'] as const;

const ROW_PARAMS = PROC_IN_PARAMS.filter(p => !(SCALAR_PARAMS as readonly string[]).includes(p));

const SESSION = { userId: 'U1', userDeptId: 'D1', changeReqNo: 'R20261012000001' };

/** 모든 편집 컬럼이 채워진 수정행. 테스트마다 필요한 값만 덮어쓴다. */
const row = (over: Record<string, unknown> = {}): Record<string, unknown> => ({
  CRUD_TYPE: 'M',
  CHANGE_TYPE: 'C',
  DIVISION_ID: '40',
  CONFIRM_ID: 'C001',
  ERP_SO_NO: '',
  SHIPMENT_CONFIRM_QTY: '100',
  SHIPMENT_DATE: '2026-10-15',
  FROM_SITE: 'FS1',
  NEW_BOD_ID: 'B1',
  NEW_ROUTE_ID: 'RT1',
  NEW_ETD: '20261016',
  NEW_ETA: '20261030',
  INCOTERMS: 'FOB',
  NEW_INCOTERMS: 'CIF-DO-NOT-USE',
  TRANSPORT_MODE: 'SEA',
  NEW_TRANSPORT_MODE: 'AIR-DO-NOT-USE',
  NEW_D_COUNTRY: 'KR',
  NEW_D_PORT_CODE: 'KRPUS',
  NEW_A_COUNTRY: 'US',
  NEW_A_PORT_CODE: 'USLAX',
  NEW_CUSTOMER_LT: '7',
  NEW_TO_COUNTRY: 'US',
  NEW_TO_CITY: 'LA',
  EDIT_MAIN: 'Y',
  EDIT_REMARKS: 'ER',
  ELECTRODE_YN: 'N',
  ELECTRODE_TYPE: '',
  ORIGIN_FROM_DIVISION_ID: '40',
  ORIGIN_TO_DIVISION_ID: '20',
  REMARKS: 'R1',
  REMARKS2: 'R2',
  REMARKS3: 'R3',
  CHANGE_REASON_CODE: 'T07',
  CHANGE_REASON_DETAIL: 'detail',
  TO_SITE_SHIPTO_CODE: 'ST1',
  ...over,
});

const tokens = (payload: Record<string, string>, key: string): string[] => payload[key].split('^');

describe('buildDraftingModifyPayload — 수정 1행(SO 없음)', () => {
  it('37키 평탄 객체다 — data 키가 없다(JVARCHAR 부재로 NULL 바인딩되던 경로 차단)', () => {
    const payload = buildDraftingModifyPayload([row()], SESSION);
    expect(payload).not.toHaveProperty('data');
    expect(Object.keys(payload)).toHaveLength(37);
    expect(Object.keys(payload).sort()).toEqual([...PROC_IN_PARAMS].sort());
    // 값이 전부 문자열이어야 평탄 객체다(중첩 배열/객체가 섞이면 BE 가 다시 못 펼친다).
    for (const [key, value] of Object.entries(payload)) {
      expect(typeof value, `${key} 타입`).toBe('string');
    }
  });

  it('activeFlag 는 행 CRUD_TYPE 인 M 이다 — 신규처럼 I 로 고정하지 않는다', () => {
    expect(buildDraftingModifyPayload([row()], SESSION).activeFlag).toBe('M');
  });

  it('changeType 은 C 고정이다 — 신규의 N 이 아니다', () => {
    expect(buildDraftingModifyPayload([row()], SESSION).changeType).toBe('C');
  });

  it('1행이면 32개 행단위 인자가 모두 1토큰이다(결합자 없음)', () => {
    const payload = buildDraftingModifyPayload([row()], SESSION);
    for (const key of ROW_PARAMS) {
      expect(payload[key], `${key} 는 결합자를 갖지 않는다`).not.toContain('^');
    }
  });

  it('CRUD_TYPE D(삭제 마킹)도 행 값 그대로 싣는다', () => {
    expect(buildDraftingModifyPayload([row({ CRUD_TYPE: 'D' })], SESSION).activeFlag).toBe('D');
  });
});

describe('buildDraftingModifyPayload — 같은 SO 2행 묶음', () => {
  const group = [
    row({ ERP_SO_NO: 'SO1', CONFIRM_ID: 'CA', SHIPMENT_DATE: '2026-10-15' }),
    row({ ERP_SO_NO: 'SO1', CONFIRM_ID: 'CB', SHIPMENT_DATE: '2026-11-11' }),
  ];

  it('스칼라 5개는 결합되지 않는다(행 수와 무관)', () => {
    const payload = buildDraftingModifyPayload(group, SESSION);
    for (const key of SCALAR_PARAMS) {
      expect(payload[key], key).not.toContain('^');
    }
    expect(payload.changeType).toBe('C');
    expect(payload.userId).toBe('U1');
    expect(payload.userDeptId).toBe('D1');
    expect(payload.changeReqNo).toBe('R20261012000001');
    expect(payload.programId).toBe(MENU_ID);
  });

  it('나머지 32개는 모두 토큰 2개다 — 하나라도 어긋나면 행이 밀린다', () => {
    const payload = buildDraftingModifyPayload(group, SESSION);
    for (const key of ROW_PARAMS) {
      expect(tokens(payload, key).length, `${key} 토큰 수`).toBe(2);
    }
  });

  it('행 순서와 값 정렬이 유지된다 — 밀림이 없다', () => {
    const payload = buildDraftingModifyPayload(group, SESSION);
    expect(tokens(payload, 'confirmId')).toEqual(['CA', 'CB']);
    expect(tokens(payload, 'activeFlag')).toEqual(['M', 'M']);
  });

  it('빈 값도 자리를 지킨다 — 토큰이 사라지면 뒤 값이 앞으로 밀려 들어온다', () => {
    const payload = buildDraftingModifyPayload(
      [row({ ERP_SO_NO: 'SO1', REMARKS: '' }), row({ ERP_SO_NO: 'SO1', REMARKS: 'R-second' })],
      SESSION
    );
    expect(tokens(payload, 'remarks')).toEqual(['', 'R-second']);
  });

  it.each([[1], [2], [3], [5]])('%s행이면 32개 행단위 인자가 모두 그만큼의 토큰이다', n => {
    const rows = Array.from({ length: n }, (_, i) =>
      row({ ERP_SO_NO: 'SO1', CONFIRM_ID: `C0${i}` })
    );
    const payload = buildDraftingModifyPayload(rows, SESSION);
    for (const key of ROW_PARAMS) {
      expect(tokens(payload, key).length, `${key} 토큰 수`).toBe(n);
    }
  });

  it('title 은 스칼라가 아니다 — 시트명을 행마다 싣는다', () => {
    const payload = buildDraftingModifyPayload(group, SESSION);
    const sheet = ADMIN_SHEET_NAME[SHEETS.MAIN];
    expect(tokens(payload, 'title')).toEqual([sheet, sheet]);
  });
});

describe('buildDraftingModifyPayload — 원천 컬럼(신규 경로와 다른 축)', () => {
  it('newIncoterms 는 NEW_INCOTERMS 가 아니라 INCOTERMS 에서 온다', () => {
    const payload = buildDraftingModifyPayload([row()], SESSION);
    expect(payload.newIncoterms).toBe('FOB');
    expect(payload.newIncoterms).not.toBe('CIF-DO-NOT-USE');
  });

  it('newTransportMode 는 NEW_TRANSPORT_MODE 가 아니라 TRANSPORT_MODE 에서 온다', () => {
    const payload = buildDraftingModifyPayload([row()], SESSION);
    expect(payload.newTransportMode).toBe('SEA');
    expect(payload.newTransportMode).not.toBe('AIR-DO-NOT-USE');
  });

  it('editMain 은 행 값이다 — 신규처럼 Y 로 고정하지 않는다', () => {
    expect(buildDraftingModifyPayload([row({ EDIT_MAIN: 'N' })], SESSION).editMain).toBe('N');
  });

  it('SP 실명의 오타 파라미터를 교정하지 않고 그대로 보낸다(고치면 NULL 바인딩된다)', () => {
    const payload = buildDraftingModifyPayload([row()], SESSION);
    expect(payload).toHaveProperty('newDContry');
    expect(payload).toHaveProperty('origionToDivisionId');
    expect(payload).not.toHaveProperty('newDCountry');
    expect(payload).not.toHaveProperty('originToDivisionId');
    // newACountry 는 정상 철자다 — 이쪽을 오타로 "맞추지" 않는다.
    expect(payload).toHaveProperty('newACountry');
    expect(payload).not.toHaveProperty('newAConuntry');
  });

  it('fromSite 는 코드열(FROM_SITE)이다 — CONFIRM_NEW 의 DESCRIPTION 축과 다르다', () => {
    const payload = buildDraftingModifyPayload(
      [row({ FROM_SITE: 'FS1', FROM_SITE_DESCRIPTION: 'DESC-DO-NOT-USE' })],
      SESSION
    );
    expect(payload.fromSite).toBe('FS1');
  });

  it('changeReasonCode 는 콤보 더미 하이픈을 제거한다', () => {
    expect(
      buildDraftingModifyPayload([row({ CHANGE_REASON_CODE: '-' })], SESSION).changeReasonCode
    ).toBe('');
  });

  it('shipmentDate 는 신규 경로와 같은 SP 날짜형식으로 변환한다', () => {
    expect(buildDraftingModifyPayload([row()], SESSION).shipmentDate).toBe(
      '2026-10-15 00:00:00.000'
    );
  });
});

describe('draftingModifyGroups — 호출 단위(AS-IS NonSoNo/SoNo)', () => {
  it('ERP_SO_NO 가 없는 수정행은 행마다 1묶음이다(NonSoNo 는 단일행)', () => {
    const groups = draftingModifyGroups([row({ CONFIRM_ID: 'C1' }), row({ CONFIRM_ID: 'C2' })]);
    expect(groups).toHaveLength(2);
    expect(groups.every(g => g.length === 1)).toBe(true);
  });

  it('같은 ERP_SO_NO 는 한 묶음으로 합친다(SoNo 중복 가드)', () => {
    const groups = draftingModifyGroups([
      row({ ERP_SO_NO: 'SO1', CONFIRM_ID: 'C1' }),
      row({ ERP_SO_NO: 'SO1', CONFIRM_ID: 'C2' }),
    ]);
    expect(groups).toHaveLength(1);
    expect(groups[0]).toHaveLength(2);
  });

  it('서로 다른 SO 2건은 둘 다 저장된다(AS-IS iCallChk 누락 버그 미복제)', () => {
    const groups = draftingModifyGroups([row({ ERP_SO_NO: 'SO1' }), row({ ERP_SO_NO: 'SO2' })]);
    expect(groups).toHaveLength(2);
  });

  it('CHANGE_TYPE P 행은 제외한다', () => {
    expect(draftingModifyGroups([row({ CHANGE_TYPE: 'P' })])).toHaveLength(0);
  });

  it('같은 SO 묶음에서도 CHANGE_TYPE P 멤버는 빠진다', () => {
    const groups = draftingModifyGroups([
      row({ ERP_SO_NO: 'SO1', CONFIRM_ID: 'C1' }),
      row({ ERP_SO_NO: 'SO1', CONFIRM_ID: 'C2', CHANGE_TYPE: 'P' }),
    ]);
    expect(groups).toHaveLength(1);
    expect(groups[0].map(r => r.CONFIRM_ID)).toEqual(['C1']);
  });

  it('P 행만 있으면 0묶음이다 — 호출부가 "변경 없음" 으로 알린다', () => {
    expect(
      draftingModifyGroups([row({ CHANGE_TYPE: 'P' }), row({ CHANGE_TYPE: 'P' })])
    ).toHaveLength(0);
  });

  it('미변경 행(CRUD_TYPE 공백)은 묶음에 넣지 않는다', () => {
    expect(draftingModifyGroups([row({ CRUD_TYPE: '' })])).toHaveLength(0);
    const groups = draftingModifyGroups([
      row({ ERP_SO_NO: 'SO1', CONFIRM_ID: 'C1' }),
      row({ ERP_SO_NO: 'SO1', CONFIRM_ID: 'C2', CRUD_TYPE: '' }),
    ]);
    expect(groups).toHaveLength(1);
    expect(groups[0].map(r => r.CONFIRM_ID)).toEqual(['C1']);
  });

  it('신규행만 있으면 수정 묶음은 0건이다(저장은 CONFIRM_NEW 소관)', () => {
    expect(draftingModifyGroups([row({ CRUD_TYPE: 'I' })])).toHaveLength(0);
  });

  it('같은 SO 의 신규행은 묶음 멤버로 함께 싣는다(AS-IS 가 I 도 멤버로 본다)', () => {
    const groups = draftingModifyGroups([
      row({ ERP_SO_NO: 'SO1', CONFIRM_ID: 'C1', CRUD_TYPE: 'M' }),
      row({ ERP_SO_NO: 'SO1', CONFIRM_ID: 'C2', CRUD_TYPE: 'I' }),
    ]);
    expect(groups).toHaveLength(1);
    expect(groups[0]).toHaveLength(2);
  });

  it('CRUD_TYPE D 는 수정저장 대상이다(AS-IS action != I)', () => {
    expect(draftingModifyGroups([row({ CRUD_TYPE: 'D' })])).toHaveLength(1);
  });
});
