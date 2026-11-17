# SCP0131 · SCP0131_GET_SALES_SITE_PRIORITY ↔ PKG_SCP0131.P_SCP0131_GET_SALES_SITE_PRIORITY

- 실행 2026-11-14 19:25:07 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 93행 전 컬럼 일치 · 키 원천 cleanup_spec.json · 키 DIVISION_ID+SCM_SITE_ID+OPMZ_PLAN_GR_ID+ITEM_ID+FROM_YYYYMMDD+TO_YYYYMMDD · golden 집합 판정 PASS
- 호출 #4 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 94 · 원천 Doc\verify\SCP0131\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "planGroupId": "", "scmSiteId": "", "itemId": "", "validYn": "", "periodFrom": "20261109", "periodTo": "20271108"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_plan_group_id": "", "p_scm_site_id": "", "p_item_id": "", "p_valid_yn": "", "p_period_from": "20261109", "p_period_to": "20271108"}`

### 결과셋 1  As-is 93행 ↔ To-Be O_RC1 93행
- 일치
- 데이터 기준: 공통 93행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 93행의 상대 순서): 일치
