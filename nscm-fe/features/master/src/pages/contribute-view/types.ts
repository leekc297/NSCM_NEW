// AS-IS DMF0043_Contribute_View.cs DefColumns L55~73 + Designer.cs control 인벤토리
// 룰 #70 P3: extends WijmoRowItem + 모든 fields non-optional + 인덱스 시그니처 `string | number` 만
export interface SalesViewRow extends WijmoRowItem {
  YYYYMM: string;
  DIVISION_ID: string;
  VER_SEQ: string;
  COMPANY_ID: string;
  DEPARTMENT_ID: string;
  DEPARTMENT_NAME: string;
  DEPT_ID: string;
  DEPT_NAME: string;
  ATTRIBUTE2: string; // 고객군 (AS-IS .cs L62)
  END_CUST_REPORT: string;
  SOLDTO_CUST_REPORT: string;
  SHIPTO_CODE: string;
  CUST_GROUP_DTL: string; // 고객상세 (AS-IS .cs L63)
  REPORT_GROUP3: string; // 제품군 (AS-IS .cs L64)
  PRODUCT_GROUP: string;
  DM_BIZ_TYPE: string; // 형태 (AS-IS .cs L65)
  CURRENCY: string;
  EDIT_FLAG: string;
  AMT: number;
  // 동적 Y#/M# 컬럼 (AS-IS InitSpread SUM 머지 대상) — WijmoRowItem 의 `[k: string]: WijmoPrimitive` 인덱스 시그니처 상속.
  // 별도 명시 시 CRUD_TYPE?: string 과 충돌 (TS2411). reference: contribute-main/types.ts MainRow.
}

export interface ValidationCheckCount {
  CNT: number;
}

// AS-IS Designer.cs 조회조건 컨트롤 9종 매핑
export interface ViewSearchCondition {
  yyyy: string; // usrYear 의 표시 연도 (4자리)
  verSeq: string; // usrYear.ControlValues (.cs L311)
  versionNo: string; // txtVersion.Text (.cs L312)
  divisionId: string; // p_division_id = '40' (.cs L146, L310)
  endCustReport: string; // usrCust.Text (.cs L313)
  productGroup: string; // usrType.SelectedValue (.cs L314)
  bizType: string; // usrBiz.SelectedValue (.cs L315)
  millionYn: 'Y' | 'N'; // chkM.Checked (.cs L316)
  compatibilityYn: 'Y' | 'N'; // usrChk.Checked (.cs L317)
}

// AS-IS .cs L131 InitSpread 결과 행 — DMF0043_GET_SALES_LIST_SPREAD_TITLE
export interface SpreadTitleRow extends WijmoRowItem {
  COLUMN_NAME: string; // AS-IS DefColumns.ColumnName (.cs L69)
  COLUMN_LABEL_NAME: string; // AS-IS DefColumns.ColumnLabel (.cs L70)
  SMALL_CLASS_LABEL_NAME: string;
  LARGE_CLASS_LABEL_NAME: string;
}

// AS-IS .cs L107 InitControls 결과 행 — Year 콤보 (GetVersionData)
export interface VersionOption {
  CODE?: string | number;
  NAME?: string;
  NAME2?: string;
}
