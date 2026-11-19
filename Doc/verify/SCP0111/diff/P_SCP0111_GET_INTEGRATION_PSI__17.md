# SCP0111 · SCP0111_GET_INTEGRATION_PSI ↔ PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI

- 실행 2026-11-19 12:12:39 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 0행/TO-BE 2행(공통 0 · AS-IS 전용 0 · TO-BE 전용 2) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #17 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 3 · 원천 Doc\verify\SCP0111\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "planStartYyyymmdd": "20261026", "planType": "", "seq": "", "fromYyyymm": "202610", "toYyyymm": "202703", "nickName": "", "cellItemId": "", "itemId": "MFMCC727-F1-02", "qtyYn": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plan_start_yyyymmdd": "20261026", "p_plan_type": "", "p_seq": "", "p_from_yyyymm": "202610", "p_to_yyyymm": "202703", "p_nick_name": "", "p_cellitem_id": "", "p_item_id": "MFMCC727-F1-02", "p_qty_yn": "N"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "81", "p_plan_start_yyyymmdd": "20261026", "p_plan_type": "ALL", "p_seq": "ALL", "p_from_yyyymm": "202610", "p_to_yyyymm": "202703", "p_nick_name": "ALL", "p_cellitem_id": "ALL", "p_item_id": "MFMCC727-F1-02", "p_qty_yn": "N"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC 2행
- 행수 불일치 0 ↔ 2
- 값 차이: As-is 전용 0행 / To-Be 전용 2행 (공통 컬럼 28)
| 측 | DIVISION_ID | COMPANY_ID | PLANT_ID | PLANT_ID_DESCRIPTION | OPERATION_GROUP | CELL_MODEL_NICK_NAME | CELL_CF | INCOTERMS | NICK_NAME | CELL_ITEM_ID | ITEM_ID | MEASURE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 81 | MI00 | MI00 | MI00 | Pack | - | 28 | - | FMC-C727 28-021 | - | AMFMCC727-F1-021 | INV |
| T | 81 | MI00 | MI00 | MI00 | Pack | - | 28 | - | FMC-C727 28-021 | - | AMFMCC727-F1-021 | PROD_PLAN |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 2행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
