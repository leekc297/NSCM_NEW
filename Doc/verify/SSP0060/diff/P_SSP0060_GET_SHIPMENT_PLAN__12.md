# SSP0060 · SSP0060_GET_SHIPMENT_PLAN ↔ PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN

- 실행 2026-11-15 05:23:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 19행 중 불일치 셀 28 — diff/P_SSP0060_GET_SHIPMENT_PLAN__12.csv · 키 원천 auto · 키 MEASURE+MEASURE_NAME+BOH_TYPE+ITEM_ID+nick_name+FCST_TYPE · golden 집합 판정 DIFF
- 호출 #12 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 24 · 원천 Doc\verify\SSP0060\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "companyId": "GM00", "fromSite": "VP_GM01-A", "planStartYyyymmdd": "20261009", "fromYyyymmdd": "20261009", "toYyyymmdd": "20261023", "itemId": "", "productLevel1": "", "userId": "minyonglee1", "programId": "SSP0060", "sheetName": "Shipment Plan", "realFlag": "Y"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_company_id": "GM00", "p_from_site": "VP_GM01-A", "p_plan_start_yyyymmdd": "20261009", "p_from_yyyymmdd": "20261009", "p_to_yyyymmdd": "20261023", "p_item_id": "", "p_product_level1": "", "p_user_id": "minyonglee1", "p_program_id": "SSP0060", "p_sheet_name": "Shipment Plan", "p_real_flag": "Y"}`

### 결과셋 1  As-is 21행 ↔ To-Be O_RC1 19행
- 행수 불일치 21 ↔ 19
- 값 차이: As-is 전용 9행 / To-Be 전용 7행 (공통 컬럼 54)
| 측 | DIVISION_ID | FROM_SITE | from_site_description | PRODUCT_LEVEL1 | ITEM_ID | nick_name | BOH_TYPE | BOH_QTY | PSI | MEASURE | MEASURE_NAME | TO_SITE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_SHIP_PLAN | Total Shipment Plan[R+P] |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 |  |  | S | SHIP_REQ | Shipment Request |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 | BOH | 98 | I | BALANCE | Balance |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 | ERP | 98 | P | PROD_PLAN | Production |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H01 | JF2-H01 |  |  | S | SHIP_REQ | Shipment Request |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H01 | JF2-H01 | ERP | 133574 | P | PROD_PLAN | Production |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_SHIP_PLAN | Total Shipment Plan[R+P] |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 | BOH | 98 | I | BALANCE | Balance |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 | ERP | 0 | P | PROD_PLAN | Production |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H01 | JF2-H01 | ERP | 0 | P | PROD_PLAN | Production |  |
- 데이터 기준: 공통 12행 · AS-IS 전용 9행 · TO-BE 전용 7행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 12행의 상대 순서): 일치

### 결과셋 2  As-is 5행 ↔ To-Be O_RC2 5행
- 일치
- 데이터 기준: 공통 5행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 5행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['82', 'VP_GM01-A', 'ECE1592F1-01-H00', 'US02279100_82-P', 'TRK', 'FCA'] ↔ TO-BE=['82', 'VP_GM01-A', 'ECE1592F1-01-H01', 'US02279100_82-P', 'TRK', 'FCA']

## 불일치 셀(≤50) — diff/P_SSP0060_GET_SHIPMENT_PLAN__12.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| PROD_PLAN|Production|ERP|ECE1592F1-01-H00|JF2-H00| | BOH_QTY | 98 | 0 |
| PROD_PLAN|Production|ERP|ECE1592F1-01-H01|JF2-H01| | BOH_QTY | 133574 | 0 |
| SHIP_PLAN|Shipment Plan[R+P]||ECE1592F1-01-H00|JF2-H00| | M_202610 | 559776 | 87808 |
| BALANCE|Balance|BOH|ECE1592F1-01-H00|JF2-H00| | M_202610 | -2281538 | -437570 |
| TOT_SHIP_REQ|Total Shipment Request|||| | M_202610 | 1053696 | 581728 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]|||| | M_202610 | 1322608 | 850640 |
| TOT_BALANCE|Total Balance|||| | M_202610 | -4120682 | -2276714 |
| SHIP_PLAN|Shipment Plan[R+P]||ECE1592F1-01-H00|JF2-H00| | W_20261043 | 559776 | 87808 |
| BALANCE|Balance|BOH|ECE1592F1-01-H00|JF2-H00| | W_20261043 | -2282518 | -438550 |
| TOT_SHIP_REQ|Total Shipment Request|||| | W_20261043 | 515872 | 43904 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]|||| | W_20261043 | 559776 | 87808 |
| TOT_BALANCE|Total Balance|||| | W_20261043 | -2351483 | -507515 |
| SHIP_PLAN|Shipment Plan[R+P]||ECE1592F1-01-H00|JF2-H00| | D_20261019 | 43904 | 87808 |
| BALANCE|Balance|BOH|ECE1592F1-01-H00|JF2-H00| | D_20261019 | -43806 | -87710 |
| TOT_SHIP_REQ|Total Shipment Request|||| | D_20261019 | 0 | 43904 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]|||| | D_20261019 | 43904 | 87808 |
| TOT_BALANCE|Total Balance|||| | D_20261019 | -216139 | -260043 |
| SHIP_PLAN|Shipment Plan[R+P]||ECE1592F1-01-H00|JF2-H00| | D_20261020 | 515872 | 0 |
| BALANCE|Balance|BOH|ECE1592F1-01-H00|JF2-H00| | D_20261020 | -559678 | -87710 |
| TOT_SHIP_REQ|Total Shipment Request|||| | D_20261020 | 515872 | 0 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]|||| | D_20261020 | 515872 | 0 |
| TOT_BALANCE|Total Balance|||| | D_20261020 | -652741 | -180773 |
| BALANCE|Balance|BOH|ECE1592F1-01-H00|JF2-H00| | D_20261021 | -559678 | -87710 |
| TOT_BALANCE|Total Balance|||| | D_20261021 | -573471 | -101503 |
| BALANCE|Balance|BOH|ECE1592F1-01-H00|JF2-H00| | D_20261022 | -559678 | -87710 |
| TOT_BALANCE|Total Balance|||| | D_20261022 | -494201 | -22233 |
| BALANCE|Balance|BOH|ECE1592F1-01-H00|JF2-H00| | D_20261023 | -559678 | -87710 |
| TOT_BALANCE|Total Balance|||| | D_20261023 | -414931 | 57037 |
