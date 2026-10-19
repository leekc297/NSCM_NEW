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
  extraSpecs: string[]; // 다중, div=40 에서만 enable (SP P_SCP0013_GET_EXTRA_SPEC + OPERATION_GROUP 클라필터)
  planStartYyyymmdds: string[]; // cboPlanDate 단일선택 필수(UsrCombo). 1-요소 배열로 보존
  planTypes: string[]; // cboPlanType 단일선택 필수(UsrCombo). 1-요소 배열로 보존
  planSeqs: string[]; // cboPlanSeq 단일선택 필수(UsrCombo). 1-요소 배열로 보존
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

// EDIT_INFO(editInfo/SEARCH = P_SCP0013_GET_PLAN_EDIT_INFO) O_RC1 — 행별 편집판정 서버원천(M4c).
//   CP_KEY 로 메인 그리드행(O_RC1 CP_KEY)과 조인(PKG body LINE 827~862 실측, ora.py 2026-10-03).
//   NEW_EDIT_MODE 는 TO-BE SP 가 리터럴 'Y' 고정(LINE 862) — IS_EDITABLE 게이트 유지 위해 비소비(editLock).
export interface EditInfoRow {
  CP_KEY?: string;
  IS_EDITABLE?: string; // Y/N (MA+confirm+날짜 / SE+날짜 / PR+날짜 → Y, else N)
  NEW_EDIT_MODE?: string; // 항상 'Y'(SP 상수)
  EDIT_START_DATE?: string; // YYYYMMDD (편집시작일 = plan_name + offset)
}

// 조회 O_RC2(fix) — fix 확정 셀 색상 원천(M4a/M2, PKG body LINE 3294~3339 실측).
//   8필드 concat = FIX_KEY(editLock.buildFixKey). 기간키 = YYYYMMDD(Daily) + BASIS_YYYYMM/ISO_WEEK(주).
export interface FixRow {
  DIVISION_ID?: string;
  OPERATION_GROUP?: string;
  SCM_SITE_ID?: string;
  ITEM_ID?: string;
  LINE_ID?: string;
  OPERATION_ID?: string;
  ORIGIN_DIVISION_ID?: string;
  ELECTRODE_TYPE?: string;
  YYYYMMDD?: string;
  BASIS_YYYYMM?: string;
  ISO_WEEK?: string;
}

// 조회 O_RC3(주)/O_RC4(월) ratio pivot — LINE_TOTAL_LOAD working-time 비율(M4b, PKG body LINE 3581~3620).
//   고정 5키 + 동적 W_/M_ 컬럼(RATIO 값). 매칭키 = DIVISION_ID/SCM_SITE_ID/OPERATION_ID/LINE_ID/MEASURE.
export type RatioRow = Record<string, unknown>;
