import { Aggregate } from '@mescius/wijmo';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { ColumnLayoutRow } from '@shared/components';

import {
  BUCKET_TYPE,
  PERIOD_COLUMN_REGEX,
  scaleOf,
  type Gubun,
} from '../demand-plan-waterfall.constants';

import {
  bucketKindOf,
  dynKindOf,
  largeKeyOf,
  rankOf,
  weekNoOf,
  type DynKind,
} from './waterfall.periods';

/** TITLE SP(`*SpreadTitle`) o_rc1 행 — 실측 소비 컬럼만 선언 */
export interface WaterfallTitleRow {
  COLUMN_NAME?: string | number;
  COLUMN_LABEL_NAME?: string | number;
  LARGE_CLASS_LABEL_NAME?: string | number;
  SMALL_CLASS_LABEL_NAME?: string | number;
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
  /** 1단 라벨 (LARGE_CLASS_LABEL_NAME) */
  large: string;
  /** 2단 라벨 (SMALL_CLASS_LABEL_NAME) */
  small: string;
  /** 3단 라벨 (COLUMN_LABEL_NAME) */
  leaf: string;
  /** 주말 헤더색 판정용 ('SAT'/'SUN'/'') */
  dayCode: string;
  sort: number;
  seq: number;
}

/**
 * VERSION_NO / MEASURE 는 메타상 VISIBLE_FLAG='N' 이어도 waterfall 의 핵심 행 축이다
 * (AS-IS 강제치환 규약 — 무조건 SELECT). 컬럼 설정으로도 끌 수 없다.
 */
export const FORCED_AXIS = ['VERSION_NO', 'MEASURE'] as const;
const isForcedAxis = (name: string): boolean => (FORCED_AXIS as readonly string[]).includes(name);

const str = (v: string | number | undefined | null): string => String(v ?? '').trim();
const num = (v: string | number | undefined | null): number => Number(v ?? 0) || 0;

/** SORT_ORDER_NO 순 정렬 + 정적/기간 분리. `B_` 접두(숨김 규약)와 VISIBLE_FLAG='N' 은 제외한다. */
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
  staticRows: WaterfallTitleRow[];
  /** GRID COLUMN SET 저장본 (null = 미설정 → TITLE SP 기본) */
  settings: ColumnLayoutRow[] | null;
  /**
   * UI CATEGORY 메타 (SHEET_COLUMNS) — 설정으로 켠 컬럼의 **존재 판정과 라벨 원천**.
   *
   * ⚠ 조회 결과 행의 키로 존재를 판정하면 안 된다 — BE 가 첫 행이 NULL 인 컬럼의 setter 를 건너뛰어
   *   응답 JSON 에서 키가 통째로 빠진다(hook pivot-dynamic-column-nvl 계보). 실측 2026-09-04:
   *   SALES div40 TITLE 기간컬럼 19 vs 메인 첫 행 기간키 2 — 데이터 기준으로 걸렀다면 17개가 사라진다.
   *   메인 SP 는 `[E20260828-ALLCOLS]` 로 division VALID 전 컬럼을 SELECT 목록에 넣으므로
   *   메타에 있으면 컬럼은 실재한다(값이 전부 NULL 일 수 있을 뿐).
   */
  metaColumns: RawFlexGridColumnConfig[];
}

/**
 * 정적(행 축) 컬럼 — TITLE SP 순서 + GRID COLUMN SET(표시·순서·폭·색) 반영.
 *
 * - **MEASURE 를 정적 말미로 핀하고 거기에만 `fixed`** 를 준다. 공용 DataGrid 가
 *   `frozenColumns = findLastIndex(_fixed) + 1` 로 계산하므로 0..MEASURE 전체가 좌측 고정된다
 *   (AS-IS `Freeze(0, GetColumnIndex(MEASURE) + 1)` — 0035 .cs:1230 / 0022 .cs:648 / 0051 .cs:1230).
 * - 설정에서 켠 컬럼이 TITLE SP 에 없어도 **UI CATEGORY 메타에 있으면** 메타 라벨로 추가한다
 *   (메인 SP `[E20260828-ALLCOLS]` 가 division VALID 전 컬럼을 SELECT 하므로 — "켰는데 안 나온다" 방지).
 */
export const buildStaticColumns = ({
  staticRows,
  settings,
  metaColumns,
}: StaticColumnInput): RawFlexGridColumnConfig[] => {
  const metaByName = new Map(metaColumns.map(c => [c.colNm, c]));
  const hasMeta = (name: string): boolean => metaColumns.length === 0 || metaByName.has(name);

  const base: RawFlexGridColumnConfig[] = staticRows.map(row => {
    const name = str(row.COLUMN_NAME);
    const meta = metaByName.get(name);
    const width = num(row.COLUMN_WIDTH) || meta?.colWth || 0;
    // ⭐ [E20260904-COLMETA] UI CATEGORY 메타를 **통째로 승계**한 뒤 TITLE SP 값으로만 덮어쓴다.
    //   셀 컨트롤(cellCtrlObjTpCd='FPComboBox')·콤보 ID(cellCboDataTp)·정렬·스케일·ATTRIBUTE1~5(콤보 파라미터
    //   계약)를 버리면 공용 DataGrid 가 dataMap 을 만들 수 없어 **콤보 셀이 코드로 표시된다**
    //   (사용자 신고 2026-09-04 — MEASURE 가 명칭 아닌 코드로 보임. 메타 실측: MEASURE = FPComboBox / CMBO 'Measure').
    return {
      ...(meta ?? {}),
      colNm: name,
      colLblNm: str(row.COLUMN_LABEL_NAME) || meta?.colLblNm || name,
      colWth: width > 0 ? width : undefined,
      visible: true,
      display: true,
    };
  });

  let columns = base;
  if (settings && settings.length > 0) {
    const byName = new Map(columns.map(c => [c.colNm, c]));
    const picked: RawFlexGridColumnConfig[] = [];
    [...settings]
      .sort((a, b) => a.SORT_ORDER_NO - b.SORT_ORDER_NO)
      .forEach(row => {
        if (row.USER_FLAG !== 'Y') return;
        const name = row.COLUMN_NAME;
        const existing = byName.get(name);
        const meta = metaByName.get(name);
        if (!existing && !(meta && hasMeta(name))) return;
        picked.push({
          ...(existing ?? {
            ...(meta ?? {}),
            colNm: name,
            colLblNm: meta?.colLblNm || name,
            visible: true,
            display: true,
          }),
          colWth: row.COL_WIDTH > 0 ? row.COL_WIDTH : existing?.colWth,
          cellColor: row.CELL_COLOR || undefined,
          textColor: row.TEXT_COLOR || undefined,
        });
      });
    // 강제 축은 설정에서 꺼져 있어도 유지 (AS-IS 무조건 SELECT 규약)
    FORCED_AXIS.forEach(name => {
      if (picked.some(c => c.colNm === name)) return;
      const existing = byName.get(name);
      if (existing) picked.push(existing);
    });
    if (picked.length > 0) columns = picked;
  }

  // MEASURE 를 정적 말미로 핀 + fixed (AS-IS freeze 기준). MEASURE 부재 시 마지막 정적 컬럼이 대신한다.
  const measure = columns.find(c => c.colNm === 'MEASURE');
  const rest = columns.filter(c => c.colNm !== 'MEASURE');
  if (measure) return [...rest, { ...measure, fixed: true }];
  if (rest.length === 0) return rest;
  return [...rest.slice(0, -1), { ...rest[rest.length - 1], fixed: true }];
};

/** 기간 컬럼 메타 — TITLE SP 순서(= AS-IS 스프레드 컬럼 순서) 유지 */
export const buildDynColMetas = (
  periodRows: WaterfallTitleRow[],
  gubun: Gubun
): DynColMeta[] =>
  periodRows
    .map((row, seq) => {
      const binding = str(row.COLUMN_NAME);
      const kind = dynKindOf(binding);
      if (!kind || rankOf(gubun, kind) === null) return null;
      const meta: DynColMeta = {
        binding,
        kind,
        large: str(row.LARGE_CLASS_LABEL_NAME),
        small: str(row.SMALL_CLASS_LABEL_NAME),
        leaf: str(row.COLUMN_LABEL_NAME),
        dayCode: str(row.DAY_CODE),
        sort: num(row.SORT_ORDER_NO),
        seq,
      };
      return meta;
    })
    .filter((m): m is DynColMeta => m !== null);

/** 컬럼그룹 재생성 억제용 서명 — 조회마다 배열 참조가 바뀌어도 내용이 같으면 rebuild 하지 않는다 */
export const dynKeySig = (metas: DynColMeta[]): string => metas.map(m => m.binding).join(',');

/**
 * 초기 표시 규칙 (hook #103 §1-2) — **config 에 직접 반영**한다.
 *   활성 버킷 kind = 표시 / 상위(rank 작음) = Sum 체크 / 하위(rank 큼) = 숨김(드릴로만)
 * config 와 base 규칙이 어긋나면 매 레이아웃마다 flip 이 일어나 깜빡인다.
 */
export const baseVisibleOf = (
  gubun: Gubun,
  bucket: string,
  isSumChecked: boolean,
  kind: DynKind
): boolean => {
  const active = rankOf(gubun, bucketKindOf(gubun, bucket));
  const rank = rankOf(gubun, kind);
  if (active === null || rank === null) return false;
  if (rank === active) return true;
  if (rank > active) return false;
  // ONLY_WEEKLY 는 AS-IS 가 상위 합계(M_)를 노출하지 않는다 (주 단위 2단 헤더 전용 표시)
  return bucket === BUCKET_TYPE.ONLY_WEEKLY ? false : isSumChecked;
};

export interface DynamicColumnInput {
  metas: DynColMeta[];
  gubun: Gubun;
  bucket: string;
  isSumChecked: boolean;
  /** 기간 컬럼 소수 자릿수 (TITLE SP DATA_SCALE_NUMBER) */
  scale: number;
}

/**
 * 3단 동적 컬럼 그룹 (1단 대분류 → 2단 중분류 → 3단 leaf).
 *   MKT·SALES : 월 > 주차/SUM > SUM·일자   (AS-IS SetSpreadHeaderSpan 0035 .cs:522-611)
 *   BIZ       : 연 > 분기/SUM > SUM·월     (AS-IS 0051 .cs:1150-1228)
 * 라벨은 TITLE SP 제공값(LARGE/SMALL/COLUMN_LABEL)을 그대로 쓰고, 합계 컬럼의 leaf 는 'SUM'.
 *
 * ⛔ **컬럼 정의에 `height` 를 넣지 않는다** (2026-09-04 클라우드 실사고).
 *   wijmo `_ColumnGroupHandler._buildColumnGroups` 는 정의 객체의 `height` 를 **각 헤더 row 에 명시 height
 *   로 박는다**. 명시 height 는 `rows.defaultSize` 를 무시하므로 1단 높이(48)가 3단 전체에 적용돼
 *   헤더가 144px 로 벌어진다. 사내는 공용 DataGrid 의 2026-08-28 정정본이 row 단위로 되돌려 가려졌지만,
 *   그 정정 이전 세대(클라우드)에서는 그대로 드러난다. 높이는 `headerRowHeight` prop 단일 출처(#93).
 */
export const buildDynamicColumns = ({
  metas,
  gubun,
  bucket,
  isSumChecked,
  scale,
}: DynamicColumnInput): FlexGridColumnConfig[] => {
  if (metas.length === 0) return [];
  type LeafCol = FlexGridColumnConfig & { binding: string };
  type SubGroup = { order: number; cols: LeafCol[] };
  type LargeBucket = { label: string; order: number; subs: Map<string, SubGroup> };

  const largeMap = new Map<string, LargeBucket>();
  const format = scale > 0 ? `#,##0.${'0'.repeat(scale)}` : '#,##0';

  metas.forEach((m, idx) => {
    const largeKey = largeKeyOf(gubun, m.binding);
    let group = largeMap.get(largeKey);
    if (!group) {
      group = { label: m.large || largeKey, order: idx, subs: new Map() };
      largeMap.set(largeKey, group);
    }
    const rank = rankOf(gubun, m.kind);
    // 2단 키 — 최상위(rank 0) 합계는 'SUM', 그 외는 SP small 라벨(없으면 주차 파생)
    const subKey = rank === 0 ? 'SUM' : m.small || weekNoOf(m.binding) || 'SUM';
    let sub = group.subs.get(subKey);
    if (!sub) {
      sub = { order: idx, cols: [] };
      group.subs.set(subKey, sub);
    }
    sub.cols.push({
      binding: m.binding,
      // 3단 라벨 — 합계(rank 0·1)는 'SUM', 최하위만 실제 leaf 라벨
      header: rank === 2 ? m.leaf || m.small || 'SUM' : 'SUM',
      align: 'right',
      format,
      aggregate: Aggregate.Sum,
      width: 90,
      allowDragging: false,
      allowMerging: false,
      allowResizing: true,
      allowSorting: false,
      visible: baseVisibleOf(gubun, bucket, isSumChecked, m.kind),
      _display: true,
    });
  });

  const sumFirst = (k: string): number => (k === 'SUM' ? 0 : 1);
  const leafRank = (binding: string): number => rankOf(gubun, dynKindOf(binding)) ?? 9;

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

/** UM-04 — 기간 컬럼 소수 자릿수 (TITLE SP DATA_SCALE_NUMBER, 없으면 0) */
export const periodScaleOf = (periodRows: WaterfallTitleRow[]): number =>
  scaleOf(periodRows[0]?.DATA_SCALE_NUMBER, 0);
