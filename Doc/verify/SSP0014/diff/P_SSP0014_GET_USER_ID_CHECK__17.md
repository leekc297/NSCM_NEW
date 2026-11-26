# SSP0014 · SSP0014_GET_USER_ID_CHECK ↔ PKG_SSP0014.P_SSP0014_GET_USER_ID_CHECK

- 실행 2026-11-25 01:54:01 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 3행 전 컬럼 일치 · 키 원천 db_resultsets.csv is_nullable=0 · 키 USER_ID · golden 집합 판정 PASS
- 호출 #17 sheet=main btn=USER_CHECK user=minyonglee1 FE 응답 행 4 · 원천 Doc\verify\SSP0014\calls\_verify_CRUD_필수_공란_실제_저장_시도_E3_필수_채워_실제_저장_재조회_값_보존_정리_F1_F2_F4_F6__0.json
- TO-BE 인자(FE 본문): `{"userId": "luping^sethlee^junha.hwang"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_user_id": "luping^sethlee^junha.hwang"}`

### 결과셋 1  As-is 3행 ↔ To-Be O_RC1 3행
- 일치
- 데이터 기준: 공통 3행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 3행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['junha.hwang'] ↔ TO-BE=['sethlee']
