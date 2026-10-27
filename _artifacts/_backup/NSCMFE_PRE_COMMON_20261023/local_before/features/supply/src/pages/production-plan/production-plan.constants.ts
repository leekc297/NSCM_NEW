export const MENU_ID = 'SCP0011' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Analysis.UIL SCP0011_ProductionPlan — master-detail 2 pivot 그리드.
//   spdMain(MODEL 시트, 읽기전용 요약) + spdLine(LINE 시트, PROD_PLAN_AMEND 편집). master 더블클릭 → line drill.
//   설계 근거: .atlas/gscm-design/SCP0011/design/00_checklist.md ~ 03_grid-columns.md (DB 실측).
//   자매화면 SCP0013(production-plan-line) 과 동일 pivot/편집잠금/cascade 패턴 — 유틸을 그대로 이식한다.
//   SP(배포 PASS): PKG_SCP0011.P_SCP0011_GET_PROD_PLAN_MODEL / _GET_PROD_MODEL_TITLE / _GET_PROD_PLAN_LINE /
//     _GET_PLAN_EDIT_INFO / P_SCP_ANL_PROD_PLAN_I_AMEND + PKG_COM0000.P_SCP0011_SAVE_PROD_PLAN_LINE /
//     _GET_LAST_PLAN_VER / P_SCP0009_GET_SHEET_CALENDAR_3SPAN.
//   API_M 7행 + 버튼 8행 등록 확인(ora.py 2026-10-07). 메뉴/버튼/권한 메타는 convert-react 05_register.sql 에서 등록.
//   PROC_M 7 proc 전건 등록(ora.py 실측). GET 3종 OUT 커서 COL_NM='o_rc1'·AMEND 6 IN='JVARCHAR'(convert-sp 재등록
//   완료 — react-gap-audit H1/H3 해소). SAVE(P_SCP0011_SAVE_PROD_PLAN_LINE)의 17 IN 은 DATA_TP_CD='CLOB' 이라
//   BE ^-fold 미발동 → FE 가 변경 D_ 셀을 컬럼별 '^' 로 접어 직접 POST 한다(utils/productionPlanLineSave, H2 해소).
export enum SHEETS {
  MAIN = 'main', // spdMain — MODEL 요약 pivot 그리드(읽기전용). SEARCH = P_SCP0011_MODEL_GET
  LINE = 'line', // spdLine — LINE 상세 pivot 그리드(편집). SEARCH = P_SCP0011_LINE_GET / SAVE = SCP0011_PRODUCTION_PLAN_LINE_SAVE
  MODEL_TITLE = 'modelTitle', // P_SCP0011_MODEL_TITLE_GET (모델 타이틀)
  EDIT_INFO = 'editInfo', // P_SCP0011_GET_PLAN_EDIT_INFO (plan version 단일 편집컨텍스트 — EDIT_START_DATE/IS_EDITABLE, CP_KEY 미반환)
  CALENDAR = 'calendar', // SCP0009_SHEET_CALENDAR_3SPAN_GET (기간열 타이틀 — 공용 PKG_COM0000)
  LAST_VER = 'lastVer', // SCP0011_LAST_PLAN_VERSION_GET (최신 계획 버전)
  AMEND = 'amend', // P_SCP0011_AMEND_SAVE (btnCal Amend 재계산)
}

// NSCM 단일 cursor 표준 — 모델/라인 GET 은 O_RC1(wide pivot 행) + O_RC3/O_RC4(주/월 ratio, LINE_TOTAL/YIELD 보정).
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  LINE: 'o_rc1',
  EDIT_INFO: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — 칼럼메타는 'Model'/'Line'(design 03 §1).
//   실측: PROGRAM_ID='SCP0011' SHEET_NAME='Model' 19행 / 'Line' 19행 등록됨(ora.py 2026-10-07).
export const ADMIN_SHEET_NAME: Record<SHEETS.MAIN | SHEETS.LINE, string> = {
  [SHEETS.MAIN]: 'Model',
  [SHEETS.LINE]: 'Line',
};
// Measure 메타 SHEET_NAME 은 대문자(design 03 §1 주의 — 'MODEL'/'LINE'). 칼럼메타(Model/Line)와 표기 불일치.
export const MEASURE_SHEET_NAME: Record<SHEETS.MAIN | SHEETS.LINE, string> = {
  [SHEETS.MAIN]: 'MODEL',
  [SHEETS.LINE]: 'LINE',
};

// Bucket — cboBucketType. 기본 WEEKLY (design 02 §4.2). AS-IS DM0003_GET_BUCKET_TYPE_CODE 는 고정 3코드라
//   콤보 재조회 없이 상수로 둔다(design 03 §6 L7 — 배포위치 확인필요 회피).
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// 편집 대상 measure — PROD_PLAN_AMEND 행만 (design 03 §1 LINE #17 / §2.5). MODEL 그리드는 전건 읽기전용.
export const EDITABLE_MEASURE = 'PROD_PLAN_AMEND';
// 비율 measure 접두 — W_/M_ SUM 이 합이 아니라 평균(design 03 §2.4). MODEL=FORMATION_YIELD / LINE=LINE_TOTAL_LOAD.
export const RATIO_MEASURES = ['FORMATION_YIELD', 'LINE_TOTAL_LOAD'] as const;
// LINE_TOTAL_LOAD(%) 소수 2자리 표시 + <100 적색 강조 (design 03 §1 LINE #6 / §3 R13/R16).
export const LINE_TOTAL_LOAD_MEASURE = 'LINE_TOTAL_LOAD';
// W_/M_ SUM 이 합이 아니라 구간 마지막 값인 measure — Target-Plan(Amend). AS-IS 화면 확인 2026-10-13.
export const SUM_LAST_VALUE_MEASURES = ['ONHAND_EOH'] as const;
export const RATIO_DECIMALS = 2;
export const LINE_TOTAL_WARN_THRESHOLD = 100;

// division 특수 코드 (design 02 §4.3/§5.2).
export const DIVISION_EE_PREFIX = 'EE'; // div 앞2자 EE → OperationGroup/PlantSite 콤보 EE 전용 + Electrode enable
export const DIVISION_ALL = 'ALL'; // Division=ALL → 하위 plan 콤보 재조회 스킵(design 02 §4.4)
// Plan Type 확정/임시 — 편집 전면 불가 (design 03 §2.5 / 01 R2).
export const PLAN_TYPE_EXCLUDE_EDIT = ['FN', 'TE'] as const;

// 조회조건 콤보 SQL_ID — DB 실측 등록 확인 (SCM_ADM_CMBO_SQL_M, ora.py 2026-10-07, design 02 §2.1).
//   Division/OpGroup/PlantSite 는 서버-파라미터(재조회) 콤보다 — 상위값을 파라미터로 실어 cascade 재조회.
//   단 Plan Date→Type→Seq 는 자매 SCP0013 과 동일하게 _SCP_ALL(전량) 콤보 + 클라 필터로 전환했다(아래 주).
//   EE 분기 콤보는 이름 재사용 금지(별개 코드셋, convert-core §2.6).
export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP', // 권한 division (@mnuId 자동주입). CODE=DIVISION_ID / NAME=ID+NAME
  OP_GROUP: 'OperationGroup_SCP', // 비EE (SEGMENT1 IN ('P','A')), 파라미터 없음
  OP_GROUP_EE: 'OperationGroupEE_SCP', // EE (SEGMENT1 IN ('A','E'))
  PLANT_SITE: 'PlantByDivisionOperation', // 비EE — @divisionId/@operationGroup
  PLANT_SITE_EE: 'PlantSiteProdPlan_SCP', // EE — @segment2/@attribute2 (토큰 바인딩 §2.7 확인필요)
  ELECTRODE: 'LookupCommon', // @lookupType=ELECTRODE_TYPE (ANODE/CATHODE/ONESIDE)
  // Plan Date→Type→Seq — 자매 SCP0013 과 동일 _SCP_ALL(전량 1회 로드) 콤보 + 반환 컬럼 클라 필터로
  //   CascadeDropdown 트리를 구성한다(buildPlanVersionTree). 상위값 파라미터 재조회(구 DATE_WEEKLY/
  //   PlanType/PlanSeq)에서 전환 — DB 실측 등록 확인(SCM_ADM_CMBO_SQL_M USE_YN='Y', ora.py 2026-10-07).
  PLAN_DATE: 'DATE_WEEKLY1_SCP_ALL', // 반환 DIVISION_ID → 클라 필터, CODE=plan_start_yyyymmdd
  PLAN_TYPE: 'PlanType1_SCP_ALL', // 반환 DIVISION_ID/PLANDATE → 클라 필터
  PLAN_SEQ: 'PlanSeq1_SCP_ALL', // 반환 DIVISION_ID/PLANDATE/PLANTYPE → 클라 필터
} as const;
export const ELECTRODE_LOOKUP_TYPE = 'ELECTRODE_TYPE';

// Bucket 콤보 옵션(고정 3코드). AS-IS 라벨(Daily/Weekly/Monthly).
export const BUCKET_OPTIONS: { value: BUCKET_TYPE; label: string }[] = [
  { value: BUCKET_TYPE.DAILY, label: 'Daily' },
  { value: BUCKET_TYPE.WEEKLY, label: 'Weekly' },
  { value: BUCKET_TYPE.MONTHLY, label: 'Monthly' },
];

// Period 프리셋 주차 (design 02 §2.8 GetDayRange — from = planDate, to = from + 52*7-1).
export const PRESET_W26 = 26;
export const PRESET_W52 = 52;
export const QUICK_WEEKS = [26, 52];

// Validation MSG ID — TO-BE SCM_ADM_MSG_M 역매핑(자매 SCP0013 매핑 정합). AS-IS 번호 직용 금지.
//   {0} 자리표시자는 i18next 가 치환하지 않으므로(.NET 형식) 호출부에서 .replace 로 넣는다.
export const MSG = {
  REQUIRED_FIELD: 'MSG00429', // {0} value is required.
  NO_PERMISSION: 'MSG00096', // No permission. (AS-IS MSG00096 — 수정권한, design 01 R1-b)
  QTY_NEGATIVE: 'MSG00225', // Quantity must be 0 or greater. (AS-IS MSG00084, design 03 R15)
  CONFIRM_AMEND: 'MSG01217', // "Do you want to recalculate Target-Plan (Amend)?" — TO-BE 실측(ora.py).
  //   AS-IS MSG00206 은 TO-BE SCM_ADM_MSG_M 미등록(0행)이라 MSG_NM 의미가 일치하는 코드로 remap(L1 해소).
  NO_CHANGES: 'MSG00004', // "No changes to save." (무변경 전용). 성공·무변경에 재사용하지 않는다(M2 해소).
  SAVE_SUCCESS: 'MSG00002', // "Saved successfully." (저장 성공 toast — 직접 POST 경로라 화면이 직접 노출).
  SAVE_FAIL: 'MSG00006', // Failed to save.
  PLAN_PERIOD_RANGE: 'MSG00108', // Invalid period (start > end).
} as const;

// i18n 라벨 코드 — SCM_ADM_MSG_M LBL 실측 역매핑(design 02 §4.5). 값=LBL 코드, 호출부는 t(LBL.KEY, '_Fallback').
export const LBL = {
  SEARCH: 'LBL00112', // Search(F5)
  // 아래 4개는 기존 의미형 LBL_* 가 SCM_ADM_MSG_M 미등록이라 화면에 ID 그대로 노출(다국어 미동작)되던 것을
  //   AS-IS 동일 문구의 등록 LBL 로 교정(ora.py 2026-10-07 KO/EN/CN 실측).
  DIVISION: 'LBL00641', // Division (구 LBL_DIVISION 미등록)
  OPERATION_GROUP: 'LBL00027', // Operation group (구 LBL_OPERATION_GROUP 미등록)
  PLANT_SITE: 'LBL00005', // Plant Site (구 LBL_PLANT_SITE 미등록)
  ELECTRODE: 'LBL00038', // Electrode
  MATERIAL: 'LBL00021', // Material (메1 MaterialByDivisionModal 픽커 → item_id)
  MODEL_NICKNAME: 'LBL00618', // Model/Nickname (메1 MaterialByDivisionModal 픽커 → nick_name)
  PLAN_DATE: 'LBL00039', // Plan Date
  PLAN_TYPE: 'LBL00040', // Plan Type
  SEQ: 'LBL00041', // Seq.
  PERIOD: 'LBL00013', // Period (구 LBL_PERIOD 미등록)
  BUCKET: 'LBL00710', // Bucket
  SUM: 'LBL00687', // Sum
  ALL: 'LBL00632', // All (chkAll 전체보기 — 자매 SCP0013 동일 LBL)
  AMEND: 'LBL01058', // Calculate(Amend) 버튼 라벨 — DB 실측 SCM_ADM_MSG_M LBL01058='Calculate'(KO/EN/CN, USE_YN=Y).
  //   구 'LBL00310' 은 실제 'Measure'(=MEASURE 와 동일코드)로 오매핑이었음(ora.py 2026-10-07 실측 교정).
  MEASURE: 'LBL00310', // Measure
  // 그리드 타이틀(AS-IS FpSpread 시트탭 'Model'/'Line' 캡션) — ora.py 2026-10-07 SCM_ADM_MSG_M 실측(KO/EN/CN, USE_YN=Y).
  MODEL: 'LBL00669', // Model — spdMain(요약) 그리드 타이틀
  LINE: 'LBL00010', // Line — spdLine(상세) 그리드 타이틀
} as const;

// 수량 범위 (design 03 §3 R5 — SetReNumerCellType 0~99999999 / R15 음수 차단).
export const QTY_MIN = 0;
export const QTY_MAX = 99999999;

// pivot 셀 색상 (design 03 §3 R16/R17) — 과거/실적 구간 회색, LINE_TOTAL<100 적색.
export const CELL_COLOR = {
  PAST_GRAY: 'rgb(234,234,234)', // 편집불가(과거/실적) 구간 배경
  EDITABLE_YELLOW: '#fff9c4', // 편집가능 pivot 셀(PROD_PLAN_AMEND · Daily D_ · 편집시작일 이후) 배경 — 식별용
  UNDER_100: '#d32f2f', // LINE_TOTAL_LOAD(%) < 100 강조 텍스트
} as const;

// pivot 컬럼 앵커 — MEASURE_NAME 다음부터 동적 기간열 (design 03 §1 / §1.4).
export const PIVOT_ANCHOR_COLUMN = 'MEASURE_NAME';

// ===== 고정 컬럼 fallback (DB 실측 — design 03 §1.1 MODEL 19 / §1.2 LINE 19, ora.py 2026-10-07) =====
//   admin(SCM_MST_SHEET_COLUMNS) 등록본이 authoritative(Model/Line 각 19행 등록 확인). 없으면 아래 fallback.
//   전건 INPUT_TP_CD='S'(표시전용) — 편집은 동적 D_ pivot 셀(LINE 시트 PROD_PLAN_AMEND 행)만.
export interface FixedColumnMeta {
  key: string;
  header: string;
  sort: number;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  fixed?: boolean; // 좌측 고정(FIXED_FLAG=Y — MEASURE/MEASURE_NAME)
  eeOnly?: boolean; // EE 사업부만 표시 (ORIGIN_DIVISION_ID/ELECTRODE_TYPE — design 03 §3 R2)
}

// MODEL 시트(spdMain) 고정컬럼 — design 03 §1.1.
export const MODEL_FIXED_COLUMNS: FixedColumnMeta[] = [
  { key: 'KEY_IDX', header: 'KEY_IDX', sort: 1, width: 40, align: 'L', visible: false },
  { key: 'FROM_YYYYMMDD', header: 'FROM_YYYYMMDD', sort: 2, width: 40, align: 'L', visible: false },
  { key: 'TO_YYYYMMDD', header: 'TO_YYYYMMDD', sort: 3, width: 40, align: 'L', visible: false },
  { key: 'PLAN_START_YYYYMMDD', header: 'PLAN_START_YYYYMMDD', sort: 4, width: 40, align: 'L', visible: false },
  { key: 'PLAN_TYPE', header: 'PLAN_TYPE', sort: 5, width: 40, align: 'L', visible: false },
  { key: 'PLAN_SEQ', header: 'PLAN_SEQ', sort: 6, width: 40, align: 'L', visible: false },
  { key: 'OPERATION_ID', header: 'OPERATION_ID', sort: 7, width: 40, align: 'L', visible: false },
  { key: 'DIVISION_ID', header: 'Div', sort: 8, width: 60, align: 'C', visible: true },
  { key: 'DIVISION_NAME', header: 'Div', sort: 9, width: 60, align: 'L', visible: false },
  { key: 'ORIGIN_DIVISION_ID', header: 'Origin Div', sort: 11, width: 60, align: 'C', visible: true, eeOnly: true },
  { key: 'OPERATION_GROUP', header: 'Operation Group', sort: 12, width: 60, align: 'L', visible: false },
  { key: 'OPERATION_GROUP_NAME', header: 'Operation Group', sort: 13, width: 90, align: 'L', visible: true },
  { key: 'SCM_SITE_ID', header: 'Plant Site Id', sort: 14, width: 90, align: 'L', visible: false },
  { key: 'SCM_SITE_DESCRIPTION', header: 'Plant Site', sort: 15, width: 100, align: 'L', visible: true },
  { key: 'MODEL_ID', header: 'Model', sort: 16, width: 130, align: 'L', visible: true },
  { key: 'ITEM_ID', header: 'Material', sort: 16.5, width: 130, align: 'L', visible: true },
  { key: 'NICK_NAME', header: 'Nick Name', sort: 17, width: 100, align: 'L', visible: true },
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', sort: 18, width: 60, align: 'C', visible: true, eeOnly: true },
  { key: 'MEASURE_NAME', header: 'Measure', sort: 19, width: 150, align: 'L', visible: true, fixed: true },
];

// LINE 시트(spdLine) 고정컬럼 — design 03 §1.2 (편집 대상 그리드).
export const LINE_FIXED_COLUMNS: FixedColumnMeta[] = [
  { key: 'PLAN_START_YYYYMMDD', header: 'PLAN_START_YYYYMMDD', sort: 1, width: 40, align: 'L', visible: false },
  { key: 'PLAN_TYPE', header: 'PLAN_TYPE', sort: 2, width: 40, align: 'L', visible: false },
  { key: 'PLAN_SEQ', header: 'PLAN_SEQ', sort: 3, width: 40, align: 'L', visible: false },
  { key: 'LINE_NAME', header: 'Line', sort: 4, width: 40, align: 'L', visible: false },
  { key: 'DIVISION_ID', header: 'Div', sort: 5, width: 60, align: 'C', visible: true },
  { key: 'DIVISION_NAME', header: 'Div', sort: 6, width: 60, align: 'L', visible: false },
  { key: 'ORIGIN_DIVISION_ID', header: 'Origin Div', sort: 7, width: 60, align: 'C', visible: true, eeOnly: true },
  { key: 'OPERATION_GROUP', header: 'Operation Group', sort: 8, width: 60, align: 'L', visible: false },
  { key: 'OPERATION_GROUP_NAME', header: 'Operation Group', sort: 9, width: 90, align: 'L', visible: true },
  { key: 'SCM_SITE_ID', header: 'Plant Site Id', sort: 10, width: 90, align: 'L', visible: false },
  { key: 'SCM_SITE_DESCRIPTION', header: 'Plant Site', sort: 11, width: 100, align: 'L', visible: true },
  { key: 'LINE_ID', header: 'Line', sort: 12, width: 85, align: 'L', visible: true },
  { key: 'MODEL_ID', header: 'Model', sort: 13, width: 130, align: 'L', visible: true },
  { key: 'ITEM_ID', header: 'Material', sort: 13.5, width: 130, align: 'L', visible: true },
  { key: 'NICK_NAME', header: 'Nick Name', sort: 14, width: 100, align: 'L', visible: true },
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', sort: 15, width: 60, align: 'C', visible: true, eeOnly: true },
  { key: 'OPERATION_ID', header: 'Operation', sort: 16, width: 100, align: 'L', visible: true },
  { key: 'MEASURE', header: 'Measure', sort: 17, width: 40, align: 'L', visible: false, fixed: true },
  { key: 'MEASURE_NAME', header: 'Measure', sort: 18, width: 150, align: 'L', visible: true, fixed: true },
];
