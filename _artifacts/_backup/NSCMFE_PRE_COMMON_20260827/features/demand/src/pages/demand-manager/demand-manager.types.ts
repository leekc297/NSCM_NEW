// 조회조건 — Version(팝업 주입) + Period(월 구간 yyyyMM)
export interface SearchCondition {
  versionNo: string;
  periodFrom: string; // yyyyMM
  periodTo: string; // yyyyMM
}

// 메인 그리드 행 — PKG_DMF0068.P_DMF0068_GET_ORDERLIST 의 o_rc1 (고정 14 + 월 M1..Mn)
//   인덱스 시그니처를 따로 떼어 낸 교차(intersection) 타입 — mkt-fcst(MktFcstRow) / forecast-price
//   와 같은 방식이다. 공용 DataGrid 의 제네릭 제약 WijmoRowItem(= Record<string, WijmoPrimitive>)
//   은 인덱스 값에 undefined 를 허용하지 않는데, 한 interface 안에서 optional 프로퍼티와 인덱스를
//   함께 두면 TS2411(프로퍼티가 인덱스 타입에 대입 불가)이 나서 종전엔 인덱스에 undefined 를
//   넣어야 했고, 그 탓에 제약을 못 맞춰 <DataGrid> 에 캐스팅을 붙여 왔다.
//   구성요소를 가르면 optional 프로퍼티는 그대로 두면서 인덱스만 WijmoPrimitive 범위에 맞출 수 있다.
export type DemandManagerRow = {
  /** 월 컬럼 M1..Mn */
  [key: string]: string | number;
} & {
  PROJECT_NAME?: string;
  MEASURE?: string;
  ORDERSTART?: string;
  ORDEREND?: string;
  ORDERAPPROVAL?: string | number;
  ORDERNOW?: string | number;
  SRESULT?: number;
  SPLAN?: number;
  STOCK?: number;
  STOCK2?: number;
  KEYVALUE?: string; // ATTRIBUTE1 — 행 자신의 키
  KEYVALUE2?: string; // ATTRIBUTE2 — Measure 짝 그룹 키
  MEASURE2?: string; // 조인용 Measure 코드
  EDIT_YN?: string;
  CRUD_TYPE?: 'I' | 'M' | 'D';
  INSERT_GROUP_ID?: string; // 신규 세트 임시 그룹 키 (저장 시 KEYVALUE2 로 승격)
};

// 버전 팝업 행 — 그리드 바인딩 대상이므로 값에 undefined 를 두지 않는다
export interface VersionPopupRow {
  CODE: string;
  VERSION_NO: string;
  VERSION_DESCRIPTION: string;
  VERSION_TYPE: string;
  VER_CRE_SEQ: string;
  YYYYMMDD: string;
  CREATED_BY: string;
  CREATION_DATE: string;
  EDIT_YN: string;
  [key: string]: string | number;
}

// Project 셀 콤보 행
export interface LookupProjectRow {
  CODE?: string;
  NAME?: string;
  [key: string]: string | number | undefined;
}

// 저장 payload 1행 (PKG_DMF0068.P_DMF0068_SAVE_ORDERLIST_JSON 의 JSON 요소)
export interface SaveOrderRow {
  DIVISION_ID: string;
  PROJECT_CODE: string;
  YYYYMM_FROM: string;
  YYYYMM_TO: string;
  MEASURE: string;
  ORDER_APPROVAL: string;
  ORDER_NOW: string;
  ATTRIBUTE1: string;
  ATTRIBUTE2: string;
}

// 월 컬럼 메타 — 조회 기간에서 산출 (n번째 표시 월 = Mn)
export interface MonthColumnMeta {
  binding: string; // M1 · M2 · ...
  yyyymm: string; // 202601
  year: string; // 2026
  label: string; // 2026.01
}
