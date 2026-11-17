# SSP0023 · SSP0023_GET_SHIPMENT_PLAN ↔ PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN

- 실행 2026-11-15 01:10:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 55행 중 불일치 셀 165 — diff/P_SSP0023_GET_SHIPMENT_PLAN__12.csv · 키 원천 auto · 키 MEASURE+MEASURE_NAME+ITEM_ID · golden 집합 판정 DIFF
- 호출 #12 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 55 · 원천 Doc\verify\SSP0023\calls\_verify_Division별_조회_오류_콤보_이름_F4_A2__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81_HG", "companyId": "HG00", "fromSite": "", "planStartYyyymmdd": "20261009", "fromYyyymmdd": "20260928", "toYyyymmdd": "20261203", "modelId": "", "itemId": "", "nickName": "", "userId": "minyonglee1", "programId": "SSP0023", "sheetName": "Shipment Plan(Electrode)", "realFlag": "Y", "nonChk": "Y", "myModelChk": "N", "delegateeChk": "N", "partLeaderChk": "N", "teamLeaderChk": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"P_DIVISION_ID": "81_HG", "P_COMPANY_ID": "HG00", "P_FROM_SITE": "", "P_PLAN_START_YYYYMMDD": "20261009", "P_FROM_YYYYMMDD": "20260928", "P_TO_YYYYMMDD": "20261203", "P_MODEL_ID": "", "P_ITEM_ID": "", "P_NICK_NAME": "", "P_USER_ID": "minyonglee1", "P_PROGRAM_ID": "SSP0023", "P_SHEET_NAME": "Shipment Plan(Electrode)", "P_REAL_FLAG": "Y", "P_NON_CHK": "Y", "P_MY_MODEL_CHK": "N", "P_DELEGATEE_CHK": "N", "P_PART_LEADER_CHK": "N", "P_TEAM_LEADER_CHK": "N"}`

### 결과셋 1  As-is 55행 ↔ To-Be O_RC1 55행
- 값 차이: As-is 전용 55행 / To-Be 전용 55행 (공통 컬럼 278)
| 측 | DIVISION_ID | PLANT_ID | SCM_SITE_ID | ELECTRODE_POST_OPER_LT | ELECTRODE_TYPE | MODEL_ID | ITEM_ID | FROM_SITE | GUBUN_NUM | TEMPCOLUMN | PSI_NAME | TOT_BOH_QTY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | I | 23 |
| A | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | I | 23 |
| A | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | I | 23 |
| A | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | P | 23 |
| A | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | P | 23 |
| A | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | P | 23 |
| A | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | S | 23 |
| A | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | S | 23 |
| A | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | S | 23 |
| A | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | S | 23 |
| T | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | I | 23292 |
| T | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | I | 23292 |
| T | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | I | 23292 |
| T | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | P | 23292 |
| T | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | P | 23292 |
| T | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | P | 23292 |
| T | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | S | 23292 |
| T | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | S | 23292 |
| T | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | S | 23292 |
| T | 81_HG | HG00 | HG00-E | - | ANODE | ACEH1069I-B1-400 | APCAN3467A | HG00-E | 1 | - | S | 23292 |
- 데이터 기준: 공통 0행 · AS-IS 전용 55행 · TO-BE 전용 55행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

## 불일치 셀(≤50) — diff/P_SSP0023_GET_SHIPMENT_PLAN__12.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| P_SCP_PROD_PLAN|SCP Target (Coater)|APCAN3467A | TOT_BOH_QTY | 23 | 23292 |
| P_SCP_SHIP_PLAN_ETD|SCP Target (Shipping Target ETD)|APCAN3467A | TOT_BOH_QTY | 23 | 23292 |
| P_SHIP_REQ_ETD|Shipment Request (ETD)|APCAN3467A | TOT_BOH_QTY | 23 | 23292 |
| P_SHIP_PLAN_SIMU_ETD|Shipment Plan (ETD)|APCAN3467A | TOT_BOH_QTY | 23 | 23292 |
| P_SHIP_CONFIRM_ETD|Shipment Plan Confirm(ETD)|APCAN3467A | TOT_BOH_QTY | 23 | 23292 |
| P_FP_NPC_ASSY_PLAN|Assy Plan(Notching)|APCAN3467A | TOT_BOH_QTY | 23 | 23292 |
| P_FP_COATER_PLAN|Coater Plan|APCAN3467A | TOT_BOH_QTY | 23 | 23292 |
| P_FP_COATER_POST_PLAN|Coater Plan+ Post Yield|APCAN3467A | TOT_BOH_QTY | 23 | 23292 |
| P_INTRANSIT_ETA|Receipt(Intransit)+Shipment Plan(In)|APCAN3467A | TOT_BOH_QTY | 23 | 23292 |
| P_INV_SIM|Inventory(Simulation)|APCAN3467A | TOT_BOH_QTY | 23 | 23292 |
| P_INV_CONFIRM|Inventory(Confirm)|APCAN3467A | TOT_BOH_QTY | 23 | 23292 |
| P_SCP_PROD_PLAN|SCP Target (Coater)|APCCA3545A | TOT_BOH_QTY | 1 | 1967 |
| P_SCP_SHIP_PLAN_ETD|SCP Target (Shipping Target ETD)|APCCA3545A | TOT_BOH_QTY | 1 | 1967 |
| P_SHIP_REQ_ETD|Shipment Request (ETD)|APCCA3545A | TOT_BOH_QTY | 1 | 1967 |
| P_SHIP_PLAN_SIMU_ETD|Shipment Plan (ETD)|APCCA3545A | TOT_BOH_QTY | 1 | 1967 |
| P_SHIP_CONFIRM_ETD|Shipment Plan Confirm(ETD)|APCCA3545A | TOT_BOH_QTY | 1 | 1967 |
| P_FP_NPC_ASSY_PLAN|Assy Plan(Notching)|APCCA3545A | TOT_BOH_QTY | 1 | 1967 |
| P_FP_COATER_PLAN|Coater Plan|APCCA3545A | TOT_BOH_QTY | 1 | 1967 |
| P_FP_COATER_POST_PLAN|Coater Plan+ Post Yield|APCCA3545A | TOT_BOH_QTY | 1 | 1967 |
| P_INTRANSIT_ETA|Receipt(Intransit)+Shipment Plan(In)|APCCA3545A | TOT_BOH_QTY | 1 | 1967 |
| P_INV_SIM|Inventory(Simulation)|APCCA3545A | TOT_BOH_QTY | 1 | 1967 |
| P_INV_CONFIRM|Inventory(Confirm)|APCCA3545A | TOT_BOH_QTY | 1 | 1967 |
| P_SCP_PROD_PLAN|SCP Target (Coater)|APCCA3269A | TOT_BOH_QTY | 2 | 2661 |
| P_SCP_SHIP_PLAN_ETD|SCP Target (Shipping Target ETD)|APCCA3269A | TOT_BOH_QTY | 2 | 2661 |
| P_SHIP_REQ_ETD|Shipment Request (ETD)|APCCA3269A | TOT_BOH_QTY | 2 | 2661 |
| P_SHIP_PLAN_SIMU_ETD|Shipment Plan (ETD)|APCCA3269A | TOT_BOH_QTY | 2 | 2661 |
| P_SHIP_CONFIRM_ETD|Shipment Plan Confirm(ETD)|APCCA3269A | TOT_BOH_QTY | 2 | 2661 |
| P_FP_NPC_ASSY_PLAN|Assy Plan(Notching)|APCCA3269A | TOT_BOH_QTY | 2 | 2661 |
| P_FP_COATER_PLAN|Coater Plan|APCCA3269A | TOT_BOH_QTY | 2 | 2661 |
| P_FP_COATER_POST_PLAN|Coater Plan+ Post Yield|APCCA3269A | TOT_BOH_QTY | 2 | 2661 |
| P_INTRANSIT_ETA|Receipt(Intransit)+Shipment Plan(In)|APCCA3269A | TOT_BOH_QTY | 2 | 2661 |
| P_INV_SIM|Inventory(Simulation)|APCCA3269A | TOT_BOH_QTY | 2 | 2661 |
| P_INV_CONFIRM|Inventory(Confirm)|APCCA3269A | TOT_BOH_QTY | 2 | 2661 |
| P_SCP_PROD_PLAN|SCP Target (Coater)|APCAN3525A | TOT_BOH_QTY | 581 | 581490 |
| P_SCP_SHIP_PLAN_ETD|SCP Target (Shipping Target ETD)|APCAN3525A | TOT_BOH_QTY | 581 | 581490 |
| P_SHIP_REQ_ETD|Shipment Request (ETD)|APCAN3525A | TOT_BOH_QTY | 581 | 581490 |
| P_SHIP_PLAN_SIMU_ETD|Shipment Plan (ETD)|APCAN3525A | TOT_BOH_QTY | 581 | 581490 |
| P_SHIP_CONFIRM_ETD|Shipment Plan Confirm(ETD)|APCAN3525A | TOT_BOH_QTY | 581 | 581490 |
| P_FP_NPC_ASSY_PLAN|Assy Plan(Notching)|APCAN3525A | TOT_BOH_QTY | 581 | 581490 |
| P_FP_COATER_PLAN|Coater Plan|APCAN3525A | TOT_BOH_QTY | 581 | 581490 |
| P_FP_COATER_POST_PLAN|Coater Plan+ Post Yield|APCAN3525A | TOT_BOH_QTY | 581 | 581490 |
| P_INTRANSIT_ETA|Receipt(Intransit)+Shipment Plan(In)|APCAN3525A | TOT_BOH_QTY | 581 | 581490 |
| P_INV_SIM|Inventory(Simulation)|APCAN3525A | TOT_BOH_QTY | 581 | 581490 |
| P_INV_CONFIRM|Inventory(Confirm)|APCAN3525A | TOT_BOH_QTY | 581 | 581490 |
| P_SCP_PROD_PLAN|SCP Target (Coater)|APCCA3617A | TOT_BOH_QTY | 23 | 23773 |
| P_SCP_SHIP_PLAN_ETD|SCP Target (Shipping Target ETD)|APCCA3617A | TOT_BOH_QTY | 23 | 23773 |
| P_SHIP_REQ_ETD|Shipment Request (ETD)|APCCA3617A | TOT_BOH_QTY | 23 | 23773 |
| P_SHIP_PLAN_SIMU_ETD|Shipment Plan (ETD)|APCCA3617A | TOT_BOH_QTY | 23 | 23773 |
| P_SHIP_CONFIRM_ETD|Shipment Plan Confirm(ETD)|APCCA3617A | TOT_BOH_QTY | 23 | 23773 |
| P_FP_NPC_ASSY_PLAN|Assy Plan(Notching)|APCCA3617A | TOT_BOH_QTY | 23 | 23773 |
