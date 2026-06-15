// DMF0042_1 — BUSINESS PLAN variant 1 (AS-IS DMF0042_1_BizPlan.cs)
// 구조: DMF0042 메인과 동일. MENU_ID 만 다름.
// 메뉴: Report > Business Plan > BUSINESS PLAN 1 (UPPR_MNU_ID='BusinessPlan')
export const MENU_ID = 'DMF0042_1' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',
}

export { MAIN_COLUMNS, FROZEN_COL_COUNT, MSG, BUCKET_TYPE, DIVISION } from '../business-plan/business-plan.constants';
export type { MainColumnMeta } from '../business-plan/business-plan.constants';
