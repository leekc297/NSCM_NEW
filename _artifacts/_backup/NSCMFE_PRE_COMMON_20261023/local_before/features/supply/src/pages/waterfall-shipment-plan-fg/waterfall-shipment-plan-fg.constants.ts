export const MENU_ID = 'SCP0016' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL SCP0016_WaterfallShipmentPlanFG — 읽기전용 Waterfall pivot 조회 화면.
//   설계 근거: .atlas/gscm-design/SCP0016/design/00_checklist.md ~ 03_grid-columns.md (v1, DB 실측).
//   - 메인 GET    : PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL (동적 pivot D_/W_/M_)
//   - 기간칼럼 헤더 : 공용 PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (start/end 2-IN, 자매 SCP0018 배선 미러)
//   - 저장 없음(읽기전용, EditButton=MSG00109 후 return · SaveButton NO-OP · Insert/Delete 미노출)
//   버튼-API 배선(SCM_ADM_MNU_BTN_MPG_M): main/SEARCH · main/MEASURE_SELECT · spreadTitle/SEARCH
//     (design 05_register.sql, 자매 SCP0018 실등록행 미러 — ora.py 적용).
//   PKG_SCP0016 미배포(all_objects 0건) → 런타임 조회는 convert-sp 배포 후. 캘린더 SP(COM0000)는 VALID.
export enum SHEETS {
  MAIN = 'main', // spdMain Waterfall 시트 — 메인 pivot 그리드 (28 고정 + D_/W_/M_ 동적)
  TITLE = 'spreadTitle', // 기간칼럼 헤더(캘린더 3span) — 자매 SCP0018 SHT_NM='spreadTitle' 미러
}

// NSCM 단일 cursor 표준 'o_rc1'.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  TITLE: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// sheetNm 이원화(design 03 §0/§6-1 실측): 칼럼 레이아웃 메타 = 'Waterfall Shipment Plan'(28행),
//   measure/데이터 SP = 'Shipment Plan FG'(8행). fetch 키를 분리한다.
export const ADMIN_COLUMN_SHEET_NAME = 'Waterfall Shipment Plan';
export const ADMIN_MEASURE_SHEET_NAME = 'Shipment Plan FG';
// 메인 조회 SP 파라미터 p_sheet_name — measure/데이터 시트명(design 02 §5, 03 §4.2).
export const SP_SHEET_NAME = 'Shipment Plan FG';

// Bucket — cboBucketType(BucketISO_SCP: DAILY/WEEKLY/MONTHLY/WEEKLY_ISO). 기본 DAILY (design 02 §4.3).
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
  WEEKLY_ISO = 'WEEKLY_ISO',
}

// division 앞2자 'EE' → 전극 본부. OperationGroup 콤보 SQL_ID 스왑 + Electrode enable (design 02 §2/§3).
export const DIVISION_EE_PREFIX = 'EE';
// isEE(division) = division.slice(0,2)==='EE' (design 02 §2 C2 / convert-core §2.6 의미 패리티).
export const isEeDivision = (division: string): boolean =>
  (division ?? '').slice(0, 2) === DIVISION_EE_PREFIX;

// 조회조건 콤보 ID — DB 실측 등록 확인(SCM_ADM_CMBO_SQL_M USE_YN='Y', ora.py, design 02 §2/§5).
//   parameterized 재조회 콤보(부모값 파라미터로 하위 재조회) — react-query 키에 부모값 포함.
export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP', // 권한 division(EE 포함 — 이름 함정, EE 미제외). @mnuId
  OP_GROUP_EE: 'OperationGroupEE_SCP', // EE (SEGMENT1 IN ('A','E'))
  OP_GROUP: 'OperationGroup_SCP', // 비EE (SEGMENT1 IN ('P','A'))
  VERSION: 'WaterfallVer_FG2_SCP', // @divisionId=division. CODE=SP_W_YYYYMMDD, 최신10
  BUCKET: 'BucketISO_SCP', // DAILY/WEEKLY/MONTHLY/WEEKLY_ISO
} as const;
// clbElecType — lookup ELECTRODE_TYPE (ANODE/CATHODE/ONESIDE — design 02 §2 C3 실측). enable=isEE.
export const ELECTRODE_LOOKUP = 'ELECTRODE_TYPE';

// Validation MSG — TO-BE SCM_ADM_MSG_M 문구 역조회(Hook #114). AS-IS 번호 그대로 재사용 금지.
//   자매 production-plan-waterfall(SCP0017)/inventory-trend 선례 매핑을 그대로 승계.
export const MSG = {
  // 권한 division 0건 안내 (design 01 D9, SetDivisionAuthCheck). AS-IS MSG00097 은 다른 문구라 재사용 금지 —
  //   의도('권한 있는 Division 없음') 1:1 일치 TO-BE 코드 MSG00667(EN 'No authority assigned.', ora.py 실측).
  REQUIRE_DIVISION: 'MSG00667',
  REQUIRED_FIELD: 'MSG00429', // {0} value is required. (조회 필수값)
  PERIOD_RANGE: 'MSG00108', // Invalid period (start > end). (ora.py 실측 EN)
  // 최대 조회기간 초과 (AS-IS DateUtil.Check_PeriodDate, param 364+7=371). 문구 역조회 TO-BE 코드
  //   MSG01187(EN 'Maximum Period is From Date + {0}.', USE_YN='Y' ora.py 실측). {0}='371 days'.
  PERIOD_MAX: 'MSG01187',
} as const;

// 최대 조회기간(일) — AS-IS Check_PeriodDate: to >= from + 1년 + 7일 이면 차단, 안내 param = 364+7.
export const MAX_PERIOD_DAYS = 371;

// i18n 라벨 코드 — SCM_ADM_MSG_M LBL 실측(문구 역조회, AS-IS 번호 그대로 재사용 금지 #114).
//   DIVISION 은 Division (표준 LBL00001).
export const LBL = {
  DIVISION: 'LBL00001', // Division (표준 LBL00001)
  OPERATION_GROUP: 'LBL00027', // Operation group
  ELECTRODE: 'LBL00038', // Electrode
  VERSION: 'LBL00606', // Version
  BUCKET: 'LBL00710', // Bucket
  PERIOD: 'LBL00013', // Period
  MODEL: 'LBL00669', // Model
  PROJECT: 'LBL00617', // Project
  SUM: 'LBL00687', // Sum
  SEARCH: 'LBL00112', // Search (searchButtonLabel)
  COLUMN_SET: 'LBL00605', // Column Setting (표시 'Column Set' — 확인필요)
  MEASURE: 'LBL00310', // Measure
  COLUMN: 'LBL00711', // Column (ColumnLayoutModal title)
  INVISIBLE: 'LBL00764', // Invisible
  VISIBLE: 'LBL00765', // Visible
} as const;

// Version 코드 형식 — 'SP_W_YYYYMMDD'(13자, design 02 §2 C4). 뒤 8자 = 계획시작일(GetDayRange fromDate).
export const VERSION_CODE_LENGTH = 13;

// 기간(버킷) 컬럼 판정 — D_yyyymmdd / W_yyyymm+ISO주차 / M_yyyymm (design 03 §2).
export const PERIOD_COLUMN_REGEX = /^(D_|W_|M_)\d/;

// VERSION_NO / MEASURE 는 메타 VISIBLE_FLAG='N' 이어도 waterfall 핵심 행 축(무조건 SELECT — design 03 §4.2).
export const FORCED_AXIS = ['version_no', 'measure'] as const;

// 기간 컬럼 표시 rank (design 03 §2.1 SORT / hook #103) — M(월) > W(주) > D(일).
export const DYN_RANK: Record<string, number> = { M: 0, W: 1, D: 2 };

// 헤더 주말 글자색 (AS-IS ForeColor cs:504 실측, design 03 §3 R9) — 토 파랑 / 일 빨강 / 그 외 기본.
export const HEADER_COLORS = {
  SATURDAY: '#1565c0',
  SUNDAY: '#d32f2f',
} as const;

// 기간 컬럼 소수 자릿수 (TITLE SP DATA_SCALE_NUMBER, 없으면 0 — 기간칼럼=정수 qty, design 03 §4.2).
export const scaleOf = (raw: string | number | null | undefined, fallback = 0): number => {
  const s = String(raw ?? '').trim();
  if (!s) return fallback;
  const n = Number(s);
  return Number.isFinite(n) && n > 0 ? Math.trunc(n) : fallback;
};

// 셀 콤보 파라미터 quoting — BE makeComboQuery 가 @토큰 을 raw 치환하므로 따옴표 없이 넘기면 ORA-00904/01722.
//   셀 콤보 0건(전 FPTextBox, design 03 §0)이나 공용 규약대로 전달. 값이 비면 관대형 게이트 'ALL'.
export const quoteComboParam = (value: string | undefined): string =>
  `'${(value && value.trim() !== '' ? value : 'ALL').replace(/'/g, '\'\'')}'`;
