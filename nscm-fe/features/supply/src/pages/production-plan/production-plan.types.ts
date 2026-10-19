import type { BUCKET_TYPE, MENU_ID, SHEETS } from './production-plan.constants';

// 그리드 행 — procedures.d.ts(SSOT) 미등재이므로 Base 인덱스시그니처 fallback(자매 SCP0013 동일).
//   pivot 값/판정 컬럼(MEASURE/PLAN_TYPE/D_·W_·M_ 등)은 GET SP 반환에 포함(design 03 §3/§4).
export type ModelRow = ResponseData<MENU_ID, SHEETS.MAIN>;
export type LineRow = ResponseData<MENU_ID, SHEETS.LINE>;

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1 인벤토리 12행.
export interface SearchCondition {
  divisionId: string; // cascade 최상위(필수). 앞2자 EE → 콤보 EE 전용 + Electrode enable
  operationGroupId: string; // 단일(필수)
  plantSiteIds: string[]; // 다중
  electrodeTypes: string[]; // 다중, EE 사업부만 enable
  planStartYyyymmdds: string[]; // cboPlanDate 단일선택(최신 자동). 1-요소 배열로 보존
  planTypes: string[]; // cboPlanType 단일선택(마지막 자동). 필수조건 제외(ConditionNotUseList)
  planSeqs: string[]; // cboPlanSeq 단일선택(첫 자동). 필수조건 제외
  bucket: BUCKET_TYPE; // 기본 WEEKLY
  fromYyyymmdd: string; // dCalendar from
  toYyyymmdd: string; // dCalendar to
  itemId: string; // txtItemId (btnItemId 팝업이 채움 — Model 필터)
  nickName: string; // txtNickName (p_nick_name)
  chkSum: boolean; // SUM(W_/M_) 컬럼 가시성 토글(그리드 표시 전용, SP 미전달)
  chkAll: boolean; // 전체보기 — 헤더 더블클릭 드릴다운 게이트(design 03 §2.3/§3 R19). 그리드 표시 전용
}

// EDIT_INFO(editInfo/SEARCH = P_SCP0011_GET_PLAN_EDIT_INFO) O_RC1 — 선택 plan version 단일 편집컨텍스트.
//   DB 실측(gap-resolve iter-1, PKG_SCP0011 body): CP_KEY 미반환. 반환 컬럼 = DIVISION_ID/PLAN_VERSION_ID/
//   PLAN_START_YYYYMMDD/PLAN_TYPE/PLAN_SEQ/OSP_YN/FP_PLAN_PERIOD/OFFSET/EDIT_START_DATE/PLAN_TYPE_ORDER/
//   CONFIRM_YN/DATE_CHK/IS_EDITABLE('Y' 상수). FE 는 EDIT_START_DATE·IS_EDITABLE 만 편집게이트에 쓴다.
export interface EditInfoRow {
  IS_EDITABLE?: string; // Y/N (현재 SP 는 'Y' 상수 — 실제 편집창은 EDIT_START_DATE)
  EDIT_START_DATE?: string; // YYYYMMDD (편집시작일)
  PLAN_TYPE?: string; // 참고(PlanType 규칙은 그리드행 PLAN_TYPE 로 판정)
  DATE_CHK?: string; // Y/N (PLAN_NAME >= BASIS_START_DATE)
}
