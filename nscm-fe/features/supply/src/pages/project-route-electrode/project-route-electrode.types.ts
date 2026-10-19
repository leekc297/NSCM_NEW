// SCP0027 ProjectRoute Electrode — 행 타입. procedures.d.ts SCP0027 미등재(미배포) →
//   Base index-signature fallback 으로 해석된다(참조: [[procedures-dts-base-index-fallback]]).
//   그 파일(procedures.d.ts)은 편집 금지. 배포 후 SSOT 갱신 시 이 alias 는 자동 정합.
import type { MENU_ID, RESPONSE_SET, SHEETS } from './project-route-electrode.constants';

export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.MAIN>;

// 조회조건(입력 중) 상태(design/02 §5). scmSiteId/projectCode 는 조회조건 아님(그리드 셀 소관).
//   plantSite/validFlag 은 ALL sentinel → SP DBNull 치환(design/02 §2-4).
export interface SearchParamProps {
  divisionId: string;
  plantSite: string; // 'ALL' → SP NULL
  operationGroup: string; // LookupCommon(P/A/E), 기본 '' (전체). 전극화면이라 UI 노출은 하되 기본 미선택
  itemId: string;
  validFlag: string; // 'ALL' → SP NULL
}
