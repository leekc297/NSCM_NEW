// SCP0122 PlanActivityMgmt — TobeGen 생성 골격 (As-is SCP0122_PlanActivityMgmt, Fact Pack Doc/asisfacts/screens/SCP0122)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 스프레드 spdMain ← 시트 'Plan Activity Mgmt'
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../plan-activity-mgmt.constants';

interface PlanActivityMgmtGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.PLAN_ACTIVITY_MGMT>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.PLAN_ACTIVITY_MGMT>[];
  staticColumns: RawFlexGridColumnConfig[];
}

export const PlanActivityMgmtGrid = ({ gridRef, gridFilterRef, data, staticColumns }: PlanActivityMgmtGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.PLAN_ACTIVITY_MGMT, RESPONSE_SET.MAIN>>>();

  // AS-IS 그리드 이벤트(이식 TODO — DataGrid 의 initialized={grid => grid.<event>.addHandler(...)} 또는 해당 prop 으로 배선):
  //   spdMain.ComboSelChange → SpdMain_ComboSelChange (SCP0122_PlanActivityMgmt.cs:220) — cellEditEnded → 콤보 셀 편집 확정 처리

  // AS-IS this.spdMain.CellClick → spdMain_CellClick (SCP0122_PlanActivityMgmt.cs:221)
  //   To-Be 패턴: DataGrid click → handleClick(hitTest)
  const handleMainCell = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    void binding;
    // TODO(이식): As-is spdMain_CellClick 로직
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.PLAN_ACTIVITY_MGMT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      click={handleMainCell}
    />
  );
};
