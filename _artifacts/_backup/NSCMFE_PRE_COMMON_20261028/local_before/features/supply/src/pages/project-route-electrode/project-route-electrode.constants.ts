// SCP0027 ProjectRoute Electrode — 상수/메타 매핑.
//   AS-IS: GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0027_ProjectRoute_Electrode/SCP0027_ProjectRoute_Electrode.cs
//   설계: .atlas/gscm-design/SCP0027/design/00~03. 자매화면 project-route-warranty(SCP0048) 골격 준용.
//   RESPONSE_SET/SHEETS 는 procedures.d.ts 미등재(SCP0027 미배포) → Base index-signature fallback.

export const MENU_ID = 'SCP0027' as const;
export type MENU_ID = typeof MENU_ID;

// BE 프로시저 라우팅 키(SCM_ADM_MNU_BTN_MPG_M.SHT_NM) + procedures.d.ts sheetName.
//   단일 시트 화면(spdMain) — GET/SAVE 공통 키.
// 값 'Main'(대문자) 근거: SCP0027 은 DB 에 SEARCH/SAVE 버튼·API 가 SHT_NM='Main',
//   API_ID='SCP0027_Main_SEARCH'/'SCP0027_Main_SAVE' 로 배포돼 있다(2026-09-26 ora.py 실측).
//   BE 버튼권한 검증(PKG_NSCM_UI_COM_AUTH: GMB.SHT_NM = P_SHT_NM)은 대소문자 구분이라, FE URL
//   세그먼트가 배포값과 정확히 일치해야 call-proc 권한이 통과한다(참조: [[sht-nm-case-sensitive-per-screen]]).
//   컬럼 메타(SCM_MST_SHEET_COLUMNS.SHEET_NAME)도 'Main' 실측이라 정합한다.
export enum SHEETS {
  MAIN = 'Main',
}

// 각 시트 커서 결과 key. NSCM 단일 cursor 표준 = 'o_rc1'(자매 SCP0048/SCP0006 등 단일그리드
//   supply 화면 공통). SCP0027 GET(P_SCP0027_GET_PROJECTROUTE_ELECTRODE)도 단일 OUT 커서 1개라
//   표준 'o_rc1' 로 읽는다. 미배포(procedures.d.ts 미등재)라 Base index-signature fallback 이며,
//   실제 반환 키는 배포 후 재확인 대상(04_react-gap).
export enum RESPONSE_SET {
  MAIN = 'o_rc1',
}

/**
 * 컬럼 메타 fetch(/admin/menu/SCP0027/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과
 * 정확히 일치해야 한다(BE 문자열 매칭). SCP0027 은 단일 시트(AS-IS spdMain)이며 DB SHEET_NAME
 * 이 'Main'(31컬럼)으로 배포됨(design/03 §1, 2026-09-26 ora.py 실측).
 */
export const COLUMN_SHEET_NAME: Record<RESPONSE_SET, string> = {
  [RESPONSE_SET.MAIN]: 'Main',
};

// OPERATION_GROUP 업무분기 키(design/03 §1 col18, R-INS/R-LOCK/N9). E=Electrode 가 이 화면 기본.
//   lookup detail 실측: P=Pack, A=Cell, E=Electrode(design/02 §2-3).
export const OPERATION_GROUP_ELECTRODE = 'E';
// Insert 가드 — OperationGroup∈{P,A} 신규행 무음 차단(design/01 §2.4, cs:548~549 "메세지추가 필요"
//   TODO — AS-IS 도 메시지 없이 return). 전극(E) 전용 화면.
export const INSERT_BLOCKED_OPERATION_GROUPS = ['P', 'A'] as const;

// 신규행 기본값(design/01 §2.4 R-INS, cs:551~572). DIVISION_ID 는 조회조건 division(len!=2 → "")으로
//   화면이 채운다. AS-IS 6종: DIVISION_ID / VALID_YN='Y' / OPERATION_GROUP='E' / SCM_SITE_ID='-' /
//   PROJECT_CODE='-' / OPERATION_GROUP_NAME='Electrode'.
export const NEW_ROW_DEFAULT_VALID_YN = 'Y';
export const NEW_ROW_DEFAULT_SCM_SITE_ID = '-';
export const NEW_ROW_DEFAULT_PROJECT_CODE = '-';
export const NEW_ROW_DEFAULT_OPERATION_GROUP_NAME = 'Electrode';

// 저장검증 실패 셀 배경 강조(design/03 §3.4, AS-IS SetBGColor(InvalidColor)). 자매 SCP0048 동일값 준용.
export const INVALID_CELL_BG_COLOR = '#cce5ff';

// 조건부 편집잠금 컬럼 범위(design/03 §3-1, R-LOCK-EXIST-ROW). INPUT_TP_CD 전건 'S' 라 메타로
//   표현 불가 → beginningEdit override 로 배선(리터럴 하드코딩 아님, 업무규칙 화이트리스트).
//   R-LOCK-EXIST-ROW: OPERATION_GROUP≠"E" 행 → PRIORITY~TO_YYYYMMDD + PLANT_SITE_ID 잠금(cs:445~448).
export const LOCK_ON_NON_ELECTRODE = [
  'PLANT_SITE_ID',
  'PRIORITY',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
  'VALID_YN',
] as const;
// OPERATION_GROUP=="E" & PRIORITY_SEQ≠"" (기존 저장행) → PLANT_SITE_ID 잠금(cs:452~455, 신규행만 편집).
export const LOCK_ON_ELECTRODE_EXISTING = ['PLANT_SITE_ID'] as const;

// 항상 편집불가(감사·파생·키). NICK_NAME/TACT_TIME_FLAG/OPERATION_GROUP_NAME 는 파생 잠금.
//   DIVISION_ID 는 조회행 잠금(신규행만 화면이 별도 허용, design/03 R-COMBO-DIV).
export const ALWAYS_LOCKED_COLUMNS = [
  'DIVISION_ID', // 조회행 잠금(신규행만 셀콤보 편집 허용)
  'OPERATION_GROUP_NAME', // 파생 표시(cs:463 신규행 락)
  'ITEM_ID', // 셀 더블클릭 팝업으로만 입력(cs:273 초기락)
  'NICK_NAME', // ITEM_ID → FN_GET_ITEM_NICKNAME 파생(cs:462 락)
  'TACT_TIME_FLAG', // PLANT_SITE_ID 파생(cs:274/464 항상 락)
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
] as const;

// 셀 콤보 SQL_ID(design/03 §1 비고, DB 실측 USE_YN=Y). VALID_YN 만 정적메타(YesOrNo) 자동배선,
//   DIVISION_ID(신규행 MyDivision)·PLANT_SITE_ID(ElecRoutePlantByOperation_SCP 3-bind)는 §3 코드배선.
// 조회조건 콤보(design/02 §2): clbDivision=MyDivision(EE 제외 SQL 내재), clbPlantSite=
//   PlantSiteByDivision(@divisionId cascade), cboOperationGroup=LookupCommon(P/A/E), cboValid=YesOrNo.
// 주의(combo-semantic-parity): SCP0027 clbDivision 은 MyDivision 이다(자매 SCP0048 은 Division_SCP).
//   MyDivision SQL 은 ATTRIBUTE3<>'EE' + 권한 subquery 를 SQL 안에서 처리하므로 화면단 EE 필터가
//   불필요하다(design/02 §2-1). 셀콤보 DIVISION_ID(신규행 전용)도 동일 MyDivision 을 쓴다.
export const COMBO = {
  DIVISION: 'MyDivision',
  PLANT_SITE: 'PlantSiteByDivision',
  OPERATION_GROUP: 'LookupCommon',
  VALID: 'YesOrNo',
  // 셀 콤보(그리드 소관, design/03 §1 비고)
  CELL_DIVISION: 'MyDivision', // DIVISION_ID 신규행 전용(getDisplayValues, insert-only)
  CELL_PLANT_SITE: 'ElecRoutePlantByOperation_SCP', // @divisionId/@itemId/@operationGroup 3-bind
  CELL_VALID_YN: 'YesOrNo',
} as const;

// 조회조건 OperationGroup 콤보 — LookupCommon @lookupType='OPERATION_GROUP'(design/02 §2-3).
//   useTabLookupQueries({ lookupType }) 규격(자매 working-time DAY_WEEK_LOOKUP 패턴).
//   SEGMENT1 AS CODE / SEGMENT2 AS NAME 반환(P/A/E).
export const OPERATION_GROUP_LOOKUP = { lookupType: 'OPERATION_GROUP' } as const;

// cboValid ALL sentinel(design/02 §2-4) — SP 파라미터 DBNull(빈값) 치환. getValid: ALL→"".
export const ALL_SENTINEL = 'ALL';

// AS-IS MSG ID 매핑(design/01·03 저장검증 N0~N9 + 상호작용 검증). i18n key 유지.
//   TO-BE 미등록 AS-IS 코드는 문구기준 재매핑(자매 SCP0048 G-6 선례 준용). 재매핑분은 04_react-gap 에 기록.
export const MSG = {
  REQUIRE_DIVISION: 'MSG00097', // 권한 division 없음(R-AUTH, design/01 §2.7)
  SAVE_RESULT: 'MSG00004', // 저장 성공(design/03 §4.2 "S"=성공 → MSG00004)
  SAVE_ERROR: 'MSG00006', // 저장 에러(O_RESULT_CODE≠S, design/03 §4.2)
  NO_CHANGE: 'MSG00133', // 수정 내용 없음
  // Edit 진입 시 데이터 없음(R-EDIT, cs:428~432). AS-IS MSG00259 는 TO-BE 미등록 → 문구기준 재매핑
  //   MSG00662("Edit mode is available after search." 3언어 등록)로 통일(자매 SCP0048 G-6 선례).
  EDIT_NO_DATA: 'MSG00662',
  // Item/PlantSite 조작 시 division 공백(R-FIND/R-COMBO-RESET, cs:902~909). AS-IS MSG00093 은
  //   "{0}을(를) 선택하십시오." — TO-BE MSG00097("Please select Division.")로 통일(자매 SCP0048 G-6).
  REQUIRE_DIVISION_CELL: 'MSG00097',
  // Valid 수정 불가 되돌림(R-VALID, cs:763~764). AS-IS MSG00211 은 TO-BE 미등록 → 문구기준 재매핑
  //   MSG01222("Can not modify its Valid." 3언어 등록)로 통일(자매 SCP0048 G-6).
  VALID_REVERT: 'MSG01222',
  // 저장검증 N0~N9(design/03 §3-4). AS-IS MSG 코드 그대로 유지(TO-BE 등록 실측분).
  N0_ELECTRODE_ITEM: 'MSG00257', // 신규행 ITEM_ID 가 전극아이템 목록에 없음
  N1_END_OVERLAP: 'MSG00212', // 시작일 동일·종료일 상이(중첩 종료일)
  N2_START_OVERLAP: 'MSG00213', // 종료일 동일·시작일 상이(중첩 시작일)
  N3_PLANT_DUP: 'MSG00214', // 동일기간 PlantSite 중복
  N4_PRIORITY_DUP: 'MSG00215', // 동일기간 Priority 중복
  N5_PERIOD_OVERLAP: 'MSG00216', // 중첩기간
  N6_CONTINUITY: 'MSG00217', // 기간 연속성(종료일+1 = 다음 시작일)
  N7_PRIORITY_POSITIVE: 'MSG00107', // Priority 양의 정수
  N8_DATE_ORDER: 'MSG00219', // from>to
  N8_DATE_RANGE: 'MSG00048', // 날짜범위(<17530101 / 공백)
  N9_PRIORITY_ONE: 'MSG00220', // 동일기간 Priority=1 존재
} as const;

// 다국어 LABEL(design/02 §4.5, 전건 기존 등록 — 신규 0건). i18n key 유지.
//   EDIT/CANCEL(Edit 토글 버튼)은 전사 공통 등록코드: LBL00414='Edit'/'수정', LBL00394='Cancel'/'취소'
//   (자매 SCP0048 G-7 실측 재사용). 신규 INSERT 없이 기등록 코드 재사용.
export const LBL = {
  SEARCH: 'LBL00112',
  DIVISION: 'LBL00001',
  PLANT_SITE: 'LBL00005',
  OPERATION_GROUP: 'LBL00027',
  MODEL: 'LBL00669',
  VALID: 'LBL00639',
  ALL: 'LBL00632',
  EDIT: 'LBL00414',
  CANCEL: 'LBL00394',
} as const;
