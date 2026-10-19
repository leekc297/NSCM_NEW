export const MENU_ID = 'SCP0049' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * SHEETS — BE 프로시저 라우팅 키(BTN_MPG.SHT_NM 실측 2026-09-26). procedures.d.ts SCP0049 유니온과 정합.
 *   capa      = 메인 조회/저장(P_GET_CAPA / P_SAVE_CAPA)
 *   userTitle = 개인화 컬럼 메타(P_GET_SHEET_USER_TITLE) — staticColumns 원천
 *   calendar  = 동적 기간칼럼(P_GET_SHEET_CALENDAR) — D_/M_/Y_
 *   dayRange  = Period 피커 min/max(P_GET_DAY_RANGE)
 *   newVersion= Version Info 조회(P_GET_NEW_VERSION_INFO) / New Version 저장(P_SAVE_NEW_VERSION)
 * mailSend / newModel 은 apiClient.post 로 직접 소비(공용 팝업) — SHEETS 미등재.
 */
export enum SHEETS {
  CAPA = 'capa',
  USER_TITLE = 'userTitle',
  CALENDAR = 'calendar',
  DAY_RANGE = 'dayRange',
  NEW_VERSION = 'newVersion',
}

/** admin UI Category Setup 의 SHEET_NAME(AS-IS 원본명 실측). SHEETS value 와 별개. */
export const ADMIN_SHEET_NAME = 'CAPA' as const;
export const ADMIN_SHEET_NAME_EXCEL = 'CAPA EXCEL' as const;

/** FE 커서 읽기키 — PROC_M OUT COL_NM 소문자(o_rc/o_rc2/o_rc3, 메모리 proc-cursor-key-colnm-vs-fe-read). */
export const RESPONSE_SET = { MAIN: 'o_rc', SUMMARY: 'o_rc2', PIC: 'o_rc3' } as const;

/**
 * 조회조건/셀 콤보 SQL_ID (02 §2·§5 실측 — 접미 규칙 준수. USE_YN='Y' 전건 확인 ora.py 2026-09-26).
 * 주의(convert-core §2.6): MyDivision·OperationByLine 은 접미 없음이 정본 — `_SCP` 오접미/재사용 금지.
 */
export const COMBO = {
  DIVISION: 'MyDivision',
  GROUP: 'ShopGroupId_SCP',
  PLANT: 'PlantByGroup_SCP',
  BUILDING: 'BuildingByShopGroupId_SCP',
  LINE: 'LineByOperationPlantId_SCP',
  OPERATION: 'OperationByLine',
  VERSION: 'MDMVersionId_SCP',
  LANE_QTY: 'LaneQtyOfLineAssign_SCP',
} as const;

/** Version 콤보 초기 정적 옵션 — 'Current' 단일(02 §4). 클릭 시 lazy fetch 로 대체. */
export const VERSION_CURRENT = 'Current' as const;

/** Bucket 정적 옵션 — Month 고정 + Day 토글(W 없음, 02 §5 소스 확정 cs:336-352). */
export const BUCKET_OPTIONS = [
  { label: 'Month', value: 'M' },
  { label: 'Day', value: 'D' },
] as const;

/**
 * 체크박스 5종 기본값(02 §4 실측): Loss=N / Line=Y / Tact=Y / Yield=Y / Empty=N.
 * GET_CAPA IN 파라미터 전용('Y'/'N') — 클라 행 토글 없음(03 Vis1~4 dead code 확정).
 */
export const CHECK_DEFAULTS = {
  checkLoss: false,
  checkLine: true,
  checkTact: true,
  checkYield: true,
  checkEmpty: false,
} as const;

/** Period 상한 = 당월 + 3년 5개월(cs:327-333). GET_DAY_RANGE p_month=13. */
export const DAY_RANGE_MONTH_PARAM = 13 as const;

/**
 * AS-IS 편집 권한 그룹(cs:568) — 행 CONFIRM_FLAG/LANE_QTY/기간 편집 개방 권한자.
 * NowGroupID 가 이 그룹이거나, 사용자 ID 가 행 USER_ID_1~10 에 포함되면 권한자.
 */
export const EDIT_AUTH_GROUP = 'SCM PI Admin' as const;

/** 계산행(파생 산식 대상, 03 §3 V — arrayCalLoss). */
export const CAL_LOSS_CODES = ['XB020', 'XB021', 'XC041', 'XC042', 'XE500', 'M08', 'XD101'] as const;

/** 저장 dataTable 축약(03 §4.3 cs:1152-1160). */
export const DATA_TABLE_ABBR: Readonly<Record<string, string>> = {
  SCM_WORK_CALENDAR_M: 'C',
  SCM_LOSS_M: 'L',
  SCM_ITEM_LINE_ASSIGN_M: 'LA',
  SCM_TACT_TIME_M: 'T',
  SCM_YIELD_M: 'Y',
};

/** REQUEST_CHK 편집 허용 행(03 §3 L4 cs:563-566). */
export const REQUEST_CHK_LOSS_CODES = ['LA001', 'LA002', 'LA003'] as const;

/**
 * AS-IS MSG ↔ TO-BE i18n 코드 (01 §2.6 실측, hook #114 — AS-IS 번호 복사 금지).
 * 확정: 동번호 등가 = MSG00096/00265/00133/00108. 이관대역 = MSG01314/01335/01327/01326/01348/01323.
 * 후보 병존(convert 단계 KO 대조 필요): SAVE_COUNT(MSG00672)·REQUEST_ERR(MSG01288)·NO_ROW_CHECKED(MSG01054).
 */
export const MSG = {
  NO_PERMISSION: 'MSG00096', // No permission. (AS-IS MSG00096 동번호 등가)
  NOT_REAL_TIME: 'MSG01314', // It is not real time data. (AS-IS MSG00312)
  SAVE_COUNT: 'MSG00672', // {0} data saved. (AS-IS MSG00004 — 후보 병존)
  SAVE_FAIL: 'MSG00003', // Failed to save. (AS-IS MSG00003 동번호)
  NO_CHANGES: 'MSG00133', // No modifications have been made. (AS-IS MSG00133 동번호 등가)
  MAIL_SUCCESS: 'MSG01335', // Success to send requestion e-mail. (AS-IS MSG00339)
  MAIL_ERROR: 'MSG01288', // Error occurred during execution. (AS-IS MSG00284 — 후보 병존)
  NO_ROW_CHECKED: 'MSG01054', // No rows are checked. (AS-IS MSG00021 — 후보 병존)
  SAVE_SUCCESS: 'MSG00002', // Saved successfully. (TO-BE MSG00002 EN 실측 — New Version 저장 성공)
  EXCEL_RELOAD_CONFIRM: 'MSG00265', // Excel upload completed. Reloading data. (AS-IS MSG00265 동번호)
  PERIOD_ORDER: 'MSG00108', // Invalid period (start > end). (AS-IS MSG00108 동번호)
  PERIOD_DAY_1Y: 'MSG01348', // {0} check Only year {1} can be viewed. (AS-IS MSG00354)
  PERIOD_6Y: 'MSG01323', // Capa Search : in {0} Year Possible. (AS-IS MSG00326)
  EXCEL_PERIOD_3Y: 'MSG01327', // Excel Download : in {0} Year Possible. (AS-IS MSG00331)
  EXCEL_UNCHECK_DAY: 'MSG01326', // Please uncheck {0}. (AS-IS MSG00329)
  DIVISION_NO_AUTH: 'MSG00097', // No division with permission.
  UPLOAD_NO_FILE: 'MSG01385', // There is no selected file information. (업로드 팝업 — DB 실측)
  UPLOAD_ERROR: 'MSG01288', // Error occurred during execution. (MAIL_ERROR 동일 코드 재사용 — 범용 오류)
  EXCEL_FORM_EMPTY: 'MSG01023', // No data found for the search conditions. (양식 다운로드 — 조회결과 없음, DB 실측)
  // 저장 셀 값검증(03 §3.1·§5-5). MSG00107 만 TO-BE 실재(재사용) — 나머지는 미등록이라
  //   t() fallback(AS-IS 소스 문구)로 배선하고 신규 등록은 admin 요청 항목(convert-core §2.3 — 임의 INSERT 금지).
  LANE_QTY_REQUIRED: 'MSG00337', // Lane QTY value required (E2000 공정). (AS-IS MSG00337 — TO-BE 미등록)
  PRIORITY_RANGE: 'MSG00203', // Enter a number between {0} and {1}. (AS-IS MSG00203 — TO-BE 미등록)
  PRIORITY_INTEGER: 'MSG00107', // Priority is a positive integer. (AS-IS MSG00107 동번호 실재 — 재사용)
  YIELD_MIN: 'MSG00193', // Only values greater than {1} can be entered. (AS-IS MSG00193 — TO-BE 미등록)
  YIELD_MAX: 'MSG00072', // Only values less than or equal to {0}. (AS-IS MSG00072 — TO-BE 미등록)
} as const;

/**
 * 다국어 LABEL (02 §4.5 실측 — 생성 금지). 'Ver.' 는 정확 문구 미등록 → LBL00606(Version) 사용.
 */
export const LBL = {
  DIVISION: 'LBL00001', // Div.
  GROUP: 'LBL00027', // Operation group
  PLANT: 'LBL00030', // Plant
  BUILDING: 'LBL00008', // Building
  LINE: 'LBL00010', // Line
  OPERATION: 'LBL00009', // Operation
  VERSION: 'LBL00606', // Version (Ver. 미등록)
  PERIOD: 'LBL00013', // Period
  MODEL: 'LBL00618', // Model/Nickname
  MATERIAL: 'LBL00021', // Material
  BUCKET: 'LBL00710', // Bucket
  DAY: 'LBL00852', // Day (Bucket 토글 체크박스)
  LOSS: 'LBL01089', // Loss
  LINE_ASSIGN: 'LBL00769', // Line Assign
  TACT_TIME: 'LBL01123', // Tact Time
  YIELD: 'LBL01133', // Yield
  RESULT: 'LBL00645', // Result (checkRESULT — Best/Worst↔Result 토글). LBL00688='Color' 오사용 정정(DB 실측)
  EMPTY_VALUE: 'LBL01076', // Empty Value
  SEARCH: 'LBL00112', // Search
  TOTAL: 'LBL00757', // Total (헤더 요약 라벨). LBL01586 미등록 → 실측 LBL00757='Total' 로 정정(DB)
  // 헤더 요약 라벨(GAP-16 해소 — SCM_ADM_MSG_M LBL 실측 2026-09-26).
  AUTO: 'LBL01053', // Auto
  SMALL: 'LBL01121', // Small
  ELEC: 'LBL01074', // Elec
  PIC: 'LBL01098', // PIC
  // 화면버튼 라벨(GAP-10 해소 — MNU00179 재사용 제거, 고유 LBL 실측).
  NEW_VERSION: 'LBL01096', // New Version
  NEW_MODEL: 'LBL01095', // New Model
  VERSION_INFO: 'LBL01132', // Version Info
  MAIL_REQUEST: 'LBL01091', // Mail Request
  // 팝업/컬럼설정 UI 라벨(SCM_ADM_MSG_M LBL 실측 2026-09-26).
  COLUMN_SETTING: 'LBL00605', // Column Setting (R6 컬럼설정 팝업 버튼)
  CONFIRM: 'LBL01034', // Confirm (New Version 저장 버튼)
  NAME: 'LBL01094', // Name (Version Name 입력 라벨 — 'Version Name' 정확 미등록 → Name 사용)
  // 엑셀 업로드/양식 다운로드(GAP-04/05 해소 — DB 실측 LBL, stock-osp 동일 코드 재사용).
  EXCEL_UPLOAD: 'LBL00346', // Excel Upload
  EXCEL_FORM: 'LBL00762', // Excel Form (양식 다운로드 버튼)
  EXCEL_FILE: 'LBL00759', // Excel File (업로드 팝업)
  OK: 'LBL00716', // OK
  CANCEL: 'LBL00107', // Cancel
  UPLOAD_RESULT: 'LBL00754', // Upload Result
  SUCCESS: 'LBL00755', // Success
  ERROR: 'LBL00756', // Error
} as const;

/** titleSet 저장 컬럼 타입(SCM0002 규약 — 'C'=Column / 'M'=Measure). 이 화면은 Column 개인화만. */
export const TITLESET_COLUMN_TYPE = 'C' as const;

/** New Version 팝업 버전유형 체크박스 3종(BP/RP/SCP) — Roslyn chkBP/chkRP/chkSCP 실측. 코드는 P_*_NEW_VERSION IN. */
export const VERSION_TYPE_LABELS = { bp: 'BP', rp: 'RP', scp: 'SCP' } as const;

/** Version Info 조회조건 라벨. 'Version Name' 라벨 ID 가 DB(SCM_ADM_MSG_M)에 없어 AS-IS 문구(Designer.cs layoutVersionName.Text)를 직접 쓴다. */
export const VERSION_NAME_LABEL = 'Version Name';

/** REQUEST_CHK 코드 칼럼 binding(DB 메타에 없음, 03 §1.1-D — staticColumns 뒤 append). */
export const REQUEST_CHK_BINDING = 'REQUEST_CHK' as const;
