# SCP0041 · SCP0041_GET_PACK_HOLD_STOCK ↔ PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK

- 실행 2026-11-14 15:25:22 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 452행/TO-BE 452행(공통 0 · AS-IS 전용 452 · TO-BE 전용 452) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #11 sheet=Pack Hold Stock btn=SEARCH user=minyonglee1 FE 응답 행 453 · 원천 Doc\verify\SCP0041\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "plantSiteId": "", "itemId": "", "fromYyyymmdd": "20210814", "toYyyymmdd": "20270814", "inspectionId": "", "status": "", "cutoffFromYyyymmdd": "20211114", "cutoffToYyyymmdd": "20261114"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plant_site_id": "", "p_item_id": "", "p_from_yyyymmdd": "20210814", "p_to_yyyymmdd": "20270814", "p_inspection_id": "", "p_status": "", "p_cutoff_from_yyyymmdd": "20211114", "p_cutoff_to_yyyymmdd": "20261114"}`

### 결과셋 1  As-is 452행 ↔ To-Be O_RC1 452행
- 값 차이: As-is 전용 452행 / To-Be 전용 452행 (공통 컬럼 41)
| 측 | DIVISION_ID | SCM_SITE_ID | SITE_DESCRIPTION | CUTOFF_DATE | PROD_ID | NICK_NAME | ORG_ITEM_ID | QTY | DATE_FINISH_REAL | DATE_FORECAST_START | DATE_FORECAST_FINISH | CHANGE_REQUEST_USER |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-17 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 | 2023-09-19 | ssorn |
| A | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-18 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 | 2023-09-19 | ssorn |
| A | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-19 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 | 2023-09-19 | ssorn |
| A | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-20 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 | 2023-09-19 | ssorn |
| A | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-21 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 | 2023-09-19 | ssorn |
| A | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-22 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 | 2023-09-19 | ssorn |
| A | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-23 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 | 2023-09-19 | ssorn |
| A | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-24 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 | 2023-09-19 | ssorn |
| A | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-25 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 | 2023-09-19 | ssorn |
| A | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-26 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 | 2023-09-19 | ssorn |
| T | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-17 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 00:00:00 | 2023-09-19 00:00:00 | ssorn |
| T | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-18 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 00:00:00 | 2023-09-19 00:00:00 | ssorn |
| T | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-19 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 00:00:00 | 2023-09-19 00:00:00 | ssorn |
| T | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-20 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 00:00:00 | 2023-09-19 00:00:00 | ssorn |
| T | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-21 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 00:00:00 | 2023-09-19 00:00:00 | ssorn |
| T | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-22 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 00:00:00 | 2023-09-19 00:00:00 | ssorn |
| T | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-23 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 00:00:00 | 2023-09-19 00:00:00 | ssorn |
| T | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-24 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 00:00:00 | 2023-09-19 00:00:00 | ssorn |
| T | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-25 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 00:00:00 | 2023-09-19 00:00:00 | ssorn |
| T | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 2023-09-26 | AMRSAB100-A4 | RSA-B10 LREV | AMRSAB100-A4 | 10 |  | 2023-09-19 00:00:00 | 2023-09-19 00:00:00 | ssorn |
- 데이터 기준: 공통 0행 · AS-IS 전용 452행 · TO-BE 전용 452행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
