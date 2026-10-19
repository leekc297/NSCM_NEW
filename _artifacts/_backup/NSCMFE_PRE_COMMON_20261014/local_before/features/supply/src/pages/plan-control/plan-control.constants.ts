export const MENU_ID = 'SCP0123' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0123_PlanControl (상/하 2그리드 Activity 실행 콘솔):
//   설계 근거: .atlas/gscm-design/SCP0123/design/00_checklist.md ~ 03_grid-columns.md
//   - GET  SP : PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL (20컬럼) / ..._GET_PLAN_ENGINE_RUN (7컬럼)
//   - SAVE SP : PKG_SCP0123.P_SCP0123_SAVE_PLAN_ACTV_RUN (IN 7 — 7번째 sesUserId 는 FE 가 직접 싣는다.
//               /call-proc 는 세션 자동주입이 없다. 주입은 /call-proc2 전용)
//   - 조회조건 3 : Division_SCP / searchInfo.planGroupList / OPMZ_DATE_WEEKLY_SCP_ALL 또는 DatePicker(배타)
//   - 저장 트리거는 툴바가 아니라 그리드 CONFIRM 버튼 셀이다(01_layout §2.3 R12)
export enum SHEETS {
  PLAN_CONTROL = 'planControl', // spdMain — 마스터 Activity 목록 (컬럼메타 'Plan Control' 22행)
  ENGINE_RUN = 'engineRun', // spdSub  — Engine Run 상태 (컬럼메타 'Status' 7행)
  SEARCH_INFO = 'searchInfo', // 조회조건 Plan Group 공급 (PKG_COM0000, 커서 6개 중 planGroupList)
}

// FE 응답 키 = SCM_ADM_PROC_M.COL_NM 실측값. 커서 인자명(O_RC1)과 별개 축이며 이 화면은 o_rc1 이
//   아니다 — 자매 SCP0122 의 'o_rc1' 을 복사하면 rows 가 항상 빈 배열(hook #80, design 03 §4.1).
export const RESPONSE_SET = {
  PLAN_CONTROL: 'planControl',
  ENGINE_RUN: 'engineRun',
  SEARCH_INFO: 'planGroupList',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin SCM_MST_SHEET_COLUMNS.SHEET_NAME (AS-IS 시트명 그대로, DB 실측). 컬럼 메타 조회 sheetNm.
//   위 SHEETS(호출 축 = SHT_NM)와 값이 다르다 — 섞으면 조용히 컬럼 0건이 된다(00_checklist §0.3).
export const ADMIN_SHEET_NAME: Record<SHEETS.PLAN_CONTROL | SHEETS.ENGINE_RUN, string> = {
  [SHEETS.PLAN_CONTROL]: 'Plan Control',
  [SHEETS.ENGINE_RUN]: 'Status',
};

// 조회조건 콤보 ID (convert-core §2.6 의미 패리티 — 이름 유사 재사용 금지, DB 실측 design 02 §2).
//   DIVISION : Division_SCP. MyDivision/FilterMyDivision/Division_SCP_NoEE 는 ATTRIBUTE3<>'EE' 를
//              품고 있어 EE_UC 가 소실 → 일단위 Plan Date 분기가 절반 사망한다. 사용 금지.
//   PLAN_DATE_WEEKLY : 全件 로드 후 FE 에서 DIVISION_ID 필터(F04). SP 가 PLAN_NAME DESC 로 정렬하므로
//              CustomDropdown 에 sortBy 를 주지 않는다(서버 순서 유지).
export const COMBO = {
  DIVISION: 'Division_SCP',
  PLAN_DATE_WEEKLY: 'OPMZ_DATE_WEEKLY_SCP_ALL',
  // 일단위 판정 집합의 조회 경로. useTabLookupQueries(admin/lookup)를 쓰면 응답 컬럼명이
  //   SCM_ADM_LOOKUP_MASTER.SEGMENT1 헤더값(OPMZ_DIVISION_GM 은 'DIVISION_ID')으로 동적 생성돼
  //   row.CODE 가 항상 undefined 가 된다(LookupResponse 가 인덱스 시그니처라 type-check 로도 안 잡힌다).
  //   LookupCommon 콤보 SQL 은 `SEGMENT1 CODE, SEGMENT2 NAME` 별칭을 보장한다(design 02 §5 데이터계약 #4).
  LOOKUP_COMMON: 'LookupCommon',
} as const;

// 일단위 Plan Date 운영 Division 집합 — 실측 2행(81_UC, EE_UC). SEGMENT2 가 '-' 라 표시용이
//   아니라 코드 집합 판정 전용이다(design 02 §2-5). COMBO.LOOKUP_COMMON 의 @lookupType 파라미터.
export const GM_DIVISION_LOOKUP_TYPE = 'OPMZ_DIVISION_GM';

// X21 owner 분기 — 이 그룹이면 searchInfo 의 userId 를 '' 로 보내 owner 필터를 우회한다.
//   그 외 사용자는 본인이 owner 인 Plan Group 만 받는다(design 02 §2-2).
export const OWNER_BYPASS_GROUP_IDS: readonly string[] = ['ADMIN', 'SCM PI Admin'];

// AS-IS timerStatus.Interval = 1000*2 (cs:156). 주기 조정이 필요하면 이 상수 1곳만 바꾼다(C-8).
export const POLL_INTERVAL_MS = 2000;

// 셀 액션 대상 컬럼 — formatItem/hitTest 가 binding 으로 판정한다(design 03 §1.5).
export const ACTION_COLUMN = {
  LINK: 'LINK',
  CONFIRM: 'CONFIRM',
  PLAN_ID: 'OPMZ_PLAN_ID',
  DETAIL: 'DETAIL',
} as const;

// lookup OPMZ_ACTV_CD 9행(A001~A009) 중 화면이 명시 분기하는 코드.
//   W-GEN 규칙: 이 목록은 화이트리스트가 아니다. A007(Input Constraint)·A008(Constraint Validation)은
//   전용 분기가 없지만 INDP_YN='Y' + CONFIRM_YN='Y' 라 default 경로로 완전히 동작해야 한다.
//   switch 의 default 를 없애고 이 상수들만 처리하면 2개 Activity 가 조용히 죽는다(design 03 §3.4 W-GEN).
export const ACTIVITY = {
  MASTER_VALIDATION: 'A001',
  CREATE_PLAN_ID: 'A002',
  ENGINE_RUN: 'A003',
  PLAN_OUT_REVIEW: 'A004',
  FP_TARGET_IF: 'A005',
  RELEASE: 'A006',
  SEMI_CUTOFF: 'A009',
} as const;

// 저장 성공 Toast 문구가 "Executed." 가 되는 Activity 집합(AS-IS cs:760-780).
export const EXECUTED_ACTIVITY_CODES: readonly string[] = [
  ACTIVITY.ENGINE_RUN,
  ACTIVITY.PLAN_OUT_REVIEW,
  ACTIVITY.FP_TARGET_IF,
  'A009',
];

// lookup OPMZ_ACTV_RUN_STAT_CD 4행.
export const RUN_STATUS = {
  WAITING: 'W',
  RUNNING: 'R',
  COMPLETED: 'C',
  ERROR: 'E',
} as const;

// SCP0039 Master Validation — A001 LINK 가 여는 타 화면(TO-BE 등록 실측: supply/master-validation).
export const MASTER_VALIDATION_MENU_ID = 'SCP0039';

// 다국어 LABEL (SCM_ADM_MSG_M + public/locales 양쪽 실측 — 전부 존재 / 신규 0, design 01 §1.3).
//   Plan Date 는 주단위 콤보·일단위 DatePicker 가 같은 키를 쓴다(배타 노출이라 중복으로 보이지 않는다).
//   PLAN_ID 는 MSG01122("Select {0}.") 의 {0} 에 넣을 라벨로 iter-2 에 신규 등록했다(05_register.sql B4).
export const LBL = {
  DIVISION: 'LBL00001',
  PLAN_GROUP: 'LBL00002',
  PLAN_DATE: 'LBL00039',
  STATUS: 'LBL00014',
  SEARCH: 'LBL00112',
  PLAN_ID: 'LBL01149',
} as const;

// MSG 코드 = TO-BE SCM_ADM_MSG_M 실측 역매핑 (hook #114 — AS-IS 번호 그대로 쓰지 않는다).
//   AS-IS MSG00093/00183/00184/00465/00466/00469/00470 은 TO-BE 에 1건도 없어 문구 역조회로 확정했다.
//   NO_AUTH_DIVISION : AS-IS MSG00097 은 TO-BE 에서 "Please select Division." 이라 의미 불일치 →
//                      문구가 일치하는 MSG00667("No authority assigned.") 사용.
//   NO_SAVE_PERMISSION : CONFIRM 셀 실행 게이트(hasButton('SAVE'))가 막을 때의 안내. NO_AUTH_DIVISION
//                      (MSG00667 "No authority assigned." / KO "권한을 가진 Division이 없습니다.")은
//                      Division 권한 축 전용이라 버튼권한 차단에 쓰면 오매핑이다 → 문구가 정확히
//                      일치하는 MSG01125("You do not have permission." / KO "사용 권한이 없습니다.")를
//                      쓴다. DB 실측 CN·EN·KO 3행 + public/locales 3개 번들 전건 실재(신규 등록 0).
export const MSG = {
  NO_AUTH_DIVISION: 'MSG00667',
  NO_SAVE_PERMISSION: 'MSG01125',
  SELECT_REQUIRED: 'MSG01122', // AS-IS MSG00093 "Select {0}."
  CONFIRM_RUN: 'MSG01456', // AS-IS MSG00183 "Do you want to run?"
  CONFIRM_CONFIRM: 'MSG01457', // AS-IS MSG00184 "Do you want to confirm?"
  CONFIRM_RELEASE: 'MSG01438', // AS-IS MSG00465 "Do you want to release?"
  CONFIRM_RERUN: 'MSG01439', // AS-IS MSG00466 재실행 확인
  MASTER_VALIDATION_REQUIRED: 'MSG01441', // AS-IS MSG00469
  MASTER_VALIDATION_CRITICAL: 'MSG01442', // AS-IS MSG00470
  SAVE_FAILED: 'MSG00003',
  // 아래 6건은 AS-IS 가 코드 리터럴로만 갖고 있어 TO-BE 등가 코드가 0건이던 문구다(design 03 §3.5 /
  //   01_layout §5 C-L1). iter-2 에 사용자 결정 B4 대로 SCM_ADM_MSG_M(KO/EN) + public/locales 양쪽에
  //   신규 등록했다(05_register.sql B4 — 채번 근거 MAX(MSG_ID)='MSG01461').
  PRE_ACTIVITY_NOT_DONE: 'MSG01462', // B11
  PLAN_ID_ALREADY_PROCESSED: 'MSG01463', // B24
  ENGINE_RUN_NOT_EXECUTED: 'MSG01464', // B30 · B37
  SAVE_CONFIRMED: 'MSG01465', // 저장 성공 — confirm_yn='Y'
  SAVE_EXECUTED: 'MSG01466', // 저장 성공 — A003·A004·A005·A009
  SAVE_RELEASED: 'MSG01467', // 저장 성공 — A006
} as const;

// 위 신규 6건의 영문 원문 — t(id, fallback) 의 fallback 이다. 번들 로드 실패·구버전 번들에서도
//   키 원문이 노출되지 않게 한다(저장소 관례). KO 문구는 AS-IS 리터럴 원문이 DB·번들에 들어가 있다.
export const MSG_FALLBACK: Record<string, string> = {
  [MSG.PRE_ACTIVITY_NOT_DONE]: '_The previous activity has not been performed.',
  [MSG.PLAN_ID_ALREADY_PROCESSED]: '_This Plan ID has already been processed.',
  [MSG.ENGINE_RUN_NOT_EXECUTED]: '_The Engine Run for the selected Plan ID has not been executed.',
  [MSG.SAVE_CONFIRMED]: '_Confirmed.',
  [MSG.SAVE_EXECUTED]: '_Executed.',
  [MSG.SAVE_RELEASED]: '_Released.',
};
