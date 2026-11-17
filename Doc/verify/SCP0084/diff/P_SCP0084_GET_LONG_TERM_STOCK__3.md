# SCP0084 · SCP0084_GET_LONG_TERM_STOCK ↔ PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOCK

- 실행 2026-11-14 13:18:02 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 516행 중 불일치 셀 3 — diff/P_SCP0084_GET_LONG_TERM_STOCK__3.csv · 컬럼 집합 차이 AS-IS 전용 [] / TO-BE 전용 ['cellcfbomchk', 'cellcfchk', 'cellcftypechk'] · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+PLANT_ID+ITEM_ID+DEVALUATION_AGE+YYYYMM_VAL+CHARG · golden 집합 판정 DIFF
- 호출 #3 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 1299 · 원천 Doc\verify\SCP0084\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"yyyymm": "202609", "divisionId": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "plantId": "", "longTermTypeCode": "CODE_5", "debugMode": "F"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_yyyymm": "202609", "p_division_id": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "p_plant_id": "", "p_long_term_type_code": "CODE_5", "debug_mode": "F"}`

### 결과셋 1  As-is 1298행 ↔ To-Be O_RC1 1298행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: CELL_CF_TYPE_CHK, CELL_CF_CHK, CELL_CF_BOM_CHK
- 값 차이: As-is 전용 783행 / To-Be 전용 783행 (공통 컬럼 51)
| 측 | YYYYMM | DIVISION_ID | PLANT_DESCRIPTION | PLANT_ID | ITEM_ID | ITEM_NAME | ITEM_UOM | LONG_TERM_TYPE | ITEM_TYPE | PROCESS_GROUP | PROCESS_DETAIL | GPLM_CELL_MODEL |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EBTT00888AA | TI Linear Regulator TPS70933QD | EA | 장기 징후 | 원부자재 | 팩 부자재 | 기타 팩 부자재 |  |
| A | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | ECT00018AA | TI TCAN1042DRQ1 SOP-8-P1.27 6. | EA | 장기 징후 | 상품 | 팩 부자재 | 기타 팩 부자재 |  |
| A | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EEIC00398AA | TI BQ7694003DBTR TSSOP044 44 F | EA | 장기 징후 | 원부자재 | 팩 부자재 | ASIC |  |
| A | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMFL00212AA | AL Foil 12㎛*555㎜ (High Strengt | KG | 장기 징후 | 원부자재 | 전극 원자재 | Al Foil |  |
| A | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMFL00222AA | AL Foil 12㎛*530㎜ (High Strengt | KG | 장기 징후 | 원부자재 | 전극 원자재 | Al Foil |  |
| A | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMFL00328AA | Cu Foil 10㎛*1240㎜ (High Elonga | KG | 장기 징후 | 원부자재 | 전극 원자재 | Cu Foil |  |
| A | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMTB00004AA | Tab ALUMINUM 0.15T*4㎜ | M | 장기 징후 | 원부자재 | 셀 조립자재 | 기타 셀 조립자재 |  |
| A | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMTB00188AA | Tab NICKEL 0.08T*4㎜ | M | 장기 징후 | 원부자재 | 셀 조립자재 | 기타 셀 조립자재 |  |
| A | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMTP00841AA | TAPE Swelling tape 0.052T*57mm | M | 장기 징후 | 원부자재 | 셀 조립자재 | TAPE |  |
| A | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | ERAA00051AA | Anode Active Material BLSO | KG | 장기 징후 | 원부자재 | 전극 원자재 | 음극재 |  |
| T | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EBTT00888AA | TI Linear Regulator TPS70933QD | EA | 장기 징후 | 원부자재 | 팩 부자재 | 기타 팩 부자재 |  |
| T | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | ECT00018AA | TI TCAN1042DRQ1 SOP-8-P1.27 6. | EA | 장기 징후 | 상품 | 팩 부자재 | 기타 팩 부자재 |  |
| T | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EEIC00398AA | TI BQ7694003DBTR TSSOP044 44 F | EA | 장기 징후 | 원부자재 | 팩 부자재 | ASIC |  |
| T | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMFL00212AA | AL Foil 12㎛*555㎜ (High Strengt | KG | 장기 징후 | 원부자재 | 전극 원자재 | Al Foil |  |
| T | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMFL00222AA | AL Foil 12㎛*530㎜ (High Strengt | KG | 장기 징후 | 원부자재 | 전극 원자재 | Al Foil |  |
| T | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMFL00328AA | Cu Foil 10㎛*1240㎜ (High Elonga | KG | 장기 징후 | 원부자재 | 전극 원자재 | Cu Foil |  |
| T | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMTB00004AA | Tab ALUMINUM 0.15T*4㎜ | M | 장기 징후 | 원부자재 | 셀 조립자재 | 기타 셀 조립자재 |  |
| T | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMTB00188AA | Tab NICKEL 0.08T*4㎜ | M | 장기 징후 | 원부자재 | 셀 조립자재 | 기타 셀 조립자재 |  |
| T | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | EMTP00841AA | TAPE Swelling tape 0.052T*57mm | M | 장기 징후 | 원부자재 | 셀 조립자재 | TAPE |  |
| T | ‘26.09 | 40 | HQ OC1 Mobile Prod | HQ06 | ERAA00051AA | Anode Active Material BLSO | KG | 장기 징후 | 원부자재 | 전극 원자재 | 음극재 |  |
- 데이터 기준: 공통 1297행 · AS-IS 전용 1행 · TO-BE 전용 1행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1297행의 상대 순서): 불일치 — 첫 차이 r2: AS-IS=['‘26.09', '40', 'HQ OC1 Mobile Prod', 'HQ06', 'APCAN1199A', 'MCCH114030D3 0014 18'] ↔ TO-BE=['‘26.09', '40', 'HQ OC1 Mobile Prod', 'HQ06', 'APCAN1199A', 'MCCH114030D3 0014 18'] · 센티널 차이 컬럼 CHARG(782행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)

## 불일치 셀(≤50) — diff/P_SCP0084_GET_LONG_TERM_STOCK__3.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 81_ST|ST00|APCCA3098D|GRM03|202609|DUMMY | CELL_CF_TYPE | BOM | WCF |
| 81_ST|ST00|APCCA3098D|GRM03|202609|DUMMY | CELL_CF |  | 0.194583 |
| 81_ST|ST00|APCCA3098D|GRM03|202609|DUMMY | CELL_CF_BOM | 0.194583 |  |
