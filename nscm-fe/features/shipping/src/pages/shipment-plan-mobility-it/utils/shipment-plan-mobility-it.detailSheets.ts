import { SHEETS } from '../shipment-plan-mobility-it.constants';
import type { MainSheet } from '../shipment-plan-mobility-it.types';

// Detail 하위 sheet 탭 순서 (AS-IS SpdDetail sheet 등록 순서 — 00_checklist §0 / design 03 §1.E).
//   아래 DETAIL_SHEETS_MAIN/PACKER 가 실제 노출 탭이다(DETAIL_SHEETS 상수는 레거시 참고용).
//   I11 해소(2026-10-07): W/H stock Detail·Hold stock Detail 은 부모 SP O_RC2, WH In Plan Detail 은
//   GET_SHIPMENT_PSI_COMMENTS(AS-IS FindData_WHinPlanDetail_btnSearch) 로 데이터 배선 완료.
//   'Shipment Request Detail' 은 **AS-IS 가 Main·Packer 양쪽에서 Visible=false(SSP0015.cs L1430·1492)** 로
//   숨긴 시트라 TO-BE 도 미노출이 정답(과구현 금지). 'Stock Detail' 은 MES_STOCK(ADMIN_SHEET_NAME 매핑).
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
  period2: boolean; // drpPeriod2 (Shipment Date — CONFIRM_DETAIL · WH In Plan Detail. AS-IS layoutControlItem11)
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
  // AS-IS L7972-7982: layoutControlItem11(Shipment Date)=Always, Model(item3/4/5)=Always, 나머지 Never.
  //   FindData_WHinPlanDetail_btnSearch(L4645-4646) 가 drpPeriod2(=period2) 를 p_from/to_yyyymmdd 로 넘긴다.
  [SHEETS.WH_IN_PLAN_DETAIL]: { period2: true, period3: false, model: true, lotId: false, requestor: false, resultType: false },
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

// master 기간셀(D_) 더블클릭 → detail sheet 분기 (design 03 §3.F, §4 / AS-IS SpdMain_CellDoubleClick).
//   AS-IS 기간셀 더블클릭이 실제로 조회(FindData_*)하는 측정치는 둘뿐이다(둘 다 열 가드 없음):
//     · SHIP_CONFIRM → FindData_Detail        (shtDetail = Confirm Detail, L8068)
//     · WH_STOCK     → FindData_WHstock        (shtWHstock = W/H stock, L8089)
//   WH_IN 은 드릴이 아니라 Comments(memo) 팝업(L8177 — ShipmentPsiMainGrid dblClick 에서 onMemo 로 처리).
//   MES stock/Hold stock/Balance 드릴(L8111·8134·8155)은 'Figure' 정적 열 클릭 전용(e.Column==FIGURE)이라
//   기간셀 더블클릭에선 AS-IS 가 동작하지 않는다 → 매핑하지 않는다(사용자 결정 2026-10-08 "엄격 AS-IS").
export const measureDrilldownOf = (measure: string): SHEETS | undefined => {
  switch (measure) {
    case 'SHIP_CONFIRM':
      return SHEETS.CONFIRM_DETAIL;
    case 'WH_STOCK':
      return SHEETS.WH_STOCK;
    default:
      return undefined;
  }
};

// BOH 'FIGURE' 정적열 더블클릭 → stock detail 드릴 (AS-IS SpdMain_CellDoubleClick L8109-8173, measure 기준).
//   BOH TYPE(item 병합 라벨)이 'Hold' 인 행 = MES_FCS_RELEASE measure → Hold stock(FindData_block_stock).
//     · MES_FCS_RELEASE → Hold stock(shtBolckStock, GET_BLOCK_STOCK) — L8111
//     · WH_STOCK·BALANCE → Stock Detail(shtMesStock=MES, FindData_mes_stock) — L8134·8155
//   기간셀(measureDrilldownOf)과 다른 열·다른 대상이라 별도 함수로 둔다(사용자 요구 2026-10-08).
export const figureDrilldownOf = (measure: string): SHEETS | undefined => {
  switch (measure) {
    case 'MES_FCS_RELEASE':
      return SHEETS.HOLD_STOCK;
    case 'WH_STOCK':
    case 'BALANCE':
      return SHEETS.MES_STOCK;
    default:
      return undefined;
  }
};
