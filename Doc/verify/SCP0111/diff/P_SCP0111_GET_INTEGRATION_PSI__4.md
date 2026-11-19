# SCP0111 · SCP0111_GET_INTEGRATION_PSI ↔ PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI

- 실행 2026-11-18 17:39:22 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 1281행/TO-BE 1281행(공통 1276 · AS-IS 전용 5 · TO-BE 전용 5) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #4 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 1282 · 원천 Doc\verify\SCP0111\calls\_trace_D3_조건부_잠금_AS-IS_조건_만족_계정_Division__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "planStartYyyymmdd": "20261026", "planType": "", "seq": "", "fromYyyymm": "202610", "toYyyymm": "202703", "nickName": "", "cellItemId": "", "itemId": "", "qtyYn": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "lucky-alex"}` · 같은 본문의 세션 조합 2종 중 최다(7회) 사용 — 나머지 [{'sesLangCd': 'KO', 'sesUserId': 'minyonglee1'}]
- AS-IS 인자(번역): `{"p_division_id": "82", "p_plan_start_yyyymmdd": "20261026", "p_plan_type": "", "p_seq": "", "p_from_yyyymm": "202610", "p_to_yyyymm": "202703", "p_nick_name": "", "p_cellitem_id": "", "p_item_id": "", "p_qty_yn": "N"}`

### 결과셋 1  As-is 1281행 ↔ To-Be O_RC 1281행
- 값 차이: As-is 전용 5행 / To-Be 전용 5행 (공통 컬럼 28)
| 측 | DIVISION_ID | COMPANY_ID | PLANT_ID | PLANT_ID_DESCRIPTION | OPERATION_GROUP | CELL_MODEL_NICK_NAME | CELL_CF | INCOTERMS | NICK_NAME | CELL_ITEM_ID | ITEM_ID | MEASURE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 82 | - | - | - | Pack | JF2S | 10080 | DAP | JF2S DC LINK | ECE1558F1-01-B00 | ETD1550BGB31 | MKT_FCST |
| A | 82 | WA00 | WA01 | WA01 | Cell | JF1R | 1 | - | JF1R | ECE0345F1-01 | ECE0345F1-01 | PROD_PLAN |
| A | 82 | WA00 | WA01 | WA01 | Pack | JF1R | 24 | - | JF1R FRONIUS | ECE0345F1-01 | EM077034PDB1 | PROD_PLAN |
| A | 82 | WA00 | WA01 | WA01 | Pack | JF2S | 10080 | - | JF2S DC LINK | ECE1558F1-01-B00 | ETD1550BGB31 | INV |
| A | 82 | WA00 | WA01 | WA01 | Pack | JF2S | 10080 | - | JF2S DC LINK | ECE1558F1-01-B00 | ETD1550BGB31 | PROD_PLAN |
| T | 82 | - | - | - | Pack | JF2S | 336 | DAP | JF2S DC LINK | ECE1558F1-01-B00 | ETD1550BGB31 | MKT_FCST |
| T | 82 | WA00 | WA01 | WA01 | Cell | JF1R | 1 | - | JF1R | ECE0345F1-01 | ECE0345F1-01 | PROD_PLAN |
| T | 82 | WA00 | WA01 | WA01 | Pack | JF1R | 24 | - | JF1R FRONIUS | ECE0345F1-01 | EM077034PDB1 | PROD_PLAN |
| T | 82 | WA00 | WA01 | WA01 | Pack | JF2S | 336 | - | JF2S DC LINK | ECE1558F1-01-B00 | ETD1550BGB31 | INV |
| T | 82 | WA00 | WA01 | WA01 | Pack | JF2S | 336 | - | JF2S DC LINK | ECE1558F1-01-B00 | ETD1550BGB31 | PROD_PLAN |
- 데이터 기준: 공통 1276행 · AS-IS 전용 5행 · TO-BE 전용 5행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1276행의 상대 순서): 일치
