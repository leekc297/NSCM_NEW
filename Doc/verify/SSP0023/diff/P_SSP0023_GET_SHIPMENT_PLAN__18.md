# SSP0023 · SSP0023_GET_SHIPMENT_PLAN ↔ PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN

- 실행 2026-11-15 01:10:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 33행 전 컬럼 일치 · 키 원천 auto · 키 MEASURE+MEASURE_NAME+ITEM_ID · golden 집합 판정 PASS
- 호출 #18 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 33 · 원천 Doc\verify\SSP0023\calls\_verify_조회조건_콤보_후보_품질_B1_B2__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "companyId": "HQ00", "fromSite": "HQ10-E", "planStartYyyymmdd": "20261010", "fromYyyymmdd": "20260928", "toYyyymmdd": "20261204", "modelId": "", "itemId": "", "nickName": "", "userId": "minyonglee1", "programId": "SSP0023", "sheetName": "Shipment Plan(Electrode)", "realFlag": "Y", "nonChk": "Y", "myModelChk": "N", "delegateeChk": "N", "partLeaderChk": "N", "teamLeaderChk": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"P_DIVISION_ID": "40", "P_COMPANY_ID": "HQ00", "P_FROM_SITE": "HQ10-E", "P_PLAN_START_YYYYMMDD": "20261010", "P_FROM_YYYYMMDD": "20260928", "P_TO_YYYYMMDD": "20261204", "P_MODEL_ID": "", "P_ITEM_ID": "", "P_NICK_NAME": "", "P_USER_ID": "minyonglee1", "P_PROGRAM_ID": "SSP0023", "P_SHEET_NAME": "Shipment Plan(Electrode)", "P_REAL_FLAG": "Y", "P_NON_CHK": "Y", "P_MY_MODEL_CHK": "N", "P_DELEGATEE_CHK": "N", "P_PART_LEADER_CHK": "N", "P_TEAM_LEADER_CHK": "N"}`

### 결과셋 1  As-is 33행 ↔ To-Be O_RC1 33행
- 일치
- 데이터 기준: 공통 33행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 33행의 상대 순서): 일치
