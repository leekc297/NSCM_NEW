export const MODAL_SALES_VERSION = 'DMF0044' as const;
export type MODAL_SALES_VERSION = typeof MODAL_SALES_VERSION;

export const MODAL_SALES_VERSION_SHEET = 'unitedVersion' as const;
export type MODAL_SALES_VERSION_SHEET = typeof MODAL_SALES_VERSION_SHEET;

export const MODAL_SALES_VERSION_COLUMN_SHEET = 'MDFVerpopup' as const;

export const REPORT_TYPE = {
  SP_W: 'REPORT_SP_W',
  BP_M: 'REPORT_BP_M',
} as const;

export const VERSION_ACTION = {
  DELETE: 'D',
  COPY: 'CP',
  CREATE: 'CR',
  TRANSFER: 'T',
  CANCEL: 'C',
} as const;

export const MSG = {
  SAVED: 'MSG00002',
  SAVE_ERROR: 'MSG00618',
  COPY_PLAN_ONLY: 'MSG00682',
  DELETE_CONFIRM: 'MSG00683',
  CANCEL_CONFIRM: 'MSG00684',
  SEND_ONLY_N: 'MSG00685',
  CANCEL_ONLY_Y: 'MSG00686',
  DELETE_ONLY_NC: 'MSG00687',
} as const;
