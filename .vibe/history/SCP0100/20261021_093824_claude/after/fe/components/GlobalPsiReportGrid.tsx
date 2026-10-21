import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  MEASURE_GROUP_BORDER_TOP,
  MEASURE_NAME_BG,
  MEASURE_BG,
  NEGATIVE_FORE,
  PAST_INVENTORY_MEASURES,
  PIVOT_PREFIX,
  UNIT_QTY_SCALE,
} from '../global-psi-report.constants';
import {
  applySearchLevelLayout,
  buildFixedColumns,
  buildPivotColumns,
  calendarColsFromRows,
  isPivotBinding,
  planStartWeekBinding,
  toCalendarCols,
  type CalendarCol,
} from '../utils/globalPsiReportColumns';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 3단(월/주/Qty) 헤더 렌더를 위한 헤더 행수. 월>주>Qty = 3행, MONTHLY(주 없음)면 2행이라 3으로 두면
//   빈 행은 병합으로 흡수된다(공용 DataGrid 병합). 고정 헤더 1행보다 크므로 명시.
const HEADER_ROW_HEIGHT = 24;

// measure 배경 시작 열 기준 — AS-IS SetBackColor colMeasureSet = MEASURE_UI 열 - 2(.cs:854-856).
const MEASURE_UI_BINDING = 'MEASURE_UI';
const MEASURE_GROUP_BINDING = 'MEASURE_GROUP';

interface Props {
  // 활성 시트 데이터 행 (searchMode/searchLevel 로 선택된 1개 시트 — page 가 결정, design 01 R1~R3).
  rows: WijmoRowItem[];
  // 활성 시트 admin 고정 컬럼 (SCM_MST_SHEET_COLUMNS, design 03 §1). page 가 시트별로 선택해 전달.
  adminColumns: RawFlexGridColumnConfig[];
  // CALENDAR SP(GET_SHEET_CALENDAR_3SPAN) 반환행 — 동적 pivot 3단 헤더 원천. 0건이면 데이터 union 폴백.
  calendarRows: Record<string, unknown>[] | undefined;
  // Search Level 콤보값 + Detail 여부 — SetLayout(.cs:1490-1542) Product Level 표시 분기.
  searchLevel: string;
  isDetail: boolean;
  // BucketType(MONTHLY/WEEKLY) — M_/W_ pivot 가시성 토글(design 03 §2.5). 서버 재조회 없는 클라 전환.
  bucket: string;
  // Plan 시작일(YYYYMMDD) — 헤더 색: 해당 월(M_YYYYMM) Red / 주(W_..A·B) Blue(design 03 §2.4).
  planStartYyyymmdd: string;
  // Unit(Qty) 로컬 표시배율 index (design 02 §2.5). pivot 셀 값 = 원값 / UNIT_QTY_SCALE[index]. 서버 재조회 없음.
  unitScaleIndex: number;
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  onFocus: () => void;
}

// AS-IS GSCM.SCP.Forms.UIL/Report/SCP0100_Global_PSI_Report spdDetail/spdSearchLevel/spdSearchLevelDetail —
//   고정 차원 컬럼(SCM_MST_SHEET_COLUMNS 메타) + 서버측 동적 M_/W_ PIVOT(GET_SHEET_CALENDAR_3SPAN 3단 헤더).
//   read-only 리포트라 편집/셀콤보/병합관리자 없음 — SetBackColor(.cs:819-1081) 표현(measure 배경·그룹 경계선·
//   과거구간 회색·과거재고 은색)·숫자 음수 빨간색·plan_start 헤더색을 formatItem 으로 재현. Unit(Qty) 로컬 배율은
//   pivot 셀 표시값 나눗셈(design 02 §2.5).
export const GlobalPsiReportGrid = ({
  rows,
  adminColumns,
  calendarRows,
  searchLevel,
  isDetail,
  bucket,
  planStartYyyymmdd,
  unitScaleIndex,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  onFocus,
}: Props) => {
  const fixedColumns = useMemo(
    () => applySearchLevelLayout(buildFixedColumns(adminColumns), searchLevel, isDetail),
    [adminColumns, searchLevel, isDetail]
  );

  // CALENDAR 메타 우선, 0건이면 데이터 행 union 폴백(design 03 §2 mkt-fcst 폴백 규약).
  const calendarCols = useMemo<CalendarCol[]>(() => {
    const fromSp = toCalendarCols(calendarRows);
    return fromSp.length > 0 ? fromSp : calendarColsFromRows(rows);
  }, [calendarRows, rows]);

  const pivotColumns = useMemo(
    () => buildPivotColumns(calendarCols, bucket),
    [calendarCols, bucket]
  );

  // 색/배율 핸들러가 최신값을 stale 없이 참조 (핸들러는 mount 후 등록).
  const planStartMonth = planStartYyyymmdd ? planStartYyyymmdd.slice(0, 6) : '';
  const planStartMonthRef = useRef(planStartMonth);
  planStartMonthRef.current = planStartMonth;
  // WEEKLY 과거구간 기준 = Plan 시작일이 속한 W_ 컬럼의 꼬리(YYYYWW[A|B]). 그보다 앞선 W_ 컬럼이 과거(.cs:998-1023).
  const planWeekTail = planStartWeekBinding(calendarCols, planStartYyyymmdd).slice(2);
  const planWeekTailRef = useRef(planWeekTail);
  planWeekTailRef.current = planWeekTail;
  const scaleRef = useRef(UNIT_QTY_SCALE[unitScaleIndex] ?? 1);
  scaleRef.current = UNIT_QTY_SCALE[unitScaleIndex] ?? 1;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      const binding = ev.panel.columns[ev.col]?.binding ?? '';

      // 헤더 색(design 03 §2.4) — 월(M_YYYYMM)이 plan_start 월이면 Red / 주(W_..A·B) 헤더면 Blue.
      //   ColumnHeader 패널의 어느 단(row)이든 자기 binding 접두로 판정한다(그룹 헤더도 leaf binding 상속).
      if (ev.panel.cellType === CellType.ColumnHeader) {
        if (!isPivotBinding(binding)) return;
        const month = planStartMonthRef.current;
        if (
          month &&
          binding.startsWith(PIVOT_PREFIX.MONTHLY) &&
          binding.slice(2, 8) === month
        ) {
          ev.cell.style.color = '#d32f2f'; // plan_start 월 헤더 Red
          ev.cell.style.fontWeight = 'bold';
        } else if (binding.startsWith(PIVOT_PREFIX.WEEKLY)) {
          const tail = binding.slice(-1); // W_...A / W_...B
          if (tail === 'A' || tail === 'B') {
            ev.cell.style.color = '#1565c0'; // 주 A/B 헤더 Blue
            ev.cell.style.fontWeight = 'bold';
          }
        }
        return;
      }

      if (ev.panel.cellType !== CellType.Cell) return;
      const row = ev.panel.rows[ev.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const measureName = s(row.MEASURE_NAME);

      // Measure Group 이 바뀌는 행 = 상단 DarkGray 경계선(.cs:877-904·947-954, 전 컬럼). 첫 행 포함.
      const prev = ev.panel.rows[ev.row - 1]?.dataItem as Record<string, unknown> | undefined;
      ev.cell.style.borderTop =
        !prev || s(prev[MEASURE_GROUP_BINDING]) !== s(row[MEASURE_GROUP_BINDING])
          ? MEASURE_GROUP_BORDER_TOP
          : '';

      // measure 행 배경색 (.cs:922-940) — MEASURE_NAME 정확 일치 스위치. 적용 열 = MEASURE_UI 열 - 2 부터 끝까지
      //   (colMeasureSet .cs:856). MEASURE_UI 컬럼이 메타에 없으면 AS-IS 열 기준을 잡을 수 없어 전 컬럼에 칠한다.
      const bg = MEASURE_NAME_BG[measureName];
      if (bg) {
        const measureUiCol = ev.panel.columns.indexOf(MEASURE_UI_BINDING);
        if (measureUiCol < 0 || ev.col >= measureUiCol - 2) ev.cell.style.backgroundColor = bg;
      }

      // pivot 기간셀만 — 과거구간 회색 + 음수 빨간색 + Unit(Qty) 로컬 배율 표시(design 02 §2.5).
      if (!isPivotBinding(binding)) return;

      // 과거 기간칼럼 = 회색(.cs:968-1023). MONTHLY: plan_start 월 이전 M_ / WEEKLY: plan_start 주 이전 W_.
      //   WEEKLY 과거 W_..A × 재고 measure 7종 = 은색(.cs:1026-1071 — case 목록 PAST_INVENTORY_MEASURES).
      const month = planStartMonthRef.current;
      const weekTail = planWeekTailRef.current;
      if (binding.startsWith(PIVOT_PREFIX.MONTHLY)) {
        const ym = binding.slice(2, 8);
        if (month && ym < month) ev.cell.style.backgroundColor = MEASURE_BG.PAST;
      } else if (binding.startsWith(PIVOT_PREFIX.WEEKLY) && weekTail && binding.slice(2) < weekTail) {
        ev.cell.style.backgroundColor =
          binding.endsWith('A') && PAST_INVENTORY_MEASURES.has(measureName)
            ? MEASURE_BG.PAST_INVENTORY
            : MEASURE_BG.PAST;
      }

      const raw = row[binding];
      // 숫자 셀 음수 = 빨간 글자(SetReNumerCellType NegativeRed=true, SpreadInfo.cs:13815).
      ev.cell.style.color = typeof raw === 'number' && raw < 0 ? NEGATIVE_FORE : '';

      // Unit(Qty) 로컬 표시배율 — 원값을 배율로 나눠 표시(서버 재조회 없음, design 02 §2.5).
      //   배율 1(index0)이면 원 표시 유지. 소수 0자리(DecimalPlaces=0) 정수 표기.
      const scale = scaleRef.current;
      if (scale > 1 && typeof raw === 'number' && Number.isFinite(raw)) {
        ev.cell.textContent = Math.round(raw / scale).toLocaleString();
      }
    };
    g.formatItem.addHandler(formatHandler);
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fixedColumns, pivotColumns, unitScaleIndex, planStartMonth, planWeekTail]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows}
      staticColumns={fixedColumns}
      dynamicColumns={pivotColumns}
      allowMerging={AllowMerging.All}
      headerRowHeight={HEADER_ROW_HEIGHT}
      gotFocus={onFocus}
    />
  );
};
