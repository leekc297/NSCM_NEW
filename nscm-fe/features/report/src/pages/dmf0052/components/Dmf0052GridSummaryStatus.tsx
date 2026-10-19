// DMF0052 EDISummary — TobeGen 생성 골격 (As-is DMF0052_EDISummary, Fact Pack Doc/asisfacts/screens/DMF0052)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 스프레드 spdSummaryStatus ← 시트 'Summary Status'
import { type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../dmf0052.constants';

interface Dmf0052GridSummaryStatusProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SUMMARY_STATUS>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SUMMARY_STATUS>[];
  staticColumns: RawFlexGridColumnConfig[];
}

export const Dmf0052GridSummaryStatus = ({ gridRef, gridFilterRef, data, staticColumns }: Dmf0052GridSummaryStatusProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.SUMMARY_STATUS, RESPONSE_SET.MAIN>>>();

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.SUMMARY_STATUS>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
