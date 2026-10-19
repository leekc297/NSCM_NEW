import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { PIVOT_PREFIX } from '../global-psi.constants';
import {
  buildFixedColumns,
  buildPivotColumns,
  calendarColsFromRows,
  isPivotBinding,
  toCalendarCols,
  type CalendarCol,
} from '../utils/globalPsiColumns';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 3단(월/주/일) 헤더 렌더 행높이. 월>주>일 = 3단. MONTHLY(주 없음)면 2단이라 병합으로 흡수. hook #93(48px≒24*2).
const HEADER_ROW_HEIGHT = 24;

// measure_label 컬럼 — MEASURE_COLOR 행배경 적용 시작 컬럼(design 03 §3 R4 "measure_label~끝").
const MEASURE_LABEL_BINDING = 'measure_label';
const MEASURE_COLOR_BINDING = 'MEASURE_COLOR';

// D_YYYYMMDD 바인딩에서 요일 판정(design 03 §3 R4). 0=일(빨강), 6=토(파랑). 로컬 Date 로 tz 무영향.
const weekdayOf = (binding: string): number | null => {
  if (!binding.startsWith(PIVOT_PREFIX.DAILY)) return null;
  const ymd = binding.slice(2, 10);
  if (ymd.length !== 8) return null;
  const y = Number(ymd.slice(0, 4));
  const m = Number(ymd.slice(4, 6));
  const d = Number(ymd.slice(6, 8));
  if (!y || !m || !d) return null;
  return new Date(y, m - 1, d).getDay();
};

// MEASURE_COLOR "r,g,b" → 유효 css color 또는 null(design 03 §3 R4 Set_MeasureColor). 공백/형식오류면 null.
const rgbOf = (raw: string): string | null => {
  const parts = raw.split(',').map(p => p.trim());
  if (parts.length !== 3) return null;
  if (!parts.every(p => /^\d{1,3}$/.test(p) && Number(p) <= 255)) return null;
  return `rgb(${parts[0]}, ${parts[1]}, ${parts[2]})`;
};

interface Props {
  // 그리드 데이터 행(메인 SP 반환 — 한 item×site 블록이 16 measure 세로 반복, design 03 §4.2).
  rows: Record<string, unknown>[];
  // 활성 admin 고정 컬럼(SCM_MST_SHEET_COLUMNS 19행, design 03 §1).
  adminColumns: RawFlexGridColumnConfig[];
  // CALENDAR SP(GET_SHEET_CALENDAR_3SPAN) 반환행 — 동적 pivot 3단 헤더 원천. 0건이면 데이터 union 폴백.
  calendarRows: Record<string, unknown>[] | undefined;
  // BucketType(DAILY/WEEKLY/MONTHLY) — D_/W_/M_ pivot 가시성 토글(design 03 §2.2).
  bucket: string;
  // chkSum — SUM 컬럼(주계·월계) 표시 토글(design 03 §2.2). 서버 재조회 없는 클라 전환.
  chkSum: boolean;
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
}

// AS-IS SCP0031_GlobalPSI spdMain — 고정 차원 컬럼(SCM_MST_SHEET_COLUMNS) + 서버측 동적 D_/W_/M_ pivot
//   (GET_SHEET_CALENDAR_3SPAN 3단 헤더). 순수 조회(read-only) — 편집/셀콤보 없음. 요일색(토=파랑/일=빨강)과
//   MEASURE_COLOR 행배경만 formatItem 으로 재현(design 03 §3 R4). 세로병합(SmartColMerge) = AllowMerging.All.
//   W_/M_ SUM 은 SP 직접 산출(클라 재집계 금지, design 03 §1-C/§4.2).
export const GlobalPsiGrid = ({
  rows,
  adminColumns,
  calendarRows,
  bucket,
  chkSum,
  gridRef,
  gridFilterRef,
  editTrackerRef,
}: Props) => {
  const fixedColumns = useMemo(() => buildFixedColumns(adminColumns), [adminColumns]);

  // CALENDAR 메타 우선, 0건이면 데이터 행 union 폴백(자매 폴백 규약 동일).
  const calendarCols = useMemo<CalendarCol[]>(() => {
    const fromSp = toCalendarCols(calendarRows);
    return fromSp.length > 0 ? fromSp : calendarColsFromRows(rows);
  }, [calendarRows, rows]);

  const pivotColumns = useMemo(
    () => buildPivotColumns(calendarCols, bucket, chkSum),
    [calendarCols, bucket, chkSum]
  );

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      const binding = ev.panel.columns[ev.col]?.binding ?? '';

      // 헤더 요일색(design 03 §3 R4) — D_ 일자 헤더가 토=파랑/일=빨강.
      if (ev.panel.cellType === CellType.ColumnHeader) {
        const wd = weekdayOf(binding);
        if (wd === 6) {
          ev.cell.style.color = '#1565c0'; // 토요일 파랑
        } else if (wd === 0) {
          ev.cell.style.color = '#d32f2f'; // 일요일 빨강
        }
        return;
      }

      if (ev.panel.cellType !== CellType.Cell) return;
      const row = ev.panel.rows[ev.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;

      // MEASURE_COLOR("r,g,b") 행 배경색(design 03 §3 R4) — measure_label 열부터 끝(값 영역)까지 적용.
      //   앞쪽 차원 컬럼(세로 병합)은 색을 입히지 않아 병합 시각을 유지(AS-IS Set_MeasureColor 시작점 재현).
      const color = rgbOf(s(row[MEASURE_COLOR_BINDING]));
      if (color && (binding === MEASURE_LABEL_BINDING || isPivotBinding(binding))) {
        ev.cell.style.backgroundColor = color;
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
  }, [fixedColumns, pivotColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      isReadOnly
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={fixedColumns}
      dynamicColumns={pivotColumns}
      allowMerging={AllowMerging.All}
      headerRowHeight={HEADER_ROW_HEIGHT}
    />
  );
};
