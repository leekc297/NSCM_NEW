# AS-IS 액션 대조표 — FP00619

> 원천: `Doc/asisfacts/screens/FP00619/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 562행 · 메서드 77 · 종류 DATA_OP 151 · UI_PROP 89 · FLAG 60 · RETURN 46 · VALUE_SET 34 · UI_MISC 28 · POPUP 27 · CALL_EXT 24 · COMBO_DATA 24 · MESSAGE 18 · GRID_INIT 13 · LIST_REBIND 11 · GRID_SET 9 · THROW 7 · ENDPOINT 5 · GRID_STYLE 5 · STATE 4 · CALL_BASE 3 · GRID_LOCK 2 · STATE_RESET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 27


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ef8c11b | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2546 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-4209d541 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2552 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ea3c0fa1 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2560 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-ff39eccd | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2561 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-269f64e3 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2562 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-7d1dd89c | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2563 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-8ac6e9a0 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2565 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3c975b8 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2566 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-c678686d | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2567 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9a885e9 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2568 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-a6001d32 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2569 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-41eb1990 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2570 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-8afad9a6 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2571 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b372131 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2572 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-c152d200 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2575 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-d946695c | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2760 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-23be79dd | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2761 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-6f2dcb82 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2762 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-92d45111 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2763 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-5b7fa6b0 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2765 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d370808 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2766 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-b3b598e6 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2767 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca119a4f | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2768 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-a3a80043 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2769 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a2f09a5 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2770 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-08aadd7a | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2771 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-046b7c0e | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2772 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-2c3e8321 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2774 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ba261a3 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2679 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0f880a4 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2680 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2a544bf3 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2681 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-966273be | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2682 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2803cf8d | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2683 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8b9fbaa | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2686 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-00eddf07 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2690 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-acff3d04 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2691 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa362ecc | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2677 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-add10fb3 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2707 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-347d7a8c | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2710 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9506ac0 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2713 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c5264d2 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2716 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-dce76801 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2719 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-4f76728c | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2722 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-38dda2a9 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2728 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-e52df7e0 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2730 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6aa354c1 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2651 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e9392c0 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2615 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dad33e18 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2616 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f444b417 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2617 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-66985b85 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2618 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-db3a2162 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2619 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb37b7e1 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2620 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b5608ca | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2622 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4fa7b335 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2623 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd247390 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2626 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-777c937a | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2627 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-319bc85d | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2628 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce228a1e | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2613 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-7f3a576b | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2636 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-54b33f32 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2637 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-19140ebf | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2642 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3bfbdde | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2588 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00619_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2beeaf3a | .ctor | FP00619_MeasureSetForm_Popup.cs:79 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-37297609 | .ctor | FP00619_MeasureSetForm_Popup.cs:80 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-aa92ed5b | .ctor | FP00619_MeasureSetForm_Popup.cs:81 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-a89c9f99 | .ctor | FP00619_MeasureSetForm_Popup.cs:83 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00619_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa1d1649 | this.btnOK.Click | FP00619_MeasureSetForm_Popup.cs:383 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-ac6fffd5 | this.btnOK.Click | FP00619_MeasureSetForm_Popup.cs:384 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-5d4583be | this.btnOK.Click | FP00619_MeasureSetForm_Popup.cs:391 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-9d2d48de | this.btnOK.Click | FP00619_MeasureSetForm_Popup.cs:392 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00619_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6a11e4b | this.btnSet.Click | FP00619_MeasureSetForm_Popup.cs:353 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-af306289 | this.btnSet.Click | FP00619_MeasureSetForm_Popup.cs:354 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-d9750583 | this.btnSet.Click | FP00619_MeasureSetForm_Popup.cs:356 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8464b6d8 | this.btnSet.Click | FP00619_MeasureSetForm_Popup.cs:357 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a43a7091 | this.btnSet.Click | FP00619_MeasureSetForm_Popup.cs:359 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-f12fd538 | this.btnSet.Click | FP00619_MeasureSetForm_Popup.cs:361 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-9cb69e50 | this.btnSet.Click | FP00619_MeasureSetForm_Popup.cs:362 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00619_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de5ecf6e | Dispose | FP00619_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00619_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c18bcc0 | this.Load | FP00619_MeasureSetForm_Popup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00619_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c38fde7 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:249 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2156b6d | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-8207d332 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:251 |  | DATA_OP | ctrls.Add | (chk_offtime) | 데이터 객체 조작/조회 |  |  |  |
| AC-653323ba | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:253 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3780f88 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:254 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-60e321f0 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3023f41 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:257 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-3309d8f8 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:258 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-e49807c1 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:259 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-588db8ad | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:261 |  | DATA_OP | ctrls.Add | (chk_gap) | 데이터 객체 조작/조회 |  |  |  |
| AC-7333b7b6 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:262 |  | DATA_OP | ctrls.Add | (chk_gapWPP) | 데이터 객체 조작/조회 |  |  |  |
| AC-0bc0e4f7 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:263 |  | DATA_OP | ctrls.Add | (chk_resultExp) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e574f55 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:266 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ad89350 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:267 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e28cf70 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:268 |  | DATA_OP | ctrls.Add | (chk_result_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee6e8f53 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:270 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-434796d6 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:271 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-08a515c6 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:272 |  | DATA_OP | ctrls.Add | (chk_resultExp_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a8900c2 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:274 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-790bbaf1 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:275 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca3c6b7e | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:276 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-40e3bb24 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:278 |  | DATA_OP | ctrls.Add | (chk_gap_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e95cf2f | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:279 |  | DATA_OP | ctrls.Add | (chk_gapWPP_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a066ef8 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:281 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7cb2d33 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:282 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-00726ee3 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:286 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-283da60c | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:286 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-3a816eaf | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:293 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-66f6ac61 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:297 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |

## FP00619_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f92fe32d | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2513f76c | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9a63c2c9 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_offtime.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f0116b49 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5c06a32a | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-aa234fc3 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7beb1287 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0d4dab66 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-59f3479f | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-36fd14fe | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_gap.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-533b916c | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_gapWPP.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5340d449 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_resultExp.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e5c368b1 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-527d2571 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c02c75b5 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_result_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4debbdbc | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f3497080 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6648e837 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_resultExp_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-56d1a07b | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5ad306f5 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-dbda778b | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_memo_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2341a678 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_gap_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5c7774a1 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:167 |  | VALUE_SET | chk_gapWPP_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-65db22f6 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-dfc1bd59 | this.Load 외 1 | FP00619_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00619_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30996db0 | (진입점 미연결) | FP00619_MeasureSetForm_Popup.cs:192 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-a0d7a4f2 | (진입점 미연결) | FP00619_MeasureSetForm_Popup.cs:203 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47660bc2 | (진입점 미연결) | FP00619_MeasureSetForm_Popup.cs:214 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00619_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-692c5720 | this.Load | FP00619_MeasureSetForm_Popup.cs:94 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ae1f7c95 | this.Load | FP00619_MeasureSetForm_Popup.cs:102 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00619_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d503a9e8 | this.btnSet.Click 외 1 | FP00619_MeasureSetForm_Popup.cs:398 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0d804db4 | this.btnSet.Click 외 1 | FP00619_MeasureSetForm_Popup.cs:406 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-a2a65fa4 | this.btnSet.Click 외 1 | FP00619_MeasureSetForm_Popup.cs:406 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-96e8dabe | this.btnSet.Click 외 1 | FP00619_MeasureSetForm_Popup.cs:423 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-eb6f336a | this.btnSet.Click 외 1 | FP00619_MeasureSetForm_Popup.cs:434 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33b0aaa8 | .ctor | FP00619_PlanBy_Line_Formation.cs:205 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00619_PlanBy_Line_Formation.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FORMATION_MAIN") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f2d84e0 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:762 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5b331ff8 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:763 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e5515d4d | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:764 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d323d284 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:765 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-85e30af6 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:766 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8f8aa3a8 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:767 |  | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b11633ad | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:769 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd7ea5f0 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:770 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-89e6bf3b | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:772 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-db0c227c | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:773 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8aa32dc7 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:775 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-60be5e17 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:776 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-0a55fe93 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:778 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f4e94765 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:779 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8ccc22a3 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:781 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00619_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b67c47ae | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:782 |  | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-bc5f73b3 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:804 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-5fc9cb54 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:813 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-aaad495e | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:814 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-c9645783 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:815 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-9c011bd9 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:816 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-db9eac5b | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:817 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00619_PlanBy_Line_Formation.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FORMATION_MAIN") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53fca5b5 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:823 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; DataTable dtWeekMonth = null; string… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9bedd692 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:837 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-3ff5efc8 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:838 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-dd9a5cc7 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:845 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_day2WeekAndMonth", Filter["BUCKET_FROM"], Filter["BUCKET_TO… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dab0059e | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:932 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_currDateCol", Filter["INSTANCE_ID"], Filter["BUCKET_FROM"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00619_PlanBy_Line_Formation.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a39bff56 | this.btnBucket.Click | FP00619_PlanBy_Line_Formation.cs:1791 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-822ef199 | this.btnBucket.Click | FP00619_PlanBy_Line_Formation.cs:1794 |  | POPUP | new FP00599_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-028c8ad2 | this.btnBucket.Click | FP00619_PlanBy_Line_Formation.cs:1795 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-aeab204a | this.btnBucket.Click | FP00619_PlanBy_Line_Formation.cs:1796 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-801e2af5 | this.btnBucket.Click | FP00619_PlanBy_Line_Formation.cs:1797 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-92c21cb0 | this.btnBucket.Click | FP00619_PlanBy_Line_Formation.cs:1801 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-0f78c28f | this.btnBucket.Click | FP00619_PlanBy_Line_Formation.cs:1813 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-464ce3cb | this.btnBucket.Click | FP00619_PlanBy_Line_Formation.cs:1822 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00619_PlanBy_Line_Formation.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f177d53b | this.btnCatagory.Click | FP00619_PlanBy_Line_Formation.cs:1740 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-00fbe665 | this.btnCatagory.Click | FP00619_PlanBy_Line_Formation.cs:1743 |  | POPUP | new FP00619_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-507db4d0 | this.btnCatagory.Click | FP00619_PlanBy_Line_Formation.cs:1744 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-45229d1b | this.btnCatagory.Click | FP00619_PlanBy_Line_Formation.cs:1745 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-50db7ae2 | this.btnCatagory.Click | FP00619_PlanBy_Line_Formation.cs:1746 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bc390d22 | this.btnCatagory.Click | FP00619_PlanBy_Line_Formation.cs:1750 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-941a3717 | this.btnCatagory.Click | FP00619_PlanBy_Line_Formation.cs:1762 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b24f2f5a | this.btnCatagory.Click | FP00619_PlanBy_Line_Formation.cs:1771 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-72498c3a | this.btnCatagory.Click | FP00619_PlanBy_Line_Formation.cs:1776 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-77e7a127 | this.btnCatagory.Click | FP00619_PlanBy_Line_Formation.cs:1782 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00619_PlanBy_Line_Formation.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f362bf8 | this.btnColumn.Click | FP00619_PlanBy_Line_Formation.cs:1713 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-feb58406 | this.btnColumn.Click | FP00619_PlanBy_Line_Formation.cs:1716 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-3a4c54c5 | this.btnColumn.Click | FP00619_PlanBy_Line_Formation.cs:1717 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9cb2fb14 | this.btnColumn.Click | FP00619_PlanBy_Line_Formation.cs:1718 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-27c4e9c1 | this.btnColumn.Click | FP00619_PlanBy_Line_Formation.cs:1724 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-b6905f24 | this.btnColumn.Click | FP00619_PlanBy_Line_Formation.cs:1724 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2992fd9f | this.btnColumn.Click | FP00619_PlanBy_Line_Formation.cs:1725 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-16a2b6f7 | this.btnColumn.Click | FP00619_PlanBy_Line_Formation.cs:1731 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00619_PlanBy_Line_Formation.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2284f652 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1857 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-f5d6f5c9 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1858 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5dde2d6 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1861 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-665c824a | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1862 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-c39a02b8 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1863 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-12f997f6 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1864 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ba32be1e | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1865 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-3cad8e48 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1866 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-b4e56790 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1867 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2e782d94 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1867 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-77d56474 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1868 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-62040d37 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1869 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e93927ac | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1870 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b22240c7 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1871 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-95af4d74 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1872 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-855b4b3d | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1873 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a52d5caf | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1874 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e0c168c3 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1875 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-463361ad | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1876 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1d737f14 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1878 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ba04c6e3 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1879 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-34fde6db | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1880 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-ed2b9e03 | this.btnMemo.Click | FP00619_PlanBy_Line_Formation.cs:1881 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00619_PlanBy_Line_Formation.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67b1ea40 | this.btnPlanInfo.Click | FP00619_PlanBy_Line_Formation.cs:1831 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-a4f18455 | this.btnPlanInfo.Click | FP00619_PlanBy_Line_Formation.cs:1832 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-162d8078 | this.btnPlanInfo.Click | FP00619_PlanBy_Line_Formation.cs:1838 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-c4e80e00 | this.btnPlanInfo.Click | FP00619_PlanBy_Line_Formation.cs:1841 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-64e6c3d8 | this.btnPlanInfo.Click | FP00619_PlanBy_Line_Formation.cs:1842 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-21b6e84e | this.btnPlanInfo.Click | FP00619_PlanBy_Line_Formation.cs:1842 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5aed0931 | this.btnPlanInfo.Click | FP00619_PlanBy_Line_Formation.cs:1843 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-a5cb34a6 | this.btnPlanInfo.Click | FP00619_PlanBy_Line_Formation.cs:1844 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9200751c | this.btnPlanInfo.Click | FP00619_PlanBy_Line_Formation.cs:1846 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2e0b7a4d | this.btnPlanInfo.Click | FP00619_PlanBy_Line_Formation.cs:1847 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00619_PlanBy_Line_Formation.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca193b20 | this.btnSql.Click | FP00619_PlanBy_Line_Formation.cs:1892 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-fddc405c | this.btnSql.Click | FP00619_PlanBy_Line_Formation.cs:1895 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3f03c952 | this.btnSql.Click | FP00619_PlanBy_Line_Formation.cs:1896 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fed1554d | this.btnSql.Click | FP00619_PlanBy_Line_Formation.cs:1898 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00619_PLANBY_LINE_FORMATION_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f16f03d | this.btnSql.Click | FP00619_PlanBy_Line_Formation.cs:1899 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00619_PLANBY_LINE_FORMATION_MEMO") | 데이터 객체 조작/조회 |  |  |  |
| AC-066f6f30 | this.btnSql.Click | FP00619_PlanBy_Line_Formation.cs:1901 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00619_PlanBy_Line_Formation.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df43c2d6 | this.Load | FP00619_PlanBy_Line_Formation.cs:1243 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-bede45b9 | this.Load | FP00619_PlanBy_Line_Formation.cs:1243 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-9c83d09d | this.Load | FP00619_PlanBy_Line_Formation.cs:1244 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00619_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-accb307f | this.Load | FP00619_PlanBy_Line_Formation.cs:1244 |  | POPUP | new FP00619_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-e980851c | this.Load | FP00619_PlanBy_Line_Formation.cs:1245 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-460e8b3e | this.Load | FP00619_PlanBy_Line_Formation.cs:1245 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP00619_PlanBy_Line_Formation.CreateFilterDataSet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain.Good())] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1214eb49 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:975 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-db1985ff | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:987 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-82f65a7b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:988 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-e2dfc097 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1009 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-54ac1d51 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1014 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-72a40cf4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1019 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-865424f9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1025 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fca3a29e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1030 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-73ffef08 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1035 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-765ae146 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1041 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-629196db | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1046 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-057598f6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1051 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c49d5103 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1056 | if (measure["chk_resultExp"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-697bf6ae | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1062 | if (measure["chk_gap"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-696bdcc8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1067 | if (measure["chk_gapWPP"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-93897d60 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1077 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_memo_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", MEMO_COLUMN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcba91a3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1082 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac489372 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1087 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f37b4e09 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1092 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ec11ee9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1097 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c73b576c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1103 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fdf4fbe1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1108 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1a064ca | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1113 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-000018a6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1118 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-223f66b5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1124 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b9b6069 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1129 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2239ac76 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1140 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f84242e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1145 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a0ece81 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1150 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e2eda49 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1155 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b06f73c2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1161 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-80a9b240 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1166 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a35dc5b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1171 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-27ee74ce | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1175 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1b4fd36 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1180 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-69d11676 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1185 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2eb65adf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1214 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c81d8f5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1217 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb82bb86 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1221 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-56cc2a59 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1226 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6de76241 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1230 | else of (m != null && m.Count() > 0) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-58ced7f7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1230 | else of (m != null && m.Count() > 0) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-33a0938e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1235 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-71adedaa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1237 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-409f16fd | this.Load | FP00619_PlanBy_Line_Formation.cs:401 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-61db568c | this.Load | FP00619_PlanBy_Line_Formation.cs:402 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-f4a5472e | this.Load | FP00619_PlanBy_Line_Formation.cs:403 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00619_PlanBy_Line_Formation.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42181da3 | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1588 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa555704 | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1590 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-46103b43 | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1594 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Block_End_Date", sInstance, sPlanDate, UserInfoContext.Current.User… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1d890cc4 | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1611 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-b7036db7 | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1612 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |
| AC-748c0117 | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1636 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-c2996b35 | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1637 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-8bb4a62d | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1646 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(block date " + dtBlock_enddate.Rows[… | 메시지 표시 |  |  |  |
| AC-6da26a1f | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1650 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | UI_PROP | dCalendar_planrange.Value2 | dEndDate | 속성 Value2 설정 |  |  |  |
| AC-b098a209 | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1656 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | MESSAGE | MessageBox.Show | ("The End date can not be later than the block date(undefined).") | 메시지 표시 |  |  |  |
| AC-edd97e6d | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1657 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-14afc0fe | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1668 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ if (dayCount > 365) | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-ffa2637a | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1669 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ if (dayCount > 365) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-b84d6c86 | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1678 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ if (dtBlock_enddate … | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(block date " + dtBlock_enddate.Rows[… | 메시지 표시 |  |  |  |
| AC-5685182e | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1682 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ if (dtBlock_enddate … | UI_PROP | dCalendar_planrange.Value2 | dEndDate | 속성 Value2 설정 |  |  |  |
| AC-77a65d9d | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1688 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ else of (dtBlock_end… | MESSAGE | MessageBox.Show | ("The End date can not be later than the block date(undefined).") | 메시지 표시 |  |  |  |
| AC-338a7bd3 | dCalendar_planrange.ValueChanged | FP00619_PlanBy_Line_Formation.cs:1689 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ else of (dtBlock_end… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a63089c | DeleteButton | FP00619_PlanBy_Line_Formation.cs:600 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de0c21cf | DeleteButton | FP00619_PlanBy_Line_Formation.cs:601 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5187136 | Dispose | FP00619_PlanBy_Line_Formation.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00619_PlanBy_Line_Formation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72b145f1 | EditButton | FP00619_PlanBy_Line_Formation.cs:607 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cc926353 | EditButton | FP00619_PlanBy_Line_Formation.cs:608 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e98cd399 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00619_PlanBy_Line_Formation.cs:651 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bdc5ccd8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00619_PlanBy_Line_Formation.cs:655 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-01038c45 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00619_PlanBy_Line_Formation.cs:659 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-e4f83649 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00619_PlanBy_Line_Formation.cs:663 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00619_PlanBy_Line_Formation.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-738370dd | ExcelButton | FP00619_PlanBy_Line_Formation.cs:622 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-14e3dce8 | ExcelButton | FP00619_PlanBy_Line_Formation.cs:623 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-acfa7457 | ExcelButton | FP00619_PlanBy_Line_Formation.cs:625 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-aefbb937 | ExcelButton | FP00619_PlanBy_Line_Formation.cs:629 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-7cb16e1b | ExcelButton | FP00619_PlanBy_Line_Formation.cs:630 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-3c2ace09 | ExcelButton | FP00619_PlanBy_Line_Formation.cs:631 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-55b5fc59 | ExcelButton | FP00619_PlanBy_Line_Formation.cs:634 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-ec504dcc | ExcelButton | FP00619_PlanBy_Line_Formation.cs:635 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-42f8f8a1 | ExcelButton | FP00619_PlanBy_Line_Formation.cs:636 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-02d2ee09 | ExcelButton | FP00619_PlanBy_Line_Formation.cs:638 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-7c48395a | ExcelButton | FP00619_PlanBy_Line_Formation.cs:639 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FORMATION_MAIN")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c39ac6e | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:750 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00619_PLANBY_LINE_FORMATION", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-79f4a9a1 | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:752 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-d4ff3a1c | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:756 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.FindTotalColorStart

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e41c967d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:969 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f14bc3ac | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:677 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06d0ad04 | this.Load | FP00619_PlanBy_Line_Formation.cs:221 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00619_PlanBy_Line_Formation.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FORMATION_MAIN") ▸ try ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90452c6e | popSql.OnSql [if (programID == "PR_UI_FP00619_PLANBY_LINE_FO… 외 3 | FP00619_PlanBy_Line_Formation.cs:2304 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.GetOperation

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c89b26f1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1909 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ac6c87d0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1910 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-29d43e87 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1910 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0151e734 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1912 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00619_PlanBy_Line_Formation.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2733acc1 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2496 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-b74d763b | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2497 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.GetToDay

진입점: this.Load [try] / dCalendar_planrange.ValueChanged [if (getTypeName == "System.Windows.Forms.MaskedTextBox")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7e0d351 | this.Load [try] 외 1 | FP00619_PlanBy_Line_Formation.cs:2445 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-fefb9a18 | this.Load [try] 외 1 | FP00619_PlanBy_Line_Formation.cs:2446 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.GoDrawCellColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf29770e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1251 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72fbc959 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1315 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b689bccf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:1316 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c5849ba | this.Load | FP00619_PlanBy_Line_Formation.cs:288 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1c979040 | this.Load | FP00619_PlanBy_Line_Formation.cs:291 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanAmendMA) | 데이터 객체 조작/조회 |  |  |  |
| AC-19a3da4c | this.Load | FP00619_PlanBy_Line_Formation.cs:293 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-78e26024 | this.Load | FP00619_PlanBy_Line_Formation.cs:294 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9ad417ae | this.Load | FP00619_PlanBy_Line_Formation.cs:297 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d657b318 | this.Load | FP00619_PlanBy_Line_Formation.cs:300 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9472cb0c | this.Load | FP00619_PlanBy_Line_Formation.cs:305 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-33e95b7c | this.Load | FP00619_PlanBy_Line_Formation.cs:329 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e07b3bde | this.Load | FP00619_PlanBy_Line_Formation.cs:330 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-56dc6d46 | this.Load | FP00619_PlanBy_Line_Formation.cs:331 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7328fc50 | this.Load | FP00619_PlanBy_Line_Formation.cs:337 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00619_PlanBy_Line_Formation.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1750dff | this.Load | FP00619_PlanBy_Line_Formation.cs:256 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-141883a0 | this.Load | FP00619_PlanBy_Line_Formation.cs:257 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-3c96aeb8 | this.Load | FP00619_PlanBy_Line_Formation.cs:258 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-fa0ced20 | this.Load | FP00619_PlanBy_Line_Formation.cs:259 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-8feee1b5 | this.Load | FP00619_PlanBy_Line_Formation.cs:260 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-98837fb1 | this.Load | FP00619_PlanBy_Line_Formation.cs:261 |  | UI_PROP | mcbo_model_lt.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-e9679373 | this.Load | FP00619_PlanBy_Line_Formation.cs:262 |  | UI_PROP | mcbo_nickname_lt.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation.InitSpread

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80e955da | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:416 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-01cf11de | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:417 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2a9d143a | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:419 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dceeb75b | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:423 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00619_PlanBy_Line_Formation.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-632b127a | InsertButton | FP00619_PlanBy_Line_Formation.cs:592 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d14e8014 | InsertButton | FP00619_PlanBy_Line_Formation.cs:593 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.MakeMemoFontBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d93724d | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:3154 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-48cd1feb | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:3158 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |
| AC-04d62167 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:3169 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-3fee33f4 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:3173 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb2dcc8f | memo_menu.Click | FP00619_PlanBy_Line_Formation.cs:2231 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb306e87 | memo_menu.Click | FP00619_PlanBy_Line_Formation.cs:2234 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca38ad1e | memo_menu.Click | FP00619_PlanBy_Line_Formation.cs:2238 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00619_PlanBy_Line_Formation.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b9da86e | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2253 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-425e2198 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2256 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bfeeb254 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2274 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4873ce37 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2275 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e6fde479 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2276 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4ad34803 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2277 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-9764f01b | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2278 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-7e3ad806 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2279 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-e2c224c3 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2280 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-49267552 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2281 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9e95c164 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2282 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00619_PlanBy_Line_Formation.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19cdf51d | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2150 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfc17513 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2153 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55a44368 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2177 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a25337ba | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2191 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7952958 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2194 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a331ba59 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2218 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation.OpenLineMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64c242ee | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1917 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-17c1b9cd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1918 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-b1d73177 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1919 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-59356fd0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1919 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a71eef4e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1920 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-211f43ba | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1921 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-df6b9eba | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1922 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-85cd1192 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1927 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef217c74 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1930 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation.OpenMaterialMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f461af7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1936 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-08a5ab9e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1937 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-c4d34fef | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1938 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-ca5c737d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1938 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-17bdac39 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1939 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-d81b6852 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1940 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c7c55bcc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1941 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b580a119 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1945 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a879af64 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00619_PlanBy_Line_Formation.cs:1947 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00619_PlanBy_Line_Formation.Query

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eca29fdb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2939 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-c925dec2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2939 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f2213084 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2940 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-880d7515 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2940 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7dfe6ac7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2941 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-36b2d0d7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2941 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-61bef4e3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2944 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-119623c2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2951 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-c1a81ca3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2956 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09c58215 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2957 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f1a97f5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2959 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00619_PlanBy_Line_Formation.RefereshHeader

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08aa0bef | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2965 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d35462d8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2967 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-538e6970 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2992 |  | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-375ea87b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2993 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00619_PlanBy_Line_Formation.RefreshHeadAndBody

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null)] / this.btnC…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75a47fd3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2822 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2648b041 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2838 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-dbe8c6bc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2842 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00619_PlanBy_Line_Formation.RefreshHeaderOnly

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1ba019e | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2856 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-7165a24f | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2860 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-c75bd3cc | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2861 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b7e2f91 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2862 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f5d4eac | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2863 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a20e5055 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2864 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-2c74f7e7 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2868 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-8918544e | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2869 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-a8924ccf | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2870 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-0fe3f664 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2871 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-c65e5294 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2877 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f059da9 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2878 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7640cfe5 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2911 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-881256a5 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2916 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, FPExtensions.DateColumnT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea5a23ea | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2918 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bcfa7c21 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2919 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1d75a0a9 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2920 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-96612c62 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2922 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-747bbcc3 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2924 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-be368e74 | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2925 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-005aedab | this.Load 외 6 | FP00619_PlanBy_Line_Formation.cs:2930 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP00619_PlanBy_Line_Formation.RefreshSpreadSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null)] / this.btnC…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b303637 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2794 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-74ba9c02 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2794 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-37068c74 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2808 | if (dsMain.Good()) | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-72abe8fe | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:2815 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00619_PlanBy_Line_Formation.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aced419f | popSql.OnSql | FP00619_PlanBy_Line_Formation.cs:2465 | if (programID == "PR_UI_FP00619_PLANBY_LINE_FORMATION_MAIN") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-3e70b485 | popSql.OnSql | FP00619_PlanBy_Line_Formation.cs:2478 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e53b57b2 | SaveButton | FP00619_PlanBy_Line_Formation.cs:614 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-36b3384f | SaveButton | FP00619_PlanBy_Line_Formation.cs:615 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetCalenderColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78444eff | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:3058 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e34f46d8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:3062 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-0cc0e1e5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:3064 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c43f41ce | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:3068 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-5724a8e4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:3084 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-857a1417 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:3099 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetChangeControl

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / cbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / chk_allLine.CheckedChanged / chk_IncludeSubOp.CheckedChanged / this.chk_IncludeSubOp.CheckedChanged / this.chkInAct.CheckedChanged / this.chk_allLine.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1993765 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:354 | switch (triggerControl) case DefColumns.INSTANCE_ID: | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-04614269 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:354 | switch (triggerControl) case DefColumns.INSTANCE_ID: | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-52b106a7 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:355 | switch (triggerControl) case DefColumns.INSTANCE_ID: | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b1216b57 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:358 | switch (triggerControl) case DefColumns.DIVISION_ID: | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-5b28fea0 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:359 | switch (triggerControl) case DefColumns.DIVISION_ID: | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2fe227d9 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:359 | switch (triggerControl) case DefColumns.DIVISION_ID: | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1509d100 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:360 | switch (triggerControl) case DefColumns.DIVISION_ID: | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f18b1f82 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:363 | switch (triggerControl) case DefColumns.SITE_ID: | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-45972cc4 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:364 | switch (triggerControl) case DefColumns.SITE_ID: | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e91b1a29 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:364 | switch (triggerControl) case DefColumns.SITE_ID: | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-753fbd82 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:365 | switch (triggerControl) case DefColumns.SITE_ID: | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7fc3d826 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:368 | switch (triggerControl) case DefColumns.PLANT_ID: | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-442f6de1 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:369 | switch (triggerControl) case DefColumns.PLANT_ID: | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-6233c444 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:369 | switch (triggerControl) case DefColumns.PLANT_ID: | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5d049cbf | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:370 | switch (triggerControl) case DefColumns.PLANT_ID: | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-22b419aa | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:374 | switch (triggerControl) case DefColumns.FACTORY_ID: | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-36dc83b2 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:375 | switch (triggerControl) case DefColumns.FACTORY_ID: | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ed2d54a2 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:375 | switch (triggerControl) case DefColumns.FACTORY_ID: | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9b37bdb7 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:376 | switch (triggerControl) case DefColumns.FACTORY_ID: | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fd271731 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:379 | switch (triggerControl) case DefColumns.OPERATION_ID: | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-39ca8308 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:380 | switch (triggerControl) case DefColumns.OPERATION_ID: | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-188d5b05 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:380 | switch (triggerControl) case DefColumns.OPERATION_ID: | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d2dac684 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:381 | switch (triggerControl) case DefColumns.OPERATION_ID: | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0beda6b6 | this.Load [try] 외 12 | FP00619_PlanBy_Line_Formation.cs:384 | switch (triggerControl) case DefColumns.LINE_ID: | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetColumnChangeByMemo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed952735 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:1424 |  | FLAG | GnlcellType | new GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-b6062871 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:1425 |  | UI_PROP | GnlcellType.FormatString | "###,###.#" | 속성 FormatString 설정 |  |  |  |
| AC-1962a3b2 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:1433 | try ▸ if (iColStartIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53192247 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:1452 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") | GRID_SET | siMain.ActiveSheet.Cells[k, froz, k, last_col - 1].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-8c9ea7f8 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:1484 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00418fab | this.Load | FP00619_PlanBy_Line_Formation.cs:241 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-37ad13b8 | this.Load | FP00619_PlanBy_Line_Formation.cs:243 | if (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-dd878759 | this.Load | FP00619_PlanBy_Line_Formation.cs:244 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-9b1529ee | this.Load | FP00619_PlanBy_Line_Formation.cs:248 | else of (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f62681d6 | this.Load | FP00619_PlanBy_Line_Formation.cs:249 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00619_PlanBy_Line_Formation.SetDirty

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1468e4f9 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:2436 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afb37554 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2332 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-096b1aff | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2332 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f2c62a41 | (진입점 미연결) | FP00619_PlanBy_Line_Formation.cs:2333 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_factory.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-757c534b | this.Load [try] 외 24 | FP00619_PlanBy_Line_Formation.cs:2299 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetModelLT

진입점: this.Load [try ▸ switch (triggerControl) case DefColumns.LINE_ID:] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / cbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / mcbo_factory.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / mcbo_operation.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / mcbo_line.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2e3709d | this.Load [try ▸ switch (triggerControl) case DefColumns.LIN… 외 13 | FP00619_PlanBy_Line_Formation.cs:2363 |  | FLAG | dtModelLT | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00619_find_Model_List", Filter["… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-311b00f3 | this.Load [try ▸ switch (triggerControl) case DefColumns.LIN… 외 13 | FP00619_PlanBy_Line_Formation.cs:2363 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00619_find_Model_List", Filter["BUCKET_FROM"], Filter["BUCKET_TO"] , F… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-067544f4 | this.Load [try ▸ switch (triggerControl) case DefColumns.LIN… 외 13 | FP00619_PlanBy_Line_Formation.cs:2366 |  | LIST_REBIND | clsCtrl.setListBox | (dtModelLT, mcbo_model_lt, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetNickNameLT

진입점: this.Load [try ▸ switch (triggerControl) case DefColumns.LINE_ID:] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / cbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / mcbo_factory.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / mcbo_operation.SelectedIndexChanged [switch (triggerControl) case DefColumns.LINE_ID:] / mcbo_line.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c275b3d4 | this.Load [try ▸ switch (triggerControl) case DefColumns.LIN… 외 13 | FP00619_PlanBy_Line_Formation.cs:2373 |  | FLAG | dtNickNameLT | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00619_find_NickName_List", Filte… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-fff98988 | this.Load [try ▸ switch (triggerControl) case DefColumns.LIN… 외 13 | FP00619_PlanBy_Line_Formation.cs:2373 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00619_find_NickName_List", Filter["BUCKET_FROM"], Filter["BUCKET_TO"] … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b0a318d | this.Load [try ▸ switch (triggerControl) case DefColumns.LIN… 외 13 | FP00619_PlanBy_Line_Formation.cs:2376 |  | LIST_REBIND | clsCtrl.setListBox | (dtNickNameLT, mcbo_nickname_lt, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e871bde | this.Load [try] | FP00619_PlanBy_Line_Formation.cs:2319 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-df9ed8a0 | this.Load [try] | FP00619_PlanBy_Line_Formation.cs:2320 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-23b4506c | this.Load [try] | FP00619_PlanBy_Line_Formation.cs:2320 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-31539e0c | this.Load [try] | FP00619_PlanBy_Line_Formation.cs:2321 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetPlanPeriod

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a5bcfef | this.Load [try] 외 1 | FP00619_PlanBy_Line_Formation.cs:2394 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6226d5d8 | this.Load [try] 외 1 | FP00619_PlanBy_Line_Formation.cs:2409 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-2e621335 | this.Load [try] 외 1 | FP00619_PlanBy_Line_Formation.cs:2410 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-f67bc2f7 | this.Load [try] 외 1 | FP00619_PlanBy_Line_Formation.cs:2414 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-857216c6 | this.Load [try] 외 1 | FP00619_PlanBy_Line_Formation.cs:2415 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-348e1d75 | this.Load [try] 외 1 | FP00619_PlanBy_Line_Formation.cs:2421 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-aeff208e | this.Load [try] 외 1 | FP00619_PlanBy_Line_Formation.cs:2422 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (mont…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae88c78f | this.Load [try] 외 6 | FP00619_PlanBy_Line_Formation.cs:431 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4afe4c32 | this.Load [try] 외 6 | FP00619_PlanBy_Line_Formation.cs:432 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00619_PlanBy_Line_Formation.SetTotalColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9ef83cd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00619_PlanBy_Line_Formation.cs:3036 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00619_PlanBy_Line_Formation.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fac535c9 | this.spdMain.CellClick | FP00619_PlanBy_Line_Formation.cs:2127 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-bb5f37b6 | this.spdMain.CellClick | FP00619_PlanBy_Line_Formation.cs:2128 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-519f655f | this.spdMain.CellClick | FP00619_PlanBy_Line_Formation.cs:2130 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-be8d8c55 | this.spdMain.CellClick | FP00619_PlanBy_Line_Formation.cs:2138 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00619_PlanBy_Line_Formation.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-648d31c7 | this.spdMain.CellDoubleClick | FP00619_PlanBy_Line_Formation.cs:2092 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-8bb5c2c2 | this.spdMain.CellDoubleClick | FP00619_PlanBy_Line_Formation.cs:2099 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00619_PlanBy_Line_Formation.SwitchMemo

진입점: memo_menu.Click [try ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e13f8ff | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00619_PlanBy_Line_Formation.cs:1957 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a111725 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00619_PlanBy_Line_Formation.cs:1974 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-4cc8d038 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00619_PlanBy_Line_Formation.cs:2005 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-d40b0466 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00619_PlanBy_Line_Formation.cs:2006 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-7cbfc77d | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00619_PlanBy_Line_Formation.cs:2008 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c2dbb6b2 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00619_PlanBy_Line_Formation.cs:2039 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-df17ff57 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00619_PlanBy_Line_Formation.cs:2040 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-b46243e7 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00619_PlanBy_Line_Formation.cs:2042 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00619_PlanBy_Line_Formation.UIFindData

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9c3dd87 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:460 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cba5c7c3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:461 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67be9dc2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:464 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5d185c76 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:468 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-864da933 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:482 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-23321bee | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:483 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c5d6722 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:486 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-129b120a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:490 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-aaa175a1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:491 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dfabab47 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:501 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-df2fed73 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:503 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-79e48972 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:503 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-39a3f122 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:516 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea73616d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:527 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-33e2ca19 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:529 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-03ed33cf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:531 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b27061b8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:537 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-252eb1ff | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:539 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-93763a10 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:542 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce8d88f0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:555 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7978f320 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:560 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-667d0d83 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:565 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d7f5683b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:566 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-529d7ae9 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:573 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b896f739 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:579 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-34f5d02e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00619_PlanBy_Line_Formation.cs:583 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

