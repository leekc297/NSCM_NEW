// Main/Detail 저장 payload 조립 (design 03 §3-H/§4.2) — 순수 함수.
//   주의: PKG_SSP0060 의 SAVE proc(SAVE_SHIPMENT_PLAN 15 IN / SAVE_SHIPMENT_REQUEST_CONFIRM 38 IN)은
//   파라미터가 전건 VARCHAR 라 BE 의 JVARCHAR 폴딩(MapUtils.cvtJsonToJVarchar)을 타지 않는다. 본문이
//   SCM_ARR_SPL_CNT(P_*, '^') + WHILE LOOP 로 다건을 도므로(ALL_SOURCE 실측), FE 가 편집 행들을
//   컬럼별 '^'-폴딩한 '단일 객체'로 보내야 한다 — 행 객체 배열({data:[]}) 전송은 전건 null 바인딩 →
//   저장 0행인데 성공 반환(false-success) 사고다(gap-audit iter-5 G01~G03, 자매 SSP0015 선례·memory
//   `save-proc-per-column-caret-fold-fe`). payload 키 = SCM_ADM_PROC_M COL_NM(camelCase = all_arguments
//   P_ 제거 + camel, memory `generic-callproc-param-key-must-match-proc-m-colnm`).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const num = (v: unknown): number => {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
};

export interface MainSaveContext {
  divisionId: string;
  companyId: string;
  planStartYyyymmdd: string; // 선택 Plan Date
  userId: string;
  userDeptId: string;
}

// 편집 셀 1건의 15 IN 값(폴딩 전 단위). 최종 전송은 컬럼별 '^'-join 단일 객체(MainSaveFolded).
interface MainSaveCell {
  activeFlag: string; // 1 P_ACTIVE_FLAG
  divisionId: string; // 2 P_DIVISION_ID
  companyId: string; // 3 P_COMPANY_ID
  fromSite: string; // 4 P_FROM_SITE
  itemId: string; // 5 P_ITEM_ID
  toSite: string; // 6 P_TO_SITE
  transportMode: string; // 7 P_TRANSPORT_MODE
  incoterms: string; // 8 P_INCOTERMS
  fcstType: string; // 9 P_FCST_TYPE
  planStartYyyymmdd: string; // 10 P_PLAN_START_YYYYMMDD
  yyyymmdd: string; // 11 P_YYYYMMDD ('D_20260901' → '20260901')
  shipmentQty: string; // 12 P_SHIPMENT_QTY
  userId: string; // 13 P_USER_ID
  userDeptId: string; // 14 P_USER_DEPT_ID
  debugMode: string; // 15 DEBUG_MODE
}

export type MainSaveFolded = Record<keyof MainSaveCell, string>;

/**
 * Main 저장 대상 수집 — 편집된 D_ 셀(원본값과 다른 셀)만 모아 컬럼별 '^'-폴딩 단일 객체로.
 *   originalOf: EditTracker 가 보관한 행별 "변경된 컬럼 원본값" 맵(그 키 중 D_ 만 diff 대상).
 *   음수(MSG00225 — AS-IS MSG00084)는 negatives 로 분리 — 호출부가 저장 자체를 abort 한다.
 *   변경 셀이 없으면 payload=null.
 */
export const collectMainSaveRows = (
  rows: Record<string, unknown>[],
  dayCols: readonly string[],
  originalOf: (row: Record<string, unknown>) => Record<string, unknown> | undefined,
  ctx: MainSaveContext
): { payload: MainSaveFolded | null; negatives: { row: Record<string, unknown>; day: string }[] } => {
  const cells: MainSaveCell[] = [];
  const negatives: { row: Record<string, unknown>; day: string }[] = [];

  const daySet = new Set(dayCols);
  rows.forEach(row => {
    if (str(row.CRUD_TYPE) !== 'M') return;
    const original = originalOf(row);
    if (!original) return;
    Object.keys(original).forEach(day => {
      if (!daySet.has(day)) return;
      const current = num(row[day]);
      const before = num(original[day]);
      if (current === before) return;
      if (current < 0) {
        negatives.push({ row, day });
        return;
      }
      cells.push({
        activeFlag: 'M', // 1 P_ACTIVE_FLAG — 편집 셀은 수정('M'). SP 는 'M'/'I' 만 DML.
        divisionId: ctx.divisionId, // 2 P_DIVISION_ID
        companyId: ctx.companyId, // 3 P_COMPANY_ID
        fromSite: str(row.FROM_SITE), // 4 P_FROM_SITE
        itemId: str(row.ITEM_ID), // 5 P_ITEM_ID
        toSite: str(row.TO_SITE), // 6 P_TO_SITE
        transportMode: str(row.TRANSPORT_MODE), // 7 P_TRANSPORT_MODE
        incoterms: str(row.INCOTERMS), // 8 P_INCOTERMS
        fcstType: str(row.FCST_TYPE), // 9 P_FCST_TYPE
        planStartYyyymmdd: ctx.planStartYyyymmdd, // 10 P_PLAN_START_YYYYMMDD
        yyyymmdd: day.slice(2), // 11 P_YYYYMMDD ('D_20260901' → '20260901')
        shipmentQty: String(current), // 12 P_SHIPMENT_QTY
        userId: ctx.userId, // 13 P_USER_ID
        userDeptId: ctx.userDeptId, // 14 P_USER_DEPT_ID
        debugMode: 'F', // 15 DEBUG_MODE
      });
    });
  });

  if (cells.length === 0) return { payload: null, negatives };
  // 컬럼별 '^'-폴딩 — proc 이 파라미터마다 같은 개수의 세그먼트를 기대(SCM_ARR_SPL_CNT 기준 루프).
  const fold = (k: keyof MainSaveCell): string => cells.map(c => c[k]).join('^');
  const payload: MainSaveFolded = {
    activeFlag: fold('activeFlag'),
    divisionId: fold('divisionId'),
    companyId: fold('companyId'),
    fromSite: fold('fromSite'),
    itemId: fold('itemId'),
    toSite: fold('toSite'),
    transportMode: fold('transportMode'),
    incoterms: fold('incoterms'),
    fcstType: fold('fcstType'),
    planStartYyyymmdd: fold('planStartYyyymmdd'),
    yyyymmdd: fold('yyyymmdd'),
    shipmentQty: fold('shipmentQty'),
    userId: fold('userId'),
    userDeptId: fold('userDeptId'),
    debugMode: fold('debugMode'),
  };
  return { payload, negatives };
};

// PlanDetail Confirm 저장 — P_SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM (38 IN, '^'-폴딩 단일 객체).
//   키·행매핑은 AS-IS SSP0060_ShipmentPlan.cs SaveData_Detail(L3161~3327) 그대로 — 38 IN 전건.
//   camelCase 키 = all_arguments P_ 제거 + camel(= SCM_ADM_PROC_M COL_NM). 자매 SSP0015
//   collectConfirmSaveRows(24 IN)와 동일 규약, 키 집합만 SSP0060 38 IN 으로 확장.
//   주의: 배열 {data:[]} 전송(useProcMutation)은 38 IN 전건 null 바인딩 → false-success(gap-audit G02).
export type ConfirmSaveFolded = Record<string, string>;

export const collectConfirmSaveRows = (
  dirty: Record<string, unknown>[],
  userId: string
): ConfirmSaveFolded | null => {
  if (dirty.length === 0) return null;
  // 행당 activeFlag — CRUD_TYPE(M/I/D). 편집행은 EDIT_MAIN='Y' 만 있고 CRUD_TYPE 공란일 수 있어 'M' 보정
  //   (AS-IS 는 action = I/M/D 인 행만 처리 — L3207).
  const activeFlagOf = (r: Record<string, unknown>): string => {
    const c = str(r.CRUD_TYPE);
    if (c) return c;
    return str(r.EDIT_MAIN) === 'Y' ? 'M' : '';
  };
  // proc camelCase 파라미터 → 행 컬럼(AS-IS SaveData_Detail CString.AppendString 매핑 L3233~3277).
  //   상수(''/'Y'/'N'/userId)는 행마다 반복 폴딩. FROM/TO_SITE 는 공백 시 *_DESCRIPTION 폴백(AS-IS L3241~3246).
  const map: Record<string, (r: Record<string, unknown>) => string> = {
    activeFlag: activeFlagOf, // 1
    divisionId: r => str(r.DIVISION_ID), // 2
    changeRequestNo: () => '', // 3 — AS-IS 는 항상 '' (L3235)
    confirmId: r => str(r.CONFIRM_ID), // 4
    productLevel1: r => str(r.PRODUCT_LEVEL1), // 5
    itemId: r => str(r.ITEM_ID), // 6
    nickName: r => str(r.NICK_NAME), // 7
    fromSite: r => str(r.FROM_SITE) || str(r.FROM_SITE_DESCRIPTION), // 8
    toSite: r => str(r.TO_SITE) || str(r.TO_SITE_DESCRIPTION), // 9
    projectCode: r => str(r.PROJECT_CODE), // 10
    projectName: r => str(r.PROJECT_NAME), // 11
    fcstType: r => str(r.FCST_TYPE), // 12
    etd: r => str(r.ETD), // 13
    eta: r => str(r.ETA), // 14
    shipmentQty: r => str(r.SHIPMENT_CONFIRM_QTY), // 15
    shipmentDate: r => str(r.SHIPMENT_DATE), // 16 — proc 가 SUBSTR(1,10)+REPLACE('-') 정규화
    newBodId: r => str(r.NEW_BOD_ID), // 17
    newRouteId: r => str(r.NEW_ROUTE_ID), // 18
    newEtdDate: r => str(r.NEW_ETD), // 19
    newEtaDate: r => str(r.NEW_ETA), // 20
    newIncoterms: r => str(r.INCOTERMS), // 21
    newTransportMode: r => str(r.TRANSPORT_MODE), // 22
    newDCountry: r => str(r.NEW_D_COUNTRY), // 23
    newDPortCode: r => str(r.NEW_D_PORT_CODE), // 24
    newACountry: r => str(r.NEW_A_COUNTRY), // 25
    newAPortCode: r => str(r.NEW_A_PORT_CODE), // 26
    newCustomerLt: r => str(r.NEW_CUSTOMER_LT), // 27
    newToCountry: r => str(r.NEW_TO_COUNTRY), // 28
    newToCity: r => str(r.NEW_TO_CITY), // 29
    remarks: r => str(r.REMARKS), // 30
    remarks2: r => str(r.REMARKS2), // 31
    remarks3: r => str(r.REMARKS3), // 32
    userId: () => userId, // 33
    checkNeedYn: () => 'Y', // 34 — AS-IS 는 항상 'Y' (L3273)
    editMain: r => str(r.EDIT_MAIN), // 35
    changeReasonCode: r => str(r.CHANGE_REASON_CODE), // 36
    changeReasonDetail: r => str(r.CHANGE_REASON_DETAIL), // 37
    topFlag: () => 'N', // 38 — AS-IS 는 항상 'N' (L3277)
  };
  const payload: ConfirmSaveFolded = {};
  for (const [key, getter] of Object.entries(map)) {
    payload[key] = dirty.map(getter).join('^');
  }
  return payload;
};
