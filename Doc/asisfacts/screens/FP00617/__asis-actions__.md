# AS-IS 액션 대조표 — FP00617

> 원천: `Doc/asisfacts/screens/FP00617/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 578행 · 메서드 81 · 종류 DATA_OP 171 · UI_PROP 78 · FLAG 58 · RETURN 49 · VALUE_SET 35 · UI_MISC 32 · COMBO_DATA 29 · POPUP 27 · CALL_EXT 26 · MESSAGE 14 · GRID_INIT 13 · LIST_REBIND 10 · GRID_SET 8 · THROW 6 · ENDPOINT 5 · GRID_STYLE 5 · STATE 4 · CALL_BASE 3 · GRID_LOCK 2 · EXCEL 1 · STATE_RESET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 29


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ab545ca | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2429 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-8caba58d | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2435 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-acb5ac71 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2443 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-edd09a4e | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2444 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-541e4900 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2445 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-8fcf241d | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2446 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-46b2d462 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2448 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-af5bf52e | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2449 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-40bd5b58 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2450 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-33f1e109 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2451 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-8c9b4e8b | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2452 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-334b3e96 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2453 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-85b6b8e0 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2454 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b89bc94 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2455 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-71cdd2aa | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2458 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-eeb62406 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2643 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-9f06c3bc | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2644 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-81763241 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2645 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-2d574df1 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2646 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-b3e73397 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2648 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-b74af307 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2649 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-0f0b80d1 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2650 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-23df02f7 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2651 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-ad8bad20 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2652 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e62e858 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2653 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-4e4f6e86 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2654 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ef98de7 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2655 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-1092d8e9 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2657 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47cd51fe | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2562 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e688930 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2563 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bbb3b165 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2564 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ded37726 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2565 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d5c45a76 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2566 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f012057 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2569 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ff1948e | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2573 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a265cbe | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2574 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d4c42e1 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2560 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-cda76d62 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2590 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-226ae89a | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2593 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4ac2f8e | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2596 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-fdca7acd | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2599 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-44a6ea37 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2602 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-d2990181 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2605 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-be0e3a07 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2611 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-e867b3f9 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2613 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecaff1d9 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2534 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a4a23ba | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2498 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ed71756 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2499 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3cde5b9e | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2500 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c309cdf | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2501 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-58f020d7 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2502 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-534a63de | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2503 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e59c3bd2 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2505 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4b74addc | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2506 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0be55198 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2509 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-79a0e7b2 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2510 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f8f3d4f | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2511 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-31bf76a2 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2496 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-75ff697f | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2519 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-36f1abd0 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2520 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a341f82 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2525 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4a2617c | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2471 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00617_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e07beb9a | .ctor | FP00617_MeasureSetForm_Popup.cs:79 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-25e13fd1 | .ctor | FP00617_MeasureSetForm_Popup.cs:80 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-e6cbdbdc | .ctor | FP00617_MeasureSetForm_Popup.cs:81 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-07ae410b | .ctor | FP00617_MeasureSetForm_Popup.cs:83 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00617_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17fcdb1f | this.btnOK.Click | FP00617_MeasureSetForm_Popup.cs:357 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-3c983aaf | this.btnOK.Click | FP00617_MeasureSetForm_Popup.cs:358 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-802c7ae7 | this.btnOK.Click | FP00617_MeasureSetForm_Popup.cs:365 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-f9ff8345 | this.btnOK.Click | FP00617_MeasureSetForm_Popup.cs:366 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00617_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06436e61 | this.btnSet.Click | FP00617_MeasureSetForm_Popup.cs:327 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-e686e647 | this.btnSet.Click | FP00617_MeasureSetForm_Popup.cs:328 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-bba75bc5 | this.btnSet.Click | FP00617_MeasureSetForm_Popup.cs:330 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cf6353be | this.btnSet.Click | FP00617_MeasureSetForm_Popup.cs:331 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5361ebf1 | this.btnSet.Click | FP00617_MeasureSetForm_Popup.cs:333 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-85522ebc | this.btnSet.Click | FP00617_MeasureSetForm_Popup.cs:335 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-1a2cdd2b | this.btnSet.Click | FP00617_MeasureSetForm_Popup.cs:336 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00617_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7eba4782 | Dispose | FP00617_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00617_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d0a11e6 | this.Load | FP00617_MeasureSetForm_Popup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00617_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc8a9a4d | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:224 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-55599323 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:225 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-5dc94421 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:226 |  | DATA_OP | ctrls.Add | (chk_result_in) | 데이터 객체 조작/조회 |  |  |  |
| AC-b12bb2f9 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:227 |  | DATA_OP | ctrls.Add | (chk_result_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-738f815d | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:229 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-a55bdd5c | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-eadbba4e | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_seq) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffb6bb79 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff5465cd | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-44df7d01 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-c96bb634 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_offtime) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa64efa0 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-2adebef3 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac5dd40d | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:242 |  | DATA_OP | ctrls.Add | (chk_result_in_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-523661bd | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-e00a6476 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:245 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-4af8954e | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:246 |  | DATA_OP | ctrls.Add | (chk_result_out_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfcf2175 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:248 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-502bba49 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:249 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-d41484a7 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3e6dc36 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:252 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-916b4694 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:253 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a2cf6b5 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:256 |  | DATA_OP | ctrls.Add | (chk_kg) | 데이터 객체 조작/조회 |  |  |  |
| AC-653d9e6b | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:257 |  | DATA_OP | ctrls.Add | (chk_batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-46b875f2 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:260 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-fa225bbf | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:260 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-dbfc0c37 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:267 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-9d05ad1c | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:271 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |

## FP00617_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0427949f | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b0828df2 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8682d083 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_result_in.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ed6aaa0e | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_result_out.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1f4c01b6 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c1b50100 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8f1decc6 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_seq.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bb33de60 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ea11d0e6 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f547ccb8 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-af6cd8de | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_offtime.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-eee82d4b | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-680f431d | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d454be68 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_result_in_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-49d2c334 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6a82b412 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8b215e36 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_result_out_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7a1b3b0c | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8f767243 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-77ee76ee | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:167 |  | VALUE_SET | chk_memo_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ffeab0db | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0ab0055f | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c2bf9331 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:174 |  | VALUE_SET | chk_kg.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-81af5082 | this.Load 외 1 | FP00617_MeasureSetForm_Popup.cs:175 |  | VALUE_SET | chk_batch.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00617_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1b5e289 | (진입점 미연결) | FP00617_MeasureSetForm_Popup.cs:422 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-9943271d | (진입점 미연결) | FP00617_MeasureSetForm_Popup.cs:433 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-647950d2 | (진입점 미연결) | FP00617_MeasureSetForm_Popup.cs:444 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00617_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f6c8228 | this.Load | FP00617_MeasureSetForm_Popup.cs:94 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c1f2a35f | this.Load | FP00617_MeasureSetForm_Popup.cs:102 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00617_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bc86849 | this.btnSet.Click 외 1 | FP00617_MeasureSetForm_Popup.cs:372 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9a2a7321 | this.btnSet.Click 외 1 | FP00617_MeasureSetForm_Popup.cs:380 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-f02ebd9f | this.btnSet.Click 외 1 | FP00617_MeasureSetForm_Popup.cs:380 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-c0ba7fff | this.btnSet.Click 외 1 | FP00617_MeasureSetForm_Popup.cs:397 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a17d7d9b | this.btnSet.Click 외 1 | FP00617_MeasureSetForm_Popup.cs:408 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b126983c | .ctor | FP00617_PlanBy_Line_PreMix.cs:193 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00617_PlanBy_Line_PreMix.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PREMIX_MEMO")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbe18d8c | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:719 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e0182b0b | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:720 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0fe6fc3b | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:721 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-73700c2f | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:722 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-142defb3 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:723 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f6113d89 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:724 |  | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f6390de1 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:726 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd945e73 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:727 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-48652fcd | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:729 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f4d86855 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:730 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c5a7a215 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:732 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9a58d680 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:733 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8d145370 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:735 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d5635374 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:736 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-70d3f735 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:738 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00617_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-760dbeed | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:739 |  | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-5841ef53 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:746 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-512ab813 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:747 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f642676d | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:748 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e9a0a357 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:749 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e538fc29 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:761 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-a6c250af | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:767 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c2ac8b43 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:768 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a1bb0eb6 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:769 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-34310ba7 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:771 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-19cdd03c | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:772 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-ffe9e4f7 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:773 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-c291e5ad | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:774 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-e5c7612b | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:775 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-0562bc7a | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:776 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-005ca035 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:777 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00617_PlanBy_Line_PreMix.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PREMIX_MEMO")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60cb1385 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:783 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; //Plan Group if (GetFilter("INSTANCE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b6245c0 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:794 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-7ccdcd74 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:795 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-8ed5dfd3 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:801 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8f58e075 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:825 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c59db155 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:828 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_currDateCol", Filter["INSTANCE_ID"], Filter["BUCKET_FROM"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00617_PlanBy_Line_PreMix.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97febf38 | this.btnBucket.Click | FP00617_PlanBy_Line_PreMix.cs:1610 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-4e929ed5 | this.btnBucket.Click | FP00617_PlanBy_Line_PreMix.cs:1613 |  | POPUP | new FP00599_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-6ed39252 | this.btnBucket.Click | FP00617_PlanBy_Line_PreMix.cs:1614 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e81249a0 | this.btnBucket.Click | FP00617_PlanBy_Line_PreMix.cs:1615 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-37413574 | this.btnBucket.Click | FP00617_PlanBy_Line_PreMix.cs:1616 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d9cdbdd5 | this.btnBucket.Click | FP00617_PlanBy_Line_PreMix.cs:1620 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-a50ea516 | this.btnBucket.Click | FP00617_PlanBy_Line_PreMix.cs:1632 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-219048d1 | this.btnBucket.Click | FP00617_PlanBy_Line_PreMix.cs:1641 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00617_PlanBy_Line_PreMix.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25062826 | this.btnCatagory.Click | FP00617_PlanBy_Line_PreMix.cs:1559 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-870c8ab2 | this.btnCatagory.Click | FP00617_PlanBy_Line_PreMix.cs:1562 |  | POPUP | new FP00617_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-6fd2ed4c | this.btnCatagory.Click | FP00617_PlanBy_Line_PreMix.cs:1563 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-2dc12b86 | this.btnCatagory.Click | FP00617_PlanBy_Line_PreMix.cs:1564 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3ea10d81 | this.btnCatagory.Click | FP00617_PlanBy_Line_PreMix.cs:1565 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3efbd667 | this.btnCatagory.Click | FP00617_PlanBy_Line_PreMix.cs:1569 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-a1064edb | this.btnCatagory.Click | FP00617_PlanBy_Line_PreMix.cs:1581 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7bb197b0 | this.btnCatagory.Click | FP00617_PlanBy_Line_PreMix.cs:1590 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aa7f9873 | this.btnCatagory.Click | FP00617_PlanBy_Line_PreMix.cs:1595 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-b0549835 | this.btnCatagory.Click | FP00617_PlanBy_Line_PreMix.cs:1601 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00617_PlanBy_Line_PreMix.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d31b136a | this.btnColumn.Click | FP00617_PlanBy_Line_PreMix.cs:1532 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-dd841c6d | this.btnColumn.Click | FP00617_PlanBy_Line_PreMix.cs:1535 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-acfe88eb | this.btnColumn.Click | FP00617_PlanBy_Line_PreMix.cs:1536 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b1b683c1 | this.btnColumn.Click | FP00617_PlanBy_Line_PreMix.cs:1537 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c33c72bc | this.btnColumn.Click | FP00617_PlanBy_Line_PreMix.cs:1543 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-511bff3b | this.btnColumn.Click | FP00617_PlanBy_Line_PreMix.cs:1543 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-149ec893 | this.btnColumn.Click | FP00617_PlanBy_Line_PreMix.cs:1544 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-517b6791 | this.btnColumn.Click | FP00617_PlanBy_Line_PreMix.cs:1550 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00617_PlanBy_Line_PreMix.btnMemo_Click

진입점: this.usrButton3.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2f1ca25 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1676 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-a8b5794a | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1677 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6d1c3b6 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1680 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a7754ff9 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1681 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-e78f8f3c | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1682 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-c1f3aa47 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1683 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fa445424 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1684 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-606c181d | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1685 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-87423270 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1686 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f996c527 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1686 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b1d5413a | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1687 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2d10cc21 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1688 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4c074f3b | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1689 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-791be872 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1690 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-25a42849 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1691 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-73378606 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1692 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f43c5e79 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1693 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1ababfef | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1694 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-87408eeb | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1695 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-42fb2ef5 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1697 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c9b3195c | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1698 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-31a41080 | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1699 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-4277461d | this.usrButton3.Click | FP00617_PlanBy_Line_PreMix.cs:1700 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00617_PlanBy_Line_PreMix.btnPlanInfo_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc123e83 | this.usrButton1.Click | FP00617_PlanBy_Line_PreMix.cs:1650 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-e99c6f34 | this.usrButton1.Click | FP00617_PlanBy_Line_PreMix.cs:1651 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc980370 | this.usrButton1.Click | FP00617_PlanBy_Line_PreMix.cs:1657 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-d10c96fd | this.usrButton1.Click | FP00617_PlanBy_Line_PreMix.cs:1660 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-06671398 | this.usrButton1.Click | FP00617_PlanBy_Line_PreMix.cs:1661 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7aaf5342 | this.usrButton1.Click | FP00617_PlanBy_Line_PreMix.cs:1661 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aab757bc | this.usrButton1.Click | FP00617_PlanBy_Line_PreMix.cs:1662 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-bc91bfea | this.usrButton1.Click | FP00617_PlanBy_Line_PreMix.cs:1663 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6f03c0d6 | this.usrButton1.Click | FP00617_PlanBy_Line_PreMix.cs:1665 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-220f6b2f | this.usrButton1.Click | FP00617_PlanBy_Line_PreMix.cs:1666 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00617_PlanBy_Line_PreMix.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8d1d2cc | this.btnSql.Click | FP00617_PlanBy_Line_PreMix.cs:1711 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a4cbcb4d | this.btnSql.Click | FP00617_PlanBy_Line_PreMix.cs:1714 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ff547882 | this.btnSql.Click | FP00617_PlanBy_Line_PreMix.cs:1715 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c6a47fc4 | this.btnSql.Click | FP00617_PlanBy_Line_PreMix.cs:1717 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00617_PLANBY_LINE_PREMIX_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebea9df4 | this.btnSql.Click | FP00617_PlanBy_Line_PreMix.cs:1718 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00617_PLANBY_LINE_PREMIX_MEMO") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2cfaf26 | this.btnSql.Click | FP00617_PlanBy_Line_PreMix.cs:1720 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00617_PlanBy_Line_PreMix.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8608859f | this.Load | FP00617_PlanBy_Line_PreMix.cs:1110 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f099525 | this.Load | FP00617_PlanBy_Line_PreMix.cs:1110 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-470b3792 | this.Load | FP00617_PlanBy_Line_PreMix.cs:1112 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00617_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-45aaa2eb | this.Load | FP00617_PlanBy_Line_PreMix.cs:1112 |  | POPUP | new FP00617_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-38595a02 | this.Load | FP00617_PlanBy_Line_PreMix.cs:1113 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-81bc4430 | this.Load | FP00617_PlanBy_Line_PreMix.cs:1113 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.chk_allLine_CheckedChanged

진입점: chk_allLine.CheckedChanged / this.chk_allLine.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8ddc211 | chk_allLine.CheckedChanged 외 1 | FP00617_PlanBy_Line_PreMix.cs:1358 | if (chk_allLine.Checked) | CALL_EXT | mcbo_line.SetAllCheckItem | (true) | ⚠ 의미 확인 필요 |  |  |  |

## FP00617_PlanBy_Line_PreMix.chkInAct_CheckedChanged

진입점: this.chkInAct.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0e3bcb0 | this.chkInAct.CheckedChanged | FP00617_PlanBy_Line_PreMix.cs:1406 | if (chk_allLine.Checked) | CALL_EXT | mcbo_line.SetAllCheckItem | (true) | ⚠ 의미 확인 필요 |  |  |  |

## FP00617_PlanBy_Line_PreMix.CreateFilterDataSet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain.Good())] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71025bcd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:866 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f08d9e0d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:878 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-092d250b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:879 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-9d7e7b2e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:900 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab37cbfc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:901 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b9c53fa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:905 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2656ec7a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:906 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-58f367bc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:910 | if (measure["chk_result_in"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-90d275cd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:911 | if (measure["chk_result_in"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-28296d78 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:918 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-825a901c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:919 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e85f515 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:923 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-273e83f4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:924 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-485ccfe2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:928 | if (measure["chk_seq"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_SEQ")) | 데이터 객체 조작/조회 |  |  |  |
| AC-12cebf35 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:932 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad766eae | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:938 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e97809aa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:939 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-67642018 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:943 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2dbb3bab | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:944 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f25f6e1d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:948 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa42e3aa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:957 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_memo_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", MEMO_COLUMN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0992adc4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:961 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3db3165a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:962 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb727e2e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:966 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a00397de | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:967 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-18ff5e8f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:971 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c07d9ff | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:972 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b1f1811 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:978 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2330c54f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:979 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-476fc45b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:983 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4ea65bb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:984 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f87a3fe | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:988 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a9baf30 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:989 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1e19b24 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:996 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-64be4e95 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:997 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a116540 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1001 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7057e0a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1002 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a3db1ed | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1013 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ee75392 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1014 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d4bec48 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1018 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5d91928 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1019 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-601d1bac | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1023 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aabd0536 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1024 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d716b3f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1030 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed261466 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1031 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-97ab16d3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1035 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b716e5cb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1036 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c30b237 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1040 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f98d6d4e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1041 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7021513b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1047 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-71fcae74 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1048 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ecfddb84 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1052 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fdebe956 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1053 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f9ab5d0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1062 | if (measure["chk_kg"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("MEASURE_NAME", "Kg")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9869287 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1065 | if (measure["chk_kg"].Value != "true") ▸ lambda | DATA_OP | x.Field | ("MEASURE_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c1b219d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1067 | if (measure["chk_kg"].Value != "true") | DATA_OP | tmp.Select | (result_row => result_row["_MM_"] = false) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7d92f65 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1067 | if (measure["chk_kg"].Value != "true") ▸ lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-c5bdc91c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1072 | if (measure["chk_batch"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("MEASURE_NAME", "Batch")) | 데이터 객체 조작/조회 |  |  |  |
| AC-00e81ef7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1076 | if (measure["chk_batch"].Value != "true") ▸ lambda | DATA_OP | x.Field | ("MEASURE_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-3148576f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1078 | if (measure["chk_batch"].Value != "true") | DATA_OP | tmp.Select | (result_row => result_row["_MM_"] = false) | 데이터 객체 조작/조회 |  |  |  |
| AC-0398906a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1078 | if (measure["chk_batch"].Value != "true") ▸ lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-e25917cd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1082 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e0a2dd7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1085 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-50e7012a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1089 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a606eab | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1094 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fe45cfbd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1098 | else of (m != null && m.Count() > 0) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e14ecfdd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1098 | else of (m != null && m.Count() > 0) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-f2310166 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1102 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-35c0fd09 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1104 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ce5e4ee | this.Load | FP00617_PlanBy_Line_PreMix.cs:374 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-32d37ebc | this.Load | FP00617_PlanBy_Line_PreMix.cs:375 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-399a9fee | this.Load | FP00617_PlanBy_Line_PreMix.cs:376 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged / this.dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b009147f | dCalendar_planrange.ValueChanged 외 1 | FP00617_PlanBy_Line_PreMix.cs:1461 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ff7b01a | dCalendar_planrange.ValueChanged 외 1 | FP00617_PlanBy_Line_PreMix.cs:1469 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8d1a1cd0 | dCalendar_planrange.ValueChanged 외 1 | FP00617_PlanBy_Line_PreMix.cs:1486 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | MESSAGE | MessageBox.Show | ("It cannot be exceeded 100 days") | 메시지 표시 |  |  |  |
| AC-082a7e16 | dCalendar_planrange.ValueChanged 외 1 | FP00617_PlanBy_Line_PreMix.cs:1487 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(100) | 속성 Value2 설정 |  |  |  |
| AC-5514b4d7 | dCalendar_planrange.ValueChanged 외 1 | FP00617_PlanBy_Line_PreMix.cs:1495 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ else of (string.… | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(" + sEndDate + ")!") | 메시지 표시 |  |  |  |
| AC-e301b074 | dCalendar_planrange.ValueChanged 외 1 | FP00617_PlanBy_Line_PreMix.cs:1496 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ else of (string.… | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-d033af73 | dCalendar_planrange.ValueChanged 외 1 | FP00617_PlanBy_Line_PreMix.cs:1497 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ else of (string.… | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-9fb3b75b | dCalendar_planrange.ValueChanged 외 1 | FP00617_PlanBy_Line_PreMix.cs:1509 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | MESSAGE | MessageBox.Show | ("It cannot be exceeded 100 days") | 메시지 표시 |  |  |  |
| AC-42d9f4b2 | dCalendar_planrange.ValueChanged 외 1 | FP00617_PlanBy_Line_PreMix.cs:1510 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(100) | 속성 Value2 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe2f3758 | DeleteButton | FP00617_PlanBy_Line_PreMix.cs:552 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c846b73 | DeleteButton | FP00617_PlanBy_Line_PreMix.cs:553 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b57abc2e | Dispose | FP00617_PlanBy_Line_PreMix.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00617_PlanBy_Line_PreMix.DrawHeader

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04d38f2f | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2739 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-0b28f10b | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2743 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-610583b9 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2744 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59fd6f57 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2745 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6436f72b | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2746 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-313f24a7 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2747 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-34b32ace | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2751 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-b4124ae8 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2752 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-25162c7f | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2753 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-57b90e61 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2754 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-7974b8d5 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2760 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f531efd | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2761 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-44d76e85 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2794 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-02753801 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2799 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, FPExtensions.DateColumnT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-63cc9736 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2801 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fff5a8d4 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2802 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c6873ba | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2803 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-202151e1 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2805 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-87ab56e3 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2807 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-051934cd | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2808 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3ea4b01 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:2813 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP00617_PlanBy_Line_PreMix.DrawSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b2ebabf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2848 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ab4ec847 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2850 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a5fb65d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2874 |  | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-68aca31f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2875 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e322d53 | EditButton | FP00617_PlanBy_Line_PreMix.cs:559 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fd5e15a | EditButton | FP00617_PlanBy_Line_PreMix.cs:560 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-874296a9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00617_PlanBy_Line_PreMix.cs:603 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b81c7f9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00617_PlanBy_Line_PreMix.cs:607 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4335cba5 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00617_PlanBy_Line_PreMix.cs:611 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-3be8c420 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00617_PlanBy_Line_PreMix.cs:615 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-879e13da | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00617_PlanBy_Line_PreMix.cs:628 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00617_PlanBy_Line_PreMix.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10daf2c0 | ExcelButton | FP00617_PlanBy_Line_PreMix.cs:574 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-2b3adc37 | ExcelButton | FP00617_PlanBy_Line_PreMix.cs:575 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-4c2109a3 | ExcelButton | FP00617_PlanBy_Line_PreMix.cs:577 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-acfef27e | ExcelButton | FP00617_PlanBy_Line_PreMix.cs:581 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-a1ee9909 | ExcelButton | FP00617_PlanBy_Line_PreMix.cs:582 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-022170f7 | ExcelButton | FP00617_PlanBy_Line_PreMix.cs:583 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-8eb59165 | ExcelButton | FP00617_PlanBy_Line_PreMix.cs:586 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-a8bbed88 | ExcelButton | FP00617_PlanBy_Line_PreMix.cs:587 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-c31de6b1 | ExcelButton | FP00617_PlanBy_Line_PreMix.cs:588 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-c08b95a3 | ExcelButton | FP00617_PlanBy_Line_PreMix.cs:590 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-a95ebff5 | ExcelButton | FP00617_PlanBy_Line_PreMix.cs:591 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PREMIX_MAIN")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-467530cb | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:707 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00617_PLANBY_LINE_PREMIX", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e5f00352 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:709 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-119bf885 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:713 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.Find_Data_Memo

진입점: popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PREMIX_MEMO")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13eb0bd8 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… | FP00617_PlanBy_Line_PreMix.cs:1271 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00617_PLANBY_LINE_PREMIX", Filter, _CurrentUser, pSysType, "SELECT_MEA_MEMO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6e30b717 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… | FP00617_PlanBy_Line_PreMix.cs:1273 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-e4f468bf | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… | FP00617_PlanBy_Line_PreMix.cs:1277 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.FindTotalColorStart

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d220155 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:860 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac2c7e7b | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:634 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-761a977d | this.Load | FP00617_PlanBy_Line_PreMix.cs:208 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00617_PlanBy_Line_PreMix.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PREMIX_MEMO") ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4252075 | popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PR… 외 3 | FP00617_PlanBy_Line_PreMix.cs:2127 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.GetOperation

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6906e7b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1728 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c5d6b7c2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1729 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b41c5cb4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1729 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5b980239 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1731 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b42e486 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2379 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-99f56485 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2380 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.GetToDay

진입점: this.Load [try] / dCalendar_planrange.ValueChanged [if (getTypeName == "System.Windows.Forms.MaskedTextBox")] / popSql.OnSql [if (programID == "PR_UI_FP00617_PLANBY_LINE_PREMIX_MEMO") ▸ lambda ▸ if (dt != null) ▸ else of (dt.Rows.Count > 0)] / this.dCalendar_planrange.ValueChanged [if (getTypeName == "System.Windows.Forms.MaskedTextBox")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ lambda ▸ if (dt != null) ▸ else of (dt.Rows.Count > 0)] / this.btnCata…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce2d2b18 | this.Load [try] 외 6 | FP00617_PlanBy_Line_PreMix.cs:2328 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-cdca2867 | this.Load [try] 외 6 | FP00617_PlanBy_Line_PreMix.cs:2329 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.GoDrawCellColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e0639bb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1119 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa310af4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1180 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fdf1f14a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:1181 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14c8a75c | this.Load | FP00617_PlanBy_Line_PreMix.cs:271 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1d8dc89 | this.Load | FP00617_PlanBy_Line_PreMix.cs:274 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanAmendMA) | 데이터 객체 조작/조회 |  |  |  |
| AC-91647a9a | this.Load | FP00617_PlanBy_Line_PreMix.cs:276 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5238801a | this.Load | FP00617_PlanBy_Line_PreMix.cs:277 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-79c7da1e | this.Load | FP00617_PlanBy_Line_PreMix.cs:280 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c17ffea2 | this.Load | FP00617_PlanBy_Line_PreMix.cs:283 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-76c269de | this.Load | FP00617_PlanBy_Line_PreMix.cs:289 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-04cdcba7 | this.Load | FP00617_PlanBy_Line_PreMix.cs:313 | try | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-0676fe81 | this.Load | FP00617_PlanBy_Line_PreMix.cs:319 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f536ee00 | this.Load | FP00617_PlanBy_Line_PreMix.cs:320 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3406cf19 | this.Load | FP00617_PlanBy_Line_PreMix.cs:321 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-eef3dec4 | this.Load | FP00617_PlanBy_Line_PreMix.cs:327 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00617_PlanBy_Line_PreMix.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d1287b9 | this.Load | FP00617_PlanBy_Line_PreMix.cs:241 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a3454fd6 | this.Load | FP00617_PlanBy_Line_PreMix.cs:242 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-3e7d0c34 | this.Load | FP00617_PlanBy_Line_PreMix.cs:243 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-41315c92 | this.Load | FP00617_PlanBy_Line_PreMix.cs:244 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-314eb34c | this.Load | FP00617_PlanBy_Line_PreMix.cs:245 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-9baf954d | this.Load | FP00617_PlanBy_Line_PreMix.cs:246 |  | UI_PROP | mcbo_prod_type.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f0795791 | this.Load | FP00617_PlanBy_Line_PreMix.cs:247 |  | UI_PROP | mcbo_nickname_lt.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix.InitSpread

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d06dd116 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:389 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-18e19c78 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:390 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7321579b | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:392 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3b3f9298 | this.Load 외 6 | FP00617_PlanBy_Line_PreMix.cs:396 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00617_PlanBy_Line_PreMix.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-916ebd45 | InsertButton | FP00617_PlanBy_Line_PreMix.cs:544 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2d1373c0 | InsertButton | FP00617_PlanBy_Line_PreMix.cs:545 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5730b753 | memo_menu.Click | FP00617_PlanBy_Line_PreMix.cs:2054 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ec2691e | memo_menu.Click | FP00617_PlanBy_Line_PreMix.cs:2057 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db0e26a5 | memo_menu.Click | FP00617_PlanBy_Line_PreMix.cs:2061 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00617_PlanBy_Line_PreMix.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d45f39b | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2076 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b401eae | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2079 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc1672b9 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2097 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-824942d4 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2098 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3131319c | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2099 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-810a5e1e | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2100 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1dd1b870 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2101 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-750ef856 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2102 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-e91d75b8 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2103 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f2c9de94 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2104 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a7b7ae1d | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2105 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00617_PlanBy_Line_PreMix.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b1c8fbe | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:1972 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1acc4372 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:1975 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ba4b5aa | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:1999 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4cd0fe8 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2013 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d340342 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2016 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10feda33 | (진입점 미연결) | FP00617_PlanBy_Line_PreMix.cs:2040 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix.OpenLineMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21a6cb3a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1736 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-32a61cc4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1737 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-4d71b588 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1738 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-c7f7414e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1738 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-860692e9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1739 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-c50e508a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1740 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d4273d28 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1741 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a1839c8b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1746 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b7670e8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1749 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix.OpenMaterialMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a2ad8ed | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1755 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-f888552f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1756 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-2da91533 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1757 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-bfde71b6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1757 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-27b0d874 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1758 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-dcb4492a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1759 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-11f1a7eb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1760 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a42daafc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1764 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4c56cd3b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00617_PlanBy_Line_PreMix.cs:1766 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00617_PlanBy_Line_PreMix.Query

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e708c937 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2822 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-b11cde13 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2822 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-263fbd2c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2823 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-bcb5434a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2823 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c4edb772 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2824 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-3865b86a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2824 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4ac1d949 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2827 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1c2c25e5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2834 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-1165639c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2839 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a80f43af | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2840 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac46e525 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2842 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00617_PlanBy_Line_PreMix.RefreshHeadAndBody

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47930161 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2705 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9d10039c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2721 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-418241cc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2725 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00617_PlanBy_Line_PreMix.RefreshSpreadSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb9f62e5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2678 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-bda8d51a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2678 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-2b456396 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2692 | if (dsMain.Good()) | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-12925ec6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2698 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00617_PlanBy_Line_PreMix.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8848e6ff | popSql.OnSql | FP00617_PlanBy_Line_PreMix.cs:2348 | if (programID == "PR_UI_FP00617_PLANBY_LINE_PREMIX_MAIN") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7fa5024e | popSql.OnSql | FP00617_PlanBy_Line_PreMix.cs:2357 | if (programID == "PR_UI_FP00617_PLANBY_LINE_PREMIX_MEMO") | RETURN | return Find_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-277b445d | popSql.OnSql | FP00617_PlanBy_Line_PreMix.cs:2361 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0679e5d6 | SaveButton | FP00617_PlanBy_Line_PreMix.cs:566 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18b4c2a4 | SaveButton | FP00617_PlanBy_Line_PreMix.cs:567 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetCalenderColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3d1edbf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2940 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-135cef56 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2944 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-5237097b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2946 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f1c06869 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2950 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-205aa6ac | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2966 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-c70cf940 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2981 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcd4184b | this.Load | FP00617_PlanBy_Line_PreMix.cs:228 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-588f4885 | this.Load | FP00617_PlanBy_Line_PreMix.cs:230 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-4230e7c0 | this.Load | FP00617_PlanBy_Line_PreMix.cs:234 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetDivision

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7b88e4f | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2147 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-63ee9c73 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2147 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7c03fb0f | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2148 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetFactory

진입점: this.Load [try] / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a471a666 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2180 |  | FLAG | dtFactoryAmend | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE, false, _CurrentUser, _sNonAuth, _sSaveAuth , … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-acaefb7e | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2180 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d6363a86 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2184 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (dtInstance.Good())] / mcbo_division.SelectedIndexChanged / cbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / mcbo_line.SelectedIndexChanged / txtItem.TextChanged / mcbo_prod_type.SelectedIndexChanged / mcbo_nickname_lt.SelectedIndexChanged / dCalendar_planrange.ValueChanged [if (getTypeName == "System.Windows.Forms.MaskedTextBox")] / chk_allLine.CheckedChanged / chk_IncludeSubOp.CheckedChanged / popSql.OnSql [if (programID == "PR_UI_FP00617_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0b5dbdb | this.Load [try] 외 22 | FP00617_PlanBy_Line_PreMix.cs:2122 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetLine

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / chk_allLine.CheckedChanged / this.chkInAct.CheckedChanged / this.chk_allLine.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9fcb464 | this.Load [try] 외 5 | FP00617_PlanBy_Line_PreMix.cs:2208 |  | FLAG | dtLine | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00617_findLineCode_List", Filter… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4da90036 | this.Load [try] 외 5 | FP00617_PlanBy_Line_PreMix.cs:2208 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00617_findLineCode_List", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4955c7e3 | this.Load [try] 외 5 | FP00617_PlanBy_Line_PreMix.cs:2212 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetNickNameLT

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / chk_allLine.CheckedChanged / this.chkInAct.CheckedChanged / this.chk_allLine.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38d40226 | this.Load [try] 외 4 | FP00617_PlanBy_Line_PreMix.cs:2229 |  | FLAG | dtNickNameLT | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00617_find_FPNickName", Filter["… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-c3d03e5d | this.Load [try] 외 4 | FP00617_PlanBy_Line_PreMix.cs:2229 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00617_find_FPNickName", Filter["BUCKET_FROM"], Filter["BUCKET_TO"] , F… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-80f99760 | this.Load [try] 외 4 | FP00617_PlanBy_Line_PreMix.cs:2233 |  | LIST_REBIND | clsCtrl.setListBox | (dtNickNameLT, mcbo_nickname_lt, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetOperation

진입점: this.Load [try] / mcbo_factory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a83c4458 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2192 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-c0385c74 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2192 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a9581b6b | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2194 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45377e74 | this.Load [try] | FP00617_PlanBy_Line_PreMix.cs:2132 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findAmendInstanceList_common", lv_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-6e2b946d | this.Load [try] | FP00617_PlanBy_Line_PreMix.cs:2132 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findAmendInstanceList_common", lv_amendInstance, _sSaveAuth) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f2849bf | this.Load [try] | FP00617_PlanBy_Line_PreMix.cs:2133 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetPlanPeriod

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26b1c653 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2250 |  | FLAG | dtPeriod | Data_FP.Common_FP(Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-70d76884 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2250 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1844264c | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2265 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-e9d9bd3b | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2266 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-a4d6976e | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2270 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-fcc644d2 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2271 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-4503316e | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2277 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-4e05310a | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2278 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetPlant

진입점: this.Load [try] / cbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-513bba26 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2167 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-5ed0c28d | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2167 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e1d70e5f | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2169 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetProdType

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4c0bdff | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2220 |  | FLAG | dtProdType | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_find_FPProdType", Filter["… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ad1744b3 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2220 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_FPProdType", Filter["DIVISION_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cb43ac22 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2222 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prod_type, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetSite

진입점: this.Load [try] / mcbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caff0f33 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2156 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-b302b6e5 | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2156 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e9d7d11d | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2157 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-093db4af | this.Load [try] 외 1 | FP00617_PlanBy_Line_PreMix.cs:2160 | if (dtSite.Rows.Count == 1) | VALUE_SET | cbo_site.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (mont…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f6353f5 | this.Load [try] 외 6 | FP00617_PlanBy_Line_PreMix.cs:404 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12f5cf53 | this.Load [try] 외 6 | FP00617_PlanBy_Line_PreMix.cs:405 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SetTotalColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-506f1561 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00617_PlanBy_Line_PreMix.cs:2918 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00617_PlanBy_Line_PreMix.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2afe281 | this.spdMain.CellClick | FP00617_PlanBy_Line_PreMix.cs:1930 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b27c5dc6 | this.spdMain.CellClick | FP00617_PlanBy_Line_PreMix.cs:1949 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-bc108967 | this.spdMain.CellClick | FP00617_PlanBy_Line_PreMix.cs:1950 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-4eba0022 | this.spdMain.CellClick | FP00617_PlanBy_Line_PreMix.cs:1952 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e9879c9 | this.spdMain.CellClick | FP00617_PlanBy_Line_PreMix.cs:1960 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00617_PlanBy_Line_PreMix.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fb7efec | this.spdMain.CellDoubleClick | FP00617_PlanBy_Line_PreMix.cs:1911 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-5fbf7e4b | this.spdMain.CellDoubleClick | FP00617_PlanBy_Line_PreMix.cs:1918 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00617_PlanBy_Line_PreMix.SwitchMemo

진입점: memo_menu.Click [try ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bafa39fa | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00617_PlanBy_Line_PreMix.cs:1776 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-151eec51 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00617_PlanBy_Line_PreMix.cs:1793 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-71c294be | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00617_PlanBy_Line_PreMix.cs:1824 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-7e0d52d5 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00617_PlanBy_Line_PreMix.cs:1825 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-a2f3508c | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00617_PlanBy_Line_PreMix.cs:1827 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-05d9a57b | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00617_PlanBy_Line_PreMix.cs:1858 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-a3d7e337 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00617_PlanBy_Line_PreMix.cs:1859 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-32f9be19 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00617_PlanBy_Line_PreMix.cs:1861 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00617_PlanBy_Line_PreMix.UIFindData

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64ca7532 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:425 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-34ae7619 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:426 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a705ea66 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:429 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5eefeaa5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:432 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-153ea32b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:445 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-775592d8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:446 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7bd6da1c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:449 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-71b91d3a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:452 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a0f72758 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:453 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-02981923 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:461 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | Find_Data_Amend("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-3ccbbd78 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:470 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6b171bc | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:472 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d847db0f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:473 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ba995b5b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:481 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-887a8869 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:483 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-dcde0eaf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:485 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-aed985c6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:491 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-1138160f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:493 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-43bad8bd | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:497 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-67e58e50 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:501 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5f4a178d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:502 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-805d88f8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:510 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d8dc2984 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:514 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-624deaa5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:519 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e155b515 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:520 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-248ab460 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:527 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-211fdcfb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:532 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-b2116419 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00617_PlanBy_Line_PreMix.cs:536 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

