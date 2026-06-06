import { CellRange, CellType, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { type MENU_ID, SHEETS } from '../customer-fcst-master.constants';
import { useCustomerFcstMasterStore } from '../useCustomerFcstMasterStore';

interface CustomerFcstMasterFcstGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_FCST>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<
    EditTracker<ResponseData<MENU_ID, SHEETS.CUSTOMER_FCST>> | undefined
  >;
  data: ResponseData<MENU_ID, SHEETS.CUSTOMER_FCST>[];
}

export const CustomerFcstMasterFcstGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
}: CustomerFcstMasterFcstGridProps) => {
  const staticColumns = useCustomerFcstMasterStore(
    state => state.staticColumns[SHEETS.CUSTOMER_FCST]
  );
  const dateColumns = useCustomerFcstMasterStore(state => state.dateColumns);

  const handleActiveChange = (
    sender: FlexGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_FCST>>,
    cellRangeEventArgs: CellRangeEventArgs
  ) => {
    if (cellRangeEventArgs.panel.cellType !== CellType.Cell) return;

    const row = cellRangeEventArgs.row;
    const col = cellRangeEventArgs.col;
    const binding = GridUtils.getBinding(sender, col);
    const dataItem = GridUtils.getRow(sender, row);
    if (!binding || !dataItem) return;

    // ⭐ B3 격차 보강 (Phase 7 A1 후속, 2026-06-04) — DMF0007 격차 #1
    // AS-IS DMF0007_CustFcstMaster.cs L1213~1221: Measure='CUST_FCST' 입력 시 MSG00379 + revert.
    // 룰 07 §2.10.2 변형 (single-value 차단).
    if (binding === 'MEASURE' && String((dataItem as Record<string, unknown>).MEASURE ?? '') === 'CUST_FCST') {
      void useMessageStore.getState().setAlert({
        type: 'alert',
        content: 'CUST_FCST 메저는 사용할 수 없습니다.',  // i18n: MSG00379
      });
      // revert: 빈 값으로 복원 (AS-IS L1218: siMain.SetText(e.Row, e.Column, ""))
      editTrackerRef.current?.storeChange(dataItem, 'MEASURE', 'CUST_FCST', '');
      (dataItem as Record<string, unknown>).MEASURE = '';
      sender.refreshRange(new CellRange(row, col, row, col));
      return;
    }

    if (binding !== 'VALID_YN') return;
    if (dataItem[binding] !== 'N') return;

    Object.keys(dataItem).forEach(key => {
      if (!key.startsWith('D_')) return;

      if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE)
        editTrackerRef.current?.storeChange(dataItem, key, dataItem[key], 'N');

      dataItem[key] = 'N';
    });
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_FCST>>
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
