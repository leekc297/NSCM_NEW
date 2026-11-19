# SCP0111 · SCP0111_GET_INTEGRATION_PSI ↔ PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI

- 실행: 2026-11-19 12:57:38
- 파라미터: `{"p_division_id": "81", "p_plan_start_yyyymmdd": "20260817", "p_plan_type": "", "p_seq": "", "p_from_yyyymm": "202608", "p_to_yyyymm": "202701", "p_nick_name": "", "p_cellitem_id": "", "p_item_id": "", "p_qty_yn": "N"}`
- 종류: GET

### 결과셋 1  As-is 1712행 ↔ To-Be O_RC 1712행
- 값 차이: As-is 전용 4행 / To-Be 전용 4행 (공통 컬럼 28)
| 측 | DIVISION_ID | COMPANY_ID | PLANT_ID | PLANT_ID_DESCRIPTION | OPERATION_GROUP | CELL_MODEL_NICK_NAME | CELL_CF | INCOTERMS | NICK_NAME | CELL_ITEM_ID | ITEM_ID | MEASURE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81 | WA00 | WA00 | WA00 | Electrode | - | 0.434934 | - | E77A-T017 | - | APCAN3037A | INV |
| A | 81 | WA00 | WA00 | WA00 | Electrode | - | 0.434934 | - | E77A-T017 | - | APCAN3037A | IN_HOUSE_MOVING |
| A | 81 | WA00 | WA00 | WA00 | Electrode | - | 0.468011 | - | E77A-T017 | - | APCCA3155A | INV |
| A | 81 | WA00 | WA00 | WA00 | Electrode | - | 0.468011 | - | E77A-T017 | - | APCCA3155A | IN_HOUSE_MOVING |
| T | 81 | WA00 | WA00 | WA00 | Electrode | - | 0.437216 | - | E77A-T017 | - | APCAN3037A | INV |
| T | 81 | WA00 | WA00 | WA00 | Electrode | - | 0.437216 | - | E77A-T017 | - | APCAN3037A | IN_HOUSE_MOVING |
| T | 81 | WA00 | WA00 | WA00 | Electrode | - | 0.470544 | - | E77A-T017 | - | APCCA3155A | INV |
| T | 81 | WA00 | WA00 | WA00 | Electrode | - | 0.470544 | - | E77A-T017 | - | APCCA3155A | IN_HOUSE_MOVING |
- 데이터 기준: 공통 1708행 · AS-IS 전용 4행 · TO-BE 전용 4행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1708행의 상대 순서): 일치
