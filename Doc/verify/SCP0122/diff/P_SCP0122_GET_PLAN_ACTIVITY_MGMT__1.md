# SCP0122 · SCP0122_GET_PLAN_ACTIVITY_MGMT ↔ PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_MGMT

- 실행 2026-11-08 16:48:20 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 7행 전 컬럼 일치 · 키 원천 cleanup_spec.json · 키 OPMZ_PRS_CD+OPMZ_PLAN_GR_ID+OPMZ_ACTV_CD · golden 집합 판정 PASS
- 호출 #1 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 8 · 원천 Doc\verify\SCP0122\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "planGroupId": "PG0003", "prsCd": "P001"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plan_group_id": "PG0003", "p_prs_cd": "P001"}`

### 결과셋 1  As-is 7행 ↔ To-Be O_RC1 7행
- 일치
- 데이터 기준: 공통 7행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 7행의 상대 순서): 일치
