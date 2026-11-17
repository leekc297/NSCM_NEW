# SCP0007 · SCP0007_GET_BOD ↔ PKG_SCP0007.P_SCP0007_GET_BOD

- 실행 2026-11-14 09:25:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 BOD_ID) — AS-IS 14254행 ↔ TO-BE 2184행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 auto · 키 BOD_ID · golden 집합 판정 DIFF
- 호출 #20 sheet=bod btn=SEARCH user=minyonglee1 FE 응답 행 2185 · 원천 Doc\verify\SCP0007\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "fromSite": "ALL", "toSite": "ALL", "incoterms": "ALL", "incotermsSsp": "ALL", "transMode": "ALL", "inputStatus": "C", "validYn": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "p_from_site": "", "p_to_site": "", "p_incoterms": "", "p_incoterms_ssp": "", "p_trans_mode": "", "p_input_status": "C", "p_valid": "Y", "debug_mode": "F"}` · 번역 메모: p_from_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_to_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms_ssp: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_trans_mode: 'ALL'→''(all_semantics: 빈 값 = 전체)

### 결과셋 1  As-is 14254행 ↔ To-Be O_RC 2184행
- 행수 불일치 14254 ↔ 2184
- 값 차이: As-is 전용 14254행 / To-Be 전용 2184행 (공통 컬럼 40)
| 측 | DIVISION_ID | BOD_ID | CUSTOMER | INCOTERMS | INCOTERMS_SSP | FROM_SITE_CODE | TO_SITE_CODE | FROM_COUNTRY | FROM_CITY | TO_COUNTRY | TO_CITY | TRANSPORT_MODE_CODE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 40 | 10016 | - | FCA | FCA | NJ01-A | IM-Re_CN_NGG | CN | CNNKG | CN | CNNGG | TRK |
| A | 40 | 10169 | - | DAP | DAP | HQ06-A | Bosch PgP_MY_BLE | KR | KRCOJ | MY | MYBLE | AIR |
| A | 40 | 10170 | - | DAP | DAP | HQ06-A | Bosch PgP_MY_BLE | KR | KRCOJ | MY | MYBLE | SEA |
| A | 40 | 10171 | - | DAP | DAP | HQ06-A | Sebang _KR_KWJ | KR | KRCOJ | KR | KRKWJ | TRK |
| A | 40 | 10172 | - | DAP | DAP | NJ01-A | Bosch PgP_MY_BLE | CN | CNNKG | MY | MYBLE | AIR |
| A | 40 | 10173 | - | DAP | DAP | NJ01-A | Bosch PgP_MY_BLE | CN | CNNKG | MY | MYBLE | SEA |
| A | 40 | 10174 | - | CIP | CIP | CN00254300_40-P | Flex Ltd._HK_HKG | CN | CNNKG | HK | HKHKG | AIR |
| A | 40 | 10175 | - | CIP | CIP | CN00254300_40-P | Flex Ltd._HK_HKG | CN | CNNKG | HK | HKHKG | SEA |
| A | 40 | 10176 | - | CIP | CIP | CN00254300_40-P | Flex Ltd._HK_HKG | CN | CNNKG | HK | HKHKG | TRK |
| A | 40 | 10177 | - | CIP | CIP | CN00254300_40-P | Venture_MY_JHB | CN | CNNKG | MY | MYJHB | AIR |
| T | 40 | 10000 | - | DAP | DAP | CN00732500_40-P | HP_MX_MTM | CN | CNCKG | MX | MXMTM | SEA |
| T | 40 | 10006 | - | Z01 | Z01 | NJ01-A | Jiutong_CN_DGG | CN | CNNKG | CN | CNDGG | AIR |
| T | 40 | 10007 | - | Z01 | Z01 | NJ01-A | Jiutong_CN_DGG | CN | CNNKG | CN | CNDGG | SEA |
| T | 40 | 10008 | - | Z01 | Z01 | NJ01-A | Jiutong_CN_DGG | CN | CNNKG | CN | CNDGG | TRK |
| T | 40 | 10194 | - | Z01 | Z01 | NJ01-A | Weidian_CN_AOY | CN | CNNKG | CN | CNAOY | TRK |
| T | 40 | 10215 | - | Z01 | Z01 | NJ01-A | Xianzhong_CN_TSN | CN | CNNKG | CN | CNTSN | TRK |
| T | 40 | 10290 | - | A01 | A01 | NJ01-A | Hanwha Defense_KR_SGM | CN | CNNKG | KR | KRSGM | FRY |
| T | 40 | 10291 | - | A01 | A01 | NJ01-A | Hanwha Defense_KR_SGM | CN | CNNKG | KR | KRSGM | SEA |
| T | 40 | 10383 | - | Z04 | Z04 | NJ01-A | Kingin_CN_DGG | CN | CNNKG | CN | CNDGG | AIR |
| T | 40 | 10384 | - | Z04 | Z04 | NJ01-A | Kingin_CN_DGG | CN | CNNKG | CN | CNDGG | SEA |
- 데이터 기준: 공통 0행 · AS-IS 전용 14254행 · TO-BE 전용 2184행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
