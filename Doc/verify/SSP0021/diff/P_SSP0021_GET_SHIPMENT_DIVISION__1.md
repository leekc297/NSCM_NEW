# SSP0021 · SSP0021_GET_SHIPMENT_DIVISION ↔ PKG_SSP0021.P_SSP0021_GET_SHIPMENT_DIVISION

- 실행 2026-11-15 02:40:13 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 0행/TO-BE 6행(공통 0 · AS-IS 전용 0 · TO-BE 전용 6) · 셋2 AS-IS 0행/TO-BE 15행(공통 0 · AS-IS 전용 0 · TO-BE 전용 15) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #1 sheet=division btn=SEARCH user=minyonglee1 FE 응답 행 21 · 원천 Doc\verify\SSP0021\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"param1": "", "param2": "minyonglee1"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"Param1": "", "Param2": "minyonglee1"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"Param1": "ALL", "Param2": "minyonglee1"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 6행
- 행수 불일치 0 ↔ 6
- 값 차이: As-is 전용 0행 / To-Be 전용 6행 (공통 컬럼 3)
| 측 | CODE | NAME | ATTRIBUTE1 |
|---|---|---|---|
| T | 81 | 81 Automotive Battery | 1 |
| T | 81_HD | 81_HD Automotive Battery(HD) | 1 |
| T | 81_HG | 81_HG Automotive Battery(HG) | 1 |
| T | 81_HM | 81_HM Automotive Battery(HM) | 1 |
| T | 81_ST | 81_ST Automotive Battery(ST) | 1 |
| T | 82 | 82 ESS Battery | 1 |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 6행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 2  As-is 0행 ↔ To-Be O_RC2 15행
- 행수 불일치 0 ↔ 15
- 값 차이: As-is 전용 0행 / To-Be 전용 15행 (공통 컬럼 3)
| 측 | CODE | NAME | DIVISION_ID |
|---|---|---|---|
| T | C100 | 구) ESOC | 81 |
| T | HD00 | ESHD | 81_HD |
| T | HD00 | ESHD | 82 |
| T | HG00 | ESHG | 81_HG |
| T | HM00 | ESHM | 81_HM |
| T | HQ00 | ESOC | 81 |
| T | HQ00 | ESOC | 82 |
| T | MI00 | ESMI | 81 |
| T | MI00 | ESMI | 82 |
| T | NA00 | ESNA | 81 |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 15행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
