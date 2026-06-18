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

// AS-IS .cs L1253/L1349/L1370 — '확인필요' 셀 더블클릭 시 표시되는 메시지 (column 별 분기).
//   GSCM_SALES_SITE_ID / ACTIVE_SS  → MSG00445 (Sales Site UI 추가)
//   GSCM_SSPM / GSCM_SSPM_INCOTERMS / ACTIVE_SSPM → MSG00446 (SSPM UI 추가)
//   PROJECT_STATUS / PLANT_SITE_STATUS  → 일반 확인 필요 안내
//
// 2026-06-17 사용자 요구: 더블클릭 (Wijmo 에디터 진입) 대신 mouseover tooltip 으로 표시.
const REPAIR_CONFIRM_MSG: Record<string, string> = {
  GSCM_SALES_SITE_ID: 'Sales Site UI에서 Sales Site를 추가하시기 바랍니다',
  ACTIVE_SS: 'Sales Site UI에서 Sales Site를 추가하시기 바랍니다',
  GSCM_SSPM: 'SSPM UI에서 SSPM을 추가하시기 바랍니다',
  GSCM_SSPM_INCOTERMS: 'SSPM UI에서 SSPM을 추가하시기 바랍니다',
  ACTIVE_SSPM: 'SSPM UI에서 SSPM을 추가하시기 바랍니다',
  PROJECT_STATUS: 'Project Status 확인이 필요합니다',
  PLANT_SITE_STATUS: 'Plant Site Status 확인이 필요합니다',
};

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
  // ⭐ 2026-06-17 사용자 요구 — mouseover tooltip (AS-IS 더블클릭 = Wijmo 에디터 진입 충돌).
  //   AS-IS 의 더블클릭 메시지를 cell title attribute 로 대체 → 사용자가 셀에 호버 시 native tooltip 표시.
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
      // mouseover tooltip — AS-IS 더블클릭 메시지 (MSG00445/MSG00446 등) column 별 분기.
      args.cell.title = REPAIR_CONFIRM_MSG[binding] ?? '확인 필요';
      args.cell.style.cursor = 'help';
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
