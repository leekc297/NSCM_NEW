export const MENU_ID = 'SCP0001' as const;
export type MENU_ID = typeof MENU_ID;

// BE 프로시저 라우팅 키(SCM_ADM_MNU_BTN_MPG_M.SHT_NM 실측 — site/location/customer/locationOsp).
// vendor 는 Vendor 검색 팝업 전용 시트(PKG_SCM0002.P_SCM0002_GET_VENDOR_POPUP 배선, 05_register.sql).
export enum SHEETS {
  SITE = 'site',
  LOCATION = 'location',
  CUSTOMER = 'customer',
  LOCATION_OSP = 'locationOsp',
  VENDOR = 'vendor',
}

// GET 커서 반환 키(procedures.d.ts o_rc1). SAVE 는 'save' payload 계약(useProcMutation).
export const RESPONSE_SET = { MAIN: 'o_rc1' } as const;

// 하단 탭 순서(activeGrid 라우팅 — 상단 site 는 SITE, 하단 3탭은 아래 순서).
export enum SHEET_INDEX {
  SITE,
  LOCATION,
  CUSTOMER,
  LOCATION_OSP,
}

// 조회조건 라벨(design 02 §4.5 — 문구 역조회 확정 TO-BE LBL). AS-IS ID 직사용 금지(hook #114).
export const LABEL = {
  DIVISION: 'LBL00001', // Div.
  PLANT_VENDOR: 'LBL00004', // Plant/Vendor
  PLANT_SITE: 'LBL00005', // Plant Site
  OSP: 'LBL00006', // OSP
  ACTIVE: 'LBL00007', // Active
  SEARCH: 'LBL00112', // Search
  // 하단 시트 탭 라벨 — AS-IS 시트명(cs:95-98) 문구로 역조회(hook #114). Location/Location(OSP) 는
  // 기존 LBL 부재라 05_register.sql 로 신규 등록(LBL00314/00315 캡션 관례대로 EN/KO/CN 동일 영문).
  // Customer 는 기존 LBL00643(Customer, KO/CN 로컬라이즈 완료) 재사용. 조회조건 OSP(LBL00006) 재사용 폐기.
  TAB_LOCATION: 'LBL01146', // Location
  TAB_CUSTOMER: 'LBL00643', // Customer (기존 라벨 재사용)
  TAB_LOCATION_OSP: 'LBL01147', // Location(OSP)
} as const;

// 메시지 코드. AS-IS MSG_ID 를 직접 쓰지 않고, 문구로 TO-BE SCM_ADM_MSG_M 을 역조회해 확정한
// TO-BE 코드다(hook #114). 주의: 같은 번호라도 TO-BE 의미가 다르다 — iter-2 ora.py 실측 결과
// AS-IS 코드 다수가 TO-BE 에서 부재이거나 의미가 뒤바뀌어 있었다(예: TO-BE MSG00002='Saved
// successfully', AS-IS MSG00129/00130 의미가 TO-BE 에서 서로 반대). 아래는 TO-BE 실측 문구 기준 매핑.
export const MSG = {
  // R-01: 권한 division 0건 → 조회영역 비활성. TO-BE MSG00096 "No permission."
  NO_DIVISION_PERMISSION: 'MSG00096',
  // sub Insert 마스터 미선택(AS-IS MSG00161 등가). TO-BE MSG00014 "No row selected."
  NO_MASTER_SELECTED: 'MSG00014',
  // R-06①: main 편집(dirty) 중 sub 편집 배타. TO-BE MSG00129 "Sheet-specific edit mode notice."
  MAIN_SUB_EDIT_NOTICE: 'MSG00129',
  // R-32: 미저장 변경 중 하단 탭 전환 차단. TO-BE MSG00130 "You have unsaved changes. Switch sheet?"
  SHEET_SWITCH_NOTICE: 'MSG00130',
  // R-06②: 외주 site 는 Location 등록 불가. TO-BE MSG01183 "Outsourcing Vendor locations can not be registered."
  NO_LOCATION_FOR_OSP: 'MSG01183',
  // R-06③: 외주만 Location(OSP) 등록 가능. TO-BE MSG01235 "Only Outsourcing Vendors can register Location (OSP)."
  ONLY_OSP_LOCATION: 'MSG01235',
  // R-26: Rep 'Y' 단일성. TO-BE MSG00028 "Only one record with Rep YN = Y can exist for the same Sales Site."
  REP_SINGLE: 'MSG00028',
  // R-38: customer 신규행 SoldTo/ShipTo 필수. TO-BE MSG01144 "Ship To, Sold To, and Rep Y / N are mandatory columns"
  CUSTOMER_REQUIRED: 'MSG01144',
  // R-34, R-28: 중복 키. TO-BE MSG00060 "Duplicate key exists."
  DUPLICATE_KEY: 'MSG00060',
  // R-33: 필수값 공백({0}=컬럼 라벨). TO-BE MSG00614 "The {0} value is required."
  REQUIRE_VALUE: 'MSG00614',
  // R-31 §6-8② 교정: 붙여넣기 표시명이 콤보 후보에 없음({0}=컬럼 라벨). TO-BE MSG01079 "Not existing {0}."
  PASTE_NOT_FOUND: 'MSG01079',
  NO_CHANGE: 'MSG_NO_CHANGE', // 수정 내용 없음(프레임워크 fallback)
} as const;

// 신규행/파생 하드코딩 division 상수(AS-IS 소스 고정값 — design 01 R-05, 03 R-07). 출처 주석 의무.
export const CONST = {
  AUTOMOTIVE_DIVISION: '40', // AS-IS 하드코딩(자동차전지) — packer suffix 행 조건(R-05·22)
  WARRANTY_OP_GROUP: 'W', // OPERATION_GROUP='W'(Warranty) 행 특례(R-05)
  WARRANTY_LOGISTIC_PLANT: 'A002', // Warranty 행 Logistic Plant 고정(AS-IS dtLogisticW, R-05)
} as const;
