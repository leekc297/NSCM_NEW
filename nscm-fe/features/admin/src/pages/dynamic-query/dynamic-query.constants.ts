// SYS0013 Dynamic Query — AS-IS SCM0005_DynamicQueryList rename (Admin_Menu 부모)
// 기준 스펙: Doc/화면설계서/SYS0013_DynamicQuery_상세동작_개발용.md (2026-07-09 재개발)

export const MENU_ID = 'SYS0013' as const;
export type MENU_ID = typeof MENU_ID;

// ⚠️ 문자열 값은 BE callProc 라우팅 키 (BTN_MPG_M.SHT_NM / SCM_MST_SHEET_COLUMNS.SHEET_NAME) — 변경 금지.
// HISTORY 는 실행이력 기록 라우트(EXECUTE_HIST)로만 사용 — 조회 UI 는 미노출 (D4).
export enum SHEETS {
  MAIN = 'main',
  RESULT = 'result',
  COLUMNS = 'columns',
  PARAMETERS = 'parameters',
  USER_GROUP = 'userGroup',
  HISTORY = 'history',
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc1',
}

// 상단 Register / View(Designer) 탭 인덱스 (AS-IS tabQuery TABPAGE1/2)
export enum SHEET_INDEX {
  REGISTER = 0,
  DESIGNER = 1,
}
