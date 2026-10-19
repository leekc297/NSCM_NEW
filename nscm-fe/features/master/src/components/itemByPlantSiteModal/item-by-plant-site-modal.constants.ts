/**
 * Item by Plant Site 공용 팝업 상수 (AS-IS GSCM.SCM.Popup.UIL.SCM0002_ItembyPlantSitePopup).
 *
 * 주의: ItemByDivisionModal(COM0008)·MaterialByDivisionModal(COM0013) 과 바꿔 쓰지 말 것.
 *   겉모습은 같은 "Division 스코프 선택 팝업" 이지만 호출 SP·조회조건(여기만 plant site 로 좁힘)·
 *   그리드 컬럼이 다르다. AS-IS 는 그리드 셀 팝업만 이 SP 를 쓴다
 *   (SCP0036/SCP0037/SSP0100 공유). 변환 시 AS-IS 버튼 핸들러가 new 하는 팝업 클래스명으로 고른다:
 *     new SCM0002_ItembyPlantSitePopup -> ItemByPlantSiteModal (menuId COM0014)  [이 팝업]
 */
export const MODAL_ITEM_BY_PLANT_SITE = 'COM0014' as const;
export type MODAL_ITEM_BY_PLANT_SITE = typeof MODAL_ITEM_BY_PLANT_SITE;

export const MODAL_SHEET_ITEM_BY_PLANT_SITE = 'itemByPlantSite';
export type MODAL_SHEET_ITEM_BY_PLANT_SITE = typeof MODAL_SHEET_ITEM_BY_PLANT_SITE;

export const MODAL_NAME = 'itemByPlantSitePopup';

/**
 * 결과 그리드 고정 컬럼(colNm → 라벨·폭). admin 컬럼 메타(SHEET_COLUMNS) 가 없을 때 쓰는 fallback.
 * o_rc1 실측 컬럼(P_SCM0002_GET_ITEM_BY_PLANT_SITE_POPUP) 기준. AS-IS 컬럼 라벨/순서(L187~196)와 동일.
 *   DIVISION_NAME 은 AS-IS 에서도 hidden 이라 뺀다.
 */
export interface PlantSiteModalColumn {
  colNm: string;
  colLblNm: string;
  colWth: number;
}
export const ITEM_BY_PLANT_SITE_COLUMNS: PlantSiteModalColumn[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Div', colWth: 80 },
  { colNm: 'SCM_SITE_ID', colLblNm: 'SCM Site', colWth: 100 },
  { colNm: 'SITE_DESCRIPTION', colLblNm: 'Site', colWth: 130 },
  { colNm: 'ITEM_ID', colLblNm: 'Model Code', colWth: 110 },
  { colNm: 'ITEM_NAME', colLblNm: 'Model', colWth: 140 },
  { colNm: 'ITEM_TYPE', colLblNm: 'Type', colWth: 50 },
  { colNm: 'NICK_NAME', colLblNm: 'Nick Name', colWth: 120 },
  { colNm: 'ITEM_CLASS_NAME', colLblNm: 'Class Name', colWth: 120 },
];
