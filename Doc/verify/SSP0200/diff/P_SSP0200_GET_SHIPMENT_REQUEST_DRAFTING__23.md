# SSP0200 · SSP0200_GET_SHIPMENT_REQUEST_DRAFTING ↔ PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTING

- 실행 2026-11-15 06:43:23 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #23 sheet=sub btn=SEARCH user=minyonglee1 FE 응답 행 3 · 원천 Doc\verify\SSP0200\calls\_verify_레이아웃_조회_묶음_H4_N1_G1_L2__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "fromSite": "", "toSite": "", "erpSoNo": "", "itemId": "", "bodId": "", "incoterms": "", "transportMode": "", "projectCode": "", "fcstType": "", "confirmId": "", "fromYyyymmdd": "Invalid Date", "toYyyymmdd": "Invalid Date", "changeRequestNo": "", "requestUserId": "minyonglee1", "requestStatus": "D", "language": "KO", "changeType": "C", "debugMode": "F"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_from_site": "", "p_to_site": "", "p_erp_so_no": "", "p_item_id": "", "p_bod_id": "", "p_incoterms": "", "p_transport_mode": "", "p_project_code": "", "p_fcst_type": "", "p_confirm_id": "", "p_from_yyyymmdd": "Invalid Date", "p_to_yyyymmdd": "Invalid Date", "p_change_request_no": "", "p_request_user_id": "minyonglee1", "p_request_status": "D", "p_language": "KO", "p_change_type": "C", "debug_mode": "F"}`
- SKIP: 인자 미해결(UNRESOLVED): fromYyyymmdd='Invalid Date'(E2E 입력 시험 중 포착된 호출 — 대조 대상 아님),toYyyymmdd='Invalid Date'(E2E 입력 시험 중 포착된 호출 — 대조 대상 아님) — param_map.csv 에 값/대응 지정
