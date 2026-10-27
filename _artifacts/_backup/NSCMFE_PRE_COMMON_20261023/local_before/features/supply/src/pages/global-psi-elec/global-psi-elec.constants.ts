export const MENU_ID = 'SCP0095' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL/Analysis/SCP0095_GlobalPSI_Elec (852줄) — 순수 조회(read-only) 3단 헤더 pivot.
//   저장/편집/신규/삭제 없음(전열 LockColumn, override 전부 NO-OP). 셀 콤보 없음.
//   설계 근거: .atlas/gscm-design/SCP0095/design/00_checklist.md ~ 03_grid-columns.md (DB 실측 PASS).
//   - 메인 GET : PKG_SCP0095.P_SCP0095_GET_GLOBAL_PSI_ELEC (11 IN + O_RC1 + O_RESULT_CURSOR)
//                PROC_M 등록 camelCase: divisionId/company/itemId/yyyymmdd/fromYyyymmdd/toYyyymmdd/
//                planType/programId/sheetName/userId/debugMode (ora.py 2026-09-26)
//   - Calendar : PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (IN startYyyymmdd/endYyyymmdd / O_RC1)
//                동적 pivot 기간칼럼 3단 헤더(월/주/일) 원천.
//   SP 배포 완료(PKG_SCP0095 PACKAGE + BODY VALID). 버튼/권한/컬럼(14)/measure(10) 메타 등록 실측(design 01·03).
//   메뉴 1행 등록됐으나 USE_YN='N' → 05_register.sql 에서 'Y' 활성화(확인필요 #4).
export enum SHEETS {
  // SCM_ADM_MNU_BTN_MPG_M SHT_NM 실측: globalPsiElec(메인) / calendar(3단 헤더). 둘 다 SEARCH 등록·USE_YN=Y.
  MAIN = 'globalPsiElec', // spdMain — Global PSI Elec pivot 그리드(고정 14열 + 동적 D_/W_/M_ 기간칼럼)
  CALENDAR = 'calendar', // GET_SHEET_CALENDAR_3SPAN — 동적 pivot 3단 헤더 원천(그리드 시트 아님)
}

// NSCM 단일 cursor 표준. GET SP 는 O_RC1(PIVOT 데이터) + O_RESULT_CURSOR(상태봉투) 반환 — O_RC1 을 바인딩.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup 시트명 — SCM_MST_SHEET_COLUMNS/SCM_MST_SHEET_MEASURE(PROGRAM_ID='SCP0095')
//   SHEET_NAME 실측 = 'Global PSI Elec'(design 03 §1, ora.py). admin 등록본이 authoritative(fetchStaticColumns).
export const ADMIN_SHEET_NAME: Record<SHEETS.MAIN, string> = {
  [SHEETS.MAIN]: 'Global PSI Elec',
};

// 조회조건 콤보 SQL_ID — SCM_ADM_CMBO_SQL_M 등록 실측(design 02 §2, USE_YN='Y').
export const COMBO = {
  // cboDivision — 권한 division. AS-IS BLUtils.GetDivisionEE(false) = Division_SCP + DataView.RowFilter
  //   "ATTRIBUTE3='EE'"(전극만). Division_SCP 는 ATTRIBUTE3 를 결과셋에 반환하므로 FE 후처리로 EE 필터 재현
  //   (design 02 §2-1 Option B — 자매 global-psi-report 가 동일 콤보를 FE ATTRIBUTE3 필터로 쓰는 선례).
  //   Division_SCP_NoEE(반대=EE 제외)·MyDivisionInEE_SCP(필터 없음) 재사용 금지(convert-core §2.6 실측).
  DIVISION: 'Division_SCP',
  // cboCompany — 전극 Company. 정적(파라미터 0, division cascade 아님). 값=COMPANY_NAME(CODE)/표시=COMPANY_ID(NAME).
  COMPANY: 'COMPANY_EE',
  // cboPlanDate — 주단위 계획일자. division 종속 재조회(토큰 @divisionId). 단일선택.
  PLAN_DATE: 'DATE_WEEKLY',
} as const;

// Division 화면 전용 필터 — ATTRIBUTE3='EE'(전극만 유지, AS-IS GetDivisionEE). 좁히는 주체는 FE 하나만(design 02 §2-1).
export const DIVISION_EE_INCLUDE = 'EE';

// Bucket Type — AS-IS GetBucketType() SP(DAILY/WEEKLY/MONTHLY 고정 enum) 대신 정적 select 로 재현
//   (자매 global-psi-report 동일 패턴 — 값이 고정 3종이고 조회 파라미터 아닌 pivot 표시 토글이라 SP 왕복 불요).
//   기본 WEEKLY(design 02 §4.2 cboBucketType.SelectedValue=Weekly). D_/W_/M_ pivot visible 을 전환(design 03 §2.2).
export const BUCKET_CODE = {
  DAILY: 'DAILY', // D_ 컬럼 visible
  WEEKLY: 'WEEKLY', // 기본 — W_ 컬럼 visible
  MONTHLY: 'MONTHLY', // M_ 컬럼 visible
} as const;
export const BUCKET_DEFAULT = BUCKET_CODE.WEEKLY;

// 동적 pivot 기간칼럼 접두(design 03 §2.1). D_(일)/W_(주)/M_(월). B_ 접두는 AS-IS 사문(SP 미산출) — 미처리.
export const PIVOT_PREFIX = {
  DAILY: 'D_',
  WEEKLY: 'W_',
  MONTHLY: 'M_',
} as const;

// Period 기본 범위 — AS-IS GetDayRange("52") = plan_start 부터 52주(52*7-1=363일). from=planDate, to=planDate+363일.
//   design 02 §2-5(W52, 일요일 보정 -1). SP PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD 의 문서화된 산식을 재현
//   (해당 SP 는 SCP0095 aux 시트 미등록 — 캘린더 경계 스냅이 다를 수 있어 확인필요 #A, 04_react-gap §확인필요).
export const PERIOD_W52_OFFSET_DAYS = 363;

// measure 행 조건부 배경색(design 03 §3 R19~R21, SetBGColor). MEASURE_NAME·PSI 조합. col4~끝(값 영역)에 적용.
export const CONDITIONAL_BG = {
  P_SUM: 'rgb(218, 238, 243)', // PSI='P' & MEASURE_NAME='SUM' → #DAEEF3 연파랑 (R19)
  S_SUM: 'rgb(224, 243, 176)', // PSI='S' & MEASURE_NAME='SUM' → #E0F3B0 연녹 (R20)
  I_EOH: 'rgb(254, 235, 201)', // PSI='I' & MEASURE_NAME='EOH' → #FEEBC9 연주황 (R21)
} as const;

// 조건부 배경 적용 시작 컬럼 index(design 03 R19~21 "col4~끝"). 0-base 4번째 컬럼부터 값 영역.
export const CONDITIONAL_BG_START_COL = 4;

// 소수 2자리 measure 행(design 03 §3.1 R30 Set_CellType). 그 외 measure 기간셀은 정수(R3).
export const DECIMAL2_MEASURES = ['Yield_A', 'Yield_E'] as const;

// 드릴다운(design 03 §3.1 buttonGuards 3중 가드 + hook #103). MEASURE_NAME 열 & 현재행='Prod Plan (Engine)'
//   더블클릭 → SCP0013 이동. 조건 5개(division/operationGroup='E'/plantSite=TO_SITE/itemId=ELEC_MODEL/planDate).
export const DRILLDOWN = {
  TARGET_MENU: 'SCP0013',
  TRIGGER_COLUMN: 'MEASURE_NAME',
  TRIGGER_MEASURE: 'Prod Plan (Engine)',
  OPERATION_GROUP: 'E',
} as const;

// Validation MSG ID — TO-BE SCM_ADM_MSG_M 역매핑(Hook #114). AS-IS 리터럴 문구를 그대로 쓰지 않는다.
export const MSG = {
  // 필수값 미입력(Division*/Plan-date*) — AS-IS DataUtil.checkRequired(design 02 §4). 등가 TO-BE 코드.
  //   MSG00013(EN)='Please enter the required fields.'(ora.py 2026-09-26 역조회). 이전 MSG00002 는
  //   'Saved successfully.'(저장성공)라 필수조건 미입력 문구로 오배선이었다(iter-1 gap-audit G2 교정).
  REQUIRE_CONDITION: 'MSG00013',
  // 권한 Division 0건(design 01 §2 #1 SetDivisionAuthCheck). MSG00097(EN)='Please select Division.'(실측).
  NO_DIVISION_AUTH: 'MSG00097',
} as const;

// i18n 라벨 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 실측 LBL ID(design 02 §4.5). t(LBL.KEY, '_Fallback').
export const LBL = {
  SEARCH: 'LBL00112', // Search (표준 LBL00112)
  DIVISION: 'LBL00001', // Division (표준 LBL00001)
  COMPANY: 'LBL00047', // Company
  MODEL: 'LBL00669', // Model
  PLAN_DATE: 'LBL00039', // Plan Date
  PERIOD: 'LBL00013', // Period
  BUCKET: 'LBL00710', // Bucket
  // Bucket 드롭다운 옵션 라벨 — SCM_ADM_MSG_M 실측 전용 코드(ora.py 2026-09-26).
  //   iter-1 은 LBL00713(='Select at least one measure.')/LBL00711(='Column')/LBL00712(미등록)로 오배선이었다
  //   → Daily/Weekly/Monthly 정확 코드로 교정(iter-1 gap-audit G3).
  BUCKET_DAILY: 'LBL00682', // Daily
  BUCKET_WEEKLY: 'LBL00683', // Weekly
  BUCKET_MONTHLY: 'LBL00684', // Monthly
} as const;
