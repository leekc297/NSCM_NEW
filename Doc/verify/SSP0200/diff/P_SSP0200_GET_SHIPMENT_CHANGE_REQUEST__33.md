# SSP0200 · SSP0200_GET_SHIPMENT_CHANGE_REQUEST ↔ PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST

- 실행 2026-11-15 06:43:23 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #33 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SSP0200\calls\_verify_텍스트_부분_삭제_Insert_행_Div_변경_E6_D1__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "fromSite": "ALL", "erpSoNo": "", "itemId": "", "fromYyyymmdd": "Invalid Date", "toYyyymmdd": "Invalid Date", "status": "ALL", "changeType": "C", "language": "KO", "debugMode": "F", "toSite": "ALL", "confirmId": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_from_site": "ALL", "p_erp_so_no": "", "p_item_id": "", "p_from_yyyymmdd": "Invalid Date", "p_to_yyyymmdd": "Invalid Date", "p_status": "ALL", "p_change_type": "C", "p_language": "KO", "debug_mode": "F", "p_to_site": "ALL", "p_confirm_id": ""}`
- SKIP: 인자 미해결(UNRESOLVED): fromYyyymmdd='Invalid Date'(E2E 입력 시험 중 포착된 호출 — 대조 대상 아님),toYyyymmdd='Invalid Date'(E2E 입력 시험 중 포착된 호출 — 대조 대상 아님) — param_map.csv 에 값/대응 지정
