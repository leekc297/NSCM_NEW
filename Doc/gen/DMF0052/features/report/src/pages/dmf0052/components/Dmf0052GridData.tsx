// DMF0052 EDISummary — TobeGen 생성 골격 (As-is DMF0052_EDISummary, Fact Pack Doc/asisfacts/screens/DMF0052)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 스프레드 spdData ← 시트 'ERP Data' / 'GSCM Data' (activeSheetData 전환)
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../dmf0052.constants';
import { useDmf0052Store } from '../useDmf0052Store';

interface Dmf0052GridDataProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.ERP_DATA>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.ERP_DATA>[];
  staticColumns: RawFlexGridColumnConfig[];
}

export const Dmf0052GridData = ({ gridRef, gridFilterRef, data, staticColumns }: Dmf0052GridDataProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.ERP_DATA, RESPONSE_SET.MAIN>>>();
  const activeSheet = useDmf0052Store(state => state.activeSheetData);
  const setActiveSheet = useDmf0052Store(state => state.setActiveSheetData);
  // TODO(이식): 시트 ERP Data / GSCM Data 전환 UI — TabWrapper 또는 SubTitle 탭 (DMF0045 activeSheet 선례)
  void activeSheet; void setActiveSheet;

  // AS-IS 그리드 이벤트(이식 TODO — DataGrid 의 initialized={grid => grid.<event>.addHandler(...)} 또는 해당 prop 으로 배선):
  //   spdData.ActiveSheetChanging → spdData_ActiveSheetChanging (DMF0052_EDISummary.Designer.cs:657) — activeSheet 상태 변경(store) → 시트별 DataGrid/TabWrapper

  // AS-IS this.spdData.CellDoubleClick → spdData_CellDoubleClick (DMF0052_EDISummary.Designer.cs:658)
  //   To-Be 패턴: DataGrid dblClick → handleDblClick(hitTest → binding 분기 → 모달/드릴다운)
  const handleData = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    void binding;
    // TODO(이식): As-is spdData_CellDoubleClick 로직
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.ERP_DATA>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleData}
    />
  );
};
