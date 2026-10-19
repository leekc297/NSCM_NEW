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

import {
  CONDITIONAL_BG,
  CONDITIONAL_BG_START_COL,
  DECIMAL2_MEASURES,
  PIVOT_PREFIX,
} from '../global-psi-elec.constants';
import {
  buildFixedColumns,
  buildPivotColumns,
  calendarColsFromRows,
  isPivotBinding,
  toCalendarCols,
  type CalendarCol,
} from '../utils/globalPsiElecColumns';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 3단(월/주/일) 헤더 렌더 행높이. 월>주>일 = 3단. MONTHLY(주 없음)면 2단이라 병합으로 흡수. hook #93(48px≒24*2).
const HEADER_ROW_HEIGHT = 24;

const DECIMAL2 = new Set<string>(DECIMAL2_MEASURES);

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

interface Props {
  // 그리드 데이터 행(메인 SP 반환 — 빈 값 0 행은 SP 가 이미 DELETE, design 03 §4.1).
  rows: Record<string, unknown>[];
  // 활성 admin 고정 컬럼(SCM_MST_SHEET_COLUMNS 14행, design 03 §1).
  adminColumns: RawFlexGridColumnConfig[];
  // CALENDAR SP(GET_SHEET_CALENDAR_3SPAN) 반환행 — 동적 pivot 3단 헤더 원천. 0건이면 데이터 union 폴백.
  calendarRows: Record<string, unknown>[] | undefined;
  // BucketType(DAILY/WEEKLY/MONTHLY) — D_/W_/M_ pivot 가시성 토글(design 03 §2.2). 서버 재조회 없는 클라 전환.
  bucket: string;
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  // 셀 더블클릭(드릴다운 3중 가드 — design 03 §3.1). 페이지가 SCP0013 이동을 소유.
  onCellDblClick: (mouseEvent: MouseEvent) => void;
}

// AS-IS SCP0095_GlobalPSI_Elec spdMain — 고정 차원 컬럼(SCM_MST_SHEET_COLUMNS) + 서버측 동적 D_/W_/M_ pivot
//   (GET_SHEET_CALENDAR_3SPAN 3단 헤더). 순수 조회(read-only) — 편집/셀콤보 없음. 색(요일색·조건부 배경 3색)과
//   소수 2자리(Yield_A/E)만 formatItem 으로 재현(design 03 §3 R4/R19~21/R30). 세로병합(SmartColMerge) = AllowMerging.All.
export const GlobalPsiElecGrid = ({
  rows,
  adminColumns,
  calendarRows,
  bucket,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  onCellDblClick,
}: Props) => {
  const fixedColumns = useMemo(() => buildFixedColumns(adminColumns), [adminColumns]);

  // CALENDAR 메타 우선, 0건이면 데이터 행 union 폴백(global-psi-report 폴백 규약 동일).
  const calendarCols = useMemo<CalendarCol[]>(() => {
    const fromSp = toCalendarCols(calendarRows);
    return fromSp.length > 0 ? fromSp : calendarColsFromRows(rows);
  }, [calendarRows, rows]);

  const pivotColumns = useMemo(() => buildPivotColumns(calendarCols, bucket), [calendarCols, bucket]);

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

      // 조건부 배경 3색(design 03 §3 R19~R21) — col4~끝(값 영역) 적용. PSI × MEASURE_NAME 조합.
      if (ev.col >= CONDITIONAL_BG_START_COL) {
        const psi = s(row.PSI);
        const measure = s(row.MEASURE_NAME);
        if (psi === 'P' && measure === 'SUM') ev.cell.style.backgroundColor = CONDITIONAL_BG.P_SUM;
        else if (psi === 'S' && measure === 'SUM')
          ev.cell.style.backgroundColor = CONDITIONAL_BG.S_SUM;
        else if (psi === 'I' && measure === 'EOH')
          ev.cell.style.backgroundColor = CONDITIONAL_BG.I_EOH;
      }

      // Yield_A/Yield_E 행 기간셀 소수 2자리(design 03 §3.1 R30). 그 외 measure 는 정수(컬럼 format n0).
      if (isPivotBinding(binding) && DECIMAL2.has(s(row.MEASURE_NAME))) {
        const raw = row[binding];
        if (typeof raw === 'number' && Number.isFinite(raw)) {
          ev.cell.textContent = raw.toLocaleString(undefined, {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          });
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
      dblClick={onCellDblClick}
    />
  );
};
