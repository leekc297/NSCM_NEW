import { SHEETS } from '../shipment-plan-mobility-it.constants';

// Detail 하위 sheet 탭 순서 (AS-IS SpdDetail sheet 등록 순서 — 00_checklist §0 / design 03 §1.E).
//   AS-IS 11 detail sheet 중 UI 트리거·전용 GET SP 가 확인된 주요 7종을 탭으로 노출한다.
//   미노출(확인필요, 04_react-gap.md): 'W/H stock Detail'·'Hold stock Detail'·'Stock Detail'·
//   'Shipment Request Detail'(SSP0026_GET_REQUEST_DETAIL_PACK 별 PKG)·'WH In Plan Detail'
//   — 드릴다운/전용 GET 경로가 이번 회차 미배선(design 03 §1.E 읽기전용 변형).
export const DETAIL_SHEETS: readonly SHEETS[] = [
  SHEETS.CONFIRM_DETAIL,
  SHEETS.WH_STOCK,
  SHEETS.HOLD_STOCK,
  SHEETS.MES_STOCK,
  SHEETS.SCS_STOCK,
  SHEETS.STOCK_LOCATION_DETAIL,
  SHEETS.SHIPMENT_RESULT,
] as const;

// 2차 조회조건(usrLayoutControl3) sheet별 필드셋 (design 02 §1/§4.2)
export interface DetailFieldSet {
  period2: boolean; // drpPeriod2 (Shipment Date — CONFIRM_DETAIL 전용)
  period3: boolean; // drpPeriod3 (Shipment Date — SHIPMENT_RESULT 전용)
  model: boolean; // txtModel2 + btnItemID2
  lotId: boolean; // txtLotID (MES Stock 전용)
  requestor: boolean; // txtRequestor + btnRequestor
  resultType: boolean; // clbResultType (SHIPMENT_RESULT 전용)
}

const FIELDSETS: Partial<Record<SHEETS, DetailFieldSet>> = {
  [SHEETS.CONFIRM_DETAIL]: { period2: true, period3: false, model: true, lotId: false, requestor: true, resultType: false },
  [SHEETS.WH_STOCK]: { period2: false, period3: false, model: true, lotId: false, requestor: false, resultType: false },
  [SHEETS.HOLD_STOCK]: { period2: false, period3: false, model: true, lotId: false, requestor: false, resultType: false },
  [SHEETS.MES_STOCK]: { period2: false, period3: false, model: true, lotId: true, requestor: false, resultType: false },
  [SHEETS.SCS_STOCK]: { period2: false, period3: false, model: true, lotId: false, requestor: false, resultType: false },
  [SHEETS.STOCK_LOCATION_DETAIL]: { period2: false, period3: false, model: true, lotId: false, requestor: false, resultType: false },
  [SHEETS.SHIPMENT_RESULT]: { period2: false, period3: true, model: true, lotId: false, requestor: false, resultType: true },
};

export const INITIAL_FIELDSET: DetailFieldSet = FIELDSETS[SHEETS.CONFIRM_DETAIL] as DetailFieldSet;

export const fieldSetOf = (sheet: SHEETS, prev: DetailFieldSet): DetailFieldSet =>
  FIELDSETS[sheet] ?? prev;

// master 기간셀/드릴다운 → detail sheet 분기 (design 03 §3.F, §4)
//   master 셀 더블클릭은 MEASURE 값으로 대상 detail 시트를 정한다(WH_IN → Confirm Detail 등).
//   AS-IS SpdMain_CellDoubleClick(#22·24·25) — WH_IN 측정치·"WH in Plan" 문자열 가드.
export const measureDrilldownOf = (measure: string): SHEETS | undefined => {
  switch (measure) {
    case 'WH_IN':
      return SHEETS.CONFIRM_DETAIL;
    case 'WH_STOCK':
      return SHEETS.WH_STOCK;
    case 'MES_FCS_HOLD':
    case 'MES_FCS_RELEASE':
      return SHEETS.MES_STOCK;
    default:
      return undefined;
  }
};
