import { Aggregate } from '@mescius/wijmo';
import { AllowMerging, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { AGGREGATE_COLUMNS } from '../inventory-raw.constants';
import type { InventoryRawRow } from '../inventory-raw.types';

interface Props {
  rows: InventoryRawRow[];
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
}

// AS-IS gridSignals(design 03 §3): 전 컬럼 조회직후 편집잠금(LockColumn) — admin 메타
//   INPUT_TP_CD 가 31컬럼 전부 'S'(ora.py 실측, 2026-09-26)라 공용 DataGrid isEditableCell 이
//   이미 전 셀을 읽기전용으로 판정한다(화면단 별도 lock 로직 불필요).
// Footer 합계 5컬럼(STOCK_QTY/AVAILABLE_QTY/HOLD_QTY/LONG_QTY/EXPIRATION_QTY, §3 규칙#9)은
//   DB 메타에 집계 여부 자체가 없어 여기서 aggregate 를 얹는다(Wijmo GroupRow 표준 합계행).
// SmartColMerge(§3 규칙#6/#10) = AllowMerging.Cells(인접 동일값 셀 병합, MdmClassMaster 표준).
export const InventoryRawGrid = ({ rows, gridRef, gridFilterRef, staticColumns }: Props) => {
  const columns = useMemo(
    () =>
      staticColumns.map(col =>
        (AGGREGATE_COLUMNS as readonly string[]).includes(col.colNm)
          ? { ...col, aggregate: Aggregate.Sum, format: '#,##0.###' }
          : col
      ),
    [staticColumns]
  );

  return (
    <DataGrid<InventoryRawRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={rows}
      staticColumns={columns}
      allowMerging={AllowMerging.Cells}
      useAggregationRow
    />
  );
};
