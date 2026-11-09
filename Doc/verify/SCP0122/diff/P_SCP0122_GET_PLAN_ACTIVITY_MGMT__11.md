# SCP0122 · SCP0122_GET_PLAN_ACTIVITY_MGMT ↔ PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_MGMT

- 실행 2026-11-08 16:48:20 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 OPMZ_PRS_CD+OPMZ_PLAN_GR_ID+OPMZ_ACTV_CD) — AS-IS 0행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 cleanup_spec.json · 키 OPMZ_PRS_CD+OPMZ_PLAN_GR_ID+OPMZ_ACTV_CD · golden 집합 판정 PASS
- 호출 #11 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SCP0122\calls\_verify_레이아웃_조회_묶음_H4_N1_G1_L2__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "EE_HG", "planGroupId": "", "prsCd": "P001"}`
- AS-IS 인자(번역): `{"p_division_id": "EE_HG", "p_plan_group_id": "", "p_prs_cd": "P001"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "EE_HG", "p_plan_group_id": "ALL", "p_prs_cd": "P001"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
