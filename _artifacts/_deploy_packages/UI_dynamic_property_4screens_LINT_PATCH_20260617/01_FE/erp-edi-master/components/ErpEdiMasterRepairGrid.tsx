import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../erp-edi-master.constants';
import { useErpEdiMasterStore } from '../useErpEdiMasterStore';

interface ErpEdiMasterRepairGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.REPAIR>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.REPAIR>[];
  onDblClick: (col: number, row: ResponseData<MENU_ID, SHEETS.REPAIR>) => void;
}

const REPAIR_STATUS_COLUMNS = new Set([
  'GSCM_SALES_SITE_ID',
  'ACTIVE_SS',
  'GSCM_SSPM',
  'GSCM_SSPM_INCOTERMS',
  'ACTIVE_SSPM',
  'PROJECT_STATUS',
  'PLANT_SITE_STATUS',
]);

// AS-IS .cs (DMF0008_ErpEdiMaster.cs L1322-1370) 의 "확인필요" 더블클릭 시 sub 조회 → 분기 메시지.
// 위즈모 grid 더블클릭 = edit 모드 진입 사고 회피 위해 mouseover tooltip 으로 대체 (사용자 요구 2026-06-17).
// - GSCM_SALES_SITE_ID / ACTIVE_SS 의 '확인필요' → Sales Site UI 추가 안내 (As-Is MSG00445)
// - GSCM_SSPM / GSCM_SSPM_INCOTERMS / ACTIVE_SSPM / PROJECT_STATUS / PLANT_SITE_STATUS 의 '확인필요' → Sales Site Project Model UI 추가 안내 (As-Is MSG00446)
const SALES_SITE_BINDINGS = new Set(['GSCM_SALES_SITE_ID', 'ACTIVE_SS']);
const TOOLTIP_MSG_SALES_SITE = 'Sales Site UI에서 Sales Site를 추가하시기 바랍니다.';
const TOOLTIP_MSG_SALES_SITE_PROJECT_MODEL = 'Sales Site Project Model UI에서 데이터를 추가하시기 바랍니다.';

export const ErpEdiMasterRepairGrid = ({
  gridRef,
  gridFilterRef,
  data,
  onDblClick,
}: ErpEdiMasterRepairGridProps) => {
  const staticColumns = useErpEdiMasterStore(state => state.staticColumns.repair);

  // Repair 셀 더블클릭 → Sub 탭 분기 (col < GSCM_SSPM ? SALES_SITE : SSPM)
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    onDblClick(ht.col, dataItem);
  };

  // 셀 시각: 값=='확인필요' 이고 컬럼 ∈ REPAIR_STATUS_COLUMNS → ForeColor=Red, BackColor=Azure
  // + 사용자 요구 (2026-06-17): mouseover tooltip 으로 As-Is 더블클릭 메시지 표시.
  //   더블클릭 = wijmo edit 모드 진입 사고 회피. 컬럼별 분기 메시지 (As-Is MSG00445 / MSG00446).
  const handleFormatItem = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.REPAIR>>,
    args: FormatItemEventArgs
  ) => {
    if (args.panel.cellType !== CellType.Cell) return;
    const binding = GridUtils.getBinding(grid, args.col);
    if (typeof binding !== 'string' || !REPAIR_STATUS_COLUMNS.has(binding)) return;
    const row = GridUtils.getRow(grid, args.row);
    if (!row) return;
    const value = row[binding];
    if (value === '확인필요') {
      args.cell.style.color = 'red';
      args.cell.style.backgroundColor = 'azure';
      args.cell.style.cursor = 'help';
      // 컬럼별 분기 — As-Is FindData_SubSalesSiteProjectModel (L1322-1370) 와 동일 매핑
      const tooltipMsg = SALES_SITE_BINDINGS.has(binding)
        ? TOOLTIP_MSG_SALES_SITE
        : TOOLTIP_MSG_SALES_SITE_PROJECT_MODEL;
      args.cell.setAttribute('title', tooltipMsg);
    } else {
      // '확인필요' 가 아닌 cell 은 tooltip 제거 (wijmo 가 동일 cell DOM 을 재사용하므로 stale 방지)
      args.cell.removeAttribute('title');
      args.cell.style.cursor = '';
    }
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.REPAIR>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleDblClick}
      formatItem={handleFormatItem}
    />
  );
};
