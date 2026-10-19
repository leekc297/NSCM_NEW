export const MENU_ID = 'DMF0014' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0014_CustFcstUpload.cs (Demand > Demand Plan > Customer FCST Upload):
//   - 메인 그리드 : 식별 13 컬럼(항상 잠금) + SPREAD_TITLE 동적 D_ 기간 컬럼(EDIT_FLAG='Y' 행만 편집)
//   - 분석서      : Doc/_analysis/domain_DM/screens/DMF0014_CustFcstUpload/ (validation 26 / expressions 6)
//   - 데이터 유입 : Excel 업로드(공통 FileController excel-upload) 가 주 경로 — 직접 INSERT 는
//     AS-IS InsertRow 가 MSG00380 안내 후 차단 (원 로직 주석 처리, .cs L786~818 실측)
export enum SHEETS {
  // 메인 그리드 — AS-IS SpdSheet.shtMain='FCST Upload' + 사내 SCM_ADM_EXCEL_COLUMNS.SHEET_NAME
  //   기존 등록명 그대로 (룰 #91). excel-upload 는 SHEET_NAME=#{shtNm} 조회이므로 이 값이 체인 키.
  MAIN = 'FCST Upload',
  SPREAD_TITLE = 'spreadTitle', // 동적 기간 헤더 — PKG_DMF0014.P_DMF0014_GET_SPREAD_TITLE
  DAY_RANGE = 'dayRange', // 기본 조회구간 — PR_GET_DAY_RANGE (AS-IS GetDayRange p_month=6, o_rc2)
}

export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  SPREAD_TITLE: 'o_rc1',
  DAY_RANGE: 'o_rc1', // AS-IS Tables[0][0][0] — PR_GET_DAY_RANGE 월 경계 범위 (DMF0048 선례 o_rc2)
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// Bucket — AS-IS BucketType struct 실측 (DAILY/WEEKLY/MONTHLY full-word, 기본 WEEKLY — .cs L308)
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// ⭐ AS-IS Validation MSG — 사내 SCM_ADM_MSG_M 실측 대조 완료 (2026-07-04, 신규 채번 0):
//   AS-IS MSG00002('{0} 값은 필수 입력')는 사내에서 저장성공으로 재정의됨 → 의미 1:1 = MSG00429.
export const MSG = {
  // "권한을 가진 Division이 없습니다." → 사내 "Please select Division." (.cs L568)
  REQUIRE_DIVISION: 'MSG00097',
  // "시작일자가 종료일자보다 늦을 수 없습니다." (.cs L579 + drpPeriod_ValueChanged L980)
  PERIOD_INVERTED: 'MSG00108',
  // 기간 상한 (.cs L583: AddYears(2) — 조건 2년 / AS-IS·사내 문구 '3년' 불일치는 AS-IS 자체 상태 1:1 보존)
  PERIOD_MAX: 'MSG00164',
  // "{0} value is required." — spdMain_Changed 필수 11건 (AS-IS MSG00002 의미 1:1)
  REQUIRED_VALUE: 'MSG00429',
  // "Customer FCST 수량이 입력된 일자가 없습니다." → 사내 "No data to save." (SaveData iCount=0)
  NO_SAVE_DATA: 'MSG00152',
  // 저장 확인 — MSG00001 '저장 하시겠습니까?' (2026-07-07 사용자 요구 — MSG00004='수정한 내용이 없습니다' 오용 수정)
  CONFIRM_SAVE: 'MSG00001',
  // "직접 INSERT 불가한 화면 — 엑셀 업로드 이용" (AS-IS InsertRow L790 1:1, 사내 기등록)
  INSERT_BLOCKED: 'MSG00380',
  // Excel 업로드 완료 (기존 키 재사용)
  UPLOAD_DONE: 'MSG00265',
  // [E20260814-EXCELFORM] Excel Form 조회 0건 — "조회된 데이터가 없습니다." (사용자 지정 2026-08-21).
  //   금지: MSG00705('업로드된 Excel 데이터가 없습니다. Excel Upload 후 조회하세요')는 업로드 스테이징
  //   기준 문구라 의미가 반대다 — Excel Form 은 양식을 받으러 들어오는 화면이라 앞뒤가 바뀐다.
  EXCEL_FORM_EMPTY: 'MSG00719',
  // ⭐ 저장 체인 3종 — SalesPlan(DMF0021)/BusinessPlan 표준 1:1 (2026-08-20 정합).
  // 재진입 가드 — "이전 작업이 아직 실행 중입니다." (저장 in-flight 중 재클릭 차단)
  WORK_IN_PROGRESS: 'MSG00137',
  // 저장 성공 — "성공적으로 저장되었습니다." (사내 SCM_ADM_MSG_M 원본 등재분.
  //   공용 useProcMutation 기본 성공 토스트와 동일 키 = 전 화면 문구 통일.
  //   ⚠ 구 MSG00606('데이터가 저장되었습니다')는 이관 스크립트 신규 등록분이라 표준에서 이탈)
  SAVED: 'MSG00002',
  // 저장 오류 공통 fallback — "저장 중 오류가 발생했습니다." (SP 원문 메시지 부재 시)
  SAVE_ERROR: 'MSG00618',
} as const;

// 코드 그대로 표시할 컬럼 — CODE -> NAME dataMap 을 붙이지 않는다 (사용자 요구 2026-08-20).
//   admin UI Category Setup 에 CELL_COMBO_DATA_TYPE 이 등재돼 있어도 이 목록이 우선한다 —
//   메타 등록 여부와 무관하게 화면 표기가 코드로 고정돼야 하기 때문이다.
export const CODE_DISPLAY_COLUMNS: readonly string[] = ['DIVISION_ID'];

// 그리드 콤보 파라미터 — 등록 SQL(SCM_ADM_CMBO_SQL_M.SQL_DTL_CTN)의 @키 치환값.
//   BE makeComboQuery 는 bind 가 아니라 raw 치환이므로 문자열 리터럴은 홑따옴표로 감싸 넘긴다.
//   Measure 콤보만 @mnuId 를 요구한다(DMF0003 대사표 §11 토큰 실측). @키가 없는 나머지 콤보는
//   여분 파라미터를 무시하므로 일괄 전달해도 무해하다.
export const GRID_COMBO_PARAMS: Record<string, string> = { mnuId: `'${MENU_ID}'` };

// SAVE payload 17 키 순서 — PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA PROC_M positional
//   (ALL_ARGUMENTS 실측 — 04_VERIFY/001_all_arguments.txt). 전부 '^' delim 다건.
export const SAVE_KEYS = [
  'activeFlag',
  'divisionId',
  'scmSiteId',
  'customerProjectCode',
  'customerModel',
  'incoterms',
  'fcstType',
  'domExp',
  'measureGroup',
  'measure',
  'plantSiteId',
  'uploadUom',
  'projectCode',
  'itemId',
  'yyyymmdd',
  'qty',
  // ⭐ 'createdBy' 금지 (2026-07-08 ORA-01400 사고) — BE(BaseService)가 세션 단일값으로 덮어써
  //   '^'×N 배열이 1토큰으로 붕괴 → SP split 시 2행째부터 CREATED_BY NULL → DM_PLN_CUSTOMER_PSI ORA-01400.
  //   DMF0020 표준 선례(createdByList)와 동일 — PROC_M COL_NM(SORT 17)도 'createdByList' 로 정렬(필수 동시배포).
  'createdByList',
] as const;
