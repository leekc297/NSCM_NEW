# SCP0007 · SCP0007_GET_ROUTE_CNT ↔ PKG_SCP0007.P_SCP0007_GET_ROUTE_CNT

- 실행 2026-11-14 09:25:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 키 없이 판정 — 전 결과셋 행 집합 완전 일치(셋1 1행 · 한쪽 전용 0) · 키 원천 (행 집합) · 키  · golden 집합 판정 PASS
- 호출 #3 sheet=routeCnt btn=SEARCH user=minyonglee1 FE 응답 행 2 · 원천 Doc\verify\SCP0007\calls\_trace_W4_E4_업무_검증_메시지_AS-IS_저장_차단__0.json
- TO-BE 인자(FE 본문): `{"fromCity": "CNNKG", "toCity": "CNNKG"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_from_city": "CNNKG", "p_to_city": "CNNKG", "debug_mode": "F"}`

### 결과셋 1  As-is 1행 ↔ To-Be O_RC 1행
- 일치
- 데이터 기준: 공통 1행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1행의 상대 순서): 비교 불가(공통 행 2 미만)
