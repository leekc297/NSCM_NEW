import {
  AllowMerging,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  BOD_EXCLUDED_COLUMN,
  BOD_EXCLUDED_EDITABLE,
  BOD_EXCLUDED_MERGE_COLUMNS,
  MENU_ID,
  SHEETS,
} from '../bod-item.constants';
import type { BodExcludedRow } from '../bod-item.types';
import { useBodItemStore } from '../useBodItemStore';

// 편집모드에서 편집가능 셀 배경(AS-IS UnLockColor, 편집가능=Yellow) — 조회 readonly 와 구분. bodItem 과 동일.
const EDITABLE_BG_COLOR = '#fffbe6';

interface BodExcludedGridProps {
  gridRef: MutableRefObject<FlexGrid<BodExcludedRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: BodExcludedRow[];
  isEditMode: boolean;
  divisionId: string;
  /** ITEM_ID 셀 더블클릭 → Material-by-division 팝업(03 §5-7). */
  onItemCellDblClick: (row: BodExcludedRow, rowIndex: number) => void;
  /** BOD_ID 셀 더블클릭 → GetBODItem 팝업(retList cascade 신규행 채움, 03 §5-7). */
  onBodCellDblClick: (row: BodExcludedRow, rowIndex: number) => void;
}

// ITEM_ID/BOD_ID = 팝업 셀(더블클릭으로 열림) — 인라인 편집 진입을 취소한다(#5-16 팝업 셀 편집취소).
const POPUP_CELLS: readonly string[] = [BOD_EXCLUDED_COLUMN.ITEM_ID, BOD_EXCLUDED_COLUMN.BOD_ID];

/**
 * Excluded Item 시트 그리드 — 편집가능=BOD_EX_FROM/TO_YYYYMMDD·VALID_YN(03 §3-A). 신규행은 Excluded
 * 시트에서만 추가(bodItem 은 추가불가), 키(DIVISION_ID/ITEM_ID/BOD_ID)는 팝업으로 채운다. ITEM_ID/BOD_ID
 * 셀 더블클릭으로 Material/GetBODItem 팝업을 열고(#5-16 편집취소), VALID_YN 콤보(YesOrNo)는 admin 메타 구동.
 * 세로 병합(SmartColMerge cs:403/799, 03 §3-E) + 편집모드 편집가능 셀 편집색(#95)은 bodItem 과 동일 처방.
 */
export const BodExcludedGrid = ({
  gridRef,
  gridFilterRef,
  data,
  isEditMode,
  divisionId,
  onItemCellDblClick,
  onBodCellDblClick,
}: BodExcludedGridProps) => {
  const staticColumns = useBodItemStore(state => state.staticColumns[SHEETS.BOD_EXCLUDED]);

  const isEditModeRef = useRef(isEditMode);
  isEditModeRef.current = isEditMode;

  // 편집가능 게이트 — 팝업 셀(ITEM_ID/BOD_ID)은 인라인 편집 취소(더블클릭 팝업 경로), 그 외는 편집모드 +
  // 화이트리스트일 때만 허용.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handler = (s: FlexGrid<BodExcludedRow>, e: CellRangeEventArgs) => {
      const binding = s.columns[e.col]?.binding;
      if (!binding) return;
      if (POPUP_CELLS.includes(binding)) {
        e.cancel = true;
        return;
      }
      if (!isEditModeRef.current || !BOD_EXCLUDED_EDITABLE.includes(binding)) {
        e.cancel = true;
      }
    };
    grid.beginningEdit.addHandler(handler);
    return () => grid.beginningEdit.removeHandler(handler);
  }, [gridRef]);

  // 컬럼별 병합(allowMerging) — 공용 DataGrid 는 allowMerging prop 이 켜지면 전 컬럼에 true 를 씌우므로,
  // updatedLayout 마다 BOD_EXCLUDED_MERGE_COLUMNS 외 컬럼을 false 로 되돌린다(bodItem 표준 처방).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const apply = () => {
      for (const col of grid.columns) {
        if (!col.binding) continue;
        col.allowMerging = BOD_EXCLUDED_MERGE_COLUMNS.has(col.binding);
      }
    };
    grid.updatedLayout.addHandler(apply);
    apply();
    return () => {
      grid.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, data]);

  // 셀 배경 — 편집모드 화이트리스트 셀=편집색, 그 외 해제(셀 DOM 재사용 대비 항상 재설정).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handler = (s: FlexGrid<BodExcludedRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding;
      if (!binding) return;
      e.cell.style.backgroundColor =
        isEditModeRef.current && BOD_EXCLUDED_EDITABLE.includes(binding) ? EDITABLE_BG_COLOR : '';
    };
    grid.formatItem.addHandler(handler);
    grid.invalidate();
    return () => grid.formatItem.removeHandler(handler);
  }, [gridRef, data, isEditMode]);

  // 팝업 셀 더블클릭 → 각 팝업 오픈(신규행 키 채움).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    // AS-IS SpdMain_CellDoubleClick 가드(cs:1775, buttonGuards #12): IsLock(SheetName) 또는
    // (기존행 && 비편집모드)이면 팝업 미오픈. TO-BE 는 시트 잠금 = 비편집모드라 편집모드 게이트로 등가
    // (신규행도 편집모드에서만 추가). 게이트 없으면 조회 readonly 행을 더블클릭해 키(ITEM_ID/BOD_ID)를
    // 채우고 CRUD_TYPE='M' 로 오염시킬 수 있음(04_react-gap.md G-DBLCLICK-EDITMODE-GUARD).
    if (!isEditModeRef.current) return;
    const binding = grid.columns[ht.col]?.binding;
    const dataItem = GridUtils.getRow(grid, ht.row) as BodExcludedRow | undefined;
    if (!dataItem) return;
    if (binding === BOD_EXCLUDED_COLUMN.ITEM_ID) onItemCellDblClick(dataItem, ht.row);
    else if (binding === BOD_EXCLUDED_COLUMN.BOD_ID) onBodCellDblClick(dataItem, ht.row);
  };

  const itemsSource = useMemo(() => data, [data]);

  return (
    <DataGrid<BodExcludedRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={itemsSource}
      staticColumns={staticColumns}
      allowMerging={AllowMerging.Cells}
      comboParams={{ divisionId, mnuId: MENU_ID }}
      dblClick={handleDblClick}
    />
  );
};
