# SCP0096 · SCM0001_GET_SCP_MONTH_PERIOD ↔ PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD

- 실행 2026-11-19 09:59:45 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 키 없이 판정 — 전 결과셋 행 집합 완전 일치(셋1 1행 · 한쪽 전용 0) · 키 원천 (행 집합) · 키  · golden 집합 판정 COLS
- 호출 #4 sheet=dayRange btn=SEARCH user=minyonglee1 FE 응답 행 2 · 원천 Doc\verify\SCP0096\calls\_trace_C1_C4_상위_조회조건_변경_하위_후보_재조회_선택_초기화_그리드_상태_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "planCycle": "DAILY", "fromDate": "", "offsetMonth": "12", "timeZone": "AM073"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "EN", "sesUserId": "minyonglee1"}` · 같은 본문의 세션 조합 2종 중 최다(40회) 사용 — 나머지 [{'sesLangCd': 'KO', 'sesUserId': 'minyonglee1'}]
- AS-IS 인자(번역): `{"p_division_id": "40", "p_plan_cycle": "DAILY", "p_from_date": "", "p_offset_month": "12", "p_timezone": "AM073"}`

### 결과셋 1  As-is 1행 ↔ To-Be O_RC1 1행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: PERIOD
- 데이터 기준: 공통 1행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1행의 상대 순서): 비교 불가(공통 행 2 미만)
- AS-IS 이름 없는 컬럼 1개 ↔ TO-BE ['period']: 컬럼 수 1 같음 → 위치 대응(이름 대조 제외)
