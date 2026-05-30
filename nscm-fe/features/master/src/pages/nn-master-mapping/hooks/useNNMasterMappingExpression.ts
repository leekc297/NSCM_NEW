/**
 * DMF0072 NNMasterMapping — Expression hook (9 패턴)
 * AS-IS: expressions.md 매핑
 */
import type { FlexGrid } from '@mescius/wijmo.grid';

import { DATA_TYPE_CODE, DIVISION_CODE } from '../nn-master-mapping.constants';
import type { NNMasterMappingRow } from '../nn-master-mapping.types';

export const useNNMasterMappingExpression = () => {
  /** AS-IS SetLockRow — DATA_TYPE_CODE != 'SCM' 행 전체 잠금 */
  const lockEdiRpaRows = (grid: FlexGrid<NNMasterMappingRow>): void => {
    grid.itemFormatter = (panel, r, _c, cell) => {
      const row = panel.rows[r]?.dataItem as NNMasterMappingRow | undefined;
      if (row?.DATA_TYPE_CODE && row.DATA_TYPE_CODE !== DATA_TYPE_CODE.SCM) {
        cell.style.backgroundColor = '#f5f5f5';
        cell.style.color = '#999';
      }
    };
  };

  /** AS-IS Division=40 시 PROJECT_CODE 컬럼 비활성 */
  const togglePROJECTColumn = (
    grid: FlexGrid<NNMasterMappingRow> | undefined,
    divisionId: string
  ): void => {
    if (!grid) return;
    const col = grid.columns.find(c => c.binding === 'PROJECT_CODE');
    if (col) {
      const isAutomotive = divisionId === DIVISION_CODE.AUTOMOTIVE;
      col.isReadOnly = isAutomotive;
      col.visible = !isAutomotive;
    }
  };

  /** AS-IS spdMain_ComboSelChange — DIVISION/EndCust cascade */
  const onComboChange = (
    row: NNMasterMappingRow,
    binding: keyof NNMasterMappingRow,
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

  /** 길이 제한 (cellEditEnded 시 차단)
   *  UNLOADING_POINT ≤35, CUSTOMER_PLANT ≤10, CUSTOMER_ITEM_ID ≤50 */
  const truncateOversizeCell = (
    row: NNMasterMappingRow,
    binding: keyof NNMasterMappingRow
  ): boolean => {
    const limits: Partial<Record<keyof NNMasterMappingRow, number>> = {
      UNLOADING_POINT: 35,
      CUSTOMER_PLANT: 10,
      CUSTOMER_ITEM_ID: 50,
    };
    const limit = limits[binding];
    if (!limit) return false;
    const value = row[binding];
    if (typeof value === 'string' && value.length > limit) {
      row[binding] = value.substring(0, limit) as never;
      return true;
    }
    return false;
  };

  return {
    lockEdiRpaRows,
    togglePROJECTColumn,
    onComboChange,
    truncateOversizeCell,
  };
};
