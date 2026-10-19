import { SHEETS } from '../shipment-plan.constants';

// Detail 하위 sheet 탭 순서 (AS-IS SpdSheet 등록 순서 — 00_checklist §0).
//   "Hold stock" 은 CreateSpread 상 주석처리(02 §4.1-2)였으나 Main BOH 드릴다운·Insert·Edit
//   코드 경로가 실재(03 §1.3/§3-E/F)하므로 탭으로 노출한다.
//   "Hold stock Detail" 은 UI 트리거·전용 GET SP 모두 미발견(03 §6-5) — 탭 제외, 확인필요로 보고.
export const DETAIL_SHEETS: readonly SHEETS[] = [
  SHEETS.PLAN_DETAIL,
  SHEETS.STOCK_DETAIL,
  SHEETS.OWMS_DETAIL,
  SHEETS.HOLD_STOCK,
  SHEETS.MES_STOCK,
  SHEETS.MES_STOCK_DETAIL,
  SHEETS.SHIPMENT_RESULT,
] as const;

// 2차 조회조건(usrLayoutControl3) sheet별 필드셋 (design 01 R1/R1a~R1f — Designer 실측 기준):
//   1차(usrLayoutControl2)의 Model 은 txtItemId+btnItemId, 2차의 Model 은 txtModel2+btnItemID2 다
//   (01 §1 좌표 실측 — 02 §1 표의 row 표기와 어긋나는 부분은 Designer 좌표를 정본으로 따른다).
//   HoldStock 전환 시 매핑 없음 = 직전 상태 유지(R1f — AS-IS dead code 실동작 재현).
export interface DetailFieldSet {
  period2: boolean; // drpPeriod2 (Shipment Date — PlanDetail 전용)
  period3: boolean; // drpPeriod3 (Shipment Date — ShipmentResult 전용)
  model: boolean; // txtModel2 + btnItemID2
  productLevel1: boolean; // clbProductLevel12
  requestor: boolean; // txtRequestor + btnRequestor
  resultType: boolean; // clbResultType
  boxId: boolean; // txtBoxID
  newButton: boolean; // btnNew
}

const FIELDSETS: Partial<Record<SHEETS, DetailFieldSet>> = {
  [SHEETS.PLAN_DETAIL]: {
    period2: true,
    period3: false,
    model: true,
    productLevel1: true,
    requestor: true,
    resultType: false,
    boxId: false,
    newButton: true,
  },
  [SHEETS.STOCK_DETAIL]: {
    period2: false,
    period3: false,
    model: true,
    productLevel1: true,
    requestor: false,
    resultType: false,
    boxId: false,
    newButton: false,
  },
  [SHEETS.OWMS_DETAIL]: {
    period2: false,
    period3: false,
    model: true,
    productLevel1: true,
    requestor: false,
    resultType: false,
    boxId: false,
    newButton: false,
  },
  [SHEETS.SHIPMENT_RESULT]: {
    period2: false,
    period3: true,
    model: true,
    productLevel1: true,
    requestor: false,
    resultType: true,
    boxId: false,
    newButton: false,
  },
  [SHEETS.MES_STOCK]: {
    period2: false,
    period3: false,
    model: true,
    productLevel1: true,
    requestor: false,
    resultType: false,
    boxId: false,
    newButton: false,
  },
  [SHEETS.MES_STOCK_DETAIL]: {
    period2: false,
    period3: false,
    model: true,
    productLevel1: true,
    requestor: false,
    resultType: false,
    boxId: true,
    newButton: false,
  },
};

// R1f: HoldStock 전환 시 "직전 필드셋 유지" — 매핑이 없으면 prev 를 그대로 반환한다.
export const fieldSetOf = (sheet: SHEETS, prev: DetailFieldSet): DetailFieldSet =>
  FIELDSETS[sheet] ?? prev;

export const INITIAL_FIELDSET: DetailFieldSet = FIELDSETS[SHEETS.PLAN_DETAIL] as DetailFieldSet;

// Main BOH_QTY 더블클릭 드릴다운 분기 (03 §3-D — BOH_TYPE 값 → 대상 sub-sheet).
//   BOH_TYPE 는 SEQ 매핑(11=BOH/9=ERP/7=oWMS/8=MES, PKG BODY L3428~3434 실측).
//   'BOH'(기초재고) 는 AS-IS 분기 대상 4종(ERP/oWMS/HOLD/MES) 밖 — 드릴다운 없음.
//   주의: 'MES' 는 이 맵을 타지 않는다 — 페이지 handleMainDrilldown 이 MES Stock Detail +
//   MES Stock 2-sheet 연속 조회로 특수 처리한다(AS-IS L2356~2366, gap-audit I10).
export const BOH_DRILLDOWN: Record<string, SHEETS | undefined> = {
  ERP: SHEETS.STOCK_DETAIL,
  oWMS: SHEETS.OWMS_DETAIL,
  HOLD: SHEETS.HOLD_STOCK,
  MES: SHEETS.MES_STOCK,
};

// Main 데이터 컬럼(D_ 셀) 더블클릭 — MEASURE 값 분기 (03 §3-D)
export const measureDrilldownOf = (measure: string, toSite: string): SHEETS | undefined => {
  if (measure === 'SHIP_PLAN') return SHEETS.PLAN_DETAIL;
  if (measure === 'SHIP_PLAN_DETAIL' && toSite.trim() !== '') return SHEETS.PLAN_DETAIL;
  if (measure === 'SHIP_RESULT' && toSite.trim() !== '') return SHEETS.SHIPMENT_RESULT;
  return undefined;
};
