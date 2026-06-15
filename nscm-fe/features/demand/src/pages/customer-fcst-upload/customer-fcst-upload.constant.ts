// AS-IS DMF0014_CustFcstUpload.cs (1,275줄) — Customer FCST Upload
//   - PKG_DMF0014: 5 SP (메인 GET / SPREAD_TITLE / SAVE / EXCEL_UPLOAD 1,541줄 / EXCEL_UPLOAD_SM)
//   - Sheet 1 (FCST Upload) / 15 cols + EditFlag + 동적 시간축
//   - F-key: F5 / F7 / F8 / F9 / F12 + btnExcelUpload (Viewer 권한 시 hide)
//   - Popup 3 (Project / Item 공용 + ExcelUpload 신규)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0014_CustFcstUpload/ (8 MD 기존)
//   - 자매 reference: DMF0048 SalesMonitoring (Plan 표준)
//   - 메뉴: Demand > Demand Plan > Customer FCST Upload (UPPR_MNU_ID='Demand_Plan')
//
// ⭐ 2026-06-07 정식 완성 보강:
//   - MENU_ID 소문자 'dmf0014' → 'DMF0014' 대문자 (자매 화면 표준 + SCM_ADM_MNU_M case 일치)
//   - SHEETS.SPREAD_TITLE 추가 (동적 헤더 D/W/M)
//   - MSG ID 인벤토리 + validation hook
export const MENU_ID = 'DMF0014' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  CUSTOMER_FCST_UPLOAD = 'customerFcstUpload',     // 메인 그리드
  SPREAD_TITLE = 'spreadTitle',                     // 동적 헤더 메타 (Bucket 별 D_/W_/M_)
}

export enum RESPONSE_SET {
  DATA = 'o_rc1',
  SPREAD_TITLE = 'o_rc1',
}

// AS-IS BucketType (DAILY/WEEKLY/MONTHLY)
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// Division 분기 (AS-IS .cs L256 sDivision=="40" — 소형사업부 특화)
export const DIVISION = {
  MOBILITY: '40',
  ESS: '81',
  POWER: '82',
} as const;

// AS-IS Validation MSG ID 매핑 (validation.md 20건):
//   필수값 11 + 비즈니스 규칙 8 + 사일런트 가드 1
export const MSG = {
  REQUIRE_DIVISION:        'MSG00097',
  NO_DATA:                 'MSG00108',
  REQUIRED_COLUMN:         'MSG00137',
  REQUIRED_FIELD:          'MSG00002',     // {0} 필수 입력
  CONFIRM_SAVE:            'MSG00004',
  CONFIRM_DELETE:          'MSG00005',
  EXCEL_UPLOAD_RESULT:     'MSG00265',
  DUPLICATE:               'MSG00043',
  INVALID_DATE:            'MSG00049',
  PERIOD_OVER:             'MSG00164',
} as const;
