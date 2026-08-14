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
  // Column/Measure Setting 개인화 영구 저장 (공유 모달이 리터럴 'titleSet' 으로 호출 —
  //   `@master/components/columnSettingModal` :96 / `columnLayoutModal` :108).
  //   화면 코드가 직접 참조하진 않지만 BTN_MPG(titleSet SEARCH/SAVE) 배선의 소유 시트이므로 등재한다
  //   (미등재 시 배선 체커 L7 이 "FE SHEETS 미사용" 으로 잡는다. sales-plan/sales-reports 등 동일 규약).
  TITLE_SET = 'titleSet',
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
  'Div',
  'End Customer',
  'Sales Site',
  'Model',
  'Incoterms',
  'FCST Type',
  'Customs Handbook',
  'Cell Prod Site',
  'Currency',
  'Measure',
  'M4',
  'M5',
  'M6',
  'M7',
  'M8',
  'M9',
  'M10',
  'M11',
  'M12',
  'M13',
  'M14',
  'M15',
  'M16',
] as const;

export const TEMPLATE_EXCEL_PREFIX = 'DMF0082_Template';

/** AS-IS cboBucketType 3종 (Daily 포함 — 카탈로그 BucketField 는 W/M 만이라 인라인 렌더). */
export const BUCKET_FALLBACK = [
  { label: 'Daily', value: 'D', lblKey: 'LBL00682' },
  { label: 'Weekly', value: 'W', lblKey: 'LBL00683' },
  { label: 'Monthly', value: 'M', lblKey: 'LBL00684' },
] as const;

/**
 * ⭐ 편집 전용 콤보 (AS-IS `UP_FX_GetCommonDataList(_DM)` 계통 이식 — 2026-08-08).
 *
 * AS-IS 는 **조회 표시**와 **편집 후보**를 다른 원천에서 얻는다. TO-BE 는 표시용 콤보를
 * `SHEET_COLUMNS.CELL_COMBO_DATA_TYPE` 메타로 바인딩하고, 편집 진입(`beginningEdit`) 시에만
 * 아래 편집판으로 dataMap 을 스왑한 뒤 편집 종료(`cellEditEnded`)에 원복한다.
 *
 * ⚠️ **메타를 편집판으로 바꾸면 안 된다.** 편집 후보 ⊊ 표시 후보이므로, 메타를 바꾸면 원장에 남아 있는
 *   폐지 코드 행이 CODE→NAME 변환에 실패해 raw 코드로 표시된다(정본 DMF0003 이 이원화한 이유).
 *   부수 효과로 공유 CMBO 소비 화면(Incoterms 36시트 / DOM_EXP 13시트 / DeptId 13시트) 회귀도 0이 된다.
 *
 * - `INCOTERMS`  : AS-IS `GetLookupValues("INCOTERMS","ALL","Y")` = `ATTRIBUTE2='Y'`(EDIT_YN) 한정.
 *                  표시용 `Incoterms` 는 VALID 16종 전부라 폐지 6종까지 선택 가능했다
 *                  (AS-IS 수정건 [E20250919-001699] 회귀분).
 * - `DOM_EXP`    : AS-IS `UP_FX_GetCommonDataList_DM @Code='DM_CUSTOMS_HANDBOOK'` = lookup
 *                  `DM_CUSTOMS_HANDBOOK_40`. 표시용 `DOM_EXP`(lookup 'DOM/EXP')는 코드 도메인이 더 넓다.
 *
 * ⛔ `TEAM_ID` 는 **대상 아님**(2026-08-08 판정). AS-IS 는 `Data.UserTeamByDivisionAuth`(권한 4분기)로
 *   셀 콤보를 구성하지만, TO-BE 는 TEAM_ID 를 저장하지 않는다 — `PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA`
 *   IN 17종에 teamId 없음(실측) = 조회 결과에서 파생되는 **표시 전용** 컬럼.
 *   저장되지 않는 컬럼에 권한 필터를 걸면 이득 없이 위험만 생긴다: `TeambyDivisionAuth` 실측 행수는
 *   hongjae.kim 0 / jiwon.park 3 / wonqthanq 0 / bpark416 0 / minyonglee1 29 로, 다수 계정에서 0행이라
 *   빈 콤보가 된다. → 표시용 `DeptId` 유지.
 *
 * ⭐ `divisions` — **AS-IS 가 적용하던 범위에만 적용한다**(2026-08-08 원장 실측 근거).
 *   AS-IS DMF0082 는 division 40 전용 화면이었고, INCOTERMS EDIT_YN / DM_CUSTOMS_HANDBOOK_40 은
 *   40 을 전제로 큐레이션된 목록이다. TO-BE 확장분(81/82)에 그대로 걸면 **실제로 쓰는 코드가 막힌다**:
 *     · 81 원장 INCOTERMS 76.9만 행 중 14.9만(19%)이 EDIT_YN='N' (Z02 14.4만 · Z01 · Z04 · A01 · DAT)
 *     · DOM_EXP: 40 은 'E' 뿐이지만 81 은 'D' 1.7만 행, 82 는 'D' 2,034 행 보유
 *   → 40 만 AS-IS 큐레이션 적용, 81/82 는 표시용 전체 목록 유지(확장 영역 = AS-IS 규칙 부재).
 *   권한 필터(TEAM_ID)는 코드 큐레이션이 아니라 사용자 권한이므로 전 division 적용.
 */
export const GRID_EDIT_COMBO: Record<
  string,
  { comboId: string; divisionParam?: boolean; rowFilterKey?: string; divisions?: string[] }
> = {
  INCOTERMS: { comboId: 'IncotermsEdit', divisions: ['40'] },
  DOM_EXP: { comboId: 'CustomsHandbook', divisions: ['40'] },
  // PLANT_SITE_ID(81 계열 전용, SAVE IN `plantSite`) — 표시용 메타 경로는 @divisionId 미전달이라
  //   관대형 폴백으로 **전 division 플랜트**가 뜬다. 편집 진입 시에만 division 한정 목록으로 스왑.
  //   (AS-IS `Data.UserPlantSiteByDivision` 호출은 주석 상태[C20200525-000296]이므로 TO-BE 확장 영역 —
  //    표시용은 건드리지 않아 기존 값의 명칭 변환은 그대로 유지된다.)
  PLANT_SITE_ID: { comboId: 'PlantByDivisionCompany', divisionParam: true },
};

/**
 * PRICE 계열 measure — CURRENCY 입력 대상 (AS-IS `NO_DATA` 분기, .cs L5628/L5639).
 * AS-IS 는 Insert 행 MEASURE 가 LOC 계열이면 `CURRENCY_LIST`, 아니면 `NO_DATA`(빈 목록)로 콤보를 교체해
 * 통화 입력 자체를 막는다. `utils/forecast-price.validate.ts` 의 정방향 검증과 짝을 이룬다.
 */
export const PRICE_MEASURES = ['LOC', 'KRW', 'USD'] as const;

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
  // ── ForecastTemplateModal (Excel Form) 조회 — P_DMF0082_GET_EXCEL_UPLOAD_DATA 0건
  //   (SP BODY L5040 'NO EXCEL DATA' 의미역. 사내 max=MSG00704 실측 +1 신규 채번, 3점 동기 2026-08-12) ──
  /** [E20260813] Excel Form 0건 — 조회조건 기준 조회이므로 '업로드분 없음'(MSG00705)과 의미가 다르다. */
  EXCEL_FORM_EMPTY: 'MSG00718',
  UPLOAD_PREVIEW_EMPTY: 'MSG00705', // 업로드된 Excel 데이터가 없습니다. Excel Upload 후 조회하세요.
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
