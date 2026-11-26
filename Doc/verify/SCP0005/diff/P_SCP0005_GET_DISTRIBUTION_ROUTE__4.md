# SCP0005 · SCP0005_GET_DISTRIBUTION_ROUTE ↔ PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE

- 실행 2026-11-26 02:25:30 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 8051행 전 컬럼 일치 · 단독행 AS-IS 0 / TO-BE 3 · 키 원천 cleanup_spec.json · 키 route_id · golden 집합 판정 DIFF
- 호출 #4 sheet=route btn=SEARCH user=minyonglee1 FE 응답 행 8055 · 원천 Doc\verify\SCP0005\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"fromCountry": "", "fromCity": "", "toCountry": "", "toCity": "", "transportMode": "", "validYn": "Y"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_from_country": "", "p_from_city": "", "p_to_country": "", "p_to_city": "", "p_transport_mode": "", "p_valid_yn": "Y"}`

### 결과셋 1  As-is 8051행 ↔ To-Be O_RC 8054행
- 행수 불일치 8051 ↔ 8054
- 값 차이: As-is 전용 342행 / To-Be 전용 345행 (공통 컬럼 41)
| 측 | route_id | from_country | from_city | from_city_name | transport_mode | transport_mode_name | priority | days_mon | days_tue | days_wed | days_thu | days_fri |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 100 | KR | KRCOJ | CHONGJU,KOREA, REPUBLIC OF | AIR | AIR | 4 | Y | Y | Y | Y | Y |
| A | 1000 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| A | 1006 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| A | 1015 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| A | 1020 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 2 | Y | Y | Y | Y | Y |
| A | 1026 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| A | 1029 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| A | 1035 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| A | 104 | KR | KRCOJ | CHONGJU,KOREA, REPUBLIC OF | AIR | AIR | 4 | Y | Y | Y | Y | Y |
| A | 1041 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| T | 100 | KR | KRCOJ | CHONGJU,KOREA, REPUBLIC OF | AIR | AIR | 4 | Y | Y | Y | Y | Y |
| T | 1000 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| T | 1006 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| T | 1015 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| T | 1020 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 2 | Y | Y | Y | Y | Y |
| T | 1026 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| T | 1029 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| T | 1035 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| T | 104 | KR | KRCOJ | CHONGJU,KOREA, REPUBLIC OF | AIR | AIR | 4 | Y | Y | Y | Y | Y |
| T | 1041 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
- 데이터 기준: 공통 8051행 · AS-IS 전용 0행 · TO-BE 전용 3행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 8051행의 상대 순서 · AS-IS ORDER BY 키 FROM_COUNTRY,FROM_CITY,TO_COUNTRY,TO_CITY,PRIORITY 기준 · 키 동률 묶음 32개(64행)는 묶음 안 순서가 AS-IS 에서 정해지지 않아 집합으로 비교): 일치 · 센티널 차이 컬럼 shipping_company(334행 AS-IS ''↔TO-BE '/'), a_port_name(8행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)
