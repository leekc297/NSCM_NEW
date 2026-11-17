export const MENU_ID = 'SCP0019' as const;
export type MENU_ID = typeof MENU_ID;

// UI 라벨 LBL 코드 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') DB 실측 매칭. 값이 곧 LBL 코드.
//   호출부는 t(LBL.KEY, '_Fallback') 폴백형(bod-item/shipment-working-day 표준).
export const LBL = {
  SEARCH: 'LBL00112', //           Search
  DIVISION: 'LBL00001', //         Division
  PLANT_SITE: 'LBL00005', //       Plant Site
  OPERATION: 'LBL00009', //        Operation
  LINE: 'LBL00010', //             Line
  DAY_OF_WEEK: 'LBL01067', //      Day of the week
  PERIOD: 'LBL00013', //           Period
  INPUT_VALUE: 'LBL01084', //      Input Value
  OK: 'LBL00716', //               OK (팝업 확인 버튼)
  CLOSE: 'LBL00627', //            Close (팝업 닫기 버튼)
} as const;

// AS-IS GSCM.SCP.Forms.UIL Master SCP0019_WorkingTime (Supply > Supply Master > Work Calendar(OSP)).
//   - 메인 그리드 : 식별/메타 14 컬럼(4 숨김 · 항상 잠금) + GET SP O_RC1 동적 D_ 기간 컬럼
//     (OSP_YN='Y' 행만 편집). 편집 대상 = WORKING_TIME_DEFAULT(FPNumber) + 동적 D_.
//   - GET SP : PKG_SCP0019.P_SCP0019_GET_WORKING_TIME (7 IN + O_RC1 데이터 + O_RESULT_CURSOR 상태)
//     실측(all_source BODY): O_RC1 = 피벗 데이터(SUM(CASE...) AS D_yyyymmdd), O_RESULT_CURSOR = '0'/'SUCCESS'.
//   - SAVE SP: PKG_SCP0019.P_SCP0019_SAVE_WORKING_TIME_ROW ('^' delim 배열, WORKING_TIME_HIST 이력 INSERT)
//   - 설계 : .atlas/gscm-design/SCP0019/design/01_layout.md / 02_search-combo.md / 03_grid-columns.md
//   - 버튼 메타 실측(SCM_ADM_MNU_BTN_MPG_M) = SEARCH/SAVE 2건만. Insert/Delete = AS-IS NO-OP(미등록).
export enum SHEETS {
  // 메인 그리드 — DB 실측 SCM_MST_SHEET_COLUMNS.SHEET_NAME (PROGRAM_ID='SCP0019') = 'Working Time'.
  //   admin `/column` 조회 키이자 그리드 데이터 sheetName.
  MAIN = 'Working Time',
  // 동적 기간 컬럼은 별도 SP 시트가 아니다 — GET SP O_RC1 데이터 커서 자신의 alias(D_yyyymmdd)이며,
  //   BE 가 o_rc1_columns(ResultSetMetaData)로 컬럼 목록을 함께 노출한다(04_impl-gap-audit #1).

  // Period 기본값 계산용 공용 SP 호출 시트(그리드 아님) — AS-IS dCalendar.InitValue = DateUtil.GetDayRange(...)
  //   재현. call-proc 매핑 SCM_ADM_MNU_BTN_MPG_M(SCP0019,'MonthPeriod',SEARCH) → API_ID
  //   SCM0001_SCP_MONTH_PERIOD_GET → PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD. 사용자 등록 timezone(tmzCd)을
  //   넘겨 오늘/기간을 timezone+달력테이블(SCM_SYS_CALENDAR_M) 기준으로 계산(브라우저 dayjs 근사 대체).
  //   SHT_NM 은 DB 등록값과 대소문자 일치 필수(불일치 시 proc 해석 실패).
  PERIOD = 'MonthPeriod',
}

// GET SP 는 단일 호출로 데이터(O_RC1) + 상태(O_RESULT_CURSOR) 2커서를 반환한다.
//   BE 규약(BaseService.java:503): 오라클 OUT 커서명을 소문자화해 응답 키로 쓴다(재라벨 없음).
//   실측(all_source PKG_SCP0019 BODY): O_RC1 = 피벗 데이터 커서, O_RESULT_CURSOR = 상태('0'/'SUCCESS').
export const RESPONSE_SET = {
  // 데이터 rows — SP OUT O_RC1 (BE 표준 매핑 o_rc1)
  MAIN: 'o_rc1',
  // 동적 D_ 컬럼 메타 — SP OUT O_RC1 의 ResultSetMetaData 사이드카 (BE 표준 매핑 o_rc1_columns)
  DYN_COLUMNS: 'o_rc1_columns',
  // 상태 커서 — SP OUT O_RESULT_CURSOR (CODE/MSG). 데이터 아님(저장/오류 확인용).
  STATUS: 'o_result_cursor',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// 콤보 SQL_ID — 02_search-combo.md §2 DB 실측 확정치(SCM_ADM_CMBO_SQL_M).
//   접미 규칙(convert-core §2.6): _SCP=권한필터 / _SCP_ALL=전체로드(클라필터) / 무접미=공통 base.
//   cascade 는 전부 필터형 — _SCP_ALL 3콤보를 1회 전량 로드 후 FE 에서 DBUtils.Filter 재현(§3).
export const COMBO = {
  // cboDivision(단일 필수) — 권한기반 Division. @sesUserId+@mnuId 조인, ATTRIBUTE3<>'EE' 내장.
  DIVISION: 'MyDivision',
  // clbPlantSite(다중) — SITE_TYPE='PLANT' AND OSP_YN='Y' 내장(OSP 사이트 한정). DIVISION_ID 클라필터.
  PLANT_SITE: 'PlantByDivisionOperOsp4_SCP_ALL',
  // clbBuilding(다중·정적 hidden) — DISTINCT FACTORY. DIVISION_ID 클라필터. 숨김이나 데이터소스 보존.
  BUILDING: 'BuildingByDivision1_SCP_ALL',
  // clbOperation(다중) — LocationGroup + 'VENDOR' UNION 상수행. 필터 없이 전체 유지.
  OPERATION: 'LocationGroupByCapaWT_SCP',
  // clbLine(다중) — LINE_SN + LINE_OSP UNION. 다중키(DIVISION_ID+FACTORY_ID+OPERATION_GROUP+SITE_ID) 클라필터.
  LINE: 'LineByOperationAddOSP2_SCP_ALL',
} as const;

// cboDayWeek lookup — SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='WEEK_WORK_TIME' (02 §2-b 실측).
//   값: EveryDay(seq10) / SelectDay(seq15·기본) / Mon~Sun(seq20~80). SEGMENT1=CODE / SEGMENT2=NAME.
export const DAY_WEEK_LOOKUP = { lookupType: 'WEEK_WORK_TIME' } as const;

// cboDayWeek 기본값 — SelectDay. btnInput 가드 #3: SelectDay 이면 값입력 차단(01 §2-c).
export const DAY_WEEK_SELECT_DAY = 'SelectDay';

// 값입력(btnInput) 일괄입력 분기 키 — AS-IS BtnInput_Click(SCP0019_WorkingTime.cs:1231~) 3분기.
//   EveryDay=전행×전 D_ / SelectDay=선택영역 D_ 셀 / Mon~Sun=전행×해당 요일 D_ 컬럼(DynDayColumn.weekday 매칭).
export const DAY_WEEK = {
  EVERY_DAY: 'EveryDay',
  SELECT_DAY: DAY_WEEK_SELECT_DAY,
} as const;

// 근무시간 값 범위 — 필드별 상한이 다르다. AS-IS 정본(SCP0019_WorkingTime.cs:877~897)이 판정 근거.
//   WORKING_TIME_DEFAULT 컬럼(cs:881): 0~7  (MSG00203 "0","7.0")  — 요일 단위 기본 근무시간.
//   그 외 동적 D_ 셀(cs:890)        : 0~1440(MSG00203 "0","1440") — 분 단위 일자별 근무시간.
//   주의: live SCP_MST_WORKING_TIME.WORKING_TIME 에 1440 초과 39행(MAX 3600)이 있으나 이는 레거시
//   더티데이터다 — AS-IS 비즈니스 룰은 0~1440 이므로 상한을 3600 으로 올리지 않는다(anti-simplification).
export const WORKING_TIME_RANGE = {
  DEFAULT_MIN: 0,
  DEFAULT_MAX: 7,
  DAY_MIN: 0,
  DAY_MAX: 1440,
} as const;

// 조회 기간 상한(일) — SP 결과가 고정 14 + 일자 컬럼이라 Oracle 1000 컬럼 제한(ORA-01792) 전에 막는다.
export const MAX_PERIOD_DAYS = 980;

// AS-IS Validation MSG — SCM_ADM_MSG_M 실측(02 §5). 미등록 3건은 EN fallback 병기(정직 표기).
export const MSG = {
  // btnInput(Bulk Update) 조회 전 차단 — 가드 조건은 !hasSearched(조회 전). AS-IS BtnInput_Click 의
  //   MSG00135("수정모드가 아니므로 입력할 수 없습니다")를 옮겼으나, 이 화면엔 '수정모드' 토글이 없어 문구가
  //   오해를 부름 → 자매 SCP0096(shipment-working-day-osp)과 동일하게 MSG00662("조회 후 수정모드로 가능합니다")로
  //   통일(2026-10-16 사용자 지시). MSG00662 DB 실재. TO-BE MSG00135 은 "편집 모드에서는 이 기능을 사용할 수
  //   없습니다"로 의미가 달라 미사용.
  NOT_SEARCHED: 'MSG00662',
  // Division 미선택 가드(validateFind) — TO-BE 전용 검증. MSG00097("Please select Division." / "Division 을
  //   선택하세요.") 사용 — fallback 문구와 동일, KO/EN/CN 등록(ora.py 실측 2026-10-19). 종전 MSG00135 는 TO-BE 에
  //   "This function is locked in edit mode."로 등록돼 Division 안내와 무관한 문구가 떴다(문구 역검색으로 교체).
  DIVISION_REQUIRED: 'MSG00097',
  // 저장 무변경 — "No changes to save." (SCM_ADM_MSG_M 등재)
  NO_CHANGES: 'MSG00004',
  // 셀/날짜 미선택 — AS-IS BtnInput_Click 의 MSG00134("날짜 선택 후 입력하세요")를 문구로 이관.
  //   TO-BE 동일 문구 코드 = MSG01153 (KO/EN/CN exact match, DB 실측 2026-10-15). AS-IS 번호 MSG00134 는
  //   TO-BE 미등록이라 MSG01153 로 교체.
  NO_CELL_SELECTED: 'MSG01153',
  // 입력값 숫자형식 오류(값입력) — AS-IS BtnInput_Click 의 MSG00050("유효한 숫자 형식이 아닙니다. {0}")를
  //   문구로 이관. TO-BE 동일 문구 코드 = MSG01082 (KO/EN/CN exact match, DB 실측 2026-10-15). {0}=입력값 치환.
  INVALID_INPUT_VALUE: 'MSG01082',
  // 기간 역전(from>to) 가드 — TO-BE 전용 검증(AS-IS 무메시지). MSG00108("Invalid period (start > end)." /
  //   "조회 기간이 잘못되었습니다 (시작일 > 종료일).") 사용 — fallback 문구와 동일, KO/EN/CN 등록(ora.py 실측 2026-10-19).
  //   종전 MSG00050 은 TO-BE 미등록이라 '_Invalid period…' fallback 이 그대로 노출됐다(화면 실측).
  INVALID_FORMAT: 'MSG00108',
  // 기간 상한 초과 — "최대 조회일은 From Date + {0} 입니다." ({0}=MAX_PERIOD_DAYS)
  PERIOD_MAX: 'MSG01187',
  // 근무시간 범위 초과(0~7 / 0~1440) — AS-IS 는 MSG00203("{0}~{1} 사이의 수를 입력하세요.")을 쓰나 TO-BE 에는
  //   MSG00203 미등록, 동일 문구가 MSG01037 로 등록됨(KO/EN/CN exact match, ora.py 실측 2026-10-19) → MSG01037 사용.
  //   AS-IS 와 동일하게 저장 시점(handleSave)에만 검사한다 — 입력·편집·일괄입력은 범위 미검사(D_ 셀 타입 max 없음,
  //   cs:330). WORKING_TIME_DEFAULT 0~7 은 셀 편집 상한(rangeGuardHandler)이 별도로 있으나 저장 검증도 AS-IS 처럼 함께 둔다.
  OUT_OF_RANGE: 'MSG01037',
  // 재진입 가드 — "이전 작업이 아직 실행 중입니다." (저장 in-flight 중 재클릭 차단, DMF0014 표준)
  WORK_IN_PROGRESS: 'MSG00137',
  // 저장 성공 — "성공적으로 저장되었습니다." (공용 표준 키, DMF0014 1:1)
  SAVED: 'MSG00002',
  // 저장 오류 공통 fallback — "저장 중 오류가 발생했습니다."
  SAVE_ERROR: 'MSG00618',
  // 저장 대상 없음 — "No data to save."
  NO_SAVE_DATA: 'MSG00152',
} as const;

// 코드 그대로 표시할 컬럼 — CODE -> NAME dataMap 을 붙이지 않는다(DIVISION_ID 는 코드 표기).
//   admin 메타에 CELL_COMBO_DATA_TYPE 이 등재돼 있어도 이 목록이 우선(DMF0014 1:1).
export const CODE_DISPLAY_COLUMNS: readonly string[] = ['DIVISION_ID'];

// 그리드 콤보 파라미터 — 등록 SQL @키 raw 치환값. 문자열 리터럴은 홑따옴표로 감싼다(BE raw 치환).
//   이 화면 정적 컬럼엔 셀 콤보가 없으나(03 §6 #5), 공용 DataGrid 규약상 전달한다(무해).
export const GRID_COMBO_PARAMS: Record<string, string> = { mnuId: `'${MENU_ID}'` };

// SAVE payload 의 '^' delim 배열 키 — PKG_SCP0019.P_SCP0019_SAVE_WORKING_TIME_ROW PROC_M param 1~10
//   (DATA_TP_CD=CLOB, positional). AS-IS 셀별 A플래그(I/M/D)→CLOB 배열 인덱스 매핑(04_react-gap #4 확인필요).
//   param 11 userId(P_USER_ID, VARCHAR 단일)는 '^' 배열이 아니므로 여기 넣지 않고 handleSave 가 스칼라로 보낸다.
export const SAVE_KEYS = [
  'activeFlag', //          P_ACTIVE_FLAG (셀 상태 I/M/D)
  'divisionId', //          P_DIVISION_ID
  'plantSiteId', //         P_PLANT_SITE_ID
  'factoryId', //           P_FACTORY_ID
  'operationId', //         P_OPERATION_ID
  'lineId', //              P_LINE_ID
  'yyyymmdd', //            P_YYYYMMDD (D_ 일자, IS_SAVE_DEFAULT='Y' 이면 미사용)
  'workingTime', //         P_WORKING_TIME (D_ 셀 값)
  'isSaveDefault', //       P_IS_SAVE_DEFAULT ('Y'=WORKING_TIME_DEFAULT 저장)
  'workingTimeDefault', //  P_WORKING_TIME_DEFAULT
] as const;
