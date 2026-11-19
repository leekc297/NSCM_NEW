# SCP0096 · SCP0096_GET_SHIPMENT_WORKING_DAY_OSP ↔ PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP

- 실행 2026-11-19 09:59:45 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 18행 중 불일치 셀 2 — diff/P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP__5.csv · 키 원천 cleanup_spec.json · 키 DIVISION_ID+PLANT_SITE_ID · golden 집합 판정 DIFF
- 호출 #5 sheet=Shipment Working Day OSP btn=SEARCH user=minyonglee1 FE 응답 행 20 · 원천 Doc\verify\SCP0096\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "plantSiteId": "ALL", "fromYyyymmdd": "20261118", "toYyyymmdd": "20271114"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "EN", "sesUserId": "minyonglee1"}` · 같은 본문의 세션 조합 2종 중 최다(26회) 사용 — 나머지 [{'sesLangCd': 'KO', 'sesUserId': 'minyonglee1'}]
- AS-IS 인자(번역): `{"p_division_id": "40", "p_plant_site_id": "", "p_from_yyyymmdd": "20261118", "p_to_yyyymmdd": "20271114", "debug_mode": "F"}` · 번역 메모: p_plant_site_id: 'ALL'→''(all_semantics: 빈 값 = 전체)

### 결과셋 1  As-is 18행 ↔ To-Be O_RC1 19행
- 행수 불일치 18 ↔ 19
- 값 차이: As-is 전용 1행 / To-Be 전용 2행 (공통 컬럼 368)
| 측 | DIVISION_ID | PLANT_SITE_ID | PLANT_SITE_NAME | WORKING_TIME_DEFAULT | LAST_INPUT_DATE | MEASURE | D_20261118 | D_20261119 | D_20261120 | D_20261121 | D_20261122 | D_20261123 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 40 | CN00254300_40-P | NEXCON_CN_NJ | 7 | 20280708 | SHIPMENT WORKING DAY | Y | Y | Y | Y | Y | Y |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | 7 | 20280708 | SHIPMENT WORKING DAY | Y | Y | Y | N | N | Y |
| T | 40 | PL01279700_40-P | INFAC_40 |  |  | SHIPMENT WORKING DAY |  |  |  |  |  |  |
- 데이터 기준: 공통 17행 · AS-IS 전용 1행 · TO-BE 전용 2행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 17행의 상대 순서): 일치

## 불일치 셀(≤50) — diff/P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP__5.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 40|CN00254300_40-P | D_20261121 | Y | N |
| 40|CN00254300_40-P | D_20261122 | Y | N |
