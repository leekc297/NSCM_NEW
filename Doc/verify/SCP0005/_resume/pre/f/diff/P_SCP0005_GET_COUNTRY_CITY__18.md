# SCP0005 · SCP0005_GET_COUNTRY_CITY ↔ PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY

- 실행 2026-11-26 02:25:30 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 1행 전 컬럼 일치 · 키 원천 db_resultsets.csv is_nullable=0 · 키 COUNTRY+CITY+CITY_NAME · golden 집합 판정 PASS
- 호출 #18 sheet=route btn=SEARCH_CITY user=minyonglee1 FE 응답 행 2 · 원천 Doc\verify\SCP0005\calls\_verify_저장_세부_F1_F6_컬럼별_왕복_0_값_저장_0.json
- TO-BE 인자(FE 본문): `{"country": "", "city": "PLWRO", "cityName": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}` · 같은 본문의 세션 조합 2종 중 최다(2회) 사용 — 나머지 [{'sesLangCd': 'KO', 'sesUserId': 'cnsytchoi'}]
- AS-IS 인자(번역): `{"p_country": "", "p_city": "PLWRO", "p_city_name": "", "debug_mode": "F"}`

### 결과셋 1  As-is 1행 ↔ To-Be O_RC 1행
- 일치
- 데이터 기준: 공통 1행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1행의 상대 순서 · AS-IS ORDER BY 키 COUNTRY,CITY,CITY_NAME 기준 · 키 동률 묶음 0개(0행)는 묶음 안 순서가 AS-IS 에서 정해지지 않아 집합으로 비교): 비교 불가(공통 행 2 미만)
