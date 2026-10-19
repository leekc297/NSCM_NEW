// SYS0013 Dynamic Query — AS-IS SCM0005_DynamicQueryList rename (Admin_Menu 부모)

export const MENU_ID = 'SYS0013' as const;
export type MENU_ID = typeof MENU_ID;

// ⚠️ 문자열 값은 BE callProc 라우팅 키 (BTN_MPG_M.SHT_NM / SCM_MST_SHEET_COLUMNS.SHEET_NAME) — 변경 금지.
// History 는 화면에서 제거됨(2026-06-26 DESIGN 정합) — SP/메타는 보존하나 FE 미사용.
export enum SHEETS {
  MAIN = 'main',
  RESULT = 'result',
  COLUMNS = 'columns',
  PARAMETERS = 'parameters',
  POPUP_COLUMNS = 'popupColumns',
  POPUP_PARAMETERS = 'popupParameters',
  USER_GROUP = 'userGroup', // Role(역할) 저장 라우트 — BTN_MPG_M SHT_NM='userGroup' (2026-06-28)
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc1',
}

// 상단 Register / View(Designer) 탭 인덱스 (DESIGN TABPAGE1 / TABPAGE2)
export enum SHEET_INDEX {
  REGISTER = 0,
  DESIGNER = 1,
}
