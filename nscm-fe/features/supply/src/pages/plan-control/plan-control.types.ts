import type { MENU_ID, RESPONSE_SET, SHEETS } from './plan-control.constants';

// 그리드 행 타입은 procedures.d.ts(SSOT)에서 파생한다 — 화면이 독자 interface 를 선언하면
//   SP 커서 계약과 조용히 어긋난다(convert-core §3.1 SSOT).
export type PlanControlRow = ResponseData<
  MENU_ID,
  SHEETS.PLAN_CONTROL,
  typeof RESPONSE_SET.PLAN_CONTROL
>;
export type EngineRunRow = ResponseData<MENU_ID, SHEETS.ENGINE_RUN, typeof RESPONSE_SET.ENGINE_RUN>;
export type PlanGroupRow = ResponseData<
  MENU_ID,
  SHEETS.SEARCH_INFO,
  typeof RESPONSE_SET.SEARCH_INFO
>;

export interface PlanControlSearchParams {
  divisionId: string;
  planGroupId: string;
  // 주단위 모드에서 쓰는 Plan Date 콤보 선택값(CODE = yyyyMMdd).
  planDateCode: string;
  // 일단위 모드에서 쓰는 DatePicker 값(yyyyMMdd). 모드 진입마다 오늘로 리셋(R04).
  planDate: string;
}

// 하단 Status 그리드 / 폴링의 행 컨텍스트. AS-IS nSelRowSpdMain 대응 — 탭 스코프 state 로 두어야
//   MDI keep-alive 에서 탭끼리 섞이지 않는다(R24).
export interface EngineRunContext {
  actvCd: string;
  planId: string;
}

// SCP0039 Master Validation 팝업 반환값(A001 LINK) — Confirm 가드 B16·B17 이 이 값을 읽는다.
export interface MasterValidationResult {
  isValidSearch: boolean;
  criticalCnt: number;
  warningCnt: number;
}
