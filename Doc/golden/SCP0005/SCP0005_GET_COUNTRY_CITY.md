# SCP0005 · SCP0005_GET_COUNTRY_CITY ↔ PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY

- 실행: 2026-11-19 14:03:02
- 파라미터: `{"p_country": "", "p_city": "", "p_city_name": "", "debug_mode": "F"}`
- 종류: GET

### 결과셋 1  As-is 89426행 ↔ To-Be O_RC 89431행
- 행수 불일치 89426 ↔ 89431
- 값 차이: As-is 전용 1행 / To-Be 전용 6행 (공통 컬럼 3)
| 측 | COUNTRY | CITY | CITY_NAME |
|---|---|---|---|
| A | PK | PKQCT |  |
| T | AJ | AJTES | AGAINTESTCITY |
| T | AK | AKTES | AGAINTESTCITY2 |
| T | AP | APTES | AGAINTESTCITY3 |
| T | AV | AVTES | AGAINTESTCITY4 |
| T | AY | AYTES | TESTCITY6 |
| T | PK | PKQCT | / |
- 데이터 기준: 공통 89426행 · AS-IS 전용 0행 · TO-BE 전용 5행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 89426행의 상대 순서): 일치 · 센티널 차이 컬럼 CITY_NAME(1행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)
