# SCP0111 · SCP0111_GET_INTEGRATION_PSI ↔ PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI

- 실행 2026-11-18 11:01:32 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 1898행/TO-BE 1898행(공통 1887 · AS-IS 전용 11 · TO-BE 전용 11) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 DIFF
- 호출 #3 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 1899 · 원천 Doc\verify\SCP0111\calls\_trace_D3_조건부_잠금_AS-IS_조건_만족_계정_Division__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "planStartYyyymmdd": "20261026", "planType": "", "seq": "", "fromYyyymm": "202610", "toYyyymm": "202703", "nickName": "", "cellItemId": "", "itemId": "", "qtyYn": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}` · 같은 본문의 세션 조합 5종 중 최다(32회) 사용 — 나머지 [{'sesLangCd': 'KO', 'sesUserId': 'lucky-alex'}, {'sesLangCd': 'KO', 'sesUserId': 'dana.robot'}, {'sesLangCd': 'EN', 'sesUserId': 'zhangjiali'}]
- AS-IS 인자(번역): `{"p_division_id": "40", "p_plan_start_yyyymmdd": "20261026", "p_plan_type": "", "p_seq": "", "p_from_yyyymm": "202610", "p_to_yyyymm": "202703", "p_nick_name": "", "p_cellitem_id": "", "p_item_id": "", "p_qty_yn": "N"}`

### 결과셋 1  As-is 1898행 ↔ To-Be O_RC 1898행
- 값 차이: As-is 전용 11행 / To-Be 전용 11행 (공통 컬럼 28)
| 측 | DIVISION_ID | COMPANY_ID | PLANT_ID | PLANT_ID_DESCRIPTION | OPERATION_GROUP | CELL_MODEL_NICK_NAME | CELL_CF | INCOTERMS | NICK_NAME | CELL_ITEM_ID | ITEM_ID | MEASURE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 40 | HQ00 | HQ06 | HQ06 | Electrode | - | 1 | - | H52A | - | APCAN2733A | INV |
| A | 40 | HQ00 | HQ06 | HQ06 | Electrode | - | 1 | - | H52A | - | APCAN2733A | IN_HOUSE_MOVING |
| A | 40 | HQ00 | HQ06 | HQ06 | Electrode | - | 1 | - | H52A | - | APCCA2841A | INV |
| A | 40 | HQ00 | HQ06 | HQ06 | Electrode | - | 1 | - | H52A | - | APCCA2841A | IN_HOUSE_MOVING |
| A | 40 | HQ00 | HQ06 | HQ06 | Electrode | - | 1 | - | M50F | - | APCAN1650A | INV |
| A | 40 | HQ00 | HQ06 | HQ06 | Electrode | - | 1 | - | M50F | - | APCAN1650A | IN_HOUSE_MOVING |
| A | 40 | NJ00 | NJ01 | NJ01 | Cell | P484599A1-X3359 | 1 | - | P484599A1-X3359 | MIP484599A11 | MAP484599A10 | INV |
| A | 40 | NJ00 | NJ01 | NJ01 | Cell | P484599A1-X3359 | 1 | - | P484599A1-X3359 | MIP484599A11 | MAP484599A10 | IN_HOUSE_MOVING |
| A | 40 | NJ00 | NJ01 | NJ01 | Cell | P484599A1-X3359 | 1 | - | P484599A1-X3359 | MIP484599A11 | MAP484599A10 | PROD_PLAN |
| A | 40 | NJ00 | NJ01 | NJ01 | Cell | P484599A1-X3359 | 1 | - | P484599A1-X3359 | MIP484599A11 | MAP484599A10 | PROD_PLAN |
| T | 40 | HQ00 | HQ06 | HQ06 | Electrode | - |  | - | H52A | - | APCAN2733A | INV |
| T | 40 | HQ00 | HQ06 | HQ06 | Electrode | - |  | - | H52A | - | APCAN2733A | IN_HOUSE_MOVING |
| T | 40 | HQ00 | HQ06 | HQ06 | Electrode | - |  | - | H52A | - | APCCA2841A | INV |
| T | 40 | HQ00 | HQ06 | HQ06 | Electrode | - |  | - | H52A | - | APCCA2841A | IN_HOUSE_MOVING |
| T | 40 | HQ00 | HQ06 | HQ06 | Electrode | - |  | - | M50F | - | APCAN1650A | INV |
| T | 40 | HQ00 | HQ06 | HQ06 | Electrode | - |  | - | M50F | - | APCAN1650A | IN_HOUSE_MOVING |
| T | 40 | NJ00 | NJ01 | NJ01 | Cell | P484599A1-X3359 |  | - | P484599A1-X3359 | MIP484599A11 | MAP484599A10 | INV |
| T | 40 | NJ00 | NJ01 | NJ01 | Cell | P484599A1-X3359 |  | - | P484599A1-X3359 | MIP484599A11 | MAP484599A10 | IN_HOUSE_MOVING |
| T | 40 | NJ00 | NJ01 | NJ01 | Cell | P484599A1-X3359 |  | - | P484599A1-X3359 | MIP484599A11 | MAP484599A10 | PROD_PLAN |
| T | 40 | NJ00 | NJ01 | NJ01 | Cell | P484599A1-X3359 |  | - | P484599A1-X3359 | MIP484599A11 | MAP484599A10 | PROD_PLAN |
- 데이터 기준: 공통 1887행 · AS-IS 전용 11행 · TO-BE 전용 11행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1887행의 상대 순서): 일치
