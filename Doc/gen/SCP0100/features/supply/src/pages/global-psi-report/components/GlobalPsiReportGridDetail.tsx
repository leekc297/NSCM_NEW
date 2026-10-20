// SCP0100 Global_PSI_Report — TobeGen 생성 골격 (As-is SCP0100_Global_PSI_Report, Fact Pack Doc/asisfacts/screens/SCP0100)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 스프레드 spdDetail ← 시트 'SEARCH_LEVEL_DETAIL'
import { type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../global-psi-report.constants';

interface GlobalPsiReportGridDetailProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SEARCH_LEVEL_DETAIL>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SEARCH_LEVEL_DETAIL>[];
  staticColumns: RawFlexGridColumnConfig[];
}

export const GlobalPsiReportGridDetail = ({ gridRef, gridFilterRef, data, staticColumns }: GlobalPsiReportGridDetailProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.SEARCH_LEVEL_DETAIL, RESPONSE_SET.MAIN>>>();

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.SEARCH_LEVEL_DETAIL>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
