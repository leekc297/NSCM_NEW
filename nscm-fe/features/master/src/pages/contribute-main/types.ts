// AS-IS .cs DefColumns 의 13 컬럼 — Wijmo FlexGrid binding 용
// Wijmo 의 WijmoPrimitive 와 호환을 위해 동적 키 인덱스 시그니처는 undefined 미포함
// (실제 row 에서 비어있는 셀은 '' 로 채움).
// hook #70 P3 — WijmoRowItem extends 의무 (Grid<T> 제네릭 제약 호환).
export interface MainRow extends WijmoRowItem {
  DIVISION_ID: string;
  VER_SEQ: string;
  DEPARTMENT_ID: string;
  DEPT_ID: string;
  END_CUST_REPORT: string;
  SOLDTO_CUST_REPORT: string;
  PRODUCT_GROUP: string;
  DM_BIZ_TYPE: string;
  EDIT_FLAG: string;
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  SMALL_CLASS_LABEL_NAME: string;
  LARGE_CLASS_LABEL_NAME: string;
  // 동적 월별 컬럼 (Y#YYYYMM#OS_CORP_CD 패턴) — WijmoRowItem 의 인덱스 시그니처
  // [k: string]: WijmoPrimitive 를 상속받음 (별도 명시 시 CRUD_TYPE?: string 과 충돌).
}

// 칸 제목 SP(P_DMF0043_GET_MAIN_SPREAD_TITLE, 시트 mainTitle) o_rc1 행.
//   기본 칸(SHEET_COLUMNS) 8행 + 동적 칸 117행(월 12 × 법인 9 = M#YYYYMM#RBU_xxxx, 연도 9 = Y#YYYY#RBU_xxxx).
//   데이터 유무와 무관하게 선택 연도 전체를 내려준다 — 그리드 칸은 이 행으로 만든다 (AS-IS InitSpread 1:1).
export interface SpreadTitleRow extends WijmoRowItem {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string; // 법인 한글명 (대만·중국-화남 … 구분)
  SMALL_CLASS_LABEL_NAME: string;
  LARGE_CLASS_LABEL_NAME: string; // 기간 표기 (2025-01 / 2025)
  // SORT_ORDER_NO 도 오지만(법인 DISPLAY_SEQ, 모든 달이 같은 값) 정렬에 쓰지 않아 명시하지 않는다.
  //   선택(?) 필드는 WijmoRowItem 의 인덱스 시그니처(undefined 미포함)와 충돌한다.
}

export interface VersionRow {
  VER_SEQ: string;
  YYYY: string;
  VERSION_NM?: string;
  DESCRIPTION?: string;
  VALID_YN?: string;
  CODE?: string;
  NAME?: string;
  NAME2?: string;
}

export interface SalesRow {
  YYYYMM: string;
  DEPARTMENT_ID: string;
  DEPARTMENT_NAME: string;
  DEPT_ID: string;
  DEPT_NAME: string;
  CUST_REPORT?: string;
  END_CUST_REPORT?: string;
  SOLDTO_CUST_REPORT?: string;
  SHIPTO_CODE?: string;
  PRODUCT_GROUP?: string;
  DM_BIZ_TYPE?: string;
  AMT?: number;
  EDIT_FLAG?: string;
}

export interface SearchParamProps {
  yyyy: string; // usrYear 선택 년도
  verSeq: string; // usrYear 선택 verSeq
  his: 'Y' | 'N'; // usrHis
  dis: 'ALL' | 'N'; // usrDiscard (불일치 조회)
  chkYear: boolean; // chkYear (년도별 필터)
}

export interface ContributeRatePopupResult {
  divisionId: string;
  yyyymm: string;
  osCorpCd: string;
  contributionType: string;
  contributionRatio: string;
}
