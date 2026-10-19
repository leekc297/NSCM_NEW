import {
  AllowMerging,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import {
  BOD_ITEM_EDITABLE,
  BOD_ITEM_MERGE_COLUMNS,
  MENU_ID,
  SHEETS,
} from '../bod-item.constants';
import type { BodItemRow } from '../bod-item.types';
import { useBodItemStore } from '../useBodItemStore';

// 편집모드에서 편집가능 셀 배경(AS-IS UnLockColor, 편집가능=Yellow) — 조회 readonly 와 구분.
const EDITABLE_BG_COLOR = '#fffbe6';

interface BodItemGridProps {
  gridRef: MutableRefObject<FlexGrid<BodItemRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: BodItemRow[];
  isEditMode: boolean;
  /** Division 콤보 셀(@divisionId) 해소 — comboParams 로 전달. */
  divisionId: string;
}

/**
 * BOD ITEM 시트 그리드 — 조회 직후 전셀 readonly, Edit 진입 시 화이트리스트(FROM/TO_YYYYMMDD·PRIORITY·
 * SAFETY_STOCK·BOD_ITEM_VALID)만 편집(03 §3-A). 세로 병합(SmartColMerge, 03 §3-E). 셀 콤보(BOD_ITEM_VALID/
 * BOD_VALID/ROUTE_VALID=YesOrNo, 사이트/Incoterms 표시전용)는 admin 컬럼메타(CELL_COMBO_DATA_TYPE) 구동이라
 * 여기서 수동 DataMap 을 만들지 않는다.
 * 주의: AS-IS 날짜 6검증(N1~N8) InvalidColor 하이라이트는 재현하지 않는다 — AS-IS SaveData_Main(cs:937-942)
 *   에서 checkValidN1~N8 호출이 전건 주석 처리(BOD LT 2단계, FROM/TO 저장은 BOD UI 관리)라 런타임에 발생하지
 *   않는다(04_react-gap.md G-VALIDATION-REDERIVED).
 */
export const BodItemGrid = ({
  gridRef,
  gridFilterRef,
  data,
  isEditMode,
  divisionId,
}: BodItemGridProps) => {
  const staticColumns = useBodItemStore(state => state.staticColumns[SHEETS.BOD_ITEM]);

  // 최신 편집모드를 이벤트 클로저(effect deps [data])에서 참조하기 위한 ref.
  const isEditModeRef = useRef(isEditMode);
  isEditModeRef.current = isEditMode;

  // 편집가능 셀 게이트 — 조회 readonly 기본, Edit 진입 시 화이트리스트만 해제(#130 배열 이식 금지).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handler = (s: FlexGrid<BodItemRow>, e: CellRangeEventArgs) => {
      const binding = s.columns[e.col]?.binding;
      if (!binding) return;
      if (!isEditModeRef.current || !BOD_ITEM_EDITABLE.includes(binding)) {
        e.cancel = true;
      }
    };
    grid.beginningEdit.addHandler(handler);
    return () => grid.beginningEdit.removeHandler(handler);
  }, [gridRef]);

  // 컬럼별 병합(allowMerging) — 공용 DataGrid 는 allowMerging prop 이 켜지면 전 컬럼에 true 를 씌우므로,
  // updatedLayout 마다 BOD_ITEM_MERGE_COLUMNS 외 컬럼을 false 로 되돌린다(BodGrid 표준 처방).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const apply = () => {
      for (const col of grid.columns) {
        if (!col.binding) continue;
        col.allowMerging = BOD_ITEM_MERGE_COLUMNS.has(col.binding);
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
    const handler = (s: FlexGrid<BodItemRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding;
      if (!binding) return;
      e.cell.style.backgroundColor =
        isEditModeRef.current && BOD_ITEM_EDITABLE.includes(binding) ? EDITABLE_BG_COLOR : '';
    };
    grid.formatItem.addHandler(handler);
    grid.invalidate();
    return () => grid.formatItem.removeHandler(handler);
  }, [gridRef, data, isEditMode]);

  const itemsSource = useMemo(() => data, [data]);

  return (
    <DataGrid<BodItemRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={itemsSource}
      staticColumns={staticColumns}
      allowMerging={AllowMerging.Cells}
      comboParams={{ divisionId, mnuId: MENU_ID }}
    />
  );
};
