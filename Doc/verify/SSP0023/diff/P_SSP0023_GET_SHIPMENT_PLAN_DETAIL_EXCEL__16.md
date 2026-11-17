# SSP0023 · SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL ↔ PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL

- 실행 2026-11-15 01:10:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 1565행 전 컬럼 일치 · 단독행 AS-IS 3 / TO-BE 3 · 키 원천 db_resultsets.csv is_nullable=0 · 키 COMPANY_ID+DIVISION_ID+FROM_SITE+ITEM_ID+YYYYMMDD+QTY · golden 집합 판정 DIFF
- 호출 #16 sheet=main btn=GET_SHIPMENT_PLAN_DETAIL_EXCEL user=minyonglee1 FE 응답 행 1568 · 원천 Doc\verify\SSP0023\calls\_verify_Excel_2단계_차단_M1__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "companyId": "HQ00", "fromSite": "", "itemId": "", "modelId": "", "nickName": "", "requestor": "", "planStartYyyymmdd": "20261010", "fromYyyymmdd": "20261010", "toYyyymmdd": "20261204", "dblFlag": "N", "realFlag": "Y", "language": "KO", "programId": "SSP0023", "sheetName": "Shipment Plan Detail", "nonChk": "Y", "myModelChk": "N", "delegateeChk": "N", "partLeaderChk": "N", "teamLeaderChk": "N", "userId": "minyonglee1", "debugMode": "F"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_company_id": "HQ00", "p_from_site": "", "p_item_id": "", "p_model_id": "", "p_nick_name": "", "p_requestor": "", "p_plan_start_yyyymmdd": "20261010", "p_from_yyyymmdd": "20261010", "p_to_yyyymmdd": "20261204", "p_dbl_flag": "N", "p_real_flag": "Y", "p_language": "KO", "p_program_id": "SSP0023", "p_sheet_name": "Shipment Plan Detail", "p_non_chk": "Y", "p_my_model_chk": "N", "p_delegatee_chk": "N", "p_part_leader_chk": "N", "p_team_leader_chk": "N", "p_user_id": "minyonglee1", "debug_mode": "F"}`

### 결과셋 1  As-is 1568행 ↔ To-Be O_RC1 1568행
- 값 차이: As-is 전용 3행 / To-Be 전용 3행 (공통 컬럼 7)
| 측 | COMPANY_ID | DIVISION_ID | FROM_SITE | ITEM_ID | YYYYMMDD | QTY | Comment |
|---|---|---|---|---|---|---|---|
| A | HQ00 | 40 | HQ06-E | APCAN1199A | 20261010 | 0 |  |
| A | HQ00 | 40 | HQ06-E | APCAN1199A | 20261011 | 0 |  |
| A | HQ00 | 40 | HQ06-E | APCAN1199A | 20261012 | 0 |  |
| T | HQ00 | 40 | HQ06-E | APCAN1199A | 20261010 | 1000 |  |
| T | HQ00 | 40 | HQ06-E | APCAN1199A | 20261011 | 500 |  |
| T | HQ00 | 40 | HQ06-E | APCAN1199A | 20261012 | 1000 |  |
- 데이터 기준: 공통 1565행 · AS-IS 전용 3행 · TO-BE 전용 3행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1565행의 상대 순서): 일치
