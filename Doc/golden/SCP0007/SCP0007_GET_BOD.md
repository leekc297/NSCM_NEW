# SCP0007 · SCP0007_GET_BOD ↔ PKG_SCP0007.P_SCP0007_GET_BOD

- 실행: 2026-11-14 07:37:13
- 파라미터: `{"p_division_id": "40", "p_from_site": "", "p_to_site": "", "p_incoterms": "", "p_incoterms_ssp": "", "p_trans_mode": "", "p_input_status": "C", "p_valid": "Y", "debug_mode": "F"}`
- 종류: GET
- To-Be 인자 중 값 없음(NULL 전달): P_VALID_YN

### 결과셋 1  As-is 6549행 ↔ To-Be O_RC 8194행
- 행수 불일치 6549 ↔ 8194
- 값 차이: As-is 전용 51행 / To-Be 전용 1696행 (공통 컬럼 40)
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
- 데이터 기준: 공통 6498행 · AS-IS 전용 51행 · TO-BE 전용 1696행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 6498행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['40', '2942', '', 'CIP', 'CIP', 'NJ01-A'] ↔ TO-BE=['40', '20597', '', 'CFR', 'CFR', 'NJ01-A'] · NULL 정렬 위치 차이 CUSTOMER(빈 값 119행 AS-IS 앞↔TO-BE 뒤), vmi_yn(빈 값 25행 AS-IS 앞↔TO-BE 뒤) — MSSQL '' 맨 앞 ↔ Oracle NULL 맨 뒤(NULLS LAST): PKG ORDER BY 에 NULLS FIRST 또는 NVL 센티널 적용 대상
