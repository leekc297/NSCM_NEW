# SSP0005 · SSP0005_GET_SHIPMENT_WORKING_DAY ↔ PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY

- 실행 2026-11-14 22:20:17 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #14 sheet=Shipment Working Day btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SSP0005\calls\_verify_레이아웃_조회_묶음_H4_N1_G1_L2__0.json
- TO-BE 인자(FE 본문): `{"fromYyyymmdd": "Invalid Date", "toYyyymmdd": "Invalid Date", "divisionId": "81_HG", "companyId": "AA00", "debugMode": "F"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_from_yyyymmdd": "Invalid Date", "p_to_yyyymmdd": "Invalid Date", "p_division_id": "81_HG", "p_company_id": "AA00", "debug_mode": "F"}`
- SKIP: 인자 미해결(UNRESOLVED): fromYyyymmdd='Invalid Date'(E2E 입력 시험 중 포착된 호출 — 대조 대상 아님),toYyyymmdd='Invalid Date'(E2E 입력 시험 중 포착된 호출 — 대조 대상 아님) — param_map.csv 에 값/대응 지정
