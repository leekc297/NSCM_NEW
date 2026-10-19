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
  GUBUN,
  GUBUN_META,
  HEADER_COLORS,
  MENU_ID,
  quoteComboParam,
  SHEETS,
  type Gubun,
} from '../demand-plan-waterfall.constants';
import { useDemandPlanWaterfallStore } from '../useDemandPlanWaterfallStore';
import {
  baseVisibleOf,
  buildDynColMetas,
  buildDynamicColumns,
  buildStaticColumns,
  dynKeySig,
  periodScaleOf,
  splitTitleRows,
  type DynColMeta,
  type WaterfallTitleRow,
} from '../utils/waterfall.columns';
import { walkHeaderDrill } from '../utils/waterfall.drill';
import { currentPeriodBindings } from '../utils/waterfall.headerColors';
import { WaterfallMergeManager } from '../utils/waterfall.merge';
import { dynKindOf } from '../utils/waterfall.periods';

// DMF0035 통합 Waterfall 그리드 — 공용 DataGrid(@shared) 기반 (2026-09-04 OLAP 제거).
//   메인 SP 커서는 wide(고정컬럼 + 기간컬럼)라 **unpivot 없이 그대로 바인딩**한다.
//   컬럼 메타 = TITLE SP(`*SpreadTitle`) — 정적 컬럼(행 축) + 3단 기간 컬럼 그룹.
//   AS-IS 대응: 3단 헤더 병합 / MEASURE 까지 좌측 고정 / footer SUM(SumIgnoreHidden) /
//     행별 NOTATION 포맷 / 버킷·Sum 컬럼 토글 / 헤더 더블클릭 드릴 / 당기 Green Bold · 주말색.
//   chkColor(실적구간 회색)는 사용자 결정(2026-09-04)으로 전 TYPE 미구현 — __asis-mapping__ 기록.

interface DemandPlanWaterfallGridProps {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  gubun: Gubun;
  data: Record<string, string | number>[];
  /** 메인 SP o_rc2 의 ISO_WEEK — 당주 헤더 강조 기준 (없으면 '') */
  isoWeek: string;
  tabId: string;
}

/** 셀 값 → 문자열 (객체가 오면 빈 문자열 — 기본 stringify '[object Object]' 방지) */
const cellText = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

/** #93 — 3단 헤더 총 48px (1단 48 / 2단 24 / 3단 16) */
const HEADER_ROW_HEIGHT = 16;

export const DemandPlanWaterfallGrid = ({
  gridRef,
  gridFilterRef,
  gubun,
  data,
  isoWeek,
  tabId,
}: DemandPlanWaterfallGridProps) => {
  const filters = useDemandPlanWaterfallStore(state => state.filters);
  const searchParams = useDemandPlanWaterfallStore(state => state.searchParams);
  const metaColumns = useDemandPlanWaterfallStore(state => state.staticColumns);
  const columnSettings = useDemandPlanWaterfallStore(state => state.columnSettings);

  const bucket = searchParams.bucket;
  const isSumChecked = searchParams.isSumChecked;

  // ⭐ [E20260904-COLMETA] 셀 콤보 파라미터 — 메타의 CMBO SQL 이 요구하는 토큰 (실측):
  //   'Measure'            → @mnuId      (PROGRAM_ID 기준으로 메저 목록을 뽑는다 → GUBUN별 종속 PROGRAM_ID)
  //   'DMF0051_BP_Measure' → @divisionId (BIZ 전용 콤보)
  //   미전달 시 BE 가 '' 로 치환해 0행 → 콤보 매핑이 비어 셀이 **코드로 표시**된다.
  const comboParams = useMemo(
    () => ({
      mnuId: quoteComboParam(GUBUN_META[gubun].programId),
      divisionId: quoteComboParam(searchParams.divisionId),
    }),
    [gubun, searchParams.divisionId]
  );

  // GUBUN별 TITLE 시트 3본 — 활성 GUBUN 만 enabled (disabled 쿼리는 유휴)
  const { data: mktTitle } = useTabProcQuery<MENU_ID, SHEETS.MKT_FCST_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.MKT_FCST_TITLE,
    tabId,
    filters: filters[SHEETS.MKT_FCST_TITLE],
    enabled: gubun === GUBUN.MKT_FCST && !!filters[SHEETS.MKT_FCST_TITLE],
  });
  const { data: salesTitle } = useTabProcQuery<MENU_ID, SHEETS.SALES_PLAN_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SALES_PLAN_TITLE,
    tabId,
    filters: filters[SHEETS.SALES_PLAN_TITLE],
    enabled: gubun === GUBUN.SALES_PLAN && !!filters[SHEETS.SALES_PLAN_TITLE],
  });
  const { data: bizTitle } = useTabProcQuery<MENU_ID, SHEETS.BIZ_PLAN_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.BIZ_PLAN_TITLE,
    tabId,
    filters: filters[SHEETS.BIZ_PLAN_TITLE],
    enabled: gubun === GUBUN.BIZ_PLAN && !!filters[SHEETS.BIZ_PLAN_TITLE],
  });

  const titleRows = useMemo<WaterfallTitleRow[]>(
    () =>
      ((gubun === GUBUN.MKT_FCST
        ? mktTitle?.o_rc1
        : gubun === GUBUN.SALES_PLAN
          ? salesTitle?.o_rc1
          : bizTitle?.o_rc1) ?? []) as WaterfallTitleRow[],
    [gubun, mktTitle?.o_rc1, salesTitle?.o_rc1, bizTitle?.o_rc1]
  );

  const { staticRows, periodRows } = useMemo(() => splitTitleRows(titleRows), [titleRows]);

  // ⚠ 컬럼 존재 판정에 조회 결과 키를 쓰지 않는다 — 첫 행이 NULL 인 컬럼은 응답 JSON 에서 키가 빠진다
  //   (실측 2026-09-04 SALES div40: TITLE 기간컬럼 19 vs 첫 행 기간키 2). 컬럼 인벤토리는 TITLE SP + 메타.
  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      buildStaticColumns({
        staticRows,
        settings: columnSettings[gubun],
        metaColumns,
      }),
    [staticRows, columnSettings, gubun, metaColumns]
  );

  const dynMetas = useMemo<DynColMeta[]>(
    () => buildDynColMetas(periodRows, gubun),
    [periodRows, gubun]
  );
  // 컬럼그룹 재생성 억제 — 내용이 같으면 참조를 유지한다(1,000+ 컬럼 재생성 = 헤더 높이 리셋·깜빡임)
  const dynSig = useMemo(() => dynKeySig(dynMetas), [dynMetas]);
  const dynMetasRef = useRef(dynMetas);
  dynMetasRef.current = dynMetas;
  const scale = useMemo(() => periodScaleOf(periodRows), [periodRows]);

  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(
    () =>
      buildDynamicColumns({
        metas: dynMetasRef.current,
        gubun,
        bucket,
        isSumChecked,
        scale,
      }),
    // dynSig 가 컬럼 목록의 동일성 판정 (metas 배열 참조는 조회마다 바뀐다)
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [dynSig, gubun, bucket, isSumChecked, scale]
  );

  const dynBindings = useMemo(() => dynMetas.map(m => m.binding), [dynMetas]);

  // 헤더 강조 대상 (당기 버킷 Green Bold / 주말색)
  const greenSet = useMemo(
    () => currentPeriodBindings({ gubun, dynBindings, isoWeek }),
    [gubun, dynBindings, isoWeek]
  );
  const dayCodeOf = useMemo(() => {
    const map = new Map<string, string>();
    dynMetas.forEach(m => map.set(m.binding, m.dayCode));
    return map;
  }, [dynMetas]);

  // ── 버킷·Sum 토글 + 헤더 드릴 (hook #103) ──
  //   config 의 초기 visible 과 동일한 base 규칙을 updatedLayout 마다 재적용하고,
  //   드릴 오버라이드(drillVisRef)만 그 위에 얹는다. 컬럼그룹 rebuild 없이 imperative flip.
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    // bucket/sum/조회(동적 메타) 변경 = AS-IS SetSpreadColumn 재실행 등가 — 드릴 상태 리셋
    drillVisRef.current.clear();
    const dynSet = new Set(dynBindings);
    const kindByBinding = new Map(dynBindings.map(b => [b, dynKindOf(b)]));

    const applyDynVisibility = () => {
      // 우클릭 Hide Column 으로 숨긴 컬럼은 공용 DataGrid 가 grid 인스턴스에 얹어 준다 — 숨김 유지
      const userHidden = (g as unknown as { _userHiddenColumns?: ReadonlySet<string> })
        ._userHiddenColumns;
      let changed = false;
      for (let i = 0; i < g.columns.length; i += 1) {
        const col = g.columns[i];
        const binding = col.binding ?? '';
        if (!dynSet.has(binding)) continue;
        if (userHidden?.has(binding)) {
          if (col.visible !== false) {
            col.visible = false;
            changed = true;
          }
          continue;
        }
        const kind = kindByBinding.get(binding);
        const base = kind ? baseVisibleOf(gubun, bucket, isSumChecked, kind) : true;
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
  }, [gridRef, dynBindings, gubun, bucket, isSumChecked, dynamicColumns]);

  // ── 헤더 높이 자급 (#93 총 48px = 3단 × 16) ──
  //   ⚠ 공용 `mapRawColumnsToWijmoColumns` 는 정적 컬럼을 1단(ONE_DEPTH)으로 판정해 `height: 48` 을 넣고,
  //   wijmo `_buildColumnGroups` 가 그 값을 **각 헤더 row 의 명시 height** 로 박는다. 명시 height 는
  //   `rows.defaultSize` 를 무시하므로 3단 헤더가 144px 로 벌어진다.
  //   공용 DataGrid 의 2026-08-28 정정본은 row 단위로 되돌려 주지만, **그 이전 세대(클라우드)에는 없다**
  //   (2026-09-04 클라우드 실사고 — 사내에서는 가려져 보이지 않았다). 화면에서 자급해 세대 차를 흡수한다.
  //   목표 높이면 즉시 빠져나오므로 wrapper 와 값이 같아 서로 덮어쓰며 루프를 돌지 않는다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const rows = g.columnHeaders?.rows;
      if (!rows || rows.length === 0) return;
      let changed = false;
      for (let i = 0; i < rows.length; i += 1) {
        if (Math.round(rows[i].height ?? rows.defaultSize) !== HEADER_ROW_HEIGHT) {
          rows[i].height = HEADER_ROW_HEIGHT;
          changed = true;
        }
      }
      if (Math.round(rows.defaultSize) !== HEADER_ROW_HEIGHT) {
        rows.defaultSize = HEADER_ROW_HEIGHT;
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
  }, [gridRef, staticColumns, dynamicColumns]);

  // ── 계층 병합 (AS-IS SmartColMerge + 헤더 스팬) — DMF0003 HierarchicalMergeManager 표준 이식 ──
  //   공용 DataGrid 가 기본 설치하는 CustomMergeManager 는 헤더를 **값 기준**으로 묶어서
  //   2·3단 라벨이 모두 'SUM' 인 합계 컬럼이 월 경계를 넘어 가로로 합쳐진다(2026-09-04 실측).
  //   화면 전용 매니저로 교체해 binding 키 기준으로 묶는다. 컬럼 구성이 바뀌면 재생성.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.mergeManager = new WaterfallMergeManager(
      gubun,
      staticColumns.map(column => column.colNm)
    );
    g.invalidate(true);
  }, [gridRef, gubun, staticColumns, dynamicColumns]);

  // ── 스크롤 시 세로 병합 재계산 (AS-IS spdMain_TopChange → SmartColMerge 재호출 1:1) ──
  //   공용 병합 매니저는 뷰포트 범위(panel.viewRange)로만 병합을 계산하므로, 스크롤 후 다시 그리지 않으면
  //   화면 밖에서 이어지던 블록이 끊겨 보인다.
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

  // ── 헤더 더블클릭 드릴다운 (AS-IS spdMain_CellDoubleClick e.ColumnHeader) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g?.hostElement) return;
    const host = g.hostElement;
    const onDblClick = (ev: MouseEvent) => {
      const hit = g.hitTest(ev);
      if (hit.cellType !== CellType.ColumnHeader) return;
      const clicked = g.columns[hit.col]?.binding ?? '';
      if (!clicked || !dynKindOf(clicked)) return;
      const isVisible = (binding: string): boolean =>
        g.columns.getColumn(binding)?.visible ?? false;
      const patch = walkHeaderDrill({ gubun, bucket, dynBindings, isVisible, clicked });
      if (patch.size === 0) return;
      patch.forEach((visible, binding) => drillVisRef.current.set(binding, visible));
      applyDynVisibilityRef.current?.();
    };
    host.addEventListener('dblclick', onDblClick);
    return () => host.removeEventListener('dblclick', onDblClick);
  }, [gridRef, gubun, bucket, dynBindings]);

  // ── 표시 규칙: 행별 NOTATION / 당기 Green Bold / 주말 헤더색 ──
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
        // AS-IS: 당기 버킷은 컬럼 헤더 전체가 Green Bold / 주말색은 leaf(3단) 행만
        if (greenSet.has(binding)) {
          e.cell.style.color = HEADER_COLORS.CURRENT;
          e.cell.style.fontWeight = 'bold';
          return;
        }
        const dayCode = isLeafRow ? dayCodeOf.get(binding) : undefined;
        const weekend =
          dayCode === 'SAT'
            ? HEADER_COLORS.SATURDAY
            : dayCode === 'SUN'
              ? HEADER_COLORS.SUNDAY
              : '';
        // 셀 재활용 대비 — 항상 명시적으로 되돌린다
        e.cell.style.color = weekend;
        e.cell.style.fontWeight = '';
        return;
      }

      if (panel.cellType !== CellType.Cell) return;
      if (!dynKindOf(binding)) return;
      const item = panel.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      const notation = cellText(item?.NOTATION);
      if (!notation) return;
      const value = toGridNumber(panel.getCellData(e.row, e.col, false));
      if (value === null) return;
      const text = formatByNotation(value, notation);
      if (text !== null) e.cell.textContent = text;
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
  }, [gridRef, greenSet, dayCodeOf]);

  return (
    <DataGrid<Record<string, string | number>>
      // GUBUN 전환 = binding 체계 자체가 바뀐다 — 인스턴스 교체로 컬럼폭/필터 잔재를 남기지 않는다
      key={gubun}
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      autoGenerateColumns={false}
      // ⭐ AS-IS `SmartColMerge`(0035 .cs:1152/1160) — 데이터 행의 **세로 병합**.
      //   공용 CustomMergeManager 가 좌측 누적 키(`_getMergeKey`)로 계층 병합하고 뷰포트 범위로 제한한다.
      //   정적 컬럼은 메타 변환 시 allowMerging 기본 true, 기간(동적) 컬럼은 `buildDynamicColumns` 에서
      //   false 로 두어 숫자 셀은 병합되지 않는다. All = 데이터 셀 + 컬럼헤더(3단 그룹) 둘 다 유지.
      allowMerging={AllowMerging.All}
      comboParams={comboParams}
      // AS-IS footer SUM (SumIgnoreHidden) — leaf 컬럼의 aggregate: Sum 을 공용 집계행이 표시
      useAggregationRow
      headerRowHeight={HEADER_ROW_HEIGHT}
      excelFileName='DemandPlanWaterfall'
    />
  );
};
