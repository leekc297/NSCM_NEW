import type { MENU_ID, SHEETS } from './scheduled-receipt-information.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반.
export type VirtualBomRow = ResponseData<MENU_ID, SHEETS.VIRTUAL_BOM>;
export type ScheduledReceiptRow = ResponseData<MENU_ID, SHEETS.SCHEDULED_RECEIPT>;

/**
 * 조회조건(design/02_search-combo.md §1 인벤토리 7논리조건: Division/PlanGroup/Site/ChildMaterial/
 * Valid/FromDate/ItemId).
 *
 * planGroupIds/siteIds/childMaterialIds — Division 필터방식 cascade(재조회 없음, design 02 §3).
 * valid — design 02 §2.5: AS-IS Designer.cs 원본 미접근으로 콤보 항목 원문 미확정. GSCM_DE_화면
 * 설계서_SCP0130 목업(1.화면 개요 시트, "Valid | All ▼")과 그리드 데이터(VALID_YN='Y'/'N')로 옵션값
 * All/Y/N 확정(엑셀 화면설계서 실측 — AS-IS .cs 원본은 아니지만 AS-IS 산출물 원본).
 */
// CustomDropdown(multiple) 값 계약 — 콤마 결합 문자열(또는 'ALL' sentinel). §3.3 quoting 은
//   apiClient.getCombo 가 값을 그대로 SP 파라미터로 실을 때 처리(화면은 관여 없음).
export interface SearchCondition {
  divisionId: string; // 단일(cascade 최상위, comboId MyDivision — 확인 필요 승계)
  planGroupIds: string; // 다중(콤마 결합/'ALL'), Division 필터방식(PlanGroup_SCP_ALL 전량 로드 후 클라 필터)
  siteIds: string; // 다중(콤마 결합/'ALL'), Division 1차 + PlanGroup 2차 cascade — comboId 미확정(확인 필요)
  childMaterialIds: string; // 다중(콤마 결합/'ALL'), Division 필터방식 — comboId 미확정(확인 필요)
  valid: string; // 단일, 정적 옵션 All/Y/N(화면설계서 목업 실측)
  fromDate: string; // 날짜, p_from_date
  itemId: string; // 텍스트(읽기전용) + 팝업(MaterialByDivisionModal) 결과 바인딩
}

/** 신규행 검증/중복체크 대상 공통 컬럼 — 두 시트가 공유하는 구조(design 03 §1). */
export interface RequiredRowFields {
  DIVISION_ID?: string;
  OPMZ_PLAN_GR_ID?: string;
  PLANT_SITE_ID?: string;
  ITEM_ID?: string;
  ITEM_ID_CHILD?: string;
  TO_YYYYMMDD?: string;
  TO_EXPC_QTY?: string | number;
  VALID_YN?: string;
  CRUD_TYPE?: string;
}
