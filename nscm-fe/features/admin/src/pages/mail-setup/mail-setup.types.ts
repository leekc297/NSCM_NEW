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

// 그리드 편집 상태(AS-IS action 컬럼 I/M/D)는 별도 필드를 두지 않는다.
//   공통 그리드(GridAction.addRow / removeRow, EditTracker)가 행의 `CRUD_TYPE` 에만 흔적을 남기므로
//   화면 전용 필드를 만들면 Save 가 편집 사실을 못 읽는다. 값은 `@foundation/constants` 의 CRUD_TYPE.
//   CRUD_TYPE 은 WijmoRowItem 이 이미 선언하고 있어 여기서 확장할 필요가 없다.

export interface ComboOption {
  CODE: string;
  NAME: string;
  PARENT_CODE?: string;
}

export type ReceiverTab = 'message' | 'receiver';
