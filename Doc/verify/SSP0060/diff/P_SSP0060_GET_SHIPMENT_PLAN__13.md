# SSP0060 · SSP0060_GET_SHIPMENT_PLAN ↔ PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN

- 실행 2026-11-15 05:23:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 MEASURE+MEASURE_NAME+BOH_TYPE+nick_name+ITEM_ID+TO_SITE+FCST_TYPE) — AS-IS 13행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 auto · 키 MEASURE+MEASURE_NAME+BOH_TYPE+nick_name+ITEM_ID+TO_SITE+FCST_TYPE · golden 집합 판정 DIFF
- 호출 #13 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 6 · 원천 Doc\verify\SSP0060\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "companyId": "GM00", "fromSite": "", "planStartYyyymmdd": "20261008", "fromYyyymmdd": "20261008", "toYyyymmdd": "20261022", "itemId": "", "productLevel1": "", "userId": "minyonglee1", "programId": "SSP0060", "sheetName": "Shipment Plan", "realFlag": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_company_id": "GM00", "p_from_site": "", "p_plan_start_yyyymmdd": "20261008", "p_from_yyyymmdd": "20261008", "p_to_yyyymmdd": "20261022", "p_item_id": "", "p_product_level1": "", "p_user_id": "minyonglee1", "p_program_id": "SSP0060", "p_sheet_name": "Shipment Plan", "p_real_flag": "N"}`

### 결과셋 1  As-is 13행 ↔ To-Be O_RC1 0행
- 행수 불일치 13 ↔ 0
- 값 차이: As-is 전용 13행 / To-Be 전용 0행 (공통 컬럼 39)
| 측 | DIVISION_ID | FROM_SITE | from_site_description | PRODUCT_LEVEL1 | nick_name | ITEM_ID | BOH_TYPE | BOH_QTY | PSI | MEASURE | MEASURE_NAME | TO_SITE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | JF2-H00 | ECE1592F1-01-H00 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] | US02279100_82-P |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | JF2-H00 | ECE1592F1-01-H00 |  |  | S | SHIP_REQ | Shipment Request |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | JF2-H00 | ECE1592F1-01-H00 | BOH | 98 | I | BALANCE | Balance |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | JF2-H00 | ECE1592F1-01-H00 | ERP | 98 | P | PROD_PLAN | Production |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | JF2-H00 | ECE1592F1-01-H00 | MES | 0 | S | CONTAINER | Container Qty |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | JF2-H00 | ECE1592F1-01-H00 | oWMS | 98 | S | INTN_MOVEMENT | Internal movement |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | JF2-H01 | ECE1592F1-01-H01 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] | US02279100_82-P |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | JF2-H01 | ECE1592F1-01-H01 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] | US02279100_82-P |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | JF2-H01 | ECE1592F1-01-H01 |  |  | S | SHIP_REQ | Shipment Request |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | JF2-H01 | ECE1592F1-01-H01 | BOH | 94668 | I | BALANCE | Balance |  |
- 데이터 기준: 공통 0행 · AS-IS 전용 13행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 2  As-is 6행 ↔ To-Be O_RC2 6행
- 일치
- 데이터 기준: 공통 6행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 6행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['82', 'VP_GM01-A', 'ECE1592F1-01-H00', 'US02279100_82-P', 'TRK', 'FCA'] ↔ TO-BE=['82', 'VP_GM01-A', 'ECE1592F1-01-H01', 'US02279100_82-P', 'TRK', 'FCA']
