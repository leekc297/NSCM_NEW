export const MENU_ID = 'SCP0031' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL/Analysis/SCP0031_GlobalPSI (51076B) — 읽기전용 Global PSI PIVOT 분석 조회.
//   Find/Excel/Measure(팝업)만 실동작. Edit/Save/Delete = 빈 override(NO-OP). 셀 편집·셀 콤보 없음.
//   설계 근거: .atlas/gscm-design/SCP0031/design/00_checklist.md ~ 03_grid-columns.md (DB 실측 PASS).
//   - 메인 GET : PKG_SCP0031.P_SCP0031_GET_GLOBAL_PSI (16 IN + O_RC1 + O_RESULT_CURSOR, ora.py 2026-09-27)
//                IN camelCase(SP arg P_ 제거): fromYyyymmdd/toYyyymmdd/divisionId/itemId/nickName/fromSite/
//                toSite/planStartYyyymmdd/planType/seq/programId/sheetName/userId/bucket/chkAll/debugMode
//   - Calendar : PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (IN startYyyymmdd/endYyyymmdd / O_RC1)
//                동적 pivot 기간칼럼 3단 헤더(월/주/일) 원천. 공통 패키지 멤버(자매 SCP0095 와 API 공유).
//   PKG_SCP0031 배포 완료(PACKAGE + BODY VALID). 컬럼메타(19)/Measure(16)/OPERATION_GROUP lookup 배포됨.
//   메뉴/버튼/API 메타는 미배포 → 05_register.sql 등록. PROC_M(GET) 미등록 = convert-sp 후속(04 명시).
export enum SHEETS {
  // FE 라우팅 sheetName. DB SHT_NM 'Global PSI'(SHEET_COLUMNS.SHEET_NAME) ↔ FE 'main' 표준(convert-core §2.4).
  MAIN = 'main', // spdMain — Global PSI pivot 그리드(정적 19열[가시15] + 동적 D_/W_/M_ 기간칼럼)
  CALENDAR = 'calendar', // GET_SHEET_CALENDAR_3SPAN — 동적 pivot 3단 헤더 원천(그리드 시트 아님)
}

// NSCM 단일 cursor 표준. GET SP 는 O_RC1(PIVOT 데이터) + O_RESULT_CURSOR(상태봉투) 반환 — O_RC1 을 바인딩.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup 시트명 — SCM_MST_SHEET_COLUMNS/SCM_MST_SHEET_MEASURE(PROGRAM_ID='SCP0031')
//   SHEET_NAME 실측 = 'Global PSI'(design 03 §DB, ora.py 2026-09-27). admin 등록본이 authoritative.
export const ADMIN_SHEET_NAME: Record<SHEETS.MAIN, string> = {
  [SHEETS.MAIN]: 'Global PSI',
};

// SCM_MST_SHEET_MEASURE 등록 시트명 — measure 16행 메타(design 03 §1-C). SHEET_NAME='Global PSI'(ora.py 실측).
export const MEASURE_SHEET_NAME = 'Global PSI';

// 조회조건 콤보 SQL_ID — SCM_ADM_CMBO_SQL_M 등록 실측(design 02 §2.2, USE_YN='Y', ora.py 2026-09-27).
//   SP 변형 규약(convert-core §2.6 1층): Data_SCP.Common→_SCP / Data_SCP.CommonAll→_SCP_ALL.
export const COMBO = {
  // cboDivision — 권한 division. AS-IS BLUtils.GetDivisionWithoutEE = Division_SCP + 클라필터.
  //   Division_SCP 는 ATTRIBUTE3(EE 마커) 반환하므로 FE 후처리로 EE·40 제외 재현(design 02 §2.2 ①②).
  //   MyDivision(DM 전용) 재사용 금지(convert-core §2.6 실측 사고).
  DIVISION: 'Division_SCP',
  // clbFromSite — SITE_TYPE='PLANT' 서버 필터 내장. 토큰 @validYn/@divisionId(FE)/@sesUserId(BE). 재조회.
  FROM_SITE: 'FromSiteByDivision',
  // clbToSite — PLANT 필터 없음(전체 valid). 토큰 @divisionId(FE)/@__GROUP__/@sesUserId(BE). 재조회.
  //   @__GROUP__ 는 FE 가 보내지 않아 makeComboQuery 가 ''로 치환 → LIKE '%%'(그룹 AuthType 필터 무력화,
  //   @sesUserId 기준만 유지). 자매 supply 화면 bod(BodForm.tsx:20~23)와 동일한 의도적 결정 — 0건이 되지
  //   않으며 목록이 AS-IS(NowGroupID 전달)보다 넓을 수 있다(04 N3, 265 공유콤보 공통 사안, runtime 대조 축).
  TO_SITE: 'ToSiteByDivision',
  // cboPlanDate — _ALL 전체로드 후 FE 필터(DIVISION_ID). 토큰 @divisionId/@versionId(미전송=전체). 반환 DIVISION_ID.
  PLAN_DATE: 'DATE_WEEKLY1_SCP_ALL',
  // cboPlanType — 토큰 없음(항상 전체). FE 필터(DIVISION_ID+PLANDATE). 반환 DIVISION_ID/PLANDATE.
  PLAN_TYPE: 'PlanType1_SCP_ALL',
  // cboPlanSeq — _ALL 전체로드 후 FE 필터(DIVISION_ID+PLANDATE+PLANTYPE). 반환 DIVISION_ID/PLANDATE/PLANTYPE.
  PLAN_SEQ: 'PlanSeq1_SCP_ALL',
  // cboBucketType — lookup BUCKET_TYPE_CODE(DAILY/WEEKLY/MONTHLY). 토큰 없음. 기본 DAILY.
  BUCKET: 'BucketType',
} as const;

// Division 화면 전용 필터(design 02 §2.2 ①②) — AS-IS 는 CMBO_SQL 에 없어 FE 재현 필수(좁힘 주체 단일).
//   ATTRIBUTE3='EE'(전극) 제외 + CODE='40'(소형) 제외. 미재현 시 목록이 AS-IS 보다 넓어짐(조회범위 결함).
export const DIVISION_EE_EXCLUDE = 'EE';
export const DIVISION_EXCLUDE_CODE = '40';

// Site 미선택 센티넬(design 02 §4.2) — 목록 앞 '-' prepend. 조회 시 '-'/'ALL'/'' 은 전부 빈값(SP 전체 우회).
export const SITE_SENTINEL = '-';

// FE cascade 클라 필터 반환컬럼(design 02 §2.3 실측 별칭). _ALL 3콤보를 이 컬럼으로 좁힌다.
export const CASCADE_COL = {
  DIVISION_ID: 'DIVISION_ID',
  PLANDATE: 'PLANDATE',
  PLANTYPE: 'PLANTYPE',
} as const;

// Bucket Type — lookup BUCKET_TYPE_CODE(DAILY/WEEKLY/MONTHLY). 기본 DAILY(design 02 §4.2 cs:168 DefineProperty).
//   D_/W_/M_ pivot visible × chkSum 조합을 전환(design 03 §2.2). SP 는 전세트 공급 — 재조회 없는 클라 토글.
export const BUCKET_CODE = {
  DAILY: 'DAILY', // 기본 — D_ 항상 표시
  WEEKLY: 'WEEKLY', // W_ 항상 표시
  MONTHLY: 'MONTHLY', // M_ 항상 표시
} as const;
export const BUCKET_DEFAULT = BUCKET_CODE.DAILY;

// 동적 pivot 기간칼럼 접두(design 03 §2.1). D_(일)/W_(주SUM)/M_(월SUM). B_ 접두는 AS-IS dead(SP 미산출, design 03 L2).
export const PIVOT_PREFIX = {
  DAILY: 'D_',
  WEEKLY: 'W_',
  MONTHLY: 'M_',
} as const;

// Period 기본 범위 — AS-IS GetDayRange 근사(design 02 §4.2/§7 N4). from=planDate, to=planDate+363일(52주-1).
//   AS-IS DateUtil.GetDayRange(GSCM/01.Framework/.../DateUtil.cs:156) 는 서버 SP SCM0001_GET_SCP_MONTH_PERIOD
//   (p_offset_month='12', 약 1년)을 호출해 범위를 산출한다 — +363 은 그 12개월 오프셋의 근사다. 정확 재현은
//   해당 SP(convert-sp 소관) 배선이 필요하나, Period 는 사용자 편집 가능한 prefill 이고 아래 clamp(C9)로
//   horizon 상한이 강제되므로 저위험 잔여로 둔다(04 N4).
export const PERIOD_W52_OFFSET_DAYS = 363;

// C9 SCP 구간(Plan horizon) 초과 검증 — AS-IS FindData_Main → SCPPlan.CheckPlanPeriodRange(GetPeriodRange)
//   (GSCM SCP0031_GlobalPSI.cs:537~542 / 979~1075). SCPPlanPeriod_SCP 콤보 SQL 을 조회해(등록 실측:
//   @planName=planDate, @divisionId — PLAN_CYCLE='WEEKLY' 하드코딩이라 bucket 토큰 없음), 조회 종료일이
//   HORIZON_END_DATE 를 넘으면 종료일을 horizon 으로 되돌리고 이번 조회를 중단한다(AS-IS return).
export const PLAN_PERIOD_COMBO_ID = 'SCPPlanPeriod_SCP';
// SCPPlanPeriod_SCP 반환 컬럼(ora.py 실측) — HORIZON_END_DATE(상한 yyyymmdd) / DIFF_WEEK(초과 메시지 {0}주).
export const PLAN_PERIOD_COL = {
  HORIZON_END_DATE: 'HORIZON_END_DATE',
  DIFF_WEEK: 'DIFF_WEEK',
} as const;

// titleSet columnType — Measure 개인화(design 03 §6 C3). saveTitleSet 3점(menuId/sheetName/columnType) 일치.
export const TITLESET_MEASURE_TYPE = 'M';

// 드릴다운(design 03 §3 R8, hook #103) — 헤더/SUM 셀 더블클릭 컬럼 show/hide(pivot 드릴다운).
//   저위험 잔여: 공용 DataGrid 에 pivot 컬럼 collapse/expand machinery 미제공 → 미구현(04 명시, 자매 SCP0100 동일).

// Validation MSG ID — TO-BE SCM_ADM_MSG_M 역매핑(Hook #114, 자매 global-psi-elec 실측 재사용).
export const MSG = {
  // 필수값 미입력(Division*/Plan-date*/Plan-type*/Seq*/Period*) — AS-IS checkRequired(design 02 §5.1).
  //   MSG00013(EN)='Please enter the required fields.'(elec iter-1 gap-audit 확정 실측).
  REQUIRE_CONDITION: 'MSG00013',
  // 권한 Division 0건(design 01 §2 R1 SetDivisionAuthCheck). MSG00097(EN)='Please select Division.'(실측).
  NO_DIVISION_AUTH: 'MSG00097',
  // 기간 horizon 초과(C9) — AS-IS CheckPlanPeriodRange 가 MSG00402 를 {0}=DIFF_WEEK/{1}=HORIZON_END 로 포맷.
  //   TO-BE SCM_ADM_MSG_M 미등록(ora.py 실측 0행, 공유 메시지). FE 는 AS-IS(TB_FX_MessageInfo) 실측 영문을
  //   defaultValue 로 병기해 i18n fallback 으로 표시한다(코드베이스 {0}/{1} .replace 규약, 예 MSG.PERIOD_MAX
  //   WaterfallShipmentPlanFg). DB 등록은 공유 메시지 후속(04 명시) — 미등록이어도 기능 정상.
  PERIOD_EXCEEDS: 'MSG00402',
} as const;

// i18n 라벨 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 실측 LBL ID(design 02 §4.5, 전건 존재·신규 추가 불요).
export const LABEL = {
  SEARCH: 'LBL00664', // 조회 버튼(SearchArea 공통 라벨)
  DIVISION: 'LBL00641',
  MATERIAL: 'LBL00021',
  NICK_NAME: 'LBL00767',
  FROM_SITE: 'LBL00022',
  TO_SITE: 'LBL00023',
  PLAN_DATE: 'LBL00039',
  PLAN_TYPE: 'LBL00040',
  SEQ: 'LBL00768',
  BUCKET: 'LBL00710',
  PERIOD: 'LBL00013',
  ALL: 'LBL00632', // chkAll
  SUM: 'LBL00687', // chkSum(SUM 컬럼 표시 토글, design 02 §4.5 note / design 03 §2.2)
  MEASURE: 'LBL00310', // Measure 버튼(개인화 팝업, 자매 SCP0100 선례 동일)
  // Bucket 드롭다운 옵션 라벨 — 자매 global-psi-elec 실측 전용 코드(ora.py).
  BUCKET_DAILY: 'LBL00682', // Daily
  BUCKET_WEEKLY: 'LBL00683', // Weekly
  BUCKET_MONTHLY: 'LBL00684', // Monthly
} as const;
