import type { BUCKET_TYPE, MENU_ID, SHEETS } from './production-plan-line.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SCP0013 은 procedures.d.ts 미등재라 Base 인덱스시그니처
//   fallback(Record<string, WijmoRowItem> & { CRUD_TYPE?: string })으로 해석된다(자매 SCP0020 동일).
//   pivot 값/편집판정에 쓰는 컬럼(MEASURE/CP_KEY/D_·W_·M_ 등)은 GET SP 반환에 포함(design 03 §3/§4).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;
export type LoadRow = ResponseData<MENU_ID, SHEETS.LOAD>;

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1 인벤토리 21건 + §5.2 22-param 매핑.
export interface SearchCondition {
  divisionId: string; // 단일 (cascade 최상위, 필수)
  operationGroupId: string; // 단일 (필수). EE 여부로 콤보 코드셋 스왑
  plantSiteIds: string[]; // 다중
  lineIds: string[]; // 다중 ('-' sentinel → '')
  electrodeTypes: string[]; // 다중, ALL→NULL. opGroup A/P 시 ALL 고정+disable
  cellTypeGrs: string[]; // 다중, div=40 에서만 enable
  extraSpecs: string[]; // 다중, div=40 에서만 enable (TO-BE 콤보 미탐 — design 02 §7)
  planStartYyyymmdds: string[]; // cboPlanDate 다중 (필수)
  planTypes: string[]; // cboPlanType 다중 (필수)
  planSeqs: string[]; // cboPlanSeq 다중 (필수)
  bucket: BUCKET_TYPE; // 기본 WEEKLY
  fromYyyymmdd: string; // dCalendar from
  toYyyymmdd: string; // dCalendar to
  modelId: string; // txtModel
  itemId: string; // txtItemId (btnItemId 팝업이 채움)
  nickName: string; // txtNickName
  chkAll: boolean; // p_chk_all — daily 분배 조회 모드
  chkLineAssign: boolean; // p_line_assign — 체크 시 Material 필수(MSG00290)
  chkSum: boolean; // SUM(W_/M_) 컬럼 가시성 토글 (SP 미전달, 그리드 표시 전용)
}

// Fix/Unfix/New 실행 타입 (design 01 E — SaveData_FixInfo("F"/"U")).
export type FixMode = 'F' | 'U';
