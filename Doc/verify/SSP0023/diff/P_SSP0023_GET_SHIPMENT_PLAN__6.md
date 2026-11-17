# SSP0023 · SSP0023_GET_SHIPMENT_PLAN ↔ PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN

- 실행 2026-11-15 01:10:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 77행 중 불일치 셀 231 — diff/P_SSP0023_GET_SHIPMENT_PLAN__6.csv · 키 원천 auto · 키 MEASURE+MEASURE_NAME+ITEM_ID · golden 집합 판정 DIFF
- 호출 #6 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 77 · 원천 Doc\verify\SSP0023\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81_HD", "companyId": "HD00", "fromSite": "", "planStartYyyymmdd": "20261009", "fromYyyymmdd": "20260928", "toYyyymmdd": "20261203", "modelId": "", "itemId": "", "nickName": "", "userId": "minyonglee1", "programId": "SSP0023", "sheetName": "Shipment Plan(Electrode)", "realFlag": "Y", "nonChk": "Y", "myModelChk": "N", "delegateeChk": "N", "partLeaderChk": "N", "teamLeaderChk": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"P_DIVISION_ID": "81_HD", "P_COMPANY_ID": "HD00", "P_FROM_SITE": "", "P_PLAN_START_YYYYMMDD": "20261009", "P_FROM_YYYYMMDD": "20260928", "P_TO_YYYYMMDD": "20261203", "P_MODEL_ID": "", "P_ITEM_ID": "", "P_NICK_NAME": "", "P_USER_ID": "minyonglee1", "P_PROGRAM_ID": "SSP0023", "P_SHEET_NAME": "Shipment Plan(Electrode)", "P_REAL_FLAG": "Y", "P_NON_CHK": "Y", "P_MY_MODEL_CHK": "N", "P_DELEGATEE_CHK": "N", "P_PART_LEADER_CHK": "N", "P_TEAM_LEADER_CHK": "N"}`

### 결과셋 1  As-is 77행 ↔ To-Be O_RC1 77행
- 값 차이: As-is 전용 77행 / To-Be 전용 77행 (공통 컬럼 278)
| 측 | DIVISION_ID | PLANT_ID | SCM_SITE_ID | ELECTRODE_POST_OPER_LT | ELECTRODE_TYPE | MODEL_ID | ITEM_ID | FROM_SITE | GUBUN_NUM | TEMPCOLUMN | PSI_NAME | TOT_BOH_QTY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | I | 3 |
| A | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | I | 3 |
| A | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | I | 3 |
| A | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | P | 3 |
| A | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | P | 3 |
| A | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | P | 3 |
| A | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | S | 3 |
| A | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | S | 3 |
| A | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | S | 3 |
| A | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | S | 3 |
| T | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | I | 3617 |
| T | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | I | 3617 |
| T | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | I | 3617 |
| T | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | P | 3617 |
| T | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | P | 3617 |
| T | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | P | 3617 |
| T | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | S | 3617 |
| T | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | S | 3617 |
| T | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | S | 3617 |
| T | 81_HD | HD00 | HD00-E | - | ANODE | ACEN4079I-A1-600 | APCAN2013G | HD00-E | 1 | - | S | 3617 |
- 데이터 기준: 공통 0행 · AS-IS 전용 77행 · TO-BE 전용 77행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

## 불일치 셀(≤50) — diff/P_SSP0023_GET_SHIPMENT_PLAN__6.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| P_SCP_PROD_PLAN|SCP Target (Coater)|APCAN2013G | TOT_BOH_QTY | 3 | 3617 |
| P_SCP_SHIP_PLAN_ETD|SCP Target (Shipping Target ETD)|APCAN2013G | TOT_BOH_QTY | 3 | 3617 |
| P_SHIP_REQ_ETD|Shipment Request (ETD)|APCAN2013G | TOT_BOH_QTY | 3 | 3617 |
| P_SHIP_PLAN_SIMU_ETD|Shipment Plan (ETD)|APCAN2013G | TOT_BOH_QTY | 3 | 3617 |
| P_SHIP_CONFIRM_ETD|Shipment Plan Confirm(ETD)|APCAN2013G | TOT_BOH_QTY | 3 | 3617 |
| P_FP_NPC_ASSY_PLAN|Assy Plan(Notching)|APCAN2013G | TOT_BOH_QTY | 3 | 3617 |
| P_FP_COATER_PLAN|Coater Plan|APCAN2013G | TOT_BOH_QTY | 3 | 3617 |
| P_FP_COATER_POST_PLAN|Coater Plan+ Post Yield|APCAN2013G | TOT_BOH_QTY | 3 | 3617 |
| P_INTRANSIT_ETA|Receipt(Intransit)+Shipment Plan(In)|APCAN2013G | TOT_BOH_QTY | 3 | 3617 |
| P_INV_SIM|Inventory(Simulation)|APCAN2013G | TOT_BOH_QTY | 3 | 3617 |
| P_INV_CONFIRM|Inventory(Confirm)|APCAN2013G | TOT_BOH_QTY | 3 | 3617 |
| P_SCP_PROD_PLAN|SCP Target (Coater)|APCAN2013H | TOT_BOH_QTY | 12 | 12720 |
| P_SCP_SHIP_PLAN_ETD|SCP Target (Shipping Target ETD)|APCAN2013H | TOT_BOH_QTY | 12 | 12720 |
| P_SHIP_REQ_ETD|Shipment Request (ETD)|APCAN2013H | TOT_BOH_QTY | 12 | 12720 |
| P_SHIP_PLAN_SIMU_ETD|Shipment Plan (ETD)|APCAN2013H | TOT_BOH_QTY | 12 | 12720 |
| P_SHIP_CONFIRM_ETD|Shipment Plan Confirm(ETD)|APCAN2013H | TOT_BOH_QTY | 12 | 12720 |
| P_FP_NPC_ASSY_PLAN|Assy Plan(Notching)|APCAN2013H | TOT_BOH_QTY | 12 | 12720 |
| P_FP_COATER_PLAN|Coater Plan|APCAN2013H | TOT_BOH_QTY | 12 | 12720 |
| P_FP_COATER_POST_PLAN|Coater Plan+ Post Yield|APCAN2013H | TOT_BOH_QTY | 12 | 12720 |
| P_INTRANSIT_ETA|Receipt(Intransit)+Shipment Plan(In)|APCAN2013H | TOT_BOH_QTY | 12 | 12720 |
| P_INV_SIM|Inventory(Simulation)|APCAN2013H | TOT_BOH_QTY | 12 | 12720 |
| P_INV_CONFIRM|Inventory(Confirm)|APCAN2013H | TOT_BOH_QTY | 12 | 12720 |
| P_SCP_PROD_PLAN|SCP Target (Coater)|APCCA3584A | TOT_BOH_QTY | 2200 | 2200440 |
| P_SCP_SHIP_PLAN_ETD|SCP Target (Shipping Target ETD)|APCCA3584A | TOT_BOH_QTY | 2200 | 2200440 |
| P_SHIP_REQ_ETD|Shipment Request (ETD)|APCCA3584A | TOT_BOH_QTY | 2200 | 2200440 |
| P_SHIP_PLAN_SIMU_ETD|Shipment Plan (ETD)|APCCA3584A | TOT_BOH_QTY | 2200 | 2200440 |
| P_SHIP_CONFIRM_ETD|Shipment Plan Confirm(ETD)|APCCA3584A | TOT_BOH_QTY | 2200 | 2200440 |
| P_FP_NPC_ASSY_PLAN|Assy Plan(Notching)|APCCA3584A | TOT_BOH_QTY | 2200 | 2200440 |
| P_FP_COATER_PLAN|Coater Plan|APCCA3584A | TOT_BOH_QTY | 2200 | 2200440 |
| P_FP_COATER_POST_PLAN|Coater Plan+ Post Yield|APCCA3584A | TOT_BOH_QTY | 2200 | 2200440 |
| P_INTRANSIT_ETA|Receipt(Intransit)+Shipment Plan(In)|APCCA3584A | TOT_BOH_QTY | 2200 | 2200440 |
| P_INV_SIM|Inventory(Simulation)|APCCA3584A | TOT_BOH_QTY | 2200 | 2200440 |
| P_INV_CONFIRM|Inventory(Confirm)|APCCA3584A | TOT_BOH_QTY | 2200 | 2200440 |
| P_SCP_PROD_PLAN|SCP Target (Coater)|APCAN3219A | TOT_BOH_QTY | 640 | 640270 |
| P_SCP_SHIP_PLAN_ETD|SCP Target (Shipping Target ETD)|APCAN3219A | TOT_BOH_QTY | 640 | 640270 |
| P_SHIP_REQ_ETD|Shipment Request (ETD)|APCAN3219A | TOT_BOH_QTY | 640 | 640270 |
| P_SHIP_PLAN_SIMU_ETD|Shipment Plan (ETD)|APCAN3219A | TOT_BOH_QTY | 640 | 640270 |
| P_SHIP_CONFIRM_ETD|Shipment Plan Confirm(ETD)|APCAN3219A | TOT_BOH_QTY | 640 | 640270 |
| P_FP_NPC_ASSY_PLAN|Assy Plan(Notching)|APCAN3219A | TOT_BOH_QTY | 640 | 640270 |
| P_FP_COATER_PLAN|Coater Plan|APCAN3219A | TOT_BOH_QTY | 640 | 640270 |
| P_FP_COATER_POST_PLAN|Coater Plan+ Post Yield|APCAN3219A | TOT_BOH_QTY | 640 | 640270 |
| P_INTRANSIT_ETA|Receipt(Intransit)+Shipment Plan(In)|APCAN3219A | TOT_BOH_QTY | 640 | 640270 |
| P_INV_SIM|Inventory(Simulation)|APCAN3219A | TOT_BOH_QTY | 640 | 640270 |
| P_INV_CONFIRM|Inventory(Confirm)|APCAN3219A | TOT_BOH_QTY | 640 | 640270 |
| P_SCP_PROD_PLAN|SCP Target (Coater)|APCCA3388A | TOT_BOH_QTY | 29 | 29177 |
| P_SCP_SHIP_PLAN_ETD|SCP Target (Shipping Target ETD)|APCCA3388A | TOT_BOH_QTY | 29 | 29177 |
| P_SHIP_REQ_ETD|Shipment Request (ETD)|APCCA3388A | TOT_BOH_QTY | 29 | 29177 |
| P_SHIP_PLAN_SIMU_ETD|Shipment Plan (ETD)|APCCA3388A | TOT_BOH_QTY | 29 | 29177 |
| P_SHIP_CONFIRM_ETD|Shipment Plan Confirm(ETD)|APCCA3388A | TOT_BOH_QTY | 29 | 29177 |
| P_FP_NPC_ASSY_PLAN|Assy Plan(Notching)|APCCA3388A | TOT_BOH_QTY | 29 | 29177 |
