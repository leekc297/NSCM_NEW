# SCP0127 · SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY ↔ PKG_SCP0127.P_SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY

- 실행 2026-11-14 19:10:25 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 DIVISION_ID+SCM_SITE_ID+OPMZ_PLAN_GR_ID+STAGE+ITEM_ID+VALUE_TYPE+FROM_YYYYMMDD+TO_YYYYMMDD) — AS-IS 0행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 컬럼 집합 차이 AS-IS 전용 [] / TO-BE 전용 ['opmzplangrname'] · 키 원천 cleanup_spec.json · 키 DIVISION_ID+SCM_SITE_ID+OPMZ_PLAN_GR_ID+STAGE+ITEM_ID+VALUE_TYPE+FROM_YYYYMMDD+TO_YYYYMMDD · golden 집합 판정 COLS
- 호출 #17 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SCP0127\calls\_verify_Division별_조회_오류_콤보_이름_F4_A2__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81_HM", "planGroupId": "ALL", "scmSiteId": "ALL", "itemId": "", "stage": "ALL", "validYn": "", "valueType": "", "periodFrom": "20261109", "periodTo": "20271108"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81_HM", "p_plan_group_id": "", "p_scm_site_id": "", "p_item_id": "", "p_stage": "", "p_valid_yn": "", "p_value_type": "", "p_period_from": "20261109", "p_period_to": "20271108"}` · 번역 메모: p_plan_group_id: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_scm_site_id: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_stage: 'ALL'→''(all_semantics: 빈 값 = 전체)
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "81_HM", "p_plan_group_id": "ALL", "p_scm_site_id": "ALL", "p_item_id": "ALL", "p_stage": "ALL", "p_valid_yn": "ALL", "p_value_type": "ALL", "p_period_from": "20261109", "p_period_to": "20271108"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: OPMZ_PLAN_GR_NAME
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
