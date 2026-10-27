// SSP0015 ShipmentPSI — TobeGen 생성 골격 (As-is SSP0015_ShipmentPSI, Fact Pack Doc/asisfacts/screens/SSP0015)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 스프레드 spdMain ← 시트 'WH In Plan Detail'
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../shipment-plan-mobility-it.constants';

interface ShipmentPlanMobilityItGridMainProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.WH_IN_PLAN_DETAIL>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.WH_IN_PLAN_DETAIL>[];
  staticColumns: RawFlexGridColumnConfig[];
}

export const ShipmentPlanMobilityItGridMain = ({ gridRef, gridFilterRef, data, staticColumns }: ShipmentPlanMobilityItGridMainProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.WH_IN_PLAN_DETAIL, RESPONSE_SET.MAIN>>>();

  // AS-IS 그리드 이벤트(이식 TODO — DataGrid 의 initialized={grid => grid.<event>.addHandler(...)} 또는 해당 prop 으로 배선):
  //   spdMain.TextTipFetch → spdMain_TextTipFetch (SSP0015_ShipmentPSI.Designer.cs:906) — (사전 없음 — map_event.csv 추가)
  //   spdMain.TopChange → SpdMain_TopChange (SSP0015_ShipmentPSI.cs:1161) — scrollPositionChanged (고정 머지 재적용)
  //   spdMain.ActiveSheetChanged → SpdMain_ActiveSheetChanged (SSP0015_ShipmentPSI.cs:1177) 호출: biz:CommonData.CommonDataList [code=LookupCommon], SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN, biz:CommonData.CommonDataList [code=PlanDateShip], SCP.SCM0001_GET_SCP_DAY_PERIOD — activeSheet 상태 변경(store) → 시트별 DataGrid/TabWrapper
  //   spdMain.EditModeOn → SpdMain_EditModeOn (SSP0015_ShipmentPSI.cs:1186) — beginningEdit → 편집 가능 판정(e.cancel) / LockRange 재현

  // AS-IS this.spdMain.CellDoubleClick → SpdMain_CellDoubleClick (SSP0015_ShipmentPSI.cs:1159)
  //   호출 엔드포인트: SSP.SSP0015_GET_STOCK_LOCATION_DETAIL, SSP.SSP0002_GET_NERP_CODE, SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN, SSP.SSP0015_GET_SCS_STOCK, SSP.SSP0015_GET_SHIPMENT_PSI, SSP.SSP0015_GET_MES_STOCK, SSP.SSP0015_GET_BLOCK_STOCK, SSP.SSP0015_GET_WH_STOCK, SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
  //   To-Be 패턴: DataGrid dblClick → handleDblClick(hitTest → binding 분기 → 모달/드릴다운)
  const handleSpdMain = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    void binding;
    // TODO(이식): As-is SpdMain_CellDoubleClick 로직
  };

  // AS-IS spdMain.CellClick → SpdMain_CellClick (SSP0015_ShipmentPSI.cs:1187)
  //   To-Be 패턴: DataGrid click → handleClick(hitTest)
  const handleSpdMainCell = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    void binding;
    // TODO(이식): As-is SpdMain_CellClick 로직
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.WH_IN_PLAN_DETAIL>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleSpdMain}
      click={handleSpdMainCell}
    />
  );
};
