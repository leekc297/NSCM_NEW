# AS-IS 액션 대조표 — FP00594

> 원천: `Doc/asisfacts/screens/FP00594/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2701행 · 메서드 234 · 종류 DATA_OP 1179 · FLAG 212 · RETURN 211 · UI_PROP 203 · VALUE_SET 115 · MESSAGE 109 · UI_MISC 87 · STATE 83 · POPUP 75 · COMBO_DATA 70 · CALL_EXT 64 · GRID_SET 61 · GRID_INIT 59 · ENDPOINT 50 · CALL_BASE 19 · VALUE_CLEAR 19 · GRID_STYLE 18 · GRID_LOCK 13 · LIST_REBIND 12 · FOCUS 10 · THROW 10 · GRID_BIND 7 · EXCEL 5 · STATE_RESET 4 · LIST_BIND 3 · LIST_CLEAR 3 · ⚠ 의미 확인 필요 83


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9c12844 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6333 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-a59ed5dc | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6339 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-23d331bd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6347 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-2348cc9f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6348 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-fa322b27 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6349 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-26ffa7e5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6350 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-4178d8f5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6352 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-319b285b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6353 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-d824b4f2 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6354 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8f3f8b6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6355 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-88faceb3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6356 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b7d7241 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6357 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-b0758d76 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6358 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-43095bec | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6359 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-efe05f68 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6362 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-f36afcf7 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6551 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-1cb023eb | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6552 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-11e5e69d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6553 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-865a73c4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6554 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-a0228d20 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6556 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-e05edd15 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6557 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-fb8a6a96 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6558 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-93b63616 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6559 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-d21a6972 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6560 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-da0ac0e3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6561 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-a83a5f8d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6562 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-d02d833b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6563 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-bfc17492 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6565 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c88aeb4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6468 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1920b5db | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6469 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-aed8ed5a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6470 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-86306e2d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6471 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c157845b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6472 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf63f85e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6475 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-72d0c62c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6479 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad5413c6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6480 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e360597 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6483 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLM_EC_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-79a374dc | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6484 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6e3190f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6466 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-30d5f832 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6498 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-a24202c3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6501 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d6bbf5a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6504 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ee1f969 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6507 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b4bacde | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6510 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-a763c11d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6513 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-edaaa0c4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6519 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-caced213 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6521 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-595a60d9 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6440 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a29f0256 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6402 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2c4bba1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6403 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0228d5fb | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6404 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1735305b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6405 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8099f97c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6406 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d393418 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6407 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a003033 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6409 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4279b048 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6410 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1497a817 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6413 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-facc1db0 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6414 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9136e50c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6415 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c193971d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6416 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLM_EC_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-ffcc072a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6417 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-77542c2d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6400 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-0614ca82 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6425 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-af6e22e2 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6426 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-6667c1e5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6431 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7f2a38f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6375 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00594_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c1340ce | .ctor | FP00594_ExcelPopup.cs:150 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-599bfed1 | .ctor | FP00594_ExcelPopup.cs:153 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-db16142b | .ctor | FP00594_ExcelPopup.cs:154 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4218073f | .ctor | FP00594_ExcelPopup.cs:156 |  | FLAG | HeaderLineCount | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-5e60ea30 | .ctor | FP00594_ExcelPopup.cs:157 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |

## FP00594_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf63218f | this.btnClose.Click | FP00594_ExcelPopup.cs:1003 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5453338 | this.btnDownload.Click | FP00594_ExcelPopup.cs:977 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-d403e132 | this.btnDownload.Click | FP00594_ExcelPopup.cs:978 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00594_ExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00917020 | this.btnUpload.Click | FP00594_ExcelPopup.cs:990 | if (bUpload) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f015a311 | this.btnUpload.Click | FP00594_ExcelPopup.cs:991 | if (bUpload) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |

## FP00594_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75671d97 | this.Load | FP00594_ExcelPopup.cs:250 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ec1489d3 | this.Load | FP00594_ExcelPopup.cs:251 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-37ff6f10 | this.Load | FP00594_ExcelPopup.cs:252 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00594_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09591573 | (진입점 미연결) | FP00594_ExcelPopup.cs:961 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-448bd912 | (진입점 미연결) | FP00594_ExcelPopup.cs:961 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00594_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9379b0b9 | this.Load | FP00594_ExcelPopup.cs:245 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00594_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b12fcf7 | Dispose | FP00594_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00594_ExcelPopup.dtpPeriod_ValueChanged

진입점: this.dtpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24197dfc | this.dtpPeriod.ValueChanged | FP00594_ExcelPopup.cs:1019 | if (bFirst == true) | FLAG | bFirst | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0d412d5b | this.dtpPeriod.ValueChanged | FP00594_ExcelPopup.cs:1020 | if (bFirst == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd484a10 | this.dtpPeriod.ValueChanged | FP00594_ExcelPopup.cs:1035 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3aa1499d | this.dtpPeriod.ValueChanged | FP00594_ExcelPopup.cs:1038 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | VALUE_SET | dtpPeriod.InitValue | sStartDate + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3cd8802a | this.dtpPeriod.ValueChanged | FP00594_ExcelPopup.cs:1039 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e553ba82 | this.dtpPeriod.ValueChanged | FP00594_ExcelPopup.cs:1044 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d757bdaa | this.dtpPeriod.ValueChanged | FP00594_ExcelPopup.cs:1052 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8486ca92 | this.dtpPeriod.ValueChanged | FP00594_ExcelPopup.cs:1054 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1af2680d | this.dtpPeriod.ValueChanged | FP00594_ExcelPopup.cs:1057 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-9f47dc6a | this.dtpPeriod.ValueChanged | FP00594_ExcelPopup.cs:1058 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |

## FP00594_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9f805fd | (진입점 미연결) | FP00594_ExcelPopup.cs:951 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00594_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-087f0980 | FindButton | FP00594_ExcelPopup.cs:292 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b291cfa6 | FindButton | FP00594_ExcelPopup.cs:293 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2d21ac36 | FindButton | FP00594_ExcelPopup.cs:295 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-434ecdde | this.Load 외 2 | FP00594_ExcelPopup.cs:324 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2ccc430b | this.Load 외 2 | FP00594_ExcelPopup.cs:330 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b885bfb | this.Load 외 2 | FP00594_ExcelPopup.cs:332 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae928f4c | this.Load 외 2 | FP00594_ExcelPopup.cs:337 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f2276812 | this.Load 외 2 | FP00594_ExcelPopup.cs:338 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3d68856 | this.Load 외 2 | FP00594_ExcelPopup.cs:340 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-b3eeaa42 | this.Load 외 2 | FP00594_ExcelPopup.cs:341 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-ecfa506d | this.Load 외 2 | FP00594_ExcelPopup.cs:343 |  | DATA_OP | Filter["BUCKET_FROM"] | _BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-16c22f7e | this.Load 외 2 | FP00594_ExcelPopup.cs:344 |  | DATA_OP | Filter["BUCKET_TO"] | _BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-69f8a548 | this.Load 외 2 | FP00594_ExcelPopup.cs:349 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-244538e6 | this.Load 외 2 | FP00594_ExcelPopup.cs:351 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-dc854eab | this.Load 외 2 | FP00594_ExcelPopup.cs:355 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9fce1ccf | this.Load 외 2 | FP00594_ExcelPopup.cs:360 | if (OnSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21f7bb87 | this.Load 외 2 | FP00594_ExcelPopup.cs:361 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-46257f31 | this.Load 외 2 | FP00594_ExcelPopup.cs:361 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d532409 | this.Load 외 2 | FP00594_ExcelPopup.cs:366 | if (OnSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0fc17858 | this.Load 외 2 | FP00594_ExcelPopup.cs:367 | if (OnSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-05827e03 | this.Load 외 2 | FP00594_ExcelPopup.cs:369 | if (OnSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7b0930ff | this.Load 외 2 | FP00594_ExcelPopup.cs:370 | if (OnSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-74cd4d5d | this.Load 외 2 | FP00594_ExcelPopup.cs:371 | if (OnSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-67130792 | this.Load 외 2 | FP00594_ExcelPopup.cs:372 | if (OnSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1fc71054 | this.Load 외 2 | FP00594_ExcelPopup.cs:373 | if (OnSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fb2685bc | this.Load 외 2 | FP00594_ExcelPopup.cs:374 | if (OnSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e227fee1 | this.Load 외 2 | FP00594_ExcelPopup.cs:375 | if (OnSearchData != null) | STATE | this.dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c1aec26a | this.Load 외 2 | FP00594_ExcelPopup.cs:381 | if (OnSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-299ded84 | this.Load 외 2 | FP00594_ExcelPopup.cs:385 | if (OnSearchData != null) ▸ try | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d807594 | this.Load 외 2 | FP00594_ExcelPopup.cs:387 | if (OnSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d9bb11b | this.Load 외 2 | FP00594_ExcelPopup.cs:389 | if (OnSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar, Dat… | ⚠ 의미 확인 필요 |  |  |  |
| AC-173a35c4 | this.Load 외 2 | FP00594_ExcelPopup.cs:394 | if (OnSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, set, ColumnWidth.Data, Colum… | 화면 필드/플래그 변경 |  |  |  |
| AC-24df69ee | this.Load 외 2 | FP00594_ExcelPopup.cs:394 | if (OnSearchData != null) ▸ try ▸ lambda | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, set, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data, Heade… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fd6c5ec | this.Load 외 2 | FP00594_ExcelPopup.cs:399 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-25cfceb8 | this.Load 외 2 | FP00594_ExcelPopup.cs:400 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-85f91ff6 | this.Load 외 2 | FP00594_ExcelPopup.cs:401 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-fe2cfb00 | this.Load 외 2 | FP00594_ExcelPopup.cs:406 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7ad8b3a | this.Load 외 2 | FP00594_ExcelPopup.cs:407 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-473316e9 | this.Load 외 2 | FP00594_ExcelPopup.cs:410 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f053d348 | this.Load 외 2 | FP00594_ExcelPopup.cs:411 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-22e58512 | this.Load 외 2 | FP00594_ExcelPopup.cs:420 | if (OnSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b7bb1db | this.Load 외 2 | FP00594_ExcelPopup.cs:423 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d14e3459 | this.Load 외 2 | FP00594_ExcelPopup.cs:424 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5b11ecaa | this.Load 외 2 | FP00594_ExcelPopup.cs:425 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-923f7619 | this.Load 외 2 | FP00594_ExcelPopup.cs:426 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4ad188a8 | this.Load 외 2 | FP00594_ExcelPopup.cs:427 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-21d72212 | this.Load 외 2 | FP00594_ExcelPopup.cs:428 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fcfd24e4 | this.Load 외 2 | FP00594_ExcelPopup.cs:429 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00594_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf4a3563 | this.Load | FP00594_ExcelPopup.cs:166 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f312de10 | this.Load | FP00594_ExcelPopup.cs:168 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00594_ExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f69dbbaa | (진입점 미연결) | FP00594_ExcelPopup.cs:688 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-72399701 | (진입점 미연결) | FP00594_ExcelPopup.cs:689 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-4e1abb7e | (진입점 미연결) | FP00594_ExcelPopup.cs:690 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-a300eaf7 | (진입점 미연결) | FP00594_ExcelPopup.cs:691 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-5c5417b7 | (진입점 미연결) | FP00594_ExcelPopup.cs:692 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-8046d940 | (진입점 미연결) | FP00594_ExcelPopup.cs:693 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-4bfe909c | (진입점 미연결) | FP00594_ExcelPopup.cs:694 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-801e97fb | (진입점 미연결) | FP00594_ExcelPopup.cs:696 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-d5f4cb48 | (진입점 미연결) | FP00594_ExcelPopup.cs:697 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-890beb5d | (진입점 미연결) | FP00594_ExcelPopup.cs:701 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2d41cb9b | (진입점 미연결) | FP00594_ExcelPopup.cs:702 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00594_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b07e494e | this.Load | FP00594_ExcelPopup.cs:203 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_FROM"].ToString()) < Convert.ToDecimal(thi… | DATA_OP | Filter["BUCKET_FROM"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c167bf0f | this.Load | FP00594_ExcelPopup.cs:208 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | sEndDay | 행/컬럼 값 대입 |  |  |  |
| AC-5afabf54 | this.Load | FP00594_ExcelPopup.cs:211 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | Filter["BUCKET_FROM"] | 화면 필드/플래그 변경 |  |  |  |
| AC-3e5e942e | this.Load | FP00594_ExcelPopup.cs:212 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | Filter["BUCKET_TO"] | 화면 필드/플래그 변경 |  |  |  |
| AC-af2abbfe | this.Load | FP00594_ExcelPopup.cs:214 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | _BucketFromDate.ToString() + ":" + _BucketToDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f1c4dd15 | this.Load | FP00594_ExcelPopup.cs:216 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e0d67742 | this.Load | FP00594_ExcelPopup.cs:218 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-c563515f | this.Load | FP00594_ExcelPopup.cs:222 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-2888ad96 | this.Load | FP00594_ExcelPopup.cs:224 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-65b16210 | this.Load | FP00594_ExcelPopup.cs:225 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-f9fb854f | this.Load | FP00594_ExcelPopup.cs:226 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fa3bd2f0 | this.Load | FP00594_ExcelPopup.cs:234 | for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d487fb0 | this.Load | FP00594_ExcelPopup.cs:237 |  | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-1d4ea994 | this.Load | FP00594_ExcelPopup.cs:239 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |

## FP00594_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e3629cb | this.Load | FP00594_ExcelPopup.cs:262 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e31ce6f3 | this.Load | FP00594_ExcelPopup.cs:263 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00594_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-337c1672 | (진입점 미연결) | FP00594_ExcelPopup.cs:283 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00594_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80c6eb1a | this.btnUpload.Click | FP00594_ExcelPopup.cs:711 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-01e0df19 | this.btnUpload.Click | FP00594_ExcelPopup.cs:711 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0458a341 | this.btnUpload.Click | FP00594_ExcelPopup.cs:713 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-af685ef3 | this.btnUpload.Click | FP00594_ExcelPopup.cs:714 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-67b0084f | this.btnUpload.Click | FP00594_ExcelPopup.cs:715 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3c2454d | this.btnUpload.Click | FP00594_ExcelPopup.cs:717 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-10d573fc | this.btnUpload.Click | FP00594_ExcelPopup.cs:719 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dc0e007e | this.btnUpload.Click | FP00594_ExcelPopup.cs:720 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-482c54ec | this.btnUpload.Click | FP00594_ExcelPopup.cs:720 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-327e824a | this.btnUpload.Click | FP00594_ExcelPopup.cs:727 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-94da13a5 | this.btnUpload.Click | FP00594_ExcelPopup.cs:728 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-b06f3cfb | this.btnUpload.Click | FP00594_ExcelPopup.cs:940 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00594_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea141eaf | this.btnSave.Click | FP00594_ExcelPopup.cs:442 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-9886567b | this.btnSave.Click | FP00594_ExcelPopup.cs:443 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57d27e35 | this.btnSave.Click | FP00594_ExcelPopup.cs:447 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix! After once seach, Try agagin.!") | 메시지 표시 |  |  |  |
| AC-0761a0ba | this.btnSave.Click | FP00594_ExcelPopup.cs:448 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73606adc | this.btnSave.Click | FP00594_ExcelPopup.cs:459 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (!String.IsNullOrEmpty(dsMain.Tables[0].Rows[i]["MESSAGE"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8515be39 | this.btnSave.Click | FP00594_ExcelPopup.cs:460 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (!String.IsNullOrEmpty(dsMain.Tables[0].Rows[i]["MESSAGE"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7b515d4 | this.btnSave.Click | FP00594_ExcelPopup.cs:464 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-42a6fe45 | this.btnSave.Click | FP00594_ExcelPopup.cs:464 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e0b2623 | this.btnSave.Click | FP00594_ExcelPopup.cs:470 | if (OnBeforeCheckData != null) | CALL_BASE | OnBeforeCheckData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9f1c323 | this.btnSave.Click | FP00594_ExcelPopup.cs:472 | if (OnBeforeCheckData != null) ▸ if (bCheck == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24113060 | this.btnSave.Click | FP00594_ExcelPopup.cs:483 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e26007d3 | this.btnSave.Click | FP00594_ExcelPopup.cs:484 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1501af0b | this.btnSave.Click | FP00594_ExcelPopup.cs:485 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1d6cc76f | this.btnSave.Click | FP00594_ExcelPopup.cs:486 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7f217101 | this.btnSave.Click | FP00594_ExcelPopup.cs:487 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-da54adaf | this.btnSave.Click | FP00594_ExcelPopup.cs:488 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-667acae1 | this.btnSave.Click | FP00594_ExcelPopup.cs:496 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-13738935 | this.btnSave.Click | FP00594_ExcelPopup.cs:497 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d770ab05 | this.btnSave.Click | FP00594_ExcelPopup.cs:498 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7e3c740a | this.btnSave.Click | FP00594_ExcelPopup.cs:499 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cebdffe1 | this.btnSave.Click | FP00594_ExcelPopup.cs:500 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-58f6ce2f | this.btnSave.Click | FP00594_ExcelPopup.cs:501 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0d2db255 | this.btnSave.Click | FP00594_ExcelPopup.cs:502 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5cfce4b4 | this.btnSave.Click | FP00594_ExcelPopup.cs:503 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7dc38ee0 | this.btnSave.Click | FP00594_ExcelPopup.cs:509 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-11c31863 | this.btnSave.Click | FP00594_ExcelPopup.cs:512 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b771daa | this.btnSave.Click | FP00594_ExcelPopup.cs:514 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-dfc41894 | this.btnSave.Click | FP00594_ExcelPopup.cs:517 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-f027e5ef | this.btnSave.Click | FP00594_ExcelPopup.cs:522 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-9bf3db65 | this.btnSave.Click | FP00594_ExcelPopup.cs:523 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-144e6965 | this.btnSave.Click | FP00594_ExcelPopup.cs:533 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGrou… | DATA_OP | this.Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-eb207348 | this.btnSave.Click | FP00594_ExcelPopup.cs:535 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rd… | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-01c0c2c7 | this.btnSave.Click | FP00594_ExcelPopup.cs:539 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d3c75ba7 | this.btnSave.Click | FP00594_ExcelPopup.cs:544 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-da77d9c0 | this.btnSave.Click | FP00594_ExcelPopup.cs:567 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-22708a9b | this.btnSave.Click | FP00594_ExcelPopup.cs:570 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | POPUP | new Planning.UIL.FP00594_InValidationExcelPopup | ("InvalidExcelPopup", dsValidation, "") | 팝업/폼 생성 |  |  |  |
| AC-3b2e348e | this.btnSave.Click | FP00594_ExcelPopup.cs:571 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dadd9cc9 | this.btnSave.Click | FP00594_ExcelPopup.cs:572 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d52cabe5 | this.btnSave.Click | FP00594_ExcelPopup.cs:589 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4013749 | this.btnSave.Click | FP00594_ExcelPopup.cs:601 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d75b6577 | this.btnSave.Click | FP00594_ExcelPopup.cs:605 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | FLAG | bUploadSaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fc6eed89 | this.btnSave.Click | FP00594_ExcelPopup.cs:606 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-98722189 | this.btnSave.Click | FP00594_ExcelPopup.cs:611 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-61c19616 | this.btnSave.Click | FP00594_ExcelPopup.cs:612 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c930fdd4 | this.btnSave.Click | FP00594_ExcelPopup.cs:618 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-d7f726a2 | this.btnSave.Click | FP00594_ExcelPopup.cs:655 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-65a4fbfd | this.btnSave.Click | FP00594_ExcelPopup.cs:657 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ad2acc6 | this.btnSave.Click | FP00594_ExcelPopup.cs:658 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-185ca12f | this.btnSave.Click | FP00594_ExcelPopup.cs:668 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-050cb48d | this.btnSave.Click | FP00594_ExcelPopup.cs:669 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-017e191d | this.btnSave.Click | FP00594_ExcelPopup.cs:673 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-46e7aaf5 | this.btnSave.Click | FP00594_ExcelPopup.cs:674 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-912cc802 | this.btnSave.Click | FP00594_ExcelPopup.cs:675 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dbf86fe2 | this.btnSave.Click | FP00594_ExcelPopup.cs:676 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-add44c09 | this.btnSave.Click | FP00594_ExcelPopup.cs:677 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-03a3763c | this.btnSave.Click | FP00594_ExcelPopup.cs:678 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00594_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-422756b7 | this.Load | FP00594_ExcelPopup.cs:275 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f9694b5 | this.Load | FP00594_ExcelPopup.cs:276 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00594_InValidationExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-308e3174 | .ctor | FP00594_InValidationExcelPopup.cs:108 |  | UI_PROP | SpdSheet.shtMain | sSheetName | 속성 shtMain 설정 |  |  |  |
| AC-68f0e343 | .ctor | FP00594_InValidationExcelPopup.cs:109 |  | FLAG | _dsSheet | dsSheet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-5610a77d | .ctor | FP00594_InValidationExcelPopup.cs:109 |  | DATA_OP | dsSheet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aa31c8fb | .ctor | FP00594_InValidationExcelPopup.cs:110 |  | FLAG | _sMessage | sMessage | 화면 필드/플래그 변경 |  |  |  |

## FP00594_InValidationExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ead3656 | this.btnClose.Click | FP00594_InValidationExcelPopup.cs:218 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_InValidationExcelPopup.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f8b2fca | this.btnExport.Click | FP00594_InValidationExcelPopup.cs:266 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-a25568d9 | this.btnExport.Click | FP00594_InValidationExcelPopup.cs:267 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00594_InValidationExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f43ed360 | this.Load | FP00594_InValidationExcelPopup.cs:164 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cd41fa58 | this.Load | FP00594_InValidationExcelPopup.cs:165 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-194ac89b | this.Load | FP00594_InValidationExcelPopup.cs:166 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00594_InValidationExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ced9aa05 | this.Load | FP00594_InValidationExcelPopup.cs:158 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00594_InValidationExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fea9ad5 | Dispose | FP00594_InValidationExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00594_InValidationExcelPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55eacffb | ExcelButton | FP00594_InValidationExcelPopup.cs:227 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00594_InValidationExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0e1cf86 | this.Load | FP00594_InValidationExcelPopup.cs:120 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5be04faf | this.Load | FP00594_InValidationExcelPopup.cs:122 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3b71117c | this.Load | FP00594_InValidationExcelPopup.cs:136 | if (!string.IsNullOrEmpty(_sMessage)) | MESSAGE | MessageBox.Show | (_sMessage, "Validation", MessageBoxButtons.OK, MessageBoxIcon.Information) | 메시지 표시 |  |  |  |

## FP00594_InValidationExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53d229af | this.Load | FP00594_InValidationExcelPopup.cs:150 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-249ee1f6 | this.Load | FP00594_InValidationExcelPopup.cs:152 |  | VALUE_SET | lblTitle.Text | " Excel InValidation Results" | 컨트롤 값 설정 |  |  |  |

## FP00594_InValidationExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1423137 | this.Load | FP00594_InValidationExcelPopup.cs:178 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-65438484 | this.Load | FP00594_InValidationExcelPopup.cs:179 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00594_InValidationExcelPopup.SetGrid_Data

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d6b5022 | this.Load | FP00594_InValidationExcelPopup.cs:236 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0d236c65 | this.Load | FP00594_InValidationExcelPopup.cs:240 | try | GRID_BIND | siMain.Query | (_dsSheet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f05e3c9e | this.Load | FP00594_InValidationExcelPopup.cs:245 | try ▸ if (_dsSheet.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-851d55d0 | this.Load | FP00594_InValidationExcelPopup.cs:250 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00594_InValidationExcelPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b08c1b2 | this.Load [try] | FP00594_InValidationExcelPopup.cs:190 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36e07e2e | this.Load [try] | FP00594_InValidationExcelPopup.cs:191 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-6b3455bd | this.Load [try] | FP00594_InValidationExcelPopup.cs:195 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-3a97107d | this.Load [try] | FP00594_InValidationExcelPopup.cs:196 |  | GRID_INIT | siMain.Freeze | (0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00594_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09b7a55b | this.btnButtonList.UsrButtonList_Click_Detected | FP00594_ItemPopup.cs:370 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-162c473f | this.btnButtonList.UsrButtonList_Click_Detected | FP00594_ItemPopup.cs:373 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-043db6ce | this.btnButtonList.UsrButtonList_Click_Detected | FP00594_ItemPopup.cs:374 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f90ebdd1 | this.Load | FP00594_ItemPopup.cs:133 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bcfa8ad7 | this.Load | FP00594_ItemPopup.cs:134 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-489862e7 | this.Load | FP00594_ItemPopup.cs:135 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00594_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a713ece | this.Load | FP00594_ItemPopup.cs:128 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00594_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9e3af17 | Dispose | FP00594_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00594_ItemPopup.Find_Data_Item

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d925dc34 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:294 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_LINE_ADD_SAVE") ⇒ FP_Planning.PR_UI_FP00622_LINE_ADD_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-82523d34 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:295 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1230e2ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:297 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-ba6f4389 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:298 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c25a9ced | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:299 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-76f64331 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:300 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-5ea4f72a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:302 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-16a12a85 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:303 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0a4ee6c9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:304 | try | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fed902a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:305 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-57563703 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:306 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-939775be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:307 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-94592ba7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:308 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eb3f2943 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:310 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e9f4fcc6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:311 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7838ed21 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:312 | try | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-12f2e72c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:313 | try | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d0ff9857 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:314 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2ba7a40a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:315 | try | DATA_OP | req.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f5b0fbb4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:317 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d735fc61 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:318 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b248a18c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:319 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f780322 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:320 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-147738f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:321 | try | DATA_OP | req.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-16f4bfb5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:322 | try | DATA_OP | req.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-99c17f5b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:324 | try | DATA_OP | req.Parameters["p_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-027264ad | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:325 | try | DATA_OP | req.Parameters["p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ef1ee405 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:326 | try | DATA_OP | req.Parameters["p_cell_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e1e561c1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:327 | try | DATA_OP | req.Parameters["p_cell_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-af4237c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:328 | try | DATA_OP | req.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-16d63a85 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:331 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f127eda1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:332 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c385ddcd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:339 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91f79a8d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:224 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8c595600 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:234 | try ▸ if (amend_instance == "LINE_AMEND_E_PRE") | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-67620072 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:238 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Item("SELECT", item_cond) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e695b948 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:245 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b29f3aaa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:248 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-25d2b940 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:250 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2a7e3f12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:258 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-02792ff5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00594_ItemPopup.cs:264 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00594_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c08609e0 | this.Load | FP00594_ItemPopup.cs:105 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ecf1791e | this.Load | FP00594_ItemPopup.cs:107 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00594_ItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53a52793 | this.Load | FP00594_ItemPopup.cs:122 |  | VALUE_SET | txtModel.Text | Filter["TOP_ITEM_ID"] | 컨트롤 값 설정 |  |  |  |

## FP00594_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57693e52 | this.Load | FP00594_ItemPopup.cs:145 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b2cdd5a | this.Load | FP00594_ItemPopup.cs:146 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00594_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b263f7c7 | (진입점 미연결) | FP00594_ItemPopup.cs:183 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00594_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-761728c0 | this.Load | FP00594_ItemPopup.cs:152 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-254950e7 | this.Load | FP00594_ItemPopup.cs:153 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-10368a54 | this.Load | FP00594_ItemPopup.cs:157 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-161134d1 | this.Load | FP00594_ItemPopup.cs:163 | if (amend_instance == "LINE_AMEND_E_PRE") | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.PLANT_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-3d77984a | this.Load | FP00594_ItemPopup.cs:164 | if (amend_instance == "LINE_AMEND_E_PRE") | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.MODEL_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-be5490fe | this.Load | FP00594_ItemPopup.cs:166 | if (amend_instance == "LINE_AMEND_E_PRE") | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), true) | 그리드 표시 설정 |  |  |  |
| AC-e74fcee2 | this.Load | FP00594_ItemPopup.cs:167 | if (amend_instance == "LINE_AMEND_E_PRE") | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.SITE_ID), true) | 그리드 표시 설정 |  |  |  |
| AC-f623d1d2 | this.Load | FP00594_ItemPopup.cs:168 | if (amend_instance == "LINE_AMEND_E_PRE") | GRID_STYLE | spdMain.Sheets[0].SetColumnWidth | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), 80) | 그리드 표시 설정 |  |  |  |
| AC-361c2146 | this.Load | FP00594_ItemPopup.cs:169 | if (amend_instance == "LINE_AMEND_E_PRE") | GRID_STYLE | spdMain.Sheets[0].SetColumnWidth | (siMain.GetColumnIndex(DefColumns.SITE_ID), 80) | 그리드 표시 설정 |  |  |  |
| AC-f41a5162 | this.Load | FP00594_ItemPopup.cs:170 | if (amend_instance == "LINE_AMEND_E_PRE") | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dbd21880 | this.Load | FP00594_ItemPopup.cs:174 | else of (amend_instance == "LINE_AMEND_E_PRE") | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.PLANT_ID), true) | 그리드 표시 설정 |  |  |  |
| AC-9d1657a4 | this.Load | FP00594_ItemPopup.cs:175 | else of (amend_instance == "LINE_AMEND_E_PRE") | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.MODEL_ID), true) | 그리드 표시 설정 |  |  |  |
| AC-3778c255 | this.Load | FP00594_ItemPopup.cs:176 | else of (amend_instance == "LINE_AMEND_E_PRE") | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-c5b192d6 | this.Load | FP00594_ItemPopup.cs:177 | else of (amend_instance == "LINE_AMEND_E_PRE") | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.SITE_ID), false) | 그리드 표시 설정 |  |  |  |

## FP00594_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7913d6b0 | this.spdMain.CellClick | FP00594_ItemPopup.cs:385 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-ede046cd | this.spdMain.CellClick | FP00594_ItemPopup.cs:386 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-df407406 | this.spdMain.CellClick | FP00594_ItemPopup.cs:389 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00594_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4b96f9c | this.spdMain.CellDoubleClick | FP00594_ItemPopup.cs:395 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-d0b80a4f | this.spdMain.CellDoubleClick | FP00594_ItemPopup.cs:396 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-910f13b6 | this.spdMain.CellDoubleClick | FP00594_ItemPopup.cs:399 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-f25159a1 | this.spdMain.CellDoubleClick | FP00594_ItemPopup.cs:402 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e171d796 | this.spdMain.CellDoubleClick | FP00594_ItemPopup.cs:412 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_LineAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90abeea1 | .ctor | FP00594_LineAddPopup.cs:97 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-fb293f91 | .ctor | FP00594_LineAddPopup.cs:98 |  | FLAG | this.InitRow | initRow | 화면 필드/플래그 변경 |  |  |  |

## FP00594_LineAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b44871a3 | this.btnClose.Click | FP00594_LineAddPopup.cs:368 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_LineAddPopup.btnLine_Click

진입점: this.btnLine.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad9c5967 | this.btnLine.Click | FP00594_LineAddPopup.cs:883 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert material value") | 메시지 표시 |  |  |  |
| AC-da8dd8de | this.btnLine.Click | FP00594_LineAddPopup.cs:884 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2c246ff | this.btnLine.Click | FP00594_LineAddPopup.cs:888 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a30ef26d | this.btnLine.Click | FP00594_LineAddPopup.cs:894 | if (dtCurrWeek != null) ▸ if (dtCurrWeek.Rows.Count > 0) | DATA_OP | Filter["RELEASE_VALUE"] | dtCurrWeek.Rows[0]["RELEASE_VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-559bccf0 | this.btnLine.Click | FP00594_LineAddPopup.cs:901 |  | POPUP | new FP00602_LinePopup | () | 팝업/폼 생성 |  |  |  |
| AC-22702b8f | this.btnLine.Click | FP00594_LineAddPopup.cs:902 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-6b82cf24 | this.btnLine.Click | FP00594_LineAddPopup.cs:903 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-50d184a6 | this.btnLine.Click | FP00594_LineAddPopup.cs:905 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-71650182 | this.btnLine.Click | FP00594_LineAddPopup.cs:906 |  | DATA_OP | popup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-05372464 | this.btnLine.Click | FP00594_LineAddPopup.cs:907 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-eddbbe4a | this.btnLine.Click | FP00594_LineAddPopup.cs:908 |  | DATA_OP | popup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c74abe82 | this.btnLine.Click | FP00594_LineAddPopup.cs:910 |  | DATA_OP | popup.Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8a85feb6 | this.btnLine.Click | FP00594_LineAddPopup.cs:911 |  | DATA_OP | popup.Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-bd69d57c | this.btnLine.Click | FP00594_LineAddPopup.cs:912 |  | DATA_OP | popup.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-45bf4799 | this.btnLine.Click | FP00594_LineAddPopup.cs:913 |  | DATA_OP | popup.Filter["RELEASE_VALUE"] | Filter["RELEASE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-19e90701 | this.btnLine.Click | FP00594_LineAddPopup.cs:914 |  | DATA_OP | popup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-062a0298 | this.btnLine.Click | FP00594_LineAddPopup.cs:915 |  | DATA_OP | popup.Filter["PRODUCTION_TYPE"] | Filter["PRODTYPE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f33a03b2 | this.btnLine.Click | FP00594_LineAddPopup.cs:916 |  | DATA_OP | popup.Filter["MARKET"] | Filter["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-d79b4b7e | this.btnLine.Click | FP00594_LineAddPopup.cs:918 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4356388b | this.btnLine.Click | FP00594_LineAddPopup.cs:920 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8474e320 | this.btnLine.Click | FP00594_LineAddPopup.cs:925 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["FACTORY_ID"] | txtBuilding.Text = data["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc45945f | this.btnLine.Click | FP00594_LineAddPopup.cs:925 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtBuilding.Text | data["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f453879c | this.btnLine.Click | FP00594_LineAddPopup.cs:926 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["OPERATION_ID"] | txtOperation.Text = data["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-17abf9f5 | this.btnLine.Click | FP00594_LineAddPopup.cs:926 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtOperation.Text | data["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-caecc83c | this.btnLine.Click | FP00594_LineAddPopup.cs:927 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["LINE_ID"] | txtLine.Text = data["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f9503701 | this.btnLine.Click | FP00594_LineAddPopup.cs:927 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtLine.Text | data["LINE_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-22f3fea6 | this.btnLine.Click | FP00594_LineAddPopup.cs:928 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | txtElectrodType.Text = data["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d97b79df | this.btnLine.Click | FP00594_LineAddPopup.cs:928 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtElectrodType.Text | data["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b8a382a4 | this.btnLine.Click | FP00594_LineAddPopup.cs:929 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["LOCATION"] | txtLocation.Text = data["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-be8b3bc3 | this.btnLine.Click | FP00594_LineAddPopup.cs:929 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtLocation.Text | data["LOCATION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-66d6fa14 | this.btnLine.Click | FP00594_LineAddPopup.cs:930 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["PLM_EC_NO"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-1f89c734 | this.btnLine.Click | FP00594_LineAddPopup.cs:931 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["VERSION"] | txtVersion.Text = data["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-de19b900 | this.btnLine.Click | FP00594_LineAddPopup.cs:931 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtVersion.Text | data["VERSION"].ToString() | 컨트롤 값 설정 |  |  |  |

## FP00594_LineAddPopup.btnMaterial_Click

진입점: this.btnMaterial.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adf2c389 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:833 |  | POPUP | new FP00594_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f7576661 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:834 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-3abc111c | this.btnMaterial.Click | FP00594_LineAddPopup.cs:835 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-993a0414 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:836 |  | DATA_OP | popup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8672991e | this.btnMaterial.Click | FP00594_LineAddPopup.cs:837 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b9337503 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:838 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-91bcfd91 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:839 |  | DATA_OP | popup.Filter["TOP_ITEM_ID"] | txtModel.Text | 행/컬럼 값 대입 |  |  |  |
| AC-0eb9d593 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:840 |  | DATA_OP | popup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fb1cbf0d | this.btnMaterial.Click | FP00594_LineAddPopup.cs:841 |  | DATA_OP | popup.Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b96e9ace | this.btnMaterial.Click | FP00594_LineAddPopup.cs:843 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-00065142 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:845 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f9019eda | this.btnMaterial.Click | FP00594_LineAddPopup.cs:850 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["MODEL_ID"] | Filter["TOP_ITEM_ID"] = txtModel.Text = data["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6be6f2b5 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:850 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["TOP_ITEM_ID"] | txtModel.Text = data["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8f45b6ef | this.btnMaterial.Click | FP00594_LineAddPopup.cs:850 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtModel.Text | data["MODEL_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5ae8ec04 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:851 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ITEM_ID"] | txtItem.Text = data["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b6b7e3d | this.btnMaterial.Click | FP00594_LineAddPopup.cs:851 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItem.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-e5aa90f5 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:852 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text = data["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9078c283 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:852 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtNickName.Text | data["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-53dd191f | this.btnMaterial.Click | FP00594_LineAddPopup.cs:853 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ITEM_TYPE"] | txtItemType.Text = data["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-959acf29 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:853 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItemType.Text | data["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-39516790 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:856 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtBuilding.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-715460c1 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:857 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtOperation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-32a01b11 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:858 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtLine.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-74fb2d95 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:859 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtElectrodType.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-433e2148 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:860 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtLocation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-c4daa756 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:861 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtVersion.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-47603dc7 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:863 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e9e122b6 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:864 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-97c81bf4 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:865 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("LINE_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c9a5a0e8 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:866 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-625ed3ba | this.btnMaterial.Click | FP00594_LineAddPopup.cs:867 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("LOCATION", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a11d22ce | this.btnMaterial.Click | FP00594_LineAddPopup.cs:868 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("PLM_EC_NO", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-daf57459 | this.btnMaterial.Click | FP00594_LineAddPopup.cs:869 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("VERSION", "") | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00594_LineAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de875ac8 | this.btnSave.Click | FP00594_LineAddPopup.cs:361 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00594_LineAddPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f88ccb5 | this.btnSql.Click | FP00594_LineAddPopup.cs:946 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-d0ad39c5 | this.btnSql.Click | FP00594_LineAddPopup.cs:949 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-98d0aa3f | this.btnSql.Click | FP00594_LineAddPopup.cs:950 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-74d6c543 | this.btnSql.Click | FP00594_LineAddPopup.cs:952 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00622_LINE_ADD_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3fa63b1 | this.btnSql.Click | FP00594_LineAddPopup.cs:954 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00594_LineAddPopup.CbMPP_CheckedChanged

진입점: cbMPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66a6cdc6 | cbMPP.CheckedChanged | FP00594_LineAddPopup.cs:296 | if (cbMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-63377c40 | cbMPP.CheckedChanged | FP00594_LineAddPopup.cs:297 | if (cbMPP.Checked == true) | VALUE_SET | cbWPP.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-2b204b84 | cbMPP.CheckedChanged | FP00594_LineAddPopup.cs:301 | else of (cbMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-01ca9f24 | cbMPP.CheckedChanged | FP00594_LineAddPopup.cs:302 | else of (cbMPP.Checked == true) | VALUE_SET | cbWPP.Checked | true | 컨트롤 값 설정 |  |  |  |

## FP00594_LineAddPopup.cbo_market_changed

진입점: cbo_market.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c8d3f43 | cbo_market.SelectedIndexChanged | FP00594_LineAddPopup.cs:331 |  | DATA_OP | Filter["MARKET"] | CString.GetCheckedListValue(dtMarket, cbo_market.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-d0841de9 | cbo_market.SelectedIndexChanged | FP00594_LineAddPopup.cs:332 |  | DATA_OP | Filter["PLM_EC_NO"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-8906c95d | cbo_market.SelectedIndexChanged | FP00594_LineAddPopup.cs:333 |  | DATA_OP | Filter["VERSION"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-2a5edeeb | cbo_market.SelectedIndexChanged | FP00594_LineAddPopup.cs:335 |  | VALUE_CLEAR | txtVersion.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-f22c8a25 | cbo_market.SelectedIndexChanged | FP00594_LineAddPopup.cs:337 |  | DATA_OP | dtSave.SetFirst | ("PLM_EC_NO", string.Empty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-edc15c0b | cbo_market.SelectedIndexChanged | FP00594_LineAddPopup.cs:338 |  | DATA_OP | dtSave.SetFirst | ("VERSION", string.Empty) | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00594_LineAddPopup.cbo_prodtype_changed

진입점: cbo_prodtype.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0727210 | cbo_prodtype.SelectedIndexChanged | FP00594_LineAddPopup.cs:343 |  | DATA_OP | Filter["PRODTYPE_ID"] | CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-9b4724a4 | cbo_prodtype.SelectedIndexChanged | FP00594_LineAddPopup.cs:344 |  | DATA_OP | Filter["PRODDUCTION_TYPE"] | CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-27262167 | cbo_prodtype.SelectedIndexChanged | FP00594_LineAddPopup.cs:345 |  | DATA_OP | Filter["PLM_EC_NO"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-805be879 | cbo_prodtype.SelectedIndexChanged | FP00594_LineAddPopup.cs:346 |  | DATA_OP | Filter["VERSION"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-5a9c35e7 | cbo_prodtype.SelectedIndexChanged | FP00594_LineAddPopup.cs:348 |  | VALUE_CLEAR | txtVersion.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-190faa6f | cbo_prodtype.SelectedIndexChanged | FP00594_LineAddPopup.cs:350 |  | DATA_OP | dtSave.SetFirst | ("PLM_EC_NO", string.Empty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-16ce5e32 | cbo_prodtype.SelectedIndexChanged | FP00594_LineAddPopup.cs:351 |  | DATA_OP | dtSave.SetFirst | ("VERSION", string.Empty) | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00594_LineAddPopup.CbWPP_CheckedChanged

진입점: cbWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b9f371a | cbWPP.CheckedChanged | FP00594_LineAddPopup.cs:316 | if (cbWPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-16298a07 | cbWPP.CheckedChanged | FP00594_LineAddPopup.cs:317 | if (cbWPP.Checked == true) | VALUE_SET | cbMPP.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-ea41e193 | cbWPP.CheckedChanged | FP00594_LineAddPopup.cs:321 | else of (cbWPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-4af4aa30 | cbWPP.CheckedChanged | FP00594_LineAddPopup.cs:322 | else of (cbWPP.Checked == true) | VALUE_SET | cbMPP.Checked | true | 컨트롤 값 설정 |  |  |  |

## FP00594_LineAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd0ec251 | this.btnSave.Click | FP00594_LineAddPopup.cs:379 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | MESSAGE | MessageBox.Show | ("You need to select line data") | 메시지 표시 |  |  |  |
| AC-1e86627c | this.btnSave.Click | FP00594_LineAddPopup.cs:380 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d1efca67 | this.btnSave.Click | FP00594_LineAddPopup.cs:384 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | MESSAGE | MessageBox.Show | ("You need to specify quantity") | 메시지 표시 |  |  |  |
| AC-76d102d3 | this.btnSave.Click | FP00594_LineAddPopup.cs:385 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8dfdd1c5 | this.btnSave.Click | FP00594_LineAddPopup.cs:393 | catch () | MESSAGE | MessageBox.Show | ("You shoud insert quantity as number") | 메시지 표시 |  |  |  |
| AC-e94edba3 | this.btnSave.Click | FP00594_LineAddPopup.cs:394 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ecd38112 | this.btnSave.Click | FP00594_LineAddPopup.cs:414 | if (!string.IsNullOrEmpty(sMsg)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-80eacc12 | this.btnSave.Click | FP00594_LineAddPopup.cs:415 | if (!string.IsNullOrEmpty(sMsg)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-90089386 | this.btnSave.Click | FP00594_LineAddPopup.cs:422 | if (string.IsNullOrWhiteSpace(ver)) | MESSAGE | MessageBox.Show | ("You need to select Version.") | 메시지 표시 |  |  |  |
| AC-5892f9ea | this.btnSave.Click | FP00594_LineAddPopup.cs:423 | if (string.IsNullOrWhiteSpace(ver)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0f8f932c | this.btnSave.Click | FP00594_LineAddPopup.cs:426 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00594_LineAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da799047 | Dispose | FP00594_LineAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00594_LineAddPopup.dpPlanDate_ValueChanged

진입점: this.dpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5f76c9d | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:791 |  | VALUE_CLEAR | txtModel.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-9a73960b | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:792 |  | VALUE_CLEAR | txtItem.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-e6c55e58 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:793 |  | VALUE_CLEAR | txtNickName.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-d1e9f2a3 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:794 |  | VALUE_CLEAR | txtItemType.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-757c94ae | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:795 |  | VALUE_CLEAR | txtBuilding.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-59dc0683 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:796 |  | VALUE_CLEAR | txtOperation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-8c05a1fd | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:797 |  | VALUE_CLEAR | txtLine.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-eb3886a6 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:798 |  | VALUE_CLEAR | txtElectrodType.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-cf63b2fd | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:799 |  | VALUE_CLEAR | txtLocation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-3c2ea1bb | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:800 |  | VALUE_CLEAR | txtQty.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-7d0b4050 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:802 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1023b8cd | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:803 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9e026e89 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:804 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-523191c4 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:805 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-119b4bff | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:806 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4065201a | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:807 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b2ef02a5 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:808 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d6c09e56 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:809 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-17bf3947 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:810 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6ac9c3c5 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:811 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ee680058 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:812 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-608582c1 | this.dpPlanDate.ValueChanged | FP00594_LineAddPopup.cs:813 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", "") | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00594_LineAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4390537b | this.Load | FP00594_LineAddPopup.cs:111 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3474c80d | this.Load | FP00594_LineAddPopup.cs:113 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7d2ee6b1 | this.Load | FP00594_LineAddPopup.cs:121 |  | FLAG | dtSave | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-0bde20dc | this.Load | FP00594_LineAddPopup.cs:122 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0910833 | this.Load | FP00594_LineAddPopup.cs:123 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-96a080f9 | this.Load | FP00594_LineAddPopup.cs:124 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ccccf5c | this.Load | FP00594_LineAddPopup.cs:126 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b28c3d1 | this.Load | FP00594_LineAddPopup.cs:127 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-66d4923a | this.Load | FP00594_LineAddPopup.cs:128 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a570cc28 | this.Load | FP00594_LineAddPopup.cs:129 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-accc5aa7 | this.Load | FP00594_LineAddPopup.cs:130 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6984f6de | this.Load | FP00594_LineAddPopup.cs:131 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e3063ab | this.Load | FP00594_LineAddPopup.cs:132 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("NICK_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-448d4048 | this.Load | FP00594_LineAddPopup.cs:133 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-70fdf5f7 | this.Load | FP00594_LineAddPopup.cs:134 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-708fe471 | this.Load | FP00594_LineAddPopup.cs:135 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-de10065b | this.Load | FP00594_LineAddPopup.cs:136 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee65b805 | this.Load | FP00594_LineAddPopup.cs:137 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-139a0c2d | this.Load | FP00594_LineAddPopup.cs:138 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2b1abcb | this.Load | FP00594_LineAddPopup.cs:139 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-325ba35a | this.Load | FP00594_LineAddPopup.cs:140 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-125aac75 | this.Load | FP00594_LineAddPopup.cs:141 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-05e25db8 | this.Load | FP00594_LineAddPopup.cs:142 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c3ac61c | this.Load | FP00594_LineAddPopup.cs:143 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLM_EC_NO", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-30a4b61c | this.Load | FP00594_LineAddPopup.cs:144 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7827d42c | this.Load | FP00594_LineAddPopup.cs:145 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ec34299 | this.Load | FP00594_LineAddPopup.cs:148 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-26b1273b | this.Load | FP00594_LineAddPopup.cs:149 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f13a57d | this.Load | FP00594_LineAddPopup.cs:150 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("CELL_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f4433bf | this.Load | FP00594_LineAddPopup.cs:151 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("CELL_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f92e6d98 | this.Load | FP00594_LineAddPopup.cs:153 |  | DATA_OP | dtSave.Rows.Add | (dtSave.NewRow()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c598444d | this.Load | FP00594_LineAddPopup.cs:153 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |

## FP00594_LineAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9c92b2a | this.Load | FP00594_LineAddPopup.cs:169 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5fca9b7b | this.Load | FP00594_LineAddPopup.cs:173 | if (InitRow== null) | MESSAGE | MessageBox.Show | ("Please select any row before add line") | 메시지 표시 |  |  |  |
| AC-74b2b0a3 | this.Load | FP00594_LineAddPopup.cs:174 | if (InitRow== null) | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-5f30478b | this.Load | FP00594_LineAddPopup.cs:175 | if (InitRow== null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-617457ee | this.Load | FP00594_LineAddPopup.cs:179 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["FP_PLAN_DATE"] | Filter["PLAN_DATE"] = DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-5633a41d | this.Load | FP00594_LineAddPopup.cs:179 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["PLAN_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-9b73766e | this.Load | FP00594_LineAddPopup.cs:181 |  | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-61f825c1 | this.Load | FP00594_LineAddPopup.cs:183 |  | VALUE_SET | txtNickName.Text | Filter["NICK_NAME"] = InitRow["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-989f9f09 | this.Load | FP00594_LineAddPopup.cs:183 |  | DATA_OP | Filter["NICK_NAME"] | InitRow["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e1d25d2e | this.Load | FP00594_LineAddPopup.cs:184 |  | VALUE_SET | txtOperation.Text | Filter["OPERATON_ID"] = InitRow["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-54adbb34 | this.Load | FP00594_LineAddPopup.cs:184 |  | DATA_OP | Filter["OPERATON_ID"] | InitRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5f091dc6 | this.Load | FP00594_LineAddPopup.cs:185 |  | VALUE_SET | txtQty.Text | "0" | 컨트롤 값 설정 |  |  |  |
| AC-19faa4b7 | this.Load | FP00594_LineAddPopup.cs:191 |  | FLAG | dtProdType | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE_PRODTYPE, false, UserInfoContext.Current.UserId… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_PRODTYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-369a26c2 | this.Load | FP00594_LineAddPopup.cs:191 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE_PRODTYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSa… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_PRODTYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c030557f | this.Load | FP00594_LineAddPopup.cs:195 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cbo_prodtype, false, "CODE", "CODE") | 목록 컨트롤 재구성 |  |  |  |
| AC-9bd8de8b | this.Load | FP00594_LineAddPopup.cs:197 |  | VALUE_SET | cbo_prodtype.SelectedValue | Filter["PRODTYPE_ID"]= InitRow["PRODUCTION_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9be1b581 | this.Load | FP00594_LineAddPopup.cs:197 |  | DATA_OP | Filter["PRODTYPE_ID"] | InitRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c6223135 | this.Load | FP00594_LineAddPopup.cs:199 |  | VALUE_SET | txtItemType.Text | Filter["ITEM_TYPE"] = InitRow["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-87b1b3a7 | this.Load | FP00594_LineAddPopup.cs:199 |  | DATA_OP | Filter["ITEM_TYPE"] | InitRow["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-51f30ae9 | this.Load | FP00594_LineAddPopup.cs:200 |  | VALUE_SET | txtModel.Text | Filter["TOP_ITEM_ID"] = InitRow["TOP_ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-0b37c43f | this.Load | FP00594_LineAddPopup.cs:200 |  | DATA_OP | Filter["TOP_ITEM_ID"] | InitRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2ffa1e81 | this.Load | FP00594_LineAddPopup.cs:201 |  | VALUE_SET | txtItem.Text | Filter["ITEM_ID"] = InitRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-03a99c7d | this.Load | FP00594_LineAddPopup.cs:201 |  | DATA_OP | Filter["ITEM_ID"] | InitRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4c42fdd8 | this.Load | FP00594_LineAddPopup.cs:202 |  | VALUE_SET | txtBuilding.Text | Filter["FACTORY_ID"] = InitRow["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-c76b7289 | this.Load | FP00594_LineAddPopup.cs:202 |  | DATA_OP | Filter["FACTORY_ID"] | InitRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-01d14c3b | this.Load | FP00594_LineAddPopup.cs:203 |  | VALUE_SET | txtElectrodType.Text | Filter["ELECTRODE_TYPE"] = InitRow["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3263e168 | this.Load | FP00594_LineAddPopup.cs:203 |  | DATA_OP | Filter["ELECTRODE_TYPE"] | InitRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f9c2b01 | this.Load | FP00594_LineAddPopup.cs:204 |  | VALUE_SET | txtLocation.Text | Filter["LOCATION"] = InitRow["LOCATION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-898edb40 | this.Load | FP00594_LineAddPopup.cs:204 |  | DATA_OP | Filter["LOCATION"] | InitRow["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0773cd25 | this.Load | FP00594_LineAddPopup.cs:209 | if (Filter["PLAN_TYPE"] == "RELEASE") | VALUE_SET | labelTitle.Text | " Add Line - MPP WPP" | 컨트롤 값 설정 |  |  |  |
| AC-0259879b | this.Load | FP00594_LineAddPopup.cs:210 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | layoutControlItem36.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-da4e7448 | this.Load | FP00594_LineAddPopup.cs:211 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcMPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c286d839 | this.Load | FP00594_LineAddPopup.cs:212 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b19b3389 | this.Load | FP00594_LineAddPopup.cs:216 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | VALUE_SET | cbWPP.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-71a0bd05 | this.Load | FP00594_LineAddPopup.cs:217 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | VALUE_SET | cbMPP.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-5659236c | this.Load | FP00594_LineAddPopup.cs:221 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (Filter["MPP_WPP"] == "MPP") | VALUE_SET | cbWPP.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-90959fc1 | this.Load | FP00594_LineAddPopup.cs:222 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (Filter["MPP_WPP"] == "MPP") | VALUE_SET | cbMPP.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-b5dc70bd | this.Load | FP00594_LineAddPopup.cs:230 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | layoutControlItem36.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9fd7180c | this.Load | FP00594_LineAddPopup.cs:231 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcMPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2171056e | this.Load | FP00594_LineAddPopup.cs:232 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9ffdeb03 | this.Load | FP00594_LineAddPopup.cs:235 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5a722305 | this.Load | FP00594_LineAddPopup.cs:236 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f69d34f7 | this.Load | FP00594_LineAddPopup.cs:237 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", Filter["PLAN_DATE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3c722c59 | this.Load | FP00594_LineAddPopup.cs:239 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ed5adb68 | this.Load | FP00594_LineAddPopup.cs:240 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-def4e53f | this.Load | FP00594_LineAddPopup.cs:241 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-69ca1032 | this.Load | FP00594_LineAddPopup.cs:242 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7312f578 | this.Load | FP00594_LineAddPopup.cs:243 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6512bca7 | this.Load | FP00594_LineAddPopup.cs:244 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4377bc8c | this.Load | FP00594_LineAddPopup.cs:245 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-12670e67 | this.Load | FP00594_LineAddPopup.cs:246 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", Filter["PRODUCTION_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4307382c | this.Load | FP00594_LineAddPopup.cs:247 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2bdd427c | this.Load | FP00594_LineAddPopup.cs:248 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", Filter["OPERATION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f99739d5 | this.Load | FP00594_LineAddPopup.cs:249 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", Filter["LINE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-02728b3b | this.Load | FP00594_LineAddPopup.cs:250 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", Filter["ELECTRODE_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5a955dab | this.Load | FP00594_LineAddPopup.cs:251 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", Filter["LOCATION"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a75bc8c5 | this.Load | FP00594_LineAddPopup.cs:256 |  | FLAG | dtMarket | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP00594_LineAddPopup", "MARKET_TYPE… | 화면 필드/플래그 변경 |  |  |  |
| AC-a8873a0c | this.Load | FP00594_LineAddPopup.cs:256 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP00594_LineAddPopup", "MARKET_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f86a8cfb | this.Load | FP00594_LineAddPopup.cs:265 |  | LIST_REBIND | clsCtrl.setListBox | (dtMarket, cbo_market, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a84dbd19 | this.Load | FP00594_LineAddPopup.cs:266 |  | VALUE_SET | cbo_market.SelectedValue | Filter["MARKET"] = InitRow["MARKET"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-457b293f | this.Load | FP00594_LineAddPopup.cs:266 |  | DATA_OP | Filter["MARKET"] | InitRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3a88613a | this.Load | FP00594_LineAddPopup.cs:272 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-6e6c122b | this.Load | FP00594_LineAddPopup.cs:273 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-34801e63 | this.Load | FP00594_LineAddPopup.cs:274 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00594_LineAddPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bd8520f | popSql.OnSql | FP00594_LineAddPopup.cs:969 | if (programID == "PR_UI_FP00622_LINE_ADD_SAVE") ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return Save_Data_Add( "SQL","INSERT_ADD_MPPWPP"); |  | 처리 중단/반환 |  |  |  |
| AC-013eb495 | popSql.OnSql | FP00594_LineAddPopup.cs:974 | if (programID == "PR_UI_FP00622_LINE_ADD_SAVE") ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return Save_Data_Add("SQL", "INSERT_ADD_LINE"); |  | 처리 중단/반환 |  |  |  |
| AC-dbeab301 | popSql.OnSql | FP00594_LineAddPopup.cs:981 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_LineAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e81797d | this.btnSave.Click | FP00594_LineAddPopup.cs:437 |  | DATA_OP | Filter["PLM_EC_NO"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-610c0700 | this.btnSave.Click | FP00594_LineAddPopup.cs:438 |  | DATA_OP | Filter["VERSION"] | txtVersion.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c3bf20e3 | this.btnSave.Click | FP00594_LineAddPopup.cs:439 |  | DATA_OP | Filter["PRODTYPE_ID"] | Filter["PRODUCTION_TYPE"] = CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlVa… | 행/컬럼 값 대입 |  |  |  |
| AC-92b9e4a4 | this.btnSave.Click | FP00594_LineAddPopup.cs:439 |  | DATA_OP | Filter["PRODUCTION_TYPE"] | CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-3d4197c0 | this.btnSave.Click | FP00594_LineAddPopup.cs:440 |  | DATA_OP | Filter["MARKET"] | cbo_market.ControlValues.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-939a0324 | this.btnSave.Click | FP00594_LineAddPopup.cs:441 |  | DATA_OP | Filter["DATE"] | dpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-30bb8109 | this.btnSave.Click | FP00594_LineAddPopup.cs:442 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5d494255 | this.btnSave.Click | FP00594_LineAddPopup.cs:446 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00602_LineAdd", "find_LineAdd_dup", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineAdd_dup] \| FP\Common\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-28dcbfdd | this.btnSave.Click | FP00594_LineAddPopup.cs:454 | else of (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00602_LineAdd", "find_dup", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dup] \| FP\Common\FP00602_… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2451b9a4 | this.btnSave.Click | FP00594_LineAddPopup.cs:472 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | MESSAGE | MessageBox.Show | ("The Line or detail information is already exists.") | 메시지 표시 |  |  |  |
| AC-23debcba | this.btnSave.Click | FP00594_LineAddPopup.cs:473 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa1c0765 | this.btnSave.Click | FP00594_LineAddPopup.cs:480 | if ((target_info.Good() && (target_info.Rows[0]["MSG1"].ToString()!=string.Empty \|\|target_info.Rows[0]["MSG2"].ToString() !=…) | MESSAGE | MessageBox.Show | ("Can not find Target Infomation.") | 메시지 표시 |  |  |  |
| AC-69ffa75e | this.btnSave.Click | FP00594_LineAddPopup.cs:481 | if ((target_info.Good() && (target_info.Rows[0]["MSG1"].ToString()!=string.Empty \|\|target_info.Rows[0]["MSG2"].ToString() !=…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22bf3976 | this.btnSave.Click | FP00594_LineAddPopup.cs:488 | if (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3c82ddc8 | this.btnSave.Click | FP00594_LineAddPopup.cs:495 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString().Equals("Y")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-64ca392a | this.btnSave.Click | FP00594_LineAddPopup.cs:497 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString().Equals("Y")) | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-c18b9865 | this.btnSave.Click | FP00594_LineAddPopup.cs:501 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9e3be6e2 | this.btnSave.Click | FP00594_LineAddPopup.cs:513 | if (dtCheckSave != null) ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + strMsg) | 메시지 표시 |  |  |  |
| AC-2c5aa52e | this.btnSave.Click | FP00594_LineAddPopup.cs:514 | if (dtCheckSave != null) ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9aa5a780 | this.btnSave.Click | FP00594_LineAddPopup.cs:518 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0df4deb6 | this.btnSave.Click | FP00594_LineAddPopup.cs:519 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d79d71f1 | this.btnSave.Click | FP00594_LineAddPopup.cs:520 |  | DATA_OP | dtSave.SetFirst | ("FP_PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-57b1279a | this.btnSave.Click | FP00594_LineAddPopup.cs:522 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-97a78bda | this.btnSave.Click | FP00594_LineAddPopup.cs:523 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6220d541 | this.btnSave.Click | FP00594_LineAddPopup.cs:524 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5596b1ee | this.btnSave.Click | FP00594_LineAddPopup.cs:525 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-339fbf9c | this.btnSave.Click | FP00594_LineAddPopup.cs:526 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4ce7ed66 | this.btnSave.Click | FP00594_LineAddPopup.cs:527 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2523a2ce | this.btnSave.Click | FP00594_LineAddPopup.cs:528 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-693bb095 | this.btnSave.Click | FP00594_LineAddPopup.cs:529 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-99c78354 | this.btnSave.Click | FP00594_LineAddPopup.cs:530 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2abb6707 | this.btnSave.Click | FP00594_LineAddPopup.cs:531 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", txtElectrodType.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-bc34c19d | this.btnSave.Click | FP00594_LineAddPopup.cs:532 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", txtOperation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-513c6b4e | this.btnSave.Click | FP00594_LineAddPopup.cs:533 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", txtLine.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-62dc9e98 | this.btnSave.Click | FP00594_LineAddPopup.cs:534 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", txtLocation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5295b7fb | this.btnSave.Click | FP00594_LineAddPopup.cs:535 |  | DATA_OP | dtSave.SetFirst | ("PLM_EC_NO", "-") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-645de8ea | this.btnSave.Click | FP00594_LineAddPopup.cs:536 |  | DATA_OP | dtSave.SetFirst | ("VERSION", txtVersion.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a28c2786 | this.btnSave.Click | FP00594_LineAddPopup.cs:538 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", cbo_prodtype.SelectedValue.ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f98ba1ed | this.btnSave.Click | FP00594_LineAddPopup.cs:539 |  | DATA_OP | dtSave.SetFirst | ("MARKET", cbo_market.SelectedValue.ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-464bec25 | this.btnSave.Click | FP00594_LineAddPopup.cs:540 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ee6f342d | this.btnSave.Click | FP00594_LineAddPopup.cs:541 |  | DATA_OP | dtSave.SetFirst | ("DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-08dbcdd8 | this.btnSave.Click | FP00594_LineAddPopup.cs:543 |  | DATA_OP | dtSave.SetFirst | ("IN_QTY", "WPP_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d6cd9a79 | this.btnSave.Click | FP00594_LineAddPopup.cs:544 |  | DATA_OP | dtSave.SetFirst | ("OUT_QTY", "WPP_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-43968019 | this.btnSave.Click | FP00594_LineAddPopup.cs:545 |  | DATA_OP | dtSave.SetFirst | ("CELL_IN_QTY", "WPP_CELL_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-56721348 | this.btnSave.Click | FP00594_LineAddPopup.cs:546 |  | DATA_OP | dtSave.SetFirst | ("CELL_OUT_QTY", "WPP_CELL_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d1605fa9 | this.btnSave.Click | FP00594_LineAddPopup.cs:548 |  | DATA_OP | dtSave.SetFirst | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f16d66fd | this.btnSave.Click | FP00594_LineAddPopup.cs:552 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | Filter["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-31c57481 | this.btnSave.Click | FP00594_LineAddPopup.cs:554 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("IN_QTY", "MPP_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5a305160 | this.btnSave.Click | FP00594_LineAddPopup.cs:555 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("OUT_QTY", "MPP_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8fbb0edf | this.btnSave.Click | FP00594_LineAddPopup.cs:556 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_IN_QTY", "MPP_CELL_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c6736f20 | this.btnSave.Click | FP00594_LineAddPopup.cs:557 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_OUT_QTY", "MPP_CELL_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0ba2a075 | this.btnSave.Click | FP00594_LineAddPopup.cs:567 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-cec24ecf | this.btnSave.Click | FP00594_LineAddPopup.cs:568 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e6f1847 | this.btnSave.Click | FP00594_LineAddPopup.cs:570 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6437604e | this.btnSave.Click | FP00594_LineAddPopup.cs:574 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dtSave.Columns.Contains | ("MPP_WPP") | 데이터 객체 조작/조회 |  |  |  |
| AC-53d55ae7 | this.btnSave.Click | FP00594_LineAddPopup.cs:575 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dtSave.Columns.Contains("MPP_WPP")) | DATA_OP | dtSave.Columns.Add | (new DataColumn("MPP_WPP", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3229829a | this.btnSave.Click | FP00594_LineAddPopup.cs:576 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dtSave.Columns.Contains | ("IN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd3c929f | this.btnSave.Click | FP00594_LineAddPopup.cs:577 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dtSave.Columns.Contains("IN_QTY")) | DATA_OP | dtSave.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-46307c58 | this.btnSave.Click | FP00594_LineAddPopup.cs:578 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dtSave.Columns.Contains | ("OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-aa0f0d66 | this.btnSave.Click | FP00594_LineAddPopup.cs:579 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dtSave.Columns.Contains("OUT_QTY")) | DATA_OP | dtSave.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-afd9a818 | this.btnSave.Click | FP00594_LineAddPopup.cs:580 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dtSave.Columns.Contains | ("CELL_IN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-024b2ed9 | this.btnSave.Click | FP00594_LineAddPopup.cs:581 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dtSave.Columns.Contains("CELL_IN_QTY")) | DATA_OP | dtSave.Columns.Add | (new DataColumn("CELL_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5e06e59 | this.btnSave.Click | FP00594_LineAddPopup.cs:582 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dtSave.Columns.Contains | ("CELL_OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff273740 | this.btnSave.Click | FP00594_LineAddPopup.cs:583 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dtSave.Columns.Contains("CELL_OUT_QTY")) | DATA_OP | dtSave.Columns.Add | (new DataColumn("CELL_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b7a208b | this.btnSave.Click | FP00594_LineAddPopup.cs:585 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dtSave.SetFirst | ("MPP_WPP", Filter["MPP_WPP"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fc0cbb92 | this.btnSave.Click | FP00594_LineAddPopup.cs:589 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("IN_QTY", "MPP_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-013e45b9 | this.btnSave.Click | FP00594_LineAddPopup.cs:590 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("OUT_QTY", "MPP_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0680a48e | this.btnSave.Click | FP00594_LineAddPopup.cs:591 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_IN_QTY", "MPP_CELL_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-de858f6c | this.btnSave.Click | FP00594_LineAddPopup.cs:592 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_OUT_QTY", "MPP_CELL_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-efadc58d | this.btnSave.Click | FP00594_LineAddPopup.cs:596 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("IN_QTY", "WPP_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-938cd073 | this.btnSave.Click | FP00594_LineAddPopup.cs:597 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("OUT_QTY", "WPP_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9e6b5748 | this.btnSave.Click | FP00594_LineAddPopup.cs:598 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_IN_QTY", "WPP_CELL_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b3bea03b | this.btnSave.Click | FP00594_LineAddPopup.cs:599 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_OUT_QTY", "WPP_CELL_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f4d98aeb | this.btnSave.Click | FP00594_LineAddPopup.cs:603 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | src.Tables.Add | (dtSave) | 데이터 객체 조작/조회 |  |  |  |
| AC-fff9fc8d | this.btnSave.Click | FP00594_LineAddPopup.cs:605 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_PseudoBatch | ("FP00602_LineAdd", "saveAll_MPPWPP", src) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=saveAll_MPPWPP] \| FP\Common\FP0… | 엔드포인트 호출 |  |  |  |
| AC-75cff28a | this.btnSave.Click | FP00594_LineAddPopup.cs:606 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_PseudoBatch | ("FP00602_LineAdd", "saveAll_MPPWPP_log", src) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=saveAll_MPPWPP_log] \| FP\Common… | 엔드포인트 호출 |  |  |  |
| AC-5a8666e2 | this.btnSave.Click | FP00594_LineAddPopup.cs:634 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtSave.DataSet == null) | DATA_OP | src.Tables.Add | (dtSave) | 데이터 객체 조작/조회 |  |  |  |
| AC-52fd62ed | this.btnSave.Click | FP00594_LineAddPopup.cs:636 | else of (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00602_LineAdd", "save_all", src) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_all] \| FP\Common\FP00602_L… | 엔드포인트 호출 |  |  |  |
| AC-3683a558 | this.btnSave.Click | FP00594_LineAddPopup.cs:637 | else of (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00602_LineAdd", "save_all_log", src) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_all_log] \| FP\Common\FP006… | 엔드포인트 호출 |  |  |  |
| AC-6a954522 | this.btnSave.Click | FP00594_LineAddPopup.cs:685 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-631ffbc0 | this.btnSave.Click | FP00594_LineAddPopup.cs:686 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_LineAddPopup.Save_Data_Add

진입점: popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE") ▸ if (Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18727ae5 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:734 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_LINE_ADD_SAVE") ⇒ FP_Planning.PR_UI_FP00622_LINE_ADD_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-ce4859eb | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:735 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b4d9280e | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:737 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-938c9afa | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:738 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a15c294b | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:739 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-32dbd03c | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:740 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-3cba6d3d | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:742 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-e198d0d4 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:743 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-8e550085 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:744 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-c958ece1 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:745 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7fbd27b4 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:746 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b0ce27f2 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:747 | try | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-97b189b0 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:748 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-85dada3f | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:750 | try | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-7fc53b1e | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:751 | try | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-5473bcc2 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:752 | try | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-608b74bf | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:753 | try | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e03e332 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:754 | try | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-f1d31b42 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:755 | try | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-1b913885 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:757 | try | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-6fb3f9fa | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:758 | try | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-b9f5e6c5 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:759 | try | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-4df3d17b | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:760 | try | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-e055ba89 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:761 | try | DATA_OP | req.Parameters["p_confirm_area"] | p_confirm_area | 행/컬럼 값 대입 |  |  |  |
| AC-01579d4b | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:762 | try | DATA_OP | req.Parameters["p_release_value"] | p_release_value | 행/컬럼 값 대입 |  |  |  |
| AC-1fc5e963 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:764 | try | DATA_OP | req.Parameters["p_in_qty"] | p_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-7e542761 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:765 | try | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-83515e4f | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:766 | try | DATA_OP | req.Parameters["p_cell_in_qty"] | p_cell_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-db4bbbe5 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:767 | try | DATA_OP | req.Parameters["p_cell_out_qty"] | p_cell_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-c07bc432 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:768 | try | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-f3f7c4f7 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:770 | try | DATA_OP | req.Parameters["p_plm_ec_no"] | p_plm_ec_no | 행/컬럼 값 대입 |  |  |  |
| AC-0fd86f6d | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:771 | try | DATA_OP | req.Parameters["p_version"] | p_version | 행/컬럼 값 대입 |  |  |  |
| AC-486e00ed | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:773 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2718b6e0 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:774 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-966c3283 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:781 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_LineAddPopup.SetSaveDataTable

진입점: popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE") ▸ if (Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00898b9e | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:985 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5428f807 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:986 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a1a2e15a | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:988 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-31a9f6b4 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:989 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c1d4ecf0 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:990 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3eb6c7b7 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:991 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e8974ca7 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:992 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7f12ccc7 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:993 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5103a5fc | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:994 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-50a51873 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:995 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7ff5f5cf | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:996 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3e043031 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:997 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", txtElectrodType.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8fbd4562 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:998 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", txtOperation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-db12e04f | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:999 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", txtLine.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7a0ac43d | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1000 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", txtLocation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9cee326e | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1002 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", cbo_prodtype.SelectedItem.ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ec54d326 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1003 |  | DATA_OP | dtSave.SetFirst | ("MARKET", cbo_market.SelectedItem.ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-148ea6ba | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1004 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0a9f83d2 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1006 |  | DATA_OP | dtSave.SetFirst | ("IN_QTY", "WPP_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f21d3402 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1007 |  | DATA_OP | dtSave.SetFirst | ("OUT_QTY", "WPP_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b92d1bfe | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1008 |  | DATA_OP | dtSave.SetFirst | ("CELL_IN_QTY", "WPP_CELL_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-38cbdba8 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1009 |  | DATA_OP | dtSave.SetFirst | ("CELL_OUT_QTY", "WPP_CELL_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cd37bac4 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1013 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | Filter["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-fa1f8c15 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1015 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("IN_QTY", "MPP_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6e0d5641 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1016 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("OUT_QTY", "MPP_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6435ccb5 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1017 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_IN_QTY", "MPP_CELL_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-de8b22bd | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1018 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_OUT_QTY", "MPP_CELL_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f396da95 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1028 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-fb15f39c | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1029 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0fd531ee | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00594_LineAddPopup.cs:1031 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00594_LinePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56d0ce1b | this.btnButtonList.UsrButtonList_Click_Detected | FP00594_LinePopup.cs:354 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-66a6a4da | this.btnButtonList.UsrButtonList_Click_Detected | FP00594_LinePopup.cs:357 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1771b046 | this.btnButtonList.UsrButtonList_Click_Detected | FP00594_LinePopup.cs:358 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_LinePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebbc9704 | this.Load | FP00594_LinePopup.cs:138 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8a3984eb | this.Load | FP00594_LinePopup.cs:139 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3d3eb2f | this.Load | FP00594_LinePopup.cs:140 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00594_LinePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1e21575 | this.Load | FP00594_LinePopup.cs:133 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00594_LinePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2c7cb1a | Dispose | FP00594_LinePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00594_LinePopup.Find_Data_Line

진입점: this.Load [try ▸ lambda] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e4b073d | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:279 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_LINE_ADD_SAVE") ⇒ FP_Planning.PR_UI_FP00622_LINE_ADD_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-738c1274 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:280 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5bab542a | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:282 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-fe8c221c | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:283 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e29ce879 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:284 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-ac421a1c | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:285 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-01f5f06a | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:287 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-9dffaf7d | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:288 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7953b869 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:289 | try | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cf866898 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:290 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d95a0c93 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:291 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-fefd6c89 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:292 | try | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-06a16fde | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:293 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-32c35715 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:295 | try | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e7c0d5e | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:296 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6326de80 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:297 | try | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a00ca989 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:298 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8e597d23 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:299 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a5d8b309 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:300 | try | DATA_OP | req.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d5112c4 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:302 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-46bc44e9 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:303 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d18b061a | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:304 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b030a7fe | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:305 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e2036ccb | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:306 | try | DATA_OP | req.Parameters["p_confirm_area"] | p_confirm_area | 행/컬럼 값 대입 |  |  |  |
| AC-bd7ec399 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:307 | try | DATA_OP | req.Parameters["p_release_value"] | p_release_value | 행/컬럼 값 대입 |  |  |  |
| AC-12e5540e | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:309 | try | DATA_OP | req.Parameters["p_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-256b0079 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:310 | try | DATA_OP | req.Parameters["p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-077ef41a | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:311 | try | DATA_OP | req.Parameters["p_cell_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d7823959 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:312 | try | DATA_OP | req.Parameters["p_cell_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-38aed1b4 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:313 | try | DATA_OP | req.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-88ee72f0 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:315 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ac7474c | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:316 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-37de5238 | this.Load [try ▸ lambda] 외 2 | FP00594_LinePopup.cs:323 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_LinePopup.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-916a0f79 | this.Load 외 2 | FP00594_LinePopup.cs:213 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-41eb1373 | this.Load 외 2 | FP00594_LinePopup.cs:223 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c62a1dcd | this.Load 외 2 | FP00594_LinePopup.cs:230 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1c16e6cf | this.Load 외 2 | FP00594_LinePopup.cs:233 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a32730d4 | this.Load 외 2 | FP00594_LinePopup.cs:235 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-0f2b0156 | this.Load 외 2 | FP00594_LinePopup.cs:243 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-df304c38 | this.Load 외 2 | FP00594_LinePopup.cs:249 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00594_LinePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9dbd4e69 | this.Load | FP00594_LinePopup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4523b11a | this.Load | FP00594_LinePopup.cs:109 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00594_LinePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d84596b4 | this.Load | FP00594_LinePopup.cs:124 |  | VALUE_SET | txtFactory.Text | Filter["FACTORY_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-b83cf9fc | this.Load | FP00594_LinePopup.cs:125 |  | VALUE_SET | txtMaterial.Text | Filter["ITEM_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-df700c48 | this.Load | FP00594_LinePopup.cs:126 |  | STATE | txtFactory.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-729988fc | this.Load | FP00594_LinePopup.cs:127 |  | STATE | txtMaterial.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00594_LinePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6c08718 | this.Load | FP00594_LinePopup.cs:150 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-758d7223 | this.Load | FP00594_LinePopup.cs:151 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00594_LinePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1747c9dc | (진입점 미연결) | FP00594_LinePopup.cs:172 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00594_LinePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61ffcbe2 | this.Load | FP00594_LinePopup.cs:157 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13aaffd8 | this.Load | FP00594_LinePopup.cs:158 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-90487710 | this.Load | FP00594_LinePopup.cs:162 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b569f332 | this.Load | FP00594_LinePopup.cs:165 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-5e9f484c | this.Load | FP00594_LinePopup.cs:166 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.SITE_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-b74cda0b | this.Load | FP00594_LinePopup.cs:167 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.PLANT_ID), false) | 그리드 표시 설정 |  |  |  |

## FP00594_LinePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07eb2ba0 | this.spdMain.CellClick | FP00594_LinePopup.cs:369 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-2bffd30e | this.spdMain.CellClick | FP00594_LinePopup.cs:370 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-66ec0732 | this.spdMain.CellClick | FP00594_LinePopup.cs:373 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00594_LinePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f7f0506 | this.spdMain.CellDoubleClick | FP00594_LinePopup.cs:379 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-7203039c | this.spdMain.CellDoubleClick | FP00594_LinePopup.cs:380 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e50fa856 | this.spdMain.CellDoubleClick | FP00594_LinePopup.cs:383 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-7fc4a0d5 | this.spdMain.CellDoubleClick | FP00594_LinePopup.cs:386 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5897c45f | this.spdMain.CellDoubleClick | FP00594_LinePopup.cs:396 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50fb98b3 | .ctor | FP00594_MeasureSetForm_Popup.cs:99 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-b4bb0a50 | .ctor | FP00594_MeasureSetForm_Popup.cs:100 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-ee705ab0 | .ctor | FP00594_MeasureSetForm_Popup.cs:101 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-f407a88d | .ctor | FP00594_MeasureSetForm_Popup.cs:103 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00594_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-880aa43e | this.btnOK.Click | FP00594_MeasureSetForm_Popup.cs:345 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-3c1e45a1 | this.btnOK.Click | FP00594_MeasureSetForm_Popup.cs:346 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-60ca18ed | this.btnOK.Click | FP00594_MeasureSetForm_Popup.cs:353 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-feded6d9 | this.btnOK.Click | FP00594_MeasureSetForm_Popup.cs:354 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3824a7fa | this.btnSet.Click | FP00594_MeasureSetForm_Popup.cs:316 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-39f6b3ba | this.btnSet.Click | FP00594_MeasureSetForm_Popup.cs:317 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-3128abd4 | this.btnSet.Click | FP00594_MeasureSetForm_Popup.cs:319 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8565f8da | this.btnSet.Click | FP00594_MeasureSetForm_Popup.cs:320 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6720b25 | this.btnSet.Click | FP00594_MeasureSetForm_Popup.cs:322 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-e857af92 | this.btnSet.Click | FP00594_MeasureSetForm_Popup.cs:324 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-90d7265a | this.btnSet.Click | FP00594_MeasureSetForm_Popup.cs:325 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef122f66 | Dispose | FP00594_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00594_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ffddc5e | this.Load | FP00594_MeasureSetForm_Popup.cs:126 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00594_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b1c0714 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:187 |  | FLAG | dtCategory | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "select_measure", "FP00594_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-81728376 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:187 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00594_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9e343c1c | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:189 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-3005d38f | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:190 |  | FLAG | measure_val | new bool[measure_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-c678d8f5 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:191 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-98062b03 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:219 |  | DATA_OP | ctrls.Add | (chk_sales) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e435647 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:220 |  | DATA_OP | ctrls.Add | (chk_past_sales) | 데이터 객체 조작/조회 |  |  |  |
| AC-013c2643 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:222 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf9917c5 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:223 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-705a7737 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:225 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3741554 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:226 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-37697db7 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:228 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-e92bd0bb | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:229 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdc213be | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_engine_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d4ea588 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_engine_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-02dab329 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-47209fb6 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_inventory) | 데이터 객체 조작/조회 |  |  |  |
| AC-3432da5e | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:237 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-27e92be4 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_uom) | 데이터 객체 조작/조회 |  |  |  |
| AC-4641edf1 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-44a7ca9a | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-1985aa7b | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:245 |  | DATA_OP | ctrls.Add | (chk_total_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-2833cd29 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:249 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-65a69fd6 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:249 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-579c1140 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:256 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-d4a66c20 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:260 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-b1a192a6 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:264 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00594_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f47551fb | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_sales.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0fb8364a | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_past_sales.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d948532c | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-381047da | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7716c85d | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6745dae8 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-fb9de120 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-993dcaa4 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1660f455 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_engine_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-abc2d7ea | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_engine_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1396ab6e | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-60338971 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_inventory.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2b45c01f | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-11101b33 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_uom.Text | measure_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e5dbe795 | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_cell.Text | measure_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d763d60c | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:167 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-24ac361c | this.Load 외 1 | FP00594_MeasureSetForm_Popup.cs:168 |  | VALUE_SET | chk_total_2.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00594_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46988ef4 | (진입점 미연결) | FP00594_MeasureSetForm_Popup.cs:411 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-2328f0f5 | (진입점 미연결) | FP00594_MeasureSetForm_Popup.cs:422 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5ac3e36 | (진입점 미연결) | FP00594_MeasureSetForm_Popup.cs:433 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00594_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09184409 | this.Load | FP00594_MeasureSetForm_Popup.cs:113 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8c7ded3a | this.Load | FP00594_MeasureSetForm_Popup.cs:121 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00594_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a7bc309 | this.btnSet.Click 외 1 | FP00594_MeasureSetForm_Popup.cs:367 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-35ffdd0b | this.btnSet.Click 외 1 | FP00594_MeasureSetForm_Popup.cs:375 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-695d8904 | this.btnSet.Click 외 1 | FP00594_MeasureSetForm_Popup.cs:375 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-6e3f3951 | this.btnSet.Click 외 1 | FP00594_MeasureSetForm_Popup.cs:392 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fbfc7eb6 | this.btnSet.Click 외 1 | FP00594_MeasureSetForm_Popup.cs:403 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bb805a8 | .ctor | FP00594_PlanAmend_Model_NJ_Pouch.cs:192 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-509b59b6 | .ctor | FP00594_PlanAmend_Model_NJ_Pouch.cs:193 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SELECT") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / InsertButton [if (row != …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adc44e21 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1016 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f4325469 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1017 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b81419a6 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1018 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-48536780 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1019 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-02c1b2cd | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1020 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2d6d0028 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1021 |  | FLAG | dsBoh | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9de3e058 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1023 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f7d3adcd | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1024 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ce8b44aa | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1025 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe34cb2f | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1026 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-3bb4bffe | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1027 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b434bab9 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1028 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4e06cbc0 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1029 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bb50a43e | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1030 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-455efc06 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1032 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_ListData_BOH", Filter["INSTANCE_ID"].ToString(), Filter["PL… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c744a902 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1034 |  | FLAG | dsBoh | dtBoh.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-544315cd | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1036 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_ListData", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c9a39336 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1038 |  | FLAG | dsListData | dtListData.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-04629442 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1041 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00594_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-73a4c794 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1043 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c9a425da | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1044 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea4b30da | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1045 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4e389408 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1046 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16ca1089 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1059 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-8c67cdd4 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1066 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-35b2b46f | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1067 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d2ca66bd | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1068 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-190247f5 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1080 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-cae7b82a | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1081 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-f2ca110a | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1082 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-2d6490ac | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1083 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-7dc67dfd | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1084 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-88770c91 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1085 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-332b0368 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1086 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.ApplyAmendCalendarCondition_ForExcel

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e20e0863 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5130 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-93bfe90b | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5131 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-47557f52 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5132 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-accd550f | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5133 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-45438ec8 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5134 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4debc4d3 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5135 |  | FLAG | dsBoh | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7b67163c | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5148 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff1b678e | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5149 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-20275959 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5150 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-065dc850 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5151 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-2774c324 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5152 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-019226da | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5153 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b1eff9fa | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5154 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-506431a2 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5155 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-04eae770 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5157 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_ListData_BOH", Filter["INSTANCE_ID"].ToString(), Filter["PL… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1478b633 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5159 |  | FLAG | dsBoh | dtBoh.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-00769b49 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5165 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00602_PlanAmendLineAssy", "FP00594_find_ListData", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=FP00594_find_ListData] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8cd60992 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5166 |  | FLAG | dsListData | dtListData.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-0350cf2a | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5170 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00594_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bdf997fe | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5172 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-11d2960b | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5173 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9103d2f7 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5174 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-147af90c | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5175 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e30beb3b | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5176 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bfe23e14 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5177 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-71c25d37 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5178 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b508582a | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5181 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-e6cb629b | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5182 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-68a6f59f | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5183 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-131342b6 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5184 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-a8b9e1b2 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5185 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-a79a838d | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5186 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-68f19b37 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5187 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / InsertButton [if (row != null…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf41f033 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1092 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; this.Invoke(new MethodInvoker(delega… | ⚠ 의미 확인 필요 |  |  |  |
| AC-78240b56 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1096 | lambda | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (GetFilter("INSTANCE_ID") == "") { SetFilter("INSTANCE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-05974fc6 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1104 | lambda ▸ lambda | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-4f2efd21 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1105 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e182b2bf | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1106 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-1c4c7fd1 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1114 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b6407aff | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1120 | lambda | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cbo_fpplanid.SelectedIndex >= 0) { Filter["PLAN_ID"] … | ⚠ 의미 확인 필요 |  |  |  |
| AC-d440dcd8 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1124 | lambda ▸ lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-ad937072 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1129 | lambda | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-b1104efc | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1130 | lambda | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_CELL_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-6a8be2aa | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1131 | lambda | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R " | 행/컬럼 값 대입 |  |  |  |
| AC-34b3fb9f | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1132 | lambda | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_CELL_BOR_R " | 행/컬럼 값 대입 |  |  |  |
| AC-9b46d78a | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1133 | lambda | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_CELL_UTIL_R " | 행/컬럼 값 대입 |  |  |  |
| AC-7ebea10b | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1137 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-99c0d90c | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1138 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_CELL_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-0c7fc1db | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1139 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H " | 행/컬럼 값 대입 |  |  |  |
| AC-df1cc1e3 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1140 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_CELL_BOR_H " | 행/컬럼 값 대입 |  |  |  |
| AC-1090e643 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1141 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_CELL_UTIL_H " | 행/컬럼 값 대입 |  |  |  |
| AC-8db8389e | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1144 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eac96348 | this.btnBucket.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2819 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-1165b39d | this.btnBucket.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2821 |  | POPUP | new FP00599_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-248d1ebf | this.btnBucket.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2822 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-94f4d6f8 | this.btnBucket.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2823 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-c30d224d | this.btnBucket.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2824 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-76ac73a0 | this.btnBucket.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2828 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-c3fb7a11 | this.btnBucket.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2837 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9b3c99a9 | this.btnBucket.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2839 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0391dd67 | this.btnBucket.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2842 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3f76ec0d | this.btnBucket.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2851 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e02c84f | this.btnCatagory.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2776 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-62584a7c | this.btnCatagory.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2778 |  | POPUP | new FP00594_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-62962178 | this.btnCatagory.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2779 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-32dc001e | this.btnCatagory.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2780 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-95cb5d40 | this.btnCatagory.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2781 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ca713c90 | this.btnCatagory.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2785 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-a7e05b74 | this.btnCatagory.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2794 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fa8b7527 | this.btnCatagory.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2796 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-df6a1357 | this.btnCatagory.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2799 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3dbdcbdb | this.btnCatagory.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2808 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc16a0bc | this.btnColumn.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2749 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-af7641a9 | this.btnColumn.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2751 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-ef38709e | this.btnColumn.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2752 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d292d840 | this.btnColumn.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2753 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-949797bd | this.btnColumn.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2759 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-ae195dc3 | this.btnColumn.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2759 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b5e387b | this.btnColumn.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2760 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-e9ae2af6 | this.btnColumn.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2766 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnCreatePlan_Click

진입점: this.btnCreatePlan2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbf2ee2d | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2954 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-f8a9bcac | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2955 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-aea3ee6b | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2963 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8214bb7b | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2964 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fcb00b1e | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2974 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c789d9cd | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2976 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4b5b9890 | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2982 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72846274 | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2983 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8958477b | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2988 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c325968 | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2989 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-58702986 | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2992 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-19b9ec8f | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2993 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff6c71f1 | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2994 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1399b24 | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3000 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-e28bcd62 | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3003 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-92c12afd | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3004 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-627a4551 | this.btnCreatePlan2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3005 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c935ddcc | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3358 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d3b64f2 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3359 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-adb501eb | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3365 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-38e9f43c | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3366 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-add18101 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3372 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not be uploaded.") | 메시지 표시 |  |  |  |
| AC-d324df98 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3373 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6ae31f2 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3384 | if (sPlanIDTag == "99" \|\| sPlanIDTag == "98") | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-1b91946d | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3388 | else of (sPlanIDTag == "99" \|\| sPlanIDTag == "98") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c613270 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3394 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-d5f6ff45 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3397 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e72b2112 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3403 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-f3ff8d33 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3404 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-74884c26 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3405 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-17f56f7d | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3407 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-94bc88fc | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3414 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP00594_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-1ae05489 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3416 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-9b3a14fa | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3416 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-30991ca5 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3419 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.CELL | 속성 DateColumnType 설정 |  |  |  |
| AC-38f46e20 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3422 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a7a11785 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3423 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-63faf843 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3424 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f55fcbb2 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3425 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["TOP_ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-40e40ce7 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3426 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e43ce9aa | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3427 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ab11663a | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3428 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-304032c1 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3429 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LOCATION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-539ecf86 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3430 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1eff24f9 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3431 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7ed25f57 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3432 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5a031f2c | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3433 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7a7112e3 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3434 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a4028a9f | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3439 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-7ff1a416 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3440 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-0bc0beba | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3441 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-8e359bcc | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3442 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["TOP_ITEM_ID"] | "Model" | 행/컬럼 값 대입 |  |  |  |
| AC-5e786e05 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3443 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-73a617c2 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3445 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-43de8aa6 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3446 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-66dc4af2 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3447 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["VERSION"] | "Version" | 행/컬럼 값 대입 |  |  |  |
| AC-3f168e56 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3449 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-a7eee1c9 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3450 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-fb84ad79 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3451 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-a629f4a9 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3452 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-dbff1c0c | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3453 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-3a5931d1 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3454 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-145f6c5b | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3455 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-d2bc7a15 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3456 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-23570769 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3461 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnSearchData | ExcelPopup_Search_Column | 속성 OnSearchData 설정 |  |  |  |
| AC-3c8ca963 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3462 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Column | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-6918af46 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3463 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Column | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-932864e3 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3464 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-15ff5ebf | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3465 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | FP00599_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-5bddc9d6 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3467 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-421c3eb8 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3469 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-60ae29ef | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3475 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP00594_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-7ca90453 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3477 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-203e6f49 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3477 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-daaca2f0 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3481 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1df24ce4 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3482 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4640d576 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3483 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6c046923 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3484 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["TOP_ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-50bdad78 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3485 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d9c414ef | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3486 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c5449e76 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3487 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5cf2ef3d | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3488 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-635104d2 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3489 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LOCATION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6b752d5e | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3490 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e7fa1a97 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3491 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b5d922eb | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3492 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e1dac169 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3493 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-75af9fe2 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3494 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-20d99434 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3495 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5ccfb393 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3498 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-acb04e43 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3499 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-00b82bdf | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3500 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-11aa0bba | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3501 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["TOP_ITEM_ID"] | "Model" | 행/컬럼 값 대입 |  |  |  |
| AC-9c50710c | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3502 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-53a9b545 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3504 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-31caee74 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3505 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-76ae1c2d | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3506 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["VERSION"] | "Version" | 행/컬럼 값 대입 |  |  |  |
| AC-e1761785 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3508 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-7f3e67ac | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3509 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-042009f4 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3510 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-1f6992b0 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3511 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-a4276e2f | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3512 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-92f4eaa8 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3513 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-6f6a27c5 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3514 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-1326527b | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3515 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-56d14e4e | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3516 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-486d23cd | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3517 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["QTY"] | "QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-86802164 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3518 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-73b91faa | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3522 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnSearchData | ExcelPopup_Search_Row | 속성 OnSearchData 설정 |  |  |  |
| AC-d59c5614 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3523 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Row | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-6b3bddf8 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3524 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Row | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-7e1ab678 | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3525 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-483e1b6d | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3527 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-2a1a751c | this.btnExcelImport.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3529 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7998231f | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3300 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-e2edc183 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3301 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-b9ef873a | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3309 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aea4df00 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3310 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b09b0d5 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3316 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-4124bc06 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3317 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a67695d4 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3320 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e1ee0199 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3321 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-38218ae0 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3322 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-460d7a15 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3322 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d672f0d9 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3323 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-caaf11f1 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3324 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-cd9f93cc | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3325 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-967b55af | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3325 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2d9a43ac | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3326 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-29f831ae | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3327 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-656fccb2 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3328 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-af4deb2e | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3329 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6e95ebe6 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3330 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-20e34827 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3331 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-16a82f72 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3332 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-58b95148 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3333 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-235fe328 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3334 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b8b0dff6 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3336 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-50c874cf | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3337 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-5de59d78 | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3338 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-df1237ab | this.btnMemo.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3339 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnMenu_Click

진입점: this.btnMenu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55a921f1 | this.btnMenu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3539 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnMenu, menuPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-c7eee2d0 | this.btnMenu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3539 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnMRP_Click

진입점: this.btnMRP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dd29d59 | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2902 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-2bace13e | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2903 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-8b638a53 | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2911 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4dc897d4 | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2912 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b600987 | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2917 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-96747c05 | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2922 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-7133e3ec | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2923 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73c42318 | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2929 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-82e15c48 | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2930 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-696233d9 | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2935 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-e34849b2 | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2936 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb42f95a | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2940 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-6e0ebcec | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2941 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-350c3659 | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2942 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d38b32fe | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2944 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-5858b765 | this.btnMRP.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2946 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnPSICalculation_Click

진입점: this.btnPSICalculation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60afd675 | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3149 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-80d56564 | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3150 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-e7dc484a | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3158 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-554a2d05 | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3159 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfbe07ed | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3163 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-515b5ec2 | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3169 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-468cd70d | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3170 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99b13ee6 | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3174 |  | MESSAGE | MessageBox.Show | ("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-94335e44 | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3180 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (Filter["PLAN_… | MESSAGE | MessageBox.Show | ("Release plan can not be calculated.!") | 메시지 표시 |  |  |  |
| AC-74c15fa4 | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3181 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (Filter["PLAN_… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6355df2 | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3185 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) | FLAG | dtSyncCalculation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_find_SyncCalcul", Filter["… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-6a76df68 | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3185 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_SyncCalcul", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a2ca796 | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3191 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtSyncCalcula… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "there is running PSI calculation." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3aad508e | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3192 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtSyncCalcula… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-817d7784 | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3201 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (Filter["PLAN_… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "FP Plan ID is null." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94479d3c | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3202 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (Filter["PLAN_… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-864e174a | this.btnPSICalculation.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3210 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (bRtn2 && bRtn… | MESSAGE | MessageBox.Show | ("PSI Calculation Excution Completed.!") | 메시지 표시 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnRelease_Click

진입점: this.btnRelease2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17decce7 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3021 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-dc3ead44 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3022 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-f1cee082 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3030 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-92ce937f | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3031 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-559a3dc5 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3051 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18274445 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3052 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95dfb07d | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3055 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_instanceInfo", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8c6c0099 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3056 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_planInfo", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e6076d76 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3060 | if (dtPlanInfo != null) | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-915e3581 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3067 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6a1270df | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3071 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c321473a | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3072 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cce5fcf5 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3079 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b62ca427 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3080 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ef8499e | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3085 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e3142524 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3088 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e9522a86 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3090 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a9d2783e | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3096 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c615c3fb | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3097 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f122d70 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3110 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-39869bee | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3111 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5b910007 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3123 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-4f1db3d7 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3126 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-c5919b4a | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3127 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d9477f23 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3128 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5ac96bca | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3136 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-b3411282 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3139 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-6da76e64 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3140 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3d86ead6 | this.btnRelease2.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3141 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.Show | () | 팝업/폼 열기 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47e35a24 | this.btnSql.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3547 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-623805d1 | this.btnSql.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3550 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6e63ce20 | this.btnSql.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3551 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d424a77c | this.btnSql.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3553 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00594_AMEND_MODEL_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b19dcf81 | this.btnSql.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3554 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00594_AMEND_MODEL_TOTAL_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-f7283db9 | this.btnSql.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3555 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00594_AMEND_MODEL_BOH_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b2931b9 | this.btnSql.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3556 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00594_AMEND_MODEL_DATA_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-21f8fb64 | this.btnSql.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3557 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00594_EXCEL_SELECT_COLTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-66017ca4 | this.btnSql.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3558 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a86ce29 | this.btnSql.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3559 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnSSP_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9b83e14 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2866 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-57a3a5d2 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2871 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-bdf731ef | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2872 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12e1809b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2878 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-2a80c919 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2879 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-044bf313 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2884 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-0445a35b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2885 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e9733164 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2889 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-f3cc54c4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2890 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc29e3a6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2891 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-eca55647 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2892 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_SSP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_SSP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-d2b96494 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2894 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7247b21b | this.btnToggleSave.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:2860 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.btnWOWStatus_Click

진입점: this.btnWOWStatus.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4628fe55 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3220 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-157481aa | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3221 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-91773230 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3229 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62e35774 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3230 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0dd83466 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3244 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95e5e9a3 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3250 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-6b09d934 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3251 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-378479aa | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3256 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_instanceInfo", pInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6b74672c | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3262 | if (!sWoWStatus.Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7092ae9c | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3265 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findInstance", pSite, "INSTANCE_ID") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3dac2b7 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3267 |  | DATA_OP | dtLocalPlanGroup.Select | (string.Format("CODE = '{0}'", pInstance)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1676fbf9 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3269 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4bf8d91a | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3281 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-1ff25768 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3284 | try | POPUP | new FP00590_WoWStatusPopup | (pSite, pInstance, pPlanDate, pPlanID, sIsSamePlanID, sConfirmArea, sWoWStatus) | 팝업/폼 생성 |  |  |  |
| AC-c3733213 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3285 | try | UI_PROP | popWowStatus.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9d3bcd13 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3286 | try | POPUP | popWowStatus.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-66837794 | this.btnWOWStatus.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3292 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2eb0d8f | this.button1.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3347 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.cbo_fpplanid_changed

진입점: this.Load [try] / cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd62981f | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2588 | if (cbo_fpplanid.Items.Count > 0) ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-0e1e1c10 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2589 | if (cbo_fpplanid.Items.Count > 0) ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-8961db4d | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2596 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-736f541b | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2597 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-ee5b6956 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2623 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[selected]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-9499db39 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2624 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[selected]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-43cbabb7 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2625 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[selected]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-d576eced | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2626 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[selected]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-9a72449b | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2627 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[selected]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-0bc749a1 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2629 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-6ca57595 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2630 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-f767e14e | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2631 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-6bb88976 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2632 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-7fc03513 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2633 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-41ca562a | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2637 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-260b56a3 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2638 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-6bc213dd | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2639 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-391324c2 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2640 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-4b521c89 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2641 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-46ab4975 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2643 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-c52e4cf3 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2644 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-c884748d | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2645 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-73a266d0 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2646 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-7cf1a46b | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2647 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09eea8a6 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:1624 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-14686fb4 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:1624 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-3131be49 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:1627 | if (measure == null) | CALL_EXT | MeasureService.MakeDefault | (new FP00594_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aaddcc24 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:1627 | if (measure == null) | POPUP | new FP00594_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-77ea7457 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:1628 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0abfa529 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:1628 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.chk_Info_CheckedChanged

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f977f5b | this.chk_Info.CheckedChanged | FP00594_PlanAmend_Model_NJ_Pouch.cs:6583 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-4727b5d1 | this.chk_Info.CheckedChanged | FP00594_PlanAmend_Model_NJ_Pouch.cs:6583 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e782b8a | this.chk_Info.CheckedChanged | FP00594_PlanAmend_Model_NJ_Pouch.cs:6589 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-d54bb01d | this.chk_Info.CheckedChanged | FP00594_PlanAmend_Model_NJ_Pouch.cs:6590 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.CreateEditBOHDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82bf7c81 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4956 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-7a871581 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4957 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-078f0e27 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4958 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b83f706 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4959 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-85e4bef8 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4960 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9b993a2 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4961 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c56d1462 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4962 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab7ad401 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4963 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe19cdc1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4964 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-143d570f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4965 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4c0593e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4966 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-839c676a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4967 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-acab1253 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4968 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-52c3560b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4969 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a1f4e1e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4970 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2465781d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4971 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ACTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f537d86f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4973 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.CreateEditDataGridDataSet

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…) ▸ if (dsMainFiltered.Good()) ▸ if (dt == null)] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (siMain.GetColumnTag(e.Column).Equa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56cdecfa | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4979 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-431c82cc | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4980 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-06aa8851 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4981 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4467f37 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4982 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff33a425 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4983 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c350e9e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4984 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f53468c8 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4985 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-39b7b5f7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4986 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9473fad | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4987 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f96490bc | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4988 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6c53883 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4989 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a57f1e1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4990 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-10003550 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4991 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0181b68 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4992 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a8d4c7d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4993 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-77537ee5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4994 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-37d5f5eb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4995 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b32ec8c3 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4996 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-795389a5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4997 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d82d9b4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4998 |  | DATA_OP | dt.Columns.Add | (new DataColumn("P_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcc482c5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4999 |  | DATA_OP | dt.Columns.Add | (new DataColumn("P_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5687695f | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5000 |  | DATA_OP | dt.Columns.Add | (new DataColumn("BOH_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3682562 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5001 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SALES_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a0d90db | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5002 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EOH_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a9c1667 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5003 |  | DATA_OP | dt.Columns.Add | (new DataColumn("YIELD", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b160835 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5005 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLM_EC_NO", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2db6f3fa | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5006 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae22ad97 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5008 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-588c7e48 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5009 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-794557d0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5011 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-29eb9796 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5013 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.CreateExelBufferDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-869d0835 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5194 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-58ad40bf | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5195 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d635e091 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5196 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-822cb5d0 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5197 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9b334c0 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5198 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f332c5dc | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5199 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf593282 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5200 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-23197e46 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5201 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-00fb1c86 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5202 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-aae7bf32 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5203 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0953802b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5204 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5f756f2 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5205 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-433a91c3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5206 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c551a7da | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5207 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d791bcd0 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5208 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce7788eb | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5209 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7e1fd43 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5210 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0abb43a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5211 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-12c2571c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5212 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CELL_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7c4de05 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5213 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-de608e97 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5214 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d980fee | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5215 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JOB_ORDER", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-79736ffe | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5216 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MPP_WPP", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-14d81b9c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5217 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLM_EC_NO", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3917dee5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5218 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea574f41 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5220 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCatagory…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0115d015 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1695 | if (dsResult == null \|\| dsTotal == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2a64cd94 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1706 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-69f9ad0c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1707 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-7df82790 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1718 | if (measure["chk_sales"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "S")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0a0a4cf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1727 | if (measure["chk_past_sales"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "PAST_SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f890bf73 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1732 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-164e5ea0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1733 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4b9e132 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1738 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-edef77f1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1739 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6eec3309 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1745 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2650fb07 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1746 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a9db652 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1751 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b87e83e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1752 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a8ee545 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1757 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd588997 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1758 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b66f3d86 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1763 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a369ed9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1764 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-66a8243b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1770 | if (measure["chk_engine_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_ENGINE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-898f635d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1771 | if (measure["chk_engine_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_ENGINE_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c0b2395 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1776 | if (measure["chk_engine_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_ENGINE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fcfcc88 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1777 | if (measure["chk_engine_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_ENGINE_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-65fd6057 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1783 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e7737a3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1784 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-82ff5fe2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1789 | if (measure["chk_inventory"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c0ff823 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1790 | if (measure["chk_inventory"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "I_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6cb1aea9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1795 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-819e7470 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1802 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "S")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3fae999 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1807 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "S")) | 데이터 객체 조작/조회 |  |  |  |
| AC-208d0e53 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1808 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-de4ea422 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1809 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-60e39b4e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1910 | if (measure["chk_uom"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("MEASURE_ID", "UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1febd067 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1920 | if (measure["chk_cell"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("MEASURE_ID", "CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-699d1407 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1930 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-871d5828 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1933 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fef13e72 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1937 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ba4e1f6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1942 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-29ff2d99 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1946 | else of (m != null && m.Count() > 0) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4e5abda1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1946 | else of (m != null && m.Count() > 0) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-dea9f45e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1950 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4f28b3b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1952 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5be6ac8d | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:477 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fa2b7c9c | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:478 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-301a186b | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:479 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6563add | dCalendar_planrange.ValueChanged | FP00594_PlanAmend_Model_NJ_Pouch.cs:2716 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-967d5eeb | dCalendar_planrange.ValueChanged | FP00594_PlanAmend_Model_NJ_Pouch.cs:2722 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-df14364d | dCalendar_planrange.ValueChanged | FP00594_PlanAmend_Model_NJ_Pouch.cs:2723 | if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Delete_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67b3c964 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6235 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-a14092af | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6236 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7ab2a415 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6238 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-c3d8b9b6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6239 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e291b553 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6240 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-ad606815 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6241 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce510f79 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6242 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-57984c7b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6243 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a7632ad9 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6244 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1c5c626b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6245 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7ee6de3c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6246 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cb0fb59b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6247 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65c18103 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6248 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-37ce62b3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6249 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-36209d13 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6250 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-046e2524 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6251 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0bc4debd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6252 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bfb2631e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6253 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-95b99b1a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6254 | try | DATA_OP | request.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1ad3b515 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6255 | try | DATA_OP | request.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-928581e5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6256 | try | DATA_OP | request.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-542bc8cc | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6257 | try | DATA_OP | request.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-179afd25 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6258 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-68f76400 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6259 | try | DATA_OP | request.Parameters["p_cell_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a6152596 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6260 | try | DATA_OP | request.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec73f69a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6261 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-79780437 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6262 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2bea24a5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6263 | try | DATA_OP | request.Parameters["p_new_seq_no"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1a3c26b2 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6264 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5cdb7d5d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6266 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b301f8d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6274 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-e477dab2 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6278 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-dc4897eb | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6279 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d41d8da7 | DeleteButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:849 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3001c1a3 | Dispose | FP00594_PlanAmend_Model_NJ_Pouch.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.DrawHeader

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Dialog…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54e8d1a9 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1210 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-92b37aa4 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1214 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-b7c004b8 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1215 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-965e25c1 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1216 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-476c36f3 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1217 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98061169 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1218 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-692ac725 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1222 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-86ad8dc9 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1223 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-b6cf15da | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1224 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-9d6e009c | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1225 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-0acf6ed0 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1231 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-370aa4e5 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1232 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-985f261e | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1265 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-174ab637 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1270 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, FPExtensions.DateColumnT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-08ac8e6a | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1272 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e33c3e9 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1273 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7f62245 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1274 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-ce6128ee | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1276 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-d0301a7b | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1278 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-af11f9f3 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1279 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.DrawSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.DialogRe…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a3fc630 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1289 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d1855328 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1291 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-782e9649 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1299 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1d76d847 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1308 | if (dsMainFiltered.Good()) | CALL_EXT | MemoService.ShowMemo | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dac2b82 | EditButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:857 | if (spdMain != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9271bd53 | EditButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:860 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67717fdd | ExcelButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:2505 |  | EXCEL | ExportExcel | (0,true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.ExcelPopup_BufferValidation_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c6b97e0 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5463 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_seq") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2c64c2bd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5467 | try ▸ if (dtSeq.Rows.Count > 0) | FLAG | _sNewSeqNo | dtSeq.Rows[0][0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d36e22fc | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5474 | try ▸ else of (dtSeq.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-89604128 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5475 | try ▸ else of (dtSeq.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-97102ac4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5503 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-279701fe | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5506 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b725ee1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5507 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eafe8c06 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5508 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-719db0cb | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5509 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e854ac36 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5510 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-17ea1da5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5511 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b451bae4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5512 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3ea7daf4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5513 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ececf427 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5514 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fac444ca | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5515 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5dc17b48 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5516 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-43e6d45f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5517 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-02022a8c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5518 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_TYPE"] | data.Tables[0].Rows[i]["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-67d29021 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5519 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05e1416c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5520 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-38ed416d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5521 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-950b60c3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5522 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a6b02ad8 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5523 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["CELL_QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0c1a6fcf | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5524 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f5617cb4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5525 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["NEW_SEQ"] | Filter["NEW_SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f63e0b7c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5526 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLM_EC_NO"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-f021324a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5527 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["VERSION"] | data.Tables[0].Rows[i]["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4db210d5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5528 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-37cccadd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5531 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7284117 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5540 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-d85ddb6f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5562 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7189976a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5567 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ed9ba960 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5569 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-63e005e5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5572 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-a2d42497 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5580 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-43aca923 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5605 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1c5d2c60 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5608 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dc098369 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5609 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6b2c5fcd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5610 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7656ebab | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5611 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a4c98c6d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5612 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6ba98c51 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5613 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7b38bf08 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5614 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2e1bd86f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5615 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8483f549 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5616 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-455d1704 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5617 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd953fcd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5618 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c37b0006 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5619 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05fb5d21 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5620 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_TYPE"] | data.Tables[0].Rows[i]["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a551aae | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5621 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3fbe59b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5622 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1d7db182 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5623 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3d7bbbdd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5624 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7b6ac325 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5625 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["CELL_QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6db3d253 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5626 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b429f480 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5627 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLM_EC_NO"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-f2ea83bd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5628 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["VERSION"] | data.Tables[0].Rows[i]["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e09987d7 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5629 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["NEW_SEQ"] | Filter["NEW_SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a3696c1e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5630 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f00902f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5634 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-2df44172 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5643 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0a1d3b7 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5668 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf528313 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5673 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d4bae1da | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5675 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-874cb397 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5678 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-7da15bce | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5689 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-383f7d15 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5694 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-1abec8df | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5699 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f16ea2b1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5700 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.ExcelPopup_BufferValidation_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75980310 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5729 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_seq") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f73eeb04 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5733 | try ▸ if (dtSeq.Rows.Count > 0) | FLAG | _sNewSeqNo | dtSeq.Rows[0][0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-14b3194a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5740 | try ▸ else of (dtSeq.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-018a8ebf | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5741 | try ▸ else of (dtSeq.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b4e97037 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5760 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f5e0c9e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5763 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-18279831 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5764 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | data.Tables[0].Rows[i]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-00f33b11 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5765 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8de8d99e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5766 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-594e7d2d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5767 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ccb98e9 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5768 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d3db367b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5769 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0812a12b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5770 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-347e65b0 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5771 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7bd746d7 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5772 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fcce6fdd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5773 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c481ebb8 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5774 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-163c1ac1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5775 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_TYPE"] | data.Tables[0].Rows[i]["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-26b73a25 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5776 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f898f1fe | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5777 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c8ebbc43 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5778 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7261d76b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5779 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-22cfc782 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5780 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["CELL_QTY"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04e67ec8 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5781 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-db551c78 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5782 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLM_EC_NO"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-2fe46f73 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5783 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["VERSION"] | data.Tables[0].Rows[i]["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b92ac9e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5784 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["NEW_SEQ"] | Filter["NEW_SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3ce5d43d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5785 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ef52795 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5788 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-d14d5612 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5791 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a545564 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5814 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ lambda | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c8b1384 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5819 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-edf930da | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5821 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-600c94e3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5824 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) ▸ if (d… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-772f5e87 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5832 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-30206ddb | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5837 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-1b4ebf22 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5842 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-15c7bf62 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5843 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.ExcelPopup_CheckBeforSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3132ed8 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5233 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe170b85 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5240 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek != null) ▸ if (dtIsCurrWeek.Rows.Count > 0) | DATA_OP | Filter["RELEASE_VALUE"] | dtIsCurrWeek.Rows[0]["RELEASE_VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f951c2b5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5248 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek != null) ▸ if (dtIsCurrWeek.Rows.Count > 0) ▸ if (dtIsCurrWeek.Rows[0]["IS_LA… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67d5c15b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5250 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek != null) ▸ if (dtIsCurrWeek.Rows.Count > 0) ▸ if (dtIsCurrWeek.Rows[0]["IS_LA… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2c019bf7 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5261 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd6903b1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5266 | try ▸ if (dtChk.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-b71b10d4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5267 | try ▸ if (dtChk.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f5ccbe1b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5270 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-d965f470 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5274 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.ExcelPopup_SaveExcel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec22b5b7 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6088 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.ExcelPopup_SaveExcel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da1fcba5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6166 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.ExcelPopup_Search_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58fea615 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5289 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-c0f8c62b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5290 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-6a4cb545 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5305 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-2b21fa0c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5306 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-57d6c6fe | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5307 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-9df979e1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5309 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-96dfa3f4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5321 | if (popup != null) ▸ if (dsData != null && dsData.Tables != null && dsData.Tables.Count > 0) | CALL_EXT | dsData.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "ITEM_TYPE", "NICK_NAME",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-af1f2177 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5323 | if (popup != null) ▸ if (dsData != null && dsData.Tables != null && dsData.Tables.Count > 0) | CALL_EXT | dsData.Tables[0].RemoveColumnsEndsWith | ("_QTY") | ⚠ 의미 확인 필요 |  |  |  |
| AC-33f6510f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5326 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-3652963a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5328 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.ExcelPopup_Search_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-769f8e9b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5338 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-19836a58 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5339 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-27cefee6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5356 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-b9edab25 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5357 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-0ddca8cf | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5358 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-c4b4d939 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5360 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-e685269f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5373 | if (popup != null) ▸ if (dsData != null && dsData.Tables != null && dsData.Tables.Count > 0) | CALL_EXT | dsData.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "NICK_NAME", "ITEM_TYPE",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c18d9ee | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5377 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-f7a5c6df | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5379 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Exec_PSI_Calculation

진입점: this.btnPSICalculation.Click [if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99ec3da9 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2457 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-91b9c7d2 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2458 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d05232b8 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2460 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-e2b732f8 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2461 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-8eb092a9 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2462 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-826f579a | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2463 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8ca75965 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2464 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-2f6e6088 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2465 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e9f0f85d | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2466 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-2e5e2fc8 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2467 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5e6d0781 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2468 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dced0a41 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2469 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a1e74bf8 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2470 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-844bb49f | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2471 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-594903d3 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2472 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-30eda02a | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2473 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5ff75e81 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2474 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-66826fed | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2475 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-71876eba | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2476 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-931890a6 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2477 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-444e99bc | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2478 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-003119a4 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2479 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a5c57278 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2480 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f8f2e4d7 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2481 | try | DATA_OP | req.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cdd90fba | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2482 | try | DATA_OP | req.Parameters["p_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1bbaee03 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2483 | try | DATA_OP | req.Parameters["p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-537a055e | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2484 | try | DATA_OP | req.Parameters["p_cell_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a4319063 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2485 | try | DATA_OP | req.Parameters["p_cell_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7bb3c939 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2486 | try | DATA_OP | req.Parameters["p_boh_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-80af3895 | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2488 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f2c4524d | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2495 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-1ba83fba | this.btnPSICalculation.Click [if (MessageBox.Show("Do you wa… | FP00594_PlanAmend_Model_NJ_Pouch.cs:2499 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SELECT")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / InsertButton [if (row != null) ▸ if (popup.ShowDi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6a2e089 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:958 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_YieldInfo", Filter["DIVISION_ID"] , Filter["SITE_ID"], Filt… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-52efc8ba | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:962 | try ▸ if (oYieldChild.Rows.Count >0) | FLAG | dsYieldChild | oYieldChild.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4987a273 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:968 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-738c6d8c | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:969 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3783da37 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:970 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-0a944644 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:971 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-d5fb0043 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:972 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-64ac9d3f | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:973 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e87b2e79 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:975 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9dc0dbe3 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:976 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6f8d0f7f | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:977 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-139db8c0 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:978 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4e664abc | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:979 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-acc2b021 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:980 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-34db6722 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:981 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-85f48df4 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:982 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-852136ae | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:983 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-79aaca7a | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:984 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6d5f4f13 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:985 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0471450d | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:986 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-22f29f1f | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:987 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9d480f54 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:988 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-8fe44666 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:989 | try | DATA_OP | request.Parameters["p_top_item_id"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bd3a83ee | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:990 | try | DATA_OP | request.Parameters["p_bucket_from_date"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-b6742abb | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:991 | try | DATA_OP | request.Parameters["p_bucket_to_date"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-a9cf1b21 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:992 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-794d627c | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:993 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-712474ac | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:994 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-df114d90 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:995 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-a2f11d49 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:996 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e698cccc | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:997 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-260d1f9f | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:998 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4f005293 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:999 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-820d6a37 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1000 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d653327b | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1001 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c649873f | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1002 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-3a7b9577 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1004 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ad3f1f3e | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1005 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9e916a4c | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_SE… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1010 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Find_Data_Excel_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-263d234b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6022 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-771ddb06 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6023 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ab09a3e5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6025 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-eda52ce0 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6026 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f1afae2d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6027 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-7c7fd7df | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6028 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa59c624 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6029 | try | DATA_OP | request.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-aa453c38 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6030 | try | DATA_OP | request.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-0a2c98e7 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6031 | try | DATA_OP | request.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-31ddd2a9 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6032 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e49d39fd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6033 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aefd862c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6034 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65e3e3db | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6035 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-13f67fbc | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6036 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8ce00fc3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6037 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-01ec862f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6038 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2fe8010a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6039 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c5039836 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6040 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-958dfa35 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6041 | try | DATA_OP | request.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-64f0f1dc | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6042 | try | DATA_OP | request.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ba7b0135 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6043 | try | DATA_OP | request.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-78389c43 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6044 | try | DATA_OP | request.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-871b26bf | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6045 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ae43d65e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6046 | try | DATA_OP | request.Parameters["p_cell_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-84a5c8cc | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6047 | try | DATA_OP | request.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f5fb4e6f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6048 | try | DATA_OP | request.Parameters["p_confirm_area"] | sConfirmArea | 행/컬럼 값 대입 |  |  |  |
| AC-c6e1bf78 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6049 | try | DATA_OP | request.Parameters["p_release_value"] | sreleaseValue | 행/컬럼 값 대입 |  |  |  |
| AC-f87e1804 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6050 | try | DATA_OP | request.Parameters["p_new_seq_no"] | sNewSeqNo | 행/컬럼 값 대입 |  |  |  |
| AC-b4a58a5a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6051 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eed817ba | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6054 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-50afe890 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6056 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-f472e43c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6061 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Find_Data_Excel_Import

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2140f1d | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5395 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL | 엔드포인트 요청 생성 |  |  |  |
| AC-943324cc | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5396 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8832a8f5 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5398 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-6ebc6a99 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5399 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-eb98f860 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5400 | try | DATA_OP | request.Parameters["p_sys_gubun"] | gubun | 행/컬럼 값 대입 |  |  |  |
| AC-65ff9935 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5401 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b9641178 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5402 | try | DATA_OP | request.Parameters["p_proc_name"] | procedure_name.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-8b8d7417 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5411 | try ▸ if (dsParameter != null && dsParameter.Rows != null && dsParameter.Rows.Count > 0) | CALL_EXT | param.Keys | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3374db27 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5425 | try | DATA_OP | request.Parameters["in_columns"] | keys | 행/컬럼 값 대입 |  |  |  |
| AC-e26c3862 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5426 | try | DATA_OP | request.Parameters["in_row"] | values | 행/컬럼 값 대입 |  |  |  |
| AC-fe1d9a36 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5427 | try | DATA_OP | request.Parameters["opt_none"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e192cd10 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5429 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-55032bea | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5431 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-ece13322 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5436 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-77ab232b | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:5438 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.FindTotalColorStart

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9aafa093 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1651 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.FindTotalValue

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TOTAL_SELECT")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (siMain.ActiveS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e88a2574 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:894 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-2f99482f | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:895 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-f41f01b6 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:896 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_TOTAL_VALUE" | 행/컬럼 값 대입 |  |  |  |
| AC-53ff78fe | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:897 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ef554f7d | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:898 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8bfddcc0 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:900 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-98ca631a | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:901 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-619ef919 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:902 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-45219aa5 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:903 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-72bc08eb | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:904 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d2401b55 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:905 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5ef67ec6 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:906 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1e266e88 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:907 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d2efb981 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:908 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-24013489 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:909 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-59514cf3 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:910 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-06acc5c3 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:911 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c41f57f5 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:912 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a6bd58c1 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:913 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-a89127a2 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:914 | try | DATA_OP | request.Parameters["p_top_item_id"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-42cf1ddc | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:915 | try | DATA_OP | request.Parameters["p_bucket_from_date"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-04dfce9a | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:916 | try | DATA_OP | request.Parameters["p_bucket_to_date"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-92eb2ee8 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:917 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-b2379f1f | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:918 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-3cd1abaa | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:919 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-e29bba7e | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:920 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-2e5bc597 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:921 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-eaa254a6 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:922 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-938665a4 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:923 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2c165fa7 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:924 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4d4c677c | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:925 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-068973fa | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:926 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1da7f74b | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:927 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4e55154b | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:929 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-34a388b7 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:932 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-3fb56037 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 4 | FP00594_PlanAmend_Model_NJ_Pouch.cs:940 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-592c1f9a | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:210 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.FP00599_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0f3617d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6288 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TOTAL_SELECT") ▸ try] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…) ▸ if (dsMainFiltered.Good()) ▸ try] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43cf14e6 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TO… 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4024 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.GetPlanGroup

진입점: this.Load [try] / popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_TOTAL_SELECT") ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…) ▸ if (dsMainFiltered.Good()) ▸ try ▸ if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08ff1422 | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4103 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f9ebf14d | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4104 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b5250735 | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4104 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-19766bb6 | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4106 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-13a1ae7b | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4108 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-69bf4b2d | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4111 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-9251bdce | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4112 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-1680b946 | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4112 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-83689104 | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4113 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ad45302a | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4114 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7e1b5a6c | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4115 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e64056da | this.Load [try] 외 9 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4119 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2d61e20 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4949 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-a88e998c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4950 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.GetToDay

진입점: sCalendar_planday.DateTimeChanged / popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ lambda ▸ else of (dt != null)] / this.btnExcelImport.Click [else of (dt != null)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda ▸ else of (dt != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d886c56a | sCalendar_planday.DateTimeChanged 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4255 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-3ea79f4a | sCalendar_planday.DateTimeChanged 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4256 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21a94b7d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1450 |  | UI_PROP | this.IsEditMode | do_edit_mode | 속성 IsEditMode 설정 |  |  |  |
| AC-e0ba39d6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1513 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolnames[k] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-7a3e9583 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1514 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolidxs[k] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-083a8957 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1550 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_LOCK | siMain.LockRange2 | (rowindex, colindex, rowindex, colindex, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-e8fb132b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1557 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_LOCK | siMain.LockRange2 | (0, colindex, current_src.Rows.Count - 1, colindex, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-eedd606b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1577 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.LockRange | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-28351551 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1594 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (calendar != null) ▸ foreach (var week_item in calendar.Weeks) ▸ if (wee… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-246a2406 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1611 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (m… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe60e6ea | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:289 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd3975cc | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:293 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ecae9f84 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:294 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-29f3b675 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:298 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-a4f81e3f | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:300 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-4da90afa | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:304 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a57f0433 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:308 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-674822b3 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:313 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-c34bc606 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:325 | try | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-788e3372 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:336 | try | FLAG | _sToDay | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-de002e44 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:345 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-13d0c444 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:346 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-06fd20d4 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:347 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5b03496e | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:348 | try ▸ if (adminAuth == false) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-716199c7 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:355 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.InitEditingBuf

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-100ae991 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4261 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a8fa1674 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4262 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-2f931785 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4263 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-459e627c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4264 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-598ac2a1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4265 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-43b69243 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4266 |  | FLAG | dlData | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1c5c3c66 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4267 |  | FLAG | dlView | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e5af2c28 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4268 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ef2be5f | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:251 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-1e478b36 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:252 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-61583771 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:253 |  | UI_PROP | mcbo_prodtype.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-275d75e1 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:254 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-3314ecbd | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:255 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-3a853711 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:256 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-0a07ab6a | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:257 |  | UI_PROP | mcbo_planner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-c2b0478b | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:258 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.InitSpread

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\|…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-481540c0 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:492 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ba6b33a | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:493 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cd1eb649 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:495 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b94b53b6 | this.Load 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:499 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Insert_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe56c9b3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5855 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00594_EXCELIMPORT", "insert_Excel_buffer", dsData) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-832efdbd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5859 | try ▸ if (result.Good()) | DATA_OP | result.Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-204bfebc | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5871 | try ▸ if (result.Good()) ▸ if (result.Columns.Contains("RESULT")) ▸ else of (result.Rows[0]["RESULT"].ToString().ToUpper() == "SUCCESS") ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a6ca258a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5879 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-90546b32 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5883 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-9e642b2f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5884 | catch ((Exception ex)) | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Insert_Data_Excel_Buffer_old

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a7eac0c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5967 | try ▸ if (iCount >0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-8ccf58d2 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5968 | try ▸ if (iCount >0) | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ae4dacd1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5970 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-01bdbf85 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5971 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-19533b55 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5972 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-9660de30 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5973 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b8973ca8 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5974 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-102c38aa | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5975 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-19555eff | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5976 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-fa1de8f0 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5977 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-607f8980 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5978 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a22576b4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5979 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-7986fcee | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5980 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-5ffb323d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5981 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-a031cddb | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5982 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-3d07cbda | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5983 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-d459d3db | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5984 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf10a6d9 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5985 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-34926858 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5986 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-086f032d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5987 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-e9eb62bb | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5988 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-134897de | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5989 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-f30ad2a5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5990 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-5281124d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5991 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_cell_qty"] | p_cell_qty | 행/컬럼 값 대입 |  |  |  |
| AC-f6f4b361 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5992 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-cc441db6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5993 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_confirm_area"] | p_confirm_area | 행/컬럼 값 대입 |  |  |  |
| AC-28f38e17 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5994 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_release_value"] | p_release_value | 행/컬럼 값 대입 |  |  |  |
| AC-8eee32d9 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5995 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_new_seq_no"] | p_new_seq_no | 행/컬럼 값 대입 |  |  |  |
| AC-36d9313c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5996 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_mpp_wpp"] | p_mpp_wpp | 행/컬럼 값 대입 |  |  |  |
| AC-9f089f75 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:5998 | try ▸ if (iCount >0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e4c23c4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6003 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-ffc0dff0 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6007 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-f18349c5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6009 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd077db7 | InsertButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:819 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-281caa81 | InsertButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:824 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | MESSAGE | MessageBox.Show | ("Can not be selected [Total] Row.!") | 메시지 표시 |  |  |  |
| AC-56b334cb | InsertButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:825 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-562204b4 | InsertButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:828 | if (row != null) | POPUP | new FP00594_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-4cd975d2 | InsertButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:829 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-43443fbd | InsertButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:829 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bea8ae59 | InsertButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:831 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-58fe0e64 | InsertButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:833 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3dd30e13 | InsertButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:841 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1cad220 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2512 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.onAlarmMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce58bd0e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3918 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f77da0ef | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3921 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c972a397 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3925 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e21263c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3929 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-0db667c5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3929 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9fb99211 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3931 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-6e804178 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3932 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-a8b4ecc4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3932 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2790c0c0 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3933 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-12f70843 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3934 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d5c7a746 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3935 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f4a4cee1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3939 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ebf8c7f6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3941 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d1aee304 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:3946 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20f099ea | memo_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3954 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-340fe1b1 | memo_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3957 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9911dd3a | memo_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3961 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.onNLFAmendMenu

진입점: nlfamend_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1a0e836 | nlfamend_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3973 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94c8b38e | nlfamend_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3976 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48f79524 | nlfamend_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3994 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-bf0b861d | nlfamend_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3995 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-78366017 | nlfamend_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3996 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-da7c2000 | nlfamend_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3997 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7b970266 | nlfamend_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3998 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-0abc04a9 | nlfamend_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3999 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-27cd1447 | nlfamend_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:4000 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1f4e6bdd | nlfamend_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:4001 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-97f21e66 | nlfamend_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:4002 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-474849cf | bucke_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3836 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b78fecee | bucke_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3839 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ac98844 | bucke_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3863 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.onZeroMaterialMenu

진입점: zero_mat_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1d25843 | zero_mat_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3877 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d59ceb6d | zero_mat_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3880 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e9a70f95 | zero_mat_menu.Click | FP00594_PlanAmend_Model_NJ_Pouch.cs:3904 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e56e27ce | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6919 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-04628956 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6919 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-af206655 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6921 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-f0bd7d91 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6922 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-7f5dc461 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6922 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2e06bead | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6923 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-cb72fed8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6924 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8dcd68d8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6925 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-de669da2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6929 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1bacb54f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6931 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-789453fd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6936 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2157f1e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6878 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-580d4218 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6879 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-2476b8bc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6880 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-15d5dbb7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6880 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e0c34122 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6881 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-b95e8de0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6882 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-50e0985f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6883 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e1801a11 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6888 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-db47c131 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6891 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4beabfe3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6897 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-264961f5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6898 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-ec2998cf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6899 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-6cb9ebaf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6899 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3f5b0a17 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6900 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-2a9d8832 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6901 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c1a19e49 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6902 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0f221a0b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6906 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3f88b367 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6908 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.planday_changed

진입점: sCalendar_planday.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d45ee22 | sCalendar_planday.DateTimeChanged | FP00594_PlanAmend_Model_NJ_Pouch.cs:2546 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bac0a816 | sCalendar_planday.DateTimeChanged | FP00594_PlanAmend_Model_NJ_Pouch.cs:2549 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-54d56077 | sCalendar_planday.DateTimeChanged | FP00594_PlanAmend_Model_NJ_Pouch.cs:2556 | else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Query

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.DialogRe…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b53a6f76 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1325 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-f007c70a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1325 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8afa9b68 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1326 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8f934905 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1331 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-2dac18be | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1354 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-9741c137 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1360 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-c15636ac | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1360 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0a4630cb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1361 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-2d567f35 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1361 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-03335cfc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1364 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-a18070fb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1371 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-fccec59c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1376 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-de723a55 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1377 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3311f5ad | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1379 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.RefreshHeadAndBody

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCatagory…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13f090cf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1177 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5d8eb3ba | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1193 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-0c48172d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1197 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.RefreshHeader

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5a4d195 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:589 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-c3ec85a1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:590 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-4b3894b2 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:591 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-3d5ae1af | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:592 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-1f2b8bce | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:598 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, bUse_month, bUse_week, bUse_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e26034c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:600 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-8d59486c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:604 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-95177922 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:606 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a599a992 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:607 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ef1c3d0d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:608 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-434db56e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:609 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e03a880 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:611 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22df696c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:612 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f53b95da | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:614 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2305215b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:617 | if (monthInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2b77e0ce | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:619 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCatagory…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f77bea6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1152 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-14a3b762 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1152 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-f5111a59 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1155 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-126d83dd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1163 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-05c3ef17 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1170 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24973026 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5021 | if (programID == "PR_UI_FP00594_AMEND_MODEL_SELECT") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-d01abad4 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5026 | if (programID == "PR_UI_FP00594_AMEND_MODEL_TOTAL_SELECT") | RETURN | return FindTotalValue("","SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-775aa811 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5033 | if (programID == "PR_UI_FP00594_AMEND_MODEL_BOH_SAVE") ▸ if (dsBoh.Tables[0].Rows.Count > 0) | DATA_OP | dsBoh.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cdec359e | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5035 | if (programID == "PR_UI_FP00594_AMEND_MODEL_BOH_SAVE") ▸ if (dsBoh.Tables[0].Rows.Count > 0) | RETURN | return Save_Data_Boh(dtData, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-ea441e80 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5039 | if (programID == "PR_UI_FP00594_AMEND_MODEL_BOH_SAVE") ▸ else of (dsBoh.Tables[0].Rows.Count > 0) | MESSAGE | MessageBox.Show | ("there is no Edit Value of BOH QTY .") | 메시지 표시 |  |  |  |
| AC-8c16b612 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5040 | if (programID == "PR_UI_FP00594_AMEND_MODEL_BOH_SAVE") ▸ else of (dsBoh.Tables[0].Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8e996868 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5051 | if (programID == "PR_UI_FP00594_AMEND_MODEL_DATA_SAVE") ▸ if (dtListData != null) ▸ if (dtListData.Rows.Count > 0) | RETURN | return Save_Data_Amend(dtListData, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-df0ff8e4 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5055 | if (programID == "PR_UI_FP00594_AMEND_MODEL_DATA_SAVE") ▸ if (dtListData != null) ▸ else of (dtListData.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_OUT_CELL.") | 메시지 표시 |  |  |  |
| AC-6290fcd8 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5056 | if (programID == "PR_UI_FP00594_AMEND_MODEL_DATA_SAVE") ▸ if (dtListData != null) ▸ else of (dtListData.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-26ee2b2f | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5061 | if (programID == "PR_UI_FP00594_AMEND_MODEL_DATA_SAVE") ▸ else of (dtListData != null) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_OUT_CELL.") | 메시지 표시 |  |  |  |
| AC-ddd8f6ab | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5062 | if (programID == "PR_UI_FP00594_AMEND_MODEL_DATA_SAVE") ▸ else of (dtListData != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c18a1033 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5072 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") | POPUP | new FP00594_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8f37520e | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5076 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.DateColumnType | FPExtensions.DateColumnType.CELL | 속성 DateColumnType 설정 |  |  |  |
| AC-edb5a243 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5078 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-f4ef4f31 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5079 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-b1a07fef | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5080 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-d94b78c1 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5082 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-01ddd868 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5089 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00594_AMEND_MODEL_EXCEL", Filter… |  | 처리 중단/반환 |  |  |  |
| AC-29479f35 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5101 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") | POPUP | new FP00594_RowExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-604fa1f0 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5106 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-8b834c75 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5107 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-4bc592e2 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5108 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-ac29bc63 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5110 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-cb3c2bd3 | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5116 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00594_AMEND_MODEL_EXCEL", Filter… |  | 처리 중단/반환 |  |  |  |
| AC-6bec99ab | popSql.OnSql | FP00594_PlanAmend_Model_NJ_Pouch.cs:5122 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Save_Boh

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60310155 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:1964 | if (siMain == null \|\| dtData == null) | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-dce42ff3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:1966 | if (dtData.Rows.Count ==0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7cbbc83e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:1970 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2c1d454b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:1971 | if (blnWork) | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-2512cc6a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:1976 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5aae9ad7 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:1988 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("this data can't save! , Plan type is Release!") | 메시지 표시 |  |  |  |
| AC-19285c66 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:1989 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cc9ab550 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:1990 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43df43d9 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:1993 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6311df0c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2006 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4cffeed7 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2007 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5659e4e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2010 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ff8c7e65 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2028 | try ▸ if (dtData.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a26068f9 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2051 | try ▸ if (!string.IsNullOrEmpty(sError)) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d1c73ee6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2060 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-82b88f49 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2061 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-58dc27eb | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2062 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-12b6dcca | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2063 | catch ((Exception ex)) | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-9d079809 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2067 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d9067cbe | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:2068 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Save_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DATA_SAVE") ▸ if (dtListData != null) ▸ if (dtListData.Rows.Count > 0)] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…) ▸ if (dsMainFiltered.Good()) ▸ try] / this.sp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e72b556 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2393 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-6b63d668 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2394 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9a4635de | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2396 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-32cfafad | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2397 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cf473469 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2398 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-7cde3e2d | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2399 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4af96de1 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2400 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-89aa6bd8 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2401 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-35822bdf | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2402 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-e5c692b1 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2403 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-21c55cd5 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2404 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f1071d46 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2405 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a29620dd | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2406 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-47fe1f7a | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2407 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-540c24d9 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2408 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-df7d2240 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2409 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-df428bb5 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2410 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5c758b8d | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2411 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-b0ddcef3 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2412 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-c3daea44 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2413 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-8bd8628a | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2414 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-65538245 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2415 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-f0093cc3 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2416 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-c6385ca0 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2417 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-a64c90da | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2418 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_in_qty"] | p_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-0b7e1609 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2419 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-c0ede514 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2420 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_in_qty"] | p_cell_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-086e9a03 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2421 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_out_qty"] | p_cell_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-cea0c399 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2422 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_boh_qty"] | p_boh_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1e134c34 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2424 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plm_ec_no"] | p_plm_ec_no | 행/컬럼 값 대입 |  |  |  |
| AC-3498498a | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2425 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version"] | p_version | 행/컬럼 값 대입 |  |  |  |
| AC-59b053e8 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2427 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-485424fc | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2428 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b7ee6f4d | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2434 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-cd560c57 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_DA… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2440 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Save_Data_Boh

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BOH_SAVE") ▸ if (dsBoh.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b94bbcd | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2151 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-e78812f4 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2152 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a6003a4f | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2154 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3f854281 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2155 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3175f842 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2156 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5de33243 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2157 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b3226444 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2158 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-19d868fd | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2159 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-dbf94fd2 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2160 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-76446fa9 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2161 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-a912fccf | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2162 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7202da38 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2163 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-488cf61a | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2164 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-2a9a3ae9 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2165 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-61284247 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2166 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-402ba170 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2167 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-4f49915d | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2168 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-555a1ab9 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2169 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-66b2f418 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2170 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-c23d4e68 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2171 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-eb9b89bd | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2172 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-e0de889a | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2173 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-ec13c396 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2174 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-2fb08624 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2175 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-5cae363f | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2176 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_in_qty"] | p_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-7fac9ab6 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2177 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-2f5f36fb | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2178 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_in_qty"] | p_cell_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-77e6092c | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2179 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_out_qty"] | p_cell_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-33f43c3a | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2180 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_boh_qty"] | p_boh_qty | 행/컬럼 값 대입 |  |  |  |
| AC-7cfdaca4 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2182 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2afefaac | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2183 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-96be947e | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2189 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-107b13e2 | popSql.OnSql [if (programID == "PR_UI_FP00594_AMEND_MODEL_BO… 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2195 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Save_Data_Excel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c979b60e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6100 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-1dd0b03b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6101 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d31f9613 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6103 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-fc28445f | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6104 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6562ced9 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6105 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-42fb525e | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6106 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e9cc37a3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6107 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-08c9def5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6108 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-74965a14 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6109 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7a8e6d67 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6110 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-518697a9 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6111 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-55203ccd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6112 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ca72f9b0 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6113 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-955e036c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6114 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5ff74aee | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6115 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-12fdf85a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6116 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7f94386d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6117 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cf3b1c35 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6118 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f79fe40 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6119 | try | DATA_OP | request.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-533210df | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6120 | try | DATA_OP | request.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f66926da | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6121 | try | DATA_OP | request.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2047c587 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6122 | try | DATA_OP | request.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bee56384 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6123 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0721a8f3 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6124 | try | DATA_OP | request.Parameters["p_cell_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3a0dc390 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6125 | try | DATA_OP | request.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e57c1253 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6126 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-39cb607a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6127 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d89f45b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6128 | try | DATA_OP | request.Parameters["p_new_seq_no"] | sNewSeqNo | 행/컬럼 값 대입 |  |  |  |
| AC-c81e8bca | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6129 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | sMppWpp | 행/컬럼 값 대입 |  |  |  |
| AC-25546ce6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6131 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2e258958 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6133 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-3d7cb119 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6138 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-9f6bcf9a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6140 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Save_Data_Excel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24122a48 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6178 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-e0992db4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6179 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-751a9c67 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6181 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-ddefe779 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6182 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-34d236c4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6183 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5557d625 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6184 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e969cfcb | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6185 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-88caa205 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6186 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-81e92534 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6187 | try | DATA_OP | request.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-28f2766a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6188 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a1ff14cb | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6189 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-db52e490 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6190 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f16bdeff | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6191 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e63ab1d6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6192 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ad07be85 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6193 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d3925dc4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6194 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-15472d12 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6195 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e0e86152 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6196 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e87e94dc | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6197 | try | DATA_OP | request.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3da0579a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6198 | try | DATA_OP | request.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-705a0aa5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6199 | try | DATA_OP | request.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-824661a1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6200 | try | DATA_OP | request.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5c2b6f47 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6201 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-76304ee1 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6202 | try | DATA_OP | request.Parameters["p_cell_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-37519a85 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6203 | try | DATA_OP | request.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-620c6b3a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6204 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-38b72637 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6205 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ba7d8066 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6206 | try | DATA_OP | request.Parameters["p_new_seq_no"] | sNewSeqNo | 행/컬럼 값 대입 |  |  |  |
| AC-6c96e8db | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6207 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | sMppWpp | 행/컬럼 값 대입 |  |  |  |
| AC-ac6c0ccf | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6209 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ad29f098 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6211 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-e3f1f043 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6216 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-3d0cafc4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:6218 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.Save_P_Cell

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…) ▸ if (dsMainFiltered.Good())] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (siMain.GetColumnTag(e.Column).Equals("BOH_QTY")) ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9643b5b7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2205 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-83c7d8d4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2208 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee7f24d1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2210 | if (dtData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16cdd648 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2211 | if (dtData.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f493e8e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2216 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd963c88 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2217 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71b12875 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2222 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1065a478 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2234 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("this data can't save! , Plan type is Release!") | 메시지 표시 |  |  |  |
| AC-65164121 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2235 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0d5ccfcf | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2236 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-761c1c86 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2239 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6d7e242d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2252 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-920def46 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2253 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-991f72f4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2256 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-39ec8394 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2285 | try ▸ if (!string.IsNullOrEmpty(sError)) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-53f79f0e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2289 | try ▸ if (!string.IsNullOrEmpty(sError)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b9918365 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2292 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-215a3b24 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2296 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4566cdb9 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2297 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-130f5342 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2298 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-6014007e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2299 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a1e7d60 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2303 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-aeb07bfe | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:2304 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56415c41 | SaveButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:866 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-803a04eb | SaveButton | FP00594_PlanAmend_Model_NJ_Pouch.cs:867 |  | MESSAGE | MessageBox.Show | ("Save button[F7] can't use!") | 메시지 표시 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetBasisTime

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a61d4064 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4040 |  | FLAG | dtBaseTime | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findBasisTime", sInstance,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-5f17eada | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4040 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findBasisTime", sInstance, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetBohQty

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain.Good())] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15898964 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1664 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-55bb7372 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1665 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e99aa64 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1670 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-d0361cde | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1675 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ffec324 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1676 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-68a2f895 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1677 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-881f11b8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1678 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5942511d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1679 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc0f972a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1680 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-67fe1784 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1681 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe7d90fd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1682 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e91af554 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1686 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetBohQtyByEditCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a442f3bf | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4291 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-063fa5d7 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4292 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-30a34b37 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4296 | lambda | DATA_OP | each_row.Field | ("IS_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-79a8b825 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4298 |  | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8f19a2df | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4314 | if (nColStart == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d560ac1d | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4348 | for (i <= nRowEnd) | GRID_SET | siMain.SetValue | (i, cCol, nBoh) | 그리드 값 설정 |  |  |  |
| AC-8c35a6c2 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4391 | for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ if (sPSI == "I") | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nI_tmp) | 그리드 값 설정 |  |  |  |
| AC-5a28fa2b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4447 | for (i <= nRowEnd) ▸ else of (sDTyp == "DATA") | GRID_SET | siMain.SetValue | (i, cCol, nBoh_tmp) | 그리드 값 설정 |  |  |  |
| AC-0b867ce8 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4499 | for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDTyp == "DATA") ▸ if (dsMainFiltered.Tables[0].Rows[i]["DATA_TYPE"].ToString() == "TOTAL… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nPI_tmp) | 그리드 값 설정 |  |  |  |
| AC-baa5c253 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4504 | for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDTyp == "DATA") ▸ if (dsMainFiltered.Tables[0].Rows[i]["DATA_TYPE"].ToString() == "TOTAL… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nPO_tmp) | 그리드 값 설정 |  |  |  |
| AC-cb82f3de | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4510 | for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDTyp == "DATA") ▸ if (dsMainFiltered.Tables[0].Rows[i]["DATA_TYPE"].ToString() == "TOTAL… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nS_tmp) | 그리드 값 설정 |  |  |  |
| AC-186df979 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4515 | for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDTyp == "DATA") ▸ if (dsMainFiltered.Tables[0].Rows[i]["DATA_TYPE"].ToString() == "TOTAL… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nI_tmp) | 그리드 값 설정 |  |  |  |
| AC-0e91bbf6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4524 | if (dsBoh == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_ListData_BOH", Filter["INSTANCE_ID"].ToString(), Filter["PL… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b71ec670 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4526 | if (dsBoh == null) | FLAG | dsBoh | dtBoh.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-cf54ea37 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4530 |  | DATA_OP | dsBoh.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7d0475bd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4538 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a4db796 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4539 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-aa2a9b97 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4540 | lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf7fc7c5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4541 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-60e268b9 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4542 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-23d41a2a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4543 | lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-e1924f99 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4544 | lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb8720c2 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4545 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-761de3f4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4538 | lambda | RETURN | return (x.Field<string>("DIVISION_ID") == row["DIVISION_ID"].ToString() && x.Fie… |  | 처리 중단/반환 |  |  |  |
| AC-34fbdd31 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4563 | if (MatchingEditRowData.Count() > 0) ▸ if (orgQty == Convert.ToDecimal(newEditingValue)) | DATA_OP | selected["ACTION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8a46ab35 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4564 | if (MatchingEditRowData.Count() > 0) ▸ if (orgQty == Convert.ToDecimal(newEditingValue)) | DATA_OP | selected["QTY"] | orgQty.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fed57a2c | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4565 | if (MatchingEditRowData.Count() > 0) ▸ if (orgQty == Convert.ToDecimal(newEditingValue)) | DATA_OP | selected["ORIG_QTY"] | orgQty.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-16d9af79 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4569 | if (MatchingEditRowData.Count() > 0) ▸ else of (orgQty == Convert.ToDecimal(newEditingValue)) | DATA_OP | selected["QTY"] | Convert.ToDecimal(newEditingValue) | 행/컬럼 값 대입 |  |  |  |
| AC-be5c99fc | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4570 | if (MatchingEditRowData.Count() > 0) ▸ else of (orgQty == Convert.ToDecimal(newEditingValue)) | DATA_OP | selected["ACTION"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-c4463f09 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4573 | if (MatchingEditRowData.Count() > 0) | DATA_OP | dtBohSave.ImportRow | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-e093a4dd | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4583 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtBohSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-42d778b4 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4585 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-e6e60383 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4586 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-145e1c2a | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4587 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | sFPPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-a720c737 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4588 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a95d71b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4589 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-82ee2720 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4590 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-12d24ba6 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4591 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7ae883ef | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4592 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-af13fe54 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4593 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc28d9a5 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4594 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-406178ba | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4595 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["TOP_ITEM_ID"] | row["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6df19073 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4596 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LOCATION"] | row["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bbd93a80 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4597 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["QTY"] | Convert.ToDecimal(newEditingValue) | 행/컬럼 값 대입 |  |  |  |
| AC-126b4002 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4598 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ORIG_QTY"] | Convert.ToDecimal(newEditingValue) | 행/컬럼 값 대입 |  |  |  |
| AC-60c4656b | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4599 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ACTION"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-80165bac | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4601 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtBohSave.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6adbd42 | (진입점 미연결) | FP00594_PlanAmend_Model_NJ_Pouch.cs:4610 |  | STATE_RESET | dtBohSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetCalenderColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMain…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfebb876 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1399 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-994cc03d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1403 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-3627937c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1405 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d30094b7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1409 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-b758dfb4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1425 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-9400127b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:1440 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetChangeControl

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_planner.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / cbo_fpplanid.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / mcbo_prodtype.SelectedIndexChanged / chk_allLine.CheckedChanged / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (mem…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d728d0e7 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:396 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d6ebb93 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:396 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a47cb475 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:405 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-8e31e89f | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:405 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f6ac648e | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:406 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fb18cb25 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:412 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-174805a4 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:413 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b0ba76b | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:413 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-73151b46 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:414 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a384ce1e | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:420 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, mcbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-7967c50d | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:421 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-79f47a6f | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:421 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6fb5817d | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:422 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e0292052 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:428 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-afc2eb8c | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:429 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-64ca3dff | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:429 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3b552c6b | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:430 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-924c5a63 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:437 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-29f7321f | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:438 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-99f7f929 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:438 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6d148636 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:439 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a5f4771c | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:445 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-774cadb9 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:446 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a3de8679 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:446 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e44e9bc6 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:447 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-34d6ea13 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:453 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-45163967 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:457 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODTYPE_ID"] | Filter["PRODUCTION_TYPE"] = Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, … | 행/컬럼 값 대입 |  |  |  |
| AC-35cfffd0 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:457 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-acfbff8d | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:457 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PROD_TYPE"] | CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-da7bc725 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:460 | switch (triggerControl) case DefColumns.PLANNER_ID: | DATA_OP | Filter["PLANNER_ID"] | CString.GetCheckedListValue(dtPlanner, mcbo_planner.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8db134f8 | this.Load [try] 외 15 | FP00594_PlanAmend_Model_NJ_Pouch.cs:463 | switch (triggerControl) case DefColumns.FP_PLAN_ID: | DATA_OP | Filter["FP_PLAN_ID"] | CString.GetCheckedListValue(dtPlanId, cbo_fpplanid.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55997b3b | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:230 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e850c6e4 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:232 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-9b8d1db1 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:236 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e22c6307 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:238 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-91358d68 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:239 |  | CALL_EXT | UserService.HasSuperRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba7f6cc1 | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:241 | if (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-9737f82d | this.Load | FP00594_PlanAmend_Model_NJ_Pouch.cs:245 | else of (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetDirty

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…)] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (siMain.GetColumnTag(e.Column).Equals("BOH_QTY"))] / this.btnBucket.Click [if (frm…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f440b145 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 5 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4241 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_planner.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) ▸ if (dtPlanId.Rows.Count > 0)] / cbo_fpplanid.SelectedIndexChanged [if (cbo_fpplanid.Items.Count > 0)] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Go…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30b64689 | this.Load [try] 외 28 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4019 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetFpPlanId

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-412592e3 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4129 |  | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-cf1f7e1b | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4129 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-052eb39c | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4130 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f96bee93 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4133 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-543d6deb | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4135 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | cbo_fpplanid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-0c1197a9 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4151 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[0]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-84ec0e0f | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4152 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[0]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-107a5c56 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4153 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[0]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-12600e1f | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4154 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[0]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-7843f2a3 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4155 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[0]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-23b03d4b | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4157 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-c4d2f606 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4158 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-832f44b6 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4159 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-9b90a8a3 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4160 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-e21155af | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4161 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-6a43995e | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4177 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-4762aa4b | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4178 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-a31e5845 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4179 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-34431fc7 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4180 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-36baffc8 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4181 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-90c4ba7c | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4183 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-7187ea3c | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4184 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-8cfa5361 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4185 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-e2c64d36 | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4186 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-b763633c | this.Load [try] 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4187 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetPlanDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a57c945a | this.Load [try] | FP00594_PlanAmend_Model_NJ_Pouch.cs:4030 |  | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetPlanner

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f30d6042 | this.Load [try] 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4053 |  | FLAG | dtPlanner | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findPlanner_List", sInstan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-c3e48df4 | this.Load [try] 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4053 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findPlanner_List", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-950a1f76 | this.Load [try] 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4054 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, mcbo_planner, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-d4b9aa84 | this.Load [try] 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4064 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row[… | CALL_EXT | mcbo_planner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e3cd684 | this.Load [try] 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4068 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of … | CALL_EXT | mcbo_planner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-21a3c32f | this.Load [try] 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4082 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-62d47634 | this.Load [try] 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4083 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-13904d32 | this.Load [try] 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4092 | if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner.Items.Count) ▸ if (mcbo_planner.Items[k].ToString() == sValueName.ToString()) | CALL_EXT | mcbo_planner.SetItemChecked | (k, true) | ⚠ 의미 확인 필요 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetPlanOutCell

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…)] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (siMain.GetColumnTag(e.Column).Equals("BOH_QTY"))] / this.spdMain.KeyDown [else of…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74aa8dc6 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4621 | if (EditingCol != cCol) | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-47b8ac30 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4626 | if (EditingRow != cRow) | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-f2f2fa29 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4631 |  | FLAG | EditingRow | cRow | 화면 필드/플래그 변경 |  |  |  |
| AC-341d9fa2 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4635 | if (dsMainFiltered.Good()) | FLAG | dlData | DataLines.CreateDataLine(siMain, calendar, cRow, cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-10967f8e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4635 | if (dsMainFiltered.Good()) | CALL_EXT | DataLines.CreateDataLine | (siMain, calendar, cRow, cCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0e550df | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4640 | if (dsMain.Good()) | FLAG | dlView | DataLines.CreateDataLine(dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | 화면 필드/플래그 변경 |  |  |  |
| AC-68b44deb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4640 | if (dsMain.Good()) | CALL_EXT | DataLines.CreateDataLine | (dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f57638ad | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4646 |  | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-74bf8651 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4655 | try | FLAG | UOMRate | AmendService.FindCellRate( clicked_row["PLANT_ID"].ToString(), clicked_row["TOP_ITEM_ID"].… | 화면 필드/플래그 변경 |  |  |  |
| AC-39fe2040 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4655 | try | CALL_EXT | AmendService.FindCellRate | ( clicked_row["PLANT_ID"].ToString(), clicked_row["TOP_ITEM_ID"].ToString(), clicked_row["… | ⚠ 의미 확인 필요 |  |  |  |
| AC-86e876c1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4661 | try | FLAG | YieldRate | AmendService.FindYieldInfo( clicked_row["DIVISION_ID"].ToString(), clicked_row["SITE_ID"].… | 화면 필드/플래그 변경 |  |  |  |
| AC-079a81c5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4661 | try | CALL_EXT | AmendService.FindYieldInfo | ( clicked_row["DIVISION_ID"].ToString(), clicked_row["SITE_ID"].ToString(), clicked_row["P… | ⚠ 의미 확인 필요 |  |  |  |
| AC-240c1047 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4673 | try ▸ if (dlData != null) | UI_PROP | dlData.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-50018837 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4674 | try ▸ if (dlData != null) | UI_PROP | dlData.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-b79451ac | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4678 | try ▸ if (dlView != null) | UI_PROP | dlView.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-bc046290 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4679 | try ▸ if (dlView != null) | UI_PROP | dlView.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-dba1d17c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4686 | if (dlData == null \|\| dlView==null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e68ebf50 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4722 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-449b5033 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4729 | if (dsMainFiltered.Good()) ▸ if (dt == null) | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f8140bc8 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4730 | if (dsMainFiltered.Good()) ▸ if (dt == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e278468 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4733 | if (dsMainFiltered.Good()) | DATA_OP | dt.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d79d27f9 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4745 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f94656c1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4746 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6d8d72c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4747 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-140abeed | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4748 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-93f5b064 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4749 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ba325d4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4750 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e867040 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4751 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-68bff202 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4752 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cee9cabc | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4755 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6382fc61 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4758 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b8c43c5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4759 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f549824b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4760 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b257a15 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4761 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ab18eec | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4762 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-83491846 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4763 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLM_EC_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-87ddb717 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4764 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-05a444db | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4743 | if (dsMainFiltered.Good()) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("FP_PL… |  | 처리 중단/반환 |  |  |  |
| AC-de7dccfe | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4777 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT_CELL") | DATA_OP | selected["P_IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-53dee06b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4778 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT_CELL") | DATA_OP | selected["P_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-c9c39f9b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4779 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT_CELL") | DATA_OP | selected["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-aee42afc | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4780 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT_CELL") | DATA_OP | selected["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-120c6c7d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4781 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT_CELL") | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-b6a6686a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4805 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT_CELL") | DATA_OP | dtSave.ImportRow | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f88c682 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4816 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f43c3d28 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4818 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-e6a15e3c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4819 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-49fcd3a4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4820 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ff1a1b97 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4821 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8470d356 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4822 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["CATEGORY_ID"] | row["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5620e6d3 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4823 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-190b3a08 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4824 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f34d7268 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4825 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e88b352c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4826 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ae8910dc | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4827 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["MARKET"] | row["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-96f74022 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4828 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0336045d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4829 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-70a82f9e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4830 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a6aa1d9 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4831 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["LOCATION"] | row["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d0086046 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4832 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-880f2f10 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4833 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["TOP_ITEM_ID"] | row["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1da3007f | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4834 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c83d2af0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4835 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["ITEM_TYPE"] | row["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4545a7f1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4836 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["PLM_EC_NO"] | row["PLM_EC_NO"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5cf24eb3 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4837 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["VERSION"] | row["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef4fa396 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4841 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT_CELL") | DATA_OP | newrow["P_IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-12f45716 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4842 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT_CELL") | DATA_OP | newrow["P_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-988e7adf | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4844 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT_CELL") | DATA_OP | newrow["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-c3239394 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4845 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT_CELL") | DATA_OP | newrow["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-503d3388 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4847 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-c72e8704 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4850 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-774205d9 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4851 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | dtSave.ImportRow | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fdf6b32 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4873 | if (dsMainFiltered.Good()) ▸ if (dlData._P_OUT != -1) | GRID_SET | siMain.ActiveSheet.Cells[dlData._P_OUT, cCol].Value | Math.Ceiling(new_value * dlData.UOMRate) | 그리드 속성/값 설정 |  |  |  |
| AC-6cb645e4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4880 | if (dsMainFiltered.Good()) ▸ if (dlData._P_IN_CELL != -1) | GRID_SET | siMain.ActiveSheet.Cells[dlData._P_IN_CELL, cCol].Value | Math.Ceiling(in_value) | 그리드 속성/값 설정 |  |  |  |
| AC-43e131ee | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4882 | if (dsMainFiltered.Good()) ▸ if (dlData._P_IN != -1) | GRID_SET | siMain.ActiveSheet.Cells[dlData._P_IN, cCol].Value | Math.Ceiling(in_value * dlData.UOMRate) | 그리드 속성/값 설정 |  |  |  |
| AC-0e4cf516 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4904 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (dlView._I_CELL != -1) | GRID_SET | siMain.ActiveSheet.Cells[dlData._I_CELL, next_col].Value | existing + delta | 그리드 속성/값 설정 |  |  |  |
| AC-c02ce481 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4907 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (dlView._I_CELL != -1) ▸ if (dlView._I !… | GRID_SET | siMain.ActiveSheet.Cells[dlData._I, next_col].Value | (existing + delta) * dlData.UOMRate | 그리드 속성/값 설정 |  |  |  |
| AC-9384f050 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4924 | if (dsMainFiltered.Good()) | LIST_BIND | dgEdit.DataSource | dt | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-26d76f99 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4930 | if (dsMainFiltered.Good()) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetPlanPeriod

진입점: this.Load [try] / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdec939b | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4219 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-76923fb1 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4220 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-e499b9a3 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4224 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-dfa0be71 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4225 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-55bdd6e8 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4231 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-32dbe5b3 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4232 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetProdType

진입점: this.Load [try] / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c922582 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4196 |  | FLAG | dtProdType | DataService.GetProdType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7bbc95fc | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4196 |  | CALL_EXT | DataService.GetProdType | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6d7d7c6 | this.Load [try] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:4197 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prodtype, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dd891ba | this.Load [try] 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:507 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-464cc0be | this.Load [try] 외 8 | FP00594_PlanAmend_Model_NJ_Pouch.cs:508 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SetTotalColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMain…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57d75b8a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 7 | FP00594_PlanAmend_Model_NJ_Pouch.cs:550 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13ff09cd | this.spdMain.ButtonClicked | FP00594_PlanAmend_Model_NJ_Pouch.cs:3729 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f07793b | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6788 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c99b93da | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6789 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43b42056 | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6810 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-1b48d904 | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6811 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-0e42d9e4 | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6813 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-e142c690 | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6830 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-30abf99a | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6831 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-ce7fb3db | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6833 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-f985776d | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6840 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae04a64b | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6843 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_mat_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-6566954b | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6844 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_mat_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-8d087749 | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6846 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_mat_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-0324b70a | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6856 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | nlfamend_menu.Text | "NLF Amend" | 컨트롤 값 설정 |  |  |  |
| AC-5bb685aa | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6857 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | nlfamend_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-fe2e845b | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6859 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (nlfamend_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfd72f0e | this.spdMain.CellClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6868 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f945ee0 | this.spdMain.CellDoubleClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6632 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-be757cd9 | this.spdMain.CellDoubleClick | FP00594_PlanAmend_Model_NJ_Pouch.cs:6639 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-417b0740 | this.spdMain.Change | FP00594_PlanAmend_Model_NJ_Pouch.cs:3710 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (siMain.GetColumnTag(e.Column).Equals("BOH_QTY")) ▸ if (Convert.ToInt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f1426ae6 | this.spdMain.Change | FP00594_PlanAmend_Model_NJ_Pouch.cs:3713 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (siMain.GetColumnTag(e.Column).Equals("BOH_QTY")) ▸ if (Convert.ToInt… | GRID_SET | siMain.SetValue | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-125f256e | this.spdMain.Change | FP00594_PlanAmend_Model_NJ_Pouch.cs:3714 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (siMain.GetColumnTag(e.Column).Equals("BOH_QTY")) ▸ if (Convert.ToInt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e41e89e | this.spdMain.Change | FP00594_PlanAmend_Model_NJ_Pouch.cs:3723 |  | VALUE_SET | tbLog.Text | "spdMain_Change" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-817dae99 | this.spdMain.ChildControlDeactivated | FP00594_PlanAmend_Model_NJ_Pouch.cs:3647 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-840c4e0b | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3739 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-d1dc2cb5 | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3740 |  | ENDPOINT | Clipboard.GetDataObject | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7746b7fe | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3742 |  | COMBO_DATA | data.GetFormats | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-44adfd25 | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3746 |  | ENDPOINT | data.GetDataPresent | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c3ed1e5 | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3748 | if (data.GetDataPresent(typeof(System.String))) | ENDPOINT | data.GetData | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b12b7315 | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3752 | if (data.GetDataPresent(typeof(System.String))) | CALL_EXT | src_string.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-382cab8e | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3768 | if (data.GetDataPresent(typeof(System.String))) ▸ if (MaxColCount > 0 && ClipRowCount > 0) | FLAG | ClipData | new string[ClipRowCount, MaxColCount] | 화면 필드/플래그 변경 |  |  |  |
| AC-d5bf611b | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3779 | if (data.GetDataPresent(typeof(System.String))) ▸ if (MaxColCount > 0 && ClipRowCount > 0) ▸ for (i < ClipRowCount) ▸ for (j < cells.Length) | DATA_OP | ClipData[i, j] | cell | 행/컬럼 값 대입 |  |  |  |
| AC-14c7cd10 | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3791 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0a0d55a | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3792 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-36fbf804 | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3797 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ac8a9e9b | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3812 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | GRID_SET | siMain.ActiveSheet.Cells[startrow, startcol].Value | src_copy | 그리드 속성/값 설정 |  |  |  |
| AC-1c70b5ff | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3819 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7e99d2bf | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3822 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9929de31 | this.spdMain.ClipboardPasting | FP00594_PlanAmend_Model_NJ_Pouch.cs:3824 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc3825fb | this.spdMain.DragFillBlockCompleted | FP00594_PlanAmend_Model_NJ_Pouch.cs:3657 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8ee3e6e | this.spdMain.EditModeOff | FP00594_PlanAmend_Model_NJ_Pouch.cs:3675 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d575606 | this.spdMain.EditModeOn | FP00594_PlanAmend_Model_NJ_Pouch.cs:3681 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-87465959 | this.spdMain.EditModeOn | FP00594_PlanAmend_Model_NJ_Pouch.cs:3682 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b0bbe61 | this.spdMain.EditorFocused | FP00594_PlanAmend_Model_NJ_Pouch.cs:3669 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09209a31 | this.spdMain.Enter | FP00594_PlanAmend_Model_NJ_Pouch.cs:3632 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4745f387 | this.spdMain.KeyDown | FP00594_PlanAmend_Model_NJ_Pouch.cs:3581 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5cd5b9d | this.spdMain.Leave | FP00594_PlanAmend_Model_NJ_Pouch.cs:3627 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f2fb2a2 | this.spdMain.SubEditorClosed | FP00594_PlanAmend_Model_NJ_Pouch.cs:3663 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-321d7d82 | this.spdMain.SubEditorOpening | FP00594_PlanAmend_Model_NJ_Pouch.cs:3652 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a301326 | this.spdMain.Validated | FP00594_PlanAmend_Model_NJ_Pouch.cs:3637 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb30b060 | this.spdMain.Validating | FP00594_PlanAmend_Model_NJ_Pouch.cs:3642 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.SwitchMemo

진입점: memo_menu.Click [if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-939842a0 | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6650 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88ccba46 | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6667 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-cfd89099 | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6692 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d07b4ed4 | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6718 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-813a480c | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6720 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-d58eed93 | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6723 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-aca61cd9 | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6725 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e04d28bd | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6725 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-f0a9a9db | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6726 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-1cdeca73 | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6728 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-fde52066 | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6730 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e3fc3482 | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6742 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-da4a5dc3 | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6742 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-f372835c | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6762 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-8455fa5c | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6763 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-6df7d06f | memo_menu.Click [if (day != null)] 외 1 | FP00594_PlanAmend_Model_NJ_Pouch.cs:6765 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00594_PlanAmend_Model_NJ_Pouch.UIFindData

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9143062b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:653 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6a4f514c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:654 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-355e1697 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:657 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e8f6e152 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:660 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-d2598d6d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:664 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan ID to proceed") | 메시지 표시 |  |  |  |
| AC-2f277f6f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:665 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-029a1952 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:666 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a18c66df | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:671 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-335696fd | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:684 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8115dcc3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:685 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc7f7f8c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:688 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c084dcd7 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:692 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-489b6d31 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:693 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3be8b377 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:695 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e90518fa | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:697 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-05e5819f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:708 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4c158147 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:710 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-6c64f9ab | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:710 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-160b443e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:721 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | LastTotalRaw | FindTotalValue("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-eb807118 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:723 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0fe1a77 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:725 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | Filter["COMPANY_ID"] | dsMain.Tables[0].Rows[0]["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c2603a66 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:732 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… | STATE | btnWOWStatus.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c7de6f87 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:734 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ else… | STATE | btnWOWStatus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b5d06900 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:739 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-e5a58c5d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:744 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-0a45f074 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:745 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-8a8983f1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:746 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6d0a3a27 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:751 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-23d7e60e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:752 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fb142d51 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:753 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-3f117421 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:756 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8cf2dbb8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:770 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8d19b37f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:774 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a5b80628 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:780 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db16fa65 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:785 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4cbf07d3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:786 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c761f7aa | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:793 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1be5ea98 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:796 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-32fc5120 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:800 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-7e63944d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00594_PlanAmend_Model_NJ_Pouch.cs:804 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00594_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49322f7d | .ctor | FP00594_RowExcelPopup.cs:155 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2847405f | .ctor | FP00594_RowExcelPopup.cs:158 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-4d993872 | .ctor | FP00594_RowExcelPopup.cs:159 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00594_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-294b122b | this.btnClose.Click | FP00594_RowExcelPopup.cs:1040 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8c636cd | this.btnDownload.Click | FP00594_RowExcelPopup.cs:1011 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-2259c9b5 | this.btnDownload.Click | FP00594_RowExcelPopup.cs:1012 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |
| AC-ff5f1073 | this.btnDownload.Click | FP00594_RowExcelPopup.cs:1014 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00594_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18c2cd4c | this.btnFind.Click | FP00594_RowExcelPopup.cs:1006 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00594_RowExcelPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-414f872d | this.btnSave.Click | FP00594_RowExcelPopup.cs:1035 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00594_RowExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98bd88db | this.btnUpload.Click | FP00594_RowExcelPopup.cs:1026 | if (bUpload) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-793d0d5f | this.btnUpload.Click | FP00594_RowExcelPopup.cs:1027 | if (bUpload) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |

## FP00594_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a31e386 | this.Load | FP00594_RowExcelPopup.cs:248 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-16be59d2 | this.Load | FP00594_RowExcelPopup.cs:249 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8523c008 | this.Load | FP00594_RowExcelPopup.cs:250 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00594_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a44a34a | (진입점 미연결) | FP00594_RowExcelPopup.cs:934 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bbf3d38c | (진입점 미연결) | FP00594_RowExcelPopup.cs:934 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00594_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db4d323d | this.Load | FP00594_RowExcelPopup.cs:243 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00594_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-152bc2e3 | Dispose | FP00594_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00594_RowExcelPopup.dtpPeriod_ValueChanged

진입점: this.dtpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffe84190 | this.dtpPeriod.ValueChanged | FP00594_RowExcelPopup.cs:1054 | if (bFirst == true) | FLAG | bFirst | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3d145cd2 | this.dtpPeriod.ValueChanged | FP00594_RowExcelPopup.cs:1055 | if (bFirst == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1161072 | this.dtpPeriod.ValueChanged | FP00594_RowExcelPopup.cs:1069 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ce22cb6 | this.dtpPeriod.ValueChanged | FP00594_RowExcelPopup.cs:1071 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | VALUE_SET | dtpPeriod.InitValue | sStartDate + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6921aa0e | this.dtpPeriod.ValueChanged | FP00594_RowExcelPopup.cs:1072 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7550a15 | this.dtpPeriod.ValueChanged | FP00594_RowExcelPopup.cs:1077 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25f1a509 | this.dtpPeriod.ValueChanged | FP00594_RowExcelPopup.cs:1085 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-19a1b148 | this.dtpPeriod.ValueChanged | FP00594_RowExcelPopup.cs:1087 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a2951258 | this.dtpPeriod.ValueChanged | FP00594_RowExcelPopup.cs:1090 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-ac7d09f7 | this.dtpPeriod.ValueChanged | FP00594_RowExcelPopup.cs:1091 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |

## FP00594_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61355d8b | (진입점 미연결) | FP00594_RowExcelPopup.cs:698 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00594_RowExcelPopup.Exec_Procedure

진입점: this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCCESS"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6c733c8 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:950 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-2f885dab | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:951 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e07820f1 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:953 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-56410a75 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:954 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-6d8b0fc4 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:955 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4786726b | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:956 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-29cd630a | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:957 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-229b064e | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:958 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f2f5c56 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:959 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-e5e1668e | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:960 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-657606ca | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:961 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0c897863 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:962 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f78464ba | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:963 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-97fcf33f | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:964 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b2acfe5e | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:965 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4999f6d9 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:966 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4e304697 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:967 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-970228f2 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:968 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-63081395 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:969 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5bd661cd | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:970 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c37fab86 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:971 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-20ddc6c9 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:972 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4745032f | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:973 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-025161f4 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:974 | try | DATA_OP | req.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-53406a1c | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:975 | try | DATA_OP | req.Parameters["p_p_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7e3cf807 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:976 | try | DATA_OP | req.Parameters["p_p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-24fca243 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:977 | try | DATA_OP | req.Parameters["p_mpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2683fda2 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:978 | try | DATA_OP | req.Parameters["p_mpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f339ccdb | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:979 | try | DATA_OP | req.Parameters["p_wpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6ad2795a | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:980 | try | DATA_OP | req.Parameters["p_wpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4078d7e8 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:981 | try | DATA_OP | req.Parameters["p_boh_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-84a48451 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:983 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dfb282fd | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:990 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-e1545437 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00594_RowExcelPopup.cs:994 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00594_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a899dc3 | FindButton | FP00594_RowExcelPopup.cs:290 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5fd4d522 | FindButton | FP00594_RowExcelPopup.cs:291 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4eca7c14 | FindButton | FP00594_RowExcelPopup.cs:293 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00594_RowExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e64af76 | this.Load 외 2 | FP00594_RowExcelPopup.cs:322 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-043554c8 | this.Load 외 2 | FP00594_RowExcelPopup.cs:328 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c021e07 | this.Load 외 2 | FP00594_RowExcelPopup.cs:330 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa64dbf9 | this.Load 외 2 | FP00594_RowExcelPopup.cs:335 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d0e2e8c | this.Load 외 2 | FP00594_RowExcelPopup.cs:336 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89b2b311 | this.Load 외 2 | FP00594_RowExcelPopup.cs:339 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-831b783e | this.Load 외 2 | FP00594_RowExcelPopup.cs:340 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-f3c20608 | this.Load 외 2 | FP00594_RowExcelPopup.cs:342 |  | DATA_OP | Filter["BUCKET_FROM"] | _BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-548679fc | this.Load 외 2 | FP00594_RowExcelPopup.cs:343 |  | DATA_OP | Filter["BUCKET_TO"] | _BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-44303713 | this.Load 외 2 | FP00594_RowExcelPopup.cs:348 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-6bba4991 | this.Load 외 2 | FP00594_RowExcelPopup.cs:350 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-5e0b4249 | this.Load 외 2 | FP00594_RowExcelPopup.cs:354 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-404ed730 | this.Load 외 2 | FP00594_RowExcelPopup.cs:358 | if (OnSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c0ea300 | this.Load 외 2 | FP00594_RowExcelPopup.cs:359 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-1d2270fb | this.Load 외 2 | FP00594_RowExcelPopup.cs:359 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0481f31a | this.Load 외 2 | FP00594_RowExcelPopup.cs:363 | if (OnSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-09376fa9 | this.Load 외 2 | FP00594_RowExcelPopup.cs:364 | if (OnSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3e5f0b49 | this.Load 외 2 | FP00594_RowExcelPopup.cs:366 | if (OnSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4532c465 | this.Load 외 2 | FP00594_RowExcelPopup.cs:367 | if (OnSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1bc597ef | this.Load 외 2 | FP00594_RowExcelPopup.cs:368 | if (OnSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7a6201f7 | this.Load 외 2 | FP00594_RowExcelPopup.cs:369 | if (OnSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3d4dee1c | this.Load 외 2 | FP00594_RowExcelPopup.cs:370 | if (OnSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d2c69cf9 | this.Load 외 2 | FP00594_RowExcelPopup.cs:371 | if (OnSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-15c10e9a | this.Load 외 2 | FP00594_RowExcelPopup.cs:372 | if (OnSearchData != null) | STATE | this.dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-22334533 | this.Load 외 2 | FP00594_RowExcelPopup.cs:378 | if (OnSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee479c68 | this.Load 외 2 | FP00594_RowExcelPopup.cs:381 | if (OnSearchData != null) ▸ try | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-144271b8 | this.Load 외 2 | FP00594_RowExcelPopup.cs:383 | if (OnSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c33d91e | this.Load 외 2 | FP00594_RowExcelPopup.cs:385 | if (OnSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar,set,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5996fa54 | this.Load 외 2 | FP00594_RowExcelPopup.cs:390 | if (OnSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-286e701c | this.Load 외 2 | FP00594_RowExcelPopup.cs:390 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, null, 1, IgnoreColumnsNotInTi… | 그리드 재구성/초기화 |  |  |  |
| AC-13bc3eb2 | this.Load 외 2 | FP00594_RowExcelPopup.cs:395 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-6a467240 | this.Load 외 2 | FP00594_RowExcelPopup.cs:396 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-d6a7214d | this.Load 외 2 | FP00594_RowExcelPopup.cs:397 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-ee17c139 | this.Load 외 2 | FP00594_RowExcelPopup.cs:402 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3250c831 | this.Load 외 2 | FP00594_RowExcelPopup.cs:403 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5096a515 | this.Load 외 2 | FP00594_RowExcelPopup.cs:408 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4206c396 | this.Load 외 2 | FP00594_RowExcelPopup.cs:409 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4bd86870 | this.Load 외 2 | FP00594_RowExcelPopup.cs:418 | if (OnSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f06988d3 | this.Load 외 2 | FP00594_RowExcelPopup.cs:421 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f15241cb | this.Load 외 2 | FP00594_RowExcelPopup.cs:422 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7a5bc313 | this.Load 외 2 | FP00594_RowExcelPopup.cs:423 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6729cc03 | this.Load 외 2 | FP00594_RowExcelPopup.cs:424 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9f6ed4a3 | this.Load 외 2 | FP00594_RowExcelPopup.cs:425 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-09b234d3 | this.Load 외 2 | FP00594_RowExcelPopup.cs:426 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f4434568 | this.Load 외 2 | FP00594_RowExcelPopup.cs:427 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00594_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f06fe0d | this.Load | FP00594_RowExcelPopup.cs:167 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-fdf09797 | this.Load | FP00594_RowExcelPopup.cs:169 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00594_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-315c75d3 | (진입점 미연결) | FP00594_RowExcelPopup.cs:672 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-81e6f872 | (진입점 미연결) | FP00594_RowExcelPopup.cs:673 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-28c5b9b5 | (진입점 미연결) | FP00594_RowExcelPopup.cs:674 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-486db7ae | (진입점 미연결) | FP00594_RowExcelPopup.cs:675 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-0f97827d | (진입점 미연결) | FP00594_RowExcelPopup.cs:676 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-2db455c0 | (진입점 미연결) | FP00594_RowExcelPopup.cs:677 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-e5de36c4 | (진입점 미연결) | FP00594_RowExcelPopup.cs:678 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-28ac704d | (진입점 미연결) | FP00594_RowExcelPopup.cs:680 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-c59f2edc | (진입점 미연결) | FP00594_RowExcelPopup.cs:681 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-eaa33cc7 | (진입점 미연결) | FP00594_RowExcelPopup.cs:685 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f912b81d | (진입점 미연결) | FP00594_RowExcelPopup.cs:686 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00594_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4b80db9 | this.Load | FP00594_RowExcelPopup.cs:202 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_FROM"].ToString()) < Convert.ToDecimal(thi… | DATA_OP | Filter["BUCKET_FROM"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d26361e5 | this.Load | FP00594_RowExcelPopup.cs:206 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-08a2687a | this.Load | FP00594_RowExcelPopup.cs:207 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | sEndDay | 행/컬럼 값 대입 |  |  |  |
| AC-2a976ca6 | this.Load | FP00594_RowExcelPopup.cs:210 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | Filter["BUCKET_FROM"] | 화면 필드/플래그 변경 |  |  |  |
| AC-2798f1c3 | this.Load | FP00594_RowExcelPopup.cs:211 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | Filter["BUCKET_TO"] | 화면 필드/플래그 변경 |  |  |  |
| AC-fa53725c | this.Load | FP00594_RowExcelPopup.cs:212 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | _BucketFromDate.ToString() + ":" + _BucketToDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-badf1771 | this.Load | FP00594_RowExcelPopup.cs:214 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-18bc2af9 | this.Load | FP00594_RowExcelPopup.cs:216 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-f00e8b4d | this.Load | FP00594_RowExcelPopup.cs:220 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-cbe331fd | this.Load | FP00594_RowExcelPopup.cs:222 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-fbbc885c | this.Load | FP00594_RowExcelPopup.cs:223 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-b14f7165 | this.Load | FP00594_RowExcelPopup.cs:224 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ce8b81bc | this.Load | FP00594_RowExcelPopup.cs:232 | for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d68b254 | this.Load | FP00594_RowExcelPopup.cs:235 |  | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-55d885eb | this.Load | FP00594_RowExcelPopup.cs:237 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |

## FP00594_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96190964 | this.Load | FP00594_RowExcelPopup.cs:260 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28a1116f | this.Load | FP00594_RowExcelPopup.cs:261 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00594_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b4fdb39 | (진입점 미연결) | FP00594_RowExcelPopup.cs:281 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00594_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45c78052 | this.btnUpload.Click | FP00594_RowExcelPopup.cs:706 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-c6ddbf51 | this.btnUpload.Click | FP00594_RowExcelPopup.cs:706 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3f7c139b | this.btnUpload.Click | FP00594_RowExcelPopup.cs:708 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-af19a0ad | this.btnUpload.Click | FP00594_RowExcelPopup.cs:709 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b2188ab9 | this.btnUpload.Click | FP00594_RowExcelPopup.cs:710 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-22aac7a8 | this.btnUpload.Click | FP00594_RowExcelPopup.cs:712 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1d62eba1 | this.btnUpload.Click | FP00594_RowExcelPopup.cs:714 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-506dd12a | this.btnUpload.Click | FP00594_RowExcelPopup.cs:715 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-f9265705 | this.btnUpload.Click | FP00594_RowExcelPopup.cs:715 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-155dfd55 | this.btnUpload.Click | FP00594_RowExcelPopup.cs:722 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fb3b09cc | this.btnUpload.Click | FP00594_RowExcelPopup.cs:723 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-bdd0851c | this.btnUpload.Click | FP00594_RowExcelPopup.cs:725 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00594_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90df8eda | this.btnSave.Click | FP00594_RowExcelPopup.cs:440 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-9411032d | this.btnSave.Click | FP00594_RowExcelPopup.cs:441 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e409eb2 | this.btnSave.Click | FP00594_RowExcelPopup.cs:445 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix! After once seach, Try agagin.!") | 메시지 표시 |  |  |  |
| AC-2c9cc84d | this.btnSave.Click | FP00594_RowExcelPopup.cs:446 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be656f47 | this.btnSave.Click | FP00594_RowExcelPopup.cs:457 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].Rows[i]["MESSAGE"].ToString().Equals("Y")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d149d404 | this.btnSave.Click | FP00594_RowExcelPopup.cs:458 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].Rows[i]["MESSAGE"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5efef794 | this.btnSave.Click | FP00594_RowExcelPopup.cs:462 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-473688c2 | this.btnSave.Click | FP00594_RowExcelPopup.cs:462 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-10c8f063 | this.btnSave.Click | FP00594_RowExcelPopup.cs:467 | if (OnBeforeCheckData != null) | CALL_BASE | OnBeforeCheckData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-00dc9a40 | this.btnSave.Click | FP00594_RowExcelPopup.cs:469 | if (OnBeforeCheckData != null) ▸ if (bCheck == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-892df61f | this.btnSave.Click | FP00594_RowExcelPopup.cs:478 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5cc202a8 | this.btnSave.Click | FP00594_RowExcelPopup.cs:479 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ab766308 | this.btnSave.Click | FP00594_RowExcelPopup.cs:480 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ad2246bf | this.btnSave.Click | FP00594_RowExcelPopup.cs:481 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1f10fea2 | this.btnSave.Click | FP00594_RowExcelPopup.cs:482 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-65af63c9 | this.btnSave.Click | FP00594_RowExcelPopup.cs:483 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-33a319ca | this.btnSave.Click | FP00594_RowExcelPopup.cs:491 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-e2d9217a | this.btnSave.Click | FP00594_RowExcelPopup.cs:492 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-86d09c91 | this.btnSave.Click | FP00594_RowExcelPopup.cs:493 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3a8c2556 | this.btnSave.Click | FP00594_RowExcelPopup.cs:494 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8320e41f | this.btnSave.Click | FP00594_RowExcelPopup.cs:495 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dfd6ecb6 | this.btnSave.Click | FP00594_RowExcelPopup.cs:496 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2405e489 | this.btnSave.Click | FP00594_RowExcelPopup.cs:497 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-00138ec0 | this.btnSave.Click | FP00594_RowExcelPopup.cs:498 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-258a3def | this.btnSave.Click | FP00594_RowExcelPopup.cs:503 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-19f10e90 | this.btnSave.Click | FP00594_RowExcelPopup.cs:506 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7dbee1f | this.btnSave.Click | FP00594_RowExcelPopup.cs:508 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-0143343a | this.btnSave.Click | FP00594_RowExcelPopup.cs:511 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-30d164b8 | this.btnSave.Click | FP00594_RowExcelPopup.cs:516 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-15662c6c | this.btnSave.Click | FP00594_RowExcelPopup.cs:517 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-a55a1232 | this.btnSave.Click | FP00594_RowExcelPopup.cs:527 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGrou… | DATA_OP | this.Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-a74e6854 | this.btnSave.Click | FP00594_RowExcelPopup.cs:529 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rd… | DATA_OP | this.Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-5332ec7b | this.btnSave.Click | FP00594_RowExcelPopup.cs:533 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-77ef0134 | this.btnSave.Click | FP00594_RowExcelPopup.cs:537 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f9096e59 | this.btnSave.Click | FP00594_RowExcelPopup.cs:572 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c04f3274 | this.btnSave.Click | FP00594_RowExcelPopup.cs:586 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e6ff795 | this.btnSave.Click | FP00594_RowExcelPopup.cs:589 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | FLAG | bUploadSaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c19c6578 | this.btnSave.Click | FP00594_RowExcelPopup.cs:590 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ae9dd3e0 | this.btnSave.Click | FP00594_RowExcelPopup.cs:595 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-2da5eaab | this.btnSave.Click | FP00594_RowExcelPopup.cs:596 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-27ecefdd | this.btnSave.Click | FP00594_RowExcelPopup.cs:602 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-dd7a0767 | this.btnSave.Click | FP00594_RowExcelPopup.cs:639 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-875ab3a1 | this.btnSave.Click | FP00594_RowExcelPopup.cs:641 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9d6e3139 | this.btnSave.Click | FP00594_RowExcelPopup.cs:642 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fe90b375 | this.btnSave.Click | FP00594_RowExcelPopup.cs:652 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2c566e8b | this.btnSave.Click | FP00594_RowExcelPopup.cs:653 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-df182437 | this.btnSave.Click | FP00594_RowExcelPopup.cs:657 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ca43aebd | this.btnSave.Click | FP00594_RowExcelPopup.cs:658 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d8f84882 | this.btnSave.Click | FP00594_RowExcelPopup.cs:659 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-68f5fd56 | this.btnSave.Click | FP00594_RowExcelPopup.cs:660 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b8edba3e | this.btnSave.Click | FP00594_RowExcelPopup.cs:661 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6f1d6126 | this.btnSave.Click | FP00594_RowExcelPopup.cs:662 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00594_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bad28286 | this.Load | FP00594_RowExcelPopup.cs:273 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d25956b3 | this.Load | FP00594_RowExcelPopup.cs:274 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

