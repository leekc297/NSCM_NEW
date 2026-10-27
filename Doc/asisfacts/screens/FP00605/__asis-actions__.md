# AS-IS 액션 대조표 — FP00605

> 원천: `Doc/asisfacts/screens/FP00605/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 575행 · 메서드 73 · 종류 DATA_OP 174 · UI_PROP 87 · FLAG 58 · RETURN 47 · VALUE_SET 33 · UI_MISC 28 · POPUP 27 · CALL_EXT 23 · COMBO_DATA 21 · MESSAGE 18 · GRID_INIT 13 · THROW 9 · GRID_SET 9 · LIST_REBIND 7 · ENDPOINT 6 · STATE 4 · GRID_STYLE 4 · CALL_BASE 3 · GRID_LOCK 2 · STATE_RESET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 26


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6346fa44 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2423 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3c846a7 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2429 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c7c0781d | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2437 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-45821802 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2438 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-5daab5fa | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2439 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-33f58cc6 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2440 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-a9663629 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2442 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8a99fba | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2443 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-29206ab9 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2444 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-4d1d42d1 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2445 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-14b4838e | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2446 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-868c7577 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2447 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-46b2d462 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2448 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d2335e4 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2449 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-1b7a434d | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2452 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-d9b18bec | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2637 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-50b9c125 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2638 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-bf44d0b0 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2639 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-bbff31cf | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2640 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-6ccb9713 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2642 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-7545fad7 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2643 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-1a882eeb | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2644 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-6bab54d0 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2645 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-648bd934 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2646 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6ec9422 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2647 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-b3e73397 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2648 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-38675115 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2649 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-5884a4de | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2651 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaff2d59 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2556 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3c1b7fe | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2557 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9bd3727 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2558 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d37794a6 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2559 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-44e6135d | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2560 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e688930 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2563 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bbf0515 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2567 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-da93eb02 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2568 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-762bd255 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2554 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-6b60d5bf | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2584 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f251795 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2587 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-165ae560 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2590 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-42e9ce50 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2593 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-40e25faf | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2596 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-1818209b | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2599 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-eedc24c3 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2605 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-2d6f8e40 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2607 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c076213a | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2528 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-568e3f87 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2492 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8b2e2fe | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2493 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4f099d6 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2494 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0304822a | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2495 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-da4dcc24 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2496 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b6b2dc1 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2497 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ed71756 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2499 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3cde5b9e | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2500 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-534a63de | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2503 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-46b8522b | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2504 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e59c3bd2 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2505 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-00cf8773 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2490 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-28e2201d | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2513 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd561457 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2514 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca66910d | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2519 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94be8487 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2465 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00605_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c02e471c | .ctor | FP00605_MeasureSetForm_Popup.cs:79 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-c525a014 | .ctor | FP00605_MeasureSetForm_Popup.cs:80 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-114e2626 | .ctor | FP00605_MeasureSetForm_Popup.cs:81 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-a09dd228 | .ctor | FP00605_MeasureSetForm_Popup.cs:83 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00605_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3fd1257 | this.btnOK.Click | FP00605_MeasureSetForm_Popup.cs:347 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-1819f3b7 | this.btnOK.Click | FP00605_MeasureSetForm_Popup.cs:348 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-669efc4a | this.btnOK.Click | FP00605_MeasureSetForm_Popup.cs:355 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-6e060f90 | this.btnOK.Click | FP00605_MeasureSetForm_Popup.cs:356 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00605_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd1d6821 | this.btnSet.Click | FP00605_MeasureSetForm_Popup.cs:317 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-4bef08e5 | this.btnSet.Click | FP00605_MeasureSetForm_Popup.cs:318 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-d5c52da0 | this.btnSet.Click | FP00605_MeasureSetForm_Popup.cs:320 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7d7a50df | this.btnSet.Click | FP00605_MeasureSetForm_Popup.cs:321 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ddf21ec | this.btnSet.Click | FP00605_MeasureSetForm_Popup.cs:323 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-4dc35561 | this.btnSet.Click | FP00605_MeasureSetForm_Popup.cs:325 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-9b8e81ed | this.btnSet.Click | FP00605_MeasureSetForm_Popup.cs:326 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00605_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caa3c5e3 | Dispose | FP00605_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00605_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-839e12e9 | this.Load | FP00605_MeasureSetForm_Popup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00605_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1501eb14 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:215 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9d7abbf | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:216 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-726f2430 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:217 |  | DATA_OP | ctrls.Add | (chk_offtime) | 데이터 객체 조작/조회 |  |  |  |
| AC-c399d517 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:219 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-a240167f | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:220 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-24dd3d0b | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:221 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-346ff96e | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:223 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-d28302cb | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:224 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d04b9c6 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:225 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-929d04a1 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:227 |  | DATA_OP | ctrls.Add | (chk_gap) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8201721 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:228 |  | DATA_OP | ctrls.Add | (chk_gapWPP) | 데이터 객체 조작/조회 |  |  |  |
| AC-1728bd38 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:229 |  | DATA_OP | ctrls.Add | (chk_resultExp) | 데이터 객체 조작/조회 |  |  |  |
| AC-81d6d887 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-24b35ae1 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:233 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-3829e86c | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_result_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3b08cce | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0b206ef | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:237 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9aaf94b | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:238 |  | DATA_OP | ctrls.Add | (chk_resultExp_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-04f2c0e2 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-d99738d4 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-07c72884 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:242 |  | DATA_OP | ctrls.Add | (chk_gap_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b084137 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-49af92c2 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:245 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-70e4722b | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:246 |  | DATA_OP | ctrls.Add | (chk_gapWPP_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-92995914 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:250 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-c96426b3 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:250 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-2c66a155 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:257 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-bd9201fb | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:261 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |

## FP00605_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d0fdb12 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3458fc91 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4d5a4108 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_offtime.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a7092552 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-39ec05f9 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1f48b69c | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9ab6133c | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1d48d991 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-74c3b6d1 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f0886a94 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_gap.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9666180e | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_gapWPP.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-390a19c7 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_resultExp.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-70ee59f4 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-32d9222a | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f030d3f0 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_result_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-17217862 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1b8a7faf | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-42c44ecd | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_resultExp_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f3586f43 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8a3f5c08 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f8661e00 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_gap_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f3e91f8d | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-20c942d4 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:167 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8075e3c5 | this.Load 외 1 | FP00605_MeasureSetForm_Popup.cs:168 |  | VALUE_SET | chk_gapWPP_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00605_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6350e2c1 | (진입점 미연결) | FP00605_MeasureSetForm_Popup.cs:410 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-b9870871 | (진입점 미연결) | FP00605_MeasureSetForm_Popup.cs:421 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90a46511 | (진입점 미연결) | FP00605_MeasureSetForm_Popup.cs:432 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00605_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e762ec54 | this.Load | FP00605_MeasureSetForm_Popup.cs:94 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-574eb2c1 | this.Load | FP00605_MeasureSetForm_Popup.cs:102 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00605_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e735194 | this.btnSet.Click 외 1 | FP00605_MeasureSetForm_Popup.cs:362 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e141a7e0 | this.btnSet.Click 외 1 | FP00605_MeasureSetForm_Popup.cs:370 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-08d1a928 | this.btnSet.Click 외 1 | FP00605_MeasureSetForm_Popup.cs:370 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-f88e2bbf | this.btnSet.Click 외 1 | FP00605_MeasureSetForm_Popup.cs:387 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7bf09781 | this.btnSet.Click 외 1 | FP00605_MeasureSetForm_Popup.cs:398 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00605_PlanBy_Model_Formation..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cedd2d41 | .ctor | FP00605_PlanBy_Model_Formation.cs:191 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00605_PlanBy_Model_Formation.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76ca2779 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:826 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b10aab14 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:827 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fb6d2630 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:828 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4b7e8094 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:829 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-bf087a08 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:830 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9c949737 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:831 |  | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-808098e5 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:833 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26838d1c | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:834 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-2fd28530 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:836 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0c55a276 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:837 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b3bb8d16 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:839 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b24d029d | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:840 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8501a240 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:842 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-796ad4cf | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:843 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1ee48669 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:845 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", measureId) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3b6a55a | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:846 |  | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-aee814f5 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:868 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-4f285caa | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:877 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-07912755 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:878 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-791f2fb7 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:879 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-1a33abe3 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:880 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-19eb847b | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:881 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00605_PlanBy_Model_Formation.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d22cf80 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:887 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; DataTable dtWeekMonth = null; string… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5abcec51 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:901 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-21e5cb63 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:902 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-ed869906 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:909 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_day2WeekAndMonth", Filter["BUCKET_FROM"], Filter["BUCKET_TO… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-307099b2 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:972 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_currDateCol", Filter["INSTANCE_ID"], Filter["BUCKET_FROM"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00605_PlanBy_Model_Formation.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23491f53 | this.btnBucket.Click | FP00605_PlanBy_Model_Formation.cs:1667 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-8f0972cf | this.btnBucket.Click | FP00605_PlanBy_Model_Formation.cs:1670 |  | POPUP | new FP00599_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-af2f454e | this.btnBucket.Click | FP00605_PlanBy_Model_Formation.cs:1671 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0be8f159 | this.btnBucket.Click | FP00605_PlanBy_Model_Formation.cs:1672 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-6371190f | this.btnBucket.Click | FP00605_PlanBy_Model_Formation.cs:1673 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-56e41f04 | this.btnBucket.Click | FP00605_PlanBy_Model_Formation.cs:1677 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-ae7621b7 | this.btnBucket.Click | FP00605_PlanBy_Model_Formation.cs:1689 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-73221ade | this.btnBucket.Click | FP00605_PlanBy_Model_Formation.cs:1698 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00605_PlanBy_Model_Formation.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-494d6df9 | this.btnCatagory.Click | FP00605_PlanBy_Model_Formation.cs:1616 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-b9ceaf4e | this.btnCatagory.Click | FP00605_PlanBy_Model_Formation.cs:1619 |  | POPUP | new FP00605_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-845bc70d | this.btnCatagory.Click | FP00605_PlanBy_Model_Formation.cs:1620 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-77b55475 | this.btnCatagory.Click | FP00605_PlanBy_Model_Formation.cs:1621 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1ada658c | this.btnCatagory.Click | FP00605_PlanBy_Model_Formation.cs:1622 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2f9d856e | this.btnCatagory.Click | FP00605_PlanBy_Model_Formation.cs:1626 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-de5e1cec | this.btnCatagory.Click | FP00605_PlanBy_Model_Formation.cs:1638 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a8ebf631 | this.btnCatagory.Click | FP00605_PlanBy_Model_Formation.cs:1647 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1e0f76b1 | this.btnCatagory.Click | FP00605_PlanBy_Model_Formation.cs:1652 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-ea2b3e74 | this.btnCatagory.Click | FP00605_PlanBy_Model_Formation.cs:1658 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00605_PlanBy_Model_Formation.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54ed28ad | this.btnColumn.Click | FP00605_PlanBy_Model_Formation.cs:1589 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-169bac43 | this.btnColumn.Click | FP00605_PlanBy_Model_Formation.cs:1592 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-f3b2e157 | this.btnColumn.Click | FP00605_PlanBy_Model_Formation.cs:1593 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-eb0cbf93 | this.btnColumn.Click | FP00605_PlanBy_Model_Formation.cs:1594 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-091e1453 | this.btnColumn.Click | FP00605_PlanBy_Model_Formation.cs:1600 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-d2c41210 | this.btnColumn.Click | FP00605_PlanBy_Model_Formation.cs:1600 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-313c65c1 | this.btnColumn.Click | FP00605_PlanBy_Model_Formation.cs:1601 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-7fc8999d | this.btnColumn.Click | FP00605_PlanBy_Model_Formation.cs:1607 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00605_PlanBy_Model_Formation.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efc22508 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1733 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-7dde5da6 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1734 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98bd7832 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1737 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-67a22a85 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1738 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-c3a75f60 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1739 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-5bf561aa | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1740 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b49f00bb | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1741 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-1c8b8f1d | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1742 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-811ced75 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1743 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9684ed31 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1743 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c1e93019 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1744 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b53b255a | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1745 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b58ae072 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1746 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-607a83a9 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1747 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e8d61125 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1748 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-caf35cfe | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1749 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-20a42431 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1750 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-22f25b73 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1751 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5943f43e | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1752 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a24a202e | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1754 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-37088748 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1755 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-5faae635 | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1756 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-9c20d2bc | this.btnMemo.Click | FP00605_PlanBy_Model_Formation.cs:1757 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00605_PlanBy_Model_Formation.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e807f46 | this.btnPlanInfo.Click | FP00605_PlanBy_Model_Formation.cs:1707 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-0a4576e5 | this.btnPlanInfo.Click | FP00605_PlanBy_Model_Formation.cs:1708 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a927e58 | this.btnPlanInfo.Click | FP00605_PlanBy_Model_Formation.cs:1714 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-048fa45d | this.btnPlanInfo.Click | FP00605_PlanBy_Model_Formation.cs:1717 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d02ec054 | this.btnPlanInfo.Click | FP00605_PlanBy_Model_Formation.cs:1718 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-851cc775 | this.btnPlanInfo.Click | FP00605_PlanBy_Model_Formation.cs:1718 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8479a504 | this.btnPlanInfo.Click | FP00605_PlanBy_Model_Formation.cs:1719 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-357e0e2f | this.btnPlanInfo.Click | FP00605_PlanBy_Model_Formation.cs:1720 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bb3ded1b | this.btnPlanInfo.Click | FP00605_PlanBy_Model_Formation.cs:1722 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b8ac89e0 | this.btnPlanInfo.Click | FP00605_PlanBy_Model_Formation.cs:1723 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00605_PlanBy_Model_Formation.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef11a189 | this.btnSql.Click | FP00605_PlanBy_Model_Formation.cs:1768 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-5e140b45 | this.btnSql.Click | FP00605_PlanBy_Model_Formation.cs:1771 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1e1503a4 | this.btnSql.Click | FP00605_PlanBy_Model_Formation.cs:1772 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ed17251a | this.btnSql.Click | FP00605_PlanBy_Model_Formation.cs:1774 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00605_FIND_FP00605") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c362345 | this.btnSql.Click | FP00605_PlanBy_Model_Formation.cs:1777 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00605_PlanBy_Model_Formation.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49040f2d | this.Load | FP00605_PlanBy_Model_Formation.cs:1278 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d34e115 | this.Load | FP00605_PlanBy_Model_Formation.cs:1278 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-ed1dc230 | this.Load | FP00605_PlanBy_Model_Formation.cs:1279 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00605_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ffc1d725 | this.Load | FP00605_PlanBy_Model_Formation.cs:1279 |  | POPUP | new FP00605_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-22c08a58 | this.Load | FP00605_PlanBy_Model_Formation.cs:1280 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b3f8c6b | this.Load | FP00605_PlanBy_Model_Formation.cs:1280 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP00605_PlanBy_Model_Formation.CreateFilterDataSet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f5f3936 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1015 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a1afb521 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1027 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-f8e9bd69 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1028 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-3fdab397 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1049 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-05313f35 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1050 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc615cdc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1054 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-accddc1c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1055 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-58ed0282 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1059 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-05f1c5d7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1065 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-90baf68e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1066 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae8d326a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1070 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4179041b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1071 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-66cf851c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1075 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4bef81d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1081 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9dfb619f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1082 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-29715ecc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1086 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-eafa1611 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1087 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2e8a541 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1091 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-261c9b9a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1092 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6cf8adab | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1096 | if (measure["chk_resultExp"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5867e4c6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1101 | if (measure["chk_gap"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ed69fdb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1106 | if (measure["chk_gapWPP"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4aef731 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1115 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-128870a7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1116 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b5d8a82 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1120 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8b66631 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1121 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8d1d85c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1126 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f89ac0c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1127 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8a0819e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1131 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-88c52081 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1132 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca08f384 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1137 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dbfca2a1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1138 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b7506c3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1142 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-398e5772 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1143 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b342e05 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1147 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb823551 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1148 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-15532e62 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1152 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-18d260f2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1157 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6426a13 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1162 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb53f489 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1172 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fc99c49 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1173 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-96a1ec06 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1177 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e4d3989 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1178 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fd120de | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1184 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-072d7974 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1185 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae9a8ce1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1189 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-52fed793 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1190 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f799270f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1196 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3de0f3e5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1197 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-42f71dde | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1201 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-439c0dca | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1202 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-87066eba | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1206 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-74e03036 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1207 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bc7b319 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1211 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-47054059 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1216 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-882cc61c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1221 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3901b9c0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1249 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57e07969 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1252 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2928e069 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1256 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad18fecb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1261 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-069f51ab | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1265 | else of (m != null && m.Count() > 0) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e76f24c0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1265 | else of (m != null && m.Count() > 0) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-0cac8923 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1270 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-d38dd581 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1272 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-434e3574 | this.Load | FP00605_PlanBy_Model_Formation.cs:461 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e875b672 | this.Load | FP00605_PlanBy_Model_Formation.cs:462 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-3c84ba83 | this.Load | FP00605_PlanBy_Model_Formation.cs:463 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00605_PlanBy_Model_Formation.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b25c9786 | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1465 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ce205c4 | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1467 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b423b58 | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1470 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Block_End_Date", sInstance, sPlanDate, UserInfoContext.Current.User… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8a360456 | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1487 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-45a3cabb | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1488 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |
| AC-420f2472 | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1512 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-4952d1e1 | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1513 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-de1fe055 | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1522 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(block date " + dtBlock_enddate.Rows[… | 메시지 표시 |  |  |  |
| AC-36eb7fcb | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1526 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | UI_PROP | dCalendar_planrange.Value2 | dEndDate | 속성 Value2 설정 |  |  |  |
| AC-c8cbb3ce | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1532 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | MESSAGE | MessageBox.Show | ("The End date can not be later than the block date(undefined).") | 메시지 표시 |  |  |  |
| AC-53c44ddd | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1533 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-3da6d66c | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1544 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ if (dayCount > 365) | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-765cb028 | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1545 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ if (dayCount > 365) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-678e8e93 | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1554 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ if (dtBlock_enddate … | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(block date " + dtBlock_enddate.Rows[… | 메시지 표시 |  |  |  |
| AC-580c466b | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1558 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ if (dtBlock_enddate … | UI_PROP | dCalendar_planrange.Value2 | dEndDate | 속성 Value2 설정 |  |  |  |
| AC-8ffa8e5d | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1564 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ else of (dtBlock_end… | MESSAGE | MessageBox.Show | ("The End date can not be later than the block date(undefined).") | 메시지 표시 |  |  |  |
| AC-91d6a647 | dCalendar_planrange.ValueChanged | FP00605_PlanBy_Model_Formation.cs:1565 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ else of (dtBlock_end… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |

## FP00605_PlanBy_Model_Formation.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dee54533 | DeleteButton | FP00605_PlanBy_Model_Formation.cs:660 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c02c1ed | DeleteButton | FP00605_PlanBy_Model_Formation.cs:661 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a50ce5e9 | Dispose | FP00605_PlanBy_Model_Formation.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00605_PlanBy_Model_Formation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f26e0470 | EditButton | FP00605_PlanBy_Model_Formation.cs:667 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b1f8ad8 | EditButton | FP00605_PlanBy_Model_Formation.cs:668 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52dd411c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00605_PlanBy_Model_Formation.cs:713 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1bd8c1b9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00605_PlanBy_Model_Formation.cs:717 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bf51b88 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00605_PlanBy_Model_Formation.cs:721 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d6080ecc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00605_PlanBy_Model_Formation.cs:725 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00605_PlanBy_Model_Formation.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-779a981a | ExcelButton | FP00605_PlanBy_Model_Formation.cs:684 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-ee9d6026 | ExcelButton | FP00605_PlanBy_Model_Formation.cs:685 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-61dd0fd2 | ExcelButton | FP00605_PlanBy_Model_Formation.cs:687 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-84df62d6 | ExcelButton | FP00605_PlanBy_Model_Formation.cs:691 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-37925918 | ExcelButton | FP00605_PlanBy_Model_Formation.cs:692 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-e1ceafe0 | ExcelButton | FP00605_PlanBy_Model_Formation.cs:693 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-23d4b8ae | ExcelButton | FP00605_PlanBy_Model_Formation.cs:696 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-fdbdf6ac | ExcelButton | FP00605_PlanBy_Model_Formation.cs:697 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-3b2541cf | ExcelButton | FP00605_PlanBy_Model_Formation.cs:698 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-0d3ec5b0 | ExcelButton | FP00605_PlanBy_Model_Formation.cs:700 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-da65afb2 | ExcelButton | FP00605_PlanBy_Model_Formation.cs:701 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00605_PlanBy_Model_Formation.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac68d2a8 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:814 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00605_FIND_FP00605", Filter, _CurrentUser, pSysType, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1ed9be7c | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:816 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-369a84a1 | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:820 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.Find_Data_Memo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d764b64 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:1292 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00619_PLANBY_LINE_FORMATION", Filter, _CurrentUser, pSysType, "SELECT_MEA_MEMO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3ab142a3 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:1294 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-8fed4a36 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:1298 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.FindTotalColorStart

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2441ede6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:1009 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8f928f2 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:741 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0b0022b | this.Load | FP00605_PlanBy_Model_Formation.cs:207 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00605_PlanBy_Model_Formation.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605") ▸ try ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ada387bb | popSql.OnSql [if (programID == "PR_UI_FP00605_FIND_FP00605")… 외 3 | FP00605_PlanBy_Model_Formation.cs:2175 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.GetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71652088 | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2183 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c7f13b88 | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2184 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-334fcd73 | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2184 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e9b8cf5e | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2186 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-0dbcbef1 | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2188 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0e548e46 | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2191 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-5821e26c | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2192 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-18130285 | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2192 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c5d8ddcd | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2193 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0276ec4d | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2194 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e0ec2a15 | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2195 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a67c51f7 | this.Load [try] | FP00605_PlanBy_Model_Formation.cs:2199 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00605_PlanBy_Model_Formation.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51556c20 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2373 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-ae7cf692 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2374 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.GetToDay

진입점: this.Load [try] / dCalendar_planrange.ValueChanged [if (getTypeName == "System.Windows.Forms.MaskedTextBox")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f46d8068 | this.Load [try] 외 1 | FP00605_PlanBy_Model_Formation.cs:2322 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-6901b589 | this.Load [try] 외 1 | FP00605_PlanBy_Model_Formation.cs:2323 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c6adb54 | this.Load | FP00605_PlanBy_Model_Formation.cs:274 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f4085951 | this.Load | FP00605_PlanBy_Model_Formation.cs:277 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanAmendMA) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c7e1432 | this.Load | FP00605_PlanBy_Model_Formation.cs:279 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9f0e6baf | this.Load | FP00605_PlanBy_Model_Formation.cs:280 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6a2a9921 | this.Load | FP00605_PlanBy_Model_Formation.cs:283 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c88561c1 | this.Load | FP00605_PlanBy_Model_Formation.cs:286 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2586e867 | this.Load | FP00605_PlanBy_Model_Formation.cs:318 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-2501806c | this.Load | FP00605_PlanBy_Model_Formation.cs:319 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d478401f | this.Load | FP00605_PlanBy_Model_Formation.cs:320 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a43c12f8 | this.Load | FP00605_PlanBy_Model_Formation.cs:326 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00605_PlanBy_Model_Formation.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e61f865 | this.Load | FP00605_PlanBy_Model_Formation.cs:242 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f0b6f716 | this.Load | FP00605_PlanBy_Model_Formation.cs:243 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-9b726783 | this.Load | FP00605_PlanBy_Model_Formation.cs:244 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a81d86ab | this.Load | FP00605_PlanBy_Model_Formation.cs:245 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-b854400c | this.Load | FP00605_PlanBy_Model_Formation.cs:246 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00605_PlanBy_Model_Formation.InitSpread

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c53cba40 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:476 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81adb061 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:477 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-097049af | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:479 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3aea67df | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:483 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00605_PlanBy_Model_Formation.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9462b7b | InsertButton | FP00605_PlanBy_Model_Formation.cs:652 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3153b908 | InsertButton | FP00605_PlanBy_Model_Formation.cs:653 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.MakeMemoFontBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbdebfa5 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:3026 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-a486a558 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:3030 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |
| AC-dbe2e3e7 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:3041 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-19f07d35 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:3045 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP00605_PlanBy_Model_Formation.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e451af70 | memo_menu.Click | FP00605_PlanBy_Model_Formation.cs:2102 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c82f387c | memo_menu.Click | FP00605_PlanBy_Model_Formation.cs:2105 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba8c3303 | memo_menu.Click | FP00605_PlanBy_Model_Formation.cs:2109 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00605_PlanBy_Model_Formation.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-811e387b | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2124 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cfb1a21a | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2127 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-292448b2 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2145 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-84b3ed9f | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2146 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-93ea26e7 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2147 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ef965103 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2148 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d956cb3e | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2149 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-38a9a4ed | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2150 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-a20198cb | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2151 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1df62f96 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2152 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3e8d6b78 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2153 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00605_PlanBy_Model_Formation.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c9827bb | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2020 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ea7b909 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2023 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bcf7d8b8 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2047 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00605_PlanBy_Model_Formation.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac18e124 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2061 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37e3d4fb | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2064 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8f4d371 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:2088 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00605_PlanBy_Model_Formation.OpenLineMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c0c950f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1786 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-e3274d82 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1787 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-4bf27a5b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1788 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-031535c7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1788 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2621e8e6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1789 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-84e735f4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1790 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b877e747 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1791 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f9b463c5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1796 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e048f49 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1799 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00605_PlanBy_Model_Formation.OpenMaterialMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0ec56b0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1805 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-5dfd4d74 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1806 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-946c937f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1807 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-77108d96 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1807 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cf34125a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1808 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-c51d1025 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1809 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6feb5dff | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1810 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8292d7ba | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1814 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ca8a4c72 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00605_PlanBy_Model_Formation.cs:1816 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00605_PlanBy_Model_Formation.Query

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4dd5ccf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2812 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-86f1396a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2812 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a5cedd2a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2813 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-33e82156 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2813 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0c7ccc4c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2814 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-c5dfae79 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2814 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fb3e7a2a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2817 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c5099ca6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2824 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-d316d685 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2829 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a92a2c82 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2830 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db6099f8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2832 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00605_PlanBy_Model_Formation.RefreshHeadAndBody

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d921ecb4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2693 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f42d54b7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2709 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d4da3808 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2713 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00605_PlanBy_Model_Formation.RefreshHeader

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3006ffc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2838 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b0344518 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2840 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f02534cb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2861 |  | CALL_EXT | MemoService.ShowMemo | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-67a9aa13 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2862 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00605_PlanBy_Model_Formation.RefreshHeaderOnly

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20881b40 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2727 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-03f68716 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2731 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-8d4a839d | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2732 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7dc40d25 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2733 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-735db973 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2734 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0124b41e | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2735 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-ba028286 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2739 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-574371bc | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2740 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-34d91ce0 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2741 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-b29df345 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2742 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-95f2042a | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2748 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-e727d7e4 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2749 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a23deff6 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2782 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd7430f7 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2787 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | DayColumnCount | siMain.SetAmendHeaderColumn_FP(calendar, use_month, use_week, use_day, 2, FPExtensions.Dat… | 화면 필드/플래그 변경 |  |  |  |
| AC-c7d7d0d1 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2787 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, FPExtensions.DateColumnType.TYPEZERO, FPExtens… | ⚠ 의미 확인 필요 |  |  |  |
| AC-249ad7e2 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2790 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41b383d2 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2791 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff2a5ece | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2792 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-bcc26c39 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2794 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-898ec9f2 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2796 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-c8d172b7 | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2797 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ba70fee | this.Load 외 6 | FP00605_PlanBy_Model_Formation.cs:2802 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP00605_PlanBy_Model_Formation.RefreshSpreadSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8991d9fe | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2669 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-9fd186c8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2669 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-2a773527 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2681 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a4a4aa0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2686 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00605_PlanBy_Model_Formation.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7355a7c7 | popSql.OnSql | FP00605_PlanBy_Model_Formation.cs:2342 | if (programID == "PR_UI_FP00605_FIND_FP00605") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7868f876 | popSql.OnSql | FP00605_PlanBy_Model_Formation.cs:2355 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dce0ed34 | SaveButton | FP00605_PlanBy_Model_Formation.cs:674 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b5c2ab8b | SaveButton | FP00605_PlanBy_Model_Formation.cs:675 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00605_PlanBy_Model_Formation.SetCalenderColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5646c1b1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2930 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a92b488d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2934 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-6b848a65 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2936 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f50a0da9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2940 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-f52bbb31 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2956 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-9e2e2b1f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2971 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00605_PlanBy_Model_Formation.SetChangeControl

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / cbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / chk_allLine.CheckedChanged / chk_IncludeSubOp.CheckedChanged / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.chk_IncludeSubOp.CheckedChanged / this.chkInAct.CheckedChanged / this.chk_allLine.CheckedChanged / this.spdMain.CellDoubleClick […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faf3ca2d | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:377 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f225486f | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:377 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a258990c | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:386 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-64265049 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:387 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c70e1b42 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:387 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7a36f937 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:388 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-23b77248 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:394 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-37ef386a | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:395 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-3e26715d | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:395 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f3c9cd91 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:396 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-966713b7 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:402 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-cc740f09 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:403 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea0eb46c | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:403 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-59bf2bf0 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:404 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-eb72aa6e | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:410 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-05bf6f9b | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:411 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-da9b0d8b | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:411 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-aebab649 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:412 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-89fd6b5c | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:419 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-fa6c4984 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:420 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-444ccf79 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:420 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1e0bf045 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:421 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-179a6968 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:427 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-fff6411a | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:428 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-84700669 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:428 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-21157a24 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:429 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3f13d5b8 | this.Load [try] 외 14 | FP00605_PlanBy_Model_Formation.cs:435 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00605_PlanBy_Model_Formation.SetColumnChangeByMemo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf95994a | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:1309 |  | FLAG | GnlcellType | new GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-febe7d28 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:1310 |  | UI_PROP | GnlcellType.FormatString | "###,###.#" | 속성 FormatString 설정 |  |  |  |
| AC-d2e4bfac | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:1318 | try ▸ if (iColStartIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e6f9bd5 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:1337 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") | GRID_SET | siMain.ActiveSheet.Cells[k, froz, k, last_col - 1].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-43b07e11 | (진입점 미연결) | FP00605_PlanBy_Model_Formation.cs:1361 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00605_PlanBy_Model_Formation.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48e2d5d6 | this.Load | FP00605_PlanBy_Model_Formation.cs:227 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e39f3ddb | this.Load | FP00605_PlanBy_Model_Formation.cs:229 | if (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0b158916 | this.Load | FP00605_PlanBy_Model_Formation.cs:230 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-99b983d1 | this.Load | FP00605_PlanBy_Model_Formation.cs:234 | else of (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-511d3e5d | this.Load | FP00605_PlanBy_Model_Formation.cs:235 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00605_PlanBy_Model_Formation.SetDirty

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b489ce16 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:2313 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00605_PlanBy_Model_Formation.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_factory.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c9edaf4 | this.Load [try] 외 23 | FP00605_PlanBy_Model_Formation.cs:2170 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00605_PlanBy_Model_Formation.SetPlanPeriod

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca2a0aaf | this.Load [try] 외 1 | FP00605_PlanBy_Model_Formation.cs:2235 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9a2ef951 | this.Load [try] 외 1 | FP00605_PlanBy_Model_Formation.cs:2250 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-29d47115 | this.Load [try] 외 1 | FP00605_PlanBy_Model_Formation.cs:2251 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-a583e866 | this.Load [try] 외 1 | FP00605_PlanBy_Model_Formation.cs:2255 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-b1a06610 | this.Load [try] 외 1 | FP00605_PlanBy_Model_Formation.cs:2256 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-eb22ba57 | this.Load [try] 외 1 | FP00605_PlanBy_Model_Formation.cs:2262 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-7866f0b9 | this.Load [try] 외 1 | FP00605_PlanBy_Model_Formation.cs:2263 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00605_PlanBy_Model_Formation.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (mont…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-263ea7ce | this.Load [try] 외 6 | FP00605_PlanBy_Model_Formation.cs:491 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61fb98a9 | this.Load [try] 외 6 | FP00605_PlanBy_Model_Formation.cs:492 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00605_PlanBy_Model_Formation.SetTotalColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a672eab | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00605_PlanBy_Model_Formation.cs:2908 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00605_PlanBy_Model_Formation.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11f37c40 | this.spdMain.CellClick | FP00605_PlanBy_Model_Formation.cs:1997 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-d647452f | this.spdMain.CellClick | FP00605_PlanBy_Model_Formation.cs:1998 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-59611711 | this.spdMain.CellClick | FP00605_PlanBy_Model_Formation.cs:2000 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-87a5f891 | this.spdMain.CellClick | FP00605_PlanBy_Model_Formation.cs:2008 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00605_PlanBy_Model_Formation.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dbdb195 | this.spdMain.CellDoubleClick | FP00605_PlanBy_Model_Formation.cs:1961 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-18109dd0 | this.spdMain.CellDoubleClick | FP00605_PlanBy_Model_Formation.cs:1968 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00605_PlanBy_Model_Formation.SwitchMemo

진입점: memo_menu.Click [try ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67524028 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00605_PlanBy_Model_Formation.cs:1826 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f833814 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00605_PlanBy_Model_Formation.cs:1843 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-d1acb008 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00605_PlanBy_Model_Formation.cs:1874 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-99dfce43 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00605_PlanBy_Model_Formation.cs:1875 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-84aa1086 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00605_PlanBy_Model_Formation.cs:1877 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ac2fb131 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00605_PlanBy_Model_Formation.cs:1908 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-c21f7e7e | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00605_PlanBy_Model_Formation.cs:1909 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-1d4941d6 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00605_PlanBy_Model_Formation.cs:1911 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00605_PlanBy_Model_Formation.UIFindData

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ceb35604 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:520 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fbc1c391 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:521 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c7677d2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:524 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ccc24ba6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:528 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ba4c86d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:542 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eba12739 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:543 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d43701b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:546 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5ecf6b14 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:550 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c840be80 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:551 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7b6f9d17 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:562 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1b94404a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:564 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f363230 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:564 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8410f453 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:576 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-da48806f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:587 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4d6ecbd8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:589 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ee43c898 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:591 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-89136459 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:597 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-74d3721b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:599 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-aeb1635d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:602 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-186857f8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:615 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c24b2dbb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:620 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3e766df | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:625 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-446f75fc | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:626 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-174c7cc4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:633 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-09b00786 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:640 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-42e9224e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00605_PlanBy_Model_Formation.cs:644 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

