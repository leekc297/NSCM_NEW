import type { MENU_ID, SHEETS } from './demand-group-master.constants';

// GET 결과 행 타입 — procedures.d.ts SCP0110 응답과 정합(공용 ResponseData 로도 접근 가능).
export type GroupMasterRow = ResponseData<MENU_ID, SHEETS.GROUP_NAME, 'o_rc1'>;
export type ModelListRow = ResponseData<MENU_ID, SHEETS.MODEL_LIST, 'o_rc1'>;

// 조회조건 (searchParams) — Form 입력값. filters(발사) 와 분리(nscm-patterns §3.6).
export interface SearchParams {
  divisionId: string; // 다중 체크 콤보 — 콤마 결합값(AS-IS GetCheckedListValue)
  operationGroup: string; // 단일 — {P,A}
  groupName: string; // 부분일치 텍스트
  projectId: string; // 팝업 반환(콤마 다중)
  itemId: string; // 팝업 반환(콤마 다중)
}
