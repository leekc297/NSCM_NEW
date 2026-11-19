export const MENU_ID = 'SCP0096' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL Master SCP0096_Shipment_Working_Day_OSP (Supply > Supply Master > Shipment Working Day(OSP)).
//   - 정적 좌측 6컬럼(SHEET_COLUMNS 메타) + GET SP O_RC1 동적 D_/W_/M_ pivot 기간 컬럼(3SPAN 헤더).
//     편집 대상 = WORKING_TIME_DEFAULT(FPNumber, scale2) + 동적 D_ 일자셀(Y/N 셀콤보 dtValidYN).
//   - 편집은 행 게이트가 아니라 EditButton(SwitchLock) 편집모드 진입 후 두 대상만 개방(01_layout §2, 03 §3-a).
//   - GET SP : PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (4 IN + O_RC1 데이터 + O_RESULT_CURSOR 상태).
//     실측(all_arguments + body): O_RC1 = 동적 PIVOT(SELECT IA.* FROM GT_SCP0096_PIVOT), O_RESULT_CURSOR = '0'/'SUCCESS'.
//   - SAVE SP: PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP (7 CLOB '^' 배열 + P_USER_ID + O_RESULT_CURSOR).
//   - 3SPAN 헤더: PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN(공용, 조회기간→대/소/일 헤더 컬럼셋).
//   - 설계 : .atlas/gscm-design/SCP0096/design/01_layout.md / 02_search-combo.md / 03_grid-columns.md
export enum SHEETS {
  // 메인 그리드 — DB 실측 SCM_MST_SHEET_COLUMNS.SHEET_NAME (PROGRAM_ID='SCP0096') = 'Shipment Working Day OSP'.
  //   admin `/column` 조회 키이자 그리드 데이터 sheetName.
  MAIN = 'Shipment Working Day OSP',
  // 동적 pivot 헤더 컬럼셋 SP 전용 시트 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN(공용, VALID).
  //   AS-IS GetSpdTitle(3SPAN)의 TO-BE 2콜 재현(03 §4): 조회기간으로 D_/W_/M_ 컬럼명·3단 라벨을 먼저 받아
  //   그리드 동적 컬럼을 구성한다. 데이터 커서(O_RC1)는 컬럼 메타를 함께 주지 않으므로(call-proc 경로는
  //   o_rc1_columns 사이드카 미발행) 컬럼 목록의 단일 원천이다. DB 등록: SCM_ADM_MNU_BTN_MPG_M
  //   (SCP0096/calendar/SEARCH → 공용 API 'SCP0009_SHEET_CALENDAR_3SPAN_GET'), 자매 SCP0010 동형.
  CALENDAR = 'calendar',
  // 조회기간 기본값 산정 SP 전용 시트 — PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD(공용, VALID).
  //   AS-IS DateUtil.GetDayRange(division,"DAILY") 재현(SCP0096.cs:837 → DateUtil.cs:156 → SP). 서버가
  //   SCM_MST_PLAN 기준으로 PERIOD 를 산정: 계획 있으면 계획일~계획일+363일(52주), 없으면 timezone 기준
  //   오늘~+offsetMonth. 반환 O_RC1.PERIOD = 'YYYYMMDD:YYYYMMDD'. DB 등록:
  //   SCM_ADM_MNU_BTN_MPG_M(SCP0096/dayRange/SEARCH → 공용 API 'SCM0001_SCP_MONTH_PERIOD_GET').
  PERIOD = 'dayRange',
}

// GET SP 는 단일 호출로 데이터(O_RC1) + 상태(O_RESULT_CURSOR) 2커서를 반환한다.
//   BE 규약(BaseService.java:503): 오라클 OUT 커서명을 소문자화해 응답 키로 쓴다(재라벨 없음).
//   실측(all_source PKG_SCP0096 BODY): O_RC1 = 동적 PIVOT 데이터, O_RESULT_CURSOR = 상태('0'/'SUCCESS').
export const RESPONSE_SET = {
  // 데이터 rows — SP OUT O_RC1 (BE 표준 매핑 o_rc1)
  MAIN: 'o_rc1',
  // 동적 D_/W_/M_ 컬럼셋 — CALENDAR(3SPAN) SP OUT O_RC1. call-proc 경로는 데이터 커서의
  //   ResultSetMetaData 사이드카(o_rc1_columns)를 발행하지 않으므로, 동적 컬럼 목록은 이 커서가 정본이다.
  CALENDAR: 'o_rc1',
  // 조회기간 산정 커서 — dayRange(GetDayRange) SP OUT O_RC1. 1행 1컬럼 PERIOD='YYYYMMDD:YYYYMMDD'.
  PERIOD: 'o_rc1',
  // 상태 커서 — SP OUT O_RESULT_CURSOR (CODE/MSG). 데이터 아님(저장/오류 확인용).
  STATUS: 'o_result_cursor',
} as const;

// GetDayRange(dayRange) SP 고정 파라미터 — AS-IS SCP0096.cs:837 GetDayRange() 호출 인자 1:1.
//   planCycle='DAILY'(BucketType.Daily, cs:86·134) / fromDate=''(plan date 미전달) /
//   offsetMonth='12'(DateUtil.cs:156 sOffsetMonth 기본). timeZone 은 호출부에서 sessionTimeZone(session)
//   으로 넘긴다 — AS-IS UserInfoContext.TimeZone 과 동일하게 사용자 등록 timezone(tmzCd) 기준으로 SP 가
//   FN_MULTY_TIME 으로 '오늘'을 잡게 한다(종전 'AS054' 하드코딩은 비-KST 사용자에게 날짜경계 오차, 2026-11-12 교정).
export const DAY_RANGE_PARAMS = {
  planCycle: 'DAILY',
  fromDate: '',
  offsetMonth: '12',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// 콤보 SQL_ID — 02_search-combo.md §2 DB 실측 확정치(SCM_ADM_CMBO_SQL_M).
//   접미 규칙(convert-core §2.6): _SCP=권한/파라미터 필터형 / 무접미=공통 base.
//   combo-sqlid-suffix-must-match-registration — 등록명과 문자 1:1(bare 금지). 전건 등록명 실측 일치.
export const COMBO = {
  // cboDivision(단일 필수) — 권한기반 Division. @sesUserId+@mnuId 조인(권한필터).
  //   AS-IS GetDivisionWithoutEE(ATTRIBUTE3<>'EE') 재현 — 'MyDivisionInEE_SCP' 는 SELECT 에 ATTRIBUTE3
  //   를 반환하지 않아 FE 클라필터가 무동작(gap-resolve iter-2 G9, 독립 검증 적발)이었다. 동일 권한조건 +
  //   ATTRIBUTE3<>'EE' 서버 필터를 가진 자매 등록행 'Division_SCP_NoEE'(plan-control/workbench 등 기존 사용)로
  //   교체 — DB 신규등록 아님, 실등록행 미러링(convert-core §2.6).
  DIVISION: 'Division_SCP_NoEE',
  // clbPlantSite(다중, cascade 하위) — SITE_TYPE='PLANT' AND OSP_YN='Y' 고정(외주 전용). @divisionId 재조회.
  //   ComboParam 객체로 divisionId 를 실어 react-query 키 변경 → 자동 재조회(필터형 아님, 02 §3).
  PLANT_SITE: 'PlantByDivisionOperOsp3_SCP',
  // cboInputValue(단일) — Y/N 공통. 일괄입력 값. 그리드 D_ 셀콤보(dtValidYN)와 동일 소스(02 §2 #5).
  INPUT_VALUE: 'YesOrNo',
} as const;

// 그리드 D_ 일자 셀콤보 — AddComboColumn(dtValidYN=YesOrNo). Y=출하근무일 / N=비근무일(03 §2).
//   조회조건 cboInputValue 와 동일 SQL_ID. 공용 DataGrid 셀콤보 배선용.
export const CELL_COMBO_VALID_YN = 'YesOrNo' as const;

// cboDayWeek lookup — SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='WEEK_WORK_TIME' (02 §2 #4 실측 9값).
//   값: EveryDay(10) / SelectDay(15·기본) / Mon~Sun(20~80). SEGMENT1=CODE / SEGMENT2=NAME.
//   btnInput 일괄입력 분기 키(SelectDay=선택셀 / EveryDay=전행 / Mon~Sun=요일별, 03 §3-b).
export const DAY_WEEK_LOOKUP = { lookupType: 'WEEK_WORK_TIME' } as const;

// btnInput 분기 상수 — 03 §3-b SetText 3분기.
export const DAY_WEEK = {
  EVERY_DAY: 'EveryDay',
  SELECT_DAY: 'SelectDay', // 기본. 선택 셀에만 기입(선택셀 0 이면 MSG00134).
} as const;

// 요일코드(Mon~Sun) → dayjs day() 인덱스(0=일 ~ 6=토). btnInput 요일별 분기(GetDayOfWeek 매칭, 03 §3-b :797).
export const WEEKDAY_CODE_TO_INDEX: Record<string, number> = {
  Sun: 0,
  Mon: 1,
  Tue: 2,
  Wed: 3,
  Thu: 4,
  Fri: 5,
  Sat: 6,
} as const;

// Validation MSG — 다국어 정본은 DB(SCM_ADM_MSG_M)다. 전 코드 DB 실재 확인(2026-10-13 ora.py).
//   JSON(public/locales)은 DB 동기본일 뿐 직접 수정 금지. 아래는 모두 DB 등록 코드로 교정했다.
export const MSG = {
  // btnInput 조회 전 차단 — MSG00662("조회 후 수정모드로 가능합니다", DB 실재). AS-IS 는 MSG00135 였으나
  //   TO-BE MSG00135 문구가 "편집 모드에서는 이 기능을 사용할 수 없습니다"로 의미가 달라 용도에 맞게 교정.
  SEARCH_FIRST: 'MSG00662',
  // 조회조건 필수(Division) — MSG00013("필수 입력란을 입력해 주세요", DB 실재). (MSG00135 오사용 교정)
  REQUIRED: 'MSG00013',
  // SelectDay 선택셀 0 — MSG01153("날짜 선택 후 입력하세요", DB 실재). AS-IS MSG00134 문구와 동일하나
  //   TO-BE DB 에는 MSG00134 가 없고 같은 문구가 MSG01153 으로 등록돼 있어 그 코드를 쓴다.
  NO_CELL_SELECTED: 'MSG01153',
  // 조회기간 역전(start>end) — MSG00108("조회 기간이 잘못되었습니다 (시작일 > 종료일)", DB 실재).
  INVALID_PERIOD: 'MSG00108',
  // InputValue 형식(Y/N) 방어검증 — cboInputValue(YesOrNo)라 정상경로 미도달(사실상 unreachable).
  //   TODO(다국어 등록 대기): MSG00050 은 AS-IS(TB_FX_MessageInfo) 에서 "This is not a valid numeric
  //   format.{0}"(숫자형식 오류)라 Y/N 검증과 의미 불일치이고, 그 숫자-형식 메시지는 TO-BE 에 MSG01082 로
  //   이미 이관됨 → MSG00050 코드는 TO-BE DB 에 없다. Y/N 전용 문구는 신규 등록 요청 중(사용자 seq 채번).
  //   등록 코드 확정되면 이 값을 그 코드로 교체한다(그 전까지 EN fallback 표시).
  INVALID_FORMAT: 'MSG01082',
  // 저장 성공 토스트 — 'MSG00002'="성공적으로 저장되었습니다." (TO-BE 실측). AS-IS 는 MSG00004("N건 저장",
  //   cs:622)였으나 TO-BE 로케일에서 MSG00004 는 "수정한 내용이 없습니다"(의미 drift)라 성공 메시지로 쓰면
  //   저장 성공인데 "수정한 내용이 없습니다" 토스트가 뜬다 — 형제 SCP0019/shipment-plan-semi 와 동일 교정.
  //   [[new-alert-msg-code-reuse-collision]]
  SAVED: 'MSG00002',
  // 재진입 가드 — 저장 in-flight 중 재클릭 차단(공통 표준)
  WORK_IN_PROGRESS: 'MSG00137',
  // 저장 대상 없음 — "No data to save."
  NO_SAVE_DATA: 'MSG00152',
  // 저장 오류 공통 fallback
  SAVE_ERROR: 'MSG00618',
} as const;

// InputValue(YesOrNo) 허용값 — btnInput 이 선택 D_ 셀에 SetText 하는 값(03 §3-b). 정수 아님(SCP0019 대비 델타).
export const INPUT_VALUE_SET: readonly string[] = ['Y', 'N'];

// D_ 셀콤보 dataMap — dtValidYN 고정 2값(Y/N). CustomerFcstMasterDateColumns 선례처럼 서버콤보 없이
//   리터럴 dataMap 으로 배선(동적 alias 라 SHEET_COLUMNS/SCM_ADM_CMBO_SQL_M 미등재, 03 §2).
export const DAY_CELL_DATA_MAP: readonly string[] = ['Y', 'N'];

// 코드 그대로 표시할 컬럼 — CODE -> NAME dataMap 을 붙이지 않는다(DIVISION_ID 는 코드 표기).
//   admin 메타에 CELL_COMBO_DATA_TYPE 이 등재돼 있어도 이 목록이 우선(WorkingTime 1:1).
export const CODE_DISPLAY_COLUMNS: readonly string[] = ['DIVISION_ID'];

// WORKING_TIME_DEFAULT 값 범위 — AS-IS SetReNumerCellType(SCP0096.cs:163, min=0, dec=0, max=7) + 정수(0~9)만
//   입력 가능(사용자 지시 2026-10-29: 소수점 입력 금지). DB 실측 SCM_MST_SHEET_COLUMNS.DATA_SCALE_NUMBER=2
//   는 이 AS-IS·사용자 지시와 불일치 — ShipmentWorkingDayOspGrid 가 scale 0 으로 코드 오버라이드한다(DB
//   정정은 별도 register SQL 대상). MIN 은 숫자키만 입력 가능해 음수 입력 자체가 안 되므로 참고용.
export const WORKING_TIME_DEFAULT_RANGE = {
  MIN: 0,
  MAX: 7,
} as const;

// 그리드 콤보 파라미터 — 등록 SQL @키 raw 치환값. 문자열 리터럴은 홑따옴표로 감싼다(BE raw 치환).
//   D_ 셀콤보 dtValidYN(YesOrNo)은 파라미터 없음(고정 2값)이나 공용 DataGrid 규약상 전달한다(무해).
export const GRID_COMBO_PARAMS: Record<string, string> = { mnuId: `'${MENU_ID}'` };

// SAVE payload 키 순서 — PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP all_arguments positional(03 §4 실측).
//   7 CLOB(pos1~7) 는 전부 '^' delim 다건 배열. P_USER_ID(pos8)는 BE 세션 자동이나 배열 붕괴 방지 List 접미.
//   AS-IS SaveData_Main DataTable A(action)열은 별도 P_ACTION 없음 → M-only 전송이므로 미편입(03 §6-1 확정:
//   SetModified 만 전송, I/D 는 AS-IS 주석처리 cs:602~604). is_save_defalut 로 D_/DEFAULT 분기.
// '^' 구분 다건 배열로 보내는 7 CLOB 파라미터(SCM_ADM_PROC_M COL_NM 실측, 전부 CLOB IN).
//   P_USER_ID 는 여기 없다 — VARCHAR 단일 파라미터(COL_NM='userId')로 payload 에 따로 싣는다(handleSave).
export const SAVE_KEYS = [
  'divisionId', //          P_DIVISION_ID
  'plantSiteId', //         P_PLANT_SITE_ID
  'yyyymmdd', //            P_YYYYMMDD (D_ 일자, is_save_defalut='Y' 이면 미사용)
  'measure', //             P_MEASURE ('SHIPMENT WORKING DAY' 고정 — GET 상수)
  'shipmentYn', //          P_SHIPMENT_YN (D_ 셀 Y/N)
  'workingTimeDefault', //  P_WORKING_TIME_DEFAULT
  'isSaveDefault', //       P_IS_SAVE_DEFAULT ('Y'=WORKING_TIME_DEFAULT 저장 / 'N'=D_ 일자셀)
] as const;

// MEASURE 고정값 — GET 이 O_RC1 에 'SHIPMENT WORKING DAY' 문자열 상수로 채움(03 §1 SEQ6 / §4 GET SELECT).
//   저장 시에도 이 값을 P_MEASURE 로 전송(고정칼럼).
export const MEASURE_CONST = 'SHIPMENT WORKING DAY' as const;

// UI 라벨 코드 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') DB 실측. 호출부는 t(LBL.KEY, '_Fallback').
export const LBL = {
  SEARCH: 'LBL00112', //         Search
  // Division 라벨은 기본 Div(LBL00001)로 통일(사용자 정책 2026-10-13 [[division-label-default-div-not-division]]).
  //   AS-IS 설계(02_search-combo §1·§4.5)는 LBL00641='Division'이나, 전사 기본값 Div 정책을 우선 적용.
  DIVISION: 'LBL00001', //       Div (KO 'Div' / EN·CN 'Div.')

  PLANT_SITE: 'LBL00005', //     Plant Site
  PERIOD: 'LBL00013', //         Period
  DAY_OF_THE_WEEK: 'LBL01067', // Day of the week
  INPUT_VALUE: 'LBL01084', //    Input Value
  INPUT: 'LBL00872', //          Input
  SUM: 'LBL00687', //            Sum
  OK: 'LBL00716', //             OK (팝업 확인 버튼)
  CLOSE: 'LBL00627', //          Close (팝업 닫기 버튼)
} as const;
