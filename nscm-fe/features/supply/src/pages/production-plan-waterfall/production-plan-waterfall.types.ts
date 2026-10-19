import type { BUCKET_TYPE, MENU_ID, SHEETS } from './production-plan-waterfall.constants';

// 그리드 행 — procedures.d.ts(SSOT). pivot wide 커서라 index signature 포함.
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;
// 기간칼럼 헤더 메타(캘린더 3span) 행.
export type TitleRow = ResponseData<MENU_ID, SHEETS.TITLE>;

// 조회조건 상태 (design 02 §1 controls 12 + §5 매핑).
export interface SearchParams {
  divisionId: string; // 단일, 필수, cascade root
  operationGroupId: string; // 단일, 필수
  plantSiteIds: string[]; // 다중
  lineIds: string[]; // 다중, '-' sentinel
  versionNos: string[]; // 단일 UI(Gap 시 2건), 필수
  electrodeTypes: string[]; // 다중, ALL→NULL, enable=isEE
  bucket: BUCKET_TYPE; // 단일, 기본 DAILY
  fromYyyymmdd: string; // date range from
  toYyyymmdd: string; // date range to
  modelId: string; // 팝업 결과(ItemByDivisionModal) → p_item_id
  nickName: string; // 텍스트
  chkGap: boolean; // Gap 체크 → p_gap + version 2건 검증
  chkAll: boolean; // 전체기간 토글(그리드 재구성)
  chkSum: boolean; // W_/M_ 합계칼럼 표시 토글
}
