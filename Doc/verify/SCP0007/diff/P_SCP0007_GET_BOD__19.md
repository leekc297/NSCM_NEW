# SCP0007 · SCP0007_GET_BOD ↔ PKG_SCP0007.P_SCP0007_GET_BOD

- 실행 2026-11-14 09:25:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 14254행 중 불일치 셀 364 — diff/P_SCP0007_GET_BOD__19.csv · 키 원천 auto · 키 BOD_ID · golden 집합 판정 DIFF
- 호출 #19 sheet=bod btn=SEARCH user=minyonglee1 FE 응답 행 None · 원천 Doc\verify\SCP0007\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "fromSite": "ALL", "toSite": "ALL", "incoterms": "ALL", "incotermsSsp": "ALL", "transMode": "ALL", "inputStatus": "C", "validYn": "Y"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "p_from_site": "", "p_to_site": "", "p_incoterms": "", "p_incoterms_ssp": "", "p_trans_mode": "", "p_input_status": "C", "p_valid": "Y", "debug_mode": "F"}` · 번역 메모: p_from_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_to_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms_ssp: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_trans_mode: 'ALL'→''(all_semantics: 빈 값 = 전체)

### 결과셋 1  As-is 14254행 ↔ To-Be O_RC 14255행
- 행수 불일치 14254 ↔ 14255
- 값 차이: As-is 전용 102행 / To-Be 전용 103행 (공통 컬럼 40)
| 측 | DIVISION_ID | BOD_ID | CUSTOMER | INCOTERMS | INCOTERMS_SSP | FROM_SITE_CODE | TO_SITE_CODE | FROM_COUNTRY | FROM_CITY | TO_COUNTRY | TO_CITY | TRANSPORT_MODE_CODE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 40 | 14432 | - | DAP | DAP | HQ06-A | BMZ_DE_KSN | KR | KRCOJ |  |  | AIR |
| A | 40 | 14433 | - | DAP | DAP | HQ06-A | BMZ_DE_KSN | KR | KRCOJ |  |  | SEA |
| A | 40 | 18000 | - | DDP | DDP | HQ06-A | HUAYOU_CN_NJG | KR | KRCOJ | CN | CNNJG | AIR |
| A | 40 | 18001 | - | DDP | DDP | HQ06-A | HUAYOU_CN_NJG | KR | KRCOJ | CN | CNNJG | SEA |
| A | 40 | 18271 | - | CIF | CIF | NJ01-A | HUAYOU_HK_YUE | CN | CNNKG | HK | HKYUE | AIR |
| A | 40 | 18272 | - | CIF | CIF | NJ01-A | HUAYOU_HK_YUE | CN | CNNKG | HK | HKYUE | TRK |
| A | 40 | 1927 | - | CIP | CIP | HQ06-A | BMZ_DE_KSN | KR | KRCOJ |  |  | AIR |
| A | 40 | 1928 | - | CIP | CIP | HQ06-A | BMZ_DE_KSN | KR | KRCOJ |  |  | SEA |
| A | 40 | 19341 | - | DAP | DAP | NJ01-A | HUAYOU_CN_NJP | CN | CNNKG | CN | CNNJP | TRK |
| A | 40 | 1973 | - | CIP | CIP | NJ01-A | BMZ_DE_KSN | CN | CNNKG |  |  | AIR |
| T | 40 | 14432 | - | DAP | DAP | HQ06-A | BMZ_DE_KSN | KR | KRCOJ | DE | DEKSN | AIR |
| T | 40 | 14433 | - | DAP | DAP | HQ06-A | BMZ_DE_KSN | KR | KRCOJ | DE | DEKSN | SEA |
| T | 40 | 18000 | - | DDP | DDP | HQ06-A | HUAYOU_CN_NJG | KR | KRCOJ |  |  | AIR |
| T | 40 | 18001 | - | DDP | DDP | HQ06-A | HUAYOU_CN_NJG | KR | KRCOJ |  |  | SEA |
| T | 40 | 18271 | - | CIF | CIF | NJ01-A | HUAYOU_HK_YUE | CN | CNNKG |  |  | AIR |
| T | 40 | 18272 | - | CIF | CIF | NJ01-A | HUAYOU_HK_YUE | CN | CNNKG |  |  | TRK |
| T | 40 | 1927 | - | CIP | CIP | HQ06-A | BMZ_DE_KSN | KR | KRCOJ | DE | DEKSN | AIR |
| T | 40 | 1928 | - | CIP | CIP | HQ06-A | BMZ_DE_KSN | KR | KRCOJ | DE | DEKSN | SEA |
| T | 40 | 19341 | - | DAP | DAP | NJ01-A | HUAYOU_CN_NJP | CN | CNNKG |  |  | TRK |
| T | 40 | 1973 | - | CIP | CIP | NJ01-A | BMZ_DE_KSN | CN | CNNKG | DE | DEKSN | AIR |
- 데이터 기준: 공통 14152행 · AS-IS 전용 102행 · TO-BE 전용 103행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 14152행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['40', '2942', '', 'CIP', 'CIP', 'NJ01-A'] ↔ TO-BE=['40', '20597', '', 'CFR', 'CFR', 'NJ01-A']

## 불일치 셀(≤50) — diff/P_SCP0007_GET_BOD__19.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 21099 | CUSTOMER |  | HKMC |
| 20905 | CUSTOMER |  | BMW |
| 21114 | CUSTOMER |  | Hanwha Q Cells |
| 20957 | CUSTOMER |  | Critical Loop Equipment |
| 20958 | CUSTOMER |  | Critical Loop Equipment |
| 21109 | TO_COUNTRY |  | ID |
| 20923 | TO_COUNTRY |  | ID |
| 20956 | TO_COUNTRY |  | DE |
| 20955 | TO_COUNTRY |  | DE |
| 20925 | TO_COUNTRY |  | PL |
| 21128 | TO_COUNTRY |  | CN |
| 20960 | TO_COUNTRY |  | IN |
| 21119 | TO_COUNTRY |  | HK |
| 21127 | TO_COUNTRY |  | HK |
| 21126 | TO_COUNTRY |  | HK |
| 20927 | TO_COUNTRY |  | DE |
| 21074 | TO_COUNTRY |  | DE |
| 20949 | TO_COUNTRY |  | IN |
| 20950 | TO_COUNTRY |  | IN |
| 21115 | TO_COUNTRY |  | IN |
| 21116 | TO_COUNTRY |  | IN |
| 20961 | TO_COUNTRY |  | IN |
| 18272 | TO_COUNTRY | HK |  |
| 18271 | TO_COUNTRY | HK |  |
| 1928 | TO_COUNTRY |  | DE |
| 1927 | TO_COUNTRY |  | DE |
| 1974 | TO_COUNTRY |  | DE |
| 1973 | TO_COUNTRY |  | DE |
| 14433 | TO_COUNTRY |  | DE |
| 14432 | TO_COUNTRY |  | DE |
| 20007 | TO_COUNTRY | HK |  |
| 20008 | TO_COUNTRY | HK |  |
| 20003 | TO_COUNTRY | HK |  |
| 20005 | TO_COUNTRY | HK |  |
| 20006 | TO_COUNTRY | HK |  |
| 20004 | TO_COUNTRY | HK |  |
| 2055 | TO_COUNTRY |  | DE |
| 2054 | TO_COUNTRY |  | DE |
| 19341 | TO_COUNTRY | CN |  |
| 20017 | TO_COUNTRY | HK |  |
| 20018 | TO_COUNTRY | HK |  |
| 20015 | TO_COUNTRY | HK |  |
| 20016 | TO_COUNTRY | HK |  |
| 20013 | TO_COUNTRY | HK |  |
| 20014 | TO_COUNTRY | HK |  |
| 5301 | TO_COUNTRY |  | DE |
| 5300 | TO_COUNTRY |  | DE |
| 18001 | TO_COUNTRY | CN |  |
| 18000 | TO_COUNTRY | CN |  |
| 5305 | TO_COUNTRY |  | DE |
