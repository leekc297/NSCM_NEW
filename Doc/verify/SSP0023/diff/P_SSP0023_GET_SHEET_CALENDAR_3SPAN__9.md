# SSP0023 · SSP0023_GET_SHEET_CALENDAR_3SPAN ↔ PKG_SSP0023.P_SSP0023_GET_SHEET_CALENDAR_3SPAN

- 실행 2026-11-15 01:10:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 249행 전 컬럼 일치 · 키 원천 auto · 키 COLUMN_NAME · golden 집합 판정 PASS
- 호출 #9 sheet=calendar btn=SEARCH user=minyonglee1 FE 응답 행 249 · 원천 Doc\verify\SSP0023\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"startYyyymmdd": "20260928", "endYyyymmdd": "20261202"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_start_yyyymmdd": "20260928", "p_end_yyyymmdd": "20261202"}`

### 결과셋 1  As-is 249행 ↔ To-Be O_RC1 249행
- 일치
- 데이터 기준: 공통 249행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 249행의 상대 순서): 일치
