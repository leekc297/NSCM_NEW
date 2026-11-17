# SSP0060 · SSP0060_GET_SHIPMENT_PLAN ↔ PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN

- 실행 2026-11-15 05:23:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 49행 중 불일치 셀 171 — diff/P_SSP0060_GET_SHIPMENT_PLAN__11.csv · 키 원천 auto · 키 MEASURE+MEASURE_NAME+ITEM_ID+nick_name+BOH_TYPE+TO_SITE+FCST_TYPE+FROM_SITE · golden 집합 판정 DIFF
- 호출 #11 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 86 · 원천 Doc\verify\SSP0060\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "companyId": "WA00", "fromSite": "", "planStartYyyymmdd": "20261009", "fromYyyymmdd": "20261009", "toYyyymmdd": "20261023", "itemId": "", "productLevel1": "", "userId": "minyonglee1", "programId": "SSP0060", "sheetName": "Shipment Plan", "realFlag": "Y"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_company_id": "WA00", "p_from_site": "", "p_plan_start_yyyymmdd": "20261009", "p_from_yyyymmdd": "20261009", "p_to_yyyymmdd": "20261023", "p_item_id": "", "p_product_level1": "", "p_user_id": "minyonglee1", "p_program_id": "SSP0060", "p_sheet_name": "Shipment Plan", "p_real_flag": "Y"}`

### 결과셋 1  As-is 55행 ↔ To-Be O_RC1 49행
- 행수 불일치 55 ↔ 49
- 값 차이: As-is 전용 20행 / To-Be 전용 14행 (공통 컬럼 54)
| 측 | DIVISION_ID | FROM_SITE | from_site_description | PRODUCT_LEVEL1 | ITEM_ID | nick_name | BOH_TYPE | BOH_QTY | PSI | MEASURE | MEASURE_NAME | TO_SITE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 82 | PL01279700_82-P | INFAC | - |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| A | 82 | PL01279700_82-P | INFAC | - |  |  |  |  | P | TOT_PROD_PLAN | Total Production |  |
| A | 82 | PL01279700_82-P | INFAC | - |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| A | 82 | PL01279700_82-P | INFAC | - | EH071057PCS1 | FRONIUS JF1 |  |  | S | SHIP_REQ | Shipment Request |  |
| A | 82 | PL01279700_82-P | INFAC | - | EH071057PCS1 | FRONIUS JF1 | BOH | 0 | I | BALANCE | Balance |  |
| A | 82 | PL01279700_82-P | INFAC | - | EH071057PCS1 | FRONIUS JF1 | ERP | 0 | P | PROD_PLAN | Production |  |
| A | 82 | PL01279700_82-P | INFAC | - | EP268623PGB1 | JF2S STACKABLE |  |  | S | SHIP_REQ | Shipment Request |  |
| A | 82 | PL01279700_82-P | INFAC | - | EP268623PGB1 | JF2S STACKABLE | BOH | 0 | I | BALANCE | Balance |  |
| A | 82 | PL01279700_82-P | INFAC | - | EP268623PGB1 | JF2S STACKABLE | ERP | 0 | P | PROD_PLAN | Production |  |
| A | 82 | WA01-A | PL WRO ESS Prod-Cell | - |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| T | 82 | PL01279700_82-P | INFAC | - |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| T | 82 | PL01279700_82-P | INFAC | - |  |  |  |  | P | TOT_PROD_PLAN | Total Production |  |
| T | 82 | PL01279700_82-P | INFAC | - |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| T | 82 | PL01279700_82-P | INFAC | - | EH071057PCS1 | FRONIUS JF1 | BOH | 0 | I | BALANCE | Balance |  |
| T | 82 | PL01279700_82-P | INFAC | - | EH071057PCS1 | FRONIUS JF1 | ERP | 0 | P | PROD_PLAN | Production |  |
| T | 82 | PL01279700_82-P | INFAC | - | EP268623PGB1 | JF2S STACKABLE | BOH | 0 | I | BALANCE | Balance |  |
| T | 82 | PL01279700_82-P | INFAC | - | EP268623PGB1 | JF2S STACKABLE | ERP | 0 | P | PROD_PLAN | Production |  |
| T | 82 | WA01-A | PL WRO ESS Prod-Cell | - |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| T | 82 | WA01-A | PL WRO ESS Prod-Cell | - |  |  |  |  | S | TOT_SHIP_PLAN | Total Shipment Plan[R+P] |  |
| T | 82 | WA01-A | PL WRO ESS Prod-Cell | - |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
- 데이터 기준: 공통 35행 · AS-IS 전용 20행 · TO-BE 전용 14행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 35행의 상대 순서): 일치

### 결과셋 2  As-is 37행 ↔ To-Be O_RC2 37행
- 일치
- 데이터 기준: 공통 37행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 37행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['82', 'PL01279700_82-P', 'EH071057PCS1', 'Fronius_AT_WSL', 'TRK', 'FCA'] ↔ TO-BE=['82', 'WA01-A', 'ECE0566F1-01-B00', 'PL01279700_82-P', 'TRK', 'DAP']

## 불일치 셀(≤50) — diff/P_SSP0060_GET_SHIPMENT_PLAN__11.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| PROD_PLAN|Production|EH071057PCS1|FRONIUS JF1|ERP|||PL01279700_82-P | M_202610 | 9226 | 0 |
| BALANCE|Balance|EH071057PCS1|FRONIUS JF1|BOH|||PL01279700_82-P | M_202610 | -330 | -69120 |
| PROD_PLAN|Production|EP268623PGB1|JF2S STACKABLE|ERP|||PL01279700_82-P | M_202610 | 520 | 0 |
| BALANCE|Balance|EP268623PGB1|JF2S STACKABLE|BOH|||PL01279700_82-P | M_202610 | 3044 | -280 |
| TOT_SHIP_REQ|Total Shipment Request||||||PL01279700_82-P | M_202610 | 7624 | 9251 |
| TOT_PROD_PLAN|Total Production||||||PL01279700_82-P | M_202610 | 9746 | 0 |
| TOT_BALANCE|Total Balance||||||PL01279700_82-P | M_202610 | 2714 | -69400 |
| SHIP_PLAN|Shipment Plan[R+P]|ECE0566F1-01-B00|JF1||||WA01-A | M_202610 | 181440 | 160606 |
| BALANCE|Balance|ECE0566F1-01-B00|JF1|BOH|||WA01-A | M_202610 | -1246200 | -1194104 |
| SHIP_PLAN|Shipment Plan[R+P]|ECE1558F1-01-B02|JF2S||||WA01-A | M_202610 | 155904 | 219408 |
| BALANCE|Balance|ECE1558F1-01-B02|JF2S|BOH|||WA01-A | M_202610 | 310072 | 130312 |
| TOT_SHIP_REQ|Total Shipment Request||||||WA01-A | M_202610 | 487320 | 586924 |
| TOT_SHIP_PLAN|Total Shipment Plan[R+P]||||||WA01-A | M_202610 | 796590 | 839260 |
| TOT_BALANCE|Total Balance||||||WA01-A | M_202610 | -4399628 | -4527292 |
| PROD_PLAN|Production|EH071057PCS1|FRONIUS JF1|ERP|||PL01279700_82-P | W_20261041 | 2130 | 0 |
| BALANCE|Balance|EH071057PCS1|FRONIUS JF1|BOH|||PL01279700_82-P | W_20261041 | 2130 | 0 |
| PROD_PLAN|Production|EP268623PGB1|JF2S STACKABLE|ERP|||PL01279700_82-P | W_20261041 | 66 | 0 |
| BALANCE|Balance|EP268623PGB1|JF2S STACKABLE|BOH|||PL01279700_82-P | W_20261041 | 66 | 0 |
| TOT_PROD_PLAN|Total Production||||||PL01279700_82-P | W_20261041 | 2196 | 0 |
| TOT_BALANCE|Total Balance||||||PL01279700_82-P | W_20261041 | 2196 | 0 |
| TOT_SHIP_REQ|Total Shipment Request||||||WA01-A | W_20261041 | 107908 | 110944 |
| PROD_PLAN|Production|EH071057PCS1|FRONIUS JF1|ERP|||PL01279700_82-P | D_20261009 | 710 | 0 |
| PROD_PLAN|Production|EP268623PGB1|JF2S STACKABLE|ERP|||PL01279700_82-P | D_20261009 | 22 | 0 |
| TOT_PROD_PLAN|Total Production||||||PL01279700_82-P | D_20261009 | 732 | 0 |
| PROD_PLAN|Production|EH071057PCS1|FRONIUS JF1|ERP|||PL01279700_82-P | D_20261010 | 710 | 0 |
| BALANCE|Balance|EH071057PCS1|FRONIUS JF1|BOH|||PL01279700_82-P | D_20261010 | 710 | 0 |
| PROD_PLAN|Production|EP268623PGB1|JF2S STACKABLE|ERP|||PL01279700_82-P | D_20261010 | 22 | 0 |
| BALANCE|Balance|EP268623PGB1|JF2S STACKABLE|BOH|||PL01279700_82-P | D_20261010 | 22 | 0 |
| TOT_PROD_PLAN|Total Production||||||PL01279700_82-P | D_20261010 | 732 | 0 |
| TOT_BALANCE|Total Balance||||||PL01279700_82-P | D_20261010 | 732 | 0 |
| TOT_SHIP_REQ|Total Shipment Request||||||WA01-A | D_20261010 | 71792 | 74828 |
| PROD_PLAN|Production|EH071057PCS1|FRONIUS JF1|ERP|||PL01279700_82-P | D_20261011 | 710 | 0 |
| BALANCE|Balance|EH071057PCS1|FRONIUS JF1|BOH|||PL01279700_82-P | D_20261011 | 1420 | 0 |
| PROD_PLAN|Production|EP268623PGB1|JF2S STACKABLE|ERP|||PL01279700_82-P | D_20261011 | 22 | 0 |
| BALANCE|Balance|EP268623PGB1|JF2S STACKABLE|BOH|||PL01279700_82-P | D_20261011 | 44 | 0 |
| TOT_PROD_PLAN|Total Production||||||PL01279700_82-P | D_20261011 | 732 | 0 |
| TOT_BALANCE|Total Balance||||||PL01279700_82-P | D_20261011 | 1464 | 0 |
| PROD_PLAN|Production|EH071057PCS1|FRONIUS JF1|ERP|||PL01279700_82-P | W_20261042 | 4140 | 0 |
| BALANCE|Balance|EH071057PCS1|FRONIUS JF1|BOH|||PL01279700_82-P | W_20261042 | 1752 | -27648 |
| PROD_PLAN|Production|EP268623PGB1|JF2S STACKABLE|ERP|||PL01279700_82-P | W_20261042 | 240 | 0 |
| BALANCE|Balance|EP268623PGB1|JF2S STACKABLE|BOH|||PL01279700_82-P | W_20261042 | 1182 | -120 |
| TOT_SHIP_REQ|Total Shipment Request||||||PL01279700_82-P | W_20261042 | 3812 | 4628 |
| TOT_PROD_PLAN|Total Production||||||PL01279700_82-P | W_20261042 | 4380 | 0 |
| TOT_BALANCE|Total Balance||||||PL01279700_82-P | W_20261042 | 2934 | -27768 |
| TOT_SHIP_REQ|Total Shipment Request||||||WA01-A | W_20261042 | 211878 | 265776 |
| PROD_PLAN|Production|EH071057PCS1|FRONIUS JF1|ERP|||PL01279700_82-P | D_20261012 | 690 | 0 |
| BALANCE|Balance|EH071057PCS1|FRONIUS JF1|BOH|||PL01279700_82-P | D_20261012 | 2130 | 0 |
| PROD_PLAN|Production|EP268623PGB1|JF2S STACKABLE|ERP|||PL01279700_82-P | D_20261012 | 40 | 0 |
| BALANCE|Balance|EP268623PGB1|JF2S STACKABLE|BOH|||PL01279700_82-P | D_20261012 | 66 | 0 |
| TOT_PROD_PLAN|Total Production||||||PL01279700_82-P | D_20261012 | 730 | 0 |
