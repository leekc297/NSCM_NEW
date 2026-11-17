# SSP0023 · SSP0023_GET_SHIPMENT_PLAN ↔ PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN

- 실행 2026-11-15 01:10:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 11행 중 불일치 셀 258 — diff/P_SSP0023_GET_SHIPMENT_PLAN__19.csv · 키 원천 auto · 키 MEASURE · golden 집합 판정 DIFF
- 호출 #19 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 11 · 원천 Doc\verify\SSP0023\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "companyId": "HQ00", "fromSite": "", "planStartYyyymmdd": "20261010", "fromYyyymmdd": "20260928", "toYyyymmdd": "20261204", "modelId": "", "itemId": "APCAN1199A", "nickName": "", "userId": "minyonglee1", "programId": "SSP0023", "sheetName": "Shipment Plan(Electrode)", "realFlag": "Y", "nonChk": "Y", "myModelChk": "N", "delegateeChk": "N", "partLeaderChk": "N", "teamLeaderChk": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"P_DIVISION_ID": "40", "P_COMPANY_ID": "HQ00", "P_FROM_SITE": "", "P_PLAN_START_YYYYMMDD": "20261010", "P_FROM_YYYYMMDD": "20260928", "P_TO_YYYYMMDD": "20261204", "P_MODEL_ID": "", "P_ITEM_ID": "APCAN1199A", "P_NICK_NAME": "", "P_USER_ID": "minyonglee1", "P_PROGRAM_ID": "SSP0023", "P_SHEET_NAME": "Shipment Plan(Electrode)", "P_REAL_FLAG": "Y", "P_NON_CHK": "Y", "P_MY_MODEL_CHK": "N", "P_DELEGATEE_CHK": "N", "P_PART_LEADER_CHK": "N", "P_TEAM_LEADER_CHK": "N"}`

### 결과셋 1  As-is 11행 ↔ To-Be O_RC1 11행
- 값 차이: As-is 전용 11행 / To-Be 전용 11행 (공통 컬럼 281)
| 측 | DIVISION_ID | PLANT_ID | SCM_SITE_ID | ELECTRODE_POST_OPER_LT | ELECTRODE_TYPE | MODEL_ID | ITEM_ID | FROM_SITE | GUBUN_NUM | TEMPCOLUMN | PSI_NAME | TOT_BOH_QTY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | I | 9 |
| A | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | I | 9 |
| A | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | I | 9 |
| A | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | P | 9 |
| A | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | P | 9 |
| A | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | P | 9 |
| A | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | S | 9 |
| A | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | S | 9 |
| A | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | S | 9 |
| A | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | S | 9 |
| T | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | I | 9288 |
| T | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | I | 9288 |
| T | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | I | 9288 |
| T | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | P | 9288 |
| T | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | P | 9288 |
| T | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | P | 9288 |
| T | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | S | 9288 |
| T | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | S | 9288 |
| T | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | S | 9288 |
| T | 40 | HQ06 | HQ06-E | - | ANODE | MCCH114030D3 | APCAN1199A | HQ06-E | 1 | - | S | 9288 |
- 데이터 기준: 공통 0행 · AS-IS 전용 11행 · TO-BE 전용 11행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

## 불일치 셀(≤50) — diff/P_SSP0023_GET_SHIPMENT_PLAN__19.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| P_SCP_PROD_PLAN | TOT_BOH_QTY | 9 | 9288 |
| P_SCP_SHIP_PLAN_ETD | TOT_BOH_QTY | 9 | 9288 |
| P_SHIP_REQ_ETD | TOT_BOH_QTY | 9 | 9288 |
| P_SHIP_PLAN_SIMU_ETD | TOT_BOH_QTY | 9 | 9288 |
| P_SHIP_CONFIRM_ETD | TOT_BOH_QTY | 9 | 9288 |
| P_FP_NPC_ASSY_PLAN | TOT_BOH_QTY | 9 | 9288 |
| P_FP_COATER_PLAN | TOT_BOH_QTY | 9 | 9288 |
| P_FP_COATER_POST_PLAN | TOT_BOH_QTY | 9 | 9288 |
| P_INTRANSIT_ETA | TOT_BOH_QTY | 9 | 9288 |
| P_INV_SIM | TOT_BOH_QTY | 9 | 9288 |
| P_INV_CONFIRM | TOT_BOH_QTY | 9 | 9288 |
| P_SCP_PROD_PLAN | TOT_BOH_QTY_PCM | 7 | 7958 |
| P_SCP_SHIP_PLAN_ETD | TOT_BOH_QTY_PCM | 7 | 7958 |
| P_SHIP_REQ_ETD | TOT_BOH_QTY_PCM | 7 | 7958 |
| P_SHIP_PLAN_SIMU_ETD | TOT_BOH_QTY_PCM | 7 | 7958 |
| P_SHIP_CONFIRM_ETD | TOT_BOH_QTY_PCM | 7 | 7958 |
| P_FP_NPC_ASSY_PLAN | TOT_BOH_QTY_PCM | 7 | 7958 |
| P_FP_COATER_PLAN | TOT_BOH_QTY_PCM | 7 | 7958 |
| P_FP_COATER_POST_PLAN | TOT_BOH_QTY_PCM | 7 | 7958 |
| P_INTRANSIT_ETA | TOT_BOH_QTY_PCM | 7 | 7958 |
| P_INV_SIM | TOT_BOH_QTY_PCM | 7 | 7958 |
| P_INV_CONFIRM | TOT_BOH_QTY_PCM | 7 | 7958 |
| P_SCP_PROD_PLAN | TOT_BOH_QTY_CELL | 9 | 9288 |
| P_SCP_SHIP_PLAN_ETD | TOT_BOH_QTY_CELL | 9 | 9288 |
| P_SHIP_REQ_ETD | TOT_BOH_QTY_CELL | 9 | 9288 |
| P_SHIP_PLAN_SIMU_ETD | TOT_BOH_QTY_CELL | 9 | 9288 |
| P_SHIP_CONFIRM_ETD | TOT_BOH_QTY_CELL | 9 | 9288 |
| P_FP_NPC_ASSY_PLAN | TOT_BOH_QTY_CELL | 9 | 9288 |
| P_FP_COATER_PLAN | TOT_BOH_QTY_CELL | 9 | 9288 |
| P_FP_COATER_POST_PLAN | TOT_BOH_QTY_CELL | 9 | 9288 |
| P_INTRANSIT_ETA | TOT_BOH_QTY_CELL | 9 | 9288 |
| P_INV_SIM | TOT_BOH_QTY_CELL | 9 | 9288 |
| P_INV_CONFIRM | TOT_BOH_QTY_CELL | 9 | 9288 |
| P_SHIP_PLAN_SIMU_ETD | X_M_202610 | 0 | 2500 |
| P_INV_SIM | X_M_202610 | 204336 | 151836 |
| P_SHIP_PLAN_SIMU_ETD | X_W_20261041 | 0 | 1500 |
| P_INV_SIM | X_W_20261041 | 18576 | 16076 |
| P_SHIP_PLAN_SIMU_ETD | X_D_20261010 | 0 | 1000 |
| P_INV_SIM | X_D_20261010 | 9288 | 8288 |
| P_SHIP_PLAN_SIMU_ETD | X_D_20261011 | 0 | 500 |
| P_INV_SIM | X_D_20261011 | 9288 | 7788 |
| P_SHIP_PLAN_SIMU_ETD | X_W_20261042 | 0 | 1000 |
| P_INV_SIM | X_W_20261042 | 65016 | 47516 |
| P_SHIP_PLAN_SIMU_ETD | X_D_20261012 | 0 | 1000 |
| P_INV_SIM | X_D_20261012 | 9288 | 6788 |
| P_INV_SIM | X_D_20261013 | 9288 | 6788 |
| P_INV_SIM | X_D_20261014 | 9288 | 6788 |
| P_INV_SIM | X_D_20261015 | 9288 | 6788 |
| P_INV_SIM | X_D_20261016 | 9288 | 6788 |
| P_INV_SIM | X_D_20261017 | 9288 | 6788 |
