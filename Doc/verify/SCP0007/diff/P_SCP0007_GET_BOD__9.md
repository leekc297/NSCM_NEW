# SCP0007 · SCP0007_GET_BOD ↔ PKG_SCP0007.P_SCP0007_GET_BOD

- 실행 2026-11-14 09:25:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 476행 중 불일치 셀 7 — diff/P_SCP0007_GET_BOD__9.csv · 키 원천 auto · 키 BOD_ID · golden 집합 판정 DIFF
- 호출 #9 sheet=bod btn=SEARCH user=minyonglee1 FE 응답 행 525 · 원천 Doc\verify\SCP0007\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "fromSite": "WA00-P", "toSite": "ALL", "incoterms": "ALL", "incotermsSsp": "ALL", "transMode": "ALL", "inputStatus": "C", "validYn": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "p_from_site": "WA00-P", "p_to_site": "", "p_incoterms": "", "p_incoterms_ssp": "", "p_trans_mode": "", "p_input_status": "C", "p_valid": "Y", "debug_mode": "F"}` · 번역 메모: p_to_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms_ssp: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_trans_mode: 'ALL'→''(all_semantics: 빈 값 = 전체)

### 결과셋 1  As-is 476행 ↔ To-Be O_RC 524행
- 행수 불일치 476 ↔ 524
- 값 차이: As-is 전용 1행 / To-Be 전용 49행 (공통 컬럼 40)
| 측 | DIVISION_ID | BOD_ID | CUSTOMER | INCOTERMS | INCOTERMS_SSP | FROM_SITE_CODE | TO_SITE_CODE | FROM_COUNTRY | FROM_CITY | TO_COUNTRY | TO_CITY | TRANSPORT_MODE_CODE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81 | 20905 |  | FCA | FCA | WA00-P | BMW_CZ_MOS | PL | PLWRO |  |  | TRK |
| T | 81 | 1046 | Audi | DAP | DAP | WA00-P | Audi_BE_BRU | PL | PLWRO |  |  | TRK |
| T | 81 | 10662 | PSA | DAP | DAP | WA00-P | PSA_FR_POI | PL | PLWRO | FR | FRPOI | TRK |
| T | 81 | 10682 | ICPT(OTS) | EXW | EXW | WA00-P | ICPT(OTS)_PL_WAW | PL | PLWRO | PL | PLWAW | TRK |
| T | 81 | 1261 | PSA | FOB | FOB | WA00-P | PSA_FR_SHX | PL | PLWRO | FR | FRSHX | SEA |
| T | 81 | 1365 | PSA | FCA | FCA | WA00-P | PSA_FR_SHX | PL | PLWRO | FR | FRSHX | SEA |
| T | 81 | 16813 | Ford | Z01 | Z01 | WA00-P | Piston_US_RDF | PL | PLWRO | US | USRDF | AIR |
| T | 81 | 16818 | LGESDJ | Z01 | Z01 | WA00-P | LGCDJ_KR_TJN | PL | PLWRO | KR | KRTJN | AIR |
| T | 81 | 16819 | LGESDJ | Z01 | Z01 | WA00-P | LGCDJ_KR_TJN | PL | PLWRO | KR | KRTJN | SEA |
| T | 81 | 16820 | LGESPI | Z02 | Z02 | WA00-P | LGCPI_US_TYM | PL | PLWRO | US | USTYM | AIR |
| T | 81 | 16821 | LGESPI | Z02 | Z02 | WA00-P | LGCPI_US_TYM | PL | PLWRO | US | USTYM | SEA |
- 데이터 기준: 공통 475행 · AS-IS 전용 1행 · TO-BE 전용 49행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 475행의 상대 순서): 불일치 — 첫 차이 r1: AS-IS=['81', '5749', '', 'DAP', 'DAP', 'WA00-P'] ↔ TO-BE=['81', '10601', 'ATL', 'EXW', 'EXW', 'WA00-P'] · NULL 정렬 위치 차이 CUSTOMER(빈 값 5행 AS-IS 앞↔TO-BE 뒤) — MSSQL '' 맨 앞 ↔ Oracle NULL 맨 뒤(NULLS LAST): PKG ORDER BY 에 NULLS FIRST 또는 NVL 센티널 적용 대상

## 불일치 셀(≤50) — diff/P_SCP0007_GET_BOD__9.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 20905 | CUSTOMER |  | BMW |
| 20905 | TO_COUNTRY |  | CZ |
| 20905 | TO_CITY |  | CZMOS |
| 20905 | LEAD_TIME |  | 0 |
| 20905 | ROUTE_CHK | N | Y |
| 20905 | route_cnt | 0 | 1 |
| 20905 | vmi_yn |  | N |
