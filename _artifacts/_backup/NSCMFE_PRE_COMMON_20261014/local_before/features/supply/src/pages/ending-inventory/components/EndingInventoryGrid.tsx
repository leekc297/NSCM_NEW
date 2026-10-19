import {
  AllowMerging,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  AGING_COLUMNS,
  CELL_CF_YELLOW,
  CELL_CF_YELLOW_COLUMNS,
  COL,
  DETAIL_COLUMNS,
  MERGE_COLUMNS,
  SEARCH_MODE,
  type SearchMode,
} from '../ending-inventory.constants';
import type { EndingInventoryRow } from '../ending-inventory.types';
import { useEndingInventoryStore } from '../useEndingInventoryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<EndingInventoryRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: EndingInventoryRow[];
  mode: SearchMode;
  divisionId: string;
  isHeaderViewDetail: boolean;
  // QUANTITY 헤더 더블클릭 → 상세 3컬럼 토글(AS-IS SpdMain_CellDoubleClick, cs:456~468).
  onToggleDetail: () => void;
}

// cboDivision 값에 '40' 포함(또는 All) 시 CELL_TYPE_GR 표시 — AS-IS SetHeaderDivision(cs:578~596).
const hasDivision40 = (divisionId: string): boolean =>
  divisionId === 'ALL' || divisionId.split(',').includes('40');

export const EndingInventoryGrid = ({
  gridRef,
  gridFilterRef,
  data,
  mode,
  divisionId,
  isHeaderViewDetail,
  onToggleDetail,
}: Props) => {
  const staticColumns = useEndingInventoryStore(state => state.staticColumns);

  const isDaily = mode === SEARCH_MODE.DAILY;
  const showCellTypeGr = hasDivision40(divisionId);

  // 동적 컬럼 가시성 — 공용 DataGrid 가 updatedLayout 마다 columnGroups(메타 visible)를 재적용하므로
  //   그 뒤에 화면 규칙을 다시 씌운다(bod/forecast-price 표준 처방). 명시 규칙 컬럼만 건드리고,
  //   나머지는 admin 메타 visible 을 그대로 둔다.
  //     - 재고월령 39컬럼: 항상 숨김(chkDetail 정적 숨김 재현 — 01_layout R8, goal.md C5)
  //     - 상세 3컬럼      : isHeaderViewDetail (초기 숨김, QUANTITY 헤더 더블클릭 토글)
  //     - YYYYMMDD        : DAILY 모드만 표시(SetHeaderDaily, cs:563~576)
  //     - CELL_TYPE_GR    : div∋'40'/All 만 표시(SetHeaderDivision, cs:578~596)
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const agingSet = new Set(AGING_COLUMNS);
    const detailSet = new Set(DETAIL_COLUMNS);
    const apply = () => {
      let changed = false;
      for (const col of g.columns) {
        const b = col.binding ?? '';
        let want: boolean | undefined;
        if (agingSet.has(b)) want = false;
        else if (detailSet.has(b)) want = isHeaderViewDetail;
        else if (b === COL.YYYYMMDD) want = isDaily;
        else if (b === COL.CELL_TYPE_GR) want = showCellTypeGr;
        if (want !== undefined && col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, staticColumns, data, isHeaderViewDetail, isDaily, showCellTypeGr]);

  // 컬럼별 병합(allowMerging) — 공용 DataGrid 는 allowMerging prop 이 켜지면 전 컬럼에 true 를 씌우므로,
  //   선두 그룹 컬럼(MERGE_COLUMNS)만 남기고 나머지는 updatedLayout 마다 false 로 되돌린다(bod 처방).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const apply = () => {
      for (const col of g.columns) {
        if (!col.binding) continue;
        col.allowMerging = MERGE_COLUMNS.has(col.binding);
      }
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, staticColumns, data]);

  // 조건부 셀 배경색 — USE_CELL_CF_BOM='Y' 행의 CELL_CONVER_FACTOR/QUANTITY 셀 Yellow(cs:256/257).
  //   DataGrid 는 formatItem prop 을 노출하지 않아 셀 DOM 에 직접 style 을 세팅한다(bod 선례).
  //   셀 DOM 재사용 대비 미해당 시 반드시 '' 로 해제한다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const yellowSet = new Set(CELL_CF_YELLOW_COLUMNS);
    const handler = (s: FlexGrid<EndingInventoryRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding;
      if (!binding || !yellowSet.has(binding)) return;
      const dataItem = GridUtils.getRow(s, e.row) as WijmoRowItem | undefined;
      const useBom = String(dataItem?.[COL.USE_CELL_CF_BOM] ?? '') === 'Y';
      e.cell.style.backgroundColor = useBom ? CELL_CF_YELLOW : '';
    };
    g.formatItem.addHandler(handler);
    g.invalidate();
    return () => g.formatItem.removeHandler(handler);
  }, [gridRef, data]);

  // QUANTITY 헤더 더블클릭만 상세 토글(다른 헤더·데이터셀 무반응 — cs:460~465 헤더 가드 + QUANTITY 한정).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(mouseEvent);
    if (ht.cellType !== CellType.ColumnHeader) return;
    if (g.columns[ht.col]?.binding !== COL.QUANTITY) return;
    onToggleDetail();
  };

  return (
    <DataGrid<EndingInventoryRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      // 전 컬럼 읽기전용 Report — 편집셀 없음(LockColumn, cs:356). staticColumns INPUT_TP_CD 전건 'S'.
      // SmartColMerge(cs:362) → Cells 로 켜 CustomMergeManager 가 선두 누적 동일값을 세로 병합.
      allowMerging={AllowMerging.Cells}
      dblClick={handleDblClick}
    />
  );
};
