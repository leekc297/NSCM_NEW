export interface SearchCondition {
  userId: string;
  startDate: string;
  endDate: string;
  status: string;
}

export interface ApprovalRow {
  REQUEST_ID: string;
  USER_ID: string;
  USER_NAME: string;
  GROUP_ID: string;
  GRP_NAME: string;
  DIVISION_ID: string;
  PLANT: string;
  CUSTOMER: string;
  REQUEST_DATE: string;
  STATUS: string;
  APPROVED_BY: string;  // optional 제거 — WijmoPrimitive index sig 에 undefined 미포함 (TS2411 회피). BE 미반환 시 '' default
  // DataGrid 의 WijmoRowItem constraint 호환 (룰 23 §6 — index signature 의무)
  [key: string]: WijmoPrimitive;
}
