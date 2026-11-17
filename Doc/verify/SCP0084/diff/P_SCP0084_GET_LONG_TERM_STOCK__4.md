# SCP0084 · SCP0084_GET_LONG_TERM_STOCK ↔ PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOCK

- 실행 2026-11-14 13:18:02 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 4716행 중 불일치 셀 12 — diff/P_SCP0084_GET_LONG_TERM_STOCK__4.csv · 컬럼 집합 차이 AS-IS 전용 [] / TO-BE 전용 ['cellcfbomchk', 'cellcfchk', 'cellcftypechk'] · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+PLANT_ID+ITEM_ID+DEVALUATION_AGE+YYYYMM_VAL+CHARG · golden 집합 판정 DIFF
- 호출 #4 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 None · 원천 Doc\verify\SCP0084\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"yyyymm": "202609", "divisionId": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "plantId": "", "longTermTypeCode": "CODE_2,CODE_5,CODE_6", "debugMode": "F"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_yyyymm": "202609", "p_division_id": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "p_plant_id": "", "p_long_term_type_code": "CODE_2,CODE_5,CODE_6", "debug_mode": "F"}`

### 결과셋 1  As-is 10274행 ↔ To-Be O_RC1 10274행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: CELL_CF_TYPE_CHK, CELL_CF_CHK, CELL_CF_BOM_CHK
- 값 차이: As-is 전용 5561행 / To-Be 전용 5561행 (공통 컬럼 51)
| 측 | YYYYMM | DIVISION_ID | PLANT_DESCRIPTION | PLANT_ID | ITEM_ID | ITEM_NAME | ITEM_UOM | LONG_TERM_TYPE | ITEM_TYPE | PROCESS_GROUP | PROCESS_DETAIL | GPLM_CELL_MODEL |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | BT1001M-K5 | BATTERY 비정제 일반 MWCNT 5KG KRAFT | KG | 비대상 | 원부자재 | 전극 원자재 | 도전재 |  |
| A | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | CMHN915L | Cathode Active Material CMHN91 | KG | 비대상 | 원부자재 | 전극 원자재 | 양극재 |  |
| A | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | CMHN916S | Cathode Active Material CMHN91 | KG | 비대상 | 원부자재 | 전극 원자재 | 양극재 |  |
| A | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | ERAA00051AA | Anode Active Material BLSO | KG | 비대상 | 원부자재 | 전극 원자재 | 음극재 |  |
| A | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | ERAA00051AA | Anode Active Material BLSO | KG | 비대상 | 원부자재 | 전극 원자재 | 음극재 |  |
| A | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | ERSV00013AA | NMP 99.85 | KG | 비대상 | 원부자재 | 전극 원자재 | Solvent |  |
| A | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | MCB00448AA | Seam Welding Lid [Steel] 0.6t  | EA | 비대상 | 원부자재 | 셀 조립자재 | CAP |  |
| A | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | MCB00621AA | Seam Welding Lid [Steel] 0.6t  | EA | 비대상 | 원부자재 | 셀 조립자재 | CAP |  |
| A | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | MCB00642AA | Seam Welding Lid [Steel] 0.6t  | EA | 비대상 | 원부자재 | 셀 조립자재 | CAP |  |
| A | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | MCB00649AA | Seam Welding Lid [Steel] 0.6t  | EA | 비대상 | 원부자재 | 셀 조립자재 | CAP |  |
| T | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | BT1001M-K5 | BATTERY 비정제 일반 MWCNT 5KG KRAFT | KG | 비대상 | 원부자재 | 전극 원자재 | 도전재 |  |
| T | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | CMHN915L | Cathode Active Material CMHN91 | KG | 비대상 | 원부자재 | 전극 원자재 | 양극재 |  |
| T | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | CMHN916S | Cathode Active Material CMHN91 | KG | 비대상 | 원부자재 | 전극 원자재 | 양극재 |  |
| T | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | ERAA00051AA | Anode Active Material BLSO | KG | 비대상 | 원부자재 | 전극 원자재 | 음극재 |  |
| T | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | ERAA00051AA | Anode Active Material BLSO | KG | 비대상 | 원부자재 | 전극 원자재 | 음극재 |  |
| T | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | ERSV00013AA | NMP 99.85 | KG | 비대상 | 원부자재 | 전극 원자재 | Solvent |  |
| T | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | MCB00448AA | Seam Welding Lid [Steel] 0.6t  | EA | 비대상 | 원부자재 | 셀 조립자재 | CAP |  |
| T | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | MCB00621AA | Seam Welding Lid [Steel] 0.6t  | EA | 비대상 | 원부자재 | 셀 조립자재 | CAP |  |
| T | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | MCB00642AA | Seam Welding Lid [Steel] 0.6t  | EA | 비대상 | 원부자재 | 셀 조립자재 | CAP |  |
| T | ‘26.09 | 40 | AZ Arizona Mobile Prod | AZ00 | MCB00649AA | Seam Welding Lid [Steel] 0.6t  | EA | 비대상 | 원부자재 | 셀 조립자재 | CAP |  |
- 데이터 기준: 공통 10271행 · AS-IS 전용 3행 · TO-BE 전용 3행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 10271행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['‘26.09', '40', 'AZ Arizona Mobile Pr', 'AZ00', 'AJRJR1212A', 'MCMM9314U0A1-018 469'] ↔ TO-BE=['‘26.09', '40', 'AZ Arizona Mobile Pr', 'AZ00', 'AJRJR1212A', 'MCMM9314U0A1-018 469'] · 센티널 차이 컬럼 CHARG(5558행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)

## 불일치 셀(≤50) — diff/P_SCP0084_GET_LONG_TERM_STOCK__4.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 82|WA01|ETD1550BGB32|GRM02|202609|DUMMY | GPLM_CELL_CONVERSION_FACTOR | 10080 | 336 |
| 82|WA01|ETD1550BGB32|GRM02|202609|DUMMY | CELL_CONVER_FACTOR | 10080 | 336 |
| 82|WA01|ETD1550BGB32|GRM02|202609|DUMMY | CELL_CONVER_FACTOR_XLS | 10080 | 336 |
| 82|WA01|ETD1550BGB32|GRM02|202609|DUMMY | CELL_CONVER_QUANTITY | 10080 | 336 |
| 82|WA01|ETD1550BGB32|GRM02|202609|DUMMY | CELL_CONVER_QUANTITY_XLS | 10080 | 336 |
| 40|HQ06|APCAN1650A|GRM00|202609|DUMMY | CELL_CF_TYPE | WCF | BOM |
| 81_ST|ST00|APCCA3098D|GRM03|202609|DUMMY | CELL_CF_TYPE | BOM | WCF |
| 40|HQ06|APCAN1650A|GRM00|202609|DUMMY | CELL_CF | 1 |  |
| 81_ST|ST00|APCCA3098D|GRM03|202609|DUMMY | CELL_CF |  | 0.194583 |
| 82|WA01|ETD1550BGB32|GRM02|202609|DUMMY | CELL_CF | 10080 | 336 |
| 40|HQ06|APCAN1650A|GRM00|202609|DUMMY | CELL_CF_BOM |  | 1 |
| 81_ST|ST00|APCCA3098D|GRM03|202609|DUMMY | CELL_CF_BOM | 0.194583 |  |
