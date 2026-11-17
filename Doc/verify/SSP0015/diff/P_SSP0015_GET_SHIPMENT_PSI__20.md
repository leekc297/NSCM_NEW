# SSP0015 · SSP0015_GET_SHIPMENT_PSI ↔ PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI

- 실행 2026-11-14 23:00:36 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 0행/TO-BE 90행(공통 0 · AS-IS 전용 0 · TO-BE 전용 90) · 셋2 AS-IS 7행/TO-BE 18행(공통 2 · AS-IS 전용 5 · TO-BE 전용 16) · 셋3 AS-IS 23행/TO-BE 23행(공통 23 · AS-IS 전용 0 · TO-BE 전용 0) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #20 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 131 · 원천 Doc\verify\SSP0015\calls\_verify_선택_조회_복수_단일_전체_왕복_G2_B6__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "fromSite": "NJ01-P,HQ06-A", "itemId": "", "planStartYyyymmdd": "20261010", "planType": "SP", "fromYyyymmdd": "20261010", "toYyyymmdd": "20261110", "userId": "minyonglee1", "myModelChk": "N", "programId": "SSP0015", "sheetName": "Shipment PSI(Mobility & IT)", "debugMode": "F", "seq": "1", "partLeaderChk": "N", "teamLeaderChk": "N", "nonChk": "Y", "delegateeChk": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_from_site": "NJ01-P,HQ06-A", "p_item_id": "", "p_plan_start_yyyymmdd": "20261010", "p_plan_type": "SP", "p_from_yyyymmdd": "20261010", "p_to_yyyymmdd": "20261110", "p_user_id": "minyonglee1", "p_myModelChk": "N", "p_program_id": "SSP0015", "p_sheet_name": "Shipment PSI(Mobility & IT)", "debug_mode": "F", "p_seq": "1", "p_partLeaderChk": "N", "p_teamLeaderChk": "N", "p_nonChk": "Y", "p_delegateeChk": "N"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "40", "p_from_site": "NJ01-P,HQ06-A", "p_item_id": "ALL", "p_plan_start_yyyymmdd": "20261010", "p_plan_type": "SP", "p_from_yyyymmdd": "20261010", "p_to_yyyymmdd": "20261110", "p_user_id": "minyonglee1", "p_myModelChk": "N", "p_program_id": "SSP0015", "p_sheet_name": "Shipment PSI(Mobility & IT)", "debug_mode": "F", "p_seq": "1", "p_partLeaderChk": "N", "p_teamLeaderChk": "N", "p_nonChk": "Y", "p_delegateeChk": "N"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 90행
- 행수 불일치 0 ↔ 90
- 값 차이: As-is 전용 0행 / To-Be 전용 90행 (공통 컬럼 61)
| 측 | DIVISION_ID | FROM_SITE | from_site_nm | PLAN_START_YYYYMMDD | PLAN_TYPE | ITEM_ID | ship_frozen | SEQ | nick_name | MEASURE | MEASURE_NAME | USER_SORT_ORDER_NO |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCBB45821-A1 | 0 | 1 | B1250 | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCC1124005A1 | 0 | 1 | E25 | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCCH114030D3 | 0 | 1 | H15 | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCCH129520B1-000 | 0 | 1 | HJ2 | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCCH318867A1T000 | 0 | 1 | H19 | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCCH318867A2T000 | 0 | 1 | H19T | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCCH335080B1T001 | 0 | 1 | H52B | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCCH335080B1T002 | 0 | 1 | H52B | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCCH350040A1-000 | 0 | 1 | H52A | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCCH350040A1T001 | 0 | 1 | H52A | SHIP_CONFIRM | Shipment Confirm | 1 |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 90행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 2  As-is 7행 ↔ To-Be O_RC2 18행
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

### 결과셋 3  As-is 23행 ↔ To-Be O_RC3 23행
- 일치
- 데이터 기준: 공통 23행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 23행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['40', 'HQ06-A', 'MCCH350040A2-000', '2026-10-22', 'Prod Qty(MASS) : 0'] ↔ TO-BE=['40', 'HQ06-A', 'MCCM356015A2', '2026-10-29', 'Prod Qty(MASS) : 0']
