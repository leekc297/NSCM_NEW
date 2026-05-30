/**
 * DMF0043 Contribute_Main — 상수
 * AS-IS: Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Master.UIL/DMF0043_Contribute_Main.cs
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0043_Contribute_Main/__asis-mapping__.md
 */
export const MENU_ID = 'DMF0043' as const;
export type MenuId = typeof MENU_ID;

export const SHEET_NAME = {
  MAIN: 'main',
  VERSION: 'version',
  TITLE: 'title',
  LOOKUP: 'lookup',
  CONTRIBUTE_RATE: 'contributeRate',
  CONTRIBUTE_RATE_YEAR: 'contributeRateYear',
  CONTRIBUTE_RATE_TITLE: 'contributeRateTitle',
} as const;
export type SheetName = (typeof SHEET_NAME)[keyof typeof SHEET_NAME];

/** AS-IS .cs:251 FindData — Division 분기 (분석 자료 기반) */
export const DIVISION_CODE = {
  AUTOMOTIVE: '40',
  ESS: '81',
  IT: '82',
} as const;
export type DivisionCode = (typeof DIVISION_CODE)[keyof typeof DIVISION_CODE];

/** AS-IS .cs:202 EditButton — EDIT_FLAG 값 */
export const EDIT_FLAG = {
  NONE: '-',
  UPDATE: 'U',
  INSERT: 'I',
  DELETE: 'D',
  NOT_EDITABLE: 'N',
} as const;
