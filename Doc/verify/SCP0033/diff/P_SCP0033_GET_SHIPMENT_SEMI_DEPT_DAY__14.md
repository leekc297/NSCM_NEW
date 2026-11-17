# SCP0033 · SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY ↔ PKG_SCP0033.P_SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY

- 실행 2026-11-14 11:51:31 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 DIVISION_ID+ITEM_ID) — AS-IS 0행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 컬럼 집합 차이 AS-IS 전용 ['svalueyn'] / TO-BE 전용 ['svalidyn'] · 키 원천 cleanup_spec.json · 키 DIVISION_ID+ITEM_ID · golden 집합 판정 DIFF
- 호출 #14 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 56 · 원천 Doc\verify\SCP0033\calls\_verify_필터_항목_연속_조회_본문_K1_G6__0.json
- TO-BE 인자(FE 본문): `{"p_division_id": "40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,EE,EE_HD,EE_HG,EE_HM,EE_ST,EE_UC", "p_item_id": "E2E", "p_valid": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,EE,EE_HD,EE_HG,EE_HM,EE_ST,EE_UC", "p_item_id": "E2E", "p_valid": ""}`
- 재시도 ''→'ALL': AS-IS 54행 ← `{"p_division_id": "40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,EE,EE_HD,EE_HG,EE_HM,EE_ST,EE_UC", "p_item_id": "E2E", "p_valid": "ALL"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- As-is 에만 있는 컬럼: S_VALUE_YN
- To-Be 에만 있는 컬럼: S_VALID_YN
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 2  As-is 54행 ↔ To-Be O_RC2 55행
- 행수 불일치 54 ↔ 55
- 값 차이: As-is 전용 0행 / To-Be 전용 1행 (공통 컬럼 2)
| 측 | DIVISION_ID | ITEM_ID |
|---|---|---|
| T | 40 | MCCM351015B1-D01 |
- 데이터 기준: 공통 54행 · AS-IS 전용 0행 · TO-BE 전용 1행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 54행의 상대 순서): 일치
