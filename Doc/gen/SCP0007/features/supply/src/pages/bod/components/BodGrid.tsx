// SCP0007 BOD — TobeGen 생성 골격 (As-is SCP0007_BOD, Fact Pack Doc/asisfacts/screens/SCP0007)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 스프레드 spdMain ← 시트 'BOD' / 'Distribution Route' (activeSheet 전환)
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../bod.constants';
import { useBodStore } from '../useBodStore';

// AS-IS 시트 'Distribution Route' — 코드 하드코딩 전용(메타 없음). grid_effective.csv 근거 (division 축: 40, 81, 82, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)
//   메타(SCM_MST_SHEET_COLUMNS) 미등록 시트이므로 하드코딩 허용. 등록 후에는 staticColumns 로 전환하고 이 배열을 지울 것.
const HARD_COLUMNS_DISTRIBUTION_ROUTE: RawFlexGridColumnConfig[] = [
  { colNm: 'A_COUNTRY', colLblNm: 'Country', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'A_PORT_CODE', colLblNm: 'Port Code', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'A_PORT_NAME', colLblNm: 'Port', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'D_COUNTRY', colLblNm: 'Country', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'D_PORT_CODE', colLblNm: 'Port Code', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'D_PORT_NAME', colLblNm: 'Port', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'DAYS', colLblNm: 'Departure Days', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'DAYS_FRI', colLblNm: 'Fri', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'DAYS_MON', colLblNm: 'Mon', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'DAYS_SAT', colLblNm: 'Sat', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'DAYS_SUN', colLblNm: 'Sun', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'DAYS_THU', colLblNm: 'Thu', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'DAYS_TUE', colLblNm: 'Tue', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'DAYS_WED', colLblNm: 'Wed', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'FROM_CITY', colLblNm: 'City', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'FROM_CITY_NAME', colLblNm: 'City Name', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'FROM_COUNTRY', colLblNm: 'Country', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'LT_ARRIVAL_INLAND', colLblNm: 'Arrival Inland', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'LT_DEPARTURE_INLAND', colLblNm: 'Departure Inland', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'LT_LAY_OFF_CLEARANCE', colLblNm: 'Lay Off/Customs Clearance', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'LT_SUM', colLblNm: 'Sum', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'LT_TYPE', colLblNm: 'L/T Type', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'LT_VOYAGE', colLblNm: 'Sea/Air Ferry', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'LT_WAIT_SHIPPING', colLblNm: 'Waiting For Shipping', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'PRIORITY', colLblNm: 'Priority', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'ROUTE_ID', colLblNm: 'Route Id', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'SHIP_DOC_PREPARATION_DATE', colLblNm: 'Shipping Document Preparation Data', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'SHIPPING_COMPANY', colLblNm: 'Shipping Company', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'TO_CITY', colLblNm: 'City', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'TO_CITY_NAME', colLblNm: 'City Name', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'TO_COUNTRY', colLblNm: 'Country', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'TRANSPORT_MODE_NAME', colLblNm: 'Trans Mode', visible: true, display: true, defaultFlag: true }, // CODE
  { colNm: 'VALID_YN', colLblNm: 'Valid', visible: true, display: true, defaultFlag: true }, // CODE
];

interface BodGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.BOD>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.BOD>[];
  staticColumns: RawFlexGridColumnConfig[];
}

export const BodGrid = ({ gridRef, gridFilterRef, data, staticColumns }: BodGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.BOD, RESPONSE_SET.MAIN>>>();
  const activeSheet = useBodStore(state => state.activeSheet);
  const setActiveSheet = useBodStore(state => state.setActiveSheet);
  // TODO(이식): 시트 BOD / Distribution Route 전환 UI — TabWrapper 또는 SubTitle 탭 (DMF0045 activeSheet 선례)
  void activeSheet; void setActiveSheet;

  // AS-IS 그리드 이벤트(이식 TODO — DataGrid 의 initialized={grid => grid.<event>.addHandler(...)} 또는 해당 prop 으로 배선):
  //   spdMain.TopChange → SpdMain_TopChange (SCP0007_BOD.cs:179) — scrollPositionChanged (고정 머지 재적용)
  //   spdMain.ComboSelChange → SpdMain_ComboSelChange (SCP0007_BOD.cs:180) — cellEditEnded → 콤보 셀 편집 확정 처리
  //   spdMain.ClipboardPasted → SpdMain_ClipboardPasted (SCP0007_BOD.cs:181) — pastingCell/pastedCell → 붙여넣기 검증·CRUD_TYPE
  //   spdMain.KeyPress → SpdMain_KeyPress (SCP0007_BOD.cs:182) — keyDown → 단축키 / Enter 이동 / 숫자 입력 제한은 beginningEdit+cellEditEnding
  //   spdMain.EditChange → SpdMain_EditChange (SCP0007_BOD.cs:183) — cellEditEnded → 재계산/CRUD_TYPE 갱신(EditTracker)

  // AS-IS spdMain.CellDoubleClick → spdMain_CellDoubleClick (SCP0007_BOD.cs:178)
  //   To-Be 패턴: DataGrid dblClick → handleDblClick(hitTest → binding 분기 → 모달/드릴다운)
  const handleMain = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    void binding;
    // TODO(이식): As-is spdMain_CellDoubleClick 로직
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.BOD>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleMain}
    />
  );
};
