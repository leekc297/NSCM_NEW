import {
  AllowMerging,
  type CellRangeEventArgs,
  type FlexGrid,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, SHEETS} from '../formation.constants';
import { RESPONSE_SET, SHEET_INDEX } from '../formation.constants';
import { useFormationStore } from '../useFormationStore';

interface FormationExceptLtGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT_LT>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.EXCEPT_LT, RESPONSE_SET.EXCEPT_LT>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const FormationExceptLtGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
}: FormationExceptLtGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.EXCEPT_LT>> | undefined>();
  const staticColumns = useFormationStore(state => state.staticColumns);
  const { setToast } = useMessageStore.getState();

  const { t } = useTranslation();

  // L/T 예외 — LT_FORMATION > 0, ADD_LT_FORMATION 정수·0 이상. 기간 중복은 저장 시 서버 99010.
  const handleCellEdit = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT_LT>>,
    e: CellRangeEventArgs
  ) => {
    const binding = grid.columns[e.col]?.binding;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!binding || !dataItem) return;

    const setCell = (col: string, value: string | number) => {
      const record = dataItem as Record<string, unknown>;
      editTrackerRef.current?.storeChange(dataItem, col, record[col] as string | number, value);
      record[col] = value;
    };

    const num = Number((dataItem as Record<string, unknown>)[binding]);
    if (binding === 'LT_FORMATION') {
      if (Number.isNaN(num) || num <= 0) {
        setCell(binding, 1);
        setToast({ type: 'error', message: t('MSG00193', '_0 보다 큰 값을 입력하세요.', { 0: '0' }) });
      }
    } else if (binding === 'ADD_LT_FORMATION') {
      if (Number.isNaN(num) || num < 0 || !Number.isInteger(num)) {
        setCell(binding, 0);
        setToast({
          type: 'error',
          message: t('MSG00085', '_0 이상의 정수를 입력하세요.', { 0: '0' }),
        });
      }
    }
    GridUtils.refreshRow(grid, e.row);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.EXCEPT_LT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.EXCEPT_LT]}
      allowMerging={AllowMerging.None}
      alternatingRowStep={0}
      gotFocus={() => setActiveTab(SHEET_INDEX.EXCEPT_LT)}
      cellEditEnded={handleCellEdit}
    />
  );
};
