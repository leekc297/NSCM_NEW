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
import { paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  // CONDITIONAL_BG,
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
import { conditionalBgOf, GlobalPsiElecMergeManager } from '../utils/globalPsiElecMerge';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 헤더 총높이 고정(hook #93, UM-06) — 보이는 tier 수로 나눠 전 헤더 row 에 강제한다(아래 applyHeaderHeight).
//   1단 48 / 2단 24 / 3단 16. SP 캘린더면 월>주>(일|SUM) 3단, 폴백(데이터 union)이면 월>leaf 2단.
const HEADER_TOTAL_HEIGHT = 48;

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

  // 병합 매니저 래핑 표식 — grid 인스턴스당 1회.
  const mergeWrappedRef = useRef<FlexGridType | null>(null);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 색 있는 행(SUM/EOH/Package Plan)은 세로병합에서 분리.
    if (mergeWrappedRef.current !== g) {
      g.mergeManager = new GlobalPsiElecMergeManager(g.mergeManager);
      mergeWrappedRef.current = g;
    }

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

      // 조건부 배경(design 03 §3 R19~R21 + Package Plan) — col4~끝(값 영역) 적용.
      // if (ev.col >= CONDITIONAL_BG_START_COL) {
      //   const psi = s(row.PSI);
      //   const measure = s(row.MEASURE_NAME);
      //   if (psi === 'P' && measure === 'SUM') ev.cell.style.backgroundColor = CONDITIONAL_BG.P_SUM;
      //   else if (psi === 'S' && measure === 'SUM')
      //     ev.cell.style.backgroundColor = CONDITIONAL_BG.S_SUM;
      //   else if (psi === 'I' && measure === 'EOH')
      //     ev.cell.style.backgroundColor = CONDITIONAL_BG.I_EOH;
      // }
      if (ev.col >= CONDITIONAL_BG_START_COL) {
        const bg = conditionalBgOf(row);
        if (bg) ev.cell.style.backgroundColor = bg;
      }

      // 음수 값 빨간 글자(AS-IS AddNumColumn NumberCellType NegativeRed 재현, 예: EOH 음수). 숫자 셀만 —
      //   식별/Measure 등 문자 컬럼은 toGridNumber 가 0 을 돌려줘 자연히 제외. 정본 @foundation/utils
      //   paintNegativeText(Wijmo 셀 재사용 대비 비음수면 색 해제까지 담당).
      paintNegativeText(ev.cell, toGridNumber(row[binding]));

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

  // 헤더 높이 자급(hook #93 총 48px) — 형제 DemandPlanWaterfallGrid 동형. 공용 mapRawColumnsToWijmoColumns 가
  //   정적 컬럼을 1단(ONE_DEPTH)으로 보고 height:48 을 박아, pivot 으로 3단이 되면 48×3=144px 로 헤더가 벌어진다.
  //   예측값이 아니라 실제 렌더된 tier 수(columnHeaders.rows.length)로 48 을 나눠 전 헤더 row 에 강제한다
  //   (1단 48 / 2단 24 / 3단 16). updatedLayout 마다 재적용해 bucket·조회 전이 중의 잔여 tier 도 흡수.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const hdrRows = g.columnHeaders?.rows;
      if (!hdrRows || hdrRows.length === 0) return;
      const target = HEADER_TOTAL_HEIGHT / hdrRows.length;
      let changed = false;
      for (let i = 0; i < hdrRows.length; i += 1) {
        if (Math.round(hdrRows[i].height ?? hdrRows.defaultSize) !== target) {
          hdrRows[i].height = target;
          changed = true;
        }
      }
      if (Math.round(hdrRows.defaultSize) !== target) {
        hdrRows.defaultSize = target;
        changed = true;
      }
      if (changed) g.invalidate(true);
    };
    applyHeaderHeight();
    g.updatedLayout.addHandler(applyHeaderHeight);
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
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
      // 초기 예측값(pivot 있으면 3단 16, 없으면 1단 48). 실제 tier 수 보정은 applyHeaderHeight effect 가 담당.
      headerRowHeight={pivotColumns.length > 0 ? HEADER_TOTAL_HEIGHT / 3 : HEADER_TOTAL_HEIGHT}
      dblClick={onCellDblClick}
    />
  );
};
