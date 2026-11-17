# SSP0060 · SSP0060_GET_SHIPMENT_PLAN ↔ PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN

- 실행 2026-11-15 05:23:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 18행 중 불일치 셀 47 — diff/P_SSP0060_GET_SHIPMENT_PLAN__10.csv · 키 원천 auto · 키 MEASURE+MEASURE_NAME+BOH_TYPE+ITEM_ID · golden 집합 판정 DIFF
- 호출 #10 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 29 · 원천 Doc\verify\SSP0060\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81_UC", "companyId": "GM00", "fromSite": "", "planStartYyyymmdd": "20261009", "fromYyyymmdd": "20261009", "toYyyymmdd": "20261023", "itemId": "", "productLevel1": "", "userId": "minyonglee1", "programId": "SSP0060", "sheetName": "Shipment Plan", "realFlag": "Y"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81_UC", "p_company_id": "GM00", "p_from_site": "", "p_plan_start_yyyymmdd": "20261009", "p_from_yyyymmdd": "20261009", "p_to_yyyymmdd": "20261023", "p_item_id": "", "p_product_level1": "", "p_user_id": "minyonglee1", "p_program_id": "SSP0060", "p_sheet_name": "Shipment Plan", "p_real_flag": "Y"}`

### 결과셋 1  As-is 20행 ↔ To-Be O_RC1 18행
- 행수 불일치 20 ↔ 18
- 값 차이: As-is 전용 8행 / To-Be 전용 6행 (공통 컬럼 54)
| 측 | DIVISION_ID | FROM_SITE | from_site_description | PRODUCT_LEVEL1 | ITEM_ID | nick_name | BOH_TYPE | BOH_QTY | PSI | MEASURE | MEASURE_NAME | TO_SITE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| A | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A |  |  |  |  | S | TOT_SHIP_PLAN | Total Shipment Plan[R+P] |  |
| A | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| A | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A | ACEN4101I-A1-1D0 | E101A-1D0 |  |  | S | SHIP_REQ | Shipment Request |  |
| A | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A | ACEN4101I-A1-1D0 | E101A-1D0 | ERP | 570688 | P | PROD_PLAN | Production |  |
| A | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A | ACEN4101I-A1-1F0 | E101A-1F0 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] |  |
| A | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A | ACEN4101I-A1-1F0 | E101A-1F0 |  |  | S | SHIP_REQ | Shipment Request |  |
| A | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A | ACEN4101I-A1-1F0 | E101A-1F0 | BOH | 1776 | I | BALANCE | Balance |  |
| T | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| T | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A |  |  |  |  | S | TOT_SHIP_PLAN | Total Shipment Plan[R+P] |  |
| T | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| T | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A | ACEN4101I-A1-1D0 | E101A-1D0 | ERP | 0 | P | PROD_PLAN | Production |  |
| T | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A | ACEN4101I-A1-1F0 | E101A-1F0 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] |  |
| T | 81_UC | GM00-A | Ultium Cells (A) - Lordstown-C | E101A | ACEN4101I-A1-1F0 | E101A-1F0 | BOH | 1776 | I | BALANCE | Balance |  |
- 데이터 기준: 공통 12행 · AS-IS 전용 8행 · TO-BE 전용 6행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 12행의 상대 순서): 일치

### 결과셋 2  As-is 11행 ↔ To-Be O_RC2 11행
- 일치
- 데이터 기준: 공통 11행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 11행의 상대 순서): 일치

## 불일치 셀(≤50) — diff/P_SSP0060_GET_SHIPMENT_PLAN__10.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| PROD_PLAN|Production|ERP|ACEN4101I-A1-1D0 | BOH_QTY | 570688 | 0 |
| SHIP_PLAN|Shipment Plan[R+P]||ACEN4101I-A1-1F0 | M_202610 | 1470528 | 1662336 |
| BALANCE|Balance|BOH|ACEN4101I-A1-1F0 | M_202610 | 2229170 | 1611122 |
| TOT_SHIP_REQ|Total Shipment Request|| | M_202610 | 1790208 | 1641024 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]|| | M_202610 | 2525472 | 2717280 |
| TOT_BALANCE|Total Balance|| | M_202610 | -5443711 | -6061759 |
| TOT_SHIP_REQ|Total Shipment Request|| | W_20261041 | 255744 | 127872 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261009 | 85248 | 127872 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261010 | 85248 | 0 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261011 | 85248 | 0 |
| TOT_SHIP_REQ|Total Shipment Request|| | W_20261042 | 895104 | 681984 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261012 | 127872 | 138528 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261013 | 127872 | 138528 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261014 | 127872 | 138528 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261015 | 127872 | 138528 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261017 | 127872 | 0 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261018 | 127872 | 0 |
| SHIP_PLAN|Shipment Plan[R+P]||ACEN4101I-A1-1F0 | W_20261043 | 1470528 | 1662336 |
| BALANCE|Balance|BOH|ACEN4101I-A1-1F0 | W_20261043 | 189107 | -428941 |
| TOT_SHIP_REQ|Total Shipment Request|| | W_20261043 | 639360 | 831168 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]|| | W_20261043 | 1470528 | 1662336 |
| TOT_BALANCE|Total Balance|| | W_20261043 | -3640438 | -4258486 |
| SHIP_PLAN|Shipment Plan[R+P]||ACEN4101I-A1-1F0 | D_20261019 | 298368 | 340992 |
| BALANCE|Balance|BOH|ACEN4101I-A1-1F0 | D_20261019 | 415809 | 373185 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261019 | 127872 | 170496 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]|| | D_20261019 | 298368 | 340992 |
| TOT_BALANCE|Total Balance|| | D_20261019 | -350100 | -392724 |
| SHIP_PLAN|Shipment Plan[R+P]||ACEN4101I-A1-1F0 | D_20261020 | 298368 | 340992 |
| BALANCE|Balance|BOH|ACEN4101I-A1-1F0 | D_20261020 | 224684 | 139436 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261020 | 127872 | 170496 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]|| | D_20261020 | 298368 | 340992 |
| TOT_BALANCE|Total Balance|| | D_20261020 | -541225 | -626473 |
| SHIP_PLAN|Shipment Plan[R+P]||ACEN4101I-A1-1F0 | D_20261021 | 298368 | 340992 |
| BALANCE|Balance|BOH|ACEN4101I-A1-1F0 | D_20261021 | 33559 | -94313 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261021 | 127872 | 170496 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]|| | D_20261021 | 298368 | 340992 |
| TOT_BALANCE|Total Balance|| | D_20261021 | -732350 | -860222 |
| SHIP_PLAN|Shipment Plan[R+P]||ACEN4101I-A1-1F0 | D_20261022 | 298368 | 340992 |
| BALANCE|Balance|BOH|ACEN4101I-A1-1F0 | D_20261022 | -157566 | -328062 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261022 | 127872 | 170496 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]|| | D_20261022 | 298368 | 340992 |
| TOT_BALANCE|Total Balance|| | D_20261022 | -923475 | -1093971 |
| SHIP_PLAN|Shipment Plan[R+P]||ACEN4101I-A1-1F0 | D_20261023 | 277056 | 298368 |
| BALANCE|Balance|BOH|ACEN4101I-A1-1F0 | D_20261023 | -327379 | -519187 |
| TOT_SHIP_REQ|Total Shipment Request|| | D_20261023 | 127872 | 149184 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]|| | D_20261023 | 277056 | 298368 |
| TOT_BALANCE|Total Balance|| | D_20261023 | -1093288 | -1285096 |
