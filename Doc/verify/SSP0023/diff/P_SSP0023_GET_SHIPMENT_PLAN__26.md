# SSP0023 · SSP0023_GET_SHIPMENT_PLAN ↔ PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN

- 실행 2026-11-15 01:10:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 0행/TO-BE 0행(공통 0 · AS-IS 전용 0 · TO-BE 전용 0) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 PASS
- 호출 #26 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 0 · 원천 Doc\verify\SSP0023\calls\_verify_필터_항목_연속_조회_본문_K1_G6__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "companyId": "HQ00", "fromSite": "", "planStartYyyymmdd": "20261010", "fromYyyymmdd": "20260928", "toYyyymmdd": "20261204", "modelId": "", "itemId": "E2E", "nickName": "", "userId": "minyonglee1", "programId": "SSP0023", "sheetName": "Shipment Plan(Electrode)", "realFlag": "Y", "nonChk": "Y", "myModelChk": "N", "delegateeChk": "N", "partLeaderChk": "N", "teamLeaderChk": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"P_DIVISION_ID": "40", "P_COMPANY_ID": "HQ00", "P_FROM_SITE": "", "P_PLAN_START_YYYYMMDD": "20261010", "P_FROM_YYYYMMDD": "20260928", "P_TO_YYYYMMDD": "20261204", "P_MODEL_ID": "", "P_ITEM_ID": "E2E", "P_NICK_NAME": "", "P_USER_ID": "minyonglee1", "P_PROGRAM_ID": "SSP0023", "P_SHEET_NAME": "Shipment Plan(Electrode)", "P_REAL_FLAG": "Y", "P_NON_CHK": "Y", "P_MY_MODEL_CHK": "N", "P_DELEGATEE_CHK": "N", "P_PART_LEADER_CHK": "N", "P_TEAM_LEADER_CHK": "N"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"P_DIVISION_ID": "40", "P_COMPANY_ID": "HQ00", "P_FROM_SITE": "ALL", "P_PLAN_START_YYYYMMDD": "20261010", "P_FROM_YYYYMMDD": "20260928", "P_TO_YYYYMMDD": "20261204", "P_MODEL_ID": "ALL", "P_ITEM_ID": "E2E", "P_NICK_NAME": "ALL", "P_USER_ID": "minyonglee1", "P_PROGRAM_ID": "SSP0023", "P_SHEET_NAME": "Shipment Plan(Electrode)", "P_REAL_FLAG": "Y", "P_NON_CHK": "Y", "P_MY_MODEL_CHK": "N", "P_DELEGATEE_CHK": "N", "P_PART_LEADER_CHK": "N", "P_TEAM_LEADER_CHK": "N"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
