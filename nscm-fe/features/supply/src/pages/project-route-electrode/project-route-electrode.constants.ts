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

// GET(PKG_SCP0027.P_SCP0027_GET_PROJECTROUTE_ELECTRODE) OUT 커서 결과 key — SCM_ADM_PROC_M 실측
//   (2026-10-21 ora.py): mainList(그리드) / allList(저장검증 전체 route) / itemList(전극아이템·N0·NICK_NAME).
//   그리드 바인딩 정본 = 'mainList'(AS-IS Tables[0]=O_MAIN_LIST). 당초 'o_rc1'("단일 커서" 오판)은
//   mainData?.['o_rc1']=undefined → 그리드가 빈 채로 뜨던 결함(자매 SCP0048 이 2026-10-16 'mainList' 로 정정).
//   allList/itemList 는 저장검증(F-5)·N0/NICK_NAME(F-7) 에서 읽는다.
export enum RESPONSE_SET {
  MAIN = 'mainList',
}

// GET 2·3번째 커서 key — 그리드 바인딩이 아니라 저장검증 전용 데이터(컬럼 메타 불요라 RESPONSE_SET enum 과 분리).
//   allList = 조회조건 무관 전체 route(F-5 N1~N6/N9 중첩·연속성 대조 모집단, AS-IS dsFullBinding).
//   itemList = 전극아이템 목록(F-7 N0 신규행 ITEM_ID 대조, AS-IS dsItemBinding=Tables[2]).
export const ALL_LIST_KEY = 'allList' as const;
export const ITEM_LIST_KEY = 'itemList' as const;

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

// 행 타입 잠금 셀의 기본(비편집) 배경. 공용 isEditableCell 은 메타(INPUT_TP_CD='M')만 봐 전 행에 편집
//   스타일(wj-cell-editable=#fff8cd 노랑)을 붙이므로, 행 타입으로 잠긴 셀은 이 흰색을 inline 으로 덮어
//   그리드 기본 컬럼처럼 보이게 한다(wj-cell-editable 은 !important 아님 → inline 우선). $wj-cell 기본색.
export const DEFAULT_CELL_BG_COLOR = '#ffffff';

// 조건부 편집잠금 컬럼 범위(design/03 §3-1, R-LOCK-EXIST-ROW). INPUT_TP_CD 전건 'S' 라 메타로
//   표현 불가 → beginningEdit override 로 배선(리터럴 하드코딩 아님, 업무규칙 화이트리스트).
//   R-LOCK-EXIST-ROW: OPERATION_GROUP≠"E" 행 → PLANT_SITE_ID + PRIORITY~TO_YYYYMMDD 잠금(cs:281-282).
//   VALID_YN 은 제외 — AS-IS 는 LockRange(PRIORITY, TO_YYYYMMDD)(cs:281) + PLANT_SITE_ID(cs:282)만 잠그고
//   그 다음 컬럼 VALID_YN 은 비전극 행에서도 편집 가능하게 둔다. [F-15]
export const LOCK_ON_NON_ELECTRODE = [
  'PLANT_SITE_ID',
  'PRIORITY',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
] as const;
// 전극 기존행(opGroup='E' && PRIORITY_SEQ≠'')은 PLANT_SITE_ID 잠금(AS-IS EditButton cs:286-289).
//   AS-IS 실측(2026-10-22 화면 이미지): Plant Site 는 값이 없는 신규/골격행(PRIORITY_SEQ='')에서만 콤보
//   편집 가능(노랑)이고, 값이 있는 기존 route 세그먼트(PRIORITY_SEQ≠'')는 흰색/잠금이다. 2026-10-21 "전 행
//   편집" 지시는 AS-IS 를 과하게 해석한 것으로 2026-10-22 정정 — 기존 전극행 Plant Site 는 고정.
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
  SAVE_RESULT: 'MSG00002', // 저장 성공 → "Saved successfully."(design/03 §4.2 "S"=성공). AS-IS MSG00004는 TO-BE에서 "No changes to save."라 의미 오매칭 — MSG00002로 교정(2026-11-03)
  SAVE_ERROR: 'MSG00006', // 저장 에러(O_RESULT_CODE≠S, design/03 §4.2)
  NO_CHANGE: 'MSG00004', // 수정 내용 없음 (AS-IS MSG00133 → TO-BE MSG00004)
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
  N0_ELECTRODE_ITEM: 'MSG01019', // 신규행 ITEM_ID 가 전극아이템 목록에 없음
  N1_END_OVERLAP: 'MSG01129', // 시작일 동일·종료일 상이(중첩 종료일)
  N2_START_OVERLAP: 'MSG01130', // 종료일 동일·시작일 상이(중첩 시작일)
  N3_PLANT_DUP: 'MSG01131', // 동일기간 PlantSite 중복
  N4_PRIORITY_DUP: 'MSG01132', // 동일기간 Priority 중복
  N5_PERIOD_OVERLAP: 'MSG00700', // 중첩기간
  N6_CONTINUITY: 'MSG01133', // 기간 연속성(종료일+1 = 다음 시작일)
  N7_PRIORITY_POSITIVE: 'MSG01134', // Priority 양의 정수
  N8_DATE_ORDER: 'MSG00219', // from>to
  N8_DATE_RANGE: 'MSG00048', // 날짜범위(<17530101 / 공백)
  N9_PRIORITY_ONE: 'MSG01137', // 동일기간 Priority=1 존재
} as const;

/**
 * 저장검증 실패 알람 fallback 문구 — N 메시지(MSG00212~00220·00257·00107)가 SCM_ADM_MSG_M 에 미등록이라
 * t(msgId) 가 번역을 못 찾아 일반 '_저장 검증 실패' 로만 뜨던 문제 보완(어느 검증 실패인지 식별 불가).
 * t() 2번째 인자(코드 fallback)로 넘기므로 DB 등록 시 자동으로 DB 번역이 우선한다(locale JSON 수기편집 아님).
 * 문구는 AS-IS SaveData 검증 의미 기준(design/03 §3-4).
 */
export const MSG_VALIDATION_FALLBACK: Record<string, string> = {
  [MSG.N0_ELECTRODE_ITEM]: '_선택한 품번이 전극 아이템 목록에 없습니다.',
  [MSG.N1_END_OVERLAP]: '_동일 시작일에 종료일이 다른 데이터가 있습니다.',
  [MSG.N2_START_OVERLAP]: '_동일 종료일에 시작일이 다른 데이터가 있습니다.',
  [MSG.N3_PLANT_DUP]: '_동일 기간에 Plant Site 가 중복됩니다.',
  [MSG.N4_PRIORITY_DUP]: '_동일 기간에 Priority 가 중복됩니다.',
  [MSG.N5_PERIOD_OVERLAP]: '_기간이 다른 일정과 중첩됩니다.',
  [MSG.N6_CONTINUITY]: '_기간이 연속되지 않습니다(종료일 +1 = 다음 시작일).',
  [MSG.N7_PRIORITY_POSITIVE]: '_Priority 는 1 이상의 정수여야 합니다.',
  [MSG.N8_DATE_ORDER]: '_시작일이 종료일보다 클 수 없습니다.',
  [MSG.N8_DATE_RANGE]: '_유효하지 않은 날짜입니다.',
  [MSG.N9_PRIORITY_ONE]: '_동일 기간에 Priority 1 데이터가 존재해야 합니다.',
};

// 다국어 LABEL(design/02 §4.5, 전건 기존 등록 — 신규 0건). i18n key 유지.
//   EDIT/CANCEL(Edit 토글 버튼)은 전사 공통 등록코드: LBL00414='Edit'/'수정', LBL00394='Cancel'/'취소'
//   (자매 SCP0048 G-7 실측 재사용). 신규 INSERT 없이 기등록 코드 재사용.
export const LBL = {
  SEARCH: 'LBL00112',
  DIVISION: 'LBL00001',
  PLANT_SITE: 'LBL00005',
  OPERATION_GROUP: 'LBL00027',
  // 조회조건 #4 명칭 To-Be 변경(SCP0027.md): Model→Model/Nickname = LBL00618(실측 EN/KO). AS-IS 는 Model(LBL00669). [F-12a]
  MODEL: 'LBL00618',
  // 조회조건 #5 명칭 To-Be 변경(SCP0027.md): Valid→Active = LBL00007(실측 'Active' EN/KO). AS-IS 는 Valid(LBL00639). [F-12b]
  ACTIVE: 'LBL00007',
  ALL: 'LBL00632',
  EDIT: 'LBL00414',
  CANCEL: 'LBL00394',
} as const;
