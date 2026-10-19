import {
  AllowMerging,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { COL, MEMO_EDITABLE_BG, MERGE_COLUMNS } from '../long-term-stock.constants';
import type { LongTermStockRow } from '../long-term-stock.types';
import { useLongTermStockStore } from '../useLongTermStockStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<LongTermStockRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: LongTermStockRow[];
  // Edit 버튼 토글 상태(page 소유) — true 면 MEMO 단일 컬럼만 편집 개시(AS-IS EditButton, cs:233~249).
  editable: boolean;
}

export const LongTermStockGrid = ({ gridRef, gridFilterRef, data, editable }: Props) => {
  const staticColumns = useLongTermStockStore(state => state.staticColumns);

  // beginningEdit/formatItem 클로저가 최신 editable 을 참조하도록 ref 로 보관(재등록 없이 최신값).
  const editableRef = useRef(editable);
  editableRef.current = editable;

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

  // MEMO 편집 개시 게이트 — 조회 직후 전 셀 읽기전용(메타 INPUT_TP_CD 전건 'S' → 공용 DataGrid 의
  //   setEditableColumns 가 beginningEdit 에서 전 셀 cancel). 여기 핸들러는 그 뒤에 등록되어, edit
  //   모드(editable)일 때 MEMO 셀만 cancel 을 되돌려 편집을 허용한다(AS-IS EditButton→LockRange
  //   MEMO 해제, W6/W7, hook #130 — 상수/좌표 이식 아니라 binding·상태 기반).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (s: FlexGrid<LongTermStockRow>, e: CellRangeEventArgs) => {
      if (e.panel?.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding;
      if (editableRef.current && binding === COL.MEMO) e.cancel = false;
    };
    g.beginningEdit.addHandler(handler);
    return () => g.beginningEdit.removeHandler(handler);
  }, [gridRef, data]);

  // 조건부 셀 배경색 — edit 모드일 때 MEMO 셀만 Yellow(hook #95 편집가능 표시). DataGrid 는
  //   formatItem prop 을 노출하지 않아 셀 DOM 에 직접 세팅한다(ending-inventory/bod 선례).
  //   셀 DOM 재사용 대비 미해당 시 반드시 '' 로 해제.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (s: FlexGrid<LongTermStockRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding;
      if (binding !== COL.MEMO) return;
      e.cell.style.backgroundColor = editableRef.current ? MEMO_EDITABLE_BG : '';
    };
    g.formatItem.addHandler(handler);
    g.invalidate();
    return () => g.formatItem.removeHandler(handler);
  }, [gridRef, data]);

  // editable 토글 시 그리드 재그림 — MEMO 셀 색(위 formatItem) 반영/해제.
  useEffect(() => {
    gridRef.current?.invalidate();
  }, [editable, gridRef]);

  return (
    <DataGrid<LongTermStockRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      // 다단 병합헤더(Exchange/KRW/Local)는 메타 LARGE/SMALL_CLASS_LABEL 구동(자동). SmartColMerge
      //   (cs:206·329) → Cells 로 켜 CustomMergeManager 가 선두 누적 동일값을 세로 병합(대상 컬럼
      //   선별은 위 updatedLayout effect). FIXED_FLAG=Y(ITEM_UOM) 틀고정도 메타 구동.
      allowMerging={AllowMerging.Cells}
    />
  );
};
