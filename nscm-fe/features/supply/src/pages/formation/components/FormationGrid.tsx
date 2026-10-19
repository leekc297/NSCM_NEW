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

interface FormationGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.FORMATION>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.FORMATION, RESPONSE_SET.FORMATION>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const FormationGrid = ({ gridRef, gridFilterRef, data, setActiveTab }: FormationGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.FORMATION>> | undefined>();
  const staticColumns = useFormationStore(state => state.staticColumns);
  const { setAlert } = useMessageStore.getState();

  const { t } = useTranslation();

  // 편집 진입 시점 셀 값 스냅샷 — 값이 실제로 바뀐 편집에서만 검증/보정한다.
  //   cellEditEnded 는 빈 셀에 클릭해 들어갔다 나오기만 해도(값 변경 없이) 발동하므로, 가드가
  //   없으면 그때마다 빈/0 셀이 1 로 강제되고 알림이 뜬다("클릭만 했는데 1이 입력" 증상).
  const preEditRef = useRef<{ row: number; col: number; value: string | number | null | undefined }>();
  const handleBeginEdit = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.FORMATION>>,
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

  // 수율/LT 셀 검증 + 총수율 자동계산(AS-IS setTotalYield). TOTAL 은 read-only(메타 잠금)라 여기서만 쓴다.
  const handleCellEdit = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.FORMATION>>,
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

    if (['FORMATION_YIELD', 'CHAR_YIELD', 'SSP_MODIFY_YIELD'].includes(binding)) {
      // 수율은 1~100. 벗어나면 1 로 되돌리고 알림(MSG01037 {1,100}).
      if (Number.isNaN(num) || num < YIELD_MIN || num > YIELD_MAX) {
        setCell(binding, YIELD_MIN);
        void setAlert({
          type: 'alert',
          content: t('MSG01037', '_{0}~{1} 사이의 수를 입력하세요')
            .replace('{0}', String(YIELD_MIN))
            .replace('{1}', String(YIELD_MAX)),
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
      // Formation L/T > 0 (MSG00699 0보다 큰 정수). 위반 시 1 로.
      if (Number.isNaN(num) || num <= 0) {
        setCell(binding, 1);
        void setAlert({ type: 'alert', content: t('MSG00699', '_0보다 큰 정수를 입력하십시오.') });
      }
    } else if (binding === 'ADD_LT_FORMATION') {
      // Add L/T 는 음수 허용(min -9999999999, design 03 §1.1 SO7). 파싱 실패 시에만 0 으로 리셋한다
      //   (AS-IS ZERO_OR_HIGHER→MSG00085). 음수는 정상 입력이므로 막지 않는다.
      if (Number.isNaN(num)) {
        setCell(binding, 0);
        void setAlert({
          type: 'alert',
          content: t('MSG00085', '_{0} 이상의 값만 입력 가능합니다.').replace('{0}', '0'),
        });
      }
    }
    GridUtils.refreshRow(grid, e.row);
  };

  // 붙여넣기도 편집과 같은 검증·총수율 계산을 탄다. 스냅샷은 편집 전용이라 비운다.
  const handlePasted = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.FORMATION>>,
    e: CellRangeEventArgs
  ) => {
    preEditRef.current = undefined;
    handleCellEdit(grid, e);
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
      initialized={attachNumberInputBlock}
      beginningEdit={handleBeginEdit}
      cellEditEnded={handleCellEdit}
      pastedCell={handlePasted}
    />
  );
};
