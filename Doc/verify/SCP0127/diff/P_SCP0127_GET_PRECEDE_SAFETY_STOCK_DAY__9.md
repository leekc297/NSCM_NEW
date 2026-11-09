# SCP0127 · SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY ↔ PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY

- 실행 2026-11-07 21:45:56 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 10행 전 컬럼 일치 · 컬럼 집합 차이 AS-IS 전용 [] / TO-BE 전용 ['opmzplangrname'] · 키 원천 cleanup_spec.json · 키 DIVISION_ID+SCM_SITE_ID+OPMZ_PLAN_GR_ID+STAGE+ITEM_ID+VALUE_TYPE+FROM_YYYYMMDD+TO_YYYYMMDD · golden 집합 판정 COLS
- 호출 #9 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 11 · 원천 Doc\verify\SCP0127\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "planGroupId": "ALL", "scmSiteId": "ALL", "itemId": "", "stage": "ASY_AGING", "validYn": "", "valueType": "", "periodFrom": "20261102", "periodTo": "20271101"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plan_group_id": "", "p_scm_site_id": "", "p_item_id": "", "p_stage": "ASY_AGING", "p_valid_yn": "", "p_value_type": "", "p_period_from": "20261102", "p_period_to": "20271101"}` · 번역 메모: p_plan_group_id: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_scm_site_id: 'ALL'→''(all_semantics: 빈 값 = 전체)

### 결과셋 1  As-is 10행 ↔ To-Be O_RC1 10행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: OPMZ_PLAN_GR_NAME
- 데이터 기준: 공통 10행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 10행의 상대 순서): 일치
