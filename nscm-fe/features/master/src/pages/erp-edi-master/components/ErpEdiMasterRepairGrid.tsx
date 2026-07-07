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
  /** AS-IS .cs L1973 column index 분기 매핑 — SALES_SITE 또는 SSPM 단일 sheet target */
  onDblClick: (
    targetSheet: 'SALES_SITE' | 'SSPM',
    row: ResponseData<MENU_ID, SHEETS.REPAIR>
  ) => void;
}

// AS-IS .cs L1032/L1150 — '확인필요' 컬러 대상 7 컬럼
// AS-IS .cs L1322/L1361 — 더블클릭 후 0 row 응답 시 표시되는 MessageBox 메시지 분류:
//   - SALES_SITE / ACTIVE_SS 가 확인필요 → MSG00445 "Sales Site UI에서 Sales Site를 추가하시기 바랍니다."
//   - GSCM_SSPM ~ PLANT 가 확인필요  → MSG00446 "Sales Site Project Model UI에서 데이터를 추가하시기 바랍니다."
const REPAIR_STATUS_COLUMNS_SALES_SITE = new Set(['GSCM_SALES_SITE_ID', 'ACTIVE_SS']);
const REPAIR_STATUS_COLUMNS_SSPM = new Set([
  'GSCM_SSPM',
  'GSCM_SSPM_INCOTERMS',
  'ACTIVE_SSPM',
  'PROJECT_STATUS',
  'PLANT_SITE_STATUS',
]);

export const ErpEdiMasterRepairGrid = ({
  gridRef,
  gridFilterRef,
  data,
  onDblClick,
}: ErpEdiMasterRepairGridProps) => {
  const { t } = useTranslation();
  const staticColumns = useErpEdiMasterStore(state => state.staticColumns.repair);

  // AS-IS .cs L1973: column < GSCM_SSPM_INDEX → SALES_SITE / else → SSPM
  // To-Be: binding 비교 — REPAIR_STATUS_COLUMNS_SSPM 에 속하거나 그 이후 컬럼 = SSPM.
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    const binding = GridUtils.getBinding(grid, ht.col);
    if (typeof binding !== 'string') return;

    // GSCM_SSPM 컬럼 인덱스를 찾아 비교 (AS-IS column index 기반 분기 1:1 매핑)
    const gscmSspmCol = grid.columns.findIndex(c => c.binding === 'GSCM_SSPM');
    const targetSheet: 'SALES_SITE' | 'SSPM' =
      gscmSspmCol >= 0 && ht.col >= gscmSspmCol ? 'SSPM' : 'SALES_SITE';

    onDblClick(targetSheet, dataItem);
  };

  // 셀 시각 (hook #95 grid-cell-backcolor-standard):
  //   base — 클래스 없음 = White + 홀짝 zebra (공용 DataGrid 자동). ⚠ 조회 grid 통째 회색칠 금지(blanket gray 제거).
  //   override — 값=='확인필요' & 컬럼 ∈ REPAIR_STATUS_COLUMNS → ForeColor=Red, BackColor=Azure (특수 상태 강조)
  //   tooltip — '확인필요' 셀 hover 시 AS-IS .cs L1350/L1370 안내(MSG00445 SALES_SITE / MSG00446 SSPM).
  const handleFormatItem = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.REPAIR>>,
    args: FormatItemEventArgs
  ) => {
    if (args.panel.cellType !== CellType.Cell) return;
    const binding = GridUtils.getBinding(grid, args.col);
    if (typeof binding !== 'string') return;
    const isSalesSiteCol = REPAIR_STATUS_COLUMNS_SALES_SITE.has(binding);
    const isSspmCol = REPAIR_STATUS_COLUMNS_SSPM.has(binding);
    if (!isSalesSiteCol && !isSspmCol) return;
    const row = GridUtils.getRow(grid, args.row);
    if (!row) return;
    const value = row[binding];
    if (value === '확인필요') {
      args.cell.style.color = 'red';
      args.cell.style.backgroundColor = 'azure';
      args.cell.title = isSalesSiteCol
        ? t('MSG00445', '_Sales Site UI에서 Sales Site를 추가하시기 바랍니다.')
        : t('MSG00446', '_Sales Site Project Model UI에서 데이터를 추가하시기 바랍니다.');
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
