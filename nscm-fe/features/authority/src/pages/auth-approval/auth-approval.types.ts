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
  APPROVED_BY?: string;
}
