import { Aggregate, Globalize } from '@mescius/wijmo';
import type { GridPanel } from '@mescius/wijmo.grid';
import { type FlexGrid, AllowMerging, CellRange, CellType, GroupRow } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef, useState } from 'react';

import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
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
} from '../mkt-fcst-comparison.constants';
import type { ComparisonRow, SpreadTitleRow } from '../mkt-fcst-comparison.types';
import { useMktFcstComparisonStore } from '../useMktFcstComparisonStore';

dayjs.extend(isoWeek);

// ⭐ DMF0040 메인 그리드 — AS-IS spdMain(버전×Measure 비교 단일 시트) 1:1 조회 전용.
//   동적 시간축 = DMF0040_GET_SPREAD_TITLE (월>주>일 3단 + SUM — forecast-price 패턴 이식) /
//   실적 구간 회색(행별 VERSION_NO 경계, FindData L774~886) / Difference 행 파랑(L889~893) /
//   헤더 더블클릭 드릴다운(M_→W_→D_, CellDoubleClick L1179~1216) / footer 합계(InitSpreadFooterSum L406~424) /
//   QTY 표시 스케일(SetAmountCalculating L1756~1830 — 표시 사본 변환).

/** 동적 컬럼 헤더 머지 키 (forecast-price FcstHeaderMergeManager 규약 이식 — mkt-fcst 원조) */
interface HeaderKey {
  ym: string;
  sub: string;
}

class ComparisonHeaderMergeManager extends CustomMergeManager<ComparisonRow> {
  constructor(
    grid: FlexGrid<ComparisonRow>,
    private readonly getKeys: () => Map<string, HeaderKey>,
    private readonly getOnlyWeekly: () => boolean
  ) {
    super(grid);
  }

    // DMF0040 그리드 - 앞의 컬럼이 셀병합 되어있으면 모두 셀병합 되도록 수정
  protected override allowEmptyCellMerge(panel: GridPanel): boolean {
    return panel.cellType === CellType.Cell;
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

interface MktFcstComparisonGridProps {
  gridRef: MutableRefObject<FlexGrid<ComparisonRow> | undefined>;
  /** UM-07 — SubTitle Filter(F4)/필터 카운트가 보는 ref. DataGrid 까지 관통해야 산다 (미전달 = 조용한 no-op) */
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  data: ComparisonRow[];
  spreadTitle: SpreadTitleRow[];
}

/** 이번 주 월요일 YYYYMMDD (AS-IS GetThisWeekMonday L1675 — G-02) */
const thisWeekMondayYmd = (): string => {
  const today = dayjs();
  return today.subtract((today.day() + 6) % 7, 'day').format('YYYYMMDD');
};

/** 기준일의 전주 일요일 (AS-IS GetLastWeekSunDayByDate L1697 — 기준일 이전 월요일의 -1일, G-03) */
const lastWeekSundayYmd = (yyyymmdd: string): string => {
  const d = dayjs(yyyymmdd, 'YYYYMMDD');
  if (!d.isValid()) return '';
  return d
    .subtract((d.day() + 6) % 7, 'day')
    .subtract(1, 'day')
    .format('YYYYMMDD');
};

/** 동적 binding 의 대표 구간 [시작일, 종료일] — 실적 회색 경계 비교용 */
const bindingRange = (binding: string): { from: string; to: string } | null => {
  const kind = kindOf(binding);
  if (kind === 'D') {
    const d = binding.slice(2);
    return { from: d, to: d };
  }
  if (kind === 'M') {
    const ym = binding.slice(2);
    const start = dayjs(`${ym}01`, 'YYYYMMDD');
    return { from: start.format('YYYYMMDD'), to: start.endOf('month').format('YYYYMMDD') };
  }
  if (kind === 'W') {
    // W_yyyymmWW — 해당 연도 ISO 주차의 월~일 (AS-IS GetWeekOfYear FirstFourDayWeek/Monday 대응)
    const year = Number(binding.slice(2, 6));
    const week = Number(binding.slice(8, 10));
    if (!year || !week) return null;
    const start = dayjs().year(year).isoWeek(week).startOf('isoWeek');
    return { from: start.format('YYYYMMDD'), to: start.add(6, 'day').format('YYYYMMDD') };
  }
  return null;
};

export const MktFcstComparisonGrid = ({
  gridRef,
  gridFilterRef,
  data,
  spreadTitle,
}: MktFcstComparisonGridProps) => {
  const searchParams = useMktFcstComparisonStore(state => state.searchParams);
  const staticColumns = useMktFcstComparisonStore(state => state.staticColumns);

  const bucket = searchParams.bucket;
  const isOnlyWeekly = bucket === BUCKET_TYPE.ONLY_WEEKLY;

  // ── QTY 표시 스케일 — 원본 보존·표시 사본 변환 (AS-IS dsOrigianlCopy 복원식 파리티).
  //   footer 합계·필터·Excel 이 모두 같은 사본을 보므로 표시-집계 정합이 유지된다.
  const divisor = Number(searchParams.qty || '1') || 1;
  const gridRows = useMemo<ComparisonRow[]>(() => {
    if (divisor === 1) return data;
    return data.map(row => {
      const next: ComparisonRow = { ...row };
      for (const key of Object.keys(row)) {
        if (!kindOf(key)) continue;
        const num = toGridNumber(row[key]);
        if (num === null || num === 0) continue; // AS-IS: 0 값 skip
        next[key] = Math.round((num / divisor) * 100) / 100; // AS-IS Math.Round(…, 2)
      }
      return next;
    });
  }, [data, divisor]);

  // ── 동적 컬럼 메타 (SPREAD_TITLE — B_ 접두 숨김은 SP 산출 제외 규약 L507) ──
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
    // fallback — data row 키 union (mkt-fcst 패턴)
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

  // ── 활성 bucket / 요약(Sum 토글) / 드릴(헤더 더블클릭) 분류 (AS-IS SetSpreadColumn L1370~1415) ──
  const bucketPrefix = (isOnlyWeekly ? 'W' : bucket.trim().charAt(0).toUpperCase()) as
    | 'M'
    | 'W'
    | 'D';
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

  // ── 동적 컬럼 nested (3단: 년월>주차>일 / 2단: 년월>주차·SUM — forecast-price 패턴) ──
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    const largeMap = new Map<
      string,
      { label: string; subs: Map<string, LeafCol[]>; order: number }
    >();
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
        header: isOnlyWeekly
          ? 'SUM'
          : dailyVisible
            ? m.kind === 'D'
              ? m.leaf || 'SUM'
              : 'SUM'
            : subKey,
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
      largeMap.forEach(g =>
        g.subs.forEach(cols => cols.forEach(col => leafByBinding.set(col.binding, col)))
      );
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
              .flatMap(([, leafCols]) =>
                leafCols.sort((a, b) => a.binding.localeCompare(b.binding))
              ),
      }));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    dynColMetas,
    dailyVisible,
    isOnlyWeekly,
    tierH,
    summaryBindings,
    drillBindings,
    isSumChecked,
    drillVis,
  ]);

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
    if (g.mergeManager instanceof ComparisonHeaderMergeManager) return;
    g.mergeManager = new ComparisonHeaderMergeManager(
      g,
      () => headerKeyRef.current,
      () => onlyWeeklyRef.current
    );
    g.invalidate(true);
  }, [gridRef, staticColumns, dynamicColumns]);

  // ── D_ binding → DAY_CODE (SAT=Blue/SUN=Red 헤더 글자색 — SetSpreadHeaderSpan L517) ──
  const dayCodeRef = useRef<Map<string, string>>(new Map());
  dayCodeRef.current = useMemo(() => {
    const m = new Map<string, string>();
    dynColMetas.forEach(d => {
      if (d.kind === 'D' && d.dayCode) m.set(d.binding, d.dayCode.toUpperCase());
    });
    return m;
  }, [dynColMetas]);

  // ── 행별 실적 회색 경계 (FindData L774~886 1:1) — VERSION_NO → {boundaryYmd, unlockMonth} ──
  //   Current/'' : min(전주 일요일, 조회 종료일) / Cutoff: 버전명[5..13] 날짜의 전주 일요일 vs 조회말일 min.
  const boundaryRef = useRef<Map<string, { ymd: string; unlockMonth: string }>>(new Map());
  boundaryRef.current = useMemo(() => {
    const m = new Map<string, { ymd: string; unlockMonth: string }>();
    const periodTo = searchParams.endYyyymmdd;
    const currentSunday = dayjs(thisWeekMondayYmd(), 'YYYYMMDD')
      .subtract(1, 'day')
      .format('YYYYMMDD');
    const versions = new Set(gridRows.map(r => String(r.VERSION_NO ?? '')));
    versions.forEach(v => {
      let ref: string;
      if (!v || v.toUpperCase() === 'CURRENT') {
        ref = currentSunday < periodTo ? currentSunday : periodTo;
      } else {
        const inDate = v.length >= 13 ? v.slice(5, 13) : '';
        const cutoffSunday = inDate ? lastWeekSundayYmd(inDate) : '';
        if (!cutoffSunday) {
          ref = currentSunday < periodTo ? currentSunday : periodTo;
        } else {
          ref = cutoffSunday < periodTo ? cutoffSunday : periodTo;
        }
      }
      m.set(v, { ymd: ref, unlockMonth: `M_${ref.slice(0, 6)}` });
    });
    return m;
  }, [gridRows, searchParams.endYyyymmdd]);

  // ── 가시성 적용 (요약=Sum 토글 / 드릴=오버라이드) — AS-IS SetSpreadColumn ──
  const applyDynVisibility = () => {
    const g = gridRef.current;
    if (!g) return;
    // 우클릭 Hide Column 으로 숨긴 컬럼(공용 DataGrid 가 grid 인스턴스에 얹어 준다 — Column 객체의
    //   커스텀 플래그는 wijmo 생성자가 `_` 로 시작하는 키를 무시해 전달되지 않는다).
    const userHiddenColumns = (g as unknown as { _userHiddenColumns?: ReadonlySet<string> })
      ._userHiddenColumns;
    g.columns.forEach(col => {
      const b = col.binding ?? '';
      if (!kindOf(b)) return;
      // Hide Column 으로 숨긴 컬럼은 sum/드릴 재계산 대상에서 제외 — 숨김 유지.
      if (userHiddenColumns?.has(b)) {
        col.visible = false;
        return;
      }
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
  }, [
    gridRef,
    dynamicColumns,
    summaryBindings,
    drillBindings,
    searchParams.isSumChecked,
    gridRows,
  ]);

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
    // footer 좌측 라벨 'Sum' (AS-IS ColumnFooter.Cells[0,1]="Sum")
    const first = g.columns[0]?.binding;
    if (first && g.columnFooters.rows.length > 0) {
      g.columnFooters.setCellData(0, 0, 'Sum');
    }
  }, [gridRef, dynamicColumns, staticColumns, gridRows]);

  // ── 이벤트: 헤더 더블클릭 드릴다운 + formatItem (회색/파랑/요일색) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 헤더 더블클릭 — M_→그 월 W_ 토글(열린 D_ 접기) / W_→그 주 D_ 토글 (CellDoubleClick L1179~1216)
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

    // formatItem — 실적 회색 / Difference 파랑 / SAT·SUN 헤더 글자색
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
      const kind = kindOf(binding);
      if (!kind) return;
      if (e.panel.cellType === CellType.ColumnHeader) {
        // leaf(일자) 행의 SAT=Blue / SUN=Red (L517)
        const dc = dayCodeRef.current.get(binding);
        if (dc === 'SAT') e.cell.style.color = '#1565c0';
        else if (dc === 'SUN') e.cell.style.color = '#c62828';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      const item = sender.rows[e.row]?.dataItem as ComparisonRow | undefined;
      if (!item) return;
      // 음수 = Red — AS-IS 프레임워크 NumberCellType.NegativeRed=true (SpreadInfo.cs L4143 등, 전 수치 셀 공통)
      // Difference 행(0·양수) = Blue (.cs L913~915 SetForeColor Measure+1 ~ max)
      const cellNum = toGridNumber(item[binding]);
      if (cellNum !== null && cellNum < 0) {
        e.cell.style.color = '#c62828';
      } else if (String(item.MEASURE ?? '') === 'Difference') {
        e.cell.style.color = '#1565c0';
      }
      // 실적 구간 회색 — 행 VERSION_NO 경계 이하 기간 컬럼 (해당 월 SUM 은 White 예외, L858~872)
      // 실적 구간 회색 적용 제외
      //const boundary = boundaryRef.current.get(String(item.VERSION_NO ?? ''));
      //if (boundary) {
      //  const range = bindingRange(binding);
      //  if (range) {
      //    if (binding === boundary.unlockMonth) {
            // 경계월 M_ SUM = White 예외
      //    } else if (range.to <= boundary.ymd) {
      //      e.cell.style.backgroundColor = '#dcdcdc'; // Gainsboro
      //    }
      //  }
      //}
    };
    g.formatItem.addHandler(formatHandler);

    return () => {
      g.hostElement?.removeEventListener('dblclick', onDblClick);
      g.formatItem.removeHandler(formatHandler);
    };
  }, [gridRef, dynColMetas, gridRows]);

  return (
    <DataGrid<ComparisonRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef} // UM-07 — Filter(F4) 배선
      itemsSource={gridRows}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      headerRowHeight={tierH} // #93 — 헤더 총 48px (3단 16 / 2단 24). 컬럼 설정 height 는 Wijmo Column 에 없어 no-op
      isReadOnly
      allowMerging={AllowMerging.All}
      alternatingRowStep={1}
      useSummaryTooltip
      useHotkey
    />
  );
};
