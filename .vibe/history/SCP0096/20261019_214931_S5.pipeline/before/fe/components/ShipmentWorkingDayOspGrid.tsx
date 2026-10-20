// SCP0096 Shipment_Working_Day_OSP — TobeGen 생성 골격 (As-is SCP0096_Shipment_Working_Day_OSP, Fact Pack Doc/asisfacts/screens/SCP0096)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is 스프레드 spdMain ← 시트 'Shipment Working Day OSP'
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../shipment-working-day-osp.constants';

interface ShipmentWorkingDayOspGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SHIPMENT_WORKING_DAY_OSP>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SHIPMENT_WORKING_DAY_OSP>[];
  staticColumns: RawFlexGridColumnConfig[];
  sumYn: boolean;
}

// AS-IS SetSpreadColumn (SCP0096_Shipment_Working_Day_OSP.cs:339-386) — 컬럼 binding prefix 별 visibility.
//   D_/W_ 는 항상 보이고, M_/W_ 는 chkSum.Checked 를 따른다. W_ 는 두 분기 모두 적용 — 두 번째 분기가
//   덮어쓰므로 결과적으로 chkSum.Checked 와 같다(AS-IS cs:348·353 그대로).
const applySumVisibility = (
  grid: FlexGrid<ResponseData<MENU_ID, SHEETS.SHIPMENT_WORKING_DAY_OSP>> | undefined,
  sumYn: boolean,
) => {
  if (!grid) return;
  grid.deferUpdate(() => {
    for (const col of grid.columns) {
      const binding = col.binding ?? '';
      if (binding.startsWith('D_')) col.visible = true;
      if (binding.startsWith('M_') || binding.startsWith('W_')) col.visible = sumYn;
    }
  });
};

export const ShipmentWorkingDayOspGrid = ({ gridRef, gridFilterRef, data, staticColumns, sumYn }: ShipmentWorkingDayOspGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.SHIPMENT_WORKING_DAY_OSP, RESPONSE_SET.MAIN>>>();

  // AS-IS chkSum_CheckedChanged (SCP0096_Shipment_Working_Day_OSP.cs:324-337) + 조회 후 cs:484 — 체크/데이터 변화 시 재적용.
  useEffect(() => {
    applySumVisibility(gridRef.current, sumYn);
  }, [gridRef, sumYn, data, staticColumns]);

  // AS-IS SpdMain_CellDoubleClick (SCP0096_Shipment_Working_Day_OSP.cs:820-823) — SpreadInfo.SetDblClickColumnShowHide.
  //   머지 헤더 셀 더블클릭 시 그 하위 상세열의 visibility 를 토글(월→주차→일 3단 접기/펼치기).
  //   To-Be 등가: 더블클릭 대상이 ColumnHeader 이고 머지 범위면 머지 범위 내 하위 D_/W_ 컬럼의 visible 반전.
  const handleSpdMain = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.ColumnHeader) return;
    const range = grid.getMergedRange(grid.columnHeaders, ht.row, ht.col) ?? ht.range;
    if (!range) return;
    let anyVisible = false;
    for (let c = range.leftCol; c <= range.rightCol; c++) if (grid.columns[c]?.visible) { anyVisible = true; break; }
    grid.deferUpdate(() => {
      for (let c = range.leftCol; c <= range.rightCol; c++) {
        const col = grid.columns[c];
        if (!col) continue;
        const binding = col.binding ?? '';
        if (!binding.startsWith('D_') && !binding.startsWith('W_') && !binding.startsWith('M_')) continue;
        col.visible = !anyVisible;
      }
    });
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
