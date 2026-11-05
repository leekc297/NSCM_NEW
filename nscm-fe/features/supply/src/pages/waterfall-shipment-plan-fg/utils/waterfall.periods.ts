import { BUCKET_TYPE, DYN_RANK } from '../waterfall-shipment-plan-fg.constants';

/**
 * 기간(버킷) 컬럼 종류 — AS-IS 컬럼 tag 규약(design 03 §2 실측):
 *   D_yyyymmdd / W_yyyymm + ISO주차(+`_ISO`) / M_yyyymm
 * SCP0016 은 D/W/M 3계층. 자매 production-plan-waterfall(SCP0017) 계층병합 표준 이식.
 */
export type DynKind = 'D' | 'W' | 'M';

const KIND_PATTERNS: Array<[DynKind, RegExp]> = [
  ['D', /^D_\d{8}$/],
  ['W', /^W_\d{7,}/], // 비ISO(W_yyyymmWW) + ISO(W_yyyymmWW_ISO) 공통
  ['M', /^M_\d{6}$/],
];

/** binding → kind (기간 컬럼이 아니면 null) */
export const dynKindOf = (binding: string): DynKind | null =>
  KIND_PATTERNS.find(([, re]) => re.test(binding))?.[0] ?? null;

/** ISO 주 컬럼 판정 — colName endsWith '_ISO' (design 03 §2.1). */
export const isIsoWeek = (binding: string): boolean => binding.endsWith('_ISO');

/** 표시 rank — M(월)=0 > W(주)=1 > D(일)=2 (design 03 §2.1 SORT). 기간 컬럼 아니면 null. */
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
 * ISO 8601 주차 (월요일 기준) — D_yyyymmdd 의 소속 주 계산용(자매 SCP0017 isoWeekOfDate 동형).
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
 * 2단(주) 그룹 키 — 라벨(small)이 아니라 binding 에서 뽑는다. W_ 롤업(주합)과 그 주의 D_ 일자들이
 *   같은 키를 공유해야 'Wxx' 2단 헤더가 한 칸으로 가로 병합된다(자매 SCP0017 weekKeyOf 동형). W_ 는
 *   인코딩된 ISO주차(slice 8,10), D_ 는 날짜에서 ISO주차 계산 — 같은 주면 두 값이 일치한다. M_ 등은 ''.
 *   종전엔 D_ 를 월 단위 상수 키(`large:D`)로 둬 W_ 롤업(`large:Wxx`)과 키가 달라, Sum 체크로 W_ 가
 *   보일 때 'W35' 2단 헤더가 주합계 칸과 일자 칸으로 쪼개졌다(SCP0016 실측 — W_ 는 slice(8,10) 이 ISO_WEEK,
 *   '_ISO' 접미는 경계 밖이라 비ISO/ISO 공통으로 파싱 영향 없음).
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

/**
 * BucketType 별 기간칼럼 기본 표시 (AS-IS SetSpreadColumn SCP0016.cs:1213-1281 1:1). chkSum = Daily/Weekly 의 W_/M_ 합계 토글.
 *   Daily      : D 표시 · W = chkSum · M = chkSum
 *   Weekly     : D 숨김 · W 표시 · M = chkSum
 *   WeeklyISO  : W 이면서 _ISO 접미인 컬럼만 표시 · 그 외(D_/비ISO W_/M_) 숨김
 *   Monthly    : M 만 표시
 * 생성은 항상 D_/W_/M_ 전량, 표시 여부만 토글(AS-IS Columns[i].Visible 상수배열 이식 금지 — 계산 재현).
 * isIso = isIsoWeek(binding). WeeklyISO 분기(AS-IS `Visible = isWeeklyISO`)에서만 쓰인다.
 *   전제: WeeklyISO 는 ISO 캘린더 title SP(SCP0009_..._3SPAN_ISO)로 소싱해 W_ 가 _ISO 접미로 온다.
 *   그 title SP 는 미배포(convert-sp 소관) — 배포·소싱 전까지 비ISO title 데이터엔 _ISO 접미가 없어 표시 대상 0.
 */
export const baseVisibleOf = (
  bucket: BUCKET_TYPE,
  chkSum: boolean,
  kind: DynKind,
  isIso: boolean
): boolean => {
  if (bucket === BUCKET_TYPE.MONTHLY) return kind === 'M';
  if (bucket === BUCKET_TYPE.WEEKLY_ISO) return kind === 'W' && isIso;
  if (bucket === BUCKET_TYPE.WEEKLY) {
    if (kind === 'D') return false;
    if (kind === 'W') return true;
    return chkSum; // M
  }
  // DAILY
  if (kind === 'D') return true;
  return chkSum; // W_/M_ 둘 다 chkSum (AS-IS Daily 분기, W_ visible=true 후 chkSum 으로 덮어씀)
};
