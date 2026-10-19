// DMF0052 EDISummary — TobeGen 생성 골격 (As-is DMF0052_EDISummary, Fact Pack Doc/asisfacts/screens/DMF0052)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 스프레드 spdSummaryPJT ← 시트 'Summary Pjt'
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../dmf0052.constants';

interface Dmf0052GridSummaryPjtProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SUMMARY_PJT>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SUMMARY_PJT>[];
  staticColumns: RawFlexGridColumnConfig[];
}

export const Dmf0052GridSummaryPjt = ({ gridRef, gridFilterRef, data, staticColumns }: Dmf0052GridSummaryPjtProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.SUMMARY_PJT, RESPONSE_SET.MAIN>>>();

  // AS-IS this.spdSummaryPJT.CellDoubleClick → spdPjt_CellDoubleClick (DMF0052_EDISummary.Designer.cs:171)
  //   호출 엔드포인트: DM.DMF0052_GET_ERP_DATA, DM.DMF0052_GET_SPREAD_TITLE, DM.DMF0052_GET_DETAIL_DATA
  //   To-Be 패턴: DataGrid dblClick → handleDblClick(hitTest → binding 분기 → 모달/드릴다운)
  const handlePjt = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    void binding;
    // TODO(이식): As-is spdPjt_CellDoubleClick 로직
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.SUMMARY_PJT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handlePjt}
    />
  );
};
