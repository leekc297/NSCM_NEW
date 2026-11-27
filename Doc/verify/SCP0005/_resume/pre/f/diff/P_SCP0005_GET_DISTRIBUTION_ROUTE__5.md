# SCP0005 · SCP0005_GET_DISTRIBUTION_ROUTE ↔ PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE

- 실행 2026-11-26 02:25:30 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 25행 전 컬럼 일치 · 키 원천 cleanup_spec.json · 키 route_id · golden 집합 판정 PASS
- 호출 #5 sheet=route btn=SEARCH user=minyonglee1 FE 응답 행 26 · 원천 Doc\verify\SCP0005\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"fromCountry": "", "fromCity": "", "toCountry": "", "toCity": "", "transportMode": "", "validYn": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_from_country": "", "p_from_city": "", "p_to_country": "", "p_to_city": "", "p_transport_mode": "", "p_valid_yn": "N"}`

### 결과셋 1  As-is 25행 ↔ To-Be O_RC 25행
- 일치
- 데이터 기준: 공통 25행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 25행의 상대 순서 · AS-IS ORDER BY 키 FROM_COUNTRY,FROM_CITY,TO_COUNTRY,TO_CITY,PRIORITY 기준 · 키 동률 묶음 0개(0행)는 묶음 안 순서가 AS-IS 에서 정해지지 않아 집합으로 비교): 일치
