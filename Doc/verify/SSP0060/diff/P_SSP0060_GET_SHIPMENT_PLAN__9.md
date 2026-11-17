# SSP0060 · SSP0060_GET_SHIPMENT_PLAN ↔ PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN

- 실행 2026-11-15 05:23:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 652행/TO-BE 552행(공통 399 · AS-IS 전용 253 · TO-BE 전용 153) · 셋2 AS-IS 327행/TO-BE 326행(공통 326 · AS-IS 전용 1 · TO-BE 전용 0) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #9 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 878 · 원천 Doc\verify\SSP0060\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "companyId": "WA00", "fromSite": "", "planStartYyyymmdd": "20261009", "fromYyyymmdd": "20261009", "toYyyymmdd": "20261023", "itemId": "", "productLevel1": "", "userId": "minyonglee1", "programId": "SSP0060", "sheetName": "Shipment Plan", "realFlag": "Y"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_company_id": "WA00", "p_from_site": "", "p_plan_start_yyyymmdd": "20261009", "p_from_yyyymmdd": "20261009", "p_to_yyyymmdd": "20261023", "p_item_id": "", "p_product_level1": "", "p_user_id": "minyonglee1", "p_program_id": "SSP0060", "p_sheet_name": "Shipment Plan", "p_real_flag": "Y"}`

### 결과셋 1  As-is 652행 ↔ To-Be O_RC1 552행
- 행수 불일치 652 ↔ 552
- 값 차이: As-is 전용 253행 / To-Be 전용 153행 (공통 컬럼 54)
| 측 | DIVISION_ID | FROM_SITE | from_site_description | PRODUCT_LEVEL1 | ITEM_ID | nick_name | BOH_TYPE | BOH_QTY | PSI | MEASURE | MEASURE_NAME | TO_SITE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81 | WA00-A | LGESWA Cell WA00 | - |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| A | 81 | WA00-A | LGESWA Cell WA00 | - |  |  |  |  | S | TOT_SHIP_PLAN | Total Shipment Plan[R+P] |  |
| A | 81 | WA00-A | LGESWA Cell WA00 | - |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| A | 81 | WA00-A | LGESWA Cell WA00 | - | ACEH1079I-A1-600 | E79A-600 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] |  |
| A | 81 | WA00-A | LGESWA Cell WA00 | - | ACEH1079I-A1-600 | E79A-600 |  |  | S | SHIP_REQ | Shipment Request |  |
| A | 81 | WA00-A | LGESWA Cell WA00 | - | ACEH1079I-A1-600 | E79A-600 | BOH | 684 | I | BALANCE | Balance |  |
| A | 81 | WA00-A | LGESWA Cell WA00 | - | ACEH1079I-A1-600 | E79A-600 | ERP | 893 | P | PROD_PLAN | Production |  |
| A | 81 | WA00-A | LGESWA Cell WA00 | - | ACEN4073I-A1-700 | E73A-700 |  |  | S | SHIP_REQ | Shipment Request |  |
| A | 81 | WA00-A | LGESWA Cell WA00 | - | ACEN4073I-A1-700 | E73A-700 | ERP | 196819 | P | PROD_PLAN | Production |  |
| A | 81 | WA00-A | LGESWA Cell WA00 | - | ACEN4077I-A1-200 | E77A-200 |  |  | S | SHIP_REQ | Shipment Request |  |
| T | 81 | WA00-A | LGESWA Cell WA00 | - |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| T | 81 | WA00-A | LGESWA Cell WA00 | - |  |  |  |  | S | TOT_SHIP_PLAN | Total Shipment Plan[R+P] |  |
| T | 81 | WA00-A | LGESWA Cell WA00 | - |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| T | 81 | WA00-A | LGESWA Cell WA00 | - | ACEH1079I-A1-600 | E79A-600 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] |  |
| T | 81 | WA00-A | LGESWA Cell WA00 | - | ACEH1079I-A1-600 | E79A-600 | BOH | 684 | I | BALANCE | Balance |  |
| T | 81 | WA00-A | LGESWA Cell WA00 | E161A |  |  |  |  | I | TOT_BALANCE | Total Balance |  |
| T | 81 | WA00-A | LGESWA Cell WA00 | E161A |  |  |  |  | S | TOT_SHIP_PLAN | Total Shipment Plan[R+P] |  |
| T | 81 | WA00-A | LGESWA Cell WA00 | E161A |  |  |  |  | S | TOT_SHIP_REQ | Total Shipment Request |  |
| T | 81 | WA00-A | LGESWA Cell WA00 | E161A | ACEH1161I-A1-700 | E161A-700 |  |  | S | SHIP_PLAN | Shipment Plan[R+P] |  |
| T | 81 | WA00-A | LGESWA Cell WA00 | E161A | ACEH1161I-A1-700 | E161A-700 | BOH | 31680 | I | BALANCE | Balance |  |
- 데이터 기준: 공통 399행 · AS-IS 전용 253행 · TO-BE 전용 153행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 399행의 상대 순서): 일치

### 결과셋 2  As-is 327행 ↔ To-Be O_RC2 326행
- 행수 불일치 327 ↔ 326
- 값 차이: As-is 전용 1행 / To-Be 전용 0행 (공통 컬럼 11)
| 측 | DIVISION_ID | FROM_SITE | ITEM_ID | TO_SITE | TRANSPORT_MODE | INCOTERMS | FCST_TYPE | YYYYMMDD | QTY | NOEDIT_QTY | NOTE |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81 | WA00-P | AMFMCC727-C1-010 | Ford_TR_KCO | TRK | DAP | MPS | 20261009 | 528 | 0 | Input Qty(Min) : 0 |
- 데이터 기준: 공통 326행 · AS-IS 전용 1행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 326행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['81', 'WA00-A', 'ACEH1079I-A1-600', 'NANO IN TECH_WA_KR_W', 'SEA', 'EXW'] ↔ TO-BE=['81', 'WA00-A', 'ACEH1161I-A1-700', 'Porsche_SK_DNV', 'TRK', 'FCA']
