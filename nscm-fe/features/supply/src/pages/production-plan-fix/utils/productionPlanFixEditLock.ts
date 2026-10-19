// SCP0024 그리드 편집잠금 white-list + 컬럼 가시성 (design 03 §2.4/§2.5/§3-보강).
//   순수 함수 — 조회직후 grid 전체 readOnly(LockColumn 전 컬럼, gridSignals #27), 편집 band 만 해제.
//   편집 band = D_(일자) 기간 컬럼 × Prod Plan measure 행 QTY 셀(SAVE SP 실측 확정, design 03 §3-보강).
//   W_/M_(SUM 롤업)·Fix Reason 행·과거 구간은 편집 불가.

import {
  BUCKET_TYPE,
  DIVISION_EE_PREFIX,
  EE_ONLY_COLUMNS,
  MEASURE_PROD_PLAN,
} from '../production-plan-fix.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// division EE 여부 — 앞2자 'EE'(design 03 §2.5 — ORIGIN_DIVISION_ID/ELECTRODE_TYPE 조건부 visible).
//   AS-IS 원식 확정(gap-resolve iter-2): InitSpread cs:473 `!_division.Substring(0, 2).Equals("EE")` 로
//   두 컬럼 visible 을 함께 on/off — 이 판정식은 근사가 아니라 정확 재현이다(design 03 §6 #2 해소).
export const isEeDivision = (division: string): boolean =>
  division.slice(0, 2).toUpperCase() === DIVISION_EE_PREFIX;

// ===== pivot 컬럼 분류 (D_/W_/M_) — design 03 §2.1 colId 규칙 =====
export type PivotKind = 'D' | 'W' | 'M' | null;
export const pivotKind = (binding: string): PivotKind => {
  if (/^D_/.test(binding)) return 'D';
  if (/^W_/.test(binding)) return 'W';
  if (/^M_/.test(binding)) return 'M';
  return null;
};
export const isPivotColumn = (binding: string): boolean => pivotKind(binding) !== null;

// ===== bucket × chkSum → pivot 가시성 (design 03 §2.4 — 재조회 아님, visible 토글) =====
//   Daily : D_ 표시 / W_·M_(SUM 롤업) = chkSum
//   Weekly: W_ 표시 / M_ = chkSum / D_ 숨김
//   Monthly: M_ 표시 / D_·W_ 숨김
//   GET SP 가 Bucket 파라미터 없이 D_/W_/M_ 전량 반환하므로(§2.4) 토글만으로 처리.
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

// ===== 편집 band 판정 — design 03 §3-보강 (SAVE SP 실측 확정) =====
//   편집가능 셀 = D_(일자) 컬럼 × Prod Plan measure 행 QTY 셀만. W_/M_(SUM 롤업)·Fix Reason 행 잠금.
//   주의: 과거 구간(cutoff 이전) 편집잠금은 AS-IS .cs 부재로 미확정(design 03 §6 #6). react-gap-audit E1 지적대로
//     iter-1 이 DMF0082 차용으로 신설한 thisWeekMonday/isPastPivot 은 근거가 없어 제거했다 — 근거 확정 전 임의 잠금 금지.
//     과거 구간을 잠글지/회색 표시할지는 AS-IS 소스 확보 후 재결정(확인필요).
export const isProdPlanRow = (row: Row): boolean => s(row.MEASURE) === MEASURE_PROD_PLAN;

// pivot 셀 편집 판정 — D_ 컬럼 + Prod Plan 행(design 03 §3-보강). 과거 cutoff 잠금은 근거 부재로 미적용(E1).
export const isPivotCellEditable = (binding: string, row: Row): boolean => {
  if (pivotKind(binding) !== 'D') return false; // D_(일자)만 편집, W_/M_ SUM 롤업 잠금
  if (!isProdPlanRow(row)) return false; // Prod Plan 행만(Fix Reason 행 잠금)
  return true;
};

// ===== 고정 컬럼 조건 가시성 (design 03 §2.5 gridSignals #3~#6) =====
//   ORIGIN_DIVISION_ID / ELECTRODE_TYPE = EE division 만 표시(두 컬럼 함께 on/off). 그 외는 기본 가시성.
export interface VisibilityContext {
  division: string;
}
export const isFixedColumnVisible = (colName: string, ctx: VisibilityContext): boolean => {
  if ((EE_ONLY_COLUMNS as readonly string[]).includes(colName)) return isEeDivision(ctx.division);
  return true;
};
