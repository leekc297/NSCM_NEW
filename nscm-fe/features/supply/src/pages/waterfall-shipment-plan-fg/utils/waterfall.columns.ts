import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import {
  type BUCKET_TYPE,
  FORCED_AXIS,
  PERIOD_COLUMN_REGEX,
  scaleOf,
} from '../waterfall-shipment-plan-fg.constants';

import {
  baseVisibleOf,
  dynKindOf,
  isIsoWeek,
  largeKeyOf,
  rankOf,
  weekNoOf,
  type DynKind,
} from './waterfall.periods';

/** TITLE SP(캘린더 3span) o_rc1 행 — 실측 소비 컬럼만 선언(design 03 §2.1). */
export interface WaterfallTitleRow {
  COLUMN_NAME?: string | number;
  COLUMN_LABEL_NAME?: string | number;
  LARGE_CLASS_LABEL_NAME?: string | number;
  SMALL_CLASS_LABEL_NAME?: string | number;
  MMDD_LABEL_NAME?: string | number;
  SORT_ORDER_NO?: string | number;
  VISIBLE_FLAG?: string | number;
  COLUMN_WIDTH?: string | number;
  DATA_SCALE_NUMBER?: string | number;
  DAY_CODE?: string | number;
  [key: string]: string | number | undefined;
}

export interface DynColMeta {
  binding: string;
  kind: DynKind;
  large: string; // 1단 라벨 (LARGE_CLASS_LABEL_NAME = 월)
  small: string; // 2단 라벨 (SMALL_CLASS_LABEL_NAME = 주 / ISO 는 MMDD_LABEL_NAME)
  leaf: string; // 3단 라벨 (COLUMN_LABEL_NAME = 일)
  dayCode: string; // 주말 헤더색 판정용 ('SAT'/'SUN'/'')
  sort: number;
  seq: number;
}

const isForcedAxis = (name: string): boolean => (FORCED_AXIS as readonly string[]).includes(name);
const str = (v: string | number | undefined | null): string => String(v ?? '').trim();
const num = (v: string | number | undefined | null): number => Number(v ?? 0) || 0;

/** SORT_ORDER_NO 순 정렬 + 정적/기간 분리. `B_`(백데이터) 접두·VISIBLE_FLAG='N' 은 제외(강제 축 예외). */
export const splitTitleRows = (
  titleRows: WaterfallTitleRow[]
): { staticRows: WaterfallTitleRow[]; periodRows: WaterfallTitleRow[] } => {
  const sorted = titleRows
    .map((row, seq) => ({ row, seq }))
    .sort((a, b) => num(a.row.SORT_ORDER_NO) - num(b.row.SORT_ORDER_NO) || a.seq - b.seq)
    .map(({ row }) => row);

  const staticRows: WaterfallTitleRow[] = [];
  const periodRows: WaterfallTitleRow[] = [];
  sorted.forEach(row => {
    const name = str(row.COLUMN_NAME);
    if (!name || name.startsWith('B_')) return;
    if (PERIOD_COLUMN_REGEX.test(name)) {
      if (str(row.VISIBLE_FLAG) !== 'N') periodRows.push(row);
      return;
    }
    if (str(row.VISIBLE_FLAG) === 'N' && !isForcedAxis(name)) return;
    staticRows.push(row);
  });
  return { staticRows, periodRows };
};

export interface StaticColumnInput {
  /** TITLE SP 가 정적 컬럼도 반환하면 그 순서, 없으면 admin 메타 순서를 쓴다 */
  staticRows: WaterfallTitleRow[];
  /** UI CATEGORY 메타 (SCM_MST_SHEET_COLUMNS admin fetch) — 컬럼 인벤토리·라벨·정렬 원천(28행) */
  metaColumns: RawFlexGridColumnConfig[];
}

/**
 * 정적(행 축) 컬럼 — admin 메타(SCM_MST_SHEET_COLUMNS 'Waterfall Shipment Plan' 28행)가 정본.
 *   공용 캘린더 TITLE SP 는 기간 컬럼만 반환하므로 staticRows 는 보통 비어 있고 admin 메타 순서를 쓴다.
 *   고정열·hidden·정렬은 admin 메타(RawFlexGridColumnConfig.fixed/visible/…)로만 표현 — FE 리터럴
 *   fixed:true·visible 덮어쓰기·컬럼 재배치 금지(CLAUDE.md §2 check4 / hook #130). SCP0016 은 EE 분기
 *   컬럼 가시성 규칙 없음(design 03 — 전 컬럼 admin VISIBLE_FLAG 그대로).
 */
export const buildStaticColumns = ({
  staticRows,
  metaColumns,
}: StaticColumnInput): RawFlexGridColumnConfig[] => {
  const metaByName = new Map(metaColumns.map(c => [c.colNm, c]));

  // TITLE SP 가 정적 컬럼을 주면 그 순서 채택, 아니면 admin 메타 그대로.
  if (staticRows.length === 0) return metaColumns.map(c => ({ ...c }));

  return staticRows
    .map(row => {
      const name = str(row.COLUMN_NAME);
      const meta = metaByName.get(name);
      if (!meta) return undefined;
      return {
        ...meta,
        colLblNm: str(row.COLUMN_LABEL_NAME) || meta.colLblNm || name,
      } as RawFlexGridColumnConfig;
    })
    .filter((c): c is RawFlexGridColumnConfig => c !== undefined);
};

/** 기간 컬럼 메타 — TITLE SP 순서(= AS-IS 스프레드 컬럼 순서) 유지. ISO 는 MMDD_LABEL_NAME 을 2단 라벨로. */
export const buildDynColMetas = (periodRows: WaterfallTitleRow[]): DynColMeta[] =>
  periodRows
    .map((row, seq) => {
      const binding = str(row.COLUMN_NAME);
      const kind = dynKindOf(binding);
      if (!kind) return null;
      const meta: DynColMeta = {
        binding,
        kind,
        large: str(row.LARGE_CLASS_LABEL_NAME),
        small: str(row.SMALL_CLASS_LABEL_NAME) || str(row.MMDD_LABEL_NAME),
        leaf: str(row.COLUMN_LABEL_NAME),
        dayCode: str(row.DAY_CODE),
        sort: num(row.SORT_ORDER_NO),
        seq,
      };
      return meta;
    })
    .filter((m): m is DynColMeta => m !== null);

/** 컬럼그룹 재생성 억제용 서명 — 내용이 같으면 rebuild 하지 않는다 */
export const dynKeySig = (metas: DynColMeta[]): string => metas.map(m => m.binding).join(',');

export interface DynamicColumnInput {
  metas: DynColMeta[];
  bucket: BUCKET_TYPE;
  chkSum: boolean;
  /** 기간 컬럼 소수 자릿수 (TITLE SP DATA_SCALE_NUMBER, 없으면 0 — 기간칼럼=정수 qty) */
  scale: number;
}

/**
 * 3단 동적 컬럼 그룹 (1단 월 → 2단 주차/SUM → 3단 일자/SUM) — design 03 §3 R5.
 *   라벨은 TITLE SP 제공값(LARGE/SMALL/COLUMN_LABEL) 그대로, 합계 컬럼의 leaf 는 'SUM'.
 *   주의: 컬럼 정의에 height 를 넣지 않는다 — headerRowHeight prop 단일 출처(#93).
 */
export const buildDynamicColumns = ({
  metas,
  bucket,
  chkSum,
  scale,
}: DynamicColumnInput): FlexGridColumnConfig[] => {
  if (metas.length === 0) return [];
  type LeafCol = FlexGridColumnConfig & { binding: string };
  type SubGroup = { order: number; cols: LeafCol[] };
  type LargeBucket = { label: string; order: number; subs: Map<string, SubGroup> };

  const largeMap = new Map<string, LargeBucket>();
  const format = scale > 0 ? `#,##0.${'0'.repeat(scale)}` : '#,##0';

  metas.forEach((m, idx) => {
    const largeKey = largeKeyOf(m.binding);
    let group = largeMap.get(largeKey);
    if (!group) {
      group = { label: m.large || largeKey, order: idx, subs: new Map() };
      largeMap.set(largeKey, group);
    }
    const rank = rankOf(m.kind);
    // 2단 키 — 최상위(월, rank 0) 합계는 'SUM', 그 외는 SP small 라벨(없으면 주차 파생)
    const subKey = rank === 0 ? 'SUM' : m.small || weekNoOf(m.binding) || 'SUM';
    let sub = group.subs.get(subKey);
    if (!sub) {
      sub = { order: idx, cols: [] };
      group.subs.set(subKey, sub);
    }
    sub.cols.push({
      binding: m.binding,
      // 3단 라벨 — 합계(rank 0·1)는 'SUM', 최하위(일, rank 2)만 실제 leaf 라벨
      header: rank === 2 ? m.leaf || m.small || 'SUM' : 'SUM',
      align: 'right',
      format,
      width: 90,
      allowDragging: false,
      allowMerging: false,
      allowResizing: true,
      allowSorting: false,
      visible: baseVisibleOf(bucket, chkSum, m.kind, isIsoWeek(m.binding)),
      _display: true,
    });
  });

  const sumFirst = (k: string): number => (k === 'SUM' ? 0 : 1);
  const leafRank = (binding: string): number => rankOf(dynKindOf(binding)) ?? 9;

  return [...largeMap.values()]
    .sort((a, b) => a.order - b.order)
    .map(group => ({
      header: group.label,
      align: 'center',
      visible: true,
      columns: [...group.subs.entries()]
        .sort(([ka, a], [kb, b]) => sumFirst(ka) - sumFirst(kb) || a.order - b.order)
        .map(([subLabel, sub]) => ({
          header: subLabel,
          align: 'center',
          visible: true,
          columns: sub.cols.sort(
            (a, b) => leafRank(a.binding) - leafRank(b.binding) || a.binding.localeCompare(b.binding)
          ),
        })),
    }));
};

/** 기간 컬럼 소수 자릿수 (TITLE SP DATA_SCALE_NUMBER, 없으면 0) */
export const periodScaleOf = (periodRows: WaterfallTitleRow[]): number =>
  scaleOf(periodRows[0]?.DATA_SCALE_NUMBER, 0);
