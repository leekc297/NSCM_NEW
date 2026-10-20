import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import { BUCKET_CODE, PIVOT_PREFIX } from '../global-psi-report.constants';

// GET_SHEET_CALENDAR_3SPAN 반환 1행(design 03 §2.1) — 동적 pivot 기간칼럼 1개의 메타.
//   COLUMN_NAME 예: 'M_202601'(월) / 'W_20260W1A'(주) / 'B_...'(BOH 보조, 숨김).
export interface CalendarCol {
  columnName: string; // COLUMN_NAME — 그리드 binding
  columnLabel: string; // COLUMN_LABEL_NAME — 3단(leaf) 라벨. 기간칼럼은 'Qty' 스팬(design 03 §2.3)
  smallLabel: string; // SMALL_CLASS_LABEL_NAME — 2단(주) 라벨
  largeLabel: string; // LARGE_CLASS_LABEL_NAME — 1단(월) 라벨
  sortOrder: number; // SORT_ORDER_NO — 좌우 정렬 순서
}

// 고정 차원 컬럼 바인딩 집합 — pivot(M_/W_/B_) 판정 기준. admin 메타 colNm 전체가 고정 컬럼.
export const fixedBindingSet = (
  adminCols: RawFlexGridColumnConfig[] | undefined
): ReadonlySet<string> => new Set((adminCols ?? []).map(c => c.colNm));

// pivot 기간칼럼 판정 — M_/W_/B_ 접두(design 03 §2.2). 고정 컬럼 목록과 무관하게 접두로 식별한다
//   (SP 가 emit 하는 동적 컬럼은 admin SHEET_COLUMNS 에 없다).
export const isPivotBinding = (binding: string): boolean =>
  binding.startsWith(PIVOT_PREFIX.MONTHLY) ||
  binding.startsWith(PIVOT_PREFIX.WEEKLY) ||
  binding.startsWith(PIVOT_PREFIX.BOH_HIDDEN);

// 고정 차원 컬럼 빌드 — admin(SCM_MST_SHEET_COLUMNS) 등록본이 유일 원천(design 03 §1, §5.1 하드코딩 금지).
//   read-only 리포트라 전 컬럼 잠금 — 편집 override 없음. admin VISIBLE_FLAG 은 그대로 둔다(속성 덮어쓰기 금지).
//   미등록/실패 시 빈 배열(store 규약) — 그리드는 pivot 컬럼만 렌더.
export const buildFixedColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined
): RawFlexGridColumnConfig[] => adminCols ?? [];

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// CALENDAR SP 반환행 -> CalendarCol. columnName 이 없거나 pivot 접두가 아니면 제외(오탐 방지).
export const toCalendarCols = (rows: readonly Record<string, unknown>[] | undefined): CalendarCol[] =>
  (rows ?? [])
    .map<CalendarCol>(r => ({
      columnName: s(r.COLUMN_NAME),
      columnLabel: s(r.COLUMN_LABEL_NAME),
      smallLabel: s(r.SMALL_CLASS_LABEL_NAME),
      largeLabel: s(r.LARGE_CLASS_LABEL_NAME),
      sortOrder: Number(r.SORT_ORDER_NO ?? 0),
    }))
    .filter(c => isPivotBinding(c.columnName))
    .sort((a, b) => a.sortOrder - b.sortOrder || a.columnName.localeCompare(b.columnName));

// CALENDAR 0건 폴백 — 데이터 행 union 에서 pivot 바인딩만 뽑아 최소 메타를 만든다(design 03 §2 mkt-fcst 폴백 규약).
//   라벨 원천이 없어 월/주 스팬은 접두 파싱으로 근사(M_202601 -> '2026-01').
export const calendarColsFromRows = (
  rows: readonly Record<string, unknown>[] | undefined
): CalendarCol[] => {
  const set = new Set<string>();
  for (const r of rows ?? []) {
    for (const k of Object.keys(r)) if (isPivotBinding(k)) set.add(k);
  }
  return [...set].sort().map<CalendarCol>(b => {
    const large = b.startsWith(PIVOT_PREFIX.MONTHLY)
      ? `${b.slice(2, 6)}-${b.slice(6, 8)}`
      : b.slice(2, 8);
    return { columnName: b, columnLabel: 'Qty', smallLabel: '', largeLabel: large, sortOrder: 0 };
  });
};

// BucketType 별 pivot 컬럼 가시성(design 03 §2.5). MONTHLY -> M_ 만 / WEEKLY -> W_ 만 visible.
//   B_(BOH 보조) 는 항상 숨김(width 0, design 03 §2.2). SP 는 양세트 공급 — 재조회 없이 클라 토글.
const isColVisibleForBucket = (binding: string, bucket: string): boolean => {
  if (binding.startsWith(PIVOT_PREFIX.BOH_HIDDEN)) return false;
  if (bucket === BUCKET_CODE.WEEKLY) return binding.startsWith(PIVOT_PREFIX.WEEKLY);
  return binding.startsWith(PIVOT_PREFIX.MONTHLY); // MONTHLY 기본
};

// 동적 pivot 컬럼 빌드 — CALENDAR 메타로 3단 헤더(월>주>Qty) 그룹 컬럼을 만든다(design 03 §2.3).
//   1단 = largeLabel(월) 그룹 / 2단 = smallLabel(주) 그룹 / leaf = 실제 값 컬럼(header='Qty').
//   MONTHLY 는 주(small) 그룹이 없으므로 월>Qty 2단으로 접힌다(SP 라벨 그대로 반영).
//   전 컬럼 읽기전용(리포트) — isReadOnly:true, allowMerging:false(pivot 은 병합 대상 아님).
export const buildPivotColumns = (
  calendarCols: readonly CalendarCol[],
  bucket: string
): FlexGridColumnConfig[] => {
  const visible = calendarCols.filter(c => isColVisibleForBucket(c.columnName, bucket));
  if (visible.length === 0) return [];

  const leafOf = (c: CalendarCol): FlexGridColumnConfig => ({
    header: c.columnLabel || 'Qty',
    binding: c.columnName,
    align: 'right',
    format: 'n0', // QTY = 정수(design 03 §4.1). 소수 measure 없음.
    width: 70, // AS-IS AddNumColumn width 70 (design 03 §2.2 cs:~740)
    allowMerging: false,
    allowSorting: false,
    allowResizing: true,
    isReadOnly: true,
    visible: true,
    _dynamic: true,
  });

  // 2단 그룹핑 — (large, small) 단위로 leaf 를 묶는다. small 이 비면(MONTHLY) large 아래 직접 leaf.
  const groups: FlexGridColumnConfig[] = [];
  let curLarge: string | null = null;
  let curSmall: string | null = null;
  let largeGroup: FlexGridColumnConfig | null = null;
  let smallGroup: FlexGridColumnConfig | null = null;

  for (const c of visible) {
    if (largeGroup === null || c.largeLabel !== curLarge) {
      curLarge = c.largeLabel;
      curSmall = null;
      smallGroup = null;
      largeGroup = { header: c.largeLabel, columns: [] };
      groups.push(largeGroup);
    }
    if (c.smallLabel) {
      if (smallGroup === null || c.smallLabel !== curSmall) {
        curSmall = c.smallLabel;
        smallGroup = { header: c.smallLabel, columns: [] };
        largeGroup.columns?.push(smallGroup);
      }
      smallGroup.columns?.push(leafOf(c));
    } else {
      largeGroup.columns?.push(leafOf(c));
    }
  }
  return groups;
};
