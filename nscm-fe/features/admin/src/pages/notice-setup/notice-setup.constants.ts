export const MENU_ID = 'SYS0016' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc1',
}

export enum SHEET_INDEX {
  MAIN = 0,
}

// 'Module' / 'SubModule' 는 SCM_ADM_CMBO_SQL_M 에 등록되지 않은 SQL_ID 였다(2026-09-11 확인,
// mail-setup 은 화면 전용 comboId 'MailModule'/'MailSubModule' 사용 - 동일 패턴 적용).
// DB 등록 전까지는 조회조건 module combo 가 항상 0건이라 ALL 만 노출된다.
export const COMBO_ID = {
  MODULE: 'NoticeModule',
  SUB_MODULE: 'NoticeSubModule',
} as const;
