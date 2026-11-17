# SCP0007 · SCP0007_GET_BOD ↔ PKG_SCP0007.P_SCP0007_GET_BOD

- 실행 2026-11-14 09:25:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 49행 전 컬럼 일치 · 단독행 AS-IS 0 / TO-BE 1 · 키 원천 auto · 키 BOD_ID · golden 집합 판정 DIFF
- 호출 #13 sheet=bod btn=SEARCH user=minyonglee1 FE 응답 행 51 · 원천 Doc\verify\SCP0007\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "fromSite": "ALL", "toSite": "ALL", "incoterms": "CFR", "incotermsSsp": "ALL", "transMode": "ALL", "inputStatus": "C", "validYn": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "p_from_site": "", "p_to_site": "", "p_incoterms": "CFR", "p_incoterms_ssp": "", "p_trans_mode": "", "p_input_status": "C", "p_valid": "Y", "debug_mode": "F"}` · 번역 메모: p_from_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_to_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms_ssp: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_trans_mode: 'ALL'→''(all_semantics: 빈 값 = 전체)

### 결과셋 1  As-is 49행 ↔ To-Be O_RC 50행
- 행수 불일치 49 ↔ 50
- 값 차이: As-is 전용 0행 / To-Be 전용 1행 (공통 컬럼 40)
| 측 | DIVISION_ID | BOD_ID | CUSTOMER | INCOTERMS | INCOTERMS_SSP | FROM_SITE_CODE | TO_SITE_CODE | FROM_COUNTRY | FROM_CITY | TO_COUNTRY | TO_CITY | TRANSPORT_MODE_CODE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 82 | 4394 | LGU+ | CFR | CFR | KR00797800-P | LGU+_KR_SEL | US | USAAZ | KR | KRSEL | TRK |
- 데이터 기준: 공통 49행 · AS-IS 전용 0행 · TO-BE 전용 1행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 49행의 상대 순서): 불일치 — 첫 차이 r14: AS-IS=['82', '560', 'Energy & HVAC', 'CFR', 'CFR', 'CN00249500-P'] ↔ TO-BE=['82', '4075', 'ENERGYGATE', 'CFR', 'CFR', 'CN00249500-P']
