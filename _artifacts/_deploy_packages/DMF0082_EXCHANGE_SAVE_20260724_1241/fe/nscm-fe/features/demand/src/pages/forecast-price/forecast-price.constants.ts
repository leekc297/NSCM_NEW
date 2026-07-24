export const MENU_ID = 'DMF0082' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * SHEETS — value = 룰 #91 sheet-name-asis-preserve: **AS-IS 원본 SHEET_NAME** 그대로.
 * ⭐ 2026-07-12 정정: AS-IS(asis.py SCM_MST_SHEET_COLUMNS) = 'FcstNPrice' 실측 → 'FcstNPrice' 로 통일.
 *   (구 값 'fcstNPrice_40'/'fcstNPrice' 소문자 = 룰 #91 이전(2026-05-28 이전) 개발 시 유입된 이관 오류.
 *    직전 세션이 "사내 실측"으로 오적용했으나 룰 #91 기준은 AS-IS 원천. DB 5구간+FE 일괄 정정 완료.)
 * - `FCST_N_PRICE_40` = 메인 조회/저장 sheet (= AS-IS 'FcstNPrice'. enum 키명은 하위호환 유지)
 * - `SPREAD_TITLE`    = `DMF0082_GET_SPREAD_TITLE` 동적 시간축 컬럼 정의
 */
export enum SHEETS {
  FCST_N_PRICE_40 = 'FcstNPrice',
  SPREAD_TITLE = 'spreadTitle',
  // DMF0073_GET_VERSION_SALESPRICE 공유 계약(9-arg) — DB 배선 P1-7 SQL 참조
  //   (DMF0020 version / DMF0074 version 시트와 동일 계약 — Version 선택 POPUP)
  VERSION = 'version',
  // DMF0082_POPUP_GET_FUTUREPRICE_INFO (4 IN + 2 OUT cursor — AS-IS .cs L3166).
  //   P1-7 DB 배선 SQL 에서 등록 예정 — Exchange Rate POPUP
  FUTURE_PRICE_INFO = 'futurePriceInfo',
  // ⭐ SavePricePeriodModal (AS-IS DMF0082_SaveSalesFuturePrice_Popup — Price 기간 일괄저장) 전용 2종.
  //   DB 배선 = DMF0082_P2_savePrice_wiring.sql (PROC_M/API_M/BTN_MPG SHT_NM = 아래 value 그대로).
  //   조회  = DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP (17 IN + O_CURSOR — 실측 2026-07-12)
  //   시간축 = DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE (4 IN + O_RESULT_CURSOR — W_/M_ 컬럼 + 저장 주차 목록)
  //   저장  = 기배선 fcstNPrice SAVE (DMF0082_SAVE_MAIN_DATA 16 IN '^' bulk) 재사용.
  SAVE_PRICE_DATA = 'savePriceData',
  SAVE_PRICE_TITLE = 'savePriceTitle',
}

/**
 * SavePricePeriodModal 고정 컬럼 메타 시트명 — SCM_MST_SHEET_COLUMNS 실측 25 컬럼
 * (PROGRAM_ID='DMF0082' SHEET_NAME='Sales Price Save All' — AS-IS SpdSheet.shtMain 등록명 그대로, 룰 #91).
 */
export const SAVE_PRICE_META_SHEET = 'Sales Price Save All';

/**
 * RESPONSE_SET — `useProcMutation` 의 3 번째 generic 용 단일 멤버.
 * 데이터 접근은 literal cursor 이름 (`data?.fcstNPrice` 등) 으로 수행.
 */
export enum RESPONSE_SET {
  SAVE_RESULT = 'o_rc1',
}

/**
 * Excel 업로드 — SCM_ADM_EXCEL_COLUMNS PROGRAM_ID='DMF0082' SHEET_NAME='FcstNPrice' 실측
 * (HEADER_CONTENT '|' 구분 23 헤더 — Error Detail grid 라벨. 기이관 확인 2026-07-12).
 */
export const UPLOAD_SHEET = 'FcstNPrice' as const;
export const UPLOAD_HEADERS = [
  'Div', 'End Customer', 'Sales Site', 'Model', 'Incoterms', 'FCST Type', 'Customs Handbook',
  'Cell Prod Site', 'Currency', 'Measure', 'M4', 'M5', 'M6', 'M7', 'M8', 'M9', 'M10', 'M11',
  'M12', 'M13', 'M14', 'M15', 'M16',
] as const;

/** AS-IS cboBucketType 3종 (Daily 포함 — 카탈로그 BucketField 는 W/M 만이라 인라인 렌더). */
export const BUCKET_FALLBACK = [
  { label: 'Daily', value: 'D', lblKey: 'LBL00682' },
  { label: 'Weekly', value: 'W', lblKey: 'LBL00683' },
  { label: 'Monthly', value: 'M', lblKey: 'LBL00684' },
] as const;

/**
 * ⭐ 편집 가능 measure (AS-IS bEDIT_AUTH_* 4분기 대상 — L802~825).
 * 실제 편집 허용 여부는 GET drop3 커서(MEASURE+EDIT_FLAG, 사용자 그룹별)가 단일 출처 —
 * 이 집합은 "권한 판정 대상 measure" 화이트리스트 (그 외 measure = 항상 read-only).
 */
export const AUTH_MEASURES = ['SCM_FCST', 'MKT_FCST', 'LOC', 'VMI_In_Req'] as const;

/**
 * AS-IS MSG 매핑 — 사내 MSG_M 실문구 대사 완료 (2026-07-12, fallback 신뢰 금지 룰).
 * AS-IS TB_FX_MessageInfo 원문 16종 ↔ TO-BE SCM_ADM_MSG_M 실측 재매핑:
 *   AS-IS MSG00002→MSG00429 / 00012→00001 / 00259→00662 (동ID 문구 뒤틀림 사고 방지).
 *   MSG00667~671 = 신규 채번 5종 (사내 max=MSG00666 실측 +1, 등록 SQL 동반).
 */
export const MSG = {
  REQUIRED: 'MSG00429', // {0} 값은 필수 입력 항목입니다. (AS-IS MSG00002)
  SAVED: 'MSG00002', // 성공적으로 저장되었습니다. (AS-IS MSG00004 {0}개 저장 대응)
  SAVE_CONFIRM: 'MSG00001', // 저장 하시겠습니까? (AS-IS MSG00012)
  DUP_SAVE_ERROR: 'MSG00043', // 저장시 중복 오류가 발생하였습니다. {0} (동일)
  PERIOD_ORDER: 'MSG00108', // 조회 기간이 잘못되었습니다 (시작일 > 종료일). (동일 의미)
  MANDATORY_COLUMN: 'MSG00113', // 필수 입력 컬럼이 없습니다. (동일)
  PERIOD_3Y: 'MSG00164', // 조회 기간은 3년 이내로 입력해주세요. (동일 의미)
  BUCKET_CHANGE_BLOCK: 'MSG00227', // Insert 된 행이 있어 Bucket 을 변경할 수 없습니다. (동일 의미)
  DUP_NEW_ROW: 'MSG00260', // 중복된 조합이 존재합니다 (Division/Project/Item/일자/Measure). (동일 의미)
  VERSION_REQUIRED: 'MSG00283', // 버전을 선택하세요. (동일)
  VERSION_MAX: 'MSG00255', // 버전은 최대 2개까지 선택 가능합니다. (metal-link/DMF0020 동일 키 재사용)
  EDIT_AFTER_SEARCH: 'MSG00662', // 조회 후 수정모드로 가능합니다. (AS-IS MSG00259)
  DIVISION_NO_AUTH: 'MSG00667', // [신규] 권한을 가진 Division 이 없습니다. (AS-IS MSG00097)
  EDIT_MODE_NO_ACTION: 'MSG00668', // [신규] Edit Mode 에서는 수행할 수 없습니다. (AS-IS MSG00142)
  EDIT_MODE_NO_INPUT: 'MSG00669', // [신규] 수정모드에서는 입력할 수 없습니다. (AS-IS MSG00408)
  QTY_PRICE_REQUIRED: 'MSG00670', // [신규] 추가된 행에 수량/가격 미입력 (AS-IS MSG00449)
  MEASURE_NOT_EDITABLE: 'MSG00671', // [신규] 수정할 수 없는 메져입니다. (AS-IS MSG00464)
  // ── SavePricePeriodModal (AS-IS DMF0082_SaveSalesFuturePrice_Popup MSG 전수 대사 2026-07-12) ──
  //   AS-IS 활성 10종: 00002→00429 / 00004→00672(신규) / 00043 동일 / 00097→00667 / 00108 동일 /
  //   00113 동일(Edit 모드 부재로 TO-BE 미사용) / 00133→00004 / 00137 동일 / 00330·00409 = ID 승계 신규 등록.
  //   MSG00079 는 AS-IS 주석 블록 전용(dead) — 미배선.
  NO_CHANGES: 'MSG00004', // 수정한 내용이 없습니다. (AS-IS MSG00133)
  WORK_IN_PROGRESS: 'MSG00137', // 이전 작업이 아직 실행 중입니다. (동일)
  PERIOD_MONDAY: 'MSG00330', // 기간을 다시 선택하여 주십시오.(월요일) — AS-IS ID 승계 (P2 SQL 등록)
  PAST_PERIOD: 'MSG00409', // 과거 구간은 일괄입력이 불가합니다. — AS-IS ID 승계 (P2 SQL 등록)
  SAVED_COUNT: 'MSG00672', // [신규 채번] {0}개의 데이터가 저장되었습니다. (AS-IS MSG00004)
  // ── ExchangeRateModal ADMIN 편집/저장 (AS-IS DMF0000_ExchangeRatePopup SaveData 2026-07-24) ──
  //   AS-IS MSG00456 원문 1:1 — 사내 부재 → MSG00689 신규 채번 (max=MSG00688+1,
  //   등록 SQL = _artifacts/_apply_corporate/DMF0082_exchange_modal_save_wiring_20260724.sql)
  PRICE_RECALC_DONE: 'MSG00689', // Sales Price Recalculation is complete. (AS-IS MSG00456)
  SAVE_ERROR: 'MSG00618', // 저장 중 오류가 발생했습니다. (SP 원문 메시지 부재 시 fallback — DMF0042 선례)
} as const;

/** ExchangeRateModal 좌측 고정 컬럼 메타 (DMF0020 EXCHANGE_RATE_COLUMNS 표준 1:1 — hook #96 단일문자 정렬코드). */
export interface ExchangeRateColumnMeta {
  key: string;
  header: string;
  width: number;
  align: 'L' | 'C' | 'R'; // RawFlexGridColumnConfig.horzAlgnCd 단일문자 코드 (hook #96)
}

// ExchangeRate POPUP — DMF0020_SalesFuturePricePopUp InitSpread 정밀 매핑 승계
//   (Division=120 / Currency=70 / Unit=50 — 캡쳐 DMF0020_Exchang_rate.png 1:1)
export const EXCHANGE_RATE_COLUMNS: ExchangeRateColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Div', width: 120, align: 'C' },
  { key: 'CURRENCY', header: 'Currency', width: 70, align: 'C' },
  { key: 'UNIT_CURRENCY', header: 'Unit', width: 50, align: 'C' },
];
