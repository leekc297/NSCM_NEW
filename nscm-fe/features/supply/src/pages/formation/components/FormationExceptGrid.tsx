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
import { attachNumberInputBlock, RESPONSE_SET, SHEET_INDEX, YIELD_MAX, YIELD_MIN, calcTotalYield } from '../formation.constants';
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
  const { setAlert } = useMessageStore.getState();

  const { t } = useTranslation();

  // 편집 진입 시점 셀 값 스냅샷 — 값이 실제로 바뀐 편집에서만 검증/보정한다(빈 셀 클릭 진입-이탈로도
  //   cellEditEnded 가 떠서 값이 강제 보정되는 것을 막는다). FormationGrid 와 동일 규약.
  const preEditRef = useRef<{ row: number; col: number; value: string | number | null | undefined }>();
  const handleBeginEdit = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT>>,
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

  // 수율 예외 — formation_yield/CHAR_YIELD 검증 + 총수율 자동계산. 기간(start/end)은 저장 시 서버 99010 중복검증.
  const handleCellEdit = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT>>,
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

    if (['FORMATION_YIELD', 'CHAR_YIELD'].includes(binding)) {
      const num = Number((dataItem as Record<string, unknown>)[binding]);
      if (Number.isNaN(num) || num < YIELD_MIN || num > YIELD_MAX) {
        setCell(binding, YIELD_MIN);
        void setAlert({
          type: 'alert',
          content: t('MSG01037', '_{0}~{1} 사이의 수를 입력하세요')
            .replace('{0}', String(YIELD_MIN))
            .replace('{1}', String(YIELD_MAX)),
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

  // 붙여넣기도 편집과 같은 검증·총수율 계산을 탄다. 스냅샷은 편집 전용이라 비운다.
  const handlePasted = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.EXCEPT>>,
    e: CellRangeEventArgs
  ) => {
    preEditRef.current = undefined;
    handleCellEdit(grid, e);
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
      initialized={attachNumberInputBlock}
      beginningEdit={handleBeginEdit}
      cellEditEnded={handleCellEdit}
      pastedCell={handlePasted}
    />
  );
};
