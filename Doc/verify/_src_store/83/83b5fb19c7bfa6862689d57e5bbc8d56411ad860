// ⭐ DMF0042 — 수량 배분·롤업 엔진 (순수함수 — AS-IS spdMain_Changed L1800~2723 1:1. TO-BE 신규 5파일 중 핵심).
//   근거(라인 = AS-IS DMF0042_1_BizPlan.cs 정본):
//     · Business_Plan (정수 long, L1857~2288):
//       - Monthly+M_ 입력(L1862~1918): 상향 롤업만 — 소속 Q_ = 분기 내 M_ 합, 소속 Y_ = 연 내 M_ 합.
//       - Quarterly+Q_ 입력(L1919~2082): 하위 M_ 균등 분할(몫) + 나머지는 마지막 칸 가산 → Y_ 롤업.
//       - Yearly+Y_ 입력(L2083~2287): 하위 M_ 균등 분할 + 나머지 마지막 칸. 실적구간(금주 월요일 이전
//         M_) 은 continue 스킵(L2206/2232 — 분모에서 제외) → Q_ 롤업.
//     · LOC·기타 (실수 double, L2289~2720): 배분 아닌 copy — 하위 M_ 에 동일값 기입(L2394~2403),
//       상위 SUM(Q_·Y_) 도 편집값 **그대로** copy (합산 무의미 — L2341/2503/L2371~2382).
//       금지: 0 기입(연 SUM 이 0.000 으로 깨짐) / Int 반올림(1.27 단가가 1 로 깨짐) — 2026-08-25 실측.
//     · 소수 검사(L1843~1855): Business_Plan + 소수 → 소수부 절삭 + MSG00289(→ TO-BE MSG00679) 안내.
//     · ⚠ CAR/CELL/ENERGY·금액(KRW/USD/SalesAmt) 파생은 FE 계산 금지 — 저장 SP·가격환산 SP 산출 ([14] ⚠).
//   분모 = AS-IS 1:1 (전체 하위 월 분모 + 잠금(실적) 월 기입 스킵 — 사용자 확정 2026-07-15 F-2 ③).
import { EDIT_MEASURE } from '../business-plan.constants';

import {
  type DynTag,
  dynKindOf,
  monthInQuarter,
  monthInYear,
  parseDynTag,
} from './business-plan.editLock';

export interface SpreadResult {
  // binding → 새 값 (입력 셀 자신 포함 — 소수 절삭 반영. null = clear)
  patches: Record<string, number | null>;
  // Business_Plan 소수 입력 절삭 발생 (호출측 MSG00679 안내)
  truncated: boolean;
}

const toNumber = (v: unknown): number => {
  if (v == null || v === '') return 0;
  if (typeof v === 'number') return Number.isFinite(v) ? v : 0;
  if (typeof v !== 'string') return 0; // 객체 등 비정상 입력 = 0 (no-base-to-string 회피)
  const n = Number(v.replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};

// 소속 M_ 목록 (오름차순) — 배분 대상. skipPast 시 실적구간(금주 월요일 이전 월) 제외 (AS-IS Yearly L2206).
const childMonths = (
  parent: DynTag,
  dynBindings: readonly string[],
  thisMonth: string,
  skipPast: boolean
): string[] =>
  dynBindings
    .filter(b => {
      const t = parseDynTag(b);
      if (!t || t.kind !== 'M') return false;
      const belongs = parent.kind === 'Q' ? monthInQuarter(t, parent) : monthInYear(t, parent);
      if (!belongs) return false;
      if (skipPast && b.slice(2) < thisMonth) return false;
      return true;
    })
    .sort();

// 소속 Q_ 목록 (Y_ 롤업 표시용)
const childQuarters = (yTag: DynTag, dynBindings: readonly string[]): string[] =>
  dynBindings.filter(b => {
    const t = parseDynTag(b);
    return !!t && t.kind === 'Q' && t.year === yTag.year;
  });

// 상위 Q_/Y_ binding 탐색
const quarterOf = (mTag: DynTag, dynBindings: readonly string[]): string | undefined =>
  dynBindings.find(b => {
    const t = parseDynTag(b);
    return !!t && t.kind === 'Q' && t.year === mTag.year && t.quarter === mTag.quarter;
  });
const yearOf = (tag: DynTag, dynBindings: readonly string[]): string | undefined =>
  dynBindings.find(b => {
    const t = parseDynTag(b);
    return !!t && t.kind === 'Y' && t.year === tag.year;
  });

/**
 * 셀 입력 → 배분/롤업 patch 산출 (row 는 읽기 전용 — 호출측이 patches 반영 + EditTracker 마킹).
 *   - rowValues: 현재 행 값 (반영 전) / binding: 입력 셀 / value: 입력값
 *   - thisMonth: 금주 월요일의 yyyymm (실적구간 기준 — AS-IS GetThisWeekMonday)
 */
export const applyCellChange = (params: {
  rowValues: Record<string, unknown>;
  binding: string;
  value: unknown;
  measure: string;
  dynBindings: readonly string[];
  thisMonth: string;
}): SpreadResult => {
  const { rowValues, binding, value, measure, dynBindings, thisMonth } = params;
  const tag = parseDynTag(binding);
  const patches: Record<string, number | null> = {};
  if (!tag) return { patches, truncated: false };

  const isBp = measure === EDIT_MEASURE.BUSINESS_PLAN;
  let input = toNumber(value);
  let truncated = false;
  // 소수 검사 — Business_Plan 은 정수만 (L1843~1855 소수부 절삭 + 안내)
  if (isBp && !Number.isInteger(input)) {
    input = Math.trunc(input);
    truncated = true;
  }
  patches[binding] = input;

  // 반영 후 값 조회 헬퍼 (patches 우선)
  const valOf = (b: string): number => (b in patches ? (patches[b] ?? 0) : toNumber(rowValues[b]));

  // 가격류(LOC 등) 상위 SUM — 합산이 무의미해 편집값을 그대로 복사한다 (AS-IS Q_ SetText 취지).
  //   금지: 0 기입 / Int 반올림(Math.round). 2026-08-25 실측 사고 2건 —
  //     · 0 기입   : 편집 즉시 연 SUM 이 0.000 으로 보이고, 되돌려도 0 이 다시 쓰여 수정(M) 이 안 풀림.
  //     · 반올림   : 1.270 셀을 더블클릭했다 그냥 빠져나오기만 해도 Q_ 가 1.000 으로 깨짐.
  //   반올림 없는 copy 는 두 사고를 함께 막는다 — 값을 안 바꿨으면 SUM 도 그대로, 바꾸면 따라간다.
  const rollupQuarter = (mTag: DynTag): void => {
    const q = quarterOf(mTag, dynBindings);
    if (!q) return;
    const qTag = parseDynTag(q)!;
    const months = childMonths(qTag, dynBindings, thisMonth, false);
    patches[q] = isBp ? months.reduce((s, b) => s + valOf(b), 0) : input;
  };
  const rollupYear = (anyTag: DynTag): void => {
    const y = yearOf(anyTag, dynBindings);
    if (!y) return;
    const yTag = parseDynTag(y)!;
    const months = childMonths(yTag, dynBindings, thisMonth, false);
    patches[y] = isBp ? months.reduce((s, b) => s + valOf(b), 0) : input;
  };

  if (tag.kind === 'M') {
    // ── Monthly 입력 — 상향 롤업만 (L1862~1918) ──
    rollupQuarter(tag);
    rollupYear(tag);
    return { patches, truncated };
  }

  if (tag.kind === 'Q') {
    // ── Quarterly 입력 — 하위 M_ 배분 (L1919~2082) ──
    const months = childMonths(tag, dynBindings, thisMonth, false);
    if (months.length > 0) {
      if (isBp) {
        const share = Math.trunc(input / months.length);
        const remnant = input - share * months.length; // 나머지 = 마지막 칸 가산 (L1987~2003)
        months.forEach((m, i) => {
          patches[m] = share + (i === months.length - 1 ? remnant : 0);
        });
      } else {
        months.forEach(m => {
          patches[m] = input; // LOC = 동일값 copy (L2394~2403)
        });
      }
    }
    rollupYear(tag);
    return { patches, truncated };
  }

  // ── Yearly 입력 — 하위 M_ 배분, 실적구간 스킵 (L2083~2287) ──
  const months = childMonths(tag, dynBindings, thisMonth, true);
  if (months.length > 0) {
    if (isBp) {
      const share = Math.trunc(input / months.length);
      const remnant = input - share * months.length;
      months.forEach((m, i) => {
        patches[m] = share + (i === months.length - 1 ? remnant : 0);
      });
    } else {
      months.forEach(m => {
        patches[m] = input;
      });
    }
  }
  // Q_ 롤업 재계산 (L2265~2286) — 연 내 전 분기. 가격류는 위 상위 SUM 규칙대로 편집값 copy
  //   (하위 월 전체가 같은 값이 되므로 분기도 같은 값이다).
  childQuarters(tag, dynBindings).forEach(q => {
    const qTag = parseDynTag(q)!;
    const qMonths = childMonths(qTag, dynBindings, thisMonth, false);
    patches[q] = isBp ? qMonths.reduce((s, b) => s + valOf(b), 0) : input;
  });
  return { patches, truncated };
};

export { dynKindOf };
