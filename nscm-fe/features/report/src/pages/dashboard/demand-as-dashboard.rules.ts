// DMD0001 AS 수요예측 대시보드 — 확정된 산출 규칙(순수 함수·상수).
//   출처: .atlas/uploads/AS수요예측 대시보드 논의_20261105.xlsx > Main 시트 '결정사항'.
//   각 위젯의 <widget>.map.ts 가 프로시저 결과를 변환할 때 이 규칙을 그대로 쓴다.
//   (각 규칙의 R## 은 Main 시트 원본 행번호)

export type ActionTone = 'keep' | 'review' | 'produce';
export type StatusDot = 'green' | 'orange' | 'red';

// 권고 Action 분류 코드 — 비즈니스 분류(임계값 정책)는 백엔드가 소유해 이 코드(ACTION_CODE)로 내려준다.
export type ActionCode = 'PRODUCE' | 'KEEP' | 'REVIEW';

// actionCode → 표시(톤·상태 신호등). 색/신호등은 순수 표시라 FE 가 코드 기준으로 매핑한다
//   (사용자 결정 2026-11-23: 색·아이콘·신호등만 FE 매핑 허용). PRODUCE red · KEEP green · REVIEW orange.
export const ACTION_PRESENTATION: Record<ActionCode, { actionTone: ActionTone; status: StatusDot }> = {
  PRODUCE: { actionTone: 'produce', status: 'red' },
  KEEP: { actionTone: 'keep', status: 'green' },
  REVIEW: { actionTone: 'review', status: 'orange' },
};

// actionCode → 라벨 메시지 코드(i18n). 라벨 텍스트는 FE 하드코딩이 아니라 SCM_ADM_MSG_M 에서 해석한다
//   (사용자 결정 2026-11-23). 코드 등록 SQL: .atlas/gscm-design/DMD0001/design/05_register_msg.sql.
export const ACTION_LABEL_CODE: Record<ActionCode, string> = {
  PRODUCE: 'LBL01279',
  KEEP: 'LBL01280',
  REVIEW: 'LBL01281',
};

// t() 2인자 fallback(MSG-03 '_' 접두 — 미등록 상태 식별용). 등록 전까지 화면에 이 문구가 보인다.
export const ACTION_LABEL_FALLBACK: Record<ActionCode, string> = {
  PRODUCE: '_생산 필요',
  KEEP: '_유지',
  REVIEW: '_감산 검토',
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

/**
 * 표시할 actionCode 를 확정한다. ACTION_CODE(SP 분류)가 유효하면 그대로, 없으면 Cover 로 파생,
 *   둘 다 없으면 null(데이터 없음). 라벨 텍스트는 호출부가 i18n 으로 해석한다.
 */
export const resolveActionCode = (
  rawCode: string,
  coverMonths: number | null
): ActionCode | null => {
  if (rawCode === 'PRODUCE' || rawCode === 'KEEP' || rawCode === 'REVIEW') return rawCode;
  if (coverMonths != null && !Number.isNaN(coverMonths)) return deriveActionCode(coverMonths);
  return null;
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
