# SCP0005 · SCP0005_GET_DISTRIBUTION_ROUTE ↔ PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE

- 실행: 2026-11-26 01:18:31
- 파라미터: `{"p_from_country": "", "p_from_city": "", "p_to_country": "", "p_to_city": "", "p_transport_mode": "", "p_valid_yn": ""}`
- 종류: GET

### 결과셋 1  As-is 8076행 ↔ To-Be O_RC 8079행
- 행수 불일치 8076 ↔ 8079
- 값 차이: As-is 전용 1688행 / To-Be 전용 1691행 (공통 컬럼 41)
| 측 | route_id | from_country | from_city | from_city_name | transport_mode | transport_mode_name | priority | days_mon | days_tue | days_wed | days_thu | days_fri |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 1 | KR | KRCOJ | CHONGJU,KOREA, REPUBLIC OF | SEA | SEA | 1 |  |  |  |  |  |
| A | 10 | KR | KRCOJ | CHONGJU,KOREA, REPUBLIC OF | SEA | SEA | 2 |  |  |  |  |  |
| A | 100 | KR | KRCOJ | CHONGJU,KOREA, REPUBLIC OF | AIR | AIR | 4 | Y | Y | Y | Y | Y |
| A | 1000 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| A | 1001 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | SEA | SEA | 1 |  | Y |  |  |  |
| A | 1002 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | SEA | SEA | 2 | Y |  |  |  |  |
| A | 1003 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| A | 1004 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | SEA | SEA | 1 |  |  |  |  | Y |
| A | 1005 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | SEA | SEA | 2 |  |  |  |  |  |
| A | 1006 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| T | 1 | KR | KRCOJ | CHONGJU,KOREA, REPUBLIC OF | SEA | SEA | 1 |  |  |  |  |  |
| T | 10 | KR | KRCOJ | CHONGJU,KOREA, REPUBLIC OF | SEA | SEA | 2 |  |  |  |  |  |
| T | 100 | KR | KRCOJ | CHONGJU,KOREA, REPUBLIC OF | AIR | AIR | 4 | Y | Y | Y | Y | Y |
| T | 1000 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| T | 1001 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | SEA | SEA | 1 |  | Y |  |  |  |
| T | 1002 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | SEA | SEA | 2 | Y |  |  |  |  |
| T | 1003 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
| T | 1004 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | SEA | SEA | 1 |  |  |  |  | Y |
| T | 1005 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | SEA | SEA | 2 |  |  |  |  |  |
| T | 1006 | KR | KRKUM | GUMI,KOREA, REPUBLIC OF | AIR | AIR | 3 | Y | Y | Y | Y | Y |
- 데이터 기준: 공통 8076행 · AS-IS 전용 0행 · TO-BE 전용 3행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 8076행의 상대 순서 · AS-IS ORDER BY 키 FROM_COUNTRY,FROM_CITY,TO_COUNTRY,TO_CITY,PRIORITY 기준 · 키 동률 묶음 32개(64행)는 묶음 안 순서가 AS-IS 에서 정해지지 않아 집합으로 비교): 일치 · 센티널 차이 컬럼 lt_type(1685행 AS-IS ''↔TO-BE '/'), shipping_company(334행 AS-IS ''↔TO-BE '/'), a_port_name(8행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)
