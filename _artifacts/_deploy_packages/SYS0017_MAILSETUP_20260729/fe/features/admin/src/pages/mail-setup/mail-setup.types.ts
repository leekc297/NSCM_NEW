import type { MENU_ID, RESPONSE_SET, SHEETS } from './mail-setup.constants';

export type CategoryRow = ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>;
export type MessageRow = ResponseData<MENU_ID, SHEETS.MESSAGE, RESPONSE_SET.OUTPUT>;
export type AllReceiverRow = ResponseData<MENU_ID, SHEETS.ALL_RECEIVER, RESPONSE_SET.OUTPUT>;
export type SelReceiverRow = ResponseData<MENU_ID, SHEETS.SEL_RECEIVER, RESPONSE_SET.OUTPUT>;

export interface MailSearchParams {
  module: string;
  submodule: string;
  active: string;
}

export interface ReceiverSearchParams {
  user: string;
  dept: string;
}

/** 그리드 편집 상태 — AS-IS action 컬럼(I/M/D) 대체 (TO-BE 상시 편집 표준, 설계서 격차 G2) */
export type RowStatus = 'I' | 'M' | 'D';

export interface CategoryEditRow extends CategoryRow {
  rowStatus?: RowStatus;
}

export interface MessageEditRow extends MessageRow {
  rowStatus?: RowStatus;
}

export interface SelReceiverEditRow extends SelReceiverRow {
  rowStatus?: RowStatus;
}

export interface ComboOption {
  CODE: string;
  NAME: string;
  PARENT_CODE?: string;
}

export type ReceiverTab = 'message' | 'receiver';
