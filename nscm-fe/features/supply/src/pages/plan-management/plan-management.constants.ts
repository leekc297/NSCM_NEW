export const MENU_ID = 'SCP0134' as const;
export type MENU_ID = typeof MENU_ID;

// BE 프로시저 라우팅 키 — DB SCM_ADM_MNU_BTN_MPG_M.SHT_NM 실측값(SCP0134 신규등록 05_register.sql).
//   SCP0015 의 planConfirm 채널은 폐지(확인정보가 mainGrid O_RC 본문에 동봉됨).
export enum SHEETS {
  MAIN_GRID = 'mainGrid',
  DETAIL_GRID = 'detailGrid',
}

// 커서 키 — PROC_M 실측 'o_rc'(단수, 표준 o_rc1 아님)
export const RESPONSE_SET = { MAIN: 'o_rc' } as const;

// admin SCM_MST_SHEET_COLUMNS.SHEET_NAME (사용자 선등록분, SHT_NM 과 다른 값 공간)
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN_GRID]: 'Main Grid',
  [SHEETS.DETAIL_GRID]: 'Detail Grid',
};

// 통합 저장 액션 — MNU_BTN_CD='EXECUTE'(05_register.sql) 1건으로 라우팅하고, 어떤 액션인지는
//   payload actvCd(A01~A04)로 구분한다. SP = PKG_SCP0134.P_SCP0134_SAVE_PLAN_MANAGEMENT_ACTV_RUN.
//   공용 BUTTON_TYPE 밖 코드라 apiClient.post 수동 경로로 호출(PlanManagement.tsx).
export const ACTION = {
  EXECUTE: 'EXECUTE',
} as const;

// P_ACTV_CD 값 — 화면설계서 Plan Management 시트 프로시저 표(R28~R31) 실측
export const ACTV = {
  RUN: 'A01', // Engine Run(ENGINE_RUN 셀버튼) — 최적화 엔진 계획 실행
  CREATE: 'A02', // Ver. Create(VER_CREATE) — Version Create 저장
  CANCEL: 'A03', // Ver. Cancel(VER_CANCEL) — Engine Confirm 취소
  SHIP_REQ: 'A04', // Ship Req. Create(SHIP_REQ_CREATE) — Ship Req. 재수립 실행
} as const;
export type ActvCode = (typeof ACTV)[keyof typeof ACTV];

// Main Grid 액션 셀버튼 컬럼명(SHEET_COLUMNS COLUMN_NAME, 사용자 선등록) → ACTV 코드 + 행별 활성 AUTH 필드 + 버튼 라벨
//   라벨은 컬럼 헤더(Engine Run 등)가 아니라 짧은 액션명(사용자 지정 2026-10-14): Run/Create/Cancel/Run.
export const ACTION_COLUMNS = {
  ENGINE_RUN: { actv: ACTV.RUN, auth: 'RUN_AUTH', label: 'Run' },
  VER_CREATE: { actv: ACTV.CREATE, auth: 'CREATE_AUTH', label: 'Create' },
  VER_CANCEL: { actv: ACTV.CANCEL, auth: 'CANCEL_AUTH', label: 'Cancel' },
  SHIP_REQ_CREATE: { actv: ACTV.SHIP_REQ, auth: 'SHIP_REQ_AUTH', label: 'Run' },
} as const;
export type ActionColumn = keyof typeof ACTION_COLUMNS;

// PLAN_STATUS 코드 (AS-IS 주석: -1 에러종료 / 0 실행중 / 1 정상종료 / -2 종료중)
export const PLAN_STATUS = {
  RUNNING: '0',
  DONE: '1',
  ERROR: '-1',
  STOPPING: '-2',
} as const;

// REVISION_NO 행별 콤보 후보 — PLAN_TYPE → mainGrid 응답 커서 키.
//   화면설계서 확인사항: Pre/Main/Semi/Final Plan 순으로 O_RC2~O_RC5 (SP 바디 실측: PR/MA/SE/FN).
export const REVISION_CANDIDATE_KEYS = {
  PR: 'o_rc2', // Pre Plan
  MA: 'o_rc3', // Main Plan
  SE: 'o_rc4', // Semi Plan
  FN: 'o_rc5', // Final Plan
} as const;
export type RevisionPlanType = keyof typeof REVISION_CANDIDATE_KEYS;

// Final Plan PLAN_TYPE 코드 — Engine Run 버튼 활성 조건(Final Plan CONFIRM_YN='N')에 사용
export const FINAL_PLAN_TYPE = 'FN';

// 조회조건 콤보 — SCM_ADM_CMBO_SQL_M 실측 SQL_ID(사용자 2026-10-14 재지정 / 화면설계서 일치).
//   Division: MyDivisionInEE_SCP 전용(표준 MyDivision=EE 제외와 정반대 의미라 재사용 금지).
//   Year: DB 콤보 아님 — 클라 당해년도 고정(PlanManagementForm, new Date().getFullYear()).
//   PlanWeek: PlanWeekDate_SCP — @planYear(당해년도) 단일 토큰. 달력 SCM_SYS_CALENDAR_M 월요일 주차.
//     응답 컬럼이 CODE/NAME 이 아니라 WEEK_LIST(라벨)/PLAN_WEEK(값) 이라 Form 에서 매핑한다.
export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP',
  PLAN_WEEK: 'PlanWeekDate_SCP',
} as const;

// i18n 라벨 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 실측 코드. 값 = LBL 코드, 표시문구는 t() fallback.
export const LBL = {
  DIVISION: 'LBL00001', // Division
  YEAR: 'LBL00086', // Year
  PLAN_DATE: 'LBL00039', // Plan Date
  REVISION: 'LBL01110', // Revision
} as const;

// i18n — TO-BE SCM_ADM_MSG_M 실측 코드(ora.py 2026-10-14, EN 기준 확정). 사용자 지정 코드와 DB 가 뒤바뀌어
//   있어 DB 실문구 기준으로 배선(버튼별 문구 일치 우선).
export const MSG = {
  NO_DIVISION_AUTH: 'MSG00097', // Please select Division.
  RUN_CONFIRM: 'MSG00033', // Would you like to proceed? (A01 Engine Run / A04 Ship Req — 실행하시겠습니까?)
  CREATE_CONFIRM: 'MSG01458', // Do you want to create the Version? (A02 — Version을 생성하시겠습니까?)
  CANCEL_CONFIRM: 'MSG01457', // Do you want to cancel this Version? (A03 — 해당 Version을 취소하시겠습니까?)
  SHIP_REQ_CONFIRM: 'MSG00033', // A04 Ship Req 도 Run 과 동일 확인(사용자 2026-10-14)
  RUN_REQUIRED: 'MSG01460', // There is no Modeling ID or Plan Type. Please re-search and try again.
  // 액션별 성공 토스트(사용자 지정 2026-10-26, ora.py DB 실측 문구). 공통 "{0} data saved" 대신 버튼별 문구.
  RUN_OK: 'MSG01459', // A01 Engine Run — Engine 실행이 정상 처리되었습니다.
  CREATE_OK: 'MSG01474', // A02 Ver. Create — Version이 생성되었습니다.
  CANCEL_OK: 'MSG01473', // A03 Ver. Cancel — Version이 취소 처리되었습니다.
  SHIP_REQ_OK: 'MSG01472', // A04 Ship Req. Create — Ship Req.가 생성되었습니다.
  SAVE_FAIL: 'MSG01471', // 공통 실패 — 실패하였습니다. (담당자에게 문의하십시오.)
} as const;

// AS-IS timerStatus.Interval=2000(Engine 진행 폴링)
export const ENGINE_POLL_MS = 2000;
// RUN 성공 후 새 REVISION 생성 대기 재조회 최대 10회(비동기 반복)
export const RUN_REFRESH_MAX_TRIES = 10;

// 레이아웃 초기 치수 — 상단(Main) 45% / 하단(Detail) 55% 근사
export const PLAN_GRID_INITIAL_HEIGHT = 334;
export const ENGINE_TOOLBAR_HEIGHT = 51;
