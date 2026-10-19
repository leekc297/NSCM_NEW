// SCP0048 ProjectRoute Warranty — 상수/메타 매핑.
//   AS-IS: GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0048_ProjectRoute_Warranty/SCP0048_ProjectRoute_Warranty.cs
//   설계: .atlas/gscm-design/SCP0048/design/00~03. 자매화면 project-route(SCP0006) 골격 준용.
//   RESPONSE_SET/SHEETS 는 procedures.d.ts SCP0048 정합.

import type { ComboResponse } from '@foundation/models';

export const MENU_ID = 'SCP0048' as const;
export type MENU_ID = typeof MENU_ID;

// BE 프로시저 라우팅 키(SCM_ADM_MNU_BTN_MPG_M.SHT_NM) + procedures.d.ts sheetName.
//   단일 시트 화면(spdMain) — GET O_MAIN_LIST / SAVE 공통 키.
// 값 'Main'(대문자) 근거: SCP0048 은 DB 에 이미 SEARCH/SAVE 버튼·API 가 SHT_NM='Main',
//   API_ID='SCP0048_Main_SEARCH'/'SCP0048_Main_SAVE' 로 배포돼 있다(2026-09-25 실측). BE 버튼권한
//   검증(PKG_NSCM_UI_COM_AUTH: GMB.SHT_NM = P_SHT_NM)은 대소문자 구분이라, FE URL 세그먼트가
//   배포값과 정확히 일치해야 call-proc 권한이 통과한다. 자매 SCP0006 은 소문자(site/bom/plant)지만
//   SHT_NM 케이싱은 전사 공통 규약이 아니라 화면별 배포값이 정본이다(전 SCP 화면 SHT_NM 실측:
//   Main/Plant 대문자와 bom/site 소문자 혼재). 따라서 SCP0048 은 배포 정본 'Main' 을 따른다.
export enum SHEETS {
  MAIN = 'Main',
}

// 각 시트 커서 결과 key(call-proc response 의 실제 cursor 키). NSCM 단일 cursor 표준 = 'o_rc1'
//   (자매 SCP0005/SCP0002/SCP0007 등 단일그리드 supply 화면 공통). SCP0048 GET(P_SCP0048_GET_
//   PROJECTROUTE_WARRANTY)도 단일 OUT 커서 1개라 표준 'o_rc1' 로 읽는다. 미배포(procedures.d.ts
//   미등재)라 Base index-signature fallback 이며, 실제 반환 키는 배포 후 재확인 대상(04_react-gap).
export enum RESPONSE_SET {
  MAIN = 'o_rc1',
}

/**
 * 컬럼 메타 fetch(/admin/menu/SCP0048/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과
 * 정확히 일치해야 한다(BE 문자열 매칭). SCP0048 은 단일 시트(AS-IS spdMain)이며 DB SHEET_NAME
 * 으로 'Main' 배포된 것으로 본다(design/03 §1). 라이브 확인필요(design/03 §6).
 */
export const COLUMN_SHEET_NAME: Record<RESPONSE_SET, string> = {
  [RESPONSE_SET.MAIN]: 'Main',
};

// 사업부 분기 — div=81 만 SCM_SITE_ID/PROJECT_CODE 팝업 반환·필수(design/03 R-D5~D7, N10).
//   그 외 사업부는 두 컬럼 "-" 고정. div=82 는 PLANT_SITE_ID 콤보 비움(design/03 R-C5).
export const DIVISION_81 = '81';
export const DIVISION_82 = '82';
export const isSalesSitePopupDivision = (divisionId: string): boolean => divisionId === DIVISION_81;

// OPERATION_GROUP 업무분기 키(design/03 §1 col18, R-L2/R-L3/N9/N11). W=Warranty 가 이 화면 기본.
export const OPERATION_GROUP_WARRANTY = 'W';
// Insert 가드 — OperationGroup∈{P,A} 신규행 차단(design/03 §4.1 Insert 가드, buttonGuards).
export const INSERT_BLOCKED_OPERATION_GROUPS = ['P', 'A'] as const;

// 신규행 기본값(design/03 §4.1). DIVISION_ID 는 조회조건 division(len!=2 → "")으로 화면이 채운다.
export const NEW_ROW_DEFAULT_VALID_YN = 'Y';
export const NEW_ROW_DEFAULT_PRIORITY = '11';
export const NEW_ROW_DEFAULT_SCM_SITE_ID = '-';
export const NEW_ROW_DEFAULT_PROJECT_CODE = '-';
export const NEW_ROW_DEFAULT_OPERATION_GROUP_NAME = 'Warranty';

// 저장검증 실패 셀 배경 강조(design/03 §3.4 R-B1/R-B2, AS-IS SetBGColor(InvalidColor)).
//   자매 BOD(BodGrid SAVE_ERROR_BG_COLOR)와 동일 푸른계통 값 준용.
export const INVALID_CELL_BG_COLOR = '#cce5ff';

// 조건부 편집잠금 컬럼 범위(design/03 §3.3, R-L2/R-L3). INPUT_TP_CD 전건 'S' 라 메타로 표현 불가 —
//   beginningEdit override 로 배선(리터럴 하드코딩 아님, 업무규칙 화이트리스트).
//   R-L2: OPERATION_GROUP≠"W" 행 → PLANT_SITE_ID~VALID_YN 잠금.
export const LOCK_ON_NON_WARRANTY = [
  'PLANT_SITE_ID',
  'SCM_SITE_ID',
  'PROJECT_CODE',
  'PRIORITY',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
  'VALID_YN',
] as const;
// R-L3: OPERATION_GROUP=="W" & PRIORITY_SEQ≠"" (기존 저장행) → PLANT_SITE_ID~PROJECT_CODE 잠금.
export const LOCK_ON_WARRANTY_EXISTING = ['PLANT_SITE_ID', 'SCM_SITE_ID', 'PROJECT_CODE'] as const;

// 항상 편집불가(감사·파생·키·working 컬럼). NICK_NAME/TACT_TIME_FLAG 는 파생 잠금.
export const ALWAYS_LOCKED_COLUMNS = [
  'DIVISION_ID', // 조회행 잠금(신규행만 화면이 별도 허용)
  'OPERATION_GROUP_NAME',
  'NICK_NAME',
  'TACT_TIME_FLAG',
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
] as const;

// 셀 콤보 SQL_ID(design/03 §3.1 R-C1~C6, DB 실측). VALID_YN 만 정적메타(YesOrNo) 자동배선,
//   DIVISION_ID(신규행 MyDivision)·PLANT_SITE_ID(ElecRoutePlantByOperation_SCP 3-bind)는 §3 코드배선.
// 조회조건 콤보(design/02 §5): clbDivision=Division_SCP(+클라 EE 제외), clbPlantSite=
//   PlantSiteByDivision(@divisionId cascade), cboOperationGroup=LookupCommon(숨김), cboValid=YesOrNo.
// 주의(combo-semantic-parity, 이름 유사 재사용 금지): clbDivision 은 MyDivision 이 아니라
//   Division_SCP + 클라 EE 제외다(자매 SCP0006 정정·design/02 §2 실측 확정). DIVISION_ID 셀콤보
//   (신규행 전용)만 MyDivision 을 쓴다 — 서로 다른 용도다.
export const COMBO = {
  DIVISION: 'Division_SCP',
  PLANT_SITE: 'PlantSiteByDivision',
  OPERATION_GROUP: 'LookupCommon',
  VALID: 'YesOrNo',
  // 셀 콤보(그리드 소관, design/03 §3.1)
  CELL_DIVISION: 'MyDivision', // DIVISION_ID 신규행 전용(getDisplayValues, insert-only)
  CELL_PLANT_SITE: 'ElecRoutePlantByOperation_SCP', // @divisionId/@itemId/@operationGroup 3-bind
  CELL_VALID_YN: 'YesOrNo',
} as const;

// LookupCommon @lookupType 값(design/02 §2 #3).
export const OPERATION_GROUP_LOOKUP_TYPE = 'OPERATION_GROUP';

// cboOperationGroup / cboValid ALL sentinel(design/02 §4) — SP 파라미터 DBNull(빈값) 치환.
export const ALL_SENTINEL = 'ALL';

// BLUtils.GetDivisionWithoutEE 2단계 중 화면측 후처리(design/02 §2 #1) — EE(전극) 사업부 제외.
//   Division_SCP 응답의 ATTRIBUTE3 컬럼으로 판정.
export const EXCLUDE_EE_DIVISION = (row: ComboResponse): boolean =>
  String(row.ATTRIBUTE3 ?? '') !== 'EE';

// AS-IS MSG ID 매핑(design/03 §4.3 저장검증 N1~N11 + 상호작용 검증). i18n key 유지.
export const MSG = {
  REQUIRE_DIVISION: 'MSG00097', // 권한 division 없음(design/02 §7-1, 자매 SCP0006 준용)
  SAVE_RESULT: 'MSG00002', // 저장 성공 토스트(자매 SCP0006 SAVE_RESULT 관례 준용)
  SAVE_ERROR: 'MSG00006', // 저장 에러(O_RESULT_CODE≠S)
  NO_CHANGE: 'MSG00133', // 수정 내용 없음
  // Edit 진입 시 데이터 없음(R-G2). AS-IS MSG00259 는 TO-BE 미등록 → 문구기준 재매핑
  //   MSG00662("Edit mode is available after search." 3언어 등록)로 통일(자매 mkt-fcst/forecast-price 선례, G-6).
  EDIT_NO_DATA: 'MSG00662',
  // Item/PlantSite 조작 시 division 공백(R-G4). AS-IS MSG00093 은 TO-BE 미등록 → 문구기준 재매핑
  //   MSG00097("Please select Division." 3언어 등록)로 통일(자매 shipment-*/operation-lt 선례, G-6).
  REQUIRE_DIVISION_CELL: 'MSG00097',
  // Valid 수정 불가 되돌림(R-D3). AS-IS MSG00211 은 TO-BE 미등록 → 문구기준 재매핑
  //   MSG01222("Can not modify its Valid." / "해당 Valid는 수정할 수 없습니다." 3언어 등록)로 통일(G-6).
  VALID_REVERT: 'MSG01222',
  // 저장검증 N1~N11(design/03 §4.3 순서: N1→N2→N5→N3→N4→N7→N8→N9→N10→N11)
  N1_END_OVERLAP: 'MSG00212', // 중첩 종료일자
  N2_START_OVERLAP: 'MSG00213', // 중첩 시작일자
  N5_PERIOD_OVERLAP: 'MSG00215', // 중첩기간(기간 겹침)
  N5_PERIOD_OVERLAP_ALT: 'MSG00216', // 중첩기간(Priority 중복/기간중첩 분기)
  N3_PLANT_DUP: 'MSG00214', // Plant Site 중복
  N4_PRIORITY_DUP: 'MSG00215', // Priority 중복(동일기간·PLANT상이·PRIORITY동일)
  N7_PRIORITY_POSITIVE: 'MSG00107', // Priority 양의 정수
  N8_DATE_ORDER: 'MSG00219', // from>to
  N8_DATE_RANGE: 'MSG00048', // 날짜범위(<17530101 / 공백)
  N9_PRIORITY_ONE: 'MSG00220', // Priority=1 존재
  N10_SALES_SITE_REQUIRED: 'MSG00002', // div=81 SCM_SITE_ID/PROJECT_CODE 필수
  // Warranty PRIORITY≥11(N11). AS-IS MSG00322 는 TO-BE 미등록 → 문구기준 재매핑
  //   MSG01319("Warranty Priority must be at least 11." 3언어 등록)로 통일(G-6).
  N11_WARRANTY_PRIORITY: 'MSG01319',
} as const;

// 다국어 LABEL(design/02 §4.5, 전건 기존 등록 — 신규 0건). i18n key 유지.
//   EDIT/CANCEL(Edit 토글 버튼)은 전사 공통 등록코드를 쓴다 — LBL00414='Edit'/'수정', LBL00394='Cancel'/'취소'
//   3언어 등록 실측(2026-09-25 ora.py). iter-1 이 임의로 쓰던 LBL00114(미등록)/LBL00113(실제=Label '라벨')
//   은 오코드라 폐기. 신규 INSERT 없이 기등록 코드 재사용(G-7).
export const LBL = {
  DIVISION: 'LBL00641',
  PLANT_SITE: 'LBL00005',
  OPERATION_GROUP: 'LBL00027',
  MODEL: 'LBL00669',
  VALID: 'LBL00639',
  EDIT: 'LBL00414',
  CANCEL: 'LBL00394',
} as const;
