export const MENU_ID = 'DMF0013' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0013_CustPsiUpload.cs (Demand > Demand Plan > Customer PSI Upload):
//   - DMF0014_CustFcstUpload 를 복제·파생한 화면 (원장 §0.3) — MeasureGroup 고정값만 "PSI" 로 분기.
//   - 메인 그리드 : 식별 14 컬럼(항상 잠금 — 신규행만 부분 개방) + SPREAD_TITLE 동적 D_ 기간 컬럼
//     (EDIT_FLAG='Y' 행 또는 신규행만 편집)
//   - 데이터 유입 : Excel 업로드(공통 FileController excel-upload) + 그리드 직접 입력 + F8 행 삽입.
//     주의: DMF0013 은 AS-IS InsertRow(F8) 가 활성이다(원장 §E12) — DMF0014 가 MSG00380 으로 차단한
//     삽입·Division81 분기를 DMF0013 은 존치한다(portspec §8-1 오케스트레이터 결정 (b)).
//   - SP: DM.DMF0013_GET_CUST_PSI_UPLOAD_DATA(메인) + DM.DMF0014_GET_SPREAD_TITLE(공유 기간 헤더)
//         + PR_GET_DAY_RANGE(기본 조회구간) + DM.DMF0013_SAVE_CUST_PSI_UPLOAD_DATA(저장 '^' 17키).
export enum SHEETS {
  // 메인 그리드 — AS-IS SheetView "PSI Upload" 등록명 그대로 (원장 §0 시트).
  //   excel-upload 는 SHEET_NAME=#{shtNm} 조회이므로 이 값이 체인 키.
  MAIN = 'PSI Upload',
  SPREAD_TITLE = 'spreadTitle', // 동적 기간 헤더 — 공유 SP DM.DMF0014_GET_SPREAD_TITLE (원장 §6.1)
  DAY_RANGE = 'dayRange', // 기본 조회구간 — PR_GET_DAY_RANGE (AS-IS GetDayRange p_month=6, o_rc2)
}

export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  SPREAD_TITLE: 'o_rc1',
  DAY_RANGE: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// Bucket — AS-IS BucketType struct 실측 (DAILY/WEEKLY/MONTHLY full-word, 기본 WEEKLY)
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// 이 화면 MeasureGroup 고정값 — AS-IS InsertRow L631 / Measure 조회 마지막 인자 "PSI"
//   (DMF0014 = "FCST" 와의 유일한 상수 차이 — 원장 §1.1, portspec §1).
export const MEASURE_GROUP_FIXED = 'PSI' as const;

// AS-IS Validation MSG — portspec §5 매핑 승계. DMF0014 는 SCM_ADM_MSG_M 실측으로 재매핑했고
//   (MSG00002→MSG00429 등), DMF0013 도 동일 사내 메시지 테이블을 쓰므로 DMF0014 재매핑을 승계한다.
//   주의: AS-IS MSG 원문 DB 미대사(portspec §8-5) — MSG00164/00150/00002 실문구는 SCM_ADM_MSG_M 실측 후 확정.
export const MSG = {
  // Division 미선택 조회 차단 (AS-IS FindData L398)
  REQUIRE_DIVISION: 'MSG00097',
  // 시작일>종료일 (AS-IS FindData L409 / Period변경 L739)
  PERIOD_INVERTED: 'MSG00108',
  // 기간 상한 (AS-IS L413: AddYears(2) — 조건 2년 / 문구 불일치는 AS-IS 자체 상태 1:1 보존)
  PERIOD_MAX: 'MSG00164',
  // "{0} value is required." — spdMain_Changed 필수 11건 (AS-IS MSG00002 의미 1:1 = DMF0014 재매핑 MSG00429)
  REQUIRED_VALUE: 'MSG00429',
  // 저장 대상 0건 (AS-IS SaveData iCount=0 L609) — DMF0014 재매핑 승계 MSG00152
  NO_SAVE_DATA: 'MSG00152',
  // Excel Form 조회 0건 — "조회된 데이터가 없습니다." (DMF0014 승계)
  EXCEL_FORM_EMPTY: 'MSG00719',
  // 재진입 가드 — "이전 작업이 아직 실행 중입니다." (저장 in-flight 중 재클릭 차단)
  WORK_IN_PROGRESS: 'MSG00137',
  // 저장 성공 — "성공적으로 저장되었습니다." (전 화면 공통 토스트 키)
  SAVED: 'MSG00002',
  // 저장 오류 공통 fallback — "저장 중 오류가 발생했습니다."
  SAVE_ERROR: 'MSG00618',
} as const;

// Column 메타 (customer-fcst-upload MainColumnMeta 동일 형태)
export interface MainColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  _default?: boolean;
  // COMBO + comboKey 조합이면 공용 DataGrid 가 CODE -> NAME dataMap 을 자동으로 붙인다.
  //   주의: 표시 전용이다 — 셀에 남는 값(= 저장 payload)은 언제나 CODE 원문이다.
  _ctrlType?: 'FPText' | 'FPComboBox';
  _comboKey?: string;
}

// 식별 컬럼 fallback — 정본은 admin 동적 fetch(fetchStaticColumns). 본 fallback 은 BE 메타 미응답 시 작동 보장용.
//   근거 = AS-IS InitSpread DefColumns(원장 §E01 1.3, 14 속성 컬럼) + DMF0014 스냅샷 승계.
//   전 컬럼 읽기전용('S') — 편집은 SPREAD_TITLE 동적 D_ 기간 컬럼 + 신규행 부분 개방(§INSERT_EDITABLE_COLUMNS)만.
//   콤보 comboKey = SCM_ADM_CMBO_SQL_M 등록 SQL_ID (AS-IS AddComboColumn 8종, 원장 §6.2):
//     DIVISION_ID   Data.Common(Division)              -> 제외. CODE_DISPLAY_COLUMNS 참조
//     SCM_SITE_ID   Data.UserSiteByEndCustomer         -> SalesSite
//     PLANT_SITE_ID Data.UserPlantSiteByDivision       -> PlantByDivisionCompany
//     INCOTERMS     GetLookupValues('INCOTERMS')       -> Incoterms
//     FCST_TYPE     GetLookupValues('SALES_TYPE_CODE') -> FcstType
//     DOM_EXP       Data.Common(DOM_EXP)               -> DOM_EXP
//     MEASURE       Data.Common(CustomerMeasure,...PSI) -> Measure (@mnuId 필요 - GRID_COMBO_PARAMS)
//     UPLOAD_UOM    Data.Common(CUST_FCST_UPLOAD_UOM)  -> 등록 SQL_ID 없음. admin CELL_COMBO_DATA_TYPE 로 병합
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division*', width: 120, align: 'L', _default: true },
  {
    key: 'SCM_SITE_ID',
    header: 'Sales Site*',
    width: 120,
    align: 'L',
    _default: true,
    _ctrlType: 'FPComboBox',
    _comboKey: 'SalesSite',
  },
  {
    key: 'PLANT_SITE_ID',
    header: 'Plant Site*',
    width: 120,
    align: 'L',
    _default: true,
    _ctrlType: 'FPComboBox',
    _comboKey: 'PlantByDivisionCompany',
  },
  { key: 'CUSTOMER_PROJECT_CODE', header: 'Customer Project*', width: 120, align: 'L', _default: true },
  { key: 'CUSTOMER_MODEL', header: 'Customer Model*', width: 120, align: 'L', _default: true },
  {
    key: 'INCOTERMS',
    header: 'Incoterms*',
    width: 80,
    align: 'L',
    _default: true,
    _ctrlType: 'FPComboBox',
    _comboKey: 'Incoterms',
  },
  {
    key: 'FCST_TYPE',
    header: 'FCST Type*',
    width: 80,
    align: 'L',
    _default: true,
    _ctrlType: 'FPComboBox',
    _comboKey: 'FcstType',
  },
  {
    key: 'DOM_EXP',
    header: 'Customs Handbook*',
    width: 120,
    align: 'L',
    _default: true,
    _ctrlType: 'FPComboBox',
    _comboKey: 'DOM_EXP',
  },
  // AS-IS AddTextColumn — 콤보 아님. MEASURE_GROUP 은 코드 자체가 표시값(이 화면 고정 "PSI").
  { key: 'MEASURE_GROUP', header: 'Measure Group*', width: 120, align: 'L', _default: true },
  {
    key: 'MEASURE',
    header: 'Measure*',
    width: 80,
    align: 'L',
    _default: true,
    _ctrlType: 'FPComboBox',
    _comboKey: 'Measure',
  },
  { key: 'UPLOAD_UOM', header: 'Upload UOM*', width: 80, align: 'L', _default: true },
  { key: 'PROJECT_CODE', header: 'Project', width: 160, align: 'L', _default: true },
  { key: 'ITEM_ID', header: 'Model', width: 200, align: 'L', _default: true },
  // 내부 컬럼 — AS-IS EDIT_FLAG(hidden) 1:1. EDIT_FLAG='Y' 행만 기간 셀 편집 허용 판정에 사용.
  { key: 'EDIT_FLAG', header: 'EDIT_FLAG', visible: false, _default: false },
  { key: 'EDIT_YN', header: 'EDIT_YN', visible: false, _default: false },
];

// 코드 그대로 표시할 컬럼 — CODE -> NAME dataMap 을 붙이지 않는다 (DMF0014 규약 승계).
export const CODE_DISPLAY_COLUMNS: readonly string[] = ['DIVISION_ID'];

// F8 신규행에서만 편집 개방하는 속성 컬럼 (AS-IS InsertRow L627~633 실측):
//   개방 = Division/ScmSite 콤보 + CustProject/CustModel/Incoterms/FcstType/DomExp/Measure.
//   PLANT_SITE_ID 는 Division=="81" 일 때만 개방(원장 §E12/§E17 D-2) — 그리드 beginningEdit 에서 조건 분기.
//   잠금 유지 = MEASURE_GROUP('PSI' 고정)/UPLOAD_UOM(Auto-Sync)/PROJECT_CODE/ITEM_ID (L631~633).
//   기존(조회) 행은 이 목록과 무관하게 항상 잠금 — 편집은 신규행(CRUD_TYPE='I')에서만.
export const INSERT_EDITABLE_COLUMNS: readonly string[] = [
  'DIVISION_ID',
  'SCM_SITE_ID',
  'PLANT_SITE_ID', // Division=="81" 조건 (그리드에서 분기)
  'CUSTOMER_PROJECT_CODE',
  'CUSTOMER_MODEL',
  'INCOTERMS',
  'FCST_TYPE',
  'DOM_EXP',
  'MEASURE',
];

// 그리드 콤보 파라미터 — 등록 SQL(SCM_ADM_CMBO_SQL_M.SQL_DTL_CTN)의 @키 치환값.
//   BE makeComboQuery 는 raw 치환이므로 문자열 리터럴은 홑따옴표로 감싸 넘긴다.
//   Measure 콤보만 @mnuId 를 요구한다. @키 없는 나머지 콤보는 여분 파라미터를 무시하므로 무해.
export const GRID_COMBO_PARAMS: Record<string, string> = { mnuId: `'${MENU_ID}'` };

// SAVE payload 17 키 순서 — DM.DMF0013_SAVE_CUST_PSI_UPLOAD_DATA positional (AS-IS 직렬화 L566~582).
//   전부 '^' delim 다건. AS-IS 는 UOM 이 PlantSite 뒤 순서라 DMF0014 와 미세 상이하나 이름 기반 대입이라
//   무해(원장 §E14). PROC_M ALL_ARGUMENTS 실측으로 최종 확정 필요(portspec §8-7).
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
  // 'createdBy' 금지 — BE(BaseService)가 세션 단일값으로 덮어써 '^'×N 배열이 1토큰으로 붕괴
  //   → SP split 2행째부터 CREATED_BY NULL → ORA-01400. DMF0014/DMF0020 선례와 동일 'createdByList'.
  'createdByList',
] as const;
