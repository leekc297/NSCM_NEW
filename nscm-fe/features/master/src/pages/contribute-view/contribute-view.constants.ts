/**
 * DMF0043_01 Contribute_View — 상수
 * AS-IS: Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Master.UIL/DMF0043_Contribute_View.cs
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0043_Contribute_View/__asis-mapping__.md
 */
export const MENU_ID = 'DMF0043_01' as const;
export type MenuId = typeof MENU_ID;

export const SHEET_NAME = {
  MAIN: 'main',
  TITLE: 'title',
  VERSION: 'version',
  LOOKUP: 'lookup',
  CONTRIBUTE_RATE: 'contributeRate',
  CONTRIBUTE_RATE_YEAR: 'contributeRateYear',
  CONTRIBUTE_RATE_TITLE: 'contributeRateTitle',
} as const;
export type SheetName = (typeof SHEET_NAME)[keyof typeof SHEET_NAME];
