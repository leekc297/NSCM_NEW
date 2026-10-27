import { SHEETS } from '../shipment-plan-auto-ess.constants';

// Detail 하위 sheet 탭 순서 (design 01 §1 / 03 §0 — 9 sheetNm 중 탭 노출 7).
//   "Hold stock" 은 AS-IS 임시 hold(표시전용)나 Main BOH 드릴다운 경로가 실재(design 03 §3.7)하므로 탭 노출.
//   "Hold stock Detail" 은 전용 GET SP 미배포(goal.md ② / 03 §6-3) — 탭 제외, 확인필요로 보고.
export const DETAIL_SHEETS: readonly SHEETS[] = [
  SHEETS.PLAN_DETAIL,
  SHEETS.STOCK_DETAIL,
  SHEETS.OWMS_DETAIL,
  SHEETS.HOLD_STOCK,
  SHEETS.MES_STOCK,
  SHEETS.MES_STOCK_DETAIL,
  SHEETS.SHIPMENT_RESULT,
] as const;

// 2차 조회조건(usrLayoutControl3) sheet별 필드셋 (design 01 §2 R3 매트릭스 — Never/Always).
//   SSP0021 은 Product Level·New 버튼이 없다(SSP0060 과 차이). HoldStock 전환 시 매핑 없음 = 직전 유지.
export interface DetailFieldSet {
  period2: boolean; // drpPeriod2 (Shipment Date — PlanDetail 전용)
  period3: boolean; // drpPeriod3 (Shipment Date — ShipmentResult 전용)
  model: boolean; // txtModel2 + btnItemID2
  requestor: boolean; // txtRequestor + btnRequestor
  resultType: boolean; // clbResultType
  boxId: boolean; // txtBoxID (LOT ID)
}

const FIELDSETS: Partial<Record<SHEETS, DetailFieldSet>> = {
  [SHEETS.PLAN_DETAIL]: {
    period2: true,
    period3: false,
    model: true,
    requestor: true,
    resultType: false,
    boxId: false,
  },
  [SHEETS.STOCK_DETAIL]: {
    period2: false,
    period3: false,
    model: true,
    requestor: false,
    resultType: false,
    boxId: false,
  },
  [SHEETS.OWMS_DETAIL]: {
    period2: false,
    period3: false,
    model: true,
    requestor: false,
    resultType: false,
    boxId: false,
  },
  [SHEETS.SHIPMENT_RESULT]: {
    period2: false,
    period3: true,
    model: true,
    requestor: false,
    resultType: true,
    boxId: false,
  },
  [SHEETS.MES_STOCK]: {
    period2: false,
    period3: false,
    model: true,
    requestor: false,
    resultType: false,
    boxId: false,
  },
  [SHEETS.MES_STOCK_DETAIL]: {
    period2: false,
    period3: false,
    model: true,
    requestor: false,
    resultType: false,
    boxId: true,
  },
};

// HoldStock 전환 시 "직전 필드셋 유지"(R3 매핑 없음) — 매핑이 없으면 prev 를 그대로 반환.
export const fieldSetOf = (sheet: SHEETS, prev: DetailFieldSet): DetailFieldSet =>
  FIELDSETS[sheet] ?? prev;

export const INITIAL_FIELDSET: DetailFieldSet = FIELDSETS[SHEETS.PLAN_DETAIL] as DetailFieldSet;

// Main BOH_QTY 더블클릭 드릴다운 분기 (design 03 §3.7 — BOH_TYPE 값 → 대상 sub-sheet).
//   주의: 'MES' 는 이 맵을 타지 않는다 — 페이지 handleMainDrilldown 이 MES Stock Detail + MES Stock
//   2-sheet 연속 조회로 특수 처리한다(AS-IS L2062-2094).
export const BOH_DRILLDOWN: Record<string, SHEETS | undefined> = {
  ERP: SHEETS.STOCK_DETAIL,
  oWMS: SHEETS.OWMS_DETAIL,
  HOLD: SHEETS.HOLD_STOCK,
  MES: SHEETS.MES_STOCK,
};

// Main 데이터 컬럼(D_ 셀) 더블클릭 — MEASURE 값 분기 (design 03 §3.7: measure=SHIP_PLAN → Plan Detail)
export const measureDrilldownOf = (measure: string): SHEETS | undefined => {
  if (measure === 'SHIP_PLAN') return SHEETS.PLAN_DETAIL;
  return undefined;
};
