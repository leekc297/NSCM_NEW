# SCP0084 · SCP0084_GET_LONG_TERM_STOCK ↔ PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOCK

- 실행 2026-11-08 17:03:38 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 20행 전 컬럼 일치 · 단독행 AS-IS 59 / TO-BE 59 · 컬럼 집합 차이 AS-IS 전용 [] / TO-BE 전용 ['cellcfbomchk', 'cellcfchk', 'cellcftypechk'] · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+PLANT_ID+ITEM_ID+DEVALUATION_AGE+YYYYMM_VAL+CHARG · golden 집합 판정 DIFF
- 호출 #6 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 80 · 원천 Doc\verify\SCP0084\calls\_verify_레이아웃_조회_묶음_H4_N1_G1_L2__0.json
- TO-BE 인자(FE 본문): `{"yyyymm": "202609", "divisionId": "81_HG", "plantId": "", "longTermTypeCode": "", "debugMode": "F"}`
- AS-IS 인자(번역): `{"p_yyyymm": "202609", "p_division_id": "81_HG", "p_plant_id": "", "p_long_term_type_code": "", "debug_mode": "F"}`

### 결과셋 1  As-is 79행 ↔ To-Be O_RC1 79행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: CELL_CF_TYPE_CHK, CELL_CF_CHK, CELL_CF_BOM_CHK
- 값 차이: As-is 전용 59행 / To-Be 전용 59행 (공통 컬럼 51)
| 측 | YYYYMM | DIVISION_ID | PLANT_DESCRIPTION | PLANT_ID | ITEM_ID | ITEM_NAME | ITEM_UOM | LONG_TERM_TYPE | ITEM_TYPE | PROCESS_GROUP | PROCESS_DETAIL | GPLM_CELL_MODEL |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ACEH1081I-A1-800 | AC,E,H1,81Ah,I,A1 | EA | 장기 | 제품 | Cell | Cell |  |
| A | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ADB22D | Binder ADB22D | KG | 비대상 | 원부자재 | 전극 원자재 | 바인더 |  |
| A | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ADB22D | Binder ADB22D | KG | 비대상 | 원부자재 | 전극 원자재 | 바인더 |  |
| A | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | BT1003M-K5 | BATTERY 고분산용 MWCNT 5KG KRAFT B | KG | 비대상 | 원부자재 | 전극 원자재 | 도전재 |  |
| A | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | BT1003M-K5 | BATTERY 고분산용 MWCNT 5KG KRAFT B | KG | 장기 징후 | 원부자재 | 전극 원자재 | 도전재 |  |
| A | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | EMTP01104AA | TAPE [PET] 0.047mm 20mm㎜ | M | 비대상 | 원부자재 | 팩 부자재 | 기타 포장재 |  |
| A | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | EMTP01104AA | TAPE [PET] 0.047mm 20mm㎜ | M | 장기 징후 | 원부자재 | 팩 부자재 | 기타 포장재 |  |
| A | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ERCD00004AA | Conducting Material SUPER-C65 | KG | 비대상 | 원부자재 | 전극 원자재 | 도전재 |  |
| A | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ERCD00004AA | Conducting Material SUPER-C65 | KG | 비대상 | 원부자재 | 전극 원자재 | 도전재 |  |
| A | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ERCD00004AA | Conducting Material SUPER-C65 | KG | 장기 징후 | 원부자재 | 전극 원자재 | 도전재 |  |
| T | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ACEH1081I-A1-800 | AC,E,H1,81Ah,I,A1 | EA | 장기 | 제품 | Cell | Cell |  |
| T | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ADB22D | Binder ADB22D | KG | 비대상 | 원부자재 | 전극 원자재 | 바인더 |  |
| T | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ADB22D | Binder ADB22D | KG | 비대상 | 원부자재 | 전극 원자재 | 바인더 |  |
| T | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | BT1003M-K5 | BATTERY 고분산용 MWCNT 5KG KRAFT B | KG | 비대상 | 원부자재 | 전극 원자재 | 도전재 |  |
| T | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | BT1003M-K5 | BATTERY 고분산용 MWCNT 5KG KRAFT B | KG | 장기 징후 | 원부자재 | 전극 원자재 | 도전재 |  |
| T | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | EMTP01104AA | TAPE [PET] 0.047mm 20mm㎜ | M | 비대상 | 원부자재 | 팩 부자재 | 기타 포장재 |  |
| T | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | EMTP01104AA | TAPE [PET] 0.047mm 20mm㎜ | M | 장기 징후 | 원부자재 | 팩 부자재 | 기타 포장재 |  |
| T | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ERCD00004AA | Conducting Material SUPER-C65 | KG | 비대상 | 원부자재 | 전극 원자재 | 도전재 |  |
| T | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ERCD00004AA | Conducting Material SUPER-C65 | KG | 비대상 | 원부자재 | 전극 원자재 | 도전재 |  |
| T | ‘26.09 | 81_HG | HG Georgia Auto Prod | HG00 | ERCD00004AA | Conducting Material SUPER-C65 | KG | 장기 징후 | 원부자재 | 전극 원자재 | 도전재 |  |
- 데이터 기준: 공통 79행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 79행의 상대 순서): 불일치 — 첫 차이 r4: AS-IS=['‘26.09', '81_HG', 'HG Georgia Auto Prod', 'HG00', 'ACEH1069I-B1-400', 'AC,E,H1,69.2Ah,I,B1'] ↔ TO-BE=['‘26.09', '81_HG', 'HG Georgia Auto Prod', 'HG00', 'ACEH1069I-B1-400', 'AC,E,H1,69.2Ah,I,B1'] · 센티널 차이 컬럼 CHARG(59행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)
