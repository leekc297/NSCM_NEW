# AS-IS 액션 대조표 — FP00596

> 원천: `Doc/asisfacts/screens/FP00596/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2800행 · 메서드 272 · 종류 DATA_OP 1155 · FLAG 245 · RETURN 241 · UI_PROP 227 · UI_MISC 129 · VALUE_SET 110 · MESSAGE 97 · GRID_SET 96 · POPUP 80 · STATE 79 · COMBO_DATA 75 · CALL_EXT 73 · GRID_INIT 61 · ENDPOINT 39 · THROW 16 · CALL_BASE 15 · GRID_LOCK 14 · LIST_REBIND 12 · FOCUS 9 · GRID_STYLE 9 · GRID_BIND 6 · EXCEL 5 · LIST_CLEAR 3 · VALUE_CLEAR 2 · STATE_RESET 2 · ⚠ 의미 확인 필요 88


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b56bfe9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6412 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-590ebbe0 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6418 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-072b9a81 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6426 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-edae4edf | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6427 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-5cbea669 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6428 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-5d507f2b | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6429 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-fecb53c2 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6431 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-843a00f9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6432 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-34c99caf | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6433 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-31a4a4fa | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6434 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-ea724262 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6435 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ba3b9bc | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6436 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-4db1131c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6437 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b5f2ff2 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6438 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-d0d2ab06 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6441 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-147c2e61 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6626 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-379db54f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6627 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-e5871473 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6628 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-fa04d934 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6629 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-3881511c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6631 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-de08a61a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6632 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-1586cd69 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6633 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3ff15b6 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6634 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-f2bcb6ce | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6635 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-59dc584f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6636 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-79883c5a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6637 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-a668d0f2 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6638 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-37fcc68d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6640 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-551d871e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6545 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ec2fc28 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6546 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c23aa3b | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6547 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-46d20fb2 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6548 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-89e73bb9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6549 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c2a2ba9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6552 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-30609070 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6556 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1846cf72 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6557 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-00c3cfe3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6543 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-1f44de5f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6573 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-151ce8e5 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6576 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-8aa809d3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6579 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-9db12b85 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6582 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-996abe76 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6585 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-6994ae8e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6588 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-a93fad5b | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6594 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-613fe685 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6596 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26b719fc | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6517 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e04ef0f3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6481 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3c74d6e2 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6482 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-73962eef | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6483 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8630829e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6484 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-10e78937 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6485 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-78be5af0 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6486 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-10ff4170 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6488 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd5ef4ca | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6489 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c2c85b4 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6492 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-64281046 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6493 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb126f85 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6494 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5269c01e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6479 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-efb76626 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6502 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-f547237e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6503 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8bae8e6 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6508 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6605b255 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6454 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00596_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a983726 | .ctor | FP00596_BucketSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-ec68f12f | .ctor | FP00596_BucketSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-0b3a1fad | .ctor | FP00596_BucketSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-79f16f9a | .ctor | FP00596_BucketSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00596_BucketSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38062ce6 | this.btnOK.Click | FP00596_BucketSetForm_Popup.cs:193 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-c07f0625 | this.btnOK.Click | FP00596_BucketSetForm_Popup.cs:193 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-61565daa | this.btnOK.Click | FP00596_BucketSetForm_Popup.cs:195 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-1f1a1693 | this.btnOK.Click | FP00596_BucketSetForm_Popup.cs:199 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-b7de8eb3 | this.btnOK.Click | FP00596_BucketSetForm_Popup.cs:200 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-3396912d | this.btnOK.Click | FP00596_BucketSetForm_Popup.cs:201 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-55e5774d | this.btnOK.Click | FP00596_BucketSetForm_Popup.cs:202 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_BucketSetForm_Popup.btnSet_Click

진입점: this.btbSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b755a563 | this.btbSet.Click | FP00596_BucketSetForm_Popup.cs:216 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-421952c2 | this.btbSet.Click | FP00596_BucketSetForm_Popup.cs:216 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-a49233cc | this.btbSet.Click | FP00596_BucketSetForm_Popup.cs:218 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-20590da8 | this.btbSet.Click | FP00596_BucketSetForm_Popup.cs:222 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-579d2a2d | this.btbSet.Click | FP00596_BucketSetForm_Popup.cs:223 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-86824448 | this.btbSet.Click | FP00596_BucketSetForm_Popup.cs:225 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-260dfa79 | this.btbSet.Click | FP00596_BucketSetForm_Popup.cs:227 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-1aee2434 | this.btbSet.Click | FP00596_BucketSetForm_Popup.cs:229 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-2ee9fdde | this.btbSet.Click | FP00596_BucketSetForm_Popup.cs:230 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff10b5da | Dispose | FP00596_BucketSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00596_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6f9709e | this.Load | FP00596_BucketSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00596_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8edfd3f8 | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:143 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-98288c49 | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:149 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e4a67a1 | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:150 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-b54b7a71 | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:151 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-7497681c | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:153 |  | DATA_OP | ctrls.Add | (chk_kg) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa4774ab | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:154 |  | DATA_OP | ctrls.Add | (chk_batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-95813324 | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:155 |  | DATA_OP | ctrls.Add | (chk_seq) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8fe61c9 | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:157 |  | VALUE_SET | chk_week.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-ad993bc9 | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:159 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-316704ad | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:159 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-6aefc5bb | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:167 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-411a326c | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:171 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-48c1a89a | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:175 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00596_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf653dca | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-61df8cb5 | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-401d13c1 | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-233941ce | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:120 |  | VALUE_SET | chk_kg.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6e93075a | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:121 |  | VALUE_SET | chk_batch.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-af2c3ead | this.Load 외 1 | FP00596_BucketSetForm_Popup.cs:122 |  | VALUE_SET | chk_seq.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00596_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da14c47a | (진입점 미연결) | FP00596_BucketSetForm_Popup.cs:240 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-6390b32a | (진입점 미연결) | FP00596_BucketSetForm_Popup.cs:251 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50331ba9 | (진입점 미연결) | FP00596_BucketSetForm_Popup.cs:262 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00596_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54ded4a8 | this.Load | FP00596_BucketSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-622667ee | this.Load | FP00596_BucketSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00596_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-722b3787 | .ctor | FP00596_ExcelPopup.cs:163 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-073963e3 | .ctor | FP00596_ExcelPopup.cs:166 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-4c8fd7ea | .ctor | FP00596_ExcelPopup.cs:167 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b78394f2 | .ctor | FP00596_ExcelPopup.cs:169 |  | FLAG | HeaderLineCount | 3 | 화면 필드/플래그 변경 |  |  |  |
| AC-a7737421 | .ctor | FP00596_ExcelPopup.cs:170 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |

## FP00596_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25c84488 | this.btnClose.Click | FP00596_ExcelPopup.cs:1304 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-335159ab | this.btnDownload.Click | FP00596_ExcelPopup.cs:1261 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-0cfa6727 | this.btnDownload.Click | FP00596_ExcelPopup.cs:1262 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00596_ExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f31574d | this.btnUpload.Click | FP00596_ExcelPopup.cs:1283 | if (bUpload) ▸ for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("Batch") != -1 && sHeadName.Length == 5) | GRID_SET | siMain.ActiveSheet.Cells[0, idx, siMain.GetMaxRowIndex(), idx].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-3bc070c5 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1287 | if (bUpload) ▸ for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("Seq") != -1 && sHeadName.Length == 3) | GRID_SET | siMain.ActiveSheet.Cells[0, idx, siMain.GetMaxRowIndex(), idx].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-23601c5c | this.btnUpload.Click | FP00596_ExcelPopup.cs:1291 | if (bUpload) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-42f86526 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1292 | if (bUpload) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |

## FP00596_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-823e91e4 | this.Load | FP00596_ExcelPopup.cs:263 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f1275557 | this.Load | FP00596_ExcelPopup.cs:264 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-18542132 | this.Load | FP00596_ExcelPopup.cs:265 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00596_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cb0037c | (진입점 미연결) | FP00596_ExcelPopup.cs:1243 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve, StartDateColumnI… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ebf51bd | (진입점 미연결) | FP00596_ExcelPopup.cs:1243 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00596_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00c79e11 | this.Load | FP00596_ExcelPopup.cs:258 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00596_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c775199 | Dispose | FP00596_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00596_ExcelPopup.dtpPeriod_ValueChanged

진입점: this.dtpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4945cdf | this.dtpPeriod.ValueChanged | FP00596_ExcelPopup.cs:1320 | if (bFirst == true) | FLAG | bFirst | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ddfc0815 | this.dtpPeriod.ValueChanged | FP00596_ExcelPopup.cs:1321 | if (bFirst == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67a877d7 | this.dtpPeriod.ValueChanged | FP00596_ExcelPopup.cs:1336 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a450e11b | this.dtpPeriod.ValueChanged | FP00596_ExcelPopup.cs:1339 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | VALUE_SET | dtpPeriod.InitValue | sStartDate + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d66c44ef | this.dtpPeriod.ValueChanged | FP00596_ExcelPopup.cs:1340 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6fb8d61c | this.dtpPeriod.ValueChanged | FP00596_ExcelPopup.cs:1345 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b39613e | this.dtpPeriod.ValueChanged | FP00596_ExcelPopup.cs:1353 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b4124420 | this.dtpPeriod.ValueChanged | FP00596_ExcelPopup.cs:1355 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9454a9e0 | this.dtpPeriod.ValueChanged | FP00596_ExcelPopup.cs:1358 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-b5939efb | this.dtpPeriod.ValueChanged | FP00596_ExcelPopup.cs:1359 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |

## FP00596_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55861a10 | (진입점 미연결) | FP00596_ExcelPopup.cs:1231 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00596_ExcelPopup.Find_Data

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0dc1f5a0 | this.Load 외 2 | FP00596_ExcelPopup.cs:337 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ba561b30 | this.Load 외 2 | FP00596_ExcelPopup.cs:343 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f9f59b34 | this.Load 외 2 | FP00596_ExcelPopup.cs:345 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1226685 | this.Load 외 2 | FP00596_ExcelPopup.cs:350 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d195b678 | this.Load 외 2 | FP00596_ExcelPopup.cs:351 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b568582 | this.Load 외 2 | FP00596_ExcelPopup.cs:353 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-dc1d0571 | this.Load 외 2 | FP00596_ExcelPopup.cs:354 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-864e0dc4 | this.Load 외 2 | FP00596_ExcelPopup.cs:356 |  | DATA_OP | Filter["BUCKET_FROM"] | _BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-0c0ae8b3 | this.Load 외 2 | FP00596_ExcelPopup.cs:357 |  | DATA_OP | Filter["BUCKET_TO"] | _BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-11ada8ef | this.Load 외 2 | FP00596_ExcelPopup.cs:362 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-f513e8a4 | this.Load 외 2 | FP00596_ExcelPopup.cs:364 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-cd7dd153 | this.Load 외 2 | FP00596_ExcelPopup.cs:368 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ce343350 | this.Load 외 2 | FP00596_ExcelPopup.cs:373 | if (OnSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49fd5b88 | this.Load 외 2 | FP00596_ExcelPopup.cs:374 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-d008cba3 | this.Load 외 2 | FP00596_ExcelPopup.cs:374 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-155a62bc | this.Load 외 2 | FP00596_ExcelPopup.cs:379 | if (OnSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-38774776 | this.Load 외 2 | FP00596_ExcelPopup.cs:380 | if (OnSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3bbb8a74 | this.Load 외 2 | FP00596_ExcelPopup.cs:382 | if (OnSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c22250bb | this.Load 외 2 | FP00596_ExcelPopup.cs:383 | if (OnSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1cbbb786 | this.Load 외 2 | FP00596_ExcelPopup.cs:384 | if (OnSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-536b2bfb | this.Load 외 2 | FP00596_ExcelPopup.cs:385 | if (OnSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-905f6b0c | this.Load 외 2 | FP00596_ExcelPopup.cs:386 | if (OnSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7ec9f83c | this.Load 외 2 | FP00596_ExcelPopup.cs:387 | if (OnSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-28f08b53 | this.Load 외 2 | FP00596_ExcelPopup.cs:388 | if (OnSearchData != null) | STATE | this.dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ccf6bd55 | this.Load 외 2 | FP00596_ExcelPopup.cs:394 | if (OnSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4428338 | this.Load 외 2 | FP00596_ExcelPopup.cs:398 | if (OnSearchData != null) ▸ try | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bae7d61a | this.Load 외 2 | FP00596_ExcelPopup.cs:400 | if (OnSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3056e458 | this.Load 외 2 | FP00596_ExcelPopup.cs:402 | if (OnSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { if (Calendar == null) { Calendar = new AmendCalendar(); DataTabl… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f20a46a0 | this.Load 외 2 | FP00596_ExcelPopup.cs:406 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-5075a46d | this.Load 외 2 | FP00596_ExcelPopup.cs:407 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d4d8352c | this.Load 외 2 | FP00596_ExcelPopup.cs:409 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-97645960 | this.Load 외 2 | FP00596_ExcelPopup.cs:411 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d0560e9f | this.Load 외 2 | FP00596_ExcelPopup.cs:415 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-3365a6b6 | this.Load 외 2 | FP00596_ExcelPopup.cs:416 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-b978f819 | this.Load 외 2 | FP00596_ExcelPopup.cs:417 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-b5b524a0 | this.Load 외 2 | FP00596_ExcelPopup.cs:424 | if (OnSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | SetAmendHeaderColumn_FP_Local(Calendar, 3) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a2e5e36 | this.Load 외 2 | FP00596_ExcelPopup.cs:428 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d679ac1c | this.Load 외 2 | FP00596_ExcelPopup.cs:429 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f5658ca | this.Load 외 2 | FP00596_ExcelPopup.cs:430 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.ColumnHeaderHeight | (2, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b286acf | this.Load 외 2 | FP00596_ExcelPopup.cs:443 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf65564d | this.Load 외 2 | FP00596_ExcelPopup.cs:444 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6420bdbd | this.Load 외 2 | FP00596_ExcelPopup.cs:447 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f5b2e2bb | this.Load 외 2 | FP00596_ExcelPopup.cs:467 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a15210dc | this.Load 외 2 | FP00596_ExcelPopup.cs:471 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-dd991919 | this.Load 외 2 | FP00596_ExcelPopup.cs:476 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-de2f3a20 | this.Load 외 2 | FP00596_ExcelPopup.cs:477 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.Cells[0, index, siMain.GetMaxRowIndex(), index].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-79899576 | this.Load 외 2 | FP00596_ExcelPopup.cs:483 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-1928b4e9 | this.Load 외 2 | FP00596_ExcelPopup.cs:484 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.Cells[0, index, siMain.GetMaxRowIndex(), index].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-2b2f80c7 | this.Load 외 2 | FP00596_ExcelPopup.cs:487 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-90ed4943 | this.Load 외 2 | FP00596_ExcelPopup.cs:491 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-9ca1c28b | this.Load 외 2 | FP00596_ExcelPopup.cs:496 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-2294cecc | this.Load 외 2 | FP00596_ExcelPopup.cs:497 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.Cells[0, index, siMain.GetMaxRowIndex(), index].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-b9f15be2 | this.Load 외 2 | FP00596_ExcelPopup.cs:503 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-f8dc2079 | this.Load 외 2 | FP00596_ExcelPopup.cs:504 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.Cells[0, index, siMain.GetMaxRowIndex(), index].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-5da97738 | this.Load 외 2 | FP00596_ExcelPopup.cs:513 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.Cells[0, index, siMain.GetMaxRowIndex(), index].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-e3720d27 | this.Load 외 2 | FP00596_ExcelPopup.cs:519 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.Cells[0, index, siMain.GetMaxRowIndex(), index].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-fea7ad7e | this.Load 외 2 | FP00596_ExcelPopup.cs:527 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-54ec0278 | this.Load 외 2 | FP00596_ExcelPopup.cs:536 | if (OnSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfd56571 | this.Load 외 2 | FP00596_ExcelPopup.cs:539 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-56990c8b | this.Load 외 2 | FP00596_ExcelPopup.cs:540 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-38d4a32a | this.Load 외 2 | FP00596_ExcelPopup.cs:541 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c4340533 | this.Load 외 2 | FP00596_ExcelPopup.cs:542 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-07b4afba | this.Load 외 2 | FP00596_ExcelPopup.cs:543 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-83f59aaf | this.Load 외 2 | FP00596_ExcelPopup.cs:544 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0c775ac0 | this.Load 외 2 | FP00596_ExcelPopup.cs:545 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00596_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5bcac1d | FindButton | FP00596_ExcelPopup.cs:305 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cc562190 | FindButton | FP00596_ExcelPopup.cs:306 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ca82a1d4 | FindButton | FP00596_ExcelPopup.cs:308 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cab750b | this.Load | FP00596_ExcelPopup.cs:179 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f8010697 | this.Load | FP00596_ExcelPopup.cs:181 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_ExcelPopup.GetDayColNameOfType_Local

진입점: this.Load [if (OnSearchData != null) ▸ try ▸ lambda ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Length)] / this.btnFind.Click [if (OnSearchData != null) ▸ try ▸ lambda ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Length)] / FindButton [if (OnSearchData != null) ▸ try ▸ lambda ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppend…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f922793 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda ▸ foreac… 외 2 | FP00596_ExcelPopup.cs:691 |  | RETURN | return day.Value + date_append_name; |  | 처리 중단/반환 |  |  |  |

## FP00596_ExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92cd4c7f | (진입점 미연결) | FP00596_ExcelPopup.cs:947 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-92400c41 | (진입점 미연결) | FP00596_ExcelPopup.cs:948 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-36696694 | (진입점 미연결) | FP00596_ExcelPopup.cs:949 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-d8d9fb47 | (진입점 미연결) | FP00596_ExcelPopup.cs:950 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-5042a27c | (진입점 미연결) | FP00596_ExcelPopup.cs:951 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-fd0cbcbf | (진입점 미연결) | FP00596_ExcelPopup.cs:952 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-404ad544 | (진입점 미연결) | FP00596_ExcelPopup.cs:953 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ae8e2216 | (진입점 미연결) | FP00596_ExcelPopup.cs:955 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-a4cbd387 | (진입점 미연결) | FP00596_ExcelPopup.cs:956 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-26e6b9c7 | (진입점 미연결) | FP00596_ExcelPopup.cs:960 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d3e5a1a8 | (진입점 미연결) | FP00596_ExcelPopup.cs:961 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00596_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93142b92 | this.Load | FP00596_ExcelPopup.cs:216 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_FROM"].ToString()) < Convert.ToDecimal(thi… | DATA_OP | Filter["BUCKET_FROM"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d82d99c7 | this.Load | FP00596_ExcelPopup.cs:221 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | sEndDay | 행/컬럼 값 대입 |  |  |  |
| AC-23f0a035 | this.Load | FP00596_ExcelPopup.cs:224 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | Filter["BUCKET_FROM"] | 화면 필드/플래그 변경 |  |  |  |
| AC-d0b744c3 | this.Load | FP00596_ExcelPopup.cs:225 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | Filter["BUCKET_TO"] | 화면 필드/플래그 변경 |  |  |  |
| AC-9b80e6a0 | this.Load | FP00596_ExcelPopup.cs:227 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | _BucketFromDate.ToString() + ":" + _BucketToDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-37eb60af | this.Load | FP00596_ExcelPopup.cs:229 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8eb89b67 | this.Load | FP00596_ExcelPopup.cs:231 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-12c69bf0 | this.Load | FP00596_ExcelPopup.cs:235 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-73706bdf | this.Load | FP00596_ExcelPopup.cs:237 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-c179ec59 | this.Load | FP00596_ExcelPopup.cs:238 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-1b4cc51e | this.Load | FP00596_ExcelPopup.cs:239 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ab0c928c | this.Load | FP00596_ExcelPopup.cs:247 | for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-2019ac53 | this.Load | FP00596_ExcelPopup.cs:250 |  | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-32b86fad | this.Load | FP00596_ExcelPopup.cs:252 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |

## FP00596_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8006ce5e | this.Load | FP00596_ExcelPopup.cs:275 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79a19513 | this.Load | FP00596_ExcelPopup.cs:276 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00596_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e98192c | (진입점 미연결) | FP00596_ExcelPopup.cs:296 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00596_ExcelPopup.lfn_setExchangeBatch_Excel

진입점: this.btnUpload.Click [try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) ▸ for (iRow < dtData.Rows.Count) ▸ for (iCol < nEnd) ▸ if (bIsKGCol && !string.IsNullOrEmpty(dtData.Rows[iRow][iCol + cnt].ToString()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf3539fb | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1156 | lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b10ce86 | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1170 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-c0169824 | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1177 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-84ba2c81 | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1178 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fad01b40 | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1179 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bfaaefce | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1180 | lambda | DATA_OP | each_row.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-acfc11ae | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1197 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6bd1ddc0 | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1198 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-44e3f9ae | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1199 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b332e7eb | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1200 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5cb06e08 | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1201 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c073ec7 | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1202 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9dbdec48 | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1202 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-05bc9094 | this.btnUpload.Click [try ▸ if (dtData != null && !hasError)… | FP00596_ExcelPopup.cs:1220 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00596_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99eb700d | this.btnUpload.Click | FP00596_ExcelPopup.cs:998 | try | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-daa99182 | this.btnUpload.Click | FP00596_ExcelPopup.cs:998 | try | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dabb6e60 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1000 | try | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-786ae020 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1001 | try | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d6a9fa3a | this.btnUpload.Click | FP00596_ExcelPopup.cs:1002 | try | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ee7432f | this.btnUpload.Click | FP00596_ExcelPopup.cs:1004 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6ea4bf42 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1006 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0ec72c3c | this.btnUpload.Click | FP00596_ExcelPopup.cs:1008 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile_Third | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-226587a7 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1016 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | res.Item2 | 화면 필드/플래그 변경 |  |  |  |
| AC-f252143b | this.btnUpload.Click | FP00596_ExcelPopup.cs:1017 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1e52cabf | this.btnUpload.Click | FP00596_ExcelPopup.cs:1018 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-a681ed2f | this.btnUpload.Click | FP00596_ExcelPopup.cs:1019 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-62ceab4c | this.btnUpload.Click | FP00596_ExcelPopup.cs:1022 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e02bb89a | this.btnUpload.Click | FP00596_ExcelPopup.cs:1023 | try | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-e147f290 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1035 | try ▸ if (dtData != null && !hasError) | DATA_OP | dtData.Columns.Contains | ("APPLIED_MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-594bd5e3 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1038 | try ▸ if (dtData != null && !hasError) ▸ if (!dtData.Columns.Contains("APPLIED_MODEL")) | DATA_OP | dtData.Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-11fcb2cc | this.btnUpload.Click | FP00596_ExcelPopup.cs:1046 | try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) ▸ foreach (DataRow row in dtData.Rows) ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-41cd91a3 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1047 | try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) ▸ foreach (DataRow row in dtData.Rows) ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-df8c325a | this.btnUpload.Click | FP00596_ExcelPopup.cs:1048 | try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) ▸ foreach (DataRow row in dtData.Rows) ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-972e761f | this.btnUpload.Click | FP00596_ExcelPopup.cs:1052 | try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) ▸ foreach (DataRow row in dtData.Rows) ▸ if (UomResult.Count() > 0) | DATA_OP | row["APPLIED_MODEL"] | UomResult.First()["VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c56bc66a | this.btnUpload.Click | FP00596_ExcelPopup.cs:1056 | try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) ▸ foreach (DataRow row in dtData.Rows) ▸ else of (UomResult.Count() > 0) | DATA_OP | row["APPLIED_MODEL"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f6c1c0b9 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1080 | try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) ▸ if (nStart == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7781effc | this.btnUpload.Click | FP00596_ExcelPopup.cs:1104 | try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) ▸ for (iRow < dtData.Rows.Count) ▸ for (iCol < nEnd) ▸ if (bIsKGCol && !… | GRID_SET | dtData.Rows[iRow][sColName] | "" | 그리드 속성/값 설정 |  |  |  |
| AC-1231c09b | this.btnUpload.Click | FP00596_ExcelPopup.cs:1108 | try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) ▸ for (iRow < dtData.Rows.Count) ▸ for (iCol < nEnd) ▸ if (bIsKGCol && !… | GRID_SET | dtData.Rows[iRow][sColName] | rVal.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-1c9662f5 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1117 | try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) | GRID_BIND | siMain.Query | (dtData, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a8a20d40 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1118 | try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f967702a | this.btnUpload.Click | FP00596_ExcelPopup.cs:1119 | try ▸ if (dtData != null && !hasError) ▸ if (dtData.Rows.Count > 0) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-28b8a47e | this.btnUpload.Click | FP00596_ExcelPopup.cs:1128 | try ▸ if (dtData != null && !hasError) | RETURN | return rtnValue; |  | 처리 중단/반환 |  |  |  |
| AC-f1c59fe2 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1132 | try ▸ else of (dtData != null && !hasError) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6f3f76e4 | this.btnUpload.Click | FP00596_ExcelPopup.cs:1138 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00596_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28921407 | this.btnSave.Click | FP00596_ExcelPopup.cs:700 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-a1ea4a79 | this.btnSave.Click | FP00596_ExcelPopup.cs:701 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7949827 | this.btnSave.Click | FP00596_ExcelPopup.cs:705 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix! After once seach, Try agagin.!") | 메시지 표시 |  |  |  |
| AC-b71ba0d8 | this.btnSave.Click | FP00596_ExcelPopup.cs:706 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44a392bd | this.btnSave.Click | FP00596_ExcelPopup.cs:717 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (!String.IsNullOrEmpty(dsMain.Tables[0].Rows[i]["MESSAGE"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a517f47 | this.btnSave.Click | FP00596_ExcelPopup.cs:718 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (!String.IsNullOrEmpty(dsMain.Tables[0].Rows[i]["MESSAGE"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50e92047 | this.btnSave.Click | FP00596_ExcelPopup.cs:722 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-ee1815ba | this.btnSave.Click | FP00596_ExcelPopup.cs:722 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-57159d9c | this.btnSave.Click | FP00596_ExcelPopup.cs:728 | if (OnBeforeCheckData != null) | CALL_BASE | OnBeforeCheckData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8fb8310 | this.btnSave.Click | FP00596_ExcelPopup.cs:730 | if (OnBeforeCheckData != null) ▸ if (bCheck == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d15d1c1 | this.btnSave.Click | FP00596_ExcelPopup.cs:741 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bd8843ea | this.btnSave.Click | FP00596_ExcelPopup.cs:742 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4b13a261 | this.btnSave.Click | FP00596_ExcelPopup.cs:743 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e8718f25 | this.btnSave.Click | FP00596_ExcelPopup.cs:744 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5827f280 | this.btnSave.Click | FP00596_ExcelPopup.cs:745 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9a2d6b71 | this.btnSave.Click | FP00596_ExcelPopup.cs:746 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-daa36b9a | this.btnSave.Click | FP00596_ExcelPopup.cs:754 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-04b563de | this.btnSave.Click | FP00596_ExcelPopup.cs:755 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9d0b51bb | this.btnSave.Click | FP00596_ExcelPopup.cs:756 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8bb154b8 | this.btnSave.Click | FP00596_ExcelPopup.cs:757 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7bd8a9b8 | this.btnSave.Click | FP00596_ExcelPopup.cs:758 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8b6dcb4f | this.btnSave.Click | FP00596_ExcelPopup.cs:759 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b3252820 | this.btnSave.Click | FP00596_ExcelPopup.cs:760 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2214e318 | this.btnSave.Click | FP00596_ExcelPopup.cs:761 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c33150e1 | this.btnSave.Click | FP00596_ExcelPopup.cs:767 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e278d8b | this.btnSave.Click | FP00596_ExcelPopup.cs:770 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe9cff26 | this.btnSave.Click | FP00596_ExcelPopup.cs:772 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-74ae7cf9 | this.btnSave.Click | FP00596_ExcelPopup.cs:775 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-f121c1d8 | this.btnSave.Click | FP00596_ExcelPopup.cs:780 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-10170f1c | this.btnSave.Click | FP00596_ExcelPopup.cs:781 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-d5ba75aa | this.btnSave.Click | FP00596_ExcelPopup.cs:792 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGrou… | DATA_OP | this.Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-980b8939 | this.btnSave.Click | FP00596_ExcelPopup.cs:794 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rd… | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-5fae9e59 | this.btnSave.Click | FP00596_ExcelPopup.cs:798 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3df5cdae | this.btnSave.Click | FP00596_ExcelPopup.cs:803 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04f449f4 | this.btnSave.Click | FP00596_ExcelPopup.cs:826 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-4113ade5 | this.btnSave.Click | FP00596_ExcelPopup.cs:829 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | POPUP | new Planning.UIL.FP00594_InValidationExcelPopup | ("InvalidExcelPopup", dsValidation, "") | 팝업/폼 생성 |  |  |  |
| AC-0e92bd1e | this.btnSave.Click | FP00596_ExcelPopup.cs:830 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1c83e743 | this.btnSave.Click | FP00596_ExcelPopup.cs:831 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-59a12be2 | this.btnSave.Click | FP00596_ExcelPopup.cs:848 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3b43652 | this.btnSave.Click | FP00596_ExcelPopup.cs:860 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e590a579 | this.btnSave.Click | FP00596_ExcelPopup.cs:864 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | FLAG | bUploadSaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1144c287 | this.btnSave.Click | FP00596_ExcelPopup.cs:865 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-bd7f84b2 | this.btnSave.Click | FP00596_ExcelPopup.cs:870 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-5d4c292b | this.btnSave.Click | FP00596_ExcelPopup.cs:871 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-32f4107b | this.btnSave.Click | FP00596_ExcelPopup.cs:877 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-59a2b4d2 | this.btnSave.Click | FP00596_ExcelPopup.cs:914 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["MESSAGE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7e43e186 | this.btnSave.Click | FP00596_ExcelPopup.cs:916 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-81c533c4 | this.btnSave.Click | FP00596_ExcelPopup.cs:917 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e2c38004 | this.btnSave.Click | FP00596_ExcelPopup.cs:927 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6521675d | this.btnSave.Click | FP00596_ExcelPopup.cs:928 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-5ed798a4 | this.btnSave.Click | FP00596_ExcelPopup.cs:932 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-183a480c | this.btnSave.Click | FP00596_ExcelPopup.cs:933 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ab8a47ce | this.btnSave.Click | FP00596_ExcelPopup.cs:934 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-984fe4b3 | this.btnSave.Click | FP00596_ExcelPopup.cs:935 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dba3a6ca | this.btnSave.Click | FP00596_ExcelPopup.cs:936 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-20ea9b5c | this.btnSave.Click | FP00596_ExcelPopup.cs:937 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00596_ExcelPopup.SearchListInfoAll

진입점: this.btnUpload.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b36728b7 | this.btnUpload.Click [try] | FP00596_ExcelPopup.cs:971 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ec364874 | this.btnUpload.Click [try] | FP00596_ExcelPopup.cs:972 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-d11cf2f6 | this.btnUpload.Click [try] | FP00596_ExcelPopup.cs:975 |  | FLAG | dtDimension | siMain.GetSpdTitle(sProgramID, sUserID, sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9c06d67 | this.btnUpload.Click [try] | FP00596_ExcelPopup.cs:975 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c48265eb | this.btnUpload.Click [try] | FP00596_ExcelPopup.cs:978 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_UOMInfo_ALL") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-38119f52 | this.btnUpload.Click [try] | FP00596_ExcelPopup.cs:979 |  | FLAG | dsUomInfoAll | dtUomAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-bbcc26e2 | this.btnUpload.Click [try] | FP00596_ExcelPopup.cs:979 |  | DATA_OP | dtUomAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-18d71f10 | this.btnUpload.Click [try] | FP00596_ExcelPopup.cs:981 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_YieldInfo_Child", Filter["INSTANCE_ID"].ToString(), Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9265ebdf | this.btnUpload.Click [try] | FP00596_ExcelPopup.cs:982 |  | FLAG | dsYieldInfoAll | dtYieldAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-682942f7 | this.btnUpload.Click [try] | FP00596_ExcelPopup.cs:982 |  | DATA_OP | dtYieldAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP00596_ExcelPopup.SetAmendHeaderColumn_FP_Local

진입점: this.Load [if (OnSearchData != null) ▸ try ▸ lambda] / this.btnFind.Click [if (OnSearchData != null) ▸ try ▸ lambda] / FindButton [if (OnSearchData != null) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80a61421 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:602 |  | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-02f1923a | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:608 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-45f1bb37 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:612 | if (!dtSheetColumnConfig.Good()) | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-46048575 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:613 | if (!dtSheetColumnConfig.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ebf3e22e | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:630 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Len… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6039e0a6 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:631 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Len… | CALL_EXT | MenuService.SetMenuColumn | (dateRowDay, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = _s… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3420097 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:642 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Len… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowDay) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8630df2 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:643 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Len… | FLAG | added_columns_count | added_columns_count++ | 화면 필드 증감 |  |  |  |
| AC-38f37f14 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:651 |  | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fa1875ed | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:652 |  | CALL_EXT | MenuService.SetMenuColumn | (dateRowMessage, new MenuOption { program = sProgramID, sheet = sSheetName, cell_object = … | ⚠ 의미 확인 필요 |  |  |  |
| AC-df9a45e9 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:663 |  | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowMessage) | 데이터 객체 조작/조회 |  |  |  |
| AC-416043d7 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:664 |  | FLAG | added_columns_count | added_columns_count++ | 화면 필드 증감 |  |  |  |
| AC-898d906a | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:668 | if (dtSheetColumnConfig.Rows.Count == 0) | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b0808efc | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:669 | if (dtSheetColumnConfig.Rows.Count == 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ef01c76a | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:672 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, iColumnHeaderRowCount, dtSheetColumnConfig) | 그리드 재구성/초기화 |  |  |  |
| AC-5925391d | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:677 | foreach (DataRow row in dtSheetColumnConfig.Rows) | DATA_OP | DictColumn.ContainsKey | (row["COLUMN_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-01fd4a94 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:678 | foreach (DataRow row in dtSheetColumnConfig.Rows) ▸ if (!DictColumn.ContainsKey(row["COLUMN_NAME"].ToString())) | DATA_OP | DictColumn.Add | (row["COLUMN_NAME"].ToString(), row["COLUMN_LABEL_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b598bef3 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:682 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2365e55a | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:683 |  | RETURN | return DictColumn; |  | 처리 중단/반환 |  |  |  |

## FP00596_ExcelPopup.SetSheetHeadColor

진입점: this.Load [if (OnSearchData != null) ▸ try ▸ lambda] / this.btnFind.Click [if (OnSearchData != null) ▸ try ▸ lambda] / FindButton [if (OnSearchData != null) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-295c1dcc | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:564 | try ▸ for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*") >= 0) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, idx].ForeColor | System.Drawing.Color.FromArgb(0, 113, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-5e7d8595 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP00596_ExcelPopup.cs:572 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00596_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e31fb0b4 | this.Load | FP00596_ExcelPopup.cs:288 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-03cc9b50 | this.Load | FP00596_ExcelPopup.cs:289 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00596_ExcelPopup.SetValidationResultSheetColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1930bf01 | (진입점 미연결) | FP00596_ExcelPopup.cs:591 | try ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValid.Equals("N")) | GRID_SET | siMain.ActiveSheet.Cells[i, 0, i, siMain.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-04fe3765 | (진입점 미연결) | FP00596_ExcelPopup.cs:596 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-0d989cc8 | (진입점 미연결) | FP00596_ExcelPopup.cs:598 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00596_InValidationPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1046d0f | .ctor | FP00596_InValidationPopup.cs:106 |  | UI_PROP | SpdSheet.shtMain | sSheetName | 속성 shtMain 설정 |  |  |  |
| AC-d564cf94 | .ctor | FP00596_InValidationPopup.cs:107 |  | FLAG | _dsSheet | dsSheet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-368dfee3 | .ctor | FP00596_InValidationPopup.cs:107 |  | DATA_OP | dsSheet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-060aadbb | .ctor | FP00596_InValidationPopup.cs:108 |  | FLAG | _sMessage | sMessage | 화면 필드/플래그 변경 |  |  |  |

## FP00596_InValidationPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43977ada | this.btnClose.Click | FP00596_InValidationPopup.cs:213 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_InValidationPopup.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef90858d | this.btnExport.Click | FP00596_InValidationPopup.cs:268 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-ab2082be | this.btnExport.Click | FP00596_InValidationPopup.cs:269 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00596_InValidationPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b26eb101 | this.Load | FP00596_InValidationPopup.cs:162 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-db0d2b18 | this.Load | FP00596_InValidationPopup.cs:163 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a6308a57 | this.Load | FP00596_InValidationPopup.cs:164 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00596_InValidationPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd92a4f7 | this.Load | FP00596_InValidationPopup.cs:156 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00596_InValidationPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7920beee | Dispose | FP00596_InValidationPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00596_InValidationPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f98dfea9 | ExcelButton | FP00596_InValidationPopup.cs:222 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00596_InValidationPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9df5dbf | this.Load | FP00596_InValidationPopup.cs:118 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3c1687ec | this.Load | FP00596_InValidationPopup.cs:120 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6dc2f60c | this.Load | FP00596_InValidationPopup.cs:134 | if (!string.IsNullOrEmpty(_sMessage)) | MESSAGE | MessageBox.Show | (_sMessage, "Validation", MessageBoxButtons.OK, MessageBoxIcon.Information) | 메시지 표시 |  |  |  |

## FP00596_InValidationPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be66f3c4 | this.Load | FP00596_InValidationPopup.cs:148 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-3227e1d8 | this.Load | FP00596_InValidationPopup.cs:150 |  | VALUE_SET | lblTitle.Text | " InValidation Results" | 컨트롤 값 설정 |  |  |  |

## FP00596_InValidationPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d83eddea | this.Load | FP00596_InValidationPopup.cs:176 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5952e355 | this.Load | FP00596_InValidationPopup.cs:177 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00596_InValidationPopup.SetGrid_Data

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ff6b50d | this.Load | FP00596_InValidationPopup.cs:231 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e3673a70 | this.Load | FP00596_InValidationPopup.cs:235 | try | GRID_BIND | siMain.Query | (_dsSheet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-774ab352 | this.Load | FP00596_InValidationPopup.cs:244 | try ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i < siMain.GetMaxRowIndex()) ▸ if (sValid.Equals("Y")) | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-062493ce | this.Load | FP00596_InValidationPopup.cs:247 | try ▸ if (siMain.GetMaxRowIndex() > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb7ceadb | this.Load | FP00596_InValidationPopup.cs:252 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00596_InValidationPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bec4a24b | this.Load [try] | FP00596_InValidationPopup.cs:188 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4ec33ad | this.Load [try] | FP00596_InValidationPopup.cs:189 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-d972128e | this.Load [try] | FP00596_InValidationPopup.cs:193 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-bd875587 | this.Load [try] | FP00596_InValidationPopup.cs:194 |  | GRID_INIT | siMain.Freeze | (0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bdff97d9 | this.Load [try] | FP00596_InValidationPopup.cs:196 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INSTANCE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-832b0098 | this.Load [try] | FP00596_InValidationPopup.cs:197 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FP_PLAN_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f45a18db | this.Load [try] | FP00596_InValidationPopup.cs:198 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00596_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9102d543 | this.btnButtonList.UsrButtonList_Click_Detected | FP00596_ItemPopup.cs:254 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-c781b839 | this.btnButtonList.UsrButtonList_Click_Detected | FP00596_ItemPopup.cs:257 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d9244a22 | this.btnButtonList.UsrButtonList_Click_Detected | FP00596_ItemPopup.cs:258 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18771e94 | this.Load | FP00596_ItemPopup.cs:131 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2adbaae8 | this.Load | FP00596_ItemPopup.cs:132 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4a6d07d9 | this.Load | FP00596_ItemPopup.cs:133 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00596_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a13514b | this.Load | FP00596_ItemPopup.cs:126 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00596_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33ec5754 | Dispose | FP00596_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00596_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f0cd115 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_ItemPopup.cs:202 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ef15d8a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_ItemPopup.cs:205 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-55a816a7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_ItemPopup.cs:206 |  | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-aee40fd4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_ItemPopup.cs:210 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => Data_FP.CallGeneralProcedure("PR_UI_FP00596_ITEM", Filter, UserInfoContext.Current.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-931da1a7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_ItemPopup.cs:211 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00596_ITEM", Filter, UserInfoContext.Current.UserId, "SELECT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0f88bc3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_ItemPopup.cs:217 | if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cdcfb70c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_ItemPopup.cs:220 | if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eacfa1aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_ItemPopup.cs:222 | if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-c4041422 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_ItemPopup.cs:226 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7932d396 | this.Load | FP00596_ItemPopup.cs:102 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1a13c89f | this.Load | FP00596_ItemPopup.cs:104 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_ItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf5befb0 | this.Load | FP00596_ItemPopup.cs:119 |  | VALUE_SET | txtMaterial.Text | this.Filter["ITEM_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-1b2f0e5e | this.Load | FP00596_ItemPopup.cs:120 |  | VALUE_SET | txtNickName.Text | this.Filter["NICK_NAME"] | 컨트롤 값 설정 |  |  |  |

## FP00596_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a9243f3 | this.Load | FP00596_ItemPopup.cs:143 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9bec0601 | this.Load | FP00596_ItemPopup.cs:144 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00596_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a90b41c | (진입점 미연결) | FP00596_ItemPopup.cs:163 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00596_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffd0c447 | this.Load | FP00596_ItemPopup.cs:150 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da8fa36d | this.Load | FP00596_ItemPopup.cs:151 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-ea657b69 | this.Load | FP00596_ItemPopup.cs:155 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00596_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fe80d48 | this.spdMain.CellClick | FP00596_ItemPopup.cs:269 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-9fd5e173 | this.spdMain.CellClick | FP00596_ItemPopup.cs:270 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-79f86eab | this.spdMain.CellClick | FP00596_ItemPopup.cs:273 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00596_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5a62631 | this.spdMain.CellDoubleClick | FP00596_ItemPopup.cs:279 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e2e73279 | this.spdMain.CellDoubleClick | FP00596_ItemPopup.cs:280 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e77bd4c7 | this.spdMain.CellDoubleClick | FP00596_ItemPopup.cs:283 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-fc3e2ae5 | this.spdMain.CellDoubleClick | FP00596_ItemPopup.cs:286 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66958285 | this.spdMain.CellDoubleClick | FP00596_ItemPopup.cs:296 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_LineAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-782560da | .ctor | FP00596_LineAddPopup.cs:73 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-205f3bb4 | .ctor | FP00596_LineAddPopup.cs:74 |  | FLAG | this.InitRow | initRow | 화면 필드/플래그 변경 |  |  |  |

## FP00596_LineAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b341fdb5 | this.btnClose.Click | FP00596_LineAddPopup.cs:243 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_LineAddPopup.btnEquipment_Click

진입점: this.btnEquipment.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22b0d11e | this.btnEquipment.Click | FP00596_LineAddPopup.cs:872 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert Material value") | 메시지 표시 |  |  |  |
| AC-75c6c234 | this.btnEquipment.Click | FP00596_LineAddPopup.cs:873 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6dd09d6 | this.btnEquipment.Click | FP00596_LineAddPopup.cs:878 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | MESSAGE | MessageBox.Show | ("Please insert Line value") | 메시지 표시 |  |  |  |
| AC-93a86796 | this.btnEquipment.Click | FP00596_LineAddPopup.cs:879 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16718b9b | this.btnEquipment.Click | FP00596_LineAddPopup.cs:883 |  | POPUP | new FP00595_EquipmentPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7292d3f1 | this.btnEquipment.Click | FP00596_LineAddPopup.cs:884 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-5e920098 | this.btnEquipment.Click | FP00596_LineAddPopup.cs:885 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-32b8eafa | this.btnEquipment.Click | FP00596_LineAddPopup.cs:887 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | this.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ef8907e3 | this.btnEquipment.Click | FP00596_LineAddPopup.cs:888 |  | DATA_OP | popup.Filter["PLAN_DATE"] | this.Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f5688bb1 | this.btnEquipment.Click | FP00596_LineAddPopup.cs:889 |  | DATA_OP | popup.Filter["PLAN_ID"] | this.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-89a5906c | this.btnEquipment.Click | FP00596_LineAddPopup.cs:890 |  | DATA_OP | popup.Filter["DIVISION_ID"] | this.Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d46703a6 | this.btnEquipment.Click | FP00596_LineAddPopup.cs:891 |  | DATA_OP | popup.Filter["SITE_ID"] | this.Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-997cb3da | this.btnEquipment.Click | FP00596_LineAddPopup.cs:892 |  | DATA_OP | popup.Filter["PLANT_ID"] | this.Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a883fd1d | this.btnEquipment.Click | FP00596_LineAddPopup.cs:893 |  | DATA_OP | popup.Filter["FACTORY_ID"] | txtBuilding.Text | 행/컬럼 값 대입 |  |  |  |
| AC-01cb69d8 | this.btnEquipment.Click | FP00596_LineAddPopup.cs:894 |  | DATA_OP | popup.Filter["OPERATION_ID"] | txtOperation.Text | 행/컬럼 값 대입 |  |  |  |
| AC-798ea7ec | this.btnEquipment.Click | FP00596_LineAddPopup.cs:895 |  | DATA_OP | popup.Filter["LINE_ID"] | txtLine.Text | 행/컬럼 값 대입 |  |  |  |
| AC-dd501a8c | this.btnEquipment.Click | FP00596_LineAddPopup.cs:898 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a92024b2 | this.btnEquipment.Click | FP00596_LineAddPopup.cs:900 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-840096e7 | this.btnEquipment.Click | FP00596_LineAddPopup.cs:906 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["EQUIPMENT_ID"] | txtEquipment.Text = row["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c34145e | this.btnEquipment.Click | FP00596_LineAddPopup.cs:906 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | VALUE_SET | txtEquipment.Text | row["EQUIPMENT_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b6adbefe | this.btnEquipment.Click | FP00596_LineAddPopup.cs:908 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("EQUIPMENT_ID", this.Filter["EQUIPMENT_ID"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00596_LineAddPopup.btnLine_Click

진입점: this.btnLine.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2708ae4 | this.btnLine.Click | FP00596_LineAddPopup.cs:814 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert material value") | 메시지 표시 |  |  |  |
| AC-fcd523cc | this.btnLine.Click | FP00596_LineAddPopup.cs:815 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7aa5cc9a | this.btnLine.Click | FP00596_LineAddPopup.cs:818 |  | DATA_OP | Filter["PLAN_DATE"] | dpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-c5019f9a | this.btnLine.Click | FP00596_LineAddPopup.cs:821 |  | POPUP | new FP00594_LinePopup | () | 팝업/폼 생성 |  |  |  |
| AC-189a7298 | this.btnLine.Click | FP00596_LineAddPopup.cs:822 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-58603763 | this.btnLine.Click | FP00596_LineAddPopup.cs:823 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-44e28e85 | this.btnLine.Click | FP00596_LineAddPopup.cs:825 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | this.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-db25532a | this.btnLine.Click | FP00596_LineAddPopup.cs:826 |  | DATA_OP | popup.Filter["PLAN_DATE"] | this.Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-fbbb6b5f | this.btnLine.Click | FP00596_LineAddPopup.cs:827 |  | DATA_OP | popup.Filter["PLAN_ID"] | this.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2ab1befd | this.btnLine.Click | FP00596_LineAddPopup.cs:828 |  | DATA_OP | popup.Filter["DIVISION_ID"] | this.Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-935beeb7 | this.btnLine.Click | FP00596_LineAddPopup.cs:829 |  | DATA_OP | popup.Filter["SITE_ID"] | this.Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-644af4ca | this.btnLine.Click | FP00596_LineAddPopup.cs:830 |  | DATA_OP | popup.Filter["PLANT_ID"] | this.Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f4148d6c | this.btnLine.Click | FP00596_LineAddPopup.cs:831 |  | DATA_OP | popup.Filter["FACTORY_ID"] | this.Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-32abb24b | this.btnLine.Click | FP00596_LineAddPopup.cs:832 |  | DATA_OP | popup.Filter["LINE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cfb62f28 | this.btnLine.Click | FP00596_LineAddPopup.cs:833 |  | DATA_OP | popup.Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-41b907d7 | this.btnLine.Click | FP00596_LineAddPopup.cs:835 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-75990a9e | this.btnLine.Click | FP00596_LineAddPopup.cs:837 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-98ede1aa | this.btnLine.Click | FP00596_LineAddPopup.cs:842 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a3b9bf0e | this.btnLine.Click | FP00596_LineAddPopup.cs:843 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["FACTORY_ID"] | txtBuilding.Text = row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a9d76a4d | this.btnLine.Click | FP00596_LineAddPopup.cs:843 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | VALUE_SET | txtBuilding.Text | row["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8992f52e | this.btnLine.Click | FP00596_LineAddPopup.cs:844 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["OPERATION_ID"] | txtOperation.Text = row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-74706f12 | this.btnLine.Click | FP00596_LineAddPopup.cs:844 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | VALUE_SET | txtOperation.Text | row["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8a7e3ead | this.btnLine.Click | FP00596_LineAddPopup.cs:845 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["LINE_ID"] | txtLine.Text = row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e29ef23a | this.btnLine.Click | FP00596_LineAddPopup.cs:845 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | VALUE_SET | txtLine.Text | row["LINE_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5e70738c | this.btnLine.Click | FP00596_LineAddPopup.cs:846 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8fa8884b | this.btnLine.Click | FP00596_LineAddPopup.cs:847 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["LOCATION"] | row["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2add2c3f | this.btnLine.Click | FP00596_LineAddPopup.cs:849 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("PLANT_ID", this.Filter["PLANT_ID"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a00df792 | this.btnLine.Click | FP00596_LineAddPopup.cs:850 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", this.Filter["FACTORY_ID"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-53069753 | this.btnLine.Click | FP00596_LineAddPopup.cs:851 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", this.Filter["OPERATION_ID"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-74c39611 | this.btnLine.Click | FP00596_LineAddPopup.cs:852 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("LINE_ID", this.Filter["LINE_ID"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-facd9800 | this.btnLine.Click | FP00596_LineAddPopup.cs:853 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", this.Filter["ELECTRODE_TYPE"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2f0f8d66 | this.btnLine.Click | FP00596_LineAddPopup.cs:854 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("LOCATION", this.Filter["LOCATION"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3e7f0ed5 | this.btnLine.Click | FP00596_LineAddPopup.cs:857 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | VALUE_SET | txtEquipment.Text | this.Filter["EQUIPMENT_ID"] = "" | 컨트롤 값 설정 |  |  |  |
| AC-40c80cb9 | this.btnLine.Click | FP00596_LineAddPopup.cs:857 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["EQUIPMENT_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1c02b5e6 | this.btnLine.Click | FP00596_LineAddPopup.cs:858 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("EQUIPMENT_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00596_LineAddPopup.btnMaterial_Click

진입점: this.btnMaterial.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d1647c8 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:758 |  | POPUP | new FP00596_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2855e77d | this.btnMaterial.Click | FP00596_LineAddPopup.cs:759 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-e8c7e449 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:760 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-e1dee99f | this.btnMaterial.Click | FP00596_LineAddPopup.cs:761 |  | DATA_OP | popup.Filter["DIVISION_ID"] | this.Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c0e86f84 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:762 |  | DATA_OP | popup.Filter["SITE_ID"] | this.Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7401ccdf | this.btnMaterial.Click | FP00596_LineAddPopup.cs:763 |  | DATA_OP | popup.Filter["PLANT_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2da09bc2 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:764 |  | DATA_OP | popup.Filter["TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1e7bf1ee | this.btnMaterial.Click | FP00596_LineAddPopup.cs:765 |  | DATA_OP | popup.Filter["EQUIPMENT_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8a3511d0 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:766 |  | DATA_OP | popup.Filter["OPERATION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bcb6bdaf | this.btnMaterial.Click | FP00596_LineAddPopup.cs:767 |  | DATA_OP | popup.Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e0a69ee9 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:768 |  | DATA_OP | popup.Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-bc3cf49e | this.btnMaterial.Click | FP00596_LineAddPopup.cs:769 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | this.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b15cfb5f | this.btnMaterial.Click | FP00596_LineAddPopup.cs:770 |  | DATA_OP | popup.Filter["PLAN_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ebe15205 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:772 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3d282fd9 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:774 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bcac6da2 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:779 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["ITEM_ID"] | txtItem.Text = row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-23944d6a | this.btnMaterial.Click | FP00596_LineAddPopup.cs:779 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | VALUE_SET | txtItem.Text | row["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-dab122ca | this.btnMaterial.Click | FP00596_LineAddPopup.cs:780 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["NICK_NAME"] | txtNickName.Text = row["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9215e75a | this.btnMaterial.Click | FP00596_LineAddPopup.cs:780 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | VALUE_SET | txtNickName.Text | row["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-abd5eeb6 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:781 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["ITEM_TYPE"] | txtItemType.Text = row["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4f61f1e8 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:781 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | VALUE_SET | txtItemType.Text | row["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6ca28dc4 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:782 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["TOP_ITEM_ID"] | row["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9eccfc85 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:784 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", row["DIVISION_ID"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cdfb2a71 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:785 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("SITE_ID", row["SITE_ID"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e791619a | this.btnMaterial.Click | FP00596_LineAddPopup.cs:786 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("ITEM_ID", row["ITEM_ID"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-668eaa23 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:787 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("NICK_NAME", row["NICK_NAME"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ff430159 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:788 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", row["ITEM_TYPE"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2c480f11 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:789 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", row["MODEL_ID"].ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4086617b | this.btnMaterial.Click | FP00596_LineAddPopup.cs:792 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("LINE_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-369f0d72 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:793 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-45468591 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:794 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("LOCATION", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6bf82cd3 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:795 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | dtSave.SetFirst | ("EQUIPMENT_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-faafa685 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:797 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | VALUE_SET | txtLine.Text | this.Filter["LINE_ID"] = "" | 컨트롤 값 설정 |  |  |  |
| AC-ade36ed7 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:797 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["LINE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0ddc2864 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:798 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["ELECTRODE_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d4f4d81 | this.btnMaterial.Click | FP00596_LineAddPopup.cs:799 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["LOCATION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-41d518ba | this.btnMaterial.Click | FP00596_LineAddPopup.cs:800 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | VALUE_SET | txtEquipment.Text | this.Filter["EQUIPMENT_ID"] = "" | 컨트롤 값 설정 |  |  |  |
| AC-591f6c1a | this.btnMaterial.Click | FP00596_LineAddPopup.cs:800 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (row != null) | DATA_OP | this.Filter["EQUIPMENT_ID"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00596_LineAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8ce903f | this.btnSave.Click | FP00596_LineAddPopup.cs:233 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00596_LineAddPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8027c897 | this.btnSql.Click | FP00596_LineAddPopup.cs:923 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-7febbfdc | this.btnSql.Click | FP00596_LineAddPopup.cs:926 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-22c254d0 | this.btnSql.Click | FP00596_LineAddPopup.cs:927 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d2628869 | this.btnSql.Click | FP00596_LineAddPopup.cs:929 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00596_ADD_LINE_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-82bd84e8 | this.btnSql.Click | FP00596_LineAddPopup.cs:930 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00596_LineAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bd1b940 | this.btnSave.Click | FP00596_LineAddPopup.cs:254 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | MESSAGE | MessageBox.Show | ("You need to select line data") | 메시지 표시 |  |  |  |
| AC-b6aeb86a | this.btnSave.Click | FP00596_LineAddPopup.cs:255 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-eeefe4ac | this.btnSave.Click | FP00596_LineAddPopup.cs:259 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | MESSAGE | MessageBox.Show | ("You need to specify quantity") | 메시지 표시 |  |  |  |
| AC-53701989 | this.btnSave.Click | FP00596_LineAddPopup.cs:260 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0b73e879 | this.btnSave.Click | FP00596_LineAddPopup.cs:268 | try ▸ if (value >= 30) | MESSAGE | MessageBox.Show | ("QTY 30 Over") | 메시지 표시 |  |  |  |
| AC-7f51b96b | this.btnSave.Click | FP00596_LineAddPopup.cs:269 | try ▸ if (value >= 30) | FOCUS | txtQty.Focus | () | 포커스 이동 |  |  |  |
| AC-49db99d6 | this.btnSave.Click | FP00596_LineAddPopup.cs:270 | try ▸ if (value >= 30) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-521b88e4 | this.btnSave.Click | FP00596_LineAddPopup.cs:276 | catch () | MESSAGE | MessageBox.Show | ("You shoud insert quantity as number") | 메시지 표시 |  |  |  |
| AC-07141fc0 | this.btnSave.Click | FP00596_LineAddPopup.cs:277 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e1ba99fa | this.btnSave.Click | FP00596_LineAddPopup.cs:300 | if (!string.IsNullOrEmpty(sMsg)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e293ab9 | this.btnSave.Click | FP00596_LineAddPopup.cs:301 | if (!string.IsNullOrEmpty(sMsg)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-06a22d76 | this.btnSave.Click | FP00596_LineAddPopup.cs:304 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00596_LineAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5912527 | Dispose | FP00596_LineAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00596_LineAddPopup.Exec_Procedure

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d25a632b | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:702 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_ADD_LINE") ⇒ FP_Planning.PR_UI_FP00596_ADD_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-a29656d7 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:703 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f342b686 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:705 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-f14df7be | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:706 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-e09b3b59 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:707 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d6c34460 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:708 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a44a65a5 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:710 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-4fc0799c | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:711 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c844eba6 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:712 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-4c34f95d | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:713 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8259c59e | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:714 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7ddbbb2a | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:715 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d269855b | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:716 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-36bd9a3d | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:717 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ce4a2734 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:718 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2e8721e3 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:719 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6e56c9a1 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:720 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4363fd66 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:721 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9d5077d9 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:722 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fb00edfb | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:723 | try | DATA_OP | req.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-acd20131 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:724 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6c2ac109 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:725 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-661d03f9 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:726 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7d2c056e | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:727 | try | DATA_OP | req.Parameters["p_equipment_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4b2c2e6f | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:728 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5bfc31c5 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:729 | try | DATA_OP | req.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c21f5bd5 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:730 | try | DATA_OP | req.Parameters["p_adjust_in_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ff3a0ff8 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:731 | try | DATA_OP | req.Parameters["p_adjust_in_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-439fde84 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:732 | try | DATA_OP | req.Parameters["p_adjust_out_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3da24896 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:733 | try | DATA_OP | req.Parameters["p_adjust_out_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-49babc12 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:735 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-16b5ea17 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:742 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-bf6bbda7 | this.btnSave.Click [try] | FP00596_LineAddPopup.cs:746 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00596_LineAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6913987 | this.Load | FP00596_LineAddPopup.cs:87 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-580d57d6 | this.Load | FP00596_LineAddPopup.cs:89 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ca29573b | this.Load | FP00596_LineAddPopup.cs:92 |  | FLAG | dtSave | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-936b9cc0 | this.Load | FP00596_LineAddPopup.cs:93 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1067350 | this.Load | FP00596_LineAddPopup.cs:94 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-321a6ebb | this.Load | FP00596_LineAddPopup.cs:95 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a04289e6 | this.Load | FP00596_LineAddPopup.cs:96 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5297d10 | this.Load | FP00596_LineAddPopup.cs:97 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc45d78b | this.Load | FP00596_LineAddPopup.cs:98 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-99f44723 | this.Load | FP00596_LineAddPopup.cs:99 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6707231f | this.Load | FP00596_LineAddPopup.cs:100 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-44f28e96 | this.Load | FP00596_LineAddPopup.cs:101 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7acdf9ee | this.Load | FP00596_LineAddPopup.cs:102 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f2f69ce | this.Load | FP00596_LineAddPopup.cs:103 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-deca7f8a | this.Load | FP00596_LineAddPopup.cs:104 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-02776d93 | this.Load | FP00596_LineAddPopup.cs:105 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("NICK_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ecc77226 | this.Load | FP00596_LineAddPopup.cs:106 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7239adcb | this.Load | FP00596_LineAddPopup.cs:107 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3be0eaa9 | this.Load | FP00596_LineAddPopup.cs:108 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("EQUIPMENT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d8ca599 | this.Load | FP00596_LineAddPopup.cs:109 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c07de8a3 | this.Load | FP00596_LineAddPopup.cs:110 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d2503a1 | this.Load | FP00596_LineAddPopup.cs:111 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-08265a5e | this.Load | FP00596_LineAddPopup.cs:112 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ADJUST_IN_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-50b55c99 | this.Load | FP00596_LineAddPopup.cs:113 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ADJUST_IN_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6ff48cb | this.Load | FP00596_LineAddPopup.cs:114 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5edc1667 | this.Load | FP00596_LineAddPopup.cs:115 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-136daf79 | this.Load | FP00596_LineAddPopup.cs:117 |  | DATA_OP | dtSave.Rows.Add | (dtSave.NewRow()) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e849103 | this.Load | FP00596_LineAddPopup.cs:117 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |

## FP00596_LineAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c92c137a | this.Load | FP00596_LineAddPopup.cs:139 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-75cd5873 | this.Load | FP00596_LineAddPopup.cs:143 | if (InitRow== null) | MESSAGE | MessageBox.Show | ("Please select any row before add line") | 메시지 표시 |  |  |  |
| AC-c97bf45c | this.Load | FP00596_LineAddPopup.cs:144 | if (InitRow== null) | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-bdba8448 | this.Load | FP00596_LineAddPopup.cs:145 | if (InitRow== null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b888f7d | this.Load | FP00596_LineAddPopup.cs:150 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["PLAN_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-4e75ae4a | this.Load | FP00596_LineAddPopup.cs:152 |  | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-c99b25ee | this.Load | FP00596_LineAddPopup.cs:154 |  | VALUE_SET | txtItem.Text | Filter["ITEM_ID"] = InitRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-fbcf7b60 | this.Load | FP00596_LineAddPopup.cs:154 |  | DATA_OP | Filter["ITEM_ID"] | InitRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-53342f9f | this.Load | FP00596_LineAddPopup.cs:155 |  | VALUE_SET | txtNickName.Text | Filter["NICK_NAME"] = InitRow["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-2ce6d1c9 | this.Load | FP00596_LineAddPopup.cs:155 |  | DATA_OP | Filter["NICK_NAME"] | InitRow["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f942c72 | this.Load | FP00596_LineAddPopup.cs:157 |  | VALUE_SET | txtOperation.Text | Filter["OPERATON_ID"] = InitRow["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-46c9eb64 | this.Load | FP00596_LineAddPopup.cs:157 |  | DATA_OP | Filter["OPERATON_ID"] | InitRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a03a3060 | this.Load | FP00596_LineAddPopup.cs:158 |  | VALUE_SET | txtBuilding.Text | Filter["FACTORY_ID"] = InitRow["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-7683a6e3 | this.Load | FP00596_LineAddPopup.cs:158 |  | DATA_OP | Filter["FACTORY_ID"] | InitRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-49d92f45 | this.Load | FP00596_LineAddPopup.cs:160 |  | VALUE_CLEAR | txtEquipment.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-bc605d71 | this.Load | FP00596_LineAddPopup.cs:162 |  | FLAG | dtProdType | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE_PRODTYPE, false, UserInfoContext.Current.UserId… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_PRODTYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-0d406d7f | this.Load | FP00596_LineAddPopup.cs:162 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE_PRODTYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSa… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_PRODTYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e86575a1 | this.Load | FP00596_LineAddPopup.cs:166 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cbo_prodtype, false, "CODE", "CODE") | 목록 컨트롤 재구성 |  |  |  |
| AC-31ce9fd6 | this.Load | FP00596_LineAddPopup.cs:168 |  | VALUE_SET | cbo_prodtype.SelectedValue | Filter["PRODUCTION_TYPE"] = InitRow["PRODUCTION_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-60e88b7a | this.Load | FP00596_LineAddPopup.cs:168 |  | DATA_OP | Filter["PRODUCTION_TYPE"] | InitRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-afeacafc | this.Load | FP00596_LineAddPopup.cs:170 |  | VALUE_SET | labelTitle.Text | " Add Line" | 컨트롤 값 설정 |  |  |  |
| AC-6df5b818 | this.Load | FP00596_LineAddPopup.cs:172 |  | FLAG | dtMarket | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP00594_LineAddPopup", "MARKET_TYPE… | 화면 필드/플래그 변경 |  |  |  |
| AC-c5fa0550 | this.Load | FP00596_LineAddPopup.cs:172 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP00594_LineAddPopup", "MARKET_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c667d07f | this.Load | FP00596_LineAddPopup.cs:180 |  | LIST_REBIND | clsCtrl.setListBox | (dtMarket, cbo_market, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9a982929 | this.Load | FP00596_LineAddPopup.cs:181 |  | VALUE_SET | cbo_market.SelectedValue | Filter["MARKET"] = InitRow["MARKET"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-21d0054a | this.Load | FP00596_LineAddPopup.cs:181 |  | DATA_OP | Filter["MARKET"] | InitRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-03350c1b | this.Load | FP00596_LineAddPopup.cs:183 |  | VALUE_SET | txtQty.Text | "0" | 컨트롤 값 설정 |  |  |  |
| AC-666422be | this.Load | FP00596_LineAddPopup.cs:186 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", this.Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-14ea2bea | this.Load | FP00596_LineAddPopup.cs:187 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", this.Filter["PLAN_DATE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-20d81545 | this.Load | FP00596_LineAddPopup.cs:188 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", this.Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-71423ff9 | this.Load | FP00596_LineAddPopup.cs:189 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", this.Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1bfa8445 | this.Load | FP00596_LineAddPopup.cs:190 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", this.Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d58413f9 | this.Load | FP00596_LineAddPopup.cs:191 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", this.Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-56d7c751 | this.Load | FP00596_LineAddPopup.cs:192 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", this.Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ddd129f4 | this.Load | FP00596_LineAddPopup.cs:193 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", this.Filter["OPERATION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-73b8eac8 | this.Load | FP00596_LineAddPopup.cs:194 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", this.Filter["LINE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-72de43ba | this.Load | FP00596_LineAddPopup.cs:195 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", this.Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d19c2c65 | this.Load | FP00596_LineAddPopup.cs:196 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", this.Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ad9d5936 | this.Load | FP00596_LineAddPopup.cs:197 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", this.Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5812614f | this.Load | FP00596_LineAddPopup.cs:198 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", this.Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c16ff933 | this.Load | FP00596_LineAddPopup.cs:199 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", this.Filter["ELECTRODE_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-073830bd | this.Load | FP00596_LineAddPopup.cs:200 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", this.Filter["PRODUCTION_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7cdd3fb3 | this.Load | FP00596_LineAddPopup.cs:201 |  | DATA_OP | dtSave.SetFirst | ("EQUIPMENT_ID", this.Filter["EQUIPMENT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1c39e626 | this.Load | FP00596_LineAddPopup.cs:202 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", this.Filter["LOCATION"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d4ded410 | this.Load | FP00596_LineAddPopup.cs:203 |  | DATA_OP | dtSave.SetFirst | ("MARKET", this.Filter["MARKET"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-54e10717 | this.Load | FP00596_LineAddPopup.cs:204 |  | DATA_OP | dtSave.SetFirst | ("QTY", "0") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-32278caf | this.Load | FP00596_LineAddPopup.cs:205 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_IN_QTY_BATCH", "0") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f7447595 | this.Load | FP00596_LineAddPopup.cs:206 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_IN_QTY_KG", "0") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-04d1d3ec | this.Load | FP00596_LineAddPopup.cs:207 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_OUT_QTY_BATCH", "0") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-63279908 | this.Load | FP00596_LineAddPopup.cs:208 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_OUT_QTY_KG", "0") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-83b1e477 | this.Load | FP00596_LineAddPopup.cs:214 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-796d749b | this.Load | FP00596_LineAddPopup.cs:215 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9db47279 | this.Load | FP00596_LineAddPopup.cs:216 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00596_LineAddPopup.lfn_getYieldInfo

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE")] / this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8d775af | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:519 | if (dsYieldInfo != null) ▸ if (dsYieldInfo.Tables[0].Rows.Count == 0) | RETURN | return nVal; |  | 처리 중단/반환 |  |  |  |
| AC-e64d887c | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:528 |  | RETURN | return nVal; |  | 처리 중단/반환 |  |  |  |

## FP00596_LineAddPopup.lfn_setExchangeBatch

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE")] / this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2915ebd9 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:550 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-c378ce35 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:556 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-08495a96 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:557 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-34f0c9b4 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:558 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-76103804 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:559 | lambda | DATA_OP | each_row.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d1c996f | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:576 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bbab8c22 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:577 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-09ce46b9 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:578 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-068887df | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:579 | lambda | DATA_OP | each_row.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-853954e5 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:580 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-39a7107e | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:581 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-83ebb68d | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:582 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff7cd26c | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:582 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-71289b8e | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:600 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00596_LineAddPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab25b821 | popSql.OnSql | FP00596_LineAddPopup.cs:952 | if (programID == "PR_UI_FP00596_ADD_LINE_SAVE") | RETURN | return Save_Data_Add("SQL", "INSERT_LINE"); |  | 처리 중단/반환 |  |  |  |
| AC-75589a26 | popSql.OnSql | FP00596_LineAddPopup.cs:958 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_LineAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdd3a0f4 | this.btnSave.Click | FP00596_LineAddPopup.cs:314 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_dup", this.Filter["INSTANCE_ID"], this.Filter["PLAN_DATE"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9331d6dd | this.btnSave.Click | FP00596_LineAddPopup.cs:327 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | MESSAGE | MessageBox.Show | ("The Line or detail information is already exists.") | 메시지 표시 |  |  |  |
| AC-83839c00 | this.btnSave.Click | FP00596_LineAddPopup.cs:328 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e195b3fc | this.btnSave.Click | FP00596_LineAddPopup.cs:355 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dfd3ac68 | this.btnSave.Click | FP00596_LineAddPopup.cs:367 | if (dtCheckSave != null) ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + strMsg) | 메시지 표시 |  |  |  |
| AC-aa4347c2 | this.btnSave.Click | FP00596_LineAddPopup.cs:368 | if (dtCheckSave != null) ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1548862 | this.btnSave.Click | FP00596_LineAddPopup.cs:372 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", this.Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-97895a15 | this.btnSave.Click | FP00596_LineAddPopup.cs:373 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-20f6bd6e | this.btnSave.Click | FP00596_LineAddPopup.cs:374 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", this.Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1b1168ce | this.btnSave.Click | FP00596_LineAddPopup.cs:376 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", this.Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7cd812ba | this.btnSave.Click | FP00596_LineAddPopup.cs:377 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", this.Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d8de0ec7 | this.btnSave.Click | FP00596_LineAddPopup.cs:378 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", this.Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-93573a6f | this.btnSave.Click | FP00596_LineAddPopup.cs:379 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", txtBuilding.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cbe984c1 | this.btnSave.Click | FP00596_LineAddPopup.cs:380 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", txtOperation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0fff121e | this.btnSave.Click | FP00596_LineAddPopup.cs:381 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", txtLine.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-74ac21c0 | this.btnSave.Click | FP00596_LineAddPopup.cs:383 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", txtItem.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-df532c76 | this.btnSave.Click | FP00596_LineAddPopup.cs:384 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", txtItem.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9b690dd6 | this.btnSave.Click | FP00596_LineAddPopup.cs:385 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", txtItemType.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e1fd1dee | this.btnSave.Click | FP00596_LineAddPopup.cs:386 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", txtNickName.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8ec036d0 | this.btnSave.Click | FP00596_LineAddPopup.cs:387 |  | DATA_OP | dtSave.SetFirst | ("ELECTORDE_TYPE", txtEquipment.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8bc61213 | this.btnSave.Click | FP00596_LineAddPopup.cs:388 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", this.Filter["PRODUCTION_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6d876ac0 | this.btnSave.Click | FP00596_LineAddPopup.cs:389 |  | DATA_OP | dtSave.SetFirst | ("EQUIPMENT_ID", txtEquipment.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5ad23643 | this.btnSave.Click | FP00596_LineAddPopup.cs:390 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", this.Filter["ELECTRODE_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2ceedca1 | this.btnSave.Click | FP00596_LineAddPopup.cs:391 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f91bfccc | this.btnSave.Click | FP00596_LineAddPopup.cs:392 |  | DATA_OP | dtSave.SetFirst | ("MARKET", this.Filter["MARKET"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-dd0a5047 | this.btnSave.Click | FP00596_LineAddPopup.cs:400 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-bd470a9b | this.btnSave.Click | FP00596_LineAddPopup.cs:401 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d97879f | this.btnSave.Click | FP00596_LineAddPopup.cs:403 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-429f3256 | this.btnSave.Click | FP00596_LineAddPopup.cs:420 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_IN_QTY_BATCH", nInValue) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1e3b914b | this.btnSave.Click | FP00596_LineAddPopup.cs:421 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_IN_QTY_KG", nIn_KG) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b666ed51 | this.btnSave.Click | FP00596_LineAddPopup.cs:422 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_OUT_QTY_BATCH", nOutValue) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3a4987bb | this.btnSave.Click | FP00596_LineAddPopup.cs:423 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_OUT_QTY_KG", nOut_KG) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-79077ef5 | this.btnSave.Click | FP00596_LineAddPopup.cs:433 | if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-74ae6f81 | this.btnSave.Click | FP00596_LineAddPopup.cs:434 | if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-425a70c1 | this.btnSave.Click | FP00596_LineAddPopup.cs:442 | if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-e668e9a4 | this.btnSave.Click | FP00596_LineAddPopup.cs:443 | if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dac66ae1 | this.btnSave.Click | FP00596_LineAddPopup.cs:447 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-95f108b7 | this.btnSave.Click | FP00596_LineAddPopup.cs:450 | try | POPUP | prg2.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9b81aeb5 | this.btnSave.Click | FP00596_LineAddPopup.cs:457 | try ▸ if (!bRtn1) | MESSAGE | MessageBox.Show | ("EXEC_PSICALCUL is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informat… | 메시지 표시 |  |  |  |
| AC-ec14176a | this.btnSave.Click | FP00596_LineAddPopup.cs:459 | try ▸ if (!bRtn1) | UI_MISC | prg2.Close | () | 창 닫기/해제 |  |  |  |
| AC-20485a56 | this.btnSave.Click | FP00596_LineAddPopup.cs:462 | try | UI_MISC | prg2.Close | () | 창 닫기/해제 |  |  |  |
| AC-ba2b5f8e | this.btnSave.Click | FP00596_LineAddPopup.cs:466 | catch () | UI_MISC | prg2.Close | () | 창 닫기/해제 |  |  |  |
| AC-fc7c005c | this.btnSave.Click | FP00596_LineAddPopup.cs:467 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-c40179a1 | this.btnSave.Click | FP00596_LineAddPopup.cs:471 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ca9750fb | this.btnSave.Click | FP00596_LineAddPopup.cs:473 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-3a6a82f4 | this.btnSave.Click | FP00596_LineAddPopup.cs:474 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_LineAddPopup.Save_Data_Add

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE")] / this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc747603 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:642 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_ADD_LINE") ⇒ FP_Planning.PR_UI_FP00596_ADD_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-e56640f0 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:643 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-61ef2026 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:645 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-c49ddebe | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:646 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-365233d7 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:647 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5b1afb37 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:648 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb966a1b | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:650 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-baf3f6fa | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:651 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-c83274d4 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:652 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-6507dca2 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:653 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bc92c80a | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:654 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-1727c261 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:655 | try | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-d3c91a52 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:656 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-9e4c3521 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:658 | try | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-a0f57c7e | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:659 | try | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-8851d710 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:660 | try | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-62c0c6bb | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:661 | try | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e4f726cb | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:662 | try | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-1be2c02c | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:663 | try | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-d1e4cb90 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:664 | try | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-95121ec1 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:665 | try | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-82976e34 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:667 | try | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-61523ee2 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:668 | try | DATA_OP | req.Parameters["p_equipment_id"] | p_equipment_id | 행/컬럼 값 대입 |  |  |  |
| AC-79d3aa1e | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:669 | try | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-89f2ece8 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:670 | try | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-50747faa | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:671 | try | DATA_OP | req.Parameters["p_adjust_in_qty_batch"] | p_adjust_in_qty_batch | 행/컬럼 값 대입 |  |  |  |
| AC-d8c3d5ea | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:672 | try | DATA_OP | req.Parameters["p_adjust_in_qty_kg"] | p_adjust_in_qty_kg | 행/컬럼 값 대입 |  |  |  |
| AC-834ce343 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:673 | try | DATA_OP | req.Parameters["p_adjust_out_qty_batch"] | p_adjust_out_qty_batch | 행/컬럼 값 대입 |  |  |  |
| AC-014c36a7 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:674 | try | DATA_OP | req.Parameters["p_adjust_out_qty_kg"] | p_adjust_out_qty_kg | 행/컬럼 값 대입 |  |  |  |
| AC-58d4ed42 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:677 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ae4b10a4 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:678 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2b8ab618 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… 외 1 | FP00596_LineAddPopup.cs:685 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_LineAddPopup.SearchListInfoAll

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16ba6744 | this.btnSave.Click | FP00596_LineAddPopup.cs:486 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_UOMInfo_ALL") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3e14a7b7 | this.btnSave.Click | FP00596_LineAddPopup.cs:487 | try | FLAG | dsUomInfoAll | dtUomAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6767fd3e | this.btnSave.Click | FP00596_LineAddPopup.cs:487 | try | DATA_OP | dtUomAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4dbba1c6 | this.btnSave.Click | FP00596_LineAddPopup.cs:489 | try | DATA_OP | this.Filter["PLAN_DATE"] | dpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-4f4671f0 | this.btnSave.Click | FP00596_LineAddPopup.cs:493 | try | DATA_OP | this.Filter["FACTORY_ID"] | txtBuilding.Text | 행/컬럼 값 대입 |  |  |  |
| AC-03ae125d | this.btnSave.Click | FP00596_LineAddPopup.cs:494 | try | DATA_OP | this.Filter["OPERATION_ID"] | txtOperation.Text | 행/컬럼 값 대입 |  |  |  |
| AC-81e10002 | this.btnSave.Click | FP00596_LineAddPopup.cs:495 | try | DATA_OP | this.Filter["LINE_ID"] | txtLine.Text | 행/컬럼 값 대입 |  |  |  |
| AC-5b6e2111 | this.btnSave.Click | FP00596_LineAddPopup.cs:496 | try | DATA_OP | this.Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c4369117 | this.btnSave.Click | FP00596_LineAddPopup.cs:498 | try ▸ if (this.Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_H" | 행/컬럼 값 대입 |  |  |  |
| AC-94ad4c01 | this.btnSave.Click | FP00596_LineAddPopup.cs:499 | try ▸ else of (this.Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_R" | 행/컬럼 값 대입 |  |  |  |
| AC-d2ca9cbd | this.btnSave.Click | FP00596_LineAddPopup.cs:501 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_YieldInfo_Child", Filter["INSTANCE_ID"].ToString(), Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-24b128ab | this.btnSave.Click | FP00596_LineAddPopup.cs:502 | try | FLAG | dsYieldInfo | dtYield.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-caf88d4c | this.btnSave.Click | FP00596_LineAddPopup.cs:502 | try | DATA_OP | dtYield.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-58a92847 | this.btnSave.Click | FP00596_LineAddPopup.cs:507 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00596_LineAddPopup.SetSaveDataTable

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cc45230 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:962 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", this.Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-eb437e3c | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:963 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-05794cbc | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:964 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", this.Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1ca98abf | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:966 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", this.Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8f814659 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:967 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", this.Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8a5d32e8 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:968 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", this.Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b6294d43 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:969 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", txtBuilding.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-39dc37b9 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:970 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", txtOperation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-addb6acd | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:971 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", txtLine.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-270c12ee | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:973 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", txtItem.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0fdf28b5 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:974 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", txtItem.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ae90b196 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:975 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", txtItemType.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0d6b5a55 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:976 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", txtNickName.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-21d3e4b9 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:977 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", this.Filter["ELECTRODE_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6d00e80e | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:978 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues)) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c9a7815e | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:979 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-dc7d2609 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:980 |  | DATA_OP | dtSave.SetFirst | ("EQUIPMENT_ID", txtEquipment.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-eb37d063 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:981 |  | DATA_OP | dtSave.SetFirst | ("MARKET", CString.GetCheckedListValue(dtMarket, cbo_market.ControlValues)) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d1c58265 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:991 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-cafe85db | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:992 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15c884b9 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:994 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b5e0e031 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:1011 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_IN_QTY_BATCH", nInValue) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e9182432 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:1012 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_IN_QTY_KG", nIn_KG) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4c8f06b7 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:1013 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_OUT_QTY_BATCH", nOutValue) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c8850d35 | popSql.OnSql [if (programID == "PR_UI_FP00596_ADD_LINE_SAVE"… | FP00596_LineAddPopup.cs:1014 |  | DATA_OP | dtSave.SetFirst | ("ADJUST_OUT_QTY_KG", nOut_KG) | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00596_LinePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba15239f | this.btnButtonList.UsrButtonList_Click_Detected | FP00596_LinePopup.cs:255 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-253cf07b | this.btnButtonList.UsrButtonList_Click_Detected | FP00596_LinePopup.cs:258 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-692ac600 | this.btnButtonList.UsrButtonList_Click_Detected | FP00596_LinePopup.cs:259 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_LinePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c433881 | this.Load | FP00596_LinePopup.cs:133 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-16f105b3 | this.Load | FP00596_LinePopup.cs:134 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d5f97b01 | this.Load | FP00596_LinePopup.cs:135 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00596_LinePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c473b792 | this.Load | FP00596_LinePopup.cs:128 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00596_LinePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-247c8d1b | Dispose | FP00596_LinePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00596_LinePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8c46910 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_LinePopup.cs:204 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b81d161c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_LinePopup.cs:207 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a9465b2a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_LinePopup.cs:208 |  | DATA_OP | Filter["LINE_ID"] | txtLine.Text | 행/컬럼 값 대입 |  |  |  |
| AC-da89dc76 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_LinePopup.cs:211 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => Data_FP.CallGeneralProcedure("PR_UI_FP00596_LINE", Filter, UserInfoContext.Current.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bbfae4d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_LinePopup.cs:212 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00596_LINE", Filter, UserInfoContext.Current.UserId, "SELECT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5416b379 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_LinePopup.cs:218 | if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4451e004 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_LinePopup.cs:221 | if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-42e4cfc2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_LinePopup.cs:223 | if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-415379cc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00596_LinePopup.cs:227 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_LinePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc919c2c | this.Load | FP00596_LinePopup.cs:105 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-75f8e7bb | this.Load | FP00596_LinePopup.cs:107 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_LinePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cc3927c | this.Load | FP00596_LinePopup.cs:122 |  | VALUE_SET | txtMaterial.Text | Filter["ITEM_ID"] | 컨트롤 값 설정 |  |  |  |

## FP00596_LinePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed0ad688 | this.Load | FP00596_LinePopup.cs:145 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb3ec133 | this.Load | FP00596_LinePopup.cs:146 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00596_LinePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cc3fdb4 | (진입점 미연결) | FP00596_LinePopup.cs:165 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00596_LinePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e84edcda | this.Load | FP00596_LinePopup.cs:152 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e8994799 | this.Load | FP00596_LinePopup.cs:153 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-edce1eca | this.Load | FP00596_LinePopup.cs:157 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00596_LinePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbb99cb0 | this.spdMain.CellClick | FP00596_LinePopup.cs:270 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b2289056 | this.spdMain.CellClick | FP00596_LinePopup.cs:271 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b97d2e97 | this.spdMain.CellClick | FP00596_LinePopup.cs:274 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00596_LinePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdaa7899 | this.spdMain.CellDoubleClick | FP00596_LinePopup.cs:280 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-98f03dd4 | this.spdMain.CellDoubleClick | FP00596_LinePopup.cs:281 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e2331d2e | this.spdMain.CellDoubleClick | FP00596_LinePopup.cs:284 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-dc12f229 | this.spdMain.CellDoubleClick | FP00596_LinePopup.cs:287 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf230345 | this.spdMain.CellDoubleClick | FP00596_LinePopup.cs:297 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24bad237 | .ctor | FP00596_MeasureSetForm_Popup.cs:91 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-4f11a287 | .ctor | FP00596_MeasureSetForm_Popup.cs:92 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-687d4930 | .ctor | FP00596_MeasureSetForm_Popup.cs:93 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-23ba2d16 | .ctor | FP00596_MeasureSetForm_Popup.cs:95 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00596_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa3474c1 | this.btnOK.Click | FP00596_MeasureSetForm_Popup.cs:310 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-8ce15a25 | this.btnOK.Click | FP00596_MeasureSetForm_Popup.cs:311 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-13c5ba48 | this.btnOK.Click | FP00596_MeasureSetForm_Popup.cs:318 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-f2211145 | this.btnOK.Click | FP00596_MeasureSetForm_Popup.cs:319 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67f87d7f | this.btnSet.Click | FP00596_MeasureSetForm_Popup.cs:282 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-94c3b446 | this.btnSet.Click | FP00596_MeasureSetForm_Popup.cs:283 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-8a65b935 | this.btnSet.Click | FP00596_MeasureSetForm_Popup.cs:285 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-070dd46d | this.btnSet.Click | FP00596_MeasureSetForm_Popup.cs:286 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-af0751a5 | this.btnSet.Click | FP00596_MeasureSetForm_Popup.cs:288 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-71c71067 | this.btnSet.Click | FP00596_MeasureSetForm_Popup.cs:289 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-8a17f241 | this.btnSet.Click | FP00596_MeasureSetForm_Popup.cs:290 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b4baf48 | Dispose | FP00596_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00596_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12c4e181 | this.Load | FP00596_MeasureSetForm_Popup.cs:118 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00596_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4451aa39 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:165 |  | FLAG | dtCategory | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "select_measure", "FP00596_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b34d522c | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:165 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00596_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9dcc13b5 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:167 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-42fa09e2 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:168 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-3c36cbdc | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:196 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ca79fa8 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:197 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-14f3532b | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:198 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-279f5d53 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:199 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d23b74e | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:202 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-8446c55a | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:203 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-37482b6f | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:204 |  | DATA_OP | ctrls.Add | (chk_result_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-417d6b03 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:205 |  | DATA_OP | ctrls.Add | (chk_off) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a049bf5 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:206 |  | DATA_OP | ctrls.Add | (chk_setup) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9510d6b | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:207 |  | DATA_OP | ctrls.Add | (chk_capa) | 데이터 객체 조작/조회 |  |  |  |
| AC-e861c941 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:208 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4415cd5 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:209 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-580e6ff0 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:210 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d89185b | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:214 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-a563cffa | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:214 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-89de3427 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:222 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-a55421fb | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:226 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-1f40c653 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:230 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00596_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e95aff18 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:131 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-76cfd29b | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:132 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8a39d189 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:133 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8750e0a7 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:134 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-49e9dcfe | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2b679818 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7e221615 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_result_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-baa7cd18 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_off.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f816de07 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_setup.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6ad37ddc | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_capa.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-27455ea4 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_memo_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d60bc4a1 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-fdd1e054 | this.Load 외 1 | FP00596_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00596_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99708d10 | (진입점 미연결) | FP00596_MeasureSetForm_Popup.cs:384 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-cc7e13b4 | (진입점 미연결) | FP00596_MeasureSetForm_Popup.cs:395 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53413471 | (진입점 미연결) | FP00596_MeasureSetForm_Popup.cs:406 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00596_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49be3992 | this.Load | FP00596_MeasureSetForm_Popup.cs:105 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-877ec9b0 | this.Load | FP00596_MeasureSetForm_Popup.cs:113 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00596_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1fb1ca0 | this.btnSet.Click 외 1 | FP00596_MeasureSetForm_Popup.cs:330 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-67eaf282 | this.btnSet.Click 외 1 | FP00596_MeasureSetForm_Popup.cs:338 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-9683487b | this.btnSet.Click 외 1 | FP00596_MeasureSetForm_Popup.cs:338 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-eb6360e1 | this.btnSet.Click 외 1 | FP00596_MeasureSetForm_Popup.cs:355 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7988fcb6 | this.btnSet.Click 외 1 | FP00596_MeasureSetForm_Popup.cs:366 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6914f51 | .ctor | FP00596_PlanAmend_Line_PreMix.cs:210 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-16ee4a60 | .ctor | FP00596_PlanAmend_Line_PreMix.cs:211 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SELECT") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05eff51d | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1298 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e586e065 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1299 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b729695d | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1300 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-661ac47a | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1301 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d6a27dd0 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1302 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8a96beaa | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1305 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e8b80ae7 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1309 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-fba6b16c | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1311 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fa7eb5c3 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1312 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-73fae643 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1313 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e3abb36 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1314 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ff4b84eb | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1315 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e6e9071d | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1316 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-31b668f9 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1318 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00596_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb54a680 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1324 | if (dtCategory != null) ▸ if (dtCategory.Rows.Count == 0) | MESSAGE | MessageBox.Show | ("Set the your column or Category popup!") | 메시지 표시 |  |  |  |
| AC-763e0ae1 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1328 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1f7dbd75 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1329 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-34dd5dec | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1330 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b3f26ffd | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1331 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2852e786 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1343 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-3d295583 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1350 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-53023ec1 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1351 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8f935bc5 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1352 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1fcd9d04 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1364 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-45ff4c25 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1365 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-01e3734a | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1366 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-41749bb1 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1367 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-89dc0b48 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1368 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-966364a0 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1369 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-41fd9d89 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1370 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.ApplyAmendCalendarCondition_ForExcel

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80009d53 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5400 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2b61a55f | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5401 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6a800192 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5402 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-74301cf6 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5403 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c7c179c8 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5404 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e1dd64e3 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5405 |  | FLAG | dsSeq | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c88c6be7 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5418 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aadc1568 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5422 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-5bb258da | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5424 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-536f5fd7 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5425 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-9e08c066 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5426 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c42819fe | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5427 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-bbfffa98 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5428 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-938baf37 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5429 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-af74b787 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5434 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00596_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5fbff85f | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5436 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f63f0113 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5437 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c27dd02d | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5438 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b397b2fe | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5439 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9694b858 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5440 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c517fc8e | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5441 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23c514f8 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5442 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0e58897b | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5445 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-24a3dafb | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5446 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-f7df723c | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5447 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-dc7c5c95 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5448 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-ff245332 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5449 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-e9bfe697 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5450 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-438ec8a3 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5451 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1d43da8 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1241 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; if (GetFilter("INSTANCE_ID") == "") … | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb27a5dc | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1251 | lambda | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-68f3ec1c | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1252 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-cb9b94f1 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1253 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-2fb5ef00 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1261 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-11c83c5c | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1269 | lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-5cffe33e | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1272 | lambda | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_R" | 행/컬럼 값 대입 |  |  |  |
| AC-ca515253 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1273 | lambda | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-18e0e50d | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1274 | lambda | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_R" | 행/컬럼 값 대입 |  |  |  |
| AC-7ec8d67e | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1275 | lambda | DATA_OP | Filter["AMEND_BOH_TABLE"] | "FP_AMEND_DAILY_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-93bab3c1 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1276 | lambda | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_DAILY_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-47e5354c | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1277 | lambda | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_DAILY_UTIL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-697766d7 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1278 | lambda | DATA_OP | Filter["AMEND_CAPA_TABLE"] | "FP_AMEND_DAILY_CAPA_R" | 행/컬럼 값 대입 |  |  |  |
| AC-4957a7ff | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1282 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_H" | 행/컬럼 값 대입 |  |  |  |
| AC-29e47f18 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1283 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H" | 행/컬럼 값 대입 |  |  |  |
| AC-d4afeb24 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1284 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_R" | 행/컬럼 값 대입 |  |  |  |
| AC-b12950b6 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1285 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_BOH_TABLE"] | "FP_AMEND_DAILY_BOH_H" | 행/컬럼 값 대입 |  |  |  |
| AC-e4f4bd92 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1286 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_DAILY_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-cbb4080f | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1287 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_DAILY_UTIL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-b0f65b42 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1288 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_CAPA_TABLE"] | "FP_AMEND_DAILY_CAPA_H" | 행/컬럼 값 대입 |  |  |  |
| AC-159faf6e | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1291 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd717c35 | this.btnBucket.Click | FP00596_PlanAmend_Line_PreMix.cs:2768 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-68ba03e6 | this.btnBucket.Click | FP00596_PlanAmend_Line_PreMix.cs:2771 |  | POPUP | new FP00596_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-dd9a9cbe | this.btnBucket.Click | FP00596_PlanAmend_Line_PreMix.cs:2772 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-56afbc2a | this.btnBucket.Click | FP00596_PlanAmend_Line_PreMix.cs:2773 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-47cbbb3f | this.btnBucket.Click | FP00596_PlanAmend_Line_PreMix.cs:2774 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ad028859 | this.btnBucket.Click | FP00596_PlanAmend_Line_PreMix.cs:2778 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-f3e1b9db | this.btnBucket.Click | FP00596_PlanAmend_Line_PreMix.cs:2787 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1a830c46 | this.btnBucket.Click | FP00596_PlanAmend_Line_PreMix.cs:2789 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-47ca133a | this.btnBucket.Click | FP00596_PlanAmend_Line_PreMix.cs:2792 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7a25871a | this.btnBucket.Click | FP00596_PlanAmend_Line_PreMix.cs:2801 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbd53085 | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2713 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-112d8a6f | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2716 |  | POPUP | new FP00596_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-35868798 | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2717 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-5af1da58 | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2718 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0e106153 | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2719 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bf2838c4 | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2723 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-3e868059 | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2732 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b5cc7c34 | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2734 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-edd28d18 | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2737 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7f81a60b | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2746 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8ccfa134 | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2751 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-097d6258 | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2754 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d9e38a7e | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2756 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-777e4e45 | this.btnCatagory.Click | FP00596_PlanAmend_Line_PreMix.cs:2759 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3953c10e | this.btnColumn.Click | FP00596_PlanAmend_Line_PreMix.cs:2686 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-16adaf9c | this.btnColumn.Click | FP00596_PlanAmend_Line_PreMix.cs:2689 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-b5c15759 | this.btnColumn.Click | FP00596_PlanAmend_Line_PreMix.cs:2690 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e1fd612c | this.btnColumn.Click | FP00596_PlanAmend_Line_PreMix.cs:2691 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4a6fa978 | this.btnColumn.Click | FP00596_PlanAmend_Line_PreMix.cs:2697 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-0ba2c58a | this.btnColumn.Click | FP00596_PlanAmend_Line_PreMix.cs:2697 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-170dbc08 | this.btnColumn.Click | FP00596_PlanAmend_Line_PreMix.cs:2698 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-4afbc8a2 | this.btnColumn.Click | FP00596_PlanAmend_Line_PreMix.cs:2704 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.btnCreatePlan_Click

진입점: this.btnCreatePlan2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1876ec35 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2870 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-ba58753f | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2871 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-06f57e5b | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2879 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82fa80d9 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2880 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b02f8c9 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2890 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f7d76418 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2892 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f69f5397 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2898 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3fdb02c | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2899 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-436dd7e8 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2904 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0924fa3 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2905 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9635bfe9 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2908 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5caacba | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2909 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c48db300 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2910 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb0ec884 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2916 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-eb2d67f8 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2919 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-b72fc166 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2920 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bbc64c03 | this.btnCreatePlan2.Click | FP00596_PlanAmend_Line_PreMix.cs:2921 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7ab0eb0 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3131 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f61cf3ef | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3132 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48b554e8 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3138 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-b37369d1 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3139 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-841427ad | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3145 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not be uploaded.") | 메시지 표시 |  |  |  |
| AC-c21287e2 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3146 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d29e1cc | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3152 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-9da3fa07 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3155 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7fc5ed9d | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3161 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-275f2db4 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3162 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f361fc0 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3163 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c9b1c5ae | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3165 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-36c43e89 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3172 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP00596_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-cc7806de | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3174 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | this.Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-3b1b4bc4 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3174 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | this.Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a73387d9 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3179 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.TYPEZERO | 속성 DateColumnType 설정 |  |  |  |
| AC-c6e7e168 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3182 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-42efc947 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3183 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e23469bf | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3184 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fa515e97 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3185 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-dc065a2d | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3186 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d7863326 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3187 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ec7c6a1d | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3188 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-70c0edeb | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3189 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c3b3f586 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3190 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-88020fe2 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3191 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ff4795fb | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3192 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a49fbca0 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3194 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-773ba7ce | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3195 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-f41c8e2c | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3196 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-54e75158 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3197 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-8679ccdb | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3198 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-9ffa0c32 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3199 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Operateion." | 행/컬럼 값 대입 |  |  |  |
| AC-04693ccb | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3200 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-3bd523fe | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3201 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-4f15dc5a | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3202 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-f407aba6 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3203 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-3225a511 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3204 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-7fc5e7f8 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3205 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-9e98208d | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3206 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-37a16ff0 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3207 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-76950dd9 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3211 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnSearchData | ExcelPopup_Search_Column | 속성 OnSearchData 설정 |  |  |  |
| AC-69d4a5f9 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3212 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Column | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-7bce6ad3 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3213 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Column | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-80284ce6 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3214 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-6c4b7a54 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3216 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-74757f83 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3218 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-928ed49e | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3228 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c8fa3bb8 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3231 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8abe3c48 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3234 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | MESSAGE | MessageBox.Show | ("ERROR: EXEC_PSICALCUL Excution occur Error!") | 메시지 표시 |  |  |  |
| AC-08199417 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3247 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP00596_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-91715abf | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3249 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | this.Filter | 화면 필드/플래그 변경 |  |  |  |
| AC-9e59ab21 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3253 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-15853a3c | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3254 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-329f6580 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3255 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-30a0c965 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3256 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b907a319 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3257 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ed36e9a5 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3258 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-030304a5 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3259 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-378ff7a8 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3260 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4414ff17 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3261 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-bbe0dc5c | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3262 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-877d607d | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3263 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0b8747bb | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3264 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-63876582 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3265 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-bcd13f45 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3266 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SEQ"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-70a17af5 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3269 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-f836103a | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3270 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-57053e8b | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3271 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-7b2b8bc8 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3272 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-47dd37ce | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3273 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Operateion" | 행/컬럼 값 대입 |  |  |  |
| AC-f3456cce | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3274 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-f1c80634 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3275 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-0c7372b3 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3276 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-54aeda3e | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3277 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-4f5be354 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3278 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-ed10c304 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3279 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-f1a8696a | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3280 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-f121bf11 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3281 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-77e1e34d | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3282 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-d38521fe | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3283 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_KG"] | "KG" | 행/컬럼 값 대입 |  |  |  |
| AC-b864e08c | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3284 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["QTY"] | "Batch" | 행/컬럼 값 대입 |  |  |  |
| AC-d9ac03ea | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3285 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SEQ"] | "Seq" | 행/컬럼 값 대입 |  |  |  |
| AC-528ce7d6 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3289 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnSearchData | ExcelPopup_Search_Row | 속성 OnSearchData 설정 |  |  |  |
| AC-c4f50dbe | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3290 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Row | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-22c27d33 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3291 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Row | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-a77aed3f | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3292 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-c3710a45 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3294 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-f47da664 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3296 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3adc5394 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3306 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3fe5361b | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3312 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | MESSAGE | MessageBox.Show | ("ERROR: EXEC_PSICALCUL Excution occur Error!") | 메시지 표시 |  |  |  |
| AC-7bcb37f0 | this.btnExcelImport.Click | FP00596_PlanAmend_Line_PreMix.cs:3314 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7fc82d1 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3072 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-fc04e6f1 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3073 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-2a8fc07f | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3081 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cdc2bf6a | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3082 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9141f225 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3087 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-53b4409d | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3088 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d4b8481 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3093 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a69de6e8 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3094 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-6e1c22fe | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3095 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-dd5e80c2 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3095 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-68185e22 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3096 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-b108cbc5 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3097 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-fe9822bc | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3098 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d65bd6c5 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3098 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3d50891f | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3099 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7d3b5a5f | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3100 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6e4a88fa | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3101 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-3cb72304 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3102 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3364124d | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3103 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-62fecbee | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3104 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-44daf84e | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3105 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-903ce905 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3106 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8c784b02 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3107 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-612085f4 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3109 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b27b47c9 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3110 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-ea21e094 | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3111 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-2cd885be | this.btnMemo.Click | FP00596_PlanAmend_Line_PreMix.cs:3112 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.btnMenu_Click

진입점: this.btnMenu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bea18a1 | this.btnMenu.Click | FP00596_PlanAmend_Line_PreMix.cs:3331 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnMenu, menuPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-8100a82c | this.btnMenu.Click | FP00596_PlanAmend_Line_PreMix.cs:3331 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.btnMRP_Click

진입점: this.btnMRP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38426e76 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2817 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-2d25dcb0 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2818 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-3131e0a0 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2826 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b2b7e85 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2827 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a732d71 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2832 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-86cc5977 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2838 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-2cf97650 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2839 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c619b8d9 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2845 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-0f352d73 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2846 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34adf397 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2851 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-cea1ef8e | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2852 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60bc0856 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2856 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-bebe5fd5 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2857 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9312bee9 | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2858 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4dafa6ba | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2860 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-5ec43e1f | this.btnMRP.Click | FP00596_PlanAmend_Line_PreMix.cs:2862 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.btnRelease_Click

진입점: this.btnRelease2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-867254fe | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2937 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-6b466ef7 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2938 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-9c350fd4 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2946 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-495a6ef1 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2947 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67296a9a | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2967 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47dbffc5 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2968 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7ee2b9e | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2971 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_instanceInfo", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ddc41211 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2972 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_planInfo", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b89118d9 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2976 | if (dtPlanInfo != null) | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fef9d152 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2983 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7b0c38d1 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2987 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a1c2e178 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2988 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a989e67b | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2995 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e7957324 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:2996 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e228218 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3003 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f0981b6f | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3006 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5e35b38e | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3008 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3bbea38a | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3014 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b1be5b6 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3015 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-925524cd | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3028 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3660b50c | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3029 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-55f70be6 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3041 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-0e2f24de | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3044 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-1f36479c | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3045 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b66148c7 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3046 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dc7bc17c | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3056 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-610de286 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3059 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-79b887e3 | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3060 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1660d77c | this.btnRelease2.Click | FP00596_PlanAmend_Line_PreMix.cs:3061 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-feb3a8c0 | this.btnSql.Click | FP00596_PlanAmend_Line_PreMix.cs:3339 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-7c220854 | this.btnSql.Click | FP00596_PlanAmend_Line_PreMix.cs:3342 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bd5f6b57 | this.btnSql.Click | FP00596_PlanAmend_Line_PreMix.cs:3343 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5f49d415 | this.btnSql.Click | FP00596_PlanAmend_Line_PreMix.cs:3345 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00596_AMEND_LINE_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-34b1dcae | this.btnSql.Click | FP00596_PlanAmend_Line_PreMix.cs:3346 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00596_SAVE_VALID_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-32b2b275 | this.btnSql.Click | FP00596_PlanAmend_Line_PreMix.cs:3347 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00596_AMEND_LINE_DATA_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-87680688 | this.btnSql.Click | FP00596_PlanAmend_Line_PreMix.cs:3348 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00596_EXCEL_SELECT_COLTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-809b2624 | this.btnSql.Click | FP00596_PlanAmend_Line_PreMix.cs:3349 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00596_EXCEL_SELECT_ROWTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b72a951c | this.btnSql.Click | FP00596_PlanAmend_Line_PreMix.cs:3350 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2b0a4c6 | this.btnToggleSave.Click | FP00596_PlanAmend_Line_PreMix.cs:2809 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74840d88 | this.button1.Click | FP00596_PlanAmend_Line_PreMix.cs:3120 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.cbo_fpplanid_changed

진입점: cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f67171bd | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2501 | if (cbo_fpplanid.Items.Count > 0) ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-4f3e53c1 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2502 | if (cbo_fpplanid.Items.Count > 0) ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-1d88d1a0 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2509 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-708e81a7 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2510 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-e164828d | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2529 | if (cbo_fpplanid.Items.Count > 0) ▸ if (sReadyOnly.Equals("Y")) | FLAG | bReadOnly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-967d4238 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2533 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (sReadyOnly.Equals("Y")) | FLAG | bReadOnly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6c1abfaf | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2536 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[selected]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-0cac1d83 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2537 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[selected]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-2a37113f | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2538 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[selected]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-69149486 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2539 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[selected]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-cfe851e6 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2540 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[selected]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-163410d5 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2542 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-82530c96 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2543 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-59288561 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2544 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-5f1ddb4f | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2545 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-3d3579eb | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2546 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-d600bbde | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2550 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-2c19c539 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2551 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-da29f242 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2552 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-5aa3e588 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2553 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-32b40fa1 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2554 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-2882ad33 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2556 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-6fd684da | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2557 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-e8d53fd0 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2558 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-50720bd6 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2559 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-d00e7958 | cbo_fpplanid.SelectedIndexChanged | FP00596_PlanAmend_Line_PreMix.cs:2560 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54aeae79 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:1653 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-d335009b | this.Load | FP00596_PlanAmend_Line_PreMix.cs:1653 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-70c10631 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:1655 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00596_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-907e90c0 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:1655 |  | POPUP | new FP00596_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-d706abb8 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:1656 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00596_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eccf3ffd | this.Load | FP00596_PlanAmend_Line_PreMix.cs:1656 |  | POPUP | new FP00596_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.chk_includeSubOp_onchanged

진입점: this.chk_includeSubOp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bc8e928 | this.chk_includeSubOp.CheckedChanged | FP00596_PlanAmend_Line_PreMix.cs:2669 | if (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-2dac0f83 | this.chk_includeSubOp.CheckedChanged | FP00596_PlanAmend_Line_PreMix.cs:2671 | else of (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.chk_Info_CheckedChanged

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8feb42b7 | this.chk_Info.CheckedChanged | FP00596_PlanAmend_Line_PreMix.cs:7070 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f1be9de | this.chk_Info.CheckedChanged | FP00596_PlanAmend_Line_PreMix.cs:7070 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb593e7a | this.chk_Info.CheckedChanged | FP00596_PlanAmend_Line_PreMix.cs:7076 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-e84920dd | this.chk_Info.CheckedChanged | FP00596_PlanAmend_Line_PreMix.cs:7077 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.CreateEditDataGridDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e53cd3d4 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5249 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-dc470b6b | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5250 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ec008b5 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5251 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb1e45f9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5252 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba76c637 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5253 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-133116e1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5254 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-20ae58d0 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5255 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-30c3a038 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5256 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0a25446 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5257 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-16c00c12 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5258 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e80c0ad6 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5259 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcb23189 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5260 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-79b470f9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5261 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5598367 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5262 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ee78db9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5263 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e62eca34 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5264 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-de54a2e4 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5265 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae59eef1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5266 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-77c923c6 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5267 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CUSTOMER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1cbc514 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5268 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e077ca0 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5269 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb52f87f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5270 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-368204c1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5271 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-26c0c6e3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5272 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4658d34a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5273 |  | DATA_OP | dt.Columns.Add | (new DataColumn("WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-99045a1d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5275 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-45286f3d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5276 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fa15311 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5277 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f580810f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5278 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d7cb7d4 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5279 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7147054b | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5281 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ACTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc575cb0 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5283 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.CreateEditSeqDataTable

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA") && iBatch != -1) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sColumnName.IndexOf("_SEQ") >= 0) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (dtList == null)] / bucke_menu.Cli…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b4a07d7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5199 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-ca00b95c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5200 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ddbe4e7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5201 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9396d5d8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5202 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bdc8f8ec | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5203 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7ddac1f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5204 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6f55f8c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5205 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6880012c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5206 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d7f2179 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5207 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-79fa5841 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5208 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fa61e86 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5209 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-57e99330 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5210 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d5ed14e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5211 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EQUIPMENT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fbe199e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5212 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-abd03d1e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5213 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-aad40d67 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5214 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4395fba9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5215 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c275ba4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5216 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5426622d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5217 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0b2f70f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5231 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6e3b7cb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5232 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-468a54e1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5235 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cd13e6e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5237 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f53d5f72 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5238 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f783db7c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5241 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-68cc1f9f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5243 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.CreateExelBufferDataTable

진입점: SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53149821 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5458 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-c20fb0b8 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5459 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4adfd9e | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5460 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3587dd73 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5461 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b32a1784 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5462 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0be8db4 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5463 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8c3c15b | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5464 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a07b868 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5465 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-79910677 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5466 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5b670d5 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5467 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-01db0c66 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5468 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c6703e4 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5469 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-71ff7600 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5470 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EQUIPMENT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a80705f7 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5471 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-26e485e1 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5472 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f73290c | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5473 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f84aef0 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5474 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b60506ae | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5475 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1e91ccd | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5476 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5bc53b89 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5477 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-13900abe | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5478 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfa9a48e | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5479 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e455c13 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5480 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec664689 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5481 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-43f20742 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5482 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JOB_ORDER", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9fa0d9d | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5485 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-909e806a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1662 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-07e7d7bb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1673 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-a49b1a43 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1674 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-c0f0c5f7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1706 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-618aa664 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1710 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-557f15b0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1714 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cac2dea8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1718 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-feb0cab3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1765 | if (measure["chk_off"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "OFF")) | 데이터 객체 조작/조회 |  |  |  |
| AC-65794fe2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1769 | if (measure["chk_setup"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SETUP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d148f036 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1773 | if (measure["chk_capa"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "CAPA")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb614ed8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1781 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_memo_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d0f694f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1783 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-98701ce4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1785 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fee080a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1787 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e996b097 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1793 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e69a387 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1795 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d320ded2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1797 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c651a6c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1812 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a5bea14 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1819 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-da2d6010 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1824 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-81a0dab4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1828 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-1536f769 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1830 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81f06e00 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:407 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-68c9ba1e | this.Load | FP00596_PlanAmend_Line_PreMix.cs:408 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-f4380d7e | this.Load | FP00596_PlanAmend_Line_PreMix.cs:409 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9a220b0 | dCalendar_planrange.ValueChanged | FP00596_PlanAmend_Line_PreMix.cs:2643 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ccc0547e | dCalendar_planrange.ValueChanged | FP00596_PlanAmend_Line_PreMix.cs:2649 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-9d35aee2 | dCalendar_planrange.ValueChanged | FP00596_PlanAmend_Line_PreMix.cs:2650 | if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Delete_buffer_Data

진입점: SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1a71a66 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2051 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Delete_Data_Excel_Buffer

진입점: SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd97c77c | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6193 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-1889949b | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6194 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4fcb4e6a | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6196 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-797b620e | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6197 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-797d484b | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6198 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-ea838f73 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6199 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cdae01a5 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6200 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b486cf5b | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6201 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7da59ece | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6202 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bfaaedc0 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6203 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1ee7e75c | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6204 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7f3080a2 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6205 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-376cf507 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6207 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f1bd7d0e | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6215 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-c372eb5d | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6219 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-8ffbf335 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6220 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a885f266 | DeleteButton | FP00596_PlanAmend_Line_PreMix.cs:880 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c4a84f7 | Dispose | FP00596_PlanAmend_Line_PreMix.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.DrawHeader

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day !=…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b383b991 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6719 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-e567f4e0 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6723 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-ec25b593 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6724 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4f3a9bc | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6725 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e5e220e | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6726 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (2, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d73d7cd3 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6727 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ece116d4 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6728 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-48a004e2 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6732 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-b088b250 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6733 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-5b53052b | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6734 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-43bbfab1 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6735 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-03d01b1d | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6741 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-36f43eba | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6742 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f257502 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6775 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-478767ae | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6782 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e2ff15a | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6783 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e9671573 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6784 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-8c28db19 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6786 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-10e6f64b | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6788 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-19e08760 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6789 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d99ba15 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:6794 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.DrawSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e99790c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6801 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b7da20d8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6804 | if (!in_Dataset.Good()) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-5c21bdee | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6805 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a99c4244 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6816 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-56e7b3de | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6824 | if (dsMainFiltered.Good()) | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIXs, dtCategoryInf… | ⚠ 의미 확인 필요 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4cf6274 | EditButton | FP00596_PlanAmend_Line_PreMix.cs:888 | if (spdMain != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9683d0b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00596_PlanAmend_Line_PreMix.cs:3446 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75dc9c38 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00596_PlanAmend_Line_PreMix.cs:3447 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-dc062942 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00596_PlanAmend_Line_PreMix.cs:3448 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-ad205bee | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00596_PlanAmend_Line_PreMix.cs:3450 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afaba321 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00596_PlanAmend_Line_PreMix.cs:3461 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-e4fce74f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00596_PlanAmend_Line_PreMix.cs:3462 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8da90258 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3503 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee49bc54 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3504 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-676ca8d4 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3505 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-87137e31 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3507 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10b3b50a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3515 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-0b2373a6 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3516 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9f2b702 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3521 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.EditByFunc

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA") && iBatch != -1) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / bucke_menu.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef7888d8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00596_PlanAmend_Line_PreMix.cs:3472 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24963b6e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00596_PlanAmend_Line_PreMix.cs:3474 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-9dd5f30c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00596_PlanAmend_Line_PreMix.cs:3475 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-dfe91204 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00596_PlanAmend_Line_PreMix.cs:3477 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f03024f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00596_PlanAmend_Line_PreMix.cs:3487 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e5c577e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00596_PlanAmend_Line_PreMix.cs:3493 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce4095cf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00596_PlanAmend_Line_PreMix.cs:3495 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.EditCommon

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA") && iBatch != -1) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / bucke_menu.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-127de596 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:3557 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sColumnName.IndexOf("_SEQ") >= 0) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f8a4437 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:3568 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SEQ") >= 0) ▸ if (sColumnName.IndexOf("_BATCH"… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-917b4b28 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:3571 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SEQ") >= 0) ▸ if (sColumnName.IndexOf("_BATCH"… | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-924078aa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:3572 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SEQ") >= 0) ▸ if (sColumnName.IndexOf("_BATCH"… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-831945a9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:3577 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SEQ") >= 0) ▸ if (sColumnName.IndexOf("_BATCH"… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e09a8464 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:3581 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SEQ") >= 0) ▸ if (sColumnName.IndexOf("_BATCH"… | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-18722086 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:3582 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SEQ") >= 0) ▸ if (sColumnName.IndexOf("_BATCH"… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09f44783 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:3597 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SEQ") >= 0) ▸ else of (sColumnName.IndexOf("_B… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca0ca421 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00596_PlanAmend_Line_PreMix.cs:1014 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-514965ac | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00596_PlanAmend_Line_PreMix.cs:1018 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d567b4f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00596_PlanAmend_Line_PreMix.cs:1022 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-8a8438d2 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00596_PlanAmend_Line_PreMix.cs:1026 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5a48bf8d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00596_PlanAmend_Line_PreMix.cs:2365 |  | EXCEL | ExportExcel | (0,true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76bce99c | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:982 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-5994c23a | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:983 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-f44b99a4 | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:984 |  | UI_PROP | select_popup.MergeSelection | ExcelMergeOption.Casecaded | 속성 MergeSelection 설정 |  |  |  |
| AC-42598ce7 | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:985 |  | UI_PROP | select_popup.ZeroSelection | ZeroOption.ShowZero | 속성 ZeroSelection 설정 |  |  |  |
| AC-1e6d82de | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:986 |  | UI_PROP | select_popup.LineSelection | ExcelBorderOption.None | 속성 LineSelection 설정 |  |  |  |
| AC-e06f6b94 | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:988 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8b7b2196 | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:992 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-9a3b5500 | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:993 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-8a77202c | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:994 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-0d1a83bb | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:997 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-61b90bef | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:998 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-443ea1dc | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:999 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-2403f8aa | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:1001 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-79d11597 | ExcelButton | FP00596_PlanAmend_Line_PreMix.cs:1002 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.ExcelPopup_BufferValidation_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24359a39 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5717 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ca619f7c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5741 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-810e935e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5743 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c6931dd1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5744 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-61da4ca4 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5745 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-58bf87a7 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5746 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ab2179e1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5747 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-851c8d25 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5748 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4c834f0d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5749 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-37eb7cad | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5750 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-11a45503 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5751 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-65a0284b | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5752 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ca2ec5e9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5753 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-56b57199 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5754 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["EQUIPMENT_ID"] | data.Tables[0].Rows[i]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-55d50be5 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5755 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8973ec3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5756 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ad5ecefc | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5757 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c8a45f62 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5758 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-09955820 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5759 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sQtyCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a2a3fcaa | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5760 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SEQ"] | data.Tables[0].Rows[i][sSeqCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-62c4b9be | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5769 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | data.Tables[0].Rows[i][sQtyCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-da504afc | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5770 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | nIn_KG | 행/컬럼 값 대입 |  |  |  |
| AC-1a170076 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5771 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Math.Round(Convert.ToUInt32(data.Tables[0].Rows[i][sQtyCol].ToString()) * nYield, 2) | 행/컬럼 값 대입 |  |  |  |
| AC-a2672834 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5771 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | CALL_EXT | Convert.ToUInt32 | (data.Tables[0].Rows[i][sQtyCol].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-93f90259 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5772 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Math.Ceiling(nIn_KG * nYield) | 행/컬럼 값 대입 |  |  |  |
| AC-2edf7c61 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5774 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-84554581 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5775 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0fbaace3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5778 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-99fa214b | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5787 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-62b11259 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5811 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-af9f7b9f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5816 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-31939ebb | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5818 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-62592f27 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5821 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-41b7fa66 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5832 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e1d7b272 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5837 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-8a3a3304 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5842 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35fbd991 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5843 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.ExcelPopup_BufferValidation_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbd203de | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5890 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4fcec899 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5892 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9cdaf853 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5893 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | data.Tables[0].Rows[i]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5e9a3008 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5894 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6f0dc22d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5895 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06be6189 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5896 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e1d1f662 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5897 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-059d8085 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5898 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-82274790 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5899 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-976c4a5c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5900 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2d191258 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5901 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-20792987 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5902 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3a343a1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5903 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["EQUIPMENT_ID"] | data.Tables[0].Rows[i]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9a51cffd | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5904 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-75f502ee | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5905 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-85cd4ef4 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5906 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ec46ce95 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5907 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7bce77e0 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5908 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8c734af8 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5909 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SEQ"] | data.Tables[0].Rows[i]["SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-78f73f8a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5918 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2d1adf26 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5919 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | nIn_KG | 행/컬럼 값 대입 |  |  |  |
| AC-ded850f5 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5920 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Math.Round(Convert.ToUInt32(data.Tables[0].Rows[i]["QTY"].ToString()) * nYield, 2) | 행/컬럼 값 대입 |  |  |  |
| AC-8a4ababe | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5920 | try ▸ for (i < data.Tables[0].Rows.Count) | CALL_EXT | Convert.ToUInt32 | (data.Tables[0].Rows[i]["QTY"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d97883df | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5921 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Math.Ceiling(nIn_KG * nYield) | 행/컬럼 값 대입 |  |  |  |
| AC-bee0186a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5923 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b859beb1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5924 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-304f904c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5927 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3378e09c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5930 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ac9ed2c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5950 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ lambda | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dac77d11 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5955 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d4a3dc30 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5957 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7ea8874 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5960 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) ▸ if (d… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-d6094922 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5968 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-7007e245 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5973 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-bd32a5fe | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5978 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0212b33d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5979 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.ExcelPopup_CheckBeforSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c211656 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5498 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Save cannot proceed Release.!") | 메시지 표시 |  |  |  |
| AC-b71bffbe | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5499 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6fca3898 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5504 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bdef2cdb | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5509 | try ▸ if (dtChk.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-ceaa4552 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5510 | try ▸ if (dtChk.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-87fb99e2 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5515 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-26959e6b | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5519 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.ExcelPopup_SaveExcel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef8b1749 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6072 | if (data.Tables[0].Rows.Count > 0) | DATA_OP | Filter["MPP_WPP"] | filter["MPP_WPP"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-854aa31b | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6082 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.ExcelPopup_SaveExcel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9201b69a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6131 | if (data.Tables[0].Rows.Count > 0) | DATA_OP | Filter["MPP_WPP"] | filter["MPP_WPP"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-549cc88a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6141 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.ExcelPopup_Search_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18126eb8 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5554 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-e6af4ca5 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5555 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-29542405 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5570 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-c0e860a6 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5571 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-0fee11cc | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5572 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-673b8d3f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5574 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-e02f4376 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5583 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-2028b5d7 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5585 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.ExcelPopup_Search_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1e856fa | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5598 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-ca1f6143 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5599 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-072e0edd | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5615 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-6c0db92f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5616 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-3ba902c3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5617 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-54147c80 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5619 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-984fcae3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5629 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-f1551163 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5631 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Exec_Procedure

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE")] / SaveButton [try ▸ if (bSaveChk == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55a22e2f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2314 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-53489781 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2315 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8985cd1f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2317 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-c22f0def | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2318 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-0ddc2343 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2319 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-46aa5061 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2320 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e2eda4fb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2322 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-cb4be5cd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2323 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5dc57f77 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2324 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-b8d3c7be | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2325 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-488612af | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2326 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5474a536 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2327 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-279c5364 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2328 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dd5d03fe | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2329 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a81c9630 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2330 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3e721cc3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2331 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-599d4a6a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2332 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f65426b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2333 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-247444ab | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2334 | try | DATA_OP | req.Parameters["p_equipment_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-50a32b5a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2335 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65283784 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2336 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1bc992ad | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2337 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-10f7977d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2338 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-72c5cfeb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2339 | try | DATA_OP | req.Parameters["p_seq"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-788c16b7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2341 | try | DATA_OP | req.Parameters["p_adjust_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6ebfaea3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2342 | try | DATA_OP | req.Parameters["p_adjust_in_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4c8570ba | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2343 | try | DATA_OP | req.Parameters["p_adjust_in_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8150a4de | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2344 | try | DATA_OP | req.Parameters["p_adjust_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-33e68b28 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2345 | try | DATA_OP | req.Parameters["p_adjust_out_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eb1d13a1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2346 | try | DATA_OP | req.Parameters["p_adjust_out_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d4ef53ac | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2348 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a034f6fd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2355 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-37871fbd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2359 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SELECT")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.Need…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-214b82a7 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1131 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-57db9429 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1132 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ffab7d10 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1133 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-e406a35f | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1134 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-92a7b134 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1135 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-05cb7d76 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1136 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2959b6fc | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1138 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b38d508c | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1139 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-68869ac9 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1140 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4af31dfb | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1141 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-83a23ad4 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1142 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-329c1241 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1143 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a4112618 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1144 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-207f6265 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1145 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-168542fe | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1146 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-37a4bf32 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1147 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-da8d1a91 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1148 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3d391c5f | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1149 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-351fc8c8 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1150 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7c049c74 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1151 | try | DATA_OP | request.Parameters["p_top_item_id"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d6e24aa7 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1152 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e4364b0c | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1153 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-4b4c5cbd | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1154 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | Filter["NICK_NAME_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-ecb5a12d | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1155 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-913eba97 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1156 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-16377a20 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1157 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-7333e35c | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1158 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-e131e3e3 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1159 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-4099c128 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1160 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-502d4516 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1161 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e17326a3 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1162 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a43dbe09 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1163 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6ac3b673 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1164 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-fbcbb450 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1165 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-99fdf3a2 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1166 | try | DATA_OP | request.Parameters["p_amend_boh_table"] | Filter["AMEND_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-786a3917 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1167 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b8a992a4 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1168 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c019d7ba | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1169 | try | DATA_OP | request.Parameters["p_amend_capa_table"] | Filter["AMEND_CAPA_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-acdc5f46 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1171 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f1e38172 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1172 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0e5efe35 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_SEL… 외 7 | FP00596_PlanAmend_Line_PreMix.cs:1177 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Find_Data_CWA_Minus_Activated

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc6b5057 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1189 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-050be551 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1190 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-272ceeea | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1191 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-0953f5c6 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1192 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_CWA_MINUS_ACTIVED" | 행/컬럼 값 대입 |  |  |  |
| AC-b6e1d149 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1193 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a8f3cab9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1194 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2e0bb850 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1196 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fe178b87 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1197 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c3a0f522 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1198 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d1c7b9df | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1199 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-05d9ee7a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1200 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-60a43274 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1201 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d1775c8a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1202 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4a6eb8c7 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1203 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-220d09f3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1204 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ad730c05 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1205 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-58a4ef0e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1206 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ba00db62 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1207 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ea7184c8 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1208 | try | DATA_OP | request.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b2c8db3e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1209 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0b7aa43a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1210 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c5a5a887 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1211 | try | DATA_OP | request.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-00748f3c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1212 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-95c9da59 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1213 | try | DATA_OP | request.Parameters["p_bucket_from"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a864f9e2 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1214 | try | DATA_OP | request.Parameters["p_bucket_to"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-99bb8044 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1215 | try | DATA_OP | request.Parameters["p_day_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a6f8723e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1216 | try | DATA_OP | request.Parameters["p_week_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7593b69d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1217 | try | DATA_OP | request.Parameters["p_month_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f34975d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1218 | try | DATA_OP | request.Parameters["p_cate_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-38dbdc8f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1219 | try | DATA_OP | request.Parameters["p_cate_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e75d10e6 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1220 | try | DATA_OP | request.Parameters["p_cate_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-56223031 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1221 | try | DATA_OP | request.Parameters["p_amend_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-17d6bc4a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1222 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ad533cea | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1223 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-24b991e5 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1224 | try | DATA_OP | request.Parameters["p_amend_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c07e82e3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1225 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9ee6072a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1226 | try | DATA_OP | request.Parameters["p_amend_util_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0741d9a8 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1227 | try | DATA_OP | request.Parameters["p_amend_capa_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f01d98b1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1229 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35fefc17 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1230 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d4654709 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1235 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Find_Data_Excel_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78525672 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6035 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-153473de | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6036 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bf4164e1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6038 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-d2c9a257 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6039 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4014778a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6040 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b41350da | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6041 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-207c5670 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6042 | try | DATA_OP | request.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-92e3b01e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6043 | try | DATA_OP | request.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-6b9bc141 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6044 | try | DATA_OP | request.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-19efe0a7 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6045 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cf9cdfd0 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6046 | try | DATA_OP | request.Parameters["p_site_id"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-3dcc2396 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6047 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4752610d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6049 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-93222266 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6051 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-6ba7f119 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6056 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Find_Data_Excel_Import

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE") ▸ if (popup != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3feab85 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5647 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL | 엔드포인트 요청 생성 |  |  |  |
| AC-ed31727b | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5648 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f49cf095 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5650 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-32bae17b | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5651 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9c25129a | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5652 | try | DATA_OP | request.Parameters["p_sys_gubun"] | gubun | 행/컬럼 값 대입 |  |  |  |
| AC-b67e7ac8 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5653 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c49725fd | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5654 | try | DATA_OP | request.Parameters["p_proc_name"] | procedure_name.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-e7e4c1fb | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5663 | try ▸ if (dsParameter != null && dsParameter.Rows != null && dsParameter.Rows.Count > 0) | CALL_EXT | param.Keys | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-461de9a4 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5677 | try | DATA_OP | request.Parameters["in_columns"] | keys | 행/컬럼 값 대입 |  |  |  |
| AC-e7849247 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5678 | try | DATA_OP | request.Parameters["in_row"] | values | 행/컬럼 값 대입 |  |  |  |
| AC-a34871a3 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5679 | try | DATA_OP | request.Parameters["opt_none"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-990d2775 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5681 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-186d1dbe | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5683 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-a3f0e231 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5688 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-dab1fdf1 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5690 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Find_Save_Valid

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SELECT")] / SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd484712 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2114 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-2f103f44 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2115 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-19ce8529 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2116 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-c8cdaa47 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2117 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8f63959e | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2118 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a1af3632 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2120 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d631865d | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2121 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6f5e193e | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2122 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2112f7ab | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2123 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-402effa1 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2124 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b5826032 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2125 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-959ab167 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2126 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8b87c10c | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2127 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-37d4f76f | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2128 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-890168fb | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2129 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-3be8ccd0 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2130 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5b38c643 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2131 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-10052292 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2132 | try | DATA_OP | request.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-508e535d | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2133 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d8e8ae56 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2134 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-80227c5c | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2135 | try | DATA_OP | request.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eacc09d5 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2136 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-32861250 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2137 | try | DATA_OP | request.Parameters["p_bucket_from"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7b1323c0 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2138 | try | DATA_OP | request.Parameters["p_bucket_to"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b8b35c43 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2139 | try | DATA_OP | request.Parameters["p_day_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d989e81 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2140 | try | DATA_OP | request.Parameters["p_week_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b80c499d | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2141 | try | DATA_OP | request.Parameters["p_month_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b995c819 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2142 | try | DATA_OP | request.Parameters["p_cate_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c0991613 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2143 | try | DATA_OP | request.Parameters["p_cate_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2425930e | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2144 | try | DATA_OP | request.Parameters["p_cate_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-025ba974 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2145 | try | DATA_OP | request.Parameters["p_amend_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-11b27126 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2146 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d361d3bd | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2147 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-096474ab | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2148 | try | DATA_OP | request.Parameters["p_amend_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4c5311b9 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2149 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c36e5ac6 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2150 | try | DATA_OP | request.Parameters["p_amend_util_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f771d968 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2151 | try | DATA_OP | request.Parameters["p_amend_capa_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-021cfe8c | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2153 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6fb2dbf4 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2155 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c2cf6f39 | popSql.OnSql [if (programID == "PR_UI_FP00596_SAVE_VALID_SEL… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2161 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.FindTotalColorStart

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtP…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-882c87e5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1853 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.FindTotalValue

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnBucket.Click [if (frm.DialogResult == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8add5f07 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1051 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-34765817 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1052 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-e39b4b0f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1053 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_TOTAL_VALUE" | 행/컬럼 값 대입 |  |  |  |
| AC-035b048e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1054 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ed6fab88 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1055 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b18834d9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1057 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ce6caebd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1058 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-276c078e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1059 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f9f4147f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1060 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-52991f5c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1061 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e97e3fb7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1062 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-415f676f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1063 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-37d831e0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1064 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0d5315c4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1065 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5ea0d3a2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1066 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-731bc19b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1067 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d04bfdb7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1068 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-042bc1b0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1069 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2b5ca385 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1070 | try | DATA_OP | request.Parameters["p_top_item_id"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b4b365aa | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1071 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e9309162 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1072 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-44f5ffff | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1073 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | Filter["NICK_NAME_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-467b0394 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1074 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-a7c19b63 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1075 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-27e1bb26 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1076 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-af9dabe4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1077 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-a9462532 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1078 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-121be6dc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1079 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-7c0df027 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1080 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-5f48f03f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1081 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-900ab38d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1082 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4c504ac7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1083 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7163c48e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1084 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b7383ddf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1085 | try | DATA_OP | request.Parameters["p_amend_boh_table"] | Filter["AMEND_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-91f33520 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1086 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d19a967b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1087 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b5885d0a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1088 | try | DATA_OP | request.Parameters["p_amend_capa_table"] | Filter["AMEND_CAPA_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-cbe0e3cb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1090 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bdee816a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1093 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-d372ce2e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:1101 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fc6fdd2 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:226 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.GetDayColNameOfType_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasureName[i]].Value.Equals("true"))] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Wee…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7775f07 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:569 |  | RETURN | return day.Value + date_append_name; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE") ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad &…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-886d2cc8 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:4073 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.GetListDataSet

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tab…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac23b3a2 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1403 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_ListData", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a18a7eb6 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1405 |  | FLAG | dsListData | dtList.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-410f0fbf | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1405 |  | DATA_OP | dtList.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a728b355 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1406 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_UOMInfo", Filter["DIVISION_ID"].ToString(), Filter["SITE_ID… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f161f6c | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1408 |  | FLAG | dsUomInfo | dtUom.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-54289559 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1408 |  | DATA_OP | dtUom.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-28fb16fd | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1410 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_YieldInfo_Child", Filter["INSTANCE_ID"].ToString(), Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-540cbaae | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1413 |  | FLAG | dsYieldInfo | dtYield.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6244fc39 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1413 |  | DATA_OP | dtYield.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.GetMonthColNameOfType_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length -1) ▸ if (measure[_sMeasureName[i]].Value.Equals("true"))] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe1d46fc | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:573 |  | RETURN | return month.Value + month_append_name; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.GetOperation

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fdf6c67 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7391 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-395bd7de | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7391 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9aa4fadb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7393 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7846ed1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5191 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-6e9d91a1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5192 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.GetToDay

진입점: sCalendar_planday.DateTimeChanged / popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE") ▸ lambda ▸ else of (dt != null)] / this.btnExcelImport.Click [else of (dt != null)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda ▸ else of (dt != null)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e95479a | sCalendar_planday.DateTimeChanged 외 9 | FP00596_PlanAmend_Line_PreMix.cs:4397 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-60a3b585 | sCalendar_planday.DateTimeChanged 외 9 | FP00596_PlanAmend_Line_PreMix.cs:4398 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.GetWeekColNameOfType_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length -1) ▸ if (measure[_sMeasureName[i]].Value.Equals("true"))] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d8f3512 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:565 |  | RETURN | return week.Value + week_append_name; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72c125a5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1513 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ for (i < current_sr… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex_batch, rowindex, colindex_batch, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1853b28e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1515 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ for (i < current_sr… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex_seq, rowindex, colindex_seq, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82573994 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1528 | if (do_edit_mode) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1da2e7a9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1538 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.LockRange | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2885bf4f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1539 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-84b10b5e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1553 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (calendar != null) ▸ foreach (var week_item in calendar.Weeks) ▸ if (wee… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-45075b7f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:1570 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (m… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba84a384 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:303 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ccd02514 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:307 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-708f2d4d | this.Load | FP00596_PlanAmend_Line_PreMix.cs:308 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7681b687 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:312 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-3f80a1b9 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:314 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-91c65f8c | this.Load | FP00596_PlanAmend_Line_PreMix.cs:318 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4581f40 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:326 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-aeb3a1bf | this.Load | FP00596_PlanAmend_Line_PreMix.cs:331 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-2008fde7 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:333 | try | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-de3c5d49 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:345 | try | FLAG | _sToDay | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-281fe7c0 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:354 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-1cdaed90 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:355 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4624d69d | this.Load | FP00596_PlanAmend_Line_PreMix.cs:356 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e214adb9 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:357 | try ▸ if (adminAuth == false) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5713fbd9 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:360 | try | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0904bdf2 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:366 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.InitEditingBuf

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmen…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08bd9882 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:4403 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fe87040b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:4404 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-e1e7747d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:4405 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-d2ec63c1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:4406 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a3d1c228 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:4407 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-4161b555 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:4408 |  | FLAG | dlData | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8dcc6a26 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:4409 |  | FLAG | dlView | null | 화면 필드/플래그 변경 |  |  |  |
| AC-562dbfde | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:4410 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30b507f3 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:267 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-915e996a | this.Load | FP00596_PlanAmend_Line_PreMix.cs:268 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-931116fa | this.Load | FP00596_PlanAmend_Line_PreMix.cs:269 |  | UI_PROP | mcbo_nicknamelt.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f3dfcf4d | this.Load | FP00596_PlanAmend_Line_PreMix.cs:270 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d40788ba | this.Load | FP00596_PlanAmend_Line_PreMix.cs:271 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-fc26b7fc | this.Load | FP00596_PlanAmend_Line_PreMix.cs:272 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-78453e77 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:273 |  | UI_PROP | mcbo_planner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ee3a53de | this.Load | FP00596_PlanAmend_Line_PreMix.cs:274 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.InitSpread

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45f04a89 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:422 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d010c4b | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:423 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2d2b5c7f | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:425 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-14790e08 | this.Load 외 11 | FP00596_PlanAmend_Line_PreMix.cs:429 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Insert_Buffer_Data

진입점: SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b722c75 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2065 | for (i < data.Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c9db09e6 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2067 | for (i < data.Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c4332c1a | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2068 | for (i < data.Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | data.Rows[i]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-657438da | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2069 | for (i < data.Rows.Count) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-38e1cb15 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2070 | for (i < data.Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8a100025 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2071 | for (i < data.Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c8e7950c | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2072 | for (i < data.Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8ef6b392 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2073 | for (i < data.Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f837bbb2 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2074 | for (i < data.Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0cf78d32 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2075 | for (i < data.Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-531058f2 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2076 | for (i < data.Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b9ce5726 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2077 | for (i < data.Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54af29dd | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2078 | for (i < data.Rows.Count) | DATA_OP | newrow["EQUIPMENT_ID"] | data.Rows[i]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29dd8f6d | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2079 | for (i < data.Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-30d0c264 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2080 | for (i < data.Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d63659b5 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2081 | for (i < data.Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2abb4ddb | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2082 | for (i < data.Rows.Count) | DATA_OP | newrow["MARKET"] | data.Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b1be0ec7 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2083 | for (i < data.Rows.Count) | DATA_OP | newrow["QTY"] | data.Rows[i]["ADJUST_OUT_QTY_BATCH"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-46d73f05 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2084 | for (i < data.Rows.Count) | DATA_OP | newrow["SEQ"] | data.Rows[i]["SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8bf1686e | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2086 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | Convert.ToDouble(data.Rows[i]["ADJUST_IN_QTY_BATCH"]) | 행/컬럼 값 대입 |  |  |  |
| AC-cf993f45 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2087 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | Convert.ToDouble(data.Rows[i]["ADJUST_IN_QTY_KG"]) | 행/컬럼 값 대입 |  |  |  |
| AC-03c7e5f7 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2088 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Convert.ToDouble(data.Rows[i]["ADJUST_OUT_QTY_BATCH"]) | 행/컬럼 값 대입 |  |  |  |
| AC-cedbca45 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2089 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Convert.ToDouble(data.Rows[i]["ADJUST_OUT_QTY_KG"]) | 행/컬럼 값 대입 |  |  |  |
| AC-391fca15 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2093 | for (i < data.Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6a58714e | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2094 | for (i < data.Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bfc0ebce | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2097 | for (i < data.Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-996ef5a0 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2100 |  | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-7270ccbb | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2104 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Insert_Data_Excel_Buffer

진입점: SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-741a4519 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5992 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00596_EXCELIMPORT", "insert_Excel_buffer", dsData) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-c97847e9 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:5996 | try ▸ if (result.Good()) | DATA_OP | result.Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-81eec47c | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6008 | try ▸ if (result.Good()) ▸ if (result.Columns.Contains("RESULT")) ▸ else of (result.Rows[0]["RESULT"].ToString().ToUpper() == "SUCCESS") ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b61558a | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6016 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-418b77e3 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6020 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-64d80e76 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:6021 | catch ((Exception ex)) | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fafb571 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:834 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-faae641b | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:839 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | MESSAGE | MessageBox.Show | ("Can not be selected [Total] Row.!") | 메시지 표시 |  |  |  |
| AC-3a7ebc28 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:840 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e0a30cd | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:844 | if (row != null) | POPUP | new FP00596_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-9e3153ce | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:845 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-22979a09 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:845 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f054c31e | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:847 | if (row != null) | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b7669b3 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:848 | if (row != null) | DATA_OP | popup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a812eeba | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:849 | if (row != null) | DATA_OP | popup.Filter["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4caf883c | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:850 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-850b6461 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:851 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9bbb8dd6 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:852 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e6add41c | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:853 | if (row != null) | DATA_OP | popup.Filter["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a6392ff3 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:854 | if (row != null) | DATA_OP | popup.Filter["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b98656c | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:855 | if (row != null) | DATA_OP | popup.Filter["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a2f9edd | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:856 | if (row != null) | DATA_OP | popup.Filter["NICK_NAME"] | row["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5d0b208 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:857 | if (row != null) | DATA_OP | popup.Filter["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e509af7e | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:858 | if (row != null) | DATA_OP | popup.Filter["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0c1a9c60 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:859 | if (row != null) | DATA_OP | popup.Filter["MARKET"] | row["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ab44cde3 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:861 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b6117320 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:863 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c1eb7e75 | InsertButton | FP00596_PlanAmend_Line_PreMix.cs:872 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf22ea7d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:2373 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00596_PlanAmend_Line_PreMix.lfn_getYieldInfo

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA") && iBatch != -1) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SEQ") >= 0) ▸ if (sColumnName.IndexOf("_BATCH") >= 0) ▸ if (sCateID.Equals("P_IN")) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e3575f4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4827 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_YieldInfo", pDivision, pSite, pPlant, pFactory, pOperation,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-787d9cb9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4833 | if (dtYieldOut != null) ▸ if (dtYieldOut.Rows.Count ==0) | RETURN | return nVal; |  | 처리 중단/반환 |  |  |  |
| AC-41583670 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4842 |  | RETURN | return nVal; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.lfn_getYieldInfo_Excel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e00c131 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6329 | if (!string.IsNullOrEmpty(sColName) && sDay == "") ▸ lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ec840bb | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6345 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e22cef5 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6346 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-be75d81a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6347 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-df0a9279 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6348 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-11c6e9f3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6349 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8dac8505 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6350 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b3dc1fd4 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6350 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-31d9e34e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6365 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.lfn_setAvailability

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3be47ec | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5093 | if (measure["chk_act"].Value != "true" \|\| measure["chk_actSim"].Value != "true" \|\| measure["chk_outqty"].Value != "true") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58b96932 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5156 | for (i < nEndTmp) ▸ if (nRow_Act != -1) | GRID_SET | siMain.ActiveSheet.Cells[nRow_Act, siMain.GetColumnIndex(sCol)].Value | Math.Round(dValue) | 그리드 속성/값 설정 |  |  |  |
| AC-29d24502 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5169 | for (i < nEndTmp) ▸ if (nRow_ActSim != -1) | GRID_SET | siMain.ActiveSheet.Cells[nRow_ActSim, siMain.GetColumnIndex(sCol)].Value | Math.Round(dValue) | 그리드 속성/값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.lfn_setExchangeBatch

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA") && iBatch != -1) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SEQ") >= 0) ▸ if (sColumnName.IndexOf("_BATCH") >= 0) ▸ if (sCateID.Equals("P_IN")) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1679c7ed | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4856 | else of (sAppendex.Equals("KG")) | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-58c68e0c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4865 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f302b31 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4866 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-040593d2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4867 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-222fbfed | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4868 | lambda | DATA_OP | x.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-1948766f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4865 | lambda | RETURN | return (x.Field<string>("FACTORY_ID") == row["FACTORY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-dc39f8e7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4891 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ac317d4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4892 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1cf14b94 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4893 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-90fc4fec | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4894 | lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a83cc77 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4895 | lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c9f868e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4896 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a865ded | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4897 | lambda | DATA_OP | x.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-16d7c7e1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4897 | lambda | DATA_OP | x.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6b54639 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4891 | lambda | RETURN | return (x.Field<string>("FACTORY_ID") == row["FACTORY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-f435aea7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4917 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.lfn_setExchangeBatch_Excel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b661505 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6240 | if (!string.IsNullOrEmpty(sColName) && sDay == "") ▸ lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-313f87e4 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6262 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-10840d75 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6269 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-57f87c58 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6270 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-19972151 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6271 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd557449 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6272 | lambda | DATA_OP | each_row.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-314a141f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6289 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0ab0ce9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6290 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0efc749c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6291 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec23a5c7 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6292 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fde96f60 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6293 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-955bf6ae | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6294 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f935f84 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6294 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e2d3339 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6312 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.lfn_setReleaseProcess

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20c48698 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1378 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26c6babe | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1392 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ if (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCurrDate… | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-32aa82a1 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1394 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ else of (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCur… | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-a5be8b40 | popSql.OnSql [if (programID == "PR_UI_FP00596_EXCEL_SELECT_C… 외 8 | FP00596_PlanAmend_Line_PreMix.cs:1398 |  | RETURN | return dtMapData; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.MakeMemoFontBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-980c51a8 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1617 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-1172bdae | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1621 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |
| AC-8eefd0e6 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1632 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-cc9d8fe8 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1636 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.onAlarmMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64b49ff1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3984 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b18f1f6f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3987 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-026b2588 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3991 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), DAY_SUFFIXs) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c13da324 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3995 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba681496 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3995 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d08d160 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3997 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-2f650908 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3998 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-aff03653 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3998 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-785dae86 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3999 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-ced6af66 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:4000 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1c4d6fe2 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:4001 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8bada4e4 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:4005 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-db0682aa | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:4007 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e8c906e3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:4012 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afeadb11 | memo_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:3966 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0423a63 | memo_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:3969 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ef0e975 | memo_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:3973 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), DAY_SUFFIXs) | ⚠ 의미 확인 필요 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.onNLFAmendMenu

진입점: nlfamend_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b09ab590 | nlfamend_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:4022 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-924536af | nlfamend_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:4025 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9902822b | nlfamend_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:4043 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-f1c6cfcc | nlfamend_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:4044 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-06ca70fb | nlfamend_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:4045 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e3c7911b | nlfamend_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:4046 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6e8f5143 | nlfamend_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:4047 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-0bf67db2 | nlfamend_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:4048 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-fe8a2249 | nlfamend_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:4049 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-21be7d48 | nlfamend_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:4050 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ee7eed82 | nlfamend_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:4051 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cfe9720 | bucke_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:3704 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50f6533b | bucke_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:3707 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.onZeroLineMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab46bd30 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3762 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cfb8c9d1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3765 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-519e3375 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:3816 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.onZeroMaterialMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09b5b40d | bucke_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:3871 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a1e4eaa | bucke_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:3874 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c601c42 | bucke_menu.Click | FP00596_PlanAmend_Line_PreMix.cs:3919 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e80a1ce | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7368 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-e75fb1ee | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7368 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-192ab8ce | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7370 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-ac2d8634 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7371 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-49b2d72a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7371 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7517e54c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7372 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-9176b03e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7373 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c7437df2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7374 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a94ab22c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7378 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2532f70a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7380 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ed41cf67 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7385 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4de0c344 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7328 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-5e50affe | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7329 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-afc823e9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7330 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-863d7ada | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7330 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9f809f4f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7331 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-6e707af3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7332 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-163f3d58 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7333 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bfa6b4e0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7337 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e35d2207 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7339 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38d4baef | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7345 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-f70638a4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7346 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-43e27231 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7347 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-e2315ddc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7347 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ddb8c271 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7348 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-491b8cbe | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7349 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-26eaee28 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7350 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f79d695d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7354 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7844aa84 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7356 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.planday_changed

진입점: sCalendar_planday.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2daf0aef | sCalendar_planday.DateTimeChanged | FP00596_PlanAmend_Line_PreMix.cs:2456 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1dcd6fdb | sCalendar_planday.DateTimeChanged | FP00596_PlanAmend_Line_PreMix.cs:2460 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-5c8cd485 | sCalendar_planday.DateTimeChanged | FP00596_PlanAmend_Line_PreMix.cs:2467 | else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Query

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-865f4e54 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6843 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-b7cef9b8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6843 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-225ebd9a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6844 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c9e539b4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6849 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-3671b074 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6872 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-f1a69b2e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6878 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-12090bc1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6878 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7cf71f93 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6879 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-116b79ca | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6879 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-46a17334 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6882 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-45ccb1a1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6889 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-c02a284b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6894 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIXs) | ⚠ 의미 확인 필요 |  |  |  |
| AC-929a264a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6895 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0948699 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6897 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIXs, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.RefreshHeadAndBody

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28c0cb1e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6684 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-23f37b30 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6700 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-bdc11ff9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6704 | finally | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a8432d6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6705 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-097c2815 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6665 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad6e3219 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6665 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-0a6ff2b9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6672 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-451a873d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6677 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92067eb2 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5291 | if (programID == "PR_UI_FP00596_AMEND_LINE_SELECT") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-10899ea4 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5295 | if (programID == "PR_UI_FP00596_SAVE_VALID_SELECT") | RETURN | return Find_Save_Valid("SQL", "FIND_AMEND_VALIDATION_PMIX"); |  | 처리 중단/반환 |  |  |  |
| AC-0ad6815d | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5310 | if (programID == "PR_UI_FP00596_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELE… | MESSAGE | MessageBox.Show | ("there can't Veiw Query[Relase].") | 메시지 표시 |  |  |  |
| AC-f3775083 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5311 | if (programID == "PR_UI_FP00596_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELE… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-3c748e4a | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5315 | if (programID == "PR_UI_FP00596_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == … | CALL_EXT | dtData.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a72daf5 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5317 | if (programID == "PR_UI_FP00596_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == … | RETURN | return Save_Data_Amend(dtSaveTmp, "MERGE_DATA", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-6f4a2d01 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5322 | if (programID == "PR_UI_FP00596_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_OUT_CELL.") | 메시지 표시 |  |  |  |
| AC-e0ad24b0 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5323 | if (programID == "PR_UI_FP00596_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5b8362e9 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5328 | if (programID == "PR_UI_FP00596_AMEND_LINE_DATA_SAVE") ▸ else of (dtData != null) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_OUT_CELL.") | 메시지 표시 |  |  |  |
| AC-14181705 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5329 | if (programID == "PR_UI_FP00596_AMEND_LINE_DATA_SAVE") ▸ else of (dtData != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c8c92eaf | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5340 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE") | POPUP | new FP00607_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8188e075 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5344 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.DateColumnType | FPExtensions.DateColumnType.CELL | 속성 DateColumnType 설정 |  |  |  |
| AC-d3d30abd | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5346 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-718738ed | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5347 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-afb22a2f | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5348 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-146d4788 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5350 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-25d1f379 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5357 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00596_AMEND_LINE_EXCEL", Filter,… |  | 처리 중단/반환 |  |  |  |
| AC-9dbded62 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5369 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_ROWTYPE") | POPUP | new FP00607_RowExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d12bb4bc | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5374 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-8ee9acaf | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5375 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-2bc07fc2 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5376 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-2a08b2e4 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5378 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-01fd3203 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5384 | if (programID == "PR_UI_FP00596_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00596_AMEND_LINE_EXCEL", Filter,… |  | 처리 중단/반환 |  |  |  |
| AC-e9e91c16 | popSql.OnSql | FP00596_PlanAmend_Line_PreMix.cs:5390 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Save_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE")] / SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5197d1f2 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2252 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-fae71e97 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2253 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3d51414d | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2255 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-1d35b9fd | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2256 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1cc06385 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2257 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-53a5c51c | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2258 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-845fc6a8 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2259 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-ec2091fe | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2260 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-d9625521 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2261 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-87655a7e | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2262 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-43bb8adc | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2263 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9c9738e2 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2264 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e5288db | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2265 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-f23f2370 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2266 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-8190b22a | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2267 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-b032da15 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2268 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-1b204d08 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2269 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-6a7b2d4d | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2270 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-613bf60a | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2271 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_equipment_id"] | p_equipment_id | 행/컬럼 값 대입 |  |  |  |
| AC-47ef4359 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2272 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-195bcf23 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2273 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-1c021c6a | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2274 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-37ec8a56 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2275 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-9cfce799 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2276 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-3402f522 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2277 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_in_qty"] | p_adjust_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-9f4a4df4 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2278 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_in_qty_batch"] | p_adjust_in_qty_batch | 행/컬럼 값 대입 |  |  |  |
| AC-b8612929 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2279 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_in_qty_kg"] | p_adjust_in_qty_kg | 행/컬럼 값 대입 |  |  |  |
| AC-92a6015b | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2280 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_out_qty"] | p_adjust_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-5f02dcf1 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2281 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_out_qty_batch"] | p_adjust_out_qty_batch | 행/컬럼 값 대입 |  |  |  |
| AC-4b173f92 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2282 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_out_qty_kg"] | p_adjust_out_qty_kg | 행/컬럼 값 대입 |  |  |  |
| AC-11d0ecf2 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2284 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1bd905d3 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2285 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3c551412 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2291 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a1e0c0a7 | popSql.OnSql [if (programID == "PR_UI_FP00596_AMEND_LINE_DAT… 외 1 | FP00596_PlanAmend_Line_PreMix.cs:2297 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Save_Data_Excel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd87ced1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6094 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-2bcc182e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6095 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7701f9f5 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6097 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-19e339fa | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6098 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-68fcf498 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6099 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-8c924581 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6100 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c07f8bc3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6101 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-a8d13ebc | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6102 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e958340c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6103 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d515486 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6104 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-28fbcd2c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6105 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-16a3f3e8 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6106 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | pMppWpp | 행/컬럼 값 대입 |  |  |  |
| AC-947ffaf9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6108 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a97e0c38 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6110 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-4f50ea07 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6115 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-195da3e3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6117 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Save_Data_Excel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4e51d1a | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6153 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-971e5575 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6154 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-976a441f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6156 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-bdc12ae9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6157 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-dfc77c5d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6158 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-67b0fdce | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6159 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1ed624c2 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6160 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-0cac8aa3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6161 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-66bf3f74 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6162 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-11fad412 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6163 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4ac0dd43 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6164 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-70a7a00f | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6165 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a10ad663 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6167 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-84666cd1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6169 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-464f3b89 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6174 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-d4db10ba | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:6176 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.Save_PIn_Data

진입점: SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6935aba8 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1902 | if (siMain == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-449a2881 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1904 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5b60d2c8 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1909 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58e230fc | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1910 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8e019469 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1915 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7da500ec | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1926 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-471b9431 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1939 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cfacdf89 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1940 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-32cd8fa7 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1943 | try | CALL_EXT | dtData.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6fe10e5d | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1957 | try ▸ if (dsValidation != null) ▸ lambda | DATA_OP | x.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b115d1d | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1957 | try ▸ if (dsValidation != null) ▸ lambda | RETURN | return (x.Field<string>("_VALID") == "N"); |  | 처리 중단/반환 |  |  |  |
| AC-75d41056 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1967 | try ▸ if (dsValidation != null) ▸ if (valid.Count() > 0) ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-63434be6 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1971 | try ▸ if (dsValidation != null) ▸ if (valid.Count() > 0) | POPUP | new FP00596_InValidationPopup | ("InValidationPopup", dsValidation, sMsg) | 팝업/폼 생성 |  |  |  |
| AC-0b27f985 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1972 | try ▸ if (dsValidation != null) ▸ if (valid.Count() > 0) | UI_PROP | popPreMixValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-86b506cf | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1973 | try ▸ if (dsValidation != null) ▸ if (valid.Count() > 0) | POPUP | popPreMixValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-115251cb | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1975 | try ▸ if (dsValidation != null) ▸ if (valid.Count() > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-432bb39d | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1981 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("It can not be PLAN_TYPE[RELEASE]", "FP", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-7d570260 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1982 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-526434b3 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:1989 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1e956f7d | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2020 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ecb995d2 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2021 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-354c30d7 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2027 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2f6fa2bd | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2030 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-615a9796 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2032 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-f82dc0ac | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2036 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-20ff7b6a | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2037 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a318dc55 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2038 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2fbfe46a | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2039 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9dcf33b6 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2043 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6969f8b5 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00596_PlanAmend_Line_PreMix.cs:2044 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db32b87d | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:899 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d106860c | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:904 | try | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e6829774 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:913 | try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) | FLAG | bSaveChk | Save_PIn_Data(dsListData.Tables[0]) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a0f1813 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:916 | try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ if (bSaveChk == false) | FLAG | bSaveChk | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a87b60d8 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:924 | try ▸ if (dsListData != null) ▸ catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-a3798e69 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:932 | try ▸ if (bSaveChk == true) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e0a8d3e5 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:939 | try ▸ if (bSaveChk == true) ▸ try ▸ if (!bRtn1) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bc4535d2 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:940 | try ▸ if (bSaveChk == true) ▸ try ▸ if (!bRtn1) | MESSAGE | MessageBox.Show | ("EXEC_PSICALCUL is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informat… | 메시지 표시 |  |  |  |
| AC-b5f8bdcf | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:944 | try ▸ if (bSaveChk == true) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-99c3cd9f | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:948 | try ▸ if (bSaveChk == true) ▸ catch ((Exception ex2)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-57282790 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:949 | try ▸ if (bSaveChk == true) ▸ catch ((Exception ex2)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-ba5f01a5 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:956 | try ▸ if (bSaveChk == true) | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-8a082ff9 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:957 | try ▸ if (bSaveChk == true) | STATE_RESET | dsListData.Tables[0].Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b679a802 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:967 | try ▸ if (!string.IsNullOrEmpty(sMsg)) | MESSAGE | MessageBox.Show | (sMsg + " Is Saved.! ") | 메시지 표시 |  |  |  |
| AC-1326b744 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:971 | try | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3244c2e4 | SaveButton | FP00596_PlanAmend_Line_PreMix.cs:975 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SearchListInfoAll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c01687b | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5533 |  | FLAG | dtDimension | siMain.GetSpdTitle(sProgramID, sUserID, sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-2994cadd | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5533 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a538f8b | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5536 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_UOMInfo_ALL") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6bed813c | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5537 |  | FLAG | dsUomInfoAll | dtUomAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-86b56cd1 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5537 |  | DATA_OP | dtUomAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ff38f8c7 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5539 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_YieldInfo_Child", Filter["INSTANCE_ID"].ToString(), Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5146eaf9 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5540 |  | FLAG | dsYieldInfoAll | dtYieldAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-486e906d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:5540 |  | DATA_OP | dtYieldAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetAmendHeaderColumn_FP_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c22a670 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:443 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-36d943ff | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:449 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c65036b | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:452 | if (!dtSheetColumnConfig.Good()) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-9a7b66d5 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:453 | if (!dtSheetColumnConfig.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07a5b29b | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:472 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length -1) ▸ if (measure[_sMea… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eeca251b | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:473 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length -1) ▸ if (measure[_sMea… | CALL_EXT | MenuService.SetMenuColumn | (dateRowWeek, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = _… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c4d8769 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:483 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length -1) ▸ if (measure[_sMea… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowWeek) | 데이터 객체 조작/조회 |  |  |  |
| AC-acceaebd | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:484 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length -1) ▸ if (measure[_sMea… | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-91a3e311 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:497 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-78f8597b | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:498 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | CALL_EXT | MenuService.SetMenuColumn | (dateRwoDay, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = _s… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a3a1f46 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:509 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRwoDay) | 데이터 객체 조작/조회 |  |  |  |
| AC-75e87e2c | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:510 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-f8333f7f | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:531 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length -1) ▸ if (measure[_… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e231b989 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:532 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length -1) ▸ if (measure[_… | CALL_EXT | MenuService.SetMenuColumn | (dateRowmonth, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = … | ⚠ 의미 확인 필요 |  |  |  |
| AC-c273ad7c | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:543 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length -1) ▸ if (measure[_… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowmonth) | 데이터 객체 조작/조회 |  |  |  |
| AC-4657428a | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:544 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length -1) ▸ if (measure[_… | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-428888fe | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:553 | if (dtSheetColumnConfig.Rows.Count == 0) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-f11e5c7d | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:554 | if (dtSheetColumnConfig.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7c4c5a3 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:557 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, iColumnHeaderRowCount, dtSheetColumnConfig) | 그리드 재구성/초기화 |  |  |  |
| AC-9642bf74 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 11 | FP00596_PlanAmend_Line_PreMix.cs:558 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetBasisTime

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.cbo_fpplanid.DropDown / this.btnRelease2.Click [if (sConfirmArea == "PLAN GROUP")] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4df63b02 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4089 |  | FLAG | dtBaseTime | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findBasisTime", sInstance,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-e957bb63 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4089 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findBasisTime", sInstance, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetBohTotalQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b373f055 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1866 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f6b97ec | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1871 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-a317081e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1876 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-699b684d | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1877 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f52896cd | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1878 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-98d0e631 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1879 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6bff472 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1880 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f0b7f16 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1881 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-45336cbf | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1882 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6a5f49e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1883 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-46ed4872 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:1887 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetCalenderColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39b7e0fd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6968 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ada3d1e2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6972 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-3111f5b5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6976 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-c06ea327 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6980 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-4630b483 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6982 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa8216e9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6986 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-e8f575b0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6989 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d5dbaf59 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6992 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-e4417f56 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:7012 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week != null) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-c616bb46 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:7015 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week != null) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-874b7476 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:7018 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week != null) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-640d10c1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:7037 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month != null) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Mo… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-6f70080e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:7040 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month != null) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Mo… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-87aa6098 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:7043 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month != null) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Mo… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetColumnChangeByText

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46df2660 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:595 | if (iColMinStartIndex <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91b92da3 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:600 | try | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-0bacb1a6 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:602 | try | FLAG | DateCellType | new FarPoint.Win.Spread.CellType.DateTimeCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-60adc305 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:604 | try | FLAG | MaskcellType | new FarPoint.Win.Spread.CellType.MaskCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-3e3c0531 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:605 | try | UI_PROP | MaskcellType.Mask | "####-##-##" | 속성 Mask 설정 |  |  |  |
| AC-87ed5e6e | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:609 | try | UI_PROP | DateCellType.DateTimeFormat | FarPoint.Win.Spread.CellType.DateTimeFormat.UserDefined | 속성 DateTimeFormat 설정 |  |  |  |
| AC-bced1fb6 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:610 | try | UI_PROP | DateCellType.UserDefinedFormat | "yyyy-MM-dd" | 속성 UserDefinedFormat 설정 |  |  |  |
| AC-c6e38219 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:620 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9ead9295 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:622 | try | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-663cb060 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:640 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k,i].CellType | MaskcellType | 그리드 속성/값 설정 |  |  |  |
| AC-26d5b632 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:642 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].Value | sData | 그리드 속성/값 설정 |  |  |  |
| AC-7b8b7628 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:646 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-566e21b0 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:647 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-63af2705 | (진입점 미연결) | FP00596_PlanAmend_Line_PreMix.cs:657 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7105c26b | this.Load | FP00596_PlanAmend_Line_PreMix.cs:246 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-14524aa9 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:248 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-089b9728 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:252 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-c31d605e | this.Load | FP00596_PlanAmend_Line_PreMix.cs:254 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-c087e62c | this.Load | FP00596_PlanAmend_Line_PreMix.cs:255 |  | CALL_EXT | UserService.HasSuperRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8fa60fea | this.Load | FP00596_PlanAmend_Line_PreMix.cs:257 | if (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-5b868113 | this.Load | FP00596_PlanAmend_Line_PreMix.cs:261 | else of (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetDirty

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA") && iBatch != -1) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / bucke_menu.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e10623c2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 12 | FP00596_PlanAmend_Line_PreMix.cs:4383 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetDivision

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-675bd8e8 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4099 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-550a2cc2 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4099 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b528befc | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4100 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetFactory

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / cbo_fpplanid.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-089eb7fb | this.Load [try] 외 4 | FP00596_PlanAmend_Line_PreMix.cs:4288 |  | FLAG | dtFactoryAmend | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findFactoryCode_amend_common", Fil… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-616d4b55 | this.Load [try] 외 4 | FP00596_PlanAmend_Line_PreMix.cs:4288 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findFactoryCode_amend_common", Filter["INSTANCE_ID"], Filter["PLAN_ID"] … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-551dd5e9 | this.Load [try] 외 4 | FP00596_PlanAmend_Line_PreMix.cs:4291 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (dtInstance.Good())] / mcbo_planner.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) ▸ if (dtPlanId.Rows.Count > 0)] / cbo_fpplanid.SelectedIndexChanged [if (cbo_fpplanid.Items.Count > 0)] / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / mcbo_line.SelectedIndexChanged / mcbo_nicknamelt.SelectedIndexChanged / txtItem.TextChanged …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3027f5cf | this.Load [try] 외 26 | FP00596_PlanAmend_Line_PreMix.cs:4068 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetFpPlanId

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.cbo_fpplanid.DropDown / this.btnRelease2.Click [if (sConfirmArea == "PLAN GROUP")] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92e5f28e | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4204 |  | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00621_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-68737ebd | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4204 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00621_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d613c27 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4205 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b54a3150 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4208 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-a98e3844 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4210 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | cbo_fpplanid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-352cb855 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4227 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[0]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-12a744f0 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4228 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[0]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-25f0e17e | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4229 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[0]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-e00da541 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4230 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[0]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-d48e5844 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4231 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[0]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-1ae91a2a | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4233 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-45ec4905 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4234 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-8526cbe4 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4235 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-c196fc8a | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4236 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-0f038999 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4237 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-eeeee609 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4242 | if (dtPlanId.Rows.Count > 0) ▸ if (dtPlanId.Rows[iDx]["READ_ONLY"].ToString().Equals("Y")) | FLAG | bReadOnly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5bacad70 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4246 | if (dtPlanId.Rows.Count > 0) ▸ else of (dtPlanId.Rows[iDx]["READ_ONLY"].ToString().Equals("Y")) | FLAG | bReadOnly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-427fc67c | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4252 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-c213fa8b | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4253 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-93ec86bd | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4254 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-66616930 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4255 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-fbdd72c4 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4256 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-7147e4e0 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4258 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-a1979ec2 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4259 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-161cf547 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4260 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-2686029a | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4261 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-ed317598 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4262 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetLine

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_planner.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / chk_allLine.CheckedChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1583b5be | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4310 |  | DATA_OP | Filter["ALL_LINE"] | chk_allLine.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d2fe3f5a | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4313 |  | FLAG | dtLine | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00596_findLineCode_List", Filter… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3049ec45 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4313 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_findLineCode_List", Filter["INSTANCE_ID"], Filter["PLAN_ID"] , F… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6370cac6 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4317 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetNickName_LT

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-025b6b2f | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4327 |  | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_R" | 행/컬럼 값 대입 |  |  |  |
| AC-b2da285e | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4331 | if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_H" | 행/컬럼 값 대입 |  |  |  |
| AC-e04a0d42 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4335 |  | FLAG | dtNickName | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00596_find_FPNickName" , Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-fa55a194 | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4335 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_FPNickName" , Filter["INSTANCE_ID"], Filter["PLAN_ID"], Fil… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3e00d31a | this.Load [try] 외 5 | FP00596_PlanAmend_Line_PreMix.cs:4340 |  | LIST_REBIND | clsCtrl.setListBox | (dtNickName, mcbo_nicknamelt, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetOperation

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / this.chk_includeSubOp.CheckedChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caee3dc4 | this.Load [try] 외 4 | FP00596_PlanAmend_Line_PreMix.cs:4299 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-acb6ea6f | this.Load [try] 외 4 | FP00596_PlanAmend_Line_PreMix.cs:4299 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-78eaf1c6 | this.Load [try] 외 4 | FP00596_PlanAmend_Line_PreMix.cs:4301 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetPlanDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7b3f99b | this.Load [try] | FP00596_PlanAmend_Line_PreMix.cs:4079 |  | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetPlanGroup

진입점: this.Load [try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Row…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c59b94e3 | this.Load [try] 외 7 | FP00596_PlanAmend_Line_PreMix.cs:4173 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findAmendInstanceList_common", lv_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d64a6633 | this.Load [try] 외 7 | FP00596_PlanAmend_Line_PreMix.cs:4173 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findAmendInstanceList_common", lv_amendInstance, _sSaveAuth) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-447c0e8f | this.Load [try] 외 7 | FP00596_PlanAmend_Line_PreMix.cs:4174 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fb18e04a | this.Load [try] 외 7 | FP00596_PlanAmend_Line_PreMix.cs:4176 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetPlanInBatch_DataSet

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA") && iBatch != -1) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SEQ") >= 0) ▸ if (sColumnName.IndexOf("_BATCH") >= 0) ▸ if (sCateID.Equals("P_IN"))] / buc…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c046e42b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4485 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-75013182 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4486 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-e4cd6e38 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4487 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-f46d9e41 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4488 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-9e36b47d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4501 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e36f34f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4509 | if (dsMainFiltered.Good()) ▸ if (org_value == new_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0035fb8d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4513 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_ListData", Filter["INSTANCE_ID"].ToString(), Filter["PLANT_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-803ef389 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4515 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | FLAG | dsListData | dtList.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-600d2d4b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4515 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | DATA_OP | dtList.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9446741b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4527 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-adf07d3d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4528 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a02a8cd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4529 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c8a72e07 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4530 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a0897ca | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4531 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f47501a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4532 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed30e315 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4533 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-55f83249 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4534 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a9f3cbc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4535 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0493db2b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4536 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ecbbe58 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4537 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-acf5e458 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4527 | if (dsMainFiltered.Good()) ▸ lambda | RETURN | return (x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &&… |  | 처리 중단/반환 |  |  |  |
| AC-4a3f33d4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4563 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["ADJUST_IN_QTY_KG"] | Math.Round(Convert.ToDecimal(nIn_KG)) | 행/컬럼 값 대입 |  |  |  |
| AC-37b2894d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4566 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["ADJUST_OUT_QTY_BATCH"] | Math.Round(Convert.ToDecimal(nOutValue), 2) | 행/컬럼 값 대입 |  |  |  |
| AC-c626d62a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4567 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["ADJUST_IN_QTY_BATCH"] | Math.Round(Convert.ToDecimal(nInValue), 2) | 행/컬럼 값 대입 |  |  |  |
| AC-a49db14f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4570 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["ADJUST_OUT_QTY_KG"] | Math.Round(Convert.ToDecimal(nOut_KG)) | 행/컬럼 값 대입 |  |  |  |
| AC-fdea8dfd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4576 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) ▸ if (measure[_sMeasureName[0]].Value.Equals("true")) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol - 1].Value | Math.Round(nIn_KG) | 그리드 속성/값 설정 |  |  |  |
| AC-925463e3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4583 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) ▸ if (measure["chk_outqty"].Value == "true") ▸ if (measure[_sMeasureName[0… | GRID_SET | siMain.ActiveSheet.Cells[cRow + 1, cCol - 1].Value | Math.Round(nOut_KG) | 그리드 속성/값 설정 |  |  |  |
| AC-98991c0d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4585 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) ▸ if (measure["chk_outqty"].Value == "true") | GRID_SET | siMain.ActiveSheet.Cells[cRow + 1, cCol].Value | Math.Round(nOutValue, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-05b29fc1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4591 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) ▸ if ((nInValue > 0) && (selected["SEQ"].ToString() == "0")) | DATA_OP | selected["SEQ"] | "1" | 행/컬럼 값 대입 |  |  |  |
| AC-2bc72b1c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4595 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) ▸ if ((nInValue > 0) && (selected["SEQ"].ToString() == "0")) ▸ if (measure… | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol + 1].Value | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-27673526 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4600 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) ▸ if ((nInValue > 0) && (selected["SEQ"].ToString() == "0")) ▸ if (measure… | GRID_SET | siMain.ActiveSheet.Cells[cRow + 1, cCol + 1].Value | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-937b255c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4607 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) ▸ if ((nInValue > 0) && (selected["SEQ"].ToString() == "0")) ▸ if (measure… | GRID_SET | siMain.ActiveSheet.Cells[cRow + 2, cCol + 1].Value | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-df29dfe7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4608 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) ▸ if ((nInValue > 0) && (selected["SEQ"].ToString() == "0")) ▸ if (measure… | GRID_SET | siMain.ActiveSheet.Cells[cRow + 1, cCol + 1].Value | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-af1123a8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4620 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-33f66b63 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4622 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6363441f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4623 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-368bdab8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4624 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4ff84146 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4625 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d63adafa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4626 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-758b1875 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4627 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc931388 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4628 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-feef4210 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4629 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LOCATION"] | row["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-877fb1e4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4630 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d80b8c50 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4631 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1f372af5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4632 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-03be5a6c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4633 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["EQUIPMENT_ID"] | row["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9aef1e13 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4634 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["TOP_ITEM_ID"] | row["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8cfb6366 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4635 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-72804ff9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4636 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a47e03de | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4637 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["MARKET"] | row["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-56a34458 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4638 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SEQ"] | nNewSeq | 행/컬럼 값 대입 |  |  |  |
| AC-c8219304 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4639 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e52d29e2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4641 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | Math.Round(nInValue,2) | 행/컬럼 값 대입 |  |  |  |
| AC-6f7e8f6a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4642 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_IN_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-14b2a53b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4643 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | Math.Round(nIn_KG) | 행/컬럼 값 대입 |  |  |  |
| AC-e07bfc8f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4644 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Math.Round(nOutValue,2) | 행/컬럼 값 대입 |  |  |  |
| AC-04093767 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4645 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_OUT_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-f3a873fc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4646 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Math.Round(nOut_KG) | 행/컬럼 값 대입 |  |  |  |
| AC-caf3965e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4649 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-34cf75e6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4652 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (dsListData == null) | FLAG | dsListData | dtList.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-eae1c384 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4655 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ else of (dsListData == null) | DATA_OP | dsListData.Tables["Table"].ImportRow | (dtList.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd6d81ac | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4662 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (measure[_sMeasureName[0]].Value.Equals("true")) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol - 1].Value | Math.Round(nIn_KG) | 그리드 속성/값 설정 |  |  |  |
| AC-2498e853 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4669 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (measure["chk_outqty"].Value == "true") ▸ if (measure[_sMeasureN… | GRID_SET | siMain.ActiveSheet.Cells[cRow + 1, cCol - 1].Value | Math.Round(nOut_KG) | 그리드 속성/값 설정 |  |  |  |
| AC-f48c0c97 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4671 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (measure["chk_outqty"].Value == "true") | GRID_SET | siMain.ActiveSheet.Cells[cRow + 1, cCol].Value | Math.Round(nOutValue,2) | 그리드 속성/값 설정 |  |  |  |
| AC-8fec7b5a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4676 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (measure[_sMeasureName[2]].Value.Equals("true")) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol + 1].Value | Convert.ToInt32(nNewSeq) | 그리드 속성/값 설정 |  |  |  |
| AC-82119e70 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4681 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (measure["chk_outqty"].Value == "true" && measure[_sMeasureName[… | GRID_SET | siMain.ActiveSheet.Cells[cRow + 1, cCol +1].Value | Convert.ToInt32(nNewSeq) | 그리드 속성/값 설정 |  |  |  |
| AC-84f5355c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4688 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (measure["chk_result"].Value == "true" && measure[_sMeasureName[… | GRID_SET | siMain.ActiveSheet.Cells[cRow + 2, cCol +1].Value | Convert.ToInt32(nNewSeq) | 그리드 속성/값 설정 |  |  |  |
| AC-f2618e35 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4689 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (measure["chk_result"].Value == "true" && measure[_sMeasureName[… | GRID_SET | siMain.ActiveSheet.Cells[cRow + 1, cCol +1].Value | Convert.ToInt32(nNewSeq) | 그리드 속성/값 설정 |  |  |  |
| AC-56747e29 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4808 | if (dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d550639e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4809 | if (dsMainFiltered.Good()) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetPlanInSeq_DataSet

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA") && iBatch != -1) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sColumnName.IndexOf("_SEQ") >= 0)] / bucke_menu.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72ea289e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4924 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-0724117d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4949 | if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-059c029a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4950 | if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-6d3577be | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4951 | if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-a5a246cf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4952 | if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-ad3c808e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4965 | if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13213e44 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4971 | if (dsListData == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_ListData", Filter["INSTANCE_ID"].ToString(), Filter["PLANT_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-feb244bf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4973 | if (dsListData == null) | FLAG | dsListData | dtList.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-e20aadd3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4973 | if (dsListData == null) | DATA_OP | dtList.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f6c45c04 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4983 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-75c4e202 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4984 | lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-edf62ce2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4985 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-42541642 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4986 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d548d18a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4987 | lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a64c2b8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4988 | lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc9866a1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4989 | lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-875aa9c7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4990 | lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a62c139d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4991 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-560f6d26 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4992 | lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6db71ee6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4993 | lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c271807 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:4983 | lambda | RETURN | return (x.Field<string>("FACTORY_ID") == row["FACTORY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-b450d6cc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5004 | if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["SEQ"] | Convert.ToDecimal(newEditingValue) | 행/컬럼 값 대입 |  |  |  |
| AC-d70b3cbc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5014 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-be32c041 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5016 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9bed13ee | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5017 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c829516e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5018 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5d910138 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5019 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b4c97325 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5020 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9da0cbfe | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5021 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b88fd4cf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5022 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f9375235 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5023 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LOCATION"] | row["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-20442d24 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5024 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-53a019cb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5025 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-208c431b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5026 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1c17b20a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5027 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["EQUIPMENT_ID"] | row["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c0b6ec02 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5028 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["TOP_ITEM_ID"] | row["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6bebff06 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5029 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b83fbea | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5030 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d2fe2be0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5031 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["MARKET"] | row["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e456f20d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5032 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SEQ"] | Convert.ToDecimal(newEditingValue) | 행/컬럼 값 대입 |  |  |  |
| AC-8b9e580b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5033 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-62e3548a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5035 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-516e9cd8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5036 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_IN_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-2ca1051f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5037 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-181c7ccd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5038 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-bb61fdfd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5039 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_OUT_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-2d993416 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5040 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-d7299d14 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5043 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-23886b7c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5046 | else of (MatchingEditRowData.Count() > 0) ▸ if (dsListData == null) | FLAG | dsListData | dtList.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-827933a3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5049 | else of (MatchingEditRowData.Count() > 0) ▸ else of (dsListData == null) | DATA_OP | dsListData.Tables["Table"].ImportRow | (dtList.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a0885e5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5056 | if (measure["chk_outqty"].Value == "true") | GRID_SET | siMain.ActiveSheet.Cells[cRow + 1, cCol].Value | newEditingValue | 그리드 속성/값 설정 |  |  |  |
| AC-3a41dd51 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5063 | if (measure["chk_result"].Value == "true") ▸ if (measure["chk_outqty"].Value == "true" && measure[_sMeasureName[2]].Value.Equals("true")) | GRID_SET | siMain.ActiveSheet.Cells[cRow + 2, cCol].Value | newEditingValue | 그리드 속성/값 설정 |  |  |  |
| AC-e3eaad26 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5064 | if (measure["chk_result"].Value == "true") ▸ if (measure["chk_outqty"].Value == "true" && measure[_sMeasureName[2]].Value.Equals("true")) | GRID_SET | siMain.ActiveSheet.Cells[cRow + 1, cCol].Value | newEditingValue | 그리드 속성/값 설정 |  |  |  |
| AC-926bfeae | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00596_PlanAmend_Line_PreMix.cs:5068 |  | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetPlanner

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd460237 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4112 |  | FLAG | dtPlanner | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findPlanner_List", sInstan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-894d4c60 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4112 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findPlanner_List", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1ad67c8e | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4114 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, mcbo_planner, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-dc4af568 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4124 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row[… | CALL_EXT | mcbo_planner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3f28df22 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4128 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of … | CALL_EXT | mcbo_planner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2508028e | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4144 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-2a2ab2a3 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4145 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-7ef88721 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4149 | if (dtPlanner != null) ▸ else of (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-223157da | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4150 | if (dtPlanner != null) ▸ else of (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-50229d80 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4160 | if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner.Items.Count) ▸ if (mcbo_planner.Items[k].ToString() == sValueName.ToString()) | CALL_EXT | mcbo_planner.SetItemChecked | (k, true) | ⚠ 의미 확인 필요 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetPlanPeriod

진입점: this.Load [try] / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a128aa35 | this.Load [try] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:4361 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-3eade078 | this.Load [try] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:4362 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-5bda4e2c | this.Load [try] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:4366 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-28b1070f | this.Load [try] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:4367 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-bc2dd271 | this.Load [try] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:4373 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-0a028599 | this.Load [try] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:4374 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetPlant

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80f8b025 | this.Load [try] 외 4 | FP00596_PlanAmend_Line_PreMix.cs:4277 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-4375f716 | this.Load [try] 외 4 | FP00596_PlanAmend_Line_PreMix.cs:4277 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d12276c8 | this.Load [try] 외 4 | FP00596_PlanAmend_Line_PreMix.cs:4279 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetSite

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28c441e3 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4270 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-50c6e0c2 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4270 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37bdc7e0 | this.Load [try] 외 2 | FP00596_PlanAmend_Line_PreMix.cs:4271 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-771e7e42 | this.Load [try] 외 11 | FP00596_PlanAmend_Line_PreMix.cs:437 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a415c5d | this.Load [try] 외 11 | FP00596_PlanAmend_Line_PreMix.cs:438 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SetTotalColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e29b3204 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00596_PlanAmend_Line_PreMix.cs:6941 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22588c89 | this.spdMain.ButtonClicked | FP00596_PlanAmend_Line_PreMix.cs:3657 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4abe074 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7227 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44c42817 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7228 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e6390c5 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7249 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-07e049f6 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7250 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-e07e15ba | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7252 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e18a90c | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7271 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-11d8f087 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7272 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-9fd79137 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7274 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-e76ae2e0 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7288 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-7fa4c48b | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7289 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-a71d12c7 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7291 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-826737a3 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7300 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-f8617695 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7301 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-80576e26 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7303 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-7579a191 | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7307 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | nlfamend_menu.Text | "NLF Amend" | 컨트롤 값 설정 |  |  |  |
| AC-f15f373f | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7308 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | nlfamend_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-9af8b76d | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7310 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (nlfamend_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f5e46fb | this.spdMain.CellClick | FP00596_PlanAmend_Line_PreMix.cs:7318 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cff2b79 | this.spdMain.CellDoubleClick | FP00596_PlanAmend_Line_PreMix.cs:3626 | try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(e.Column), DAY_SUFFIXs) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b8bdc1b | this.spdMain.CellDoubleClick | FP00596_PlanAmend_Line_PreMix.cs:3644 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount + startpos) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-28ff3fa7 | this.spdMain.CellDoubleClick | FP00596_PlanAmend_Line_PreMix.cs:3651 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d603980a | this.spdMain.ChildControlDeactivated | FP00596_PlanAmend_Line_PreMix.cs:3404 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3471f04 | this.spdMain.ClipboardPasted | FP00596_PlanAmend_Line_PreMix.cs:3664 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7535ea97 | this.spdMain.ClipboardPasted | FP00596_PlanAmend_Line_PreMix.cs:3672 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4186b964 | this.spdMain.ClipboardPasted | FP00596_PlanAmend_Line_PreMix.cs:3673 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-baa61389 | this.spdMain.ClipboardPasted | FP00596_PlanAmend_Line_PreMix.cs:3675 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db046e4a | this.spdMain.ClipboardPasting | FP00596_PlanAmend_Line_PreMix.cs:3681 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-951139a6 | this.spdMain.ClipboardPasting | FP00596_PlanAmend_Line_PreMix.cs:3682 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-ff64d4ab | this.spdMain.ClipboardPasting | FP00596_PlanAmend_Line_PreMix.cs:3682 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e16b40d | this.spdMain.ClipboardPasting | FP00596_PlanAmend_Line_PreMix.cs:3686 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d8836bb | this.spdMain.ClipboardPasting | FP00596_PlanAmend_Line_PreMix.cs:3686 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b988600 | this.spdMain.ClipboardPasting | FP00596_PlanAmend_Line_PreMix.cs:3690 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ecaa2d5 | this.spdMain.ClipboardPasting | FP00596_PlanAmend_Line_PreMix.cs:3692 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1abed73a | this.spdMain.DragFillBlockCompleted | FP00596_PlanAmend_Line_PreMix.cs:3414 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af3fa709 | this.spdMain.EditModeOff | FP00596_PlanAmend_Line_PreMix.cs:3432 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee349f99 | this.spdMain.EditModeOn | FP00596_PlanAmend_Line_PreMix.cs:3438 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-aa475d1a | this.spdMain.EditModeOn | FP00596_PlanAmend_Line_PreMix.cs:3439 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd0756db | this.spdMain.EditorFocused | FP00596_PlanAmend_Line_PreMix.cs:3426 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1084a2c | this.spdMain.Enter | FP00596_PlanAmend_Line_PreMix.cs:3389 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c5697f9 | this.spdMain.KeyDown | FP00596_PlanAmend_Line_PreMix.cs:3374 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-bcf5fbc9 | this.spdMain.KeyDown | FP00596_PlanAmend_Line_PreMix.cs:3378 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fec1ccf4 | this.spdMain.KeyDown | FP00596_PlanAmend_Line_PreMix.cs:3379 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6968a345 | this.spdMain.SubEditorClosed | FP00596_PlanAmend_Line_PreMix.cs:3420 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b6f4a4b | this.spdMain.SubEditorOpening | FP00596_PlanAmend_Line_PreMix.cs:3409 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7f10ad1 | this.spdMain.Validated | FP00596_PlanAmend_Line_PreMix.cs:3394 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d6732c7 | this.spdMain.Validating | FP00596_PlanAmend_Line_PreMix.cs:3399 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.SwitchMemo

진입점: memo_menu.Click [if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3436e06f | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7089 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48a524d8 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7106 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-4007b273 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7131 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-dcf27813 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7157 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-a388e42b | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7159 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-8c0f02a8 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7162 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b8c16191 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7164 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f08d420e | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7164 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-6653e295 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7165 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-4c978bc0 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7167 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-225db4d9 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7169 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-85339736 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7181 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8dfe8bd | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7181 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-53346bc8 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7201 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-404a6bd3 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7202 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-fbc0ba50 | memo_menu.Click [if (day != null)] 외 1 | FP00596_PlanAmend_Line_PreMix.cs:7204 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00596_PlanAmend_Line_PreMix.UIFindData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK)] / SaveButton…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04e581ab | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:675 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4556ad87 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:676 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e019afa | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:679 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8d5e818c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:683 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-b51319e2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:687 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan ID to proceed") | 메시지 표시 |  |  |  |
| AC-1f385e5a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:688 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae4939cb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:709 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e4b31bc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:710 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b60cc3ac | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:713 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9d247433 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:716 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-506d667f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:717 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-30e8ab2a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:720 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-0355b886 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:729 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b59ae12b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:731 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4426eb7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:731 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-27898b6a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:741 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | LastTotalRaw | FindTotalValue("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-4844846d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:743 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-90cd42cd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:747 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e87a2902 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:748 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bb492d4b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:750 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-b2e51f22 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:752 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f804a4a7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:756 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-35e5c940 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:757 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-8b7f3c09 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:759 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5bceec89 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:764 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-aa76780d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:765 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-73208ac5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:766 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-a64de0e6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:770 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f13b672d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:774 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6ab9958c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:775 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d6959279 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:783 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d7a84422 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:787 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-17e58ccc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:792 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2093c31a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:793 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8ad85013 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:797 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-758d65ca | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:808 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5f905489 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:813 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-b09d29ab | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00596_PlanAmend_Line_PreMix.cs:817 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00596_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a646244 | .ctor | FP00596_RowExcelPopup.cs:161 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8eec45a1 | .ctor | FP00596_RowExcelPopup.cs:164 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-23639663 | .ctor | FP00596_RowExcelPopup.cs:165 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00596_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3577079d | this.btnClose.Click | FP00596_RowExcelPopup.cs:936 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d35089b8 | this.btnDownload.Click | FP00596_RowExcelPopup.cs:844 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-62287116 | this.btnDownload.Click | FP00596_RowExcelPopup.cs:845 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |
| AC-0fbd3922 | this.btnDownload.Click | FP00596_RowExcelPopup.cs:847 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00596_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa2fdb14 | this.btnFind.Click | FP00596_RowExcelPopup.cs:839 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00596_RowExcelPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d84f9b5c | this.btnSave.Click | FP00596_RowExcelPopup.cs:931 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00596_RowExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d9a35de | this.btnUpload.Click | FP00596_RowExcelPopup.cs:861 | if (bUpload) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2d59607c | this.btnUpload.Click | FP00596_RowExcelPopup.cs:862 | if (bUpload) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-87e24e17 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:864 | if (bUpload) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-82dd9b3c | this.btnUpload.Click | FP00596_RowExcelPopup.cs:865 | if (bUpload) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-3a5d93c3 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:871 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | DATA_OP | dsSource.Tables[0].Columns.Contains | ("APPLIED_MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9c3465b | this.btnUpload.Click | FP00596_RowExcelPopup.cs:874 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (!dsSource.Tables[0].Columns.Contains("APPLIED_MODEL")) | DATA_OP | dsSource.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef005e02 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:882 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2cd02de | this.btnUpload.Click | FP00596_RowExcelPopup.cs:883 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7da68e8 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:884 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-abbf828e | this.btnUpload.Click | FP00596_RowExcelPopup.cs:888 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | row["APPLIED_MODEL"] | UomResult.First()["VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-18d29ca5 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:892 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | row["APPLIED_MODEL"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-25d833fe | this.btnUpload.Click | FP00596_RowExcelPopup.cs:909 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ for (iRow < dsSource.Ta… | GRID_SET | dsSource.Tables[0].Rows[iRow]["ADJUST_IN_QTY_KG"] | "" | 그리드 속성/값 설정 |  |  |  |
| AC-2606a0e7 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:913 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ for (iRow < dsSource.Ta… | GRID_SET | dsSource.Tables[0].Rows[iRow]["ADJUST_IN_QTY_KG"] | rVal.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-f3cc3c2f | this.btnUpload.Click | FP00596_RowExcelPopup.cs:919 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-21ad5ee7 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:920 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-174536a9 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:922 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00596_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f7e56aa | this.Load | FP00596_RowExcelPopup.cs:254 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-50b71f3e | this.Load | FP00596_RowExcelPopup.cs:255 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f3d09063 | this.Load | FP00596_RowExcelPopup.cs:256 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00596_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43bce33f | (진입점 미연결) | FP00596_RowExcelPopup.cs:767 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f8edc1e | (진입점 미연결) | FP00596_RowExcelPopup.cs:767 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00596_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34f432f6 | this.Load | FP00596_RowExcelPopup.cs:249 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00596_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-911e985c | Dispose | FP00596_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00596_RowExcelPopup.dtpPeriod_ValueChanged

진입점: this.dtpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fdceca6 | this.dtpPeriod.ValueChanged | FP00596_RowExcelPopup.cs:1045 | if (bFirst == true) | FLAG | bFirst | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ad98491a | this.dtpPeriod.ValueChanged | FP00596_RowExcelPopup.cs:1046 | if (bFirst == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64fe959a | this.dtpPeriod.ValueChanged | FP00596_RowExcelPopup.cs:1060 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8dd65c28 | this.dtpPeriod.ValueChanged | FP00596_RowExcelPopup.cs:1062 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | VALUE_SET | dtpPeriod.InitValue | sStartDate + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-265e19d9 | this.dtpPeriod.ValueChanged | FP00596_RowExcelPopup.cs:1063 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e803728 | this.dtpPeriod.ValueChanged | FP00596_RowExcelPopup.cs:1068 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6320bd1b | this.dtpPeriod.ValueChanged | FP00596_RowExcelPopup.cs:1076 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-751d2921 | this.dtpPeriod.ValueChanged | FP00596_RowExcelPopup.cs:1078 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aed7e480 | this.dtpPeriod.ValueChanged | FP00596_RowExcelPopup.cs:1081 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-923cc177 | this.dtpPeriod.ValueChanged | FP00596_RowExcelPopup.cs:1082 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |

## FP00596_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1303ec40 | (진입점 미연결) | FP00596_RowExcelPopup.cs:731 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00596_RowExcelPopup.Exec_Procedure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ae56035 | (진입점 미연결) | FP00596_RowExcelPopup.cs:783 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-1fa18d69 | (진입점 미연결) | FP00596_RowExcelPopup.cs:784 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3cc68a52 | (진입점 미연결) | FP00596_RowExcelPopup.cs:786 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-1214acd5 | (진입점 미연결) | FP00596_RowExcelPopup.cs:787 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-b2f87eac | (진입점 미연결) | FP00596_RowExcelPopup.cs:788 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0be09a4e | (진입점 미연결) | FP00596_RowExcelPopup.cs:789 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-08b7060e | (진입점 미연결) | FP00596_RowExcelPopup.cs:790 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-46c908f7 | (진입점 미연결) | FP00596_RowExcelPopup.cs:791 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-154cdd8c | (진입점 미연결) | FP00596_RowExcelPopup.cs:792 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-07d1b939 | (진입점 미연결) | FP00596_RowExcelPopup.cs:793 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d440d5de | (진입점 미연결) | FP00596_RowExcelPopup.cs:794 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b7258a6d | (진입점 미연결) | FP00596_RowExcelPopup.cs:795 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7b9e3eb9 | (진입점 미연결) | FP00596_RowExcelPopup.cs:796 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-16a666ca | (진입점 미연결) | FP00596_RowExcelPopup.cs:797 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6805970f | (진입점 미연결) | FP00596_RowExcelPopup.cs:798 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5925bc32 | (진입점 미연결) | FP00596_RowExcelPopup.cs:799 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-989aebe8 | (진입점 미연결) | FP00596_RowExcelPopup.cs:800 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1ba64517 | (진입점 미연결) | FP00596_RowExcelPopup.cs:801 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b2e15176 | (진입점 미연결) | FP00596_RowExcelPopup.cs:802 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-624ad45e | (진입점 미연결) | FP00596_RowExcelPopup.cs:803 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5bb04d26 | (진입점 미연결) | FP00596_RowExcelPopup.cs:804 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-000410d0 | (진입점 미연결) | FP00596_RowExcelPopup.cs:805 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d870a2ab | (진입점 미연결) | FP00596_RowExcelPopup.cs:806 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f5489d97 | (진입점 미연결) | FP00596_RowExcelPopup.cs:807 | try | DATA_OP | req.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b6291497 | (진입점 미연결) | FP00596_RowExcelPopup.cs:808 | try | DATA_OP | req.Parameters["p_p_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8bb81df9 | (진입점 미연결) | FP00596_RowExcelPopup.cs:809 | try | DATA_OP | req.Parameters["p_p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-071f72fc | (진입점 미연결) | FP00596_RowExcelPopup.cs:810 | try | DATA_OP | req.Parameters["p_mpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0c5dcf8a | (진입점 미연결) | FP00596_RowExcelPopup.cs:811 | try | DATA_OP | req.Parameters["p_mpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5620ceb2 | (진입점 미연결) | FP00596_RowExcelPopup.cs:812 | try | DATA_OP | req.Parameters["p_wpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-67ce901e | (진입점 미연결) | FP00596_RowExcelPopup.cs:813 | try | DATA_OP | req.Parameters["p_wpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-51cd5a0e | (진입점 미연결) | FP00596_RowExcelPopup.cs:814 | try | DATA_OP | req.Parameters["p_boh_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eaf9cfd1 | (진입점 미연결) | FP00596_RowExcelPopup.cs:816 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-614af9b9 | (진입점 미연결) | FP00596_RowExcelPopup.cs:823 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-a8157bac | (진입점 미연결) | FP00596_RowExcelPopup.cs:827 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00596_RowExcelPopup.Find_Data

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40021573 | this.Load 외 2 | FP00596_RowExcelPopup.cs:328 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-aaadbf2b | this.Load 외 2 | FP00596_RowExcelPopup.cs:334 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d98b806d | this.Load 외 2 | FP00596_RowExcelPopup.cs:336 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8198af0 | this.Load 외 2 | FP00596_RowExcelPopup.cs:341 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-04ba8ec1 | this.Load 외 2 | FP00596_RowExcelPopup.cs:342 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ae28835 | this.Load 외 2 | FP00596_RowExcelPopup.cs:345 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-cf223768 | this.Load 외 2 | FP00596_RowExcelPopup.cs:346 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-7cc7d353 | this.Load 외 2 | FP00596_RowExcelPopup.cs:348 |  | DATA_OP | Filter["BUCKET_FROM"] | _BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-5e544910 | this.Load 외 2 | FP00596_RowExcelPopup.cs:349 |  | DATA_OP | Filter["BUCKET_TO"] | _BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-ec21d8a6 | this.Load 외 2 | FP00596_RowExcelPopup.cs:352 |  | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fa3e211b | this.Load 외 2 | FP00596_RowExcelPopup.cs:355 | if (OnSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0cda37b | this.Load 외 2 | FP00596_RowExcelPopup.cs:356 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-0dcead16 | this.Load 외 2 | FP00596_RowExcelPopup.cs:356 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ef84c87 | this.Load 외 2 | FP00596_RowExcelPopup.cs:360 | if (OnSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0e0a3c2e | this.Load 외 2 | FP00596_RowExcelPopup.cs:361 | if (OnSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-90aac2d9 | this.Load 외 2 | FP00596_RowExcelPopup.cs:363 | if (OnSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e6d2931f | this.Load 외 2 | FP00596_RowExcelPopup.cs:364 | if (OnSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-679a1b36 | this.Load 외 2 | FP00596_RowExcelPopup.cs:365 | if (OnSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-331365af | this.Load 외 2 | FP00596_RowExcelPopup.cs:366 | if (OnSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-77db7409 | this.Load 외 2 | FP00596_RowExcelPopup.cs:367 | if (OnSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-83c1994a | this.Load 외 2 | FP00596_RowExcelPopup.cs:368 | if (OnSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b0197d9d | this.Load 외 2 | FP00596_RowExcelPopup.cs:369 | if (OnSearchData != null) | STATE | this.dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ac0b5945 | this.Load 외 2 | FP00596_RowExcelPopup.cs:375 | if (OnSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-76c1fd0e | this.Load 외 2 | FP00596_RowExcelPopup.cs:378 | if (OnSearchData != null) ▸ try | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-69780ca5 | this.Load 외 2 | FP00596_RowExcelPopup.cs:380 | if (OnSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-991f0818 | this.Load 외 2 | FP00596_RowExcelPopup.cs:382 | if (OnSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar,set,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a7c26d5 | this.Load 외 2 | FP00596_RowExcelPopup.cs:387 | if (OnSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-5a377d28 | this.Load 외 2 | FP00596_RowExcelPopup.cs:387 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, null, 1, IgnoreColumnsNotInTi… | 그리드 재구성/초기화 |  |  |  |
| AC-87a9d64c | this.Load 외 2 | FP00596_RowExcelPopup.cs:392 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-a2a7f421 | this.Load 외 2 | FP00596_RowExcelPopup.cs:393 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-65e68a69 | this.Load 외 2 | FP00596_RowExcelPopup.cs:394 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-c6851de1 | this.Load 외 2 | FP00596_RowExcelPopup.cs:399 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed298e95 | this.Load 외 2 | FP00596_RowExcelPopup.cs:400 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-38c9120a | this.Load 외 2 | FP00596_RowExcelPopup.cs:405 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3d6bbf8e | this.Load 외 2 | FP00596_RowExcelPopup.cs:406 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ea69dfc1 | this.Load 외 2 | FP00596_RowExcelPopup.cs:417 | if (OnSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-598276d8 | this.Load 외 2 | FP00596_RowExcelPopup.cs:420 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-128cbd7c | this.Load 외 2 | FP00596_RowExcelPopup.cs:421 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-334a75ed | this.Load 외 2 | FP00596_RowExcelPopup.cs:422 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-51b138bd | this.Load 외 2 | FP00596_RowExcelPopup.cs:423 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2d76b3c9 | this.Load 외 2 | FP00596_RowExcelPopup.cs:424 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1d601a9c | this.Load 외 2 | FP00596_RowExcelPopup.cs:425 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-924380e6 | this.Load 외 2 | FP00596_RowExcelPopup.cs:426 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00596_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-315cef4d | FindButton | FP00596_RowExcelPopup.cs:296 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6ffaf700 | FindButton | FP00596_RowExcelPopup.cs:297 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-37ea5947 | FindButton | FP00596_RowExcelPopup.cs:299 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00596_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c03110bb | this.Load | FP00596_RowExcelPopup.cs:173 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9739eca6 | this.Load | FP00596_RowExcelPopup.cs:175 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00596_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c09aa2ab | (진입점 미연결) | FP00596_RowExcelPopup.cs:705 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-edbe69e6 | (진입점 미연결) | FP00596_RowExcelPopup.cs:706 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-5ed260cf | (진입점 미연결) | FP00596_RowExcelPopup.cs:707 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-3f12420f | (진입점 미연결) | FP00596_RowExcelPopup.cs:708 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-ab850dd0 | (진입점 미연결) | FP00596_RowExcelPopup.cs:709 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-90ed199c | (진입점 미연결) | FP00596_RowExcelPopup.cs:710 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-b564e041 | (진입점 미연결) | FP00596_RowExcelPopup.cs:711 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a175b357 | (진입점 미연결) | FP00596_RowExcelPopup.cs:713 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-66f48fa8 | (진입점 미연결) | FP00596_RowExcelPopup.cs:714 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-6b86581e | (진입점 미연결) | FP00596_RowExcelPopup.cs:718 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-16469602 | (진입점 미연결) | FP00596_RowExcelPopup.cs:719 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00596_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cffde342 | this.Load | FP00596_RowExcelPopup.cs:208 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_FROM"].ToString()) < Convert.ToDecimal(thi… | DATA_OP | Filter["BUCKET_FROM"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1f75306b | this.Load | FP00596_RowExcelPopup.cs:212 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6d44a2c4 | this.Load | FP00596_RowExcelPopup.cs:213 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | sEndDay | 행/컬럼 값 대입 |  |  |  |
| AC-0207e517 | this.Load | FP00596_RowExcelPopup.cs:216 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | Filter["BUCKET_FROM"] | 화면 필드/플래그 변경 |  |  |  |
| AC-f3edcf6d | this.Load | FP00596_RowExcelPopup.cs:217 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | Filter["BUCKET_TO"] | 화면 필드/플래그 변경 |  |  |  |
| AC-54c8f510 | this.Load | FP00596_RowExcelPopup.cs:218 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | _BucketFromDate.ToString() + ":" + _BucketToDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-60264ee1 | this.Load | FP00596_RowExcelPopup.cs:222 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a4cc8ce4 | this.Load | FP00596_RowExcelPopup.cs:226 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-2994dd4f | this.Load | FP00596_RowExcelPopup.cs:228 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-6aa2961d | this.Load | FP00596_RowExcelPopup.cs:229 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-3d24fe70 | this.Load | FP00596_RowExcelPopup.cs:243 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |

## FP00596_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed2139fa | this.Load | FP00596_RowExcelPopup.cs:266 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4da5e40 | this.Load | FP00596_RowExcelPopup.cs:267 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00596_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cf60894 | (진입점 미연결) | FP00596_RowExcelPopup.cs:287 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00596_RowExcelPopup.lfn_setExchangeBatch_Excel

진입점: this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ for (iRow < dsSource.Tables[0].Rows.Count) ▸ if (!string.IsNullOrEmpty(dsSource.Tables[0].Rows[iRow]["QTY"].ToString()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3246acb5 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:967 | lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c32fe67 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:981 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-6294cdff | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:988 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4bc30a93 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:989 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f82ceb7d | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:990 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8433663d | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:991 | lambda | DATA_OP | each_row.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-218e9232 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:1008 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a87721d7 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:1009 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-071aa490 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:1010 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a42e2dc | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:1011 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-426d1fd9 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:1012 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-319b9a22 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:1013 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff19b587 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:1013 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7bca98fd | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00596_RowExcelPopup.cs:1031 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00596_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cabb9f7 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:739 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a74258d | this.btnUpload.Click | FP00596_RowExcelPopup.cs:739 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dceada7e | this.btnUpload.Click | FP00596_RowExcelPopup.cs:741 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d37fd5d8 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:742 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bf15ce1e | this.btnUpload.Click | FP00596_RowExcelPopup.cs:743 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-65a9daa7 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:745 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-828d58cb | this.btnUpload.Click | FP00596_RowExcelPopup.cs:747 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9b14fcfa | this.btnUpload.Click | FP00596_RowExcelPopup.cs:748 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-fea6e4b7 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:748 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-885cfac5 | this.btnUpload.Click | FP00596_RowExcelPopup.cs:755 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-00f6b54e | this.btnUpload.Click | FP00596_RowExcelPopup.cs:756 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-c4a4de8a | this.btnUpload.Click | FP00596_RowExcelPopup.cs:758 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00596_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62425c01 | this.btnSave.Click | FP00596_RowExcelPopup.cs:476 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-1ff4e48e | this.btnSave.Click | FP00596_RowExcelPopup.cs:477 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a596ee0b | this.btnSave.Click | FP00596_RowExcelPopup.cs:481 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix! After once seach, Try agagin.!") | 메시지 표시 |  |  |  |
| AC-6defd18e | this.btnSave.Click | FP00596_RowExcelPopup.cs:482 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b50b14d9 | this.btnSave.Click | FP00596_RowExcelPopup.cs:493 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].Rows[i]["MESSAGE"].ToString().Equals("Y")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-decfcc9c | this.btnSave.Click | FP00596_RowExcelPopup.cs:494 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].Rows[i]["MESSAGE"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30ecf0a9 | this.btnSave.Click | FP00596_RowExcelPopup.cs:498 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-7611ec8c | this.btnSave.Click | FP00596_RowExcelPopup.cs:498 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-066c835e | this.btnSave.Click | FP00596_RowExcelPopup.cs:503 | if (OnBeforeCheckData != null) | CALL_BASE | OnBeforeCheckData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1207e31 | this.btnSave.Click | FP00596_RowExcelPopup.cs:505 | if (OnBeforeCheckData != null) ▸ if (bCheck == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58fce0cb | this.btnSave.Click | FP00596_RowExcelPopup.cs:514 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7d749b6f | this.btnSave.Click | FP00596_RowExcelPopup.cs:515 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-51a70efc | this.btnSave.Click | FP00596_RowExcelPopup.cs:516 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b4d0167d | this.btnSave.Click | FP00596_RowExcelPopup.cs:517 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9af29db9 | this.btnSave.Click | FP00596_RowExcelPopup.cs:518 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a9f0f8b2 | this.btnSave.Click | FP00596_RowExcelPopup.cs:519 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-894452e2 | this.btnSave.Click | FP00596_RowExcelPopup.cs:527 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-9d9b46c2 | this.btnSave.Click | FP00596_RowExcelPopup.cs:528 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d9b9556c | this.btnSave.Click | FP00596_RowExcelPopup.cs:529 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7094bfd1 | this.btnSave.Click | FP00596_RowExcelPopup.cs:530 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c9536db8 | this.btnSave.Click | FP00596_RowExcelPopup.cs:531 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-94f527ab | this.btnSave.Click | FP00596_RowExcelPopup.cs:532 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7b81cf1d | this.btnSave.Click | FP00596_RowExcelPopup.cs:533 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-686116c5 | this.btnSave.Click | FP00596_RowExcelPopup.cs:534 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f66e81bf | this.btnSave.Click | FP00596_RowExcelPopup.cs:539 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1f1cf6d | this.btnSave.Click | FP00596_RowExcelPopup.cs:542 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-49d7b278 | this.btnSave.Click | FP00596_RowExcelPopup.cs:544 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-a463cf14 | this.btnSave.Click | FP00596_RowExcelPopup.cs:547 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-2154cac1 | this.btnSave.Click | FP00596_RowExcelPopup.cs:552 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-3ff4e8df | this.btnSave.Click | FP00596_RowExcelPopup.cs:553 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-28f0397e | this.btnSave.Click | FP00596_RowExcelPopup.cs:560 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e19f122e | this.btnSave.Click | FP00596_RowExcelPopup.cs:563 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70f6a553 | this.btnSave.Click | FP00596_RowExcelPopup.cs:579 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (dsValidation != null) ▸ if (dsValidation.Tables.Count > 0) ▸ if… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-2f5c1078 | this.btnSave.Click | FP00596_RowExcelPopup.cs:582 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (dsValidation != null) ▸ if (dsValidation.Tables.Count > 0) ▸ if… | POPUP | new Planning.UIL.FP00594_InValidationExcelPopup | ("InvalidExcelPopup", dsValidation, "") | 팝업/폼 생성 |  |  |  |
| AC-6af9d964 | this.btnSave.Click | FP00596_RowExcelPopup.cs:583 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (dsValidation != null) ▸ if (dsValidation.Tables.Count > 0) ▸ if… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-05870594 | this.btnSave.Click | FP00596_RowExcelPopup.cs:584 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (dsValidation != null) ▸ if (dsValidation.Tables.Count > 0) ▸ if… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5dcd0251 | this.btnSave.Click | FP00596_RowExcelPopup.cs:608 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b01a6772 | this.btnSave.Click | FP00596_RowExcelPopup.cs:619 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f0e9224e | this.btnSave.Click | FP00596_RowExcelPopup.cs:622 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | FLAG | bUploadSaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3f323444 | this.btnSave.Click | FP00596_RowExcelPopup.cs:623 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f15cefc5 | this.btnSave.Click | FP00596_RowExcelPopup.cs:628 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-c289ff2a | this.btnSave.Click | FP00596_RowExcelPopup.cs:629 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fca5f7e7 | this.btnSave.Click | FP00596_RowExcelPopup.cs:635 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-bdefd9a8 | this.btnSave.Click | FP00596_RowExcelPopup.cs:672 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-2ac56bbf | this.btnSave.Click | FP00596_RowExcelPopup.cs:674 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-382fa4c2 | this.btnSave.Click | FP00596_RowExcelPopup.cs:675 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d0d551b3 | this.btnSave.Click | FP00596_RowExcelPopup.cs:685 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-dac95117 | this.btnSave.Click | FP00596_RowExcelPopup.cs:686 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-83066f48 | this.btnSave.Click | FP00596_RowExcelPopup.cs:690 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-210cbbc9 | this.btnSave.Click | FP00596_RowExcelPopup.cs:691 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2ac22b7a | this.btnSave.Click | FP00596_RowExcelPopup.cs:692 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-87bb4513 | this.btnSave.Click | FP00596_RowExcelPopup.cs:693 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6b60699d | this.btnSave.Click | FP00596_RowExcelPopup.cs:694 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-83f4d62d | this.btnSave.Click | FP00596_RowExcelPopup.cs:695 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00596_RowExcelPopup.SearchListInfoAll

진입점: this.btnUpload.Click [if (bUpload)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abca6fdb | this.btnUpload.Click [if (bUpload)] | FP00596_RowExcelPopup.cs:945 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e0f84b0 | this.btnUpload.Click [if (bUpload)] | FP00596_RowExcelPopup.cs:946 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-61e71317 | this.btnUpload.Click [if (bUpload)] | FP00596_RowExcelPopup.cs:949 |  | FLAG | dtDimension | siMain.GetSpdTitle(sProgramID, sUserID, sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-4e5a133e | this.btnUpload.Click [if (bUpload)] | FP00596_RowExcelPopup.cs:949 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-365697c1 | this.btnUpload.Click [if (bUpload)] | FP00596_RowExcelPopup.cs:952 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_UOMInfo_ALL") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-21195f41 | this.btnUpload.Click [if (bUpload)] | FP00596_RowExcelPopup.cs:953 |  | FLAG | dsUomInfoAll | dtUomAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c90fe180 | this.btnUpload.Click [if (bUpload)] | FP00596_RowExcelPopup.cs:953 |  | DATA_OP | dtUomAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4db06f2e | this.btnUpload.Click [if (bUpload)] | FP00596_RowExcelPopup.cs:955 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_YieldInfo_Child", Filter["INSTANCE_ID"].ToString(), Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-325ab258 | this.btnUpload.Click [if (bUpload)] | FP00596_RowExcelPopup.cs:956 |  | FLAG | dsYieldInfoAll | dtYieldAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-82564b49 | this.btnUpload.Click [if (bUpload)] | FP00596_RowExcelPopup.cs:956 |  | DATA_OP | dtYieldAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP00596_RowExcelPopup.SetSheetColor

진입점: this.Load [if (OnSearchData != null) ▸ try] / this.btnFind.Click [if (OnSearchData != null) ▸ try] / FindButton [if (OnSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51845cd7 | this.Load [if (OnSearchData != null) ▸ try] 외 2 | FP00596_RowExcelPopup.cs:442 | for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*Batch") != -1) | GRID_SET | siMain.ActiveSheet.Cells[0, idx, siMain.GetMaxRowIndex(), idx].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-ccd6d04c | this.Load [if (OnSearchData != null) ▸ try] 외 2 | FP00596_RowExcelPopup.cs:446 | for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*Seq") != -1) | GRID_SET | siMain.ActiveSheet.Cells[0, idx, siMain.GetMaxRowIndex(), idx].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |

## FP00596_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff0857fd | this.Load | FP00596_RowExcelPopup.cs:279 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca63f887 | this.Load | FP00596_RowExcelPopup.cs:280 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

