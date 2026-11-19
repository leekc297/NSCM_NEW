# SCP0096 · SCP0096_GET_SHIPMENT_WORKING_DAY_OSP ↔ PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP

- 실행: 2026-11-19 09:28:18
- 파라미터: `{"p_division_id": "40", "p_plant_site_id": "", "p_from_yyyymmdd": "20260101", "p_to_yyyymmdd": "20261231", "debug_mode": "F"}`
- 종류: GET

### 결과셋 1  As-is 18행 ↔ To-Be O_RC1 19행
- 행수 불일치 18 ↔ 19
- 값 차이: As-is 전용 1행 / To-Be 전용 2행 (공통 컬럼 371)
| 측 | DIVISION_ID | PLANT_SITE_ID | PLANT_SITE_NAME | WORKING_TIME_DEFAULT | LAST_INPUT_DATE | MEASURE | D_20260101 | D_20260102 | D_20260103 | D_20260104 | D_20260105 | D_20260106 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 40 | CN00254300_40-P | NEXCON_CN_NJ | 7 | 20280708 | SHIPMENT WORKING DAY | Y | Y | Y | Y | Y | Y |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | 7 | 20280708 | SHIPMENT WORKING DAY | Y | Y | Y | Y | Y | Y |
| T | 40 | PL01279700_40-P | INFAC_40 |  |  | SHIPMENT WORKING DAY |  |  |  |  |  |  |
- 데이터 기준: 공통 17행 · AS-IS 전용 1행 · TO-BE 전용 2행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 17행의 상대 순서): 일치
