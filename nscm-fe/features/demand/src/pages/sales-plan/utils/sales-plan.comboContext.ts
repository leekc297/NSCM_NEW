import type { ComboParam } from '@foundation/models';

import type { SalesPlanRow } from '../sales-plan.types';

import { toCellStr } from './sales-plan.gridCombos';

export interface SalesPlanComboContext {
  divisionId: string;
  deptId: string;
  endCustomer: string;
  itemId: string;
  // ⭐ Model(ITEM_ID) Insert 행 드롭박스(COM0008/itemByDivision) 필터용 — 2026-07-28 추가.
  scmSiteId: string;
  projectCode: string;
}

const ROW_DEPENDENT_BINDINGS = new Set(['END_CUSTOMER', 'SCM_SITE_ID', 'CELL_PROD_SITE_ID']);
const quote = (value: string): string => `'${(value || 'ALL').replace(/'/g, '\x27\x27')}'`;

export const buildSalesPlanComboContext = (
  row: SalesPlanRow | undefined,
  defaultDivisionId: string
): SalesPlanComboContext => ({
  divisionId: toCellStr(row?.DIVISION_ID) || defaultDivisionId,
  deptId: toCellStr(row?.DEPT_ID),
  endCustomer: toCellStr(row?.END_CUSTOMER) || toCellStr(row?.END_CUSTOMER40),
  itemId: toCellStr(row?.ITEM_ID),
  scmSiteId: toCellStr(row?.SCM_SITE_ID),
  projectCode: toCellStr(row?.PROJECT_CODE),
});

export const salesPlanComboContextKey = (context: SalesPlanComboContext): string =>
  [
    context.divisionId,
    context.deptId,
    context.endCustomer,
    context.itemId,
    context.scmSiteId,
    context.projectCode,
  ].join('|');

export const isSalesPlanRowDependentCombo = (binding: string): boolean =>
  ROW_DEPENDENT_BINDINGS.has(binding);

export const buildSalesPlanComboFilter = (
  binding: string,
  metadataComboId: string,
  context: SalesPlanComboContext,
  rowExact: boolean
): ComboParam | string => {
  const divisionId = quote(context.divisionId);
  const deptId = quote(rowExact ? context.deptId : 'ALL');
  const endCustomer = quote(rowExact ? context.endCustomer : 'ALL');
  const itemId = quote(rowExact ? context.itemId : 'ALL');

  switch (binding) {
    case 'DEPT_ID':
      return { comboId: 'DeptId', divisionId };
    case 'END_CUSTOMER':
      return { comboId: 'EndCustomerByDivisionDept', divisionId, deptId };
    case 'SCM_SITE_ID':
      return { comboId: 'SiteByEndCustomer', divisionId, deptId, endCustomer };
    case 'CELL_PROD_SITE_ID':
      return { comboId: 'CELL_PROD_SITE_ID', divisionId, itemId };
    case 'FROM_SITE_ID':
    case 'PLANT_SITE_ID':
      return { comboId: 'FromSiteByDivision', divisionId };
    default:
      return metadataComboId;
  }
};
