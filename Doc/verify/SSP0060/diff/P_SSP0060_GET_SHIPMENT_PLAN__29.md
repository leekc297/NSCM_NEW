# SSP0060 · SSP0060_GET_SHIPMENT_PLAN ↔ PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN

- 실행 2026-11-15 05:23:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 0행/TO-BE 19행(공통 0 · AS-IS 전용 0 · TO-BE 전용 19) · 셋2 AS-IS 0행/TO-BE 5행(공통 0 · AS-IS 전용 0 · TO-BE 전용 5) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #29 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 24 · 원천 Doc\verify\SSP0060\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "companyId": "GM00", "fromSite": "", "planStartYyyymmdd": "20261009", "fromYyyymmdd": "20261009", "toYyyymmdd": "20261023", "itemId": "CE1592F1-01-H0", "productLevel1": "", "userId": "minyonglee1", "programId": "SSP0060", "sheetName": "Shipment Plan", "realFlag": "Y"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_company_id": "GM00", "p_from_site": "", "p_plan_start_yyyymmdd": "20261009", "p_from_yyyymmdd": "20261009", "p_to_yyyymmdd": "20261023", "p_item_id": "CE1592F1-01-H0", "p_product_level1": "", "p_user_id": "minyonglee1", "p_program_id": "SSP0060", "p_sheet_name": "Shipment Plan", "p_real_flag": "Y"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "82", "p_company_id": "GM00", "p_from_site": "ALL", "p_plan_start_yyyymmdd": "20261009", "p_from_yyyymmdd": "20261009", "p_to_yyyymmdd": "20261023", "p_item_id": "CE1592F1-01-H0", "p_product_level1": "ALL", "p_user_id": "minyonglee1", "p_program_id": "SSP0060", "p_sheet_name": "Shipment Plan", "p_real_flag": "Y"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 19행
- 행수 불일치 0 ↔ 19
- 값 차이: As-is 전용 0행 / To-Be 전용 19행 (공통 컬럼 54)
| 측 | DIVISION_ID | FROM_SITE | from_site_description | PRODUCT_LEVEL1 | ITEM_ID | nick_name | BOH_TYPE | BOH_QTY | PSI | MEASURE | MEASURE_NAME | TO_SITE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | P | TOT_PROD_PLAN | Total Production |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_CONTAINER | Total Container Qty |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_INTN_MOVEMENT | Total Internal movement |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_SHIP_PLAN | Total Shipment Plan[R+P] |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 |  |  | S | SHIP_PLAN_DETAIL | Shipment Plan | US02279100_82-P |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 | BOH | 98 | I | BALANCE | Balance |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 | ERP | 0 | P | PROD_PLAN | Production |  |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 19행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 2  As-is 0행 ↔ To-Be O_RC2 5행
- 행수 불일치 0 ↔ 5
- 값 차이: As-is 전용 0행 / To-Be 전용 5행 (공통 컬럼 11)
| 측 | DIVISION_ID | FROM_SITE | ITEM_ID | TO_SITE | TRANSPORT_MODE | INCOTERMS | FCST_TYPE | YYYYMMDD | QTY | NOEDIT_QTY | NOTE |
|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 82 | VP_GM01-A | ECE1592F1-01-H00 | US02279100_82-P | TRK | FCA | - | 20261019 | 43904 | 0 | Input Qty(Min) : 0 |
| T | 82 | VP_GM01-A | ECE1592F1-01-H01 | US02279100_82-P | TRK | FCA | - | 20261013 | 537824 | 0 | Input Qty(Min) : 0 |
| T | 82 | VP_GM01-A | ECE1592F1-01-H01 | US02279100_82-P | TRK | FCA | MPS | 20261009 | 71344 | 0 | Input Qty(Min) : 0 |
| T | 82 | VP_GM01-A | ECE1592F1-01-H01 | US02279100_82-P | TRK | FCA | MPS | 20261010 | 76832 | 0 | Input Qty(Min) : 0 |
| T | 82 | VP_GM01-A | ECE1592F1-01-H01 | US02279100_82-P | TRK | FCA | MPS | 20261011 | 76832 | 0 | Input Qty(Min) : 0 |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 5행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
