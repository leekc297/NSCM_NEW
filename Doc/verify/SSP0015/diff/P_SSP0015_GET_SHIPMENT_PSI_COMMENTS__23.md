# SSP0015 · SSP0015_GET_SHIPMENT_PSI_COMMENTS ↔ PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_COMMENTS

- 실행 2026-11-14 23:00:36 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 5행 중 불일치 셀 21 — diff/P_SSP0015_GET_SHIPMENT_PSI_COMMENTS__23.csv · 키 원천 auto · 키 YYYYMMDD · golden 집합 판정 DIFF
- 호출 #23 sheet=main btn=GET_SHIPMENT_PSI_COMMENTS user=minyonglee1 FE 응답 행 9 · 원천 Doc\verify\SSP0015\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "planStartYyyymmdd": "20261010", "fromSite": "", "itemId": "mcbb45821-a1", "fromYyyymmdd": "20261010", "toYyyymmdd": "20261110"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_plan_start_yyyymmdd": "20261010", "p_from_site": "", "p_item_id": "mcbb45821-a1", "p_from_yyyymmdd": "20261010", "p_to_yyyymmdd": "20261110"}`

### 결과셋 1  As-is 5행 ↔ To-Be O_RC1 9행
- 행수 불일치 5 ↔ 9
- 값 차이: As-is 전용 5행 / To-Be 전용 9행 (공통 컬럼 13)
| 측 | DIVISION_ID | SITE | FROM_SITE_NM | nick_name | ITEM_ID | YYYYMMDD | USER_ADD_QTY | QTY | BEFORE_QTY | GAP | COMMENTS | LAST_UPDATED_BY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-10-10 | 11 | 11 | 0 | 11 |  |  |
| A | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-10-11 | 11 | 11 | 0 | 11 |  |  |
| A | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-10-12 | 11 | 11 | 0 | 11 |  |  |
| A | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-10-13 | 12 | 12 | 11 | 1 |  |  |
| A | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-10-14 | 300 | 300 | 0 | 300 | test 300 |  |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-10-10 | 12 | 12 | 13 | -1 |  |  |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-10-11 | 3 | 3 | 1 | 2 |  |  |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-10-12 | 4 | 4 | 2 | 2 |  |  |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-10-13 | 3 | 3 | 12 | -9 |  |  |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-10-14 | 4 | 4 | 300 | -296 |  |  |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-10-15 | 5 | 5 | 0 | 5 |  |  |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-11-02 | 1 | 1 | 0 | 1 |  |  |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-11-03 | 2 | 2 | 0 | 2 |  |  |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | B1250 | MCBB45821-A1 | 2026-11-04 | 3 | 3 | 0 | 3 |  |  |
- 데이터 기준: 공통 0행 · AS-IS 전용 5행 · TO-BE 전용 9행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
- A7 공란 컬럼(AS-IS 값 있음 · TO-BE 전 행 공란): COMMENTS

### 결과셋 2  As-is 0행 ↔ To-Be O_RC2 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

## 불일치 셀(≤50) — diff/P_SSP0015_GET_SHIPMENT_PSI_COMMENTS__23.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 2026-10-10 | USER_ADD_QTY | 11 | 12 |
| 2026-10-11 | USER_ADD_QTY | 11 | 3 |
| 2026-10-12 | USER_ADD_QTY | 11 | 4 |
| 2026-10-13 | USER_ADD_QTY | 12 | 3 |
| 2026-10-14 | USER_ADD_QTY | 300 | 4 |
| 2026-10-10 | QTY | 11 | 12 |
| 2026-10-11 | QTY | 11 | 3 |
| 2026-10-12 | QTY | 11 | 4 |
| 2026-10-13 | QTY | 12 | 3 |
| 2026-10-14 | QTY | 300 | 4 |
| 2026-10-10 | BEFORE_QTY | 0 | 13 |
| 2026-10-11 | BEFORE_QTY | 0 | 1 |
| 2026-10-12 | BEFORE_QTY | 0 | 2 |
| 2026-10-13 | BEFORE_QTY | 11 | 12 |
| 2026-10-14 | BEFORE_QTY | 0 | 300 |
| 2026-10-10 | GAP | 11 | -1 |
| 2026-10-11 | GAP | 11 | 2 |
| 2026-10-12 | GAP | 11 | 2 |
| 2026-10-13 | GAP | 1 | -9 |
| 2026-10-14 | GAP | 300 | -296 |
| 2026-10-14 | COMMENTS | test 300 |  |
