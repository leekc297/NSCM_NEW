// SCP0025 그리드 가시성 순수 함수 — 전 컬럼 read-only(LockColumn all, gridSignals #43)라 편집잠금 판정은 없다.
//   EE 조건부 컬럼(design 03 §2.7) + bucket×chkSum pivot 가시성(design 03 §2.6) + pivot 분류만 담당.

import { BUCKET_TYPE, EE_DIVISION_GROUP, EE_ONLY_COLUMNS } from '../shipment-plan-fix.constants';

// division EE 여부 — FN_GET_DIVISION_DIV('EE') 실측 목록 멤버십(design 03 §2.7 — 프리픽스 근사 아님, 목록 정확 판정).
export const isEeDivision = (division: string): boolean =>
  (EE_DIVISION_GROUP as readonly string[]).includes((division ?? '').toUpperCase());

// ===== pivot 컬럼 분류 (D_/W_/M_) — design 03 §2.2 colId 규칙 =====
export type PivotKind = 'D' | 'W' | 'M' | null;
export const pivotKind = (binding: string): PivotKind => {
  if (/^D_/.test(binding)) return 'D';
  if (/^W_/.test(binding)) return 'W';
  if (/^M_/.test(binding)) return 'M';
  return null;
};
export const isPivotColumn = (binding: string): boolean => pivotKind(binding) !== null;

// ===== bucket × chkSum → pivot 가시성 (design 03 §2.6 — 재조회 아님, visible 토글) =====
//   Daily : D_ 표시 / W_·M_(SUM 롤업) = chkSum
//   Weekly: W_ 표시 / M_ = chkSum / D_ 숨김
//   Monthly: M_ 표시 / D_·W_ 숨김
//   GET SP 가 Bucket 파라미터 없이 D_/W_/M_ 전량 반환하므로(§2.2) 토글만으로 처리.
export const isPivotVisible = (binding: string, bucket: BUCKET_TYPE, chkSum: boolean): boolean => {
  const kind = pivotKind(binding);
  if (kind === null) return false;
  if (bucket === BUCKET_TYPE.DAILY) {
    if (kind === 'D') return true;
    return chkSum; // W_/M_ SUM 롤업
  }
  if (bucket === BUCKET_TYPE.WEEKLY) {
    if (kind === 'D') return false;
    if (kind === 'W') return true;
    return chkSum; // M_
  }
  // Monthly
  return kind === 'M';
};

// ===== 고정 컬럼 조건 가시성 (design 03 §2.7 gridSignals #2~#7 R-D) =====
//   ELECTRODE_TYPE / ORIGIN_TO_DIVISION_ID / ORIGIN_FROM_DIVISION_ID = EE division 만 표시(세 컬럼 함께 on/off).
export interface VisibilityContext {
  division: string;
}
export const isFixedColumnVisible = (colName: string, ctx: VisibilityContext): boolean => {
  if ((EE_ONLY_COLUMNS as readonly string[]).includes(colName)) return isEeDivision(ctx.division);
  return true;
};
