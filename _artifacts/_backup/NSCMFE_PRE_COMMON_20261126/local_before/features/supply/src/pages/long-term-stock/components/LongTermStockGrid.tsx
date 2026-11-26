import {
  AllowMerging,
  type CellRange,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
  type GridPanel,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { CustomMergeManager, ensureTopLeftMergeManager } from '@foundation/utils';
import { DataGrid } from '@shared/components';

// 기존 import 주석 보존 (2026-10-22)
// import { COL, MEMO_EDITABLE_BG, MERGE_COLUMNS } from '../long-term-stock.constants';
import { COL, EXCEL_XLS_PAIRS, MEMO_EDITABLE_BG } from '../long-term-stock.constants';
import type { LongTermStockRow } from '../long-term-stock.types';
import { useLongTermStockStore } from '../useLongTermStockStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<LongTermStockRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: LongTermStockRow[];
  // Edit 버튼 토글 상태(page 소유) — true 면 MEMO 단일 컬럼만 편집 개시(AS-IS EditButton, cs:233~249).
  editable: boolean;
}

// AS-IS SmartColMerge(Restricted): 좌측에 병합 안 되는 셀(빈 값, MEMO)이 있으면 그 뒤 컬럼은 모두 분할
//   공용 누적키는 빈 값과 병합 제외 컬럼을 통과시키므로 그 앞에서 끊는다(inventory-trend 선례)
class LongTermStockMergeManager extends CustomMergeManager<LongTermStockRow> {
  override getMergedRange(
    panel: GridPanel,
    currentRow: number,
    currentCol: number
  ): CellRange | null {
    if (
      panel.cellType === CellType.Cell &&
      currentRow >= 0 &&
      currentRow < panel.rows.length &&
      currentCol >= 0 &&
      currentCol < panel.columns.length
    ) {
      for (let c = 0; c <= currentCol; c++) {
        const column = panel.columns[c];
        if (!column?.visible) continue;
        if (!column.allowMerging) return null;
        const value: unknown = panel.getCellData(currentRow, c, false);
        if (value === null || value === undefined || (typeof value === 'string' && value.trim() === ''))
          return null;
      }
    }
    return super.getMergedRange(panel, currentRow, currentCol);
  }
}

export const LongTermStockGrid = ({ gridRef, gridFilterRef, data, editable }: Props) => {
  const staticColumns = useLongTermStockStore(state => state.staticColumns);

  // 엑셀 고정밀 표시 — *_XLS 컬럼에 _excelFormat(명시 Excel 서식) 주입. 공용 excelDownload 변환기가
  //   숫자 셀 서식을 값타입(0/2자리)으로만 정하고 scale 을 무시하므로, formatItem 의 _excelFormat opt-in
  //   으로 scale 자릿수를 강제한다(SCP0084 한정 — 다른 화면은 _excelFormat 미주입이라 영향 없음).
  const columnsWithExcelFormat = useMemo(
    () =>
      staticColumns.map(column => {
        const pair = EXCEL_XLS_PAIRS.find(p => p.xls === column.colNm);
        return pair ? { ...column, _excelFormat: `#,##0.${'0'.repeat(pair.scale)}` } : column;
      }),
    [staticColumns]
  );

  // 분할 경계 병합 매니저로 교체 후 코너 병합 재적용
  const handleInitialized = useCallback((grid: FlexGrid<LongTermStockRow>) => {
    grid.mergeManager = new LongTermStockMergeManager(grid);
    ensureTopLeftMergeManager(grid);
  }, []);

  // beginningEdit/formatItem 클로저가 최신 editable 을 참조하도록 ref 로 보관(재등록 없이 최신값).
  const editableRef = useRef(editable);
  editableRef.current = editable;

  // 컬럼별 병합(allowMerging) — 공용 DataGrid 는 allowMerging prop 이 켜지면 전 컬럼에 true 를 씌우므로,
  //   선두 그룹 컬럼(MERGE_COLUMNS)만 남기고 나머지는 updatedLayout 마다 false 로 되돌린다(bod 처방).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    // 기존 로직 주석 보존 (2026-10-22) 시작
    // const apply = () => {
    //   for (const col of g.columns) {
    //     if (!col.binding) continue;
    //     col.allowMerging = MERGE_COLUMNS.has(col.binding);
    //   }
    // };
    // 기존 로직 주석 보존 (2026-10-22) 끝
    // AS-IS SmartColMerge 계단식 병합: 전 컬럼 대상, 좌측 누적값이 같을 때만 병합(CustomMergeManager)
    // MEMO 는 편집 컬럼이라 병합 제외(병합 블록 편집 시 여러 행이 함께 바뀌는 것 방지)
    const apply = () => {
      for (const col of g.columns) {
        if (!col.binding) continue;
        col.allowMerging = col.binding !== COL.MEMO;
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
      initialized={handleInitialized}
      itemsSource={data}
      staticColumns={columnsWithExcelFormat}
      // 다단 병합헤더(Exchange/KRW/Local)는 메타 LARGE/SMALL_CLASS_LABEL 구동(자동). SmartColMerge
      //   (cs:206·329) → Cells 로 켜 CustomMergeManager 가 선두 누적 동일값을 세로 병합(대상 컬럼
      //   선별은 위 updatedLayout effect). FIXED_FLAG=Y(ITEM_UOM) 틀고정도 메타 구동.
      allowMerging={AllowMerging.Cells}
    />
  );
};
