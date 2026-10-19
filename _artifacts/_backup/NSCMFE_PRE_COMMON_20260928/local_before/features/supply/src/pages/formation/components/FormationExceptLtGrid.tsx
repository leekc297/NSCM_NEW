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
  const { setAlert } = useMessageStore.getState();

  const { t } = useTranslation();

  // 편집 진입 시점 셀 값 스냅샷 — 값이 실제로 바뀐 편집에서만 검증/보정한다(빈 셀 클릭 진입-이탈로도
  //   cellEditEnded 가 떠서 값이 강제 보정되는 것을 막는다). FormationGrid 와 동일 규약.
  const preEditRef = useRef<{ row: number; col: number; value: string | number | null | undefined }>();
  const handleBeginEdit = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT_LT>>,
    e: CellRangeEventArgs
  ) => {
    const binding = grid.columns[e.col]?.binding ?? '';
    const item = GridUtils.getRow(grid, e.row) as Record<string, unknown> | undefined;
    preEditRef.current = {
      row: e.row,
      col: e.col,
      value: item?.[binding] as string | number | null | undefined,
    };
  };

  // L/T 예외 — LT_FORMATION > 0, ADD_LT_FORMATION 정수·0 이상. 기간 중복은 저장 시 서버 99010.
  const handleCellEdit = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT_LT>>,
    e: CellRangeEventArgs
  ) => {
    const binding = grid.columns[e.col]?.binding;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!binding || !dataItem) return;

    // 값이 실제로 바뀌지 않았으면(클릭 진입-이탈·편집 취소 등) 검증/보정하지 않는다.
    const snap = preEditRef.current;
    const nextRaw = (dataItem as Record<string, unknown>)[binding] as
      | string
      | number
      | null
      | undefined;
    if (
      snap &&
      snap.row === e.row &&
      snap.col === e.col &&
      String(snap.value ?? '') === String(nextRaw ?? '')
    ) {
      return;
    }

    const setCell = (col: string, value: string | number) => {
      const record = dataItem as Record<string, unknown>;
      editTrackerRef.current?.storeChange(dataItem, col, record[col] as string | number, value);
      record[col] = value;
    };

    const num = Number((dataItem as Record<string, unknown>)[binding]);
    if (binding === 'LT_FORMATION') {
      // Formation L/T > 0 (MSG00699 0보다 큰 정수). 위반 시 1 로.
      if (Number.isNaN(num) || num <= 0) {
        setCell(binding, 1);
        void setAlert({ type: 'alert', content: t('MSG00699', '_0보다 큰 정수를 입력하십시오.') });
      }
    } else if (binding === 'ADD_LT_FORMATION') {
      // Add L/T 정수·0 이상 (MSG00085 ZERO_OR_HIGHER). 위반 시 0 으로.
      if (Number.isNaN(num) || num < 0 || !Number.isInteger(num)) {
        setCell(binding, 0);
        void setAlert({
          type: 'alert',
          content: t('MSG00085', '_0 이상의 정수를 입력하세요.', { 0: '0' }),
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
      beginningEdit={handleBeginEdit}
      cellEditEnded={handleCellEdit}
    />
  );
};
