export const MENU_ID = 'SSP0005' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0005_ShipmentWorkingDay (Shipping > Shipping Master > Shipment Working Day).
//   출하 근무일 달력 마스터 — (division x company) 행 x 일자 열 매트릭스에서 WORKDAY_YN(Y/N)만 편집한다.
//   - 정적 2열(SCM_MST_SHEET_COLUMNS 실측 COMPANY_ID/DIVISION_ID, 둘 다 INPUT_TP_CD='S')
//     + 동적 일자열 D_YYYYMMDD N개(GET SP pivot alias, 기본 363열 / 상한 10,000).
//   - 헤더 3단(월/주차/일)은 공용 PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN 이 정본이다.
//     클라에서 dayjs 로 요일/주차를 재계산하지 않는다(자매 SCP0096 이 그렇게 우회한 것을 복사 금지).
//   - GET  : PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY (5 IN + o_rc1 + O_RESULT_CURSOR)
//   - SAVE : PKG_SSP0005.P_SSP0005_SAVE_SHIPMENT_WORKING_DAY (5 CLOB '^' 배열 + 3 VARCHAR2 + OUT)
//   - 설계 : .atlas/gscm-design/SSP0005/design/00_checklist.md ~ 03_grid-columns.md
//     AS-IS 라인 매핑은 __asis-mapping__.md.
export enum SHEETS {
  // 메인 그리드 — DB 실측 SCM_MST_SHEET_COLUMNS.SHEET_NAME (PROGRAM_ID='SSP0005').
  //   admin `/column` 조회 키이자 SCM_ADM_MNU_BTN_MPG_M.SHT_NM 이다(두 축을 일치시켜 등록했다).
  MAIN = 'Shipment Working Day',
  // 헤더 3단 컬럼셋 전용 시트 — 공용 3SPAN SP. 자매 SCP0010/SCP0031/SCP0095/SSP0015 와 동일 명명.
  CALENDAR = 'calendar',
}

// 커서 응답 키 — SCM_ADM_PROC_M.COL_NM 실측값을 대소문자까지 그대로 쓴다.
//   필수: BaseService 는 COL_NM 을 변형 없이 응답 키로 내보낸다(cursorKey.add(colNm) ->
//   writeArrayFieldStart). 이 화면의 PROC_M 은 커서마다 등록 케이스가 다르다 —
//   o_rc1 은 소문자, O_RESULT_CURSOR 는 대문자다. 한쪽 케이스로 통일해 적으면
//   조회는 조용히 빈 배열, 저장은 RESULT_CNT 미수신 후 FE 카운트로 폴백한다(타입도 안 걸린다).
export const RESPONSE_SET = {
  // 그리드 데이터 행 — SP OUT o_rc1
  MAIN: 'o_rc1',
  // 동적 D_ 컬럼 메타 사이드카 {name,type}[] — BE ResultSetMetaData 표준.
  //   미사용(참조 0건): 동적 컬럼 원천은 3SPAN 응답으로 잡았다(04_react-gap.md R-9).
  //   사이드카를 쓰면 DAY_CODE·주차·월 라벨이 없어 클라 재계산이 필요해지고 03 §2-c 금지에 걸린다.
  //   키 자체는 응답 계약 문서로 남긴다 — 삭제하면 다음 회차가 "사이드카가 없다"고 오판한다.
  DYN_COLUMNS: 'o_rc1_columns',
  // 3SPAN 헤더 컬럼셋 — calendar 시트 OUT o_rc1
  CALENDAR: 'o_rc1',
  // 상태 커서 {CODE,MSG,RESULT_CNT} — PROC_M 등록값이 대문자다
  STATUS: 'O_RESULT_CURSOR',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// Period 기본값 SP 버튼코드 — SCM_ADM_MNU_BTN_MPG_M (SHT_NM=SHEETS.MAIN) -> API SCM0001_SCP_PERIOD_GET
//   (= PKG_COM0000.P_SCM0001_GET_SCP_PERIOD). 자매 SSP0200 의 GET_SCP_DAY_PERIOD 와 같은 형식이다.
export const BTN_GET_SCP_PERIOD = 'GET_SCP_PERIOD' as const;

// 조회조건 콤보 SQL_ID — 02_search-combo.md §2.1 DB 실측 확정치(SCM_ADM_CMBO_SQL_M).
export const COMBO = {
  // cboCompany — 화면 전용 SQL_ID(05_register.sql 신설). 공유 'Company' 는 NAME=COMPANY_ID 라
  //   AS-IS(COMPANY_NAME 표시)와 다르고 ORDER BY 도 없다. 소비자 2건이라 본문 수정 금지(hook #117)
  //   -> 화면 전용 분리가 정답이다(02 §5.3 A안, 사용자 확정 2026-09-29).
  COMPANY: 'Company_SSP0005',
  // clbDivision — 권한 Division. ATTRIBUTE3<>'EE' 제외가 SQL 본문에 있다.
  //   주의: 이름이 비슷한 Division_SCP / MyDivisionInEE 는 EE 제외가 없는 별개 콤보다(convert-core §2.6).
  DIVISION: 'MyDivision',
  // cboInputValue — Y/N. AS-IS 는 C# BLL 리터럴이나 의미가 같은 등록 SQL_ID 를 쓴다(하드코딩 금지).
  INPUT_VALUE: 'YesOrNo',
  // cboDayWeek — AS-IS Data.Common(Data.Type.LookupCommon, "WEEK_WORK_TIME")(cs:47)의 직접 이관.
  //   그 데이터소스는 TO-BE 콤보 SQL_ID='LookupCommon'(SCM_ADM_CMBO_SQL_M, @lookupType,
  //   ORDER BY B.DISPLAY_SEQ)에 1:1 대응한다. 종전엔 generic /admin/lookup
  //   (PKG_NSCM_UI_COM_LOOKUP.PR_GET_LOOKUP_INFO_LIST — SYSTEM_ADM 외 ORDER BY 없음)로 호출해
  //   정렬이 빠져 CODE 알파벳순으로 나왔다(2026-09-30 실측·프로시저 담당 확인). 이 콤보는
  //   DISPLAY_SEQ 순 정렬이라 화면 정렬 불필요 — EveryDay/SelectDay/Mon~Sun(10/15/20~80).
  //   선례: plan-activity-mgmt {comboId:'LookupCommon', lookupType:'OPMZ_PRS_CD'}.
  DAY_WEEK: { comboId: 'LookupCommon', lookupType: 'WEEK_WORK_TIME' },
} as const;

// btnInput 일괄입력 분기 키 — 03 §3-b. 요일 코드(Mon~Sun)는 lookup 값을 그대로 쓰고
//   DAY_CODE(MON~SUN)와는 대소문자 무시 비교한다(AS-IS .cs:808 ToUpper 비교 1:1).
export const DAY_WEEK = {
  EVERY_DAY: 'EveryDay',
  SELECT_DAY: 'SelectDay',
} as const;

// AS-IS 기본 요일 — 바인딩 시점 index 0 자동선택으로 항상 EveryDay 였다(02 §3.2 실측).
export const DEFAULT_DAY_WEEK: string = DAY_WEEK.EVERY_DAY;

// Division 조회조건 전체선택 sentinel. 주의: 이 값을 그대로 SP 에 보내면 TO-BE SP 가
//   UPPER(값)='ALL' 을 "필터 없음"으로 해석해 권한 밖 Division 이 새어나온다(02 §4.4 / §7 E-2).
//   store.setFilters 가 divisionCodes 콤마 전개로 치환한다.
export const ALL = 'ALL' as const;

// 동적 일자 컬럼 binding 규약 — GET SP alias 'D_' || BASIS_YYYYMMDD.
//   AS-IS IndexOf("D_")==0 의 등가이면서 형식(8자리)까지 강제한다(03 §3-R5).
export const DAY_BINDING_RE = /^D_\d{8}$/;

// 3SPAN 응답 DAY_CODE — SCM_SYS_CALENDAR_M.DAYOFWEEK 실측 대문자 7값.
export const DAY_CODE = { SAT: 'SAT', SUN: 'SUN' } as const;

// 주말 헤더 색 — AS-IS .cs:265-268 (SAT=Blue / SUN=Red). 자매 SCP0096 과 동일 팔레트.
export const WEEKEND_HEADER_COLOR = { SAT: '#1e56c8', SUN: '#c0392b' } as const;

// 동적 D_ 셀 콤보 dataMap — dtYesOrNo 고정 2값. 화면 주입형이므로 _ctrlData(cellCboDataTp)는
//   절대 세팅하지 않는다(값이 남으면 공용 DataGrid 자동 콤보가 이 dataMap 을 덮어쓴다).
export const DAY_CELL_DATA_MAP: readonly string[] = ['Y', 'N'];

// 동적 일자 컬럼 폭 — AS-IS AddComboColumn(..., 70, ...) .cs:263 리터럴.
export const DAY_COLUMN_WIDTH = 70;

// 다단 헤더 총높이 — 48px 고정(hook #93 단일 출처 = foundation HEIGHT_BY_COLUMN_DEPTH).
//   AS-IS ColumnHeaderSpan 의 20 을 3배(60)로 옮기면 위반이다. 자매 SCP0096 의 TOTAL=60 은 복사 금지.
//   per-tier 높이는 여기서 상수로 박지 않는다 — 실제 렌더된 columnHeaders.rows.length 로 나눈다
//   (hook #93 §3 원칙 2. 3SPAN 응답이 비거나 늦는 프레임에서 tier 수 추정이 어긋난다).
export const HEADER_TOTAL_HEIGHT = 48;

// i18n — 전부 SCM_ADM_MSG_M 역조회 실측치다. AS-IS 번호 그대로 쓰면 문구가 뒤집힌다(hook #114).
//   AS-IS MSG00097 -> MSG00667 / MSG00093 -> MSG01122 / MSG00134 -> MSG01153 / MSG00004 -> MSG00672.
export const MSG = {
  // 권한 Division 0건 게이트(AS-IS MSG00097). TO-BE MSG00097 은 "Please select Division." 라 오매핑 금지.
  NO_DIVISION_AUTH: 'MSG00667',
  // {0} 선택 안내(AS-IS MSG00093). Input Value 미선택 / Period 빈값 가드가 공유한다.
  SELECT_REQUIRED: 'MSG01122',
  // SelectDay 인데 선택영역 0(AS-IS MSG00134)
  NO_CELL_SELECTED: 'MSG01153',
  // 값을 비운 일자 셀이 있어 저장을 차단했을 때. AS-IS 에는 대응 가드 자체가 없다(TO-BE 전용
  //   방어 — 빈값을 보내면 WORKDAY_YN NOT NULL 에 걸려 전건 롤백된다). 원인이 조회조건이 아니라
  //   그리드 일자 셀이므로 {0}=LBL00069('Date') 로 넣는다. DB 실존 코드만 쓴다(임의 INSERT 금지).
  BLANK_DAY_CELL: 'MSG00614',
  // btnInput 조회 전 차단 — AS-IS 는 편집모드 판정(MSG00135)이었으나 그 축은 폐기됐다.
  //   TO-BE 는 "조회 전"이 실제 가드라 MSG00719 를 쓴다(사용자 확정 2026-09-29, Q1).
  NOT_SEARCHED: 'MSG00719',
  // 저장 성공(AS-IS MSG00004). TO-BE MSG00004 는 "No changes to save." 로 정반대다.
  SAVED: 'MSG00672',
  // 저장 대상 0건
  NO_SAVE_DATA: 'MSG00152',
  // 저장 오류 fallback
  SAVE_ERROR: 'MSG00618',
  // 재진입 가드(AS-IS CanModelChange 등가)
  WORK_IN_PROGRESS: 'MSG00137',
} as const;

// 라벨 — 01 부록 A 실측. 조회조건 Division 은 LBL00641 이 아니라 LBL00001(커밋 a5b92cf0 표준화).
export const LBL = {
  COMPANY: 'LBL00047',
  DIVISION: 'LBL00001',
  PERIOD: 'LBL00013',
  DAY_OF_WEEK: 'LBL01067',
  INPUT_VALUE: 'LBL01084',
  INPUT_BUTTON: 'LBL00872',
  SEARCH: 'LBL00112',
  // 동적 일자 컬럼 지시용(메시지 인자 전용 — 화면 라벨로는 쓰지 않는다. 컬럼 헤더는 3SPAN 메타다).
  DATE: 'LBL00069',
} as const;

// SAVE payload 키 순서 — SCM_ADM_PROC_M 실측 IN 1~8(PKG_SSP0005.P_SSP0005_SAVE_...).
//   1~5 는 CLOB '^' 결합 배열, 6~8 은 스칼라 VARCHAR2 다.
//   필수: activeFlag 를 변경 셀 건수만큼 채운다 — SP 가 F_SPL_CNT(P_ACTIVE_FLAG) 로 루프 길이를
//   뽑으므로 1토큰만 보내면 나머지가 조용히 미저장된다(03 §4-e #3).
export const SAVE_ARRAY_KEYS = [
  'activeFlag', //   1 P_ACTIVE_FLAG (CLOB, 'M' x 건수)
  'divisionId', //   2 P_DIVISION_ID (CLOB)
  'companyId', //    3 P_COMPANY_ID  (CLOB)
  'yyyymmdd', //     4 P_YYYYMMDD    (CLOB, binding 에서 'D_' 제거)
  'workdayYn', //    5 P_WORKDAY_YN  (CLOB, 셀 값 Y/N)
] as const;

// 변경 셀 1건의 활성 플래그 — SP 는 값 자체를 쓰지 않고 토큰 수만 센다(BODY:296-297).
export const SAVE_ACTIVE_FLAG = 'M' as const;

// '^' 배열 구분자 — BE makeProcedure 가 결합해 주지 않으므로 FE 가 직접 만든다.
export const SAVE_DELIMITER = '^' as const;

// GET SP debugMode 고정값 — AS-IS .cs:409 "F".
export const DEBUG_MODE = 'F' as const;
