# SCP0005 · SCP0005_GET_COUNTRY_CITY ↔ PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY

- 실행: 2026-11-26 01:18:35
- 파라미터: `{"p_country": "", "p_city": "", "p_city_name": "", "debug_mode": "F"}`
- 종류: GET

### 결과셋 1  As-is 89426행 ↔ To-Be O_RC 89417행
- 행수 불일치 89426 ↔ 89417
- 값 차이: As-is 전용 10행 / To-Be 전용 1행 (공통 컬럼 3)
| 측 | COUNTRY | CITY | CITY_NAME |
|---|---|---|---|
| A | AA | AATES | TESTCITY |
| A | AB | AB | TESTCITY |
| A | AB | ABTES | TESTCITY2 |
| A | AC | AC | TESTCITY2 |
| A | AC | ACTES | TESTCIT3 |
| A | AH | AH | TESTCITY3 |
| A | AH | AHTES | TESTCITY4 |
| A | AZ | AZ | TESTCITY4 |
| A | HH | HH | TESTCITY5 |
| A | PK | PKQCT |  |
| T | PK | PKQCT | / |
- 데이터 기준: 공통 89417행 · AS-IS 전용 9행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 89417행의 상대 순서 · AS-IS ORDER BY 키 COUNTRY,CITY,CITY_NAME 기준 · 키 동률 묶음 0개(0행)는 묶음 안 순서가 AS-IS 에서 정해지지 않아 집합으로 비교): 일치 · 센티널 차이 컬럼 CITY_NAME(1행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)
