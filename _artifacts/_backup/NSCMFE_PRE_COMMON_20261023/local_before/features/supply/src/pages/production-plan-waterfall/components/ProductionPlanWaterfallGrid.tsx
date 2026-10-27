import type { FlexGrid, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import {
  formatByNotation,
  HEADER_COLORS,
  isEeDivision,
  MENU_ID,
  PAST_ACTUAL_BG,
  PERIOD_COLUMN_REGEX,
  quoteComboParam,
  SHEETS,
  VERSION_CODE_LENGTH,
} from '../production-plan-waterfall.constants';
import { useProductionPlanWaterfallStore } from '../useProductionPlanWaterfallStore';
import {
  buildDynColMetas,
  buildDynamicColumns,
  buildStaticColumns,
  dynKeySig,
  periodScaleOf,
  splitTitleRows,
  type DynColMeta,
  type WaterfallTitleRow,
} from '../utils/waterfall.columns';
import { WaterfallMergeManager } from '../utils/waterfall.merge';
import { baseVisibleOf, dayOf, dynKindOf } from '../utils/waterfall.periods';

// #93 다단 헤더 총 높이 48px 표준(demand-plan-waterfall / mkt-fcst-comparison 동일).
const HEADER_TOTAL_HEIGHT = 48;

// 셀 값 → 문자열 (객체가 오면 빈 문자열 — 기본 stringify '[object Object]' 방지). NOTATION 판정용.
const cellText = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

interface ProductionPlanWaterfallGridProps {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: Record<string, string | number>[];
  tabId: string;
}

export const ProductionPlanWaterfallGrid = ({
  gridRef,
  gridFilterRef,
  data,
  tabId,
}: ProductionPlanWaterfallGridProps) => {
  const filters = useProductionPlanWaterfallStore(state => state.filters);
  const searchParams = useProductionPlanWaterfallStore(state => state.searchParams);
  const metaColumns = useProductionPlanWaterfallStore(state => state.staticColumns[SHEETS.MAIN]);

  const bucket = searchParams.bucket;
  const chkSum = searchParams.chkSum;
  const isEe = isEeDivision(searchParams.divisionId);

  // 셀 콤보 파라미터 — 메타 CMBO 토큰(@mnuId). 셀 콤보 0건이나 공용 규약대로 전달.
  const comboParams = useMemo(
    () => ({ mnuId: quoteComboParam(MENU_ID) }),
    []
  );

  // 기간칼럼 헤더(캘린더 3span) — 활성 시 enabled.
  const { data: titleData } = useTabProcQuery<MENU_ID, SHEETS.TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.TITLE,
    tabId,
    filters: filters[SHEETS.TITLE],
    enabled: !!filters[SHEETS.TITLE],
  });

  const titleRows = useMemo<WaterfallTitleRow[]>(
    () => (titleData?.o_rc1 ?? []) as WaterfallTitleRow[],
    [titleData?.o_rc1]
  );

  const { staticRows, periodRows } = useMemo(() => splitTitleRows(titleRows), [titleRows]);

  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => buildStaticColumns({ staticRows, metaColumns, isEe }),
    [staticRows, metaColumns, isEe]
  );

  const dynMetas = useMemo<DynColMeta[]>(() => buildDynColMetas(periodRows), [periodRows]);
  const dynSig = useMemo(() => dynKeySig(dynMetas), [dynMetas]);
  const dynMetasRef = useRef(dynMetas);
  dynMetasRef.current = dynMetas;
  const scale = useMemo(() => periodScaleOf(periodRows), [periodRows]);

  const headerRowHeight = dynMetas.length === 0 ? HEADER_TOTAL_HEIGHT : HEADER_TOTAL_HEIGHT / 3;

  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(
    () => buildDynamicColumns({ metas: dynMetasRef.current, bucket, chkSum, scale }),
    // dynSig 가 컬럼 목록 동일성 판정 (metas 배열 참조는 조회마다 바뀐다)
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [dynSig, bucket, chkSum, scale]
  );

  const dynBindings = useMemo(() => dynMetas.map(m => m.binding), [dynMetas]);

  // 헤더 강조 — 주말색(토/일) + 과거실적 음영(R11) 기준 계획시작일. (AS-IS 에 당기 green 강조 없음 — G10 제거)
  const dayCodeOf = useMemo(() => {
    const map = new Map<string, string>();
    dynMetas.forEach(m => map.set(m.binding, m.dayCode));
    return map;
  }, [dynMetas]);
  // 과거실적 음영: version_no(PP_W_YYYYMMDD) 뒤 8자 = 계획시작일. from < 계획시작 → (계획시작-1)까지 D_ 회색.
  const planStart = useMemo<Date | null>(() => {
    const v = searchParams.versionNos[0] ?? '';
    if (v.length < VERSION_CODE_LENGTH) return null;
    const ymd = v.slice(-8);
    const y = Number(ymd.slice(0, 4));
    const m = Number(ymd.slice(4, 6));
    const d = Number(ymd.slice(6, 8));
    if (!y || !m || !d) return null;
    return new Date(y, m - 1, d);
  }, [searchParams.versionNos]);

  // ── 버킷·Sum 토글 + 헤더 더블클릭 드릴(R14, hook #103) ──
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  // 드릴 오버라이드 리셋 — bucket 변경·새 조회(dynamicColumns 재생성) 시에만 초기화한다. SUM 토글(chkSum)은
  //   드릴 상태를 보존한다(자매 SCP0025 ShipmentPlanFixGrid 동형 — Monthly 에서 드릴 펼친 뒤 Sum 체크해도
  //   접히지 않도록 chkSum 을 리셋 트리거에서 제외). 종전엔 아래 applyDynVisibility effect 안에서 clear 를
  //   호출했는데 그 effect deps 에 chkSum 이 있어 SUM 클릭마다 드릴이 함께 풀리는 동작 차이가 있었다.
  useEffect(() => {
    drillVisRef.current.clear();
  }, [bucket, dynamicColumns]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const dynSet = new Set(dynBindings);
    const kindByBinding = new Map(dynBindings.map(b => [b, dynKindOf(b)]));

    const applyDynVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i += 1) {
        const col = g.columns[i];
        const binding = col.binding ?? '';
        if (!dynSet.has(binding)) continue;
        const kind = kindByBinding.get(binding);
        const base = kind ? baseVisibleOf(bucket, chkSum, kind) : true;
        const want = drillVisRef.current.get(binding) ?? base;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };

    applyDynVisibilityRef.current = applyDynVisibility;
    g.updatedLayout.addHandler(applyDynVisibility);
    applyDynVisibility();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, dynBindings, bucket, chkSum, dynamicColumns]);

  // ── 헤더 높이 자급 (#93 총 48px — 보이는 tier 수로 나눠 전 헤더 row 에 강제) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const rows = g.columnHeaders?.rows;
      if (!rows || rows.length === 0) return;
      const targetHeight = HEADER_TOTAL_HEIGHT / rows.length;
      let changed = false;
      for (let i = 0; i < rows.length; i += 1) {
        if (Math.round(rows[i].height ?? rows.defaultSize) !== targetHeight) {
          rows[i].height = targetHeight;
          changed = true;
        }
      }
      if (Math.round(rows.defaultSize) !== targetHeight) {
        rows.defaultSize = targetHeight;
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
  }, [gridRef, staticColumns, dynamicColumns, headerRowHeight]);

  // ── 계층 병합 (AS-IS SmartColMerge + 헤더 스팬) — binding 키 기준 ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.mergeManager = new WaterfallMergeManager(staticColumns.map(column => column.colNm));
    g.invalidate(true);
  }, [gridRef, staticColumns, dynamicColumns]);

  // ── 스크롤 시 세로 병합 재계산 (AS-IS spdMain_TopChange → SmartColMerge 재호출) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const onScroll = () => g.invalidate();
    g.scrollPositionChanged.addHandler(onScroll);
    return () => {
      try {
        g.scrollPositionChanged?.removeHandler(onScroll);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, data]);

  // ── 헤더 더블클릭 드릴다운 (R14, AS-IS spdMain_CellDoubleClick → SetDblClickColumnShowHide) ──
  //   자매 SCP0025 ShipmentPlanFixGrid dblClickHandler 1:1. 종전엔 largeKeyOf(=yyyymm, 월)로 하위를
  //   모아 W_ 헤더를 더블클릭해도 그 "달 전체"의 D_ 가 펼쳐졌다(사용자 신고: Weekly 에서 1주 SUM
  //   더블클릭 시 다른 주까지 전부 펼쳐짐). 월 키 매칭 대신 표시순서(g.columns)를 걸어 클릭한 헤더의
  //   구간(다음 동급/상위 경계 전까지)만 토글해 클릭한 주/월로 스코프를 좁힌다.
  //     M_ 헤더 = 그 달 구간(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기(hideOnly) /
  //     W_ 헤더 = 그 주 구간(다음 W_/M_ 전까지) D_ 토글.
  useEffect(() => {
    const g = gridRef.current;
    if (!g?.hostElement) return;
    const host = g.hostElement;
    const onDblClick = (ev: MouseEvent) => {
      const hit = g.hitTest(ev);
      if (hit.cellType !== CellType.ColumnHeader) return;
      const clicked = g.columns[hit.col]?.binding ?? '';
      const clickedKind = dynKindOf(clicked);
      if (clickedKind !== 'M' && clickedKind !== 'W') return; // leaf(일)는 접을 하위 없음
      // 표시순서의 동적 바인딩만 추려 클릭 헤더 뒤 구간을 walk.
      const dyn: string[] = [];
      for (let i = 0; i < g.columns.length; i += 1) {
        const b = g.columns[i].binding ?? '';
        if (dynKindOf(b) !== null) dyn.push(b);
      }
      const idx = dyn.indexOf(clicked);
      if (idx < 0) return;
      const flip = (target: string, hideOnly: boolean) => {
        const col = g.columns.getColumn(target);
        if (!col) return;
        if (hideOnly && !col.visible) return; // M 드릴: 보이는 D_ 만 접는다(AS-IS 동일)
        drillVisRef.current.set(target, hideOnly ? false : !col.visible);
      };
      for (let i = idx + 1; i < dyn.length; i += 1) {
        const t = dyn[i];
        const tk = dynKindOf(t);
        if (clickedKind === 'M') {
          if (tk === 'M') break;
          if (tk === 'W') flip(t, false);
          else if (tk === 'D') flip(t, true);
        } else {
          if (tk === 'W' || tk === 'M') break;
          if (tk === 'D') flip(t, false);
        }
      }
      applyDynVisibilityRef.current?.();
    };
    host.addEventListener('dblclick', onDblClick);
    return () => host.removeEventListener('dblclick', onDblClick);
  }, [gridRef, dynBindings]);

  // ── 표시 규칙: 주말 헤더색(토/일) / 과거실적 음영(R11) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (_sender: FlexGrid, e: FormatItemEventArgs) => {
      const panel = e.panel;
      const col = panel.columns[e.col];
      if (!col) return;
      const binding = col.binding ?? '';

      if (panel.cellType === CellType.ColumnHeader) {
        const isLeafRow = e.row === panel.rows.length - 1;
        const dayCode = isLeafRow ? dayCodeOf.get(binding) : undefined;
        const weekend =
          dayCode === 'SAT'
            ? HEADER_COLORS.SATURDAY
            : dayCode === 'SUN'
              ? HEADER_COLORS.SUNDAY
              : '';
        e.cell.style.color = weekend;
        e.cell.style.fontWeight = '';
        return;
      }

      if (panel.cellType !== CellType.Cell) return;
      // 과거실적 음영(R11) — D_ 일자 컬럼이 계획시작일 이전이면 배경 회색
      if (!PERIOD_COLUMN_REGEX.test(binding)) {
        e.cell.style.backgroundColor = '';
        return;
      }
      const day = dayOf(binding);
      if (planStart && day && day < planStart) {
        e.cell.style.backgroundColor = PAST_ACTUAL_BG;
      } else {
        e.cell.style.backgroundColor = '';
      }
      // 행별 NOTATION 포맷(R13/G4) — 균일 컬럼 format(scale=0)을 measure 행의 표시 소수자리로 덮어쓴다.
      //   SP 가 비율 measure 를 POINT/POINT3 로 내려주면 소수 표기가 살아난다(NOTATION 없으면 컬럼 format 유지).
      const item = panel.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      const notation = cellText(item?.NOTATION);
      if (notation) {
        const value = toGridNumber(panel.getCellData(e.row, e.col, false));
        if (value !== null) {
          const text = formatByNotation(value, notation);
          if (text !== null) e.cell.textContent = text;
        }
      }
    };
    g.formatItem.addHandler(handler);
    g.invalidate(true);
    return () => {
      try {
        g.formatItem.removeHandler(handler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, dayCodeOf, planStart]);

  // footer 합계행 없음 — AS-IS SCP0017 에 ColumnFooter/합계행 신호 0건(cs 전수 grep). 이질 measure(수량·
  //   비율·EOH)를 세로 합산하면 무의미 값이라 AS-IS 파리티로 제거(G12, iter-4). demand-plan-waterfall 이식 잔재.

  return (
    <DataGrid<Record<string, string | number>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      // 조회 전용 화면 — CUD 상태(CRUD_TYPE) 표시용 rowHeader 컬럼을 만들지 않는다.
      isReadOnly={true}
      itemsSource={data}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      autoGenerateColumns={false}
      // AS-IS SmartColMerge — 데이터 행 세로 병합 + 헤더 3단 그룹 병합(WaterfallMergeManager 로 교체).
      allowMerging={AllowMerging.All}
      comboParams={comboParams}
      headerRowHeight={headerRowHeight}
      excelFileName='ProductionPlanWaterfall'
    />
  );
};
