import type { BUCKET_TYPE, MENU_ID, SHEETS } from './waterfall-shipment-plan-fg.constants';

// 그리드 행 — procedures.d.ts(SSOT). pivot wide 커서라 index signature 포함.
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;
// 기간칼럼 헤더 메타(캘린더 3span) 행.
export type TitleRow = ResponseData<MENU_ID, SHEETS.TITLE>;

// 조회조건 상태 (design 02 §1 조회조건 9 + §5 매핑). Plant Site/Line/Nick Name/Gap/All 없음(FG 화면).
export interface SearchParams {
  divisionId: string; // 단일, 필수, cascade root
  operationGroupId: string; // 단일, 필수 (EE 여부로 콤보 스왑)
  versionNos: string[]; // 다중 CheckedList, 필수
  electrodeTypes: string[]; // 다중, ALL→NULL, enable=isEE
  bucket: BUCKET_TYPE; // 단일, 기본 DAILY
  fromYyyymmdd: string; // date range from
  toYyyymmdd: string; // date range to
  itemId: string; // 팝업 결과(ItemByDivisionModal) → p_item_id (Model)
  projectCode: string; // 팝업 결과(ProjectByDivisionModal) → p_project_code
  chkSum: boolean; // W_/M_ 합계칼럼 표시 토글 (WeeklyISO 면 체크박스 숨김, design 01 D1)
}
