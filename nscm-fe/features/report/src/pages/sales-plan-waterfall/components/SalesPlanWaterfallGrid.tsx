import { type FlexGrid, AllowMerging, SelectionMode } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../sales-plan-waterfall.constants';
import { useSalesPlanWaterfallStore } from '../useSalesPlanWaterfallStore';

interface SalesPlanWaterfallGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.SALES_PLAN_WATERFALL>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SALES_PLAN_WATERFALL>[];
  tabId: string;
}

export const SalesPlanWaterfallGrid = ({
  gridRef,
  gridFilterRef,
  data,
  tabId,
}: SalesPlanWaterfallGridProps) => {
  const titleFilters = useSalesPlanWaterfallStore(state => state.titleFilters);
  const baseColumns = useSalesPlanWaterfallStore(state => state.staticColumns);

  const { data: titleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: titleFilters,
    enabled: titleFilters !== undefined,
  });

  const dynamicColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    const rows = titleData?.o_rc1 ?? [];
    if (rows.length === 0) return [];
    return rows
      .slice()
      .sort((a, b) => Number(a.SORT_ORDER_NO ?? 0) - Number(b.SORT_ORDER_NO ?? 0))
      .filter(row => !String(row.COLUMN_NAME).startsWith('B_'))
      .map(row => ({
        colNm: String(row.COLUMN_NAME),
        colLblNm: String(row.COLUMN_LABEL_NAME ?? ''),
        sClsLblNm: String(row.SMALL_CLASS_LABEL_NAME ?? ''),
        lClsLblNm: String(row.LARGE_CLASS_LABEL_NAME ?? ''),
        colWth: row.COLUMN_WIDTH ? Number(row.COLUMN_WIDTH) : undefined,
        visible: row.VISIBLE_FLAG !== 'N',
        display: true,
        horzAlgnCd:
          row.HORIZONTAL_ALIGN_CODE === 'R' ? 'R' : row.HORIZONTAL_ALIGN_CODE === 'C' ? 'C' : 'L',
        attribute1: String(row.DAY_CODE ?? ''),
      })) as RawFlexGridColumnConfig[];
  }, [titleData?.o_rc1]);

  const staticColumns = dynamicColumns.length > 0 ? dynamicColumns : baseColumns;

  // TODO(F9): chkMem=true 시 lock-area Gainsboro / unlock month white (formatItem)
  // TODO(F12): M_/W_ 헤더 더블클릭 → 자식 컬럼 visible 토글
  // TODO(F15): cboKRW/USD/LOC/QTY index 별 divisor MEASURE 행 적용
  // TODO(F16): Footer SUM (D_/M_/W_ prefix, SumIgnoreHidden)
  // TODO(S4): SAT/SUN 헤더 색상 (DAY_CODE 참조), 당월/당주 Green Bold
  // TODO(S4): NOTATION/FORMATTER (INTEGER/POINT/POINT3) Measure 행 포맷
  // TODO(S4): Freeze — frozenColumns = columns.findIndex(c => c.binding === 'MEASURE') + 1
  // TODO(S4): LockColumn(0..max,true) — 전체 read-only
  // TODO(S4): Bucket 전환 D_/W_/M_ visible 토글 (chkSum 영향)

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.SALES_PLAN_WATERFALL>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      selectionMode={SelectionMode.MultiRange}
      allowMerging={AllowMerging.Cells}
      alternatingRowStep={0}
      useSummaryTooltip
      useResultColumns
      useHotkey
    />
  );
};
