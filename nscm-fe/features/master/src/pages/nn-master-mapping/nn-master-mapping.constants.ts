export const MENU_ID = 'DMF0072' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0072_NNMasterMapping.cs / .Designer.cs:
//   - Main(L477):  DMF0072_GET_NNMASTER_MAPPING (7 IN + cursor)
//   - DataType(L200): GetLookupValues("DM_EDI_DATA_TYPE_CODE")
//   - Division(L154): Data.Common(Data.Type.MyDivision) — DMF0008_GET_MY_DIVISION_LIST 재사용
//   - Team(L159):     SetChangeControl("UserTeamByDivision", sDivision)
//   - EndCustomer(L165~178): div=40 → EndCustomerByDivision40 / 그 외 → EndCustomerByDivision
//   - SalesSite(L186): SetChangeControl("UserSiteByEndCustomer", divisions, endCustomer)
export enum SHEETS {
  MAIN = 'main',
  DATA_TYPE = 'dataType',
  DIVISION = 'division',
  TEAM = 'team',
  END_CUSTOMER = 'endCustomer',
  SALES_SITE = 'salesSite',
}

// const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용)
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  DATA_TYPE: 'o_rc1',
  DIVISION: 'o_rc1',
  TEAM: 'o_rc1',
  END_CUSTOMER: 'o_rc1',
  SALES_SITE: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// 2026-06-20: MAIN_COLUMNS (23 컬럼) + NnColumnMeta interface 제거.
//   사내 DB 080_DMF0072_dynamic_property_management.sql 적용 후 BE 가 SCM_MST_SHEET_COLUMNS 로부터 23 row 반환.
//   FE 하드코딩 제거 — admin UI Category Setup 변경 즉시 반영 (룰 #65 ui-category-setup-column-meta 준수).
//   관련 로직: useNnMasterMappingStore.fetchStaticColumns → store.staticColumns.main → DataGrid staticColumns prop.

// 빈 SP 결과 대응 fallback (lookup SP 호출 실패 시 — Form의 division 첫 옵션 자동 선택용)
export const FALLBACK_ALL: ReadonlyArray<{ value: string; label: string }> = [
  { value: 'ALL', label: 'ALL' },
];

// lookup 타입 (SCM0001_GET_LOOKUP_VALUES 도메인 — useTabLookupQueries 소비)
//   COMPANY = AS-IS InsertRow cs:558 GetLookupValues("DM_EDI_COMPANY_LIST") (MI00/NA00/GM00 3건).
//   TO-BE 컬럼 메타는 Company 콤보(SCM_MST_COMPANY_SN 전건)로 잘못 배선돼 후보범위가 다르다(design 03 §6 불일치).
//   AS-IS 와 동일 후보를 보이도록 FE 가 이 lookup 을 조회해 COMPANY_ID 신규행 셀에 DataMap 을 주입한다.
export const LOOKUP = {
  COMPANY: 'DM_EDI_COMPANY_LIST',
} as const;
