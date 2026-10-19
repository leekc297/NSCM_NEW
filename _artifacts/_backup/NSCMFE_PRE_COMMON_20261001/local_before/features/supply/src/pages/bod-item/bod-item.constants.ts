export const MENU_ID = 'SCP0030' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * 시트(=BE 프로시저 라우팅 키, SCM_ADM_MNU_BTN_MPG_M.SHT_NM) — DB 실측(2026-09-26):
 *   bodItem / bodItemExcluded × SEARCH/SAVE 4행 등록, API_M 배선 VALID.
 * AS-IS SCP0030_BOD_ITEM.cs spdMain 2시트("BOD ITEM"/"Excluded Item").
 */
export enum SHEETS {
  BOD_ITEM = 'bodItem',
  BOD_EXCLUDED = 'bodItemExcluded',
}

/** NSCM 단일 cursor 표준 'o_rc1' (GET SP 는 O_RC1 + O_RESULT_CURSOR 2커서, o_rc1 이 그리드). */
export const RESPONSE_SET = {
  [SHEETS.BOD_ITEM]: 'o_rc1',
  [SHEETS.BOD_EXCLUDED]: 'o_rc1',
} as const;

/**
 * admin UI Category Setup 의 SHEET_NAME — AS-IS 원본 시트명 그대로(SHEETS value 와 별개).
 * DB 실측(SCM_MST_SHEET_COLUMNS.SHEET_NAME, 2026-09-26): 'BOD ITEM'(37열) / 'Excluded Item'(14열).
 * 주의: 컬럼 메타 조회 SP(PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST)는 SHEET_NAME 을 정확히
 *   일치 비교하므로, fetchStaticColumns 는 SHEETS value('bodItem')가 아니라 이 admin 명을 보낸다.
 */
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.BOD_ITEM]: 'BOD ITEM',
  [SHEETS.BOD_EXCLUDED]: 'Excluded Item',
};

export enum SHEET_INDEX {
  BOD_ITEM,
  BOD_EXCLUDED,
}

/**
 * 팝업 조회 시트(procedures.d.ts SCP0030.itemPopup/bodPopup). 조회 SP·API 배선은 PKG_SCP0030 에
 * 미배포(convert-sp 후속) — 배선 완비, 런타임 실행은 팝업 SP 배포 후(04 리포트 확인필요).
 */
export const POPUP_SHEET = {
  ITEM: 'itemPopup',
  BOD: 'bodPopup',
} as const;

export const SHEET_BY_INDEX: Record<SHEET_INDEX, SHEETS> = {
  [SHEET_INDEX.BOD_ITEM]: SHEETS.BOD_ITEM,
  [SHEET_INDEX.BOD_EXCLUDED]: SHEETS.BOD_EXCLUDED,
};

/**
 * 조회조건 콤보 SQL_ID — DB 실측(SCM_ADM_CMBO_SQL_M, USE_YN='Y' 전건, 2026-09-26).
 * SCP SQL_ID 도출 규칙(convert-core §2.6): Data_SCP.Common(X)→X_SCP / CommonAll(X)→X_SCP_ALL.
 */
export const COMBO_ID = {
  // Division_SCP: @sesUserId 권한필터. ATTRIBUTE3='EE'(전극) 제외는 CMBO 에 없어 FE 클라 필터로 재현
  //   (AS-IS BLUtils.GetDivisionWithoutEE, convert-core §2.6). ATTRIBUTE3 는 Division_SCP SELECT 에 포함.
  DIVISION: 'Division_SCP',
  // From/To Site 동일 원본(ToSiteBOD1_SCP_ALL) — 둘 다 division 클라 필터(AS-IS 02 §1 주2, 후보 동일).
  SITE: 'ToSiteBOD1_SCP_ALL',
  // Incoterms/Trans Mode 는 범용 LookupCommon(@lookupType) — 파라미터로 코드셋 분기.
  LOOKUP_COMMON: 'LookupCommon',
  // Plan Group: PlanGroup_SCP_ALL(SCP_OPMZ_PLAN_GR_M) — division 클라 필터. AS-IS SCP0130 Tables[0] 1:1.
  PLAN_GROUP: 'PlanGroup_SCP_ALL',
  // BOD Item Valid: Y/N 고정.
  YES_OR_NO: 'YesOrNo',
} as const;

export const LOOKUP_TYPE = {
  INCOTERMS: 'INCOTERMS',
  TRANSPORT_MODE: 'TRANSPORT_MODE_CODE',
} as const;

/** 전체선택 sentinel — cascade 필터·조회 시 무필터로 해석(convert-core, bod.util 규약 동일). */
export const ALL = 'ALL';

/**
 * bodItem 시트 컬럼 ID — AS-IS SCP0030_BOD_ITEM.cs + SCM_MST_SHEET_COLUMNS 실측(03 §1-A).
 * 그리드 바인딩은 admin 동적 컬럼(staticColumns)이므로 여기 상수는 로직 참조(편집 화이트리스트/검증/병합)용.
 */
export const BOD_ITEM_COLUMN = {
  SEQ: 'SEQ',
  DIVISION_ID: 'DIVISION_ID',
  CUSTOMER: 'CUSTOMER',
  FROM_SITE_CODE: 'FROM_SITE_CODE',
  FROM_CITY: 'FROM_CITY',
  TO_SITE_CODE: 'TO_SITE_CODE',
  TO_CITY: 'TO_CITY',
  INCOTERMS: 'INCOTERMS',
  SAFETY_STOCK: 'SAFETY_STOCK',
  TRANSPORT_MODE: 'TRANSPORT_MODE',
  ITEM_ID: 'ITEM_ID',
  NICK_NAME: 'NICK_NAME',
  FROM_YYYYMMDD: 'FROM_YYYYMMDD',
  TO_YYYYMMDD: 'TO_YYYYMMDD',
  PRIORITY: 'PRIORITY',
  BOD_ITEM_VALID: 'BOD_ITEM_VALID',
  BOD_VALID: 'BOD_VALID',
  ROUTE_VALID: 'ROUTE_VALID',
  ROUTE_ID: 'ROUTE_ID',
  BOD_ID: 'BOD_ID',
  ORG_FROM_YYYYMMDD: 'ORG_FROM_YYYYMMDD',
  ORG_TO_YYYYMMDD: 'ORG_TO_YYYYMMDD',
} as const;

/** Excluded Item 시트 컬럼 ID — AS-IS + SCM_MST_SHEET_COLUMNS 실측(03 §1-B). */
export const BOD_EXCLUDED_COLUMN = {
  DIVISION_ID: 'DIVISION_ID',
  OPMZ_PLAN_GR_NAME: 'OPMZ_PLAN_GR_NAME',
  ITEM_ID: 'ITEM_ID',
  BOD_ID: 'BOD_ID',
  FROM_SITE_NAME: 'FROM_SITE_NAME',
  TO_SITE_NAME: 'TO_SITE_NAME',
  INCOTERMS: 'INCOTERMS',
  TRANSPORT_MODE: 'TRANSPORT_MODE',
  BOD_EX_FROM_YYYYMMDD: 'BOD_EX_FROM_YYYYMMDD',
  BOD_EX_TO_YYYYMMDD: 'BOD_EX_TO_YYYYMMDD',
  VALID_YN: 'VALID_YN',
  PRE_KEY_VALUES: 'PRE_KEY_VALUES',
} as const;

/**
 * 편집가능 화이트리스트(정본 = SAVE SP JSON 계약, 03 §3-A). AS-IS LockColumn 배열 직접이식 금지(#130).
 * 조회 직후 전셀 readonly, Edit 진입 시에만 이 컬럼들 해제.
 */
export const BOD_ITEM_EDITABLE: readonly string[] = [
  BOD_ITEM_COLUMN.FROM_YYYYMMDD,
  BOD_ITEM_COLUMN.TO_YYYYMMDD,
  BOD_ITEM_COLUMN.PRIORITY,
  BOD_ITEM_COLUMN.SAFETY_STOCK,
  BOD_ITEM_COLUMN.BOD_ITEM_VALID,
];

export const BOD_EXCLUDED_EDITABLE: readonly string[] = [
  BOD_EXCLUDED_COLUMN.BOD_EX_FROM_YYYYMMDD,
  BOD_EXCLUDED_COLUMN.BOD_EX_TO_YYYYMMDD,
  BOD_EXCLUDED_COLUMN.VALID_YN,
];

/** 신규행(Excluded 시트만) 팝업 경유로 채우는 키 컬럼 — 신규행에서만 편집 허용(03 §3-A LockRange 56). */
export const BOD_EXCLUDED_NEW_ROW_KEYS: readonly string[] = [
  BOD_EXCLUDED_COLUMN.DIVISION_ID,
  BOD_EXCLUDED_COLUMN.ITEM_ID,
  BOD_EXCLUDED_COLUMN.BOD_ID,
];

/**
 * 세로 병합 대상(bodItem) — AS-IS SmartColMerge(cs:389/702, 03 §3-E). 같은 키(DIVISION/CUSTOMER/사이트/
 * Incoterms/TransMode)가 여러 FROM/TO 기간 행에 걸쳐 반복되므로 그 grouping 컬럼을 세로 병합. 신규행('I')
 * 제외는 공용 CustomMergeManager 가 처리.
 * 주의: SmartColMerge 는 SCM_MST_SHEET_COLUMNS 의 per-column 병합 플래그로 구동되지 않는다 — 해당 메타
 *   테이블에 병합 플래그 컬럼 자체가 없다(2026-09-26 ora.py 실측, ALL_TAB_COLUMNS 36컬럼 확인). 따라서
 *   병합 대상은 admin 관리 속성이 아니라 화면(프레임워크) 결정이며 여기 상수로 두는 것이 정합이다
 *   (CLAUDE.md §2 "속성 단위 덮어쓰기 금지"는 admin 관리 속성에 한함).
 */
export const BOD_ITEM_MERGE_COLUMNS = new Set<string>([
  BOD_ITEM_COLUMN.DIVISION_ID,
  BOD_ITEM_COLUMN.CUSTOMER,
  BOD_ITEM_COLUMN.FROM_SITE_CODE,
  BOD_ITEM_COLUMN.FROM_CITY,
  BOD_ITEM_COLUMN.TO_SITE_CODE,
  BOD_ITEM_COLUMN.TO_CITY,
  BOD_ITEM_COLUMN.INCOTERMS,
  BOD_ITEM_COLUMN.TRANSPORT_MODE,
]);

/**
 * 세로 병합 대상(Excluded Item) — AS-IS SmartColMerge(cs:403 InitSpread shtExcluded / cs:799 FindData_Sub,
 * 03 §3-E). bodItem 과 동일 처방: 편집 불가 grouping 컬럼(키/사이트/Incoterms/TransMode)만 세로 병합하고
 * 편집 컬럼(dates·VALID_YN)·기술 컬럼(PRE_KEY_VALUES)은 제외. 병합 플래그 메타 부재는 위와 동일.
 */
export const BOD_EXCLUDED_MERGE_COLUMNS = new Set<string>([
  BOD_EXCLUDED_COLUMN.DIVISION_ID,
  BOD_EXCLUDED_COLUMN.OPMZ_PLAN_GR_NAME,
  BOD_EXCLUDED_COLUMN.ITEM_ID,
  BOD_EXCLUDED_COLUMN.BOD_ID,
  BOD_EXCLUDED_COLUMN.FROM_SITE_NAME,
  BOD_EXCLUDED_COLUMN.TO_SITE_NAME,
  BOD_EXCLUDED_COLUMN.INCOTERMS,
  BOD_EXCLUDED_COLUMN.TRANSPORT_MODE,
]);

/** PRIORITY 0~99 / SAFETY_STOCK 0~100 (03 §3-D, cs:386/387). */
export const RANGE = {
  PRIORITY_MAX: 99,
  SAFETY_STOCK_MAX: 100,
} as const;

/**
 * i18n 코드 — SCM_ADM_MSG_M 실측(02 §4.5 LABEL 9종 + 03 검증 MSG). AS-IS 번호 그대로 쓰지 말 것(#114):
 * 문구 역조회한 TO-BE 코드. 등가 없으면 defaultValue fallback.
 */
export const LBL = {
  DIVISION: 'LBL00641',
  FROM_SITE: 'LBL00022',
  TO_SITE: 'LBL00023',
  TRANS_MODE: 'LBL00025',
  INCOTERMS: 'LBL00024',
  MODEL: 'LBL00669', // Item ID 라벨 = "Model"(AS-IS Designer). 임의 "Item" 변경 금지.
  NICK_NAME: 'LBL00767',
  BOD_ITEM_VALID: 'LBL01054',
  PLAN_GROUP: 'LBL00002',
  SEARCH: 'LBL00112',
  EDIT: 'LBL00108',
} as const;

/**
 * 화면 메시지 코드 — 문구 역조회 TO-BE 코드(#114).
 * 주의: bodItem 날짜 6검증(N1~N8, 03 §3-B: MSG00212/213/216/060/217/219)은 TO-BE 에서 저장 차단으로
 *   재현하지 않는다 — AS-IS SaveData_Main(cs:937-942)에서 checkValidN1~N8 호출이 전건 주석 처리돼 있고
 *   ("BOD LT 2단계 개발 - FROM, TO 저장 BOD UI 에서 관리"), 실제 저장 검증은 checkRequiredOfSpread(cs:929)
 *   뿐이다. 설계 03 §3-B 는 호출부 확인 없이 dead 메소드 본문만 추출한 것이라 런타임 동작과 불일치한다.
 *   상세: design/04_react-gap.md G-VALIDATION-REDERIVED.
 */
export const MSG = {
  // 시트 편집 중 탭 전환 차단(L8, 03 §3-G) — "{0}를 수정 중이어서 시트를 변경할 수 없습니다".
  SHEET_LOCKED: 'MSG00129',
  // Excluded 저장 시 FROM>TO 날짜역전 차단(03 §4-C) — AS-IS SaveData_Sub(cs:1131-1135) 라이브 검증.
  //   TO-BE SCM_ADM_MSG_M 실재(EN "Invalid period (start > end)."). 형식검증 MSG00046 은 FPDate 구조 보장.
  PERIOD_REVERSED: 'MSG00219',
} as const;
