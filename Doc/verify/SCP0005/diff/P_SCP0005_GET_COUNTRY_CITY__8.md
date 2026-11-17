# SCP0005 · SCP0005_GET_COUNTRY_CITY ↔ PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY

- 실행 2026-11-14 07:23:24 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #8 sheet=route btn=SEARCH_CITY user=minyonglee1 FE 응답 행 2 · 원천 Doc\verify\SCP0005\calls\_verify_그리드_더블클릭_팝업_인자_G5_AS-IS_가_팝업에_넘기는_셀_값이_TO-BE_팝업_조회_요청에_들어가는지_0.json
- TO-BE 인자(FE 본문): `{"country": "", "city": "AATES", "cityName": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_country": "", "p_city": "AATES", "p_city_name": "", "debug_mode": ""}`
- SKIP: 인자 미해결(UNRESOLVED): debug_mode — param_map.csv 에 값/대응 지정
