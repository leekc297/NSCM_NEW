# SHEET_COLUMN 지식사전 (COLUMN_NAME 축)
> **스냅샷** 2026-08-21 · **AS-IS 원천** DEV / LGCE_SCMDEV
> **재생성** `_artifacts/_diagnostics/ui_meta_dictionary_20260821/` (01~05 실행 후 07_build_outputs.py)
> ⚠ 이 파일은 생성물이다. 직접 수정하지 말고 파이프라인을 고쳐 재생성한다.
>
> 신규/보완 화면의 컬럼 메타 작성 전 해당 컬럼 행을 대조한다. `confidence` 가 low/none 이면 표준으로 쓰지 말고 AS-IS 를 확인한다.

## 0. 이 사전이 왜 2단인가 (구조 사실)

- AS-IS 의 INPUT_TP_CD 는 전행 'S' 단일값이고 FPModal 은 0건 — 편집·모달 축은 TO-BE 전용이다.
- 표시표준(전 행 최빈)과 편집표준(콤보·모달 배정행 한정)을 분리한다. 합치면 읽기전용 행이 다수라 항상 TextBox 가 표준이 된다.
- 값 도메인 정본은 TO-BE SCM_ADM_LOOKUP_MASTER_DETAIL(64,500행) — AS-IS 와 동일 (컨트롤 13종·align C/L/R). 2026-08-21 관측된 0행은 적재 창의 일시 상태였다.

- **confidence**: high>=5 / medium 2~4 / low 1 / none 0 (근거 = 콤보·모달 배정 행수)
- **허용 컨트롤** 16종: FPButton, FPCheckBox, FPComboBox, FPDate, FPDateMonth, FPDateText, FPDateTime, FPExNum, FPModal, FPMultiLineTextBox, FPNumber, FPNumberText, FPPercent, FPText, FPTextBox, FPTextModal
  - FE enum 전용(= AS-IS lookup 미등록): FPModal, FPText, FPTextModal
  - AS-IS lookup 전용(= FE 미해석): FPExNum
- **콤보 격차**: 표준 콤보가 TO-BE CMBO 에 없다 = 즉시 결함이 아니라 **매핑 판단 대상**. TO-BE 가 다른 ID 로 재매핑한 선례가 있다(AS-IS FCST_TYPE → DM_LOOKUP_DIV). 대안 후보는 combo_tobe_alternatives 참조.
- **교대쌍**: AS-IS DMF0049 실측 — 같은 라벨의 X(콤보)/T_X(텍스트) 를 .cs 가 모드별로 번갈아 노출한다. 메타만 보면 '같은 라벨 2컬럼 둘 다 VISIBLE=Y' 로만 보인다.

## 1. 컬럼 표준 (전 3225종)

| COLUMN | AS-IS 행/화면 | TO-BE 행/화면 | 라벨 표준 | 정렬 | 폭 | 표시 컨트롤 | 편집 컨트롤 | 편집 콤보 | 등록 | 모달키 | conf | 교대쌍 |
|---|---:|---:|---|---|---:|---|---|---|---|---|---|---|
| `` | 1/1 | 1/1 | 미확인(라벨 이력 없음) | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A1000` | 1/1 | 1/1 | V/D(Cylinder/Prismatic) | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A2000` | 1/1 | 1/1 | Winding | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A3000` | 1/1 | 1/1 | Assembly | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A5000` | 1/1 | 1/1 | Notching | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A6000` | 1/1 | 1/1 | VD(Pouch) | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A7000` | 1/1 | 1/1 | Lamination | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A7100` | 1/1 | 1/1 | SRC | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A7200` | 1/1 | 1/1 | SSC Bi-Cell | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A7500` | 1/1 | 1/1 | Winder Pouch | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A8000` | 1/1 | 1/1 | Stacking & Folding | 미확인(정렬코드 이력 없음) | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A8100` | 1/1 | 1/1 | STP | 미확인(정렬코드 이력 없음) | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A9000` | 1/1 | 1/1 | Packaging | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ABC` | 0/0 | 1/1 | X1 | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACCUMULATED_CHILD_QTY` | 1/1 | 1/1 | Accum Child Qty | R | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACNT_LOK_YN` | 0/0 | 1/1 | Locked YN | C | 80 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `ACTION` | 1/1 | 3/3 | Action | C | 70 | FPButton | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_01_NAME` | 2/2 | 2/2 | Validation | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_01_TYPE` | 2/2 | 2/2 | Action 01 Type | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_01_VALUE` | 2/2 | 2/2 | Action 01 Value | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_02_NAME` | 2/2 | 2/2 | Revision | C | 160 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_02_TYPE` | 2/2 | 2/2 | Action 02 Type | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_02_VALUE` | 2/2 | 2/2 | Action 02 Value | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_03_NAME` | 2/2 | 2/2 | Run | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_03_TYPE` | 2/2 | 2/2 | Action 03 Type | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_03_VALUE` | 2/2 | 2/2 | Action 03 Value | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_04_NAME` | 2/2 | 2/2 | SCP Target | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_04_TYPE` | 2/2 | 2/2 | Action 04 Type | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_04_VALUE` | 2/2 | 2/2 | Action 04 Value | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_05_NAME` | 2/2 | 2/2 | Confirm | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_05_TYPE` | 2/2 | 2/2 | Action 05 Type | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_05_VALUE` | 2/2 | 2/2 | Action 05 Value | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_06_NAME` | 2/2 | 2/2 | Confirm Release | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_06_TYPE` | 2/2 | 2/2 | Action 06 Type | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_06_VALUE` | 2/2 | 2/2 | Action 06 Value | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_FLAG_DIV` | 2/2 | 2/2 | ACTION_FLAG_DIV | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTION_NAME` | 1/1 | 1/1 | ACTION_NAME | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTIVE` | 0/0 | 1/1 | Active | C | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTIVE_FLAG` | 25/20 | 26/21 | Active | C | 60 | FPTextBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `ACTIVE_MATERIAL_1` | 7/6 | 7/6 | Active 1 | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTIVE_MATERIAL_2` | 7/6 | 7/6 | Active 2 | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTIVE_MATERIAL_3` | 7/6 | 7/6 | Active3 | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTIVE_SS` | 1/1 | 1/1 | Active SS | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTIVE_SSPM` | 1/1 | 1/1 | Active. SSPM | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTIVE_YN` | 1/1 | 3/2 | Active Flag | C | 45 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `ACTUAL_CAPACITY` | 2/1 | 2/1 | Actual Capacity | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTUAL_END_TIME` | 4/2 | 4/2 | End Time | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTUAL_GOOD_QTY` | 2/1 | 2/1 | Good | C | 75 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTUAL_OUTPUT` | 2/1 | 2/1 | Actual Output | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTUAL_QTY` | 7/6 | 7/6 | Result | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTUAL_SCRAP_QTY` | 2/1 | 2/1 | Scrap | C | 75 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ACTUAL_START_TIME` | 4/2 | 4/2 | Start Time | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ADDICTION` | 2/2 | 2/2 | Addiction Agent | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ADDITION_AGENT` | 5/4 | 5/4 | Addition Agent | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ADD_LT_FORMATION` | 2/1 | 2/1 | Formation Add L/T (Days) | R | 140 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ADJUST_CELL_QTY` | 1/1 | 1/1 | Adjust Cell QTY | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ADJUST_IN_QTY_KG` | 1/1 | 1/1 | KG | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AFTER_DEGAS_LT` | 1/1 | 1/1 | L/T (min) | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AFTER_DEGAS_LT_DAY` | 1/1 | 1/1 | L/T (day) | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AFTER_DEGAS_ROUTE_ID` | 1/1 | 1/1 | Route | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AFTER_LEAD_TIME` | 1/1 | 1/1 | Additional Lead Time | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AGGREGATE` | 0/0 | 1/1 | Aggregate | C | 80 | FPComboBox | FPComboBox | sysAggregateOptions | O | 미확인(모달키 이력 없음) | low | - |
| `AGGR_DV` | 2/1 | 2/1 | Aggr DV | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AGING_LEAD_TIME` | 2/2 | 2/2 | Aging L/T | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AGING_LT` | 1/1 | 1/1 | Aging L/T | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AGING_LT_LINE_AVG` | 1/1 | 1/1 | Aging L/T (Line Avg) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AGING_LT_RATIO` | 1/1 | 1/1 | Aging L/T * Ratio | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ALARM_TIME` | 1/1 | 1/1 | Alarm Time | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ALLOCATION_QTY` | 8/5 | 8/5 | Allocation Qty | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ALLO_BOH_QTY` | 1/1 | 1/1 | BOH(Allo) | C | 50 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ALT_ID` | 3/2 | 3/2 | Alternate ID | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ALT_PRIORITY` | 5/4 | 5/4 | Alternate Priority | C | 94 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ALT_SIM_YN` | 1/1 | 1/1 | 대체/유사모델 | C | 100 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `AL_KG_PER_BIZ_TYPE` | 1/1 | 1/1 | Al | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AL_MIX_METAL_LINK_PERIOD` | 1/1 | 1/1 | Al | C | 80 | FPComboBox | FPComboBox | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | X | 미확인(모달키 이력 없음) | medium | - |
| `AL_USD_PER_KG` | 1/1 | 1/1 | Al | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AMEND` | 2/1 | 2/1 | AMEND | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AMEND_PLAN_LT` | 1/1 | 1/1 | Release Target Plan ID | C | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AMOUNT` | 6/5 | 6/5 | Amount | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AMOUNT_KRW` | 5/4 | 5/4 | AMOUNT KRW | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AMOUNT_KRW_XLS` | 2/2 | 2/2 | Amount(KRW) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AMOUNT_XLS` | 5/4 | 5/4 | Amount | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AMT` | 2/1 | 2/1 | Amount(KRW) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ANLS_DIF_RSN_CD` | 1/1 | 1/1 | Detailed factors | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `API_ID` | 0/0 | 2/2 | API ID | L | 150 | (공란) | FPComboBox | ApiList | O | 미확인(모달키 이력 없음) | low | - |
| `API_MSG_DESC` | 0/0 | 1/1 | API Description | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `API_MSG_ID` | 0/0 | 1/1 | API Msg ID | L | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `API_MSG_NM` | 0/0 | 1/1 | API Name | L | 150 | FPModal | FPModal | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | low | - |
| `API_TP_CD` | 0/0 | 1/1 | API Type | C | 120 | FPComboBox | FPComboBox | ApiType | O | 미확인(모달키 이력 없음) | low | - |
| `API_URL` | 0/0 | 1/1 | Call API | L | 350 | FPComboBox | FPComboBox | ProcedureList | O | 미확인(모달키 이력 없음) | low | - |
| `APL_QTY` | 1/1 | 1/1 | Qty* | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPLICATION` | 21/19 | 21/19 | Application | L | 80 | (공란) | FPComboBox | APPLICATION | O | 미확인(모달키 이력 없음) | high | - |
| `APPLICATION_GR` | 2/2 | 2/2 | Application Gr | L | 80 | FPComboBox | FPComboBox | DMF0005_REPORT_GROUP1 | O | 미확인(모달키 이력 없음) | medium | - |
| `APPLICATION_NAME` | 6/1 | 6/1 | Application | C | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPLIED_MODEL` | 13/12 | 13/12 | Applied Model | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPLY_DATE` | 1/1 | 1/1 | Apply Date | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPLY_PRICE_TYPE_CODE1` | 1/1 | 1/1 | Ni | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPLY_PRICE_TYPE_CODE2` | 1/1 | 1/1 | Co | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPLY_PRICE_TYPE_CODE3` | 1/1 | 1/1 | Li2CO3 | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPLY_PRICE_TYPE_CODE4` | 1/1 | 1/1 | LIOH | C | 70 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPLY_PRICE_TYPE_CODE5` | 1/1 | 1/1 | Al | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPLY_PRICE_TYPE_CODE6` | 1/1 | 1/1 | Mn | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPLY_PRICE_TYPE_CODE7` | 1/1 | 1/1 | Cu | C | 70 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPROVAL` | 1/1 | 1/1 | Approval | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPROVAL_DATE` | 1/1 | 1/1 | Approval Date | L | 80 | FPDateTime | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPROVAL_DEPT` | 2/2 | 2/2 | Approval Dept Name | L | 130 | FPComboBox | FPComboBox | Dept | X | 미확인(모달키 이력 없음) | medium | - |
| `APPROVAL_DEPT_NAME` | 1/1 | 1/1 | Approval Dept Name | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPROVAL_FLAG` | 2/2 | 2/2 | Approval Flag | C | 0 | FPTextBox | FPComboBox | APPROVAL_FLAG | X | 미확인(모달키 이력 없음) | medium | - |
| `APPROVAL_ID` | 2/2 | 2/2 | Approval | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPROVAL_NAME` | 2/2 | 2/2 | Status | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPROVAL_RESULT` | 0/0 | 1/1 | Approval Result | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPROVAL_TIME` | 4/4 | 4/4 | Approval Time | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPROVAL_USER` | 2/2 | 2/2 | Approval | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPROVAL_USER_NAME` | 2/2 | 2/2 | Approval | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPROVED_BY` | 0/0 | 1/1 | Approval User | C | 120 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `APPROVED_DATE` | 0/0 | 1/1 | Approval Date | C | 140 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ASSEMBLY_QTY` | 1/1 | 1/1 | QTY | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ASSEMBLY_TOTAL_RATIO` | 1/1 | 1/1 | (Total) Ratio | R | 100 | FPPercent | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ASSEMBLY_TYPE_RATIO` | 1/1 | 1/1 | (Type) Ratio | R | 100 | FPPercent | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ASSY` | 1/1 | 1/1 | Assy | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ASSY_BOH` | 1/1 | 1/1 | P/C(Assy) | R | 80 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ASSY_BOH_HOLD` | 1/1 | 1/1 | P/C(Assy) | R | 80 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ASSY_BOH_ONLYHOLD` | 1/1 | 1/1 | P/C(Assy) | R | 80 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ASSY_ITEM_ID` | 2/2 | 2/2 | Cell Assy Code | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AS_FROM_SITE` | 3/3 | 3/3 | AS From Site | C | 100 | (공란) | FPComboBox | AS_FROM_SITE | O | 미확인(모달키 이력 없음) | medium | - |
| `AS_IS_WIP` | 2/2 | 2/2 | As-is | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AS_WAS_WIP` | 2/2 | 2/2 | As-was | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AS_YN` | 1/1 | 2/2 | AS_YN | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTR1` | 2/2 | 3/3 | ATTR1 | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTR1_TXT` | 1/1 | 1/1 | Model Change | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTR2` | 1/1 | 1/1 | Category | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTR2_TXT` | 1/1 | 1/1 | Category | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTRIBUTE1` | 10/9 | 14/11 | Sold-to Cust.(Report) | C | 120 | FPComboBox | FPComboBox | SOLD_TO_CUST_REPORT | O | 미확인(모달키 이력 없음) | high | - |
| `ATTRIBUTE10` | 8/8 | 12/10 | ATTRIBUTE10 | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTRIBUTE11` | 0/0 | 2/1 | Attribute11 | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTRIBUTE12` | 0/0 | 2/1 | Attribute12 | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTRIBUTE13` | 0/0 | 2/1 | Attribute13 | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTRIBUTE14` | 0/0 | 2/1 | Attribute14 | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTRIBUTE15` | 0/0 | 2/1 | Attribute15 | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTRIBUTE2` | 8/8 | 11/9 | End Cust.(Report) | C | 70 | FPComboBox | FPComboBox | END_CUST_REPORT | O | 미확인(모달키 이력 없음) | high | - |
| `ATTRIBUTE3` | 8/6 | 11/8 | RTF | C | 120 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTRIBUTE4` | 9/8 | 13/10 | Destination | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTRIBUTE5` | 12/10 | 16/12 | Cell Model | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTRIBUTE6` | 6/4 | 11/7 | RTF Detail | C | 110 | (공란) | FPComboBox | IncotermsEdit | O | 미확인(모달키 이력 없음) | low | - |
| `ATTRIBUTE7` | 8/1 | 12/3 | Discontinuation of SCP | C | 100 | FPComboBox | FPComboBox | ALL_V_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `ATTRIBUTE8` | 1/1 | 5/3 | Attribute8 | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ATTRIBUTE9` | 1/1 | 6/4 | Attribute9 | L | 80 | (공란) | FPComboBox | ProductionProgress | O | 미확인(모달키 이력 없음) | low | - |
| `ATTR_TYPE` | 2/2 | 2/2 | W/H Type | C | 15 | FPTextBox | FPComboBox | ATTR_TYPE | X | 미확인(모달키 이력 없음) | medium | - |
| `AUTHORITY` | 0/0 | 1/1 | Authority | L | 180 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AUTHORITY_YN` | 6/5 | 4/3 | AY | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AUTO_FLAG` | 1/1 | 1/1 | Auto BNP In / PR Request | C | 90 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `AUTO_NET_QTY` | 1/1 | 1/1 | Net Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AUTO_YN` | 1/1 | 1/1 | Auto Flag | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AVAILABILITY` | 1/1 | 1/1 | Availability | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AVAILABLE_DATE` | 9/8 | 9/8 | Available Date | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AVAILABLE_DATE2` | 1/1 | 1/1 | Exp. Formation End Date(90) | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AVAILABLE_DATE_CPY` | 2/2 | 2/2 | Date to be usable | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AVAILABLE_QTY` | 16/7 | 16/7 | Available Qty | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AVAILABLE_STOCK` | 2/2 | 2/2 | Available Stock | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AVAILABLE_YN` | 7/6 | 7/6 | Available stock YN | C | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AVAIL_CELL_LONG_QTY` | 2/2 | 2/2 | Long-Term | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AVAIL_CELL_QTY` | 1/1 | 1/1 | Available | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AVAIL_QTY` | 2/2 | 2/2 | Available | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `AVG_PERCENT` | 1/1 | 1/1 | % | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A_COUNTRY` | 10/10 | 10/10 | A Country | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A_PORT_CODE` | 10/10 | 10/10 | A Port | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A_PORT_NAME` | 4/4 | 4/4 | Port* | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A_TYPE_BOH` | 1/1 | 1/1 | P/C(Elec.) - A | R | 80 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A_TYPE_BOH_HOLD` | 1/1 | 1/1 | P/C(Elec.) - A | R | 110 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `A_TYPE_BOH_ONLYHOLD` | 1/1 | 1/1 | P/C(Elec.) - A | R | 80 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BACK_COLOR` | 5/5 | 5/5 | Back Color | C | 30 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BACK_ORDER` | 1/1 | 1/1 | Back Order | C | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BACK_ROW_NUM` | 1/1 | 1/1 | Back Row Num | R | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASE_EDITABLE_YN` | 1/1 | 1/1 | BASE_EDITABLE_YN | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASE_PRICE` | 1/1 | 1/1 | Base Price | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASE_PRICE_PER_EA` | 1/1 | 1/1 | Base Price(EA) | R | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASE_QTY` | 8/3 | 13/3 | Base | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASE_YYYYMM` | 1/1 | 1/1 | Ending INV Month | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_APPLICATION` | 6/1 | 6/1 | Application | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_CELL_CAPACITY` | 8/1 | 8/1 | Cell Capacity | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_CELL_TYPE` | 6/1 | 6/1 | Cell Type | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_END_CUSTOMER` | 7/1 | 7/1 | End Customer | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_FINISHED_PRODUCT` | 8/1 | 8/1 | Biz Type | C | 70 | FPComboBox | FPComboBox | ALL_Y_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `BASIC_ITEM` | 1/1 | 1/1 | Basic Code | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_MODEL_CELL` | 9/1 | 9/1 | Code | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_MODEL_PACK` | 9/1 | 9/1 | Code | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_NICKNAME_CELL` | 10/2 | 10/2 | NickName | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_NICKNAME_CELL40` | 1/1 | 1/1 | Product level2 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_NICKNAME_PACK` | 9/1 | 9/1 | NickName | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_NICK_NAME` | 4/1 | 4/1 | Nickname | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIC_TOTAL_CAPACITY` | 8/1 | 8/1 | Total Capacity | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIS_CODE` | 1/1 | 1/1 | Basic Code | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIS_MONTH` | 1/1 | 1/1 | BASIS month | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIS_PLAN_ID` | 1/1 | 1/1 | Basic FP Plan ID | C | 165 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIS_WEEK` | 1/1 | 1/1 | BASIS week | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BASIS_YYYYMM` | 2/1 | 2/1 | YYYYMM | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BATCH_ID` | 7/6 | 7/6 | Slurry Batch Group ID | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BATCH_ID_2` | 3/3 | 3/3 | Slurry 2 | L | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BATCH_LOT_SIZE` | 2/2 | 2/2 | Batch Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BATCH_QTY` | 1/1 | 1/1 | BATCH_QTY | R | 80 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BATCH_RATIO_ID` | 2/2 | 2/2 | Batch | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEFORE_DEGAS` | 1/1 | 1/1 | Before Degas* | C | 0 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `BEFORE_DEGAS_LT` | 1/1 | 1/1 | L/T (min) | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEFORE_DEGAS_LT_DAY` | 1/1 | 1/1 | L/T (day) | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEFORE_DEGAS_ROUTE_ID` | 1/1 | 1/1 | Route | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEFORE_INCOTERMS` | 1/1 | 1/1 | Before Incoterms | C | 65 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEFORE_LEAD_TIME` | 1/1 | 1/1 | Before | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEFORE_OQC` | 2/2 | 2/2 | Before OQC | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEFORE_QTY` | 6/4 | 4/4 | Before Qty | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEFORE_SHIPMENT_DATE` | 1/1 | 1/1 | Before Shipment Date | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEFORE_TRANSPORT_MODE` | 1/1 | 1/1 | Before Trans Mode | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_BEST` | 2/2 | 2/2 | Best | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_BEST_RESULT` | 3/3 | 3/3 | Best | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M1` | 2/2 | 2/2 | BEF_M1 | R | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M1_RESULT` | 3/3 | 3/3 | BEF_M1_RESULT | R | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M2` | 2/2 | 2/2 | BEF_M2 | R | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M2_RESULT` | 3/3 | 3/3 | BEF_M2_RESULT | R | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M3` | 2/2 | 2/2 | BEF_M3 | R | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M3_RESULT` | 3/3 | 3/3 | BEF_M3_RESULT | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M4` | 2/2 | 2/2 | BEF_M4 | R | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M4_RESULT` | 3/3 | 3/3 | BEF_M4_RESULT | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M5` | 2/2 | 2/2 | BEF_M5 | R | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M5_RESULT` | 3/3 | 3/3 | BEF_M5_RESULT | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M6` | 2/2 | 2/2 | BEF_M6 | R | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_M6_RESULT` | 3/3 | 3/3 | BEF_M6_RESULT | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_WORST` | 2/2 | 2/2 | Worst | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BEF_WORST_RESULT` | 3/3 | 3/3 | Worst | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BENEFIT_QUALITATIVE` | 1/1 | 1/1 | 정성적 | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BENEFIT_QUANTITATIVE` | 1/1 | 1/1 | 정량적 | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BIG_LAST_UPDATE_DATE` | 3/2 | 3/2 | Big Last Update Date | C | 130 | FPDateTime | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BIG_TACT_TIME` | 2/1 | 2/1 | Big Tact Time | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BINDER_1` | 11/10 | 11/10 | Binder 1 | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BINDER_2` | 11/10 | 11/10 | Binder 2 | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BINDER_3` | 7/6 | 7/6 | Binder 3 | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BIZ_QTY` | 2/1 | 3/1 | BP | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BIZ_TYPE` | 32/25 | 38/29 | Biz. Type | L | 80 | (공란) | FPComboBox | BizTypeByDivision | O | 미확인(모달키 이력 없음) | high | - |
| `BIZ_TYPE_NAME` | 23/20 | 25/21 | Biz.Type | L | 80 | FPTextBox | FPComboBox | BizTypeByDivision | O | 미확인(모달키 이력 없음) | high | - |
| `BIZ_TYPE_NAME40` | 6/6 | 6/6 | Biz.Type | L | 80 | FPComboBox | FPComboBox | DM_Biz_Type | X | 미확인(모달키 이력 없음) | high | - |
| `BIZ_TYPE_NAME81` | 2/2 | 2/2 | Biz.Type* | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL1` | 1/1 | 1/1 | Material | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL11` | 1/1 | 1/1 | Material | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL11_A` | 1/1 | 1/1 | Alt | 미확인(정렬코드 이력 없음) | 30 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL11_P` | 1/1 | 1/1 | B | 미확인(정렬코드 이력 없음) | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL1_A` | 1/1 | 1/1 | Alt | 미확인(정렬코드 이력 없음) | 30 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL1_P` | 1/1 | 1/1 | B | 미확인(정렬코드 이력 없음) | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL2` | 1/1 | 1/1 | Material | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL2_A` | 1/1 | 1/1 | Alt | 미확인(정렬코드 이력 없음) | 30 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL2_P` | 1/1 | 1/1 | B | 미확인(정렬코드 이력 없음) | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL3` | 1/1 | 1/1 | Material | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL3_A` | 1/1 | 1/1 | Alt | 미확인(정렬코드 이력 없음) | 30 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL3_P` | 1/1 | 1/1 | B | 미확인(정렬코드 이력 없음) | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL4` | 1/1 | 1/1 | Material | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL4_A` | 1/1 | 1/1 | Alt | 미확인(정렬코드 이력 없음) | 30 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL4_P` | 1/1 | 1/1 | B | 미확인(정렬코드 이력 없음) | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL5` | 1/1 | 1/1 | Material | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL5_A` | 1/1 | 1/1 | Alt | 미확인(정렬코드 이력 없음) | 30 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL5_P` | 1/1 | 1/1 | B | 미확인(정렬코드 이력 없음) | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL6` | 1/1 | 1/1 | Material | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL6_A` | 1/1 | 1/1 | Alt | 미확인(정렬코드 이력 없음) | 30 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL6_P` | 1/1 | 1/1 | B | 미확인(정렬코드 이력 없음) | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL8` | 1/1 | 1/1 | Material | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL8_A` | 1/1 | 1/1 | Alt | 미확인(정렬코드 이력 없음) | 30 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL8_P` | 1/1 | 1/1 | B | 미확인(정렬코드 이력 없음) | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL9` | 1/1 | 1/1 | Material | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL9_A` | 1/1 | 1/1 | Alt | 미확인(정렬코드 이력 없음) | 30 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLEVEL9_P` | 1/1 | 1/1 | B | 미확인(정렬코드 이력 없음) | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BLOCKED_STOCK` | 2/2 | 2/2 | Blocked Stock | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BNP_IN_DATE` | 1/1 | 1/1 | BNP_IN_DATE | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOD_EX_FROM_YYYYMMDD` | 1/1 | 1/1 | From* | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOD_EX_TO_YYYYMMDD` | 1/1 | 1/1 | To* | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOD_FROM_YYYYMMDD` | 6/6 | 6/6 | BOD_FROM_YYYYMMDD | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOD_ID` | 62/44 | 60/43 | BOD ID | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOD_ITEM_VALID` | 1/1 | 1/1 | BOD Item Valid | C | 70 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `BOD_LEAD_TIME` | 2/2 | 2/2 | BOD | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOD_LT` | 1/1 | 1/1 | BOD L/T | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOD_PATTERN_ID` | 2/2 | 2/2 | BOD Pattern ID | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOD_START_TIME` | 2/2 | 2/2 | BOD Start Time | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOD_TOTAL_CODE` | 2/1 | 2/1 | Trans Mode* | C | 80 | FPComboBox | FPComboBox | dtlocBodTotal | X | 미확인(모달키 이력 없음) | medium | - |
| `BOD_TO_YYYYMMDD` | 6/6 | 6/6 | BOD_TO_YYYYMMDD | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOD_TYPE` | 1/1 | 0/0 | BOD Type | L | 120 | FPComboBox | FPComboBox | BodType | X | 미확인(모달키 이력 없음) | low | - |
| `BOD_VALID` | 2/2 | 2/2 | BOD Valid* | C | 50 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `BOD_VALIDATION` | 1/1 | 1/1 | BOD_VALIDATION | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH` | 23/21 | 23/21 | BOH (To Site) | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_CELL` | 1/1 | 1/1 | BOH(CELL) | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_CELL_BOX_PACKING_QTY` | 1/1 | 1/1 | Good(Box) | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_CELL_GOOD_QTY` | 1/1 | 1/1 | Good(Auto) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_CELL_HOLD_QTY` | 1/1 | 1/1 | Hold | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_CELL_LONG_TERM_QTY` | 1/1 | 1/1 | Long Term. | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_CELL_QTY` | 4/4 | 4/4 | BOH(Cell) | R | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_CELL_UNINSPEC_QTY` | 1/1 | 1/1 | Uninspec. | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_HOLD` | 1/1 | 1/1 | BOH(Hold Cell Tray) | R | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_INT` | 1/1 | 1/1 | BOH(Intransit Cell Tray) | R | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_INTRANSIT_HOLD_QTY` | 1/1 | 1/1 | Intransit | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_PACK_GOOD_QTY` | 1/1 | 1/1 | Good | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_PACK_HOLD_QTY` | 1/1 | 1/1 | Hold | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_PACK_QTY` | 1/1 | 1/1 | Total | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_QTY` | 21/21 | 21/21 | BOH | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOH_TYPE` | 2/2 | 2/2 | BOH_TYPE | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOM_LEVEL` | 1/1 | 1/1 | BOM Level | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOM_MIN_DUE_DATE` | 3/2 | 4/2 | Due Date | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOM_RATE` | 4/4 | 4/4 | BOM Rate | R | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOM_VERSION_ID` | 1/1 | 1/1 | BOM Version | R | 94 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOXID` | 2/2 | 2/2 | Box ID | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BOX_PER_CUT` | 1/1 | 1/1 | Box/Cut* | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BPMS_EXIST` | 7/5 | 10/4 | BPMS Exist | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `BP_CONFIRM` | 1/1 | 1/1 | BP Confirm | C | 75 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BTN_AUTH_YN` | 0/0 | 1/1 | Auth | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `BUCKET` | 2/2 | 2/2 | BUCKET | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BUFFER_DAY` | 2/2 | 2/2 | Buffer Day | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BUFFER_TIME` | 2/1 | 2/1 | Value | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BUFFER_TIME_UOM` | 2/1 | 2/1 | UOM | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BUILDING` | 5/4 | 5/4 | Building | L | 120 | (공란) | FPComboBox | BuildingByPlantSite | X | 미확인(모달키 이력 없음) | medium | - |
| `BUILDING_DESC` | 1/1 | 1/1 | Building Desc. | L | 140 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BUILD_AHEAD` | 1/1 | 1/1 | Build Ahead(day)* | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `BUSINESS_UNIT_CODE` | 1/1 | 1/1 | BU | L | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `B_TYPE_BOH` | 1/1 | 1/1 | P/C(Elec.) - B | R | 80 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `B_TYPE_BOH_HOLD` | 1/1 | 1/1 | P/C(Elec.) - B | R | 110 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `B_TYPE_BOH_ONLYHOLD` | 1/1 | 1/1 | P/C(Elec.) - B | R | 80 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CALCULATION` | 2/1 | 2/1 | Calculation | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CAL_QTY` | 1/1 | 1/1 | QTY (CAL) | R | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CAPA` | 1/1 | 1/1 | Capa* | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CAPACITY` | 4/3 | 3/2 | Capacity | C | 55 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CAPA_GRADE` | 9/5 | 9/5 | Capa. Grade | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CAPA_ORDER` | 1/1 | 1/1 | Daily Capacity Order | L | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CAP_PCT` | 1/1 | 1/1 | Cap(%) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CARRIER` | 4/2 | 4/2 | Carrier | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATE` | 19/19 | 19/19 | Category | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATEGORY` | 3/3 | 3/3 | Category | L | 200 | FPComboBox | FPComboBox | ITEM_CONV_CALC | X | 미확인(모달키 이력 없음) | medium | - |
| `CATEGORY_CODE` | 3/1 | 3/1 | Category | L | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATEGORY_DESC` | 0/0 | 3/1 | Category | L | 280 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATEGORY_DETAIL_ID` | 2/1 | 2/1 | Category Detail ID | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATEGORY_DV` | 1/1 | 1/1 | CATEGORY | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATEGORY_ID` | 33/30 | 36/31 | Category ID | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATEGORY_NAME` | 28/23 | 28/23 | Category | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATEGORY_ORDER` | 22/21 | 22/21 | Category Order | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATE_LV1` | 1/1 | 1/1 | Category | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATHODE_CODE` | 1/1 | 1/1 | Cathode | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATHODE_MATERIALS` | 4/4 | 4/4 | 양극재 | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CATHODE_NAME` | 1/1 | 1/1 | Cathode | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL` | 1/1 | 1/1 | CELL | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELLPHONENUM` | 0/0 | 2/1 | TEL | C | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_AGING_LT` | 1/1 | 1/1 | Aging L/T | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_ASSY_ITEM_ID` | 2/2 | 2/2 | Cell Assy Code | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_BATCH` | 1/1 | 1/1 | Cell/batch(Before R/Press) | R | 155 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_CF` | 12/5 | 14/7 | GPLM Cell Conversion factor | R | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_CF_BOM` | 2/2 | 2/2 | CELL CF BOM | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_CNT` | 2/2 | 2/2 | Channel Qty | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_CODE` | 1/1 | 1/1 | CELL CODE | L | 120 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_COMBO_DATA_TYPE` | 0/0 | 1/1 | Cell Combo Data Type | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_CONTROL_OBJECT_TYPE_CODE` | 0/0 | 1/1 | Cell object | C | 120 | FPComboBox | FPComboBox | ColumnControlType | O | 미확인(모달키 이력 없음) | low | - |
| `CELL_CONVERT_YN` | 1/1 | 1/1 | Cell Convert YN | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_CONVER_FACTOR` | 2/2 | 2/2 | GPLM Cell Conversion factor | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_CONVER_FACTOR_XLS` | 2/2 | 2/2 | GPLM Cell Conversion factor | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_CONVER_QUANTITY` | 2/2 | 2/2 | Cell Conversion Quantity | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_CONVER_QUANTITY_XLS` | 2/2 | 2/2 | Cell Conversion Quantity | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_EOL_SHIPPING_LOT` | 1/1 | 1/1 | EOL/Shipping Lot | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_GROUP` | 25/21 | 28/22 | Pjt Group Name | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_GROUP_CODE` | 9/6 | 9/6 | Cell Group Code | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_GROUP_ITEM_ID` | 1/1 | 1/1 | Cell Group Code | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_ID` | 3/2 | 3/2 | Cell* | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_ITEM_ID` | 20/17 | 21/18 | Cell Item ID | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_JUMBO` | 1/1 | 1/1 | Jumbo Roll(cell/m) | R | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_LINE_ID` | 1/1 | 1/1 | PKG Line* | L | 95 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_M` | 2/2 | 2/2 | Pancake(cell/m) | R | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_MATERIAL_ID` | 2/2 | 2/2 | Cell Material | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_MODEL` | 14/6 | 14/6 | Code | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_MODEL_INFO` | 3/3 | 3/3 | Cell Model Info | L | 80 | FPComboBox | FPComboBox | DMF0005_REPORT_GROUP6 | O | 미확인(모달키 이력 없음) | medium | - |
| `CELL_MODEL_NICKNAME` | 9/1 | 9/1 | NickName | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_MODEL_NICK_NAME` | 8/8 | 9/9 | Cell Model Nick Name | L | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_NAME` | 9/8 | 9/8 | Cell Name | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_NICK` | 1/1 | 1/1 | Cell Nick | C | 80 | FPComboBox | FPComboBox | DMF_BIZ_PLAN_METAL_CELL_NICK | X | 미확인(모달키 이력 없음) | medium | - |
| `CELL_NICKNAME` | 4/4 | 4/4 | Cell Nickname | L | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_NICK_NAME` | 4/4 | 4/4 | Nick Name | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_PACK_COUNT` | 1/1 | 1/1 | Cell Pack Count | R | 65 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_PER_CAR` | 17/16 | 19/16 | Cell/Car | R | 40 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_PER_MODULE` | 15/14 | 17/14 | Cell/Module | R | 40 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_PER_PACK` | 3/3 | 3/3 | Cell/Pack | L | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_PLANT_SITE_ID` | 1/1 | 1/1 | PKG Site* | L | 150 | FPComboBox | FPComboBox | PlantSiteByDivision | X | 미확인(모달키 이력 없음) | medium | - |
| `CELL_PROD_SITE` | 6/6 | 6/6 | Cell Prod Site | C | 80 | FPComboBox | FPComboBox | CELL_PROD_SITE | X | 미확인(모달키 이력 없음) | high | - |
| `CELL_PROD_SITE_ID` | 7/6 | 7/6 | Cell Prod Site* | L | 110 | (공란) | FPComboBox | CELL_PROD_SITE_ID | O | 미확인(모달키 이력 없음) | high | - |
| `CELL_QTY` | 1/1 | 1/1 | Cell Qty(/Biz Type) | R | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_QTY_PACK` | 5/5 | 5/5 | Cell qty/Pack | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_QUANTITY` | 8/6 | 9/7 | Cell Quantity | R | 40 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_S_OP_REPORT` | 1/1 | 2/1 | Cell Prod. Site (S&OP Report) | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_TYPE` | 29/27 | 35/30 | Product Group | L | 80 | (공란) | FPComboBox | CellTypeByDivision | O | 미확인(모달키 이력 없음) | medium | - |
| `CELL_TYPE_81` | 5/4 | 5/4 | Cell Type* | C | 80 | FPComboBox | FPComboBox | CELL_TYPE_81 | X | 미확인(모달키 이력 없음) | high | - |
| `CELL_TYPE_82` | 5/4 | 5/4 | Cell Type* | C | 80 | FPComboBox | FPComboBox | CELL_TYPE_82 | X | 미확인(모달키 이력 없음) | high | - |
| `CELL_TYPE_GR` | 5/5 | 5/5 | Cell Type Gr | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_TYPE_GROUP_CODE` | 6/6 | 6/6 | Cell Type Gr | L | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_TYPE_GROUP_NAME` | 1/1 | 1/1 | Product level1 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CELL_TYPE_NAME` | 0/0 | 2/1 | Cell Type | L | 80 | FPComboBox | FPComboBox | CellTypeByDivision | O | 미확인(모달키 이력 없음) | low | - |
| `CHANGE_QTY` | 1/1 | 1/1 | ⓑ Quantity Change | R | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHANGE_REASON` | 1/1 | 1/1 | CHANGE REASON | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHANGE_REASON_CODE` | 13/13 | 13/13 | Change Reason | L | 0 | FPComboBox | FPComboBox | CHANGE_REASON_CODE_ALL | X | 미확인(모달키 이력 없음) | high | - |
| `CHANGE_REASON_DETAIL` | 11/11 | 11/11 | Reason Detail | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHANGE_REQUEST_NO` | 3/3 | 3/3 | Change Request No | C | 150 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHANGE_REQ_NO` | 20/15 | 20/15 | Change Request No | L | 125 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHANGE_STATUS` | 2/2 | 2/2 | Change Status | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHANGE_TYPE` | 13/13 | 13/13 | CHANGE_TYPE | C | 10 | (공란) | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `CHARACTERIZATION_YIELD` | 1/1 | 1/1 | DW | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHARG` | 2/2 | 2/2 | CHARG | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHARGE_USER_ID` | 2/2 | 2/2 | Charge User | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHAR_YIELD` | 2/1 | 2/1 | Characteristic Yield(%) | R | 140 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHECK_CNT` | 2/1 | 2/1 | 추가입력필요 | C | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHECK_ERP_CNT` | 1/1 | 1/1 | ERP Data 확인 필요 | R | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHECK_GSCM_CNT` | 1/1 | 1/1 | Master Data 정비 필요 건 수 (GSCM) | R | 140 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHECK_INCOTERMS` | 1/1 | 1/1 | EDI Incoterms(SSPM) | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHECK_NEED_YN` | 9/9 | 9/9 | Checked | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHECK_SALES_ACTIVE` | 1/1 | 1/1 | Sales Site Active | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHECK_SALES_SITE` | 1/1 | 1/1 | Sales Site 누락 | C | 90 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHECK_SSPM` | 1/1 | 1/1 | SSPM 누락 | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHECK_SSPM_ACTIVE` | 1/1 | 1/1 | SSPM Active | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHECK_UI` | 1/1 | 2/2 | Problem Type | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHG_QTY` | 8/3 | 8/3 | Changed Qty* | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHG_RSN` | 5/1 | 5/1 | Reason* | L | 200 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHG_TYPE` | 5/1 | 5/1 | Change Type | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_ASSIGN_EXCEPT` | 2/1 | 2/1 | Child Assign Except | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_ASSIGN_LINE_ID` | 2/1 | 2/1 | Child Assign Line | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_ASSIGN_PRIORITY` | 2/1 | 2/1 | Child Assign Priority | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_ELECTRODE_TYPE` | 2/1 | 2/1 | Electrode Type | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_ITEM` | 1/1 | 1/1 | Child Item | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_ITEM_ATTRIBUTE` | 1/1 | 1/1 | Child Material Attribute | L | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_ITEM_ID` | 11/7 | 11/7 | Child Material | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_ITEM_NAME` | 2/2 | 2/2 | Child Item Name | L | 200 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_ITEM_TYPE` | 1/1 | 1/1 | Child  Material Type | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_LEVEL_3_NAME` | 1/1 | 1/1 | Child Material Class 3 | L | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_MATERIAL` | 1/1 | 1/1 | Child Mateial | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_MATERIAL_NAME` | 1/1 | 1/1 | Child Mateial Name | C | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_NICK_NAME` | 3/2 | 3/2 | Child Nick Name | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_OPERATION_ID` | 2/1 | 2/1 | Child Operation | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_QTY` | 5/4 | 5/4 | Child Quantity | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_SETUP_ATTRIBUTE` | 1/1 | 1/1 | Child Setup Attribute | L | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHILD_UOM` | 3/2 | 3/2 | Child UOM | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHK` | 26/22 | 24/20 | ALL | C | 40 | FPCheckBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHK1_RELEASE` | 2/1 | 2/1 | Cheak Release | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHK2_MES` | 2/1 | 2/1 | Cheak MES | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHK3_ERP` | 2/1 | 2/1 | Check ERP | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHK_FLAG` | 1/1 | 1/1 | CHK_FLAG | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CHK_QTY` | 1/1 | 1/1 | CHK_QTY | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CITY` | 9/8 | 8/6 | City | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CITY_NAME` | 16/15 | 16/14 | City | L | 80 | (공란) | FPModal | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `CLASSIFY_DATE` | 1/1 | 1/1 | 완료예정일(최초) 완료예정일(변경) 완료일 | C | 110 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CLASSIFY_START_DATE` | 1/1 | 1/1 | 시작일 | C | 110 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CLASSIFY_STATUS` | 1/1 | 1/1 | 상태 | C | 60 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `CLASSIFY_USER_ID` | 1/1 | 1/1 | 작업자 | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CLASS_ID` | 2/2 | 2/2 | Class ID | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CLASS_NAME` | 4/4 | 5/5 | Class Name | C | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CMC` | 7/6 | 7/6 | CMC | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CNFM_USER_ID` | 0/0 | 1/1 | Confirm User | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CNFM_USER_NAME` | 0/0 | 1/1 | Confirm User | L | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CNT` | 1/1 | 1/1 | Count | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CNTRC_EXCHANGE_PRICE` | 1/1 | 1/1 | Contract Ex. Rate | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CNTR_NO` | 2/2 | 2/2 | CNTR No. | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CODE` | 1/1 | 1/1 | CODE | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CODE_SUCCESS_YN` | 0/0 | 1/1 | code success | L | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CODE_VALID_YN` | 1/1 | 1/1 | Active | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COLUMN DESCRIPTION` | 2/2 | 2/2 | Column Description | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COLUMN TAB` | 0/0 | 1/1 | grid | R | 222 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COLUMN_LABEL_NAME` | 0/0 | 2/1 | Column Label Name | L | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COLUMN_NAME` | 0/0 | 3/2 | Column Name | L | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COLUMN_WIDTH` | 0/0 | 1/1 | Column Width | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COLUM_LABEL_NAME` | 1/1 | 1/1 | Measure | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COL_LIST` | 3/2 | 3/2 | COL_LIST | L | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COL_NM` | 0/0 | 1/1 | Parameter Name | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COL_TP_CD` | 0/0 | 1/1 | Input/Output | C | 100 | FPComboBox | FPComboBox | InOrOut | O | 미확인(모달키 이력 없음) | low | - |
| `COMMENT` | 2/2 | 2/2 | Comment | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COMMENTS` | 2/2 | 2/2 | Comments | L | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COMMON_CELL_YN` | 1/1 | 1/1 | Common Cell | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `COMPANY` | 6/5 | 6/5 | Company | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COMPANY_ID` | 168/105 | 183/107 | Company | C | 0 | FPTextBox | FPComboBox | DM_COMPANY | O | 미확인(모달키 이력 없음) | high | - |
| `COMPANY_NAME` | 7/1 | 8/1 | Company Name | L | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COMPLETED_CNT` | 2/2 | 2/2 | 정상 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COMPLETED_YN` | 1/1 | 1/1 | Completed | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COMPLETE_CNT` | 1/1 | 1/1 | Count | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COMPLETE_QTY` | 1/1 | 1/1 | Quantity | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COMPLETE_RATIO` | 1/1 | 1/1 | Ratio(%) | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COMPLITE_DATE` | 1/1 | 1/1 | Complete Date | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONDUCTING_MATERIAL` | 4/4 | 4/4 | Conducting Material | L | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONDUCTION_MATERIAL_1` | 4/3 | 4/3 | Conducting Material 1 | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONDUCTION_MATERIAL_2` | 4/3 | 4/3 | Conducting Material 2 | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIG_SET_ID` | 1/1 | 1/1 | CONFIG_SET_ID | L | 110 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM` | 1/1 | 1/1 | Action | C | 120 | FPButton | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_AREA` | 1/1 | 1/1 | Confirm Type | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_DATE` | 5/5 | 5/5 | Confirm Time | C | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_DAY` | 7/6 | 7/6 | Confrim Day | C | 30 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_FLAG` | 7/5 | 7/5 | Finish | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_ID` | 31/20 | 31/20 | Confirm/Plan ID | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_OPINION` | 1/1 | 1/1 | 종료의견 | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_QTY` | 2/2 | 2/2 | Confirmed Qty | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_QTY_CELL` | 1/1 | 1/1 | Confirm Qty (Cell) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_QTY_JR` | 1/1 | 1/1 | Confirm Qty (Jumboroll m) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_QTY_PANCAKE` | 1/1 | 1/1 | Confirm Qty (Pancake m) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_QTY_ROLL_LENGTH` | 1/1 | 1/1 | Confirm Qty (Cut) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_STATUS` | 1/1 | 1/1 | 상태 | C | 60 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `CONFIRM_TIME` | 2/1 | 2/1 | Confirm Time | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_USER_ID` | 1/1 | 1/1 | 종료자 아이디 | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_USER_NAME` | 1/1 | 1/1 | 종료자 | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONFIRM_YN` | 4/4 | 4/4 | CONFIRM_YN | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONSENSUS` | 1/1 | 1/1 | CONSENSUS | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONSENSUS_ESS` | 1/1 | 1/1 | ESS Subsidiary* | C | 100 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `CONSENSUS_MKT` | 1/1 | 1/1 | MKT* | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `CONSENSUS_SCM` | 1/1 | 1/1 | SCM* | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `CONSTRAINTS01` | 1/1 | 1/1 | CONSTRAINTS01 | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTAINER_COST` | 2/1 | 2/1 | 물류비(USD) | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTAINER_COUNT` | 1/1 | 1/1 | Container 개수 | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTAINER_QTY` | 2/1 | 2/1 | 컨테이너수량 | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTRACT_UNIT1` | 1/1 | 1/1 | Ni | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTRACT_UNIT2` | 1/1 | 1/1 | Co | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTRACT_UNIT3` | 1/1 | 1/1 | Li2CO3 | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTRACT_UNIT4` | 1/1 | 1/1 | LIOH | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTRACT_UNIT5` | 1/1 | 1/1 | Al | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTRACT_UNIT6` | 1/1 | 1/1 | Mn | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTRACT_UNIT7` | 1/1 | 1/1 | Cu | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTRIBUTION_RATIO` | 0/0 | 1/1 | Ratio | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONTRIBUTION_TYPE` | 1/1 | 2/2 | 기여율 구분 | C | 80 | FPComboBox | FPComboBox | DMF0005_DM_CONTRIBUTION_TYPE_CD | O | 미확인(모달키 이력 없음) | medium | - |
| `CONVERSION` | 7/6 | 7/6 | Conversion (1 Batch) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONVERT_CELL_QTY` | 1/1 | 1/1 | Convert Cell Qty | R | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONVERT_QTY_CELL` | 4/4 | 3/3 | Convert Qty Cell | R | 200 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONVERT_QTY_MODULE` | 2/2 | 1/1 | Convert Qty(Module) | R | 200 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CONVERT_QTY_PACK` | 2/2 | 1/1 | Convert Qty(Pack) | R | 200 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CORPORATION` | 1/1 | 1/1 | Corporation | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COUNT` | 1/1 | 2/2 | Count | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COUNTRY` | 10/9 | 9/7 | Country | L | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `COUNTRY_CODE` | 2/2 | 2/2 | Country Name | L | 80 | FPComboBox | FPComboBox | COUNTRY_MST | O | 미확인(모달키 이력 없음) | medium | - |
| `COUNTRY_NAME` | 17/16 | 17/15 | Country | L | 80 | (공란) | FPModal | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `COVER_DAY_TYPE` | 0/0 | 1/1 | TYPE* | C | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CO_KG_PER_BIZ_TYPE` | 1/1 | 1/1 | Co | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CO_MIX_METAL_LINK_PERIOD` | 1/1 | 1/1 | Co | C | 80 | FPComboBox | FPComboBox | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | X | 미확인(모달키 이력 없음) | medium | - |
| `CO_USD_PER_KG` | 1/1 | 1/1 | Co | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CP_KEY` | 3/3 | 3/3 | CP_KEY | L | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CP_MATERIAL_GROUP` | 2/2 | 2/2 | CP Material Group | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CP_MODEL` | 2/2 | 2/2 | CP Material | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CP_PROCESS_GROUP` | 2/2 | 2/2 | CP Process Group | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CREATED_BY` | 46/36 | 69/50 | Created By | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CREATE_DATE` | 5/3 | 5/3 | Creator Date | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CREATE_FROM_YYYYMMDD` | 1/1 | 1/1 | Create From YYMMDD | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CREATE_PSN_ID` | 1/1 | 1/1 | CREATE_PSN_ID | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CREATE_TO_YYYYMMDD` | 1/1 | 1/1 | Create To YYMMDD | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CREATE_USER_ID` | 3/1 | 3/1 | Creator | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CREATION_DATE` | 49/38 | 72/53 | Creation Date | C | 150 | FPDateTime | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CREATION_TYPE` | 1/1 | 1/1 | Occurrence Types | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CRGE_ORG_NM` | 1/1 | 1/1 | Org.Name (Report) | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CSR_ID` | 1/1 | 1/1 | CSR_ID | C | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CSR_NO` | 1/1 | 1/1 | CSR 번호 | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CURRENCY` | 33/25 | 34/25 | Currency | L | 40 | (공란) | FPComboBox | CURRENCY_LIST | X | 미확인(모달키 이력 없음) | high | - |
| `CURRENCY_UNITCURRENCY` | 0/0 | 1/1 | Currency | L | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CURRENT_OP_START_DATE` | 2/1 | 2/1 | Current OP Start Date | C | 80 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUR_AUTH` | 2/2 | 2/2 | Current Auth. | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUST` | 2/1 | 2/1 | CUSTOMER | L | 70 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER` | 6/5 | 8/6 | Customer | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER_CALL_OFF_NO` | 1/1 | 1/1 | Call-Off No. | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER_CODE` | 11/9 | 9/8 | Customer Code | L | 100 | (공란) | FPComboBox | EndCustomerByDivisionDept | O | 미확인(모달키 이력 없음) | high | - |
| `CUSTOMER_ID` | 7/7 | 7/7 | Customer | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER_ITEM_ID` | 1/1 | 2/1 | Cust. Item ID | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER_LT` | 7/7 | 6/6 | Customer LT | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER_MODEL` | 9/7 | 9/6 | Customer Model | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER_NAME` | 5/5 | 5/5 | Customer Name | L | 210 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER_PLANT` | 2/2 | 3/2 | Cust. Plant | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER_PO_NO` | 1/1 | 1/1 | P/O No. | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER_PROJECT_CODE` | 2/2 | 2/2 | Customer PJT* | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER_PSI` | 3/2 | 1/1 | Customer PSI* | L | 60 | FPComboBox | FPComboBox | CustomerPSI | O | 미확인(모달키 이력 없음) | medium | - |
| `CUSTOMER_REQUIRMENT` | 1/1 | 1/1 | Customer Requirement | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUSTOMER_VALID_YN` | 1/1 | 1/1 | Customer Active* | C | 80 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `CUST_ENG_NM` | 1/1 | 1/1 | End Customer (Report) | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUST_GROUP` | 15/15 | 16/15 | Cust Group | L | 80 | (공란) | FPComboBox | CustGroup | O | 미확인(모달키 이력 없음) | high | - |
| `CUST_GROUP_DTL` | 16/16 | 16/16 | Cust Group Detail | L | 80 | (공란) | FPComboBox | CUST_GROUP_DTL | O | 미확인(모달키 이력 없음) | high | - |
| `CUST_ITEM_ID` | 2/2 | 2/2 | Cust. Item ID | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUST_MATERIAL_CODE` | 1/1 | 1/1 | Customer Code | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUST_PLANT` | 1/1 | 1/1 | Cust. Plant | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUST_REPORT` | 3/3 | 4/4 | Cust. (Report) | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUST_UNLOADING_POINT` | 1/1 | 1/1 | Cust. Unloading Point | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUTOFF_DATE` | 12/9 | 12/9 | Cutoff Date | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CUTOFF_YYYYMMDD` | 5/2 | 5/2 | CUTOFF_YYYYMMDD | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CU_KG_PER_BIZ_TYPE` | 1/1 | 1/1 | Cu | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CU_MIX_METAL_LINK_PERIOD` | 1/1 | 1/1 | Cu | C | 80 | FPComboBox | FPComboBox | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | X | 미확인(모달키 이력 없음) | medium | - |
| `CU_USD_PER_KG` | 1/1 | 1/1 | Cu | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CY2_ATA` | 1/1 | 1/1 | ATA | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CY2_ETA` | 1/1 | 1/1 | ETA | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CY2_PORT` | 1/1 | 1/1 | Port | L | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CYCLE` | 1/1 | 1/1 | Cycle | R | 50 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CYCLE_CLASS_CODE` | 0/0 | 1/1 | Main * | C | 100 | FPComboBox | FPComboBox | MailSendCycle | O | 미확인(모달키 이력 없음) | low | - |
| `CYCLE_STOCK` | 1/1 | 1/1 | Cycle Stock | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `CYCLE_TOTAL_AUTO` | 1/1 | 1/1 | Cycle Total | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DAILY_BOH_QTY` | 1/1 | 1/1 | Daily(BOH) | C | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DAILY_CAPA` | 1/1 | 1/1 | Daily Capa | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DAILY_CAPACITY` | 4/1 | 4/1 | Daily Capacity | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DAILY_CAPA_CHECK` | 2/1 | 2/1 | Capa | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DAILY_CAPA_QTY` | 2/2 | 2/2 | Daily Capacity* | R | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DAILY_CAPA_QTY_FP` | 1/1 | 1/1 | Daily Capacity(FP) | R | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DATA_MAX_LENGTH` | 0/0 | 1/1 | Data Max Length | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DATA_SCALE_NUMBER` | 0/0 | 1/1 | Data Scale Num | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DATA_SEQ` | 1/1 | 1/1 | DATA_SEQ | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DATA_SORT_METHOD_CODE` | 0/0 | 1/1 | Data Sort Method | C | 80 | FPComboBox | FPComboBox | DataSortMethod | O | 미확인(모달키 이력 없음) | low | - |
| `DATA_TABLE` | 3/3 | 3/3 | DATA_TABLE | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DATA_TP_CD` | 3/1 | 4/2 | Data TP CD | C | 100 | FPTextBox | FPComboBox | DataType | O | 미확인(모달키 이력 없음) | low | - |
| `DATA_TYPE` | 24/23 | 24/23 | Data Type | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DATA_TYPE_CODE` | 1/1 | 2/1 | ERP/SCM | C | 55 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DATE` | 1/1 | 1/1 | Date* | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DATE_FINISH_REAL` | 1/1 | 1/1 | 실제 완료일 | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DATE_FORECAST_FINISH` | 1/1 | 1/1 | 예상 완료일 | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DATE_FORECAST_START` | 1/1 | 1/1 | 예상 시작일 | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DAYOFWEEK_NAME` | 1/1 | 1/1 | Day | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DAYS_FRI` | 5/4 | 5/4 | Fri | C | 40 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `DAYS_MON` | 5/4 | 5/4 | Mon | C | 40 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `DAYS_SAT` | 5/4 | 5/4 | Sat | C | 40 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `DAYS_SUN` | 5/4 | 5/4 | Sun | C | 40 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `DAYS_THU` | 5/4 | 5/4 | Thu | C | 40 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `DAYS_TUE` | 5/4 | 5/4 | Tue | C | 40 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `DAYS_WED` | 5/4 | 5/4 | Wed | C | 40 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `DAY_CNT` | 0/0 | 5/1 | DAY_CNT | R | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DAY_CNT_BASE` | 1/1 | 1/1 | DAY_CNT_BASE | R | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DAY_OF_WEEK` | 1/1 | 1/1 | Day of Week | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DB_COL_NM` | 0/0 | 1/1 | DB Parameter Name | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DB_COL_TP_CD` | 0/0 | 1/1 | DB Input/Output | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DB_DATA_TP_CD` | 0/0 | 1/1 | DB Data Type | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DB_SORT_ORD` | 0/0 | 1/1 | DB Sort Order | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DC_BATCH` | 7/7 | 7/7 | Batch | R | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DC_CELL` | 4/4 | 4/4 | Cell | R | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DC_ELEC` | 1/1 | 1/1 | Elec. | C | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DC_FLAG` | 3/3 | 3/3 | Flag | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DC_JR` | 4/4 | 4/4 | M(J/R) | R | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DC_KG` | 7/7 | 7/7 | Kg | R | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DC_LEVEL` | 1/1 | 2/1 | DC_LEVEL | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DC_M` | 4/4 | 4/4 | M(P/C) | R | 45 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DC_PPM` | 7/6 | 7/6 | PPM | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEFAULT_FLAG` | 1/1 | 3/2 | Route Flag | C | 80 | FPTextBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `DEFAULT_MARKET` | 1/1 | 1/1 | Market | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEFAULT_ROUTE` | 1/1 | 1/1 | Default Route | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEFAULT_YN` | 1/1 | 1/1 | Is Default | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEFECT_QTY` | 6/5 | 6/5 | Deffect Qty | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEGAS_END_DATE` | 1/1 | 1/1 | Degas End Date | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEGAS_YIELD` | 1/1 | 1/1 | DW | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEGREE` | 1/1 | 1/1 | Degree | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELAY_YN_CLASSIFY` | 1/1 | 1/1 | 지연 CLASSIFY | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELAY_YN_DEV` | 1/1 | 1/1 | 지연 DEV | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELAY_YN_FINISH` | 1/1 | 1/1 | 지연 FINISH | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELAY_YN_PRIORITY` | 1/1 | 1/1 | 지연 PRIORITY | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELAY_YN_RECEIPT` | 1/1 | 1/1 | 지연 RECEIPT | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELAY_YN_REVIEW` | 1/1 | 1/1 | 지연 REVIEW | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELAY_YN_TEST` | 1/1 | 1/1 | 지연 TEST | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELEGATEE` | 1/1 | 1/1 | Delegatee | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELEGATEE_DEPT` | 2/2 | 2/2 | Delegatee Dept Name | L | 130 | FPComboBox | FPComboBox | Dept | X | 미확인(모달키 이력 없음) | medium | - |
| `DELEGATEE_USER` | 2/2 | 2/2 | Delegatee | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELEGATEE_USER_NAME` | 2/2 | 2/2 | Delegatee | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELEGATOR` | 1/1 | 1/1 | Delegator | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELETE` | 1/1 | 1/1 | 파일 삭제 | C | 90 | FPButton | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELETE_FLAG` | 1/1 | 1/1 | DELETE_FLAG | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DELIVERY_QTY` | 3/3 | 3/3 | Delivery Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEMAND` | 1/1 | 1/1 | Demand | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEMAND_CELL` | 1/1 | 1/1 | Demand | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEMAND_GROUPING_DAYS` | 1/1 | 1/1 | Demand Grouping Days | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEMAND_HORIZON` | 1/1 | 1/1 | Demand Horizon | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEMAND_ID` | 15/2 | 15/2 | Demand ID | L | 320 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEMAND_LOT_SIZE` | 4/4 | 4/4 | Demand Lot Size | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEMAND_OPERATION` | 1/1 | 1/1 | 수요/운영 | C | 80 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `DEMAND_PLAN_ID` | 1/1 | 1/1 | Demand Plan ID | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEMAND_TYPE` | 6/4 | 6/4 | Demand Type | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEMO EDIT PROG` | 0/0 | 1/1 | Demo Edit | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEMO EDIT PROG1` | 0/0 | 1/1 | Demo Edit | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEMO002` | 0/0 | 1/1 | not ecist | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEPARTMENT` | 7/7 | 8/8 | PIC(Team) | L | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEPARTMENT_ID` | 8/4 | 8/4 | DEPARTMENT_ID | L | 80 | (공란) | FPComboBox | DMF0041_MDF_Team | O | 미확인(모달키 이력 없음) | high | 콤보측↔T_DEPARTMENT_ID |
| `DEPARTMENT_NAME` | 2/2 | 4/3 | 부문 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEPARTURE_DAY` | 1/1 | 1/1 | Departure day | L | 140 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `DEPARTURE_INTRANSIT_VMI_AUTO` | 1/1 | 1/1 | Departure Days /Intransit /VMI | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEPT_DAY` | 2/2 | 2/2 | Dept_Day | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEPT_ID` | 44/37 | 55/40 | Team | L | 80 | FPComboBox | FPComboBox | DeptId | O | UserMgmt | high | 콤보측↔T_DEPT_ID |
| `DEPT_ID2` | 4/4 | 4/4 | Team | C | 80 | FPComboBox | FPComboBox | TeambyDivision2 | O | 미확인(모달키 이력 없음) | high | - |
| `DEPT_ID40` | 3/3 | 3/3 | Team | L | 80 | FPComboBox | FPComboBox | DeptId | O | 미확인(모달키 이력 없음) | high | - |
| `DEPT_ID_82` | 1/1 | 1/1 | Team(Sales) | L | 80 | FPComboBox | FPComboBox | TeambyDivision | O | 미확인(모달키 이력 없음) | medium | - |
| `DEPT_NAME` | 7/7 | 24/15 | Department | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEPT_NAME_CN` | 0/0 | 2/1 | Department(CN) | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEPT_NAME_EN` | 0/0 | 2/1 | Department(EN) | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEPT_NAME_KO` | 23/19 | 25/21 | Team | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEPT_NM` | 1/1 | 6/6 | Dept Name | L | 240 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEPT_POP_BTN` | 0/0 | 1/1 | Search | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DESC` | 5/2 | 6/3 | Desc | L | 200 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DESCRIPTION` | 38/28 | 41/30 | Description | L | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DETAIL` | 1/1 | 1/1 | Detail | C | 200 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DETAILS` | 1/1 | 1/1 | Details | L | 400 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DETAIL_CLASS_CODE` | 0/0 | 1/1 | Sub1 | C | 100 | FPComboBox | FPComboBox | MailSendCycleDetail | O | 미확인(모달키 이력 없음) | low | - |
| `DETAIL_POSITION` | 1/1 | 1/1 | Detail position | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEVALUATION_AGE` | 2/2 | 2/2 | Devaluation Age | C | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEV_DATE` | 1/1 | 1/1 | 완료예정일(최초) 완료예정일(변경) 완료일 | C | 110 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEV_START_DATE` | 1/1 | 1/1 | 시작일 | C | 110 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DEV_STATUS` | 1/1 | 1/1 | 상태 | C | 60 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `DEV_USER_ID` | 1/1 | 1/1 | 작업자 | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DFCT_QTY2` | 1/1 | 1/1 | Defect QTY | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DIF_ANLS_TP_CD` | 1/1 | 1/1 | Demand/Operation | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DIO` | 1/1 | 1/1 | Day | C | 50 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DIR` | 1/1 | 1/1 | Status | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DISABLE_YN` | 0/0 | 1/1 | Disable Flag | L | 20 | FPCheckBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DISPLAY_SEQ` | 4/3 | 3/2 | DISPLAY_SEQ | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DISTRIBUTION_CHANNEL` | 3/3 | 3/3 | Distribution Channel | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DIS_TOTAL_LEAD_TIME` | 1/1 | 1/1 | Distribution Total Lead Time | R | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DIV` | 3/1 | 3/1 | Div | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DIVISION` | 4/4 | 4/4 | Division | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DIVISION_ID` | 565/305 | 592/311 | Division | C | 60 | FPTextBox | FPComboBox | Division | O | 미확인(모달키 이력 없음) | high | - |
| `DIVISION_ID40` | 1/1 | 1/1 | Division* | L | 30 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DIVISION_NAME` | 45/36 | 56/43 | Division | L | 130 | FPTextBox | FPComboBox | MyDivision | O | 미확인(모달키 이력 없음) | low | - |
| `DIVSION_ID` | 1/1 | 1/1 | Div | L | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DMS_CUSTOMER` | 11/11 | 11/11 | End Cust.(Report) | L | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DMS_SALES` | 13/11 | 13/11 | Sold-To Cust.(Report) | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DM_BIZ_TYPE` | 2/1 | 4/2 | 형태 | L | 100 | (공란) | FPComboBox | DM_Biz_Type | X | 미확인(모달키 이력 없음) | medium | - |
| `DM_REQUESTED_BY` | 2/1 | 2/1 | DM_REQUESTED_BY | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DM_REQUEST_DATE` | 2/1 | 2/1 | Request Date | L | 170 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DM_REQ_NO` | 2/1 | 2/1 | DM. Req No | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DM_RTF_YN` | 1/1 | 1/1 | DM RTF YN | C | 100 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `DNI_ARRIVAL_INLAND` | 1/1 | 1/1 | Arrival Inland | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_ARRIVAL_INLAND_SUM` | 1/1 | 1/1 | Arrival Inland | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_CELL_ARRIVAL_INLAND` | 1/1 | 1/1 | Arrival Inland | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_CELL_DEPARTURE_DAYS` | 1/1 | 1/1 | Departure Days | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_CELL_DEPARTURE_INLAND` | 1/1 | 1/1 | Departure Inland | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE` | 1/1 | 1/1 | Lay Off/Customs Clearance | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_CELL_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_CELL_VOYAGE` | 1/1 | 1/1 | Voyage | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_CELL_WAITING_FOR_SHIPPING` | 1/1 | 1/1 | Waiting For Shipping | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_DEPARTURE_DAYS_SUM` | 1/1 | 1/1 | Departure Days | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_DEPARTURE_INLAND` | 1/1 | 1/1 | Departure Inland | R | 65 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_DEPARTURE_INLAND_SUM` | 1/1 | 1/1 | Departure Inland | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_DEPART_DAYS` | 1/1 | 1/1 | Departure Days | R | 65 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_LAY_OFF_CUSTOMS_CLEARANCE` | 1/1 | 1/1 | Lay Off/Customs Clearance | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_LAY_OFF_CUSTOMS_CLEARANCE_SUM` | 1/1 | 1/1 | Lay Off/Customs Clearance | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_PACK_ARRIVAL_INLAND` | 1/1 | 1/1 | Arrival Inland | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_PACK_DEPARTURE_DAYS` | 1/1 | 1/1 | Departure Days | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_PACK_DEPARTURE_INLAND` | 1/1 | 1/1 | Departure Inland | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE` | 1/1 | 1/1 | Lay Off/Customs Clearance | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_PACK_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_PACK_VOYAGE` | 1/1 | 1/1 | Voyage | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_PACK_WAITING_FOR_SHIPPING` | 1/1 | 1/1 | Waiting For Shipping | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_VOYAGE` | 1/1 | 1/1 | Voyage | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_VOYAGE_SUM` | 1/1 | 1/1 | Voyage | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_WAITING_FOR_SHIPPING` | 1/1 | 1/1 | Waiting For Shipping | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DNI_WAITING_FOR_SHIPPING_SUM` | 1/1 | 1/1 | Waiting For Shipping | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DOM_EXP` | 24/22 | 22/19 | Customs Handbook* | L | 30 | FPComboBox | FPComboBox | DOM_EXP | O | 미확인(모달키 이력 없음) | high | - |
| `DOM_EXP_TYPE_CODE` | 1/1 | 1/1 | DOM/EXP.* | C | 100 | FPComboBox | FPComboBox | DomExpTypeCode | X | 미확인(모달키 이력 없음) | medium | - |
| `DPJT_ATUH_REG_STATUS` | 0/0 | 3/2 | Auth Management Status | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_ATUH_REG_STATUS_COLOR_TYPE` | 0/0 | 3/2 | Auth Management Status | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_ATUH_REG_STATUS_NAME` | 0/0 | 3/2 | Auth Management Status | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_ATUH_REG_STR` | 0/0 | 3/2 | Auth Management | L | 80 | FPModal | FPModal | 미확인(콤보 배정 이력 없음) | - | ProjectAuthRegModal | medium | - |
| `DPJT_AUTH_MGMT` | 0/0 | 1/1 | Auth Management | L | 80 | FPModal | FPModal | 미확인(콤보 배정 이력 없음) | - | ProjectAuthRegModal | low | - |
| `DPJT_AUTH_REQ_LINK` | 0/0 | 1/1 | Auth Request | C | 40 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_AUTH_REQ_READ` | 0/0 | 1/1 | Auth Request Read | C | 30 | FPCheckBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_AUTH_REQ_STATUS` | 0/0 | 1/1 | Auth Request Status | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_AUTH_REQ_WRITE` | 0/0 | 1/1 | Auth Request Write | C | 30 | FPCheckBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_AUTH_REQ_WRITE_COLOR_TYPE` | 0/0 | 1/1 | Auth Request Status | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_AUTH_REQ_WRITE_NAME` | 0/0 | 1/1 | Auth Request Status | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_AUTH_STATUS` | 0/0 | 1/1 | Dpjt Auth Status | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_AUTH_STATUS_NAME` | 0/0 | 1/1 | Status | C | 40 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_AUTH_TYPE` | 0/0 | 3/2 | My Authority | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_AUTH_TYPE_NAME` | 0/0 | 3/2 | My Authority | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_CLASS` | 0/0 | 6/3 | Project Class | L | 0 | FPComboBox | FPComboBox | DpjtClass | O | 미확인(모달키 이력 없음) | medium | - |
| `DPJT_CLASS_NAME` | 0/0 | 3/1 | Project Class | L | 80 | FPComboBox | FPComboBox | DpjtClass | O | 미확인(모달키 이력 없음) | low | - |
| `DPJT_CODE` | 0/0 | 6/3 | Project Code | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_DEVELOP_STATUS` | 0/0 | 3/3 | Development Status | C | 80 | FPComboBox | FPComboBox | DpjtDevelopStatus | O | 미확인(모달키 이력 없음) | medium | - |
| `DPJT_DEVELOP_STATUS_NAME` | 0/0 | 1/1 | Development Status | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_KEY` | 0/0 | 9/3 | Project Key | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_KEY_PARENT` | 0/0 | 1/1 | Project Key Parent | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_NAME` | 0/0 | 6/3 | Project Name | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_REG_CAT` | 0/0 | 2/1 | Project Reg. Category | L | 80 | FPComboBox | FPComboBox | DpjtRegCat | X | 미확인(모달키 이력 없음) | medium | - |
| `DPJT_REG_STATUS` | 0/0 | 3/2 | Reg Status | C | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_REG_STATUS_COLOR_TYPE` | 0/0 | 3/2 | Reg Status Color | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_REG_STATUS_NAME` | 0/0 | 3/2 | Reg Status | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DPJT_SEQ` | 0/0 | 6/3 | Seq | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DQ_ID` | 0/0 | 4/1 | DQ ID | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DQ_NAME` | 0/0 | 1/1 | Query Name | L | 250 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DQ_TEXT` | 0/0 | 2/1 | SQL | L | 600 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DR1` | 2/2 | 2/2 | DR1 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DR2` | 2/2 | 2/2 | DR2 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DR3` | 2/2 | 2/2 | DR3 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DR4` | 2/2 | 2/2 | DR4 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DR5` | 2/2 | 2/2 | DR5 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DRTTL` | 2/2 | 2/2 | DR TTL | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DRTTL_INCOTERMS` | 1/1 | 1/1 | DR TTL(Incoterms) | R | 75 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DSCRIPTION` | 1/1 | 1/1 | Desc. | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DUE_DATE` | 15/11 | 15/11 | Due Date | C | 75 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DUE_FENCE_DATE` | 2/2 | 2/2 | Due Date | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DUMMY_YN` | 3/2 | 4/2 | Dummy | C | 0 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `DUR_TIME` | 1/1 | 1/1 | duratiion | C | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DV` | 1/1 | 1/1 | DV | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DW_SUBMIT_FLAG` | 1/1 | 1/1 | DW Submit Flag | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `DW_SUBMIT_TIME` | 1/1 | 1/1 | DW Submit Time | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `D_COUNTRY` | 8/8 | 8/8 | D Country | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `D_FRI` | 2/2 | 1/1 | Fri | C | 50 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `D_MON` | 2/2 | 1/1 | Mon | C | 50 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `D_PORT_CODE` | 8/8 | 8/8 | D Port | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `D_PORT_NAME` | 2/2 | 2/2 | Port* | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `D_SAT` | 2/2 | 1/1 | Sat | C | 50 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `D_SUN` | 2/2 | 1/1 | Sun | C | 50 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `D_THU` | 2/2 | 1/1 | Thu | C | 50 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `D_TUE` | 2/2 | 1/1 | Tue | C | 50 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `D_WED` | 2/2 | 1/1 | Wed | C | 50 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `E0500` | 1/1 | 1/1 | Pre Mixing | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `E1000` | 1/1 | 1/1 | Mixing | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `E2000` | 1/1 | 1/1 | Coating | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `E2300` | 1/1 | 1/1 | InsulationCoating(J/R) | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `E2500` | 1/1 | 1/1 | Half Slitting | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `E3000` | 1/1 | 1/1 | Roll Pressing | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `E3500` | 1/1 | 1/1 | Taping | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `E4000` | 1/1 | 1/1 | Slitting | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `E4500` | 1/1 | 1/1 | Insulation Coating(Pancake) | 미확인(정렬코드 이력 없음) | 160 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `E8000` | 1/1 | 1/1 | ElectrodeV/D | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ECO_CODE` | 3/2 | 3/2 | Eco Code | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDI` | 5/4 | 6/4 | EDI Incoterms | L | 80 | FPComboBox | FPComboBox | Incoterms | O | 미확인(모달키 이력 없음) | high | - |
| `EDITABLE` | 1/1 | 1/1 | EDITABLE | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDITABLE_YN` | 1/1 | 1/1 | EDITABLE_YN | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDITORBLE_YN` | 2/2 | 2/2 | EDITORBLE_YN | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDIT_CHECK` | 2/1 | 2/1 | EDIT_CHECK | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDIT_FLAG` | 40/27 | 37/23 | Edit Flag | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDIT_FLAG2` | 5/5 | 5/5 | Edit Flag | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDIT_FLAG3` | 4/4 | 4/4 | Edit Flag | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDIT_MAIN` | 10/10 | 10/10 | EDIT_MAIN | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDIT_REMARKS` | 10/10 | 10/10 | EDIT_REMARKS | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDIT_TYPE` | 1/1 | 1/1 | EDIT_TYPE | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDIT_YN` | 17/14 | 18/15 | Edit Y/N | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDIT_YN2` | 1/1 | 1/1 | Edit Y/N 2 | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDI_FCST_YN` | 4/2 | 2/1 | EDI FCST Y/N* | C | 0 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `EDI_IF_SEQ` | 3/3 | 3/3 | EDI No | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDI_LT` | 5/4 | 7/4 | EDI Leadtime | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDI_QTY` | 4/3 | 4/3 | ⓐCust.FCST(EDI/RPA) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDI_SENDER_CODE` | 1/1 | 1/1 | EDI Sender Code | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EDI_SENDER_NAME` | 2/1 | 2/1 | EDI Sender Name | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EFCY` | 1/1 | 1/1 | Efficiency* | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EFCY1` | 1/1 | 1/1 | Efficiency 1(%)* | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EFCY2` | 1/1 | 1/1 | Efficiency 2(%) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EFCY3` | 1/1 | 1/1 | Efficiency 3(%) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EFCY4` | 1/1 | 1/1 | Efficiency 4(%) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EFFECTIVE_DATA_COUNT` | 2/1 | 2/1 | Effective Data Count | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EFF_END_DATE` | 4/3 | 3/2 | Effective End Date | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EFF_START_DATE` | 4/3 | 3/2 | Effective Start Date | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELECTRODE` | 1/1 | 1/1 | ELECTRODE | C | 75 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELECTRODE_POST_OPER` | 1/1 | 1/1 | Post Oper. | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELECTRODE_POST_OPER_LT` | 1/1 | 1/1 | Oper. L/T | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELECTRODE_TYPE` | 147/106 | 151/108 | Electrode Type | C | 60 | FPTextBox | FPComboBox | ELECTRODE_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `ELECTRODE_YN` | 15/12 | 15/12 | ELECTRODE_YN | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELECTROD_TYPE` | 2/2 | 2/2 | Elec. | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELEC_FACTORY_ID` | 1/1 | 1/1 | Elec. Bld. | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELEC_ITEM_ID` | 1/1 | 1/1 | Item Code | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELEC_LINE_ID` | 1/1 | 1/1 | Supply Line | L | 95 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELEC_MODEL` | 1/1 | 1/1 | Elec Material | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELEC_PLANT_SITE_ID` | 1/1 | 1/1 | Supply Site* | L | 150 | FPComboBox | FPComboBox | ToSiteByDivision | X | 미확인(모달키 이력 없음) | medium | - |
| `ELEC_POST` | 1/1 | 1/1 | Elec Post | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELTR_LN_TP_CD` | 17/5 | 24/5 | Line Type | L | 100 | (공란) | FPComboBox | OperationElectrodeType | X | 미확인(모달키 이력 없음) | medium | - |
| `ELTR_QTY` | 1/1 | 1/1 | Base | R | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ELTR_TP_NM_EN` | 3/2 | 3/2 | Equipment Type* | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EMAIL` | 7/3 | 9/4 | Mail Address | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ENDING_STOCK_CONVERSION_QTY` | 2/2 | 2/2 | Q'ty(Cell) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ENDING_STOCK_QTY` | 2/2 | 2/2 | Q'ty(All) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `END_CUSTOMER` | 85/56 | 93/55 | End Customer | L | 80 | (공란) | FPComboBox | EndCustomerByDivisionDept | O | 미확인(모달키 이력 없음) | high | - |
| `END_CUSTOMER40` | 18/16 | 20/17 | End Customer* | L | 80 | FPComboBox | FPComboBox | EndCustomerByDivision40 | O | 미확인(모달키 이력 없음) | high | - |
| `END_CUSTOMER_NAME` | 1/1 | 4/2 | Customer | L | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `END_CUST_REPORT` | 4/3 | 6/4 | 고객군 | L | 100 | FPComboBox | FPComboBox | END_CUST_REPORT | O | 미확인(모달키 이력 없음) | high | - |
| `END_DATE` | 7/5 | 8/6 | End Date | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `END_MONTH` | 1/1 | 1/1 | EOH Month | L | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `END_TIME` | 5/4 | 5/4 | End Date | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `END_YM` | 2/2 | 2/2 | End | C | 80 | FPDateMonth | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ENERGE` | 5/5 | 6/6 | Energy(KWH) | R | 40 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ENERGE_KWH` | 1/1 | 1/1 | Energy(KWH) | R | 50 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ENERGE_WH` | 5/5 | 6/5 | Energy(WH) | R | 40 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ENERGY` | 2/2 | 2/2 | Energy | R | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ENGINE_STATUS` | 2/2 | 2/2 | Engine Status | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ENG_DEMAND_ID` | 2/2 | 2/2 | ENG_DEMAND_ID | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ENG_PROBLEM_DESC` | 7/6 | 7/6 | Problem Desc | L | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ENG_PROBLEM_TYPE` | 7/6 | 7/6 | Problem Type | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EOH_QTY` | 1/1 | 1/1 | Daily EOH | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EOL_MODEL_FLAG` | 1/1 | 1/1 | EOL Model | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EPST` | 2/2 | 2/2 | EPST | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EQP_ID` | 0/0 | 1/1 | Equipment | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EQP_NAME` | 0/0 | 1/1 | Equipment | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EQUIPMENT` | 1/1 | 1/1 | Equipment | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EQUIPMENT_COUNT` | 3/2 | 3/2 | Equipment Count | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EQUIPMENT_ID` | 34/20 | 34/20 | Equipment | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EQUIPMENT_NAME` | 7/5 | 7/5 | Equipment Name | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP` | 2/1 | 2/1 | ERP | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_ATTR1` | 2/2 | 2/2 | Consignee Name | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_ATTR2` | 2/2 | 2/2 | Contact Point | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_ATTR3` | 2/2 | 2/2 | Lot | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_DIV` | 1/1 | 1/1 | ERP Div | C | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_DO_NO` | 1/1 | 1/1 | DO No | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_EOL` | 4/4 | 4/4 | EOL | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_IF_STATUS` | 1/1 | 1/1 | Status | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_ITEM_ID` | 1/1 | 1/1 | ERP. Item ID | C | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_MESSAGE` | 1/1 | 1/1 | ERP Return | L | 300 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_PO_STATUS` | 1/1 | 1/1 | PO Status | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_RESULT` | 2/2 | 2/2 | Message | L | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_SEND_FLAG` | 1/1 | 0/0 | ERP Send | C | 34 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_SHIPTO` | 1/1 | 1/1 | ERP. Shipto | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_SOLDTO` | 1/1 | 1/1 | ERP. Soldto | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_SO_NO` | 25/16 | 25/16 | SO No | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERP_STATUS` | 13/13 | 13/13 | erp_status | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ERROR_MSG` | 2/2 | 2/2 | I/F Log | L | 300 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ETA` | 22/19 | 22/19 | ETA | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ETA_DATE` | 9/7 | 9/7 | ETA | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ETC_REASON` | 1/1 | 1/1 | Others | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ETC_REASON_CELL` | 1/1 | 1/1 | Others | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ETD` | 19/16 | 19/16 | ETD | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ETD_DATE` | 9/7 | 9/7 | ETD | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EVAL_CLASS_DETAIL` | 1/1 | 1/1 | Valuation name | L | 250 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXCEPTION_DATA` | 1/1 | 1/1 | 예외처리 | C | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXCEPTION_DATE` | 2/2 | 2/2 | Excepted Date | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXCEPTION_FLAG` | 2/2 | 2/2 | Exception | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXCEPT_COMMENT` | 3/2 | 3/2 | Comment | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXCEPT_YN` | 3/1 | 3/1 | EXCEPT_YN | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXCLUSION` | 1/1 | 1/1 | EXCLUSION | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXFACTORY` | 2/2 | 2/2 | Exfactory Date | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXFACTORY_DATE` | 3/3 | 3/3 | Exfactory Date | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXHT_TP_CD` | 3/2 | 3/2 | 소진방안 유형 | L | 100 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | high | - |
| `EXHT_TP_CTN` | 4/3 | 4/3 | 소진방안 상세 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXHT_TP_DESC` | 1/1 | 1/1 | 소진방안 | C | 100 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `EXPECTED_SHIPPING_DATE` | 11/11 | 11/11 | Expected Shipping Date | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXPECTED_SHIP_DATE` | 3/3 | 3/3 | Expected Shipping Date | C | 150 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXPECT_CNT` | 0/0 | 1/1 | EXPECT_CNT | L | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXPIRATION_DATE` | 2/2 | 2/2 | Expiration Date | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXPIRATION_QTY` | 10/6 | 10/6 | Expiration Qty | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXP_FORMATION_END_DATE` | 2/1 | 2/1 | Exp. Formation End Date | C | 80 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXP_INSP_VALID_DATE` | 2/2 | 2/2 | Exp Insp Vaild Date | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXTH_TP_CTN` | 1/1 | 0/0 | EXTH_TP_CTN | L | 110 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXTRA_LIMIT_TIME` | 1/1 | 1/1 | Excess Limit Time(Min) | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EXTRA_SPEC` | 14/11 | 14/11 | Extra Spec | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `EX_TO_BAMT` | 6/4 | 6/4 | Exchange Rate | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FACTORY` | 1/1 | 1/1 | Planning Group | C | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FACTORY_ID` | 178/103 | 191/103 | Building | C | 80 | FPTextBox | FPComboBox | BuildingByShopGroupId1 | X | 미확인(모달키 이력 없음) | high | - |
| `FACTORY_ID2` | 1/1 | 1/1 | Building | L | 160 | FPComboBox | FPComboBox | BuildingByPlant | X | 미확인(모달키 이력 없음) | medium | - |
| `FACTORY_LT` | 1/1 | 1/1 | Release Building | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FACTORY_NAME` | 43/22 | 56/22 | Building Name | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FCST_TYPE` | 67/49 | 65/46 | FCST Type | L | 80 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | high | - |
| `FCST_TYPE2` | 1/1 | 0/0 | FCST_TYPE | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FCST_TYPE_CODE` | 1/1 | 1/1 | FCST_TYPE_CODE | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FCST_TYPE_NAME` | 3/3 | 3/3 | FCST Type | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FCST_VERSION` | 1/1 | 1/1 | FCST Version | C | 125 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FCS_HOLD_YN` | 3/2 | 3/2 | FCS Hold YN | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FCS_INPUT_DATE` | 1/1 | 1/1 | Aging Input Date | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FCS_MODEL_ID` | 1/1 | 1/1 | FCS Model | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FCS_SPECIAL_QTY` | 3/2 | 3/2 | Special Lot Qty | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FERT` | 1/1 | 1/1 | FERT | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FG_EX_COMPANY` | 2/1 | 2/1 | 고객향 삼국간 여부 | R | 140 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FG_EX_COST` | 2/1 | 2/1 | 삼국간 중간국가 물류비 | R | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FIGURE` | 5/2 | 5/2 | Figure | R | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FILEID` | 1/1 | 1/1 | 파일 고유번호 | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FILEREALNAME` | 1/1 | 1/1 | 파일명 | L | 420 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FILESIZE` | 1/1 | 1/1 | SIZE | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FILE_LIST` | 1/1 | 1/1 | 첨부파일 List | L | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FILE_UPLOAD` | 1/1 | 1/1 | 첨부파일 | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FINISH_DATE` | 1/1 | 1/1 | 완료예정일(최초) 완료예정일(변경) 완료일 | C | 110 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FINISH_STATUS` | 1/1 | 1/1 | 상태 | C | 60 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `FINISH_USER_ID` | 1/1 | 1/1 | 작업자 | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FINITE_TERM` | 1/1 | 1/1 | FINITE_TERM | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FINITE_TERM_UOM` | 1/1 | 1/1 | FINITE_TERM_UOM | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FIRST_TEST_WO` | 2/2 | 2/2 | First Test W/O | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FIX` | 1/1 | 1/1 | Fix | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FIXED_FLAG` | 0/0 | 1/1 | Fixed | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `FIX_KEY` | 3/3 | 3/3 | FIX_KEY | L | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FLAG` | 2/1 | 2/1 | Flag | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FLOW_ID` | 8/8 | 8/8 | MES Route | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FOIL` | 7/6 | 7/6 | Foil | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FOIL_CODE` | 7/6 | 7/6 | Foil Code | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORECAST_INFOR_VERSION` | 7/7 | 7/7 | Model Version | L | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORECAST_INFO_ALL` | 8/8 | 8/8 | Spec & Version | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORECAST_INFO_BIZ_TYPE` | 5/5 | 5/5 | Biz Type | L | 80 | (공란) | FPComboBox | DM_Biz_Type | X | 미확인(모달키 이력 없음) | medium | - |
| `FORECAST_INFO_CELL_MODEL` | 11/11 | 11/11 | Cell Model | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORECAST_INFO_CELL_PACK_COUNT` | 11/11 | 11/11 | Cell Pack Count | L | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORECAST_INFO_PRODUCT_GROUP` | 10/10 | 10/10 | Product Group | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORECAST_INFO_SPEC` | 11/11 | 11/11 | Model Spec | L | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORECAST_MODEL_CODE` | 1/1 | 1/1 | Fcst Model | L | 90 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FOREIGN_CORP` | 1/1 | 1/1 | Foreign Corp. | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORMATION1_YIELD` | 1/1 | 1/1 | DW | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORMATION2_YIELD` | 1/1 | 1/1 | DW | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORMATION_END_DATE` | 2/1 | 2/1 | End Date* | C | 90 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORMATION_FLOW_ID` | 4/4 | 4/4 | Formation Route | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORMATION_START_DATE` | 2/1 | 2/1 | Start Date* | C | 90 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORMATION_TOTAL_YIELD` | 4/3 | 4/3 | Aging Yield | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORMATION_YIELD` | 2/1 | 2/1 | Formation Yield(%) | R | 140 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FORM_ATTRIBUTE` | 3/3 | 3/3 | Form Attribute | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FP_APPLY_ITEM_ID` | 1/1 | 1/1 | Material(FP) | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FP_APPLY_OPERATION_ID` | 1/1 | 1/1 | Operation (FP) | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FP_APPLY_WIPQTY` | 1/1 | 1/1 | Qty(UOM Planning) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FP_DEMAND_ID` | 1/1 | 1/1 | Demand ID | L | 500 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FP_EXTRA_SPEC` | 3/3 | 3/3 | Extra Spec. | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FP_IF_RETURN` | 1/1 | 1/1 | Message | L | 300 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FP_PJT_CODE` | 1/1 | 1/1 | FP JPT Code | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FP_PLAN_ID` | 9/4 | 9/4 | FP Plan ID | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FP_PLAN_PERIOD` | 1/1 | 1/1 | FP Plan Period(day)* | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FP_PRODUCTION_TYPE` | 3/3 | 3/3 | Prod.Type | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FP_TARGET_YN` | 3/3 | 3/3 | FP Interface | C | 100 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `FREIGHT_FORWARDER` | 1/1 | 0/0 | Freight Forwarder | L | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FRI` | 1/1 | 1/1 | Fri | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `FROM_ACTUAL_CAPACITY` | 2/1 | 2/1 | From Actual Capacity | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_BOH_QTY` | 5/5 | 5/5 | BOH (From Site) | R | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_CATEGORY` | 1/1 | 1/1 | From | L | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_CITY` | 9/7 | 10/7 | From City | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_CITY_NAME` | 1/1 | 1/1 | City Name | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_COUNTRY` | 2/2 | 2/2 | Country* | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_DATE` | 4/2 | 4/2 | From Date* | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_FACTORY_ID` | 2/2 | 2/2 | From Building* | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_ITEM_SETUP_GROUP_ID` | 1/1 | 1/1 | From Setup Group | 미확인(정렬코드 이력 없음) | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_ITEM_SETUP_GROUP_NAME` | 1/1 | 1/1 | From Setup Group Nick Name | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_OPERATION_ID` | 2/2 | 2/2 | From Operation* | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_OPERATION_NAME` | 1/1 | 1/1 | From Operation Name | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_PERIOD1` | 1/1 | 1/1 | Ni | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_PERIOD2` | 1/1 | 1/1 | Co | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_PERIOD3` | 1/1 | 1/1 | Li2CO3 | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_PERIOD4` | 1/1 | 1/1 | LIOH | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_PERIOD5` | 1/1 | 1/1 | Al | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_PERIOD6` | 1/1 | 1/1 | Mn | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_PERIOD7` | 1/1 | 1/1 | Cu | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_PLANT_ID` | 2/2 | 2/2 | Ship From Plant | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_SCM_SITE_ID` | 3/2 | 3/2 | Plant Site | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_SITE` | 119/53 | 119/54 | From Site | L | 80 | (공란) | FPComboBox | PlantSiteByDivision | X | 미확인(모달키 이력 없음) | high | - |
| `FROM_SITE_CODE` | 3/3 | 4/3 | From Site | L | 100 | FPComboBox | FPComboBox | FromSiteByDivision | O | 미확인(모달키 이력 없음) | high | - |
| `FROM_SITE_DESCRIPTION` | 38/29 | 38/29 | From Site | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_SITE_ID` | 4/3 | 4/2 | From Site Id* | L | 100 | (공란) | FPComboBox | FromSiteByDivision | O | 미확인(모달키 이력 없음) | medium | - |
| `FROM_SITE_NAME` | 8/8 | 8/8 | From Site | L | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_SITE_NM` | 15/4 | 15/4 | From Site | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_STE_ID` | 1/1 | 1/1 | From Site* | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_UI` | 1/1 | 2/1 | FROM UI | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_VALID_YYYYMMDD` | 0/0 | 1/1 | VALID FROM* | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROM_YYYYMMDD` | 25/25 | 25/25 | FROM_YYYYMMDD | C | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROZEN_PERIOD` | 1/1 | 0/0 | Frozen Period | L | 120 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `FROZEN_TYPE` | 1/1 | 1/1 | Ship Frozen(day/week)* | C | 150 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `FROZEN_YYYYMMDD` | 2/2 | 2/2 | FROZEN_YYYYMMDD | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `F_DEST_ATA` | 4/2 | 4/2 | F.DEST ATA | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `F_DEST_ATA_DATE` | 1/1 | 1/1 | F.Dest Date | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `F_DEST_CODE` | 2/2 | 2/2 | F.Dest code | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `F_DEST_ETA` | 1/1 | 1/1 | F.DEST ETA | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `F_DEST_ETA_DATE` | 3/3 | 3/3 | F.Dest Date (ETA) | C | 120 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `F_DEST_ETA_DATE2` | 2/2 | 2/2 | Incoterms       F.Dest Date(ETA) | C | 120 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP` | 11/9 | 11/9 | GAP (ⓒ-ⓓ) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP1` | 1/1 | 1/1 | GAP1 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP1_NDR` | 1/1 | 1/1 | GAP1(NDR) | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP2` | 1/1 | 1/1 | GAP2 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP2_NDR` | 1/1 | 1/1 | GAP2(NDR) | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP3` | 1/1 | 1/1 | GAP3 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP3_NDR` | 1/1 | 1/1 | GAP3(NDR) | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP4` | 1/1 | 1/1 | GAP4 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP4_NDR` | 1/1 | 1/1 | GAP4(NDR) | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP5` | 1/1 | 1/1 | GAP5 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP5_NDR` | 1/1 | 1/1 | GAP5(NDR) | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP_ACC` | 1/1 | 1/1 | GAP(Accum.) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP_ACC_CELL` | 1/1 | 1/1 | GAP(Accum.) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP_CELL` | 1/1 | 1/1 | GAP | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP_INCOTERMS` | 1/1 | 1/1 | GAP(Incoterms) | R | 75 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP_NDR` | 1/1 | 1/1 | GAP(NDR) | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP_NDR_INCOTERMS` | 1/1 | 1/1 | GAP(NDR Incoterms) | R | 75 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP_PER` | 1/1 | 1/1 | % | R | 55 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP_REASON_SALE` | 1/1 | 1/1 | Gap Reason Sale | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GAP_REASON_SUPPLY` | 1/1 | 1/1 | Gap Reason Supply | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GLOBAL_MODEL_SUM` | 1/1 | 1/1 | SUM(Global) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GLOBAL_RATIO` | 1/1 | 1/1 | RATIO(Global) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GLOBAL_SITE_RATIO` | 1/1 | 1/1 | Global Site Ratio | C | 50 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GMES_BOFORE_NT_QTY_SUM` | 2/2 | 2/2 | Assy | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GMES_QTY_PCM` | 2/2 | 2/2 | Pancake M | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GMES_QTY_UOM` | 2/2 | 2/2 | UOM | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GMES_REWORK_QTY_SUM` | 2/2 | 2/2 | RW | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GMES_STOCK_QTY_SUM` | 2/2 | 2/2 | Elec | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GODS` | 1/1 | 1/1 | GODS | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GOOD_01_QTY` | 1/1 | 1/1 | oWMS/Form | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GOOD_02_QTY` | 1/1 | 1/1 | Pack | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GOOD_BOFORE_NT_QTY_SUM` | 2/2 | 2/2 | Assy | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GOOD_QTY` | 2/2 | 2/2 | Good | R | 80 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GOOD_REWORK_QTY_SUM` | 2/2 | 2/2 | RW | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GOOD_STOCK_QTY_SUM` | 2/2 | 2/2 | Elec | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GPLM_BATCH_LOT_SIZE` | 1/1 | 1/1 | Lot Size(GPLM) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GPLM_CELL_CONVERSION_FACTOR` | 3/3 | 3/3 | GPLM Cell Conversion factor | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GPLM_CELL_MODEL` | 5/4 | 5/4 | GPLM Cell Model | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GPLM_JUMBO_ROLL_LENGTH` | 1/1 | 1/1 | Jumbo Roll (m/Roll)_GPLM | C | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GPLM_PC_ROLL_LENGTH` | 1/1 | 1/1 | Pancake (m/Roll)_GPLM | C | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GRADE` | 9/5 | 9/5 | Grade | C | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GRADE_YIELD` | 1/1 | 1/1 | DW | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GREEN` | 1/1 | 1/1 | -1% ~ 1% | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP` | 1/1 | 1/1 | Group | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_CELL_ID` | 2/1 | 2/1 | Group Cell* | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_CELL_NAME` | 2/1 | 2/1 | Group Name | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_CODE` | 4/1 | 5/2 | Group Code | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_CODE1` | 9/2 | 9/2 | Cell Nickname | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_CODE2` | 10/2 | 10/2 | Pack Group | L | 90 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_CODE3` | 9/2 | 9/2 | Demand management | L | 90 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_CODE4` | 9/2 | 9/2 | Supply management | L | 90 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_CODE5` | 9/2 | 9/2 | Product level3 | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_CODE6` | 7/1 | 7/1 | Product level1 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_CODE7` | 7/1 | 7/1 | Product level2 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_CODE8` | 1/1 | 1/1 | Application | L | 100 | FPComboBox | FPComboBox | ESS_CATEGORY | X | 미확인(모달키 이력 없음) | medium | - |
| `GROUP_CODE9` | 1/1 | 1/1 | Product level4 | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_ID` | 9/8 | 10/9 | Group Id | L | 0 | FPText | FPComboBox | GroupMaster | X | 미확인(모달키 이력 없음) | medium | - |
| `GROUP_ITEM_ID` | 1/1 | 1/1 | Cell Group Code | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_NAME` | 3/2 | 4/3 | Job Group Name | L | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_TRAY_ID` | 3/3 | 3/3 | Group Tray ID | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GROUP_TYPE` | 1/1 | 1/1 | Group | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GRP_NAME` | 0/0 | 1/1 | Authority | L | 180 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GSCM_CODE` | 1/1 | 1/1 | (GSCM) Sold to / Ship to | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GSCM_MASTER_DATA` | 1/1 | 1/1 | GSCM Master Data 정비필요 | C | 200 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GSCM_SALES_SITE_ID` | 1/1 | 1/1 | GSCM. Sales Site | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GSCM_SSPM` | 1/1 | 1/1 | GSCM. SSPM | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GSCM_SSPM_INCOTERMS` | 1/1 | 1/1 | GSCM. SSPM INCOTERMS | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GSCM_STATUS` | 1/1 | 1/1 | Status | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GUBUN` | 1/1 | 1/1 | GUBUN | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `GUBUN_NUM` | 1/1 | 1/1 | GUBUN_NUM | C | 30 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HALF_SLIT_FLAG` | 1/1 | 1/1 | Half Slit Flag | C | 70 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `HASPIC` | 1/1 | 1/1 | Alarm | L | 0 | FPCheckBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HISTORY_SEQ` | 0/0 | 1/1 | History Seq | R | 100 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HOLD` | 2/2 | 2/2 | Hold | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HOLDING_DATE` | 7/6 | 7/6 | Holding Date | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HOLD_CELL_LONG_QTY` | 2/2 | 2/2 | Hold Long-Term | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HOLD_CELL_QTY` | 1/1 | 1/1 | Hold Normal | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HOLD_ID` | 8/4 | 8/4 | HOLD_ID | C | 30 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HOLD_QTY` | 24/12 | 24/12 | Hold Qty | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HOLD_YN` | 4/3 | 4/3 | Hold Y/N | C | 150 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HOLD_YYYYMMDD` | 8/4 | 8/4 | Start Date | C | 110 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HORIZONTAL_ALIGN_CODE` | 0/0 | 1/1 | Horizontal Align | C | 80 | FPComboBox | FPComboBox | HorizontalAlignCode | O | 미확인(모달키 이력 없음) | low | - |
| `HP` | 1/1 | 1/1 | HP | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HQ_VENDOR_CODE` | 1/1 | 1/1 | HQ Vendor Code | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HQ_VENDOR_CODE_NAME` | 1/1 | 1/1 | HQ Vendor | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `HUB_SLOC` | 1/1 | 0/0 | Hub Sloc | L | 120 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IDX` | 6/2 | 8/2 | IDX | R | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IMPACT` | 1/1 | 1/1 | Impact | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IMPUTATION_YN` | 1/1 | 1/1 | 귀책여부 | C | 80 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `IMPU_DEPT_NM` | 1/1 | 1/1 | R&R.Dept | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INBOUND_DAY` | 1/1 | 1/1 | In Bound | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INCH_NUMBER` | 1/1 | 1/1 | Inch | R | 35 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INCOTERMS` | 112/77 | 110/73 | Incoterms | C | 65 | (공란) | FPComboBox | Incoterms | O | 미확인(모달키 이력 없음) | high | - |
| `INCOTERMS82` | 1/1 | 1/1 | Incoterms | L | 80 | FPComboBox | FPComboBox | Incoterms | O | 미확인(모달키 이력 없음) | medium | - |
| `INCOTERMS_COST` | 2/1 | 2/1 | 환산자(물류비) | R | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INCOTERMS_LINE` | 11/1 | 13/1 | INCOTERMS/LINE | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INCOTERMS_SSP` | 2/2 | 2/2 | Incoterms SSP* | C | 70 | FPComboBox | FPComboBox | LOOKUPCOMMON | X | 미확인(모달키 이력 없음) | medium | - |
| `INCREMENT` | 1/1 | 1/1 | Increment* | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INLAND_ATD` | 4/2 | 4/2 | Inland ATD | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_DATE` | 3/3 | 3/3 | Input Date | C | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_QTY` | 1/1 | 1/1 | Input QTY | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_RATE_1` | 1/1 | 1/1 | Material 1 InputRate | R | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_RATE_10` | 1/1 | 1/1 | Material 10 InputRate | R | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_RATE_2` | 1/1 | 1/1 | Material 2 InputRate | R | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_RATE_3` | 1/1 | 1/1 | Material 3 InputRate | R | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_RATE_4` | 1/1 | 1/1 | Material 4 InputRate | R | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_RATE_5` | 1/1 | 1/1 | Material 5 InputRate | R | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_RATE_6` | 1/1 | 1/1 | Material 6 InputRate | R | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_RATE_7` | 1/1 | 1/1 | Material 7 InputRate | R | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_RATE_8` | 1/1 | 1/1 | Material 8 InputRate | R | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_RATE_9` | 1/1 | 1/1 | Material 9 InputRate | R | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_STATUS` | 4/1 | 4/1 | INPUT_STATUS | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INPUT_TP_CD` | 0/0 | 2/1 | Input Type | C | 80 | FPComboBox | FPComboBox | InputTypeCode | O | 미확인(모달키 이력 없음) | medium | - |
| `INSERT_ID` | 11/11 | 11/11 | Creator | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INSERT_TIME` | 12/11 | 13/11 | Insert Time | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INSPECTION_ID` | 1/1 | 1/1 | 관리번호 | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INSTANCE_DATE` | 2/2 | 2/2 | Instance Date* | C | 0 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INSTANCE_ID` | 35/21 | 35/21 | Instance | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INSTANCE_NAME` | 6/4 | 7/5 | Instance* | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INST_SEQ` | 1/1 | 1/1 | seq | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INTERNAL_YN` | 6/6 | 6/6 | Internal Txn | L | 80 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `INTRANSIT` | 2/2 | 2/2 | Intransit | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INTRANSIT_CNT` | 1/1 | 1/1 | Intransit | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INTRANSIT_QTY` | 1/1 | 1/1 | In-transit | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INTRANSIT_TOTAL_AUTO` | 1/1 | 1/1 | Intransit Total | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INTRANSIT_TYPE` | 2/2 | 2/2 | Type | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INVENTORY` | 2/2 | 2/2 | Delivery issue | R | 90 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INVENTORY_03` | 1/1 | 1/1 | Delivery issue | R | 90 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INVENTORY_06` | 1/1 | 1/1 | Delivery issue | R | 90 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INVENTORY_12` | 1/1 | 1/1 | Delivery issue | R | 90 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INVENTORY_CNT` | 1/1 | 1/1 | Inventory | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INVENTORY_DAY` | 1/1 | 1/1 | INVENTORY DAY | C | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INVENTORY_STATUS` | 2/1 | 2/1 | Inventory Status | L | 80 | FPComboBox | FPComboBox | OWMS_STOCK_STATUS | X | 미확인(모달키 이력 없음) | medium | - |
| `INVENTORY_TYPE` | 3/2 | 3/2 | Inventory Type | C | 100 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `INVENTORY_TYPE_DESC` | 1/1 | 1/1 | Inv.Type Description | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INV_ALLO_QTY` | 2/1 | 2/1 | Netting Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INV_DATE` | 2/1 | 2/1 | Date* | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INV_FLAG` | 1/1 | 1/1 | Inv Flag | C | 80 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `INV_QTY` | 1/1 | 1/1 | Monthly | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INV_STATUS_AVAILABLE` | 1/1 | 1/1 | Available | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INV_STATUS_BLOCKED` | 1/1 | 1/1 | Blocked | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INV_STATUS_HOLDING` | 1/1 | 1/1 | Holding | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `INV_STATUS_QT` | 1/1 | 1/1 | QT | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IN_BUFFER_DAY` | 1/1 | 1/1 | In Buffer | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IN_DDAY` | 1/1 | 1/1 | 입력기한 | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IN_DE_DEMAND` | 1/1 | 1/1 | 증감반영수요 | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IN_DE_VOL` | 1/1 | 1/1 | 증감물량 | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IN_ITEM_ID` | 1/1 | 1/1 | In Material | L | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IN_NICK_NAME` | 1/1 | 1/1 | In Nick Name | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IN_PLAN_QTY` | 1/1 | 1/1 | In QTY | R | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IN_QTY` | 2/2 | 2/2 | IN_QTY | R | 80 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IN_TRANSIT` | 2/2 | 2/2 | In-transit | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IPRV_GOL_DIVS_CD` | 4/1 | 5/1 | Improvement/Goal | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IPRV_GOL_DIVS_NM` | 4/1 | 5/1 | Improvement/Goal | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IP_ADDRESS` | 1/1 | 1/1 | Ip | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IP_ADRESS` | 1/1 | 1/1 | IP | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ISCHK` | 2/1 | 2/1 | Is Check | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ISENABLE` | 2/1 | 2/1 | Is Enable | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ISO_WEEK` | 2/1 | 2/1 | WEEK | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_ENABLE_REL` | 2/1 | 2/1 | Is Enable Rel | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_PASS_N1` | 3/3 | 3/3 | N1 | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_PASS_N2` | 3/3 | 3/3 | N2 | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_PASS_N3` | 3/3 | 3/3 | N3 | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_PASS_N4` | 3/3 | 3/3 | N4 | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_PASS_N5` | 3/3 | 3/3 | N5 | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_PASS_N6` | 3/3 | 3/3 | N6 | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_PASS_N7` | 3/3 | 3/3 | N7 | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_PREV_SCHEDULE` | 4/2 | 4/2 | Prev Schedule | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_RESULT` | 1/1 | 1/1 | Is Result | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_RESULT_COLOR` | 1/1 | 1/1 | Is Result Color | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_RESULT_NAME` | 1/1 | 1/1 | Simulation Result | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_VALID` | 1/1 | 1/1 | Active | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IS_YN` | 0/0 | 2/1 | RegStatus YN | C | 80 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `ITEM` | 1/1 | 1/1 | ITEM | C | 120 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_ATTRIBUTE` | 4/4 | 4/4 | Material Attribute | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_CATEGORY` | 1/1 | 1/1 | Item Category | L | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_CLASS` | 7/7 | 7/7 | Class | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_CLASS_LEVEL_1` | 4/4 | 4/4 | Class 1 | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_CLASS_LEVEL_2` | 4/4 | 4/4 | Class 2 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_CLASS_LEVEL_3` | 4/4 | 4/4 | Class 3 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_CLASS_LEVEL_4` | 4/4 | 4/4 | Class 4 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_CLASS_NAME` | 33/30 | 35/27 | Model Type | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_CNT` | 1/1 | 1/1 | ITEM_CNT | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_DESCRIPTION` | 2/2 | 2/2 | Description | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_GROUP_ID` | 1/1 | 1/1 | ITEM_GROUP_ID | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_ID` | 436/238 | 444/235 | Model | L | 120 | FPTextBox | FPTextModal | ITEM | X | 미확인(모달키 이력 없음) | high | - |
| `ITEM_ID40` | 6/6 | 6/6 | Model* | L | 80 | (공란) | FPTextModal | ITEM | X | 미확인(모달키 이력 없음) | low | - |
| `ITEM_ID_ASSY` | 9/1 | 9/1 | Assy Code | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_ID_CHILD` | 2/1 | 3/2 | Item* | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_ID_NICK_NAME` | 1/1 | 1/1 | Nick Name | L | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_LINE_ASSIGN_CHECK` | 2/1 | 2/1 | Line Assing | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_NAME` | 50/44 | 48/38 | Model Name | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_SEQ` | 3/2 | 3/2 | Item Seq | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_SETUP_GROUP_ID` | 2/2 | 2/2 | Material Setup Group | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_TYPE` | 74/61 | 75/57 | Item Type | L | 80 | FPTextBox | FPComboBox | ItemType | O | 미확인(모달키 이력 없음) | high | - |
| `ITEM_TYPE_DETAIL` | 2/2 | 2/2 | ITEM Type Detail | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_TYPE_NAME` | 3/3 | 5/4 | Type | L | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_UOM` | 15/13 | 15/13 | UOM | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITEM_USE` | 5/5 | 5/5 | 용도 | L | 80 | (공란) | FPComboBox | DM_LOOKUP_DIV | O | 미확인(모달키 이력 없음) | medium | - |
| `ITVL1` | 1/1 | 1/1 | Interval 1(Day)* | C | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITVL2` | 1/1 | 1/1 | Interval 2(Day) | C | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITVL3` | 1/1 | 1/1 | Interval 3(Day) | C | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ITVL4` | 1/1 | 1/1 | Interval 4(Day) | C | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IWMS_HOLD_YN` | 2/2 | 2/2 | iWMS Hold YN | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IWMS_QTY_PCM` | 2/2 | 2/2 | Pancake M | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `IWMS_QTY_UOM` | 2/2 | 2/2 | UOM | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JIG_ITEM_SEQ` | 1/1 | 1/1 | JIG_ITEM_SEQ | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JIG_NAME` | 2/2 | 2/2 | JIG Name* | L | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JIG_SEQ` | 2/2 | 2/2 | JIG_SEQ | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JOB_CODE` | 0/0 | 4/1 | Job | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JOB_DESC` | 2/1 | 2/1 | Sub Job Name | L | 105 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JOB_ID` | 2/1 | 2/1 | Procedure Name | L | 160 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JOB_NAME` | 0/0 | 4/1 | Job | L | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JOB_ORDER` | 1/1 | 1/1 | Job Order | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JOB_TIME` | 1/1 | 1/1 | Job Time | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JOB_TYPE` | 4/3 | 4/3 | Job Type | C | 50 | FPTextBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `JOB_USER_ID` | 1/1 | 1/1 | Job User | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JR_AFTER_BOH_QTY` | 1/1 | 1/1 | J/R (After R/P) | R | 60 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JR_AFTER_HOLD_QTY` | 1/1 | 1/1 | J/R (After R/P) | R | 60 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JR_BOH` | 2/2 | 2/2 | J/R | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JR_BOH_HOLD` | 1/1 | 1/1 | J/R | R | 110 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JR_BOH_ONLYHOLD` | 1/1 | 1/1 | J/R | R | 80 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JR_BOH_QTY` | 4/4 | 4/4 | J/R | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JR_BOH_QTY_CELL` | 2/2 | 2/2 | J/R | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JR_BOH_QTY_PCM` | 2/2 | 2/2 | J/R | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JR_HOLD_QTY` | 2/2 | 2/2 | J/R (Before R/P) | R | 70 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JUDG_VLD_DATE` | 3/2 | 3/2 | Judge Vaild Date | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JUMBO_BATCH` | 1/1 | 1/1 | Jumbo Roll(m/batch)(Before R/Press) | R | 220 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JUMBO_MIN` | 2/1 | 2/1 | Jumbo / Min | R | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JUMBO_ROLL_LENGTH` | 1/1 | 1/1 | Jumbo Roll (m/Roll)_Simul | C | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `JV_PLANT_ID` | 0/0 | 1/1 | JV Plant | 미확인(정렬코드 이력 없음) | 180 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KEYVALUE` | 3/2 | 3/2 | KEYVALUE | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KEYVALUE2` | 1/1 | 1/1 | KEYVALUE2 | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KEYVAUE` | 2/1 | 2/1 | KEYVALUE | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KEY_ID` | 7/6 | 7/6 | Level 2 | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KEY_IDX` | 17/17 | 17/17 | KEY_IDX | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KEY_PRIORITY` | 1/1 | 1/1 | KEY_PRIORITY | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KEY_VALUE` | 3/2 | 3/2 | Key Value | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KPI_ID` | 1/1 | 1/1 | KPI_ID | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KPI_NM` | 1/1 | 1/1 | KPI | L | 140 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KUBUN` | 3/3 | 3/3 | 구분 ▼ | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KWH` | 5/4 | 7/4 | KWh/Cell* | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KWH_CELL` | 5/5 | 5/5 | KWh/Cell | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KWH_MODULE` | 5/5 | 5/5 | KWh/Module | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `KWH_PACK` | 5/5 | 5/5 | KWh/Pack | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LANE` | 7/7 | 7/7 | Lane | C | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LANE_NUMBER` | 1/1 | 1/1 | Lane Number | R | 120 | FPComboBox | FPComboBox | LANE | X | 미확인(모달키 이력 없음) | medium | - |
| `LANE_QTY` | 13/11 | 13/11 | Lane | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LANGUAGE` | 0/0 | 2/1 | Language | C | 90 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LANGUAGE_CODE` | 0/0 | 1/1 | Language * | C | 110 | FPComboBox | FPComboBox | MailLanguage | O | 미확인(모달키 이력 없음) | low | - |
| `LANG_CD` | 0/0 | 2/2 | Language | C | 200 | FPComboBox | FPComboBox | Language | O | 미확인(모달키 이력 없음) | medium | - |
| `LARGE_CLASS_LABEL_NAME` | 0/0 | 2/1 | Large Label | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LAST_INPUT_DATE` | 2/2 | 2/2 | Last Input Date | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LAST_MODIFY_DATE` | 1/1 | 1/1 | Last Update | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LAST_MODIFY_ID` | 1/1 | 1/1 | Update ID | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LAST_SEQ` | 1/1 | 1/1 | Last Seq | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LAST_UPDATED_BY` | 123/68 | 139/76 | Last Updated By | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LAST_UPDATED_BY11` | 0/0 | 1/1 | Last Updated By | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LAST_UPDATED_DATE` | 5/3 | 5/3 | Request Date | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LAST_UPDATE_DATE` | 111/62 | 127/70 | Last Update Date | C | 150 | FPDateTime | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LATEST_DW_SUBMIT_FLAG` | 1/1 | 1/1 | Latest DW Submit Flag | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LATEST_RELEASE_FLAG` | 1/1 | 1/1 | Last Release version(W/O) | C | 110 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LATEST_RUN_DATE` | 1/1 | 1/1 | Last Run Date | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LATE_CNT` | 1/1 | 1/1 | Count | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LATE_QTY` | 1/1 | 1/1 | Quantity | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LATE_RATIO` | 1/1 | 1/1 | Ratio(%) | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEAD_TIME` | 2/2 | 2/2 | Lead Time | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL` | 4/3 | 3/2 | Level | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL1_GROUP` | 6/1 | 6/1 | Level1 Group | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL2_CODE` | 7/1 | 7/1 | Replacement  code | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_1_CODE` | 2/2 | 2/2 | LEVEL_1_CODE | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_1_ID` | 2/2 | 2/2 | LEVEL_1_ID | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_1_NAME` | 6/5 | 6/5 | MDM class_Lv1 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_2_CODE` | 2/2 | 2/2 | LEVEL_2_CODE | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_2_ID` | 2/2 | 2/2 | LEVEL_2_ID | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_2_NAME` | 6/5 | 6/5 | MDM class_Lv2 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_3_CODE` | 2/2 | 2/2 | LEVEL_3_CODE | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_3_ID` | 2/2 | 2/2 | LEVEL_3_ID | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_3_NAME` | 8/7 | 8/7 | MDM class_Lv3 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_4_CODE` | 2/2 | 2/2 | LEVEL_4_CODE | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_4_ID` | 2/2 | 2/2 | LEVEL_4_ID | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_4_NAME` | 6/5 | 6/5 | MDM class_Lv4 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_NAME_1` | 1/1 | 1/1 | Material 1 LevelName | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_NAME_10` | 1/1 | 1/1 | Material 10 LevelName | L | 160 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_NAME_2` | 1/1 | 1/1 | Material 2 LevelName | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_NAME_3` | 1/1 | 1/1 | Material 3 LevelName | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_NAME_4` | 1/1 | 1/1 | Material 4 LevelName | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_NAME_5` | 1/1 | 1/1 | Material 5 LevelName | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_NAME_6` | 1/1 | 1/1 | Material 6 LevelName | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_NAME_7` | 1/1 | 1/1 | Material 7 LevelName | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_NAME_8` | 1/1 | 1/1 | Material 8 LevelName | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_NAME_9` | 1/1 | 1/1 | Material 9 LevelName | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_NO` | 0/0 | 1/1 | Level | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_ONE_MNU_ID` | 0/0 | 3/2 | Level 1 | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LEVEL_TWO_MNU_ID` | 0/0 | 2/2 | Level 2 | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LI2CO3_KG_PER_BIZ_TYPE` | 1/1 | 1/1 | Li2Co3 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LI2CO3_MIX_METAL_LINK_PERIOD` | 1/1 | 1/1 | Li2Co3 | C | 80 | FPComboBox | FPComboBox | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | X | 미확인(모달키 이력 없음) | medium | - |
| `LI2CO3_USD_PER_KG` | 1/1 | 1/1 | Li2Co3 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LIABILITY_PERIOD` | 7/5 | 5/4 | Liablity(Week) | L | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINE` | 5/4 | 5/4 | Line Name | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINE_ATTRIBUTE1` | 3/2 | 3/2 | Line Attribute* | C | 100 | FPComboBox | FPComboBox | LINE_ATTRIBUTE | X | 미확인(모달키 이력 없음) | high | - |
| `LINE_ATTR_1` | 2/1 | 2/1 | Line Attribute* | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINE_GROUP_ID` | 2/2 | 2/2 | Line Group | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINE_ID` | 189/107 | 201/107 | Line | L | 80 | FPTextBox | FPComboBox | LineByOperation | X | 미확인(모달키 이력 없음) | high | - |
| `LINE_IDX` | 5/1 | 7/1 | LINE_IDX | R | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINE_LOCATION` | 3/2 | 3/2 | Location | C | 100 | FPComboBox | FPComboBox | LINE_LOCATION | X | 미확인(모달키 이력 없음) | high | - |
| `LINE_MODEL_TYPE` | 3/2 | 3/2 | Model Type* | C | 100 | FPComboBox | FPComboBox | LINE_MODEL_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `LINE_NAME` | 140/84 | 151/84 | Line Name | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINE_RATIO` | 2/1 | 2/1 | RATIO | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINE_RATIO_LT` | 1/1 | 1/1 | LT*RATIO | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINE_SEQ` | 1/1 | 1/1 | Line Seq | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINE_SETUP_GROUP_ID` | 10/5 | 10/5 | Line Setup Group | L | 200 | FPTextBox | FPComboBox | LINE_SETUP_GROUP_ID | X | 미확인(모달키 이력 없음) | medium | - |
| `LINE_TYPE` | 9/3 | 9/3 | Line Type | C | 80 | (공란) | FPComboBox | LINE_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `LINE_TYPE_NAME` | 1/1 | 1/1 | Line Type Name | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINK` | 1/1 | 1/1 | Link | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINK_ADDRESS` | 1/1 | 1/1 | LINK_ADDRESS | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINK_LINE_ID` | 1/1 | 1/1 | Link Line | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINK_PLANT_SITE` | 1/1 | 1/1 | Link Plant Site | L | 130 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINK_PLANT_SITE_CODE` | 1/1 | 1/1 | Link Plant Site Code | L | 130 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LINK_UI_TYPE` | 1/1 | 1/1 | Link UI Type | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LIOH_KG_PER_BIZ_TYPE` | 1/1 | 1/1 | LiOH | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LIOH_MIX_METAL_LINK_PERIOD` | 1/1 | 1/1 | LiOH | C | 80 | FPComboBox | FPComboBox | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | X | 미확인(모달키 이력 없음) | medium | - |
| `LIOH_USD_PER_KG` | 1/1 | 1/1 | LiOH | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOAD_RATE` | 1/1 | 1/1 | LOAD_RATE | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOAD_YIELD` | 2/2 | 2/2 | Load Rate | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOCATION` | 38/27 | 38/27 | Loc. | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOCATION_CODE` | 6/5 | 6/4 | Location Code | L | 100 | FPTextBox | FPModal | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | low | - |
| `LOCATION_CODE2` | 1/1 | 1/1 | Location* | L | 120 | FPComboBox | FPComboBox | Location | X | 미확인(모달키 이력 없음) | medium | - |
| `LOCATION_DESCRIPTION` | 5/4 | 4/3 | Location | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOCATION_SEQ` | 3/3 | 2/2 | Seq | R | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOGISTIC_PLANT_ID` | 2/1 | 2/1 | Logistic Plant | L | 150 | FPComboBox | FPComboBox | PlantByDivision | X | 미확인(모달키 이력 없음) | medium | - |
| `LOGN_DTM` | 0/0 | 1/1 | Last Login | C | 200 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOG_MESSAGE` | 1/1 | 1/1 | LOG MESSAGE | L | 500 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOG_TYPE` | 2/2 | 2/2 | LOG TYPE | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONGTERM_HOLD_YN` | 2/2 | 2/2 | Long term Hold YN | C | 70 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONG_QTY` | 2/1 | 2/1 | Long-Term Qty | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONG_TERM_BOH_QTY` | 1/1 | 1/1 | Long-Term | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONG_TERM_EXPECT_QTY` | 1/1 | 1/1 | EOH long-term sign Qty | R | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONG_TERM_FLAG` | 2/2 | 2/2 | Long Term Flag | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONG_TERM_FLAG_CPY` | 4/4 | 4/4 | Long Term Flag | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONG_TERM_QTY` | 11/8 | 11/8 | Long-term Qty | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONG_TERM_STOCK_AMOUNT` | 3/3 | 3/3 | Amount(KRW) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONG_TERM_STOCK_AMOUNT_XLS` | 3/3 | 3/3 | Amount(KRW) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONG_TERM_STOCK_QTY` | 2/2 | 2/2 | Quantity | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONG_TERM_STOCK_QTY_XLS` | 2/2 | 2/2 | Quantity | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LONG_TERM_TYPE` | 4/2 | 4/2 | Long term Type | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOOKUP_GROUP` | 0/0 | 1/1 | System | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOOKUP_TYPE` | 0/0 | 2/1 | Lookup Type | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOSS_CODE` | 4/4 | 4/4 | LOSS_CODE | C | 10 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOSS_END_DATE` | 1/1 | 1/1 | End Date* | C | 110 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOSS_QTY2` | 1/1 | 1/1 | Loss QTY | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOSS_START_DATE` | 1/1 | 1/1 | Start Date* | C | 110 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOSS_TIME` | 2/1 | 2/1 | Loss Time (Day:MIN) | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOSS_TIME_BIG` | 1/1 | 1/1 | Loss Time Big Data (Day:MIN) | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT` | 2/1 | 2/1 | Lot | L | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOTID` | 2/2 | 2/2 | Lot ID | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT_COUNT` | 1/1 | 1/1 | Lot Count | C | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT_ID` | 13/9 | 13/9 | Lot ID | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT_ISSUE_DATE` | 5/5 | 5/5 | Lot Issue Date | L | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT_QTY` | 2/2 | 2/2 | Lot Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT_QTY_FCS` | 3/2 | 3/2 | FCS Lot Qty | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT_QTY_MES` | 3/2 | 3/2 | GMES Lot Qty | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT_QTY_MES_NG` | 2/2 | 2/2 | GMES NG Qty | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT_QTY_TOT` | 3/2 | 3/2 | Total Qty(GMES+FCS) | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT_SIZE` | 4/3 | 3/2 | 환산자(LOT SIZE) | R | 130 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT_SIZE_UOM` | 3/2 | 3/2 | UOM | C | 80 | FPComboBox | FPComboBox | LOT_SIZE_UOM | X | 미확인(모달키 이력 없음) | medium | - |
| `LOT_TYPE` | 3/2 | 3/2 | Lot Type | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LOT_YN` | 2/2 | 2/2 | Lot_YN | C | 30 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LPST` | 8/8 | 8/8 | LPST | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT` | 5/5 | 5/5 | L/T | R | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_ARRIVAL_INLAND` | 3/2 | 3/2 | Arrival Inland | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_DAY` | 41/33 | 40/33 | L/T(Day) | R | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_DEPARTURE_INLAND` | 3/2 | 3/2 | Departure Inland | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_FORMATION` | 2/1 | 2/1 | Foramtion L/T (Days) | R | 140 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_INCOTERMS` | 1/1 | 1/1 | L/T (Incoterms) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_INCOTERMS_CONST` | 1/1 | 1/1 | LT INCOTERMS CONST | R | 150 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_LAY_OFF_CLEARANCE` | 3/2 | 3/2 | Lay Off/Customs Clearance | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_OPERATION` | 1/1 | 1/1 | LT Operation | L | 115 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `LT_SUM` | 3/2 | 3/2 | Total L/T | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_TOTAL` | 9/8 | 8/7 | L/T(Day) | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_TYPE` | 4/4 | 4/4 | L/T Type | C | 80 | (공란) | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `LT_UPDATE_YN` | 5/2 | 5/2 | LT_UPDATE_YN | C | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_VOYAGE` | 3/2 | 3/2 | Voyage | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_WAIT_SHIPPING` | 3/2 | 3/2 | Waiting For Shipping | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LT_WEEK` | 1/1 | 1/1 | Lt Week | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LV1` | 2/2 | 2/2 | Lv1 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LV1_NAME` | 3/3 | 3/3 | Cat. | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `LWH_BOH` | 1/1 | 1/1 | Material | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M0` | 1/1 | 1/1 | M0 | C | 40 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M1` | 5/3 | 5/3 | M1 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M10` | 5/3 | 5/3 | M10 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M100` | 1/1 | 1/1 | M100 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M101` | 1/1 | 1/1 | M101 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M102` | 1/1 | 1/1 | M102 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M103` | 1/1 | 1/1 | M103 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M104` | 1/1 | 1/1 | M104 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M105` | 1/1 | 1/1 | M105 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M106` | 1/1 | 1/1 | M106 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M107` | 1/1 | 1/1 | M107 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M108` | 1/1 | 1/1 | M108 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M109` | 1/1 | 1/1 | M109 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M10_AMOUNT` | 1/1 | 1/1 | Amount 10M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M10_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 10M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M10_QTY` | 2/1 | 2/1 | M10_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M10_QUANTITY` | 2/2 | 2/2 | Quantity 10M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M11` | 5/3 | 5/3 | M11 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M110` | 1/1 | 1/1 | M110 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M111` | 1/1 | 1/1 | M111 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M112` | 1/1 | 1/1 | M112 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M113` | 1/1 | 1/1 | M113 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M114` | 1/1 | 1/1 | M114 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M115` | 1/1 | 1/1 | M115 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M116` | 1/1 | 1/1 | M116 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M117` | 1/1 | 1/1 | M117 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M118` | 1/1 | 1/1 | M118 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M119` | 1/1 | 1/1 | M119 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M11_AMOUNT` | 1/1 | 1/1 | Amount 11M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M11_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 11M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M11_QTY` | 2/1 | 2/1 | M11_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M11_QUANTITY` | 2/2 | 2/2 | Quantity 11M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M12` | 5/3 | 5/3 | M12 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M120` | 1/1 | 1/1 | M120 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M121` | 1/1 | 1/1 | M121 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M122` | 1/1 | 1/1 | M122 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M123` | 1/1 | 1/1 | M123 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M124` | 1/1 | 1/1 | M124 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M125` | 1/1 | 1/1 | M125 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M126` | 1/1 | 1/1 | M126 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M127` | 1/1 | 1/1 | M127 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M128` | 1/1 | 1/1 | M128 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M12_AMOUNT` | 1/1 | 1/1 | Amount 12M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M12_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 12M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M12_QTY` | 2/1 | 2/1 | M12_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M12_QUANTITY` | 2/2 | 2/2 | Quantity 12M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M13` | 1/1 | 1/1 | M13 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M130` | 1/1 | 1/1 | M130 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M131` | 1/1 | 1/1 | M131 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M132` | 1/1 | 1/1 | M132 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M133` | 1/1 | 1/1 | M133 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M134` | 1/1 | 1/1 | M134 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M135` | 1/1 | 1/1 | M135 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M136` | 1/1 | 1/1 | M136 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M137` | 1/1 | 1/1 | M137 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M138` | 1/1 | 1/1 | M138 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M139` | 1/1 | 1/1 | M139 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M13_AMOUNT` | 1/1 | 1/1 | Amount 13M ~ | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M13_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 13M ~ | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M13_QTY` | 2/1 | 2/1 | M13_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M13_QUANTITY` | 2/2 | 2/2 | Quantity 13M ~ | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M14` | 1/1 | 1/1 | M14 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M140` | 1/1 | 1/1 | M140 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M141` | 1/1 | 1/1 | M141 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M142` | 1/1 | 1/1 | M142 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M143` | 1/1 | 1/1 | M143 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M144` | 1/1 | 1/1 | M144 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M14_QTY` | 2/1 | 2/1 | M14_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M15` | 1/1 | 1/1 | M15 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M15_QTY` | 2/1 | 2/1 | M15_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M16` | 1/1 | 1/1 | M16 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M16_QTY` | 2/1 | 2/1 | M16_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M17` | 1/1 | 1/1 | M17 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M17_QTY` | 2/1 | 2/1 | M17_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M18` | 1/1 | 1/1 | M18 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M18_QTY` | 2/1 | 2/1 | M18_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M19` | 1/1 | 1/1 | M19 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M19_QTY` | 2/1 | 2/1 | M19_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M1_AMOUNT` | 1/1 | 1/1 | Amount 1M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M1_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 1M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M1_CUST_FCST_QTY` | 1/1 | 1/1 | Cust.FCST | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M1_MKT_FCST_QTY` | 1/1 | 1/1 | MKT.FCST(DP) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M1_QTY` | 2/1 | 2/1 | M1_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M1_QUANTITY` | 2/2 | 2/2 | Quantity 1M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M2` | 5/3 | 5/3 | M2 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M20` | 1/1 | 1/1 | M20 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M20_QTY` | 2/1 | 2/1 | M20_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M21` | 1/1 | 1/1 | M21 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M21_QTY` | 2/1 | 2/1 | M21_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M22` | 1/1 | 1/1 | M22 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M22_QTY` | 2/1 | 2/1 | M22_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M23` | 1/1 | 1/1 | M23 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M23_QTY` | 2/1 | 2/1 | M23_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M24` | 1/1 | 1/1 | M24 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M24_QTY` | 2/1 | 2/1 | M24_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M25` | 1/1 | 1/1 | M25 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M25_QTY` | 2/1 | 2/1 | M25_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M26` | 1/1 | 1/1 | M26 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M26_QTY` | 2/1 | 2/1 | M26_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M27` | 1/1 | 1/1 | M27 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M27_QTY` | 2/1 | 2/1 | M27_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M28` | 1/1 | 1/1 | M28 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M28_QTY` | 2/1 | 2/1 | M28_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M29` | 1/1 | 1/1 | M29 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M29_QTY` | 2/1 | 2/1 | M29_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M2_AMOUNT` | 1/1 | 1/1 | Amount 2M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M2_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 2M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M2_CUST_FCST_QTY` | 1/1 | 1/1 | Cust.FCST | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M2_MKT_FCST_QTY` | 1/1 | 1/1 | MKT.FCST(DP) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M2_QTY` | 2/1 | 2/1 | M2_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M2_QUANTITY` | 2/2 | 2/2 | Quantity 2M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M3` | 5/3 | 5/3 | M3 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M30` | 1/1 | 1/1 | M30 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M30_QTY` | 2/1 | 2/1 | M30_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M31` | 1/1 | 1/1 | M31 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M31_QTY` | 2/1 | 2/1 | M31_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M32` | 1/1 | 1/1 | M32 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M32_QTY` | 2/1 | 2/1 | M32_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M33` | 1/1 | 1/1 | M33 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M33_QTY` | 2/1 | 2/1 | M33_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M34` | 1/1 | 1/1 | M34 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M34_QTY` | 2/1 | 2/1 | M34_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M35` | 1/1 | 1/1 | M35 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M35_QTY` | 2/1 | 2/1 | M35_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M36` | 1/1 | 1/1 | M36 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M36_QTY` | 2/1 | 2/1 | M36_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M37` | 1/1 | 1/1 | M37 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M37_QTY` | 2/1 | 2/1 | M37_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M38` | 1/1 | 1/1 | M38 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M38_QTY` | 2/1 | 2/1 | M38_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M39` | 1/1 | 1/1 | M39 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M39_QTY` | 2/1 | 2/1 | M39_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M3_AMOUNT` | 1/1 | 1/1 | Amount 3M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M3_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 3M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M3_CUST_FCST_QTY` | 1/1 | 1/1 | Cust.FCST | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M3_MKT_FCST_QTY` | 1/1 | 1/1 | MKT.FCST(DP) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M3_QTY` | 2/1 | 2/1 | M3_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M3_QUANTITY` | 2/2 | 2/2 | Quantity 3M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M4` | 5/3 | 5/3 | M4 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M40` | 1/1 | 1/1 | M40 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M40_QTY` | 2/1 | 2/1 | M40_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M41` | 1/1 | 1/1 | M41 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M41_QTY` | 2/1 | 2/1 | M41_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M42` | 1/1 | 1/1 | M42 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M42_QTY` | 2/1 | 2/1 | M42_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M43` | 1/1 | 1/1 | M43 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M43_QTY` | 2/1 | 2/1 | M43_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M44` | 1/1 | 1/1 | M44 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M44_QTY` | 2/1 | 2/1 | M44_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M45` | 1/1 | 1/1 | M45 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M45_QTY` | 2/1 | 2/1 | M45_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M46` | 1/1 | 1/1 | M46 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M46_QTY` | 2/1 | 2/1 | M46_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M47` | 1/1 | 1/1 | M47 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M47_QTY` | 2/1 | 2/1 | M47_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M48` | 1/1 | 1/1 | M48 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M48_QTY` | 2/1 | 2/1 | M48_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M49` | 1/1 | 1/1 | M49 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M49_QTY` | 2/1 | 2/1 | M49_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M4_AMOUNT` | 1/1 | 1/1 | Amount 4M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M4_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 4M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M4_QTY` | 2/1 | 2/1 | M4_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M4_QUANTITY` | 2/2 | 2/2 | Quantity 4M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M5` | 5/3 | 5/3 | M5 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M50` | 1/1 | 1/1 | M50 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M50_QTY` | 2/1 | 2/1 | M50_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M51` | 1/1 | 1/1 | M51 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M51_QTY` | 2/1 | 2/1 | M51_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M52` | 1/1 | 1/1 | M52 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M52_QTY` | 2/1 | 2/1 | M52_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M53` | 1/1 | 1/1 | M53 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M53_QTY` | 2/1 | 2/1 | M53_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M54` | 1/1 | 1/1 | M54 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M54_QTY` | 2/1 | 2/1 | M54_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M55` | 1/1 | 1/1 | M55 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M55_QTY` | 2/1 | 2/1 | M55_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M56` | 1/1 | 1/1 | M56 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M56_QTY` | 2/1 | 2/1 | M56_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M57` | 1/1 | 1/1 | M57 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M57_QTY` | 2/1 | 2/1 | M57_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M58` | 1/1 | 1/1 | M58 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M58_QTY` | 2/1 | 2/1 | M58_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M59` | 1/1 | 1/1 | M59 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M59_QTY` | 2/1 | 2/1 | M59_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M5_AMOUNT` | 1/1 | 1/1 | Amount 5M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M5_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 5M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M5_QTY` | 2/1 | 2/1 | M5_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M5_QUANTITY` | 2/2 | 2/2 | Quantity 5M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M6` | 5/3 | 5/3 | M6 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M60` | 1/1 | 1/1 | M60 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M60_QTY` | 2/1 | 2/1 | M60_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M61` | 1/1 | 1/1 | M61 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M62` | 1/1 | 1/1 | M62 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M63` | 1/1 | 1/1 | M63 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M64` | 1/1 | 1/1 | M64 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M65` | 1/1 | 1/1 | M65 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M66` | 1/1 | 1/1 | M66 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M67` | 1/1 | 1/1 | M67 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M68` | 1/1 | 1/1 | M68 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M69` | 1/1 | 1/1 | M69 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M6_AMOUNT` | 1/1 | 1/1 | Amount 6M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M6_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 6M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M6_QTY` | 2/1 | 2/1 | M6_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M6_QUANTITY` | 2/2 | 2/2 | Quantity 6M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M7` | 5/3 | 5/3 | M7 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M70` | 1/1 | 1/1 | M70 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M71` | 1/1 | 1/1 | M71 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M72` | 1/1 | 1/1 | M72 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M73` | 1/1 | 1/1 | M73 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M74` | 1/1 | 1/1 | M74 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M75` | 1/1 | 1/1 | M75 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M76` | 1/1 | 1/1 | M76 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M77` | 1/1 | 1/1 | M77 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M78` | 1/1 | 1/1 | M78 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M79` | 1/1 | 1/1 | M79 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M7_AMOUNT` | 1/1 | 1/1 | Amount 7M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M7_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 7M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M7_QTY` | 2/1 | 2/1 | M7_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M7_QUANTITY` | 2/2 | 2/2 | Quantity 7M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M8` | 5/3 | 5/3 | M8 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M80` | 1/1 | 1/1 | M80 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M81` | 1/1 | 1/1 | M81 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M82` | 1/1 | 1/1 | M82 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M83` | 1/1 | 1/1 | M83 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M84` | 1/1 | 1/1 | M84 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M85` | 1/1 | 1/1 | M85 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M86` | 1/1 | 1/1 | M86 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M87` | 1/1 | 1/1 | M87 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M88` | 1/1 | 1/1 | M88 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M89` | 1/1 | 1/1 | M89 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M8_AMOUNT` | 1/1 | 1/1 | Amount 8M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M8_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 8M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M8_QTY` | 2/1 | 2/1 | M8_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M8_QUANTITY` | 2/2 | 2/2 | Quantity 8M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M9` | 5/3 | 5/3 | M9 | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M90` | 1/1 | 1/1 | M90 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M91` | 1/1 | 1/1 | M91 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M92` | 1/1 | 1/1 | M92 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M93` | 1/1 | 1/1 | M93 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M94` | 1/1 | 1/1 | M94 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M95` | 1/1 | 1/1 | M95 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M96` | 1/1 | 1/1 | M96 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M97` | 1/1 | 1/1 | M97 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M98` | 1/1 | 1/1 | M98 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M99` | 1/1 | 1/1 | M99 | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M9_AMOUNT` | 1/1 | 1/1 | Amount 9M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M9_AMOUNT_KRW` | 1/1 | 1/1 | Amount(KRW) 9M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M9_QTY` | 2/1 | 2/1 | M9_QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M9_QUANTITY` | 2/2 | 2/2 | Quantity 9M | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAIL ADDRESS` | 1/1 | 1/1 | Mail Address | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAIL_INFO_DATE` | 1/1 | 1/1 | Mail Inform Date | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAIL_TITLE` | 0/0 | 1/1 | Mail Title * | L | 260 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAIL_USER1` | 1/1 | 1/1 | Mail User1 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAIL_USER2` | 1/1 | 1/1 | Mail User2 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAIL_USER3` | 1/1 | 1/1 | Mail User3 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAIL_USER4` | 1/1 | 1/1 | Mail User4 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAIL_USER5` | 1/1 | 1/1 | Mail User5 | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAIN_LANE_QTY` | 1/1 | 1/1 | Main | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAIN_POPUP_OPTION` | 0/0 | 1/1 | Main | C | 90 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAIN_YN` | 1/1 | 1/1 | MainYN | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAJOR_CAT` | 2/2 | 2/2 | 대분류 | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAKE_AND_BUY` | 4/4 | 4/4 | Make And Buy | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAKE_DATE` | 2/1 | 2/1 | Make Date | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MANAGER` | 4/4 | 4/4 | PIC(Person) | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MANUAL_YN` | 0/0 | 1/1 | MANUAL_YN | L | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAN_MONTH_PLAN` | 1/1 | 1/1 | 계획 | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAN_MONTH_REAL` | 1/1 | 1/1 | 실행 | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAPPING_ITEM_ID` | 1/1 | 2/1 | MAPPING_ITEM_ID | C | 140 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAPPING_ITEM_ID_ORIGINAL` | 1/1 | 2/1 | MAPPING_ITEM_ID | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MARK` | 2/1 | 2/1 | Description | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MARKET` | 74/51 | 74/51 | Market | C | 60 | FPTextBox | FPComboBox | DEMAND_MARKET_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `MARKETING_DEPARTMENT` | 2/1 | 3/2 | Marketing Department | L | 110 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MASTER_INVLD_CD` | 1/1 | 1/1 | VALID INFO | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MASTER_INVLD_CTN` | 10/1 | 12/1 | VALID INFO | L | 350 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MASTER_INVLD_MSG` | 12/1 | 14/1 | ERROR MESSAGE | L | 300 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL` | 4/3 | 4/3 | Raw Material | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_1` | 1/1 | 1/1 | Material 1 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_10` | 1/1 | 1/1 | Material 10 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_2` | 1/1 | 1/1 | Material 2 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_3` | 1/1 | 1/1 | Material 3 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_4` | 1/1 | 1/1 | Material 4 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_5` | 1/1 | 1/1 | Material 5 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_6` | 1/1 | 1/1 | Material 6 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_7` | 1/1 | 1/1 | Material 7 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_8` | 1/1 | 1/1 | Material 8 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_9` | 1/1 | 1/1 | Material 9 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_CELL` | 1/1 | 1/1 | Raw Material | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_CLASS` | 4/4 | 4/4 | Material Class | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_CLASS_NAME` | 6/6 | 6/6 | Material Class Name | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_DESC` | 1/1 | 1/1 | Material Desc | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_GROUP` | 2/2 | 2/2 | Material Group | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_ID` | 2/2 | 2/2 | Material | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_NAME` | 1/1 | 1/1 | Material Name | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MATERIAL_RANK` | 1/1 | 1/1 | Material Rank | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAX_CAPA` | 1/1 | 1/1 | Max Capa* | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAX_LOAD_QTY` | 1/1 | 1/1 | SLOT STOCK | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MAX_VER_FLAG` | 4/2 | 4/2 | Max Version | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MDF_VERSION_NO` | 1/1 | 1/1 | MDF Version No* | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MDL_GR_NM` | 1/1 | 1/1 | Item Group* | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MDM_ACTIVE` | 0/0 | 3/1 | MDM Active | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MDM_NICK_NAME` | 3/3 | 3/3 | MDM Project Nick name | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MDM_PROJECT_NAME` | 11/11 | 11/11 | Project Name | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MDM_PROJECT_NICK_NAME` | 2/2 | 2/2 | MDM Project Nick name | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE` | 112/86 | 110/81 | Measure | L | 80 | (공란) | FPComboBox | Measure | O | 미확인(모달키 이력 없음) | high | - |
| `MEASURE2` | 1/1 | 1/1 | MEASURE2 | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_COLOR` | 26/20 | 27/21 | MEASURE_COLOR | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_DB` | 1/1 | 1/1 | MEASURE DB | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_GROUP` | 24/12 | 28/11 | Level 1 | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_GROUP_NAME` | 10/2 | 14/2 | Level 1 | L | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_ID` | 9/8 | 9/8 | Measure | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_LABEL` | 25/24 | 26/25 | Measure | L | 110 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_NAME` | 57/38 | 67/39 | Measure | L | 130 | FPTextBox | FPComboBox | Measure | O | 미확인(모달키 이력 없음) | medium | - |
| `MEASURE_NAME2` | 1/1 | 1/1 | Measure Name2 | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_ORDER_NO` | 15/15 | 15/15 | MEASURE_ORDER_NO | C | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_TYPE` | 1/1 | 1/1 | Measure Type | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_UI` | 5/3 | 8/4 | Measure | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_VALUE` | 1/1 | 1/1 | Measure Value | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_VALUE1` | 1/1 | 1/1 | Measure Value1 | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_VALUE1_LABEL` | 1/1 | 1/1 | Measure Value1 Label | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_VALUE2` | 1/1 | 1/1 | Measure Value2 | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEASURE_VALUE2_LABEL` | 1/1 | 1/1 | Measure Value2 Label | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEMO` | 6/6 | 6/6 | Memo | L | 350 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEMO_RANGE` | 1/1 | 1/1 | Line or Material | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MEMO_TYPE` | 1/1 | 1/1 | Memo Type* | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MENU_AUTHORITY_ID` | 3/2 | 3/2 | Authority | C | 100 | FPComboBox | FPComboBox | MENU_AUTHORITY_TYPE | X | 미확인(모달키 이력 없음) | medium | - |
| `MENU_AUTHORITY_NAME` | 1/1 | 1/1 | Authority | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MERGE_DATE` | 1/1 | 1/1 | MERGE_DATE | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MERGE_NUM` | 1/1 | 1/1 | SSP0023 | C | 10 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MES` | 2/1 | 2/1 | MES | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MESSAGE` | 3/3 | 3/3 | MESSAGE | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MESSAGE_CONTENT` | 0/0 | 1/1 | Mail Content * | L | 420 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MESSAGE_ID` | 14/7 | 14/7 | Message | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MES_CHANGE_STATUS` | 3/2 | 3/2 | Change Status | C | 80 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | high | - |
| `MES_HOLD_QTY` | 1/1 | 1/1 | MES Hold | R | 80 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MES_HOLD_RELEASE` | 3/2 | 3/2 | MES Unhold Sched Date | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MES_HOLD_YN` | 7/6 | 7/6 | MES Hold YN | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MES_LINE_ID` | 5/3 | 5/3 | Mes Line | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MES_UNHOLD_SCHD_DATE` | 2/2 | 2/2 | MES Unhold Sched Date | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_APPLY1` | 1/1 | 1/1 | Ni | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_APPLY2` | 1/1 | 1/1 | Co | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_APPLY3` | 1/1 | 1/1 | Li2CO3 | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_APPLY4` | 1/1 | 1/1 | LIOH | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_APPLY5` | 1/1 | 1/1 | Al | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_APPLY6` | 1/1 | 1/1 | Mn | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_APPLY7` | 1/1 | 1/1 | Cu | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_EXCEPTION_YN` | 1/1 | 1/1 | Exception | C | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_LINK_MTD` | 1/1 | 1/1 | Cur_Metal Link | C | 100 | FPComboBox | FPComboBox | DMF_METAL_BUCKET | X | 미확인(모달키 이력 없음) | medium | - |
| `METAL_LINK_PERIOD` | 1/1 | 1/1 | Metal Link Period | C | 100 | FPComboBox | FPComboBox | DMF_BIZ_PLAN_METAL_LINK_PERIOD | O | 미확인(모달키 이력 없음) | medium | - |
| `METAL_LINK_START_MONTH` | 1/1 | 1/1 | Metal Link Start Month | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_LINK_YN` | 2/2 | 2/2 | Metal Link | C | 80 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `METAL_REQR1` | 1/1 | 1/1 | Ni | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_REQR2` | 1/1 | 1/1 | Co | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_REQR3` | 1/1 | 1/1 | Li2CO3 | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_REQR4` | 1/1 | 1/1 | LIOH | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_REQR5` | 1/1 | 1/1 | Al | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_REQR6` | 1/1 | 1/1 | Mn | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METAL_REQR7` | 1/1 | 1/1 | Cu | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `METER_PER_ROLL` | 1/1 | 1/1 | Conversion(M/Roll) | L | 70 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MFG_DATE` | 3/2 | 3/2 | SCP Date | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MFG_QTY` | 8/5 | 8/5 | SCP QTY | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MFG_QTY_UOM` | 1/1 | 1/1 | MFG QTY UOM | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MFG_WEEK` | 9/6 | 9/6 | SCP Week | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MGMT_USER_ID` | 0/0 | 4/3 | User | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MINOR_CAT` | 2/2 | 2/2 | 소분류 | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MIN_CAPACITY` | 12/12 | 12/12 | Min Capacity | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MIN_EXHT_YYYYMM` | 1/1 | 1/1 | Consume point of long-term Inv. | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MIN_LOT_SIZE` | 2/1 | 2/1 | Min | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MKT_DEPT` | 7/2 | 7/2 | Marketing department | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MKT_DP` | 4/3 | 4/3 | ⓓMKT FCST(DP) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MKT_FCST` | 1/1 | 1/1 | 고객수요계획 | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MKT_FCST_DATE` | 2/2 | 2/2 | MKT FCST Date | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MKT_OWMER` | 3/3 | 3/3 | MKT Owner | L | 120 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MKT_OWNER` | 2/2 | 2/2 | MKT Owner | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MMS_CF` | 2/1 | 5/1 | MMS_CF | L | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MNU_AUTH_YN` | 0/0 | 1/1 | Auth | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `MNU_BTN_CD` | 0/0 | 2/2 | Button | L | 100 | (공란) | FPComboBox | BtnType | O | 미확인(모달키 이력 없음) | low | - |
| `MNU_DESC` | 0/0 | 3/1 | Description | L | 240 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MNU_ID` | 0/0 | 6/3 | Level 3 Menu | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MNU_MSG_ID` | 0/0 | 3/1 | Menu Message ID | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MNU_MSG_NM` | 0/0 | 5/2 | Menu Title | L | 120 | FPModal | FPModal | 미확인(콤보 배정 이력 없음) | - | LevelTwoMenu | medium | - |
| `MNU_NM` | 0/0 | 1/1 | Menu | L | 200 | FPComboBox | FPComboBox | MenuList | O | 미확인(모달키 이력 없음) | low | - |
| `MNU_TP_CD` | 0/0 | 1/1 | Menu Type | C | 100 | FPComboBox | FPComboBox | MenuType | O | 미확인(모달키 이력 없음) | low | - |
| `MNU_URL` | 0/0 | 3/1 | URL | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MN_KG_PER_BIZ_TYPE` | 1/1 | 1/1 | Mn | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MN_MIX_METAL_LINK_PERIOD` | 1/1 | 1/1 | Mn | C | 80 | FPComboBox | FPComboBox | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | X | 미확인(모달키 이력 없음) | medium | - |
| `MN_USD_PER_KG` | 1/1 | 1/1 | Mn | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL` | 18/13 | 18/13 | Model | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL CODE` | 1/1 | 1/1 | MODEL CODE | C | 120 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_AVG` | 1/1 | 1/1 | Avarage | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_CODE` | 1/1 | 1/1 | MODEL CODE | L | 150 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_GROUP_LEVEL2_NAME` | 1/1 | 1/1 | Prod Gr2 | L | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_ID` | 58/29 | 58/29 | Model | L | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_ID_NICK_NAME` | 1/1 | 1/1 | Nick Name | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_ITEM_ID` | 1/1 | 1/1 | Model | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_LEVEL_3_NAME` | 2/2 | 2/2 | Item Class | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_MIX` | 2/2 | 2/2 | Model Mix | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_MIX_03` | 1/1 | 1/1 | Model Mix | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_MIX_06` | 1/1 | 1/1 | Model Mix | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_MIX_12` | 1/1 | 1/1 | Model Mix | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_NAME` | 4/4 | 4/4 | Model Name | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_NICK_NAME` | 6/6 | 6/6 | Nick Name | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_PIC` | 4/4 | 3/3 | Model PIC | L | 150 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_SITE` | 3/2 | 4/2 | Model Site | L | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_SPEC` | 1/1 | 1/1 | Model Spec | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_SUM` | 2/1 | 2/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_SUM2` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_SUM_CELL_CONV` | 1/1 | 1/1 | SUM (환산수량적용) | R | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_TYPE` | 4/3 | 4/3 | MODEL TYPE | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_TYPE_CD` | 1/1 | 1/1 | Type | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_TYPE_GR` | 2/2 | 2/2 | Model | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_TYPE_NAME_40` | 1/1 | 1/1 | Model Type | C | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_USER` | 11/11 | 11/11 | Model PIC | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODEL_VERSION` | 1/1 | 1/1 | Model Version | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODIFIER` | 1/1 | 1/1 | 수정자 | C | 110 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODIFIER_DATE` | 1/1 | 1/1 | Change Date | C | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODIFY_DATE` | 3/1 | 3/1 | Last Update Date | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODIFY_DESCRIPTION` | 1/1 | 1/1 | Modify Description | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODIFY_FP_APPLY_WIPQTY` | 1/1 | 1/1 | Modify QTY (FP) | R | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODIFY_USER_ID` | 3/1 | 3/1 | Updater | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODULE` | 1/1 | 2/2 | MODULE | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODULE_CODE` | 0/0 | 1/1 | Module * | C | 110 | FPComboBox | FPComboBox | MailModule | O | 미확인(모달키 이력 없음) | low | - |
| `MODULE_ID` | 1/1 | 1/1 | Module | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODULE_ITEM_ID` | 1/1 | 1/1 | Module | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODULE_NAME` | 1/1 | 1/1 | Module Name | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODULE_PER_CAR` | 17/16 | 19/16 | Module/Car | R | 40 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODULE_PER_PACK` | 3/3 | 3/3 | Module/Pack | L | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MODULE_VARIANT` | 5/4 | 5/4 | Module Variant | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MOEL_USER` | 1/1 | 0/0 | Model PIC | C | 150 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MON` | 1/1 | 1/1 | Mon | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `MONTH` | 3/2 | 3/2 | Month | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MONTHLY_ROLLING_FCST` | 1/1 | 1/1 | Monthly Rolling Forecast | C | 100 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `MOQ` | 2/2 | 2/2 | Box Qty | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MOVING_FACTORY` | 1/1 | 1/1 | Moving Factory | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MOVING_QTY` | 14/6 | 14/6 | Moving Qty | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MO_ID` | 1/1 | 1/1 | MO_ID | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MPP_DW_TIME` | 1/1 | 1/1 | DW Submit Time | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MPP_DW_USER` | 1/1 | 1/1 | Submit ID | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MPP_LATEST_DW_SUBMIT_FLAG` | 1/1 | 1/1 | Latest DW Submit Flag | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MPP_OUT` | 1/1 | 1/1 | MPP(Out) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MPP_OUT_CELL` | 1/1 | 1/1 | MPP(Out) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MRP_FLAG` | 1/1 | 1/1 | MRP Flag | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MRP_TARGET_YN` | 2/2 | 2/2 | MRP Interface | C | 100 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `MSG_ID` | 0/0 | 2/2 | Message ID | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MSG_NM_CN` | 0/0 | 2/2 | Chinese | C | 250 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MSG_NM_EN` | 0/0 | 2/2 | English | C | 250 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MSG_NM_KO` | 0/0 | 2/2 | Korean | C | 250 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MSG_TP_CD` | 0/0 | 2/2 | Type | C | 100 | FPComboBox | FPComboBox | MessageType | O | 미확인(모달키 이력 없음) | medium | - |
| `MSR_TP_CD` | 2/1 | 5/1 | Measure | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MTK_OWNER` | 11/11 | 11/11 | MKT Owner | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MV_PLAN_YYYYMM` | 1/1 | 1/1 | 이동계획월 | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `MY_WORK` | 0/0 | 1/1 | My Work | C | 30 | FPModal | FPModal | 미확인(콤보 배정 이력 없음) | - | MyWorkModal | low | - |
| `M_BATCH` | 1/1 | 1/1 | Pancake(m/batch)(Before R/Press) | R | 215 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M_BOH_QTY` | 1/1 | 1/1 | Monthly(BOH) | C | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M_MIN` | 1/1 | 1/1 | Coating Speed* | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M_PER_ROLL` | 1/1 | 1/1 | Conversion | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `M_PER_ROLL_QTY` | 1/1 | 1/1 | Conversion (M/Roll) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NAME` | 1/1 | 1/1 | Name | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NATION_NM` | 1/1 | 1/1 | Nation Name | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NDR` | 1/1 | 1/1 | NDR TTL | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NDR1` | 1/1 | 1/1 | NDR1 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NDR2` | 1/1 | 1/1 | NDR2 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NDR3` | 1/1 | 1/1 | NDR3 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NDR4` | 1/1 | 1/1 | NDR4 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NDR5` | 1/1 | 1/1 | NDR5 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NDR_INCOTERMS` | 1/1 | 1/1 | NDR TTL(Incoterms) | R | 75 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEWDOM_EXP` | 2/2 | 2/2 | New Customs Handbook | L | 80 | FPComboBox | FPComboBox | DOM_EXP | O | 미확인(모달키 이력 없음) | medium | - |
| `NEWFCSTTYPE` | 2/2 | 2/2 | New FCST Type | L | 80 | FPComboBox | FPComboBox | FCST_TYPE_NOT_ETC | O | 미확인(모달키 이력 없음) | medium | - |
| `NEWINCOTERMS` | 2/2 | 2/2 | New Incoterms | L | 80 | FPComboBox | FPComboBox | Incoterms | O | 미확인(모달키 이력 없음) | medium | - |
| `NEWPLANT_SITE_ID` | 2/2 | 2/2 | New Plant Site | L | 80 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `NEW_A_COUNTRY` | 15/13 | 15/13 | A Country | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_A_PORT_CODE` | 15/13 | 15/13 | A Port | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_BASE_CONFIRM_YN` | 5/5 | 5/5 | NEW_BASE_CONFIRM_YN | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_BOD_ID` | 15/13 | 15/13 | new bod | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_CUSTOMER_LT` | 15/13 | 15/13 | Customer LT | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_D_COUNTRY` | 15/13 | 15/13 | D Country | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_D_PORT_CODE` | 15/13 | 15/13 | D Port | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_ETA` | 15/13 | 15/13 | ETA | C | 70 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_ETD` | 15/13 | 15/13 | ETD | C | 70 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_FLAG` | 4/3 | 5/3 | New Flag | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_INCOTERMS` | 15/13 | 15/13 | new incoterms | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_ITEM_FLAG` | 1/1 | 1/1 | New Item | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_LONG_TERM_EXPECT_AMT` | 1/1 | 1/1 | EOH New long-term Amt (KRW) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_LONG_TERM_EXPECT_QTY` | 1/1 | 1/1 | EOH New long-term Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_LT_DAY` | 15/13 | 15/13 | L/T(Day) | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_ROUTE` | 2/2 | 2/2 | Route | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_ROUTE_ID` | 13/11 | 13/11 | Route | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_SHIPMENT_CONFIRM_QTY` | 5/5 | 5/5 | Qty* | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_SHIPMENT_DATE` | 15/13 | 15/13 | Shipment Date* | C | 70 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_SHIPTO_CODE` | 2/2 | 2/2 | ShipTo Code | C | 70 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_TO_CITY` | 15/13 | 15/13 | To City | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_TO_COUNTRY` | 15/13 | 15/13 | To Country | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_TRANSPORT_MODE` | 15/13 | 15/13 | Trans Mode | C | 45 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_USER_DEPARTMENT` | 1/1 | 1/1 | Department | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_USER_ID` | 2/2 | 2/2 | User ID | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_USER_NAME` | 2/2 | 2/2 | User Name | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NEW_YN` | 6/6 | 6/6 | new_yn | R | 100 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `NEXT_RUN_DATE` | 1/1 | 1/1 | Next Run Date | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NICKNAME` | 3/3 | 3/3 | Nick Name | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NICKNAME_40` | 1/1 | 1/1 | Product level3 | L | 180 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NICK_NAME` | 390/218 | 403/215 | Nick Name | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NICK_NAME_DUMMY_YN` | 2/1 | 5/1 | Dummy | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NI_KG_PER_BIZ_TYPE` | 1/1 | 1/1 | Ni | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NI_MIX_METAL_LINK_PERIOD` | 1/1 | 1/1 | Ni | C | 80 | FPComboBox | FPComboBox | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | X | 미확인(모달키 이력 없음) | medium | - |
| `NI_USD_PER_KG` | 1/1 | 1/1 | Ni | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NLEVEL` | 2/2 | 2/2 | Level | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NLT` | 2/2 | 2/2 | 기준 L/T(조회시점) | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NO` | 4/1 | 4/1 | Job No | C | 37 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NON_OPERATION` | 1/1 | 1/1 | Non-Operation | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NORMAL_QTY` | 1/1 | 1/1 | EOH Normal Qty | R | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NOTE` | 0/0 | 2/1 | Note | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NOTE1` | 1/1 | 1/1 | Reason | C | 250 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NOTE2` | 1/1 | 1/1 | Action Plan | C | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NOTE3` | 1/1 | 1/1 | PIC | C | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NOTICE` | 0/0 | 1/1 | Notice | L | 500 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NO_DEMAND` | 1/1 | 0/0 | NO_DEMAND | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NO_USAGE_IN_3M` | 2/2 | 2/2 | No usage in 3M | C | 55 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NO_WORK` | 1/1 | 1/1 | NO_WORK | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NO_WORK_CALC` | 1/1 | 1/1 | NO_WORK_CALC | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NO_WORK_DATE` | 1/1 | 1/1 | Date* | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NO_WORK_TYPE` | 1/1 | 0/0 | Type | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NPC_ITEM_ID` | 3/3 | 2/2 | Material (Notched-Pancake) | L | 110 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `NUM` | 3/2 | 4/2 | No. | C | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OCCR_RSN_CD` | 3/2 | 3/2 | 발생사유 유형 | L | 100 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | high | - |
| `OCCR_RSN_CD_ATTRIBUTE1` | 1/1 | 0/0 | Test OCC_RSN_CD | L | 100 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | low | - |
| `OCCR_RSN_CTN` | 4/3 | 4/3 | 발생사유 상세 | L | 110 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OCCR_RSN_DESC` | 1/1 | 1/1 | 발생사유 | C | 100 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `OEE` | 1/1 | 1/1 | Capa/일 (OEE 반영) | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OFF_TIME` | 1/1 | 1/1 | Off Time(Day)* | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OLD_KEY_ID` | 1/1 | 1/1 | OLD_KEY_ID | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OLD_KEY_VALUE` | 1/1 | 1/1 | OLD_KEY_VALUE | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OLD_PART_ID` | 1/1 | 1/1 | OLD_PART_ID | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ONE_SEGMENT_COST` | 1/1 | 1/1 | Pick Up Cost | R | 80 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ONLY_STOCK` | 1/1 | 1/1 | Only Stock | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `OPEN` | 1/1 | 2/2 | Action | C | 70 | FPButton | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPERATION` | 5/3 | 5/3 | Operation | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPERATION_GROUP` | 65/50 | 67/51 | Operation Group | C | 60 | FPTextBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | high | - |
| `OPERATION_GROUP_DESC` | 7/7 | 7/7 | Operation Group | L | 65 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPERATION_GROUP_ID` | 15/10 | 15/10 | Operation Group | C | 100 | FPTextBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `OPERATION_GROUP_NAME` | 40/29 | 40/29 | Operation Group | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPERATION_ID` | 216/118 | 229/120 | Operation | C | 80 | FPTextBox | FPComboBox | OperationByLine | X | 미확인(모달키 이력 없음) | high | - |
| `OPERATION_ID2` | 1/1 | 1/1 | Operation | L | 120 | FPComboBox | FPComboBox | OperationByBuilding | X | 미확인(모달키 이력 없음) | medium | - |
| `OPERATION_ID_CPY` | 4/4 | 4/4 | Operation / Storage | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPERATION_LEAD_TIME` | 2/1 | 2/1 | Value | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPERATION_LEAD_TIME_UOM` | 2/1 | 2/1 | UOM | C | 80 | FPComboBox | FPComboBox | OPERATION_LEAD_TIME_UOM | X | 미확인(모달키 이력 없음) | medium | - |
| `OPERATION_LOT_SIZE` | 2/1 | 2/1 | Max | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPERATION_LT` | 1/1 | 1/1 | Oper. L/T | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPERATION_NAME` | 66/41 | 68/41 | Operation Name | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPERATION_SEQ` | 2/2 | 2/2 | Operation Seq | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPERATION_STEP` | 1/1 | 1/1 | Operation Step | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPMZ_ACTV_CD` | 3/3 | 3/3 | Activity Code | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPMZ_ACTV_NAME` | 3/3 | 3/3 | Activity Name | L | 200 | (공란) | FPComboBox | ActivityCode | X | 미확인(모달키 이력 없음) | medium | - |
| `OPMZ_ACTV_RUN_STAT_CD` | 1/1 | 1/1 | OPMZ_ACTV_RUN_STAT_CD | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPMZ_ACTV_RUN_STAT_NAME` | 1/1 | 1/1 | OPMZ_ACTV_RUN_STAT_NAME | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPMZ_ACTV_SEQ` | 2/2 | 2/2 | Act. Seq | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPMZ_PLAN_GR_DESC` | 1/1 | 1/1 | Desc. | L | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPMZ_PLAN_GR_ID` | 14/11 | 16/12 | Plan Group* | L | 120 | FPComboBox | FPComboBox | PlanGroup | X | 미확인(모달키 이력 없음) | high | - |
| `OPMZ_PLAN_GR_ITEM_ID` | 1/1 | 1/1 | Model | L | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPMZ_PLAN_GR_NAME` | 15/7 | 16/7 | Plan Group | L | 140 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPMZ_PLAN_ID` | 2/2 | 2/2 | Plan ID | L | 250 | FPComboBox | FPComboBox | PlanID | X | 미확인(모달키 이력 없음) | medium | - |
| `OPMZ_PLAN_ID_INDP_YN` | 1/1 | 1/1 | OPMZ_PLAN_ID_INDP_YN | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPMZ_PRS_CD` | 3/3 | 3/3 | Process CD | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPMZ_PRS_NAME` | 1/1 | 1/1 | Process | L | 180 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPMZ_TGT_DIVS_CD` | 2/2 | 2/2 | Type* | L | 100 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `OPTION_YN` | 2/2 | 2/2 | Option Flag | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OPT_YN` | 0/0 | 1/1 | OPT YN | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `OP_LT_TOTAL_AUTO` | 1/1 | 1/1 | OP L/T Total | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OP_START_TIME` | 1/1 | 1/1 | Current Op Start Time | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OQC_COMPLETE` | 2/2 | 2/2 | OQC Complete | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OQC_INSP_REQUEST` | 2/2 | 2/2 | OQC Insp Request | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OQC_INSP_RESULT` | 2/2 | 2/2 | OQC Insp Result | C | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OQC_NG` | 2/2 | 2/2 | OQC NG | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORDERAPPROVAL` | 1/1 | 1/1 | 수주(품의) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORDEREND` | 1/1 | 1/1 | 종료 | C | 50 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORDERNOW` | 1/1 | 1/1 | 수주(현재) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORDERSTART` | 1/1 | 1/1 | 시작 | C | 50 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORDER_CREAT_DATE` | 1/1 | 1/1 | ORDER_CREAT_DATE | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORDER_TYPE` | 8/6 | 8/6 | WO Type | C | 80 | FPTextBox | FPComboBox | FCST_TYPE | X | 미확인(모달키 이력 없음) | medium | - |
| `ORDER_TYPE ORDER` | 1/1 | 1/1 | Order Type | L | 75 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORDER_TYPE_DETAIL` | 4/3 | 4/3 | Order Type Detail | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORGINAL_QTY` | 1/1 | 1/1 | Org. QTY | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORGN` | 0/0 | 1/1 | Org | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_DIVISION_ID` | 6/5 | 6/5 | ORG_DIVISION_ID | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_FACTORY_ID` | 2/2 | 2/2 | Org Building | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_FORMATION_END_DATE` | 2/1 | 2/1 | ORG_FORMATION_END_DATE | L | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_FORMATION_START_DATE` | 2/1 | 2/1 | ORG_FORMATION_START_DATE | L | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_FROM_YYYYMMDD` | 4/4 | 4/4 | ORG_FROM_YYYYMMDD | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_INSTANCE_ID` | 1/1 | 1/1 | Org Instance | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_ITEM_ID` | 3/2 | 3/2 | ORG_ITEM_ID | L | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_LINE_ID` | 2/2 | 2/2 | ORG_LINE_ID | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_LINE_SETUP_GROUP_ID` | 2/2 | 2/2 | Org Line Setup Group | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_LOSS_END_DATE` | 1/1 | 1/1 | ORG_LOSS_END_DATE | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_LOSS_START_DATE` | 1/1 | 1/1 | ORG_LOSS_START_DATE | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_MARKET` | 3/2 | 3/2 | Org Market | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_MENU_AUTHORITY_ID` | 1/1 | 1/1 | Org Authority | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_OPERATION_ID` | 2/2 | 2/2 | ORG_OPERATION_ID | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_PLANT_ID` | 1/1 | 1/1 | Org Plant | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_PLANT_SITE_ID` | 4/3 | 4/3 | ORG_PLANT_SITE_ID | L | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_PLAN_GROUP_ID` | 1/1 | 1/1 | Org Plan Group | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_PLAN_IN_QTY` | 2/2 | 2/2 | Org. Plan QTY | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_SHOP_GROUP_ID` | 1/1 | 1/1 | Org Shop Group | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_SITE_ID` | 1/1 | 1/1 | Org Site | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_TACT_TIME_END_DATE` | 1/1 | 1/1 | ORG_TACT_TIME_END_DATE | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_TACT_TIME_START_DATE` | 1/1 | 1/1 | ORG_TACT_TIME_START_DATE | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_TO_YYYYMMDD` | 4/4 | 4/4 | ORG_TO_YYYYMMDD | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_VALID_YN` | 2/2 | 2/2 | ORG_VALID_YN | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORG_VERSION` | 1/1 | 1/1 | Org Version | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORIGINAL_QTY` | 1/1 | 1/1 | Org. QTY | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORIGIN_DIV` | 1/1 | 1/1 | Origin Div | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORIGIN_DIVISION_ID` | 18/13 | 17/13 | Origin Div | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORIGIN_DIVISION_NAME` | 1/1 | 1/1 | Origin Div | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORIGIN_FROM_DIVISION_ID` | 40/31 | 40/31 | Origin From Div | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORIGIN_MATERIAL` | 2/1 | 2/1 | Origin Material Code | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORIGIN_PLANT_SITE_ID` | 1/1 | 1/1 | ORIGIN_PLANT_SITE_ID | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORIGIN_TO_DIVISION_ID` | 39/29 | 39/29 | Origin To Div | C | 65 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ORI_VERSION` | 1/1 | 1/1 | Ori.Version | C | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OSP_YN` | 3/3 | 3/3 | OSP_YN | C | 50 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `OS_CORP` | 1/1 | 1/1 | 해외법인 | C | 80 | FPComboBox | FPComboBox | DMF0005_DM_OS_CORP_CD | O | 미확인(모달키 이력 없음) | medium | - |
| `OS_CORP_CD` | 0/0 | 1/1 | OS Corp | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OTHER_STOCK_CELL` | 1/1 | 1/1 | Cell | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OTHER_STOCK_PACK` | 1/1 | 1/1 | Pack | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OTHER_STOCK_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OTMZ_PLAN_GR_ID` | 0/0 | 1/1 | OTP_PLAN_GR_ID | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OTMZ_PLAN_GR_ITEM_ID` | 0/0 | 1/1 | Model | L | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OTMZ_PLAN_GR_NAME` | 0/0 | 1/1 | Plan Group | L | 200 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OTP_PLAN_GR_ID` | 0/0 | 1/1 | OTP_PLAN_GR_ID | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OTP_PLAN_GR_ITEM_ID` | 0/0 | 1/1 | Model | L | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OTP_PLAN_GR_NAME` | 0/0 | 1/1 | Plan Group | L | 200 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OUTBOUND_DAY` | 1/1 | 1/1 | Out Bound | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OUTSOURCING_FACTORY` | 7/6 | 7/6 | Outsourcing Factory | C | 30 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OUTSOURCING_FLAG` | 7/6 | 7/6 | Outsourcing Flag | C | 30 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OUT_BUFFER_DAY` | 1/1 | 1/1 | Out Buffer | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OUT_QTY` | 3/3 | 3/3 | Out Qty | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OWMS_HOLD_YN` | 2/2 | 2/2 | oWMS Hold YN | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OWMS_QTY_PCM` | 2/2 | 2/2 | Pancake M | C | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OWMS_QTY_UOM` | 2/2 | 2/2 | UOM | C | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OWMS_STOCK_QTY` | 3/2 | 3/2 | oWMS Stock Qty | C | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `OWNER` | 21/19 | 29/21 | Owner | L | 80 | (공란) | FPModal | DbSchema | O | 미확인(모달키 이력 없음) | high | - |
| `OWNER_NAME` | 2/2 | 7/3 | Owner Name | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `P5000` | 1/1 | 1/1 | CMA Completion | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `P5200` | 1/1 | 1/1 | CMA Assembly Completion | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `P5500` | 1/1 | 1/1 | CMA Packing | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `P9500` | 1/1 | 1/1 | BMA Packing | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACK` | 1/1 | 1/1 | PACK | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACKAGE_QTY` | 1/1 | 1/1 | Package Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACKAGE_TYPE` | 1/1 | 1/1 | Package Type * | C | 100 | FPComboBox | FPComboBox | ElectrodePackageType | X | 미확인(모달키 이력 없음) | medium | - |
| `PACKAGE_TYPE_CODE` | 3/3 | 3/3 | Package Type (oWMS) | C | 100 | FPText | FPComboBox | ElectrodePackageType | X | 미확인(모달키 이력 없음) | medium | - |
| `PACKER_ITEM_ID_SUFFIX` | 1/1 | 1/1 | Packer Item Suffix | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACKER_LINE_ACTIVE_YN` | 1/1 | 1/1 | Packer Line Active | C | 80 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `PACKING_QTY` | 8/5 | 8/5 | Packing Qty | C | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACKING_STATUS` | 5/5 | 5/5 | Packing Status | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACK_GROUP` | 7/6 | 7/6 | PACK GROUP | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACK_GROUP_CODE` | 2/2 | 2/2 | Pack Group Code | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACK_INCOMMING` | 1/1 | 1/1 | Incomming | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACK_ITEM_ID` | 2/2 | 2/2 | Pack Code | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACK_MOVE_FLAG` | 1/1 | 1/1 | Pack move flag | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACK_MOVE_QTY_SUM` | 1/1 | 1/1 | Pack Intransit | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACK_NICK_NAME` | 2/2 | 2/2 | Nick Name | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACK_OPERATION_LT` | 1/1 | 1/1 | Operatoin L/T | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PACK_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PALLET_ID` | 9/8 | 9/8 | Pallet ID | L | 110 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PANCAKE` | 1/1 | 1/1 | Pancake (m/Roll)_Result | C | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PANCAKE_GOOD_QTY_SUM` | 2/2 | 2/2 | Pancake Good Stock | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAM1` | 0/0 | 1/1 | PARAM1 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAM2` | 0/0 | 1/1 | PARAM2 | L | 20 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAM3` | 0/0 | 1/1 | PARAM3 | L | 20 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAM4` | 0/0 | 1/1 | PARAM4 | L | 20 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAM5` | 0/0 | 1/1 | PARAM5 | L | 20 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAMETER1` | 2/1 | 1/1 | Parameter 1 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAMETER2` | 2/1 | 1/1 | Parameter 2 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAMETER3` | 2/1 | 1/1 | Parameter 3 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAMETER4` | 2/1 | 1/1 | Parameter 4 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAMETER5` | 2/1 | 1/1 | Parameter 5 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAMETER_ID` | 0/0 | 1/1 | Parameter ID | L | 130 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAMETER_TYPE` | 0/0 | 1/1 | Type | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARAM_VALUE` | 1/1 | 1/1 | Parameter | C | 300 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARENT_ITEM_CLASS_NAME` | 1/1 | 1/1 | Parent Material ClassName | L | 190 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARENT_ITEM_ID` | 8/6 | 8/6 | Parent Material | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARENT_ITEM_ID2` | 1/1 | 1/1 | Parent Material | L | 220 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARENT_ITEM_NAME` | 2/2 | 2/2 | Parent Item Name | L | 200 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARENT_ITEM_TYPE` | 1/1 | 1/1 | Parent Material Type | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARENT_LEVEL_3_NAME` | 1/1 | 1/1 | Parent Material Class 3 | L | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARENT_MATERIAL` | 1/1 | 1/1 | Parent Mateial | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARENT_MATERIAL_NAME` | 1/1 | 1/1 | Parent Mateial Name | C | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARENT_NICK_NAME` | 3/2 | 3/2 | Parent Nick Name | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARENT_QTY` | 3/2 | 3/2 | Parent Quantity | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARENT_UOM` | 3/2 | 3/2 | Parent UOM | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PARTIAL_PLAN_YN` | 4/4 | 4/4 | Partial Plan YN | C | 80 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `PART_ID` | 1/1 | 1/1 | PART_ID | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PART_LEADER` | 2/2 | 2/2 | Part Leader | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PART_LEADER_NAME` | 2/2 | 2/2 | Part Leader Name | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PASS_CODE` | 1/1 | 1/1 | PassCode | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PATTERN_QTY` | 1/1 | 1/1 | PATTERN_QTY | C | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PC_BOH` | 1/1 | 1/1 | Pancake | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PC_BOH_QTY` | 4/4 | 4/4 | Pancake | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PC_BOH_QTY_CELL` | 2/2 | 2/2 | Pancake | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PC_BOH_QTY_PCM` | 2/2 | 2/2 | Pancake | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PC_HOLD_QTY` | 2/2 | 2/2 | Pancake | R | 60 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PC_MODEL_ID` | 1/1 | 1/1 | Work Sheet Model | 미확인(정렬코드 이력 없음) | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PC_ROLL_LENGTH` | 2/2 | 2/2 | Pancake (m/Roll)_Simul | C | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PC_ROLL_LENGTH_UOM` | 1/1 | 1/1 | PC_ROLL_LENGTH_UOM | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PDS_EQUIPMENT_ID` | 1/1 | 1/1 | Equipment | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PDS_PLAN_ID` | 1/1 | 1/1 | PDS Plan ID | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PDS_TARGET_ID` | 1/1 | 1/1 | PDS Target ID | L | 300 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PDS_TARGET_ID_ORG` | 1/1 | 1/1 | PDS ID | L | 300 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PEGGING_OPERATION` | 6/6 | 6/6 | Pegging Operation | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PERIOD` | 1/1 | 1/1 | Period | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PERIOD1_LT` | 1/1 | 0/0 | Plant to CY | L | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PERIOD2_LT` | 1/1 | 0/0 | CY to CY | L | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PERIOD3_LT` | 1/1 | 0/0 | CY to Dest. | L | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PERIOD_NM2` | 1/1 | 1/1 | Period | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PERIOD_SHIPSCH_FRI` | 1/1 | 0/0 | Fri | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `PERIOD_SHIPSCH_MON` | 1/1 | 0/0 | Mon | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `PERIOD_SHIPSCH_SAT` | 1/1 | 0/0 | Sat | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `PERIOD_SHIPSCH_SUN` | 1/1 | 0/0 | Sun | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `PERIOD_SHIPSCH_THU` | 1/1 | 0/0 | Thu | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `PERIOD_SHIPSCH_TUE` | 1/1 | 0/0 | Tue | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `PERIOD_SHIPSCH_WED` | 1/1 | 0/0 | Wed | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `PERIOD_TYPE` | 3/2 | 3/2 | New Demand | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PERM_KEP_CNC_YN` | 0/0 | 1/1 | Permanent YN | C | 80 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `PFRSLT_QTY` | 8/3 | 13/3 | Result | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PHASE1` | 1/1 | 1/1 | Phase1 | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PHASE2` | 1/1 | 1/1 | Phase2 | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PHONE` | 7/3 | 7/3 | HP | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PIC` | 4/3 | 4/3 | PIC | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PIC_ID` | 9/1 | 9/1 | ID | C | 90 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PIC_NAME` | 9/1 | 9/1 | Name | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PJT_CODE` | 2/1 | 2/1 | Nick Name | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PJT_GROUP_NAME` | 4/4 | 4/4 | Pjt Group Name | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PJT_PROGRESS_STEP_ID` | 1/1 | 1/1 | Step | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PJT_STATUS_ID` | 1/1 | 1/1 | Status | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PKG_CAPA` | 1/1 | 1/1 | PKG Capa(Tray) | R | 110 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PKG_CAPA_CELL` | 1/1 | 1/1 | PKG Capa | R | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PKG_TYPE` | 2/2 | 2/2 | Pkg Type | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN` | 1/1 | 1/1 | 계획 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANNED_QTY` | 6/6 | 6/6 | Planned Qty | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT` | 4/3 | 5/4 | Plant | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_CD` | 1/1 | 1/1 | Plant Code | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_DESC` | 1/1 | 1/1 | 플랜트이름 | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_DESCRIPTION` | 3/3 | 3/3 | Plant Site | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_ID` | 265/141 | 277/141 | Plant | C | 80 | FPTextBox | FPComboBox | PlantByGroup | X | 미확인(모달키 이력 없음) | high | - |
| `PLANT_ID_DESCRIPTION` | 1/1 | 2/2 | Plant | C | 65 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_ISSUE_DATE` | 2/2 | 2/2 | Ex-Factory Date | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_NAME` | 41/22 | 52/22 | Plant Name | L | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_PER_ITEM` | 3/2 | 3/2 | Plant/Item | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_QTY` | 2/2 | 2/2 | Plan Qty* | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_SCM_SITE_ID` | 2/2 | 2/2 | Plant Site* | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_SITE` | 4/3 | 4/3 | Plant Site | L | 120 | (공란) | FPComboBox | ProductionPlanOSP | X | 미확인(모달키 이력 없음) | medium | - |
| `PLANT_SITE_CODE` | 1/1 | 1/1 | Plant Site Code | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_SITE_DESCRIPTION` | 2/2 | 2/2 | Plant Site | L | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_SITE_ID` | 48/38 | 46/35 | Plant Site* | L | 80 | (공란) | FPComboBox | FromSiteByDivision | O | 미확인(모달키 이력 없음) | high | - |
| `PLANT_SITE_ID_B` | 2/2 | 2/2 | PLANT_SITE_ID_B | C | 40 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_SITE_NAME` | 11/6 | 12/6 | Plant Site | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_SITE_STATUS` | 1/1 | 1/1 | GSCM. PLANT | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLANT_TYPE` | 2/2 | 1/1 | PLANT_TYPE | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_CONFIRM_ID` | 4/3 | 4/3 | PLAN_CONFIRM_ID | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_DATE` | 41/29 | 42/29 | Plan Date | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_DATE2` | 2/2 | 2/2 | ETA Date | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_DESC` | 1/1 | 1/1 | DESC | L | 120 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_END_DATE` | 7/7 | 7/7 | End Date | C | 75 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_END_TIME` | 6/4 | 6/4 | End Time | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_EQUIPMENT_R` | 2/1 | 2/1 | Plan Equipment | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_GROUP` | 12/1 | 14/1 | Basic Nick/PLAN GROUP | L | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_GROUP_ID` | 7/4 | 8/5 | Plan Group | C | 120 | FPTextBox | FPComboBox | PlanGroup | X | 미확인(모달키 이력 없음) | low | - |
| `PLAN_GROUP_NAME` | 2/1 | 3/2 | Plan Group | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_HORIZON` | 1/1 | 1/1 | Plan Horizon | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_ID` | 9/5 | 9/5 | Plan ID | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_IN_QTY` | 5/4 | 5/4 | Plan In QTY | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_MONTH` | 2/1 | 2/1 | Plan Month | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_QTY` | 16/12 | 16/12 | Original | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_RESULT` | 1/1 | 1/1 | Plan Result | C | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_REVISION` | 1/1 | 1/1 | PLan Revision | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_SEQ` | 11/8 | 11/8 | PLAN_SEQ | L | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_START_DATE` | 7/7 | 7/7 | Start Date | C | 75 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_START_TIME` | 6/4 | 6/4 | Start Time | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_START_YYYYMMDD` | 40/32 | 40/32 | PLAN_START_YYYYMMDD | L | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_TP` | 1/1 | 1/1 | PLAN TP TYPE | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_TP_CD` | 2/1 | 2/1 | Plan TP CD | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_TP_DESC` | 1/1 | 1/1 | 구분 | C | 100 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `PLAN_TYPE` | 40/31 | 40/31 | PLAN_TYPE | L | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_WEEK` | 12/8 | 10/7 | Plan Week | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_WEEK_NAME` | 2/1 | 2/1 | Plan Week Name | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_WEEK_ORDER` | 2/1 | 2/1 | Plan Week Order | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_YIELD` | 1/1 | 1/1 | Plan Yield | R | 75 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLAN_YYYYMM` | 4/3 | 4/3 | Plan Date | C | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PLM_EC_NO` | 23/21 | 24/22 | PDS ID | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD` | 5/4 | 4/3 | POD Port | C | 60 | (공란) | FPComboBox | PortBySite | X | 미확인(모달키 이력 없음) | low | - |
| `POD_AREA` | 4/3 | 4/3 | POD Area | C | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_AREA_V` | 1/1 | 1/1 | To Area | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_ARRIVE_ATA` | 1/1 | 1/1 | ATA | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_ARRIVE_ETA` | 1/1 | 1/1 | ETA | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_ARRIVE_PORT` | 1/1 | 1/1 | Port | L | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_ATA` | 4/2 | 4/2 | POD ATA | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_ATA_DATE` | 2/2 | 2/2 | POD Date(Arrive) | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_ATD` | 4/2 | 4/2 | POD ATD | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_ATD_DATE` | 2/2 | 2/2 | POD Date (Departure) | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_CLEARANCE_LT` | 1/1 | 0/0 | Pod Clearance | L | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_DEPARTURE_ATD` | 1/1 | 1/1 | ATD | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_DEPARTURE_ETD` | 1/1 | 1/1 | ETD | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_ETA` | 1/1 | 1/1 | POD ETA | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_ETA_DATE` | 1/1 | 1/1 | POD Date (ETA) | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_ETD` | 1/1 | 1/1 | POD ETD | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POD_PORT` | 2/2 | 2/2 | POD Port | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POL` | 5/4 | 4/3 | POL Port | C | 60 | (공란) | FPComboBox | PortBySite | X | 미확인(모달키 이력 없음) | low | - |
| `POL_AREA` | 2/2 | 2/2 | POL Area | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POL_ATA` | 4/2 | 4/2 | POL ATA | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POL_ATD` | 5/3 | 5/3 | POL ATD | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POL_ATD_DATE` | 2/2 | 2/2 | POL Date(Departure) | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POL_CLEARANCE_LT` | 1/1 | 0/0 | Pol Clearance | L | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POL_ETA` | 1/1 | 1/1 | POL ETA | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POL_ETD` | 2/2 | 2/2 | ETD | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POL_PORT` | 3/3 | 3/3 | POL Port | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POPUP_STATUS` | 1/1 | 1/1 | POPUP_STATUS | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POSITION_CATEGORY` | 1/1 | 1/1 | Position category | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POST_BOH_QTY` | 1/1 | 1/1 | Post Boh Qty | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `POST_OPER` | 1/1 | 1/1 | Post Oper.* | L | 100 | FPComboBox | FPComboBox | ElectrodePostOperCode | X | 미확인(모달키 이력 없음) | medium | - |
| `POST_OPER_LT` | 1/1 | 1/1 | Post Oper.LT(Day) | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PO_CREATED_DATE` | 2/1 | 2/1 | PO_CREATED_DATE | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PO_END_FLAG` | 2/1 | 2/1 | PO_END_FLAG | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PO_ITEM_ID` | 2/1 | 2/1 | PO_ITEM_ID | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PO_ITEM_IN_QTY` | 2/1 | 2/1 | PO_ITEM_IN_QTY | C | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PO_ITEM_SEQ` | 2/1 | 2/1 | PO_ITEM_SEQ | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PO_NO` | 2/1 | 2/1 | PO_NO | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PO_QTY` | 2/1 | 2/1 | PO_QTY | C | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PO_RTF_DATE` | 2/1 | 2/1 | PO_RTF_DATE | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRDN_OPER_RT` | 1/1 | 1/1 | Efficiency(%) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRDN_PREP_RT` | 0/0 | 1/1 | 생산준비율(%) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRDT_REQ_QTY2` | 1/1 | 1/1 | PRDT_Req. Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRECEDE_PRODUCING_TERM` | 2/1 | 2/1 | Value | R | 150 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRECEDE_PRODUCING_TERM_UOM` | 2/1 | 2/1 | UOM | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PREP_RT` | 1/1 | 1/1 | Preparation Rate(%)* | R | 130 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PREV_BOH_QTY` | 1/1 | 1/1 | Prev Boh Qty | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PREV_OPER_PLANNING_YN` | 1/1 | 1/1 | Prev Oper Planning | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_CHG_QTY` | 5/1 | 5/1 | PRE_CHG_QTY | R | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_CHG_RSN` | 5/1 | 5/1 | PRE_CHG_RSN | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_DISPERSION_ID` | 7/6 | 7/6 | Pre Dispersion Slurry ID | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_DISPERSION_ID_2` | 5/4 | 5/4 | Pre Dispersion Slurry ID 2 | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_DISPERSION_NAME` | 7/6 | 7/6 | Pre Dispersion Slurry Name | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_DISPERSION_NAME_2` | 5/4 | 5/4 | Pre Dispersion Slurry Name 2 | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_FIX_DATE` | 1/1 | 1/1 | Fix Date | C | 85 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_FIX_DATE1` | 1/1 | 1/1 | Fix Date 1 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_FIX_DATE2` | 1/1 | 1/1 | Fix Date 2 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_FIX_TYPE` | 1/1 | 1/1 | Fix Option | C | 85 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_FIX_TYPE1` | 1/1 | 1/1 | Fix Option 1 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_FIX_TYPE2` | 1/1 | 1/1 | Fix Option 2 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_INSPECTION_CELL` | 1/1 | 1/1 | Plant | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_INSPECTION_PACK` | 1/1 | 1/1 | VMI | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_INSPECTION_SUM` | 1/1 | 1/1 | SUM | R | 140 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_KEY_VALUES` | 19/10 | 19/10 | PRE_KEY_VALUES | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_OPMZ_ACTV_CD` | 1/1 | 1/1 | PRE_OPMZ_ACTV_CD | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_OPMZ_ACTV_SEQ` | 1/1 | 1/1 | PRE_OPMZ_ACTV_SEQ | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_PLAN_GR_ID` | 1/1 | 1/1 | Pre_Plan Group | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_PLAN_GR_ITEM_ID` | 1/1 | 1/1 | Pre_Model | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRE_QTY` | 2/1 | 3/1 | RP | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRICE` | 2/1 | 2/1 | Price(KRW) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRICE_ALL` | 2/2 | 2/2 | 일괄입력 Price | R | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRICE_EXIST` | 1/1 | 1/1 | Price Exist* | C | 70 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRIMARY_PLANT` | 1/1 | 1/1 | Primary Plant | L | 220 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRIORITY` | 22/19 | 23/19 | Priority | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRIORITY_DATE` | 1/1 | 1/1 | 완료예정일(최초) 완료예정일(변경) 완료일 | C | 110 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRIORITY_SEQ` | 3/3 | 3/3 | priority seq | C | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRIORITY_START_DATE` | 1/1 | 1/1 | 시작일 | C | 110 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRIORITY_STATUS` | 1/1 | 1/1 | 상태 | C | 60 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `PRIORITY_USER_ID` | 1/1 | 1/1 | 작업자 | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRIO_RANK` | 1/1 | 1/1 | Priority* | C | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRIVATE_FLAG` | 1/1 | 1/1 | Private | C | 50 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `PRJT_NAME` | 2/2 | 2/2 | Nick Name | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRJ_OWNR_ID` | 1/1 | 2/1 | Owner(PM) | L | 80 | (공란) | FPModal | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | low | - |
| `PROBLEM_DATA` | 1/1 | 2/2 | Problem Material | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_DATA_NICK` | 1/1 | 2/2 | PJT Code | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_DESCRIPTION` | 4/3 | 5/3 | Problem Description | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_FACTORY` | 1/1 | 1/1 | Building | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_ITEM` | 1/1 | 1/1 | Material | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_LINE` | 1/1 | 1/1 | Line | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_OPERATION` | 1/1 | 1/1 | Operation | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_PLANT` | 1/1 | 1/1 | Plant | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_QTY` | 8/7 | 8/7 | Problem Qty | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_REASON` | 1/1 | 1/1 | Reason | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_SEQ` | 7/6 | 7/6 | Problem Seq | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_TABLE` | 2/1 | 2/1 | Problem Table | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROBLEM_TYPE` | 11/9 | 12/10 | Problem Type | L | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROCEDURE_NAME` | 1/1 | 1/1 | PROCEDURE_NAME | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROCESS` | 0/0 | 1/1 | Process | C | 150 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROCESSING_TIME` | 1/1 | 1/1 | Processing Time(Min) | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROCESSING_YN` | 1/1 | 1/1 | PROCESSING_YN | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROCESS_DETAIL` | 4/4 | 4/4 | Material Group | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROCESS_GROUP` | 6/5 | 6/5 | Process Group | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROC_NM` | 0/0 | 2/1 | Procedure Name | L | 400 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODID` | 2/2 | 2/2 | Model | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT` | 2/2 | 2/2 | Production issue | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCTION_CYCLE_CELL` | 1/1 | 1/1 | Cell | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCTION_CYCLE_PACK` | 1/1 | 1/1 | Pack | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCTION_CYCLE_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCTION_DATE` | 2/1 | 2/1 | Production Date | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCTION_PROCESS` | 4/4 | 4/4 | Production Process* | C | 80 | FPComboBox | FPComboBox | PRODUCTION_PROCESS | O | 미확인(모달키 이력 없음) | high | - |
| `PRODUCTION_TYPE` | 81/58 | 81/58 | Prod. Type | C | 80 | FPTextBox | FPComboBox | DIVISION_DEMAND_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `PRODUCT_03` | 1/1 | 1/1 | Production issue | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_06` | 1/1 | 1/1 | Production issue | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_12` | 1/1 | 1/1 | Production issue | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_DATE` | 1/1 | 1/1 | MFG Date | 미확인(정렬코드 이력 없음) | 125 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_DETAILS` | 2/2 | 2/2 | Product Details (Report) | L | 80 | FPComboBox | FPComboBox | DMF0005_REPORT_GROUP4 | O | 미확인(모달키 이력 없음) | medium | - |
| `PRODUCT_GROUP` | 5/4 | 7/5 | 제품군 | L | 100 | (공란) | FPComboBox | DMF0005_REPORT_GROUP3 | O | 미확인(모달키 이력 없음) | medium | - |
| `PRODUCT_GROUP_NAME` | 5/5 | 4/4 | Product Group Name | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_ID` | 1/1 | 1/1 | Product | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_LEVEL1` | 8/5 | 11/6 | Product Level1 | C | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_LEVEL2` | 6/4 | 9/5 | Product Level2 | C | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_LEVEL3` | 6/4 | 9/5 | Product Level3 | C | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_MOD` | 1/1 | 1/1 | Production Adjustment | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_MOD_CELL` | 1/1 | 1/1 | Production Adjustment | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_OVER` | 1/1 | 1/1 | Over Production | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_OVER_CELL` | 1/1 | 1/1 | Over Production | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_READY` | 1/1 | 1/1 | 생산준비 (%) | R | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_SETBACK` | 1/1 | 1/1 | Production Failure | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PRODUCT_SETBACK_CELL` | 1/1 | 1/1 | Production Failure | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROD_DATE` | 4/4 | 4/4 | Prod Date | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROD_FROZEN` | 1/1 | 1/1 | Prod Frozen(day)* | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROD_ID` | 1/1 | 1/1 | Model | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROD_LINE` | 2/2 | 2/2 | LINE | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROD_SEQ` | 8/7 | 8/7 | Degree | L | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROD_SHORTAGE_DATE` | 1/1 | 1/1 | Shortage Date(BOH : Mat.) | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROD_TYPE` | 1/1 | 1/1 | Product Type | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROD_VALID_DATE` | 2/2 | 2/2 | Prod Valid Date | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROD_VERSION_TYPE` | 10/7 | 10/7 | Conversion Type | C | 100 | FPTextBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `PROD_VERSION_TYPE_ORG` | 1/1 | 1/1 | PROD_VERSION_TYPE_ORG | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROD_YN` | 1/1 | 1/1 | Prod Y/N | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROFIT_CENTER` | 1/1 | 1/1 | Profit Center | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROFIT_CENTER_CODE` | 1/1 | 1/1 | Profit Center Code | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROGRAM_ID` | 1/1 | 4/3 | Program ID | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROGRAM_NAME` | 2/2 | 5/4 | Program Name | L | 250 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROGRAM_PATH` | 0/0 | 1/1 | Program Path | 미확인(정렬코드 이력 없음) | 250 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROGRESS_CODE` | 1/1 | 1/1 | Step | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROGRESS_TEXT` | 1/1 | 1/1 | Progress | L | 250 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROG_ID` | 1/1 | 1/1 | Program | C | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT` | 3/2 | 3/2 | Project | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT_CD` | 1/1 | 1/1 | PJT Group Name | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT_CNT` | 2/2 | 2/2 | 수신한 데이터 수 | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT_CODE` | 110/77 | 111/73 | Project Code | L | 80 | (공란) | FPModal | PROJECT | X | 미확인(모달키 이력 없음) | high | - |
| `PROJECT_CODE82` | 3/3 | 3/3 | Project Code | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT_CODE_40` | 1/1 | 1/1 | Project Code | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT_DESC` | 1/1 | 1/1 | PROJECT_NAME | L | 150 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT_INFO` | 1/1 | 2/1 | Project | L | 400 | FPComboBox | FPComboBox | ProjectModelMapping | O | 미확인(모달키 이력 없음) | medium | - |
| `PROJECT_NAME` | 72/59 | 71/54 | Project | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT_OPERATION` | 11/1 | 13/1 | PROJECT/OPERATION ID | L | 160 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT_OWNER` | 24/24 | 23/23 | Project Owner | L | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT_STATUS` | 25/21 | 22/18 | Project Status | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT_S_OP_REPORT` | 3/3 | 4/4 | Project(S&OP Report) | L | 131 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PROJECT_VER_SEQ` | 2/2 | 4/4 | Version Seq | L | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PR_CHECK` | 1/1 | 1/1 | PR Check | C | 50 | FPCheckBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PR_CONFIRM_DATE` | 2/1 | 2/1 | PR_CONFIRM_DATE | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PR_ITEM_DETAIL` | 2/2 | 2/2 | BMS ONLY - Software Detail | C | 150 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PR_NO` | 3/1 | 3/1 | PR No | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PR_QTY` | 1/1 | 1/1 | PR Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PR_REQ_QTY` | 2/1 | 2/1 | PR_REQ_QTY | C | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PSEUDO_FACTORY_ID` | 3/3 | 3/3 | Virtual Building | C | 100 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `PSI` | 16/16 | 16/16 | PSI | C | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PSI_NAME` | 11/8 | 11/8 | PSI | C | 30 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PSI_TYPE` | 5/5 | 5/5 | PSI_Type | L | 65 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PSI_VALUE` | 5/5 | 5/5 | PSI Value | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PUBLICATION_PERIOD` | 0/0 | 1/1 | 게시기간 | C | 300 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PUBLISH_TYPE` | 2/2 | 2/2 | Publish Type | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PUCH_GROUP` | 2/1 | 2/1 | PUCH_GROUP | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PUCH_MGR` | 2/1 | 2/1 | PUCH_MGR | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PURCHASE_PO` | 2/2 | 2/2 | Purchase Order Number | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `PWH_BOH` | 1/1 | 1/1 | Product | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QLTY_NO_INSP_FLAG` | 1/1 | 1/1 | QLTY NO INSP flag | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QMS_BOFORE_NT_QTY_SUM` | 2/2 | 2/2 | Assy | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QMS_HOLD_QTY` | 1/1 | 1/1 | QMS Hold | R | 80 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QMS_HOLD_RELEASE` | 3/2 | 3/2 | QMS Unhold Sched Date | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QMS_HOLD_YN` | 9/8 | 9/8 | QMS Hold YN | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QMS_HOLD_YN_CPY` | 3/3 | 3/3 | Hold(QMS) | C | 65 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QMS_MES_HOLD` | 2/2 | 2/2 | QMS/MES Hold | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QMS_REWORK_QTY_SUM` | 2/2 | 2/2 | RW | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QMS_STOCK_QTY_SUM` | 2/2 | 2/2 | Elec | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QMS_UNHOLD_SCHD_DATE` | 2/2 | 2/2 | QMS Unhold Sched Date | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY` | 56/29 | 57/29 | QTY | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY2` | 1/1 | 1/1 | Qty(UOM) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_1` | 2/2 | 2/2 | QTY_1 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_10` | 2/2 | 2/2 | QTY_10 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_11` | 2/2 | 2/2 | QTY_11 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_12` | 2/2 | 2/2 | QTY_12 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_2` | 2/2 | 2/2 | QTY_2 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_3` | 2/2 | 2/2 | QTY_3 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_4` | 2/2 | 2/2 | QTY_4 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_5` | 2/2 | 2/2 | QTY_5 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_6` | 2/2 | 2/2 | QTY_6 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_7` | 2/2 | 2/2 | QTY_7 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_8` | 2/2 | 2/2 | QTY_8 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_9` | 2/2 | 2/2 | QTY_9 | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_CHANGE` | 1/1 | 1/1 | Qty Change | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_CHECK` | 1/1 | 1/1 | Qty | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_LANE` | 1/1 | 1/1 | QTY | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_MONTH1` | 1/1 | 1/1 | MONTH1 | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_MONTH2` | 1/1 | 1/1 | MONTH2 | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_MONTH3` | 1/1 | 1/1 | MONTH3 | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_MONTH4` | 1/1 | 1/1 | MONTH4 | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_MONTH5` | 1/1 | 1/1 | MONTH5 | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_MONTH_FOCUS` | 1/1 | 1/1 | MONTH FOCUS | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QTY_UOM` | 8/7 | 8/7 | Qty Uom | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QUANTITY` | 3/3 | 3/3 | Quantity | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QUANTITY_XLS` | 2/2 | 2/2 | Quantity | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QUERY` | 1/1 | 2/2 | Action | C | 70 | FPButton | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QUERY_ID` | 1/1 | 1/1 | Query | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QUERY_SEQ` | 1/1 | 1/1 | seq (query) | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `QUERY_VAL` | 1/1 | 1/1 | Query Value | C | 300 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RACK_BIZ` | 1/1 | 1/1 | Rack Biz | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RACK_YN` | 1/1 | 1/1 | Rack* | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `RAMP_UP` | 1/1 | 1/1 | RAMP_UP | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RANK` | 1/1 | 1/1 | RANK | C | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RATE` | 3/1 | 3/1 | Rate | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RATE_CELL` | 3/1 | 3/1 | Rate | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RATIO` | 2/2 | 2/2 | Ratio(%) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RATIO_ID` | 2/2 | 2/2 | Batch ID | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RATIO_NAME` | 1/1 | 1/1 | Batch | C | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RCV_CNT` | 1/1 | 1/1 | GSCM 수신한 데이터 수 | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REASON` | 3/3 | 4/4 | Reason* | L | 120 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `REASON_DETAIL` | 2/2 | 2/2 | Reason Detail* | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REASON_ID` | 1/1 | 1/1 | DIO 초과 사유 ID | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RECEIPT_DATE` | 1/1 | 1/1 | 완료예정일(최초) 완료예정일(변경) 완료일 | C | 110 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RECEIPT_GOOD_QTY` | 1/1 | 1/1 | Good | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RECEIPT_GOOD_QTY_SUM` | 2/2 | 2/2 | Good | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RECEIPT_HOLD_QTY` | 1/1 | 1/1 | Hold | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RECEIPT_HOLD_QTY_SUM` | 2/2 | 2/2 | Hold | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RECEIPT_STATUS` | 1/1 | 1/1 | 상태 | C | 60 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `RECEIPT_UNINSPEC_QTY` | 1/1 | 1/1 | Uninspected | R | 78 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RECEIPT_USER_ID` | 1/1 | 1/1 | 작업자 | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RECEIVING_QTY` | 8/5 | 8/5 | Reciving Qty | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RED` | 1/1 | 1/1 | ~-3% or 3%~ | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REFERANCE_OPERATION_ID` | 2/1 | 2/1 | Ref. Operation | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REGISTERID` | 1/1 | 1/1 | 등록자 | C | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REG_COL` | 0/0 | 1/1 | Registration | C | 60 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REG_COMP_DATE` | 0/0 | 3/3 | Reg Complete Date | C | 80 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REG_REQ_DATE` | 0/0 | 2/2 | Reg Request Date | C | 80 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REJECT_REASON` | 3/2 | 4/3 | Reject Reason | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RELEASE` | 2/1 | 2/1 | RELEASE | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RELEASE_APPLY_FLAG` | 1/1 | 1/1 | Release Apply | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RELEASE_DATE` | 1/1 | 1/1 | Last Release Date | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RELEASE_FLAG` | 2/2 | 2/2 | Release Flag | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RELEASE_NOTIFIY_TYPE` | 3/2 | 3/2 | Rel.Msg. | C | 100 | FPComboBox | FPComboBox | RELEASE_NOTIFIY_TYPE | X | 미확인(모달키 이력 없음) | medium | - |
| `RELEASE_PLAN` | 1/1 | 1/1 | Last Release Plan | C | 170 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RELEASE_PLAN_ID` | 3/3 | 3/3 | Plan ID | L | 160 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RELEASE_TIME` | 2/1 | 2/1 | Release Time | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RELEASE_VALUE` | 3/3 | 3/3 | Building | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RELEASE_YN` | 1/1 | 1/1 | RELEASE_YN | C | 90 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RELEASE_YYYYMMDD` | 8/4 | 8/4 | End Date* | C | 110 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REL_DESC` | 1/1 | 1/1 | Release Plan Description | L | 170 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMAIN` | 1/1 | 1/1 | EOH Remain total Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMAIN_AMT` | 1/1 | 1/1 | EOH Remain total Amt (KRW) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMAIN_AMT_USD` | 1/1 | 1/1 | EOH Remain total Amt (USD) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMAIN_LEAD_TIME` | 3/2 | 3/2 | Remain Lead Time(Day) | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMAIN_LONG_TERM_EXPECT_QTY` | 1/1 | 1/1 | EOH Remain long-term sign Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMAIN_LONG_TERM_QTY` | 1/1 | 1/1 | EOH Remain long-term Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMAIN_QTY` | 5/4 | 5/4 | Remain | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMARK` | 17/6 | 17/6 | Remark | L | 300 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMARKS` | 30/16 | 30/16 | Remarks | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMARKS2` | 16/13 | 16/13 | Building | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMARKS3` | 18/14 | 18/14 | Customer Requirement | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REMARKS_CHANGE` | 1/1 | 1/1 | Remarks Change | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REPLACEMENT` | 6/1 | 6/1 | Replacement Y/N | C | 120 | FPComboBox | FPComboBox | ALL_Y_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `REPORT_GROUP1` | 7/7 | 7/7 | Application Gr. | L | 80 | FPComboBox | FPComboBox | DMF0005_REPORT_GROUP1 | O | 미확인(모달키 이력 없음) | high | - |
| `REPORT_GROUP2` | 7/7 | 7/7 | Cust. (Report) | L | 80 | FPComboBox | FPComboBox | DMF0005_REPORT_GROUP2 | O | 미확인(모달키 이력 없음) | high | - |
| `REPORT_GROUP3` | 7/7 | 7/7 | Product Gr.(Report) | L | 80 | FPComboBox | FPComboBox | DMF0005_REPORT_GROUP3 | O | 미확인(모달키 이력 없음) | high | - |
| `REPORT_GROUP4` | 7/7 | 7/7 | Product Details.(Report) | L | 80 | FPComboBox | FPComboBox | DMF0005_REPORT_GROUP4 | O | 미확인(모달키 이력 없음) | high | - |
| `REPORT_GROUP5` | 6/6 | 6/6 | Cyl Gr.(Report) | L | 80 | FPComboBox | FPComboBox | DMF0005_REPORT_GROUP5 | O | 미확인(모달키 이력 없음) | high | - |
| `REPORT_GROUP6` | 10/10 | 10/10 | Cell Model Info | L | 80 | FPComboBox | FPComboBox | DMF0005_REPORT_GROUP6 | O | 미확인(모달키 이력 없음) | high | - |
| `REPORT_GROUP7` | 4/4 | 4/4 | 비고1 | L | 80 | FPComboBox | FPComboBox | DMF0005_REPORT_GROUP7 | O | 미확인(모달키 이력 없음) | high | - |
| `REPORT_GROUP8` | 4/4 | 4/4 | 비고2 | L | 80 | FPComboBox | FPComboBox | DMF0005_REPORT_GROUP8 | O | 미확인(모달키 이력 없음) | high | - |
| `REPORT_TYPE` | 1/1 | 1/1 | Report Type | L | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REP_SHIPTO_CODE` | 3/3 | 3/2 | Rep Ship-To | L | 120 | (공란) | FPModal | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | low | - |
| `REP_SOLDTO_CODE` | 3/3 | 3/2 | Sold-To | L | 100 | (공란) | FPModal | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | low | - |
| `REP_YN` | 4/4 | 4/4 | Rep* | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `REQUESTER` | 1/1 | 1/1 | REQUESTER | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUESTOR` | 12/12 | 12/12 | Shipment Requestor | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUESTOR_DEPT_NAME` | 1/1 | 1/1 | Requestor Dept Name | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUEST_DATE` | 5/5 | 6/6 | Request Date | L | 150 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUEST_DEPT` | 2/2 | 2/2 | Requestor Dept Name | L | 130 | FPComboBox | FPComboBox | Dept | X | 미확인(모달키 이력 없음) | medium | - |
| `REQUEST_DEPT_NAME` | 1/1 | 1/1 | 부서명 | R | 160 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUEST_ID` | 6/5 | 7/6 | Request ID | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUEST_NAME` | 1/1 | 1/1 | Request Name | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUEST_NO` | 2/2 | 2/2 | Request No. | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUEST_REASON` | 1/1 | 1/1 | REQUEST_REASON | L | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUEST_TIME` | 12/11 | 12/11 | Request Date | C | 75 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUEST_TITLE` | 2/2 | 2/2 | Title | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUEST_TYPE` | 1/1 | 1/1 | REQUEST_TYPE | C | 100 | FPComboBox | FPComboBox | REQUEST_TYPE | X | 미확인(모달키 이력 없음) | medium | - |
| `REQUEST_USER` | 5/4 | 5/4 | Requestor | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUEST_USER_ID` | 3/3 | 3/3 | Request User* | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUEST_USER_NAME` | 4/4 | 4/4 | Requestor | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUIRED_QTY` | 6/6 | 6/6 | Required Qty | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQUSET_USER` | 1/1 | 1/1 | 변경점 신청자 | C | 110 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQ_GRP_ID` | 2/1 | 2/1 | REQ_GRP_ID | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQ_MST_ID` | 1/1 | 1/1 | REQ_MST_ID | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQ_RSN_CD` | 1/1 | 1/1 | Requestor | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REQ_RSN_DTL_CTN` | 1/1 | 1/1 | Detailed description | C | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESET` | 1/1 | 1/1 | Reset Status | C | 90 | FPButton | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESPONSE_TIME` | 8/7 | 8/7 | Response Date | C | 75 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT` | 8/5 | 8/5 | ⓒResult (ⓐ+ⓑ) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT(R_P)` | 1/1 | 1/1 | Result(R+P) | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_CELL` | 3/1 | 3/1 | Result | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_DATE` | 3/2 | 3/2 | Result Date | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_LONG_TERM_AMT` | 1/1 | 1/1 | M-1 Long-term Amt (KRW) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_LONG_TERM_EXPECT_QTY` | 1/1 | 1/1 | M-1 Long-term sign Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_LONG_TERM_QTY` | 1/1 | 1/1 | M-1 Long-term Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_NORMAL_QTY` | 1/1 | 1/1 | M-1 Normal Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_PRICE` | 1/1 | 1/1 | M-1 Price(KRW) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_RP` | 1/1 | 1/1 | Result(R+P) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_RP_CELL` | 1/1 | 1/1 | Result(R+P) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_TYPE` | 3/3 | 3/3 | Result Type | L | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_WITH_RTF` | 3/1 | 3/1 | Result With RTF | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_WITH_RTF_CELL` | 3/1 | 3/1 | Result With RTF | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RESULT_YIELD` | 1/1 | 1/1 | Result Yield | R | 75 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RETURN_STATUS` | 1/1 | 1/1 | Status | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REVIEW_DATE` | 1/1 | 1/1 | 완료예정일(최초) 완료예정일(변경) 완료일 | C | 110 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `REVIEW_STATUS` | 1/1 | 1/1 | 상태 | C | 60 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `REVIEW_USER_ID` | 1/1 | 1/1 | 작업자 | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RMTL` | 1/1 | 1/1 | RMTL | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RNUM` | 1/1 | 1/1 | No | 미확인(정렬코드 이력 없음) | 40 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROLE_ID` | 2/2 | 2/2 | Role Id | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROLE_NAME` | 4/4 | 4/4 | Role Name | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROLE_TYPE` | 2/2 | 2/2 | Type | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROLLCAKE` | 1/1 | 1/1 | Jumbo Roll (m/Roll)_Result | C | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROLL_TYPE` | 1/1 | 1/1 | Roll Type | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROOT` | 1/1 | 1/1 | Material | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROUTE` | 17/16 | 17/16 | Route | L | 80 | (공란) | FPComboBox | ROUTE | O | 미확인(모달키 이력 없음) | high | - |
| `ROUTE_CHK` | 1/1 | 1/1 | ROUTE_CHK | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROUTE_CNT` | 2/2 | 3/2 | Route Count | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROUTE_DESC` | 1/1 | 1/1 | Route Desc. | L | 160 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROUTE_DESCRIPTION` | 1/1 | 1/1 | Route Description | L | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROUTE_ID` | 21/16 | 21/16 | Route | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROUTE_NAME` | 2/1 | 2/1 | Route Name | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROUTE_PATH` | 0/0 | 1/1 | Route Path | L | 220 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROUTE_TYPE` | 3/2 | 3/2 | Route Type | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROUTE_VALID` | 2/2 | 2/2 | Route Valid | C | 50 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `ROW_COLOR_INDEX` | 2/2 | 2/2 | ROW_COLOR_INDEX | C | 10 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROW_NUM` | 1/1 | 1/1 | Row Num | R | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `ROW_RANKING` | 3/3 | 3/3 | ROW_RANKING | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RPT_MEASURE` | 1/1 | 1/1 | Measure | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RP_BOH` | 1/1 | 1/1 | J/R(R/P) | R | 80 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RP_BOH_HOLD` | 1/1 | 1/1 | J/R(R/P) | R | 80 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RP_BOH_ONLYHOLD` | 1/1 | 1/1 | J/R(R/P) | R | 80 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RTF` | 4/2 | 4/2 | RTF | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RTF3` | 2/2 | 2/2 | RTF | L | 110 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RTF4` | 2/2 | 2/2 | RTF ETD | L | 110 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RTF5` | 2/2 | 2/2 | RTF QTY | R | 110 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RTF6` | 2/2 | 2/2 | RTF Detail | L | 110 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RTF_CELL` | 3/1 | 3/1 | RTF | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RTF_GAP` | 3/1 | 3/1 | RTF Gap | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RTF_REASON` | 3/1 | 3/1 | RTF Reason | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RTF_VERSION` | 1/1 | 1/1 | RTF Version | C | 150 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RTF_VS` | 3/1 | 3/1 | RTF Vs | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `RUNNING_FLAG` | 1/1 | 1/1 | Running Flag | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `S1000` | 1/1 | 1/1 | SRS Mixing | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `S2000` | 1/1 | 1/1 | SRS Coating | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `S4000` | 1/1 | 1/1 | SRS Slitting | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAFETY_STOCK` | 4/4 | 4/3 | Safety Stock | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAFETY_STOCK_CELL` | 1/1 | 1/1 | Plant | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAFETY_STOCK_PACK` | 1/1 | 1/1 | VMI | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAFETY_STOCK_PIN_HOUSE` | 1/1 | 1/1 | In-house | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAFETY_STOCK_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALE` | 2/2 | 2/2 | Sales issue | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALES_COMPANY` | 9/8 | 14/8 | Sales Company | L | 80 | FPComboBox | FPComboBox | CompanySalesSite | O | 미확인(모달키 이력 없음) | high | - |
| `SALES_FROM_YYYYMMDD` | 7/1 | 7/1 | Effective Start | C | 90 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALES_MODEL` | 9/2 | 9/2 | Sales Model | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALES_PLANT` | 6/5 | 11/5 | Sales Plant | L | 80 | FPComboBox | FPComboBox | PlantByDivisionCompany | O | 미확인(모달키 이력 없음) | high | - |
| `SALES_PLANT_SITE` | 11/1 | 13/1 | SALES/PLANT SITE | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALES_PLAN_ADJUST_YN` | 11/9 | 8/7 | SP | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `SALES_PRIORITY` | 7/1 | 7/1 | Priority | C | 90 | FPComboBox | FPComboBox | SEQ_NUMBER | X | 미확인(모달키 이력 없음) | high | - |
| `SALES_SITE` | 2/2 | 2/2 | SALES SITE | L | 120 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALES_SITE_DESCRIPTION` | 2/2 | 2/2 | Sales Site | L | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALES_SITE_ID` | 3/3 | 3/3 | Sales Site | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALES_TO_YYYYMMDD` | 7/1 | 7/1 | Effective End | C | 90 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALES_VALID_YN` | 7/1 | 7/1 | Use | C | 90 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | high | - |
| `SALES_YYYYMMDD` | 2/1 | 2/1 | 매출일 | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALE_03` | 1/1 | 1/1 | Sales issue | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALE_06` | 1/1 | 1/1 | Sales issue | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALE_12` | 1/1 | 1/1 | Sales issue | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SALE_VER` | 1/1 | 1/1 | SALE_VER | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAMPLE_A_DATE` | 0/0 | 1/1 | A-Sample | C | 80 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAMPLE_B_DATE` | 0/0 | 1/1 | B-Sample | C | 80 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAMPLE_C_DATE` | 0/0 | 1/1 | C-Sample | C | 80 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAMPLE_D_DATE` | 0/0 | 1/1 | D-Sample | C | 80 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAT` | 1/1 | 1/1 | Sat | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `SAT_SIPM_MAX_QTY` | 1/1 | 1/1 | Max Qty(SAT) | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAT_SIPM_MIN_QTY` | 1/1 | 1/1 | Min Qty(SAT) | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SAVE_FLAG` | 1/1 | 1/1 | Save | C | 40 | FPCheckBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCM_PI_USER_ID` | 1/1 | 1/1 | 아이디 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCM_PI_USER_NAME` | 1/1 | 1/1 | 성명 | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCM_PJT_CODE` | 1/1 | 1/1 | SCM PJT Code | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCM_SITE_DESCRIPTION` | 20/10 | 20/10 | Plant Site | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCM_SITE_ID` | 108/75 | 105/68 | Sales Site | L | 120 | (공란) | FPComboBox | SiteByEndCustomer | O | 미확인(모달키 이력 없음) | high | - |
| `SCM_SITE_ID40` | 10/10 | 10/10 | Sales Site* | L | 120 | FPComboBox | FPComboBox | SiteByEndCustomer | O | 미확인(모달키 이력 없음) | high | - |
| `SCM_SITE_ID81` | 3/3 | 3/3 | Sales Site | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCM_SITE_ID82` | 3/3 | 3/3 | Sales Site | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCM_SITE_NAME` | 5/4 | 5/4 | Sales Site | L | 160 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCM_SOLUTION_USER_ID` | 1/1 | 1/1 | 아이디 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCM_SOLUTION_USER_NAME` | 1/1 | 1/1 | 성명 | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCM_VENDOR_NAME` | 1/1 | 1/1 | SCM Plant Name | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCP_EOL` | 4/4 | 4/4 | SCP EOL | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCP_EXTRA_SPEC` | 10/10 | 10/10 | Scp Extra Spec | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCP_LINE_ID` | 3/2 | 3/2 | SCP Line | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCP_OPERATION_GROUP` | 2/2 | 2/2 | Operation Group | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCP_PLAN_ID` | 9/5 | 9/5 | SCP Plan ID | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCP_PLAN_START_YYYYMMDD` | 1/1 | 1/1 | SCP Plan Date | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCP_PLAN_YN` | 1/1 | 1/1 | SCP YN | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `SCP_PRDN_PLAN_REF_END_YM` | 4/1 | 6/1 | SCP_PRDN_PLAN_REF_END_YM | R | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCP_PRDN_PLAN_REF_ST_YM` | 4/1 | 6/1 | SCP_PRDN_PLAN_REF_ST_YM | R | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCP_TARGET_ID` | 7/5 | 7/5 | SCP Demand ID | L | 300 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SCP_USE_YN` | 5/5 | 5/5 | SCP Use | L | 45 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `SCP_YN` | 2/2 | 2/2 | SCP YN | C | 40 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `SCS_PROD_AMEND` | 1/1 | 1/1 | SCS Prod Amend | C | 100 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `SEARCH` | 1/1 | 1/1 | Search | L | 50 | FPButton | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SECOND_OCV_DATE` | 1/1 | 1/1 | 2nd OCV Date | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SECOND_OCV_EXP_DATE` | 5/5 | 5/5 | Estimated aging date | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SECOND_OCV_TIME` | 1/1 | 1/1 | 2nd OCV Time | C | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEGMENT1` | 0/0 | 2/1 | Segment1 | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEGMENT2` | 0/0 | 2/1 | Segment2 | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEGMENT3` | 0/0 | 2/1 | Segment3 | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEGMENT4` | 0/0 | 2/1 | Segment4 | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEGMENT5` | 0/0 | 2/1 | Segment5 | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEL_COLUMN` | 1/1 | 1/1 | Sel Column | R | 120 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEMI_EX_COST` | 2/1 | 2/1 | 법인간 도착지 물류비 | R | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEMI_PRODUCT` | 1/1 | 1/1 | Semi-Product | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEMI_PRODUCT_CELL` | 1/1 | 1/1 | Semi-Product | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SENDER_CODE` | 2/1 | 2/1 | EDI Sender Code | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SENDER_NAME` | 8/5 | 8/5 | EDI Sender | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEND_CNT` | 1/1 | 1/1 | ERP전송 데이터 수 | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEND_MIN_TIME_TEXT` | 0/0 | 1/1 | Sub3 | C | 100 | FPComboBox | FPComboBox | MailSendCycleDetail | O | 미확인(모달키 이력 없음) | low | - |
| `SEND_TIME_TEXT` | 0/0 | 1/1 | Sub2 | C | 100 | FPComboBox | FPComboBox | MailSendCycleDetail | O | 미확인(모달키 이력 없음) | low | - |
| `SEND_YN` | 1/1 | 1/1 | Send YN | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEQ` | 38/30 | 39/31 | SEQ | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEQNO` | 0/0 | 1/1 | Seq | R | 50 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SEQ_FLAG` | 2/2 | 2/2 | SEQ_FLAG | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SESSION_ID` | 1/1 | 1/1 | session | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SETUP_ATTRIBUTE` | 4/4 | 4/4 | Setup Attribute | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SETUP_CATEGORY_ID` | 5/2 | 5/2 | Category | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SETUP_CONDITION_ID` | 2/1 | 2/1 | Condition | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SETUP_DESC` | 0/0 | 1/1 | Validation Type | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SETUP_GROUP_ID_1` | 1/1 | 1/1 | SETUP_GROUP_ID_1 | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SETUP_GROUP_ID_2` | 1/1 | 1/1 | SETUP_GROUP_ID_2 | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SETUP_GROUP_ID_3` | 1/1 | 1/1 | SETUP_GROUP_ID_3 | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SETUP_KEY_ID` | 5/2 | 5/2 | Class | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SETUP_LOSS_TIME` | 2/1 | 2/1 | Daily Average Setup Loss Time (Day:MIN) | C | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SETUP_LOSS_TIME_BIG` | 1/1 | 1/1 | Daily Average Setup Loss Time Big Data (Day:MIN) | C | 260 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SETUP_TIME` | 2/1 | 2/1 | Setup Time (MIN) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHEET_NAME` | 1/1 | 4/3 | SHEET_NAME | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_CELL_INSPECTION_LOAD` | 1/1 | 1/1 | Inspection/Load | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_CELL_INSPECTION_WAITING` | 1/1 | 1/1 | Waiting | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_CELL_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_CONFIRM_QTY` | 16/13 | 16/13 | Shipment Qty* | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_COUNT` | 2/2 | 2/2 | Shipment 개수 | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_DATE` | 18/15 | 18/15 | Shipment Date | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_DATE_CHANGE` | 1/1 | 1/1 | Shipment Date Change | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_INSPECTION_LOAD_SUM` | 1/1 | 1/1 | Inspection/Load | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_INSPECTION_WAITING_SUM` | 1/1 | 1/1 | Waiting | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_NO` | 8/5 | 8/5 | Shipment No | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_PACK_INSPECTION_LOAD` | 1/1 | 1/1 | Inspecton/Load | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_PACK_INSPECTION_WAITING` | 1/1 | 1/1 | Waiting | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_PACK_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_PIC_USER` | 1/1 | 1/1 | Model PIC | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_QTY` | 1/1 | 1/1 | Qty* | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_REQUESTOR` | 1/1 | 1/1 | Shipment Requestor | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_SITE` | 1/1 | 1/1 | Shipment Site | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPMENT_STATUS` | 13/13 | 13/13 | Status | L | 70 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | high | - |
| `SHIPMENT_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPPING_COMPANY` | 1/1 | 1/1 | Forwarder* | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPPING_PLAN_QTY` | 1/1 | 1/1 | Shipping Plan Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPTO_CITY_NAME` | 5/5 | 5/5 | Ship-To City | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPTO_CODE` | 21/18 | 25/18 | Rep Ship-To | L | 100 | (공란) | FPModal | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | low | - |
| `SHIPTO_COUNTRY` | 2/2 | 2/2 | ShipToCountry | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPTO_DESCRIPTION` | 29/27 | 30/25 | Ship To Party | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPTO_NAME` | 4/3 | 4/3 | Ship to Name | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIPTO_REGION_NAME` | 5/5 | 5/5 | Ship-To Region | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIP_DATE` | 4/4 | 4/4 | Ship Date* | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIP_DOC_PREPARATION_DATE` | 1/1 | 1/1 | Shipping Document Preparation Date | R | 120 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIP_FROZEN` | 22/15 | 22/15 | SHIP_FROZEN | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIP_IN_QTY` | 2/2 | 2/2 | QTY | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIP_PLAN_AUTO` | 2/2 | 3/2 | Ship Plan Auto | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `SHIP_PORT_DAY` | 1/1 | 1/1 | Closing | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIP_QTY` | 4/4 | 4/4 | Ship Qty* | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIP_TO` | 3/3 | 3/3 | Ship to | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIP_TO_PARTY` | 1/1 | 1/1 | Ship To Party | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIP_TYPE` | 6/6 | 6/6 | Ship Type | C | 150 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHIP_WEEK` | 2/2 | 2/2 | Ship Week | C | 94 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHOP_GROUP_ID` | 13/9 | 13/9 | Shop Group | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHOP_GROUP_NAME` | 2/1 | 2/1 | Shop Group | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHOP_TYPE` | 2/2 | 2/2 | Shop | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHORTAGE_DATE` | 1/1 | 1/1 | Shortage Date(BOH : Mat.+Prod.) | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHORTER_LEAD_TIME` | 2/2 | 2/2 | Shorter L/T | R | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHORTER_LT` | 2/2 | 2/2 | Change L/T (day) | C | 110 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SHT_NM` | 0/0 | 2/2 | Sheet Name | L | 120 | (공란) | FPComboBox | SheetList | O | 미확인(모달키 이력 없음) | low | - |
| `SIDE_TYPE` | 1/1 | 1/1 | SIDE_TYPE | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SIGNAL` | 1/1 | 1/1 | Signal | C | 65 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SIPM_MAX_QTY` | 1/1 | 1/1 | Max Qty* | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SIPM_MIN_QYT` | 1/1 | 1/1 | Min Qty* | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SITE` | 2/2 | 2/2 | Site | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SITE_DESCRIPTION` | 29/21 | 30/21 | Plant Site | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SITE_ID` | 218/124 | 231/125 | Site | C | 80 | FPTextBox | FPComboBox | CapaSite | X | 미확인(모달키 이력 없음) | high | - |
| `SITE_ITEM_VALID_YN` | 1/1 | 1/1 | Site Item Valid | C | 100 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `SITE_NAME` | 29/10 | 41/11 | Site Name | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SITE_VALID_YN` | 1/1 | 1/1 | Site Active* | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `SI_ALT_PRIORITY` | 1/1 | 1/1 | Simulator Alt Priority | C | 70 | FPComboBox | FPComboBox | SEQ_NUMBER | X | 미확인(모달키 이력 없음) | medium | - |
| `SI_SCP_YN` | 1/1 | 1/1 | Simulator SCP YN | C | 70 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `SLIT_WIDTH` | 1/1 | 1/1 | Width(mm) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SLOC_ID` | 2/1 | 2/1 | SLOC_ID | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SLOC_PLANT_ID` | 2/1 | 2/1 | SLOC_PLANT_ID | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SLURRY_1` | 4/3 | 4/3 | Slurry 1 | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SLURRY_2` | 4/3 | 4/3 | Slurry 2 | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SMALL_CLASS_LABEL_NAME` | 0/0 | 2/1 | Small Label | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOC` | 11/6 | 11/6 | SOC | C | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOC_ID` | 2/2 | 2/2 | Transport | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOLDTO_CODE` | 20/19 | 23/18 | Sold-To | L | 80 | (공란) | FPModal | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | low | - |
| `SOLDTO_COUNTRY` | 2/2 | 2/2 | SoldToCountry | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOLDTO_CUSTOMER` | 17/16 | 16/13 | Sold-To Customer | L | 80 | FPComboBox | FPComboBox | SoldCustomer | O | 미확인(모달키 이력 없음) | high | - |
| `SOLDTO_CUST_REPORT` | 4/3 | 6/4 | 판매처 | L | 100 | FPComboBox | FPComboBox | SOLD_TO_CUST_REPORT | O | 미확인(모달키 이력 없음) | high | - |
| `SOLDTO_DESCRIPTION` | 23/23 | 25/22 | Sold To Party | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOLD_TO_PARTY` | 1/1 | 1/1 | Sold To Party | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOLVENT` | 4/4 | 4/4 | Solvent | L | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOON_YN_CLASSIFY` | 1/1 | 1/1 | 임박 CLASSIFY | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOON_YN_DEV` | 1/1 | 1/1 | 임박 DEV | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOON_YN_FINISH` | 1/1 | 1/1 | 임박 FINISH | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOON_YN_PRIORITY` | 1/1 | 1/1 | 임박 PRIORITY | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOON_YN_RECEIPT` | 1/1 | 1/1 | 임박 RECEIPT | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOON_YN_REVIEW` | 1/1 | 1/1 | 임박 REVIEW | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOON_YN_TEST` | 1/1 | 1/1 | 임박 TEST | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOP_DATE` | 0/0 | 6/3 | SOP Date | C | 80 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOP_DDN` | 2/1 | 3/1 | SOP_DDN | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOP_DT` | 2/1 | 3/1 | SOP | C | 80 | FPDateText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOP_PLANT_ID` | 0/0 | 6/3 | SOP Plant | L | 0 | FPComboBox | FPComboBox | PlantByDivisionCompany | O | 미확인(모달키 이력 없음) | medium | - |
| `SOP_PLANT_NAME` | 0/0 | 3/1 | SOP Plant | L | 80 | FPComboBox | FPComboBox | PlantByDivisionCompany | O | 미확인(모달키 이력 없음) | low | - |
| `SOP_YM` | 2/1 | 3/1 | SOP_YM | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SORT` | 2/1 | 2/1 | Sort | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SORT_KEY` | 2/2 | 2/2 | SORT_KEY | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SORT_ORD` | 0/0 | 4/2 | Sort Order | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SORT_ORDER` | 4/4 | 4/4 | Sort Order | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SORT_ORDER_NO` | 20/7 | 28/8 | SORT_ORDER_NO | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SORT_ORDER_NO_GR` | 6/2 | 9/2 | SORT_ORDER_NO_GR | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SOURCE_YYYYMM` | 1/1 | 1/1 | Source YYYYMM | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SPART` | 0/0 | 1/1 | ERP Div | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SPEC` | 1/1 | 1/1 | SPEC | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SPECIAL_STOCK_INDICATOR` | 1/1 | 1/1 | Special Stock Indicator | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SPECIAL_YN` | 3/2 | 3/2 | Special YN | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SPEC_VERSION` | 1/1 | 1/1 | Spec && Version | L | 65 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SPEED_BASE_PPM` | 8/1 | 11/1 | SPEED_BASE_PPM | R | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SPEED_PPM` | 8/1 | 11/1 | SPEED_PPM | R | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SPEED_UNIT_GROUP_SEQ` | 2/1 | 5/1 | SPEED_UNIT_GROUP_SEQ | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SPLAN` | 1/1 | 1/1 | 계획 | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SPLIT_YN` | 1/1 | 1/1 | Container Split* | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `SPRD` | 1/1 | 1/1 | SPRD | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SRCE_DIVIS_CD` | 0/0 | 1/1 | SRCE_DIVIS_CD | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SRCE_DIVS_CD` | 2/1 | 2/1 | SRCE_DIVS_CD | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SRCE_TP_CD` | 3/1 | 3/1 | SRCE TP CD | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SRESULT` | 1/1 | 1/1 | 실적 | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SSCM_SITE_ID` | 1/1 | 1/1 | Sales Site* | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SSO_LOCATE` | 0/0 | 1/1 | SSO Locate | C | 100 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SSP_BOH_QTY` | 1/1 | 1/1 | SSP_BOH(Hold) | R | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SSP_INCOTERMS` | 2/2 | 2/2 | SSP Incoterms | C | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SSP_MODIFY_YIELD` | 1/1 | 1/1 | User Modify Yield(%) | R | 145 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SSP_STORAGE_ID` | 1/1 | 1/1 | SSP Storage | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STACK_METHOD` | 0/0 | 5/3 | Stack Method | L | 80 | FPComboBox | FPComboBox | StackMethodByCellType | O | 미확인(모달키 이력 없음) | medium | - |
| `STACK_METHOD_NAME` | 0/0 | 2/1 | Stack Method | L | 80 | FPComboBox | FPComboBox | StackMethod | O | 미확인(모달키 이력 없음) | low | - |
| `STAGE` | 6/5 | 7/6 | Stage* | C | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STANDARD_DIO_AUTO` | 1/1 | 1/1 | Standard DIO (Include Cycle) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STANDARD_FLAG` | 2/1 | 2/1 | Standard | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STANDARD_LT` | 1/1 | 1/1 | FP L/T | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `START_DATE` | 8/5 | 9/6 | Start Date | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `START_TIME` | 5/4 | 5/4 | Start Date | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `START_YM` | 2/2 | 2/2 | Start | C | 80 | FPDateMonth | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATE_NM` | 1/1 | 2/2 | State Name | C | 200 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATUS` | 9/9 | 10/10 | Status | C | 100 | FPText | FPComboBox | STATUS | X | 미확인(모달키 이력 없음) | medium | - |
| `STATUS_ACTIVE` | 8/1 | 8/1 | Active | C | 60 | FPComboBox | FPComboBox | ALL_Y_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `STATUS_DETAIL` | 2/2 | 2/2 | Status Detail | C | 150 | FPText | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `STATUS_END` | 2/2 | 2/2 | Status End | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATUS_ERP` | 1/1 | 1/1 | Status ERP | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATUS_FLAG` | 2/2 | 2/2 | Status Flag | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATUS_GSCM` | 1/1 | 1/1 | Status GSCM | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATUS_MASS` | 8/1 | 8/1 | Plan | C | 90 | FPComboBox | FPComboBox | ALL_Y_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `STATUS_MSG` | 2/2 | 2/2 | Message | L | 260 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATUS_NAME` | 2/2 | 2/2 | Engine Running | L | 160 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATUS_NEW` | 8/1 | 8/1 | New | C | 90 | FPComboBox | FPComboBox | ALL_Y_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `STATUS_PROTOTYPE` | 8/1 | 8/1 | Prototype | C | 70 | FPComboBox | FPComboBox | ALL_Y_TYPE | X | 미확인(모달키 이력 없음) | high | - |
| `STATUS_START` | 2/2 | 2/2 | Status Start | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATUS_STEP1` | 2/2 | 2/2 | 25% | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATUS_STEP2` | 2/2 | 2/2 | 50% | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATUS_STEP3` | 2/2 | 2/2 | 75% | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STATUS_STEP4` | 2/2 | 2/2 | 100% | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STEELCRATE_PER_CUT` | 1/1 | 1/1 | Steelcrate/Cut* | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STEELRACK_PER_CUT` | 1/1 | 1/1 | Steelrack/Cut* | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK` | 1/1 | 1/1 | 잔고(실적 기준) | R | 110 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK2` | 1/1 | 1/1 | 잔고(실적+계획 기준) | R | 150 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK_EXCEPTION` | 1/1 | 1/1 | Stock Exception | C | 70 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `STOCK_PLAN_LOT_ID` | 6/6 | 6/6 | Stock Plan Lot Id | L | 400 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK_POINT` | 1/1 | 1/1 | Storage | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK_QTY` | 10/6 | 10/6 | Stock Qty | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK_STATUS` | 15/11 | 15/11 | Inventory Status | C | 100 | FPComboBox | FPComboBox | LookupCommon3 | X | 미확인(모달키 이력 없음) | high | - |
| `STOCK_SUM` | 1/1 | 1/1 | STOCK SUM | C | 100 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `STOCK_TYPE` | 11/8 | 11/8 | Stock Type | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK_TYPE_CPY` | 4/4 | 4/4 | Stock type | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK_TYPE_NAME` | 3/1 | 3/1 | Stock Type* | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK_VERSION0` | 2/2 | 2/2 | .. | R | 32 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK_VERSION1` | 2/2 | 2/2 | .. | R | 32 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK_VERSION2` | 2/2 | 2/2 | .. | R | 32 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK_VERSION3` | 2/2 | 2/2 | .. | R | 32 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOCK_VERSION4` | 2/2 | 2/2 | .. | R | 32 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STORAGE_DESC` | 2/2 | 2/2 | S.Loc Description | L | 110 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STORAGE_DESCRIPTION` | 6/5 | 7/6 | Storage | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STORAGE_ID` | 31/19 | 31/19 | Storage | C | 80 | (공란) | FPComboBox | StorageID | X | 미확인(모달키 이력 없음) | medium | - |
| `STORAGE_LOCATION` | 2/2 | 2/2 | Storage Location | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STORAGE_PLANT_ID` | 1/1 | 1/1 | PLANT_SITE* | C | 80 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOR_LOC` | 1/1 | 1/1 | Storage Loc | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOR_LOC_NAME` | 1/1 | 1/1 | Storage Loc | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STOR_PER` | 1/1 | 1/1 | Storage Per* | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `STRATEGY_MODEL_FLAG` | 1/1 | 1/1 | Strategic Model | C | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUB_LANE_QTY` | 1/1 | 1/1 | Sub | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUB_MODULE` | 0/0 | 1/1 | Sub Module | C | 90 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUB_MODULE_CODE` | 0/0 | 1/1 | Sub Module * | C | 110 | FPComboBox | FPComboBox | MailSubModule | O | 미확인(모달키 이력 없음) | low | - |
| `SUB_POPUP_OPTION1` | 0/0 | 1/1 | Sub1 | C | 90 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUB_POPUP_OPTION2` | 0/0 | 1/1 | Sub2 | C | 70 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUCCESS` | 1/1 | 1/1 | 정상 | C | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUCCESS_CNT` | 0/0 | 1/1 | SUCCESS_CNT | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUCCESS_YN` | 0/0 | 1/1 | import success | L | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUM` | 3/3 | 3/3 | ⓑ(SUM) | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUMMARY_BUCKET_TYPE` | 4/2 | 2/1 | Bucket Type* | L | 0 | FPComboBox | FPComboBox | BucketType | O | 미확인(모달키 이력 없음) | high | - |
| `SUM_03` | 1/1 | 1/1 | ⓑ(SUM) | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUM_06` | 1/1 | 1/1 | ⓑ(SUM) | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUM_12` | 1/1 | 1/1 | ⓑ(SUM) | R | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUN` | 1/1 | 1/1 | Sun | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `SUN_SIPM_MAX_QTY` | 1/1 | 1/1 | Max Qty(SUN) | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUN_SIPM_MIN_QTY` | 1/1 | 1/1 | Min Qty(SUN) | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUPPLIER` | 1/1 | 1/1 | Supplier | L | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUPPLIER_CODE` | 3/3 | 3/3 | Supplier Code | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUPPLIER_NAME` | 4/4 | 4/4 | Supplier Name | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUPPLY_ISSUE` | 2/2 | 2/2 | Supply Issue | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUPPLY_ISSUE_03` | 1/1 | 1/1 | Supply Issue | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUPPLY_ISSUE_06` | 1/1 | 1/1 | Supply Issue | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUPPLY_ISSUE_12` | 1/1 | 1/1 | Supply Issue | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUPPLY_SITE` | 1/1 | 1/1 | Supply Site | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `SUPPLY_SITE_DESC` | 1/1 | 1/1 | Supply Site Desc | L | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `S_ROW` | 2/2 | 2/2 | S Row | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `S_VALID_YN` | 1/1 | 1/1 | S_VALID_YN | C | 65 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `S_VALUE_YN` | 2/2 | 2/2 | S_VALUE_YN | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `T0_SITE_DESCRIPTION` | 3/3 | 3/3 | To Site | L | 65 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TABLE_DIV0` | 0/0 | 1/1 | TABLE_DIV0 | L | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TABLE_DIV1` | 0/0 | 1/1 | TABLE_DIV1 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TABLE_DIV2` | 0/0 | 1/1 | TABLE_DIV2 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TACT_TIME` | 4/1 | 4/1 | Tact Time* | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TACT_TIME_END_DATE` | 1/1 | 1/1 | End Date* | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TACT_TIME_FLAG` | 2/2 | 2/2 | Tact Time Flag | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TACT_TIME_START_DATE` | 1/1 | 1/1 | Start Date* | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TARGET_CELL` | 2/2 | 2/2 | Target Cell | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TARGET_ID` | 2/2 | 2/2 | TARGET_ID | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TARGET_YN` | 2/2 | 2/2 | Target YN | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TAT` | 3/2 | 3/2 | Value | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TAT_UOM` | 3/2 | 3/2 | UOM | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEAM` | 9/7 | 9/7 | Team | L | 180 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEAM_EDIT_FLAG` | 2/2 | 2/2 | Team Edit Flag | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEAM_ID` | 8/8 | 6/6 | Team | L | 80 | FPComboBox | FPComboBox | TeambyDivision | O | 미확인(모달키 이력 없음) | high | - |
| `TEAM_LEADER` | 2/2 | 2/2 | Team Leader | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEAM_LEADER_NAME` | 2/2 | 2/2 | Team Leader Name | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEAM_NAME` | 11/7 | 13/7 | Team | C | 80 | (공란) | FPModal | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `TEAM_NAME_KO` | 17/11 | 17/11 | Team | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEMP` | 3/2 | 3/2 | TEMP | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEMPCOLUMN` | 2/2 | 2/2 | TEMPCOLUMN | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEST_DATE` | 1/1 | 1/1 | 완료예정일(최초) 완료예정일(변경) 완료일 | C | 110 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEST_STATUS` | 1/1 | 1/1 | 상태 | C | 60 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `TEST_TARGET_ID` | 2/1 | 2/1 | Test Target ID | C | 300 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEST_USER_ID` | 1/1 | 1/1 | 작업자 | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEXT` | 3/3 | 3/3 | Text* | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TEXT4082` | 1/1 | 1/1 | Text | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `THEORY_STOCK_QTY` | 1/1 | 1/1 | Theory Stock(Batch) | R | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `THREE_SEGMENT_COST` | 1/1 | 1/1 | Delivery Cost | R | 80 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `THU` | 1/1 | 1/1 | Thu | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `TIME_ADJUST` | 2/2 | 2/2 | Sales Allocation | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TIME_ADJUST_03` | 1/1 | 1/1 | Sales Allocation | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TIME_ADJUST_06` | 1/1 | 1/1 | Sales Allocation | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TIME_ADJUST_12` | 1/1 | 1/1 | Sales Allocation | R | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TMZ_CD` | 0/0 | 2/2 | Time Zone | C | 200 | FPComboBox | FPComboBox | TimeZone | O | 미확인(모달키 이력 없음) | medium | - |
| `TOLERANCE` | 3/2 | 3/2 | Value | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOLERANCE_UOM` | 3/2 | 3/2 | UOM | C | 80 | FPComboBox | FPComboBox | TOLERANCE_UOM | X | 미확인(모달키 이력 없음) | medium | - |
| `TOP_COATING_QTY2` | 1/1 | 1/1 | Top Coating | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOP_ITEM_ID` | 40/33 | 41/33 | Model | L | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOP_ITEM_ID_NICK` | 1/1 | 2/2 | Nick Name | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOTAL` | 5/5 | 5/5 | Total | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOTAL_CAPACITY` | 0/0 | 1/1 | Total Capacity(kWh) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOTAL_CELL_QTY` | 1/1 | 1/1 | Total | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOTAL_CHG_LT` | 1/1 | 1/1 | Total L/T (change) | C | 110 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOTAL_CNT` | 0/0 | 1/1 | TOTAL_CNT | L | 30 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOTAL_LT` | 2/2 | 2/2 | Total L/T | C | 110 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOTAL_QTY` | 9/8 | 9/8 | Total Qty | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOTAL_QTY_PCM` | 2/2 | 2/2 | Pancake M | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOTAL_QTY_UOM` | 2/2 | 2/2 | UOM | R | 75 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOTAL_YIELD` | 1/1 | 1/1 | DW | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOT_BOH_JR` | 1/1 | 0/0 | J/R | C | 60 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOT_BOH_QTY` | 2/2 | 2/2 | BOH | R | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOT_BOH_QTY_CELL` | 2/2 | 2/2 | BOH | R | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TOT_BOH_QTY_PCM` | 2/2 | 2/2 | BOH | R | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_ACTUAL_CAPACITY` | 2/1 | 2/1 | To Actual Capacity | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_BOH_QTY` | 5/5 | 5/5 | BOH (To Site) | R | 40 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_CITY` | 15/13 | 16/13 | To City | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_CITY_NAME` | 1/1 | 1/1 | City Name | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_COUNTRY` | 8/8 | 8/8 | To Country | R | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_DATE` | 4/2 | 4/2 | To Date* | C | 80 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_EXPC_DT` | 0/0 | 1/1 | YYYYMMDD* | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_EXPC_QTY` | 2/1 | 2/1 | Qty* | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_FACTORY_ID` | 3/3 | 3/3 | To Building* | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_ITEM_SETUP_GROUP_ID` | 1/1 | 1/1 | To Setup Group | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_ITEM_SETUP_GROUP_NAME` | 1/1 | 1/1 | To Setup Group Nick Name | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_OPERATION_ID` | 3/3 | 3/3 | To Operation* | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_OPERATION_NAME` | 1/1 | 1/1 | To Operation Name | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_PERIOD1` | 1/1 | 1/1 | Ni | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_PERIOD2` | 1/1 | 1/1 | Co | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_PERIOD3` | 1/1 | 1/1 | Li2CO3 | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_PERIOD4` | 1/1 | 1/1 | LIOH | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_PERIOD5` | 1/1 | 1/1 | Al | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_PERIOD6` | 1/1 | 1/1 | Mn | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_PERIOD7` | 1/1 | 1/1 | Cu | R | 50 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_PLANT_ID` | 6/5 | 6/5 | To Plant | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_PLANT_NAME` | 1/1 | 1/1 | Ship to Plant Name | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_PRODUCT` | 1/1 | 1/1 | To Product | L | 90 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_SCM_SITE_ID` | 4/3 | 4/3 | Sales Site | L | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_SCM_SITE_ID_ORG` | 1/1 | 1/1 | To Site Org | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_SITE` | 82/49 | 83/50 | To Site | L | 100 | (공란) | FPComboBox | ToSiteByDivision | X | 미확인(모달키 이력 없음) | high | - |
| `TO_SITE_CODE` | 3/3 | 4/3 | To Site | L | 140 | FPComboBox | FPComboBox | ToSiteByDivision | X | 미확인(모달키 이력 없음) | high | - |
| `TO_SITE_DESCRIPTION` | 32/28 | 32/28 | To Site | L | 130 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_SITE_ID` | 8/7 | 8/7 | To Site | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_SITE_NAME` | 9/8 | 9/8 | To Site | L | 65 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_SITE_SHIPTO_CODE` | 4/4 | 4/4 | Ship to | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_SITE_SOLDTO_CODE` | 4/4 | 4/4 | Sold to | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_STE_ID` | 1/1 | 1/1 | To Site* | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_VALID_YYYYMMDD` | 0/0 | 1/1 | VALID TO* | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TO_YYYYMMDD` | 34/33 | 34/33 | to_yyyymmdd | C | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRANSFER_FLAG` | 1/1 | 1/1 | Transfer Flag | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRANSFER_LOT_SIZE` | 2/1 | 2/1 | Value | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRANSFER_LOT_SIZE_UOM` | 2/1 | 2/1 | UOM | C | 80 | FPComboBox | FPComboBox | TRANSFER_LOT_SIZE_UOM | X | 미확인(모달키 이력 없음) | medium | - |
| `TRANSPORT_MODE` | 63/45 | 63/44 | Trans Mode | C | 50 | (공란) | FPComboBox | TransportMode | X | 미확인(모달키 이력 없음) | high | - |
| `TRANSPORT_MODE_LINE` | 7/5 | 7/5 | Trans Mode or Line | L | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRANSPORT_PRIORITY` | 1/1 | 1/1 | Priority | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRANSPORT_TIME` | 2/2 | 2/2 | Value* | R | 150 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRANSPORT_TIME_UOM` | 2/2 | 2/2 | UOM | C | 150 | FPComboBox | FPComboBox | TRANSPORT_TIME_UOM | X | 미확인(모달키 이력 없음) | medium | - |
| `TRANS_MODE` | 3/2 | 3/2 | Trans Mode | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRANS_MODE_CHANGE` | 1/1 | 1/1 | Trans Mode Change | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRANS_MODE_CODE` | 1/1 | 1/1 | Trans Mode | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRANS_MODE_NAME` | 1/1 | 1/1 | Trans Mode | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRAN_STATUS` | 1/1 | 1/1 | TRAN_STATUS | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRAY_FACTORY_ID` | 1/1 | 1/1 | Tray Bld. | C | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRAY_ID` | 2/2 | 2/2 | Tray ID | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRAY_NAME` | 3/3 | 3/3 | Tray Name | C | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRAY_OP_STATUS` | 1/1 | 1/1 | Tray Operation Status | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TRAY_TYPE` | 3/3 | 3/3 | Tray Type | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TR_MODE` | 15/9 | 15/9 | Trans Mode* | C | 50 | (공란) | FPComboBox | TransportMode | X | 미확인(모달키 이력 없음) | high | - |
| `TTL` | 2/2 | 2/2 | TTL | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TTL1` | 2/2 | 2/2 | TTL1 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TTL12` | 1/1 | 1/1 | TTL12 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TTL2` | 2/2 | 2/2 | TTL2 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TTL3` | 2/2 | 2/2 | TTL3 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TTL4` | 2/2 | 2/2 | TTL4 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TTL45` | 1/1 | 1/1 | TTL45 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TTL5` | 2/2 | 2/2 | TTL5 | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TTL_INCOTERMS` | 1/1 | 1/1 | TTL(Incoterms) | R | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TUE` | 1/1 | 1/1 | Tue | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `TWO_SEGMENT_COST` | 1/1 | 1/1 | Freight Cost | R | 80 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TYPE` | 17/12 | 17/12 | Status | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `TYPE_APPLY_DAY` | 1/1 | 2/2 | Day* | R | 45 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `T_DEPARTMENT_ID` | 1/1 | 1/1 | Department* | L | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | 텍스트측↔DEPARTMENT_ID |
| `T_DEPARTMENT_NAME` | 1/1 | 1/1 | Department Name | C | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `T_DEPT_ID` | 1/1 | 1/1 | Team | L | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | 텍스트측↔DEPT_ID |
| `T_DEPT_NAME` | 1/1 | 1/1 | Team Name | C | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UI_COLOR` | 1/1 | 1/1 | Color | 미확인(정렬코드 이력 없음) | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UI_DESC` | 1/1 | 1/1 | Desciption | 미확인(정렬코드 이력 없음) | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UI_UPD_YN` | 2/1 | 5/1 | Dummy | L | 0 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `UNDECIDED_QTY` | 8/5 | 8/5 | Undecided Qty | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNHOLD_EXP_DATE` | 1/1 | 1/1 | Unhold Exp Date | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNINSPECTED_BOH_QTY` | 1/1 | 1/1 | Uninspected | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNINSPECTED_FLAG` | 1/1 | 1/1 | Uninspected Flag | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNINSPECTED_QTY` | 1/1 | 1/1 | Uninspected | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNINSPEC_BOH_QTY` | 1/1 | 1/1 | Uninspected | R | 78 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNIT` | 7/6 | 7/6 | Unit | C | 40 | FPTextBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `UNIT_CURRENCY` | 1/1 | 2/2 | UNIT Currency | L | 80 | FPComboBox | FPComboBox | DMF0041_MDF_Currency | O | 미확인(모달키 이력 없음) | medium | - |
| `UNIT_ENERGY` | 3/3 | 3/3 | Energy | L | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNIT_ID` | 0/0 | 1/1 | Name | 미확인(정렬코드 이력 없음) | 180 | FPComboBox | FPComboBox | MyDivision | O | 미확인(모달키 이력 없음) | low | - |
| `UNIT_PRICE` | 5/4 | 5/4 | Unit Price | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNIT_PRICE_KRW` | 5/4 | 5/4 | Unit Price(KRW) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNIT_PRICE_KRW_XLS` | 5/4 | 5/4 | Unit Price(KRW) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNIT_PRICE_XLS` | 5/4 | 5/4 | Unit Price | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNIT_TP_CD` | 0/0 | 1/1 | Auth Unit | C | 100 | FPComboBox | FPComboBox | UnitType | O | 미확인(모달키 이력 없음) | low | - |
| `UNLOADING_POINT` | 3/3 | 4/3 | Unloading Point | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNPLAN_CNT` | 1/1 | 1/1 | Count | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNPLAN_QTY` | 1/1 | 1/1 | Quantity | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNPLAN_RATIO` | 1/1 | 1/1 | Ratio(%) | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UNRESTRICTED_QTY` | 2/2 | 2/2 | Unrestricted Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UOM` | 17/12 | 17/12 | UOM | C | 30 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UOM_CONVERT_IN_TACT_TIME` | 1/1 | 1/1 | Pancake (m/cell) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UOM_CONVERT_VALUE` | 2/1 | 2/1 | UOM Convert | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UOM_ID` | 1/1 | 1/1 | UOM | C | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UPDATED_BY` | 11/11 | 11/11 | Updated By | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UPDATED_DATE` | 10/10 | 10/10 | Updated Date | L | 130 | FPDateTime | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UPDATE_DATE` | 3/3 | 3/3 | UPDATE_DATE | C | 170 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UPDATE_ID` | 24/24 | 24/24 | Update ID | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UPDATE_PSN_ID` | 1/1 | 1/1 | UPDATE_PSN_ID | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UPDATE_TIME` | 24/24 | 24/24 | Update Time | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UPDATE_YN` | 0/0 | 1/1 | Update YN | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `UPLOAD_BUCKET_TYPE` | 4/2 | 2/1 | Upload Bucket Type* | L | 55 | FPComboBox | FPComboBox | BucketType | O | 미확인(모달키 이력 없음) | high | - |
| `UPLOAD_ORDER` | 2/2 | 1/1 | UPLOAD ORDER | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `UPLOAD_UOM` | 4/2 | 3/2 | Upload UOM* | L | 60 | FPComboBox | FPComboBox | UploadUOM | O | 미확인(모달키 이력 없음) | high | - |
| `UPPERCASE_APPLY_FLAG` | 0/0 | 2/1 | Uppercase Apply | C | 80 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `UPPER_DEPT_ID` | 5/5 | 3/3 | Department | L | 80 | FPComboBox | FPComboBox | UpperDeptId | O | 미확인(모달키 이력 없음) | high | - |
| `UPPER_DEPT_NAME_KO` | 1/1 | 0/0 | Department | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USAGE` | 1/1 | 1/1 | Usage | R | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USD_AMT` | 1/1 | 1/1 | EOH Amount (USD) | R | 0 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USELESS_QTY` | 1/1 | 1/1 | Process delayed | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER ID` | 1/1 | 1/1 | User ID | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER NAME` | 1/1 | 1/1 | User Name | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USERID` | 2/1 | 2/1 | User ID | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USERNAME` | 2/1 | 2/1 | User Name | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ADD_QTY` | 2/2 | 2/2 | Before Input Qty | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_CHARACTERIZATION_YIELD` | 1/1 | 1/1 | Yield | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_CHARACTERIZATION_YIELD_BACKGROUND` | 1/1 | 1/1 | CHARACTERIZATION_YIELD_BACKGROUND | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_CHARACTERIZATION_YIELD_BACKGROUND2` | 1/1 | 1/1 | CHARACTERIZATION_YIELD_BACKGROUND2 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_CHARACTERIZATION_YIELD_EDITTYPE` | 1/1 | 1/1 | CHARACTERIZATION_YIELD_EDITTYPE | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_COUNT` | 0/0 | 1/1 | Users | L | 0 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_DEGAS_YIELD` | 1/1 | 1/1 | Yield | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_DEGAS_YIELD_BACKGROUND` | 1/1 | 1/1 | DEGAS_YIELD_BACKGROUND | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_DEGAS_YIELD_BACKGROUND2` | 1/1 | 1/1 | DEGAS_YIELD_BACKGROUND2 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_DEGAS_YIELD_EDITTYPE` | 1/1 | 1/1 | DEGAS_YIELD_EDITTYPE | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_EML` | 0/0 | 2/2 | Email | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ENG_NM` | 0/0 | 4/4 | English Name | L | 160 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_FORMATION1_YIELD` | 1/1 | 1/1 | Yield | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_FORMATION1_YIELD_BACKGROUND` | 1/1 | 1/1 | FORMATION1_YIELD_BACKGROUND | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_FORMATION1_YIELD_BACKGROUND2` | 1/1 | 1/1 | FORMATION1_YIELD_BACKGROUND2 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_FORMATION1_YIELD_EDITTYPE` | 1/1 | 1/1 | FORMATION1_YIELD_EDITTYPE | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_FORMATION2_YIELD` | 1/1 | 1/1 | Yield | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_FORMATION2_YIELD_BACKGROUND` | 1/1 | 1/1 | FORMATION2_YIELD_BACKGROUND | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_FORMATION2_YIELD_BACKGROUND2` | 1/1 | 1/1 | FORMATION2_YIELD_BACKGROUND2 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_FORMATION2_YIELD_EDITTYPE` | 1/1 | 1/1 | FORMATION2_YIELD_EDITTYPE | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_GRADE_YIELD` | 1/1 | 1/1 | Yield | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_GRADE_YIELD_BACKGROUND` | 1/1 | 1/1 | GRADE_YIELD_BACKGROUND | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_GRADE_YIELD_BACKGROUND2` | 1/1 | 1/1 | GRADE_YIELD_BACKGROUND2 | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_GRADE_YIELD_EDITTYPE` | 1/1 | 1/1 | GRADE_YIELD_EDITTYPE | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_GRAD_CODE` | 1/1 | 1/1 | User Grade | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_GR_ID` | 0/0 | 7/4 | Group ID | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_GR_NM` | 0/0 | 5/4 | Authority | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_HPHN` | 0/0 | 1/1 | Cell Phone | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID` | 17/11 | 27/18 | User ID | C | 80 | (공란) | FPModal | 미확인(콤보 배정 이력 없음) | - | UserMgmt | medium | - |
| `USER_ID_1` | 4/4 | 4/4 | USER_ID_1 | C | 10 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID_10` | 4/4 | 4/4 | USER_ID_10 | C | 10 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID_2` | 4/4 | 4/4 | USER_ID_2 | C | 10 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID_3` | 4/4 | 4/4 | USER_ID_3 | C | 10 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID_4` | 4/4 | 4/4 | USER_ID_4 | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID_5` | 4/4 | 4/4 | USER_ID_5 | C | 10 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID_6` | 4/4 | 4/4 | USER_ID_6 | C | 10 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID_7` | 4/4 | 4/4 | USER_ID_7 | C | 10 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID_8` | 4/4 | 4/4 | USER_ID_8 | C | 10 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID_82` | 1/1 | 1/1 | Owner(Sales)* | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID_9` | 4/4 | 4/4 | USER_ID_9 | C | 10 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_ID_ALTER` | 1/1 | 1/1 | User ID | C | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_MOD_RELEASE_DATE` | 3/2 | 3/2 | User Modified Release Date* | C | 100 | FPDate | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME` | 11/7 | 21/12 | User Name | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME_1` | 1/1 | 1/1 | User Name 1 | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME_10` | 1/1 | 1/1 | User Name 10 | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME_2` | 1/1 | 1/1 | User Name 2 | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME_3` | 1/1 | 1/1 | User Name 3 | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME_4` | 1/1 | 1/1 | User Name 4 | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME_5` | 1/1 | 1/1 | User Name 5 | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME_6` | 1/1 | 1/1 | User Name 6 | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME_7` | 1/1 | 1/1 | User Name 7 | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME_8` | 1/1 | 1/1 | User Name 8 | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME_9` | 1/1 | 1/1 | User Name 9 | C | 100 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NAME_EN` | 2/1 | 3/2 | User Name(Eng) | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_NM` | 0/0 | 5/5 | User Name | L | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_POP_BTN` | 0/0 | 1/1 | Search | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USER_SELECTABLE_FLAG` | 2/1 | 2/1 | USER_SELECTABLE_FLAG | C | 0 | (공란) | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `USER_TOTAL_YIELD` | 1/1 | 1/1 | Yield | R | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USE_AT_FLAG` | 2/1 | 2/1 | Use | C | 70 | FPCheckBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USE_CELL_CF_BOM` | 2/2 | 2/2 | Use CELL CF BOM | C | 140 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USE_FLAG` | 3/2 | 3/2 | Use* | C | 50 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `USE_TYPE_CODE` | 0/0 | 3/1 | Use Type | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `USE_YN` | 3/3 | 12/10 | Active | C | 80 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `UTIL_RT` | 1/1 | 1/1 | Utilization Rate(%)* | R | 130 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VAILD_YN` | 0/0 | 1/1 | Vaild* | C | 60 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | low | - |
| `VALID` | 6/2 | 6/2 | Valid | C | 60 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `VALIDATION_TYPE` | 2/2 | 3/3 | Validation Type | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VALID_END_DATE` | 1/1 | 2/1 | Valid To | C | 65 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VALID_START_DATE` | 1/1 | 2/1 | Valid From | C | 65 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VALID_YN` | 74/44 | 81/42 | Valid | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `VALTAGE` | 2/1 | 2/1 | Valtage | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VALUATION_CLASS` | 5/4 | 5/4 | Valuation class | C | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VALUATION_TYPE` | 1/1 | 1/1 | Valuation Type | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VALUE` | 1/1 | 1/1 | Value | R | 200 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VALUE1` | 1/1 | 1/1 | Elec Stock  (Pancake) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VALUE2` | 1/1 | 1/1 | Elec Stock  (Assy) | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VALUE_DESCRIPTION` | 9/7 | 9/7 | Description | L | 300 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VALUE_TYPE` | 4/4 | 5/5 | Type* | C | 70 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VALUE_YN` | 0/0 | 1/1 | Value Y/N | C | 80 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VAL_TP_CD` | 1/1 | 1/1 | Type | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VARIABLE_DATE` | 1/1 | 1/1 | Variable Date | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VARIABLE_QTY` | 1/1 | 1/1 | Variable Qty | R | 60 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VARIATION_FACTOR` | 1/1 | 1/1 | 상세변동요인 | C | 120 | FPComboBox | FPComboBox | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | medium | - |
| `VARIOUS_KEY` | 1/1 | 2/2 | Trans Mode or Line or Project | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VD_FIRST_TEST_WO` | 2/2 | 2/2 | VD First Test W/O | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VENDOR_CODE` | 3/2 | 3/2 | Vendor Code | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VENDOR_NAME` | 3/2 | 3/2 | Vendor Name | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VER` | 0/0 | 24/5 | Ver | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VERSION` | 39/30 | 39/30 | Version | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VERSION_DESCRIPTION` | 4/4 | 4/4 | Description | C | 300 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VERSION_ID` | 5/4 | 5/4 | Version | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VERSION_NM` | 1/1 | 2/1 | Version | L | 200 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VERSION_NO` | 23/21 | 21/19 | Version | L | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VERSION_TYPE` | 8/6 | 8/6 | Type | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VERSION_YN` | 1/1 | 1/1 | Version Y/N | C | 60 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VER_CRE_SEQ` | 1/1 | 1/1 | Seq | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VER_ID` | 21/5 | 23/5 | Ver | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VER_SEQ` | 23/6 | 36/6 | Seq | L | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VIEW` | 1/1 | 2/2 | 세부내역 | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VIEW_FLAG` | 1/1 | 1/1 | VIEW_FLAG | C | 100 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `VIRTUAL_FACTORY_EDIT_YN` | 1/1 | 1/1 | Factory Edit Y/N | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VIRTUAL_LINE_YN` | 1/1 | 1/1 | Virtual Line Y/N | C | 100 | FPComboBox | FPComboBox | YesNo | X | 미확인(모달키 이력 없음) | medium | - |
| `VISIBLE_FLAG` | 0/0 | 1/1 | Visible | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | low | - |
| `VMI_ATA` | 4/2 | 4/2 | 허브 ATA | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VMI_ATD` | 4/2 | 4/2 | 허브 ATD | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VMI_CELL` | 1/1 | 1/1 | Cell | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VMI_ETA` | 1/1 | 1/1 | 허브 ETA | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VMI_ETD` | 1/1 | 1/1 | 허브 ETD | C | 60 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VMI_LT` | 4/4 | 5/4 | VMI_LT | R | 50 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VMI_PACK` | 1/1 | 1/1 | Pack | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VMI_STD_DIO` | 1/1 | 2/2 | VMI_STD_DIO | C | 0 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VMI_SUM` | 1/1 | 1/1 | SUM | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VMI_YN` | 18/18 | 19/17 | VMI | L | 45 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | high | - |
| `VOC_DETAIL` | 1/1 | 1/1 | 세부내역 | L | 380 | FPMultiLineTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VOC_DETAIL_BUTTON` | 1/1 | 1/1 | VIEW | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VOC_NAME` | 1/1 | 1/1 | 과제명 | L | 250 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VOC_NO` | 1/1 | 1/1 | No | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `VOC_TYPE` | 1/1 | 1/1 | 구분 | L | 70 | FPComboBox | FPComboBox | LookupCommon | X | 미확인(모달키 이력 없음) | medium | - |
| `VOYAGE_DAY` | 1/1 | 1/1 | Voyage | R | 70 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `W-1_ITEM_COUNT` | 1/1 | 1/1 | W-1_ITEM_COUNT | R | 130 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `W-2_ITEM_COUNT` | 1/1 | 1/1 | W-2_ITEM_COUNT | R | 130 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `W-3_ITEM_COUNT` | 1/1 | 1/1 | W-3_ITEM_COUNT | R | 130 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `W-4_ITEM_COUNT` | 1/1 | 1/1 | W-4_ITEM_COUNT | R | 130 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `W0` | 1/1 | 1/1 | W0 | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `W0_ITEM_COUNT` | 1/1 | 1/1 | W0_ITEM_COUNT | R | 130 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `W0_LAST_UPDATE_DATE` | 1/1 | 1/1 | W0_LAST_UPDATE_DATE | L | 150 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WED` | 1/1 | 1/1 | Wed | C | 60 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `WEEK_END_DATE` | 0/0 | 1/1 | WEEK_END_DATE | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEEK_LATE_CNT` | 1/1 | 1/1 | Count | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEEK_LATE_QTY` | 1/1 | 1/1 | Quantity | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEEK_LATE_RATIO` | 1/1 | 1/1 | Ratio(%) | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEEK_NAME` | 1/1 | 1/1 | Week* | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEEK_START_DATE` | 0/0 | 1/1 | WEEK_START_DATE | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEIGHT_CYCLE_STOCK` | 1/1 | 1/1 | Weight Cycle Stock | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEIGHT_CYCLE_TOTAL_AUTO` | 1/1 | 1/1 | Weight Cycle (Total) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEIGHT_CYCLE_TYPE_AUTO` | 1/1 | 1/1 | Weight Cycle (Type) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEIGHT_DIO_AUTO` | 1/1 | 1/1 | Weight DIO | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEIGHT_INTRANSIT_TOTAL_AUTO` | 1/1 | 1/1 | Weight Intransit (Total) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEIGHT_INTRANSIT_TYPE_AUTO` | 1/1 | 1/1 | Weight Intransit (Type) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEIGHT_OPEARTION_TOTAL_AUTO` | 1/1 | 1/1 | Weight Operation (Total) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WEIGHT_OPEARTION_TYPE_AUTO` | 1/1 | 1/1 | Weight Operation (Type) | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WH_ID` | 1/1 | 1/1 | WH ID | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WH_NAME` | 1/1 | 1/1 | WH NAME | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WH_NM` | 2/1 | 2/1 | Warehouse Name* | L | 120 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WH_TEMP_CAPA` | 1/1 | 1/1 | TEMP STOCK | R | 100 | FPNumberText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WH_TOTAL_CAPA` | 1/1 | 1/1 | TOTAL  STOCK | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WIDE_YN` | 1/1 | 1/1 | Wide Y/N* | C | 80 | FPComboBox | FPComboBox | YesOrNo | O | 미확인(모달키 이력 없음) | medium | - |
| `WIPHOLD_YN` | 9/8 | 9/8 | Wiphold Yn | C | 30 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WIPHOLD_YN_CPY` | 4/4 | 4/4 | Hold(GMES) | C | 70 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WIPQTY2_ENGINE` | 1/1 | 1/1 | FP QTY | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WIP_TYPE_CODE` | 1/1 | 1/1 | WIP Type Code | C | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WIP_UOM` | 2/2 | 2/2 | UOM | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORKER_QTY` | 1/1 | 1/1 | Worker | R | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORKING_NAME` | 0/0 | 1/1 | Working Name | L | 110 | 미확인(표시 컨트롤 이력 없음) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORKING_TIME_DEFAULT` | 2/2 | 2/2 | Working Time Default | R | 85 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_CENTER_ID` | 7/5 | 6/4 | Work Center | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_DETAIL1` | 0/0 | 1/1 | WORK_DETAIL1 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_DETAIL2` | 0/0 | 1/1 | WORK_DETAIL2 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_DETAIL3` | 0/0 | 1/1 | WORK_DETAIL3 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_DETAIL4` | 0/0 | 1/1 | WORK_DETAIL4 | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_GROUP` | 0/0 | 1/1 | WORK_GROUP | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_MODEL` | 7/6 | 7/6 | Work Sheet Model | L | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_MODEL_NAME` | 6/6 | 6/6 | Work Sheet Model Nick | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_ORDER_ID` | 12/9 | 12/9 | WO | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_ORDER_SPL_ID` | 3/2 | 3/2 | Equipment Work Order | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_REQUEST_MODEL_ID` | 13/13 | 13/13 | Work Sheet Model | C | 180 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_SHHET_MODEL` | 1/1 | 1/1 | Work Sheet Model | 미확인(정렬코드 이력 없음) | 120 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WORK_TYPE` | 0/0 | 1/1 | WORK_TYPE | L | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WOW_ID` | 2/2 | 2/2 | WOW Id | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WOW_NAME` | 2/2 | 2/2 | Activity List | L | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WO_BASE_DATE` | 1/1 | 1/1 | WO_BASE_DATE | C | 100 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WO_ID` | 1/1 | 1/1 | WO_ID | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WO_STATUS` | 5/3 | 5/3 | Status | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WO_TYPE` | 1/1 | 1/1 | WO_TYPE | C | 80 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WPP_DW_TIME` | 1/1 | 1/1 | DW Submit Time | C | 130 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WPP_DW_USER` | 1/1 | 1/1 | Submit ID | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WPP_LATEST_DW_SUBMIT_FLAG` | 1/1 | 1/1 | Latest DW Submit Flag | C | 150 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `WPP_TYPE` | 1/1 | 1/1 | WPP Type | C | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `XLS_ATTRIBUTE1` | 1/1 | 1/1 | Xls_Attribute1 | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `XLS_KEY1` | 1/1 | 1/1 | Xls_Key1 | L | 0 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `XYZ` | 0/0 | 1/1 | X1 | C | 0 | FPText | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `YEAR` | 1/1 | 1/1 | Total | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `YEAR_CELL` | 1/1 | 1/1 | Total | R | 90 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `YEILD` | 5/2 | 4/2 | Yeild(%) | R | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `YELLOW` | 1/1 | 1/1 | -3% ~ -1% or 1% ~ 3% | R | 100 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `YIELD` | 7/4 | 8/4 | Yield(%)* | R | 80 | FPNumber | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `YYYY` | 1/1 | 2/1 | Year | L | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `YYYYMM` | 12/9 | 14/10 | YY.MM | C | 80 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `YYYYMMDD` | 27/17 | 28/17 | Shipment Date | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `YYYYMMDD_LOT_ID_APPLIED_LT` | 3/2 | 3/2 | D Day(Expected) | C | 100 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `YYYYMM_VAL` | 2/2 | 2/2 | YYYYMM_VAL | C | 50 | (공란) | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `_CONFIRM_FLAG` | 1/1 | 1/1 | Confirm | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `_GPLMCHK` | 1/1 | 1/1 | 0 | C | 30 | FPCheckBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `_MES_TRANSFER_FLAG` | 1/1 | 1/1 | MES Trans | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `_MSG` | 5/5 | 5/5 | Message | L | 250 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `_QUEUE_FLAG` | 1/1 | 1/1 | Queue | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `_RELEASE_FLAG` | 1/1 | 1/1 | Release | C | 90 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `_SELECT` | 1/1 | 1/1 | _SELECT | C | 30 | FPCheckBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |
| `_VALID` | 2/2 | 2/2 | Valid | L | 50 | FPTextBox | 미확인(콤보·모달 배정 이력 없음) | 미확인(콤보 배정 이력 없음) | - | 미확인(모달키 이력 없음) | none | - |

## 2. 교대쌍 (콤보 ↔ 텍스트)

| 콤보측 | 텍스트측 | 화면 | 시트 | 라벨 | 콤보측 컨트롤 | 콤보측 VIS | 텍스트측 VIS | 원천 |
|---|---|---|---|---|---|---|---|---|
| `DEPARTMENT_ID` | `T_DEPARTMENT_ID` | DMF0049 | MDF Reports | Department* | FPComboBox | Y | Y | ASIS |
| `DEPARTMENT_ID` | `T_DEPARTMENT_ID` | DMF0049 | MDF Reports | Department* | FPComboBox | Y | N | TOBE |
| `DEPT_ID` | `T_DEPT_ID` | DMF0049 | MDF Reports | Team | FPComboBox | Y | Y | ASIS |
| `DEPT_ID` | `T_DEPT_ID` | DMF0049 | MDF Reports | Team | FPComboBox | Y | N | TOBE |

## 3. 적출 결함

| 코드 | 심각도 | 설명 | 건수 |
|---|---|---|---:|
| D1 | ERROR | 콤보인데 CELL_COMBO_DATA_TYPE 공란 → CODE 노출 | 47 |
| D10 | - | AS-IS lookup 에만 있고 FE enum 에 없는 컨트롤 → 미해석 | 0 |
| D11 | ERROR | 키(PROGRAM_ID/SHEET_NAME/COLUMN_NAME) 공란 행 — 어느 화면에도 속하지 않는 쓰레기 행 | 1 |
| D12 | WARN | CELL_COMBO_DATA_TYPE 가 지정됐으나 컨트롤이 FPComboBox 가 아니라 **소비되지 않음** | 118 |
| D13 | WARN | 모달 컬럼의 ATTRIBUTE1 에 모달키 잔존 — 구 규약(슬롯 이전 전) 잔재 | 11 |
| D14 | WARN | DIVISION_ID 가 AS-IS 보다 **축소** — 그 division 에서 컬럼이 사라짐 | 16 |
| D15 | INFO | DIVISION_ID 가 AS-IS 보다 **확장** — TO-BE 추가분, 근거 확인 대상 | 301 |
| D2 | ERROR | 콤보 SQL_ID 미등록 → 0행·CODE 노출 | 344 |
| D3 | INFO | 콤보가 @토큰 요구 — FE 전달 필요(미전달=조용한 0행) | 220 |
| D4 | ERROR | 모달 컨트롤인데 CELL_COMBO_DATA_TYPE(모달키) 공란/오값 → 선택 창 안 뜸 | 39 |
| D5 | WARN | 사전 편집표준은 모달인데 **모달 없는** 컨트롤로 등록 → 선택 창 불가 | 2 |
| D6 | - | INPUT_TP_CD 가 FE enum 밖 (MI/OI 역순 등) → 편집 불가 fallthrough | 0 |
| D7 | ERROR | HORIZONTAL_ALIGN_CODE 가 C/L/R 밖 → 좌측 fallback | 509 |
| D8 | ERROR | CELL_CONTROL_OBJECT_TYPE_CODE 가 허용값 밖 → 미해석 | 204 |
| D9 | ERROR | PK 중복 → 어느 행이 적용될지 비결정적 | 1 |

합계 — ERROR 1145 · WARN 147 · INFO 521

### 3.1 ERROR 전수

| 코드 | 화면 | 시트 | 컬럼 | 내용 |
|---|---|---|---|---|
| D1 | DMF0003 | Customer Demand Analysis | `DEMAND_OPERATION` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | DMF0003 | Customer Demand Analysis | `IMPUTATION_YN` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | DMF0003 | Customer Demand Analysis | `VARIATION_FACTOR` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP00100 | Line(FP) | `PSEUDO_FACTORY_ID` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP00100 | WIP_LEVEL | `ELECTRODE_TYPE` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP00517 | Main | `PRODUCTION_TYPE` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP00606 | Amend | `ELECTRODE_TYPE` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP00614 | Amend | `ELECTRODE_TYPE` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP00614 | Main | `ELECTRODE_TYPE` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP01820 | AddPopup | `JOB_TYPE` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP01820 | AddPopup | `VALID` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP01820 | ExceptPopup | `VALID` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP02320 | Main | `PROD_VERSION_TYPE` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP02550 | Sub | `LOT_SIZE_UOM` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP02550 | Sub | `OPERATION_LEAD_TIME_UOM` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP02550 | Sub | `TOLERANCE_UOM` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP02550 | Sub | `TRANSFER_LOT_SIZE_UOM` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FP02670 | Main | `ACTIVE_FLAG` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | FPC0100 | LineExcelPopup_WIP | `ELECTRODE_TYPE` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCM0002_MKTFCSTAdjstPopup | AdjstPopup | `NewDOM_EXP` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCM0002_MKTFCSTAdjstPopup | AdjstPopup | `NewFCSTType` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCM0002_MKTFCSTAdjstPopup | AdjstPopup | `NewINCOTERMS` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCM0002_MKTFCSTAdjstPopup | AdjstPopup | `NewPLANT_SITE_ID` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCM0002_MasterChgPopup | MasterChg Popup | `NewPLANT_SITE_ID` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0080 | Group Code Management | `SALES_VALID_YN` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0080 | Group Code Management - 81 | `SALES_VALID_YN` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0080 | Group Code Management - 81_HD | `SALES_VALID_YN` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0080 | Group Code Management - 81_HG | `SALES_VALID_YN` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0080 | Group Code Management - 81_HM | `SALES_VALID_YN` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0080 | Group Code Management - 81_ST | `SALES_VALID_YN` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0080 | Group Code Management - 81_UC | `SALES_VALID_YN` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0084 | Long Term Stock | `EXHT_TP_CD` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0084 | Long Term Stock | `OCCR_RSN_CD` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0097 | SCP BOM Elec | `SCP_YN` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0097 | SCP BOM Elec | `STOCK_SUM` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0104 | MAIN | `ELECTRODE_TYPE` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0113 | BOH Long-Term Stock | `EXHT_TP_CD` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0113 | BOH Long-Term Stock | `OCCR_RSN_CD` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0113 | Long Term Stock Management | `EXHT_TP_CD` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0113 | Long Term Stock Management | `OCCR_RSN_CD` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0115 | Policy Inv Management | `DIVISION_ID` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0115 | Policy Inv Management | `EXHT_TP_DESC` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0115 | Policy Inv Management | `OCCR_RSN_DESC` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0115 | Policy Inv Management | `PLANT_ID` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0115 | Policy Inv Management | `PLAN_TP_DESC` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0121 | PlanGroupInfoPopup | `VAILD_YN` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D1 | SCP0121 | PlanGroupInfoPopup | `VALID_YN` | 콤보 컬럼인데 CELL_COMBO_DATA_TYPE 공란 → 드롭다운 없음·CODE 노출 |
| D11 |   |   | ` ` | 키 3부 중 공란 존재 — 어느 화면에도 속하지 않는 행 |
| D2 | DMF0009 | Production | `AL_MIX_METAL_LINK_PERIOD` | CELL_COMBO_DATA_TYPE 'DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | DMF0009 | Production | `CELL_NICK` | CELL_COMBO_DATA_TYPE 'DMF_BIZ_PLAN_METAL_CELL_NICK' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | DMF0009 | Production | `CELL_PROD_SITE` | CELL_COMBO_DATA_TYPE 'CELL_PROD_SITE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | DMF0009 | Production | `CO_MIX_METAL_LINK_PERIOD` | CELL_COMBO_DATA_TYPE 'DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | DMF0009 | Production | `CU_MIX_METAL_LINK_PERIOD` | CELL_COMBO_DATA_TYPE 'DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | DMF0009 | Production | `LI2CO3_MIX_METAL_LINK_PERIOD` | CELL_COMBO_DATA_TYPE 'DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | DMF0009 | Production | `LIOH_MIX_METAL_LINK_PERIOD` | CELL_COMBO_DATA_TYPE 'DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | DMF0009 | Production | `METAL_LINK_MTD` | CELL_COMBO_DATA_TYPE 'DMF_METAL_BUCKET' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | DMF0009 | Production | `MN_MIX_METAL_LINK_PERIOD` | CELL_COMBO_DATA_TYPE 'DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | DMF0009 | Production | `NI_MIX_METAL_LINK_PERIOD` | CELL_COMBO_DATA_TYPE 'DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | DMF0010 | Production | `CELL_PROD_SITE` | CELL_COMBO_DATA_TYPE 'CELL_PROD_SITE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00100 | Line(FP) | `ACTIVE_FLAG` | CELL_COMBO_DATA_TYPE 'YesNo' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00100 | Line(FP) | `ELECTRODE_TYPE` | CELL_COMBO_DATA_TYPE 'ELECTRODE_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00100 | Line(FP) | `LINE_ATTRIBUTE1` | CELL_COMBO_DATA_TYPE 'LINE_ATTRIBUTE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00100 | Line(FP) | `LINE_LOCATION` | CELL_COMBO_DATA_TYPE 'LINE_LOCATION' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00100 | Line(FP) | `LINE_MODEL_TYPE` | CELL_COMBO_DATA_TYPE 'LINE_MODEL_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00100 | Line(FP) | `LINE_TYPE` | CELL_COMBO_DATA_TYPE 'LINE_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00100 | Line(FP) | `VIRTUAL_LINE_YN` | CELL_COMBO_DATA_TYPE 'YesNo' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00160 | BuildingBOD | `TRANSPORT_MODE` | CELL_COMBO_DATA_TYPE 'TRANSPORT_MODE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00160 | BuildingBOD | `TRANSPORT_TIME_UOM` | CELL_COMBO_DATA_TYPE 'TRANSPORT_TIME_UOM' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00510 | SCPTarget | `MARKET` | CELL_COMBO_DATA_TYPE 'DEMAND_MARKET_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00510 | SCPTarget | `PRODUCTION_TYPE` | CELL_COMBO_DATA_TYPE 'LOOKUP_CODE_TARGET' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00510 | SCPTargetChangeProdTypePopup | `PRODUCTION_TYPE` | CELL_COMBO_DATA_TYPE 'DIVISION_DEMAND_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00514 | TEST_TargetMultiPopup | `PRODUCTION_TYPE` | CELL_COMBO_DATA_TYPE 'DIVISION_DEMAND_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00517 | Main | `ACTIVE_FLAG` | CELL_COMBO_DATA_TYPE 'YesNo' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP00519 | Main | `PRODUCTION_TYPE` | CELL_COMBO_DATA_TYPE 'PRODUCTION_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP01886 | AuthorityRequest | `MENU_AUTHORITY_ID` | CELL_COMBO_DATA_TYPE 'MENU_AUTHORITY_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP01886 | AuthorityRequest | `RELEASE_NOTIFIY_TYPE` | CELL_COMBO_DATA_TYPE 'RELEASE_NOTIFIY_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP01887 | AuthorityApproval | `APPROVAL_FLAG` | CELL_COMBO_DATA_TYPE 'APPROVAL_FLAG' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP01887 | AuthorityApproval | `MENU_AUTHORITY_ID` | CELL_COMBO_DATA_TYPE 'MENU_AUTHORITY_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP01887 | AuthorityApproval | `RELEASE_NOTIFIY_TYPE` | CELL_COMBO_DATA_TYPE 'RELEASE_NOTIFIY_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP01950 | Main | `MARKET` | CELL_COMBO_DATA_TYPE 'MARKET' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP01950 | Main | `REQUEST_TYPE` | CELL_COMBO_DATA_TYPE 'REQUEST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP01950 | Main | `STATUS` | CELL_COMBO_DATA_TYPE 'STATUS' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP02550 | Main | `LOT_SIZE_UOM` | CELL_COMBO_DATA_TYPE 'LOT_SIZE_UOM' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP02550 | Main | `OPERATION_LEAD_TIME_UOM` | CELL_COMBO_DATA_TYPE 'OPERATION_LEAD_TIME_UOM' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP02550 | Main | `TOLERANCE_UOM` | CELL_COMBO_DATA_TYPE 'TOLERANCE_UOM' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP02550 | Main | `TRANSFER_LOT_SIZE_UOM` | CELL_COMBO_DATA_TYPE 'TRANSFER_LOT_SIZE_UOM' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP02843 | Amend | `ATTR_TYPE` | CELL_COMBO_DATA_TYPE 'ATTR_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP03033 | MeasureConversion | `LANE_NUMBER` | CELL_COMBO_DATA_TYPE 'LANE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP03033 | MeasureConversionAdd | `CATEGORY` | CELL_COMBO_DATA_TYPE 'ITEM_CONV_CALC' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP03033 | Sub | `ACTIVE_FLAG` | CELL_COMBO_DATA_TYPE 'YN' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FP03590 | MAIN | `ACTIVE_FLAG` | CELL_COMBO_DATA_TYPE 'YN' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineExcelPopup | `ACTIVE_FLAG` | CELL_COMBO_DATA_TYPE 'YesNo' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineExcelPopup | `ELECTRODE_TYPE` | CELL_COMBO_DATA_TYPE 'ELECTRODE_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineExcelPopup | `LINE_ATTRIBUTE1` | CELL_COMBO_DATA_TYPE 'LINE_ATTRIBUTE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineExcelPopup | `LINE_LOCATION` | CELL_COMBO_DATA_TYPE 'LINE_LOCATION' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineExcelPopup | `LINE_MODEL_TYPE` | CELL_COMBO_DATA_TYPE 'LINE_MODEL_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineExcelPopup | `LINE_SETUP_GROUP_ID` | CELL_COMBO_DATA_TYPE 'LINE_SETUP_GROUP_ID' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineExcelPopup | `LINE_TYPE` | CELL_COMBO_DATA_TYPE 'LINE_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineImportExcelPopup | `ACTIVE_FLAG` | CELL_COMBO_DATA_TYPE 'YesNo' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineImportExcelPopup | `ELECTRODE_TYPE` | CELL_COMBO_DATA_TYPE 'ELECTRODE_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineImportExcelPopup | `LINE_ATTRIBUTE1` | CELL_COMBO_DATA_TYPE 'LINE_ATTRIBUTE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineImportExcelPopup | `LINE_LOCATION` | CELL_COMBO_DATA_TYPE 'LINE_LOCATION' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineImportExcelPopup | `LINE_MODEL_TYPE` | CELL_COMBO_DATA_TYPE 'LINE_MODEL_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineImportExcelPopup | `LINE_SETUP_GROUP_ID` | CELL_COMBO_DATA_TYPE 'LINE_SETUP_GROUP_ID' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | LineImportExcelPopup | `LINE_TYPE` | CELL_COMBO_DATA_TYPE 'LINE_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | SCPTargetImport | `MARKET` | CELL_COMBO_DATA_TYPE 'DEMAND_MARKET_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | FPC0100 | SCPTargetImport | `PRODUCTION_TYPE` | CELL_COMBO_DATA_TYPE 'DIVISION_DEMAND_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0001 | Location | `ELECTRODE_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0001 | Location | `FACTORY_ID2` | CELL_COMBO_DATA_TYPE 'BuildingByPlant' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0001 | Location | `LOCATION_CODE2` | CELL_COMBO_DATA_TYPE 'Location' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0001 | Location | `OPERATION_ID2` | CELL_COMBO_DATA_TYPE 'OperationByBuilding' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0001 | Location | `STORAGE_ID` | CELL_COMBO_DATA_TYPE 'StorageID' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0001 | Location(OSP) | `LOGISTIC_PLANT_ID` | CELL_COMBO_DATA_TYPE 'PlantByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0001 | Location(OSP) | `PLANT_ID` | CELL_COMBO_DATA_TYPE 'PlantByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0001 | Location(OSP) | `STORAGE_ID` | CELL_COMBO_DATA_TYPE 'StorageID' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0001 | Plant Site | `FROZEN_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0001 | Plant Site | `LOGISTIC_PLANT_ID` | CELL_COMBO_DATA_TYPE 'PlantByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0001 | Plant Site | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0005 | Distribution Route | `LT_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0005 | Distribution Route | `TRANSPORT_MODE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0006 | Plant Assign | `PLANT_SITE_ID` | CELL_COMBO_DATA_TYPE 'PlantByDivisionOperationItem' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0007 | BOD | `INCOTERMS` | CELL_COMBO_DATA_TYPE 'LOOKUPCOMMON' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0007 | BOD | `INCOTERMS_SSP` | CELL_COMBO_DATA_TYPE 'LOOKUPCOMMON' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0007 | BOD | `TO_SITE_CODE` | CELL_COMBO_DATA_TYPE 'ToSiteByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0020 | Packer | `LINE_ID` | CELL_COMBO_DATA_TYPE 'LineByOperationOsp' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0020 | Plant | `LINE_ID` | CELL_COMBO_DATA_TYPE 'LineByOperation' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0020 | Tact Time | `LINE_ID` | CELL_COMBO_DATA_TYPE 'LineByOperation' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0020 | Tact Time Except | `LINE_ID` | CELL_COMBO_DATA_TYPE 'LineByOperation' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0028 | Shipment Lot Size | `OPERATION_GROUP_ID` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0030 | BOD ITEM | `INCOTERMS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0030 | BOD ITEM | `TO_SITE_CODE` | CELL_COMBO_DATA_TYPE 'ToSiteByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0031 | Global PSI | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0032 | 11. NO RESOURCE | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0032 | 12. PREFER NO RESOURCE | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0032 | 2. PREFER NO BOM | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0032 | 4. PREFER NO PRODUCT | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0032 | 5. PREFER NO SITE | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0032 | 8. PREFER NO BOD | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0033 | Shipment Semi Dept Day | `DEPARTURE_DAY` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0033 | Shipment Semi Dept Day | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0034 | PSI Electrode | `UNIT` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0035 | JIG Master | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0035 | JIG Master | `SCM_SITE_ID` | CELL_COMBO_DATA_TYPE 'PlantByDivisionOperation' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0037 | Operation LT | `LT_OPERATION` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0037 | Operation LT | `SCM_SITE_ID` | CELL_COMBO_DATA_TYPE 'PlantByDivisionOperation' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0038 | Global PSI | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0039 | BOD | `INCOTERMS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0039 | BOD | `TO_SITE_CODE` | CELL_COMBO_DATA_TYPE 'ToSiteByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0039 | BOD / BOD Item | `INCOTERMS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0039 | BOD / BOD Item | `TO_SITE_CODE` | CELL_COMBO_DATA_TYPE 'ToSiteByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0044 | Global PSI ESS | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0045 | Shipment Request | `FROM_SITE` | CELL_COMBO_DATA_TYPE 'PlantSiteByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0045 | Shipment Request | `TO_SITE` | CELL_COMBO_DATA_TYPE 'ToSiteByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0046 | Model Allocation | `CELL_PLANT_SITE_ID` | CELL_COMBO_DATA_TYPE 'PlantSiteByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0046 | Model Allocation | `ELEC_PLANT_SITE_ID` | CELL_COMBO_DATA_TYPE 'ToSiteByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0050 | MDM Auth Management | `SITE_ID` | CELL_COMBO_DATA_TYPE 'SiteFP' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0051 | Target | `MARKET` | CELL_COMBO_DATA_TYPE 'DomExpTypeCode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0051 | Target | `ORDER_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0051 | Target | `REASON` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0053 | SCP BOM | `SI_ALT_PRIORITY` | CELL_COMBO_DATA_TYPE 'SEQ_NUMBER' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0065 | Target | `MARKET` | CELL_COMBO_DATA_TYPE 'DomExpTypeCode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0065 | Target | `ORDER_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0065 | Target | `REASON` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0078 | Main | `CLASSIFY_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0078 | Main | `CONFIRM_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0078 | Main | `DEV_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0078 | Main | `DIVISION_ID` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0078 | Main | `FINISH_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0078 | Main | `PRIORITY_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0078 | Main | `RECEIPT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0078 | Main | `REVIEW_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0078 | Main | `TEST_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0078 | Main | `VOC_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 40 | `ATTRIBUTE7` | CELL_COMBO_DATA_TYPE 'ALL_V_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 40 | `BASIC_FINISHED_PRODUCT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 40 | `STATUS_ACTIVE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 40 | `STATUS_MASS` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 40 | `STATUS_NEW` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 40 | `STATUS_PROTOTYPE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81 | `ATTRIBUTE7` | CELL_COMBO_DATA_TYPE 'ALL_V_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81 | `BASIC_FINISHED_PRODUCT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81 | `REPLACEMENT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81 | `SALES_PRIORITY` | CELL_COMBO_DATA_TYPE 'SEQ_NUMBER' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81 | `STATUS_ACTIVE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81 | `STATUS_MASS` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81 | `STATUS_NEW` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81 | `STATUS_PROTOTYPE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HD | `ATTRIBUTE7` | CELL_COMBO_DATA_TYPE 'ALL_V_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HD | `BASIC_FINISHED_PRODUCT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HD | `REPLACEMENT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HD | `SALES_PRIORITY` | CELL_COMBO_DATA_TYPE 'SEQ_NUMBER' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HD | `STATUS_ACTIVE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HD | `STATUS_MASS` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HD | `STATUS_NEW` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HD | `STATUS_PROTOTYPE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HG | `ATTRIBUTE7` | CELL_COMBO_DATA_TYPE 'ALL_V_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HG | `BASIC_FINISHED_PRODUCT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HG | `REPLACEMENT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HG | `SALES_PRIORITY` | CELL_COMBO_DATA_TYPE 'SEQ_NUMBER' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HG | `STATUS_ACTIVE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HG | `STATUS_MASS` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HG | `STATUS_NEW` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HG | `STATUS_PROTOTYPE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HM | `ATTRIBUTE7` | CELL_COMBO_DATA_TYPE 'ALL_V_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HM | `BASIC_FINISHED_PRODUCT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HM | `REPLACEMENT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HM | `SALES_PRIORITY` | CELL_COMBO_DATA_TYPE 'SEQ_NUMBER' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HM | `STATUS_ACTIVE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HM | `STATUS_MASS` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HM | `STATUS_NEW` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_HM | `STATUS_PROTOTYPE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_ST | `ATTRIBUTE7` | CELL_COMBO_DATA_TYPE 'ALL_V_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_ST | `BASIC_FINISHED_PRODUCT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_ST | `REPLACEMENT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_ST | `SALES_PRIORITY` | CELL_COMBO_DATA_TYPE 'SEQ_NUMBER' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_ST | `STATUS_ACTIVE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_ST | `STATUS_MASS` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_ST | `STATUS_NEW` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_ST | `STATUS_PROTOTYPE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_UC | `ATTRIBUTE7` | CELL_COMBO_DATA_TYPE 'ALL_V_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_UC | `BASIC_FINISHED_PRODUCT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_UC | `REPLACEMENT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_UC | `SALES_PRIORITY` | CELL_COMBO_DATA_TYPE 'SEQ_NUMBER' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_UC | `STATUS_ACTIVE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_UC | `STATUS_MASS` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_UC | `STATUS_NEW` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 81_UC | `STATUS_PROTOTYPE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 82 | `ATTRIBUTE7` | CELL_COMBO_DATA_TYPE 'ALL_V_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 82 | `BASIC_FINISHED_PRODUCT` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 82 | `GROUP_CODE8` | CELL_COMBO_DATA_TYPE 'ESS_CATEGORY' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 82 | `STATUS_ACTIVE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 82 | `STATUS_MASS` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 82 | `STATUS_NEW` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0080 | Group Code Management - 82 | `STATUS_PROTOTYPE` | CELL_COMBO_DATA_TYPE 'ALL_Y_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0092 | RTF Archeivement Rate Weekly Report - 40 | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0092 | RTF Archeivement Rate Weekly Report - 81 | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0092 | RTF Archeivement Rate Weekly Report - 82 | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0104 | MAIN | `ELTR_LN_TP_CD` | CELL_COMBO_DATA_TYPE 'OperationElectrodeType' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0104 | MAIN | `FACTORY_ID` | CELL_COMBO_DATA_TYPE 'CapaFactory' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0104 | MAIN | `LINE_ID` | CELL_COMBO_DATA_TYPE 'CapaLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0104 | MAIN | `OPERATION_ID` | CELL_COMBO_DATA_TYPE 'OperationByLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0104 | MAIN | `PLANT_ID` | CELL_COMBO_DATA_TYPE 'CapaPlant' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0104 | MAIN | `SITE_ID` | CELL_COMBO_DATA_TYPE 'CapaSite' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | 1ST_CUTOFF | `ELECTRODE_TYPE` | CELL_COMBO_DATA_TYPE 'OperationElectrodeType' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | 1ST_CUTOFF | `FACTORY_ID` | CELL_COMBO_DATA_TYPE 'BuildingByShopGroupId1' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | 1ST_CUTOFF | `LINE_ID` | CELL_COMBO_DATA_TYPE 'LineByOperationPlantId' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | 1ST_CUTOFF | `OPERATION_ID` | CELL_COMBO_DATA_TYPE 'OperationByLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | 1ST_CUTOFF | `PLANT_ID` | CELL_COMBO_DATA_TYPE 'PlantByGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | 1ST_CUTOFF | `SITE_ID` | CELL_COMBO_DATA_TYPE 'CapaSite' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | CURRENT | `ELECTRODE_TYPE` | CELL_COMBO_DATA_TYPE 'OperationElectrodeType' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | CURRENT | `FACTORY_ID` | CELL_COMBO_DATA_TYPE 'BuildingByShopGroupId1' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | CURRENT | `LINE_ID` | CELL_COMBO_DATA_TYPE 'LineByOperationPlantId' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | CURRENT | `OPERATION_ID` | CELL_COMBO_DATA_TYPE 'OperationByLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | CURRENT | `PLANT_ID` | CELL_COMBO_DATA_TYPE 'PlantByGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | CURRENT | `SITE_ID` | CELL_COMBO_DATA_TYPE 'CapaSite' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | MAIN | `ELECTRODE_TYPE` | CELL_COMBO_DATA_TYPE 'OperationElectrodeType' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | MAIN | `ELTR_LN_TP_CD` | CELL_COMBO_DATA_TYPE 'OperationElectrodeType' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | MAIN | `FACTORY_ID` | CELL_COMBO_DATA_TYPE 'BuildingByShopGroupId1' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | MAIN | `LINE_ID` | CELL_COMBO_DATA_TYPE 'LineByOperationPlantId' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | MAIN | `OPERATION_ID` | CELL_COMBO_DATA_TYPE 'OperationByLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | MAIN | `PLANT_ID` | CELL_COMBO_DATA_TYPE 'PlantByGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0105 | MAIN | `SITE_ID` | CELL_COMBO_DATA_TYPE 'CapaSite' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0106 | 1ST_CUTOFF_LINE | `OPERATION_ID` | CELL_COMBO_DATA_TYPE 'OperationByLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0106 | 1ST_CUTOFF_LINE_ASSEMBLY | `OPERATION_ID` | CELL_COMBO_DATA_TYPE 'OperationByLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0106 | 2ND_CUTOFF_LINE | `OPERATION_ID` | CELL_COMBO_DATA_TYPE 'OperationByLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0106 | CURRENT | `OPERATION_ID` | CELL_COMBO_DATA_TYPE 'OperationByLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0107 | MAIN | `OPERATION_ID` | CELL_COMBO_DATA_TYPE 'OperationByLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0108 | ASSEMBLY | `OPERATION_ID` | CELL_COMBO_DATA_TYPE 'OperationByLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0108 | ELTR | `OPERATION_ID` | CELL_COMBO_DATA_TYPE 'OperationByLine' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0110 | Group Name | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0110 | Model List | `GROUP_ID` | CELL_COMBO_DATA_TYPE 'GroupMaster' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0121 | Plan Group Master | `OPMZ_PLAN_GR_ID` | CELL_COMBO_DATA_TYPE 'PlanGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0121 | PlanGroupInfoPopup | `OPMZ_TGT_DIVS_CD` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0122 | Plan Activity Mgmt | `OPMZ_ACTV_NAME` | CELL_COMBO_DATA_TYPE 'ActivityCode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0123 | Plan Control | `OPMZ_PLAN_ID` | CELL_COMBO_DATA_TYPE 'PlanID' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0127 | PRECEDE / SAFETY STOCK DAY | `OPMZ_PLAN_GR_ID` | CELL_COMBO_DATA_TYPE 'PlanGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0128 | Safety Stock | `OPMZ_PLAN_GR_ID` | CELL_COMBO_DATA_TYPE 'PlanGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0129 | Demand Exception | `OPMZ_PLAN_GR_ID` | CELL_COMBO_DATA_TYPE 'PlanGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0130 | Scheduled Reciept Information | `OPMZ_PLAN_GR_ID` | CELL_COMBO_DATA_TYPE 'PlanGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0130 | Virtual Bom | `OPMZ_PLAN_GR_ID` | CELL_COMBO_DATA_TYPE 'PlanGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0131 | Sales Site Priority | `OPMZ_PLAN_GR_ID` | CELL_COMBO_DATA_TYPE 'PlanGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0132 | CONSTRAINT OF SHIPMENT QTY | `OPMZ_PLAN_GR_ID` | CELL_COMBO_DATA_TYPE 'PlanGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0133 | Warehouse Capacity | `OPMZ_PLAN_GR_ID` | CELL_COMBO_DATA_TYPE 'PlanGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0133 | Warehouse Item Mapping | `OPMZ_PLAN_GR_ID` | CELL_COMBO_DATA_TYPE 'PlanGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SCP0202 | Precede Safety Stock Day | `PLAN_GROUP_ID` | CELL_COMBO_DATA_TYPE 'PlanGroup' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SDM5010 | TAB1 | `DPJT_REG_CAT` | CELL_COMBO_DATA_TYPE 'DpjtRegCat' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SDM5010 | TAB2 | `DPJT_REG_CAT` | CELL_COMBO_DATA_TYPE 'DpjtRegCat' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0001 | Shipment Plan Confirm Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0002 | Change Request | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0002 | Shipment Change Request | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0002 | Shipment Change Request | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0003 | Shipment Change Request Confirm | `APPROVAL_DEPT` | CELL_COMBO_DATA_TYPE 'Dept' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0003 | Shipment Change Request Confirm | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'LookupCommon3' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0003 | Shipment Change Request Confirm | `CHANGE_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0003 | Shipment Change Request Confirm | `DELEGATEE_DEPT` | CELL_COMBO_DATA_TYPE 'Dept' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0003 | Shipment Change Request Confirm | `REQUEST_DEPT` | CELL_COMBO_DATA_TYPE 'Dept' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0003 | Shipment Change Request Confirm | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0003 | Shipment Change Request Confirm Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0003 | Shipment Change Request Confirm Detail | `STATUS_DETAIL` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0012 | Shipment Plan Confirm Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0013 | Shipment Plan Adjustment | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'CHANGE_REASON_CODE_ALL' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0013 | Shipment Plan Adjustment | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0013 | Shipment Plan Adjustment | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0013 | Stock Information | `STOCK_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon3' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0013 | Stock Information Detail | `STOCK_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon3' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0014 | Shipment Model PIC | `FROM_SITE` | CELL_COMBO_DATA_TYPE 'PlantSiteByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0014 | Shipment Model PIC | `OPERATION_GROUP` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015 | MES Stock Detail | `MES_CHANGE_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015 | Shipment Confirm Detail | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'CHANGE_REASON_CODE_ALL' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015 | Shipment Confirm Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015 | Shipment Confirm Detail | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015 | Shipment Request Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015 | Shipment Request Detail | `TR_MODE` | CELL_COMBO_DATA_TYPE 'TransportMode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015 | Stock Detail | `MES_CHANGE_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015 | W/H stock | `STOCK_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon3' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015 | W/H stock Detail | `STOCK_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon3' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015_TEMP2 | Shipment Confirm Detail | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'CHANGE_REASON_CODE_ALL' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015_TEMP2 | Shipment Confirm Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0015_TEMP2 | Shipment Confirm Detail | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0016 | Shipment Request Detail | `BOD_TOTAL_CODE` | CELL_COMBO_DATA_TYPE 'dtlocBodTotal' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0016 | Shipment Request Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0016 | Shipment Request Detail | `TO_SITE` | CELL_COMBO_DATA_TYPE 'dtlocToSite' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0016 | Shipment Request Detail(All) | `BOD_TOTAL_CODE` | CELL_COMBO_DATA_TYPE 'dtlocBodTotal' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0016 | Shipment Request Detail(All) | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0017 | Inventory Raw(IT & Mobile) | `INVENTORY_STATUS` | CELL_COMBO_DATA_TYPE 'OWMS_STOCK_STATUS' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0017 | Inventory Raw(IT & Mobile) | `INVENTORY_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0017 | Inventory Raw(Mobility & IT) | `INVENTORY_STATUS` | CELL_COMBO_DATA_TYPE 'OWMS_STOCK_STATUS' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0017 | Inventory Raw(Mobility & IT) | `INVENTORY_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0018 | Production Plan(OSP) | `PLANT_SITE` | CELL_COMBO_DATA_TYPE 'ProductionPlanOSP' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0019 | Shipment Change History | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'CHANGE_REASON_CODE_ALL' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0019 | Shipment Change History | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0021 | Shipment Plan Detail | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'CHANGE_REASON_CODE_ALL' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0021 | Shipment Plan Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0021 | Shipment Plan Detail | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0021 | oWMS Detail | `STOCK_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon3' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0022 | Shipment Request Detail | `TRANSPORT_MODE` | CELL_COMBO_DATA_TYPE 'TransportMode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0023 | Shipment Plan Detail | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'CHANGE_REASON_CODE_ALL' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0023 | Shipment Plan Detail | `DOM_EXP` | CELL_COMBO_DATA_TYPE 'DomExpTypeCode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0023 | Shipment Plan Detail | `FACTORY_ID` | CELL_COMBO_DATA_TYPE 'BuildingByPlantSite' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0023 | Shipment Plan Detail | `PACKAGE_TYPE` | CELL_COMBO_DATA_TYPE 'ElectrodePackageType' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0023 | Shipment Plan Detail | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0024 | Ship Master Elec | `BUILDING` | CELL_COMBO_DATA_TYPE 'BuildingByPlantSite' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0024 | Ship Master Elec | `DOM_EXP_TYPE_CODE` | CELL_COMBO_DATA_TYPE 'DomExpTypeCode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0024 | Ship Master Elec | `PACKAGE_TYPE_CODE` | CELL_COMBO_DATA_TYPE 'ElectrodePackageType' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0024 | Ship Master Elec | `PLANT_SITE_ID` | CELL_COMBO_DATA_TYPE 'PlantByDivisionOperation' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0024 | Ship Master Elec | `POST_OPER` | CELL_COMBO_DATA_TYPE 'ElectrodePostOperCode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0026 | Cell Biz | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0026 | Cell Biz | `TR_MODE` | CELL_COMBO_DATA_TYPE 'TransportMode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0026 | Pack Biz | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0026 | Pack Biz | `TR_MODE` | CELL_COMBO_DATA_TYPE 'TransportMode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0026 | Shipment Request Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0026 | Shipment Request Detail | `FROM_SITE` | CELL_COMBO_DATA_TYPE 'PlantSiteByDivisionOSP' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0026 | Shipment Request Detail | `TR_MODE` | CELL_COMBO_DATA_TYPE 'TransportMode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0026 | Shipment Request Detail_BACKUP | `TR_MODE` | CELL_COMBO_DATA_TYPE 'TransportMode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0027 | Shipment Plan Detail | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'CHANGE_REASON_CODE_ALL' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0027 | Shipment Plan Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0027 | Shipment Plan Detail | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0029 | Shipment Confirm Detail | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'CHANGE_REASON_CODE_ALL' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0029 | Shipment Confirm Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0029 | Shipment Confirm Detail | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0029 | Shipment Confirm Detail | `TRANSPORT_MODE` | CELL_COMBO_DATA_TYPE 'TransportMode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0029 | Shipment Request Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0029 | Shipment Request Detail | `TR_MODE` | CELL_COMBO_DATA_TYPE 'TransportMode' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0029 | Stock Detail | `MES_CHANGE_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0029 | Stock Detail | `STOCK_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon3' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0029 | W/H stock | `STOCK_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon3' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0029 | W/H stock Detail | `STOCK_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon3' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0045 | Shipment Request | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0045 | Shipment Request | `FROM_SITE` | CELL_COMBO_DATA_TYPE 'PlantSiteByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0045 | Shipment Request | `TO_SITE` | CELL_COMBO_DATA_TYPE 'ToSiteByDivision' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0046 | Cell Biz | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0046 | Pack Biz | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'FCST_TYPE' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0060 | Shipment Plan | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0060 | Shipment Plan Detail | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'CHANGE_REASON_CODE_ALL' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0060 | Shipment Plan Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0060 | Shipment Plan Detail | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0060 | oWMS Detail | `STOCK_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon3' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0200 | Change Request | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0200 | Shipment Change Request | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'CHANGE_REASON_CODE_ALL' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0200 | Shipment Change Request | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0200 | Shipment Change Request | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0201 | Change Request | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0201 | Shipment Change Request | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'CHANGE_REASON_CODE_ALL' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0201 | Shipment Change Request | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0201 | Shipment Change Request | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0202 | Shipment Change Request Confirm | `APPROVAL_DEPT` | CELL_COMBO_DATA_TYPE 'Dept' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0202 | Shipment Change Request Confirm | `CHANGE_REASON_CODE` | CELL_COMBO_DATA_TYPE 'LookupCommon3' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0202 | Shipment Change Request Confirm | `CHANGE_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0202 | Shipment Change Request Confirm | `DELEGATEE_DEPT` | CELL_COMBO_DATA_TYPE 'Dept' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0202 | Shipment Change Request Confirm | `REQUEST_DEPT` | CELL_COMBO_DATA_TYPE 'Dept' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0202 | Shipment Change Request Confirm | `SHIPMENT_STATUS` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D2 | SSP0202 | Shipment Change Request Confirm Detail | `FCST_TYPE` | CELL_COMBO_DATA_TYPE 'LookupCommon' 가 SCM_ADM_CMBO_SQL_M 미등록 → 0행·CODE 노출 |
| D4 | DMF0004 | salesCustomer | `SHIPTO_CODE` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0004 | salesCustomer | `SOLDTO_CODE` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0004 | salesLocation | `LOCATION_CODE` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0004 | salesSite | `CITY_NAME` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0004 | salesSite | `COUNTRY_NAME` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0004 | salesSite_40 | `CITY_NAME` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0004 | salesSite_40 | `COUNTRY_NAME` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0005 | production_40 | `OWNER` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0005 | production_40 | `TEAM_NAME` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0005 | production_81 | `OWNER` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0005 | production_81 | `PROJECT_CODE` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0005 | production_81 | `TEAM_NAME` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0005 | production_82 | `OWNER` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0005 | production_82 | `PRJ_OWNR_ID` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0005 | production_82 | `PROJECT_CODE` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0005 | production_82 | `TEAM_NAME` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0005 | purchase_81 | `OWNER` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0005 | purchase_82 | `OWNER` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0006 | customerModelMapping | `ITEM_ID` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0006 | customerModelMapping | `PROJECT_CODE` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0008 | salesSite | `CITY_NAME` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0008 | salesSite | `COUNTRY_NAME` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0008 | salesSite | `REP_SHIPTO_CODE` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0008 | salesSite | `REP_SOLDTO_CODE` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0008 | sspm | `ITEM_ID` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0008 | sspm | `PROJECT_CODE` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | DMF0008 | sspm | `USER_ID` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SDM1010 | TAB1 | `DPJT_ATUH_REG_STR` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SDM1010 | TAB2 | `MY_WORK` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SDM1020 | Project List | `DPJT_AUTH_MGMT` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SDM5010 | TAB1 | `DPJT_ATUH_REG_STR` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SDM5010 | TAB2 | `DPJT_ATUH_REG_STR` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SYS0002 | userMgmt | `DEPT_ID` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SYS0002 | userMgmt | `USER_ID` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SYS0003 | levelOneMenu | `MNU_MSG_NM` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SYS0003 | levelThreeMenu | `MNU_MSG_NM` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SYS0003 | levelTwoMenu | `MNU_MSG_NM` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SYS0006 | apiList | `API_MSG_NM` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D4 | SYS0014 | UserInfo | `USER_ID` | FPModal 인데 CELL_COMBO_DATA_TYPE(모달키) 공란 → 선택 창이 뜨지 않음 |
| D7 | FP00130 | Equipment | `ACTIVE_FLAG` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Equipment | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Equipment | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Equipment | `EQUIPMENT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Equipment | `EQUIPMENT_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Equipment | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Equipment | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Equipment | `MES_LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Equipment | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Equipment | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Equipment | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Sub | `ACTIVE_FLAG` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Sub | `END_TIME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Sub | `EQUIPMENT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Sub | `EQUIPMENT_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | Sub | `START_TIME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | UNUSING | `ACTIVE_FLAG` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | UNUSING | `COMPANY` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | UNUSING | `DIVISION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | UNUSING | `END_TIME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | UNUSING | `EQUIPMENT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | UNUSING | `EQUIPMENT_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00130 | UNUSING | `START_TIME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ACTIVE_FLAG` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `APPLIED_MODEL` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `DEMAND_LOT_SIZE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ERP_EOL` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `FLOW_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `FORMATION_FLOW_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `FORM_ATTRIBUTE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ITEM_ATTRIBUTE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ITEM_CLASS` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ITEM_CLASS_LEVEL_1` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ITEM_CLASS_LEVEL_2` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ITEM_CLASS_LEVEL_3` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ITEM_CLASS_LEVEL_4` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ITEM_CLASS_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ITEM_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ITEM_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `ITEM_UOM` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `MAKE_AND_BUY` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `MATERIAL_CLASS` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `MATERIAL_CLASS_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `SCP_EOL` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `SETUP_ATTRIBUTE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00180 | Main | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Main | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Main | `LINE_SETUP_GROUP_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Main | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Main | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Main | `SETUP_CATEGORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Main | `SETUP_CONDITION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Main | `SETUP_KEY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Main | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | MaterialSetupGroup | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | MaterialSetupGroup | `ITEM_SETUP_GROUP_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | MaterialSetupGroup | `LINE_SETUP_GROUP_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | MaterialSetupGroup | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | MaterialSetupGroup | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | MaterialSetupGroup | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | MaterialSetupGroup | `SETUP_CATEGORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | MaterialSetupGroup | `SETUP_KEY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | MaterialSetupGroup | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `FROM_ITEM_SETUP_GROUP_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `FROM_ITEM_SETUP_GROUP_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `LINE_SETUP_GROUP_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `SETUP_CATEGORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `SETUP_CONDITION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `SETUP_KEY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `TO_ITEM_SETUP_GROUP_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00450 | Matrix | `TO_ITEM_SETUP_GROUP_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Main | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Main | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Main | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Main | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Main | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Main | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Main | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Main | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Main | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Total | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Total | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | Total | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | TotalAdd | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | TotalAdd | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00461 | TotalAdd | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `CHECK_UI` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `INSERT_TIME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `INSTANCE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `PLAN_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `PROBLEM_DATA` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `PROBLEM_DATA_NICK` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `PROBLEM_DESCRIPTION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `PROBLEM_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `TOP_ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00470 | Main | `TOP_ITEM_ID_NICK` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `CATEGORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `CATEGORY_ORDER` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `DATA_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `ITEM_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `LOCATION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `PLAN_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `PSI` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00594 | Amend | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | AddLine | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | AddLine | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | AddLine | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | AddLine | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | AddLine | `LOCATION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | AddLine | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | AddLine | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `ACTIVE_MATERIAL_1` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `ACTIVE_MATERIAL_2` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `ACTIVE_MATERIAL_3` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `ADDICTION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `APPLIED_MODEL` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `BATCH_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `BATCH_ID_2` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `BINDER_1` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `BINDER_2` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `BINDER_3` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `CATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `CATEGORY_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `CMC` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `DEGREE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `EQUIPMENT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `FOIL` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `FOIL_CODE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `MEASURE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `MEASURE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `PC_MODEL_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `PRE_DISPERSION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `PRE_DISPERSION_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `PROD_SEQ` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `VERSION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `WORK_MODEL` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | Amend | `WORK_SHHET_MODEL` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | CapaSync | `ACTIVE_FLAG` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | CapaSync | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | CapaSync | `END_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | CapaSync | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | CapaSync | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | CapaSync | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | CapaSync | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | CapaSync | `START_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | EquipmentPopup | `EQUIPMENT_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | LineCopy | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | LineCopy | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | LineCopy | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | LineCopy | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | LineCopy | `LOCATION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | LineCopy | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | LineCopy | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | SetupColor | `UI_COLOR` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00595 | SetupColor | `UI_DESC` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00596 | ItemPopup | `COMPANY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00596 | ItemPopup | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00596 | ItemPopup | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00596 | ItemPopup | `ITEM_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00596 | ItemPopup | `MODEL_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00596 | ItemPopup | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00596 | ItemPopup | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ACTIVE_FLAG` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `APPLIED_MODEL` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `COMPANY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `DEMAND_LOT_SIZE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ERP_EOL` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `FLOW_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `FORMATION_FLOW_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `FORM_ATTRIBUTE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ITEM_ATTRIBUTE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ITEM_CLASS` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ITEM_CLASS_LEVEL_1` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ITEM_CLASS_LEVEL_2` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ITEM_CLASS_LEVEL_3` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ITEM_CLASS_LEVEL_4` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ITEM_CLASS_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ITEM_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ITEM_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `ITEM_UOM` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `MAKE_AND_BUY` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `MATERIAL_CLASS` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `MATERIAL_CLASS_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `SCP_EOL` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `SETUP_ATTRIBUTE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00600 | Main | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `LOCATION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `PLAN_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `QTY` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `SEQ` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `TOP_ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00601 | InvalidExcel | `_MSG` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `LOCATION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `PLAN_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `QTY` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `SEQ` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `TOP_ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | InvalidExcel | `_MSG` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | LinePopup | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | LinePopup | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | LinePopup | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | LinePopup | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | LinePopup | `LOCATION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | LinePopup | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | MaterialPopup | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | MaterialPopup | `ITEM_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | MaterialPopup | `MODEL_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | MaterialPopup | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | MaterialPopup | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `BOH` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `BOH_CELL` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `MEASURE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `PSI` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00602 | NLF | `TOP_ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `CATEGORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `CATEGORY_ORDER` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `DATA_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `ITEM_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `LOCATION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `PLAN_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP00622 | Amend | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `COMPANY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `EQUIPMENT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | ColumnExcel | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `COMPANY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `EQUIPMENT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `LINE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Confirm | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `EQUIPMENT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `PLAN_REVISION` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `PLAN_WEEK` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Main | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `EQUIPMENT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `INSTANCE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `MEMO` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `PLAN_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `TOP_ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `UPDATE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | Memo | `UPDATE_TIME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `COMPANY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `EQUIPMENT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `PLAN_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `PLAN_QTY` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | RowExcel | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | WOData | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | WOData | `EQUIPMENT` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | WOData | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | WOData | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | WOData | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | WOData | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | WOData | `NICKNAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | WOData | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | WOData | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP01624 | WOData | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A1000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A2000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A3000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A5000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A6000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A7000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A7100` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A7200` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A7500` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A8000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A8100` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `A9000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `COMPANY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `E0500` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `E1000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `E2000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `E2300` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `E2500` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `E3000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `E3500` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `E4000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `E4500` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `E8000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `MODEL_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `P5000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `P5500` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `P9500` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `S1000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `S2000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `S4000` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02510 | Main | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02602 | Main | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02602 | Main | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02602 | Main | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02602 | Main | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02602 | Main | `PRODUCT_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL1` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL11` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL11_A` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL11_P` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL1_A` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL1_P` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL2` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL2_A` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL2_P` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL3` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL3_A` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL3_P` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL4` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL4_A` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL4_P` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL5` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL5_A` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL5_P` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL6` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL6_A` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL6_P` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL8` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL8_A` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL8_P` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL9` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL9_A` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `BLEVEL9_P` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `RNUM` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FP02800 | Material Class | `ROOT` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0098 | NamePopup | `COMPANY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0098 | NamePopup | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0098 | NamePopup | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0098 | NamePopup | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC010 | MPPWPPCopy | `ELECTROD_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC010 | MPPWPPCopy | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC010 | MPPWPPCopy | `LINE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC010 | MPPWPPCopy | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC010 | MPPWPPCopy | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC010 | MPPWPPCopy | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC010 | MPPWPPCopy | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC010 | MPPWPPCopy | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC010 | MPPWPPCopy | `TOP_ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | MPPWPPCopy | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | MPPWPPCopy | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | MPPWPPCopy | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | MPPWPPCopy | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | MPPWPPCopy | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | MPPWPPCopy | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | MPPWPPCopy | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | MPPWPPCopy | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | MPPWPPCopy | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | MPPWPPCopy | `TOP_ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `ELECTROD_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `LINE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0102 | WppMppCopy | `TOP_ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `DIVISION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `ELECTRODE_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `EQUIPMENT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `FACTORY_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `LINE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `LINE_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `MARKET` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `MEMO` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `NICK_NAME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `OPERATION_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `PLAN_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `PRODUCTION_TYPE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `SITE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `TOP_ITEM_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `UPDATE_ID` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | FPC0104 | MemoPopup | `UPDATE_TIME` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | Division | `JV_PLANT_ID` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | Division | `UNIT_ID` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | GroupInfo | `USER_GR_ID` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | GroupInfo | `USER_GR_NM` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | UserInfo | `CREATED_BY` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | UserInfo | `CREATION_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | UserInfo | `DEPT_NM` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | UserInfo | `LAST_UPDATED_BY` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | UserInfo | `LAST_UPDATE_DATE` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | UserInfo | `USER_EML` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | UserInfo | `USER_ENG_NM` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | UserInfo | `USER_ID` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0014 | UserInfo | `USER_NM` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0015 | main | `CLASS_NAME` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0015 | main | `PROGRAM_ID` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0015 | main | `PROGRAM_NAME` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0015 | main | `PROGRAM_PATH` | HORIZONTAL_ALIGN_CODE 'Left' 는 C/L/R 밖 — 'L' 로 정정 필요. 현 상태는 좌측 fallback |
| D7 | SYS0015 | main | `USE_YN` | HORIZONTAL_ALIGN_CODE 'Center' 는 C/L/R 밖 — 'C' 로 정정 필요. 현 상태는 좌측 fallback |
| D8 | SDM1010 | POP1_GRID1 | `DEPT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID1 | `DEPT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID1 | `JOB_CODE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID1 | `JOB_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID1 | `USER_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID1 | `USER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID2 | `DEPT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID2 | `DEPT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID2 | `DPJT_KEY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID2 | `JOB_CODE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID2 | `JOB_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID2 | `USER_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID2 | `USER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID3 | `DEPT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID3 | `DEPT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID3 | `DPJT_KEY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID3 | `JOB_CODE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID3 | `JOB_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID3 | `USER_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID3 | `USER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `DEPT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `DEPT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `DPJT_AUTH_STATUS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `DPJT_AUTH_STATUS_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `DPJT_AUTH_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `DPJT_AUTH_TYPE_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `DPJT_KEY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `JOB_CODE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `JOB_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `PROCESS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `USER_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_GRID4 | `USER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_TREE | `DEPT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_TREE | `DEPT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_TREE | `LEVEL_NO` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_TREE | `ORGN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_TREE | `UPPER_DEPT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP1_TREE | `USER_COUNT` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `DIVISION_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `DIVISION_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `DPJT_CLASS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `DPJT_CLASS_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `DPJT_CODE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `DPJT_KEY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `DPJT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `DPJT_SEQ` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `END_CUSTOMER` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `END_CUSTOMER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `SOP_PLANT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | POP2_GRID5 | `SOP_PLANT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `BIZ_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `CELL_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DEPT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DEPT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DEPT_NAME_CN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DEPT_NAME_EN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DEPT_NAME_KO` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DIVISION_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DPJT_ATUH_REG_STATUS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DPJT_ATUH_REG_STATUS_COLOR_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DPJT_ATUH_REG_STATUS_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DPJT_CLASS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DPJT_CODE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DPJT_KEY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DPJT_REG_STATUS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DPJT_REG_STATUS_COLOR_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DPJT_REG_STATUS_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `DPJT_SEQ` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `END_CUSTOMER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `MGMT_USER_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `SOP_PLANT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `STACK_METHOD` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `USER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB1 | `USER_NAME_EN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `BIZ_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `BIZ_TYPE_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `CELL_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `CELL_TYPE_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DEPT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DEPT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DEPT_NAME_CN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DEPT_NAME_EN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DEPT_NAME_KO` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DIVISION_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DIVISION_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_AUTH_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_AUTH_TYPE_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_CLASS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_CLASS_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_CODE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_DEVELOP_STATUS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_DEVELOP_STATUS_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_KEY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_REG_STATUS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_REG_STATUS_COLOR_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_REG_STATUS_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `DPJT_SEQ` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `END_CUSTOMER` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `END_CUSTOMER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `MGMT_USER_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `SOP_PLANT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `SOP_PLANT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `STACK_METHOD` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `STACK_METHOD_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `USER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1010 | TAB2 | `USER_NAME_EN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DEPT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DEPT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_AUTH_REQ_LINK` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_AUTH_REQ_STATUS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_AUTH_REQ_WRITE_COLOR_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_AUTH_REQ_WRITE_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_AUTH_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_AUTH_TYPE_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_CODE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_KEY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_REG_STATUS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_REG_STATUS_COLOR_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_REG_STATUS_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `DPJT_SEQ` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `MGMT_USER_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM1020 | Project List | `USER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB1 | `DEPT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB1 | `DEPT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB1 | `DPJT_ATUH_REG_STATUS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB1 | `DPJT_ATUH_REG_STATUS_COLOR_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB1 | `DPJT_ATUH_REG_STATUS_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB1 | `DPJT_KEY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB1 | `DPJT_KEY_PARENT` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB1 | `DPJT_SEQ` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB1 | `MGMT_USER_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB1 | `REG_COL` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB1 | `USER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB2 | `CNFM_USER_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB2 | `CNFM_USER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB2 | `DPJT_ATUH_REG_STATUS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB2 | `DPJT_ATUH_REG_STATUS_COLOR_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB2 | `DPJT_ATUH_REG_STATUS_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB2 | `DPJT_CODE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB2 | `DPJT_KEY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB2 | `DPJT_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB2 | `DPJT_SEQ` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SDM5010 | TAB2 | `NOTE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `APPROVED_BY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `APPROVED_DATE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `AUTHORITY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `COMPANY_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `CUSTOMER` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `DEPARTMENT` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `DIVISION_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `GROUP_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `GRP_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `PLANT` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `REASON` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `REQUEST_DATE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `REQUEST_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `SSO_LOCATE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `STATUS` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `USER_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `USER_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0012 | main | `WORKING_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | columns | `COLUMN_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | columns | `CREATED_BY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | columns | `CREATION_DATE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | columns | `DQ_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | columns | `VALID_YN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | columns | `VALUE_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | columns | `VALUE_YN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | history | `CREATED_BY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | history | `CREATION_DATE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | history | `DQ_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | history | `DQ_TEXT` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | history | `HISTORY_SEQ` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | main | `CREATED_BY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | main | `CREATION_DATE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | main | `DQ_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | main | `DQ_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | main | `DQ_TEXT` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | main | `GROUP_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | main | `VALID_YN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | parameters | `CREATED_BY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | parameters | `DQ_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | parameters | `PARAMETER_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | parameters | `PARAMETER_TYPE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | parameters | `REP_YN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | parameters | `SEQNO` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0013 | parameters | `VALID_YN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0014 | Division | `JV_PLANT_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0014 | GroupInfo | `USER_GR_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0014 | GroupInfo | `USER_GR_NM` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0014 | UserInfo | `CREATED_BY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0014 | UserInfo | `CREATION_DATE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0014 | UserInfo | `DEPT_NM` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0014 | UserInfo | `LAST_UPDATED_BY` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0014 | UserInfo | `LAST_UPDATE_DATE` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0014 | UserInfo | `USER_EML` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0014 | UserInfo | `USER_ENG_NM` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0014 | UserInfo | `USER_NM` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0015 | main | `CLASS_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0015 | main | `PROGRAM_ID` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0015 | main | `PROGRAM_NAME` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0015 | main | `PROGRAM_PATH` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D8 | SYS0015 | main | `USE_YN` | CELL_CONTROL_OBJECT_TYPE_CODE 'S' 가 허용 컨트롤 밖 → 미해석 |
| D9 | DMF0021 | Sales Plan | `FROM_SITE_ID` | PK 중복 2행 — 값 조합 ['S/FPComboBox']. 어느 행이 적용될지 비결정적 |

## 4. 표준 콤보 TO-BE 미등록 (117컬럼)

| COLUMN | 표준 콤보(AS-IS) | TO-BE 실사용 대안 |
|---|---|---|
| `AL_MIX_METAL_LINK_PERIOD` | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | - |
| `APPROVAL_DEPT` | Dept | - |
| `APPROVAL_FLAG` | APPROVAL_FLAG | - |
| `ATTRIBUTE7` | ALL_V_TYPE | - |
| `ATTR_TYPE` | ATTR_TYPE | - |
| `BASIC_FINISHED_PRODUCT` | ALL_Y_TYPE | - |
| `BIZ_TYPE_NAME40` | DM_Biz_Type | DmBizType |
| `BOD_TOTAL_CODE` | dtlocBodTotal | - |
| `BOD_TYPE` | BodType | - |
| `BUILDING` | BuildingByPlantSite | - |
| `CATEGORY` | ITEM_CONV_CALC | - |
| `CELL_NICK` | DMF_BIZ_PLAN_METAL_CELL_NICK | - |
| `CELL_PLANT_SITE_ID` | PlantSiteByDivision | - |
| `CELL_PROD_SITE` | CELL_PROD_SITE | DMF0042CellProdSite |
| `CELL_TYPE_81` | CELL_TYPE_81 | CellType81 |
| `CELL_TYPE_82` | CELL_TYPE_82 | CellType82 |
| `CHANGE_REASON_CODE` | CHANGE_REASON_CODE_ALL | - |
| `CHANGE_TYPE` | LookupCommon | - |
| `CLASSIFY_STATUS` | LookupCommon | - |
| `CONFIRM_STATUS` | LookupCommon | - |
| `CO_MIX_METAL_LINK_PERIOD` | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | - |
| `CURRENCY` | CURRENCY_LIST | CurrencyList |
| `CU_MIX_METAL_LINK_PERIOD` | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | - |
| `DELEGATEE_DEPT` | Dept | - |
| `DEPARTURE_DAY` | LookupCommon | - |
| `DEV_STATUS` | LookupCommon | - |
| `DM_BIZ_TYPE` | DM_Biz_Type | DmBizType |
| `DOM_EXP_TYPE_CODE` | DomExpTypeCode | - |
| `DPJT_REG_CAT` | DpjtRegCat | - |
| `ELECTRODE_TYPE` | ELECTRODE_TYPE | - |
| `ELEC_PLANT_SITE_ID` | ToSiteByDivision | - |
| `ELTR_LN_TP_CD` | OperationElectrodeType | - |
| `FACTORY_ID` | BuildingByShopGroupId1 | - |
| `FACTORY_ID2` | BuildingByPlant | - |
| `FCST_TYPE` | LookupCommon | DM_LOOKUP_DIV, FCST_TYPE_NOT_ETC, FCST_TYPE_NOT_FREE, FcstType, FcstTypeByUserGroupDMF0082 |
| `FINISH_STATUS` | LookupCommon | - |
| `FORECAST_INFO_BIZ_TYPE` | DM_Biz_Type | DmBizType |
| `FROM_SITE` | PlantSiteByDivision | - |
| `FROZEN_TYPE` | LookupCommon | - |
| `GROUP_CODE8` | ESS_CATEGORY | - |
| `GROUP_ID` | GroupMaster | - |
| `INCOTERMS_SSP` | LOOKUPCOMMON | - |
| `INVENTORY_STATUS` | OWMS_STOCK_STATUS | - |
| `INVENTORY_TYPE` | LookupCommon | - |
| `ITEM_ID` | ITEM | DM_LOOKUP_DIV |
| `ITEM_ID40` | ITEM | - |
| `LANE_NUMBER` | LANE | - |
| `LI2CO3_MIX_METAL_LINK_PERIOD` | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | - |
| `LINE_ATTRIBUTE1` | LINE_ATTRIBUTE | - |
| `LINE_ID` | LineByOperation | - |
| `LINE_LOCATION` | LINE_LOCATION | - |
| `LINE_MODEL_TYPE` | LINE_MODEL_TYPE | - |
| `LINE_SETUP_GROUP_ID` | LINE_SETUP_GROUP_ID | - |
| `LINE_TYPE` | LINE_TYPE | - |
| `LIOH_MIX_METAL_LINK_PERIOD` | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | - |
| `LOCATION_CODE2` | Location | - |
| `LOGISTIC_PLANT_ID` | PlantByDivision | - |
| `LOT_SIZE_UOM` | LOT_SIZE_UOM | - |
| `LT_OPERATION` | LookupCommon | - |
| `LT_TYPE` | LookupCommon | - |
| `MARKET` | DEMAND_MARKET_TYPE | - |
| `MENU_AUTHORITY_ID` | MENU_AUTHORITY_TYPE | - |
| `MES_CHANGE_STATUS` | LookupCommon | - |
| `METAL_LINK_MTD` | DMF_METAL_BUCKET | - |
| `MN_MIX_METAL_LINK_PERIOD` | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | - |
| `NI_MIX_METAL_LINK_PERIOD` | DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX | - |
| `OPERATION_GROUP` | LookupCommon | - |
| `OPERATION_GROUP_ID` | LookupCommon | - |
| `OPERATION_ID` | OperationByLine | sysOperationOptions |
| `OPERATION_ID2` | OperationByBuilding | - |
| `OPERATION_LEAD_TIME_UOM` | OPERATION_LEAD_TIME_UOM | - |
| `OPMZ_ACTV_NAME` | ActivityCode | - |
| `OPMZ_PLAN_GR_ID` | PlanGroup | - |
| `OPMZ_PLAN_ID` | PlanID | - |
| `OPMZ_TGT_DIVS_CD` | LookupCommon | - |
| `ORDER_TYPE` | FCST_TYPE | - |
| `PACKAGE_TYPE` | ElectrodePackageType | - |
| `PACKAGE_TYPE_CODE` | ElectrodePackageType | - |
| `PLANT_ID` | PlantByGroup | - |
| `PLANT_SITE` | ProductionPlanOSP | - |
| `PLAN_GROUP_ID` | PlanGroup | - |
| `POD` | PortBySite | - |
| `POL` | PortBySite | - |
| `POST_OPER` | ElectrodePostOperCode | - |
| `PRIORITY_STATUS` | LookupCommon | - |
| `PRODUCTION_TYPE` | DIVISION_DEMAND_TYPE | - |
| `PROJECT_CODE` | PROJECT | - |
| `REASON` | LookupCommon | - |
| `RECEIPT_STATUS` | LookupCommon | - |
| `RELEASE_NOTIFIY_TYPE` | RELEASE_NOTIFIY_TYPE | - |
| `REPLACEMENT` | ALL_Y_TYPE | - |
| `REQUEST_DEPT` | Dept | - |
| `REQUEST_TYPE` | REQUEST_TYPE | - |
| `REVIEW_STATUS` | LookupCommon | - |
| `SALES_PRIORITY` | SEQ_NUMBER | - |
| `SHIPMENT_STATUS` | LookupCommon | - |
| `SITE_ID` | CapaSite | - |
| `SI_ALT_PRIORITY` | SEQ_NUMBER | - |
| `STATUS` | STATUS | - |
| `STATUS_ACTIVE` | ALL_Y_TYPE | - |
| `STATUS_DETAIL` | LookupCommon | - |
| `STATUS_MASS` | ALL_Y_TYPE | - |
| `STATUS_NEW` | ALL_Y_TYPE | - |
| `STATUS_PROTOTYPE` | ALL_Y_TYPE | - |
| `STOCK_STATUS` | LookupCommon3 | - |
| `STORAGE_ID` | StorageID | - |
| `TEST_STATUS` | LookupCommon | - |
| `TOLERANCE_UOM` | TOLERANCE_UOM | - |
| `TO_SITE` | ToSiteByDivision | - |
| `TO_SITE_CODE` | ToSiteByDivision | - |
| `TRANSFER_LOT_SIZE_UOM` | TRANSFER_LOT_SIZE_UOM | - |
| `TRANSPORT_MODE` | TransportMode | - |
| `TRANSPORT_TIME_UOM` | TRANSPORT_TIME_UOM | - |
| `TR_MODE` | TransportMode | - |
| `UNIT` | LookupCommon | - |
| `VIRTUAL_LINE_YN` | YesNo | - |
| `VOC_TYPE` | LookupCommon | - |
