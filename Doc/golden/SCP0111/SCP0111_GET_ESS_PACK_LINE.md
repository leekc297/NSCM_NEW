# SCP0111 · SCP0111_GET_ESS_PACK_LINE ↔ PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE

- 실행: 2026-11-18 19:39:48
- 파라미터: `{}`
- 종류: GET

### 결과셋 1  As-is 32행 ↔ To-Be O_RC 50행
- 행수 불일치 32 ↔ 50
- 값 차이: As-is 전용 0행 / To-Be 전용 18행 (공통 컬럼 7)
| 측 | DIVISION_ID | SCM_SITE_ID | SITE_DESCRIPTION | COMPANY_ID | CODE | NAME | OPERATION_ID |
|---|---|---|---|---|---|---|---|
| T | 82 | CN00249500-P | Peopleworks_CN | NJ00 | C1D01 | 남경 피플웍스 B-Link Line 1 | CN00249500 |
| T | 82 | CN00249500-P | Peopleworks_CN | NJ00 | C1D01x | 남경 피플웍스 B-Link Line 1 - test | CN00249500 |
| T | 82 | CN00249500-P | Peopleworks_CN | NJ00 | C1P01 | 남경 피플웍스 Line 1 | CN00249500 |
| T | 82 | CN00249500-P | Peopleworks_CN | NJ00 | C1P02 | 남경 피플웍스 Line 2 | CN00249500 |
| T | 82 | CN00249500-P | Peopleworks_CN | NJ00 | C1P03 | 남경 피플웍스 Line 3 | CN00249500 |
| T | 82 | CN00249500-P | Peopleworks_CN | NJ00 | C1P04 | 남경 피플웍스 Line 4 | CN00249500 |
| T | 82 | CN00249500-P | Peopleworks_CN | NJ00 | C1P05 | 남경 피플웍스 Line 5 | CN00249500 |
| T | 82 | CN00249500-P | Peopleworks_CN | NJ00 | C1P06 | 남경 피플웍스 Line 6 | CN00249500 |
| T | 82 | CN00249500-P | Peopleworks_CN | NJ00 | C1P07 | 남경 피플웍스 Line 7 | CN00249500 |
| T | 82 | CN00249500-P | Peopleworks_CN | NJ00 | C1P08 | 남경 피플웍스 Line 8 | CN00249500 |
- 데이터 기준: 공통 32행 · AS-IS 전용 0행 · TO-BE 전용 18행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 32행의 상대 순서): 일치
