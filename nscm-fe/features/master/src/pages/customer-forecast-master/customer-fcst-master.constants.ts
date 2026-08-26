export const MENU_ID = 'DMF0007' as const;
export type MENU_ID = typeof MENU_ID;

export const SHEET_NAME = 'customerFcst';
export type SHEET_NAME = typeof SHEET_NAME;

/**
 * 조회조건 cascade 콤보 ID — Div / Team / End Customer / Sales Site 를 조인한 평면 콤보 1건.
 *
 * 종전에는 단계마다 콤보를 따로 조회했다(MyDivision / EndCustomer / SalesSite). 콤보마다 스키마가
 * 달라 화면이 cascade 컬럼을 배선했고(End Customer 를 SalesSite 콤보의 PROJECT_CODE 자리로 보는 식),
 * 상위 컬럼이 공란인 행을 자를지도 콤보마다 달라 화면이 판단해야 했다. 조인 1건으로 바꾸면
 * 모든 행에 모든 단계가 차 있어 그 분기가 전부 사라진다.
 *
 * 이 화면은 Team 조회조건이 없어 division - endCustomer - salesSite 3단만 쓴다. 같은 콤보를
 * 4단으로 쓰는 화면(DMF0005 / DMF0006)과 컬럼을 다르게 읽지 않는다 — 컬럼명은 단계 순서와
 * 무관하게 카탈로그 풀네임 하나뿐이다. 자세한 규약은 CascadeFields 헤더 주석 참조.
 *
 * 주의: 아래 값은 SCM_ADM_CMBO_SQL_M 등록명이 확정되면 그 이름으로 바꾼다.
 */
export const SEARCH_CASCADE_COMBO_ID = 'SalesSite';
