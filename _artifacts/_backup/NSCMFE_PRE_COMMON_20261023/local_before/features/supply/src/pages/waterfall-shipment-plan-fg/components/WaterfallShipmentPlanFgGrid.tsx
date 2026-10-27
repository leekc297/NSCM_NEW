import type { FlexGrid, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { useWaterfallShipmentPlanFgStore } from '../useWaterfallShipmentPlanFgStore';
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
import { derivePeriodSums } from '../utils/waterfall.derive';
import { WaterfallMergeManager } from '../utils/waterfall.merge';
import { baseVisibleOf, dynKindOf, isIsoWeek, largeKeyOf, rankOf } from '../utils/waterfall.periods';
import {
  BUCKET_TYPE,
  HEADER_COLORS,
  MENU_ID,
  quoteComboParam,
  SHEETS,
} from '../waterfall-shipment-plan-fg.constants';

// #93 다단 헤더 총 높이 48px 표준(production-plan-waterfall 동일).
const HEADER_TOTAL_HEIGHT = 48;

interface WaterfallShipmentPlanFgGridProps {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: Record<string, string | number>[];
  tabId: string;
}

export const WaterfallShipmentPlanFgGrid = ({
  gridRef,
  gridFilterRef,
  data,
  tabId,
}: WaterfallShipmentPlanFgGridProps) => {
  const filters = useWaterfallShipmentPlanFgStore(state => state.filters);
  const searchParams = useWaterfallShipmentPlanFgStore(state => state.searchParams);
  const metaColumns = useWaterfallShipmentPlanFgStore(state => state.staticColumns[SHEETS.MAIN]);

  const bucket = searchParams.bucket;
  const chkSum = searchParams.chkSum;

  // 셀 콤보 파라미터 — 메타 CMBO 토큰(@mnuId). 셀 콤보 0건이나 공용 규약대로 전달.
  const comboParams = useMemo(() => ({ mnuId: quoteComboParam(MENU_ID) }), []);

  // 기간칼럼 헤더(공용 캘린더 3span) — filters 세팅 후 enabled.
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
    () => buildStaticColumns({ staticRows, metaColumns }),
    [staticRows, metaColumns]
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

  // W_/M_ 파생 합산(R6~R8) — D_ 만 신뢰하고 FE 재합산(measure!=BALANCE=합, BALANCE=기간 마지막 D_).
  //   서버 plain SUM 을 덮어써 BALANCE 행을 교정(design 03 §2.2/§3). 기간 메타 없으면 원본 그대로.
  const gridData = useMemo(() => derivePeriodSums(data, dynMetas), [data, dynMetas]);

  // 헤더 주말색(토/일) 판정용 — binding → DAY_CODE.
  const dayCodeOf = useMemo(() => {
    const map = new Map<string, string>();
    dynMetas.forEach(m => map.set(m.binding, m.dayCode));
    return map;
  }, [dynMetas]);

  // ── 버킷·Sum 토글 + 헤더 더블클릭 드릴(R10, hook #103) ──
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
      let changed = false;
      for (let i = 0; i < g.columns.length; i += 1) {
        const col = g.columns[i];
        const binding = col.binding ?? '';
        if (!dynSet.has(binding)) continue;
        const kind = kindByBinding.get(binding);
        const base = kind ? baseVisibleOf(bucket, chkSum, kind, isIsoWeek(binding)) : true;
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

  // ── 계층 병합 (AS-IS SmartColMerge + 헤더 스팬) — binding 키 기준(KEY_IDX 그룹) ──
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

  // ── 헤더 더블클릭 드릴다운 (R10, AS-IS SpdMain_CellDoubleClick + WeeklyISO 가드 buttonGuard #1) ──
  //   상위(월/주) 헤더 더블클릭 = 그 그룹의 하위 rank 컬럼 접기/펼치기. WeeklyISO 면 무동작(주별만 표시).
  useEffect(() => {
    const g = gridRef.current;
    if (!g?.hostElement) return;
    const host = g.hostElement;
    const onDblClick = (ev: MouseEvent) => {
      if (bucket === BUCKET_TYPE.WEEKLY_ISO) return; // design 03 §2.4 buttonGuard #1
      const hit = g.hitTest(ev);
      if (hit.cellType !== CellType.ColumnHeader) return;
      const clicked = g.columns[hit.col]?.binding ?? '';
      const clickedKind = dynKindOf(clicked);
      const clickedRank = rankOf(clickedKind);
      if (clickedRank === null || clickedRank >= 2) return; // leaf(일)는 접을 하위 없음
      const groupKey = largeKeyOf(clicked);
      // 같은 월 그룹의 더 하위 rank 컬럼(현재 보이는지로 토글) 접기/펼치기
      const childBindings = dynBindings.filter(b => {
        const rk = rankOf(dynKindOf(b));
        return rk !== null && rk > clickedRank && largeKeyOf(b) === groupKey;
      });
      if (childBindings.length === 0) return;
      const anyVisible = childBindings.some(b => g.columns.getColumn(b)?.visible ?? false);
      childBindings.forEach(b => drillVisRef.current.set(b, !anyVisible));
      applyDynVisibilityRef.current?.();
    };
    host.addEventListener('dblclick', onDblClick);
    return () => host.removeEventListener('dblclick', onDblClick);
  }, [gridRef, dynBindings, bucket]);

  // ── 표시 규칙: 주말 헤더색(토=파랑/일=빨강, design 03 §3 R9) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (_sender: FlexGrid, e: FormatItemEventArgs) => {
      const panel = e.panel;
      if (panel.cellType !== CellType.ColumnHeader) return;
      const col = panel.columns[e.col];
      if (!col) return;
      const binding = col.binding ?? '';
      const isLeafRow = e.row === panel.rows.length - 1;
      const dayCode = isLeafRow ? dayCodeOf.get(binding) : undefined;
      const weekend =
        dayCode === 'SAT'
          ? HEADER_COLORS.SATURDAY
          : dayCode === 'SUN'
            ? HEADER_COLORS.SUNDAY
            : '';
      e.cell.style.color = weekend;
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
  }, [gridRef, dayCodeOf]);

  return (
    <DataGrid<Record<string, string | number>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      // 조회 전용 화면 — 전 컬럼 Lock(design 03 R1). CUD 상태(CRUD_TYPE) rowHeader 미생성.
      isReadOnly={true}
      itemsSource={gridData}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      autoGenerateColumns={false}
      // AS-IS SmartColMerge — 데이터 행 세로 병합 + 헤더 3단 그룹 병합(WaterfallMergeManager 로 교체).
      allowMerging={AllowMerging.All}
      comboParams={comboParams}
      headerRowHeight={headerRowHeight}
      excelFileName='WaterfallShipmentPlanFg'
    />
  );
};
