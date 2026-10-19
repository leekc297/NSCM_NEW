import type { MENU_ID, SHEETS, TACT_MODE } from './tact-time.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. 편집판정/파생에 쓰는 값 컬럼은 GET SP 반환에 포함됨(design 03 §3.2).
export type PlantRow = ResponseData<MENU_ID, SHEETS.PLANT>;
export type PackerRow = ResponseData<MENU_ID, SHEETS.PACKER>;
export type ExceptRow = ResponseData<MENU_ID, SHEETS.EXCEPT>;
export type ItemSearchRow = ResponseData<MENU_ID, SHEETS.ITEM_SEARCH>;

// spdMain 은 Plant/Packer 두 시트를 한 그리드에서 탭 전환 — 행 형상은 union.
export type MainRow = PlantRow  ;

// 조회조건 (Form 입력 상태 — searchParams).
//   design 02 §1 인벤토리: division(단일) / plantSite(다중) / line(다중) / operationGroup / valid / itemId(다건).
export interface SearchCondition {
  divisionId: string;
  plantSiteIds: string[];
  lineIds: string[];
  operationGroupId: string;
  valid: string;
  itemId: string; // 개행/콤마 다건 (txtItemId — btnItemId 팝업이 채움)
  mode: TACT_MODE; // spdMain 활성 탭 (cascade 공급 경로 분기 — design 02 §3)
}
