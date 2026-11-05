import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { MasterValidationRow } from '../master-validation.types';

import styles from './MasterValidationMasterGrid.module.scss';

interface Props {
  gridRef: MutableRefObject<FlexGrid<MasterValidationRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: MasterValidationRow[];
  // "Validation Info" 메타(admin fetch — 하드코딩 금지). QUERY/OPEN 액션 컬럼 포함.
  staticColumns: RawFlexGridColumnConfig[];
  onQuery: (row: MasterValidationRow) => void;
  onOpen: (row: MasterValidationRow) => void;
  onRowSelect: (row: MasterValidationRow) => void;
  gotFocus?: () => void;
}

// 마스터 목록(siMain "Validation Info") — read-only. QUERY/OPEN 액션셀만 클릭 동작(design 01 R20).
//   QUERY 클릭 = 해당 행 검증 SP dispatch, OPEN 클릭 = PROGRAM_ID 네비게이션. 그 외 셀 클릭 = 행 선택
//   (CONSTRAINTS01 파싱으로 조회조건 잠금 + detail sheet 프리뷰 전환, design 01 §2-C R15).
export const MasterValidationMasterGrid = ({
  gridRef,
  gridFilterRef,
  data,
  staticColumns,
  onQuery,
  onOpen,
  onRowSelect,
  gotFocus,
}: Props) => {
  // QUERY/OPEN 컬럼은 데이터 바인딩이 없는 액션셀 — formatItem 으로 클릭 가능한 라벨을 렌더한다.
  //   PROCEDURE_NAME='-' 행(Sales Site 등 비활성)은 QUERY 를 비워 조회 불가를 시각화한다(design 03 §3).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handler = (_s: unknown, e: { cell: HTMLElement; row: number; col: number; panel: { cellType: CellType } }) => {
      if (e.panel.cellType !== CellType.Cell || e.row < 0) return;
      const binding = grid.columns[e.col]?.binding;
      const row = grid.rows[e.row]?.dataItem as MasterValidationRow | undefined;
      if (!row) return;
      if (binding === 'QUERY') {
        const queryable = (row.PROCEDURE_NAME ?? '').trim() !== '' && (row.PROCEDURE_NAME ?? '') !== '-';
        e.cell.textContent = queryable ? 'Query' : '';
        e.cell.classList.toggle(styles.actionCell, queryable);
      } else if (binding === 'OPEN') {
        const openable = (row.PROGRAM_ID ?? '').trim() !== '';
        e.cell.textContent = openable ? 'Open' : '';
        e.cell.classList.toggle(styles.actionCell, openable);
      }
    };
    grid.formatItem.addHandler(handler);
    return () => grid.formatItem.removeHandler(handler);
  }, [gridRef]);

  const handleClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.row < 0) return;
    const row = grid.rows[ht.row]?.dataItem as MasterValidationRow | undefined;
    if (!row) return;
    const binding = grid.columns[ht.col]?.binding;
    if (binding === 'QUERY') {
      if ((row.PROCEDURE_NAME ?? '').trim() !== '' && row.PROCEDURE_NAME !== '-') onQuery(row);
    } else if (binding === 'OPEN') {
      if ((row.PROGRAM_ID ?? '').trim() !== '') onOpen(row);
    } else {
      onRowSelect(row);
    }
  };

  return (
    <DataGrid<MasterValidationRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly
      itemsSource={data}
      staticColumns={staticColumns}
      click={handleClick}
      gotFocus={gotFocus}
    />
  );
};
