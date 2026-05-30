/**
 * DMF0008 ErpEdiMaster — Expression hook
 * AS-IS: expressions.md 75건 LockRange
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0008_ErpEdiMaster/__asis-mapping__.md §4
 *
 * 본 hook 은 Step B (2026-05-29 보완) 의 핵심 산출물 — InsertRow 직후 4 컬럼 잠금.
 */
import type { FlexGrid } from '@mescius/wijmo.grid';

type AnyRow = Record<string, unknown>;

const CRUD_INSERT = 'I';

export const useErpEdiMasterExpression = () => {
  /** AS-IS L1849-1879 — InsertRow 직후 Sub SalesSite 의 4 컬럼 잠금
   *  대상 컬럼: DIVISION_ID / REP_SOLDTO_CODE / REP_SHIPTO_CODE / SCM_SITE_ID
   *  조건: CRUD_TYPE='I' 인 신규 행만 */
  const lockSalesSiteInsertColumns = (grid: FlexGrid<AnyRow>): void => {
    const lockBindings = new Set([
      'DIVISION_ID',
      'REP_SOLDTO_CODE',
      'REP_SHIPTO_CODE',
      'SCM_SITE_ID',
    ]);
    grid.beginningEdit.addHandler((s, e) => {
      const row = s.rows[e.row]?.dataItem as AnyRow | undefined;
      const binding = s.columns[e.col]?.binding ?? '';
      if (row?.CRUD_TYPE === CRUD_INSERT && lockBindings.has(binding)) {
        e.cancel = true;
      }
    });
  };

  /** AS-IS L1879~ — InsertRow 직후 Sub SSPM 의 4 컬럼 잠금
   *  대상 컬럼: DIVISION_ID / SOLDTO_CODE / SHIPTO_CODE / ITEM_ID */
  const lockSspmInsertColumns = (grid: FlexGrid<AnyRow>): void => {
    const lockBindings = new Set([
      'DIVISION_ID',
      'SOLDTO_CODE',
      'SHIPTO_CODE',
      'ITEM_ID',
    ]);
    grid.beginningEdit.addHandler((s, e) => {
      const row = s.rows[e.row]?.dataItem as AnyRow | undefined;
      const binding = s.columns[e.col]?.binding ?? '';
      if (row?.CRUD_TYPE === CRUD_INSERT && lockBindings.has(binding)) {
        e.cancel = true;
      }
    });
  };

  /** AS-IS EditButton 시 DIVISION 컬럼 전체 잠금 (SalesSite/SSPM) */
  const lockDivisionColumn = (grid: FlexGrid<AnyRow>): void => {
    const col = grid.columns.find(c => c.binding === 'DIVISION_ID');
    if (col) col.isReadOnly = true;
  };

  /** AS-IS spdSub_ComboSelChange — DIVISION/EndCust cascade reset */
  const onComboChange = (
    row: AnyRow,
    binding: string,
    _newValue: unknown
  ): void => {
    if (binding === 'DIVISION_ID') {
      row.END_CUSTOMER = '';
      row.SCM_SITE_ID = '';
      row.FCST_TYPE = '';
      row.INCOTERMS = '';
      row.DOM_EXP = '';
    } else if (binding === 'END_CUSTOMER') {
      row.SCM_SITE_ID = '';
    }
  };

  return {
    lockSalesSiteInsertColumns,
    lockSspmInsertColumns,
    lockDivisionColumn,
    onComboChange,
  };
};
