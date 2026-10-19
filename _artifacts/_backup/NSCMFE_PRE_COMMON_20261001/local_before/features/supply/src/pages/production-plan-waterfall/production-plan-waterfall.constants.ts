export const MENU_ID = 'SCP0017' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL SCP0017_WaterfallProductionPlan — 읽기전용 Waterfall pivot 조회 화면.
//   설계 근거: .atlas/gscm-design/SCP0017/design/00_checklist.md ~ 03_grid-columns.md (v1, DB 실측).
//   - 메인 GET   : PKG_SCP0017.P_SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL (15 IN, 동적 pivot D_/W_/M_)
//   - 기간칼럼 헤더: GetSpdTitle 상당 = SCP0009_GET_SHEET_CALENDAR_3SPAN(+_ISO) — bucket 으로 ISO/비ISO 분기
//   - 저장 없음(읽기전용, InsertButton/DeleteButton/SaveButton 전량 NO-OP · EditButton 메시지 후 return)
//   버튼-API 배선(SCM_ADM_MNU_BTN_MPG_M): main/SEARCH · title/SEARCH 2행 등록(design 05_register.sql, ora.py 적용).
//   PKG_SCP0017 미배포(all_objects 0건) → 런타임 조회는 convert-sp 배포 후.
export enum SHEETS {
  MAIN = 'main', // spdMain Model 시트 — 메인 pivot 그리드 (25 고정 + D_/W_/M_ 동적)
  TITLE = 'title', // 기간칼럼 헤더(캘린더 3span) — COLUMN_NAME/라벨/DAY_CODE/SORT
}

// NSCM 단일 cursor 표준 'o_rc1'.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  TITLE: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 상수(design 03 §1).
//   실측: PROGRAM_ID='SCP0017' SHEET_NAME='MODEL' 25행 등록됨(ora.py) → admin fetch authoritative.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'MODEL',
};

// Bucket — cboBucketType(BucketISO_SCP: DAILY/WEEKLY/MONTHLY/WEEKLY_ISO). 기본 DAILY (design 02 §4.3).
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
  WEEKLY_ISO = 'WEEKLY_ISO',
}

// division 앞2자 'EE' → 전극 본부. OperationGroup/PlantSite/Line 콤보 SQL_ID 자매 스왑 + Electrode enable.
export const DIVISION_EE_PREFIX = 'EE';
// isEE(division) = division.slice(0,2)==='EE' (design 02 §4.5 / convert-core §2.6 의미 패리티).
export const isEeDivision = (division: string): boolean =>
  (division ?? '').slice(0, 2) === DIVISION_EE_PREFIX;

// 조회조건 콤보 ID — DB 실측 등록 확인(SCM_ADM_CMBO_SQL_M USE_YN='Y', ora.py, design 02 §2/§5).
//   parameterized 재조회 콤보(부모값을 파라미터로 실어 하위 콤보 재조회) — react-query 키에 부모값 포함.
export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP', // 권한 division(EE 포함 — 이름 함정, EE 미제외). @mnuId
  OP_GROUP_EE: 'OperationGroupEE_SCP', // EE (SEGMENT1 IN ('A','E'))
  OP_GROUP: 'OperationGroup_SCP', // 비EE (SEGMENT1 IN ('P','A'))
  PLANT_SITE_EE: 'PlantSiteProdPlan_SCP', // EE — @attribute2=division, @segment2=opGroup
  PLANT_SITE: 'PlantByDivisionOperation', // 비EE — @divisionId=division, @operationGroup=opGroup
  LINE_EE: 'LineProdPlanLine_SCP', // EE — @attribute2=division, @operationGroup=opGroup
  LINE: 'LineByOperationAddOSP_SCP', // 비EE — @divisionId=division
  VERSION: 'WaterfallVer2_SCP', // @divisionId=division. CODE=PP_W_YYYYMMDD
  BUCKET: 'BucketISO_SCP', // DAILY/WEEKLY/MONTHLY/WEEKLY_ISO
} as const;
// cboElectrode — lookup ELECTRODE_TYPE (ANODE/CATHODE/ONESIDE — design 02 §2.6 실측). enable=isEE.
export const ELECTRODE_LOOKUP = 'ELECTRODE_TYPE';

// Line 콤보 sentinel — 결과에 코드=이름='-' 행 존재. 조회 파라미터에서 '' 로 치환(AS-IS cs:1060~1063, design 02 §2 #4).
export const LINE_SENTINEL = '-';

// Validation MSG — TO-BE SCM_ADM_MSG_M 문구 역조회(Hook #114). AS-IS 번호 그대로 재사용 금지(convert-core §4.1).
//   design 01 §5 Q2 확인필요 — 문구 기준 매핑. 미확정분은 영문 defaultValue fallback 병기.
export const MSG = {
  // 권한 division 0건 안내 (design 01 L1, SetDivisionAuthCheck cs:211~212). AS-IS 는 MSG00097 이나 TO-BE
  //   MSG00097 은 'Please select Division.'(다른 문구)라 AS-IS 번호 재사용 금지(Hook #114). 의도('권한 있는
  //   Division 없음')가 1:1 일치하는 TO-BE 코드 MSG00667(EN 'No authority assigned.', ora.py 실측)을 쓴다.
  //   자매 inventory-trend 선례 동일.
  REQUIRE_DIVISION: 'MSG00667',
  // Gap 체크 시 version 2건 필요 (design 02 §4e). AS-IS MSG00376 은 TO-BE 미등록(ora.py 0행)이고 문구
  //   역조회(ora.py)로 1:1 일치 코드 없음 — MSG00255('You can select up to 2 versions.')는 상한 제약이라
  //   'Gap 시 정확히 2건' 의도와 불일치. EN defaultValue fallback 유지, 정식 코드 신규 등록은 i18n 팀 소관
  //   (SCM_ADM_MSG_M INSERT 금지, memory deploy-sql-no-msg-m-insert). 04 리포트 잔여(I1).
  GAP_NEED_TWO_VERSION: 'MSG00376',
  REQUIRED_FIELD: 'MSG00429', // {0} value is required. (조회 필수값)
  PERIOD_RANGE: 'MSG00108', // Invalid period (start > end). (ora.py 실측 EN 확인)
  // 최대 조회기간 초과 (AS-IS DateUtil.Check_PeriodDate cs:142~144, param 364+7=371). AS-IS MSG00172 은
  //   TO-BE 미등록(ora.py 실측 0행)이라 번호 재사용 금지(Hook #114) — 문구 역조회로 등록된 TO-BE 코드
  //   MSG01187(EN 'Maximum Period is From Date + {0}.', USE_YN='Y' ora.py 실측)에 매핑. {0}='371 days'.
  PERIOD_MAX: 'MSG01187',
} as const;

// 최대 조회기간(일) — AS-IS Check_PeriodDate: to >= from + 1년 + 7일 이면 차단, 안내 param = 364+7.
export const MAX_PERIOD_DAYS = 371;

// i18n 라벨 — design 02 §4.5 실측 LBL ID(전건 존재, 신규 0). defaultValue = AS-IS 캡션 문구.
export const LABEL = {
  DIVISION: { id: 'LBL00641', text: 'Division' },
  OPERATION_GROUP: { id: 'LBL00027', text: 'Operation Group' },
  PLANT_SITE: { id: 'LBL00005', text: 'Plant Site' },
  LINE: { id: 'LBL00010', text: 'Line' },
  VERSION: { id: 'LBL00606', text: 'Version' },
  ELECTRODE: { id: 'LBL00038', text: 'Electrode' },
  BUCKET: { id: 'LBL00710', text: 'Bucket' },
  PERIOD: { id: 'LBL00013', text: 'Period' },
  ALL: { id: 'LBL00632', text: 'All' },
  GAP: { id: 'LBL01079', text: 'Gap' },
  MODEL: { id: 'LBL00669', text: 'Model' },
  NICK_NAME: { id: 'LBL00767', text: 'Nick Name' },
} as const;

// EE 분기 조건 가시성 컬럼(design 03 R2) — 비EE division 이면 숨김.
export const EE_ONLY_COLUMNS = ['ORIGIN_DIVISION_ID', 'ELECTRODE_TYPE'] as const;

// Version 코드 형식 — 'PP_W_YYYYMMDD'(13자). Gap 시 2건 콤마 연결 = 27자(design 02 §2 #5/§4e).
export const VERSION_CODE_LENGTH = 13;
export const GAP_VERSION_NO_LENGTH = 27; // 13 + ',' + 13

// 기간(버킷) 컬럼 판정 — D_yyyymmdd / W_yyyymm+ISO주차 / M_yyyymm (design 03 §2).
export const PERIOD_COLUMN_REGEX = /^(D_|W_|M_)\d/;

// VERSION_NO / MEASURE 는 메타 VISIBLE_FLAG='N' 이어도 waterfall 핵심 행 축(무조건 SELECT — design 03 §4.2).
export const FORCED_AXIS = ['VERSION_NO', 'MEASURE'] as const;

// 기간 컬럼 표시 rank (design 03 §2.5 / hook #103) — M(월) > W(주) > D(일).
export const DYN_RANK: Record<string, number> = { M: 0, W: 1, D: 2 };

// 헤더 주말 글자색 (AS-IS ForeColor cs:509~511 실측, design 03 §2.4) — 토 파랑 / 일 빨강.
//   주의: AS-IS SCP0017 에는 당기(당월/당주) Green 강조가 없다(cs 전수 grep — ForeColor 는 SAT/SUN 뿐).
//   iter-2 까지 있던 green 당기강조는 demand-plan-waterfall 이식 잔재(drift)라 제거(G10).
export const HEADER_COLORS = {
  SATURDAY: '#1565c0',
  SUNDAY: '#d32f2f',
} as const;

// 과거실적 음영 배경(design 03 R11) — from < 계획시작일이면 (계획시작-1)까지 D_ 칼럼 배경 회색.
export const PAST_ACTUAL_BG = 'rgb(234,234,234)';

// 기간 컬럼 소수 자릿수 (TITLE SP DATA_SCALE_NUMBER, 없으면 0 — design 03 §1 R13은 행별 formatItem).
export const scaleOf = (raw: string | number | null | undefined, fallback = 0): number => {
  const s = String(raw ?? '').trim();
  if (!s) return fallback;
  const n = Number(s);
  return Number.isFinite(n) && n > 0 ? Math.trunc(n) : fallback;
};

// 행별 NOTATION 포맷 (design 03 §3.1 R13 — SetDecimal siMain:1459/siLine:1291). measure 행마다 SP 가
//   내려주는 표시 포맷 지시(o_rc1.NOTATION)로 균일 컬럼 format 을 덮어쓴다. 비율 measure(FORMATION_YIELD/
//   LINE_TOTAL_LOAD)는 SP 가 POINT/POINT3 로 내려 소수 표기가 살아난다. 계보=demand-plan-waterfall(DMF0035
//   SetRowFormat 1:1) 동일 계약 — 소수 자릿수 실측은 PKG_SCP0017 배포 후 확정(04 리포트 확인필요).
//   INTEGER: 정수·천단위 / POINT: 정수면 정수·소수면 최대 3자리(꼬리 0 제거) / POINT3: 소수 3자리 고정(0은 '0').
//   그 외/'' : null 반환 → 호출측이 컬럼 기본 format 유지.
export const formatByNotation = (value: number, notation: string): string | null => {
  const n = String(notation ?? '')
    .trim()
    .toUpperCase();
  const int0 = (v: number): string => Math.round(v).toLocaleString('en-US');
  if (n === 'INTEGER') return int0(value);
  if (n === 'POINT') {
    if (Number.isInteger(value)) return int0(value);
    return value.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 3 });
  }
  if (n === 'POINT3') {
    if (Math.abs(value) < 0.0005) return '0';
    return value.toLocaleString('en-US', { minimumFractionDigits: 3, maximumFractionDigits: 3 });
  }
  return null;
};

// 셀 콤보 파라미터 quoting — BE makeComboQuery 가 @토큰 을 raw 치환하므로 따옴표 없이 넘기면 ORA-00904/01722.
//   값이 비면 관대형 SQL 전체 게이트 'ALL'. (정본 규약: demand-plan-waterfall quoteComboParam)
export const quoteComboParam = (value: string | undefined): string =>
  `'${(value && value.trim() !== '' ? value : 'ALL').replace(/'/g, '\'\'')}'`;
