import type { BUCKET_TYPE, DivisionCode } from './mkt-forecast-master.constants';

// AS-IS .cs Form_Load + InitControls (DMF0003_1_MktFcst.cs L318) 18 조회조건 필드
// SP DMF0003_GET_MKT_FCST_DATA (archive line 1546) 22 IN parameter 매핑:
//   sesUserId / mnuId / createdBy / userGroup / userDeptId / invalidExec : BE 자동 채움 (메모리 표준)
//   senderCode : Phase 6 (EDI Sender — 8 EDI sender 다중)
export interface SearchCondition {
  // 1. 사업부 (단일 — Division 3-way 114건 validation 의 가장 중요)
  divisionId: DivisionCode;

  // 2~8. 다중선택 ListBox (AS-IS clbTeam / clbCustomer / clbBizType / ... ControlValues, ^ 구분)
  teamIds: string[];
  endCustomers: string[];
  bizTypes: string[];
  scmSiteIds: string[];
  plantSiteIds: string[];     // Div 81 (ESS) 전용 — End Customer 종속
  itemTypes: string[];
  ediSenders: string[];       // Phase 6 (EDI Sender from UP_FX_GetCommonDataList_DM)

  // 9~10. Period (최대 3년 — MSG00164 validation)
  startYyyymmdd: string;      // YYYYMMDD format
  endYyyymmdd: string;

  // 11. Bucket type combo (D/W/M, AS-IS cboBucketType — DMF0003_GET_BUCKET_TYPE_CODE)
  bucketType: typeof BUCKET_TYPE[keyof typeof BUCKET_TYPE];

  // 12~14. 선택적 Lookup (textBox + popup)
  projectCode: string;        // AS-IS btnProject — Project Popup
  itemId: string;             // AS-IS btnItemId — Item Popup
  owner: string;              // AS-IS btnOwner — Owner Popup

  // 15~18. Checkbox 필터 (AS-IS chk*_CheckedChanged)
  asFromSite: boolean;        // AS-IS cboAS — AS From Site toggle (Phase 6)
  qtyFilter: boolean;         // AS-IS chkQty — "Qty>=0" filter
  cellQty: boolean;           // AS-IS chkCell — "Cell Qty" filter
  colorYn: boolean;           // AS-IS chkColor — 색상 표시 (Grid UX)
  sumYn: boolean;             // AS-IS chkSum — 합계 표시 (Grid UX, Phase 3 SUM 헤더)
}

// 메인 grid row — AS-IS DefColumns Main 43 fixed cols (analysis.md §4.5)
// SP O_RC1 cursor 의 SELECT alias 일치 (hook sheet-columns-binding-match)
// Phase 3 동적 PIVOT cols (Bucket D/W/M 별 ~50-100 cols) 는 [key: string]: any 로 확장
export interface MktFcstRow {
  // Fixed cols 43 (read-only Phase 1)
  DIVISION_ID: string;
  DEPT_ID: string;
  DEPT_NAME_KO: string;
  TEAM_ID: string;
  TEAM_NAME_KO: string;
  END_CUSTOMER: string;
  BIZ_TYPE: string;
  SCM_SITE_ID: string;
  PLANT_SITE_ID: string;
  PROJECT_CODE: string;
  PROJECT_CODE_NAME: string;
  PROJECT_NAME: string;
  ITEM_ID: string;
  ITEM_NAME: string;
  NICK_NAME: string;
  INCOTERMS: string;
  ITEM_TYPE: string;
  FCST_TYPE: string;
  DOM_EXP: string;
  PROJECT_STATUS: string;
  PROJECT_OWNER: string;
  OWNER: string;
  SOLD_TO_CUSTOMER: string;
  CELL_TYPE: string;
  CITY: string;
  CITY_NAME: string;
  COUNTRY: string;
  COUNTRY_NAME: string;
  EDIT_FLAG: 'I' | 'U' | 'D' | '';   // CRUD_TYPE marker (Phase 2)
  MEASURE_GROUP: string;
  MEASURE: string;
  YYYYMMDD: string;
  QTY: number;
  COLUMN_NAME: string;
  COLUMN_LABEL: string;
  SMALL_LABEL_NAME: string;
  LARGE_LABEL_NAME: string;
  DAY_CODE: string;
  DIVISION_ID40: string;
  END_CUSTOMER40: string;
  SCM_SITE_ID40: string;
  ITEM_ID40: string;
  VMI_YN: 'Y' | 'N' | '';

  // 동적 PIVOT cols (Phase 3) — Bucket 별 일자/주차/월 컬럼 (e.g. W_20260101 / M_202601 / D_20260101)
  [key: string]: string | number;
}

// CRUD_TYPE marker (Phase 2~7 — cellEditEnded cascade)
export type CrudType = 'I' | 'U' | 'D' | '';

// SCM_MST_SHEET_MEASURE row (admin SYS0004 UI Category Setup Measure 탭)
//   master hook §5 — "UI 생성의 동적 속성관리" Measure 부분
//   BE POST /admin/menu/{mnuId}/measure → List<GridMeasure>
//   ⭐ BE GridMeasure DTO 가 camelCase JSON 반환 (colNm, colLblNm). UPPER_SNAKE 키 접근 시 undefined.
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  lClsLblNm?: string;
  personalizable?: boolean;
  display?: boolean;
  attribute1?: string;
  attribute2?: string;
  attribute3?: string;
  attribute4?: string;
  attribute5?: string;
  attribute6?: string;
  attribute7?: string;
  attribute8?: string;
  attribute9?: string;
  attribute10?: string;
}
