# SSP0021 · SSP0002_GET_USER_INFO_LIST ↔ PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST

- 실행 2026-11-15 02:40:13 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #2 sheet=main btn=USER_CHECK user=minyonglee1 FE 응답 행 2 · 원천 Doc\verify\SSP0021\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"userId": "minyonglee1", "language": "KO", "ssoUserYn": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"Language": "KO", "SSOUserYN": "N", "Search": ""}`
- SKIP: 인자 미해결(UNRESOLVED): Search — param_map.csv 에 값/대응 지정
