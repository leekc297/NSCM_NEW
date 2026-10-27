import type { MENU_ID, SHEETS } from './plan-management.constants';

// SP 응답 행 타입 — procedures.d.ts SCP0134 계약에서 파생(SSOT)
export type PlanRow = ResponseData<MENU_ID, SHEETS.MAIN_GRID, 'o_rc'>;
export type RevisionCandidateRow = ResponseData<MENU_ID, SHEETS.MAIN_GRID, 'o_rc2'>;
export type EngineRow = ResponseData<MENU_ID, SHEETS.DETAIL_GRID, 'o_rc'>;

// PLAN_TYPE(PR/MA/SE/FN)별 REVISION_NO 후보 맵 — 한 조회 응답에 o_rc2~o_rc5 로 전량 동봉
export type RevisionCandidateMap = Record<string, RevisionCandidateRow[]>;

// 선택된 Plan 행 컨텍스트 — Detail Grid(Engine) 조회 파라미터(division+revision) + 액션 입력
export interface SelectedPlan {
  modelingId: string;
  divisionId: string;
  revisionNo: string;
  planStatus: string;
}
