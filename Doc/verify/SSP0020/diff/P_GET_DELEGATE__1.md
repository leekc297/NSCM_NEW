# SSP0020 · SSP0020_GET_DELEGATE ↔ PKG_SSP0020.P_GET_DELEGATE

- 실행 2026-11-17 10:05:42 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 0행/TO-BE 0행(공통 0 · AS-IS 전용 0 · TO-BE 전용 0) · 셋2 AS-IS 0행/TO-BE 0행(공통 0 · AS-IS 전용 0 · TO-BE 전용 0) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 PASS
- 호출 #1 sheet=Delegate btn=SEARCH user=minyonglee1 FE 응답 행 27 · 원천 Doc\verify\SSP0020\calls\_formfix_정리_검증용_행_해제_합산_기록_formteardown_0.json
- TO-BE 인자(FE 본문): `{"language": "KO"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}` · 같은 본문의 세션 조합 3종 중 최다(442회) 사용 — 나머지 [{'sesLangCd': 'EN', 'sesUserId': 'iqromoh'}, {'sesLangCd': 'KO', 'sesUserId': 'hoseoknam'}]
- AS-IS 인자(번역): `{"p_user_id": "minyonglee1", "p_language": "KO"}`
- TO-BE 인자 묶음(PROC_M 순서 = BE 방식): sesUserId→P_USER_ID

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 2  As-is 0행 ↔ To-Be O_RC2 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
