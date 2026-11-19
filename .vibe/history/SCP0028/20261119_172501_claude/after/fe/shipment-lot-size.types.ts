import type { MENU_ID, SHEETS } from './shipment-lot-size.constants';

// AS-IS GSCM.SCP.Forms.UIL SCP0028_Shipment_Lot_Size — 단일 그리드 마스터 편집 화면(domain SSP/Shipping).
//   설계 근거: .atlas/gscm-design/SCP0028/design/00_checklist.md ~ 03_grid-columns.md.

// 조회조건 (design 02 §1) — 콤보 6(Division 단일 / Operation Group·Valid 단일+ALL / From·To Site·Trans Mode
//   다중+ALL) + Model(텍스트+Item 팝업). 다중선택은 콤마 join 문자열, 'ALL' sentinel=전체(무필터).
export interface SearchCondition {
  divisionId: string; // cboDivision (단일 필수, EE 제외)
  operationGroup: string; // cboOperationGroup ('ALL' 기본)
  fromSite: string; // clbFromSite (다중, 'ALL' 기본)
  toSite: string; // clbToSite (다중, 'ALL' 기본)
  transMode: string; // clbTransMode (다중, 'ALL' 기본)
  itemId: string; // txtItemId (Item 팝업 반환, 콤마 다중)
  valid: string; // cboValid ('ALL' 기본, ALL->SP null)
}

// 메인 그리드 행 (design 03 §1 — 18칼럼). 세부 타입은 procedures.d.ts SCP0028.main.
export type ShipmentLotSizeRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 일괄입력/삭제 팝업 후보 행 (design 01 R5/R6 — P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP).
export type LotSizePopupRow = ResponseData<MENU_ID, SHEETS.POPUP>;

// 일괄 팝업 모드 — 'I' 일괄입력 / 'D' 일괄삭제 (AS-IS SCM0002_ShipmentLotSizePopup action).
export type BatchMode = 'I' | 'D';
