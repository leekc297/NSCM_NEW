# DMF0005 · DMF0005_GET_SALES_SITE_MODEL_PRODUCTION ↔ PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION

- 실행 2026-11-14 09:06:59 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #36 sheet=production btn=SEARCH user=minyonglee1 FE 응답 행 2555 · 원천 Doc\verify\DMF0005\calls\_verify_이름_ID_조건_건수_A1__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "deptId": "ALL", "endCustomer": "ALL", "salesSite": "ALL", "projectCode": "", "itemId": "", "activeFlag": "ALL", "owner": "yay12021", "endCustReportYn": "N", "projectInfoYn": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_dept_id": "ALL", "p_end_customer": "ALL", "p_project_code": "", "p_item_id": "", "p_owner": "yay12021", "p_end_cust_report_yn": "N", "p_project_info_yn": "N", "p_scm_site_id": "Fabricators_CN_QIN", "p_valid_yn": "", "p_created_by": "bpark416", "p_userinfo": "", "p_user_dept_id": ""}`
- SKIP: 인자 미해결(UNRESOLVED): p_valid_yn,p_userinfo,p_user_dept_id — param_map.csv 에 값/대응 지정
