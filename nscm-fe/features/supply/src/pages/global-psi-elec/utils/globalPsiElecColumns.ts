import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import { BUCKET_CODE, PIVOT_PREFIX } from '../global-psi-elec.constants';

// GET_SHEET_CALENDAR_3SPAN 반환 1행(design 03 §2.1) — 동적 pivot 기간칼럼 1개의 메타.
//   COLUMN_NAME 예: 'D_20260118'(일) / 'W_202601W1'(주) / 'M_202601'(월).
export interface CalendarCol {
  columnName: string; // COLUMN_NAME — 그리드 binding
  columnLabel: string; // COLUMN_LABEL_NAME — leaf 라벨(일=일자 / 주=주 / 월=월)
  smallLabel: string; // SMALL_CLASS_LABEL_NAME — 2단(주) 라벨
  largeLabel: string; // LARGE_CLASS_LABEL_NAME — 1단(월) 라벨
  sortOrder: number; // SORT_ORDER_NO — 좌우 정렬 순서
}

// pivot 기간칼럼 판정 — D_/W_/M_ 접두(design 03 §2.1). 고정 컬럼과 무관하게 접두로 식별
//   (SP 가 emit 하는 동적 컬럼은 admin SHEET_COLUMNS 에 없다).
export const isPivotBinding = (binding: string): boolean =>
  binding.startsWith(PIVOT_PREFIX.DAILY) ||
  binding.startsWith(PIVOT_PREFIX.WEEKLY) ||
  binding.startsWith(PIVOT_PREFIX.MONTHLY);

// 고정 차원 컬럼 빌드 — admin(SCM_MST_SHEET_COLUMNS) 등록본이 유일 원천(design 03 §1, convert-core §2.4 하드코딩 금지).
//   read-only 화면이라 전 컬럼 잠금(메타 INPUT_TP_CD='S') — 편집 override 없음. VISIBLE/FIXED 속성은 그대로 둔다
//   (속성 단위 덮어쓰기 금지 — PLANT_ID 숨김·VALUE2 고정열은 메타가 이미 표현). 미등록/실패 시 빈 배열.
export const buildFixedColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined
): RawFlexGridColumnConfig[] => adminCols ?? [];

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// CALENDAR SP 반환행 -> CalendarCol. columnName 이 없거나 pivot 접두가 아니면 제외(오탐 방지).
export const toCalendarCols = (
  rows: readonly Record<string, unknown>[] | undefined
): CalendarCol[] =>
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

// CALENDAR 0건 폴백 — 데이터 행 union 에서 pivot 바인딩만 뽑아 최소 메타를 만든다(global-psi-report 폴백 규약 동일).
//   라벨 원천이 없어 월/주 스팬은 접두 파싱으로 근사.
export const calendarColsFromRows = (
  rows: readonly Record<string, unknown>[] | undefined
): CalendarCol[] => {
  const set = new Set<string>();
  for (const r of rows ?? []) {
    for (const k of Object.keys(r)) if (isPivotBinding(k)) set.add(k);
  }
  return [...set].sort().map<CalendarCol>(b => {
    let large = '';
    let leaf = '';
    if (b.startsWith(PIVOT_PREFIX.MONTHLY)) {
      large = `${b.slice(2, 6)}-${b.slice(6, 8)}`;
      leaf = large;
    } else if (b.startsWith(PIVOT_PREFIX.WEEKLY)) {
      large = `${b.slice(2, 6)}-${b.slice(6, 8)}`;
      leaf = b.slice(2);
    } else {
      // D_YYYYMMDD
      large = `${b.slice(2, 6)}-${b.slice(6, 8)}`;
      leaf = b.slice(6, 8);
    }
    return { columnName: b, columnLabel: leaf, smallLabel: '', largeLabel: large, sortOrder: 0 };
  });
};

// BucketType 별 pivot 컬럼 가시성(design 03 §2.2). DAILY->D_ / WEEKLY->W_ / MONTHLY->M_ 만 visible.
//   chkSum 은 AS-IS Visible=false(기본 off, 미노출)라 SUM 컬럼 추가 표시 없음 = 활성 버킷 접두만(design 03 §2.2 실측).
//   SP 는 D_/W_/M_ 전세트 공급 — 재조회 없이 클라 토글.
const isColVisibleForBucket = (binding: string, bucket: string): boolean => {
  if (bucket === BUCKET_CODE.DAILY) return binding.startsWith(PIVOT_PREFIX.DAILY);
  if (bucket === BUCKET_CODE.MONTHLY) return binding.startsWith(PIVOT_PREFIX.MONTHLY);
  return binding.startsWith(PIVOT_PREFIX.WEEKLY); // WEEKLY 기본
};

// 동적 pivot 컬럼 빌드 — CALENDAR 메타로 3단 헤더(월>주>일/주/월) 그룹 컬럼을 만든다(design 03 §2.3).
//   1단 = largeLabel(월) 그룹 / 2단 = smallLabel(주) 그룹 / leaf = 실제 값 컬럼(일/주/월 라벨).
//   MONTHLY 는 주(small) 그룹이 없으므로 월>leaf 2단으로 접힌다(SP 라벨 그대로 반영).
//   전 컬럼 읽기전용(순수 조회) — isReadOnly:true, allowMerging:false(pivot 은 병합 대상 아님). Excel export 위해
//   group/leaf 둘 다 visible:true 명시(hook #103 §5).
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
    format: 'n0', // 기본 정수(design 03 §3 R3). Yield_A/Yield_E 행만 grid formatItem 이 소수 2자리로 덮음(R30)
    width: 70, // AS-IS AddNumColumn width 70 (design 03 §2.1)
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
      largeGroup = { header: c.largeLabel, visible: true, columns: [] };
      groups.push(largeGroup);
    }
    if (c.smallLabel) {
      if (smallGroup === null || c.smallLabel !== curSmall) {
        curSmall = c.smallLabel;
        smallGroup = { header: c.smallLabel, visible: true, columns: [] };
        largeGroup.columns?.push(smallGroup);
      }
      smallGroup.columns?.push(leafOf(c));
    } else {
      largeGroup.columns?.push(leafOf(c));
    }
  }
  return groups;
};
