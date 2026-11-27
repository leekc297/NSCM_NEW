# DMF0042 · DMF0042_GET_SPREAD_TITLE ↔ PKG_DMF0042.P_DMF0042_GET_SPREAD_TITLE

- 실행 2026-11-26 22:25:49 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 7행 중 불일치 셀 21 — diff/P_DMF0042_GET_SPREAD_TITLE__59.csv · 컬럼 집합 차이 AS-IS 전용 [] / TO-BE 전용 ['edityn'] · 키 원천 db_resultsets.csv is_nullable=0 · 키 DAY_CODE+COLUMN_WIDTH+HORIZONTAL_ALIGN_CODE+VISIBLE_FLAG+VALID_YN+COLUMN_NAME · golden 집합 판정 DIFF
- 호출 #59 sheet=spreadTitle btn=SEARCH user=park6151 FE 응답 행 20 · 원천 Doc\verify\DMF0042\calls\eg_auth_계정_순회_메뉴_트리_직접_접근_Div_후보_자동_선택_조회_전_버튼_행_범위_0.json
- TO-BE 인자(FE 본문): `{"startYyyymmdd": "20261101", "endYyyymmdd": "20270531", "divisionId": "40", "userId": "dodae", "mnuId": "DMF0042"}`
- AS-IS 인자(번역): `{"p_start_yyyymmdd": "20261101", "p_end_yyyymmdd": "20270531", "p_division_id": "40", "p_created_by": "bpark416"}`
- TO-BE 인자 묶음(PROC_M 순서 = BE 방식): mnuId→P_MENU_ID
- TO-BE 인자 중 값 없음(NULL 전달): P_CREATED_BY

### 결과셋 1  As-is 25행 ↔ To-Be O_RC1 19행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: EDIT_YN
- 행수 불일치 25 ↔ 19
- 값 차이: As-is 전용 25행 / To-Be 전용 19행 (공통 컬럼 27)
| 측 | PROGRAM_ID | SHEET_NAME | COLUMN_NAME | COLUMN_LABEL_NAME | SORT_ORDER_NO | DATA_SORT_METHOD_CODE | SMALL_CLASS_LABEL_NAME | LARGE_CLASS_LABEL_NAME | DAY_CODE | FIXED_FLAG | COLUMN_WIDTH | CELL_CONTROL_OBJECT_TYPE_CODE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | DMF0042 | Biz Plan | CELL_PROD_SITE | Cell Prod Site* | 235 |  |  |  |  |  | 80 |  |
| A | DMF0042 | Biz Plan | CURRENCY | Currency* | 240 |  |  |  |  |  | 80 |  |
| A | DMF0042 | Biz Plan | DEPT_ID40 | Team | 25 |  |  |  |  |  | 80 | FPComboBox |
| A | DMF0042 | Biz Plan | DIVISION_ID | Division* | 10 |  |  |  |  |  | 80 |  |
| A | DMF0042 | Biz Plan | EDIT_FLAG | Edit Flag | 800 |  |  |  |  |  | 0 |  |
| A | DMF0042 | Biz Plan | END_CUSTOMER40 | End Customer* | 40 |  |  |  |  |  | 80 | FPComboBox |
| A | DMF0042 | Biz Plan | ENERGE_WH | Energy(WH) | 895 | ASC |  |  |  |  | 60 | FPNumber |
| A | DMF0042 | Biz Plan | FCST_TYPE | FCST Type | 210 |  |  |  |  |  | 80 | FPComboBox |
| A | DMF0042 | Biz Plan | INCOTERMS | Rep. Incoterms* | 200 |  |  |  |  |  | 80 | FPComboBox |
| A | DMF0042 | Biz Plan | ITEM_ID40 | Model* | 150 |  |  |  |  |  | 80 |  |
| T | DMF0042 | Biz Plan | CELL_PROD_SITE | Cell Prod Site* | 235 |  |  |  |  | N | 80 | FPComboBox |
| T | DMF0042 | Biz Plan | DEPT_ID40 | Team | 25 |  |  |  |  | N | 80 | FPComboBox |
| T | DMF0042 | Biz Plan | END_CUSTOMER40 | End Customer* | 40 |  |  |  |  | N | 80 | FPComboBox |
| T | DMF0042 | Biz Plan | ENERGE_WH | Energy(WH) | 895 | ASC |  |  |  | N | 60 | FPNumber |
| T | DMF0042 | Biz Plan | ITEM_ID40 | Model* | 150 |  |  |  |  | N | 80 |  |
| T | DMF0042 | Biz Plan | ITEM_NAME | Model Name | 170 | ASC |  |  |  | N | 80 |  |
| T | DMF0042 | Biz Plan | M_202611 | 2026-11 | 20261101 |  | Q4 | 2026 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202612 | 2026-12 | 20261201 |  | Q4 | 2026 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202701 | 2027-01 | 20270101 |  | Q1 | 2027 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202702 | 2027-02 | 20270201 |  | Q1 | 2027 |  |  | 117 | FPNumber |
- 데이터 기준: 공통 0행 · AS-IS 전용 25행 · TO-BE 전용 19행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서 · AS-IS ORDER BY 키 SORT_ORDER_NO 기준 · 키 동률 묶음 0개(0행)는 묶음 안 순서가 AS-IS 에서 정해지지 않아 집합으로 비교): 비교 불가(공통 행 2 미만)
- A7 공란 컬럼(AS-IS 값 있음 · TO-BE 전 행 공란): DATA_MAX_LENGTH, ATTRIBUTE3, ATTRIBUTE5

## 불일치 셀(≤50) — diff/P_DMF0042_GET_SPREAD_TITLE__59.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| |80|L|Y|Y|DEPT_ID40 | FIXED_FLAG |  | N |
| |80|L|Y|Y|END_CUSTOMER40 | FIXED_FLAG |  | N |
| |120|L|Y|Y|SCM_SITE_ID40 | FIXED_FLAG |  | N |
| |80|L|Y|Y|ITEM_ID40 | FIXED_FLAG |  | N |
| |80|L|Y|Y|ITEM_NAME | FIXED_FLAG |  | N |
| |80|L|Y|Y|CELL_PROD_SITE | FIXED_FLAG |  | N |
| |60|R|Y|Y|ENERGE_WH | FIXED_FLAG |  | N |
| |80|L|Y|Y|CELL_PROD_SITE | CELL_CONTROL_OBJECT_TYPE_CODE |  | FPComboBox |
| |80|L|Y|Y|DEPT_ID40 | CELL_COMBO_DATA_TYPE | DeptId | TeambyDivision |
| |80|L|Y|Y|CELL_PROD_SITE | CELL_COMBO_DATA_TYPE |  | DMF0042CellProdSite |
| |80|L|Y|Y|DEPT_ID40 | UPPERCASE_APPLY_FLAG |  | N |
| |80|L|Y|Y|END_CUSTOMER40 | UPPERCASE_APPLY_FLAG |  | N |
| |120|L|Y|Y|SCM_SITE_ID40 | UPPERCASE_APPLY_FLAG |  | N |
| |80|L|Y|Y|ITEM_ID40 | UPPERCASE_APPLY_FLAG |  | N |
| |80|L|Y|Y|ITEM_NAME | UPPERCASE_APPLY_FLAG |  | N |
| |80|L|Y|Y|CELL_PROD_SITE | UPPERCASE_APPLY_FLAG |  | N |
| |60|R|Y|Y|ENERGE_WH | UPPERCASE_APPLY_FLAG |  | N |
| |80|L|Y|Y|END_CUSTOMER40 | USER_SELECTABLE_FLAG | Y | N |
| |120|L|Y|Y|SCM_SITE_ID40 | USER_SELECTABLE_FLAG | Y | N |
| |80|L|Y|Y|ITEM_ID40 | USER_SELECTABLE_FLAG | Y | N |
| |80|L|Y|Y|CELL_PROD_SITE | USER_SELECTABLE_FLAG | Y | N |
