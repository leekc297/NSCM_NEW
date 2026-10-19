import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { type EditTracker, paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { PIVOT_PREFIX } from '../global-psi.constants';
import {
  buildFixedColumns,
  buildPivotColumns,
  calendarColsFromRows,
  isColVisibleForBucket,
  isPivotBinding,
  pivotKind,
  toCalendarCols,
  type CalendarCol,
} from '../utils/globalPsiColumns';
import { GlobalPsiMergeManager } from '../utils/globalPsiMerge';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 다단 헤더 총 높이 48px 표준(hook #93, shipment-working-day 표준). 월>주>일 3단이면 per-tier=16,
//   MONTHLY(주 없음) 2단이면 24. 높이는 아래 applyHeaderHeight effect 가 실제 렌더된 header row 수로
//   나눠 각 rows[i].height 까지 강제하는 단일 출처다 — headerRowHeight prop 은 쓰지 않는다(§3).
const HEADER_TOTAL_HEIGHT = 48;

// measure 라벨 컬럼 — MEASURE_COLOR 행배경 적용 시작 컬럼(design 03 §3 R4 "measure_label~끝").
//   주의: 그리드 binding 은 admin SCM_MST_SHEET_COLUMNS COLUMN_NAME 그대로이므로 대문자 'MEASURE_LABEL'
//   이다(응답 필드·admin colNm 둘 다 대문자, DB 실측). AS-IS 코드상수(DefMain.MEASURE_LABEL='measure_label')
//   의 소문자를 따르면 formatItem 의 binding 비교가 빗나가 Measure 라벨 열에 색이 안 입혀진다(사용자 신고).
const MEASURE_LABEL_BINDING = 'MEASURE_LABEL';
const MEASURE_COLOR_BINDING = 'MEASURE_COLOR';

// measure 세로축 컬럼(행라벨/색/정렬) — 계층 세로병합(fixedBindings) 대상에서 제외한다. 한 item×site
//   블록 안에서 measure 16행이 각기 다른 행이라 이들을 병합하면 블록이 한 셀로 뭉친다(design 03 §4.2).
const MEASURE_AXIS_BINDINGS = new Set([
  MEASURE_LABEL_BINDING,
  MEASURE_COLOR_BINDING,
  'MEASURE', // binding = admin colNm 대문자(위 MEASURE_LABEL 과 동일 사유)
  'MEASURE_ORDER_NO',
]);

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

  // SUM 토글(chkSum)·헤더 더블클릭 드릴은 컬럼 재생성 없이 imperative visible flip 으로 반영한다(아래
  //   applyPivotVisibility) — 스크롤/폭 보존 + 헤더 재레이아웃 깜빡임 제거. 그래서 pivotColumns 빌드 dep 에서
  //   chkSum 을 제외하고(calendarCols/bucket 구조 변화에만 재생성), 빌드 시점 초기 visible 만 chkSumRef 로
  //   최신값을 참조한다(자매 SCP0025 Shipment Plan Fix chkSumRef 패턴).
  const chkSumRef = useRef(chkSum);
  chkSumRef.current = chkSum;
  // 헤더 더블클릭 드릴 오버라이드(binding → visible). base(isColVisibleForBucket) 위에 우선 적용. bucket/조회 변경 시 리셋.
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyPivotVisibilityRef = useRef<(() => void) | null>(null);
  const pivotColumns = useMemo(
    () => buildPivotColumns(calendarCols, bucket, chkSumRef.current),
    [calendarCols, bucket]
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

      // 음수 = 빨간 글자 — AS-IS 프레임워크 NumberCellType.NegativeRed=true(SpreadInfo.cs:13823,
      //   SetReNumerCellType 로 전 수치 셀 공통). pivot 값 영역(D_/W_/M_)만 대상 — 고정 차원 컬럼은
      //   텍스트라 음수가 없다. paintNegativeText 는 비음수면 color 를 지워 MEASURE_COLOR 배경과 공존한다
      //   (글자색만 다루고 배경은 위에서 이미 설정). gridNegativeText 공통 헬퍼 사용.
      if (isPivotBinding(binding)) {
        paintNegativeText(ev.cell, toGridNumber(row[binding]));
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 병합 매니저 — 공용 매니저를 감싸 동적 M_/W_/D_ 헤더 병합(년월/주차 가로 · M_ SUM 세로)과 선행
    //   식별 컬럼 데이터셀 계층 세로병합(SmartColMerge)을 전담한다. 자매 SCP0025 Shipment Plan Fix 1:1 —
    //   값기반 공용 병합이 M_/W_ 의 'SUM' leaf 라벨을 가로로 뭉쳐 "Weekly SUM 헤더가 가로로 합쳐져 보이는"
    //   문제(사용자 신고 2026-10-07)를 교정. 정적 헤더·TopLeft 는 delegate 로 위임.
    //   instanceof 가드 — DataGrid 가 init 에서 mergeManager 를 재배선하므로 "내 타입이 아닐 때만" 감싼다.
    if (!(g.mergeManager instanceof GlobalPsiMergeManager)) {
      g.mergeManager = new GlobalPsiMergeManager(g.mergeManager);
    }
    const mergeManager = g.mergeManager as GlobalPsiMergeManager;

    // 계층 세로병합 키(fixedBindings) 갱신 — 동적(M_/W_/D_)·measure 세로축(행라벨/색/정렬)을 제외한 선행
    //   식별 컬럼(Division/Item/Site …)을 값이 같은 연속 행끼리 세로병합한다(AS-IS SmartColMerge).
    //   fixedBindings 는 매니저 필드라 대입해도 invalidate 가 없어 깜빡임과 무관하다(SCP0025 동일).
    const syncFixedBindings = () => {
      const fixed: string[] = [];
      g.columns.forEach(col => {
        const b = col.binding ?? '';
        if (!!b && !isPivotBinding(b) && !MEASURE_AXIS_BINDINGS.has(b)) fixed.push(b);
      });
      mergeManager.fixedBindings = fixed;
    };
    g.updatedLayout.addHandler(syncFixedBindings);
    syncFixedBindings();

    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.updatedLayout?.removeHandler(syncFixedBindings);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fixedColumns, pivotColumns]);

  // 동적 컬럼 visible 제어 — (a) SUM(chkSum)·bucket 기본 가시성 + (b) 헤더 더블클릭 드릴 오버라이드.
  //   컬럼을 재생성하지 않고 col.visible 만 flip 하므로 헤더 재레이아웃 깜빡임이 없다(자매 SCP0025 동형).
  //   DataGrid 의 columnGroups 재적용이 visible 을 덮을 수 있어 updatedLayout 마다 재적용하고, 바뀐 게 있을 때만 invalidate.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyPivotVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i += 1) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!isPivotBinding(b)) continue;
        // base(bucket×chkSum) 위에 드릴 오버라이드 우선(AS-IS SetSpreadColumn + SetDblClickColumnShowHide 통합).
        const base = isColVisibleForBucket(b, bucket, chkSum);
        const want = drillVisRef.current.get(b) ?? base;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    applyPivotVisibilityRef.current = applyPivotVisibility;
    g.updatedLayout.addHandler(applyPivotVisibility);
    applyPivotVisibility();

    // 헤더 더블클릭 드릴다운 (AS-IS SpdMain_CellDoubleClick → siMain.SetDblClickColumnShowHide,
    //   SCP0031.cs:816-818 / SpreadInfo.cs:13648-13695, 자매 SCP0025 ShipmentPlanFixGrid dblClickHandler 1:1):
    //   M_ 헤더 = 그 달 구간(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기 / W_ 헤더 = 그 주 구간(다음 W_/M_ 전까지)
    //   D_ 토글. 표시 순서(g.columns)의 동적 바인딩을 walk 한다. SUM(leaf 'SUM') 헤더 포함 M_/W_ 전부 반응.
    const dblClickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.ColumnHeader) return;
      const hb = g.columns[ht.col]?.binding ?? '';
      const hk = pivotKind(hb);
      if (hk !== 'M' && hk !== 'W') return;
      const dyn: string[] = [];
      for (let i = 0; i < g.columns.length; i += 1) {
        const b = g.columns[i].binding ?? '';
        if (isPivotBinding(b)) dyn.push(b);
      }
      const idx = dyn.indexOf(hb);
      if (idx < 0) return;
      const flip = (target: string, hideOnly: boolean) => {
        const col = g.getColumn(target);
        if (!col) return;
        if (hideOnly && !col.visible) return; // M 드릴: 보이는 D_ 만 접는다(AS-IS 동일)
        drillVisRef.current.set(target, hideOnly ? false : !col.visible);
      };
      for (let i = idx + 1; i < dyn.length; i += 1) {
        const t = dyn[i];
        const tk = pivotKind(t);
        if (hk === 'M') {
          if (tk === 'M') break;
          if (tk === 'W') flip(t, false);
          else if (tk === 'D') flip(t, true);
        } else {
          if (tk === 'W' || tk === 'M') break;
          if (tk === 'D') flip(t, false);
        }
      }
      applyPivotVisibilityRef.current?.();
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyPivotVisibility);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [bucket, chkSum, pivotColumns, gridRef]);

  // 드릴 오버라이드 리셋 — bucket 변경·새 조회(pivotColumns 재생성) 시 초기화한다. SUM 토글(chkSum)은 드릴을
  //   보존한다(SCP0025 동형 — 드릴 펼친 뒤 Sum 체크해도 접히지 않도록 chkSum 은 리셋 트리거에서 제외).
  useEffect(() => {
    drillVisRef.current.clear();
  }, [bucket, pivotColumns]);

  // 다단 헤더 총 높이 48px 강제(hook #93) — demand-plan-waterfall 표준 이식.
  //   공용 mapRawColumnsToWijmoColumns 가 정적 컬럼을 1단으로 판정해 각 헤더 row 에 height:48 을
  //   명시로 박는다. 명시 height 는 rows.defaultSize 를 무시하므로 defaultSize 만 맞춰선(기존 early-
  //   return) 행별 명시값 48 이 안 지워져 헤더가 그대로 높게 남는다. 각 row.height 를 실제 tier 수로
  //   나눈 target 과 대조해 다르면 전부 덮고 invalidate(true) 로 재배치한다. merge/format effect 보다
  //   뒤에 둔다(hook #93 §3-5).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const applyHeaderHeight = () => {
      const rows = g.columnHeaders?.rows;
      if (!rows || rows.length === 0) return;
      // 총 48px 를 "실제 렌더된 tier 수"로 나눈다(예측값 아님) — 검색조건 전이 중 빈 tier 가 남아
      //   예측 단수와 실제 단수가 어긋나면 48×단수 로 배로 커지는 것을 막는다.
      const target = HEADER_TOTAL_HEIGHT / rows.length;
      let changed = false;
      for (let i = 0; i < rows.length; i += 1) {
        if (Math.round(rows[i].height ?? rows.defaultSize) !== Math.round(target)) {
          rows[i].height = target;
          changed = true;
        }
      }
      if (Math.round(rows.defaultSize) !== Math.round(target)) {
        rows.defaultSize = target;
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
      // headerRowHeight prop 은 쓰지 않는다 — rows.defaultSize 만 세팅해서 정적 1단 컬럼의 명시
      //   height:48 잔여를 못 덮는다(hook #93 §3, shipment-working-day 표준). 총높이 48px 는 위
      //   applyHeaderHeight effect 가 각 rows[i].height 까지 강제해 단일 출처로 책임진다.
      autoGenerateColumns={false}
    />
  );
};
