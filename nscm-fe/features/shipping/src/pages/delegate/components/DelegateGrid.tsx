import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { ColumnMeta } from '../delegate.constants';
import { buildColumns } from '../utils/delegateColumns';

interface Props {
  rows: WijmoRowItem[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  columnMeta: ColumnMeta[];
  adminColumns?: RawFlexGridColumnConfig[];
  // Delegate 시트만 CHK 선택(useCheckbox=Selector). Delegated List 는 view-only(false). design 03 §1-B.
  useCheckbox: boolean;
}

// AS-IS spdMain 시트(Delegate / Delegated List) — DIVISION_ID~끝열 LockColumn(전칼럼 읽기전용),
//   SmartColMerge(인접 동일값 세로 병합, 단일 헤더). 선택은 공용 DataGrid useCheckbox(Selector,
//   rowHeader 체크박스 + 헤더 전체선택 = AS-IS SpdMain_CellClick 헤더 토글 전행선택 등가, design 03 §3).
export const DelegateGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  columnMeta,
  adminColumns,
  useCheckbox,
}: Props) => {
  const columns = useMemo(() => buildColumns(columnMeta, adminColumns), [columnMeta, adminColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly
      itemsSource={rows}
      staticColumns={columns}
      useCheckbox={useCheckbox}
      // AS-IS SmartColMerge(cs:200,208) 재현 — 인접 동일값 세로 병합. CustomMergeManager 는 좌→우
      //   누적 키라 DIVISION_ID -> FROM_DATE -> ... 선행 식별 컬럼 계층 병합(design 03 §3 #1,#3).
      allowMerging={AllowMerging.Cells}
    />
  );
};
