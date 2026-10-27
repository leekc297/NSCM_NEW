# AS-IS 액션 대조표 — FP00604

> 원천: `Doc/asisfacts/screens/FP00604/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 685행 · 메서드 78 · 종류 DATA_OP 194 · UI_PROP 94 · FLAG 63 · GRID_SET 60 · RETURN 52 · CALL_EXT 36 · VALUE_SET 35 · POPUP 30 · COMBO_DATA 25 · UI_MISC 20 · MESSAGE 16 · GRID_INIT 16 · LIST_REBIND 13 · THROW 9 · ENDPOINT 6 · GRID_STYLE 5 · STATE 4 · CALL_BASE 3 · GRID_LOCK 2 · STATE_RESET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 39


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d70b79fa | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3350 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-f882deb7 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3356 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-7910abee | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3364 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-d61e13d7 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3365 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-2f9bfad2 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3366 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-ad487fbe | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3367 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-a40bf3b3 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3369 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-401fd9c8 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3370 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-a8de5ae6 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3371 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-0318f96a | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3372 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-ea535738 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3373 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c70f5b1 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3374 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-e49cb6e4 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3375 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc85c0e7 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3376 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-a93ccd0a | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3379 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-08abb2cb | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3564 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-06f2685e | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3565 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-a09218b7 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3566 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-5d386a8a | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3567 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-c949d5d8 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3569 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-d41a2762 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3570 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-7aba7d81 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3571 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-d59003f4 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3572 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-3fdb494f | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3573 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-af8abf73 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3574 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-984b762b | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3575 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc4ca507 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3576 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-7e60f46b | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3578 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b96b2651 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3483 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-89ded34e | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3484 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebc963df | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3485 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ab6ffa9 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3486 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c82fdfcf | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3487 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-de049985 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3490 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a84c373c | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3494 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-84cfa845 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3495 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4935a6ed | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3481 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-390fb6bc | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3511 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1f44eef | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3514 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-bceb950e | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3517 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-8fd874eb | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3520 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-f11d72a9 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3523 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-75f7d8f8 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3526 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-e468a16e | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3532 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-89a51eb1 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3534 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-702e9508 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3455 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-703dd514 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3419 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e91ac49 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3420 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa1ffbd5 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3421 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e6e93b7 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3422 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd17f156 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3423 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-087ef17e | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3424 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4fa4b0ac | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3426 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c53e741c | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3427 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff73b958 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3430 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5365a7ee | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3431 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c677eeb | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3432 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc919275 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3417 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-3b6c1675 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3440 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-35155109 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3441 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-66079715 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3446 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-066f34e6 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3392 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00604_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a728e21 | .ctor | FP00604_MeasureSetForm_Popup.cs:79 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-3fcf968d | .ctor | FP00604_MeasureSetForm_Popup.cs:80 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-12a9330b | .ctor | FP00604_MeasureSetForm_Popup.cs:81 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-d455892d | .ctor | FP00604_MeasureSetForm_Popup.cs:83 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00604_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ba730a2 | this.btnOK.Click | FP00604_MeasureSetForm_Popup.cs:351 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-9a2644bd | this.btnOK.Click | FP00604_MeasureSetForm_Popup.cs:352 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-3e85184d | this.btnOK.Click | FP00604_MeasureSetForm_Popup.cs:359 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-b5ba9b4f | this.btnOK.Click | FP00604_MeasureSetForm_Popup.cs:360 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00604_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec08a8fa | this.btnSet.Click | FP00604_MeasureSetForm_Popup.cs:321 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-9a7fa423 | this.btnSet.Click | FP00604_MeasureSetForm_Popup.cs:322 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-313a9317 | this.btnSet.Click | FP00604_MeasureSetForm_Popup.cs:324 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1fa17d60 | this.btnSet.Click | FP00604_MeasureSetForm_Popup.cs:325 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc23fcf4 | this.btnSet.Click | FP00604_MeasureSetForm_Popup.cs:327 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-7464a57d | this.btnSet.Click | FP00604_MeasureSetForm_Popup.cs:329 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-1f89ce38 | this.btnSet.Click | FP00604_MeasureSetForm_Popup.cs:330 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00604_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b7c5e12 | Dispose | FP00604_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00604_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7879d475 | this.Load | FP00604_MeasureSetForm_Popup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00604_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3166b120 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:218 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-3df1dec3 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:219 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-abe1700b | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:220 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-877dd903 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:222 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb766511 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:223 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-69ce2b0e | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:224 |  | DATA_OP | ctrls.Add | (chk_resultExp) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b22c77f | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:226 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6002adc | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:227 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7d21956 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:228 |  | DATA_OP | ctrls.Add | (chk_offtime) | 데이터 객체 조작/조회 |  |  |  |
| AC-98f9d7d6 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_gap) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a64b774 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_gapWPP) | 데이터 객체 조작/조회 |  |  |  |
| AC-28aa6339 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-83a9b8ff | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-8237796e | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e4793b6 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:238 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5daa612 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-27a66032 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-af24d9da | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:242 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-61186ca8 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_result_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1c8393a | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:245 |  | DATA_OP | ctrls.Add | (chk_gap_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-76c0cfc7 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:246 |  | DATA_OP | ctrls.Add | (chk_gapWPP_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9664213 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_resultExp_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-45b6dc77 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:249 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-90c89061 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-49183800 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:254 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-2481bb0c | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:254 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-68df4c85 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:261 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-059a64fb | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:265 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |

## FP00604_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93852d9f | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4b3f455f | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6747f7f9 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7e4e6233 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bc44b1a7 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5961c882 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_resultExp.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9110c6d3 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-cd67546a | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f3990f81 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_offtime.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4a79db3c | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_gap.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-32e06952 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_gapWPP.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-fc637322 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9d2d0904 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a8c4f593 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-271236bb | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e944786d | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4247d421 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a13bb4c6 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2880686b | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_result_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2d6517aa | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_gap_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e0c31119 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_gapWPP_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-307029f1 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:167 |  | VALUE_SET | chk_resultExp_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-74f7e05c | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-08d2ee73 | this.Load 외 1 | FP00604_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00604_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96fd9d1e | (진입점 미연결) | FP00604_MeasureSetForm_Popup.cs:414 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-f02596a8 | (진입점 미연결) | FP00604_MeasureSetForm_Popup.cs:425 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c5dd527 | (진입점 미연결) | FP00604_MeasureSetForm_Popup.cs:436 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00604_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4057970 | this.Load | FP00604_MeasureSetForm_Popup.cs:94 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-46eb3499 | this.Load | FP00604_MeasureSetForm_Popup.cs:102 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00604_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7e0ce57 | this.btnSet.Click 외 1 | FP00604_MeasureSetForm_Popup.cs:366 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7831331b | this.btnSet.Click 외 1 | FP00604_MeasureSetForm_Popup.cs:374 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-89fe95b1 | this.btnSet.Click 외 1 | FP00604_MeasureSetForm_Popup.cs:374 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-8c5afe31 | this.btnSet.Click 외 1 | FP00604_MeasureSetForm_Popup.cs:391 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a165ea62 | this.btnSet.Click 외 1 | FP00604_MeasureSetForm_Popup.cs:402 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00604_PlanByModel_Pack..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2bbf76d | .ctor | FP00604_PlanByModel_Pack.cs:187 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00604_PlanByModel_Pack.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PACK_MEMO")] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7a43a8d | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1279 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c797a936 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1280 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1e098d1a | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1281 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-70bbfb05 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1282 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0b80811b | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1283 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e912b34f | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1284 |  | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-80533c53 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1286 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5ee3dfba | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1287 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-cb27a827 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1289 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2e0c71b1 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1290 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4fb287ac | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1292 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e5f0469 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1293 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-a7eca303 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1295 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-20279e9e | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1296 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-5b773cdc | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1298 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00604_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-60f1ce48 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1299 |  | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-6e3995e6 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1321 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-b10f1af3 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1330 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-60c682c5 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1331 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-d3f87fcc | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1332 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-3dc6ff9c | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1333 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-a53d4b2f | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1334 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00604_PlanByModel_Pack.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PACK_MEMO")] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21b921af | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1340 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; DataTable dtWeekMonth = null; string… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2f82619 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1354 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a91eceea | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1355 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-40856576 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1362 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_day2WeekAndMonth", Filter["BUCKET_FROM"], Filter["BUCKET_TO… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aae83689 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1425 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_currDateCol", Filter["INSTANCE_ID"], Filter["BUCKET_FROM"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00604_PlanByModel_Pack.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a9607b1 | this.btnBucket.Click | FP00604_PlanByModel_Pack.cs:2559 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-38547afa | this.btnBucket.Click | FP00604_PlanByModel_Pack.cs:2562 |  | POPUP | new FP00599_BucketSetForm_Popup | ("FP00604", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-9f2318dc | this.btnBucket.Click | FP00604_PlanByModel_Pack.cs:2563 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5d614be2 | this.btnBucket.Click | FP00604_PlanByModel_Pack.cs:2564 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-28c6cb4f | this.btnBucket.Click | FP00604_PlanByModel_Pack.cs:2570 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00604_PlanByModel_Pack.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a490461 | this.btnCatagory.Click | FP00604_PlanByModel_Pack.cs:2523 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-d73cdb0c | this.btnCatagory.Click | FP00604_PlanByModel_Pack.cs:2526 |  | POPUP | new FP00604_MeasureSetForm_Popup | ("FP00604", "Main",false, "") | 팝업/폼 생성 |  |  |  |
| AC-7cc06351 | this.btnCatagory.Click | FP00604_PlanByModel_Pack.cs:2527 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-998e82d7 | this.btnCatagory.Click | FP00604_PlanByModel_Pack.cs:2528 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-46e74728 | this.btnCatagory.Click | FP00604_PlanByModel_Pack.cs:2535 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00604_PlanByModel_Pack.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1757bf2b | this.btnColumn.Click | FP00604_PlanByModel_Pack.cs:2499 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-ac08d90b | this.btnColumn.Click | FP00604_PlanByModel_Pack.cs:2502 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00604", SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-b22e97fd | this.btnColumn.Click | FP00604_PlanByModel_Pack.cs:2503 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-614431f9 | this.btnColumn.Click | FP00604_PlanByModel_Pack.cs:2504 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00604_PlanByModel_Pack.btnMemo_Click

진입점: this.usrButton3.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f639039 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2609 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-0a4b73a3 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2610 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83ee1a3e | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2613 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6fb1982c | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2614 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-ba687fa1 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2615 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-e3c59ecb | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2616 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-dcabf80f | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2617 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-badaf7af | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2618 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-0be0c598 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2619 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ed55f74a | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2619 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7792b62e | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2620 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-195fd744 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2621 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f8c12c18 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2622 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-5e14b84d | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2623 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2fa2d1ac | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2624 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5905e111 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2625 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0157e108 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2626 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0a7a2b48 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2627 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-df478f59 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2628 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a65735fd | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2630 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d49b248d | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2631 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-2b51af49 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2632 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-d1c3eb19 | this.usrButton3.Click | FP00604_PlanByModel_Pack.cs:2633 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00604_PlanByModel_Pack.btnPlanInfo_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87117cbd | this.usrButton1.Click | FP00604_PlanByModel_Pack.cs:2583 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-5bb47914 | this.usrButton1.Click | FP00604_PlanByModel_Pack.cs:2584 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75d67f9f | this.usrButton1.Click | FP00604_PlanByModel_Pack.cs:2590 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-f9a498db | this.usrButton1.Click | FP00604_PlanByModel_Pack.cs:2593 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-97c55bba | this.usrButton1.Click | FP00604_PlanByModel_Pack.cs:2594 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bd05381a | this.usrButton1.Click | FP00604_PlanByModel_Pack.cs:2594 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c33cae23 | this.usrButton1.Click | FP00604_PlanByModel_Pack.cs:2595 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-af59f221 | this.usrButton1.Click | FP00604_PlanByModel_Pack.cs:2596 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9f69b373 | this.usrButton1.Click | FP00604_PlanByModel_Pack.cs:2598 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d71fdfab | this.usrButton1.Click | FP00604_PlanByModel_Pack.cs:2599 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00604_PlanByModel_Pack.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87aa8aec | this.btnSql.Click | FP00604_PlanByModel_Pack.cs:2643 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-20311790 | this.btnSql.Click | FP00604_PlanByModel_Pack.cs:2646 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f18a5834 | this.btnSql.Click | FP00604_PlanByModel_Pack.cs:2647 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-82768b73 | this.btnSql.Click | FP00604_PlanByModel_Pack.cs:2649 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00604_PLANBYMODEL_PACK_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-c256fafa | this.btnSql.Click | FP00604_PlanByModel_Pack.cs:2650 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00604_PLANBYMODEL_PACK_MEMO") | 데이터 객체 조작/조회 |  |  |  |
| AC-29d0a85a | this.btnSql.Click | FP00604_PlanByModel_Pack.cs:2652 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00604_PlanByModel_Pack.CheckAndGetMeasure

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (ds…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c854c407 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2010 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9b50238 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2010 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-a718ed61 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2012 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00604_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5026f469 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2012 |  | POPUP | new FP00604_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-0437e1cb | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2013 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b06f495f | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2013 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-273dba5c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2017 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-de0abfda | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2018 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-768ffbcc | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2019 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-3756e78b | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2020 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-64ae0c72 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2021 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a715cbd | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:2022 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00604_PlanByModel_Pack.CreateFilterDataSet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try] / this.btnCatagory.Click [if (frm.Dialog…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7f45b18 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1752 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1e9f250f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1764 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-ab77ba54 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1765 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-74ac076e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1786 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bbe32a96 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1787 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e88912dc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1791 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-64a90211 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1792 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a3f76b8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1796 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6651d810 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1802 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3dc3f1b0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1803 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d9fc43c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1807 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d76f5f1a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1808 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e28a179 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1812 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-603dedcc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1818 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d9dc379 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1819 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-01c63d81 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1823 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-62987f3a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1824 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-feae3337 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1828 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-19370cd0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1829 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3b85b3f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1833 | if (measure["chk_resultExp"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb75389a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1839 | if (measure["chk_gap"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-73ab8cc5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1844 | if (measure["chk_gapWPP"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-188909f6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1852 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b91c8007 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1853 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-45a58672 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1857 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c9d6db7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1858 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-881b91e3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1863 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d903c29 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1864 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9d29f26 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1868 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ca61c5d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1869 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-df9b2950 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1874 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-22fec08b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1875 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-88225adb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1879 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-df5fb661 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1880 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-62ac0477 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1884 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f767bca | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1885 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0942bcfa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1889 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-95193517 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1895 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-212f9c42 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1899 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a41ae4d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1909 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-610a8dea | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1910 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cba72cd7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1914 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-20be1a5c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1915 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-df85ff0f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1921 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb5eb519 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1922 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-af57616d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1926 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-afbb57c9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1927 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-77e1cf6e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1933 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4f02401 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1934 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1809d5d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1938 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f05c7d3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1939 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-55bbf1b5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1943 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-321a1f8f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1944 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d1d9cca | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1948 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c736e39c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1954 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-492c148e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1958 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc18286d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1986 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c412880 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1989 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ddd914b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1993 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-8155ff0f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1998 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f96ec4b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:2002 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-d892940b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:2004 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cef43e74 | this.Load | FP00604_PlanByModel_Pack.cs:432 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1422fecf | this.Load | FP00604_PlanByModel_Pack.cs:433 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f974ed8 | this.Load | FP00604_PlanByModel_Pack.cs:434 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00604_PlanByModel_Pack.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7263b670 | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2400 | if (sender == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6197e51c | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2406 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c5dc04f | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2408 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5000cc67 | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2425 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-1c0d1b38 | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2426 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |
| AC-3e91fa97 | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2450 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-4e9bbe1a | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2451 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-621939da | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2458 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(undefined).") | 메시지 표시 |  |  |  |
| AC-933eaaca | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2459 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-9142a750 | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2470 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ if (dayCount > 365) | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-1343142b | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2471 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ if (dayCount > 365) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-70f88d2a | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2478 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ if (dayCount > 28 * … | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(undefined).") | 메시지 표시 |  |  |  |
| AC-5af85d30 | dCalendar_planrange.ValueChanged | FP00604_PlanByModel_Pack.cs:2479 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ if (dayCount > 28 * … | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |

## FP00604_PlanByModel_Pack.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2b394a7 | DeleteButton | FP00604_PlanByModel_Pack.cs:616 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e758bba2 | DeleteButton | FP00604_PlanByModel_Pack.cs:617 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8eacec23 | Dispose | FP00604_PlanByModel_Pack.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00604_PlanByModel_Pack.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45a58a5d | EditButton | FP00604_PlanByModel_Pack.cs:623 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2cc9973 | EditButton | FP00604_PlanByModel_Pack.cs:624 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bd15eb4 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:670 |  | FLAG | base.ExcelOption | ExcelExportOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |
| AC-10244225 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:677 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5892d034 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:681 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99a3cd59 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:685 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-7e4aced5 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:689 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00604_PlanByModel_Pack.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2e8133d | ExcelButton | FP00604_PlanByModel_Pack.cs:639 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-28674595 | ExcelButton | FP00604_PlanByModel_Pack.cs:640 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-b87e8698 | ExcelButton | FP00604_PlanByModel_Pack.cs:642 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cd08eb83 | ExcelButton | FP00604_PlanByModel_Pack.cs:646 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-07221c6b | ExcelButton | FP00604_PlanByModel_Pack.cs:647 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-d6539814 | ExcelButton | FP00604_PlanByModel_Pack.cs:648 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-77865470 | ExcelButton | FP00604_PlanByModel_Pack.cs:651 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-b467fea9 | ExcelButton | FP00604_PlanByModel_Pack.cs:652 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-79f6db1d | ExcelButton | FP00604_PlanByModel_Pack.cs:653 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-89a2571e | ExcelButton | FP00604_PlanByModel_Pack.cs:655 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-ad33166e | ExcelButton | FP00604_PlanByModel_Pack.cs:656 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00604_PlanByModel_Pack.ExportExcelSimple

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fbbe38d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:699 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-526d513f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:702 | try ▸ if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9f7fac4 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:708 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c075880c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:716 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4e138ee | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:720 | try ▸ if (myarray.Length == 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6bb8fa53 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:721 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89a61d23 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:725 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1c622af | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:767 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.LoadObjectXml | (typeof(FarPoint.Win.Spread.SheetView), FarPoint.Win.Serializer.GetObjectXml(sv, "CopyShee… | ⚠ 의미 확인 필요 |  |  |  |
| AC-dbd26da8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:767 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.GetObjectXml | (sv, "CopySheet") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d868a176 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:773 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-27a0fdaf | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:787 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc4d020a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:791 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (RemoveActionCell == tr… | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-00f074c1 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:795 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-806e31d4 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:807 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-1ddd8ff6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:808 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-84c23514 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:817 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-6efd7cd5 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:818 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-f3293ea6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:824 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-7ac1e553 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:833 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c35ea23 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:835 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-00babcea | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:838 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.FrozenColumnCount | FrozenColumnCount | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-0178aa67 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:847 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (ignoreDepth > 0) ▸ for (i < newSheet.RowCount) ▸ for (j < collen) ▸ if (newSheet.Cells… | GRID_SET | newSheet.Cells[i, j].Value | null | 그리드 속성/값 설정 |  |  |  |
| AC-0d9f659f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:858 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-3bc574fc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:867 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-a29a9322 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:876 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b7f2319 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:883 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | UI_PROP | si.MaxRightMerge | 50 | 속성 MaxRightMerge 설정 |  |  |  |
| AC-5934a0d7 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:884 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | CALL_EXT | si.RightColMerge | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ef9670b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:889 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.SeperatedRows: case ExcelExp… | CALL_EXT | si.UnMerge | (newSheet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8554a3e8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:896 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 0, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-5bbc697c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:898 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-1a937a01 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:902 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-a4753113 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:904 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-aef15f57 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:907 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-75c4636a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:909 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-8a9f56d2 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:914 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-ee23951e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:929 | try | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d11af030 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:935 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d447c499 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:939 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00604_PlanByModel_Pack.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PACK_MAIN")] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-235964e2 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1267 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00604_PLANBYMODEL_PACK", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-12f371b7 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1269 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-be556de0 | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:1273 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.Find_Data_Memo

진입점: popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PACK_MEMO")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67c1243a | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… | FP00604_PlanByModel_Pack.cs:2185 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00604_PLANBYMODEL_PACK", Filter, _CurrentUser, pSysType, "SELECT_MEMO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bc81212c | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… | FP00604_PlanByModel_Pack.cs:2187 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-a5e6116c | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… | FP00604_PlanByModel_Pack.cs:2191 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.FindTotalColorStart

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6712b3b0 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1746 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d245d4e | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:1194 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b4b5de1 | this.Load | FP00604_PlanByModel_Pack.cs:200 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00604_PlanByModel_Pack.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PACK_MEMO") ▸ lambda] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d045dfeb | popSql.OnSql [if (programID == "PR_UI_FP00604_PLANBYMODEL_PA… 외 2 | FP00604_PlanByModel_Pack.cs:3052 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.GetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a14a5dd8 | this.Load [try] | FP00604_PlanByModel_Pack.cs:3060 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9e494903 | this.Load [try] | FP00604_PlanByModel_Pack.cs:3061 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e60c44ee | this.Load [try] | FP00604_PlanByModel_Pack.cs:3061 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f97ec351 | this.Load [try] | FP00604_PlanByModel_Pack.cs:3063 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-8776c009 | this.Load [try] | FP00604_PlanByModel_Pack.cs:3065 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ab58c6be | this.Load [try] | FP00604_PlanByModel_Pack.cs:3068 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-313cb083 | this.Load [try] | FP00604_PlanByModel_Pack.cs:3069 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-5055307c | this.Load [try] | FP00604_PlanByModel_Pack.cs:3069 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-529affd9 | this.Load [try] | FP00604_PlanByModel_Pack.cs:3070 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e09150ca | this.Load [try] | FP00604_PlanByModel_Pack.cs:3071 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef3d95a4 | this.Load [try] | FP00604_PlanByModel_Pack.cs:3072 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-84e25657 | this.Load [try] | FP00604_PlanByModel_Pack.cs:3076 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00604_PlanByModel_Pack.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72eb1e1a | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3300 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-9ba34784 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3301 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.GetToDay

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a14ba42 | this.Load [try] | FP00604_PlanByModel_Pack.cs:3249 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-1bd53fb6 | this.Load [try] | FP00604_PlanByModel_Pack.cs:3250 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.GoDrawCellColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da05ab85 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:2028 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1cccd858 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:2093 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ee13d5d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:2094 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetBGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP00604_PlanByModel_Pack.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2a2a14d | this.Load | FP00604_PlanByModel_Pack.cs:266 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-eaa9b911 | this.Load | FP00604_PlanByModel_Pack.cs:269 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanAmendMA) | 데이터 객체 조작/조회 |  |  |  |
| AC-495e602c | this.Load | FP00604_PlanByModel_Pack.cs:271 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-bd900c8f | this.Load | FP00604_PlanByModel_Pack.cs:272 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-27a7d6a3 | this.Load | FP00604_PlanByModel_Pack.cs:275 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0ca6bfd | this.Load | FP00604_PlanByModel_Pack.cs:278 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6609360d | this.Load | FP00604_PlanByModel_Pack.cs:284 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-0d4ce407 | this.Load | FP00604_PlanByModel_Pack.cs:306 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3529e791 | this.Load | FP00604_PlanByModel_Pack.cs:307 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-11add77f | this.Load | FP00604_PlanByModel_Pack.cs:308 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5a2ea0c5 | this.Load | FP00604_PlanByModel_Pack.cs:314 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00604_PlanByModel_Pack.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-061cfe08 | this.Load | FP00604_PlanByModel_Pack.cs:235 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a4e696f0 | this.Load | FP00604_PlanByModel_Pack.cs:236 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5109286f | this.Load | FP00604_PlanByModel_Pack.cs:237 |  | UI_PROP | mcbo_prodtype.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-45ee27dd | this.Load | FP00604_PlanByModel_Pack.cs:238 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-375eba58 | this.Load | FP00604_PlanByModel_Pack.cs:239 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ab68832b | this.Load | FP00604_PlanByModel_Pack.cs:240 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00604_PlanByModel_Pack.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-079ee748 | this.Load | FP00604_PlanByModel_Pack.cs:446 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec5a0c26 | this.Load | FP00604_PlanByModel_Pack.cs:447 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a30e5b5e | this.Load | FP00604_PlanByModel_Pack.cs:451 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00604_PlanByModel_Pack.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b60474c | InsertButton | FP00604_PlanByModel_Pack.cs:608 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c6a220d | InsertButton | FP00604_PlanByModel_Pack.cs:609 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0433f863 | memo_menu.Click | FP00604_PlanByModel_Pack.cs:2977 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aaee4785 | memo_menu.Click | FP00604_PlanByModel_Pack.cs:2980 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b33baab7 | memo_menu.Click | FP00604_PlanByModel_Pack.cs:2986 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00604_PlanByModel_Pack.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75632e9d | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3001 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8076db8a | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3004 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4aa29c4c | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3022 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-69d8e44a | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3023 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6618aef1 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3024 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2bd2fc0b | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3025 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7f7233d4 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3026 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-4e843163 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3027 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-18cdb796 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3028 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-71bab614 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3029 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dfadf697 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3030 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00604_PlanByModel_Pack.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25805062 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2895 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75bdc890 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2898 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b834dea | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2922 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00604_PlanByModel_Pack.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33796c2d | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2936 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0de7b16 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2939 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61fb3ee7 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2963 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00604_PlanByModel_Pack.OpenLineMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-556ffd68 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2661 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-7c82e997 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2662 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-664f884f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2663 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-c41218f1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2663 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2bc2f4b2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2664 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-e84087e8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2665 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4b8541b7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2666 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cad9e75f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2671 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1bb51e5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2674 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00604_PlanByModel_Pack.OpenMaterialMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c79f5547 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2680 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-5246bcc1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2681 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-904949ec | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2682 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-3988ee4a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2682 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4fdaf823 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2683 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-a39582cd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2684 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-06bf8892 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2685 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-65f2e0eb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2689 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a38724e4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00604_PlanByModel_Pack.cs:2691 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00604_PlanByModel_Pack.Query

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bebf581 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1502 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-2520ff96 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1502 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fe8be60c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1503 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-56e9349b | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1503 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e2af12a9 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1504 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-a8485ea2 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1504 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-324cebe7 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1507 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c2d5e214 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1514 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-d7c88110 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1519 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-22eadf17 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1520 |  | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-bcb50f65 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00604_PlanByModel_Pack.cs:1522 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00604_PlanByModel_Pack.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnBucket.Click [if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c40e980f | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1539 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-e4f52c77 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1540 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-21a6653c | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1541 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-c08a812b | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1542 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-e26cc64d | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1554 | if (monthInfo != null) | FLAG | on_redraw | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dd5b9a92 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1559 | if (monthInfo != null) ▸ if (!on_redraw) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, bUse_month, bUse_week, bUse_day, 2, FPExtensions.DateColumnType.TYPEZERO, FPExt… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b12937dc | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1563 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-b4fdaa94 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1567 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | FLAG | on_redraw | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2ca82402 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1568 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1566084 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1570 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-496372ba | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1571 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3b73728 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1573 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-379ef55d | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1581 | if (monthInfo != null) | UI_PROP | siMain.MergeVerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-37838af2 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1582 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb3ac13d | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1587 | if (monthInfo != null) | UI_PROP | mct.FormatString | "###,###.#" | 속성 FormatString 설정 |  |  |  |
| AC-2cd881d0 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1609 | if (monthInfo != null) ▸ else of (bUseNote == false) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c126f6e | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1612 | if (monthInfo != null) ▸ else of (bUseNote == false) ▸ if (bHideZero) | CALL_EXT | siMain.SetFormat | ("#,###.##", siMain.ActiveSheet.FrozenColumnCount, -1, bHideZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c073a653 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1616 | if (monthInfo != null) ▸ else of (bUseNote == false) ▸ else of (bHideZero) | CALL_EXT | siMain.SetFormat | ("#,##0.##", siMain.ActiveSheet.FrozenColumnCount, -1, bHideZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cab41f38 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1621 | if (monthInfo != null) | CALL_EXT | MemoService.ShowMemo | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f3fd859 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1622 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4467e4f0 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1660 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor | (line, start, line, siMain.GetMaxColumnIndex(), tmp) | 그리드 표시 설정 |  |  |  |
| AC-8a91dbd0 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1679 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-486e741f | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1683 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-0bb6d730 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1685 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-63d77baf | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1689 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-e16849d2 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1705 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-0d6603c5 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00604_PlanByModel_Pack.cs:1720 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00604_PlanByModel_Pack.RefreshHeaderOnly

진입점: this.Load [try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (frm._bSearchFlag == true) ▸ else of (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce0f2aa2 | this.Load [try] 외 3 | FP00604_PlanByModel_Pack.cs:471 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-8406ec82 | this.Load [try] 외 3 | FP00604_PlanByModel_Pack.cs:472 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-ba87da5f | this.Load [try] 외 3 | FP00604_PlanByModel_Pack.cs:473 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f1941eb | this.Load [try] 외 3 | FP00604_PlanByModel_Pack.cs:474 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5dc37789 | this.Load [try] 외 3 | FP00604_PlanByModel_Pack.cs:475 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bcbb5701 | this.Load [try] 외 3 | FP00604_PlanByModel_Pack.cs:482 |  | UI_PROP | spdMain.HorizontalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 HorizontalScrollBarPolicy 설정 |  |  |  |
| AC-102faed6 | this.Load [try] 외 3 | FP00604_PlanByModel_Pack.cs:483 |  | UI_PROP | spdMain.VerticalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 VerticalScrollBarPolicy 설정 |  |  |  |

## FP00604_PlanByModel_Pack.RefreshSpreadSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogRe…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fe672b0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1442 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-08ef95cc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1442 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-f009ea26 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1447 | try ▸ if (!dsMain.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90bcb1a6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1462 | try | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-78686956 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1469 | try ▸ if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b4a8631b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00604_PlanByModel_Pack.cs:1487 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00604_PlanByModel_Pack.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d29ea9a | popSql.OnSql | FP00604_PlanByModel_Pack.cs:3269 | if (programID == "PR_UI_FP00604_PLANBYMODEL_PACK_MAIN") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-1a3266e9 | popSql.OnSql | FP00604_PlanByModel_Pack.cs:3278 | if (programID == "PR_UI_FP00604_PLANBYMODEL_PACK_MEMO") | RETURN | return Find_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-c68f4fb4 | popSql.OnSql | FP00604_PlanByModel_Pack.cs:3282 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03c5d8b0 | SaveButton | FP00604_PlanByModel_Pack.cs:630 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f863137 | SaveButton | FP00604_PlanByModel_Pack.cs:631 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00604_PlanByModel_Pack.SaveSimplexcel

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcf3f798 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:965 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < spSheet.Columns.Count) | DATA_OP | spSheet.Columns[i].DataField.ToUpper().Contains | ("W0") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb5f2eac | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:970 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < spSheet.Columns.Count) | DATA_OP | spSheet.Columns[i].DataField.ToUpper().Contains | ("D0") | 데이터 객체 조작/조회 |  |  |  |
| AC-229d0d79 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:986 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (i == 0) | DATA_OP | xSheet.ColumnWidths[j] | spSheet.ColumnHeader.Columns[j].Width / 9 | 행/컬럼 값 대입 |  |  |  |
| AC-64c88868 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:988 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j] | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-8a6410c9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:993 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Bottom | 그리드 속성/값 설정 |  |  |  |
| AC-cd997835 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:996 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-74ec1b7e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:999 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-79f653f5 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1002 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-02d0e8e0 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1005 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Justify | 그리드 속성/값 설정 |  |  |  |
| AC-18dae97e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1008 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-45b47d89 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1011 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-15b83226 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1018 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Left | 그리드 속성/값 설정 |  |  |  |
| AC-6bc852f6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1021 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Center | 그리드 속성/값 설정 |  |  |  |
| AC-dcd61c38 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1024 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.None | 그리드 속성/값 설정 |  |  |  |
| AC-bd4b0a34 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1027 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.General | 그리드 속성/값 설정 |  |  |  |
| AC-7d0cc63c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1030 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Justify | 그리드 속성/값 설정 |  |  |  |
| AC-17530681 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1033 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Right | 그리드 속성/값 설정 |  |  |  |
| AC-d4781853 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1037 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].ColSpan | cell.ColumnSpan | 그리드 속성/값 설정 |  |  |  |
| AC-b614280e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1038 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].RowSpan | cell.RowSpan | 그리드 속성/값 설정 |  |  |  |
| AC-f6ad88a6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1039 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Border | Simplexcel.CellBorder.All | 그리드 속성/값 설정 |  |  |  |
| AC-292a6a3e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1041 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-b13c9779 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1047 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (!fg.IsEmpty) | GRID_SET | xSheet.Cells[i, j].TextColor | Simplexcel.Color.FromArgb(fg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-3a1b87df | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1047 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (!fg.IsEmpty) | CALL_EXT | fg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-38662c0c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1053 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Fill.BackgroundColor | Simplexcel.Color.FromArgb(0, 240, 240, 240) | 그리드 속성/값 설정 |  |  |  |
| AC-c63abad6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1056 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (cell.Font != null) | GRID_SET | xSheet.Cells[i, j].FontSize | (int)cell.Font.Size | 그리드 속성/값 설정 |  |  |  |
| AC-c2b96d57 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1059 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ else of (cell.Font != n… | GRID_SET | xSheet.Cells[i, j].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-2b44aa0f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1081 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-d9216116 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1082 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-a824817a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1090 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-8cf6f8b7 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1091 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-394d8657 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1096 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-7e5fc240 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1097 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-6bb64378 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1103 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | ss | 그리드 속성/값 설정 |  |  |  |
| AC-8338c293 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1109 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-2984b70c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1119 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-0b747b9e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1120 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-94c099a3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1126 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-122a939e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1127 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-9d642738 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1132 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-af5c7dd5 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1136 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-d8ea6881 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1143 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!fg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].TextColor | Simplexcel.Color.FromArgb(fg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-daf53a40 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1143 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!fg.IsEmpty) | CALL_EXT | fg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f4c0caf | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1147 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!bg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.FromArgb(bg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-c1046998 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1147 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!bg.IsEmpty) | CALL_EXT | bg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c90b28af | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1151 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ else of (!bg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-c0f0e443 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1156 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].FontSize | (int)spSheet.Cells[i, j].Font.Size | 그리드 속성/값 설정 |  |  |  |
| AC-07f1902a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1158 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].Bold | true | 그리드 속성/값 설정 |  |  |  |
| AC-1e2cbee8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1160 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].Italic | true | 그리드 속성/값 설정 |  |  |  |
| AC-14d4ff71 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1163 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ else of (spSheet.Cells[i, j].Font !… | GRID_SET | xSheet.Cells[id, jd].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-0bb6ecdf | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1165 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) | GRID_SET | xSheet.Cells[id, jd].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-8c83c59a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1170 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) | GRID_INIT | xSheet.FreezeTopLeft | (spSheet.ColumnHeader.RowCount, froz) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9708ed88 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1171 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) | DATA_OP | workbook.Add | (xSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f04347b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1185 |  | UI_PROP | workbook.Title | name | 속성 Title 설정 |  |  |  |
| AC-443adde3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1186 |  | UI_PROP | workbook.Author | "GSCM,FP, logged as " + this.UserInfo.UserId | 속성 Author 설정 |  |  |  |
| AC-246af48c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00604_PlanByModel_Pack.cs:1188 |  | CALL_EXT | workbook.Save | (fileName) | ⚠ 의미 확인 필요 |  |  |  |

## FP00604_PlanByModel_Pack.SetChangeControl

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / cbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / mcbo_prodtype.SelectedIndexChanged / chk_allLine.CheckedChanged / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.chkInAct.CheckedChanged / this.chk_allLine.CheckedChanged / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("W…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b15a97d | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:356 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee1848a2 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:356 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b99d08ef | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:365 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a8b1ef4d | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:366 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9b7eaed4 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:366 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8ed3b024 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:367 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4fb4b170 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:373 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c5058b94 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:374 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-fb629a0e | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:374 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3de92ed8 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:375 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-110349d2 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:381 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-5397425b | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:382 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-22d20a10 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:382 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e35987b5 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:383 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7453284f | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:389 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-b921e806 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:390 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-7266fcc3 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:390 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-dd32c635 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:391 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8904f152 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:398 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-27ad79bf | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:399 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f83058e9 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:399 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6fa7a8fd | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:400 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fdf81d26 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:406 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-6fde29c2 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:407 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-715790b6 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:407 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-2e7770c5 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:408 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-933ebe48 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:414 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-146572d3 | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:418 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PROD_TYPE"] = Filter["PRODTYPE_ID"]= CString.GetCheckedListValue(dtProdType, mcbo_… | 행/컬럼 값 대입 |  |  |  |
| AC-85e9125b | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:418 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PROD_TYPE"] | Filter["PRODTYPE_ID"]= CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues… | 행/컬럼 값 대입 |  |  |  |
| AC-ea1fef9f | this.Load [try] 외 13 | FP00604_PlanByModel_Pack.cs:418 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODTYPE_ID"] | CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00604_PlanByModel_Pack.SetColumnChangeByMemo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b552f6c7 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2208 | try ▸ if (iColStartIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68c15a98 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2226 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-74d4c8db | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2229 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") | GRID_SET | siMain.ActiveSheet.Cells[k, iColStartIndex, k, iColEndIndex].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-3ff1ac59 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2237 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e3a9902f | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2244 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00604_PlanByModel_Pack.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85f57502 | this.Load | FP00604_PlanByModel_Pack.cs:220 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71fdf798 | this.Load | FP00604_PlanByModel_Pack.cs:222 | if (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-89510014 | this.Load | FP00604_PlanByModel_Pack.cs:223 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-98d927df | this.Load | FP00604_PlanByModel_Pack.cs:227 | else of (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3149d0b9 | this.Load | FP00604_PlanByModel_Pack.cs:228 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00604_PlanByModel_Pack.SetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a2d7a94 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3082 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-69dcaa8a | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3082 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8dc8b8ea | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3083 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00604_PlanByModel_Pack.SetFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ef69c8f | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3111 |  | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-56e2d2e7 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3111 |  | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-61f93627 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3113 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00604_PlanByModel_Pack.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_factory.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd7daddc | this.Load [try] 외 22 | FP00604_PlanByModel_Pack.cs:3047 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00604_PlanByModel_Pack.SetInitMemo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f632635f | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2252 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-80be6664 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2253 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-1313a497 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2254 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-e955a63a | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2255 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-1bedd8b1 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2267 | foreach (AmendDate a in calendar.Days.Values) | CALL_EXT | dsResult.Tables[0].Columns[sColName].ChangeType | (typeof(string)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca5c2aaa | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2284 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0681e9c2 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2291 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a1fa3fc5 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2293 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-4a44bf4a | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2297 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | String.Format("{0}", m) | 행/컬럼 값 대입 |  |  |  |
| AC-d9478901 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:2304 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00604_PlanByModel_Pack.SetOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ec1c20e | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3120 |  | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-740ffcdc | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3120 |  | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5ac94553 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3121 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00604_PlanByModel_Pack.SetPlanPeriod

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90b48389 | this.Load [try] 외 1 | FP00604_PlanByModel_Pack.cs:3171 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb5285c5 | this.Load [try] 외 1 | FP00604_PlanByModel_Pack.cs:3186 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(56) | 속성 Value2 설정 |  |  |  |
| AC-e8ba9c6f | this.Load [try] 외 1 | FP00604_PlanByModel_Pack.cs:3187 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-56d01b33 | this.Load [try] 외 1 | FP00604_PlanByModel_Pack.cs:3191 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-c7f6c977 | this.Load [try] 외 1 | FP00604_PlanByModel_Pack.cs:3192 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-efb038bc | this.Load [try] 외 1 | FP00604_PlanByModel_Pack.cs:3198 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(56) | 속성 Value2 설정 |  |  |  |
| AC-dcafb3cb | this.Load [try] 외 1 | FP00604_PlanByModel_Pack.cs:3199 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00604_PlanByModel_Pack.SetPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-243b08a8 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3102 |  | FLAG | dtSite | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-59dab68b | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3102 |  | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6c69e666 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3103 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00604_PlanByModel_Pack.SetProdType

진입점: this.Load [try] / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccb99f6c | this.Load [try] 외 1 | FP00604_PlanByModel_Pack.cs:3130 |  | FLAG | dtProdType | DataService.GetProdType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0ae6cef | this.Load [try] 외 1 | FP00604_PlanByModel_Pack.cs:3130 |  | CALL_EXT | DataService.GetProdType | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7be11a2d | this.Load [try] 외 1 | FP00604_PlanByModel_Pack.cs:3131 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prodtype, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00604_PlanByModel_Pack.SetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6c996e6 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3091 |  | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-bf27912d | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3091 |  | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ed408eb9 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3092 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-20874211 | (진입점 미연결) | FP00604_PlanByModel_Pack.cs:3095 | if (dtSite.Rows.Count == 1) | VALUE_SET | cbo_site.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00604_PlanByModel_Pack.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be0e7ff0 | this.Load [try] | FP00604_PlanByModel_Pack.cs:459 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ed21071 | this.Load [try] | FP00604_PlanByModel_Pack.cs:460 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00604_PlanByModel_Pack.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed7caaf6 | this.spdMain.CellClick | FP00604_PlanByModel_Pack.cs:2871 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-f321073d | this.spdMain.CellClick | FP00604_PlanByModel_Pack.cs:2872 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-cce42ca6 | this.spdMain.CellClick | FP00604_PlanByModel_Pack.cs:2874 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf7a8fc9 | this.spdMain.CellClick | FP00604_PlanByModel_Pack.cs:2883 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00604_PlanByModel_Pack.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa01d681 | this.spdMain.CellDoubleClick | FP00604_PlanByModel_Pack.cs:2836 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-f11d4e4c | this.spdMain.CellDoubleClick | FP00604_PlanByModel_Pack.cs:2843 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00604_PlanByModel_Pack.SwitchMemo

진입점: memo_menu.Click [try ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acbe4c99 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00604_PlanByModel_Pack.cs:2701 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2c5f918 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00604_PlanByModel_Pack.cs:2718 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-c0c04b2d | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00604_PlanByModel_Pack.cs:2749 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-47c115dd | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00604_PlanByModel_Pack.cs:2750 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-0fa234e0 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00604_PlanByModel_Pack.cs:2752 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4912f95e | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00604_PlanByModel_Pack.cs:2783 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-2c96d18e | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00604_PlanByModel_Pack.cs:2784 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-12f77289 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00604_PlanByModel_Pack.cs:2786 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00604_PlanByModel_Pack.UIFindData

진입점: this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-648605f8 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:510 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e2b5460 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:511 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11bf705e | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:514 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5e49133d | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:518 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a47786a6 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:519 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c3411f6d | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:527 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-39790d4b | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:537 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d7dcc9b | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:538 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-986cb066 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:542 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-422500ec | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:543 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f3476ed1 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:551 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c1dc1e5 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:558 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc7e86c4 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:558 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ff82375b | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:565 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-434b0c46 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:571 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-470e1501 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:576 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-23291753 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:582 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-453f0c7b | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:584 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dc6d8460 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:590 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9461fda6 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:596 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-ef0a6827 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00604_PlanByModel_Pack.cs:600 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

