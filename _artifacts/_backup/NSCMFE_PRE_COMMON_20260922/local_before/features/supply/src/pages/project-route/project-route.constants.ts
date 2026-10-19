// SCP0006 Project Route — 상수/메타 매핑.
//   AS-IS: GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0006_ProjectRoute/SCP0006_ProjectRoute.cs (2142 lines)
//   설계: .atlas/gscm-design/SCP0006/design/00~03. RESPONSE_SET/SHEETS 는 procedures.d.ts SCP0006 정합.

export const MENU_ID = 'SCP0006' as const;
export type MENU_ID = typeof MENU_ID;

// BE 프로시저 라우팅 키(SCM_ADM_MNU_BTN_MPG_M.SHT_NM) + procedures.d.ts sheetName.
export enum SHEETS {
  SITE = 'site',
  BOM = 'bom',
  PLANT = 'plant',
}

// 각 시트 커서 결과 key(procedures.d.ts response key). 단일 커서 화면은 '_rc1' 대신 시트명과 동일.
export enum RESPONSE_SET {
  SITE = 'site',
  BOM = 'bom',
  PLANT = 'plant',
}

export enum SHEET_INDEX {
  SITE,
  BOM,
  PLANT,
}

/**
 * 컬럼 메타 fetch(/admin/menu/SCP0006/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과
 * 정확히 일치해야 한다(BE 문자열 매칭). AS-IS SpreadInfo 시트명(Main/BOM Explosion/Plant Assign)이
 * DB SHEET_NAME 으로 배포된 것으로 본다(design/03 §0). 라이브 확인필요(design/03 §6-2).
 */
export const COLUMN_SHEET_NAME: Record<RESPONSE_SET, string> = {
  [RESPONSE_SET.SITE]: 'Main',
  [RESPONSE_SET.BOM]: 'BOM Explosion',
  [RESPONSE_SET.PLANT]: 'Plant Assign',
};

// 사업부 분기 — 40/82 는 Main 에서 SCM_SITE_NAME/PROJECT_CODE/SALES_MODEL 숨김(design/03 R-DYN),
//   조회조건에서 Sales Site ALL 고정 + Project 입력/픽커 비활성(design/01 R2).
export const DIVISION_82 = '82';
export const DIVISION_40 = '40';
export const isProjectHiddenDivision = (divisionId: string): boolean =>
  divisionId === DIVISION_82 || divisionId === DIVISION_40;

// Main 시트 division 82/40 시 숨기는 컬럼(design/03 R-DYN).
export const SITE_HIDE_ON_82_40 = ['SCM_SITE_NAME', 'PROJECT_CODE', 'SALES_MODEL'] as const;

// Plant 편집가능 컬럼(design/03 §1.3) — 나머지 키·감사·파생·플래그 열은 잠금.
export const PLANT_EDITABLE_COLUMNS = [
  'PLANT_SITE_ID',
  'VALID_YN',
  'PRIORITY',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
] as const;

// Period 기본 구간 = PERIOD_DEFAULT From ~ +11M(design/02 §4). 기본 12개월.
export const PERIOD_MONTHS_SPAN = 11;

// 동적 월 컬럼 prefix — AS-IS 는 raw YYYYMM 을 컬럼ID 로 쓰나(design/02 SetCalendar), TO-BE 는
//   고정 컬럼과의 충돌을 피하려 M_ 접두를 붙인다(sales-future-price 동일 관례). SITE GET 응답도
//   동일 key(M_YYYYMM)로 내려주는 계약(design/03 §2 TO-BE 재현계약). 확인필요(SP 미배포, design/03 §6-5).
export const DYN_MONTH_PREFIX = 'M_';

// 셀 콤보 SQL_ID(design/03 §4.5). PLANT_SITE_ID 는 라이브 미등재 → admin 메타 cellCboDataTp 우선.
// PLANT_SITE 는 AS-IS _SCP proc(UP_FX_GetCommonDataList_SCP) 출처라 도메인 suffix '_SCP' 부여
//   (cascade-combo-filter §0-N — 공통+_SCP 양쪽 존재 실측 2026-09-10). DIVISION/STATUS/VALID_YN 은
//   공통 proc 출처라 무접미 유지. 등록 SQL_ID 도 동일 이름이어야 함(§0-N 2 — 한쪽만 붙이면 빈 콤보).
export const COMBO = {
  DIVISION: 'MyDivision',
  STATUS: 'YesOrNo',
  VALID_YN: 'YesOrNo',
  PLANT_SITE: 'PlantByDivisionOperationItem_SCP',
} as const;

// AS-IS MSG ID 매핑(design/00 §5.1 validations 18 + design/03 §3.4 N0~N9). i18n key 유지.
export const MSG = {
  REQUIRE_DIVISION: 'MSG00097', // 권한 division 없음(design/01 R1)
  READONLY_EDIT_BLOCK: 'MSG00109', // Main/BOM 읽기전용 편집 차단(design/03 R-EDIT)
  SAVE_RESULT: 'MSG00004', // 저장 결과 건수
  SAVE_ERROR: 'MSG00006', // 저장 에러
  NO_CHANGE: 'MSG00133', // 수정 내용 없음
  INSERT_NEED_BOM: 'MSG00116', // Insert 전 BOM Item 더블클릭 선행 필요
  OS_PACKER_MISSING: 'MSG00226', // 외주 PACKER ITEM 미등록
  N1_END_OVERLAP: 'MSG00101', // 종료일자 중첩
  N2_START_OVERLAP: 'MSG00102', // 시작일자 중첩
  N3_PLANT_DUP: 'MSG00103', // Plant Site 중복
  N4_PRIORITY_DUP: 'MSG00104', // Priority 중복
  N5_PERIOD_OVERLAP: 'MSG00105', // 중첩 기간
  N6_PERIOD_CONTINUITY: 'MSG00106', // 기간 연속성
  N7_PRIORITY_POSITIVE: 'MSG00107', // Priority 양수
  N8_DATE_ORDER: 'MSG00108', // 시작<=종료 순서
  N8_DATE_RANGE: 'MSG00048', // 처리가능 날짜범위
  N9_PRIORITY_ONE: 'MSG00110', // Priority=1 존재
} as const;

// design/02 §5 btnAllFind — Input All. SYS0004 미등록(정직 고지, design/02 §7).
//   등록 전까지는 로케일 전환이 반영되지 않는 임시 fallback.
export const LBL = {
  INPUT_ALL: 'LBL_INPUT_ALL', // 미등록 — 확인 필요(SYS0004 등록 대상)
} as const;
