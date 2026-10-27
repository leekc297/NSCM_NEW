// SSP0015 ShipmentPSI — TobeGen 생성 골격 (As-is SSP0015_ShipmentPSI, Fact Pack Doc/asisfacts/screens/SSP0015)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 스프레드 spdDetail ← 시트 'Hold stock Detail' / 'Hold stock' / 'MES Stock Detail' / 'SCS Stock Detail' / 'Shipment Confirm Detail' / 'Shipment PSI(IT & Mobile)' / 'Shipment PSI(Mobility & IT)' / 'Shipment PSI(Packer)' / 'Shipment Request Detail' / 'Shipment Result' / 'Stock Detail' / 'Stock Location Detail' / 'W/H stock' / 'W/H stock Detail' (activeSheetDetail 전환)
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../shipment-plan-mobility-it.constants';
import { useShipmentPlanMobilityItStore } from '../useShipmentPlanMobilityItStore';

interface ShipmentPlanMobilityItGridDetailProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.HOLD_STOCK_DETAIL>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.HOLD_STOCK_DETAIL>[];
  staticColumns: RawFlexGridColumnConfig[];
}

export const ShipmentPlanMobilityItGridDetail = ({ gridRef, gridFilterRef, data, staticColumns }: ShipmentPlanMobilityItGridDetailProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.HOLD_STOCK_DETAIL, RESPONSE_SET.MAIN>>>();
  const activeSheet = useShipmentPlanMobilityItStore(state => state.activeSheetDetail);
  const setActiveSheet = useShipmentPlanMobilityItStore(state => state.setActiveSheetDetail);
  // TODO(이식): 시트 Hold stock Detail / Hold stock / MES Stock Detail / SCS Stock Detail / Shipment Confirm Detail / Shipment PSI(IT & Mobile) / Shipment PSI(Mobility & IT) / Shipment PSI(Packer) / Shipment Request Detail / Shipment Result / Stock Detail / Stock Location Detail / W/H stock / W/H stock Detail 전환 UI — TabWrapper 또는 SubTitle 탭 (DMF0045 activeSheet 선례)
  void activeSheet; void setActiveSheet;

  // AS-IS 그리드 이벤트(이식 TODO — DataGrid 의 initialized={grid => grid.<event>.addHandler(...)} 또는 해당 prop 으로 배선):
  //   spdDetail.TopChange → SpdDetail_TopChange (SSP0015_ShipmentPSI.cs:1162) — scrollPositionChanged (고정 머지 재적용)
  //   spdDetail.ComboSelChange → spdDetail_ComboSelChange (SSP0015_ShipmentPSI.cs:1173) — cellEditEnded → 콤보 셀 편집 확정 처리
  //   spdDetail.SheetTabClick → SpdDetail_SheetTabClick (SSP0015_ShipmentPSI.cs:1174) — activeSheet 상태 변경(store) → 시트별 DataGrid/TabWrapper
  //   spdDetail.ActiveSheetChanged → SpdDetail_ActiveSheetChanged (SSP0015_ShipmentPSI.cs:1181) — activeSheet 상태 변경(store) → 시트별 DataGrid/TabWrapper
  //   spdDetail.EditChange → SpdDetail_EditChange (SSP0015_ShipmentPSI.cs:1182) — cellEditEnded → 재계산/CRUD_TYPE 갱신(EditTracker)
  //   spdDetail.ClipboardPasted → SpdDetail_ClipboardPasted (SSP0015_ShipmentPSI.cs:1183) 호출: biz:CommonData.CommonDataList [code=TransMode] — pastingCell/pastedCell → 붙여넣기 검증·CRUD_TYPE

  // AS-IS this.spdDetail.CellClick → SpdDetail_CellClick (SSP0015_ShipmentPSI.cs:1172)
  //   호출 엔드포인트: biz:CommonData.CommonDataList [code=TransMode], biz:CommonData.CommonDataList [code=ShipToCodeByDivision]
  //   To-Be 패턴: DataGrid click → handleClick(hitTest)
  const handleSpdDetailCell = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    void binding;
    // TODO(이식): As-is SpdDetail_CellClick 로직
  };

  // AS-IS this.spdDetail.CellDoubleClick → SpdDetail_CellDoubleClick (SSP0015_ShipmentPSI.cs:1175)
  //   To-Be 패턴: DataGrid dblClick → handleDblClick(hitTest → binding 분기 → 모달/드릴다운)
  const handleSpdDetail = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    void binding;
    // TODO(이식): As-is SpdDetail_CellDoubleClick 로직
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.HOLD_STOCK_DETAIL>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleSpdDetail}
      click={handleSpdDetailCell}
    />
  );
};
