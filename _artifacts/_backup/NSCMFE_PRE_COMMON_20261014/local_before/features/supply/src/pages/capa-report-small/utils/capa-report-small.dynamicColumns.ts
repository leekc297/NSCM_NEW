import type { GridPanel } from '@mescius/wijmo.grid';
import { type FlexGrid, CellRange, CellType } from '@mescius/wijmo.grid';

import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
import type { FlexGridColumnConfig } from '@foundation/models';
import { CustomMergeManager } from '@foundation/utils';

import type { CapaReportSmallRow } from '../capa-report-small.types';

dayjs.extend(isoWeek);

/** 동적 pivot 기간 컬럼 종류 — PR_M_ 은 M_ 보다 먼저 판별해야 한다(접두 포함관계). */
export type DynKind = 'PR' | 'M' | 'W' | 'D';

export const kindOf = (binding: string): DynKind | null => {
  if (/^PR_M_\d{6}$/.test(binding)) return 'PR';
  if (/^M_\d{6}$/.test(binding)) return 'M';
  if (/^W_\d{6,10}$/.test(binding)) return 'W';
  if (/^D_\d{8}$/.test(binding)) return 'D';
  return null;
};

export interface DynColMeta {
  binding: string;
  kind: DynKind;
  large: string; // 1단 = 년-월
  small: string; // 2단 = 주차 라벨 / 'SUM'
  leaf: string; // 3단 = 일자 / 'SUM'
  sort: number;
}

/** binding 파생 3단 라벨 — 기간헤더 SP(SCP0009 CALENDAR, C4) 미확정이므로 날짜에서 직접 산출. */
const metaOf = (binding: string, kind: DynKind): DynColMeta => {
  if (kind === 'D') {
    const ymd = binding.slice(2); // YYYYMMDD
    const yyyy = ymd.slice(0, 4);
    const mm = ymd.slice(4, 6);
    const dd = ymd.slice(6, 8);
    const iso = dayjs(`${yyyy}-${mm}-${dd}`).isoWeek();
    return {
      binding,
      kind,
      large: `${yyyy}-${mm}`,
      small: `W${String(iso).padStart(2, '0')}`,
      leaf: dd,
      sort: Number(`${ymd}31`),
    };
  }
  if (kind === 'W') {
    const ym = binding.slice(2, 8);
    const wk = binding.slice(8);
    return {
      binding,
      kind,
      large: `${ym.slice(0, 4)}-${ym.slice(4, 6)}`,
      small: `W${wk}`,
      leaf: 'SUM',
      sort: Number(`${ym}21`),
    };
  }
  // M / PR — 월 단위
  const ym = binding.slice(kind === 'PR' ? 5 : 2, kind === 'PR' ? 11 : 8);
  return {
    binding,
    kind,
    large: `${ym.slice(0, 4)}-${ym.slice(4, 6)}`,
    small: kind === 'PR' ? 'PR' : 'SUM',
    leaf: kind === 'PR' ? 'PR' : 'SUM',
    sort: Number(`${ym}${kind === 'PR' ? '02' : '01'}`),
  };
};

/** GET 응답 행 키(union)에서 동적 컬럼 메타를 도출한다(SPREAD_TITLE SP 미보유 — C4 fallback). */
export const buildDynColMetas = (rows: readonly CapaReportSmallRow[]): DynColMeta[] => {
  const set = new Set<string>();
  for (const r of rows) {
    for (const k of Object.keys(r)) {
      if (kindOf(k)) set.add(k);
    }
  }
  return [...set]
    .map(b => metaOf(b, kindOf(b) as DynKind))
    .sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
};

const kindRank: Record<DynKind, number> = { M: 0, PR: 1, W: 2, D: 3 };

/**
 * 3단 nested 컬럼(년월 → 주차/SUM → 일자). D_ 존재 시 3단(각 16px), 없으면 2단(각 24px) = 48px 고정(#93).
 * 편집 여부는 grid beginningEdit(editLock)이 판정하므로 여기서는 표시 구조만 만든다.
 */
export const buildDynamicColumns = (
  metas: readonly DynColMeta[],
  hasDaily: boolean
): FlexGridColumnConfig[] => {
  if (metas.length === 0) return [];
  const tierH = hasDaily ? 16 : 24;
  type LeafCol = FlexGridColumnConfig & { binding: string };
  const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();

  metas.forEach((m, idx) => {
    let bucket = largeMap.get(m.large);
    if (!bucket) {
      bucket = { label: m.large, subs: new Map(), order: idx };
      largeMap.set(m.large, bucket);
    }
    const subKey = m.kind === 'M' || m.kind === 'PR' ? m.small : m.small || 'SUM';
    if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
    bucket.subs.get(subKey)?.push({
      binding: m.binding,
      header: hasDaily ? (m.kind === 'D' ? m.leaf : m.small) : m.small,
      align: 'right',
      width: 80,
      allowDragging: true,
      allowMerging: false,
      allowResizing: true,
      allowSorting: false,
      visible: true,
      height: tierH,
    });
  });

  const subOrder = (k: string): number => {
    if (k === 'SUM') return Number.NEGATIVE_INFINITY;
    if (k === 'PR') return Number.POSITIVE_INFINITY;
    return Number(k.replace(/\D/g, '') || 0);
  };

  return [...largeMap.values()]
    .sort((a, b) => a.order - b.order)
    .map(bucket => ({
      header: bucket.label,
      align: 'center',
      height: tierH,
      allowSorting: false,
      allowMerging: false,
      columns: hasDaily
        ? [...bucket.subs.entries()]
            .sort(([a], [b]) => subOrder(a) - subOrder(b))
            .map(([subLabel, leafCols]) => ({
              header: subLabel,
              align: 'center',
              height: tierH,
              allowSorting: false,
              allowMerging: false,
              columns: leafCols.sort(
                (a, b) =>
                  kindRank[kindOf(a.binding) ?? 'D'] - kindRank[kindOf(b.binding) ?? 'D'] ||
                  a.binding.localeCompare(b.binding)
              ),
            }))
        : [...bucket.subs.entries()]
            .sort(([a], [b]) => subOrder(a) - subOrder(b))
            .flatMap(([, leafCols]) => leafCols.sort((a, b) => a.binding.localeCompare(b.binding))),
    }));
};

interface HeaderKey {
  ym: string;
  sub: string;
}

/** binding → 헤더 머지 키. buildDynamicColumns 의 그룹 구성(large/sub)과 동일 규칙. */
export const buildHeaderKeyMap = (metas: readonly DynColMeta[]): Map<string, HeaderKey> => {
  const m = new Map<string, HeaderKey>();
  metas.forEach(d => {
    m.set(d.binding, {
      ym: d.large,
      sub: d.kind === 'M' || d.kind === 'PR' ? d.small : d.small || 'SUM',
    });
  });
  return m;
};

/**
 * 3단 동적 헤더 머지 — ForecastPrice FcstHeaderMergeManager 규약 이식(정본 grid-behavior-parity).
 * ColumnHeader 만 재정의(TopLeft/Cell 은 super 위임 — 회귀 0). 라벨 동일('SUM') 오병합을 binding 키로 차단.
 */
export class CapaHeaderMergeManager extends CustomMergeManager<CapaReportSmallRow> {
  constructor(
    grid: FlexGrid<CapaReportSmallRow>,
    private readonly getKeys: () => Map<string, HeaderKey>
  ) {
    super(grid);
  }

  protected override allowEmptyCellMerge(panel: GridPanel): boolean {
    return panel.cellType === CellType.Cell;
  }

  getMergedRange(panel: GridPanel, r: number, c: number): CellRange | null {
    if (panel.cellType !== CellType.ColumnHeader) return super.getMergedRange(panel, r, c);
    const keys = this.getKeys();
    const bindingAt = (i: number): string => panel.columns[i]?.binding ?? '';
    const b = bindingAt(c);
    if (!keys.has(b)) return super.getMergedRange(panel, r, c);

    const leafRow = panel.rows.length - 1;
    // M_/PR_ (월 SUM) — 1단 아래 전 행 세로 병합(2·3단 라벨 동일).
    if ((b.startsWith('M_') || b.startsWith('PR_M_')) && r >= 1) {
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

/** bucket + isDetail → 표시할 동적 컬럼 종류 집합 (design 03 §2.3).
 *   Daily: !detail→M_ / detail→D_. Weekly→W_ / Monthly→M_ (C2 기능적 해석, 스펙확정 대상).
 *   PR_M_ 은 항상 숨김(design: Daily 숨김, 그 외 미정 → 숨김 유지). */
export const visibleKinds = (bucketType: string, isDetail: boolean): Set<DynKind> => {
  const b = (bucketType || 'DAILY').toUpperCase();
  if (b === 'WEEKLY') return new Set<DynKind>(['W']);
  if (b === 'MONTHLY') return new Set<DynKind>(['M']);
  // DAILY
  return isDetail ? new Set<DynKind>(['D']) : new Set<DynKind>(['M']);
};
