import type { MENU_ID, SHEETS } from './bod-item.constants';

/**
 * 조회조건(searchParams). 다중선택 콤보는 콤마 CSV 문자열('ALL'=전체). AS-IS SCP0030_BOD_ITEM.cs
 * clbDivision/clbFromSite/clbToSite/clbIncoterms/clbTransMode/clbPlanGroup + cboValidYN + txtItemId/txtNickName.
 */
export interface SearchParamProps {
  divisionId: string;
  fromSite: string;
  toSite: string;
  incoterms: string;
  transMode: string;
  planGroupId: string;
  validYn: string;
  itemId: string; // Model(=Item ID) 콤마 다중 자유입력
  nickName: string;
}

export type BodItemRow = ResponseData<MENU_ID, SHEETS.BOD_ITEM>;
export type BodExcludedRow = ResponseData<MENU_ID, SHEETS.BOD_EXCLUDED>;

export type BodPopupRow = ResponseData<MENU_ID, 'bodPopup'> & { No?: number };
