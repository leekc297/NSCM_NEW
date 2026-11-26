// DMD0001 AS 수요예측 대시보드 — 확정된 산출 규칙(순수 함수·상수).
//   출처: .atlas/uploads/AS수요예측 대시보드 논의_20261105.xlsx > Main 시트 '결정사항'.
//   목업 샘플값(demand-as-dashboard.mock.ts)과 분리한다 — 실제 데이터를 붙일 때 이 규칙을 그대로 쓴다.
//   (각 규칙의 R## 은 Main 시트 원본 행번호)

export type ActionTone = 'keep' | 'review' | 'produce';
export type StatusDot = 'green' | 'orange' | 'red';

export interface ActionResult {
  action: string;
  actionTone: ActionTone;
  status: StatusDot; // 상태 신호등 (Main R19 — 권고 Action 에 종속)
}

// 권고 Action 분류 코드 — 비즈니스 분류(임계값 정책)는 백엔드가 소유해 이 코드로 내려준다.
//   (사용자 결정 2026-11-16: 임계값이 KPI '예상 부족 품목'·Heat Map 등과 공유되므로 한 곳에서 소유)
export type ActionCode = 'PRODUCE' | 'KEEP' | 'REVIEW';

/**
 * actionCode → 표시(라벨·톤·상태 신호등). 비즈니스 분류는 백엔드, 표시 매핑만 FE 가 소유한다.
 *   PRODUCE 생산 필요(red) · KEEP 유지(green) · REVIEW 감산 검토(orange).
 * 상태(신호등)는 actionCode 에서 파생하므로 백엔드가 따로 보낼 필요 없다 (Main R19).
 */
export const ACTION_BY_CODE: Record<ActionCode, ActionResult> = {
  PRODUCE: { action: '생산 필요', actionTone: 'produce', status: 'red' },
  KEEP: { action: '유지', actionTone: 'keep', status: 'green' },
  REVIEW: { action: '감산 검토', actionTone: 'review', status: 'orange' },
};

/**
 * 폴백 — actionCode 미수신 시 Inventory Cover(개월)로 분류 (Main R18 임계값, 백엔드와 동일).
 *   생산 필요 Cover < 12 · 유지 12 ≤ Cover < 24 · 감산 검토 Cover ≥ 24.
 *   결정 문구가 '유지 <24 / 감산 >24'라 경계 24 가 공백 — 24 이상을 감산으로 닫는다.
 */
export const deriveActionCode = (coverMonths: number): ActionCode => {
  if (coverMonths < 12) return 'PRODUCE';
  if (coverMonths < 24) return 'KEEP';
  return 'REVIEW';
};

/** 폴백용 — actionCode 가 없을 때 Cover 로 표시를 산출한다. */
export const deriveAction = (coverMonths: number | null | undefined): ActionResult => {
  if (coverMonths == null || Number.isNaN(coverMonths)) {
    return { action: '-', actionTone: 'keep', status: 'green' }; // 데이터 없음
  }
  return ACTION_BY_CODE[deriveActionCode(coverMonths)];
};

/**
 * Excess (EA) = 현재 재고 − 예상 수요(12M) (Main R32 결정사항).
 *   0 이하면 과재고 없음(null) — 표에는 '–' 로 표기한다.
 * (Excess 금액 = Excess 수량 × 재고단가[SCP_ANL_MONTH_END_STOCK_R] 는 단가 데이터가 필요해
 *  실데이터 연결 후 산출한다. Main R33.)
 */
export const computeExcessEa = (stock: number, demand12m: number): number | null => {
  const excess = stock - demand12m;
  return excess > 0 ? excess : null;
};

// Biz Type (Main R4 결정사항) — SCM_MST_ITEM.MATERIAL_CLASS 기준.
//   모델코드의 Biz Type 속성값은 SCM_MST_ITEM.FORECAST_INFO_BIZ_TYPE 로 확인한다(Main R14).
export const BIZ_TYPE_BY_MATERIAL_CLASS: Record<string, string> = {
  MA01: 'Cell',
  MA02: 'Pack',
  MA03: 'Module',
};
