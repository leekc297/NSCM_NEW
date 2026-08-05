export const MENU_ID = 'DMF0048' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0048_SalesMonitoring.cs (Demand > Demand Plan > Sales Monitoring / 판매 모니터링):
//   - 메인 그리드 : PIVOT wide format (좌측 고정 식별 컬럼 + 기간 동적 M_/W_/D_ 컬럼) — read-only
//   - 분석서      : Doc/_analysis/domain_DM/screens/DMF0048_SalesMonitoring/ (validation 23 / expressions 7 / events 21)
//   - 디자인      : Doc/_figma/DMF0048/DMF0048.png
//   - AS-IS 는 FindButton/ExcelButton 만 override — 저장 스택(InitSaveDataTable 등)은 주석 처리된
//     데드코드 (사용자 확정 2026-07-04: read-only, Insert/Delete/Save 미지원)
export enum SHEETS {
  MAIN = 'Sales Monitoring', // 메인 그리드 — AS-IS 등록명 그대로 (룰 #91 sheet-name-asis-preserve, SHEET_COLUMNS 54행 키)
  SPREAD_TITLE = 'spreadTitle', // 동적 컬럼 메타 (기간 PIVOT 헤더) — DMF0048_GET_SPREAD_TITLE
  DAY_RANGE = 'dayRange', // 기본 조회구간 — PR_GET_DAY_RANGE (AS-IS GetDayRange, o_rc2=월단위 범위 사용)
}

// const object — 메인 데이터 커서 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  SPREAD_TITLE: 'o_rc1',
  DAY_RANGE: 'o_rc2', // ⭐ AS-IS Tables[1] (해당 월 1일 ~ p_month개월 마지막 날) — .cs L996 1:1
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// Bucket Type — DMF0003_GET_BUCKET_TYPE_CODE 실측 (CODE='DAILY'/'WEEKLY'/'MONTHLY').
//   ⚠️ DMF0003 화면('D'/'W'/'M')과 달리 DMF0048 SP 는 full-word 비교 (p_bucket = 'DAILY').
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// 동적 컬럼 kind 매핑 (M_/W_/D_ prefix)
export const BUCKET_PREFIX: Record<BUCKET_TYPE, 'M' | 'W' | 'D'> = {
  [BUCKET_TYPE.MONTHLY]: 'M',
  [BUCKET_TYPE.WEEKLY]: 'W',
  [BUCKET_TYPE.DAILY]: 'D',
};

// Division 분기 (AS-IS validation — 40 / 81* / 82)
export const DIVISION = {
  MOBILITY: '40',
  ESS: '81',
  POWER: '82',
} as const;

// ⭐ AS-IS Validation MSG ID — 5종 전부 사내 SCM_ADM_MSG_M 실존 (2026-07-04 실측) → 그대로 재사용.
export const MSG = {
  // "이전 작업이 아직 실행 중입니다." (.cs L625 blnWork 가드)
  WORK_IN_PROGRESS: 'MSG00137',
  // "조회 기간이 잘못되었습니다 (시작일 > 종료일)." (.cs L638)
  PERIOD_INVERTED: 'MSG00108',
  // "조회 기간은 3년 이내로 입력해주세요." (.cs L645)
  PERIOD_MAX_3YEAR: 'MSG00164',
  // "Division 을 선택하세요." (.cs L671)
  REQUIRE_DIVISION: 'MSG00097',
  // "Insert 된 행이 있어 Bucket 을 변경할 수 없습니다." (.cs L2173 — read-only 화면이라 N/A, 기록용)
  INSERT_ONLY_BUCKET: 'MSG00227',
} as const;

// Column 메타 (mkt-fcst MainColumnMeta 동일 형태)
export interface MainColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  scale?: number;
  visible?: boolean;
  _ctrlType?:
    | 'FPText'
    | 'FPModal'
    | 'FPComboBox'
    | 'FPCheckBox'
    | 'FPDate'
    | 'FPDateTime'
    | 'FPNumber';
  _inputEditType?: 'S' | 'M' | 'O' | 'IM' | 'IO';
  _comboKey?: string;
  // hook #92 — DIVISION_ID 콤마 토큰 (공란 = 항상 표시)
  _divisionAllow?: string;
  // DEFAULT_FLAG='Y' 스냅샷 — 최초(개인 컬럼설정 없음) 기본 표시 세트 (BE display 필드의 fallback)
  _default?: boolean;
}

// 좌측 고정 컬럼 fallback — 사내 SCM_MST_SHEET_COLUMNS 54행 실측 스냅샷 (2026-07-04, SORT_ORDER_NO 순,
//   VISIBLE_FLAG='Y' 이면서 division 대표 컬럼). 정본은 admin 동적 fetch (fetchStaticColumns) — 본
//   fallback 은 BE 메타 미응답 시 화면 작동 보장용. INPUT_TP_CD 전행 'S' (read-only 실측).
export const MAIN_COLUMNS: MainColumnMeta[] = [
  {
    key: 'DIVISION_ID',
    header: 'Division',
    width: 40,
    align: 'L',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'S',
    _default: true,
    _comboKey: 'Division',
    _divisionAllow: '',
  },
  {
    key: 'DEPT_ID',
    header: 'Team',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _divisionAllow: '',
  },
  {
    key: 'END_CUSTOMER',
    header: 'End Customer',
    width: 90,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '82,81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'END_CUSTOMER40',
    header: 'End Customer',
    width: 90,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '40',
  },
  {
    key: 'SCM_SITE_ID',
    header: 'Sales Site',
    width: 120,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '',
  },
  {
    key: 'PROJECT_CODE',
    header: 'Project Code',
    width: 90,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '82,81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'CUST_GROUP',
    header: 'Cust Group',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _divisionAllow: '40',
  },
  {
    key: 'CUST_GROUP_DTL',
    header: 'Cust Group Dtl',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _divisionAllow: '40',
  },
  { key: 'OWNER', header: 'Owner', width: 80, align: 'L', _inputEditType: 'S', _divisionAllow: '' },
  {
    key: 'PROJECT_NAME',
    header: 'Project',
    width: 90,
    align: 'L',
    _inputEditType: 'S',
    _divisionAllow: '81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'PROJECT_STATUS',
    header: 'Project Status',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _divisionAllow: '82,81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'BIZ_TYPE_NAME40',
    header: 'Biz.Type',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _divisionAllow: '40',
  },
  {
    key: 'BIZ_TYPE_NAME',
    header: 'Biz.Type',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _divisionAllow: '82,81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'ITEM_ID',
    header: 'Model',
    width: 110,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '',
  },
  {
    key: 'TEXT',
    header: 'Text',
    width: 100,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '82,81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'ITEM_CLASS_NAME',
    header: 'Model Type',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _divisionAllow: '40,81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'KWH_CELL',
    header: 'KWh/Cell',
    width: 100,
    align: 'R',
    scale: 10,
    _ctrlType: 'FPNumber',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'KWH_MODULE',
    header: 'KWh/Module',
    width: 100,
    align: 'R',
    scale: 10,
    _ctrlType: 'FPNumber',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'KWH_PACK',
    header: 'KWh/Pack',
    width: 100,
    align: 'R',
    scale: 10,
    _ctrlType: 'FPNumber',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'ITEM_TYPE',
    header: 'Item Type',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _divisionAllow: '40,81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'NICK_NAME',
    header: 'Nickname',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '',
  },
  {
    key: 'INCOTERMS',
    header: 'Incoterms',
    width: 60,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '',
  },
  {
    key: 'FCST_TYPE',
    header: 'FCST Type',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '',
  },
  {
    key: 'DOM_EXP',
    header: 'Customs Handbook',
    width: 60,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '',
  },
  {
    key: 'COMPANY_ID',
    header: 'Company',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '40',
  },
  {
    key: 'CELL_PROD_SITE_ID',
    header: 'Cell Prod Site',
    width: 110,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '40',
  },
  {
    key: 'CURRENCY',
    header: 'Currency',
    width: 60,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '',
  },
  {
    key: 'PLANT_SITE_ID',
    header: 'Plant Site',
    width: 80,
    align: 'L',
    _inputEditType: 'S',
    _default: true,
    _divisionAllow: '81,81_UC,81_HM,81_ST,81_HD,81_HG',
  },
  {
    key: 'MEASURE',
    header: 'Measure',
    width: 100,
    align: 'L',
    _inputEditType: 'S',
    _divisionAllow: '',
  },
] as const as MainColumnMeta[];
