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

interface FormationGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.FORMATION>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.FORMATION, RESPONSE_SET.FORMATION>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const FormationGrid = ({ gridRef, gridFilterRef, data, setActiveTab }: FormationGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.FORMATION>> | undefined>();
  const staticColumns = useFormationStore(state => state.staticColumns);
  const { setToast } = useMessageStore.getState();

  const { t } = useTranslation();

  // 수율/LT 셀 검증 + 총수율 자동계산(AS-IS setTotalYield). TOTAL 은 read-only(메타 잠금)라 여기서만 쓴다.
  const handleCellEdit = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.FORMATION>>,
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

    if (['FORMATION_YIELD', 'CHAR_YIELD', 'SSP_MODIFY_YIELD'].includes(binding)) {
      // 수율은 1~100. 벗어나면 1 로 되돌리고 알림(AS-IS MSG00203 {1,100}).
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
      if (binding === 'FORMATION_YIELD' || binding === 'CHAR_YIELD') {
        const total = calcTotalYield(
          Number((dataItem as Record<string, unknown>).FORMATION_YIELD),
          Number((dataItem as Record<string, unknown>).CHAR_YIELD)
        );
        setCell('FORMATION_TOTAL_YIELD', total);
      }
    } else if (binding === 'LT_FORMATION') {
      // Formation L/T > 0 (AS-IS MSG00193 UPPER_ZERO). 위반 시 1 로.
      if (Number.isNaN(num) || num <= 0) {
        setCell(binding, 1);
        setToast({ type: 'error', message: t('MSG00193', '_0 보다 큰 값을 입력하세요.', { 0: '0' }) });
      }
    } else if (binding === 'ADD_LT_FORMATION') {
      // Add L/T 정수·0 이상 (AS-IS MSG00085 ZERO_OR_HIGHER). 위반 시 0 으로.
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
    <DataGrid<ResponseData<MENU_ID, SHEETS.FORMATION>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.FORMATION]}
      allowMerging={AllowMerging.None}
      alternatingRowStep={0}
      gotFocus={() => setActiveTab(SHEET_INDEX.FORMATION)}
      cellEditEnded={handleCellEdit}
    />
  );
};
