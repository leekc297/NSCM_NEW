# DMF0042 · DMF0042_GET_SPREAD_TITLE ↔ PKG_DMF0042.P_DMF0042_GET_SPREAD_TITLE

- 실행 2026-11-26 22:25:49 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 DAY_CODE+COLUMN_WIDTH+HORIZONTAL_ALIGN_CODE+VISIBLE_FLAG+VALID_YN+COLUMN_NAME) — AS-IS 109행 ↔ TO-BE 97행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 컬럼 집합 차이 AS-IS 전용 [] / TO-BE 전용 ['edityn'] · 키 원천 db_resultsets.csv is_nullable=0 · 키 DAY_CODE+COLUMN_WIDTH+HORIZONTAL_ALIGN_CODE+VISIBLE_FLAG+VALID_YN+COLUMN_NAME · golden 집합 판정 DIFF
- 호출 #85 sheet=spreadTitle btn=SEARCH user=park6151 FE 응답 행 98 · 원천 Doc\verify\DMF0042\calls\eg_auth_계정_순회_메뉴_트리_직접_접근_Div_후보_자동_선택_조회_전_버튼_행_범위_0.json
- TO-BE 인자(FE 본문): `{"startYyyymmdd": "20211101", "endYyyymmdd": "20270531", "divisionId": "81", "userId": "jiwon.park", "mnuId": "DMF0042"}`
- AS-IS 인자(번역): `{"p_start_yyyymmdd": "20211101", "p_end_yyyymmdd": "20270531", "p_division_id": "81", "p_created_by": "bpark416"}`
- TO-BE 인자 묶음(PROC_M 순서 = BE 방식): mnuId→P_MENU_ID
- TO-BE 인자 중 값 없음(NULL 전달): P_CREATED_BY

### 결과셋 1  As-is 109행 ↔ To-Be O_RC1 97행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: EDIT_YN
- 행수 불일치 109 ↔ 97
- 값 차이: As-is 전용 109행 / To-Be 전용 97행 (공통 컬럼 27)
| 측 | PROGRAM_ID | SHEET_NAME | COLUMN_NAME | COLUMN_LABEL_NAME | SORT_ORDER_NO | DATA_SORT_METHOD_CODE | SMALL_CLASS_LABEL_NAME | LARGE_CLASS_LABEL_NAME | DAY_CODE | FIXED_FLAG | COLUMN_WIDTH | CELL_CONTROL_OBJECT_TYPE_CODE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | DMF0042 | Biz Plan | CURRENCY | Currency* | 240 |  |  |  |  |  | 80 |  |
| A | DMF0042 | Biz Plan | DEPT_ID | Team* | 20 |  |  |  |  |  | 80 | FPComboBox |
| A | DMF0042 | Biz Plan | DIVISION_ID | Division* | 10 |  |  |  |  |  | 80 |  |
| A | DMF0042 | Biz Plan | EDIT_FLAG | Edit Flag | 800 |  |  |  |  |  | 0 |  |
| A | DMF0042 | Biz Plan | END_CUSTOMER | End Customer* | 30 |  |  |  |  |  | 80 | FPComboBox |
| A | DMF0042 | Biz Plan | FCST_TYPE | FCST Type* | 210 |  |  |  |  |  | 80 | FPComboBox |
| A | DMF0042 | Biz Plan | INCOTERMS | Rep. Incoterms* | 195 |  |  |  |  |  | 80 | FPComboBox |
| A | DMF0042 | Biz Plan | ITEM_ID | Model* | 155 | ASC |  |  |  |  | 80 |  |
| A | DMF0042 | Biz Plan | MEASURE | Measure* | 900 |  |  |  |  |  | 80 | FPComboBox |
| A | DMF0042 | Biz Plan | M_202111 | 2021-11 | 20211101 |  | Q4 | 2021 |  |  | 50 | FPNumber |
| T | DMF0042 | Biz Plan | M_202111 | 2021-11 | 20211101 |  | Q4 | 2021 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202112 | 2021-12 | 20211201 |  | Q4 | 2021 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202201 | 2022-01 | 20220101 |  | Q1 | 2022 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202202 | 2022-02 | 20220201 |  | Q1 | 2022 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202203 | 2022-03 | 20220301 |  | Q1 | 2022 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202204 | 2022-04 | 20220401 |  | Q2 | 2022 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202205 | 2022-05 | 20220501 |  | Q2 | 2022 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202206 | 2022-06 | 20220601 |  | Q2 | 2022 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202207 | 2022-07 | 20220701 |  | Q3 | 2022 |  |  | 117 | FPNumber |
| T | DMF0042 | Biz Plan | M_202208 | 2022-08 | 20220801 |  | Q3 | 2022 |  |  | 117 | FPNumber |
- 데이터 기준: 공통 0행 · AS-IS 전용 109행 · TO-BE 전용 97행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서 · AS-IS ORDER BY 키 SORT_ORDER_NO 기준 · 키 동률 묶음 0개(0행)는 묶음 안 순서가 AS-IS 에서 정해지지 않아 집합으로 비교): 비교 불가(공통 행 2 미만)
- A7 공란 컬럼(AS-IS 값 있음 · TO-BE 전 행 공란): CELL_COMBO_DATA_TYPE, DATA_MAX_LENGTH, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID, ATTRIBUTE1, ATTRIBUTE4
