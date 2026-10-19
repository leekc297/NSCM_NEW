import { Aggregate, Globalize } from '@mescius/wijmo';
import type { GridPanel } from '@mescius/wijmo.grid';
import {
  type FlexGrid,
  AllowMerging,
  CellRange,
  CellType,
  GroupRow,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { FlexGridColumnConfig } from '@foundation/models';
import { CustomMergeManager, toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  BUCKET_TYPE,
  DYN_RANK,
  FOOTER_FORMAT,
  kindOf,
  scaleOf,
  widthOf,
} from '../cust-fcst-waterfall.constants';
import type { SpreadTitleRow, WaterfallRow } from '../cust-fcst-waterfall.types';
import { useCustFcstWaterfallStore } from '../useCustFcstWaterfallStore';

// ⭐ DMF0053 메인 그리드 — AS-IS spdMain('CUST Fcst Waterfall' 단일 시트) 1:1 조회 전용.
//   동적 시간축 = P_DMF0053_GET_SPREAD_TITLE (월>주>일 3단 + SUM — DMF0040 패턴 이식) /
//   헤더 더블클릭 드릴다운(M_→W_→D_, CellDoubleClick L1160~1210) / footer 합계(InitSpreadFooterSum L414~431) /
//   SAT/SUN 헤더 글자색(L512~516) / QTY 표시 스케일(SetAmountCalculating L1731~1818 — 표시 사본).
//   실적 회색·Difference 축 없음 — AS-IS 에서 회색 로직 전부 주석(L811~903)·비교 버전 축 부재 (DMF0040 과의 차이).

/** 동적 컬럼 헤더 머지 키 (DMF0040 ComparisonHeaderMergeManager 계보) */
interface HeaderKey {
  ym: string;
  sub: string;
}

class WaterfallHeaderMergeManager extends CustomMergeManager<WaterfallRow> {
  constructor(
    grid: FlexGrid<WaterfallRow>,
    private readonly getKeys: () => Map<string, HeaderKey>,
    private readonly getOnlyWeekly: () => boolean
  ) {
    super(grid);
  }

  getMergedRange(panel: GridPanel, r: number, c: number): CellRange | null {
    if (panel.cellType !== CellType.ColumnHeader) return super.getMergedRange(panel, r, c);
    const keys = this.getKeys();
    const bindingAt = (i: number): string => panel.columns[i]?.binding ?? '';
    const b = bindingAt(c);
    if (!keys.has(b)) return super.getMergedRange(panel, r, c);
    // UM-09 — ONLY_WEEKLY 는 AS-IS SetSpreadHeader(.cs L439~471): span 없이 3행(월/주차/SUM)을 컬럼마다 반복.
    //   병합하면 주차:날짜 1:1 이 무너진다 (사용자 결정 2026-08-28 = AS-IS 3행 그대로).
    if (this.getOnlyWeekly()) return null;
    const leafRow = panel.rows.length - 1;
    if (b.startsWith('M_') && r >= 1) {
      return leafRow <= 1 ? null : new CellRange(1, c, leafRow, c);
    }
    if (r === leafRow) return null;
    const keyOf = (i: number): string => {
      const k = keys.get(bindingAt(i));
      if (!k) return '\0';
      return r === 0 ? k.ym : `${k.ym}|${k.sub}`;
    };
    const key = keyOf(c);
    let c1 = c;
    let c2 = c;
    while (c1 > 0 && keyOf(c1 - 1) === key) c1--;
    while (c2 < panel.columns.length - 1 && keyOf(c2 + 1) === key) c2++;
    return c1 === c2 ? null : new CellRange(r, c1, r, c2);
  }
}

interface DynColMeta {
  binding: string;
  kind: 'M' | 'W' | 'D';
  large: string;
  small: string;
  leaf: string;
  dayCode: string;
  sort: number;
  /** UM-04 — SP DATA_SCALE_NUMBER (소수 자릿수) */
  scale: number;
  /** UM-04 — SP COLUMN_WIDTH (px) */
  width: number;
}

interface CustFcstWaterfallGridProps {
  gridRef: MutableRefObject<FlexGrid<WaterfallRow> | undefined>;
  /** UM-07 — SubTitle Filter(F4)/필터 카운트가 보는 ref. DataGrid 까지 관통해야 산다 (미전달 = 조용한 no-op) */
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  data: WaterfallRow[];
  spreadTitle: SpreadTitleRow[];
}

export const CustFcstWaterfallGrid = ({
  gridRef,
  gridFilterRef,
  data,
  spreadTitle,
}: CustFcstWaterfallGridProps) => {
  const searchParams = useCustFcstWaterfallStore(state => state.searchParams);
  const staticColumns = useCustFcstWaterfallStore(state => state.staticColumns);

  const bucket = searchParams.bucket;
  const isOnlyWeekly = bucket === BUCKET_TYPE.ONLY_WEEKLY;

  // ── QTY 표시 스케일 — 원본 보존·표시 사본 변환 (AS-IS dsOrigianlCopy 복원식 파리티) ──
  const divisor = Number(searchParams.qty || '1') || 1;
  const gridRows = useMemo<WaterfallRow[]>(() => {
    if (divisor === 1) return data;
    return data.map(row => {
      const next: WaterfallRow = { ...row };
      for (const key of Object.keys(row)) {
        if (!kindOf(key)) continue;
        const num = toGridNumber(row[key]);
        if (num === null || num === 0) continue; // AS-IS: 0 값 skip (L1789)
        next[key] = Math.round((num / divisor) * 100) / 100; // AS-IS Math.Round(…, 2)
      }
      return next;
    });
  }, [data, divisor]);

  // ── 동적 컬럼 메타 (SPREAD_TITLE — B_ 접두는 SP 산출 제외·항상 숨김 규약 L499~502) ──
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    const titleRows = (spreadTitle ?? []).filter(r => !!kindOf(String(r.COLUMN_NAME ?? '')));
    if (titleRows.length > 0) {
      return titleRows
        .map<DynColMeta>(r => ({
          binding: String(r.COLUMN_NAME),
          kind: kindOf(String(r.COLUMN_NAME)) as DynColMeta['kind'],
          large: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
          small: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
          leaf: String(r.COLUMN_LABEL_NAME ?? ''),
          dayCode: String(r.DAY_CODE ?? ''),
          sort: Number(r.SORT_ORDER_NO ?? 0),
          scale: scaleOf(r.DATA_SCALE_NUMBER), // UM-04 — 메타 자릿수 (AS-IS SpreadInfo.cs L1433~1440)
          width: widthOf(r.COLUMN_WIDTH),
        }))
        .sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
    }
    // fallback — data row 키 union (DMF0040 패턴)
    if (!data || data.length === 0) return [];
    const set = new Set<string>();
    for (const r of data) for (const k of Object.keys(r)) if (kindOf(k)) set.add(k);
    return [...set].sort().map<DynColMeta>(b => ({
      binding: b,
      kind: kindOf(b) as DynColMeta['kind'],
      large: `${b.slice(2, 6)}-${b.slice(6, 8)}`,
      small: '',
      leaf: b.slice(8),
      dayCode: '',
      sort: 0,
      scale: scaleOf(''),
      width: widthOf(''),
    }));
  }, [spreadTitle, data]);

  // ── 활성 bucket / 요약(Sum 토글) / 드릴(헤더 더블클릭) 분류 (AS-IS SetSpreadColumn L1368~1438) ──
  const bucketPrefix = (isOnlyWeekly ? 'W' : bucket.trim().charAt(0).toUpperCase()) as 'M' | 'W' | 'D';
  const { hasDaily, summaryBindings, drillBindings } = useMemo(() => {
    const daily = dynColMetas.some(m => m.kind === 'D');
    const active = DYN_RANK[bucketPrefix] ?? DYN_RANK.M;
    return {
      hasDaily: daily,
      summaryBindings: dynColMetas.filter(m => DYN_RANK[m.kind] < active).map(m => m.binding),
      drillBindings: dynColMetas.filter(m => DYN_RANK[m.kind] > active).map(m => m.binding),
    };
  }, [dynColMetas, bucketPrefix]);

  // 드릴 오버라이드(binding→visible) — bucket/조회 변경 시 리셋 (AS-IS SetSpreadColumn 재실행)
  //   state 로 둔다: DataGrid 는 렌더마다 columnGroups 를 재대입해 wijmo Column 객체를 통째로 재생성하므로
  //   col.visible 직접 대입은 다음 렌더에 설정값으로 되돌아간다 — 가시성은 컬럼 설정에 넣어야 남는다.
  const [drillVis, setDrillVis] = useState<ReadonlyMap<string, boolean>>(() => new Map());
  useEffect(() => {
    setDrillVis(new Map());
  }, [dynColMetas, bucketPrefix]);
  const drillVisRef = useRef(drillVis);
  drillVisRef.current = drillVis;
  const isSumChecked = searchParams.isSumChecked;
  const dynVisible = (binding: string): boolean => {
    if (summaryBindings.includes(binding)) return isSumChecked;
    if (drillBindings.includes(binding)) return drillVis.get(binding) ?? false;
    return true;
  };
  // #93/UM-06 — 헤더 총 48px 고정, 단수는 **보이는** 깊이로 결정: 기간 컬럼 없음(초기·0행)=1단 48 / 월>SUM·주차 2단 24 /
  //   일(D) 컬럼이 실제로 보일 때(DAILY bucket 또는 드릴 펼침)만 월>주차>일 3단 16. ONLY_WEEKLY = 월/주차/SUM 3단(UM-09).
  //   ⚠ 타이틀에 D 컬럼이 있어도 숨겨져 있으면 2단 — 숨은 컬럼으로 3단을 세우면 월 라벨이 16px 에 잘린다(2026-08-29 실측).
  const dailyVisible = hasDaily && dynColMetas.some(m => m.kind === 'D' && dynVisible(m.binding));
  const tierH = dynColMetas.length === 0 ? 48 : dailyVisible || isOnlyWeekly ? 16 : 24;

  // ── 동적 컬럼 nested (3단: 년월>주차>일 / 2단: 년월>주차·SUM — DMF0040 패턴) ──
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();
    const kindRank = { M: 0, W: 1, D: 2 } as const;
    dynColMetas.forEach((m, idx) => {
      const ymKey = m.binding.slice(2, 8);
      let group = largeMap.get(ymKey);
      if (!group) {
        group = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, group);
      }
      const subKey = m.kind === 'M' ? 'SUM' : (m.small || 'SUM').trim() || 'SUM';
      if (!group.subs.has(subKey)) group.subs.set(subKey, []);
      group.subs.get(subKey)?.push({
        binding: m.binding,
        header: isOnlyWeekly ? 'SUM' : dailyVisible ? (m.kind === 'D' ? m.leaf || 'SUM' : 'SUM') : subKey,
        align: 'right',
        width: m.width, // UM-04 — SP COLUMN_WIDTH (ONLY_WEEKLY 100 / 그 외 50 계열)
        format: `n${m.scale}`, // UM-04 — SP DATA_SCALE_NUMBER = AS-IS NumberCellType.DecimalPlaces
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: dynVisible(m.binding),
        height: tierH,
        isReadOnly: true,
        _display: true,
      } as LeafCol);
    });
    const subOrder = (k: string): number => {
      if (k === 'SUM') return Number.NEGATIVE_INFINITY;
      const n = Number(k.replace(/\D/g, '') || 0);
      return k.trim().startsWith('+') ? n - 1000 : n;
    };
    const leafKind = (b: string): 'M' | 'W' | 'D' => kindOf(b) ?? 'D';
    // UM-09 — ONLY_WEEKLY: 컬럼마다 월(LARGE) > 주차(SMALL) > 'SUM' 3단을 독립 그룹으로 세운다.
    //   같은 월끼리 그룹을 합치지 않는다 — AS-IS 는 병합 없이 컬럼마다 월 텍스트를 반복 표시(주차:날짜 1:1).
    if (isOnlyWeekly) {
      const leafByBinding = new Map<string, LeafCol>();
      largeMap.forEach(g => g.subs.forEach(cols => cols.forEach(col => leafByBinding.set(col.binding, col))));
      return dynColMetas.flatMap(m => {
        const leaf = leafByBinding.get(m.binding);
        if (!leaf) return [];
        return [
          {
            header: m.large || m.binding.slice(2, 8),
            align: 'center',
            height: tierH,
            allowSorting: false,
            allowMerging: false,
            columns: [
              {
                header: (m.small || m.leaf || m.binding.slice(8)).trim(),
                align: 'center',
                height: tierH,
                allowSorting: false,
                allowMerging: false,
                columns: [leaf],
              },
            ],
          } as FlexGridColumnConfig,
        ];
      });
    }
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(group => ({
        header: group.label,
        align: 'center',
        height: tierH,
        allowSorting: false,
        allowMerging: false,
        columns: dailyVisible
          ? [...group.subs.entries()]
              .sort(([a], [b]) => subOrder(a) - subOrder(b))
              .map(([subLabel, leafCols]) => ({
                header: subLabel,
                align: 'center',
                height: tierH,
                allowSorting: false,
                allowMerging: false,
                columns: leafCols.sort(
                  (a, b) =>
                    kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                    a.binding.localeCompare(b.binding)
                ),
              }))
          : [...group.subs.entries()]
              .sort(([a], [b]) => subOrder(a) - subOrder(b))
              .flatMap(([, leafCols]) => leafCols.sort((a, b) => a.binding.localeCompare(b.binding))),
      }));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynColMetas, dailyVisible, isOnlyWeekly, tierH, summaryBindings, drillBindings, isSumChecked, drillVis]);

  // ── 헤더 머지 키 + 매니저 (1회 설치 — ref 로 최신 맵) ──
  const headerKeyMap = useMemo<Map<string, HeaderKey>>(() => {
    const m = new Map<string, HeaderKey>();
    dynColMetas.forEach(d => {
      m.set(d.binding, {
        ym: d.binding.slice(2, 8),
        sub: d.kind === 'M' ? 'SUM' : (d.small || 'SUM').trim() || 'SUM',
      });
    });
    return m;
  }, [dynColMetas]);
  const headerKeyRef = useRef(headerKeyMap);
  headerKeyRef.current = headerKeyMap;
  const onlyWeeklyRef = useRef(isOnlyWeekly);
  onlyWeeklyRef.current = isOnlyWeekly;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    if (g.mergeManager instanceof WaterfallHeaderMergeManager) return;
    g.mergeManager = new WaterfallHeaderMergeManager(g, () => headerKeyRef.current, () => onlyWeeklyRef.current);
    g.invalidate(true);
  }, [gridRef, staticColumns, dynamicColumns]);

  // ── D_ binding → DAY_CODE (SAT=Blue/SUN=Red 헤더 글자색 — SetSpreadHeaderSpan L512~516) ──
  const dayCodeRef = useRef<Map<string, string>>(new Map());
  dayCodeRef.current = useMemo(() => {
    const m = new Map<string, string>();
    dynColMetas.forEach(d => {
      if (d.kind === 'D' && d.dayCode) m.set(d.binding, d.dayCode.toUpperCase());
    });
    return m;
  }, [dynColMetas]);

  // ── 가시성 적용 (요약=Sum 토글 / 드릴=오버라이드) — AS-IS SetSpreadColumn ──
  const applyDynVisibility = () => {
    const g = gridRef.current;
    if (!g) return;
    g.columns.forEach(col => {
      const b = col.binding ?? '';
      if (!kindOf(b)) return;
      if (summaryBindings.includes(b)) {
        col.visible = searchParams.isSumChecked;
      } else if (drillBindings.includes(b)) {
        col.visible = drillVisRef.current.get(b) ?? false;
      } else {
        col.visible = true;
      }
    });
  };
  const applyDynVisibilityRef = useRef(applyDynVisibility);
  applyDynVisibilityRef.current = applyDynVisibility;
  useEffect(() => {
    applyDynVisibilityRef.current();
  }, [gridRef, dynamicColumns, summaryBindings, drillBindings, searchParams.isSumChecked, gridRows]);

  // ── footer 합계 (InitSpreadFooterSum — Sum, 숨김 컬럼 제외는 visible 토글이 담당) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    if (g.columnFooters.rows.length === 0) {
      g.columnFooters.rows.push(new GroupRow());
    }
    g.columns.forEach(col => {
      const b = col.binding ?? '';
      col.aggregate = kindOf(b) ? Aggregate.Sum : Aggregate.None;
    });
    // UM-11 — footer 는 bucket 무관 항상 표시 (AS-IS InitSpread() 말미 InitSpreadFooterSum 무조건 — ONLY_WEEKLY 포함)
    // footer 좌측 라벨 'Sum' (AS-IS ColumnFooter.Cells[0,1]="Sum" L418)
    const first = g.columns[0]?.binding;
    if (first && g.columnFooters.rows.length > 0) {
      g.columnFooters.setCellData(0, 0, 'Sum');
    }
  }, [gridRef, dynamicColumns, staticColumns, gridRows]);

  // ── 이벤트: 헤더 더블클릭 드릴다운 + formatItem (SAT/SUN 헤더 글자색) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 헤더 더블클릭 — M_→그 월 W_ 토글(열린 D_ 접기) / W_→그 주 D_ 토글 (CellDoubleClick L1160~1210)
    const onDblClick = (e: MouseEvent) => {
      const ht = g.hitTest(e);
      if (ht.panel !== g.columnHeaders) return;
      // UM-10 (#103) — hitTest 는 커서 아래 **물리 컬럼**을 준다(머지 원점이 아니다). 월/주차 라벨은 머지 범위
      //   가운데 = 하위 W_/D_ 컬럼 위에 그려지므로, 상위 행이면 머지 좌단 binding 으로 복원한다
      //   (정본 BusinessPlanGrid L754~771). leaf 행은 물리 컬럼이 곧 대상. 그룹 내 정렬이 M_→W_→D_ 라 좌단이 대표다.
      const leafRow = g.columnHeaders.rows.length - 1;
      let binding = g.columns[ht.col]?.binding ?? '';
      if (ht.row < leafRow && kindOf(binding)) {
        const merged = g.getMergedRange(g.columnHeaders, ht.row, ht.col);
        if (merged) binding = g.columns[merged.leftCol]?.binding ?? binding;
      }
      const kind = kindOf(binding);
      if (kind === 'M') {
        const ym = binding.slice(2, 8);
        const weeks = dynColMetas.filter(m => m.kind === 'W' && m.binding.slice(2, 8) === ym);
        const anyVisible = weeks.some(w => drillVisRef.current.get(w.binding) ?? false);
        const next = new Map(drillVisRef.current);
        weeks.forEach(w => next.set(w.binding, !anyVisible));
        // 열려있던 D_ 접기 (같은 월)
        dynColMetas
          .filter(m => m.kind === 'D' && m.binding.slice(2, 8) === ym)
          .forEach(d => next.set(d.binding, false));
        setDrillVis(next);
      } else if (kind === 'W') {
        const meta = dynColMetas.find(m => m.binding === binding);
        if (!meta) return;
        const days = dynColMetas.filter(
          m => m.kind === 'D' && m.large === meta.large && m.small === meta.small
        );
        const anyVisible = days.some(d => drillVisRef.current.get(d.binding) ?? false);
        const next = new Map(drillVisRef.current);
        days.forEach(d => next.set(d.binding, !anyVisible));
        setDrillVis(next);
      }
    };
    g.hostElement?.addEventListener('dblclick', onDblClick);

    // formatItem — SAT/SUN 헤더 글자색 (leaf 일자 행)
    const formatHandler = (
      sender: FlexGrid,
      e: { panel: GridPanel; row: number; col: number; cell: HTMLElement }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      // UM-11/12 — footer 합계 = 클라이언트 Aggregate.Sum(=AS-IS SumIgnoreHidden) / 서식 {0:#,##0.###} / LightGray
      if (e.panel.cellType === CellType.ColumnFooter) {
        e.cell.style.backgroundColor = '#d3d3d3';
        if (kindOf(binding)) {
          const n = toGridNumber(e.panel.getCellData(e.row, e.col, false));
          if (n !== null) e.cell.textContent = Globalize.format(n, FOOTER_FORMAT);
        }
        return;
      }
      if (!kindOf(binding)) return;
      if (e.panel.cellType === CellType.ColumnHeader) {
        const dc = dayCodeRef.current.get(binding);
        if (dc === 'SAT') e.cell.style.color = '#1565c0';
        else if (dc === 'SUN') e.cell.style.color = '#c62828';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      // 음수 = Red — AS-IS 프레임워크 NumberCellType.NegativeRed=true (SpreadInfo.cs L4143 등, 전 수치 셀 공통)
      const item = sender.rows[e.row]?.dataItem as WaterfallRow | undefined;
      const cellNum = item ? toGridNumber(item[binding]) : null;
      if (cellNum !== null && cellNum < 0) e.cell.style.color = '#c62828';
    };
    g.formatItem.addHandler(formatHandler);

    return () => {
      g.hostElement?.removeEventListener('dblclick', onDblClick);
      g.formatItem.removeHandler(formatHandler);
    };
  }, [gridRef, dynColMetas, gridRows]);

  return (
    <DataGrid<WaterfallRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef} // UM-07 — Filter(F4) 배선
      itemsSource={gridRows}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      headerRowHeight={tierH} // #93 — 헤더 총 48px (3단 16 / 2단 24). 컬럼 설정 height 는 Wijmo Column 에 없어 no-op
      // MEASURE 셀 콤보(CMBO 'Measure' — PROGRAM_ID = @mnuId 비관대형) 명칭 표시용 토큰 (hook #117 §5.6 — 미전달 = 0행 = CODE raw 표시)
      comboParams={{ mnuId: "'DMF0053'", divisionId: `'${searchParams.divisionId}'` }} // eslint-disable-line quotes
      isReadOnly
      allowMerging={AllowMerging.All}
      alternatingRowStep={1}
      useSummaryTooltip
      useHotkey
    />
  );
};
