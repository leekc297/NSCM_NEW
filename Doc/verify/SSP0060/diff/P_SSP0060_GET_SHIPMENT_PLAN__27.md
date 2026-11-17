# SSP0060 · SSP0060_GET_SHIPMENT_PLAN ↔ PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN

- 실행 2026-11-15 05:23:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 12행 중 불일치 셀 29 — diff/P_SSP0060_GET_SHIPMENT_PLAN__27.csv · 키 원천 auto · 키 MEASURE · golden 집합 판정 DIFF
- 호출 #27 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 13 · 원천 Doc\verify\SSP0060\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "companyId": "GM00", "fromSite": "", "planStartYyyymmdd": "20261009", "fromYyyymmdd": "20261009", "toYyyymmdd": "20261023", "itemId": "ECE1592F1-01-H00", "productLevel1": "", "userId": "minyonglee1", "programId": "SSP0060", "sheetName": "Shipment Plan", "realFlag": "Y"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_company_id": "GM00", "p_from_site": "", "p_plan_start_yyyymmdd": "20261009", "p_from_yyyymmdd": "20261009", "p_to_yyyymmdd": "20261023", "p_item_id": "ECE1592F1-01-H00", "p_product_level1": "", "p_user_id": "minyonglee1", "p_program_id": "SSP0060", "p_sheet_name": "Shipment Plan", "p_real_flag": "Y"}`

### 결과셋 1  As-is 13행 ↔ To-Be O_RC1 12행
- 행수 불일치 13 ↔ 12
- 값 차이: As-is 전용 7행 / To-Be 전용 6행 (공통 컬럼 54)
| 측 | DIVISION_ID | FROM_SITE | from_site_description | PRODUCT_LEVEL1 | ITEM_ID | nick_name | BOH_TYPE | BOH_QTY | PSI | MEASURE | MEASURE_NAME | TO_SITE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_SHIP_PLAN | Total Shipment Plan[R+P] |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 |  |  | S | SHIP_REQ | Shipment Request |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 | BOH | 98 | I | BALANCE | Balance |  |
| A | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 | ERP | 98 | P | PROD_PLAN | Production |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_SHIP_PLAN | Total Shipment Plan[R+P] |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 | BOH | 98 | I | BALANCE | Balance |  |
| T | 82 | VP_GM01-A | virtual plant(GM01)-Cell | - | ECE1592F1-01-H00 | JF2-H00 | ERP | 0 | P | PROD_PLAN | Production |  |
- 데이터 기준: 공통 6행 · AS-IS 전용 7행 · TO-BE 전용 6행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 6행의 상대 순서): 일치

### 결과셋 2  As-is 1행 ↔ To-Be O_RC2 1행
- 일치
- 데이터 기준: 공통 1행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1행의 상대 순서): 비교 불가(공통 행 2 미만)

## 불일치 셀(≤50) — diff/P_SSP0060_GET_SHIPMENT_PLAN__27.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| PROD_PLAN | BOH_QTY | 98 | 0 |
| SHIP_PLAN | M_202610 | 559776 | 87808 |
| BALANCE | M_202610 | -2281538 | -437570 |
| TOT_SHIP_REQ | M_202610 | 1053696 | 43904 |
| TOT_SHIP_PLAN | M_202610 | 559776 | 87808 |
| TOT_BALANCE | M_202610 | -2281538 | -437570 |
| TOT_SHIP_REQ | W_20261042 | 537824 | 0 |
| TOT_SHIP_REQ | D_20261013 | 537824 | 0 |
| SHIP_PLAN | W_20261043 | 559776 | 87808 |
| BALANCE | W_20261043 | -2282518 | -438550 |
| TOT_SHIP_REQ | W_20261043 | 515872 | 43904 |
| TOT_SHIP_PLAN | W_20261043 | 559776 | 87808 |
| TOT_BALANCE | W_20261043 | -2282518 | -438550 |
| SHIP_PLAN | D_20261019 | 43904 | 87808 |
| BALANCE | D_20261019 | -43806 | -87710 |
| TOT_SHIP_REQ | D_20261019 | 0 | 43904 |
| TOT_SHIP_PLAN | D_20261019 | 43904 | 87808 |
| TOT_BALANCE | D_20261019 | -43806 | -87710 |
| SHIP_PLAN | D_20261020 | 515872 | 0 |
| BALANCE | D_20261020 | -559678 | -87710 |
| TOT_SHIP_REQ | D_20261020 | 515872 | 0 |
| TOT_SHIP_PLAN | D_20261020 | 515872 | 0 |
| TOT_BALANCE | D_20261020 | -559678 | -87710 |
| BALANCE | D_20261021 | -559678 | -87710 |
| TOT_BALANCE | D_20261021 | -559678 | -87710 |
| BALANCE | D_20261022 | -559678 | -87710 |
| TOT_BALANCE | D_20261022 | -559678 | -87710 |
| BALANCE | D_20261023 | -559678 | -87710 |
| TOT_BALANCE | D_20261023 | -559678 | -87710 |
