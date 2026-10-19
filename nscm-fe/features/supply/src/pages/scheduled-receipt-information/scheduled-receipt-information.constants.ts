export const MENU_ID = 'SCP0130' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0130_ScheduledRecieptInformation — 2 sheetNm 정적 그리드(pivot 없음):
//   design/00_checklist.md ~ 03_grid-columns.md, convert-flow/goal.md·plan.md
//   - GET SP(2건)  : virtualBom 시트 = SCP.SCP0130_GET_VIRTUAL_BOM / scheduledReceipt 시트 =
//     SCP.SCP0130_GET_SCHEDULED_RECIEPT_INFORMATION — AS-IS FindData_Main()(.cs:556-666)이
//     활성 시트에 따라 분기하는 서로 다른 SP다(gap-resolve/iter-1, AS-IS 원문으로 확정 — 이전
//     회차가 두 시트 모두 GET_VIRTUAL_BOM으로 잘못 기재). 동명 SEARCH_INFO 는 시트전환 부가정보용
//     (그리드 데이터 아님, 이 화면 미적용)
//   - SAVE SP(2건) : SCP.SCP0130_SVAE_VIRTUAL_BOM(원문 오탈자 그대로 유지) / SCP.SCP0130_SAVE_
//     SCHEDULED_RECIEPT_INFORMATION — 저장 시 순차 호출(SVAE_VIRTUAL_BOM → SAVE_SCHEDULED_RECIEPT_
//     INFORMATION → GET_VIRTUAL_BOM 재조회, design/03_grid-columns.md §4)
//   - PKG_SCP0130 는 TO-BE 미배포(all_objects 0건, goal.md ② — convert-sp 백로그)
export enum SHEETS {
  VIRTUAL_BOM = 'virtualBom',
  SCHEDULED_RECEIPT = 'scheduledReceipt',
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  VIRTUAL_BOM: 'o_rc1',
  SCHEDULED_RECEIPT: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

/**
 * 컬럼 메타 fetch(/admin/menu/SCP0130/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과
 * 정확히 일치해야 한다(BE 가 문자열 그대로 매칭). DB 실측(design/03_grid-columns.md §1) 값을
 * 그대로 쓴다 — 코드 키(SHEETS)와 분리(formation.constants.ts 선례와 동일 패턴).
 */
export const COLUMN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.VIRTUAL_BOM]: 'Virtual Bom',
  [SHEETS.SCHEDULED_RECEIPT]: 'Scheduled Reciept Information',
};

/**
 * 조회조건 콤보 SQL_ID.
 *
 * DIVISION: design/02_search-combo.md §2.1 — comboCalls#1(`BLUtils.GetDivision(false,"")`,
 *   target=dtMyDivision)이 `MyDivision`(WithoutEE 필터 포함) 사용을 강하게 시사(변수명 일치).
 *   `Division_SCP`(WithoutEE 필터 없음)와는 다른 콤보 — §2.6 5층 대조 중 target 변수명 근거로
 *   `MyDivision` 채택, 나머지 근거(BLUtils 소스·AS-IS DB)는 이 세션에서도 확보 불가(§2.7 확인 필요
 *   승계) — EE 노출 여부는 사용자 QA 축.
 * PLAN_GROUP: design 02 §2.2 — `PlanGroup_SCP_ALL`(전량 로드 후 클라 필터, AS-IS dtPlanGroupAll과
 *   동일 패턴) 채택. 5층 완전 대조 미완(AS-IS 소스 부재) — 확인 필요 승계.
 * SITE / CHILD_MATERIAL: design 02 §2.3/§2.4 — TO-BE 미등록(Site 계열은 이름 유사 다건 존재하나
 *   의미 대조 불가, ChildMaterial 은 0건) — §2.3 예외(b) 원천(AS-IS DB)이 ERROR 라 신규 등록 불가.
 *   UI 골격만 노출(SafetyStock/DemandException 선례와 동일 처리).
 */
export const COMBO = {
  DIVISION: 'MyDivision',
  PLAN_GROUP: 'PlanGroup_SCP_ALL',
} as const;

// AS-IS validations(00_checklist.md §3a, design 03 §3.1) MSG ID → TO-BE 실측 매핑(Hook #114).
//   MSG00046/050/160/193 은 TO-BE SCM_ADM_MSG_M 미등록(0 rows, design 03 §3.1 i18n 갭 요약) —
//   등록된 근접 코드로 대체하고 확인 필요로 __asis-mapping__.md 에 남긴다(safety-stock 선례).
export const MSG = {
  // AS-IS MSG00001(7개 필수값 공백) — TO-BE MSG00001 은 "저장하시겠습니까?"로 의미가 다르므로
  //   (message-id.ts CRUD_MSG.SAVE_CONFIRM) 근접 필수값 코드로 대체.
  REQUIRED_FIELDS: 'MSG00013', // "_필수값을 입력하세요." (CRUD_MSG.REQUIRED_INPUT)
  // AS-IS MSG00046(Valid To/Arrival Date 필수) — TO-BE 미등록. 확인 필요(design 03 §3.1).
  ARRIVAL_DATE_REQUIRED: 'MSG00046',
  // AS-IS MSG00085(수량 0 미만 금지) — TO-BE 등록됐으나 본문 TODO(design 03 §3.1 #4).
  QTY_NEGATIVE: 'MSG00085',
  // AS-IS MSG00050(숫자 형식 아님) — TO-BE 미등록. 확인 필요.
  QTY_NOT_NUMBER: 'MSG00050',
  // 소수 10자리 초과(AS-IS literal 메시지, msgId 없음) — TO-BE 근접 등록 코드 재사용
  //   (MSG00165 "자리수를 초과했습니다", ora.py 실측).
  QTY_DECIMAL_OVERFLOW: 'MSG00165',
  // AS-IS MSG00260(Division/PlanGroup/Site/ItemChild/ValidTo 조합 중복) — TO-BE 등록·본문 존재.
  DUPLICATE_EXISTS: 'MSG00260',
  NO_CHANGE: 'MSG00004',
  // AS-IS MSG00129(.cs:1516 spdSub_ActiveSheetChanging) — 편집 중 시트전환 차단 안내. TO-BE 등록
  //   본문("시트 별 편집 모드 안내.")이 AS-IS 사용 문구("{0}를 수정 중이어서...")와 달라 `{0}` 치환이
  //   무의미할 수 있음(gap-resolve/iter-1 G12) — 문구 자체 확정은 사용자 협의 대상으로 남기고, 코드는
  //   등록된 키를 그대로 쓰되 defaultValue 에 AS-IS 원문 의미를 넣어 등록본문 교정 시 자연히 반영되게 한다.
  SHEET_EDIT_LOCK: 'MSG00129',
} as const;

/** 수량 저장 검증 — 소수 10자리 초과 금지(design 03 §3.1 #5/#16 literal 메시지). */
export const QTY_DECIMAL_MAX_DIGITS = 10;

// 조회조건 다국어 라벨 — design 02 §4.5 DB 실측(SCM_ADM_MSG_M 7종 전건 존재, ora.py 재조회 확인).
export const LABEL = {
  DIVISION: 'LBL00001',
  PLAN_GROUP: 'LBL00002',
  SITE: 'LBL00015',
  CHILD_MATERIAL: 'LBL01062',
  VALID: 'LBL00639',
  FROM_DATE: 'LBL00062',
  ITEM_ID: 'LBL01142',
} as const;
