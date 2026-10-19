import { SHEETS } from '../shipment-plan-mobility-it.constants';
import type { MainSheet } from '../shipment-plan-mobility-it.types';

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

// 상단 시트(Main/Packer)별 노출 detail 탭 — AS-IS SpdMain_ActiveSheetChanged(.cs L1392-1500):
//   Main(Mobility & IT) → WH stock/Hold stock/MES 표시, SCS/Stock Location 숨김.
//   Packer → SCS/Stock Location 표시, WH stock/Hold stock/MES 숨김.
//   Confirm Detail·Shipment Result 는 공통 표시(핸들러 미토글).
const DETAIL_SHEETS_MAIN: readonly SHEETS[] = [
  SHEETS.CONFIRM_DETAIL,
  SHEETS.WH_STOCK,
  SHEETS.WH_STOCK_DETAIL,
  SHEETS.HOLD_STOCK,
  SHEETS.HOLD_STOCK_DETAIL,
  SHEETS.MES_STOCK, // 표시명 'Stock Detail'
  SHEETS.WH_IN_PLAN_DETAIL,
  SHEETS.SHIPMENT_RESULT,
];
const DETAIL_SHEETS_PACKER: readonly SHEETS[] = [
  SHEETS.CONFIRM_DETAIL,
  SHEETS.SCS_STOCK,
  SHEETS.STOCK_LOCATION_DETAIL,
  SHEETS.SHIPMENT_RESULT,
];
export const detailSheetsFor = (mainSheet: MainSheet): readonly SHEETS[] =>
  mainSheet === 'packer' ? DETAIL_SHEETS_PACKER : DETAIL_SHEETS_MAIN;

// 2차 조회조건(usrLayoutControl3) sheet별 필드셋 (design 02 §1/§4.2)
export interface DetailFieldSet {
  period2: boolean; // drpPeriod2 (Shipment Date — CONFIRM_DETAIL 전용)
  period3: boolean; // drpPeriod3 (Shipment Date — SHIPMENT_RESULT 전용)
  model: boolean; // txtModel2 + btnItemID2
  lotId: boolean; // txtLotID (MES Stock 전용)
  requestor: boolean; // txtRequestor + btnRequestor
  resultType: boolean; // clbResultType (SHIPMENT_RESULT 전용)
}

// AS-IS SpdDetail_ActiveSheetChanged(SSP0015_ShipmentPSI.cs L7908) 전수 대조 — 시트별 layoutControlItem
//   Visible 토글 그대로. 단, Search 버튼(item3)은 AS-IS 가 Hold stock 에서 숨기지만 UX상 항상 유지한다
//   (ShipmentPsiDetailBar 는 조건 필드셋과 무관하게 Search 버튼 상시 렌더 — 의도적 divergence).
const FIELDSETS: Partial<Record<SHEETS, DetailFieldSet>> = {
  [SHEETS.CONFIRM_DETAIL]: { period2: true, period3: false, model: true, lotId: false, requestor: true, resultType: false },
  [SHEETS.WH_STOCK]: { period2: false, period3: false, model: true, lotId: false, requestor: false, resultType: false },
  // Hold stock — AS-IS L7920~7929 전부 Never: 조건 필드(Model 포함) 전량 숨김(master 활성행 Insert 로 채우는 편집 탭).
  //   Search 버튼만 예외로 유지(위 주석).
  [SHEETS.HOLD_STOCK]: { period2: false, period3: false, model: false, lotId: false, requestor: false, resultType: false },
  [SHEETS.MES_STOCK]: { period2: false, period3: false, model: true, lotId: true, requestor: false, resultType: false },
  [SHEETS.SCS_STOCK]: { period2: false, period3: false, model: true, lotId: false, requestor: false, resultType: false },
  [SHEETS.STOCK_LOCATION_DETAIL]: { period2: false, period3: false, model: true, lotId: false, requestor: false, resultType: false },
  [SHEETS.SHIPMENT_RESULT]: { period2: false, period3: true, model: true, lotId: false, requestor: false, resultType: true },
  // drill/서브 detail(읽기전용) — Model 검색만 노출
  [SHEETS.WH_STOCK_DETAIL]: { period2: false, period3: false, model: true, lotId: false, requestor: false, resultType: false },
  [SHEETS.HOLD_STOCK_DETAIL]: { period2: false, period3: false, model: true, lotId: false, requestor: false, resultType: false },
  [SHEETS.WH_IN_PLAN_DETAIL]: { period2: false, period3: false, model: true, lotId: false, requestor: false, resultType: false },
};

export const INITIAL_FIELDSET: DetailFieldSet = FIELDSETS[SHEETS.CONFIRM_DETAIL] as DetailFieldSet;

export const fieldSetOf = (sheet: SHEETS, prev: DetailFieldSet): DetailFieldSet =>
  FIELDSETS[sheet] ?? prev;

// AS-IS 하단 SUM footer(InitSpreadFooterSum L987 / _Detail L9328) 시트별 합산 대상 컬럼.
//   AS-IS 는 시트별 컬럼 인덱스 범위에 AggregationType.SumIgnoreHidden 을 건다 = 그 범위의 "가시 숫자(FPNumber)"
//   컬럼만 실제 합산된다. 범위 경계(예: Confirm=MTK_OWNER+2..SHIPMENT_DATE, W/H stock=SOC+1..end,
//   Hold=RELEASE_YYYYMMDD+1..REMARKS, MES=LOT_TYPE+1..AVAILABLE_YN)를 SCM_MST_SHEET_COLUMNS 실측 컬럼
//   순서/타입(FPNumber·VISIBLE)에 대조해 확정(DB 실측 2026-09-30). footer 없는 시트(SCS/Stock Location/
//   WH In Plan/Shipment Result)는 등재하지 않는다 = AS-IS InitSpreadFooterSum 미호출.
export const FOOTER_SUM_COLUMNS: Partial<Record<SHEETS, readonly string[]>> = {
  [SHEETS.CONFIRM_DETAIL]: ['SHIPMENT_CONFIRM_QTY'],
  [SHEETS.WH_STOCK]: [
    'STOCK_QTY', 'AVAILABLE_QTY', 'UNDECIDED_QTY', 'ALLOCATION_QTY', 'HOLD_QTY',
    'PACKING_QTY', 'MOVING_QTY', 'RECEIVING_QTY', 'EXPIRATION_QTY', 'LONG_TERM_QTY',
  ],
  [SHEETS.WH_STOCK_DETAIL]: [
    'STOCK_QTY', 'AVAILABLE_QTY', 'UNDECIDED_QTY', 'ALLOCATION_QTY', 'HOLD_QTY',
    'PACKING_QTY', 'MOVING_QTY', 'RECEIVING_QTY', 'EXPIRATION_QTY', 'LONG_TERM_QTY',
  ],
  [SHEETS.HOLD_STOCK]: ['HOLD_QTY'],
  [SHEETS.HOLD_STOCK_DETAIL]: ['HOLD_QTY'],
  [SHEETS.MES_STOCK]: [
    'LOT_QTY_MES', 'LOT_QTY_MES_NG', 'LOT_QTY_FCS', 'FCS_SPECIAL_QTY', 'OWMS_STOCK_QTY', 'LOT_QTY_TOT',
  ],
};

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
