# SCP0084 · SCP0084_GET_LONG_TERM_STOCK ↔ PKG_SCP0084.P_SCP0084_GET_LONG_TERM_STOCK

- 실행 2026-11-08 17:03:38 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 1107행 전 컬럼 일치 · 단독행 AS-IS 3003 / TO-BE 3003 · 컬럼 집합 차이 AS-IS 전용 [] / TO-BE 전용 ['cellcfbomchk', 'cellcfchk', 'cellcftypechk'] · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+PLANT_ID+ITEM_ID+DEVALUATION_AGE+YYYYMM_VAL+CHARG · golden 집합 판정 DIFF
- 호출 #5 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 4111 · 원천 Doc\verify\SCP0084\calls\_trace_W4d_잔여_판정필요_실측_0.json
- TO-BE 인자(FE 본문): `{"yyyymm": "202609", "divisionId": "81", "plantId": "", "longTermTypeCode": "", "debugMode": "F"}`
- AS-IS 인자(번역): `{"p_yyyymm": "202609", "p_division_id": "81", "p_plant_id": "", "p_long_term_type_code": "", "debug_mode": "F"}`

### 결과셋 1  As-is 4110행 ↔ To-Be O_RC1 4110행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: CELL_CF_TYPE_CHK, CELL_CF_CHK, CELL_CF_BOM_CHK
- 값 차이: As-is 전용 3003행 / To-Be 전용 3003행 (공통 컬럼 51)
| 측 | YYYYMM | DIVISION_ID | PLANT_DESCRIPTION | PLANT_ID | ITEM_ID | ITEM_NAME | ITEM_UOM | LONG_TERM_TYPE | ITEM_TYPE | PROCESS_GROUP | PROCESS_DETAIL | GPLM_CELL_MODEL |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ADB22D | Binder ADB22D | KG | 장기 | 원부자재 | 전극 원자재 | 바인더 |  |
| A | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | EABS00035AA | GM_VOLT_GEN2_MP_BMS | EA | 비대상 | 상품 | 팩 부자재 | BMS |  |
| A | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | EAPJ00235AA | VCC_HRE_VP_MSD Plug | EA | 장기 | 원부자재 | 팩 부자재 | ASSEMBLY |  |
| A | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | EBA00230AE | HW LGIT Renault BEV L38 LR BMS | EA | 장기 | 원부자재 | 팩 부자재 | BMS |  |
| A | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02177AA | FFC_1 MBAG EB565M A-TYPE PET 2 | EA | 비대상 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
| A | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02177AA | FFC_1 MBAG EB565M A-TYPE PET 2 | EA | 장기 징후 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
| A | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02178AA | FFC_4 MBAG EB565M B-TYPE PET 2 | EA | 비대상 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
| A | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02178AA | FFC_4 MBAG EB565M B-TYPE PET 2 | EA | 장기 징후 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
| A | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02179AA | FFC_3 MBAG EB565M B-TYPE PET 2 | EA | 비대상 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
| A | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02179AA | FFC_3 MBAG EB565M B-TYPE PET 2 | EA | 장기 징후 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
| T | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ADB22D | Binder ADB22D | KG | 장기 | 원부자재 | 전극 원자재 | 바인더 |  |
| T | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | EABS00035AA | GM_VOLT_GEN2_MP_BMS | EA | 비대상 | 상품 | 팩 부자재 | BMS |  |
| T | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | EAPJ00235AA | VCC_HRE_VP_MSD Plug | EA | 장기 | 원부자재 | 팩 부자재 | ASSEMBLY |  |
| T | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | EBA00230AE | HW LGIT Renault BEV L38 LR BMS | EA | 장기 | 원부자재 | 팩 부자재 | BMS |  |
| T | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02177AA | FFC_1 MBAG EB565M A-TYPE PET 2 | EA | 비대상 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
| T | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02177AA | FFC_1 MBAG EB565M A-TYPE PET 2 | EA | 장기 징후 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
| T | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02178AA | FFC_4 MBAG EB565M B-TYPE PET 2 | EA | 비대상 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
| T | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02178AA | FFC_4 MBAG EB565M B-TYPE PET 2 | EA | 장기 징후 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
| T | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02179AA | FFC_3 MBAG EB565M B-TYPE PET 2 | EA | 비대상 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
| T | ‘26.09 | 81 | HQ OC1 Auto Prod | HQ07 | ECW02179AA | FFC_3 MBAG EB565M B-TYPE PET 2 | EA | 장기 징후 | 원부자재 | 팩 부자재 | CABLE & WIRE |  |
- 데이터 기준: 공통 4110행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 4110행의 상대 순서): 불일치 — 첫 차이 r1: AS-IS=['‘26.09', '81', '한국 전지 서비스', 'HQ05', 'ACEN1063I-D1', 'AC,E,N1,63Ah,I,D1'] ↔ TO-BE=['‘26.09', '81', '한국 전지 서비스', 'HQ05', 'ACEN1063I-D1', 'AC,E,N1,63Ah,I,D1'] · 센티널 차이 컬럼 CHARG(3003행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)
