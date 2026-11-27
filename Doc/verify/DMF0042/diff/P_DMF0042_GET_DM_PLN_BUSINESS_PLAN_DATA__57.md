# DMF0042 · DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA ↔ PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA

- 실행 2026-11-26 22:25:49 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #57 sheet=Biz Plan btn=SEARCH user=yooah.chung FE 응답 행 7577 · 원천 Doc\verify\DMF0042\calls\eg_auth_개인화_칸_설정_보유_미보유_계정_정렬_EG032__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "deptId": "ALL", "endCustomer": "ALL", "scmSiteId": "ALL", "projectCode": "", "itemId": "", "itemType": "ALL", "fromYyyymmdd": "20261101", "nowYyyymmdd": "20261123", "toYyyymmdd": "20270531", "plantSiteId": "ALL", "bizType": "ALL", "userGroup": "DM Planner", "owner": "", "qtyYn": "N"}`
- SKIP: kind=SAVE — GET 만 실행(쓰기 SP 실행 금지) ·  · kind 근거: DML 대상 ['A']
