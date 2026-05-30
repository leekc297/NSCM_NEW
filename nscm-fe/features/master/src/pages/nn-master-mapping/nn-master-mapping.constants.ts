/**
 * DMF0072 NNMasterMapping — 상수
 * AS-IS: Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0072_NNMasterMapping/DMF0072_NNMasterMapping.cs
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0072_NNMasterMapping/__asis-mapping__.md
 */
export const MENU_ID = 'DMF0072' as const;
export type MenuId = typeof MENU_ID;

export const SHEET_NAME = {
  MAIN: 'main',
  TITLE: 'title',
} as const;

/** AS-IS .cs — DATA_TYPE_CODE lookup (DM_EDI_DATA_TYPE_CODE) */
export const DATA_TYPE_CODE = {
  SCM: 'SCM',
  EDI: 'EDI',
  RPA: 'RPA',
} as const;
export type DataTypeCode = (typeof DATA_TYPE_CODE)[keyof typeof DATA_TYPE_CODE];

/** AS-IS .cs — Division=40 분기 (PROJECT_CODE 컬럼 비활성) */
export const DIVISION_CODE = {
  AUTOMOTIVE: '40',
  ESS: '81',
  IT: '82',
} as const;
