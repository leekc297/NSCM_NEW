export const MENU_ID = 'DMF0042_2' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',
}

export { MAIN_COLUMNS, FROZEN_COL_COUNT, MSG, BUCKET_TYPE, DIVISION } from '../business-plan/business-plan.constants';
export type { MainColumnMeta } from '../business-plan/business-plan.constants';
