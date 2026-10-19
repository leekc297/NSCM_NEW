export const MENU_ID = 'SCP0120' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  LOOKUP_MASTER = 'lookupMaster',
  LOOKUP_DETAIL = 'lookupDetail',
}

/**
 * 응답 커서 키. PKG 인자명은 O_RC1 이지만 FE 응답키는 SCM_ADM_PROC_M.COL_NM 축이고
 * 실측값이 o_rc 다. 자매 SCP0122 는 o_rc1 이라 constants 를 복사하면 조용히 빈 그리드가 된다.
 */
export enum RESPONSE_SET {
  SAVE = 'o_rc',
}

export type ActiveGrid = 'main' | 'sub';

/** 조회조건 콤보 SQL_ID (design 02 §5.2). 둘 다 05_register.sql 등록분이다. */
export const COMBO = {
  /**
   * Plan Group 후보. PlanGroup / PlanGroup_SCP_ALL 재사용 금지 — owner 필터·정렬이 없어
   * 비관리자에게 전 Plan Group 이 노출된다. 두 콤보는 FE 소비자 2화면이 있어 수정도 금지다.
   */
  PLAN_GROUP: 'PlanGroupByOwner_SCP0120',
  YES_OR_NO: 'YesOrNo',
  /**
   * 관리자 판정. GET SP 의 adminYn IN 파라미터 원천이며 판정은 서버 SQL 이 세션 사용자로 한다
   * (GET_ADMIN_GROUP / SEGMENT2='SCP0120' 메타 기반) — 그룹명 FE 하드코딩 금지.
   */
  ADMIN_YN: 'AdminYn_SCP0120',
} as const;

/** 관리자 판정 콤보가 'Y' 를 돌려줄 때의 CODE 값. */
export const ADMIN_YN_TRUE = 'Y';

export const LBL = {
  LOOKUP_TYPE: 'LBL00057',
  PLAN_GROUP: 'LBL00002',
  /** AS-IS 문구는 Valid(LBL00639) 지만 TO-BE 조회조건 카탈로그가 Active 로 개명을 지정했다. */
  ACTIVE: 'LBL00007',
  LOOKUP_VALUES: 'LBL00637',
  SEARCH: 'LBL00112',
} as const;

/**
 * AS-IS 메시지 번호를 그대로 쓰지 않는다 — 번호가 겹치면서 의미가 다르다.
 *   저장성공 AS-IS MSG00004 -> TO-BE MSG00672 (TO-BE MSG00004 는 "No changes to save.")
 *   변경0건  AS-IS MSG00133 -> TO-BE MSG00004
 *   필수     AS-IS MSG00002 -> TO-BE MSG00429 (TO-BE MSG00002 는 "Saved successfully.")
 *   중복     MSG00060 은 번호·의미 모두 일치
 */
export const MSG = {
  SAVE_SUCCESS: 'MSG00672',
  NO_CHANGES: 'MSG00004',
  /**
   * 필수 미입력. 이 화면 코드에서는 참조하지 않는다 — 공용 `useSaveWithValidation` 이
   * `CRUD_MSG.REQUIRED_FIELD`(= 같은 번호) 로 직접 발신한다. dead 상수가 아니라
   * AS-IS MSG00002 -> TO-BE MSG00429 매핑을 남기는 기록이다(삭제 금지).
   */
  REQUIRED: 'MSG00429',
  DUPLICATE: 'MSG00060',
  SELECT_LOOKUP_TYPE: 'MSG00624',
  /** 조회권한 없음 — AS-IS R-29 CanSelect 불통과 시의 안내와 같은 자리. */
  NO_PERMISSION: 'MSG00096',
  /** DISPLAY_SEQ 정수 사전검사 실패. SP 의 ORA-20002 원문 노출을 대신한다. */
  INTEGER_ONLY: 'MSG00460',
  /** 저장 대상이 아닌 영역에 변경분이 남아 있을 때의 확인 문구(전용 MSG 미등록 대체분). */
  UNSAVED_DATA: 'MSG01059',
} as const;

/**
 * Sub 그리드 동적 3축(표시/라벨/필수)의 대상 컬럼 25개 = AS-IS sColumnList (cs:38~40).
 * 마스터 행의 이 컬럼 "값"이 곧 디테일 컬럼의 이름이다.
 * 주의: SYS0010 은 SEGMENT1~5 + ATTRIBUTE1~15 = 20개다. 그대로 복사하면 SEGMENT6~10 이 빠진다.
 */
export const DYNAMIC_SUB_COLUMNS = [
  'SEGMENT1',
  'SEGMENT2',
  'SEGMENT3',
  'SEGMENT4',
  'SEGMENT5',
  'SEGMENT6',
  'SEGMENT7',
  'SEGMENT8',
  'SEGMENT9',
  'SEGMENT10',
  'ATTRIBUTE1',
  'ATTRIBUTE2',
  'ATTRIBUTE3',
  'ATTRIBUTE4',
  'ATTRIBUTE5',
  'ATTRIBUTE6',
  'ATTRIBUTE7',
  'ATTRIBUTE8',
  'ATTRIBUTE9',
  'ATTRIBUTE10',
  'ATTRIBUTE11',
  'ATTRIBUTE12',
  'ATTRIBUTE13',
  'ATTRIBUTE14',
  'ATTRIBUTE15',
] as const;

/** 마스터 슬롯 값이 이 문자열이면 그 컬럼이 Plan Group 권한 필터의 대상이 된다(cs:476 exact match). */
export const PLAN_GROUP_SLOT_VALUE = 'PLAN_GROUP';

/** 동적 슬롯 "미사용" 표식 — 이 값이면 Sub 컬럼을 숨긴다(cs:465~468). */
export const UNUSED_SLOT_VALUES = ['', '-', '*'] as const;

/** 중복검증 키 11축 — LOOKUP_TYPE + SEGMENT1~10. Main·Sub 공통(AS-IS CheckValidation 공유). */
export const DUPLICATE_KEY_COLUMNS = [
  'LOOKUP_TYPE',
  'SEGMENT1',
  'SEGMENT2',
  'SEGMENT3',
  'SEGMENT4',
  'SEGMENT5',
  'SEGMENT6',
  'SEGMENT7',
  'SEGMENT8',
  'SEGMENT9',
  'SEGMENT10',
] as const;

/** SP 가 REGEXP_LIKE 로 거는 검사와 같은 식. 불통과면 ORA-20002 라 FE 가 먼저 막는다. */
export const DISPLAY_SEQ_PATTERN = /^[+-]?[0-9]{1,10}$/;
/** SP 범위 검사(PKG L813~821)와 같은 한계값. */
export const DISPLAY_SEQ_MAX = 2147483647;
