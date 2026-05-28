export const MENU_ID = 'DMF0022' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  SALES_PLAN_WATERFALL = 'salesPlanWaterfall',
  SPREAD_TITLE = 'spreadTitle',
}

export const BUCKET_TYPE = {
  DAILY: 'DAILY',
  WEEKLY: 'WEEKLY',
  MONTHLY: 'MONTHLY',
  ONLY_WEEKLY: 'ONLY_WEEKLY',
} as const;
