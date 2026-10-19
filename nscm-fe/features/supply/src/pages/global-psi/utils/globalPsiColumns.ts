import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import { BUCKET_CODE, PIVOT_PREFIX } from '../global-psi.constants';

// GET_SHEET_CALENDAR_3SPAN 반환 1행(design 03 §2.1) — 동적 pivot 기간칼럼 1개의 메타.
//   COLUMN_NAME 예: 'D_20260118'(일) / 'W_202601W1'(주) / 'M_202601'(월).
export interface CalendarCol {
  columnName: string; // COLUMN_NAME — 그리드 binding
  columnLabel: string; // COLUMN_LABEL_NAME — leaf 라벨(일=일자 / 주=주명 / 월=월명)
  smallLabel: string; // SMALL_CLASS_LABEL_NAME — 2단(주) 라벨
  largeLabel: string; // LARGE_CLASS_LABEL_NAME — 1단(월) 라벨
  sortOrder: number; // SORT_ORDER_NO — 좌우 정렬 순서(월>주>일)
}

// pivot 기간칼럼 판정 — D_/W_/M_ 접두(design 03 §2.1). 고정 컬럼과 무관하게 접두로 식별
//   (SP 가 emit 하는 동적 컬럼은 admin SHEET_COLUMNS 에 없다).
export const isPivotBinding = (binding: string): boolean =>
  binding.startsWith(PIVOT_PREFIX.DAILY) ||
  binding.startsWith(PIVOT_PREFIX.WEEKLY) ||
  binding.startsWith(PIVOT_PREFIX.MONTHLY);

// 고정 차원 컬럼 빌드 — admin(SCM_MST_SHEET_COLUMNS) 등록본이 유일 원천(design 03 §1, convert-core §2.4 하드코딩 금지).
//   read-only 화면이라 전 컬럼 잠금(메타 INPUT_TP_CD='S') — 편집 override 없음. VISIBLE/FIXED 속성은 그대로 둔다
//   (속성 단위 덮어쓰기 금지 — hidden 4열·measure_label FIXED 는 메타가 이미 표현). 미등록/실패 시 빈 배열.
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

// CALENDAR 0건 폴백 — 데이터 행 union 에서 pivot 바인딩만 뽑아 최소 메타를 만든다(자매 폴백 규약 동일).
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

// BucketType × chkSum 별 pivot 컬럼 가시성(design 03 §2.2 표). SP 는 D_/W_/M_ 전세트 공급 — 재조회 없는 클라 토글.
//   Daily : D_ 항상 / W_·M_ = chkSum
//   Weekly: W_ 항상 / M_ = chkSum / D_ 숨김
//   Monthly: M_ 항상 / (chkSum 무시) / D_·W_ 숨김
export const isColVisibleForBucket = (
  binding: string,
  bucket: string,
  chkSum: boolean
): boolean => {
  const isD = binding.startsWith(PIVOT_PREFIX.DAILY);
  const isW = binding.startsWith(PIVOT_PREFIX.WEEKLY);
  const isM = binding.startsWith(PIVOT_PREFIX.MONTHLY);
  if (bucket === BUCKET_CODE.DAILY) {
    if (isD) return true;
    if (isW || isM) return chkSum;
    return false;
  }
  if (bucket === BUCKET_CODE.WEEKLY) {
    if (isW) return true;
    if (isM) return chkSum;
    return false;
  }
  // MONTHLY — M_ 만(chkSum 무시)
  return isM;
};

// pivot 컬럼 분류 — D_/W_/M_ 접두(design 03 §2.1). CALENDAR 라벨이 아니라 binding 접두로 kind 를 판정한다
//   (자매 SCP0025 Shipment Plan Fix pivotKind 와 동형).
export type PivotKind = 'D' | 'W' | 'M' | null;
export const pivotKind = (binding: string): PivotKind => {
  if (binding.startsWith(PIVOT_PREFIX.DAILY)) return 'D';
  if (binding.startsWith(PIVOT_PREFIX.WEEKLY)) return 'W';
  if (binding.startsWith(PIVOT_PREFIX.MONTHLY)) return 'M';
  return null;
};

// ISO 8601 주차(월요일 기준) — D_ 바인딩(D_YYYYMMDD)의 소속 주 계산용(자매 SCP0025 isoWeek 동일).
const isoWeek = (yyyymmdd: string): number => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
};

// 동적 pivot 컬럼 빌드 — binding 접두(D_/W_/M_)로 3단 헤더(월>주>일)를 구성한다(자매 SCP0025 Shipment Plan Fix 형태 정합).
//   1단 = 월(yyyy-MM) / 2단 = 주(Wxx, ISO) / 3단(leaf) = 일(DD). W_(주 SUM)·M_(월 SUM) 롤업 leaf 헤더는 'SUM'
//   이고 각 블록 맨 앞에 배치한다(AS-IS SCP0031.cs InitSpreadDateColumn 월/주 경계 "SUM" ColumnHeaderSpan, design 03 §2.1).
//   CALENDAR 라벨(WEEK_NAME/MONTH_NAME)을 leaf 로 쓰던 종전 형태는 롤업이 주명·월명으로 떠 SUM 이 아니었다(사용자 신고).
//   Monthly 는 월>SUM / Weekly 는 월>Wxx>SUM 으로 접힌다. 전 컬럼 읽기전용(순수 조회).
export const buildPivotColumns = (
  calendarCols: readonly CalendarCol[],
  bucket: string,
  chkSum: boolean
): FlexGridColumnConfig[] => {
  // bucket·chkSum 과 무관하게 D_/W_/M_ 전량을 build(= 구조 고정). 표시는 leaf 의 visible
  //   (isColVisibleForBucket)로만 제어한다. 안 보이는 kind 도 build 해 둬야 (1) SUM 토글이
  //   컬럼을 재생성하지 않아 헤더 깜빡임이 없고, (2) 헤더 더블클릭 드릴다운(M_ SUM→주·일, W_ SUM→일
  //   펼침)의 대상 컬럼이 존재한다(AS-IS SpreadInfo.cs SetDblClickColumnShowHide 가 bucket 무관 전 컬럼의
  //   Visible 을 flip — SP 가 D_/W_/M_ 전량 반환, design 03 §2.2). 자매 SCP0025 buildPivotColumns 동형.
  if (calendarCols.length === 0) return [];

  // 월(yyyymm) → 주(Wxx) → 일 leaf 계층 구성. CALENDAR 의 좌우 정렬 순(sortOrder)은 toCalendarCols 가 이미 적용.
  type WeekGroup = { label: string; leaves: FlexGridColumnConfig[] };
  type MonthGroup = { label: string; weeks: Map<string, WeekGroup> };
  const months = new Map<string, MonthGroup>();

  for (const c of calendarCols) {
    const binding = c.columnName;
    const kind = pivotKind(binding);
    if (kind === null) continue;
    const tag = binding.slice(2);
    const ym = tag.slice(0, 6);
    const monthLabel = `${ym.slice(0, 4)}-${ym.slice(4, 6)}`;
    let month = months.get(ym);
    if (!month) {
      month = { label: monthLabel, weeks: new Map() };
      months.set(ym, month);
    }
    // 주 라벨: W_ colId = 'W_'+BASIS_YYYYMM(6)+ISO_WEEK(2) → tag.slice(6,8) 가 주번호(design 03 §2.1).
    //   D_ colId = 'D_'+BASIS_YYYYMMDD(8) → isoWeek(날짜)로 소속 주 계산(그룹핑용). M_ 는 월 SUM 이라 'SUM' 그룹.
    const weekNum = kind === 'W' ? Number(tag.slice(6, 8)) : isoWeek(tag);
    const weekLabel = kind === 'M' ? 'SUM' : `W${weekNum}`;
    let week = month.weeks.get(weekLabel);
    if (!week) {
      week = { label: weekLabel, leaves: [] };
      month.weeks.set(weekLabel, week);
    }
    // leaf 헤더: D_ 는 일(DD), W_·M_ 롤업은 'SUM'(AS-IS ColumnHeaderSpan "SUM" 정합). 주 식별은 상위 그룹(Wxx)이 맡는다.
    const leafHeader = kind === 'D' ? tag.slice(6, 8) : 'SUM';
    week.leaves.push({
      header: leafHeader,
      binding,
      align: 'right',
      format: 'n0', // 전 measure 정수(design 03 §3 R2, DATA_SCALE_NUMBER NULL). 소수 measure 없음
      width: 70, // AS-IS AddNumColumn width 70 (design 03 §1-B)
      allowMerging: false,
      allowSorting: false,
      allowResizing: true,
      isReadOnly: true,
      // 초기 visible = bucket×chkSum 기준. 안 보이는 leaf 도 구조엔 남아(위 주석) 더블클릭 드릴·SUM 토글이
      //   컬럼 재생성 없이 col.visible 만 flip 한다(GlobalPsiGrid applyPivotVisibility).
      visible: isColVisibleForBucket(binding, bucket, chkSum),
      _dynamic: true,
    });
  }

  return [...months.values()].map<FlexGridColumnConfig>(month => {
    // SUM 을 블록 맨 앞에 배치(AS-IS iLargeStartCol/iSmallStartCol) — (1) 월 SUM(M_) 그룹을 월 맨 앞으로,
    //   (2) 각 주 그룹 안에서 주 SUM(W_) leaf 를 일자(D_) 앞으로. SUM 그룹 식별 = label==='SUM'(M_ 전용).
    const weekGroups = [
      ...[...month.weeks.values()].filter(w => w.label === 'SUM'),
      ...[...month.weeks.values()].filter(w => w.label !== 'SUM'),
    ];
    for (const w of weekGroups) {
      w.leaves.sort((a, b) => {
        const ba = a.binding ?? '';
        const bb = b.binding ?? '';
        const ra = pivotKind(ba) === 'D' ? 1 : 0; // D_(일자)는 뒤, W_/M_ SUM 은 앞
        const rb = pivotKind(bb) === 'D' ? 1 : 0;
        return ra - rb || ba.localeCompare(bb);
      });
    }
    // 월 아래 주가 1개이고 leaf 라벨이 그 주 라벨과 같으면 2단으로 접는다(Monthly/Weekly).
    const allLeaves = weekGroups.flatMap(w => w.leaves);
    const isSingleTier =
      weekGroups.length === 1 &&
      weekGroups[0].leaves.length === allLeaves.length &&
      weekGroups[0].leaves.every(l => l.header === weekGroups[0].label);
    if (isSingleTier) {
      return { header: month.label, align: 'center', columns: allLeaves };
    }
    return {
      header: month.label,
      align: 'center',
      columns: weekGroups.map<FlexGridColumnConfig>(w => ({
        header: w.label,
        align: 'center',
        columns: w.leaves,
      })),
    };
  });
};
