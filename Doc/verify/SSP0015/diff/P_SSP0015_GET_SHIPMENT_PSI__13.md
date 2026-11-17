# SSP0015 · SSP0015_GET_SHIPMENT_PSI ↔ PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI

- 실행 2026-11-14 23:00:36 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 0행/TO-BE 87행(공통 0 · AS-IS 전용 0 · TO-BE 전용 87) · 셋2 AS-IS 0행/TO-BE 0행(공통 0 · AS-IS 전용 0 · TO-BE 전용 0) · 셋3 AS-IS 18행/TO-BE 18행(공통 18 · AS-IS 전용 0 · TO-BE 전용 0) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #13 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 105 · 원천 Doc\verify\SSP0015\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "fromSite": "", "itemId": "", "planStartYyyymmdd": "20261009", "planType": "SP", "fromYyyymmdd": "20261009", "toYyyymmdd": "20261109", "userId": "minyonglee1", "myModelChk": "N", "programId": "SSP0015", "sheetName": "Shipment PSI(Mobility & IT)", "debugMode": "F", "seq": "1", "partLeaderChk": "N", "teamLeaderChk": "N", "nonChk": "Y", "delegateeChk": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_from_site": "", "p_item_id": "", "p_plan_start_yyyymmdd": "20261009", "p_plan_type": "SP", "p_from_yyyymmdd": "20261009", "p_to_yyyymmdd": "20261109", "p_user_id": "minyonglee1", "p_myModelChk": "N", "p_program_id": "SSP0015", "p_sheet_name": "Shipment PSI(Mobility & IT)", "debug_mode": "F", "p_seq": "1", "p_partLeaderChk": "N", "p_teamLeaderChk": "N", "p_nonChk": "Y", "p_delegateeChk": "N"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "40", "p_from_site": "ALL", "p_item_id": "ALL", "p_plan_start_yyyymmdd": "20261009", "p_plan_type": "SP", "p_from_yyyymmdd": "20261009", "p_to_yyyymmdd": "20261109", "p_user_id": "minyonglee1", "p_myModelChk": "N", "p_program_id": "SSP0015", "p_sheet_name": "Shipment PSI(Mobility & IT)", "debug_mode": "F", "p_seq": "1", "p_partLeaderChk": "N", "p_teamLeaderChk": "N", "p_nonChk": "Y", "p_delegateeChk": "N"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 87행
- 행수 불일치 0 ↔ 87
- 값 차이: As-is 전용 0행 / To-Be 전용 87행 (공통 컬럼 61)
| 측 | DIVISION_ID | FROM_SITE | from_site_nm | PLAN_START_YYYYMMDD | PLAN_TYPE | ITEM_ID | ship_frozen | SEQ | nick_name | MEASURE | MEASURE_NAME | USER_SORT_ORDER_NO |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261009 | SP | MCBB45821-A1 | 0 | 1 | B1250 | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261009 | SP | MCC1124005A1 | 0 | 1 | E25 | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261009 | SP | MCCH114030D3 | 0 | 1 | H15 | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261009 | SP | MCCH129520B1-000 | 0 | 1 | HJ2 | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261009 | SP | MCCH318867A1T000 | 0 | 1 | H19 | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261009 | SP | MCCH318867A2T000 | 0 | 1 | H19T | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261009 | SP | MCCH335080B1T001 | 0 | 1 | H52B | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261009 | SP | MCCH335080B1T002 | 0 | 1 | H52B | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261009 | SP | MCCH350040A1-000 | 0 | 1 | H52A | SHIP_CONFIRM | Shipment Confirm | 1 |
| T | 40 | HQ06-A | LGESOC Cell HQ06 | 20261009 | SP | MCCH350040A1T001 | 0 | 1 | H52A | SHIP_CONFIRM | Shipment Confirm | 1 |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 87행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 2  As-is 0행 ↔ To-Be O_RC2 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 3  As-is 18행 ↔ To-Be O_RC3 18행
- 일치
- 데이터 기준: 공통 18행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 18행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['40', 'HQ06-A', 'MCCH350040A1T001', '2026-10-10', 'Prod Qty(MASS) : 0'] ↔ TO-BE=['40', 'HQ06-A', 'MCCM350415A1', '2026-10-13', 'oWMS Qty : 205,140']
