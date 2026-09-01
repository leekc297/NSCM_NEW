import { CellType, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEET_NAME } from '../customer-fcst-master.constants';
import { useCustomerFcstMasterStore } from '../useCustomerFcstMasterStore';

interface CustomerFcstMasterFcstGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEET_NAME>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<ResponseData<MENU_ID, SHEET_NAME>> | undefined>;
  data: ResponseData<MENU_ID, SHEET_NAME>[];
}

export const CustomerFcstMasterFcstGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
}: CustomerFcstMasterFcstGridProps) => {
  const staticColumns = useCustomerFcstMasterStore(state => state.staticColumns);
  const dateColumns = useCustomerFcstMasterStore(state => state.dateColumns);

  // 셀 콤보는 comboId 만 넘긴다 (comboParams 미전달). Division 좁힘은 서버 바인드가 아니라 행 단위
  // cascade 가 맡는다 — 컬럼 메타 attribute2 의 DIVISION_ID:DIVISION_ID 가 그 행의 DIVISION_ID 로
  // 후보를 거른다. 콤보를 division 무관하게 한 벌만 받으므로 division 을 바꿔도 재조회가 없다.
  //
  // Team / End Customer / Sales Site 의 행 단위 후보 좁힘과 상위 변경 시 하위 셀 비우기는 공용
  // DataGrid 가 컬럼 메타로 처리한다 — 콤보는 cellCboDataTp, 종속 규약은 attribute2 다.
  // 화면에 cascade 표를 두지 않는다. 표를 두면 메타와 두 벌이 되어 관리자가 메타를 고쳐도 화면이
  // 안 따라간다 (2026-08-25 정리 — GRID_CASCADE_FILTERS / GRID_CASCADE_CLEAR 제거).
  // 규약은 columnMapping.filterComboRowsByRowItem / DataGrid.findStaleComboCells 참조.

  const handleActiveChange = (
    sender: FlexGrid<ResponseData<MENU_ID, SHEET_NAME>>,
    cellRangeEventArgs: CellRangeEventArgs
  ) => {
    if (cellRangeEventArgs.panel.cellType !== CellType.Cell) return;

    const row = cellRangeEventArgs.row;
    const col = cellRangeEventArgs.col;
    const binding = GridUtils.getBinding(sender, col);
    const dataItem = GridUtils.getRow(sender, row);

    if (binding !== 'VALID_YN' || !dataItem) return;
    if (dataItem[binding] !== 'N') return;

    Object.keys(dataItem).forEach(key => {
      if (!key.startsWith('D_')) return;

      if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE)
        editTrackerRef.current?.storeChange(dataItem, key, dataItem[key], 'N');

      dataItem[key] = 'N';
    });
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEET_NAME>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns ?? []}
      dynamicColumns={dateColumns ?? []}
      cellEditEnded={handleActiveChange}
    />
  );
};
