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
