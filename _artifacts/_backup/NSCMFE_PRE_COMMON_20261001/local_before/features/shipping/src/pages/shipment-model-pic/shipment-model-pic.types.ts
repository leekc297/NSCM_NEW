import type { MENU_ID, SHEETS } from './shipment-model-pic.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. GET SP 반환 21컬럼 (design 03 §1/§4).
//   SSP0014 는 generated procedures.d.ts 에 아직 없어 Base index-signature 로 loose 해석된다
//   (SCP0023 자매와 동일 — 생성 SSOT 파일은 건드리지 않는다, convert-core §2.2 Hard Boundary).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — design 02 §1):
//   Division*(단일,필수) / OperationGroup(단일+ALL) / FromSite(다중+ALL) / Valid(단일+ALL)
//   / Model(다건 ^) / UserId(LIKE 텍스트).
export interface SearchCondition {
  divisionId: string;
  operationGroup: string; // ALL sentinel = 전체
  fromSiteIds: string[];
  validYn: string; // ALL sentinel = 전체
  itemId: string; // 다건 (txtItemId — btnItemId SCM0002 팝업이 채움, 콤마 구분)
  userId: string; // LIKE 텍스트 (User ID(Name), GET SP 6필드 OR)
}
