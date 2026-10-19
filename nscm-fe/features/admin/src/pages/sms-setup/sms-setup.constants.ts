// MENU_ID 는 AS-IS 원본 코드(SCM0007)를 그대로 사용한다.
export const MENU_ID = 'SCM0007' as const;
export type MENU_ID = typeof MENU_ID;

/** AS-IS SCM0007 은 UseTypeCode 'SMS' 고정 (Mail 화면과 RECIPIENT 스키마 공유) */
export const USE_TYPE_CODE = 'SMS' as const;

export enum SHEETS {
  MAIN = 'main',
  MESSAGE = 'message',
  ALL_RECEIVER = 'allReceiver',
  SEL_RECEIVER = 'selReceiver',
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc1',
}

/**
 * SMS Content 최대 바이트 — AS-IS PopContent 는 MSG00165 를 3회(서로 다른 길이 기준으로 추정) 검증한다.
 * TODO(확인필요): Roslyn 추출은 msgId/line 만 캡쳐하고 실제 바이트 임계값은 캡쳐하지 못했다.
 * SMS 단문(SMS)/장문(LMS) 2단계 임계값일 가능성이 높으나 근거 부족으로 단일 임계값(90byte, 표준 SMS 한도)만 적용한다.
 */
export const SMS_CONTENT_MAX_BYTES = 90;

/** 주기(Main) 코드 — Mail 과 동일 LOOKUP(MAIL_SEND_CYCLE) 공유 가정 (README: 공유 테이블) */
export const CYCLE = {
  DAY: 'DAY',
  MONTH: 'MONTH',
  WEEK: 'WEEK',
  REAL_TIME: 'RT',
} as const;

/** Sub2(시각)·Sub3(분) 콤보 부모 코드 — Mail 과 동일 LOOKUP(MAIL_SEND_CYCLE_DETAIL) 공유 가정 */
export const CYCLE_DETAIL_PARENT = {
  HOUR_LIST: 'DAY',
  MINUTE_LIST: 'HOUR',
} as const;

/**
 * Module/SubModule 콤보는 SYS0017(Mail_Setup) 등록분을 그대로 재사용한다 — AS-IS 확인 완료.
 * SCM0007_SMS_Setup.cs:37-39/167-169/1602-1604 와 SCM0006_Mail_Setup.cs:38-39/178-179/1638 이
 * 동일하게 `Data.Common(Data.Type.Module/SubModule, false, CConstVariable.SMS_MAIL_SEND_SYSTEM)` +
 * `cboSubModule.DataBind(..., cboModule.SelectedValue.ToString())` 캐스케이드를 공유한다.
 * `_deploy_packages/SYS0017_MAILSETUP_20260729/sql/05_P5_cmbo.sql` 의 SQL_ID 'MailModule'/'MailSubModule'
 * 이 LOOKUP_TYPE='SMS_MAIL_SEND_SYSTEM' 을 그대로 조회하므로 신규 CMBO 등록이 불필요하다.
 */
export const COMBO_ID = {
  MODULE: 'MailModule',
  SUB_MODULE: 'MailSubModule',
  CYCLE: 'MailSendCycle',
  CYCLE_DETAIL: 'MailSendCycleDetail',
} as const;

export const ALL = 'ALL' as const;
