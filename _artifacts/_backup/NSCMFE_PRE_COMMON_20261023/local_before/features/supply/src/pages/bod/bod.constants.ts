export const MENU_ID = 'SCP0007' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  BOD = 'bod',
  // AS-IS GetData_Country()/SetCityCode() 캐시 원천(SCP.SCP0007_GET_COUNTRY_CITY/GET_ROUTE_CNT).
  // 버튼/API 미배선 상태(design/05_register.sql 작성, DB 미적용 — 확인필요) — 등록 전에는
  // useTabProcQuery 가 -9997 No Permission 로 실패한다.
  COUNTRY_CITY = 'countryCity',
  ROUTE_CNT = 'routeCnt',
}

export enum RESPONSE_SET {
  // TODO: BE MyBatis resultMap 키 확인 후 확정 (AS-IS SCP.SCP0007_GET_BOD 반환 컬럼셋 기준 추정).
  DATA = 'o_rc1',
}

/**
 * 그리드 바인딩 — AS-IS DefColumns struct(SCP0007_BOD.cs L94-146) 1:1.
 * procedures.d.ts SCP0007.bod.response.o_rc1 과 반드시 동기 유지.
 */
export const BOD_COLUMN = {
  BOD_ID: 'BOD_ID',
  DIVISION_ID: 'DIVISION_ID',
  CUSTOMER: 'CUSTOMER',
  // AS-IS DefColumns.CUSTOMER_CODE(SCP0007_BOD.cs L101) — 그리드 표시 흔적 없는 legacy 필드로 보이나
  // 컬럼 정의 자체는 존재해 procedures.d.ts 응답에도 반영(04_impl-gap-audit.md #11).
  CUSTOMER_CODE: 'CUSTOMER_CODE',
  INCOTERMS: 'INCOTERMS',
  INCOTERMS_SSP: 'INCOTERMS_SSP',
  FROM_SITE_CODE: 'FROM_SITE_CODE',
  TO_SITE_CODE: 'TO_SITE_CODE',
  TRANSPORT_MODE: 'TRANSPORT_MODE',
  PRIORITY: 'PRIORITY',
  ROUTE_ID: 'ROUTE_ID',
  BOD_VALID: 'BOD_VALID', // 저장 시 SP 파라미터는 p_valid_yn (컬럼명≠파라미터명, SaveData_Main L765)
  ROUTE_VALID: 'ROUTE_VALID',
  FROM_COUNTRY: 'FROM_COUNTRY',
  FROM_CITY: 'FROM_CITY',
  TO_COUNTRY: 'TO_COUNTRY',
  TO_CITY: 'TO_CITY',
  SAFETY_STOCK: 'SAFETY_STOCK',
  ROUTE_CNT: 'ROUTE_CNT',
  VMI_YN: 'VMI_YN',
  LEAD_TIME: 'LEAD_TIME',
  DIS_TOTAL_LEAD_TIME: 'DIS_TOTAL_LEAD_TIME',
  ROUTE_CHK: 'ROUTE_CHK',
  LT_TYPE: 'LT_TYPE',
  FROM_YYYYMMDD: 'FROM_YYYYMMDD',
  TO_YYYYMMDD: 'TO_YYYYMMDD',
  BEFORE_LEAD_TIME: 'BEFORE_LEAD_TIME',
  AFTER_LEAD_TIME: 'AFTER_LEAD_TIME',
  REMARKS: 'REMARKS',
} as const;

/** 요일별 운송가능 Y/N 7컬럼 — Route 선택 팝업이 주입(AS-IS DAYS_MON~DAYS_SUN). */
export const DAY_OF_WEEK_COLUMNS = [
  'DAYS_MON',
  'DAYS_TUE',
  'DAYS_WED',
  'DAYS_THU',
  'DAYS_FRI',
  'DAYS_SAT',
  'DAYS_SUN',
] as const;

/** Valid YN 콤보 — AS-IS cboValidYN (Y/N 고정값, DB 콤보 아님). */
export const VALID_YN_OPTIONS = [
  { label: 'Y', value: 'Y' },
  { label: 'N', value: 'N' },
] as const;

/**
 * Input Status 콤보 — SP/DB 콤보 아님. AS-IS InitControls()가 코드에서 만든 정적 2행
 * (SCP0007_BOD.cs L217-223). 기본값은 'C'(Completed) — L223 cboInputStatus.SelectedValue.
 */
export const INPUT_STATUS_OPTIONS = [
  { label: 'Required', value: 'R' },
  { label: 'Completed', value: 'C' },
] as const;
export const DEFAULT_INPUT_STATUS = 'C';

/**
 * 검색조건 8개 중 콤보 원천(SQL_ID)이 필요한 5개. AS-IS Data.Common/Data_SCP.CommonAll 호출을
 * MDU_DIVS_CD 는 BE 미참조(순수 분류 태그) 확인 — 'DM' 태그라도 SCP 화면에서 호출 가능.
 */
export const BOD_COMBO_ID = {
  // SCP 표준 Division_SCP(AS-IS UP_FX_GetCommonDataList_SCP @Code='Division' 이관 — 사용자 division 권한 필터).
  // ATTRIBUTE3<>'EE' 제외는 이 콤보가 tact-time 과 공유돼 공유 SQL 을 못 고치므로 BodForm 에서 fetch 후
  // client-side 로 재현한다(convert-core §2.6 소스 필터는 화면 재구현). ATTRIBUTE3 는 Division_SCP SELECT 에 포함.
  DIVISION: 'Division_SCP',
  // AS-IS: Data_SCP.CommonAll(Data_SCP.Type.FromSiteByDivision1Ex, ...) — SITE_TYPE='PLANT' + division/권한 필터.
  FROM_SITE: 'FromSiteByDivision1Ex_SCP_ALL',
  // AS-IS: Data_SCP.CommonAll(Data_SCP.Type.ToSiteBOD1, ...) — division 필터 + '-A' 접미 site UNION.
  TO_SITE: 'ToSiteBOD1_SCP_ALL',
  // AS-IS: Data.Common(Data.Type.LookupCommon, false, "INCOTERMS") — 범용 LOOKUP_TYPE='INCOTERMS' 조회.
  INCOTERMS: 'Incoterms',
  // AS-IS: Data.Common(Data.Type.LookupCommon, false, "TRANSPORT_MODE_CODE") — CODE/NAME 분리 반환(TransportMode 는 CODE=NAME 동일값이라 제외).
  TRANS_MODE: 'TransModeCode',
} as const;

/**
 * From Site 코드 끝자리 + OSP_YN 에 따른 To Site 후보 3분기(AS-IS SpdMain_ComboSelChange
 * L1142-1161, ClipboardPasted L1220-1241 동일 로직).
 *   - From Site 코드가 'E' 로 끝남           → ToSiteBOD1_SCP_ALL(전체, division 필터 + '-A' 접미 UNION)
 *   - 'A' 로 끝나고 해당 site 의 OSP_YN='Y'  → ToSiteByDivisionPlant1_SCP_ALL(SITE_TYPE='PLANT' AND
 *     OSP_YN='N' AND OPERATION_GROUP='A')
 *   - 그 외                                  → ToSiteByDivision1_SCP_ALL(division+권한 필터만)
 * 3개 SQL_ID 전부 `SCM_ADM_CMBO_SQL_M` 에 등록돼 있음을 DB 실측으로 확정했다(2026-09-19, ora.py,
 * WHERE 절까지 확인 — 이름 유사성 추정 아님, convert-core §2.6).
 *
 * 미배선 상태 유지(호출부 0건) — 등록 여부가 아니라 **분기 판정에 필요한 입력값 OSP_YN 을 이 화면이
 * 어디서도 못 받는 것**이 배선을 막는 진짜 원인이다. `countryCity` SP(SCP.SCP0007_GET_COUNTRY_CITY,
 * `procedures.d.ts` SCP0007.countryCity.response) 도, 헤더/그리드가 쓰는 From Site 콤보
 * (`FromSiteByDivision1Ex_SCP_ALL`) 도 응답에 `OSP_YN` 컬럼이 없다(SCM_MST_SITE 테이블 자체엔
 * OSP_YN 컬럼이 있음 — DB 실측 확인, 2026-09-19). 이 값을 추측해 하드코딩하면 anti-simplification
 * 위반이라 배선하지 않는다. 필요 조치: `convert-sp` 가 `SCP.SCP0007_GET_COUNTRY_CITY`(또는 TO-BE
 * `PKG_SCP0007.P_SCP0007_GET_COUNTRY_CITY`) 반환 컬럼에 `OSP_YN` 을 추가해야 이 함수를 실제
 * beginningEdit 배선에 연결할 수 있다.
 */
export const TO_SITE_BUCKET = {
  ALL: 'ALL',
  PLANT_NON_OSP: 'PLANT_NON_OSP',
  DEFAULT: 'DEFAULT',
} as const;
export type ToSiteBucket = (typeof TO_SITE_BUCKET)[keyof typeof TO_SITE_BUCKET];

export const resolveToSiteBucket = (fromSiteCode: string, ospYn: string): ToSiteBucket => {
  const suffix = fromSiteCode.split('-')[1];
  if (suffix === 'E') return TO_SITE_BUCKET.ALL;
  if (suffix === 'A' && ospYn === 'Y') return TO_SITE_BUCKET.PLANT_NON_OSP;
  return TO_SITE_BUCKET.DEFAULT;
};

/**
 * 그리드 셀 콤보 원천(SQL_ID) — 검색조건 콤보(BOD_COMBO_ID)와 별개.
 * AS-IS SCP0007_BOD.cs L60/62-64 Data_SCP.CommonAll(...) = UP_FX_GetCommonDataList_SCP_ALL 이관본
 * (naming rule: _SCP_ALL). FROM_SITE 는 OSP_YN 을 응답에 포함해 TO_SITE 3분기 판정에 쓰인다.
 * TO_SITE 3종은 resolveToSiteBucket 버킷(ALL/PLANT_NON_OSP/DEFAULT)에 1:1 대응(§3.6).
 */
export const BOD_GRID_COMBO_ID = {
  FROM_SITE: 'FromSiteByDivision1_SCP_ALL',
  TO_SITE_ALL: 'ToSiteBOD1_SCP_ALL',
  TO_SITE_PLANT_NON_OSP: 'ToSiteByDivisionPlant1_SCP_ALL',
  TO_SITE_DEFAULT: 'ToSiteByDivision1_SCP_ALL',
} as const;

/** resolveToSiteBucket 결과 → 그 버킷의 TO_SITE 콤보 SQL_ID */
export const TO_SITE_BUCKET_COMBO: Record<ToSiteBucket, string> = {
  [TO_SITE_BUCKET.ALL]: BOD_GRID_COMBO_ID.TO_SITE_ALL,
  [TO_SITE_BUCKET.PLANT_NON_OSP]: BOD_GRID_COMBO_ID.TO_SITE_PLANT_NON_OSP,
  [TO_SITE_BUCKET.DEFAULT]: BOD_GRID_COMBO_ID.TO_SITE_DEFAULT,
};
