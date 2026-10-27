// SCP0048 ProjectRoute Warranty — 행 타입. procedures.d.ts SCP0048 response 기반 alias.
import type { MENU_ID, RESPONSE_SET, SHEETS } from './project-route-warranty.constants';

export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.MAIN>;

// 조회조건(입력 중) 상태(design/02 §5). scmSiteId/projectCode 는 조회조건 아님(그리드 셀 소관).
//   plantSite/operationGroup/validFlag 은 ALL sentinel → SP DBNull 치환(design/02 §4).
export interface SearchParamProps {
  divisionId: string;
  plantSite: string; // 'ALL' → SP NULL
  operationGroup: string; // UI 숨김 — LookupCommon(P/A/E), 기본 '' (그리드 리셋 트리거)
  itemId: string;
  validFlag: string; // 'ALL' → SP NULL
}
