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
import { RESPONSE_SET, SHEET_INDEX, YIELD_MAX, YIELD_MIN, calcTotalYield } from '../formation.constants';
import { useFormationStore } from '../useFormationStore';

interface FormationExceptGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.EXCEPT, RESPONSE_SET.EXCEPT>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const FormationExceptGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
}: FormationExceptGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.EXCEPT>> | undefined>();
  const staticColumns = useFormationStore(state => state.staticColumns);
  const { setToast } = useMessageStore.getState();

  const { t } = useTranslation();

  // 수율 예외 — formation_yield/CHAR_YIELD 검증 + 총수율 자동계산. 기간(start/end)은 저장 시 서버 99010 중복검증.
  const handleCellEdit = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT>>,
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

    if (['FORMATION_YIELD', 'CHAR_YIELD'].includes(binding)) {
      const num = Number((dataItem as Record<string, unknown>)[binding]);
      if (Number.isNaN(num) || num < YIELD_MIN || num > YIELD_MAX) {
        setCell(binding, YIELD_MIN);
        setToast({
          type: 'error',
          message: t('MSG00203', '_{{0}}~{{1}} 사이의 값을 입력하세요.', {
            0: YIELD_MIN,
            1: YIELD_MAX,
          }),
        });
      }
      const total = calcTotalYield(
        Number((dataItem as Record<string, unknown>).FORMATION_YIELD),
        Number((dataItem as Record<string, unknown>).CHAR_YIELD)
      );
      setCell('FORMATION_TOTAL_YIELD', total);
    }
    GridUtils.refreshRow(grid, e.row);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.EXCEPT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.EXCEPT]}
      allowMerging={AllowMerging.None}
      alternatingRowStep={0}
      gotFocus={() => setActiveTab(SHEET_INDEX.EXCEPT)}
      cellEditEnded={handleCellEdit}
    />
  );
};
