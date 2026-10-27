# AS-IS 액션 대조표 — FP00603

> 원천: `Doc/asisfacts/screens/FP00603/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 712행 · 메서드 75 · 종류 DATA_OP 224 · UI_PROP 95 · FLAG 63 · GRID_SET 59 · RETURN 49 · VALUE_SET 38 · CALL_EXT 37 · POPUP 30 · UI_MISC 24 · COMBO_DATA 21 · GRID_INIT 16 · MESSAGE 13 · THROW 10 · LIST_REBIND 8 · GRID_STYLE 7 · ENDPOINT 6 · STATE 4 · CALL_BASE 3 · GRID_LOCK 2 · GRID_BIND 2 · STATE_RESET 1 · ⚠ 의미 확인 필요 40


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-258ff017 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3420 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-59f563e4 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3426 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-52267025 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3434 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-994e4502 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3435 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-5f805c64 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3436 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-5bfc0eb3 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3437 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-f1b1a1a7 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3439 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-1ceabe1d | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3440 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-838ef661 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3441 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a06846a | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3442 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-cc5e4b53 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3443 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-f2c07692 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3444 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-3217f9b8 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3445 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-7fc73b34 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3446 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-58010ead | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3449 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-7303a7a0 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3634 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-b048e752 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3635 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-abfeb869 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3636 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-ff41c34b | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3637 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-1ee0102a | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3639 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb039661 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3640 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-b404a497 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3641 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-6cf8fe58 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3642 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-9915640d | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3643 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-046c5288 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3644 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-f3394ee9 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3645 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-d348aa66 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3646 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-c87b63fb | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3648 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0ec12be | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3553 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-849c61c3 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3554 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-34f4b871 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3555 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1412a63a | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3556 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e1ee5f4 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3557 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-98510fb6 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3560 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-932e8859 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3564 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-844a03fb | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3565 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a853359f | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3551 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-b55f66e1 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3581 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-767743b0 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3584 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6d04215 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3587 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-acd6b56c | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3590 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-306e5fe8 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3593 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-87ab11f1 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3596 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-5825947f | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3602 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-3aafbf93 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3604 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-288ab160 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3525 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69410209 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3489 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-698e7933 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3490 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-453d3dfe | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3491 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b573aa63 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3492 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-062957c5 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3493 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cbaab31c | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3494 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-efef834d | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3496 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f83f1bd | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3497 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-10d91484 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3500 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f67e540 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3501 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dbb1f78c | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3502 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9561a3c | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3487 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-f7f6db73 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3510 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-0625d5b6 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3511 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-6857fa32 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3516 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7048ed66 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3462 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00603_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e7d00de | .ctor | FP00603_MeasureSetForm_Popup.cs:105 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-ee6627b8 | .ctor | FP00603_MeasureSetForm_Popup.cs:106 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-37e96857 | .ctor | FP00603_MeasureSetForm_Popup.cs:107 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-ea0e3a09 | .ctor | FP00603_MeasureSetForm_Popup.cs:109 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00603_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-905d4e34 | this.btnOK.Click | FP00603_MeasureSetForm_Popup.cs:374 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-61e5a65a | this.btnOK.Click | FP00603_MeasureSetForm_Popup.cs:375 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-1ec4cb39 | this.btnOK.Click | FP00603_MeasureSetForm_Popup.cs:382 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-0361eaaa | this.btnOK.Click | FP00603_MeasureSetForm_Popup.cs:383 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00603_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efca6169 | this.btnSet.Click | FP00603_MeasureSetForm_Popup.cs:345 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-1f606558 | this.btnSet.Click | FP00603_MeasureSetForm_Popup.cs:346 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-ffc5d9c1 | this.btnSet.Click | FP00603_MeasureSetForm_Popup.cs:348 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-97916bd9 | this.btnSet.Click | FP00603_MeasureSetForm_Popup.cs:349 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-60a1e4fe | this.btnSet.Click | FP00603_MeasureSetForm_Popup.cs:351 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-99dc2f05 | this.btnSet.Click | FP00603_MeasureSetForm_Popup.cs:352 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-ad8a0935 | this.btnSet.Click | FP00603_MeasureSetForm_Popup.cs:353 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00603_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0f83434 | Dispose | FP00603_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00603_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17fe6070 | this.Load | FP00603_MeasureSetForm_Popup.cs:132 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00603_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-207ccaa9 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:204 |  | FLAG | dtCategory | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "select_measure", "FP00603_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-a979d7dd | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:204 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00603_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a1639961 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:206 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-0b77bffe | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:207 |  | FLAG | measure_val | new bool[measure_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-b8c29bea | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:208 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-aa166178 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-851fcc27 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-c91d6f64 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:237 |  | DATA_OP | ctrls.Add | (chk_offtime) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ec3a094 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-d18c0d20 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fcaa12c | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e745b94 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-27cd59f1 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-bbd399d8 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:245 |  | DATA_OP | ctrls.Add | (chk_cut) | 데이터 객체 조작/조회 |  |  |  |
| AC-2caecd0c | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-792afc47 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:248 |  | DATA_OP | ctrls.Add | (chk_resultExp) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9411de9 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_gap) | 데이터 객체 조작/조회 |  |  |  |
| AC-baa863e4 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:251 |  | DATA_OP | ctrls.Add | (chk_gapWPP) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fd84238 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:254 |  | DATA_OP | ctrls.Add | (chk_uom) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2600698 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fc16245 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:258 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1c5a3b2 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:259 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbc96f42 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:260 |  | DATA_OP | ctrls.Add | (chk_result_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-a74ed36d | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:262 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc328474 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:263 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-75f271b5 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:264 |  | DATA_OP | ctrls.Add | (chk_resultExp_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cbdd6b3 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:266 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d29e861 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:267 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9eb39bd | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:268 |  | DATA_OP | ctrls.Add | (chk_cut_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-babc3c97 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:270 |  | DATA_OP | ctrls.Add | (chk_gap_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d93d6d4 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:271 |  | DATA_OP | ctrls.Add | (chk_gapWPP_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-c95fb155 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:273 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-8306e5a2 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:274 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-c516746d | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:277 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-bdad6ea8 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:277 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-1763a4c5 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:284 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-c23e4ec9 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:288 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-59d0e9fc | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:292 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00603_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43f7114e | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b94c00ff | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e5aeb4bb | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_offtime.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1f98fc7e | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b2935c72 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-52fd5cd5 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-035c0dfe | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e72ad92d | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b29dc962 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_cut.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-cf25c74d | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-370ddc19 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_resultExp.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-cddcb7f9 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_gap.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-11b361d2 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_gapWPP.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-20bec0e2 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_uom.Text | measure_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-84850351 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_cell.Text | measure_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-94f468c8 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7859ddb2 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:171 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0b2d9c51 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:172 |  | VALUE_SET | chk_result_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d294c210 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:174 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5a23f0a4 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:175 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-94978c2c | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:176 |  | VALUE_SET | chk_resultExp_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3c0e8792 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:178 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4c47bc3b | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:179 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8ad1d003 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:180 |  | VALUE_SET | chk_cut_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-518a99fa | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:182 |  | VALUE_SET | chk_gap_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f6a0836d | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:183 |  | VALUE_SET | chk_gapWPP_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6eff9661 | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:185 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-33a1b64a | this.Load 외 1 | FP00603_MeasureSetForm_Popup.cs:186 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00603_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf6c5bef | (진입점 미연결) | FP00603_MeasureSetForm_Popup.cs:437 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-8d375f72 | (진입점 미연결) | FP00603_MeasureSetForm_Popup.cs:448 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69980404 | (진입점 미연결) | FP00603_MeasureSetForm_Popup.cs:459 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00603_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e295e170 | this.Load | FP00603_MeasureSetForm_Popup.cs:119 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d06df208 | this.Load | FP00603_MeasureSetForm_Popup.cs:127 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00603_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-662d21a6 | this.btnSet.Click 외 1 | FP00603_MeasureSetForm_Popup.cs:389 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8ddd76e6 | this.btnSet.Click 외 1 | FP00603_MeasureSetForm_Popup.cs:397 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-59d74f74 | this.btnSet.Click 외 1 | FP00603_MeasureSetForm_Popup.cs:397 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-d58fec7f | this.btnSet.Click 외 1 | FP00603_MeasureSetForm_Popup.cs:414 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e7bc7d94 | this.btnSet.Click 외 1 | FP00603_MeasureSetForm_Popup.cs:425 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00603_PlanByModel_Assy..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8be5f58f | .ctor | FP00603_PlanByModel_Assy.cs:194 |  | FLAG | CurrentUser | _CurrentUser = UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-dbf27584 | .ctor | FP00603_PlanByModel_Assy.cs:194 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00603_PlanByModel_Assy.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_ASSY_MEMO")] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bff7598 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1265 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3fcaf775 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1266 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c0032e5b | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1267 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-58fab471 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1268 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c9f32ede | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1269 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5111a959 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1270 |  | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3124ce9f | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1272 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe79f578 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1273 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-5234e704 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1275 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16f2c6b7 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1276 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-35392d22 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1278 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8887c3ae | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1279 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-0b7b67ca | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1281 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e9d4840d | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1282 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-09d44437 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1284 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00603_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45145f8a | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1285 |  | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-9cf1c4aa | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1307 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-c2e2e5e2 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1316 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-397278ef | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1317 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-a395d831 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1318 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-09b9cff9 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1319 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-b0760991 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1320 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00603_PlanByModel_Assy.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_ASSY_MEMO")] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6af23ec3 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1326 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; DataTable dtWeekMonth = null; string… | ⚠ 의미 확인 필요 |  |  |  |
| AC-767b4574 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1340 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-177173b1 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1341 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-9c15f133 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1348 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_day2WeekAndMonth", Filter["BUCKET_FROM"], Filter["BUCKET_TO… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-80f40593 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1411 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_currDateCol", Filter["INSTANCE_ID"], Filter["BUCKET_FROM"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00603_PlanByModel_Assy.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c877ff0b | this.btnBucket.Click | FP00603_PlanByModel_Assy.cs:2789 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-34b36948 | this.btnBucket.Click | FP00603_PlanByModel_Assy.cs:2792 |  | POPUP | new FP00599_BucketSetForm_Popup | ("FP00603", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-b343f9be | this.btnBucket.Click | FP00603_PlanByModel_Assy.cs:2793 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-775c5746 | this.btnBucket.Click | FP00603_PlanByModel_Assy.cs:2794 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-12439ed4 | this.btnBucket.Click | FP00603_PlanByModel_Assy.cs:2800 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00603_PlanByModel_Assy.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-268bd2ef | this.btnCatagory.Click | FP00603_PlanByModel_Assy.cs:2753 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-fffbac7f | this.btnCatagory.Click | FP00603_PlanByModel_Assy.cs:2756 |  | POPUP | new FP00603_MeasureSetForm_Popup | ("FP00603", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-a7a56125 | this.btnCatagory.Click | FP00603_PlanByModel_Assy.cs:2757 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6c1d718f | this.btnCatagory.Click | FP00603_PlanByModel_Assy.cs:2758 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3415ccd9 | this.btnCatagory.Click | FP00603_PlanByModel_Assy.cs:2765 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00603_PlanByModel_Assy.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06932a5f | this.btnColumn.Click | FP00603_PlanByModel_Assy.cs:2729 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-14488175 | this.btnColumn.Click | FP00603_PlanByModel_Assy.cs:2732 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00603", SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-203b09c0 | this.btnColumn.Click | FP00603_PlanByModel_Assy.cs:2733 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fd37cc08 | this.btnColumn.Click | FP00603_PlanByModel_Assy.cs:2734 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00603_PlanByModel_Assy.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdb0a942 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2839 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-4c8ca5f2 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2840 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f7a30ec | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2843 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-880b781d | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2844 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-755c8e8a | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2845 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-49cfd57a | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2846 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-64ebeec4 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2847 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-1e90b77e | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2848 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-1f0a3506 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2849 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-32f5d26b | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2849 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a2aa448b | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2850 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7d8b6bfc | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2851 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a52e588c | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2852 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-410ade2d | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2853 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-450be8a2 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2854 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-32340770 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2855 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-12fa2a95 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2856 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-81578176 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2857 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e1fcfb80 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2858 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b2fdb603 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2860 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-60da5680 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2861 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-709ac8d5 | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2862 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-7d89fb2c | this.btnMemo.Click | FP00603_PlanByModel_Assy.cs:2863 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00603_PlanByModel_Assy.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f114fe3 | this.btnPlanInfo.Click | FP00603_PlanByModel_Assy.cs:2813 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-2eac117f | this.btnPlanInfo.Click | FP00603_PlanByModel_Assy.cs:2814 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8a4cf4f0 | this.btnPlanInfo.Click | FP00603_PlanByModel_Assy.cs:2820 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-869362a5 | this.btnPlanInfo.Click | FP00603_PlanByModel_Assy.cs:2823 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-07634f16 | this.btnPlanInfo.Click | FP00603_PlanByModel_Assy.cs:2824 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-12e46d48 | this.btnPlanInfo.Click | FP00603_PlanByModel_Assy.cs:2824 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-124c9743 | this.btnPlanInfo.Click | FP00603_PlanByModel_Assy.cs:2825 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-5c876a21 | this.btnPlanInfo.Click | FP00603_PlanByModel_Assy.cs:2826 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-90f3fd30 | this.btnPlanInfo.Click | FP00603_PlanByModel_Assy.cs:2828 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bb478142 | this.btnPlanInfo.Click | FP00603_PlanByModel_Assy.cs:2829 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00603_PlanByModel_Assy.btnSimpleXcel_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e84868c | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:714 |  | FLAG | base.ExcelOption | ExcelExportOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |

## FP00603_PlanByModel_Assy.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e2575de | this.btnSql.Click | FP00603_PlanByModel_Assy.cs:2874 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-b4bb3450 | this.btnSql.Click | FP00603_PlanByModel_Assy.cs:2877 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-69f07d47 | this.btnSql.Click | FP00603_PlanByModel_Assy.cs:2878 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2832433e | this.btnSql.Click | FP00603_PlanByModel_Assy.cs:2880 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00603_PLANBYMODEL_ASSY_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c7fac9e | this.btnSql.Click | FP00603_PlanByModel_Assy.cs:2881 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00603_PLANBYMODEL_ASSY_MEMO") | 데이터 객체 조작/조회 |  |  |  |
| AC-83b32565 | this.btnSql.Click | FP00603_PlanByModel_Assy.cs:2883 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00603_PlanByModel_Assy.CheckAndGetMeasure

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (ds…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ceaabde | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2048 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-59478358 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2048 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-376cf027 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2050 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00603_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf7e255e | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2050 |  | POPUP | new FP00603_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-721ace9c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2051 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c72c27e | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2051 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-23342e7b | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2055 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-7dde176f | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2056 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-2e45a8a6 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2057 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-72eb7a14 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2058 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-21ee6055 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2059 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7802d70 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 7 | FP00603_PlanByModel_Assy.cs:2060 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00603_PlanByModel_Assy.CreateFilterDataSet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try] / this.btnCatagory.Click [if (frm.Dialog…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4181e3a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1776 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6fa3f701 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1788 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-735e1e54 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1789 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-f92d9fbb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1810 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8a62bc4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1811 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-42aa7186 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1815 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2720ad5e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1816 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-97b9a3f6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1820 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2127194d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1821 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9639250 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1825 | if (measure["chk_resultExp"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_EXP_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3dc43c9b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1826 | if (measure["chk_resultExp"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_EXP_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9eb3b56d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1831 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b9cf4b4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1832 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef9f950b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1836 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-36edfcd2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1837 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfff337f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1841 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9fea1e5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1846 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-31fd5f86 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1847 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7143101a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1851 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-19347e7d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1852 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bbc48896 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1857 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", MEMO_COLUMN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-65e4630d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1861 | if (measure["chk_gap"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff7b1e55 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1862 | if (measure["chk_gap"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-24d3e396 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1866 | if (measure["chk_cut"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-54faafac | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1870 | if (measure["chk_gapWPP"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f836bde | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1878 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_IN_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec4ef0b8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1879 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-82a537f0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1883 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_OUT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-535d8b42 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1884 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-27e3dcce | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1888 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-000a23bd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1889 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8b2e557 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1894 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fb6ab46 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1895 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c1d17b5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1899 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ebc24840 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1900 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-637a17d7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1904 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cut_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d795e31 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1910 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f4f9077 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1911 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-23f258bf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1915 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-157c1214 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1916 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-56b6671b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1920 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a71ec3a1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1921 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4eb8391 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1925 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_EXP_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9c693af | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1926 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_EXP_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a15ee489 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1931 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-59932910 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1941 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_IN_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d49e4ec | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1942 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-55db5ca4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1946 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_OUT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fbc6e32 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1947 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c77a61b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1951 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-736e4c94 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1952 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc538f6d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1958 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-55cf6646 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1959 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7638930 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1963 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7db2391e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1964 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0a5ad60 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1968 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cut_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_CUT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-89484dbf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1969 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cut_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_CUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-72d16f96 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1974 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a2421c1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1975 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ae16e56 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1979 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-41a18267 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1980 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-14888ef5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1984 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d5864b7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1985 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4eb701e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1989 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_EXP_UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-586fafe7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1990 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_EXP_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-40576917 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1995 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d576541 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:2004 | if (measure["chk_uom"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("MEASURE_ID", "UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c580cc4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:2014 | if (measure["chk_cell"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("MEASURE_ID", "CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a0e26d9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:2024 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc8469f6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:2027 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f53cc79 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:2031 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2c6675a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:2036 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ae4f2201 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:2040 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-924bb550 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:2042 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00603_PlanByModel_Assy.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d830788b | this.Load | FP00603_PlanByModel_Assy.cs:447 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-56d8718f | this.Load | FP00603_PlanByModel_Assy.cs:448 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-c0cb1b08 | this.Load | FP00603_PlanByModel_Assy.cs:449 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00603_PlanByModel_Assy.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b5c0ffc | dCalendar_planrange.ValueChanged | FP00603_PlanByModel_Assy.cs:2646 | if (sender == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-300ad2e1 | dCalendar_planrange.ValueChanged | FP00603_PlanByModel_Assy.cs:2652 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-00783e7a | dCalendar_planrange.ValueChanged | FP00603_PlanByModel_Assy.cs:2662 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9c21d506 | dCalendar_planrange.ValueChanged | FP00603_PlanByModel_Assy.cs:2679 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | MESSAGE | MessageBox.Show | ("It cannot be exceeded 100 days") | 메시지 표시 |  |  |  |
| AC-5a7bd291 | dCalendar_planrange.ValueChanged | FP00603_PlanByModel_Assy.cs:2680 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(100) | 속성 Value2 설정 |  |  |  |
| AC-afd8a0e8 | dCalendar_planrange.ValueChanged | FP00603_PlanByModel_Assy.cs:2704 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | MESSAGE | MessageBox.Show | ("It cannot be exceeded 100 days") | 메시지 표시 |  |  |  |
| AC-6d8cc3e7 | dCalendar_planrange.ValueChanged | FP00603_PlanByModel_Assy.cs:2705 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(100) | 속성 Value2 설정 |  |  |  |

## FP00603_PlanByModel_Assy.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc94738b | DeleteButton | FP00603_PlanByModel_Assy.cs:632 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-86c55c3e | DeleteButton | FP00603_PlanByModel_Assy.cs:633 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00603_PlanByModel_Assy.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35107ffd | Dispose | FP00603_PlanByModel_Assy.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00603_PlanByModel_Assy.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83bb0cd6 | EditButton | FP00603_PlanByModel_Assy.cs:639 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9973a7bc | EditButton | FP00603_PlanByModel_Assy.cs:640 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00603_PlanByModel_Assy.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-570b513c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00603_PlanByModel_Assy.cs:686 |  | FLAG | base.ExcelOption | ExcelExportOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |
| AC-6cfdff49 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00603_PlanByModel_Assy.cs:692 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a9ab264 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00603_PlanByModel_Assy.cs:696 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f181a923 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00603_PlanByModel_Assy.cs:700 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-2bbcdaaf | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00603_PlanByModel_Assy.cs:704 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00603_PlanByModel_Assy.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b5a784f | ExcelButton | FP00603_PlanByModel_Assy.cs:655 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-8a28977d | ExcelButton | FP00603_PlanByModel_Assy.cs:656 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-62d40714 | ExcelButton | FP00603_PlanByModel_Assy.cs:658 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4ce114f0 | ExcelButton | FP00603_PlanByModel_Assy.cs:662 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-25b64d0b | ExcelButton | FP00603_PlanByModel_Assy.cs:663 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-920ae76a | ExcelButton | FP00603_PlanByModel_Assy.cs:664 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-23cb860c | ExcelButton | FP00603_PlanByModel_Assy.cs:667 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-bbc41124 | ExcelButton | FP00603_PlanByModel_Assy.cs:668 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-7757cba8 | ExcelButton | FP00603_PlanByModel_Assy.cs:669 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-5d8c40f5 | ExcelButton | FP00603_PlanByModel_Assy.cs:671 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-ac765ad8 | ExcelButton | FP00603_PlanByModel_Assy.cs:672 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00603_PlanByModel_Assy.ExportExcelSimple

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19cc0432 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:720 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8dbf0d22 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:723 | try ▸ if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50237fc9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:729 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1b6a05a9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:737 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3983524 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:741 | try ▸ if (myarray.Length == 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6a717316 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:742 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56413ca3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:746 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0e649ef | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:788 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.LoadObjectXml | (typeof(FarPoint.Win.Spread.SheetView), FarPoint.Win.Serializer.GetObjectXml(sv, "CopyShee… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4aa6081d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:788 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.GetObjectXml | (sv, "CopySheet") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1545a082 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:794 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-1a48c2f1 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:808 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-10edb661 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:812 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (RemoveActionCell == tr… | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-69d1b5bc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:816 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac24ecd2 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:828 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-34574496 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:829 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-6be8361b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:838 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-dafc86d3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:839 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-b8321c0f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:845 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-d9d491cc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:854 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-65197af3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:856 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-54edfb81 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:859 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.FrozenColumnCount | FrozenColumnCount | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-71fa9f2e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:868 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (ignoreDepth > 0) ▸ for (i < newSheet.RowCount) ▸ for (j < collen) ▸ if (newSheet.Cells… | GRID_SET | newSheet.Cells[i, j].Value | null | 그리드 속성/값 설정 |  |  |  |
| AC-df9b2eb6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:879 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-7c6f3926 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:888 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-cc2b1edb | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:897 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-e60d133a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:904 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | UI_PROP | si.MaxRightMerge | 50 | 속성 MaxRightMerge 설정 |  |  |  |
| AC-6da19950 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:905 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | CALL_EXT | si.RightColMerge | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-389581ca | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:910 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.SeperatedRows: case ExcelExp… | CALL_EXT | si.UnMerge | (newSheet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c9427913 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:917 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 0, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-9ac014dd | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:919 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-4ca757cc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:923 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-aca76739 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:925 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-d8f384e6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:928 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-89a5e270 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:930 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-6747cb58 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:935 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-8691d5fb | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:950 | try | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-788f59eb | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:956 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a6d5aaa | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:960 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00603_PlanByModel_Assy.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_ASSY_MAIN")] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-196579cb | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1253 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00603_PLANBYMODEL_ASSY", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6732b3bd | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1255 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-efb2f03d | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:1259 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00603_PlanByModel_Assy.Find_Data_Memo

진입점: popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_ASSY_MEMO")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce541fc0 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… | FP00603_PlanByModel_Assy.cs:2223 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00603_PLANBYMODEL_ASSY", Filter, _CurrentUser, pSysType, "SELECT_MEMO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8c8f68d2 | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… | FP00603_PlanByModel_Assy.cs:2225 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-83495f1b | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… | FP00603_PlanByModel_Assy.cs:2229 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00603_PlanByModel_Assy.FindTotalColorStart

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4298472a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1770 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00603_PlanByModel_Assy.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0b4ff76 | this.Load | FP00603_PlanByModel_Assy.cs:224 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00603_PlanByModel_Assy.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_ASSY_MEMO") ▸ lambda] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c3dca3e | popSql.OnSql [if (programID == "PR_UI_FP00603_PLANBYMODEL_AS… 외 2 | FP00603_PlanByModel_Assy.cs:3254 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00603_PlanByModel_Assy.GetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62f80aae | this.Load [try] | FP00603_PlanByModel_Assy.cs:3262 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fd2041a3 | this.Load [try] | FP00603_PlanByModel_Assy.cs:3263 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b3b90fd1 | this.Load [try] | FP00603_PlanByModel_Assy.cs:3263 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d12f39d4 | this.Load [try] | FP00603_PlanByModel_Assy.cs:3265 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-e148d5cf | this.Load [try] | FP00603_PlanByModel_Assy.cs:3267 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-226f3371 | this.Load [try] | FP00603_PlanByModel_Assy.cs:3270 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-0a69f978 | this.Load [try] | FP00603_PlanByModel_Assy.cs:3271 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-4a624eb9 | this.Load [try] | FP00603_PlanByModel_Assy.cs:3271 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-12c09a7f | this.Load [try] | FP00603_PlanByModel_Assy.cs:3272 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d43b0581 | this.Load [try] | FP00603_PlanByModel_Assy.cs:3273 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc07c834 | this.Load [try] | FP00603_PlanByModel_Assy.cs:3274 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5433ccd8 | this.Load [try] | FP00603_PlanByModel_Assy.cs:3278 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00603_PlanByModel_Assy.GetToDay

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1f3c5de | this.Load [try] | FP00603_PlanByModel_Assy.cs:3344 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-81ab419d | this.Load [try] | FP00603_PlanByModel_Assy.cs:3345 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00603_PlanByModel_Assy.GoDrawCellColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a9dec76 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:2066 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f02f302 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:2131 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d3b0b33 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:2132 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetBGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP00603_PlanByModel_Assy.GoEditMode

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da9fd30f | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2381 |  | UI_PROP | this.IsEditMode | do_edit_mode | 속성 IsEditMode 설정 |  |  |  |
| AC-a88593ef | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2403 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-29173115 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2457 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | GRID_LOCK | siMain.LockRange | (rowindex, colindex, rowindex, colindex, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b058e64 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2468 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-39507006 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2480 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.LockRange | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e69db3d7 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2481 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5fb059e2 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2497 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar != null) ▸ foreach (var week_item in c… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-69a832b6 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2514 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (month_measure != null && month_measure.On) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00603_PlanByModel_Assy.InitColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5bb345a | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:1427 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-58d2ac11 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:1428 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-76dfac6b | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:1429 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-caa0c52d | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:1430 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-163fe9ce | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:1435 | foreach (AmendDate a in calendar.Days.Values) | CALL_EXT | dsResult.Tables[0].Columns[sColName].ChangeType | (typeof(string)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e120306a | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:1460 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-60d74e8f | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:1466 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9b72b6aa | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:1470 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | String.Format("{0}", m) | 행/컬럼 값 대입 |  |  |  |
| AC-0afa5e91 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:1477 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00603_PlanByModel_Assy.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbf93da3 | this.Load | FP00603_PlanByModel_Assy.cs:249 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-caf03fa5 | this.Load | FP00603_PlanByModel_Assy.cs:254 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-de2a6399 | this.Load | FP00603_PlanByModel_Assy.cs:255 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-72092c34 | this.Load | FP00603_PlanByModel_Assy.cs:258 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b2c4f5c | this.Load | FP00603_PlanByModel_Assy.cs:261 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5eb6c8c1 | this.Load | FP00603_PlanByModel_Assy.cs:287 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-1e71c6d7 | this.Load | FP00603_PlanByModel_Assy.cs:288 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2ca7e173 | this.Load | FP00603_PlanByModel_Assy.cs:289 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8866437a | this.Load | FP00603_PlanByModel_Assy.cs:295 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00603_PlanByModel_Assy.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-845dfbac | this.Load | FP00603_PlanByModel_Assy.cs:414 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d1f0ce7a | this.Load | FP00603_PlanByModel_Assy.cs:415 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f0060db1 | this.Load | FP00603_PlanByModel_Assy.cs:416 |  | UI_PROP | mcbo_prodtype.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-4bf85aba | this.Load | FP00603_PlanByModel_Assy.cs:417 |  | UI_PROP | clb_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-07ec5a49 | this.Load | FP00603_PlanByModel_Assy.cs:418 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-1b4abdd7 | this.Load | FP00603_PlanByModel_Assy.cs:419 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00603_PlanByModel_Assy.InitSpread

진입점: this.Load / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23407494 | this.Load 외 2 | FP00603_PlanByModel_Assy.cs:461 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e4bd2dd | this.Load 외 2 | FP00603_PlanByModel_Assy.cs:462 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2881a591 | this.Load 외 2 | FP00603_PlanByModel_Assy.cs:466 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00603_PlanByModel_Assy.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-228ff388 | InsertButton | FP00603_PlanByModel_Assy.cs:624 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e95150d | InsertButton | FP00603_PlanByModel_Assy.cs:625 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00603_PlanByModel_Assy.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b747ad2 | memo_menu.Click | FP00603_PlanByModel_Assy.cs:3180 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45b09a6f | memo_menu.Click | FP00603_PlanByModel_Assy.cs:3183 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afad1422 | memo_menu.Click | FP00603_PlanByModel_Assy.cs:3187 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00603_PlanByModel_Assy.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00d7dbeb | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3203 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ccd5f12 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3206 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8de5b8d | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3224 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-3c135690 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3225 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-043e778f | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3226 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-000c5cea | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3227 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4506959e | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3228 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-83c750ea | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3229 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-9a39f5ff | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3230 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4a14b19b | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3231 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d8619fdb | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3232 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00603_PlanByModel_Assy.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ebc99cc | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3098 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e420da2 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3101 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-faa65196 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3125 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00603_PlanByModel_Assy.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b69b02da | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3139 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96b94482 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3142 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-459ace40 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:3166 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00603_PlanByModel_Assy.OpenLineMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a854b479 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3048 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-55a8c6a1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3049 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-8039584c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3050 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-ccd418f1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3050 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a765decc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3051 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-af7d7049 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3052 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7d6d7552 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3053 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1229a208 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3058 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-da25dc57 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3061 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00603_PlanByModel_Assy.OpenMaterialMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c22782ed | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3067 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-eeca87df | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3068 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-14cd34d1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3069 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-cbe3cf68 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3069 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9359721a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3070 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-92c76fe8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3071 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-56bcd5ef | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3072 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a1932b2a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3076 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a2fa9ca3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00603_PlanByModel_Assy.cs:3078 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00603_PlanByModel_Assy.Query

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (ds…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29476574 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1218 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-1757766b | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1218 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1ef5be58 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1219 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-31e93571 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1219 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0ee658f6 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1220 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-e3f51820 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1220 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6c56fa2a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1223 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-caff7e77 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1230 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-a1b88d13 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1235 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo,calendar, dictCategory,MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-84e7d3ad | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1236 |  | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5072d046 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:1238 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo,calendar,MEMO_COLUMN,DAY_SUFFIX,false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00603_PlanByModel_Assy.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnBucket.Click [if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0d203c9 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1541 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5eecef55 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1555 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-fbf5d05c | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1556 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-91faf2ab | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1557 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-7dc933cf | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1558 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-cad10e12 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1579 | if (monthInfo != null) ▸ if (!on_redraw) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b689d2cf | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1582 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-718cd0c6 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1583 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5e7082e6 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1585 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da93e9c5 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1587 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef40b9d5 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1589 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98db2a6d | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1590 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a64fdcf4 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1592 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count +1 | 그리드 속성/값 설정 |  |  |  |
| AC-40836e08 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1600 | if (monthInfo != null) | UI_PROP | siMain.MergeVerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-e609b9ce | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1601 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b7c8ce7 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1606 | if (monthInfo != null) | UI_PROP | mct.FormatString | "###,###.#" | 속성 FormatString 설정 |  |  |  |
| AC-4d9b1780 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1628 | if (monthInfo != null) ▸ else of (bUseNote == false) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0fef2d36 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1631 | if (monthInfo != null) ▸ else of (bUseNote == false) ▸ if (bHideZero) | CALL_EXT | siMain.SetFormat | ("#,###.##", siMain.ActiveSheet.FrozenColumnCount, -1, bHideZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6376aa6 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1635 | if (monthInfo != null) ▸ else of (bUseNote == false) ▸ else of (bHideZero) | CALL_EXT | siMain.SetFormat | ("#,##0.##", siMain.ActiveSheet.FrozenColumnCount, -1, bHideZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-58889c1a | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1645 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-96163139 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1683 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor | (line, start, line, siMain.GetMaxColumnIndex(), tmp) | 그리드 표시 설정 |  |  |  |
| AC-20df2726 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1702 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-35811154 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1706 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-24db1422 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1708 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c296604 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1712 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-cb6402b9 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1728 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-04c8c7fe | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1743 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-7da8f154 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00603_PlanByModel_Assy.cs:1749 | if (monthInfo != null) | CALL_EXT | MemoService.ShowMemo | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |

## FP00603_PlanByModel_Assy.RefreshHeaderOnly

진입점: this.Load [try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (frm._bSearchFlag == true) ▸ else of (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f6eb171 | this.Load [try] 외 4 | FP00603_PlanByModel_Assy.cs:486 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-30673701 | this.Load [try] 외 4 | FP00603_PlanByModel_Assy.cs:488 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2284c897 | this.Load [try] 외 4 | FP00603_PlanByModel_Assy.cs:489 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a2fbdebc | this.Load [try] 외 4 | FP00603_PlanByModel_Assy.cs:490 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9134050 | this.Load [try] 외 4 | FP00603_PlanByModel_Assy.cs:497 |  | UI_PROP | spdMain.HorizontalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 HorizontalScrollBarPolicy 설정 |  |  |  |
| AC-ec4224b5 | this.Load [try] 외 4 | FP00603_PlanByModel_Assy.cs:498 |  | UI_PROP | spdMain.VerticalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 VerticalScrollBarPolicy 설정 |  |  |  |

## FP00603_PlanByModel_Assy.RefreshSpreadSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogRe…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8278bbd2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1493 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-cc694127 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1493 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-754b02f7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1504 | try ▸ if (!dsMain.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8c59d1c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1509 | try | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-dd4e63a0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00603_PlanByModel_Assy.cs:1534 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00603_PlanByModel_Assy.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b90f209b | popSql.OnSql | FP00603_PlanByModel_Assy.cs:3358 | if (programID == "PR_UI_FP00603_PLANBYMODEL_ASSY_MAIN") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-f2e89232 | popSql.OnSql | FP00603_PlanByModel_Assy.cs:3367 | if (programID == "PR_UI_FP00603_PLANBYMODEL_ASSY_MEMO") | RETURN | return Find_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-6bc84cd7 | popSql.OnSql | FP00603_PlanByModel_Assy.cs:3371 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00603_PlanByModel_Assy.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20fe248f | SaveButton | FP00603_PlanByModel_Assy.cs:646 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a697aab | SaveButton | FP00603_PlanByModel_Assy.cs:647 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00603_PlanByModel_Assy.SaveSimplexcel

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b813d7b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:986 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < spSheet.Columns.Count) | DATA_OP | spSheet.Columns[i].DataField.ToUpper().Contains | ("W0") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba1bfcca | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:991 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < spSheet.Columns.Count) | DATA_OP | spSheet.Columns[i].DataField.ToUpper().Contains | ("D0") | 데이터 객체 조작/조회 |  |  |  |
| AC-34afda35 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1007 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (i == 0) | DATA_OP | xSheet.ColumnWidths[j] | spSheet.ColumnHeader.Columns[j].Width / 9 | 행/컬럼 값 대입 |  |  |  |
| AC-213c7976 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1009 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j] | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-476bd9b8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1014 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Bottom | 그리드 속성/값 설정 |  |  |  |
| AC-b454d6dd | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1017 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-a6b5f2da | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1020 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-b97c0482 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1023 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-0995d8e0 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1026 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Justify | 그리드 속성/값 설정 |  |  |  |
| AC-e73a1cef | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1029 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-8c44a492 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1032 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-71197ab2 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1039 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Left | 그리드 속성/값 설정 |  |  |  |
| AC-9dbec04e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1042 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Center | 그리드 속성/값 설정 |  |  |  |
| AC-0bc60659 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1045 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.None | 그리드 속성/값 설정 |  |  |  |
| AC-c9c44610 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1048 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.General | 그리드 속성/값 설정 |  |  |  |
| AC-ea7ad130 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1051 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Justify | 그리드 속성/값 설정 |  |  |  |
| AC-fa287465 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1054 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Right | 그리드 속성/값 설정 |  |  |  |
| AC-0523ccae | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1058 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].ColSpan | cell.ColumnSpan | 그리드 속성/값 설정 |  |  |  |
| AC-4d4299ef | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1059 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].RowSpan | cell.RowSpan | 그리드 속성/값 설정 |  |  |  |
| AC-6777a8a4 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1060 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Border | Simplexcel.CellBorder.All | 그리드 속성/값 설정 |  |  |  |
| AC-11d2b79c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1062 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-32c774b2 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1068 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (!fg.IsEmpty) | GRID_SET | xSheet.Cells[i, j].TextColor | Simplexcel.Color.FromArgb(fg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-40873fed | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1068 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (!fg.IsEmpty) | CALL_EXT | fg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-daf04542 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1074 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Fill.BackgroundColor | Simplexcel.Color.FromArgb(0, 240, 240, 240) | 그리드 속성/값 설정 |  |  |  |
| AC-8cbecc6d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1077 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (cell.Font != null) | GRID_SET | xSheet.Cells[i, j].FontSize | (int)cell.Font.Size | 그리드 속성/값 설정 |  |  |  |
| AC-14ff60a3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1080 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ else of (cell.Font != n… | GRID_SET | xSheet.Cells[i, j].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-912edba3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1102 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-1ac53d9d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1103 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-894e115f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1111 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-30dd9166 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1112 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-eed9a57e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1117 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-f3c1e49f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1118 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-dc661bbc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1124 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | ss | 그리드 속성/값 설정 |  |  |  |
| AC-dba9afd7 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1130 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-51b70560 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1140 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-400a4dd3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1141 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-b251e1e5 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1147 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-261325b3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1148 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-0cf728ea | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1153 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-0fd1bbf4 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1157 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-5cb11e39 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1164 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!fg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].TextColor | Simplexcel.Color.FromArgb(fg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-ffa81914 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1164 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!fg.IsEmpty) | CALL_EXT | fg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c250385a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1168 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!bg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.FromArgb(bg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-6b95b348 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1168 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!bg.IsEmpty) | CALL_EXT | bg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c876a265 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1172 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ else of (!bg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-031a8a5f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1177 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].FontSize | (int)spSheet.Cells[i, j].Font.Size | 그리드 속성/값 설정 |  |  |  |
| AC-a3c9436c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1179 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].Bold | true | 그리드 속성/값 설정 |  |  |  |
| AC-0338b9f5 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1181 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].Italic | true | 그리드 속성/값 설정 |  |  |  |
| AC-ec50a4d9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1184 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ else of (spSheet.Cells[i, j].Font !… | GRID_SET | xSheet.Cells[id, jd].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-45cc3308 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1186 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) | GRID_SET | xSheet.Cells[id, jd].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-c5a696fc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1191 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) | GRID_INIT | xSheet.FreezeTopLeft | (spSheet.ColumnHeader.RowCount, froz) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-74e7544e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1192 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) | DATA_OP | workbook.Add | (xSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3238366 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1206 |  | UI_PROP | workbook.Title | name | 속성 Title 설정 |  |  |  |
| AC-355b64f9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1207 |  | UI_PROP | workbook.Author | "GSCM,FP, logged as " + this.UserInfo.UserId | 속성 Author 설정 |  |  |  |
| AC-43a1d26a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… 외 1 | FP00603_PlanByModel_Assy.cs:1209 |  | CALL_EXT | workbook.Save | (fileName) | ⚠ 의미 확인 필요 |  |  |  |

## FP00603_PlanByModel_Assy.SetBohQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf3caae1 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2534 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6194a311 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2535 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-01f1ac72 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2540 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-c68406fc | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2545 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-22e26d61 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2546 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c9c6910 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2547 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4aaa2286 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2548 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-77bc30b7 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2549 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-76663a0c | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2550 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-badcfb22 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2551 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-239eb399 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2552 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff003ecf | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2556 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00603_PlanByModel_Assy.SetChangeControl

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / cbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / clb_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / mcbo_prodtype.SelectedIndexChanged / chk_allLine.CheckedChanged / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.chkInAct.CheckedChanged / this.chk_allLine.CheckedChanged / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("We…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-329a9506 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:338 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a2930644 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:338 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ff99c873 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:347 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2ab70f67 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:348 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b10ec92 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:348 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e3fc9c07 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:349 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-950dd6e5 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:355 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-f8bcb26e | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:356 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e5c97b5d | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:356 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-43e5d102 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:357 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-50f87347 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:363 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-95f48809 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:364 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a948ec82 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:364 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8155fa5f | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:365 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b0371f1e | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:371 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-9c6ea332 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:372 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-4b9df800 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:372 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3377c133 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:373 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-73ea8b20 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:380 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-e83e61b0 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:381 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a21fc05 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:381 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-78689ac2 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:382 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clb_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c61a3549 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:388 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, clb_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-ffc65b7a | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:389 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-071c641a | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:389 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7664483e | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:390 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0581555f | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:396 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-4b9daa53 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:400 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PROD_TYPE"]=Filter["PRODTYPE_ID"] = CString.GetCheckedListValue(dtProdType, mcbo_p… | 행/컬럼 값 대입 |  |  |  |
| AC-b9624d79 | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:400 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PROD_TYPE"] | Filter["PRODTYPE_ID"] = CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValue… | 행/컬럼 값 대입 |  |  |  |
| AC-c6b5f20e | this.Load [try] 외 13 | FP00603_PlanByModel_Assy.cs:400 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODTYPE_ID"] | CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00603_PlanByModel_Assy.SetColumnChangeByMemo

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (ds…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac3e935c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:2244 | try ▸ if (iColStartIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13980e17 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:2254 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType == "DATA" && sCategory == MEMO_COLUMN) | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-6597c9bb | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:2257 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType == "DATA" && sCategory == MEMO_COLUMN) | GRID_SET | siMain.ActiveSheet.Cells[k, iColStartIndex, k, iColEndIndex].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-57915e08 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00603_PlanByModel_Assy.cs:2269 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00603_PlanByModel_Assy.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45423d08 | this.Load | FP00603_PlanByModel_Assy.cs:204 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ec144ee | this.Load | FP00603_PlanByModel_Assy.cs:206 | if (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3869339c | this.Load | FP00603_PlanByModel_Assy.cs:207 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-7dda07f1 | this.Load | FP00603_PlanByModel_Assy.cs:212 | else of (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e86cc156 | this.Load | FP00603_PlanByModel_Assy.cs:213 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00603_PlanByModel_Assy.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_factory.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clb_o…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62295a1a | this.Load [try] 외 21 | FP00603_PlanByModel_Assy.cs:3249 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00603_PlanByModel_Assy.SetInitMemo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5884d52 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2278 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-8a6e4e86 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2279 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-b954c41f | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2280 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-f2732e93 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2281 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-0210d524 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2292 | try ▸ foreach (AmendDate a in calendar.Days.Values) | CALL_EXT | dsResult.Tables[0].Columns[sColName].ChangeType | (typeof(string)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-68449278 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2307 | try ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if … | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d9e70efd | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2313 | try ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if … | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-56d9e822 | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2317 | try ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if … | DATA_OP | row[sColName] | String.Format("{0}", m) | 행/컬럼 값 대입 |  |  |  |
| AC-386552ab | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2324 | try ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if … | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-99a1420a | (진입점 미연결) | FP00603_PlanByModel_Assy.cs:2375 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00603_PlanByModel_Assy.SetPlanPeriod

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88551547 | this.Load [try] 외 1 | FP00603_PlanByModel_Assy.cs:3303 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c34aa8e3 | this.Load [try] 외 1 | FP00603_PlanByModel_Assy.cs:3318 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(56) | 속성 Value2 설정 |  |  |  |
| AC-d1886fb8 | this.Load [try] 외 1 | FP00603_PlanByModel_Assy.cs:3319 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-23e47244 | this.Load [try] 외 1 | FP00603_PlanByModel_Assy.cs:3323 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-892f5149 | this.Load [try] 외 1 | FP00603_PlanByModel_Assy.cs:3324 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-5446c7b6 | this.Load [try] 외 1 | FP00603_PlanByModel_Assy.cs:3330 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(56) | 속성 Value2 설정 |  |  |  |
| AC-6e12feca | this.Load [try] 외 1 | FP00603_PlanByModel_Assy.cs:3331 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00603_PlanByModel_Assy.SetProdType

진입점: this.Load [try] / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e27ca90c | this.Load [try] 외 1 | FP00603_PlanByModel_Assy.cs:3285 |  | FLAG | dtProdType | DataService.GetProdType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-955b38d3 | this.Load [try] 외 1 | FP00603_PlanByModel_Assy.cs:3285 |  | CALL_EXT | DataService.GetProdType | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee749df4 | this.Load [try] 외 1 | FP00603_PlanByModel_Assy.cs:3286 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prodtype, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00603_PlanByModel_Assy.SetSpreadInit

진입점: this.Load [try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17286176 | this.Load [try] 외 2 | FP00603_PlanByModel_Assy.cs:474 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5cc6a07f | this.Load [try] 외 2 | FP00603_PlanByModel_Assy.cs:475 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00603_PlanByModel_Assy.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ec8ddbc | this.spdMain.CellClick | FP00603_PlanByModel_Assy.cs:3684 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-12e1c711 | this.spdMain.CellClick | FP00603_PlanByModel_Assy.cs:3685 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-80a40a2b | this.spdMain.CellClick | FP00603_PlanByModel_Assy.cs:3687 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ceac823 | this.spdMain.CellClick | FP00603_PlanByModel_Assy.cs:3696 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00603_PlanByModel_Assy.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a0ff6b0 | this.spdMain.CellDoubleClick | FP00603_PlanByModel_Assy.cs:2927 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-c69b0b95 | this.spdMain.CellDoubleClick | FP00603_PlanByModel_Assy.cs:2935 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00603_PlanByModel_Assy.SwitchMemo

진입점: memo_menu.Click [try ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ccf499a | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00603_PlanByModel_Assy.cs:2946 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd21f954 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00603_PlanByModel_Assy.cs:2963 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-5596b98c | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00603_PlanByModel_Assy.cs:2994 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-3f4d7059 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00603_PlanByModel_Assy.cs:2995 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-ba83d1f0 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00603_PlanByModel_Assy.cs:2997 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ebe21885 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00603_PlanByModel_Assy.cs:3028 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-e64d42d1 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00603_PlanByModel_Assy.cs:3029 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-65ab6fe3 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00603_PlanByModel_Assy.cs:3031 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00603_PlanByModel_Assy.UIFindData

진입점: this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (frm._bSearchFlag == true)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9ce08ba | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:525 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c19d3060 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:526 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46f95be3 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:529 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3344ce64 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:533 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2a24295 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:540 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-04464ff4 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:550 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da88a1de | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:551 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5b604dd | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:556 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e82ec005 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:557 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-69823317 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:560 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b12032d0 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:572 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-3465b929 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:572 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-668b947d | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:579 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-12ef0174 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:585 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e83e4629 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:592 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2330a60f | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:597 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8def1a88 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:598 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-198c8627 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:605 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8af0f224 | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:612 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d2afbcbb | this.btnCatagory.Click [if (frm.DialogResult == DialogResult… 외 1 | FP00603_PlanByModel_Assy.cs:616 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

