# SSP0023 · SSP0023_GET_SHIPMENT_PLAN_DETAIL ↔ PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_DETAIL

- 실행 2026-11-15 01:10:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 146행/TO-BE 150행(공통 20 · AS-IS 전용 126 · TO-BE 전용 130) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #17 sheet=planDetail btn=SEARCH user=minyonglee1 FE 응답 행 150 · 원천 Doc\verify\SSP0023\calls\_verify_Excel_2단계_차단_M1__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "companyId": "HQ00", "fromSite": "", "itemId": "", "modelId": "", "nickName": "", "requestor": "", "planStartYyyymmdd": "20261010", "fromYyyymmdd": "20261010", "toYyyymmdd": "20261204", "dblFlag": "N", "realFlag": "Y", "language": "KO", "programId": "SSP0023", "sheetName": "Shipment Plan Detail", "nonChk": "Y", "myModelChk": "N", "delegateeChk": "N", "partLeaderChk": "N", "teamLeaderChk": "N", "userId": "minyonglee1", "debugMode": "F"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_company_id": "HQ00", "p_from_site": "", "p_item_id": "", "p_model_id": "", "p_nick_name": "", "p_requestor": "", "p_plan_start_yyyymmdd": "20261010", "p_from_yyyymmdd": "20261010", "p_to_yyyymmdd": "20261204", "p_dbl_flag": "N", "p_real_flag": "Y", "p_language": "KO", "p_program_id": "SSP0023", "p_sheet_name": "Shipment Plan Detail", "p_non_chk": "Y", "p_my_model_chk": "N", "p_delegatee_chk": "N", "p_part_leader_chk": "N", "p_team_leader_chk": "N", "p_user_id": "minyonglee1", "debug_mode": "F"}`

### 결과셋 1  As-is 146행 ↔ To-Be O_RC1 150행
- 행수 불일치 146 ↔ 150
- 값 차이: As-is 전용 126행 / To-Be 전용 130행 (공통 컬럼 70)
| 측 | DIVISION_ID | ERP_SO_NO | SHIPMENT_STATUS | ITEM_ID | ITEM_ID_NICK_NAME | MODEL_ID | MODEL_ID_NICK_NAME | DAYOFWEEK_NAME | SHIPPING_PLAN_QTY | SHIPMENT_CONFIRM_QTY | GAP | SHIPMENT_DATE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 40 |  | C | APCAN1650A | M50F | MCCM348015A1-D06 | M50F | Friday | 81218 | 81218 | 0 | 2026-10-16 |
| A | 40 |  | C | APCAN1650A | M50F | MCCM348015A1-D06 | M50F | Saturday | 273716 | 167513 | 106203 | 2026-10-31 |
| A | 40 |  | C | APCAN1650A | M50F | MCCM348015A1-D06 | M50F | Sunday | 274112 | 274112 | 0 | 2026-10-18 |
| A | 40 |  | C | APCAN1650A | M50F | MCCM348015A1-D06 | M50F | Sunday | 274112 | 301523 | -27411 | 2026-11-01 |
| A | 40 |  | C | APCAN3440B | H52A | MCCH350040A1-000 | H52A | Monday | 66246 | 66246 | 0 | 2026-10-19 |
| A | 40 |  | C | APCAN3440B | H52A | MCCH350040A1-000 | H52A | Saturday | 66246 | 66246 | 0 | 2026-10-31 |
| A | 40 |  | C | APCAN3440B | H52A | MCCH350040A1-000 | H52A | Sunday | 0 | 66246 | -66246 | 2026-11-01 |
| A | 40 |  | C | APCAN3440B | H52A | MCCH350040A1-000 | H52A | Sunday | 66246 | 66246 | 0 | 2026-10-18 |
| A | 40 |  | C | APCCA1714A | M50F | MCCM348015A1-D06 | M50F | Friday | 81218 | 81218 | 0 | 2026-10-16 |
| A | 40 |  | C | APCCA1714A | M50F | MCCM348015A1-D06 | M50F | Saturday | 273716 | 167513 | 106203 | 2026-10-31 |
| T | 40 |  | C | APCAN1650A | M50F | MCCM348015A1-D06 | M50F | Friday | 81218 | 81218 | 0 | 2026-10-16 |
| T | 40 |  | C | APCAN1650A | M50F | MCCM348015A1-D06 | M50F | Monday | 0 | 167000 | -167000 | 2026-11-30 |
| T | 40 |  | C | APCAN1650A | M50F | MCCM348015A1-D06 | M50F | Saturday | 273716 | 167513 | 106203 | 2026-10-31 |
| T | 40 |  | C | APCAN1650A | M50F | MCCM348015A1-D06 | M50F | Sunday | 274112 | 274112 | 0 | 2026-10-18 |
| T | 40 |  | C | APCAN1650A | M50F | MCCM348015A1-D06 | M50F | Sunday | 274112 | 301523 | -27411 | 2026-11-01 |
| T | 40 |  | C | APCAN3440B | H52A | MCCH350040A1-000 | H52A | Monday | 66246 | 1 | 66245 | 2026-10-19 |
| T | 40 |  | C | APCAN3440B | H52A | MCCH350040A1-000 | H52A | Monday | 66246 | 66246 | 0 | 2026-10-19 |
| T | 40 |  | C | APCAN3440B | H52A | MCCH350040A1-000 | H52A | Saturday | 66246 | 66246 | 0 | 2026-10-31 |
| T | 40 |  | C | APCAN3440B | H52A | MCCH350040A1-000 | H52A | Sunday | 0 | 66246 | -66246 | 2026-11-01 |
| T | 40 |  | C | APCAN3440B | H52A | MCCH350040A1-000 | H52A | Sunday | 66246 | 66246 | 0 | 2026-10-18 |
- 데이터 기준: 공통 20행 · AS-IS 전용 126행 · TO-BE 전용 130행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 20행의 상대 순서): 일치
