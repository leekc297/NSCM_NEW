// SCP0096 Shipment_Working_Day_OSP — TobeGen 생성 골격 (As-is SCP0096_Shipment_Working_Day_OSP, Fact Pack Doc/asisfacts/screens/SCP0096)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 스프레드 spdMain ← 시트 'Shipment Working Day OSP'
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../shipment-working-day-osp.constants';

interface ShipmentWorkingDayOspGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SHIPMENT_WORKING_DAY_OSP>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SHIPMENT_WORKING_DAY_OSP>[];
  staticColumns: RawFlexGridColumnConfig[];
}

export const ShipmentWorkingDayOspGrid = ({ gridRef, gridFilterRef, data, staticColumns }: ShipmentWorkingDayOspGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.SHIPMENT_WORKING_DAY_OSP, RESPONSE_SET.MAIN>>>();

  // AS-IS 그리드 이벤트(이식 TODO — DataGrid 의 initialized={grid => grid.<event>.addHandler(...)} 또는 해당 prop 으로 배선):
  //   spdMain.TopChange → SpdMain_TopChange (SCP0096_Shipment_Working_Day_OSP.cs:250) — scrollPositionChanged (고정 머지 재적용)

  // AS-IS spdMain.CellDoubleClick → SpdMain_CellDoubleClick (SCP0096_Shipment_Working_Day_OSP.cs:249)
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

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.SHIPMENT_WORKING_DAY_OSP>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleSpdMain}
    />
  );
};
