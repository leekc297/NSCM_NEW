# SSP0014 · SSP0014_GET_USER_ID_CHECK ↔ PKG_SSP0014.P_SSP0014_GET_USER_ID_CHECK

- 실행 2026-11-25 01:54:01 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 3행 전 컬럼 일치 · 키 원천 db_resultsets.csv is_nullable=0 · 키 USER_ID · golden 집합 판정 PASS
- 호출 #32 sheet=main btn=USER_CHECK user=candoism FE 응답 행 4 · 원천 Doc\verify\SSP0014\calls\_verify_그리드_컬럼_프로브_표시_A5_기존행_신규행_편집_D1_입력_후_재편집_콤보_후보_B1_B2_숫자_E1_날짜_0.json
- TO-BE 인자(FE 본문): `{"userId": "eunjin.choi^sethlee^junha.hwang^ZZ_E2E_BAD_POPUP_KEY"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "candoism"}`
- AS-IS 인자(번역): `{"p_user_id": "eunjin.choi^sethlee^junha.hwang^ZZ_E2E_BAD_POPUP_KEY"}`

### 결과셋 1  As-is 3행 ↔ To-Be O_RC1 3행
- 일치
- 데이터 기준: 공통 3행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 3행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['eunjin.choi'] ↔ TO-BE=['sethlee']
