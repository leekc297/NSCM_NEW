export const MENU_ID = 'DMF0068' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0068_DemandManager40.cs (Demand > Demand Waterfall > Demand Manager — 정본 Forms.UIL 1,337행 1:1):
//   - Division 40 전용 화면 (사업부 선택 조회조건 없음. 모든 SP 호출에 '40' 고정 — MSG 게이트 3곳).
//   - 한 건 = Measure 2행 1세트 (QTY(Cell) / Sales Amt.(KRW)) — 그룹키 KEYVALUE2(ATTRIBUTE2).
//     행 추가는 항상 2행, 짝 행의 Project·수주기간은 첫 행을 따라가며 잠긴다.
//     삭제는 1행만 골라도 SP 가 같은 그룹 전체를 지운다.
//   - 조회조건 = Version(팝업 주입, 필수) + Period(월 구간, 기본 전년01~익년12 = 36개월).
//     Period 가 그리드 월 컬럼(M1..Mn) 표시 개수와 헤더(yyyy.MM)를 결정한다.
//   - 분석서: Doc/화면분석서/DMF0068_DemandManager_{주요이벤트_상세분석,제약매트릭스_상세}.md
export enum SHEETS {
  MAIN = 'ContributeSalesList', // SHEET_COLUMNS 159행 등록명 (룰 #91 — rename 금지)
  VERSION_POPUP = 'versionPopup', // 버전 팝업 (PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP)
  LOOKUP_PROJECT = 'lookupProject', // Project 셀 콤보 (PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT)
}

// ⭐ Division 40 전용 (AS-IS viewAuth/anyDivision 게이트. TO-BE 는 정확일치로 강화)
export const DIVISION_40 = '40' as const;

// AS-IS 편집 허용 그룹은 참고용 기록 (viewAuth = { "DM ADMIN", "ADMIN" }).
//   TO-BE 는 이 값을 화면에서 비교하지 않는다 — 버튼 권한 + 행 EDIT_YN 으로 판정한다.

// 버전 팝업 유형 콤보 원천 (MDF_TYPE 룩업 — REPORT_SP_W / REPORT_BP_M 2건)
export const VERSION_TYPE_LOOKUP = 'MDF_TYPE' as const;

// 버전 팝업 Div 콤보 원천 — 사내 CMBO 레지스트리 등록명 (DivisionField 와 동일 룩업).
//   화면이 40 전용이라 선택은 잠그고 라벨 표시용으로만 쓴다 (AS-IS '40 Mobility & IT Battery').
export const DIVISION_LOOKUP = 'MyDivision' as const;

// ⭐ 버전 팝업 기본 유형 — 조회 프로시저가 VERSION_TYPE 을 등호로 비교하므로 빈 값이면 0행이 된다.
//   AS-IS 도 콤보 첫 항목이 선택된 상태로 열린다. 사내 실측(Division 40): REPORT_SP_W 176건 / REPORT_BP_M 139건.
export const VERSION_TYPE_DEFAULT = 'REPORT_SP_W' as const;

// 버전 팝업 기본 기간 — AS-IS DMF0068_VersionPopup 과 동일하게 오늘 기준 -3개월 ~ +3개월.
//   월초/월말로 스냅하지 않고 오늘 날짜를 그대로 더하고 뺀다 (AS-IS 표시: 2026-05-27 ~ 2026-11-27).
//   2026-07-30 에는 버전이 뜸한 구간에서 팝업이 비어 보인다는 이유로 과거를 12개월로 넓혔었으나,
//   2026-08-27 사용자 요구로 AS-IS 로 되돌렸다. 기간은 팝업에서 직접 바꿀 수 있다.
export const VERSION_POPUP_MONTHS_BACK = 3 as const;
export const VERSION_POPUP_MONTHS_FWD = 3 as const;

// ⭐ Measure 2행 1세트 — AS-IS dtMeasureS()/dtMeasureB() 는 내용이 동일하므로 단일 정의로 승계.
//   저장 시 첫 행은 항상 'MEA_1', 둘째 행은 'SalesAmt_KRW' (AS-IS InsertRow 고정 대입).
export const MEASURE_PAIR = [
  { code: 'MEA_1', name: 'QTY(Cell)' },
  { code: 'SalesAmt_KRW', name: 'Sales Amt.(KRW)' },
] as const;
export const MEASURE_SET_SIZE = MEASURE_PAIR.length; // 2 (AS-IS multiful=2)

// 편집 가능 정적 컬럼 — 세트 첫 행만 (AS-IS EditButton 잠금 조합의 결과).
//   ⭐ 바인딩은 조회 프로시저가 돌려주는 별칭(대문자)과 동일해야 한다 = SHEET_COLUMNS 등록명과도 동일.
export const EDITABLE_BINDINGS = [
  'PROJECT_NAME',
  'ORDERSTART',
  'ORDEREND',
  'ORDERAPPROVAL',
  'ORDERNOW',
] as const;

// 짝 행(둘째 행)에서 첫 행 값을 따라가며 잠기는 컬럼 (AS-IS Formula 연결 + Locked)
export const PAIR_FOLLOW_BINDINGS = ['PROJECT_NAME', 'ORDERSTART', 'ORDEREND'] as const;

// 신규 세트(CRUD_TYPE='I')에서만 고칠 수 있는 컬럼.
//   Project 는 저장 키(PROJECT_CODE)라 조회된 행에서 바꾸면 같은 행이 다른 건이 되어 버린다.
//   조회행의 Project 를 바꾸려면 삭제 후 새로 추가한다.
export const INSERT_ONLY_BINDINGS = ['PROJECT_NAME'] as const;

// 월 컬럼 상위 헤더 — AS-IS 는 전체 월을 하나의 헤더로 묶는다(연도별로 쪼개지 않는다)
export const MONTH_GROUP_HEADER = '수주 기간 매출 상세' as const;

// 저장 payload 8필드 (AS-IS dtProd 컬럼 정의 1:1)
export const SAVE_FIELDS = [
  'PROJECT_CODE',
  'YYYYMM_FROM',
  'YYYYMM_TO',
  'MEASURE',
  'ORDER_APPROVAL',
  'ORDER_NOW',
  'ATTRIBUTE1',
  'ATTRIBUTE2',
] as const;

// ⭐ MSG — AS-IS 문구를 사내 메시지 원장과 명칭 기준으로 대사한 결과 (재사용 9 / 신규 4).
//   AS-IS 번호를 그대로 쓰면 안 되는 3건(MSG00002/00004/00284)은 같은 뜻의 기존 코드로 대체했다.
export const MSG = {
  REQUIRED_FIELD: 'MSG00614', // {0} 값은 필수 입력입니다. (AS-IS MSG00002)
  SAVED_COUNT: 'MSG00672', // {0}개의 데이터가 저장되었습니다. (AS-IS MSG00004)
  INVALID_DATE: 'MSG00611', // 유효한 날짜 형식이 아닙니다. (AS-IS MSG00049)
  POSITIVE_INT: 'MSG00699', // 0보다 큰 정수를 입력하십시오. (신규)
  NO_PERMISSION: 'MSG00096', // 권한이 없습니다.
  PERIOD_OVERLAP: 'MSG00700', // 중첩된 기간이 있습니다. (신규)
  PERIOD_ORDER: 'MSG00108', // 조회 기간이 잘못되었습니다 (시작일 > 종료일).
  REQUIRED_COLUMN: 'MSG00113', // 필수 입력 컬럼이 없습니다. (신규 행 짝 미충족)
  DUPLICATED: 'MSG00260', // 중복된 조합이 존재합니다.
  VERSION_ONE_ONLY: 'MSG00701', // 버전은 1개만 선택해 주세요. (신규)
  VERSION_REQUIRED: 'MSG00283', // 버전을 선택하세요.
  EXEC_ERROR: 'MSG00618', // 저장 중 오류가 발생했습니다. (AS-IS MSG00284)
  DIVISION_40_ONLY: 'MSG00702', // 40번 사업부 전용 화면입니다. (신규)
} as const;

// 신규 행 기본값 (AS-IS InsertRow — 수량은 빈값에서 시작해 필수 검증을 태운다)
export const INSERT_ROW_DEFAULTS = {
  PROJECT_NAME: '',
  ORDERSTART: '',
  ORDEREND: '',
  ORDERAPPROVAL: '',
  ORDERNOW: '',
  SRESULT: 0,
  SPLAN: 0,
  STOCK: 0,
  STOCK2: 0,
  EDIT_YN: 'Y',
} as const;

/**
 * unknown 값을 안전하게 문자열로 — 객체가 섞여 들어와도 '[object Object]' 를 만들지 않는다.
 *
 * 그리드 셀 값과 SP 결과 커서는 타입이 unknown 이라 String() 을 그대로 쓰면
 * @typescript-eslint/no-base-to-string 에 걸리고, 실제로도 객체가 오면 쓰레기 문자열이 된다.
 * sales-plan / business-plan / mkt-fcst / etc-sales-reports 의 페이지-로컬 toCellStr 과 동일 형태.
 */
export const toCellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
