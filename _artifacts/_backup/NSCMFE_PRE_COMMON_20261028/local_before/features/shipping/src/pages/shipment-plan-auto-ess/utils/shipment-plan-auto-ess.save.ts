// PlanDetail Confirm 저장 payload 조립 (design 03 §4.3) — 순수 함수.
//   주의: PKG_SSP0021.P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM(24 IN)은 파라미터가 전건 VARCHAR 라
//   BE 의 JVARCHAR 폴딩(MapUtils.cvtJsonToJVarchar)을 타지 않는다. 본문이 SCM_ARR_SPL_CNT(P_ACTIVE_FLAG,'^')
//   + WHILE LOOP 로 다건을 돌고 UPDATE ... WHERE CONFIRM_ID = V_CONFIRM_ID 로 건별 반영한다(DB ALL_SOURCE
//   L5205~5444 실측). 즉 FE 가 편집 행들을 **컬럼별 '^'-폴딩한 단일 객체**로 보내야 한다 — 행 객체 배열
//   ({data:[]}) 전송(useProcMutation)은 전건 null 바인딩 → P_ACTIVE_FLAG 빈값 → SCM_ARR_SPL_CNT=0 →
//   루프 0회 → 0행 UPDATE 인데 성공 반환(false-success)이다(자매 SSP0060/SSP0015 선례, memory
//   `save-proc-per-column-caret-fold-fe`). payload 키 = SCM_ADM_PROC_M COL_NM(camelCase = all_arguments
//   P_ 제거 + camel, memory `generic-callproc-param-key-must-match-proc-m-colnm`).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// PlanDetail Confirm 저장 — P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM (24 IN, '^'-폴딩 단일 객체).
//   키·행매핑은 05_register_proc_m_confirm 의 COL_NM↔그리드 컬럼 실측(= AS-IS SaveData_Detail
//   .cs L2628-2688 DefColumns)을 그대로 따른다. 자매 SSP0060 collectConfirmSaveRows(38 IN)와 동일 규약,
//   키 집합만 SSP0021 24 IN 으로 축소(SSP0021 proc 은 fromSite/toSite/changeReason/productLevel 파라미터 없음 —
//   사이트 정보는 proc 가 CONFIRM_ID 로 내부 재조회, CHANGE_REASON 은 confirm 테이블에 저장 안 함 = AS-IS 동일).
export type ConfirmSaveFolded = Record<string, string>;

export const collectConfirmSaveRows = (
  dirty: Record<string, unknown>[],
  userId: string
): ConfirmSaveFolded | null => {
  if (dirty.length === 0) return null;
  // 행당 activeFlag — CRUD_TYPE(M/I/D). 편집행은 EDIT_MAIN='Y' 만 있고 CRUD_TYPE 공란일 수 있어 'M' 보정
  //   (DetailGrid cellEditEnded 는 편집 당사자 행에 EDIT_MAIN 만 세팅, CRUD_TYPE 미세팅). proc 은
  //   IF V_ACTIVE_FLAG <> 'I' THEN UPDATE(L5379) 이라 'M' 이면 수정 반영된다. 빈값이면 SCM_ARR_SPL_CNT 집계·
  //   루프 자체가 안 돌아 저장이 전무해진다(false-success 근원).
  const activeFlagOf = (r: Record<string, unknown>): string => {
    const c = str(r.CRUD_TYPE);
    if (c) return c;
    return str(r.EDIT_MAIN) === 'Y' ? 'M' : '';
  };
  // proc camelCase 파라미터(SORT_ORD 1~24) → 행 컬럼. 상수(''/'Y'/userId)는 행마다 반복 폴딩.
  const map: Record<string, (r: Record<string, unknown>) => string> = {
    activeFlag: activeFlagOf, // 1  P_ACTIVE_FLAG (CRUD_TYPE)
    divisionId: r => str(r.DIVISION_ID), // 2  P_DIVISION_ID
    confirmId: r => str(r.CONFIRM_ID), // 3  P_CONFIRM_ID (UPDATE 키)
    shipmentQty: r => str(r.SHIPMENT_CONFIRM_QTY), // 4  P_SHIPMENT_QTY
    // 5  P_SHIPMENT_DATE — 'YYYYMMDD' 로 정규화해 보낸다(그리드 값은 '2026-10-15' 대시 포맷).
    //   proc 의 BOD 경로 조회(SCP_MST_BOD_N_V)가 저장 전 필수 게이트인데
    //   `A.FROM_YYYYMMDD <= V_SHIPMENT_DATE AND A.TO_YYYYMMDD >= V_SHIPMENT_DATE` 를 **대시 제거 전** 값으로
    //   비교한다 → '20260101' <= '2026-10-15' 가 문자열상 거짓('-'(0x2D) < '0'(0x30))이라 0건 → V_*_TEMP
    //   NULL → 'X' 조기반환(저장 실패). 자매 SSP0060 proc 은 2026.10.16(AJS)에 이 비교를
    //   `<= REPLACE(SUBSTR(V_SHIPMENT_DATE,1,10),'-','')` 로 인라인 정규화해 고쳤으나 SSP0021 proc 에는
    //   그 패치가 누락돼 있다(ora.py 실측: 대시 0건 / '20261015' 1건). proc 가 내부에서도 같은
    //   REPLACE(SUBSTR) 정규화를 하므로(UPDATE 직전) FE 선정규화는 안전·forward-compatible 하다
    //   (DB 측 proc 파리티 패치 시 no-op). 그 패치가 배포되면 이 slice/replace 는 제거 가능.
    shipmentDate: r => str(r.SHIPMENT_DATE).slice(0, 10).replace(/-/g, ''),
    newBodId: r => str(r.NEW_BOD_ID), // 6  P_NEW_BOD_ID
    newRouteId: r => str(r.NEW_ROUTE_ID), // 7  P_NEW_ROUTE_ID
    newEtdDate: r => str(r.NEW_ETD), // 8  P_NEW_ETD_DATE
    newEtaDate: r => str(r.NEW_ETA), // 9  P_NEW_ETA_DATE
    newIncoterms: r => str(r.INCOTERMS), // 10 P_NEW_INCOTERMS
    newTransportMode: r => str(r.TRANSPORT_MODE), // 11 P_NEW_TRANSPORT_MODE
    newDContry: r => str(r.NEW_D_COUNTRY), // 12 P_NEW_D_CONTRY (proc 파라미터 철자 그대로)
    newDPortCode: r => str(r.NEW_D_PORT_CODE), // 13 P_NEW_D_PORT_CODE
    newACountry: r => str(r.NEW_A_COUNTRY), // 14 P_NEW_A_COUNTRY
    newAPortCode: r => str(r.NEW_A_PORT_CODE), // 15 P_NEW_A_PORT_CODE
    newCustomerLt: r => str(r.NEW_CUSTOMER_LT), // 16 P_NEW_CUSTOMER_LT
    newToCountry: r => str(r.NEW_TO_COUNTRY), // 17 P_NEW_TO_COUNTRY
    newToCity: r => str(r.NEW_TO_CITY), // 18 P_NEW_TO_CITY
    remarks: r => str(r.REMARKS), // 19 P_REMARKS
    remarks2: r => str(r.REMARKS2), // 20 P_REMARKS2
    remarks3: r => str(r.REMARKS3), // 21 P_REMARKS3
    userId: () => userId, // 22 P_USER_ID (세션)
    checkNeedYn: () => 'Y', // 23 P_CHECK_NEED_YN (AS-IS 상수 'Y' 강제 — SSP0021_ShipmentPlan.cs)
    editMain: r => str(r.EDIT_MAIN), // 24 P_EDIT_MAIN
  };
  const payload: ConfirmSaveFolded = {};
  for (const [key, getter] of Object.entries(map)) {
    payload[key] = dirty.map(getter).join('^');
  }
  return payload;
};
