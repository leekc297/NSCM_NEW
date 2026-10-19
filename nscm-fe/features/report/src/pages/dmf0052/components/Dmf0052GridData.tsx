// DMF0052 EDISummary — As-is 스프레드 spdData ← 시트 'ERP Data' / 'GSCM Data' (activeSheetData 전환)
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../dmf0052.constants';
import { useDmf0052Validation } from '../hooks/useDmf0052Validation';
import { useDmf0052Store } from '../useDmf0052Store';

interface Dmf0052GridDataProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.ERP_DATA>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.ERP_DATA>[];
  staticColumns: RawFlexGridColumnConfig[];
}

export const Dmf0052GridData = ({ gridRef, gridFilterRef, data, staticColumns }: Dmf0052GridDataProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.ERP_DATA, RESPONSE_SET.MAIN>>>();
  const setSelectedDataRow = useDmf0052Store(state => state.setSelectedDataRow);
  const setOpenGSCMDataModal = useDmf0052Store(state => state.setOpenGSCMDataModal);
  const { runDataGuard } = useDmf0052Validation();

  // AS-IS this.spdData.CellDoubleClick → spdData_CellDoubleClick (DMF0052_EDISummary.Designer.cs:658)
  //   V-004 (validation.md:634 siMain.ActiveSheet.Rows.Count <= 0) : 행 0건이면 종료
  //   AS-IS 로직: 셀 더블클릭 시 GSCM Data Popup 호출 → 선택 행을 store 에 담고 모달을 연다.
  const handleData = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    if (!runDataGuard(data.length)) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as Record<string, unknown> | undefined;
    if (!dataItem) return;
    setSelectedDataRow(dataItem);
    setOpenGSCMDataModal(true);
  };

  // AS-IS spdData.ActiveSheetChanging (DMF0052_EDISummary.Designer.cs:657) — FarPoint 다중 시트 전환 이벤트.
  //   To-Be 에서는 단일 DataGrid 가 store.activeSheetData 를 구독해 시트별 columns/data 를 바인딩하므로
  //   별도의 'Changing' 이벤트가 없다. 전환은 Dmf0052GridSummaryPjt.handlePjt 와 Dmf0052.handleRefresh 가 setActiveSheetData 로 수행.

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.ERP_DATA>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleData}
    />
  );
};
