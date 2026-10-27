import { BUCKET_TYPE, DYN_RANK } from '../production-plan-waterfall.constants';

/**
 * 기간(버킷) 컬럼 종류 — TO-BE 캘린더 SP(P_SCP0017_GET_SHEET_CALENDAR_3SPAN) binding 규약(DB 실측 2026-10-13):
 *   D_yyyymmdd / W_ + BASIS_YYYYMM(6) + ISO_WEEK(2) / M_yyyymm — W_ 는 이미 ISO 주차(접미 없음).
 * SCP0017 은 D/W/M 3계층(Q_/Y_ 없음). demand-plan-waterfall 계층병합 표준의 단일시트 이식.
 */
export type DynKind = 'D' | 'W' | 'M';

const KIND_PATTERNS: Array<[DynKind, RegExp]> = [
  ['D', /^D_\d{8}$/],
  ['W', /^W_\d{7,}/], // W_yyyymm(6) + ISO_WEEK(2)
  ['M', /^M_\d{6}$/],
];

/** binding → kind (기간 컬럼이 아니면 null) */
export const dynKindOf = (binding: string): DynKind | null =>
  KIND_PATTERNS.find(([, re]) => re.test(binding))?.[0] ?? null;

/** 표시 rank — M(월)=0 > W(주)=1 > D(일)=2 (design 03 §2.5). 기간 컬럼 아니면 null. */
export const rankOf = (kind: DynKind | null): number | null => {
  if (!kind) return null;
  const rank = DYN_RANK[kind];
  return rank === undefined ? null : rank;
};

/**
 * 1단(대분류) 그룹 키 — 라벨이 아니라 binding 에서 뽑는다(동명 라벨 충돌 방지). 월 = yyyymm.
 *   D_yyyymmdd → yyyymm / W_yyyymmWW(_ISO) → yyyymm / M_yyyymm → yyyymm
 */
export const largeKeyOf = (binding: string): string => binding.slice(2, 8);

/** W_yyyymmWW(_ISO) → 주차 문자열(월 6자 다음 2자). 그 외 kind 는 '' */
export const weekNoOf = (binding: string): string =>
  dynKindOf(binding) === 'W' ? binding.slice(8, 10) : '';

/**
 * ISO 8601 주차 (월요일 기준) — D_yyyymmdd 의 소속 주 계산용(자매 SCP0025 isoWeek 동형).
 *   8자리 yyyymmdd 아니면 NaN.
 */
const isoWeekOfDate = (yyyymmdd: string): number => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
};

/**
 * 2단(주) 그룹 키 — 라벨(small)이 아니라 binding 에서 뽑는다. W_ 롤업과 그 주의 D_ 일자들이 같은 키를
 *   공유해야 헤더가 한 칸으로 병합된다(자매 SCP0025 buildPivotColumns weekLabel 동형). W_ 는 인코딩된
 *   ISO주차(slice 8,10), D_ 는 날짜에서 ISO주차 계산 — 같은 주면 두 값이 일치한다. M_ 등은 ''.
 *   종전 small 라벨을 키로 쓰면 W_ 롤업행과 D_ 일자행의 SP small 라벨이 달라 'W01' 이 두 그룹으로 쪼개졌다.
 */
export const weekKeyOf = (binding: string): string => {
  const kind = dynKindOf(binding);
  if (kind === 'W') return binding.slice(8, 10);
  if (kind === 'D') {
    const wk = isoWeekOfDate(binding.slice(2, 10));
    return Number.isNaN(wk) ? '' : String(wk).padStart(2, '0');
  }
  return '';
};

/** D_yyyymmdd → Date (그 외 null) */
export const dayOf = (binding: string): Date | null => {
  if (dynKindOf(binding) !== 'D') return null;
  const y = Number(binding.slice(2, 6));
  const m = Number(binding.slice(6, 8));
  const d = Number(binding.slice(8, 10));
  if (!y || !m || !d) return null;
  return new Date(y, m - 1, d);
};

/**
 * BucketType 별 기간칼럼 기본 표시 (AS-IS SetSpreadColumn SCP0017.cs:849-906 1:1). chkSum = Daily/Weekly 의 W_/M_ 합계 토글.
 *   Daily      : D 표시 · W = chkSum · M = chkSum (AS-IS cs:862-870 — isDaily||isWeekly=true 후 isMonthly||isWeekly=chkSum 이 W_ 를 덮어씀)
 *   Weekly     : D 숨김 · W 표시 · M = chkSum
 *   WeeklyISO  : W 만 표시 · 그 외(D_/M_) 숨김
 *   Monthly    : M 만 표시
 * 생성은 항상 D_/W_/M_ 전량, 표시 여부만 토글(AS-IS Columns[i].Visible 상수배열 이식 금지 — 계산 재현).
 * WeeklyISO(= 콤보 'Only Weekly', AS-IS `Visible = isWeeklyISO` cs:892-894): TO-BE 캘린더 SP 가 하나뿐이고
 *   (P_SCP0017_GET_SHEET_CALENDAR_3SPAN, bucket/ISO 인자 없음) 그 SP 가 이미 W_ 를 ISO 주차로 만든다
 *   (binding = 'W_'||BASIS_YYYYMM||ISO_WEEK, PKG_SCP0017 본문 line152 DB 실측 2026-10-13). AS-IS 의 별도
 *   _3SPAN_ISO SP·'_ISO' 접미는 TO-BE 에 존재하지 않으므로, WeeklyISO 는 일반 Weekly 와 같은 W_ 를 표시한다.
 */
export const baseVisibleOf = (
  bucket: BUCKET_TYPE,
  chkSum: boolean,
  kind: DynKind
): boolean => {
  if (bucket === BUCKET_TYPE.MONTHLY) return kind === 'M';
  if (bucket === BUCKET_TYPE.WEEKLY_ISO) return kind === 'W';
  if (bucket === BUCKET_TYPE.WEEKLY) {
    if (kind === 'D') return false;
    if (kind === 'W') return true;
    return chkSum; // M
  }
  // DAILY — D 표시, W_/M_ 둘 다 chkSum (AS-IS cs:867-869 isMonthly||isWeekly 가 W_ visible 을 chkSum 으로 덮어씀)
  if (kind === 'D') return true;
  return chkSum; // W_/M_
};
