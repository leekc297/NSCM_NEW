import {
  CHANGE_REASON_NONE,
  COLUMN,
  EDIT_MAIN_OFF,
  NEW_ROW_END_CUSTOMER_DIVISION,
} from '../shipment-change-request-plan.constants';

import type { GridRowData } from './shipmentChangeRequestPlanDerive';

/**
 * 신규행 초기값 — **3경로가 서로 다르다**(design 03 §3.3). 동일 구현하면 AS-IS 불일치(CP-15).
 *
 *  - `InsertButton` / `btnInsertMultiple` : 상위행 13키 복사 + div 분기 `'-'`. 사전조건 `RowCount>0`.
 *  - `btnNew`                            : `DIVISION_ID` 만 + div 분기 `'-'`.
 *                                          AS-IS 가 **의도적으로** `RowCount>0` 가드를 뺀 경로다.
 *
 * div 분기 기준은 **조회조건 division**(`clbDivision_ID.ControlValues`)이며 행 값이 아니다.
 * 또한 AS-IS 는 두 경로 모두 `== "40"` **단일 비교**다 — 컬럼 표시 축의 `END_CUSTOMER_DIVISIONS`
 * (`['40','EE']`, hook #113)를 여기 재사용하면 div 'EE' 에서 AS-IS 가 넣지 않는 `'-'` 가 들어간다.
 */

/**
 * `InsertButton`/`InsertRowMultiple` — 상위행 13키 복사(cs:2677·2785).
 *
 * div 분기(cs:2696~2703 + cs:2740~2750): div=='40' 이면 복사원의 **END_CUSTOMER** 를
 * END_CUSTOMER 로 옮기고 `PROJECT_CODE='-'`, 그 외에는 복사원 **PROJECT_CODE** 를
 * PROJECT_CODE 로 옮기고 `END_CUSTOMER='-'` 다. 두 열을 그대로 복사하면 AS-IS 가 비우는 열에
 * 값이 남아 상호배타 규칙(§2.4)이 깨진다.
 * 주의: AS-IS 는 div=='40' 에서 `setEndCustomer(ActiveRowIndex)` 도 부른다 — 후보 재조회는
 * 셀 콤보 훅(`ITEM_ID`/`TO_SITE_DESCRIPTION` 편집 종료 트리거)이 담당하고 여기서는 값만 세팅한다.
 */
export const buildCopiedRow = (base: GridRowData, divisionId: string): GridRowData => {
  const endCustomerDiv = divisionId === NEW_ROW_END_CUSTOMER_DIVISION;
  return {
    [COLUMN.DIVISION_ID]: base[COLUMN.DIVISION_ID],
    [COLUMN.ITEM_ID]: base[COLUMN.ITEM_ID],
    // 주의: 복사원은 **코드값**(`FROM_SITE`/`TO_SITE`)이다(cs:2693·2806).
    //   셀 콤보 CODE 가 `SCM_SITE_ID` 라 description 문자열을 넣으면 콤보가 매칭되지 않는다.
    [COLUMN.FROM_SITE_DESCRIPTION]: base[COLUMN.FROM_SITE],
    [COLUMN.TO_SITE_DESCRIPTION]: base[COLUMN.TO_SITE],
    [COLUMN.PROJECT_CODE]: endCustomerDiv ? CHANGE_REASON_NONE : base[COLUMN.PROJECT_CODE],
    [COLUMN.END_CUSTOMER]: endCustomerDiv ? base[COLUMN.END_CUSTOMER] : CHANGE_REASON_NONE,
    [COLUMN.SHIPMENT_CONFIRM_QTY]: base[COLUMN.SHIPMENT_CONFIRM_QTY],
    [COLUMN.SHIPMENT_DATE]: base[COLUMN.SHIPMENT_DATE],
    [COLUMN.INCOTERMS]: base[COLUMN.INCOTERMS],
    [COLUMN.TRANSPORT_MODE]: base[COLUMN.TRANSPORT_MODE],
    [COLUMN.FCST_TYPE]: base[COLUMN.FCST_TYPE],
    [COLUMN.NICK_NAME]: base[COLUMN.NICK_NAME],
    MTK_OWNER: base.MTK_OWNER,
    [COLUMN.EDIT_MAIN]: EDIT_MAIN_OFF,
  };
};

/**
 * `btnNew` — 조회조건 division + div=='40' 분기 `'-'` 뿐이다(cs:3400~3409).
 *
 * `CHANGE_REASON_CODE` 는 **넣지 않는다** — `BtnNew_Click`(cs:3375~3435) 전문에 대입이 0건이고,
 * `'T07'` 은 `SSP_Main_Validation`(cs:3639~3643)이 **저장 직전에 수정행**을 상대로 자동 세팅하는
 * 값이다. 신규행 기본값으로 넣으면 사용자가 사유를 고르지 않아도 채워진 것처럼 보여
 * 그 자동세팅 규칙(미구현 — 04 참조)의 판정 자체를 흐린다.
 */
export const buildNewRow = (divisionId: string): GridRowData => {
  const endCustomerDiv = divisionId === NEW_ROW_END_CUSTOMER_DIVISION;
  return {
    [COLUMN.DIVISION_ID]: divisionId,
    [COLUMN.PROJECT_CODE]: endCustomerDiv ? CHANGE_REASON_NONE : '',
    [COLUMN.END_CUSTOMER]: endCustomerDiv ? '' : CHANGE_REASON_NONE,
    [COLUMN.EDIT_MAIN]: EDIT_MAIN_OFF,
  };
};
