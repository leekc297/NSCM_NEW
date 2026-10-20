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
  MEASURE_NAME_BG,
  MEASURE_BG,
  PIVOT_PREFIX,
  UNIT_QTY_SCALE,
} from '../global-psi-report.constants';
import {
  buildFixedColumns,
  buildPivotColumns,
  calendarColsFromRows,
  isPivotBinding,
  toCalendarCols,
  type CalendarCol,
} from '../utils/globalPsiReportColumns';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 3단(월/주/Qty) 헤더 렌더를 위한 헤더 행수. 월>주>Qty = 3행, MONTHLY(주 없음)면 2행이라 3으로 두면
//   빈 행은 병합으로 흡수된다(공용 DataGrid 병합). 고정 헤더 1행보다 크므로 명시.
const HEADER_ROW_HEIGHT = 24;

interface Props {
  // 활성 시트 데이터 행 (searchMode/searchLevel 로 선택된 1개 시트 — page 가 결정, design 01 R1~R3).
  rows: WijmoRowItem[];
  // 활성 시트 admin 고정 컬럼 (SCM_MST_SHEET_COLUMNS, design 03 §1). page 가 시트별로 선택해 전달.
  adminColumns: RawFlexGridColumnConfig[];
  // CALENDAR SP(GET_SHEET_CALENDAR_3SPAN) 반환행 — 동적 pivot 3단 헤더 원천. 0건이면 데이터 union 폴백.
  calendarRows: Record<string, unknown>[] | undefined;
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
//   read-only 리포트라 편집/셀콤보/병합관리자 없음 — 색(measure BG 8그룹·plan_start 헤더색·과거구간 회색)만
//   formatItem 으로 재현(design 03 §3-B/§2.4). Unit(Qty) 로컬 배율은 pivot 셀 표시값 나눗셈(design 02 §2.5).
export const GlobalPsiReportGrid = ({
  rows,
  adminColumns,
  calendarRows,
  bucket,
  planStartYyyymmdd,
  unitScaleIndex,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  onFocus,
}: Props) => {
  const fixedColumns = useMemo(() => buildFixedColumns(adminColumns), [adminColumns]);

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

      // measure 행 배경색 8그룹 (design 03 §3-B) — MEASURE_NAME 정확 일치 스위치. 전 컬럼 동일 배경.
      const bg = MEASURE_NAME_BG[s(row.MEASURE_NAME)];
      if (bg) ev.cell.style.backgroundColor = bg;

      // pivot 기간셀만 — 과거구간 회색 + Unit(Qty) 로컬 배율 표시(design 03 §3-B PAST / design 02 §2.5).
      if (!isPivotBinding(binding)) return;

      // 과거 기간칼럼(plan_start 이전 월) = 회색. WEEKLY inventory measure x W_..A = 은색(design 03 §3-B).
      const month = planStartMonthRef.current;
      if (binding.startsWith(PIVOT_PREFIX.MONTHLY)) {
        const ym = binding.slice(2, 8);
        if (month && ym < month) ev.cell.style.backgroundColor = MEASURE_BG.PAST;
      } else if (binding.startsWith(PIVOT_PREFIX.WEEKLY) && binding.slice(-1) === 'A') {
        // 재고성 measure(배경색 그룹 = INVENTORY) x W_..A 컬럼 = 과거재고 은색.
        if (MEASURE_NAME_BG[s(row.MEASURE_NAME)] === MEASURE_BG.INVENTORY) {
          ev.cell.style.backgroundColor = MEASURE_BG.PAST_INVENTORY;
        }
      }

      // Unit(Qty) 로컬 표시배율 — 원값을 배율로 나눠 표시(서버 재조회 없음, design 02 §2.5).
      //   배율 1(index0)이면 원 표시 유지. n0 포맷 기준으로 정수 표기.
      const scale = scaleRef.current;
      if (scale > 1) {
        const raw = row[binding];
        if (typeof raw === 'number' && Number.isFinite(raw)) {
          ev.cell.textContent = Math.round(raw / scale).toLocaleString();
        }
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
  }, [fixedColumns, pivotColumns, unitScaleIndex, planStartMonth]);

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
