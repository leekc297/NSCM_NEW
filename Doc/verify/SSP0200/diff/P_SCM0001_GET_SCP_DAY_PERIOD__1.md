# SSP0200 · SCM0001_GET_SCP_DAY_PERIOD ↔ PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD

- 실행 2026-11-15 06:43:23 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 키 없이 판정 — 전 결과셋 행 집합 완전 일치(셋1 1행 · 한쪽 전용 0) · 컬럼 집합 차이 AS-IS 전용 [''] / TO-BE 전용 ['period'] · 키 원천 (행 집합) · 키  · golden 집합 판정 COLS
- 호출 #1 sheet=main btn=GET_SCP_DAY_PERIOD user=minyonglee1 FE 응답 행 2 · 원천 Doc\verify\SSP0200\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"fromDate": "", "offsetDay": "30", "timeZone": "AS054"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_from_date": "", "p_offset_day": "30", "p_timezone": "AS054"}`

### 결과셋 1  As-is 1행 ↔ To-Be O_RC1 1행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: PERIOD
- 데이터 기준: 공통 1행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1행의 상대 순서): 비교 불가(공통 행 2 미만)
