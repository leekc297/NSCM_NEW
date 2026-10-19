export const MENU_ID = 'DMF0045' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0045_ShipmentRequest.cs (Demand > Demand Plan > Shipment Request / 출하요청 —
//   GSCM.DM.Plan.UIL 2,305줄 정본):
//   - 메인 그리드 : PIVOT wide format (정적 16컬럼 admin 메타 + 기간 동적 M_/W_/D_ + DB_ 플래그)
//   - 설계        : .atlas/gscm-design/DMF0045/design/00~03 (layout/search-combo/grid-columns)
//   - Division 다종(40 Mobility / 81 계열 Automotive / 82 ESS) — 81 조건부 TO_SITE 필수 판정.
//   - 시트 2개(Pack Biz / Cell Biz) — SCM_MST_SHEET_COLUMNS 는 PROGRAM_ID+SHEET_NAME 단위.
export enum SHEETS {
  // 메인 그리드 — 배포 DB SHEET_NAME 케이싱 그대로(ora.py 실측 'Pack Biz'/'Cell Biz', 공백 title case).
  //   BE 버튼권한/시트검증은 대소문자 구분이므로 배포값과 1:1 일치해야 한다(memory sht-nm-case-sensitive).
  PACK = 'Pack Biz', // Pack Biz 시트 (P) — btnItemId sBizType='P'
  CELL = 'Cell Biz', // Cell Biz 시트 (A) — btnItemId sBizType='A'
  SPREAD_TITLE = 'spreadTitle', // 동적 기간 헤더 메타 (P_DMF0045_GET_SPREAD_TITLE)
  // TR_MODE 셀 BOD 팝업(DMF0046 GetBODItemPrjRoutePopup) 컬럼 메타 + 조회 시트.
  //   SCM_MST_SHEET_COLUMNS PROGRAM_ID='DMF0045' SHEET_NAME='bodPopup' (register.sql — 팝업 컬럼 admin 메타).
  //   DMF0045 는 procedures.d.ts 미등재(Base index-fallback) — 이 시트도 느슨 타입으로 통과한다.
  BOD_POPUP = 'bodPopup',
}

// Bucket Type — AS-IS cboBucketType (DM0003_GET_BUCKET_TYPE_CODE / LOOKUP BUCKET_TYPE_CODE).
//   기본값 = Daily (OnShown cs:179 에서 Daily 강제 — design 02 §4).
export enum BUCKET_TYPE {
  DAILY = 'D',
  WEEKLY = 'W',
  MONTHLY = 'M',
}

// SP 전송/재조회용 full-word 변환 — LOOKUP SEGMENT1 이 full-word(DAILY/WEEKLY/MONTHLY)라
//   콤보 CODE 첫 글자를 enum 으로 접고, SP 로는 다시 full-word 로 편다(design 02 §2-6 실측).
export const BUCKET_WORD: Record<BUCKET_TYPE, string> = {
  [BUCKET_TYPE.DAILY]: 'DAILY',
  [BUCKET_TYPE.WEEKLY]: 'WEEKLY',
  [BUCKET_TYPE.MONTHLY]: 'MONTHLY',
};

// Division 분기 (design 03 §4.3 저장검증 실측): 40=Mobility / 81 계열=Automotive / 82=ESS.
//   81 조건부 TO_SITE(Plant) 필수 판정은 startsWith('81') — '===' 비교 금지(sales-plan.division 선례).
export const DIVISION = {
  MOBILITY: '40',
  AUTOMOTIVE: '81',
  ESS: '82',
} as const;

// 조회 기간 기본값 — 오늘 ~ 오늘+55일(8주). drpPeriod readOnly (design 02 §4, cs:229).
export const PERIOD_DEFAULT_DAYS = 55;

// 편집 가능(음영 아님) Measure 화이트리스트 (design 03 §3 — cs 하드코딩).
//   이 6종만 입력 가능, 그 외 measure 행은 배경 음영 + 잠금.
export const EDIT_MEASURE_WHITELIST = [
  'SHIP_REQ',
  'SHIP_PLAN',
  'RTF',
  'RTF_SCP',
  'SCP_PLAN',
  'SCP_SHIP_PLAN',
] as const;

// BOH 앞채움 대상 measure (design 03 §3 — 첫 D_ 값을 선행 M_/W_ 에 복사 표기).
export const BOH_MEASURES = ['WH_BOH_PLAN', 'WH_BOH_REQ'] as const;

// 신규 행 기본값 (design 03 §3 white-list #10/#11 — DIVISION_ID=선택 division, MEASURE='SHIP_REQ').
export const INSERT_DEFAULT_MEASURE = 'SHIP_REQ' as const;

// handleInsert 신규행 기본 컬럼값 — DIVISION_ID/INSERT_GROUP_ID 는 삽입 시점 값이라 여기 두지 않고
//   화면에서 채운다. MEASURE 만 고정 기본값(#11). sales-plan INSERT_ROW_DEFAULTS 동형(화면 상수 단일 출처).
export const INSERT_ROW_DEFAULTS = {
  MEASURE: INSERT_DEFAULT_MEASURE,
} as const;

// ColumnLayoutModal / MeasureSelectModal titleSet 저장 타입 — 조회·저장·복원이 반드시 같은 값
//   (sales-plan 선례. 조회는 시트명, 저장은 'C'/'M' 로 갈리면 개인화가 재진입 시 영구 미조회).
export const TITLESET_COLUMN_TYPE = 'C';
export const TITLESET_MEASURE_TYPE = 'M';

// btnItemId 팝업 sBizType — 시트 기준 상수(SP 산출 아님, design 02 §4.6 / §2-7).
export const SHEET_BIZ_TYPE: Record<SHEETS.PACK | SHEETS.CELL, string> = {
  [SHEETS.PACK]: 'P',
  [SHEETS.CELL]: 'A',
};

// AS-IS Validation MSG ID 매핑 — 사내 SCM_ADM_MSG_M 실측 대사(ora.py, 2026-09-26).
//   룰: MSG ID 는 실존 대사 후 지정(추측/생성 금지). AS-IS 미배포 코드는 배포 코드로 재매핑하고
//   근거를 __asis-mapping__ 에 남긴다(sales-plan 선례).
export const MSG = {
  // Division 미선택 — 조회 가드 (AS-IS FindData cs:609 MSG00097). 실측 존재.
  REQUIRE_DIVISION: 'MSG00097',
  // 필수값 — "{0} 필수" (design 03 §4.3 필수 7종). 실측 존재.
  REQUIRED_FIELD: 'MSG00002',
  // 필수 컬럼 없음 — (EditButton/SaveData). 실측 존재.
  REQUIRED_COLUMN: 'MSG00113',
  // 음수 qty 차단 — AS-IS MSG00084(미배포) → 사내 MSG00085("{0} 이상 값만") 재매핑.
  //   design 03 §4.3 은 MSG00084 를 인용하나 SCM_ADM_MSG_M 미존재(실측 0행). SalesPlan Catch_Up
  //   음수도 MSG00085 를 쓴다 — 동일 재매핑. 근거는 __asis-mapping__ 기록.
  NEGATIVE_QTY: 'MSG00085',
  // Bucket 변경 차단 — Insert 행/변경분 존재 시 (AS-IS cboBucketType_Click MSG00227). 실측 존재.
  BUCKET_CHANGE_BLOCK: 'MSG00227',
  // 저장 성공 — 실측 존재.
  SAVED: 'MSG00002',
  // 변경 0건 — 저장 대상 없음. 실측 존재.
  NO_CHANGES: 'MSG00004',
  // 재진입 가드 — 이전 작업 실행 중. 실측 존재.
  WORK_IN_PROGRESS: 'MSG00137',
  // 미저장 변경 존재 시 재조회 확인 (UI 공통 UC-02). 실측 존재(EN/CN = 재조회 문구, KO 번역만 "닫기"로 상이).
  //   전 화면 공통 요구(2026-08-12) — AS-IS DMF0045 FindData 에는 confirm 없으나 TO-BE 표준 신설 항목.
  CONFIRM_RESEARCH_UNSAVED: 'MSG00703',
  // 저장 오류 공통 fallback — SP 원문 메시지 부재 시. 실측 존재.
  SAVE_ERROR: 'MSG00618',
  // 확인필요: TR_MODE(BOD) 팝업 전제 ITEM_ID 미입력 경고 — AS-IS MSG00098 은 SCM_ADM_MSG_M 미존재
  //   (실측 0행). 실배포 대체 코드 미확정이라 register.sql 확인필요 항목으로 남기고,
  //   화면은 REQUIRED_FIELD(MSG00002, {0}=Model) 로 임시 대체(추측 코드 하드코딩 금지).
  ITEM_REQUIRED_FOR_BOD: 'MSG00002',
} as const;

// i18n 라벨 코드 — BOD 팝업 표시용(실측 코드, shipping SSP0045 와 동일 대사).
//   자유 형식 키 금지(convert-core §2.4) — SCM_ADM_MSG_M/LABEL 실존 코드만.
export const LBL = {
  DIVISION: 'LBL00641',
  OPERATION_GROUP: 'LBL00027',
  MODEL: 'LBL00669',
  SEARCH: 'LBL00664',
  NO: 'LBL00674',
  OK: 'LBL00716',
  CLOSE: 'LBL00627',
} as const;

// BOD 팝업 시트명 i18n — AS-IS 팝업 시트명 'BOD Item Master' 역조회 코드(hook #114, shipping 선례).
export const BOD_POPUP_TITLE_KEY = 'MNU00158';

// 선택 0건 안내 — 실측 존재(shipping SSP0045 동일).
export const MSG_NO_ROWS_SELECTED = 'MSG00071';

// TR_MODE(BOD) 팝업이 채우는 컬럼 묶음 (design 03 §3 셀 더블클릭 팝업 — DMF0046 반환).
export const BOD_FILL_FIELDS = [
  'FROM_SITE',
  'TO_SITE',
  'INCOTERMS',
  'TR_MODE',
  'BOD_ID',
  'END_CUSTOMER',
  'TEAM_NAME_KO',
] as const;

// PROJECT_CODE 셀 팝업이 채우는 컬럼 묶음 (design 03 §3 — SCM0002 반환).
export const PROJECT_FILL_FIELDS = [
  'PROJECT_CODE',
  'END_CUSTOMER',
] as const;

// ITEM_ID 셀 팝업이 채우는 컬럼 묶음 (design 03 §3 — DMF0047 반환).
export const ITEM_FILL_FIELDS = ['ITEM_ID', 'NICK_NAME'] as const;
