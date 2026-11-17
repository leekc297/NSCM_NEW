# SCP0007 · SCP0007_GET_BOD ↔ PKG_SCP0007.P_SCP0007_GET_BOD

- 실행 2026-11-14 09:25:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 0행/TO-BE 186행(공통 0 · AS-IS 전용 0 · TO-BE 전용 186) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #24 sheet=bod btn=SEARCH user=minyonglee1 FE 응답 행 187 · 원천 Doc\verify\SCP0007\calls\_trace_W4d_잔여_판정필요_실측_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "fromSite": "ALL", "toSite": "ALL", "incoterms": "ALL", "incotermsSsp": "ALL", "transMode": "ALL", "inputStatus": "R", "validYn": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_from_site": "", "p_to_site": "", "p_incoterms": "", "p_incoterms_ssp": "", "p_trans_mode": "", "p_input_status": "R", "p_valid": "Y", "debug_mode": "F"}` · 번역 메모: p_from_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_to_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms_ssp: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_trans_mode: 'ALL'→''(all_semantics: 빈 값 = 전체)
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "81", "p_from_site": "ALL", "p_to_site": "ALL", "p_incoterms": "ALL", "p_incoterms_ssp": "ALL", "p_trans_mode": "ALL", "p_input_status": "R", "p_valid": "Y", "debug_mode": "F"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC 186행
- 행수 불일치 0 ↔ 186
- 값 차이: As-is 전용 0행 / To-Be 전용 186행 (공통 컬럼 40)
| 측 | DIVISION_ID | BOD_ID | CUSTOMER | INCOTERMS | INCOTERMS_SSP | FROM_SITE_CODE | TO_SITE_CODE | FROM_COUNTRY | FROM_CITY | TO_COUNTRY | TO_CITY | TRANSPORT_MODE_CODE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 81 |  | ATL | EXW | EXW |  | ATL_DE_RDG |  |  | DE | DERDG |  |
| T | 81 |  | ATL | EXW | EXW |  | ATL_GB_POO |  |  | GB | GBPOO |  |
| T | 81 |  | Ampere Electricity | DAP | DAP |  | Ampere Electricity_FR_CLE |  |  | FR | FRCLE |  |
| T | 81 |  | Ampere Electricity | DAP | DAP |  | Ampere Electricity_FR_DOI |  |  | FR | FRDOI |  |
| T | 81 |  | Ampere Electricity | DAP | DAP |  | Ampere Electricity_FR_HRB |  |  | FR | FRHRB |  |
| T | 81 |  | Audi | DAP | DAP |  | Audi_DE_ING |  |  | DE | DEING |  |
| T | 81 |  | Audi | FCA | FCA |  | Audi_DE_ING |  |  | DE | DEING |  |
| T | 81 |  | Audi | FCA | FCA |  | Audi_DE_NEM |  |  | DE | DENEM |  |
| T | 81 |  | Audi | FCA | FCA |  | Audi_SK_BTS |  |  | SK | SKBTS |  |
| T | 81 |  | BMW | DAP | DAP |  | BMW_DE_DFG |  |  | DE | DEDFG |  |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 186행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
