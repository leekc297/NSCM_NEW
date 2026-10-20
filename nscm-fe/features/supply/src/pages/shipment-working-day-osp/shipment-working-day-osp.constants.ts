export const MENU_ID = 'SCP0096' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL Master SCP0096_Shipment_Working_Day_OSP (Supply > Supply Master > Shipment Working Day(OSP)).
//   - 정적 좌측 6컬럼(SHEET_COLUMNS 메타) + 동적 기간 컬럼(3SPAN 타이틀 SP 응답 행으로 생성 — AS-IS InitSpreadDateColumn 1:1).
//     편집 대상 = WORKING_TIME_DEFAULT(FPNumber, scale2) + 동적 D_ 일자셀(Y/N 셀콤보 dtValidYN).
//   - 편집은 행 게이트가 아니라 EditButton(SwitchLock) 편집모드 진입 후 두 대상만 개방(01_layout §2, 03 §3-a).
//   - GET SP : PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (4 IN + O_RC1 데이터 + O_RESULT_CURSOR 상태).
//     실측(all_arguments + body): O_RC1 = 동적 PIVOT(SELECT IA.* FROM GT_SCP0096_PIVOT — 'D_'||YYYYMMDD 열), O_RESULT_CURSOR = '0'/'SUCCESS'.
//   - SAVE SP: PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP (7 CLOB '^' 배열 + P_USER_ID + O_RESULT_CURSOR).
//   - 3SPAN 헤더: PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN(공용, 조회기간→대/소/일 헤더 컬럼셋) — SHEETS.CALENDAR 로 조회.
//   - 설계 : .atlas/gscm-design/SCP0096/design/01_layout.md / 02_search-combo.md / 03_grid-columns.md
export enum SHEETS {
  // 메인 그리드 — DB 실측 SCM_MST_SHEET_COLUMNS.SHEET_NAME (PROGRAM_ID='SCP0096') = 'Shipment Working Day OSP'.
  //   admin `/column` 조회 키이자 그리드 데이터 sheetName.
  MAIN = 'Shipment Working Day OSP',
  // 동적 기간 헤더 컬럼셋 전용(데이터 시트 아님) — 사내 현행 배선 SCM_ADM_MNU_BTN_MPG_M(SCP0096 / calendar / SEARCH →
  //   API SCP0009_SHEET_CALENDAR_3SPAN_GET → PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN, proc_meta.csv).
  //   AS-IS InitSpread → GetSpdTitle(.cs:151,825-838 SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN) 1:1.
  //   IN 2개(startYyyymmdd/endYyyymmdd = 사내 PROC_M COL_NM, proc_params.csv)는 Store 의 calendarFilters 가 채운다.
  //   자매 SCP0095 shipment-working-day / SCP0010·SCP0031·SSP0015 와 동일 명명.
  CALENDAR = 'calendar',
  // 기본 조회기간 전용(데이터 시트 아님) — 사내 현행 배선 SCM_ADM_MNU_BTN_MPG_M(SCP0096 / dayRange / SEARCH →
  //   API SCM0001_SCP_MONTH_PERIOD_GET → PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD, 2026-10-20 ZIOUI1 실측).
  //   AS-IS InitControls `dCalendar.InitValue = GetDayRange()`(.cs:137,840-846) = DateUtil.GetDayRange(cboDivision,'DAILY')
  //   (DateUtil.cs:330-359 → SCP.SCM0001_GET_SCP_MONTH_PERIOD) 1:1. 응답 o_rc1[0].PERIOD = 'yyyymmdd:yyyymmdd'.
  //   IN 5개(divisionId/planCycle/fromDate/offsetMonth/timeZone = 사내 PROC_M COL_NM)는 Page 의 dayRangeFilters 가 채운다.
  DAY_RANGE = 'dayRange',
}

// 응답 키 = 사내 PROC_M OUT COL_NM 그대로(Doc/tobefacts/db/proc_params.csv, 대소문자 그대로).
//   BE 규약(BaseService.java:84/128/164): OUT 커서는 '@'+COL_NM 로 바인딩하고 응답 키는 '@' 만 뗀 COL_NM(재라벨·소문자화 없음).
//   ResultSetMetaData 사이드카(o_rc1_columns)는 SYS0013 DynamicQuery(DynamicQueryServiceImpl.java:46,73) 전용이라
//   일반 call-proc 응답에는 없다 — 동적 헤더는 CALENDAR 시트(3SPAN) 응답 행으로 만든다(2026-10-20 정정, DoD B26/B27).
export const RESPONSE_SET = {
  // 데이터 rows — GET SP OUT COL_NM 'o_rc1' (PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP pos5)
  MAIN: 'o_rc1',
  // 동적 기간 헤더 컬럼셋 rows — 3SPAN OUT COL_NM 'o_rc1' (PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN pos3).
  //   행 = COLUMN_NAME·COLUMN_LABEL_NAME·SMALL_CLASS_LABEL_NAME·LARGE_CLASS_LABEL_NAME·DAY_CODE·SORT_ORDER_NO (사내 실측 2026-10-20).
  CALENDAR: 'o_rc1',
  // 상태 커서 — GET/SAVE SP OUT COL_NM 'o_result_cursor' (CODE/MSG). 데이터 아님(저장/오류 확인용).
  STATUS: 'o_result_cursor',
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

// 3SPAN 응답 DAY_CODE — SCM_SYS_CALENDAR_M.DAYOFWEEK 실측 대문자(MON~SUN, 사내 2026-10-20).
//   AS-IS DefColumnsLabel Saturday="SAT"/Sunday="SUN"(.cs:81-85) — 헤더 요일색(.cs:206-208) 판정 원천.
//   btnInput 요일별 분기는 AS-IS GetDayOfWeek(.cs:811-818)처럼 cboDayWeek 코드(Mon~Sun).toUpperCase() 와 DAY_CODE 를
//   그대로 비교한다(.cs:798) — dayjs 요일 재계산 금지(서버 달력이 진실, 2026-10-20 정정: 이전 WEEKDAY_CODE_TO_INDEX 폐기).
export const DAY_CODE = { SAT: 'SAT', SUN: 'SUN' } as const;

// 주말 헤더 색 — AS-IS .cs:208 (SAT=Blue / SUN=Red). 자매 SCP0095 동일 팔레트.
export const WEEKEND_HEADER_COLOR = { SAT: '#1e56c8', SUN: '#c0392b' } as const;

// 동적 일자 컬럼 binding 규약 — 3SPAN COLUMN_NAME / GET SP alias 'D_' || BASIS_YYYYMMDD.
//   AS-IS Tag.IndexOf("D_")==0(.cs:542,745,759,772,788) 등가이면서 형식(8자리)까지 강제한다.
export const DAY_BINDING_RE = /^D_\d{8}$/;
// 합계 컬럼 binding — 3SPAN 'W_'||BASIS_YYYYMM||ISO_WEEK(주) / 'M_'||BASIS_YYYYMM(월). AS-IS SetSpreadColumn(.cs:353)·SetLockSumColumn(.cs:406).
export const SUM_BINDING_RE = /^[WM]_\d+$/;

// 동적 일자 컬럼 폭 — AS-IS AddComboColumn(sColumnLabelname, sColumnName, FPMerge.None, 50, …) .cs:203 리터럴.
export const DAY_COLUMN_WIDTH = 50;

// 다단 헤더 총높이 — 48px 고정(hook #93 단일 출처 = foundation HEIGHT_BY_COLUMN_DEPTH, 10_RULES_KEEP D3).
//   AS-IS ColumnHeaderSpan 의 20 을 3배(60)로 옮기면 위반이다(2026-10-20 정정: 이전 TOTAL=60, 자매 SCP0095 :98-99 지적).
//   per-tier 높이는 실제 렌더된 columnHeaders.rows.length 로 나눈다(3SPAN 응답 전 1단 → 수신 후 3단 전이에도 총합 유지).
export const HEADER_TOTAL_HEIGHT = 48;

// AS-IS Validation MSG — TO-BE SCM_ADM_MSG_M 실측(Doc/tobefacts/db/msg_master.csv 2026-10-19 추출) 기준 코드.
//   ⚠ AS-IS 코드 번호를 그대로 쓰면 안 된다 — TO-BE 는 재채번돼 본문이 다르다(2026-10-20 정정, 원장 S96-10~12):
//   AS-IS MSG00004 "{0}개의 데이터가 저장되었습니다" → TO-BE MSG00004 는 "수정한 내용이 없습니다" / AS-IS MSG00135 "수정모드가 아니므로
//   입력할 수 없습니다" → TO-BE MSG00135 는 "편집 모드에서는 이 기능을 사용할 수 없습니다" / AS-IS MSG00134·MSG00050 은 TO-BE 미등록.
//   원문 동일 코드가 있으면 그것(MSG01154·MSG01153·MSG00672), 없으면 의미 동일 공통 코드를 쓴다. 호출부는 t(MSG.KEY, '_Fallback').
export const MSG = {
  // btnInput 가드 #1 — 조회 전(AS-IS Columns.Get(0).Visible==false .cs:686 → MSG00135 "수정모드가 아니므로…").
  //   TO-BE 는 편집모드 토글이 없어 '조회 전' 이 이 가드의 실체 → "조회 후 수정모드로 가능합니다."
  NOT_SEARCHED: 'MSG00662',
  // btnInput 가드 — 편집 권한 없음(AS-IS 같은 MSG00135 분기). TO-BE 원문 동일 코드 "수정모드가 아니므로 입력할 수 없습니다."
  NOT_EDIT_MODE: 'MSG01154',
  // btnInput 가드 #4 — SelectDay 인데 선택셀 0(AS-IS MSG00134 "날짜 선택 후 입력하세요." .cs:703). TO-BE 원문 동일 코드.
  NO_CELL_SELECTED: 'MSG01153',
  // 필수값 — "{0} 값은 필수 입력 항목입니다." ({0}=라벨). 조회 Period 빈값(AS-IS Designer "Period*" :532 +
  //   DataUtil.checkRequiredOfSearch .cs:432) · btnInput Input Value 빈값/오염(cboInputValue 미선택) 공용.
  REQUIRED_VALUE: 'MSG00429',
  // 조회 Division 필수(AS-IS Designer "Division*" :545 + checkRequiredOfSearch) — "Division 을 선택하세요."
  DIVISION_REQUIRED: 'MSG00097',
  // 조회기간 역전(from > to) — "조회 기간이 잘못되었습니다 (시작일 > 종료일)."
  INVALID_PERIOD: 'MSG00108',
  // WORKING_TIME_DEFAULT 범위 — AS-IS SetReNumerCellType(…, 0, 0, 7) .cs:163 (최소 0 · 최대 7). "{0}~{1} 사이의 수를 입력하세요."
  WTD_RANGE: 'MSG01037',
  // WORKING_TIME_DEFAULT 정수 — AS-IS SetReNumerCellType 소수 0자리 .cs:163. "정수값만 입력가능합니다!"
  WTD_INTEGER: 'MSG00460',
  // 저장 성공 건수 — AS-IS MSG00004 "{0}개의 데이터가 저장되었습니다"(.cs:622 iCount) = TO-BE MSG00672 "{0}개의 데이터가 저장되었습니다."
  //   {0} = SAVE SP O_RESULT_CURSOR.RESULT_CNT (선례 SavePricePeriodModal / demand-manager SAVED_COUNT).
  SAVED_COUNT: 'MSG00672',
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

// 그리드 콤보 파라미터 — 등록 SQL @키 raw 치환값. 문자열 리터럴은 홑따옴표로 감싼다(BE raw 치환).
//   D_ 셀콤보 dtValidYN(YesOrNo)은 파라미터 없음(고정 2값)이나 공용 DataGrid 규약상 전달한다(무해).
export const GRID_COMBO_PARAMS: Record<string, string> = { mnuId: `'${MENU_ID}'` };

// SAVE payload 키 순서 — PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP all_arguments positional(03 §4 실측).
//   7 CLOB(pos1~7) 는 전부 '^' delim 다건 배열. P_USER_ID(pos8)는 BE 세션 자동이나 배열 붕괴 방지 List 접미.
//   AS-IS SaveData_Main DataTable A(action)열은 별도 P_ACTION 없음 → M-only 전송이므로 미편입(03 §6-1 확정:
//   SetModified 만 전송, I/D 는 AS-IS 주석처리 cs:602~604). is_save_defalut 로 D_/DEFAULT 분기.
export const SAVE_KEYS = [
  'divisionId', //          P_DIVISION_ID
  'plantSiteId', //         P_PLANT_SITE_ID
  'yyyymmdd', //            P_YYYYMMDD (D_ 일자, is_save_defalut='Y' 이면 미사용)
  'measure', //             P_MEASURE ('SHIPMENT WORKING DAY' 고정 — GET 상수)
  'shipmentYn', //          P_SHIPMENT_YN (D_ 셀 Y/N)
  'workingTimeDefault', //  P_WORKING_TIME_DEFAULT
  'isSaveDefault', //       P_IS_SAVE_DEFAULT ('Y'=WORKING_TIME_DEFAULT 저장 / 'N'=D_ 일자셀)
  'userIdList', //          P_USER_ID (BE 세션 자동 — 배열 붕괴 방지 List 접미, WorkingTime 선례)
] as const;

// MEASURE 고정값 — GET 이 O_RC1 에 'SHIPMENT WORKING DAY' 문자열 상수로 채움(03 §1 SEQ6 / §4 GET SELECT).
//   저장 시에도 이 값을 P_MEASURE 로 전송(고정칼럼).
export const MEASURE_CONST = 'SHIPMENT WORKING DAY' as const;

// WORKING_TIME_DEFAULT 입력 제약 — AS-IS InitSpread `SetReNumerCellType(spdInfo, col(WORKING_TIME_DEFAULT), 0, 0, 7)`(.cs:163):
//   소수 0자리 · 최소 0 · 최대 7(주당 출하 가능 일수). 사내 SAVE SP(F_TO_NUM)는 범위 검사가 없으므로 저장 직전 FE 가 판정한다.
//   빈값은 AS-IS 가 "0" 으로 치환(.cs:567) = 사내 SP F_TO_NUM(NULL)=0 과 동등이라 FE 는 '' 그대로 보낸다.
export const WTD_RANGE = { MIN: 0, MAX: 7 } as const;

// UI 라벨 코드 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') DB 실측. 호출부는 t(LBL.KEY, '_Fallback').
//   (Sum 라벨 LBL00687 은 2026-10-20 제거 — AS-IS chkSum 은 Designer Visible=false(:346)라 사용자에게 보이지 않는 컨트롤.)
export const LBL = {
  SEARCH: 'LBL00112', //         Search
  DIVISION: 'LBL00641', //       Division (DB 실측 EN/KO='Division'. LBL00001='Div.' 는 다른 라벨)
  PLANT_SITE: 'LBL00005', //     Plant Site
  PERIOD: 'LBL00013', //         Period
  DAY_OF_THE_WEEK: 'LBL01067', // Day of the week
  INPUT_VALUE: 'LBL01084', //    Input Value
  INPUT: 'LBL00872', //          Input
} as const;
