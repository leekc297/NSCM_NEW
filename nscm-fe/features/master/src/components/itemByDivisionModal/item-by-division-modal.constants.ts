export const MODAL_ITEM_BY_DIVISION = 'COM0008' as const;
export type MODAL_ITEM_BY_DIVISION = typeof MODAL_ITEM_BY_DIVISION;

export const MODAL_SHEET_ITEM_BY_DIVISION = 'itemByDivision';
export type MODAL_SHEET_ITEM_BY_DIVISION = typeof MODAL_SHEET_ITEM_BY_DIVISION;

/**
 * 그리드 셀 호출용 좁은 조회 시트.
 *
 * itemByDivision 은 team/end customer/site 축까지 펼친 목록이라, 팝업 컬럼을 좁혀 연 화면에서는
 * 같은 Model 이 여러 줄로 보인다(구분 근거가 화면에서 빠지므로). AS-IS 는 그리드 셀 팝업만
 * 별도 팝업 + 별도 SP 를 썼다 - DM0002_ItembySmallDivPopup / ..._GET_ITEM_BY_SMALLDIVISION_POPUPEx.
 * AS-IS 에서 이 좁은 팝업을 띄우는 화면은 셋뿐이다(06.UIL 전수 검색, 최신 세대 기준):
 *   DMF0005 SaleSite_PjtModelMapping  L3413            -> TO-BE SalesSiteProjectModelGrid 반영
 *   DMF0008 ErpEdiMaster              L2367 · L3150    -> TO-BE ErpEdiMasterSspmGrid 반영
 *   DMF0010 BizPlanPrice              L1510            -> TO-BE 화면 아직 없음(미이행)
 * 셋 다 그리드 셀이고, 같은 화면의 조회조건 버튼은 넓은 쪽을 쓴다(DMF0005 L4076, DMF0010 L1941).
 * DMF0006 은 셀에서도 넓은 쪽을 쓴다 - 전역 규칙이 아니라 화면별 선택이므로 호출처가 고른다.
 */
export const MODAL_SHEET_ITEM_BY_SMALL_DIVISION = 'itemBySmallDivision';
export type MODAL_SHEET_ITEM_BY_SMALL_DIVISION = typeof MODAL_SHEET_ITEM_BY_SMALL_DIVISION;

/**
 * 좁은 조회에서 "조건 없음"을 뜻하는 값.
 *
 * 넓은 조회는 빈 문자열을 조건 없음으로 받지만 좁은 쪽은 규약이 다르다. project/item 조건이
 *   AND (EXISTS (... WHERE D.PROJECT_CODE LIKE P.TOKEN || '%') OR ...)
 * 형태라 UF_FX_STRING_SPLIT 가 토큰을 하나라도 내놔야 EXISTS 가 참이 된다.
 *   ''    -> 토큰 0개 -> EXISTS 거짓 -> 결과 0건 (Oracle 에서 '' 은 NULL)
 *   'ALL' -> LIKE 'ALL%' -> 매칭 없음
 *   '%'   -> LIKE '%%'   -> 전 행 통과
 * 2026-08-28 실측: division 81 에 projectCode/itemId 를 '%' 로 주면 43,674 건.
 */
export const SMALL_DIVISION_WILDCARD = '%';

export const MODAL_NAME = 'itemByDivisionPopup';

/**
 * 팝업 검색조건 식별자 — visibleConditions prop 으로 호출 화면별 노출을 고른다.
 * (문자열 리터럴 대신 이 상수를 쓸 것 — 오타는 "조건이 조용히 사라짐" 으로만 드러난다.)
 */
export const ITEM_MODAL_CONDITION = {
  DIVISION: 'division',
  TEAM: 'team',
  END_CUSTOMER: 'endCustomer',
  SALES_SITE: 'salesSite',
  PROJECT: 'project',
  MODEL: 'model',
  ITEM_TYPE: 'itemType',
} as const;
export type ItemModalCondition = (typeof ITEM_MODAL_CONDITION)[keyof typeof ITEM_MODAL_CONDITION];

/**
 * visibleConditions 미지정 시 기본 노출 세트 = 기존 동작 그대로(회귀 0).
 * Item Type 은 신설 조건이라 기본 세트에서 빠진다 — 원하는 화면만 명시적으로 켠다.
 */
export const DEFAULT_ITEM_MODAL_CONDITIONS: ItemModalCondition[] = [
  ITEM_MODAL_CONDITION.DIVISION,
  ITEM_MODAL_CONDITION.TEAM,
  ITEM_MODAL_CONDITION.END_CUSTOMER,
  ITEM_MODAL_CONDITION.SALES_SITE,
  ITEM_MODAL_CONDITION.PROJECT,
  ITEM_MODAL_CONDITION.MODEL,
];

/**
 * visibleColumns 항목.
 * - 문자열: admin 컬럼 메타에서 그 colNm 을 찾아 쓴다. 없으면 그 컬럼은 빠진다.
 * - 객체: 메타에 없을 때 쓸 정의(라벨·폭)까지 같이 준다 → 메타에 없어도 컬럼이 그려진다.
 *   응답(o_rc1)에는 있는데 admin 메타에 등록이 안 된 컬럼(ITEM_TYPE 등)을 화면단에서 살릴 때 쓴다.
 * 둘 다 colNm 에 'A|B' 로 후보를 나열할 수 있다.
 */
export interface ItemModalColumnSpec {
  /** 'A|B' — 메타(객체는 응답 데이터까지)에서 먼저 잡히는 후보 하나만 쓴다. */
  colNm: string;
  /** 메타에 없어 직접 만들 때 쓸 헤더 라벨. */
  colLblNm: string;
  colWth?: number;
}
export type ItemModalColumn = string | ItemModalColumnSpec;

/**
 * Item Type 조건의 '전체' 값.
 * CustomDropdown 의 allOption(단일 선택)은 value 가 빈 문자열이라 그 규약을 그대로 따른다.
 */
export const ITEM_TYPE_ALL = '';

/**
 * Item Type 조건의 기본 선택값 — AS-IS 'Model by DivisionPopup' 이 Product 로 열리는 것과 동등.
 * ⚠ 'ItemType' 콤보가 이 값을 CODE 로 주는지 NAME 으로 주는지는 admin 메타에 달렸다.
 *   둘 다 조회해 맞는 쪽의 CODE 를 쓰고, 어느 쪽에도 없으면 ITEM_TYPE_ALL 로 떨어진다.
 */
export const DEFAULT_ITEM_TYPE = 'Product';
