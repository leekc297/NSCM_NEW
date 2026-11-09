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

// 각 시트 커서 결과 key(call-proc response 의 실제 cursor 키).
//   GET SP(PKG_SCP0048.P_SCP0048_GET_PROJECTROUTE_WARRANTY)는 3 cursor 를 반환한다(2026-10-16
//   ora.py 실측): O_MAIN_LIST→'mainList', O_ALL_LIST→'allList', O_ITEM_LIST→'itemList'.
//   이는 AS-IS DataSet 의 Tables[0]/[1]/[2] 를 그대로 옮긴 것이다(.cs FindData 390~399).
//   그리드 바인딩은 AS-IS 가 siMain.Query(ds)=ds.Tables[0]=O_MAIN_LIST 를 쓰므로 'mainList' 가
//   정본이다. 'allList'(O_ALL_LIST=Tables[1]=dsFullBinding 저장검증 비교본)에는 PLANT_SITE_ID_B
//   (저장원본)·NICK_NAME·TACT_TIME_FLAG·합성 PLANT_SITE_ID 가 없어, 이를 그리드에 바인딩하면
//   plantSiteId 가 저장 payload 에서 빈값이 되고(ORA-01407 ROLLBACK) nick/표시컬럼이 비는 사고가
//   난다(2026-10-16 근본원인 확정). 이전 'allList' 는 세 cursor 중 하나가 온 것을 그리드용으로
//   오인한 것이라 'mainList' 로 바로잡는다. 키 불일치 시 mainData?.[키] 가 undefined 라 그리드가
//   빈 채로 뜬다.
export enum RESPONSE_SET {
  MAIN = 'mainList',
}

/**
 * 컬럼 메타 fetch(/admin/menu/SCP0048/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과
 * 정확히 일치해야 한다(BE 문자열 매칭). SCP0048 은 단일 시트(AS-IS spdMain)이며 DB SHEET_NAME
 * 으로 'Main' 배포된 것으로 본다(design/03 §1). 라이브 확인필요(design/03 §6).
 */
export const COLUMN_SHEET_NAME: Record<RESPONSE_SET, string> = {
  [RESPONSE_SET.MAIN]: 'Main',
};

// SCM_SITE_ID/PROJECT_CODE "없는 값" 표식. AS-IS 는 '-' 였으나 TO-BE 는 '/' 로 통일(2026-10-19).
//   근거: TO-BE PKG_SCP0048 GET SP 가 이미 NVL(NULLIF(..,'-'),'/') / NVL(..,'/') 로 조회 시점에
//   '/' 로 내려준다(ora.py 실측). FE 신규행 기본값·clear·저장 payload 를 '/' 로 맞춰 BE/DB 규약과
//   일치시킨다. '/' 는 null 회피용 기본값이자 유효한 저장값이므로 N10 저장검증은 '/' 를 미입력으로
//   보지 않는다 — 공백/null 과 AS-IS 레거시 '-' 만 미입력(사용자 확인 2026-10-19, isSalesSiteBlank).
export const NO_VALUE_PLACEHOLDER = '/';

// SalesSite 팝업 조회조건으로 넘길 때 "없는 값" 표식은 빈 값으로 보낸다(AS-IS cs:779 .Replace("-","")
//   의 등가). placeholder 가 그대로 넘어가면 그 값으로 좁혀 조회가 0건이 된다. 신규 규약 '/' 와
//   기존 데이터의 '-' 를 둘 다 제거한다(저장검증 isSalesSiteBlank 와 동일 하위호환 규약).
//   placeholder 만으로 채워진 값은 undefined 로 떨궈 조회조건에서 아예 뺀다.
export const stripNoValuePlaceholder = (v: WijmoPrimitive | undefined): string | undefined => {
  const s = String(v ?? '').replace(/[-/]/g, '');
  return s || undefined;
};

// 사업부 분기 — div=81 만 SCM_SITE_ID/PROJECT_CODE 팝업 반환·필수(design/03 R-D5~D7, N10).
//   그 외 사업부는 두 컬럼 "없는 값"(NO_VALUE_PLACEHOLDER) 고정. div=82 는 PLANT_SITE_ID 콤보 비움(design/03 R-C5).
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
export const NEW_ROW_DEFAULT_SCM_SITE_ID = NO_VALUE_PLACEHOLDER;
export const NEW_ROW_DEFAULT_PROJECT_CODE = NO_VALUE_PLACEHOLDER;
export const NEW_ROW_DEFAULT_OPERATION_GROUP_NAME = 'Warranty';

// 저장검증 실패 셀 배경 강조(design/03 §3.4 R-B1/R-B2, AS-IS SetBGColor(InvalidColor)).
//   자매 BOD(BodGrid SAVE_ERROR_BG_COLOR)와 동일 푸른계통 값 준용.
export const INVALID_CELL_BG_COLOR = '#cce5ff';

// 행-조건부 잠금 셀 배경(design/03 §3.3). 공용 DataGrid 가 메타 INPUT_TP_CD='M' 컬럼에 편집 스타일
//   (wj-cell-editable=#fff8cd 노랑)을 붙이므로, R-L2/R-L3 로 잠긴 M 셀은 이 흰색을 inline 으로 덮어
//   그리드 기본 컬럼처럼 보이게 한다(wj-cell-editable 은 !important 아님 → inline 우선, 자매 SCP0027 준용).
export const DEFAULT_CELL_BG_COLOR = '#ffffff';

// 조건부 편집잠금 컬럼 범위(design/03 §3.3, R-L2/R-L3). 메타 INPUT_TP_CD 는 정적 editable 만
//   표현한다(실측 S22/IM3/IO2/M4) — 행-조건부(opGroup·PRIORITY_SEQ) 잠금은 메타로 표현 불가해
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

// 팝업 전용 셀(design/03 §1: editable="팝업") — 키인 편집기를 열지 않는다. 값 입력은 셀 더블클릭
//   팝업(handleDblClick: ITEM_ID→Item, div=81 SCM_SITE_ID/PROJECT_CODE→SalesSite)으로만 한다.
//   신규행 등 조건부 잠금(R-L2/R-L3)에 안 걸리는 경우에도 beginningEdit override 가 이 목록은 항상
//   잠가 키인 편집을 막는다(공용 게이트를 cancel=false 로 되돌린 뒤에도 유지).
export const POPUP_ONLY_COLUMNS = ['ITEM_ID', 'SCM_SITE_ID', 'PROJECT_CODE'] as const;

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
  SAVE_ERROR: 'MSG00618', // 저장 중 오류가 발생했습니다.(TO-BE DB 실측 정정, O_RESULT_CODE≠S)
  NO_CHANGE: 'MSG00004', // 수정한 내용이 없습니다.(TO-BE DB 실측 정정)
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
  //   AS-IS MSG ID(00212/213/214/215/216/220/048)는 TO-BE 미등록 → 문구기준 재매핑(G-6).
  //   동일 영문/국문 텍스트가 TO-BE SCM_ADM_MSG_M 에 신 ID 로 3언어·USE_YN=Y 등록(2026-10-16 ora.py 실측):
  //   00212→01223, 00213→01224, 00214→01225, 00215→01226, 00216→01227, 00220→01231, 00048→01080,
  //   00107→01134, 00219→01230. (00107·00219 는 당초 TO-BE 기등록으로 보았으나 ora.py 실측 결과 미등록
  //   이라 문구기준 재매핑으로 정정. MSG00107 vs MSG01134 동일성은 사용자 제보로 확인.)
  N1_END_OVERLAP: 'MSG01223', // 중첩 종료일자(AS-IS MSG00212 재매핑)
  N2_START_OVERLAP: 'MSG01224', // 중첩 시작일자(AS-IS MSG00213 재매핑)
  N5_PERIOD_OVERLAP: 'MSG01226', // 중첩기간-Priority 중복(AS-IS MSG00215 재매핑)
  N5_PERIOD_OVERLAP_ALT: 'MSG01227', // 중첩기간-기간 겹침(AS-IS MSG00216 재매핑)
  N3_PLANT_DUP: 'MSG01225', // Plant Site 중복(AS-IS MSG00214 재매핑)
  N4_PRIORITY_DUP: 'MSG01226', // Priority 중복(AS-IS MSG00215 재매핑)
  N7_PRIORITY_POSITIVE: 'MSG01134', // Priority 양의 정수(AS-IS MSG00107 재매핑)
  N8_DATE_ORDER: 'MSG01230', // from>to(AS-IS MSG00219 재매핑)
  N8_DATE_RANGE: 'MSG01080', // 날짜범위(<17530101 / 공백)(AS-IS MSG00048 재매핑)
  N9_PRIORITY_ONE: 'MSG01231', // Priority=1 존재(AS-IS MSG00220 재매핑)
  // div=81 SCM_SITE_ID/PROJECT_CODE 필수. AS-IS 는 MSG00002("Salse Site Code, Project" 치환)로 썼으나
  //   TO-BE DB 의 MSG00002 는 "Saved successfully./저장되었습니다"(성공문구)라 충돌(ora.py 실측
  //   2026-10-19). 문구기준 재매핑으로 표준 필수문구 MSG00429("{0} value is required.")에 항목명 치환.
  N10_SALES_SITE_REQUIRED: 'MSG00429',
  N10_SALES_SITE_LABEL: 'Sales Site Code, Project', // MSG00429 {0} 치환 인자(AS-IS GetTerm 인자)
  // Warranty PRIORITY≥11(N11). AS-IS MSG00322 는 TO-BE 미등록 → 문구기준 재매핑
  //   MSG01319("Warranty Priority must be at least 11." 3언어 등록)로 통일(G-6).
  N11_WARRANTY_PRIORITY: 'MSG01319',
} as const;

// 저장검증 msgId 별 fallback 문구(MSG-03 `_` 접두). 재매핑 결과 N1~N11 전건이 TO-BE
//   SCM_ADM_MSG_M 에 3언어·USE_YN=Y 로 등록되어 있으므로(2026-10-16 ora.py 실측) 런타임은 DB
//   문구로 표시한다 → fallback 은 DB 미표시(캐시 누락 등) 대비용 안전망이며 정상 흐름에선 쓰이지
//   않는다. 키는 MSG 상수의 신 ID 와 일치시켜 둔다. 별도 DB INSERT 는 하지 않는다.
export const SAVE_VALIDATION_FALLBACK: Record<string, string> = {
  MSG01223: '_중첩되는 종료일자가 있습니다.\n리스트 확인 후 입력하십시오.',
  MSG01224: '_중첩되는 시작일자가 있습니다.\n리스트 확인 후 입력하십시오.',
  MSG01225: '_동일 기간에 Plant Site가 중복되었습니다.\n리스트 확인 후 입력하십시오.',
  MSG01226: '_동일 기간에 Priority가 중복되었습니다.\n리스트 확인 후 입력하십시오.',
  MSG01227: '_중첩된 기간이 있습니다.\n리스트 확인 후 입력하십시오.',
  MSG01231: '_해당 기간에 Priority 1이 없습니다.\n리스트 확인 후 입력하십시오.',
  MSG01134: '_Priority는 양의 정수입니다.',
  MSG01230: '_시작일자가 종료일자보다 늦을 수 없습니다.\n리스트 확인 후 입력하십시오.',
  MSG01080: '_처리가능한 날짜 범위가 아닙니다.',
  MSG01319: '_Warranty의 Priority 는 11 이상 입력해야 합니다.',
  MSG00429: '_{0} 값은 필수 입력 항목입니다.', // N10(div=81 Sales Site/Project 필수) 재매핑
};

// 다국어 LABEL(design/02 §4.5, 전건 기존 등록 — 신규 0건). i18n key 유지.
//   EDIT/CANCEL(Edit 토글 버튼)은 전사 공통 등록코드를 쓴다 — LBL00414='Edit'/'수정', LBL00394='Cancel'/'취소'
//   3언어 등록 실측(2026-09-25 ora.py). iter-1 이 임의로 쓰던 LBL00114(미등록)/LBL00113(실제=Label '라벨')
//   은 오코드라 폐기. 신규 INSERT 없이 기등록 코드 재사용(G-7).
//   MODEL/VALID 명칭 변경(사용자 지시 2026-11-03, 메1 교체 동반): Model→Model/Nickname(LBL00618,
//   자매 SCP0006 동일), Valid→Active(LBL00007). 둘 다 KO/EN/CN·USE_YN=Y 기등록 실측(ora.py 2026-11-03).
export const LBL = {
  SEARCH: 'LBL00112',
  DIVISION: 'LBL00001',
  PLANT_SITE: 'LBL00005',
  OPERATION_GROUP: 'LBL00027',
  MODEL: 'LBL00618', // Model/Nickname(메1 픽커). 구 LBL00669='Model' 에서 변경
  VALID: 'LBL00007', // Active. 구 LBL00639='Valid' 에서 변경
  EDIT: 'LBL00414',
  CANCEL: 'LBL00394',
} as const;
