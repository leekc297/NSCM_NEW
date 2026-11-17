# SCP0007 · SCP0007_GET_BOD ↔ PKG_SCP0007.P_SCP0007_GET_BOD

- 실행 2026-11-14 09:25:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 2145행 중 불일치 셀 15 — diff/P_SCP0007_GET_BOD__23.csv · 키 원천 auto · 키 BOD_ID · golden 집합 판정 DIFF
- 호출 #23 sheet=bod btn=SEARCH user=minyonglee1 FE 응답 행 2431 · 원천 Doc\verify\SCP0007\calls\_trace_W4d_잔여_판정필요_실측_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "fromSite": "ALL", "toSite": "ALL", "incoterms": "ALL", "incotermsSsp": "ALL", "transMode": "ALL", "inputStatus": "C", "validYn": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_from_site": "", "p_to_site": "", "p_incoterms": "", "p_incoterms_ssp": "", "p_trans_mode": "", "p_input_status": "C", "p_valid": "Y", "debug_mode": "F"}` · 번역 메모: p_from_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_to_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms_ssp: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_trans_mode: 'ALL'→''(all_semantics: 빈 값 = 전체)

### 결과셋 1  As-is 2145행 ↔ To-Be O_RC 2430행
- 행수 불일치 2145 ↔ 2430
- 값 차이: As-is 전용 3행 / To-Be 전용 288행 (공통 컬럼 40)
| 측 | DIVISION_ID | BOD_ID | CUSTOMER | INCOTERMS | INCOTERMS_SSP | FROM_SITE_CODE | TO_SITE_CODE | FROM_COUNTRY | FROM_CITY | TO_COUNTRY | TO_CITY | TRANSPORT_MODE_CODE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81 | 20905 |  | FCA | FCA | WA00-P | BMW_CZ_MOS | PL | PLWRO |  |  | TRK |
| A | 81 | 21099 |  | DAP | DAP | HQ07-A | Sungwoo Hightech_KR_PUS | KR | KRCOJ |  |  | TRK |
| A | 81 | 8641 | Audi | DAP | DAP | HQ07-A | Audi_DE_NEM | KR | KRCOJ | DE | DENEM | AIR |
| T | 81 | 1032 | FCA | Z02 | Z02 | MI00-P | FCA_CA_WND | US | USHLM | CA | CAWND | TRK |
| T | 81 | 1034 | Landsuccess | Z04 | Z04 | NA00-A | Landsuccess_CN_SZX | CN | CNNKG | CN | CNSZX | TRK |
| T | 81 | 1046 | Audi | DAP | DAP | WA00-P | Audi_BE_BRU | PL | PLWRO |  |  | TRK |
| T | 81 | 10478 | HKMC | DAP | DAP | WA00-A | HLGP_KR_CHU | PL | PLWRO | KR | KRCHU | AIR |
| T | 81 | 10479 | HKMC | DAP | DAP | WA00-A | HLGP_KR_CHU | PL | PLWRO | KR | KRCHU | SEA |
| T | 81 | 10662 | PSA | DAP | DAP | WA00-P | PSA_FR_POI | PL | PLWRO | FR | FRPOI | TRK |
| T | 81 | 10677 | GM | Z02 | Z02 | MI03-P | LGE_US_LRP | US | USHLM | US | USLRP | TRK |
| T | 81 | 10682 | ICPT(OTS) | EXW | EXW | WA00-P | ICPT(OTS)_PL_WAW | PL | PLWRO | PL | PLWAW | TRK |
| T | 81 | 10750 | ICPT(OTS) | EXW | EXW | WA00-A | ICPT(OTS)_PL_WAW | PL | PLWRO | PL | PLWAW | TRK |
| T | 81 | 10757 | HKMC | Z02 | Z02 | NB01-A | MOBIS_KR_CHU | CN | CNNKG | KR | KRCHU | FRY |
- 데이터 기준: 공통 2142행 · AS-IS 전용 3행 · TO-BE 전용 288행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 2142행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['81', '5926', '', 'DAP', 'FOB', 'HQ05-W'] ↔ TO-BE=['81', '19674', 'ANDURIL', 'CIP', 'CIP', 'WA00-A'] · NULL 정렬 위치 차이 CUSTOMER(빈 값 132행 AS-IS 앞↔TO-BE 뒤), vmi_yn(빈 값 4행 AS-IS 앞↔TO-BE 뒤) — MSSQL '' 맨 앞 ↔ Oracle NULL 맨 뒤(NULLS LAST): PKG ORDER BY 에 NULLS FIRST 또는 NVL 센티널 적용 대상

## 불일치 셀(≤50) — diff/P_SCP0007_GET_BOD__23.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 21099 | CUSTOMER |  | HKMC |
| 20905 | CUSTOMER |  | BMW |
| 21099 | TO_COUNTRY |  | KR |
| 20905 | TO_COUNTRY |  | CZ |
| 21099 | TO_CITY |  | KRPUS |
| 20905 | TO_CITY |  | CZMOS |
| 8641 | PRIORITY | 2 | 10 |
| 21099 | LEAD_TIME |  | 1 |
| 20905 | LEAD_TIME |  | 0 |
| 21099 | ROUTE_CHK | N | Y |
| 20905 | ROUTE_CHK | N | Y |
| 21099 | route_cnt | 0 | 1 |
| 20905 | route_cnt | 0 | 1 |
| 21099 | vmi_yn |  | N |
| 20905 | vmi_yn |  | N |
