import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import { BUCKET_CODE, PIVOT_PREFIX, SEARCH_LEVEL_CODE } from '../global-psi-report.constants';

// GET_SHEET_CALENDAR_3SPAN 반환 1행(design 03 §2.1) — 동적 pivot 기간칼럼 1개의 메타.
//   COLUMN_NAME 예: 'M_202601'(월) / 'W_20260W1A'(주) / 'B_...'(BOH 보조, 숨김).
export interface CalendarCol {
  columnName: string; // COLUMN_NAME — 그리드 binding
  // COLUMN_LABEL_NAME — SP 는 W_=WEEK_NAME('W44')/M_=MONTH_NAME('2026-10') 반환. leaf 헤더는 AS-IS 가 "Qty"
  //   로 하드코딩하므로(buildPivotColumns) 이 값은 leaf 라벨로 쓰지 않는다(참조/디버깅용 보존).
  columnLabel: string;
  smallLabel: string; // SMALL_CLASS_LABEL_NAME — 2단(주) 라벨. M_ 는 MONTH_NAME(=largeLabel) 로 접힘
  largeLabel: string; // LARGE_CLASS_LABEL_NAME — 1단(월) 라벨
  sortOrder: number; // SORT_ORDER_NO — 좌우 정렬 순서
  // DAY_CODE — 기간(주/월) 시작일 YYYYMMDD(SP MIN(BASIS_START_DATE)). WEEKLY 과거주차 회색 판정 기준
  //   (AS-IS cs:999 FindDataValue DAY_CODE==plan_start → 그 주 이전 회색). 폴백 경로는 ''(정보 없음).
  dayCode: string;
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

// AS-IS SetLayout(cs:1488~1543) — Search Level 모드에서 cboSearchLevel 선택별로 PRODUCT_LEVEL1/2/3 컬럼
//   가시성을 토글한다. 설계 01_layout §2 R5 에 트리거·case 매핑이 있으나 design-grid §3·FE 로 미이관된
//   누락분 복원(2026-10-16 감사). Detail(REPORT) 모드는 사용자정의 컬럼 기준이라 호출부에서 제외한다
//   (AS-IS `if (!_is_detail)`). admin VISIBLE_FLAG 은 세 컬럼 전부 Y(실측)라, 이 토글이 없으면 항상 셋 다 노출돼
//   AS-IS 와 어긋난다. searchLevel 값 = cboSearchLevel 선택과 1:1(CELL_GROUP/CELL_GROUP_DETAIL/PRODUCT_LEVEL1~3).
const PRODUCT_LEVEL_VISIBILITY: Record<string, readonly [boolean, boolean, boolean]> = {
  [SEARCH_LEVEL_CODE.CELL_GROUP]: [false, false, false], // index0 default — 전부 숨김
  [SEARCH_LEVEL_CODE.CELL_GROUP_DETAIL]: [true, true, false], // case1 — L1·L2
  [SEARCH_LEVEL_CODE.PRODUCT_LEVEL1]: [true, false, false], // case2 — L1
  [SEARCH_LEVEL_CODE.PRODUCT_LEVEL2]: [false, true, false], // case3 — L2
  [SEARCH_LEVEL_CODE.PRODUCT_LEVEL3]: [true, true, true], // case4 — L1·L2·L3
};
const PRODUCT_LEVEL_INDEX: Record<string, 0 | 1 | 2 | undefined> = {
  PRODUCT_LEVEL1: 0,
  PRODUCT_LEVEL2: 1,
  PRODUCT_LEVEL3: 2,
};

// Search Level 모드 고정컬럼에 PRODUCT_LEVEL1/2/3 show/hide 를 적용한 복사본을 돌려준다(원본 불변).
//   PRODUCT_LEVEL 외 컬럼·매핑 없는 searchLevel 값은 메타 그대로 둔다(안전 폴백).
export const applySearchLevelVisibility = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  searchLevel: string
): RawFlexGridColumnConfig[] => {
  const cols = adminCols ?? [];
  const flags = PRODUCT_LEVEL_VISIBILITY[searchLevel];
  if (!flags) return cols;
  return cols.map(c => {
    const idx = PRODUCT_LEVEL_INDEX[c.colNm];
    if (idx === undefined) return c;
    const vis = flags[idx];
    return { ...c, visible: vis, display: vis };
  });
};

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
      dayCode: s(r.DAY_CODE),
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
    return { columnName: b, columnLabel: 'Qty', smallLabel: '', largeLabel: large, sortOrder: 0, dayCode: '' };
  });
};

// BucketType 별 pivot 컬럼 가시성(design 03 §2.5). MONTHLY -> M_ 만 / WEEKLY -> W_ 만 visible.
//   B_(BOH 보조) 는 항상 숨김(width 0, design 03 §2.2). SP 는 양세트 공급 — 재조회 없이 클라 토글.
const isColVisibleForBucket = (binding: string, bucket: string): boolean => {
  if (binding.startsWith(PIVOT_PREFIX.BOH_HIDDEN)) return false;
  if (bucket === BUCKET_CODE.WEEKLY) return binding.startsWith(PIVOT_PREFIX.WEEKLY);
  return binding.startsWith(PIVOT_PREFIX.MONTHLY); // MONTHLY 기본
};

// 동적 pivot 컬럼 빌드 — CALENDAR 메타로 버킷별 헤더(WEEKLY 월>주>Qty 3단 / MONTHLY 월>Qty 2단)를 만든다.
//   AS-IS InitSpreadDateColumn(SCP0100.cs:714~817) 재현: row0=LARGE(월) / row1=SMALL(주) / leaf="Qty".
//   leaf 라벨은 AS-IS ColumnHeaderSpan(…,"Qty") 하드코딩이다 — SP COLUMN_LABEL_NAME 이 아니다.
//   MONTHLY 는 SP(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN) 가 M_ 행에 SMALL=LARGE=MONTH_NAME 로
//   같은 라벨을 주므로(DB 실측), small 이 large 와 같으면 주 단을 접어 월>Qty 2단으로 둔다(AS-IS monthly 2-span).
//   전 컬럼 읽기전용(리포트) — isReadOnly:true, allowMerging:false(pivot 은 병합 대상 아님).
export const buildPivotColumns = (
  calendarCols: readonly CalendarCol[],
  bucket: string
): FlexGridColumnConfig[] => {
  const visible = calendarCols.filter(c => isColVisibleForBucket(c.columnName, bucket));
  if (visible.length === 0) return [];

  const leafOf = (c: CalendarCol): FlexGridColumnConfig => ({
    // leaf(최하단) 헤더는 AS-IS 하드코딩 "Qty" 고정. columnLabel(W_=WEEK_NAME 'W44' / M_=MONTH_NAME
    //   '2026-10')을 쓰면 leaf 에 주/월 코드가 찍힌다(AS-IS 와 불일치) — design 03 §2.3.
    header: 'Qty',
    binding: c.columnName,
    align: 'right',
    // QTY 기본 정수. Unit(Qty) 배율>1 로 나눈 값(scaledRows)은 소수 2자리까지 표시(AS-IS Round(,2) cs:1635).
    //   배율1(원값=정수)이면 '.##' 가 소수부 없이 정수로 표기 → 배율 미선택 화면은 종전과 동일.
    format: '#,##0.##',
    // Excel 내려받기는 정수 서식(AS-IS AmendDecimalFormat '#,##0;[Red]-#,##0' cs:1200) — 값은 배율 반영분.
    _excelFormat: '#,##0;[Red]-#,##0',
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
    // 주(small) 단은 small 라벨이 월(large)과 다를 때만 만든다. MONTHLY(M_)는 SMALL=LARGE=MONTH_NAME 라
    //   접혀 월>Qty 2단, WEEKLY(W_)는 SMALL(WEEK_NAME)≠LARGE(MONTH_NAME) 라 월>주>Qty 3단이 된다.
    if (c.smallLabel && c.smallLabel !== c.largeLabel) {
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
