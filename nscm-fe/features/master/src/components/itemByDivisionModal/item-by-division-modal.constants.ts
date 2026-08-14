export const MODAL_ITEM_BY_DIVISION = 'COM0008' as const;
export type MODAL_ITEM_BY_DIVISION = typeof MODAL_ITEM_BY_DIVISION;

export const MODAL_SHEET_ITEM_BY_DIVISION = 'itemByDivision';
export type MODAL_SHEET_ITEM_BY_DIVISION = typeof MODAL_SHEET_ITEM_BY_DIVISION;

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
