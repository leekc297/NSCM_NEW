import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../scp-if-blocking.constants';
import { useScpIfBlockingStore } from '../useScpIfBlockingStore';

interface ScpIfBlockingGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.MAIN>[];
}

// 단일 평면 그리드(design 03): 5컬럼 전부 admin 메타 구동(하드코딩 금지, COL-02/03).
//   DIVISION_ID·PLAN_START_YYYYMMDD = 키·잠금(INPUT_TP_CD='S', 메타 구동 — GRID-07/COL-01).
//   FP/MRP/DM_RTF_YN = FPComboBox + YesOrNo 셀콤보(메타 CELL_COMBO_DATA_TYPE, 공용 DataGrid 자동 배선).
//   Measure 0 → 정적 칼럼셋(피벗 없음). 셀콤보 상위 좁힘/cascade 없음(상수 2값) → 커스텀 콤보 로직 불요.
export const ScpIfBlockingGrid = ({ gridRef, gridFilterRef, data }: ScpIfBlockingGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const staticColumns = useScpIfBlockingStore(state => state.staticColumns);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.MAIN>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
