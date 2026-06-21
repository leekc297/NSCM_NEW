import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { BASE_COLUMN_COUNT, MENU_ID, SHEETS } from '../contribute-view.constants';
import { buildColumnMeta, type ColumnMeta } from '../hooks/useContributeViewExpression';
import type { SalesViewRow, SpreadTitleRow } from '../types';
import { useContributeViewStore } from '../useContributeViewStore';

interface Props {
  gridRef: MutableRefObject<FlexGridType<SalesViewRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  data: SalesViewRow[];
}

// AS-IS DMF0043_Contribute_View.cs InitSpread + SetSpreadHeaderSpan
//   - 좌측 9 컬럼 (BASE) = staticColumns + frozen (wrapper 자동)
//   - 우측 동적 (지역 × Commission/Markup) = dynamicColumns (large group + leaf)
//   - read-only grid (AS-IS L342: siMain.LockColumn(0, Max, true))
//   - 룰 #10 datagrid-shared-component-mandatory: 공용 DataGrid wrapper + @foundation/utils
//   - 룰 #70 P3: SalesViewRow extends WijmoRowItem (types.ts)
//   - 룰 #70 P4: dynamicColumns group + leaf 객체에 allowSorting/allowMerging false 명시

// 동적 컬럼 (Row 0 large = 지역, Row 1 leaf = Commission/Markup) → FlexGridColumnConfig
// 인접 같은 large 컬럼은 wijmo `allowMerging: ColumnHeaders` 가 자동 가로 머지.
// 룰 #70 P4 — group + leaf 객체에 allowSorting/allowMerging false 명시.
const buildDynamicColumns = (metas: ColumnMeta[]): FlexGridColumnConfig[] =>
  metas
    .filter(m => !m.isBase && !m.isHidden)
    .map(m => ({
      header: m.large,
      align: 'center',
      allowSorting: false,
      allowMerging: false,
      height: 24,
      columns: [
        {
          binding: m.binding,
          header: m.leaf,
          width: m.width,
          align: 'right',
          format: 'n0',
          allowSorting: false,
          allowMerging: false,
          height: 24,
          _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        },
      ],
    })) as FlexGridColumnConfig[];

export const ContributeViewGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const titleFilter = useContributeViewStore(s => s.filters[SHEETS.MAIN_TITLE]);
  // BASE 컬럼 = admin SHEET_COLUMNS (UI Category Setup) 동적 fetch — VISIBLE/WIDTH/ALIGN
  // 즉시 반영 (룰 #65 ui-category-setup-column-meta). 하드코딩 0.
  // ⚠️ hook #70 P1 — `?? []` fallback 금지 (매 render 새 array → re-render loop).
  //    store init 에 `[SHEETS.MAIN]: []` 명시 → undefined 안 됨.
  const staticColumnsAll = useContributeViewStore(s => s.staticColumns[SHEETS.MAIN]);
  const visibleBaseColumns = useContributeViewStore(s => s.visibleBaseColumns);

  // ColumnSettingModal OK 결과 (visibleBaseColumns) 반영 — display flag 동적 override.
  // 빈배열 = popup 사용 전 (전체 표시).
  const staticColumns = useMemo(() => {
    if (!staticColumnsAll || visibleBaseColumns.length === 0) return staticColumnsAll;
    return staticColumnsAll.map(c => ({
      ...c,
      display: visibleBaseColumns.includes(c.colNm),
    }));
  }, [staticColumnsAll, visibleBaseColumns]);

  // AS-IS InitSpread: DMF0043_GET_SALES_LIST_SPREAD_TITLE — 동적 컬럼 (지역×Type) 메타 fetch
  const { data: titleData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN_TITLE,
    tabId: MENU_ID,
    filters: titleFilter,
    enabled: !!titleFilter,
  });

  // SP body 가 SORT_ORDER_NO 기준 정렬 + DISTINCT 처리됨 → FE dedup 불필요
  const titleRows = useMemo<SpreadTitleRow[]>(
    () => (titleData?.o_rc1 ?? []) as unknown as SpreadTitleRow[],
    [titleData]
  );

  // SP titleData 의 dynamic 컬럼만 build (BASE 9 = admin staticColumns 가 처리)
  const columnMetas = useMemo<ColumnMeta[]>(
    () => buildColumnMeta(titleRows, BASE_COLUMN_COUNT),
    [titleRows]
  );

  const dynamicColumns = useMemo(() => buildDynamicColumns(columnMetas), [columnMetas]);

  return (
    <DataGrid<SalesViewRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      itemsSource={data}
      isReadOnly
      allowMerging={AllowMerging.All}
    />
  );
};
