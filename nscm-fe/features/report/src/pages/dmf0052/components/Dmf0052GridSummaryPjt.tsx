// DMF0052 EDISummary — As-is 스프레드 spdSummaryPJT ← 시트 'Summary Pjt'
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../dmf0052.constants';
import { SHEETS as SHEETS_ENUM } from '../dmf0052.constants';
import { useDmf0052Validation } from '../hooks/useDmf0052Validation';
import { useDmf0052Store } from '../useDmf0052Store';

interface Dmf0052GridSummaryPjtProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SUMMARY_PJT>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SUMMARY_PJT>[];
  staticColumns: RawFlexGridColumnConfig[];
}

const toStr = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');
const toNum = (v: unknown): number => (typeof v === 'number' ? v : typeof v === 'string' ? Number(v.trim()) : 0);

export const Dmf0052GridSummaryPjt = ({ gridRef, gridFilterRef, data, staticColumns }: Dmf0052GridSummaryPjtProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.SUMMARY_PJT, RESPONSE_SET.MAIN>>>();
  const setActiveSheetData = useDmf0052Store(state => state.setActiveSheetData);
  const setSelectedPjtKey = useDmf0052Store(state => state.setSelectedPjtKey);
  const { runPjtGuard } = useDmf0052Validation();

  // AS-IS this.spdSummaryPJT.CellDoubleClick → spdPjt_CellDoubleClick (DMF0052_EDISummary.Designer.cs:171)
  //   호출 엔드포인트: DM.DMF0052_GET_ERP_DATA (ERP Data 전환), DM.DMF0052_GET_DETAIL_DATA (GSCM Data 전환)
  //   business_analysis.md §3-3 분기:
  //     column=CHECK_GSCM_CNT && 값 != 0 → activeSheet='GSCM Data'
  //     column=CHECK_ERP_CNT  && 값 != 0 → activeSheet='ERP Data'
  //   V-003 (validation.md:572 siPjt.ActiveSheet.Rows.Count <= 0) : 행 0건이면 종료
  const handlePjt = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    if (!runPjtGuard(data.length)) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as Record<string, unknown> | undefined;
    if (!dataItem) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    const asNum = toNum(binding ? dataItem[binding] : undefined);
    if (!asNum) return; // AS-IS: 값 != "0"
    const projectCode = toStr(dataItem.PROJECT_CODE) || toStr(dataItem.PJT_CODE);
    const senderCode = toStr(dataItem.SENDER_CODE) || toStr(dataItem.EDI_SENDER_CODE);
    setSelectedPjtKey({ projectCode, senderCode });
    if (binding === 'CHECK_GSCM_CNT') {
      setActiveSheetData(SHEETS_ENUM.GSCM_DATA);
    } else if (binding === 'CHECK_ERP_CNT') {
      setActiveSheetData(SHEETS_ENUM.ERP_DATA);
    }
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
