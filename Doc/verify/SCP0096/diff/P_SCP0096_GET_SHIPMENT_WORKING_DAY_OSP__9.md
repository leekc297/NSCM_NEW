# SCP0096 · SCP0096_GET_SHIPMENT_WORKING_DAY_OSP ↔ PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP

- 실행 2026-11-19 09:59:45 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 1행 중 불일치 셀 1 — diff/P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP__9.csv · 키 원천 cleanup_spec.json · 키 DIVISION_ID+PLANT_SITE_ID · golden 집합 판정 DIFF
- 호출 #9 sheet=Shipment Working Day OSP btn=SEARCH user=minyonglee1 FE 응답 행 3 · 원천 Doc\verify\SCP0096\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "plantSiteId": "KR02239900_81-P,AU000062_81-P", "fromYyyymmdd": "20261118", "toYyyymmdd": "20271114"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}` · 같은 본문의 세션 조합 2종 중 최다(1회) 사용 — 나머지 [{'sesLangCd': 'EN', 'sesUserId': 'minyonglee1'}]
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plant_site_id": "KR02239900_81-P,AU000062_81-P", "p_from_yyyymmdd": "20261118", "p_to_yyyymmdd": "20271114", "debug_mode": "F"}`

### 결과셋 1  As-is 1행 ↔ To-Be O_RC1 2행
- 행수 불일치 1 ↔ 2
- 값 차이: As-is 전용 1행 / To-Be 전용 2행 (공통 컬럼 368)
| 측 | DIVISION_ID | PLANT_SITE_ID | PLANT_SITE_NAME | WORKING_TIME_DEFAULT | LAST_INPUT_DATE | MEASURE | D_20261118 | D_20261119 | D_20261120 | D_20261121 | D_20261122 | D_20261123 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 7 | 20280708 | SHIPMENT WORKING DAY | Y | Y | Y | Y | Y | Y |
| T | 81 | AU000062_81-P | TEST |  |  | SHIPMENT WORKING DAY |  |  |  |  |  |  |
| T | 81 | KR02239900_81-P | CS-ENERTECH_PACK | 7 | 20280708 | SHIPMENT WORKING DAY | Y | Y | Y | N | Y | Y |
- 데이터 기준: 공통 0행 · AS-IS 전용 1행 · TO-BE 전용 2행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

## 불일치 셀(≤50) — diff/P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP__9.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 81|KR02239900_81-P | D_20261121 | Y | N |
