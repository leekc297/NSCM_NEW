// SCP0098 Production Plan Line (CAPA Mobility IT / CAPA Report Small)
//   AS-IS: GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0098_CAPAReprotSmall/SCP0098_CAPAReprotSmall.cs
//   TO-BE 전환 상수 SSOT. MENU_ID / SHEETS(BE 라우팅 키) / RESPONSE_SET / measure·bucket·category 정적값.

export const MENU_ID = 'SCP0098' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * SHEETS — value = BE 프로시저 라우팅 키(SCM_ADM_MNU_BTN_MPG_M.SHT_NM). procedures.d.ts 유니온과 정합.
 * - `MAIN`             = 메인 조회 (PKG_SCP0098.P_GET_CAPA_MOBILITYIT)
 * - `CAPA_PRODUCT_RATE`= 생산준비율 저장 (P_SAVE_SCP_CAPA_PRODUCT_RATE)
 * - `CAPA_MONTH`       = Capa(월) 저장 (P_SAVE_SCP_CAPA)
 * - `CAPA_WORK`        = Capa Work(일) 저장 (P_SAVE_SCP_CAPA_WORK)
 * - `COPY`             = Week/Month 복사 (P_COPY_MONTH_WEEK)
 * - `TITLE_SET`        = 공용 Column/Measure 설정 모달이 리터럴 'titleSet' 으로 호출 — BTN_MPG 소유 시트.
 */
export enum SHEETS {
  MAIN = 'main',
  CAPA_PRODUCT_RATE = 'capaProductRate',
  CAPA_MONTH = 'capaMonth',
  CAPA_WORK = 'capaWork',
  COPY = 'copy',
  TITLE_SET = 'titleSet',
}

/**
 * RESPONSE_SET — OUT ref cursor 이름(lowercase) 기준 (hook #80 sp-cursor-name-response-key).
 *   GET/SAVE/COPY 모두 O_RC(데이터) + O_RESULT_CURSOR(결과상태). 데이터 접근은 리터럴 'o_rc'.
 */
export const RESPONSE_SET = { MAIN: 'o_rc' } as const;

/**
 * admin UI Category Setup 의 SHEET_NAME — AS-IS 원본명 그대로(룰 #91). SCM_MST_SHEET_COLUMNS/
 *   SCM_MST_SHEET_MEASURE 의 PROGRAM_ID='SCP0098' AND SHEET_NAME='CAPA_SMALL' (DB 실측 19/4행).
 */
export const ADMIN_SHEET_NAME = 'CAPA_SMALL' as const;

/**
 * MSG — AS-IS MSG_ID 를 그대로 쓰지 않고 TO-BE 표준 ID 로 매핑(Hook #114). 등가 없으면 영문
 *   defaultValue fallback(임의 한글 INSERT 금지 — convert-core §2.3).
 *   - SAVE_CONFIRM/SAVED/NO_CHANGES = ForecastPrice(DMF0082) 대사 완료 TO-BE ID 재사용.
 *   - 화면 고유 검증(Y/N·범위)은 fallback 문구로 처리.
 */
export const MSG = {
  SAVE_CONFIRM: 'MSG00001', // 저장 하시겠습니까? (AS-IS MSG00012)
  SAVED: 'MSG00002', // 성공적으로 저장되었습니다.
  NO_CHANGES: 'MSG00004', // 저장할 데이터가 없습니다. (AS-IS validations #20)
  SAVE_ERROR: 'MSG00618', // 저장 중 오류가 발생했습니다.
  PERIOD_REQUIRED: 'MSG00108', // 조회 기간을 입력하세요.
} as const;

/** Bucket Type — 클라 정적 3옵션(AS-IS CommonUtils.GetBucketType, struct BucketType). 기본 DAILY. */
export const BUCKET_OPTIONS = [
  { label: 'Daily', value: 'DAILY' },
  { label: 'Weekly', value: 'WEEKLY' },
  { label: 'Monthly', value: 'MONTHLY' },
] as const;

export const DEFAULT_BUCKET = 'DAILY' as const;

/** Measure 코드 — SCM_MST_SHEET_MEASURE 4행(DB 실측). 편집 축 분기(D_ / M_)의 단일 출처. */
export const MEASURE = {
  NO_WORK: 'NO_WORK',
  LOAD_RATE: 'LOAD_RATE',
  RAMP_UP: 'RAMP_UP',
  DAILY_CAPA: 'DAILY_CAPA',
} as const;

/** M_(월) 컬럼 편집 measure — 그 외(NO_WORK/LOAD_RATE/RAMP_UP)는 D_(일) 컬럼 편집. (design 03 §1.2) */
export const M_EDIT_MEASURES: readonly string[] = [MEASURE.DAILY_CAPA];
export const D_EDIT_MEASURES: readonly string[] = [
  MEASURE.NO_WORK,
  MEASURE.LOAD_RATE,
  MEASURE.RAMP_UP,
];

/**
 * 일괄입력 Category(cboCategory) — AS-IS Form_Load dtCategoryList 하드코딩 정적(cs L186~192).
 *   btnInput 대상 measure 구분. label = measure 표시명, value = measure 코드.
 */
export const CATEGORY_OPTIONS = [
  { label: 'No Work', value: MEASURE.NO_WORK },
  { label: 'Load Rate', value: MEASURE.LOAD_RATE },
  { label: 'Ramp-up', value: MEASURE.RAMP_UP },
  { label: 'Daily Capa', value: MEASURE.DAILY_CAPA },
] as const;

/**
 * 일괄입력 Day Type(cboDayWeek) — AS-IS Form_Load dtDayType 하드코딩 정적(cs L194~205).
 *   EveryDay=전 기간 / SelectDay=선택 영역만.
 */
export const DAY_TYPE = {
  EVERY_DAY: 'EveryDay',
  SELECT_DAY: 'SelectDay',
} as const;
export const DAY_TYPE_OPTIONS = [
  { label: 'Every Day', value: DAY_TYPE.EVERY_DAY },
  { label: 'Select Day', value: DAY_TYPE.SELECT_DAY },
] as const;

/** Division 고정값 — AS-IS cboDivision.ControlValues='40'; Enabled=false (cs L182~183). */
export const FIXED_DIVISION = '40' as const;

/** CAPA_WORK(일) 저장 상한 — AS-IS validations #16/#23 (iCount_CAPA_WORK > 10000). */
export const CAPA_WORK_SAVE_LIMIT = 10000;

/** i18n 조회조건 라벨 — DB 실측 LBL ID (design 02 §4.5, 전건 존재·임의 생성 0). */
export const LBL = {
  DIVISION: 'LBL00641',
  PLANT_SITE: 'LBL00005',
  LINE: 'LBL00010',
  BUCKET: 'LBL00710',
  PERIOD: 'LBL00013',
  MATERIAL: 'LBL00021',
  NICK_NAME: 'LBL00767',
  CATEGORY: 'LBL00036',
  DAY_TYPE: 'LBL01066',
} as const;
