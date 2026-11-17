# SSP0060 · SCP0009_GET_SHEET_CALENDAR_3SPAN ↔ PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN

- 실행 2026-11-15 05:23:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #31 sheet=calendar btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SSP0060\calls\_verify_텍스트_부분_삭제_Insert_행_Div_변경_E6_D1__0.json
- TO-BE 인자(FE 본문): `{"startYyyymmdd": "Invalid Date", "endYyyymmdd": "20261023"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_start_yyyymmdd": "Invalid Date", "p_end_yyyymmdd": "20261023"}`
- SKIP: 인자 미해결(UNRESOLVED): startYyyymmdd='Invalid Date'(E2E 입력 시험 중 포착된 호출 — 대조 대상 아님) — param_map.csv 에 값/대응 지정
