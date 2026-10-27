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
  INPUT: 'LBL00872', //            Input
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

// AS-IS Validation MSG — SCM_ADM_MSG_M 실측(02 §5). 미등록 3건은 EN fallback 병기(정직 표기).
//   MSG00135 는 존재하나 EN 문구("This function is locked in edit mode.")가 AS-IS 실제 용도(조회 전
//   btnInput 차단)와 어긋난다 — 재사용하되 fallback 문구를 실제 용도로 지정(04_react-gap 확인필요 이월).
export const MSG = {
  // btnInput 조회 전 차단 — MSG00135 존재(단 EN 문구 용도 불일치, 04_react-gap #2)
  NOT_SEARCHED: 'MSG00135',
  // 저장 무변경 — "No changes to save." (SCM_ADM_MSG_M 등재)
  NO_CHANGES: 'MSG00004',
  // 셀 미선택 — TO-BE 미등록(신규 채번 필요, 04_react-gap #3). EN fallback.
  NO_CELL_SELECTED: 'MSG00134',
  // 입력값 형식 오류 — TO-BE 미등록(신규 채번 필요). EN fallback.
  INVALID_FORMAT: 'MSG00050',
  // 근무시간 범위 초과(0~7 / 0~1440) — TO-BE 미등록(신규 채번 필요). EN fallback.
  OUT_OF_RANGE: 'MSG00203',
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

// SAVE payload 키 순서 — PKG_SCP0019.P_SCP0019_SAVE_WORKING_TIME_ROW PROC_M positional(03 §SAVE 실측).
//   전부 '^' delim 다건. AS-IS 셀별 A플래그(I/M/D)→CLOB 배열 인덱스 매핑(04_react-gap #4 확인필요).
//   userId(P_USER_ID)는 BE 세션 자동이나 배열 붕괴 방지 위해 List 접미로 보강(DMF0014 createdByList 선례).
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
  'userIdList', //          P_USER_ID (BE 세션 자동 — 배열 붕괴 방지 List 접미, DMF0014 선례)
] as const;
