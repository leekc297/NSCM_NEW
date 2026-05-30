/**
 * DMF0043 Contribute_Main — Expression hook (3건)
 * AS-IS: __asis-mapping__.md §4 — LockRange row / LockColumn full / ColumnHeaderSpan SUM
 */
import type { FlexGrid } from '@mescius/wijmo.grid';

import { EDIT_FLAG } from '../contribute-main.constants';
import type { ContributeMainRow } from '../contribute-main.types';

export const useContributeMainExpression = () => {
  /** AS-IS .cs:202 EditButton — EDIT_FLAG='N' 행 전체 잠금 */
  const lockNonEditableRows = (grid: FlexGrid<ContributeMainRow>): void => {
    const view = grid.collectionView;
    if (!view) return;
    grid.itemFormatter = (panel, r, c, cell) => {
      const row = panel.rows[r]?.dataItem as ContributeMainRow | undefined;
      if (row?.EDIT_FLAG === EDIT_FLAG.NOT_EDITABLE) {
        cell.style.backgroundColor = '#f5f5f5';
        cell.style.color = '#999';
      }
    };
  };

  /** AS-IS .cs:273 FindData 후 전체 컬럼 읽기전용 */
  const lockAllColumns = (grid: FlexGrid<ContributeMainRow>, readOnly: boolean): void => {
    grid.isReadOnly = readOnly;
  };

  /** AS-IS .cs:630, 658 SetSpreadHeaderSpan — 3년 SUM 그룹 헤더 머지
   *  Wijmo FlexGrid 의 ColumnGroup 정의로 구현 */
  const buildYearSumColumnGroups = () => [
    {
      header: '전년 SUM',
      columns: [{ header: 'PREV_YEAR_SUM', binding: 'PREV_YEAR_SUM', width: 100, align: 'right' }],
    },
    {
      header: '당년 SUM',
      columns: [{ header: 'CURR_YEAR_SUM', binding: 'CURR_YEAR_SUM', width: 100, align: 'right' }],
    },
    {
      header: '차년 SUM',
      columns: [{ header: 'NEXT_YEAR_SUM', binding: 'NEXT_YEAR_SUM', width: 100, align: 'right' }],
    },
  ];

  return {
    lockNonEditableRows,
    lockAllColumns,
    buildYearSumColumnGroups,
  };
};
