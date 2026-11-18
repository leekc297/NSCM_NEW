# SSP0020 · UP_FX_GetSSPUserUseInfoList ↔ PKG_SSP0020.P_USER_CHECK

- 실행 2026-11-18 09:48:12 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 1행 전 컬럼 일치 · 키 원천 db_resultsets.csv is_nullable=0 · 키 UserID+UserName+UseYN+RegtUserID · golden 집합 판정 PASS
- 호출 #9 sheet=Delegate btn=USER_CHECK user=minyonglee1 FE 응답 행 2 · 원천 Doc\verify\SSP0020\calls\_trace_W4_E4_업무_검증_메시지_AS-IS_저장_차단__0.json
- TO-BE 인자(FE 본문): `{"search": "minyonglee1", "language": "KO", "useYn": "Y"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"Search": "minyonglee1", "Language": "KO", "UseYN": "Y"}`

### 결과셋 1  As-is 1행 ↔ To-Be O_RC1 1행
- 일치
- 데이터 기준: 공통 1행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1행의 상대 순서): 비교 불가(공통 행 2 미만)
