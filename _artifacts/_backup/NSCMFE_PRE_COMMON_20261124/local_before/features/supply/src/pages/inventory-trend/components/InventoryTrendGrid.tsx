import {
  AllowMerging,
  type CellRange,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
  type GridPanel,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, type MutableRefObject } from 'react';

import dayjs from '@foundation/dayjs';
import { CustomMergeManager, ensureTopLeftMergeManager, GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  AMOUNT_FOCUS_MONTH_COLUMN,
  CHK_QTY_LIGHT_GREEN,
  CHK_QTY_RED,
  CHK_QTY_RED_TEXT_BY_VALUE,
  COL,
  DETAIL_COLUMNS,
  FOCUS_HEADER_COLOR,
  INV_STATUS_COLUMNS,
  INV_STATUS_GROUP_SUFFIX,
  LONG_TERM_ROW_BG,
  MERGE_COLUMNS,
  MONTH_HEADER_OFFSET,
  REPORT_TYPE_ENDING,
} from '../inventory-trend.constants';
import type { InventoryTrendRow } from '../inventory-trend.types';
import { useInventoryTrendStore } from '../useInventoryTrendStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<InventoryTrendRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: InventoryTrendRow[];
  // monthPicker 선택월(YYYYMM) — 6개월 롤링 헤더 relabel 기준(focus 월, cs:407~412 GetYYMM).
  month: string;
  // Detail 체크 — 상세 22컬럼 show/hide(chkDetail, cs:425~448). 기본 false=숨김.
  detail: boolean;
}

// YYYYMM → yy.MM (AS-IS GetYYMM(today, n)) — n 개월 오프셋 적용.
const toYyMm = (yyyymm: string, offset: number): string => {
  if (!/^\d{6}$/.test(yyyymm)) return '';
  return dayjs(`${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}-01`).add(offset, 'month').format('YY.MM');
};

const invStatusSet = new Set<string>(INV_STATUS_COLUMNS);

// 세로 병합 매니저 — AS-IS SmartColMerge 는 restricted(좌측 셀이 병합돼 있어야 자기도 병합) 라 공백 셀에서
//   체인이 끊기고 그 뒤 컬럼은 값이 같아도 병합하지 않는다(사용자 확인 2026-10-20 — Detail 캡처: GPLM Cell
//   Model 공백 뒤의 MDM Nick/class_Lv* 가 동일값이어도 미병합). 공용 CustomMergeManager 의 좌측 누적키는
//   공백을 '' 로 담아 통과시켜 공백 뒤 동일값을 과병합하므로, 셀 병합 판정 앞에 "좌측 보이는 병합컬럼 경로에
//   공백이 하나라도 있으면 이 셀부터 병합 안 함" 가드를 덧댄다. MERGE_COLUMNS(식별 5 + item 속성 6~22)가
//   병합 후보를 정하고, 이 매니저가 공백 경계를 동적으로 끊는다(GPLM 이 채워진 행은 그 뒤 공백까지 병합).
class InventoryTrendMergeManager extends CustomMergeManager<InventoryTrendRow> {
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
        if (!column?.visible || !column.allowMerging) continue;
        const value = panel.getCellData(currentRow, c, false);
        if (value === null || value === undefined || (typeof value === 'string' && value.trim() === ''))
          return null;
      }
    }
    return super.getMergedRange(panel, currentRow, currentCol);
  }
}

export const InventoryTrendGrid = ({ gridRef, gridFilterRef, data, month, detail }: Props) => {
  const staticColumns = useInventoryTrendStore(state => state.staticColumns);

  // 공백 경계에서 끊는 세로병합 매니저 주입 — DataGrid 내부 설정(기본 CustomMergeManager + TopLeft 래핑)이
  //   끝난 뒤 1회 호출되므로(initialized), 여기서 커스텀으로 교체하고 No/Status 코너 병합을 다시 씌운다.
  const handleInitialized = useCallback((grid: FlexGrid<InventoryTrendRow>) => {
    grid.mergeManager = new InventoryTrendMergeManager(grid);
    ensureTopLeftMergeManager(grid);
  }, []);

  // 동적 6개월 롤링 헤더(leaf row) — 선택월 기준 QTY_MONTH1..5(-5..-1) + FOCUS(0) yy.MM +
  //   LONG_TERM_STOCK_AMOUNT(focus 월, 그룹 row0='Amount(KRW)' 유지). 컬럼 add/remove 없음(design 03 §2).
  const focusLabel = useMemo(() => toYyMm(month, 0), [month]);
  const leafHeaderByBinding = useMemo(() => {
    const map = new Map<string, string>();
    for (const { binding, offset } of MONTH_HEADER_OFFSET) map.set(binding, toYyMm(month, offset));
    map.set(AMOUNT_FOCUS_MONTH_COLUMN, focusLabel);
    return map;
  }, [month, focusLabel]);

  // leaf 헤더 텍스트 relabel — 공용 DataGrid 는 columnGroups 재대입마다 헤더를 메타 라벨로 되돌리므로
  //   updatedLayout 마다 재적용(bod/ending-inventory 표준 처방). 변경 있을 때만 invalidate(루프 방지).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const apply = () => {
      let changed = false;
      for (const col of g.columns) {
        const label = col.binding ? leafHeaderByBinding.get(col.binding) : undefined;
        if (label !== undefined && col.header !== label) {
          col.header = label;
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
  }, [gridRef, staticColumns, data, leafHeaderByBinding]);

  // 컬럼별 병합(allowMerging) — 공용 DataGrid 는 allowMerging prop 이 켜지면 전 컬럼에 true 를 씌우므로,
  //   선두 식별 그룹(MERGE_COLUMNS)만 남기고 나머지는 updatedLayout 마다 false 로 되돌린다(bod 처방).
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

  // Detail 토글 — 상세 22컬럼 show/hide(AS-IS chkDetail SetLayout VisibleColumns, cs:425~448). 공용 DataGrid 가
  //   updatedLayout 마다 메타 visible 을 재적용하므로 그 뒤에 다시 씌운다(형제 ending-inventory 동형). 명시 컬럼만
  //   건드리고 나머지는 메타 visible 유지. 변경 있을 때만 invalidate(루프 방지).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const detailSet = new Set<string>(DETAIL_COLUMNS);
    const apply = () => {
      let changed = false;
      for (const col of g.columns) {
        if (!col.binding || !detailSet.has(col.binding)) continue;
        if (col.visible !== detail) {
          col.visible = detail;
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
  }, [gridRef, staticColumns, data, detail]);

  // 헤더 강조/그룹 relabel(formatItem, ColumnHeader) — DataGrid 는 header prop 을 노출하지 않아 셀 DOM 에
  //   직접 세팅(forecast-price 선례). (a) QTY_MONTH_FOCUS leaf = Red + Bold(R3, cs:381~382).
  //   (b) INV_STATUS 그룹헤더(row0) = "{focus월} Inventory Status"(cs:834~843) — 메타 'Inventory Status' 를 덮어씀.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (s: FlexGrid<InventoryTrendRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.ColumnHeader) return;
      const binding = s.columns[e.col]?.binding ?? '';
      const leafRow = s.columnHeaders.rows.length - 1;
      // focus 월 leaf 헤더 강조
      if (binding === COL.QTY_MONTH_FOCUS && e.row === leafRow) {
        e.cell.style.color = FOCUS_HEADER_COLOR;
        e.cell.style.fontWeight = 'bold';
        return;
      }
      // INV_STATUS 그룹헤더(row0) — 선택월 접두 relabel
      if (e.row === 0 && invStatusSet.has(binding)) {
        const label = `${focusLabel}${INV_STATUS_GROUP_SUFFIX}`;
        if (e.cell.textContent !== label) e.cell.textContent = label;
      }
    };
    g.formatItem.addHandler(handler);
    g.invalidate();
    return () => g.formatItem.removeHandler(handler);
  }, [gridRef, data, focusLabel]);

  // 조건부 셀 포맷 — DataGrid 는 formatItem prop 을 노출하지 않아 셀 DOM 에 직접 세팅(bod/ending-inventory
  //   선례). 셀 DOM 재사용 대비 미해당 시 반드시 '' 로 해제한다.
  //     R1(cs:454~469 SetBackColor): LongTerm 행(REPORT_TYPE≠'Ending') 배경 음영을 iColFocus=REPORT_TYPE
  //       부터 iColMax(마지막 컬럼)까지만 칠한다 — 좌측 식별/item 속성 컬럼은 흰색(사용자 확인 2026-10-20).
  //       Ending 행은 continue 로 제외. 음영색은 AS-IS 오버로드 버그로 폼기본색이나 TO-BE 는 #f2f2f2(04 유지확정).
  //     R2(cs:498~546): hidden CHK_QTY 값(40/30/20/10)에 따라 INV_STATUS 4컬럼 글자 Red(+40 은 배경 LightGreen).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (s: FlexGrid<InventoryTrendRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding;
      if (!binding) return;
      const dataItem = GridUtils.getRow(s, e.row) as WijmoRowItem | undefined;
      if (!dataItem) return;

      // R1 — LongTerm 행 배경 음영. AS-IS 는 REPORT_TYPE 컬럼부터 우측만 음영(좌측 식별/item 속성은 흰색).
      const rtIndex = s.columns.getColumn(COL.REPORT_TYPE)?.index ?? Infinity;
      const isLongTerm = String(dataItem[COL.REPORT_TYPE] ?? '') !== REPORT_TYPE_ENDING;
      let bg = isLongTerm && e.col >= rtIndex ? LONG_TERM_ROW_BG : '';
      let fg = '';

      // R2 — CHK_QTY 조건포맷(INV_STATUS 컬럼 한정). 40 은 배경 LightGreen 우선.
      if (invStatusSet.has(binding)) {
        const chk = String(dataItem[COL.CHK_QTY] ?? '');
        const redCols = CHK_QTY_RED_TEXT_BY_VALUE[chk];
        if (redCols?.includes(binding)) fg = CHK_QTY_RED;
        if (chk === '40') bg = CHK_QTY_LIGHT_GREEN;
      }

      e.cell.style.backgroundColor = bg;
      e.cell.style.color = fg;
    };
    g.formatItem.addHandler(handler);
    g.invalidate();
    return () => g.formatItem.removeHandler(handler);
  }, [gridRef, data]);

  return (
    <DataGrid<InventoryTrendRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      initialized={handleInitialized}
      itemsSource={data}
      staticColumns={staticColumns}
      // 읽기전용 Report — AS-IS Save NO-OP(cs:248~249)·Edit 실효0(MEMO 부재)·조회직후 전컬럼 LockColumn(cs:320).
      //   그리드 레벨 isReadOnly 로 셀 편집 차단 + CRUD status rowHeader 제거(DataGrid 기본은 편집가능).
      isReadOnly
      // 전 컬럼 읽기전용 Report — 편집셀 없음(LockColumn cs:320, staticColumns INPUT_TP_CD 전건 'S').
      // SmartColMerge(cs:325, 헤더 cs:192) → All 로 데이터 셀 + 컬럼 헤더 병합.
      //   데이터 셀 병합은 per-column allowMerging(위 effect)이 MERGE_COLUMNS 선두만 남기고,
      //   헤더 병합은 그리드 레벨 플래그만 보므로(mergeManager _getColumnHeaderMergedRange) 단독 컬럼
      //   2단 헤더가 세로 병합된다. Cells 만 주면 헤더 병합이 꺼져 단독 컬럼 라벨이 2줄로 중복 노출됨.
      allowMerging={AllowMerging.All}
    />
  );
};
