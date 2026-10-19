/**
 * SCP0049 CAPA 타입 — 조회 커서(o_rc) 행 + 조회조건(searchParams).
 * 서버 커서 형상은 procedures.d.ts SCP0049.capa.response.o_rc 가 SSOT — 여기서는 화면 로직이
 * 참조하는 필드만 명시하고, 동적 기간칼럼(D_/M_/Y_) 및 잉여 필드는 인덱스 시그니처로 받는다(03 §4.1).
 */
// WijmoRowItem 확장(전역 index = WijmoPrimitive) — DataGrid<CapaRow>/EditTracker<CapaRow> 제약 충족.
//   동적 기간칼럼(D_/M_/Y_)·USER_ID_1~10·잉여 필드는 상속 index 시그니처로 접근한다.
export interface CapaRow extends WijmoRowItem {
  DIVISION_ID: string;
  COMPANY_ID: string;
  SITE_ID: string;
  PLANT_ID: string;
  FACTORY_ID: string;
  LINE_ID: string;
  OPERATION_ID: string;
  ELECTRODE_TYPE: string;
  ITEM_ID: string;
  LOSS_CODE: string;
  EDITORBLE_YN: string;
  CATEGORY_ID: string;
  KEY_ID: string;
  DATA_TABLE: string;
  ROW_RANKING: string;
  LANE_QTY: string;
  CONFIRM_FLAG: boolean; // SP 는 'True'/'False' 문자열, Capa.tsx rows 에서 boolean 으로 정규화
  UOM: string;
  DEPARTMENT: string;
  MANAGER: string;
  // CRUD_TYPE / REQUEST_CHK / USER_ID_* / 기간칼럼은 WijmoRowItem index 로 접근(CRUD_TYPE 은 상속 optional).
}

/** 확정률 헤더 요약(o_rc2 1행 4필드 + o_rc3 1필드) — 영역1 R14. */
export interface CapaSummary {
  total: string;
  auto: string;
  small: string;
  elec: string;
  pic: string;
}

/** 조회조건 입력 상태(store searchParams). */
export interface CapaSearchParams {
  divisionId: string;
  group: string; // 단일 선택(첫 그룹). 하위 재조회 파라미터.
  plantIds: string[];
  factoryIds: string[]; // Building
  lineIds: string[];
  operationIds: string[];
  versionId: string; // 'Current' | VERSION_ID
  fromYyyymm: string;
  toYyyymm: string;
  modelId: string; // 텍스트(콤마 다중)
  materialId: string;
  bucketDay: boolean; // Month 고정 + Day 토글
  checkLoss: boolean;
  checkLine: boolean;
  checkTact: boolean;
  checkYield: boolean;
  checkResult: boolean; // 그리드 Best/Worst↔Result 토글(SP 파라미터 아님)
  checkEmpty: boolean;
}

/** 캘린더 커서 1행(P_GET_SHEET_CALENDAR). */
export interface CalendarRow {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  SMALL_CLASS_LABEL_NAME?: string;
  LARGE_CLASS_LABEL_NAME?: string;
  DAY_CODE: string;
  SORT_ORDER_NO: string | number;
}
