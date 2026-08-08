export const MENU_ID = 'SYS0017' as const;
export type MENU_ID = typeof MENU_ID;

/** AS-IS SCM0006 은 UseTypeCode 'MAIL' 고정 (SMS 화면과 RECIPIENT 스키마 공유) */
export const USE_TYPE_CODE = 'MAIL' as const;

export enum SHEETS {
  MAIN = 'main',
  MESSAGE = 'message',
  ALL_RECEIVER = 'allReceiver',
  SEL_RECEIVER = 'selReceiver',
  SQL_TEXT = 'sqlText',
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc1',
}

export enum SHEET_INDEX {
  MAIN = 0,
  MESSAGE = 1,
  ALL_RECEIVER = 2,
  SEL_RECEIVER = 3,
}

/** Mail Content 최대 바이트 — TO-BE 단일 기준(설계서 v1.0 격차 G1 확정: DB 컬럼 한계 4,000) */
export const MAIL_CONTENT_MAX_BYTES = 4000;

/** 주기(Main) 코드 — LOOKUP MAIL_SEND_CYCLE 실측 (DAY/MONTH/WEEK/RT) */
export const CYCLE = {
  DAY: 'DAY',
  MONTH: 'MONTH',
  WEEK: 'WEEK',
  REAL_TIME: 'RT',
} as const;

/** Sub2(시각)·Sub3(분) 콤보 부모 코드 — LOOKUP MAIL_SEND_CYCLE_DETAIL SEGMENT1 실측 */
export const CYCLE_DETAIL_PARENT = {
  HOUR_LIST: 'DAY',
  MINUTE_LIST: 'HOUR',
} as const;

export const COMBO_ID = {
  MODULE: 'MailModule',
  SUB_MODULE: 'MailSubModule',
  CYCLE: 'MailSendCycle',
  CYCLE_DETAIL: 'MailSendCycleDetail',
  LANGUAGE: 'MailLanguage',
} as const;

export const ALL = 'ALL' as const;
