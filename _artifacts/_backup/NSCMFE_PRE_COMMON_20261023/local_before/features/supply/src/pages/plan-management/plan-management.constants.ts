export const MENU_ID = 'SCP0015' as const;
export type MENU_ID = typeof MENU_ID;

// BE 프로시저 라우팅 키 — DB SCM_ADM_MNU_BTN_MPG_M.SHT_NM 실측값 그대로(design 03 §0)
export enum SHEETS {
  PLAN_MGMT = 'planMgmt',
  ENGINE_RUN = 'engineRun',
  // 비가시 데이터 채널 — 별도 그리드가 아니라 REVISION_NO 변경 시 CONFIRM_YN/USER/TIME 만
  //   조회해 planMgmt 행에 반영한다(design 03 §0/§4.3, AS-IS FindData_Confirm 등가)
  PLAN_CONFIRM = 'planConfirm',
}

// 커서 키 — PROC_M 실측 'o_rc'(단수, 표준 o_rc1 아님)
export const RESPONSE_SET = { MAIN: 'o_rc' } as const;

// admin SCM_MST_SHEET_COLUMNS.SHEET_NAME (AS-IS SpdSheet 상수 그대로 — SHT_NM 과 다른 값 공간, design 03 §0)
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.PLAN_MGMT]: 'Plan Management',
  [SHEETS.ENGINE_RUN]: 'Engine Run',
};

// 저장/실행 액션 — MNU_BTN_CD(SCM_ADM_MNU_BTN_MPG_M 실측). CONFIRM/STOP 은 공용 BUTTON_TYPE 에
//   없는 코드라 useProcMutation 대신 apiClient.post 수동 경로로 호출한다(PlanManagement.tsx)
export const ACTION = {
  EXECUTE: 'EXECUTE', // RUN 버튼셀 → P_SCP0015_SAVE_PLAN_MST_RUN
  CONFIRM: 'CONFIRM', // CONFIRM 버튼셀 → P_SCP0015_SAVE_PLAN_MST_COMFIRM
  STOP: 'STOP', // btnStop → P_SCP0015_SAVE_PLAN_MST_STOP
} as const;

// PLAN_STATUS 코드 (AS-IS 주석 L553/L818: -1 에러종료 / 0 실행중 / 1 정상종료 / -2 종료중)
export const PLAN_STATUS = {
  RUNNING: '0',
  DONE: '1',
  ERROR: '-1',
  STOPPING: '-2',
} as const;

// REVISION_NO 행별 콤보 후보 — PLAN_TYPE → planMgmt 응답 커서 키(design 03 §1.4/§4.2)
export const REVISION_CANDIDATE_KEYS = {
  TE: 'o_rc2',
  TM: 'o_rc3',
  PR: 'o_rc4',
  MA: 'o_rc5',
  SE: 'o_rc6',
  FN: 'o_rc7',
  SU: 'o_rc8',
} as const;
export type RevisionPlanType = keyof typeof REVISION_CANDIDATE_KEYS;

// 조회조건 콤보 — SCM_ADM_CMBO_SQL_M 실측 SQL_ID·토큰명 그대로(design 02 §2/§5).
//   Division 은 MyDivisionInEE_SCP 전용 — 표준 MyDivision(EE 제외)과 정반대 의미라 재사용 금지.
//   PlanWeek 의 연도 토큰명은 param2 가 아니라 calendarYyyy(design 02 §2 함정 주의).
export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP',
  PLAN_YEAR: 'PlanYear',
  PLAN_WEEK: 'PlanWeek',
} as const;

// i18n 라벨 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 실측 코드. 값 = LBL 코드, 표시문구는 t() fallback.
export const LBL = {
  DIVISION: 'LBL00001', // Division (표준 LBL00001)
  YEAR: 'LBL00086', // Year
  PLAN_DATE: 'LBL00039', // Plan Date
  REVISION: 'LBL01110', // Revision
} as const;

// i18n — AS-IS MSG_ID 를 그대로 쓰지 않는다(Hook #114). TO-BE SCM_ADM_MSG_M 의도 문구 역조회 실측
//   (ora.py 2026-09-24). AS-IS 원 ID 는 주석에 병기.
export const MSG = {
  NO_DIVISION_AUTH: 'MSG00097', // AS-IS MSG00097 — Please select Division.
  RUN_CONFIRM: 'MSG01456', // AS-IS MSG00183 — Do you want to run?
  CONFIRM_CONFIRM: 'MSG01457', // AS-IS MSG00184 — Do you want to confirm?
  STOP_CONFIRM: 'MSG01458', // AS-IS MSG00185 — The Plan will be terminated of the Error Status. Do you want to run?
  RUN_REQUIRED: 'MSG01460', // AS-IS MSG00205 — There is no Modeling ID or Plan Type. Please re-search and try again.
  SAVE_OK: 'MSG01461', // AS-IS MSG00004 — {0} data saved. (TO-BE MSG00004 는 "No changes to save." — 오용 금지)
  SAVE_FAIL: 'MSG00006', // AS-IS MSG00006 — Failed to save.
} as const;

// AS-IS timerStatus.Interval=2000(CheckEngineStatus 폴링)
export const ENGINE_POLL_MS = 2000;
// AS-IS CallEnginRun — RUN 성공 후 새 REVISION 생성 대기 재조회 최대 10회(L486-519).
//   UI 블로킹 Thread.Sleep 대신 비동기 반복으로 재설계(design 03 §4.5)
export const RUN_REFRESH_MAX_TRIES = 10;

// 레이아웃 초기 치수 — AS-IS splitContainer1.SplitterDistance=334 / splitContainer2=51 (design 01 §1)
export const PLAN_GRID_INITIAL_HEIGHT = 334;
export const ENGINE_TOOLBAR_HEIGHT = 51;
