# SCP0084 · SCP0084_GET_LONG_TERM_STOCK ↔ PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOCK

- 실행 2026-11-08 17:03:38 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 1825행 전 컬럼 일치 · 단독행 AS-IS 4322 / TO-BE 4322 · 컬럼 집합 차이 AS-IS 전용 [] / TO-BE 전용 ['cellcfbomchk', 'cellcfchk', 'cellcftypechk'] · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+PLANT_ID+ITEM_ID+DEVALUATION_AGE+YYYYMM_VAL+CHARG · golden 집합 판정 DIFF
- 호출 #7 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 6148 · 원천 Doc\verify\SCP0084\calls\_verify_선택_조회_복수_단일_전체_왕복_G2_B6__0.json
- TO-BE 인자(FE 본문): `{"yyyymm": "202609", "divisionId": "40,81", "plantId": "", "longTermTypeCode": "", "debugMode": "F"}`
- AS-IS 인자(번역): `{"p_yyyymm": "202609", "p_division_id": "40,81", "p_plant_id": "", "p_long_term_type_code": "", "debug_mode": "F"}`

### 결과셋 1  As-is 6147행 ↔ To-Be O_RC1 6147행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: CELL_CF_TYPE_CHK, CELL_CF_CHK, CELL_CF_BOM_CHK
- 값 차이: As-is 전용 4322행 / To-Be 전용 4322행 (공통 컬럼 51)
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
- 데이터 기준: 공통 6147행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 6147행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['‘26.09', '40', 'AZ Arizona Mobile Pr', 'AZ00', 'AJRJR1212A', 'MCMM9314U0A1-018 469'] ↔ TO-BE=['‘26.09', '40', 'AZ Arizona Mobile Pr', 'AZ00', 'AJRJR1212A', 'MCMM9314U0A1-018 469'] · 센티널 차이 컬럼 CHARG(4322행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)
