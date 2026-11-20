# SCP0005 · SCP0005_GET_DISTRIBUTION_ROUTE ↔ PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE

- 실행 2026-11-20 07:26:50 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 2813행 중 불일치 셀 2 — diff/P_SCP0005_GET_DISTRIBUTION_ROUTE__5.csv · 키 원천 cleanup_spec.json · 키 route_id · golden 집합 판정 DIFF
- 호출 #5 sheet=route btn=SEARCH user=minyonglee1 FE 응답 행 2814 · 원천 Doc\verify\SCP0005\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"fromCountry": "", "fromCity": "", "toCountry": "", "toCity": "", "transportMode": "AIR", "validYn": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_from_country": "", "p_from_city": "", "p_to_country": "", "p_to_city": "", "p_transport_mode": "AIR", "p_valid_yn": ""}`

### 결과셋 1  As-is 2813행 ↔ To-Be O_RC 2813행
- 값 차이: As-is 전용 314행 / To-Be 전용 314행 (공통 컬럼 41)
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
- 데이터 기준: 공통 2812행 · AS-IS 전용 1행 · TO-BE 전용 1행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 2812행의 상대 순서): 불일치 — 첫 차이 r1446: AS-IS=['683', 'KR', 'KRCOJ', 'CHONGJU,KOREA, REPUB', 'AIR', 'AIR'] ↔ TO-BE=['650', 'KR', 'KRCOJ', 'CHONGJU,KOREA, REPUB', 'AIR', 'AIR'] · 센티널 차이 컬럼 shipping_company(309행 AS-IS ''↔TO-BE '/'), a_port_name(4행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)

## 불일치 셀(≤50) — diff/P_SCP0005_GET_DISTRIBUTION_ROUTE__5.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 7305 | from_country | CN | KR |
| 7305 | from_city_name | NANJING |  |
