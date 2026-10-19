import type { MENU_ID, SHEETS } from './plan-management.constants';

// SP 응답 행 타입 — procedures.d.ts SCP0015 계약에서 파생(SSOT)
export type PlanRow = ResponseData<MENU_ID, SHEETS.PLAN_MGMT, 'o_rc'>;
export type RevisionCandidateRow = ResponseData<MENU_ID, SHEETS.PLAN_MGMT, 'o_rc2'>;
export type EngineRow = ResponseData<MENU_ID, SHEETS.ENGINE_RUN, 'o_rc'>;
export type EngineStatusRow = ResponseData<MENU_ID, SHEETS.ENGINE_RUN, 'o_rc2'>;
export type ConfirmInfoRow = ResponseData<MENU_ID, SHEETS.PLAN_CONFIRM, 'o_rc'>;

// PLAN_TYPE(TE/TM/PR/MA/SE/FN/SU)별 REVISION_NO 후보 맵 — 한 조회 응답에 전량 동봉(design 03 §1.4)
export type RevisionCandidateMap = Record<string, RevisionCandidateRow[]>;

// 더블클릭으로 선택된 Plan 행 컨텍스트 — Engine 조회 파라미터 + btnStop enable 판정 입력
//   (AS-IS nSelRowSpdPlan/txtRevision/FindData_Engin 등가, design 01 §2 행4)
export interface SelectedPlan {
  modelingId: string;
  divisionId: string;
  revisionNo: string;
  planStatus: string;
}
