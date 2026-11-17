# SSP0060 · SSP0060_GET_SHIPMENT_DIVISION ↔ PKG_SSP0060.P_SSP0060_GET_SHIPMENT_DIVISION

- 실행 2026-11-15 05:23:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 0행/TO-BE 3행(공통 0 · AS-IS 전용 0 · TO-BE 전용 3) · 셋2 AS-IS 0행/TO-BE 4행(공통 0 · AS-IS 전용 0 · TO-BE 전용 4) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #1 sheet=division btn=SEARCH user=minyonglee1 FE 응답 행 7 · 원천 Doc\verify\SSP0060\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"param1": "", "param2": "minyonglee1"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"Param1": "", "Param2": "minyonglee1"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"Param1": "ALL", "Param2": "minyonglee1"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 3행
- 행수 불일치 0 ↔ 3
- 값 차이: As-is 전용 0행 / To-Be 전용 3행 (공통 컬럼 3)
| 측 | CODE | NAME | ATTRIBUTE1 |
|---|---|---|---|
| T | 81 | 81 Automotive Battery | 1 |
| T | 81_UC | 81_UC Automotive Battery(UC) | 1 |
| T | 82 | 82 ESS Battery | 1 |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 3행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 2  As-is 0행 ↔ To-Be O_RC2 4행
- 행수 불일치 0 ↔ 4
- 값 차이: As-is 전용 0행 / To-Be 전용 4행 (공통 컬럼 3)
| 측 | CODE | NAME | DIVISION_ID |
|---|---|---|---|
| T | GM00 | ESUC | 81_UC |
| T | GM00 | ESUC | 82 |
| T | WA00 | ESWA | 81 |
| T | WA00 | ESWA | 82 |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 4행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
