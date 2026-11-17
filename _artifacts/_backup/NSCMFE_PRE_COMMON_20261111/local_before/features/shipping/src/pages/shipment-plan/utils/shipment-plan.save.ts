// Main/Detail 저장 payload 조립 (design 03 §3-H/§4.2) — 순수 함수.
//   주의: PKG_SSP0060 의 SAVE proc(SAVE_SHIPMENT_PLAN 15 IN / SAVE_SHIPMENT_REQUEST_CONFIRM 38 IN)은
//   파라미터가 전건 VARCHAR 라 BE 의 JVARCHAR 폴딩(MapUtils.cvtJsonToJVarchar)을 타지 않는다. 본문이
//   SCM_ARR_SPL_CNT(P_*, '^') + WHILE LOOP 로 다건을 도므로(ALL_SOURCE 실측), FE 가 편집 행들을
//   컬럼별 '^'-폴딩한 '단일 객체'로 보내야 한다 — 행 객체 배열({data:[]}) 전송은 전건 null 바인딩 →
//   저장 0행인데 성공 반환(false-success) 사고다(gap-audit iter-5 G01~G03, 자매 SSP0015 선례·memory
//   `save-proc-per-column-caret-fold-fe`). payload 키 = SCM_ADM_PROC_M COL_NM(camelCase = all_arguments
//   P_ 제거 + camel, memory `generic-callproc-param-key-must-match-proc-m-colnm`).

import { CHANGE_TYPE_SKIP } from '../shipment-plan.constants';

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

/**
 * Request 팝업(변경요청 확정) 저장 행 판정 — AS-IS SSP0060_ShipmentPlanRequestPopup.RowSave_Check
 * (cs L811~820): Confirmed 와 Change 의 **일자 또는 수량이 다른** 행만 확정 대상이다.
 */
export const isRequestRowChanged = (r: Record<string, unknown>): boolean =>
  str(r.SHIPMENT_DATE) !== str(r.NEW_SHIPMENT_DATE) ||
  num(r.SHIPMENT_CONFIRM_QTY) !== num(r.NEW_SHIPMENT_CONFIRM_QTY);

/**
 * Request 팝업 Confirm 저장 — P_SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM (38 IN, '^'-폴딩 단일 객체).
 *   AS-IS SSP0060_ShipmentPlanRequestPopup.SaveData(cs L504~578) 그대로. collectConfirmSaveRows(하단
 *   Plan Detail Confirm)와 **키 집합은 같지만 소스 컬럼이 다르다** — 팝업은 변경요청 확정이라 NEW_* 를
 *   shipment 본값에 싣는다:
 *     shipmentQty      ← NEW_SHIPMENT_CONFIRM_QTY (변경 수량, L551)   [Detail: SHIPMENT_CONFIRM_QTY]
 *     shipmentDate     ← NEW_SHIPMENT_DATE        (변경 일자, L554)   [Detail: SHIPMENT_DATE]
 *     changeRequestNo  ← 행 CHANGE_REQ_NO         (L539)             [Detail: '']
 *     newIncoterms     ← INCOTERMS  / newTransportMode ← TRANSPORT_MODE (팝업 미편집 = 확정값, L559·560)
 *     newCustomerLt    ← NEW_LT_DAY (L565) / topFlag ← NEW_YN (L575)  [Detail: 'N']
 *   저장 대상 = 수량/일자가 바뀐 행만(isRequestRowChanged). activeFlag = 'M' 고정(결함 B1 — 아래 매핑 주석).
 *   SHIPMENT_REQUEST_CONFIRM 는 하단 Detail Confirm 과 동일 SP·엔드포인트(planDetail/SAVE)라 검증됨.
 */
export const collectRequestConfirmSaveRows = (
  rows: Record<string, unknown>[],
  userId: string
): ConfirmSaveFolded | null => {
  const dirty = rows.filter(isRequestRowChanged);
  if (dirty.length === 0) return null;
  const map: Record<string, (r: Record<string, unknown>) => string> = {
    // 1 — 팝업 행은 전부 조회된 기존 행이라 'M'(수정) 고정. AS-IS 팝업도 그리드 행 상태(M)를 보낸다
    //   (SSP0060_ShipmentPlanRequestPopup.cs L584, ACT_FLAG 컬럼 사용부는 L915 에서 주석 처리).
    //   종전엔 GET 결과 ACT_FLAG 를 보냈는데, 기존 Confirm 은 ACT_FLAG='I' 로 와서(PKG GET_..._DRAFTING
    //   L1947) SP 가 신규로 보고 UPDATE 를 건너뛴 채 옛 수량으로 XIF 를 적재했다(결함 B1, 실증
    //   R20261022542846). 'M' 이면 SP 가 원장 있으면 UPDATE, 없으면(증량 신규) INSERT 한다(PKG L7541~).
    activeFlag: () => 'M',
    divisionId: r => str(r.DIVISION_ID), // 2
    changeRequestNo: r => str(r.CHANGE_REQ_NO), // 3 — 팝업은 행 CHANGE_REQ_NO (Detail='')
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
    shipmentQty: r => str(r.NEW_SHIPMENT_CONFIRM_QTY), // 15 — 변경 수량(NEW)
    shipmentDate: r => str(r.NEW_SHIPMENT_DATE), // 16 — 변경 일자(NEW), proc 가 SUBSTR(1,10)+REPLACE('-')
    newBodId: r => str(r.NEW_BOD_ID), // 17
    newRouteId: r => str(r.NEW_ROUTE_ID), // 18
    newEtdDate: r => str(r.NEW_ETD), // 19
    newEtaDate: r => str(r.NEW_ETA), // 20
    newIncoterms: r => str(r.INCOTERMS), // 21 — 팝업 미편집 = 확정 INCOTERMS
    newTransportMode: r => str(r.TRANSPORT_MODE), // 22 — 팝업 미편집 = 확정 TRANSPORT_MODE
    newDCountry: r => str(r.NEW_D_COUNTRY), // 23
    newDPortCode: r => str(r.NEW_D_PORT_CODE), // 24
    newACountry: r => str(r.NEW_A_COUNTRY), // 25
    newAPortCode: r => str(r.NEW_A_PORT_CODE), // 26
    newCustomerLt: r => str(r.NEW_LT_DAY), // 27
    newToCountry: r => str(r.NEW_TO_COUNTRY), // 28
    newToCity: r => str(r.NEW_TO_CITY), // 29
    remarks: r => str(r.REMARKS), // 30
    remarks2: r => str(r.REMARKS2), // 31
    remarks3: r => str(r.REMARKS3), // 32
    checkNeedYn: () => 'Y', // 33
    userId: () => userId, // 34
    editMain: r => str(r.EDIT_MAIN), // 35
    changeReasonCode: r => str(r.CHANGE_REASON_CODE), // 36
    changeReasonDetail: r => str(r.CHANGE_REASON_DETAIL), // 37
    topFlag: r => str(r.NEW_YN), // 38 — 팝업은 행 NEW_YN (Detail='N')
  };
  const payload: ConfirmSaveFolded = {};
  for (const [key, getter] of Object.entries(map)) {
    payload[key] = dirty.map(getter).join('^');
  }
  return payload;
};

// ────────────────────────────────────────────────────────────────────────────────────────
// ERP 송신 연쇄용 순수 함수 — AS-IS SSP0060_ShipmentPlan.cs GetERPInterface(3840~4065)·NonSoNo(4067)·
//   SoNo(4254), 팝업 SSP0060_ShipmentPlanRequestPopup.cs SoNo(1108)·NonSoNo(1282). 호출 배선은
//   shipment-plan.erpChain.ts 가 한다.
// ────────────────────────────────────────────────────────────────────────────────────────

// 날짜 값 → 8자리 yyyymmdd. 날짜로 읽을 수 없으면 undefined (AS-IS DateTime.TryParse 실패 등가, cs:3887~3892).
export const toYmd8 = (v: unknown): string | undefined => {
  const digits = str(v).replace(/\D/g, '').slice(0, 8);
  if (digits.length !== 8) return undefined;
  const y = Number(digits.slice(0, 4));
  const m = Number(digits.slice(4, 6));
  const d = Number(digits.slice(6, 8));
  const dt = new Date(y, m - 1, d);
  return dt.getFullYear() === y && dt.getMonth() === m - 1 && dt.getDate() === d ? digits : undefined;
};

// yyyy-MM-dd 로 맞춘다(날짜가 아니면 원값). DRAFTING SP 가 SUBSTR(1,10)+REPLACE('-') 로 정규화한다
//   (PKG_SSP0060 BODY 6811/6922/6924) — '2026.10.29' 같은 표기는 그대로 보내면 일자 비교가 깨진다.
const toDashYmd = (v: unknown): string => {
  const ymd = toYmd8(v);
  return ymd ? `${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}` : str(v);
};

// 하단 Plan Detail 행의 AS-IS action(I/M/D). 편집행은 EDIT_MAIN='Y' 만 있고 CRUD_TYPE 이 비어 있을 수 있어
//   'M' 으로 본다 — collectConfirmSaveRows 의 activeFlag 판정과 같은 규칙.
export const detailActionOf = (r: Record<string, unknown>): string => {
  const c = str(r.CRUD_TYPE);
  if (c) return c;
  return str(r.EDIT_MAIN) === 'Y' ? 'M' : '';
};

const isIMD = (action: string): boolean => action === 'I' || action === 'M' || action === 'D';

/**
 * 하단 Plan Detail 의 DRAFTING 호출 단위 — AS-IS GetERPInterface 2번째 루프(cs:3910~3955).
 *   'I' 행과 CHANGE_TYPE='P' 행은 건너뛴다(cs:3920·3929). SO 없는 행은 행마다 1단위(NonSoNo),
 *   SO 있는 행은 같은 SO 의 M/D 행 전체가 1단위(SoNo cs:4316~4334). 주의: AS-IS SoNo 루프는 'I' 행도 묶음에
 *   넣지만, 신규행은 원본 CONFIRM_ID 를 복사하므로(PLAN_DETAIL_INSERT_COPY_COLUMNS) DRAFTING 에 같은 confirmId 가
 *   activeFlag 'I' 로 중복 들어간다. TO-BE 는 'I' 를 묶음에서도 뺀다(검토 R4, SSP0023 과 같은 규칙). 신규행은
 *   ERP_SO_NO 를 복사하지 않아 실제로 SO 묶음에 들 일도 거의 없다.
 *   주의: AS-IS SoNo 는 "그리드 위쪽 아무 행(변경 여부 무관)에 같은 SO 가 있으면" 그 묶음을 통째로 건너뛴다
 *   (cs:4259~4268). 위쪽 행이 미변경이면 변경된 SO 묶음이 송신되지 않는 결함이라, TO-BE 는 "이미 처리한 SO"
 *   기준으로만 건너뛴다(보고서 확인 필요 항목).
 */
export const buildDetailErpUnits = (dirty: Record<string, unknown>[]): Record<string, unknown>[][] => {
  const eligible = (r: Record<string, unknown>): boolean => {
    const action = detailActionOf(r);
    return isIMD(action) && action !== 'I' && str(r.CHANGE_TYPE) !== CHANGE_TYPE_SKIP;
  };
  const units: Record<string, unknown>[][] = [];
  const seenSo = new Set<string>();
  dirty.forEach(row => {
    if (!eligible(row)) return;
    const so = str(row.ERP_SO_NO).trim();
    if (!so) {
      units.push([row]);
      return;
    }
    if (seenSo.has(so)) return;
    seenSo.add(so);
    units.push(dirty.filter(r => eligible(r) && str(r.ERP_SO_NO).trim() === so));
  });
  return units;
};

export interface DraftingSaveMeta {
  userId: string;
  /** AS-IS UserInfoContext[Dept_ID] (cs:4093). TO-BE 세션에 부서가 없어 '' (B11 보류). */
  userDeptId: string;
  /** AS-IS siDetail.ActiveSheet.SheetName (cs:4107) — SP 가 행별로 SCM_ARR_SPL_VAL 해 'Change on …' 제목을 만든다. */
  title: string;
  /** AS-IS this.Name (cs:4109). SSP0015 선례대로 MENU_ID. */
  programId: string;
}

/**
 * 하단 Plan Detail 변경요청 초안 — P_SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING (34 IN, '^'-폴딩 단일 객체).
 *   키 = 01 SQL PROC 메타 COL_NM(SSP0015 와 같은 키, shiptoCode 만 없음). 오타 `newDContry`·`origionToDivisionId` 그대로.
 *   행 값 원천은 AS-IS NonSoNo(cs:4115~4153)·SoNo(cs:4336~4367).
 *   userId·userDeptId·programId 는 스칼라 1회(결함 D-2 — SP 가 '^' 분해 없이 CHG_REQ 에 그대로 넣는다,
 *   BODY 6889~6901·7072). title 은 SP 가 행별로 자르므로(BODY 6696) 행별 폴딩을 유지한다.
 *   AS-IS SoNo 의 p_shipment_date 이중 Append(cs:4340~4341) 는 세그먼트 수를 어긋나게 하는 결함이라 옮기지 않는다.
 */
export const collectDetailDraftingRows = (
  rows: Record<string, unknown>[],
  meta: DraftingSaveMeta
): Record<string, string> | null => {
  if (rows.length === 0) return null;
  const map: Record<string, (r: Record<string, unknown>) => string> = {
    activeFlag: detailActionOf,
    divisionId: r => str(r.DIVISION_ID),
    confirmId: r => str(r.CONFIRM_ID),
    shipmentQty: r => str(r.SHIPMENT_CONFIRM_QTY),
    shipmentDate: r => toDashYmd(r.SHIPMENT_DATE),
    fromSite: r => str(r.FROM_SITE),
    newBodId: r => str(r.NEW_BOD_ID),
    newRouteId: r => str(r.NEW_ROUTE_ID),
    newEtdDate: r => toDashYmd(r.NEW_ETD),
    newEtaDate: r => toDashYmd(r.NEW_ETA),
    newIncoterms: r => str(r.INCOTERMS),
    newTransportMode: r => str(r.TRANSPORT_MODE),
    newDContry: r => str(r.NEW_D_COUNTRY), // proc 파라미터 철자 CONTRY
    newDPortCode: r => str(r.NEW_D_PORT_CODE),
    newACountry: r => str(r.NEW_A_COUNTRY),
    newAPortCode: r => str(r.NEW_A_PORT_CODE),
    newCustomerLt: r => str(r.NEW_CUSTOMER_LT),
    newToCountry: r => str(r.NEW_TO_COUNTRY),
    newToCity: r => str(r.NEW_TO_CITY),
    editMain: r => str(r.EDIT_MAIN),
    editRemark: r => str(r.EDIT_REMARKS),
    electrodeYn: r => str(r.ELECTRODE_YN),
    electrodeType: r => str(r.ELECTRODE_TYPE),
    originFromDivisionId: r => str(r.ORIGIN_FROM_DIVISION_ID),
    origionToDivisionId: r => str(r.ORIGIN_TO_DIVISION_ID), // proc 파라미터 철자 ORIGION
    remarks: r => str(r.REMARKS),
    remarks2: r => str(r.REMARKS2),
    remarks3: r => str(r.REMARKS3),
    changeReasonCode: r => str(r.CHANGE_REASON_CODE).replace(/-/g, ''), // cs:4148 .Replace("-", "")
    changeReasonDetail: r => str(r.CHANGE_REASON_DETAIL),
    title: () => meta.title,
  };
  const payload: Record<string, string> = {};
  for (const [key, getter] of Object.entries(map)) {
    payload[key] = rows.map(getter).join('^');
  }
  payload.userId = meta.userId;
  payload.userDeptId = meta.userDeptId;
  payload.programId = meta.programId;
  return payload;
};

/**
 * Request 팝업 변경요청 초안 갱신 — P_SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN (13 IN, requestDraftingMain/SAVE).
 *   AS-IS 팝업 NonSoNo(RP:1282~1405) 행 매핑. 주의: 하단 Detail 의 DRAFTING(34 IN)과 다른 SP 다.
 *   userId·title·programId 는 스칼라(SP 가 userId 는 첫 세그먼트만 쓰고 title/programId 는 로그명에만 쓴다,
 *   BODY 5102·5117). 날짜 2종은 SP 가 8자리로 자르므로(BODY 5157~5158) 숫자 8자리로 보낸다.
 */
export const collectRequestDraftingMainRows = (
  rows: Record<string, unknown>[],
  meta: { userId: string; title: string; programId: string }
): Record<string, string> | null => {
  if (rows.length === 0) return null;
  const map: Record<string, (r: Record<string, unknown>) => string> = {
    activeFlag: () => 'M', // 팝업 행은 전부 조회된 기존 행(collectRequestConfirmSaveRows 와 같은 판단)
    divisionId: r => str(r.DIVISION_ID),
    changeReqNo: r => str(r.CHANGE_REQ_NO), // RP:1335 p_change_seq
    confirmId: r => str(r.CONFIRM_ID),
    shipmentQty: r => str(r.SHIPMENT_CONFIRM_QTY),
    shipmentDate: r => toYmd8(r.SHIPMENT_DATE) ?? str(r.SHIPMENT_DATE).replace(/-/g, ''),
    newYyyymmdd: r => toYmd8(r.NEW_SHIPMENT_DATE) ?? str(r.NEW_SHIPMENT_DATE).replace(/-/g, ''),
    newQty: r => str(r.NEW_SHIPMENT_CONFIRM_QTY),
    changeReasonCode: r => str(r.CHANGE_REASON_CODE).replace(/-/g, ''),
    changeReasonDetail: r => str(r.CHANGE_REASON_DETAIL),
  };
  const payload: Record<string, string> = {};
  for (const [key, getter] of Object.entries(map)) {
    payload[key] = rows.map(getter).join('^');
  }
  payload.userId = meta.userId;
  payload.title = meta.title;
  payload.programId = meta.programId;
  return payload;
};

/**
 * ERP 거절 메시지 분해 — AS-IS GetErpIFCheckNew(cs:4635~4650): 끝 '^' 제거 → '^' 분리 → 첫 ':' 앞이 CONFIRM_ID.
 *   AS-IS 는 뒤에서 다시 Split(':') 해 [1] 만 메시지로 쓰므로 메시지 안의 ':' 이후가 잘린다 — TO-BE 는 첫 ':'
 *   이후 전체를 메시지로 둔다. CONFIRM_ID 가 빈 조각은 버린다(SSP0015 선례).
 */
export const parseErpErrors = (eMessage: string): { confirmId: string; message: string }[] => {
  const body = eMessage.endsWith('^') ? eMessage.slice(0, -1) : eMessage;
  return body
    .split('^')
    .map(part => {
      const at = part.indexOf(':');
      return at < 0
        ? { confirmId: part.trim(), message: '' }
        : { confirmId: part.slice(0, at).trim(), message: part.slice(at + 1).trim() };
    })
    .filter(e => e.confirmId !== '');
};

// 변경사유 필수 판정 — AS-IS Validation_Check(SSP0021_ShipmentPlan.cs L2961~3186, SSP0060 동일 구조).
//   수정 행('M')은 출하수량·출하일·운송수단 중 하나라도 바뀌었을 때만 사유를 요구한다(MSG00285 → TO-BE MSG01289).
//   비고(REMARKS·REMARKS2)만 바뀐 행과 신규 행('I')은 사유 검사를 하지 않는다(신규 행 분기 L3189~ 에 사유 검사 없음).
//   original 은 EditTracker 가 보관한 "현재 값과 다른 컬럼의 원본값" 맵이라, 키가 있으면 그 컬럼이 바뀐 것이다
//   (되돌리면 키가 지워진다). 종전엔 저장 대상 전 행에 사유를 강제했다(결함 B10).
export const SHIPMENT_CHANGE_KEYS = ['SHIPMENT_CONFIRM_QTY', 'SHIPMENT_DATE', 'TRANSPORT_MODE'] as const;

export const needsChangeReason = (
  row: Record<string, unknown>,
  original: Record<string, unknown> | undefined
): boolean => {
  if (str(row.CRUD_TYPE) === 'I') return false;
  if (!original) return false;
  return SHIPMENT_CHANGE_KEYS.some(key => key in original);
};
