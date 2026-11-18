# SCP0104 · SCP0104_GET_SPREAD_TITLE ↔ PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE

- 실행 2026-11-18 10:50:43 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 29행 전 컬럼 일치 · 키 원천 auto · 키 COLUMN_NAME · golden 집합 판정 PASS
- 호출 #1 sheet=spreadTitle btn=SEARCH user=minyonglee1 FE 응답 행 30 · 원천 Doc\verify\SCP0104\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"p_from_yyyymm": "202611", "p_program_id": "SCP0104", "p_sheet_name": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}` · 같은 본문의 세션 조합 10종 중 최다(678회) 사용 — 나머지 [{'sesLangCd': 'KO', 'sesUserId': 'dana.robot'}, {'sesLangCd': 'KO', 'sesUserId': 'lucky-alex'}, {'sesLangCd': 'EN', 'sesUserId': 'zhangjiali'}]
- AS-IS 인자(번역): `{"p_from_yyyymm": "202611", "p_program_id": "SCP0104", "p_sheet_name": ""}`

### 결과셋 1  As-is 29행 ↔ To-Be O_RC1 29행
- 일치
- 데이터 기준: 공통 29행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 29행의 상대 순서): 일치
