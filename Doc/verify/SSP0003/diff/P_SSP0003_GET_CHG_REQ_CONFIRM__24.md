# SSP0003 · SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM ↔ PKG_SSP0003.P_SSP0003_GET_CHG_REQ_CONFIRM

- 실행 2026-11-14 20:01:46 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #24 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SSP0003\calls\_verify_필터_항목_연속_조회_본문_K1_G6__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,EE_HD,EE_HG,EE_HM,EE_ST,EE_UC", "fromSite": "ALL", "requestId": "E2E", "fromYyyymmdd": "Invalid Date", "toYyyymmdd": "Invalid Date", "status": "D", "language": "KO", "itemId": "", "changeType": "ALL"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,EE_HD,EE_HG,EE_HM,EE_ST,EE_UC", "p_from_site": "", "p_request_id": "E2E", "p_from_yyyymmdd": "Invalid Date", "p_to_yyyymmdd": "Invalid Date", "p_status": "D", "p_language": "KO", "p_item_id": "", "p_change_type": ""}` · 번역 메모: p_from_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_change_type: 'ALL'→''(all_semantics: 빈 값 = 전체)
- SKIP: 인자 미해결(UNRESOLVED): fromYyyymmdd='Invalid Date'(E2E 입력 시험 중 포착된 호출 — 대조 대상 아님),toYyyymmdd='Invalid Date'(E2E 입력 시험 중 포착된 호출 — 대조 대상 아님) — param_map.csv 에 값/대응 지정
