# SCP0131 · SCP0131_GET_SALES_SITE_PRIORITY ↔ PKG_SCP0131.P_SCP0131_GET_SALES_SITE_PRIORITY

- 실행 2026-11-07 20:26:40 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 3행 전 컬럼 일치 · 키 원천 cleanup_spec.json · 키 DIVISION_ID+SCM_SITE_ID+OPMZ_PLAN_GR_ID+ITEM_ID+FROM_YYYYMMDD+TO_YYYYMMDD · golden 집합 판정 PASS
- 호출 #20 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 4 · 원천 Doc\verify\SCP0131\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "planGroupId": "", "scmSiteId": "", "itemId": "MCOME782-A1-0A", "validYn": "", "periodFrom": "20261102", "periodTo": "20271101"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plan_group_id": "", "p_scm_site_id": "", "p_item_id": "MCOME782-A1-0A", "p_valid_yn": "", "p_period_from": "20261102", "p_period_to": "20271101"}`

### 결과셋 1  As-is 3행 ↔ To-Be O_RC1 3행
- 일치
- 데이터 기준: 공통 3행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 3행의 상대 순서): 일치
