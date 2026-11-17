# SSP0015 · SSP0015_GET_SHIPMENT_PSI_COMMENTS ↔ PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_COMMENTS

- 실행 2026-11-14 23:00:36 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 7행 중 불일치 셀 21 — diff/P_SSP0015_GET_SHIPMENT_PSI_COMMENTS__9.csv · 키 원천 auto · 키 YYYYMMDD+nick_name · golden 집합 판정 DIFF
- 호출 #9 sheet=main btn=GET_SHIPMENT_PSI_COMMENTS user=minyonglee1 FE 응답 행 41 · 원천 Doc\verify\SSP0015\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "planStartYyyymmdd": "20261010", "fromSite": "AC00-A,AT00-A,AZ00-A,HQ10-A,NJ01-P,NJ01-A,HQ06-A,HQ05_40-W", "itemId": "", "fromYyyymmdd": "20261010", "toYyyymmdd": "20261110"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_plan_start_yyyymmdd": "20261010", "p_from_site": "AC00-A,AT00-A,AZ00-A,HQ10-A,NJ01-P,NJ01-A,HQ06-A,HQ05_40-W", "p_item_id": "", "p_from_yyyymmdd": "20261010", "p_to_yyyymmdd": "20261110"}`

### 결과셋 1  As-is 7행 ↔ To-Be O_RC1 18행
- 행수 불일치 7 ↔ 18
- 값 차이: As-is 전용 5행 / To-Be 전용 16행 (공통 컬럼 13)
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
| T | 40 | HQ06-A | LGESOC Cell HQ06 | E25 | MCC1124005A1 | 2026-11-02 | 1 | 1 | 0 | 1 |  |  |
- 데이터 기준: 공통 2행 · AS-IS 전용 5행 · TO-BE 전용 16행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 2행의 상대 순서): 일치

### 결과셋 2  As-is 23행 ↔ To-Be O_RC2 23행
- 일치
- 데이터 기준: 공통 23행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 23행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['40', 'HQ06-A', 'MCCH350040A2-000', '2026-10-22', 'Prod Qty(MASS) : 0'] ↔ TO-BE=['40', 'HQ06-A', 'MCCM356015A2', '2026-10-29', 'Prod Qty(MASS) : 0']

## 불일치 셀(≤50) — diff/P_SSP0015_GET_SHIPMENT_PSI_COMMENTS__9.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 2026-10-10|B1250 | USER_ADD_QTY | 11 | 12 |
| 2026-10-11|B1250 | USER_ADD_QTY | 11 | 3 |
| 2026-10-12|B1250 | USER_ADD_QTY | 11 | 4 |
| 2026-10-13|B1250 | USER_ADD_QTY | 12 | 3 |
| 2026-10-14|B1250 | USER_ADD_QTY | 300 | 4 |
| 2026-10-10|B1250 | QTY | 11 | 12 |
| 2026-10-11|B1250 | QTY | 11 | 3 |
| 2026-10-12|B1250 | QTY | 11 | 4 |
| 2026-10-13|B1250 | QTY | 12 | 3 |
| 2026-10-14|B1250 | QTY | 300 | 4 |
| 2026-10-10|B1250 | BEFORE_QTY | 0 | 13 |
| 2026-10-11|B1250 | BEFORE_QTY | 0 | 1 |
| 2026-10-12|B1250 | BEFORE_QTY | 0 | 2 |
| 2026-10-13|B1250 | BEFORE_QTY | 11 | 12 |
| 2026-10-14|B1250 | BEFORE_QTY | 0 | 300 |
| 2026-10-10|B1250 | GAP | 11 | -1 |
| 2026-10-11|B1250 | GAP | 11 | 2 |
| 2026-10-12|B1250 | GAP | 11 | 2 |
| 2026-10-13|B1250 | GAP | 1 | -9 |
| 2026-10-14|B1250 | GAP | 300 | -296 |
| 2026-10-14|B1250 | COMMENTS | test 300 |  |
