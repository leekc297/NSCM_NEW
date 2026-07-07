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
  DAY_RANGE: 'o_rc2', // AS-IS Tables[0][0][0] — PR_GET_DAY_RANGE 월 경계 범위 (DMF0048 선례 o_rc2)
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
} as const;

// Column 메타 (sales-monitoring MainColumnMeta 동일 형태)
export interface MainColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  _default?: boolean;
}

// 식별 컬럼 fallback — 사내 SCM_MST_SHEET_COLUMNS 15행 등재본 1:1 스냅샷 (2026-07-04 신규 등록,
//   근거 = AS-IS InitSpread DefColumns/DefColumnsLabel + GET o_rc1 실측 15 cols. §9 BLOCK 6).
//   정본은 admin 동적 fetch (fetchStaticColumns) — 본 fallback 은 BE 메타 미응답 시 작동 보장용.
//   전 컬럼 읽기전용('S') — 편집은 SPREAD_TITLE 동적 D_ 기간 컬럼만 (AS-IS EditButton 실측).
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division*', width: 120, align: 'L', _default: true },
  { key: 'SCM_SITE_ID', header: 'Sales Site*', width: 120, align: 'L', _default: true },
  { key: 'PLANT_SITE_ID', header: 'Plant Site*', width: 120, align: 'L', _default: true },
  { key: 'CUSTOMER_PROJECT_CODE', header: 'Customer Project*', width: 120, align: 'L', _default: true },
  { key: 'CUSTOMER_MODEL', header: 'Customer Model*', width: 120, align: 'L', _default: true },
  { key: 'INCOTERMS', header: 'Incoterms*', width: 80, align: 'L', _default: true },
  { key: 'FCST_TYPE', header: 'FCST Type*', width: 80, align: 'L', _default: true },
  { key: 'DOM_EXP', header: 'Customs Handbook*', width: 120, align: 'L', _default: true },
  { key: 'MEASURE_GROUP', header: 'Measure Group*', width: 120, align: 'L', _default: true },
  { key: 'MEASURE', header: 'Measure*', width: 80, align: 'L', _default: true },
  { key: 'UPLOAD_UOM', header: 'Upload UOM*', width: 80, align: 'L', _default: true },
  { key: 'PROJECT_CODE', header: 'Project', width: 160, align: 'L', _default: true },
  { key: 'ITEM_ID', header: 'Model', width: 200, align: 'L', _default: true },
  // 내부 컬럼 — AS-IS EDIT_FLAG(w0 hidden) 1:1. EDIT_FLAG='Y' 행만 기간 셀 편집 허용 판정에 사용.
  { key: 'EDIT_FLAG', header: 'EDIT_FLAG', visible: false, _default: false },
  { key: 'EDIT_YN', header: 'EDIT_YN', visible: false, _default: false },
];

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
  'createdBy',
] as const;
