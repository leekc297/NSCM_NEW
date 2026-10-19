export const MENU_ID = 'DMF0021' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0021_SalesPlan.cs (Demand > Demand Plan > Sales Plan / 판매계획 — GSCM.DM.Forms.UIL 5,599줄 정본):
//   - 메인 그리드 : PIVOT wide format (정적 66컬럼 admin 메타 + 기간 동적 M_/W_/D_ 3단 헤더)
//   - 분석서      : Doc/_analysis/domain_DM/screens/DMF0021_SalesPlan/ (validation 141 / expressions 120)
//               + Doc/화면설계서/DMF0021_SalesPlan_UI분석서_v1.0.xlsx (11시트) + 상세동작_개발용.md
//   - Division 3종(40 소형 / 81* 자동차 / 82 ESS) 단일 화면 — 81 계열 판정 = startsWith('81') 의무.
export enum SHEETS {
  MAIN = 'Sales Plan', // 메인 그리드 — 공백 포함 quoted key (룰 #91 sheet-name-asis-preserve, DMF0003 'Mkt Fcst' 선례)
  SPREAD_TITLE = 'spreadTitle', // 동적 3단 헤더 메타 (P_DMF0021_GET_SPREAD_TITLE)
  MEASURE_INFO = 'measureInfo', // Insert 행 Measure 콤보 (P_DMF0021_GET_SALES_PLAN_MEASUREINFO)
  DAY_RANGE = 'dayRange', // 기본 조회구간 — PR_GET_DAY_RANGE 공유 (AS-IS GetDayRange p_month=6, o_rc2)
  TITLE_SET = 'titleSet', // Column/Measure Setting 영구 저장 (SCM0002_SET_TITLESET_POPUP 공유)
}

// 컬럼 개인화(SCM_MST_TITLESET_USER) 구분값 — USER_INQUIRY_COLUMN_TYPE_CODE.
//   필수: 팝업 조회(ColumnLayoutModal) · 저장(saveTitleSet) · 진입 복원(fetchUserColumnLayout) 이
//     셋 다 같은 값을 써야 한다. 하나라도 다르면 저장은 성공하는데 재진입 조회가 그 행을 못 찾아
//     개인화가 사라진다.
//   2026-07-29: 팝업이 SHEETS.MAIN('Sales Plan')으로 조회하고 저장은 'C' 로 하던 불일치를 교정
//     (실측 값 = 'C'(컬럼)/'M'(measure). forecast-price 2026-07-27 / sales-monitoring 2026-07-04 동일 사고).
export const TITLESET_COLUMN_TYPE = 'C';
export const TITLESET_MEASURE_TYPE = 'M';

// Bucket Type — AS-IS cboBucketType (DMF0003_GET_BUCKET_TYPE_CODE). 기본값 = Monthly (DefineProperty L543).
export enum BUCKET_TYPE {
  DAILY = 'D',
  WEEKLY = 'W',
  MONTHLY = 'M',
}

// SP 전송용 full-word 변환 (P_BUCKET — AS-IS cboBucketType.ControlValues 1:1, DMF0014 P_BUCKET_TYPE 동일)
export const BUCKET_WORD: Record<BUCKET_TYPE, string> = {
  [BUCKET_TYPE.DAILY]: 'DAILY',
  [BUCKET_TYPE.WEEKLY]: 'WEEKLY',
  [BUCKET_TYPE.MONTHLY]: 'MONTHLY',
};

// Division 분기 (UI분석서 v1.0 시트 9 실측): 40=Mobility / 81 계열(81/81_UC/81_HM/81_ST/81_HD/81_HG)=Automotive / 82=ESS.
//   ⚠ 81 계열 판정은 divisionKindOf(sales-plan.division.ts) 의 startsWith('81') — '===' 비교 금지.
export const DIVISION = {
  MOBILITY: '40',
  AUTOMOTIVE: '81',
  ESS: '82',
} as const;

// 편집 가능 Measure 3종 (AS-IS EditButton L952~1094 — 행 SALES_PLAN_ADJUST_YN='N_Y' + 아래 measure 만 Unlock)
//   SalesAmt_LOC = EDIT_AUTH_SALESAMT_LOC 권한 / RTF_SYS_RP = EDIT_AUTH_RTF_SYS_RP 권한(+당월 잠금) /
//   Catch_Up = 40 전용·M+3 이후 (권한 무관).
export const EDIT_MEASURE = {
  SALES_AMT_LOC: 'SalesAmt_LOC',
  CATCH_UP: 'Catch_Up',
  RTF_SYS_RP: 'RTF_SYS_RP',
} as const;

// 신규 행 기본값 (AS-IS InsertRow L2925~2945 — Measure=SalesAmt_LOC + FcstType=ETC 고정)
export const INSERT_DEFAULT_MEASURE = EDIT_MEASURE.SALES_AMT_LOC;
export const INSERT_DEFAULT_FCST_TYPE = 'ETC' as const;

// 신규 행 초기 필드 (AS-IS InsertRow — DIVISION_ID 는 조회조건으로 세팅, 나머지 공란 + 기본값 2종)
export const INSERT_ROW_DEFAULTS = {
  DEPT_ID: '',
  END_CUSTOMER: '',
  END_CUSTOMER40: '',
  SCM_SITE_ID: '',
  PROJECT_CODE: '',
  ITEM_ID: '',
  TEXT: '',
  TEXT4082: '',
  NICK_NAME: '',
  INCOTERMS: '',
  FCST_TYPE: INSERT_DEFAULT_FCST_TYPE,
  DOM_EXP: '',
  CELL_PROD_SITE_ID: '',
  FROM_SITE_ID: '',
  CURRENCY: '',
  PLANT_SITE_ID: '',
  MEASURE: INSERT_DEFAULT_MEASURE,
} as const;

// ⭐ AS-IS Validation MSG ID 매핑 — 사내 SCM_ADM_MSG_M 실측 대사 완료 (2026-07-14, 계약 확정 — 이 용법 그대로).
//   룰: MSG ID 는 실문구 대사 후 지정(fallback 신뢰 금지). 각 항목에 사내 KO 실측 문구 주석.
export const MSG = {
  // 재진입 가드 — "이전 작업이 아직 실행 중입니다." (AS-IS blnWork L1460/1933)
  WORK_IN_PROGRESS: 'MSG00137',
  // Division 미선택 — "Division 을 선택하세요." (FindData L1513)
  REQUIRE_DIVISION: 'MSG00097',
  // 기간 역전 — "조회 기간이 잘못되었습니다 (시작일 > 종료일)." (FindData L1474)
  PERIOD_INVERTED: 'MSG00108',
  // 기간 3년 초과 — "조회 기간은 3년 이내로 입력해주세요." (FindData L1481 — Value2 자동 보정 후 차단)
  PERIOD_MAX_3YEAR: 'MSG00164',
  // 필수값 — "{0} 값은 필수 입력 항목입니다." (AS-IS MSG00002 용법 → 사내 MSG00429 재매핑. SaveData L2239 필수 13종)
  REQUIRED_FIELD: 'MSG00429',
  // 필수 컬럼 — "필수 입력 컬럼이 없습니다." (EditButton L726/730 · SaveData L2024)
  REQUIRED_COLUMN: 'MSG00113',
  // Bucket 변경 차단 — "Insert 된 행이 있어 Bucket 을 변경할 수 없습니다." (cboBucketType_Click L5475)
  BUCKET_CHANGE_BLOCK: 'MSG00227',
  // Catch_Up 음수 — "{0} 이상의 값만 입력 가능합니다." (SaveData L2587 — 40+Catch_Up+음수, {0}=0)
  CATCHUP_MIN_ZERO: 'MSG00085',
  // 라인 변경 없음 — "라인 [{0}] 에 변경된 값이 없습니다." (SaveData L2666 — iDateCount==0)
  LINE_NO_CHANGE: 'MSG00146',
  // Daily 편집 불가 — (EditButton L1103. Weekly/Monthly 만 편집 — MSG_M 본문 등록 대상)
  DAILY_EDIT_BLOCK: 'MSG00361',
  // 저장 성공 — "성공적으로 저장되었습니다." (AS-IS MSG00004 {0}건 저장 용법 → 사내 MSG00002 재매핑)
  SAVED: 'MSG00002',
  // 변경 0건 — "수정한 내용이 없습니다." (저장 대상 없음)
  NO_CHANGES: 'MSG00004',
  // 저장 오류 공통 fallback — "저장 중 오류가 발생했습니다." (SP 원문 메시지 부재 시)
  SAVE_ERROR: 'MSG00618',
} as const;

// ============================================================================
// Grid 셀 콤보 좁힘 — 코드가 아니라 admin 컬럼 메타(UI Category Setup)가 단일 원천이다.
//   종전에는 이 자리에 GRID_CASCADE_FILTERS / GRID_EDIT_COMBO 표를 두고 SalesPlanGrid 가
//   편집 진입마다 col.dataMap 을 갈아끼웠다. dataMap 은 셀이 아니라 컬럼 속성이라 그 스왑이
//   메타(PARAM2/PARAM9/PARAM10)로 만든 맵을 통째로 덮었고, Sales Site 가 End Customer 변경을
//   반영하지 못했다 (2026-09-01). 그래서 표를 지우고 좁힘을 전부 메타로 넘겼다.
//
//   AS-IS spdMain_ComboSelChange 행 내 cascade (L4500~5082) 를 메타로 옮긴 대응표 —
//   컬럼별로 아래대로 등록한다. PARAM2 왼쪽은 행 컬럼, 오른쪽은 방식에 따라 뜻이 갈린다.
//     PARAM10 미지정 : 콤보 전량을 받아 행 값으로 필터 — 오른쪽 = 콤보 결과 컬럼명
//     PARAM10='D'    : 행 값을 콤보 SQL 파라미터로 실어 조합마다 재조회 — 오른쪽 = 바인드명
//
//   END_CUSTOMER      PARAM2 `DIVISION_ID:DIVISION_ID,DEPT_ID:DEPT_ID`
//   END_CUSTOMER40    PARAM2 `DIVISION_ID:DIVISION_ID,DEPT_ID:DEPT_ID`
//                       (EndCustomerByDivision40 도 DEPT_ID 를 반환한다 — dmf0021/sql/05_DMF0021_combo.sql)
//   SCM_SITE_ID       PARAM2 `DIVISION_ID:divisionId,END_CUSTOMER:endCustomer,END_CUSTOMER40:endCustomer`
//                       + PARAM10='D' (SiteByEndCustomer 는 좁힘 기준을 결과로 안 내려줘 재조회가 유일한 수단)
//                       END_CUSTOMER 두 컬럼을 같은 바인드에 거는 것은 40 이 값을 END_CUSTOMER40 에
//                       싣기 때문이다 — 공통이 선언 순서대로 보다 처음 채워진 값을 쓴다
//                       (foundation rowParamValues).
//   CELL_PROD_SITE_ID PARAM2 `DIVISION_ID:divisionId,ITEM_ID:itemId` + PARAM10='D'
//                       (AS-IS L4769 Data.Common(CELL_PROD_SITE_ID, division, itemId))
//   ITEM_ID           메타 콤보 없음(FPText) — 신규행 전용이라 SalesPlanGrid 가 CMBO
//                       `SalesPlanItemId` 로 직접 건다 (AS-IS L3341~3353 lookup).
//                       조회 행이 텍스트여야 해서 컬럼 단위 메타로 표현이 안 된다.
//                       상세 = SalesPlanGrid insertOnlyDataMaps 주석.
//   CURRENCY          cellCboDataTp `CURRENCY_LIST` (2026-09-04 admin 메타 FPComboBox 전환 —
//                       파생/캐스케이드 없어 공용 경로로 이관, 구 SalesPlanGrid 하드코딩 제거)
//   DOM_EXP           cellCboDataTp `CustomsHandbook` (AS-IS L4916)
//   INCOTERMS         cellCboDataTp `AsIncotermsEdit` (AS-IS L4934)
//
//   DEPT_ID(Team) 은 전 Division 신규행에서 콤보 편집 컬럼이다 (사용자 요구 2026-09-08 —
//   Catch_Up 시만 잠금, insertStaticEditable DEPT_ID 참조). 콤보 후보·표시는 이 컬럼의
//   admin 메타(cellCboDataTp = TeamByDivision)가 단일 원천이고 공용 DataGrid 가 만든다.
//   화면이 상위 선택에서 파생하거나 신규행 전용으로 별도 세팅하지 않는다.
//
//   화면 코드로 되돌리지 말 것. 행 상태로 후보를 더 좁혀야 하는데 메타로 표현이 안 되는 경우
//   (MEASURE 신규행 후보 / FCST_TYPE Catch_Up ETC 제외)는 dataMap 을 교체하지 말고 기존 맵의
//   getDisplayValues 만 덮는다 — SalesPlanGrid installMeasureCandidateFilter 참조.
// ============================================================================

// Project 셀 모달(ProjectByDivisionModal)이 한 번에 채우는 컬럼 묶음.
//   필수: 코드만 지우고 파생 표시 컬럼을 남기면 Project 는 빈칸인데 Status/Biz Type/Owner 는
//   이전 프로젝트 값이 남아 행이 어긋난다 — 항상 이 묶음 단위로 비운다.
const PROJECT_CLEAR_FIELDS = [
  'PROJECT_CODE',
  'PROJECT_NAME',
  'PROJECT_STATUS',
  'BIZ_TYPE_NAME',
  'PROJECT_OWNER',
] as const;

// Model 셀(ITEM 모달 / 'SalesPlanItemId' 콤보)이 채우는 컬럼 묶음 — 위와 같은 이유로 묶음 단위.
export const ITEM_CLEAR_FIELDS = [
  'ITEM_ID',
  'ITEM_NAME',
  'ITEM_CLASS_NAME',
  'ITEM_TYPE',
  'NICK_NAME',
] as const;

// Model 과 함께 입력되는 자유 텍스트 슬롯 — 81=TEXT / 40·82=TEXT4082 (sales-plan.division 참조).
const TEXT_CLEAR_FIELDS = ['TEXT', 'TEXT4082'] as const;

// 상위 콤보 값 변경 시 하위 셀 clear 체인 (AS-IS ComboSelChange 하위 키 셀 clear 1:1 —
//   END_CUSTOMER L4646 / END_CUSTOMER40 L4682 / SCM_SITE_ID L4710. DEPT_ID 분기는 전량 주석 = no-op).
//   2026-08-23 (사용자 요구): End Customer 변경 = Sales Site / Project / Model 전부 초기화.
//   구: END_CUSTOMER 계열에 PROJECT_CODE 가 빠져 있어 Sales Site 는 비는데 그 아래 Project 는
//   남아, 상위 없는 하위 값이 그대로 저장되는 상태가 됐다.
//   Team(DEPT_ID/TEAM_NAME)은 이 체인에서 뺀다 (2026-09-08) — Team 은 상위 파생값이 아니라
//   메타 콤보로 직접 편집하는 독립 컬럼이라 상위 변경이 사용자 입력을 지우면 안 된다.
export const GRID_CASCADE_CLEAR: Record<string, readonly string[]> = {
  END_CUSTOMER: ['SCM_SITE_ID', ...PROJECT_CLEAR_FIELDS, ...ITEM_CLEAR_FIELDS, ...TEXT_CLEAR_FIELDS],
  END_CUSTOMER40: [
    'SCM_SITE_ID',
    ...PROJECT_CLEAR_FIELDS,
    ...ITEM_CLEAR_FIELDS,
    ...TEXT_CLEAR_FIELDS,
  ],
  SCM_SITE_ID: [...PROJECT_CLEAR_FIELDS, ...ITEM_CLEAR_FIELDS, ...TEXT_CLEAR_FIELDS],
};

// Team(DEPT_ID) 변경 시 하위 clear — 40 을 제외한 division 한정 (사용자 요구 2026-09-08).
//   40 이 아닌 division 은 End Customer 가 Team(부서) 종속(EndCustomerByDivisionDept)이라,
//   Team 이 바뀌면 그 아래 End Customer / Sales Site / Project(그리고 종속 Model/Text)가
//   모두 어긋난다 — GRID_CASCADE_CLEAR 의 END_CUSTOMER 계열과 같은 하위 묶음을 비운다.
//   division 조건이 붙어 GRID_CASCADE_CLEAR(binding 단일 키)로는 표현되지 않으므로 별도 상수 —
//   SalesPlanGrid cellEditEnded 에서 isDiv40 분기로만 적용한다. 40 은 End Customer 가
//   Team 종속이 아니므로(EndCustomerByDivision40) 대상이 아니다.
export const DEPT_CASCADE_CLEAR_NON40: readonly string[] = [
  'END_CUSTOMER',
  'SCM_SITE_ID',
  ...PROJECT_CLEAR_FIELDS,
  ...ITEM_CLEAR_FIELDS,
  ...TEXT_CLEAR_FIELDS,
];

// Project 셀 모달을 선택 없이 닫았을 때 비우는 컬럼 (사용자 요구 2026-08-23).
//   닫기 = Project 미선택 확정으로 본다(기존 값이 있어도 비움). Model 은 Project 종속이라
//   Project 가 비면 남길 근거가 없어 함께 초기화한다.
//   TEXT/TEXT4082 는 대상이 아니다 — 팝업이 채우는 값이 아니라 사용자가 직접 친 자유 입력이다.
//   Team(DEPT_ID/TEAM_NAME)도 대상이 아니다 (2026-09-08) — Team 은 Project 파생값이 아니라
//   메타 콤보로 직접 편집하는 독립 컬럼이다.
export const PROJECT_POPUP_CANCEL_CLEAR: readonly string[] = [
  ...PROJECT_CLEAR_FIELDS,
  ...ITEM_CLEAR_FIELDS,
];

// Catch_Up 전환 시 콤보 개방 3종 (AS-IS spdMain_ComboSelChange Measure 분기 L4865~4877 —
//   DomExp/Incoterms/FcstType 개방. SalesAmt_LOC 복귀 시 FCST_TYPE='ETC' 고정 + 3종 잠금).
export const CATCH_UP_OPEN_COLS = ['DOM_EXP', 'INCOTERMS', 'FCST_TYPE'] as const;
