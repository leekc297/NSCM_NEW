import {
  BUCKET2_TYPE,
  BUCKET_TYPE,
  DYN_RANK,
  GUBUN,
  type Gubun,
} from '../demand-plan-waterfall.constants';

/**
 * 기간(버킷) 컬럼 종류 — AS-IS 컬럼 tag 규약 (실측):
 *   D_yyyymmdd / W_yyyymm + ISO주차(2) / M_yyyymm / Q_yyyy_q / Y_yyyy
 *   (AS-IS 0035 .cs:1887 `Substring(8)`=주차 · `Substring(2,6)`=yyyymm, 0051 .cs:677-692 Q_/Y_ 조립)
 */
export type DynKind = 'D' | 'W' | 'M' | 'Q' | 'Y';

const KIND_PATTERNS: Array<[DynKind, RegExp]> = [
  ['D', /^D_\d{8}$/],
  ['W', /^W_\d{7,9}$/],
  ['M', /^M_\d{6}$/],
  ['Q', /^Q_\d{4}_\d$/],
  ['Y', /^Y_\d{4}$/],
];

/** binding → kind (기간 컬럼이 아니면 null) */
export const dynKindOf = (binding: string): DynKind | null =>
  KIND_PATTERNS.find(([, re]) => re.test(binding))?.[0] ?? null;

/**
 * 표시 rank (hook #103 §1-2) — 활성 버킷 kind = 표시 / rank 작음(상위) = 합계(Sum 토글) /
 * rank 큼(하위) = 기본 숨김(헤더 더블클릭 드릴로만).
 * @returns 해당 GUBUN 의 버킷 체계에 없는 kind 면 null
 */
export const rankOf = (gubun: Gubun, kind: DynKind | null): number | null => {
  if (!kind) return null;
  const rank = DYN_RANK[gubun][kind];
  return rank === undefined ? null : rank;
};

/**
 * 조회조건 bucket → 활성 kind.
 * ONLY_WEEKLY 는 주 단위 표시라 WEEKLY 와 같은 kind('W')를 쓴다 (헤더 단수만 다름 — UM-09).
 */
export const bucketKindOf = (gubun: Gubun, bucket: string): DynKind => {
  if (gubun === GUBUN.BIZ_PLAN) {
    if (bucket === BUCKET2_TYPE.YEARLY) return 'Y';
    if (bucket === BUCKET2_TYPE.QUARTERLY) return 'Q';
    return 'M';
  }
  if (bucket === BUCKET_TYPE.DAILY) return 'D';
  if (bucket === BUCKET_TYPE.WEEKLY || bucket === BUCKET_TYPE.ONLY_WEEKLY) return 'W';
  return 'M';
};

/**
 * 1단(대분류) 그룹 키 — 라벨이 아니라 binding 에서 뽑는다(동명 라벨 충돌 방지, DMF0003 규약).
 *   MKT·SALES = yyyymm(월) / BIZ = yyyy(연)
 */
export const largeKeyOf = (gubun: Gubun, binding: string): string =>
  gubun === GUBUN.BIZ_PLAN ? binding.slice(2, 6) : binding.slice(2, 8);

/** W_yyyymmWW → 주차 문자열(뒤 2자리). 그 외 kind 는 '' */
export const weekNoOf = (binding: string): string =>
  dynKindOf(binding) === 'W' ? binding.slice(8) : '';

/** D_yyyymmdd → Date (그 외 null) */
export const dayOf = (binding: string): Date | null => {
  if (dynKindOf(binding) !== 'D') return null;
  const y = Number(binding.slice(2, 6));
  const m = Number(binding.slice(6, 8));
  const d = Number(binding.slice(8, 10));
  if (!y || !m || !d) return null;
  return new Date(y, m - 1, d);
};
