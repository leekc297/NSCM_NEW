import type { MENU_ID, RESPONSE_SET, SHEETS } from './notice-setup.constants';

export type NoticeSetupRow = ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>;

export interface NoticeSearchParams {
  module: string;
  subModule: string;
  activeYn: string;
}

export interface NoticeImageUploadResult {
  fileId: string;
  fileName: string;
}

export interface ComboOption {
  CODE: string;
  NAME: string;
  PARENT_CODE?: string;
}

export type NoticeDialogMode = 'create' | 'edit';
