export interface SearchCondition {
  divisionId: string;
  userId: string;
  department: string;
  startDate: string;
  endDate: string;
  status: string;
}

// 2026-07-02 — SP P_SYS0012_GET_APPROVAL_LIST 컬럼 확장 정합 (AS-IS 기준 13 표시 컬럼):
//   COMPANY_ID/WORKING_NAME/SSO_LOCATE(SSO_USER_INFO) + DEPARTMENT(SSO_DEPT) + AUTHORITY(USER_GR_NM).
//   구 GRP_NAME/PLANT/CUSTOMER 는 SP/메타에서 제거(VALID_YN='N').
export interface ApprovalRow {
  REQUEST_ID: string;
  USER_ID: string;
  USER_NAME: string;
  COMPANY_ID: string;
  WORKING_NAME: string;
  SSO_LOCATE: string;
  DEPARTMENT: string;
  GROUP_ID: string;
  AUTHORITY: string;
  DIVISION_ID: string;
  REQUEST_DATE: string;
  STATUS: string;
  APPROVED_BY: string;
  APPROVED_DATE: string;
  REASON: string;
  REJECT_REASON: string;
  // optional 제거 — WijmoPrimitive index sig 에 undefined 미포함 (TS2411 회피). BE 미반환 시 '' default
  // DataGrid 의 WijmoRowItem constraint 호환 (룰 23 §6 — index signature 의무)
  [key: string]: WijmoPrimitive;
}
