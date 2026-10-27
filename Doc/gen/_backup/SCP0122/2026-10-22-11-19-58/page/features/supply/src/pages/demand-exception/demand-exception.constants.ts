export const MENU_ID = 'SCP0129' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0129_DemandException (단일 FpSpread spdMain, 단일 SheetView):
//   설계 근거: .atlas/gscm-design/SCP0129/design/00_checklist.md ~ 03_grid-columns.md,
//   convert-flow/goal.md·plan.md
//   - GET SP  : PKG_SCP0129.P_SCP0129_GET_DEMAND_EXCEPTION (16컬럼) — 배포 완료(2026-10-13 ora.py 실측)
//   - SAVE SP : PKG_SCP0129.P_SCP0129_SAVE_DEMAND_EXCEPTION (현재값 9 + user 1 + PRE_* 7 = 19파라미터,
//     surrogate PK 없는 복합키 UPDATE 패턴) — 배포 완료
//   - INIT SP : PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO (IN divisionId/siteId → OUT o_rc1~o_rc7) —
//     조회조건 콤보 PlanGroup/Site/Stage 다중커서 원천. AS-IS GetSearchInfo(.cs:191~216)가 동일 SP
//     (`SCP.SCP0128_GET_SEARCH_INFO`)를 호출한다 — SCP0129 전용 SP 가 아니라 SCP0128 것을 재사용.
//   - 조회조건 7개 전건 데이터소스 확정(DB 실측 2026-10-13, AS-IS 원본 .cs 확보): Division/PlanGroup/
//     Site/Stage/ValidYn/ItemId(팝업)/Period. 이전 "4개 확인 필요"는 설계 당시 AS-IS .cs 미확보로
//     인한 잠정 판단 — GSCM/ 원본·배포 SP 커서 실측으로 해소(__asis-mapping__.md 갱신).
export enum SHEETS {
  MAIN = 'main',
  // 조회조건 콤보 다중커서 전용 시트 — PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO 재사용(SCP0129 전용
  //   GET_SEARCH_INFO 는 없음, AS-IS 가 SCP0128 SP 를 호출). SCM_ADM_MNU_BTN_MPG_M(SCP0129, init,
  //   SEARCH → API_ID 'SCP0128_init_SEARCH') 등록 필요(register SQL, 형제 SCP0128 init 동형).
  INIT = 'init',
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// init(GET_SEARCH_INFO) 커서 ↔ 조회조건 콤보 매핑 — PKG_SCP0128 PACKAGE BODY `OPEN O_RCn FOR` 실측
//   (ora.py 2026-10-13, L35~138). AS-IS SCP0129 GetSearchInfo 가 읽는 DataSet.Tables[n]:
//   Tables[0]=o_rc1(PlanGroup) / Tables[1]=o_rc2(Site) / Tables[6]=o_rc7(Stage). Stage 는 O_RC3(구버전)
//   이 아니라 O_RC7(`ATTRIBUTE3='Y'` 필터, 2025-11-14 변경분 .cs:181~182)을 읽는다 — 형제 SCP0128 은
//   O_RC3(구버전)을 쓰므로 커서 번호가 다르다. Item(o_rc6)·Type(o_rc4)·ValidYn(o_rc5)은 조회조건
//   콤보가 아니라 미사용(Item 은 팝업, Valid 는 정적 YesOrNo, Type 은 SCP0129 에 조건 없음).
export const INIT_SET = {
  PLAN_GROUP: 'o_rc1',
  SITE: 'o_rc2',
  STAGE: 'o_rc7',
} as const;

/**
 * 조회조건 콤보 SQL_ID — design/02_search-combo.md §2·§5 + AS-IS .cs + DB 실측(2026-10-13)으로 확정.
 *
 * DIVISION: CMBO SQL_ID `Division_SCP`, AS-IS `BLUtils.GetDivision(false,"")`(.cs:45) ↔ 확정(EE 포함
 *   유지 — WithoutEE 아님).
 * VALID: CMBO SQL_ID `YesOrNo`(고정 Y/N), AS-IS `cboValid.DataBind(Data.Type.YesOrNo, true)`(.cs:174)
 *   정적 바인드 ↔ 1:1 일치(§2.6 위반 아님 — 그리드 셀 STOCK_EXCEPTION/VALID_YN 콤보와 동일 SQL_ID).
 * PlanGroup/Site/Stage: CMBO 가 아니라 init 시트(PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO) 다중커서
 *   (o_rc1/o_rc2/o_rc7)에서 온다 — INIT_SET 매핑·DemandExceptionForm 참조. 전부 선택 Division 으로
 *   클라 cascade 필터(AS-IS Refresh{PlanGroup,Site,Stage}ByDivision .cs:254~283 재현).
 */
export const COMBO = {
  DIVISION: 'Division_SCP',
  VALID: 'YesOrNo',
  // 그리드 ClipboardPasted(OPMZ_PLAN_GR_ID NAME→CODE 역조회)용 Plan Group 전체 목록. 조회조건
  //   PlanGroup 은 init o_rc1 에서 오지만(INIT_SET), 붙여넣기 NAME→CODE 변환은 CODE/NAME 쌍 목록만
  //   있으면 되므로 그리드 셀 콤보와 동일한 CMBO `PlanGroup`(SCP_OPMZ_PLAN_GR_M)을 재사용한다.
  PLAN_GROUP: 'PlanGroup',
} as const;

// AS-IS validations(00_checklist.md §3a) MSG ID → TO-BE 실측 매핑(Hook #114, SCM_ADM_MSG_M 역조회).
//   AS-IS 번호 그대로 쓰지 않는다 — 문구 대조로 확정.
export const MSG = {
  REQUIRED_FIELDS: 'MSG00013', // "Please enter the required fields." — AS-IS MSG00001(8필드 공백)의 TO-BE 등가(AS-IS MSG00001 은 TO-BE 에서 "저장하시겠습니까?" 로 의미가 다름 — 역조회로 확정)
  DATE_RANGE_INVALID: 'MSG00219', // "Invalid period (start > end)." — AS-IS 번호 그대로 일치 확인
  SAFETY_STOCK_EXISTS: 'MSG00260', // "Duplicate combination ..." — AS-IS 저장 가드(안전재고 존재 시 차단)의 근접 TO-BE 매핑, 검사 컬럼 확인 필요(design 01 §5-2)
  ITEM_NOT_FOUND: 'MSG00458', // "MODEL:{0} Invalid model!" — AS-IS 번호 그대로 일치 확인
  SAVE_SUCCESS: 'MSG00002', // "Saved successfully." — useProcMutation 기본 onSuccess 가 사용(화면 별도 배선 불필요, 문서화 목적)
  NO_CHANGE: 'MSG_NO_CHANGE',
} as const;
