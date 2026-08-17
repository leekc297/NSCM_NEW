// 조회조건 — AS-IS 9 컨트롤 1:1 (콤보 CMBO 0 화면 — 목록성 콤보는 useTabComboQueries 공용 콤보 사용).
//   멀티 콤보 값은 CustomDropdown 콤마 문자열. Version 기본 'Current' (Division 변경 시 clear — .cs L574).
export interface SearchParamProps {
  divisionId: string;
  team: string;
  endCustomer: string;
  salesSite: string;
  plantSite: string; // 81* 전용 활성 (82/40 비활성+clear — .cs SetChangeControl 분기)
  project: string; // 40 비활성 (.cs L841~864 division 분기)
  modelNickname: string;
  fromYyyymm: string; // Plan Date 월 범위 (기본 당월 — AS-IS drpPeriodMonth L167)
  toYyyymm: string; // 기본 +6개월
  version: string; // 'Current' 또는 버전NO 콤마 최대 2 (MSG00283/MSG00255)
}

// GET o_rc1 — Base 16 + 메탈 42(인덱스 시그니처) + EDIT_YN (division-gate 프로젝션 —
//   행 하드필터는 SP INNER JOIN 소관. 그리드는 전셀 읽기전용 — EDIT_YN 으로 셀 열지 않음).
export interface MetalLinkPriceRow {
  DIVISION_ID: string;
  PLAN_YYYYMM: string;
  DEPT_ID: string;
  DEPT_NAME: string;
  END_CUSTOMER: string;
  PROJECT_CODE: string;
  PROJECT_NAME: string;
  PLANT_SITE_ID: string;
  ITEM_ID: string;
  METAL_LINK_YN: string;
  SCM_SITE_ID: string;
  CURRENCY: string;
  FCST_TYPE_CODE: string;
  FCST_TYPE: string;
  METAL_EXCEPTION_YN: string;
  ENERGY: string | number;
  EDIT_YN: string;
  // APPLY_PRICE_TYPE_CODE1~7 / FROM_PERIOD1~7 / TO_PERIOD1~7 / CONTRACT_UNIT1~7 / METAL_APPLY1~7 / METAL_REQR1~7
  [key: string]: string | number;
}

// TEMPLATE o_rc1 — 업로드 대상 조합 (measure 열 '-' placeholder). 구조는 메인과 동형.
export type MetalLinkTemplateRow = MetalLinkPriceRow;
