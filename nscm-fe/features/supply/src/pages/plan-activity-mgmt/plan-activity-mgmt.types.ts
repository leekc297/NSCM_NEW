import type { MENU_ID, SHEETS } from './plan-activity-mgmt.constants';

// GET SCP0122_GET_PLAN_ACTIVITY_MGMT 반환 행 (procedures.d.ts SCP0122.main.response.o_rc1 + CRUD_TYPE).
export type PlanActivityMgmtRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 + 신규행 기본값 복사원본). CODE/NAME 를 함께 보관 — 신규행이 Text(NAME)까지 채운다.
export interface PlanActivityMgmtSearchParams {
  divisionId: string;
  planGroupId: string;
  planGroupName: string;
  prsCd: string;
  prsName: string;
}
