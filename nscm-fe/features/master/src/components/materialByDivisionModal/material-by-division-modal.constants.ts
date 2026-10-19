/**
 * Material by Division 공용 팝업 상수.
 *
 * AS-IS SCM0002_MaterialByDivisionPopup(SCP 27개 화면 공용)의 TO-BE 등가. 공용 팝업이라
 * COM 계열 신규 코드 COM0013 으로 등록되어 있다(COM0008 ItemByDivision 팝업과 동일 패턴).
 *
 * 시트명 구분(COM0008 의 itemByDivision / itemByDivisionPopup 과 동일한 이분):
 *   - 프로시저 호출 시트(useTabProcQuery sheetName) = 'materialByDivision'
 *   - 컬럼 메타 시트(/admin/menu/{menuId}/column 의 sheetNm) = 'materialByDivisionPopup'
 */
export const MODAL_MATERIAL_BY_DIVISION = 'COM0013' as const;
export type MODAL_MATERIAL_BY_DIVISION = typeof MODAL_MATERIAL_BY_DIVISION;

export const MODAL_SHEET_MATERIAL_BY_DIVISION = 'materialByDivision';
export type MODAL_SHEET_MATERIAL_BY_DIVISION = typeof MODAL_SHEET_MATERIAL_BY_DIVISION;

/** 컬럼 메타(SCM_MST_SHEET_COLUMNS.SHEET_NAME) 시트명 = /column 요청의 sheetNm. */
export const MODAL_NAME = 'materialByDivisionPopup';
