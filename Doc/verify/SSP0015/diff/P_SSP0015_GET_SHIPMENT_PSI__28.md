# SSP0015 · SSP0015_GET_SHIPMENT_PSI ↔ PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI

- 실행 2026-11-14 23:00:36 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 0행/TO-BE 2행(공통 0 · AS-IS 전용 0 · TO-BE 전용 2) · 셋2 AS-IS 6행/TO-BE 13행(공통 1 · AS-IS 전용 5 · TO-BE 전용 12) · 셋3 AS-IS 0행/TO-BE 0행(공통 0 · AS-IS 전용 0 · TO-BE 전용 0) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #28 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 15 · 원천 Doc\verify\SSP0015\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "fromSite": "", "itemId": "MCBB45821-A1,MCC1124005A1", "planStartYyyymmdd": "20261010", "planType": "SP", "fromYyyymmdd": "20261010", "toYyyymmdd": "20261110", "userId": "minyonglee1", "myModelChk": "N", "programId": "SSP0015", "sheetName": "Shipment PSI(Mobility & IT)", "debugMode": "F", "seq": "1", "partLeaderChk": "N", "teamLeaderChk": "N", "nonChk": "Y", "delegateeChk": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_from_site": "", "p_item_id": "MCBB45821-A1,MCC1124005A1", "p_plan_start_yyyymmdd": "20261010", "p_plan_type": "SP", "p_from_yyyymmdd": "20261010", "p_to_yyyymmdd": "20261110", "p_user_id": "minyonglee1", "p_myModelChk": "N", "p_program_id": "SSP0015", "p_sheet_name": "Shipment PSI(Mobility & IT)", "debug_mode": "F", "p_seq": "1", "p_partLeaderChk": "N", "p_teamLeaderChk": "N", "p_nonChk": "Y", "p_delegateeChk": "N"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "40", "p_from_site": "ALL", "p_item_id": "MCBB45821-A1,MCC1124005A1", "p_plan_start_yyyymmdd": "20261010", "p_plan_type": "SP", "p_from_yyyymmdd": "20261010", "p_to_yyyymmdd": "20261110", "p_user_id": "minyonglee1", "p_myModelChk": "N", "p_program_id": "SSP0015", "p_sheet_name": "Shipment PSI(Mobility & IT)", "debug_mode": "F", "p_seq": "1", "p_partLeaderChk": "N", "p_teamLeaderChk": "N", "p_nonChk": "Y", "p_delegateeChk": "N"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 2행
- 행수 불일치 0 ↔ 2
- 값 차이: As-is 전용 0행 / To-Be 전용 2행 (공통 컬럼 61)
| 측 | DIVISION_ID | FROM_SITE | from_site_nm | PLAN_START_YYYYMMDD | PLAN_TYPE | ITEM_ID | ship_frozen | SEQ | nick_name | MEASURE | MEASURE_NAME | USER_SORT_ORDER_NO |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCBB45821-A1 | 0 | 1 | B1250 | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261010 | SP | MCC1124005A1 | 0 | 1 | E25 | SHIP_CONFIRM | Shipment Confirm | 1 |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 2행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 2  As-is 6행 ↔ To-Be O_RC2 13행
- 행수 불일치 6 ↔ 13
- 값 차이: As-is 전용 5행 / To-Be 전용 12행 (공통 컬럼 13)
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
- 데이터 기준: 공통 1행 · AS-IS 전용 5행 · TO-BE 전용 12행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 3  As-is 0행 ↔ To-Be O_RC3 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
