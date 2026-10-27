# AS-IS 액션 대조표 — FP00618

> 원천: `Doc/asisfacts/screens/FP00618/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 576행 · 메서드 82 · 종류 DATA_OP 171 · UI_PROP 77 · FLAG 59 · RETURN 48 · VALUE_SET 34 · UI_MISC 32 · COMBO_DATA 30 · POPUP 27 · CALL_EXT 26 · MESSAGE 14 · GRID_INIT 13 · LIST_REBIND 9 · GRID_SET 7 · THROW 7 · ENDPOINT 5 · GRID_STYLE 5 · STATE 4 · CALL_BASE 3 · GRID_LOCK 2 · EXCEL 1 · STATE_RESET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 29


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b91c0749 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2443 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfa6c54e | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2449 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c10550be | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2457 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-d24da504 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2458 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-4d684a23 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2459 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-38b66782 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2460 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-4e850119 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2462 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-b2fc41f1 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2463 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-1e5a1d18 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2464 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-66a3285c | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2465 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-4c815798 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2466 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-53dcf328 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2467 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-db3f3771 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2468 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-7668dcf2 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2469 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-31bf073d | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2472 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-269e308d | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2657 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-52cc4b61 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2658 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-107707fa | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2659 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-243a9329 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2660 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-ffc5588e | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2662 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1ded7b2 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2663 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-dc626a47 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2664 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb57db65 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2665 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-8a549656 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2666 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb1a386f | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2667 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-c1578712 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2668 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-39b732a7 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2669 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-bfaa5a57 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2671 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9aeb956 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2576 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-681b7320 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2577 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bbcfe4e7 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2578 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-810c8f1c | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2579 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f17894ce | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2580 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bffad8c6 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2583 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c62dfad7 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2587 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-67c39c28 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2588 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b36fec8 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2574 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-2553db09 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2604 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfd26af4 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2607 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-99422a3a | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2610 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-67bcfbe0 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2613 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6ff6ea2 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2616 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-42cf6eeb | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2619 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-f32ad82c | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2625 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-a1219834 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2627 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ef6902d | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2548 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c0ed62f | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2512 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-faa11525 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2513 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb2f5bee | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2514 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf39a497 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2515 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-263e7cf8 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2516 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-965a0fef | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2517 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f20bc15b | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2519 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4584f41 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2520 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a5267b4 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2523 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-426820ab | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2524 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d5432f1 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2525 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf048fbb | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2510 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-77f8560d | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2533 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1ccf65a | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2534 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-04683916 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2539 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8aa3297 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2485 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00618_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-692a9aab | .ctor | FP00618_MeasureSetForm_Popup.cs:79 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-9dd86539 | .ctor | FP00618_MeasureSetForm_Popup.cs:80 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-de6cdb09 | .ctor | FP00618_MeasureSetForm_Popup.cs:81 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-4c102176 | .ctor | FP00618_MeasureSetForm_Popup.cs:83 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00618_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8f4a121 | this.btnOK.Click | FP00618_MeasureSetForm_Popup.cs:355 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-98e91045 | this.btnOK.Click | FP00618_MeasureSetForm_Popup.cs:356 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-319040f0 | this.btnOK.Click | FP00618_MeasureSetForm_Popup.cs:363 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-743b1695 | this.btnOK.Click | FP00618_MeasureSetForm_Popup.cs:364 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00618_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43da2697 | this.btnSet.Click | FP00618_MeasureSetForm_Popup.cs:325 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-27ab13eb | this.btnSet.Click | FP00618_MeasureSetForm_Popup.cs:326 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-3cfbd479 | this.btnSet.Click | FP00618_MeasureSetForm_Popup.cs:328 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-790f2002 | this.btnSet.Click | FP00618_MeasureSetForm_Popup.cs:329 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32a0e3f1 | this.btnSet.Click | FP00618_MeasureSetForm_Popup.cs:331 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-f34cc307 | this.btnSet.Click | FP00618_MeasureSetForm_Popup.cs:333 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-cd061256 | this.btnSet.Click | FP00618_MeasureSetForm_Popup.cs:334 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00618_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52381126 | Dispose | FP00618_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00618_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0d37414 | this.Load | FP00618_MeasureSetForm_Popup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00618_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92566dfb | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:223 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-55777562 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:224 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef0cb6a4 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:225 |  | DATA_OP | ctrls.Add | (chk_result_in) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d267b5e | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:226 |  | DATA_OP | ctrls.Add | (chk_result_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fae37a5 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:228 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a8fc981 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:229 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-52f4c804 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_seq) | 데이터 객체 조작/조회 |  |  |  |
| AC-6135e2dc | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-b43dd0fd | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:233 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-c80cd7b7 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-2de5554f | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_offtime) | 데이터 객체 조작/조회 |  |  |  |
| AC-49e4d34f | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-71bcc5a3 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cc080e7 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_result_in_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-4193b6b7 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-08e15b8c | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7d83289 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:245 |  | DATA_OP | ctrls.Add | (chk_result_out_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ea7789a | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-453fad4e | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:248 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0c2ae30 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-0af43789 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:251 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-337f53f9 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:254 |  | DATA_OP | ctrls.Add | (chk_kg) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c1cc031 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2502d7e | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:258 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-3d5d2483 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:258 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-f051f429 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:265 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-89144e09 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:269 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |

## FP00618_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbdf3bba | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-832a8fb6 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-004a151c | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_result_in.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-feb013ba | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_result_out.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6fe1a17d | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-84499a68 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1ea3635b | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_seq.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c1f43c11 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d47bb1db | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7fdd4d27 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1e983cee | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_offtime.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-71499ca7 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-49fb4155 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-642db670 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_result_in_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3059dcdc | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-44e95cc5 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-08187139 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_result_out_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d968dbdd | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8a55feb2 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6572f1e8 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:168 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b93ac422 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-360a60d1 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:173 |  | VALUE_SET | chk_kg.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-502cff18 | this.Load 외 1 | FP00618_MeasureSetForm_Popup.cs:174 |  | VALUE_SET | chk_batch.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00618_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bdd07f5 | (진입점 미연결) | FP00618_MeasureSetForm_Popup.cs:418 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-fccf7dc2 | (진입점 미연결) | FP00618_MeasureSetForm_Popup.cs:429 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6ea8b20 | (진입점 미연결) | FP00618_MeasureSetForm_Popup.cs:440 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00618_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b4b3369 | this.Load | FP00618_MeasureSetForm_Popup.cs:94 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8eca46fd | this.Load | FP00618_MeasureSetForm_Popup.cs:102 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00618_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a18070bd | this.btnSet.Click 외 1 | FP00618_MeasureSetForm_Popup.cs:370 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b3498f8e | this.btnSet.Click 외 1 | FP00618_MeasureSetForm_Popup.cs:378 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-7904cbab | this.btnSet.Click 외 1 | FP00618_MeasureSetForm_Popup.cs:378 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-58906095 | this.btnSet.Click 외 1 | FP00618_MeasureSetForm_Popup.cs:395 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2e1113c7 | this.btnSet.Click 외 1 | FP00618_MeasureSetForm_Popup.cs:406 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74df0a3c | .ctor | FP00618_PlanBy_Model_PreMix.cs:201 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00618_PlanBy_Model_PreMix.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_PREMIX_MEMO")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab4031bd | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:729 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b19a6155 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:730 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a3007dd7 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:731 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8bccb853 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:732 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c23ba214 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:733 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-88f5c240 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:734 |  | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8be5eb16 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:736 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-717031a4 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:737 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-912c12b7 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:739 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8765fbf9 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:740 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-62a05ad4 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:742 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9c39502a | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:743 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-d347bdd1 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:745 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37ded558 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:746 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b562848a | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:748 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00618_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-340338a2 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:749 |  | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-0c3086fb | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:756 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-31922fc0 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:757 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ebb968cc | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:758 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e8a450a4 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:759 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5671f5de | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:771 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-9e4c372f | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:777 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1214cd6f | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:778 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e2c2cd68 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:779 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bec99a0d | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:781 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-e5a619e1 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:782 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-4149ee83 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:783 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-ecabd0b6 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:784 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-9a440fc8 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:785 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-0b01b06c | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:786 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-98802330 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:787 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00618_PlanBy_Model_PreMix.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_PREMIX_MEMO")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-776504ed | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:793 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; //Plan Group if (GetFilter("INSTANCE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-eaa574c5 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:804 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-6e94cfba | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:805 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-6fc57940 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:811 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9185de9b | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:835 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-65b0a974 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:838 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_currDateCol", Filter["INSTANCE_ID"], Filter["BUCKET_FROM"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00618_PlanBy_Model_PreMix.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1aab9276 | this.btnBucket.Click | FP00618_PlanBy_Model_PreMix.cs:1622 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-edb975b5 | this.btnBucket.Click | FP00618_PlanBy_Model_PreMix.cs:1625 |  | POPUP | new FP00599_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-157eae04 | this.btnBucket.Click | FP00618_PlanBy_Model_PreMix.cs:1626 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6c41dae1 | this.btnBucket.Click | FP00618_PlanBy_Model_PreMix.cs:1627 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-18f53176 | this.btnBucket.Click | FP00618_PlanBy_Model_PreMix.cs:1628 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-47f52a39 | this.btnBucket.Click | FP00618_PlanBy_Model_PreMix.cs:1632 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-c1806840 | this.btnBucket.Click | FP00618_PlanBy_Model_PreMix.cs:1644 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cf8eee1e | this.btnBucket.Click | FP00618_PlanBy_Model_PreMix.cs:1653 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00618_PlanBy_Model_PreMix.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be3ddae5 | this.btnCatagory.Click | FP00618_PlanBy_Model_PreMix.cs:1571 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-8ce27e14 | this.btnCatagory.Click | FP00618_PlanBy_Model_PreMix.cs:1574 |  | POPUP | new FP00618_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-5e50139b | this.btnCatagory.Click | FP00618_PlanBy_Model_PreMix.cs:1575 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-35b8e5e3 | this.btnCatagory.Click | FP00618_PlanBy_Model_PreMix.cs:1576 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4f9cfb35 | this.btnCatagory.Click | FP00618_PlanBy_Model_PreMix.cs:1577 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7db08988 | this.btnCatagory.Click | FP00618_PlanBy_Model_PreMix.cs:1581 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-0c657628 | this.btnCatagory.Click | FP00618_PlanBy_Model_PreMix.cs:1593 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c5c52fa1 | this.btnCatagory.Click | FP00618_PlanBy_Model_PreMix.cs:1602 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0d872921 | this.btnCatagory.Click | FP00618_PlanBy_Model_PreMix.cs:1607 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-794554c0 | this.btnCatagory.Click | FP00618_PlanBy_Model_PreMix.cs:1613 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00618_PlanBy_Model_PreMix.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8587cfaf | this.btnColumn.Click | FP00618_PlanBy_Model_PreMix.cs:1544 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-52606190 | this.btnColumn.Click | FP00618_PlanBy_Model_PreMix.cs:1547 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-8fc7d2d6 | this.btnColumn.Click | FP00618_PlanBy_Model_PreMix.cs:1548 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fc03a026 | this.btnColumn.Click | FP00618_PlanBy_Model_PreMix.cs:1549 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2c45ec98 | this.btnColumn.Click | FP00618_PlanBy_Model_PreMix.cs:1555 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-d06ccf4f | this.btnColumn.Click | FP00618_PlanBy_Model_PreMix.cs:1555 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d33d0fdc | this.btnColumn.Click | FP00618_PlanBy_Model_PreMix.cs:1556 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-d712e259 | this.btnColumn.Click | FP00618_PlanBy_Model_PreMix.cs:1562 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00618_PlanBy_Model_PreMix.btnMemo_Click

진입점: this.usrButton3.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18b66733 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1689 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-73b592e4 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1690 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e37517c | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1693 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-98d190b5 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1694 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-e938aa4d | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1695 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-d74db415 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1696 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4540baa7 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1697 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-581b1b9c | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1698 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-75b79c94 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1699 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b3c40e79 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1699 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fb8141cd | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1700 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-941fa4c2 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1701 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6797fc01 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1702 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c7ff68fe | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1703 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-565ecbdc | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1704 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aad84309 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1705 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3e932d00 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1706 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-eff623c3 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1707 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d27dfdf2 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1708 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-49b7464d | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1710 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-30b388da | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1711 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-486b14fa | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1712 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-ce3bcca3 | this.usrButton3.Click | FP00618_PlanBy_Model_PreMix.cs:1713 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00618_PlanBy_Model_PreMix.btnPlanInfo_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97eb9b8d | this.usrButton1.Click | FP00618_PlanBy_Model_PreMix.cs:1663 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-e3b43ecd | this.usrButton1.Click | FP00618_PlanBy_Model_PreMix.cs:1664 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8cfdc15 | this.usrButton1.Click | FP00618_PlanBy_Model_PreMix.cs:1670 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-0a75ce9f | this.usrButton1.Click | FP00618_PlanBy_Model_PreMix.cs:1673 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-162cf6bf | this.usrButton1.Click | FP00618_PlanBy_Model_PreMix.cs:1674 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ca8655c2 | this.usrButton1.Click | FP00618_PlanBy_Model_PreMix.cs:1674 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e136ca26 | this.usrButton1.Click | FP00618_PlanBy_Model_PreMix.cs:1675 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-d1f3a8c1 | this.usrButton1.Click | FP00618_PlanBy_Model_PreMix.cs:1676 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-35514d65 | this.usrButton1.Click | FP00618_PlanBy_Model_PreMix.cs:1678 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1b0bfb10 | this.usrButton1.Click | FP00618_PlanBy_Model_PreMix.cs:1679 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00618_PlanBy_Model_PreMix.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb779375 | this.btnSql.Click | FP00618_PlanBy_Model_PreMix.cs:1724 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-5864e6a2 | this.btnSql.Click | FP00618_PlanBy_Model_PreMix.cs:1727 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-39dd15af | this.btnSql.Click | FP00618_PlanBy_Model_PreMix.cs:1728 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-79fdf8a2 | this.btnSql.Click | FP00618_PlanBy_Model_PreMix.cs:1730 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00618_PLANBY_MODEL_PREMIX_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc0b9209 | this.btnSql.Click | FP00618_PlanBy_Model_PreMix.cs:1731 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00618_PLANBY_MODEL_PREMIX_MEMO") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c52ecac | this.btnSql.Click | FP00618_PlanBy_Model_PreMix.cs:1733 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00618_PlanBy_Model_PreMix.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7db2e40c | this.Load | FP00618_PlanBy_Model_PreMix.cs:1124 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d322325 | this.Load | FP00618_PlanBy_Model_PreMix.cs:1124 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-b9ccd23a | this.Load | FP00618_PlanBy_Model_PreMix.cs:1126 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00618_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9749efb4 | this.Load | FP00618_PlanBy_Model_PreMix.cs:1126 |  | POPUP | new FP00618_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-bee5cf23 | this.Load | FP00618_PlanBy_Model_PreMix.cs:1127 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3436bf5 | this.Load | FP00618_PlanBy_Model_PreMix.cs:1127 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP00618_PlanBy_Model_PreMix.chk_allLine_CheckedChanged

진입점: chk_allLine.CheckedChanged / this.chk_allLine.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03062ad3 | chk_allLine.CheckedChanged 외 1 | FP00618_PlanBy_Model_PreMix.cs:1371 | if (chk_allLine.Checked) | CALL_EXT | mcbo_line.SetAllCheckItem | (true) | ⚠ 의미 확인 필요 |  |  |  |

## FP00618_PlanBy_Model_PreMix.chkInAct_CheckedChanged

진입점: this.chkInAct.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd2d9421 | this.chkInAct.CheckedChanged | FP00618_PlanBy_Model_PreMix.cs:1419 | if (chk_allLine.Checked) | CALL_EXT | mcbo_line.SetAllCheckItem | (true) | ⚠ 의미 확인 필요 |  |  |  |

## FP00618_PlanBy_Model_PreMix.CreateFilterDataSet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null)] / this.btnC…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cae8841b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:878 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-669252d8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:890 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-46f874b0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:891 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-bc39148a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:912 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7544baec | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:913 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-80493b2d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:917 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c504540f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:918 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1f207ea | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:922 | if (measure["chk_result_in"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d961184 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:923 | if (measure["chk_result_in"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d4c66f4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:927 | if (measure["chk_result_out"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff8ea851 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:928 | if (measure["chk_result_out"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b26ce7a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:934 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0d60a2a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:935 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7a080de | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:939 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ffa7355 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:940 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5745bb29 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:944 | if (measure["chk_seq"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_SEQ")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a7d4100 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:948 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-23d53b57 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:954 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc4702a1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:955 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-54d5f0d1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:959 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bec6c077 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:960 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ecd3d301 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:964 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-98920c33 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:973 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-af308461 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:974 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a4cae98 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:978 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-10002fae | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:979 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9410eb49 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:983 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2818b682 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:984 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c027590 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:991 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c1a5241 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:992 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa3ff2e8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:996 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cb40ec5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:997 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b5352d8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1001 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ae5a8e7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1002 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-97b64616 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1009 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a007bc5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1010 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f000a30 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1014 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-02848fb4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1015 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-815c8977 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1026 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e8f42b1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1027 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-709fa190 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1031 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-eecbef93 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1032 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-28410d83 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1036 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b709da34 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1037 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-29dd0aca | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1043 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a58662c5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1044 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-831a85a5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1048 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9a5911a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1049 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5e10415 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1053 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0097d20c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1054 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b883d0af | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1060 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a30a6d3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1061 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4ddb66f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1065 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b69e8721 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1066 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc506354 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1075 | if (measure["chk_kg"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("CATEGORY_NAME", "Kg")) | 데이터 객체 조작/조회 |  |  |  |
| AC-726f4123 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1078 | if (measure["chk_kg"].Value != "true") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-8932fcdf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1080 | if (measure["chk_kg"].Value != "true") | DATA_OP | tmp.Select | (result_row => result_row["_MM_"] = false) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ae2b37f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1080 | if (measure["chk_kg"].Value != "true") ▸ lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-01390e1e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1085 | if (measure["chk_batch"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("CATEGORY_NAME", "Batch")) | 데이터 객체 조작/조회 |  |  |  |
| AC-edd7298e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1089 | if (measure["chk_batch"].Value != "true") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ce70396 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1091 | if (measure["chk_batch"].Value != "true") | DATA_OP | tmp.Select | (result_row => result_row["_MM_"] = false) | 데이터 객체 조작/조회 |  |  |  |
| AC-479ea80b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1091 | if (measure["chk_batch"].Value != "true") ▸ lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-5ec09761 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1095 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-93264703 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1098 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ffb9aa9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1102 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-60e5e656 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1107 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bfaeea5f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1111 | else of (m != null && m.Count() > 0) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-07da2190 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1111 | else of (m != null && m.Count() > 0) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-20792c94 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1116 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcbe2da8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1118 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d70b20aa | this.Load | FP00618_PlanBy_Model_PreMix.cs:387 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8a98ab8a | this.Load | FP00618_PlanBy_Model_PreMix.cs:388 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a1dbe52 | this.Load | FP00618_PlanBy_Model_PreMix.cs:389 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00618_PlanBy_Model_PreMix.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged / this.dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-917c49e2 | dCalendar_planrange.ValueChanged 외 1 | FP00618_PlanBy_Model_PreMix.cs:1477 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df1fd594 | dCalendar_planrange.ValueChanged 외 1 | FP00618_PlanBy_Model_PreMix.cs:1482 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-669e0ff0 | dCalendar_planrange.ValueChanged 외 1 | FP00618_PlanBy_Model_PreMix.cs:1499 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | MESSAGE | MessageBox.Show | ("It cannot be exceeded 100 days") | 메시지 표시 |  |  |  |
| AC-7f97902b | dCalendar_planrange.ValueChanged 외 1 | FP00618_PlanBy_Model_PreMix.cs:1500 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(100) | 속성 Value2 설정 |  |  |  |
| AC-d9567880 | dCalendar_planrange.ValueChanged 외 1 | FP00618_PlanBy_Model_PreMix.cs:1508 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ else of (string.… | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(" + sEndDate + ")!") | 메시지 표시 |  |  |  |
| AC-22d3ffcb | dCalendar_planrange.ValueChanged 외 1 | FP00618_PlanBy_Model_PreMix.cs:1509 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ else of (string.… | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-43dd870d | dCalendar_planrange.ValueChanged 외 1 | FP00618_PlanBy_Model_PreMix.cs:1510 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ else of (string.… | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-49f6b5cf | dCalendar_planrange.ValueChanged 외 1 | FP00618_PlanBy_Model_PreMix.cs:1522 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | MESSAGE | MessageBox.Show | ("It cannot be exceeded 100 days") | 메시지 표시 |  |  |  |
| AC-21c229d0 | dCalendar_planrange.ValueChanged 외 1 | FP00618_PlanBy_Model_PreMix.cs:1523 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(100) | 속성 Value2 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-346f7632 | DeleteButton | FP00618_PlanBy_Model_PreMix.cs:563 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4acb365 | DeleteButton | FP00618_PlanBy_Model_PreMix.cs:564 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a855ed9e | Dispose | FP00618_PlanBy_Model_PreMix.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00618_PlanBy_Model_PreMix.DrawHeader

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10479327 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2747 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-91c7cdf2 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2751 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-efc41814 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2752 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-44be3d0b | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2753 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04ba9778 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2754 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-751c2bba | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2755 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-d1b234b2 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2759 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-928291a9 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2760 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-dc8311b2 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2761 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-a059d67a | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2762 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-ecb83516 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2768 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-09b4af69 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2769 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1173403 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2802 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-587966f7 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2807 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, FPExtensions.DateColumnT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-16f5d91e | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2809 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34531873 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2810 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8f7087e | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2811 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-5e9c3c56 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2813 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-877708d9 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2815 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-41387718 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2816 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a720176 | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:2821 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP00618_PlanBy_Model_PreMix.DrawSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a240d10 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2856 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-93693092 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2858 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf66a4d6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2882 |  | CALL_EXT | MemoService.ShowMemo | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a62edcda | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2883 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00618_PlanBy_Model_PreMix.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c44f855 | EditButton | FP00618_PlanBy_Model_PreMix.cs:570 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b30d797 | EditButton | FP00618_PlanBy_Model_PreMix.cs:571 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8320294c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00618_PlanBy_Model_PreMix.cs:614 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-84adcf7a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00618_PlanBy_Model_PreMix.cs:618 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4610106 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00618_PlanBy_Model_PreMix.cs:622 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-ce59f11c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00618_PlanBy_Model_PreMix.cs:626 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c230998c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00618_PlanBy_Model_PreMix.cs:638 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00618_PlanBy_Model_PreMix.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdd3e23c | ExcelButton | FP00618_PlanBy_Model_PreMix.cs:585 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-ba45fd5a | ExcelButton | FP00618_PlanBy_Model_PreMix.cs:586 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-7ebf0aee | ExcelButton | FP00618_PlanBy_Model_PreMix.cs:588 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-57915f11 | ExcelButton | FP00618_PlanBy_Model_PreMix.cs:592 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-2129a862 | ExcelButton | FP00618_PlanBy_Model_PreMix.cs:593 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-8aecc353 | ExcelButton | FP00618_PlanBy_Model_PreMix.cs:594 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-308d0f01 | ExcelButton | FP00618_PlanBy_Model_PreMix.cs:597 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-c388dd51 | ExcelButton | FP00618_PlanBy_Model_PreMix.cs:598 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-d8065867 | ExcelButton | FP00618_PlanBy_Model_PreMix.cs:599 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-806f6ac6 | ExcelButton | FP00618_PlanBy_Model_PreMix.cs:601 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-93b7f161 | ExcelButton | FP00618_PlanBy_Model_PreMix.cs:602 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_PREMIX_MAIN")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-991bec9a | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:717 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00618_PLANBY_MODEL_PREMIX", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-59bfcc99 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:719 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-c001a731 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:723 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.Find_Data_Memo

진입점: popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_PREMIX_MEMO")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12462c88 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… | FP00618_PlanBy_Model_PreMix.cs:1284 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00618_PLANBY_MODEL_PREMIX", Filter, _CurrentUser, pSysType, "SELECT_MEA_MEMO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e55e5eac | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… | FP00618_PlanBy_Model_PreMix.cs:1286 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-d8c0d026 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… | FP00618_PlanBy_Model_PreMix.cs:1290 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.FindTotalColorStart

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfc5a385 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:872 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23483868 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:644 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a35397a | this.Load | FP00618_PlanBy_Model_PreMix.cs:216 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00618_PlanBy_Model_PreMix.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_PREMIX_MEMO") ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccd98fa8 | popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_P… 외 3 | FP00618_PlanBy_Model_PreMix.cs:2138 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.GetOperation

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d954cdf5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1741 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e94584b7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1742 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ca0dbb64 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1742 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a6d5b6f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1744 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00618_PlanBy_Model_PreMix.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95e40dc7 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2393 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-1fb87304 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2394 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.GetToDay

진입점: this.Load [try] / dCalendar_planrange.ValueChanged [if (getTypeName == "System.Windows.Forms.MaskedTextBox")] / popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_PREMIX_MEMO") ▸ lambda ▸ if (dt != null) ▸ else of (dt.Rows.Count > 0)] / this.dCalendar_planrange.ValueChanged [if (getTypeName == "System.Windows.Forms.MaskedTextBox")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ lambda ▸ if (dt != null) ▸ else of (dt.Rows.Count > 0)] / this.btnCa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8486f99 | this.Load [try] 외 6 | FP00618_PlanBy_Model_PreMix.cs:2342 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-a4953e60 | this.Load [try] 외 6 | FP00618_PlanBy_Model_PreMix.cs:2343 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.GoDrawCellColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10a0aa15 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1133 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7474943f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1194 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-933eea54 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:1195 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f01d147c | this.Load | FP00618_PlanBy_Model_PreMix.cs:279 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3665e7af | this.Load | FP00618_PlanBy_Model_PreMix.cs:282 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanAmendMA) | 데이터 객체 조작/조회 |  |  |  |
| AC-42080f2e | this.Load | FP00618_PlanBy_Model_PreMix.cs:284 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a5e410d5 | this.Load | FP00618_PlanBy_Model_PreMix.cs:285 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ec6f5a7a | this.Load | FP00618_PlanBy_Model_PreMix.cs:288 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-32d3f410 | this.Load | FP00618_PlanBy_Model_PreMix.cs:291 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-565bb000 | this.Load | FP00618_PlanBy_Model_PreMix.cs:297 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-af3d9b49 | this.Load | FP00618_PlanBy_Model_PreMix.cs:326 | try | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-0725e205 | this.Load | FP00618_PlanBy_Model_PreMix.cs:332 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-9972bca4 | this.Load | FP00618_PlanBy_Model_PreMix.cs:333 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-06cf5191 | this.Load | FP00618_PlanBy_Model_PreMix.cs:334 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a81243d9 | this.Load | FP00618_PlanBy_Model_PreMix.cs:340 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00618_PlanBy_Model_PreMix.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6397d38a | this.Load | FP00618_PlanBy_Model_PreMix.cs:249 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a0f2fab5 | this.Load | FP00618_PlanBy_Model_PreMix.cs:250 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5ce221ad | this.Load | FP00618_PlanBy_Model_PreMix.cs:251 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-af08476b | this.Load | FP00618_PlanBy_Model_PreMix.cs:252 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-85bc8f10 | this.Load | FP00618_PlanBy_Model_PreMix.cs:253 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a91d5c37 | this.Load | FP00618_PlanBy_Model_PreMix.cs:254 |  | UI_PROP | mcbo_prod_type.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix.InitSpread

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-012fe37b | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:402 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a51ab89b | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:403 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9fd736ec | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:405 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e18a92a | this.Load 외 6 | FP00618_PlanBy_Model_PreMix.cs:409 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00618_PlanBy_Model_PreMix.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-236594d9 | InsertButton | FP00618_PlanBy_Model_PreMix.cs:555 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-59d63e10 | InsertButton | FP00618_PlanBy_Model_PreMix.cs:556 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f7806bd | memo_menu.Click | FP00618_PlanBy_Model_PreMix.cs:2065 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-160f71de | memo_menu.Click | FP00618_PlanBy_Model_PreMix.cs:2068 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7c15f2c | memo_menu.Click | FP00618_PlanBy_Model_PreMix.cs:2072 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00618_PlanBy_Model_PreMix.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca218891 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2087 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3dd55c88 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2090 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99ec147a | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2108 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-e4702cc4 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2109 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8e4f5925 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2110 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d89cdbcc | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2111 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d47358f6 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2112 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-9309e895 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2113 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-d329c944 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2114 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ba32e86d | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2115 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-133747b7 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2116 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00618_PlanBy_Model_PreMix.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94a16058 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:1983 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c4567e8 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:1986 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64661dcd | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2010 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fa399b8 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2024 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfa55a2e | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2027 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cdbf9e82 | (진입점 미연결) | FP00618_PlanBy_Model_PreMix.cs:2051 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix.OpenLineMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2003ffb5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1749 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-7f125253 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1750 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-d2d50ef8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1751 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-4e9e6321 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1751 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aa4eddc9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1752 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-dd5ce0cd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1753 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cf98b335 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1754 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-efd541b9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1759 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-adca32fe | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1762 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix.OpenMaterialMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a19ce75f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1768 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-a275ce92 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1769 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-78c0269a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1770 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-9a0c50d1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1770 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-735eb08f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1771 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-7caa1198 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1772 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a18f65fd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1773 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-eb0f77a7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1777 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-393fa78b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00618_PlanBy_Model_PreMix.cs:1779 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00618_PlanBy_Model_PreMix.Query

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7c28cde | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2830 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-ac8ccd89 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2830 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-009463c3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2831 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-2ea3c696 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2831 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6ff13432 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2832 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-ab11d8d6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2832 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4e794176 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2835 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-4d1694c5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2842 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-364522d6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2847 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5402170 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2848 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-911f9b13 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2850 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00618_PlanBy_Model_PreMix.RefreshHeadAndBody

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null)] / this.btnC…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38467bf2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2713 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a73ee8a5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2729 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-8d59b2e1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2733 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00618_PlanBy_Model_PreMix.RefreshSpreadSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null)] / this.btnC…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdf57bd3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2689 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-fcf5905c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2689 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-279379a2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2701 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-9230e681 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2706 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00618_PlanBy_Model_PreMix.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49bfcfa7 | popSql.OnSql | FP00618_PlanBy_Model_PreMix.cs:2362 | if (programID == "PR_UI_FP00618_PLANBY_MODEL_PREMIX_MAIN") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-20b417c8 | popSql.OnSql | FP00618_PlanBy_Model_PreMix.cs:2371 | if (programID == "PR_UI_FP00618_PLANBY_MODEL_PREMIX_MEMO") | RETURN | return Find_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-2a867973 | popSql.OnSql | FP00618_PlanBy_Model_PreMix.cs:2375 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e22dbb9 | SaveButton | FP00618_PlanBy_Model_PreMix.cs:577 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3550ea32 | SaveButton | FP00618_PlanBy_Model_PreMix.cs:578 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetBasisTime

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18c2bc40 | this.Load [try] | FP00618_PlanBy_Model_PreMix.cs:2305 |  | FLAG | dtBaseTime | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findBasisTime", sInstance,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-dea4deb8 | this.Load [try] | FP00618_PlanBy_Model_PreMix.cs:2305 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findBasisTime", sInstance, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetCalenderColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-126f744e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2948 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a642b758 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2952 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-e616badc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2954 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-755b30fd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2958 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-e024b878 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2974 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-357abc08 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2989 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-598e769e | this.Load | FP00618_PlanBy_Model_PreMix.cs:236 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd62a1be | this.Load | FP00618_PlanBy_Model_PreMix.cs:238 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-3caf13bb | this.Load | FP00618_PlanBy_Model_PreMix.cs:242 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetDivision

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06d333ad | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2161 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-6d745833 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2161 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-320c8e2e | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2162 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetFactory

진입점: this.Load [try] / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-145f409e | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2194 |  | FLAG | dtFactoryAmend | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE, false, _CurrentUser, _sNonAuth, _sSaveAuth , … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-04c71c38 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2194 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5438ce75 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2198 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (dtInstance.Good())] / mcbo_division.SelectedIndexChanged / cbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / mcbo_line.SelectedIndexChanged / txtItem.TextChanged / mcbo_prod_type.SelectedIndexChanged / dCalendar_planrange.ValueChanged [if (getTypeName == "System.Windows.Forms.MaskedTextBox")] / chk_allLine.CheckedChanged / chk_IncludeSubOp.CheckedChanged / popSql.OnSql [if (programID == "PR_UI_FP00618_PLANBY_MODEL_PREMIX_MEMO") ▸ lambda ▸ if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e549719 | this.Load [try] 외 21 | FP00618_PlanBy_Model_PreMix.cs:2133 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetFpPlanId

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b146507 | this.Load [try] | FP00618_PlanBy_Model_PreMix.cs:2317 |  | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00603_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-8858c296 | this.Load [try] | FP00618_PlanBy_Model_PreMix.cs:2317 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetLine

진입점: this.Load [try] / mcbo_operation.SelectedIndexChanged [try] / chk_allLine.CheckedChanged / this.chkInAct.CheckedChanged / this.chk_allLine.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-659d7377 | this.Load [try] 외 4 | FP00618_PlanBy_Model_PreMix.cs:2223 |  | FLAG | dtLine | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00617_findLineCode_List", Filter… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-33ccfe0d | this.Load [try] 외 4 | FP00618_PlanBy_Model_PreMix.cs:2223 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00617_findLineCode_List", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23dd8a68 | this.Load [try] 외 4 | FP00618_PlanBy_Model_PreMix.cs:2227 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetOperation

진입점: this.Load [try] / mcbo_factory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee666c04 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2206 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-8b3c6f71 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2206 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0529e3e9 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2208 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8c4bad1 | this.Load [try] | FP00618_PlanBy_Model_PreMix.cs:2143 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findAmendInstanceList_common", lv_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3f16e38d | this.Load [try] | FP00618_PlanBy_Model_PreMix.cs:2143 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findAmendInstanceList_common", lv_amendInstance, _sSaveAuth) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fced729e | this.Load [try] | FP00618_PlanBy_Model_PreMix.cs:2145 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-b89995dc | this.Load [try] | FP00618_PlanBy_Model_PreMix.cs:2147 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetPlanPeriod

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccd46a66 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2265 |  | FLAG | dtPeriod | Data_FP.Common_FP(Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-ccb97471 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2265 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0fa291c8 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2280 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-c51ac2de | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2281 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-7b67e282 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2285 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-72260853 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2286 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-89038a25 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2292 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-35b0b766 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2293 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetPlant

진입점: this.Load [try] / cbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-019e38fb | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2181 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-e698bda4 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2181 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-112b5e59 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2183 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetProdType

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28448add | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2235 |  | FLAG | dtProdType | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_find_FPProdType", Filter["… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-71c12bc4 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2235 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_FPProdType", Filter["DIVISION_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b973d92 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2237 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prod_type, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetSite

진입점: this.Load [try] / mcbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67cea82a | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2170 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-34bf69fe | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2170 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-715a8fd6 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2171 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-db19f761 | this.Load [try] 외 1 | FP00618_PlanBy_Model_PreMix.cs:2174 | if (dtSite.Rows.Count == 1) | VALUE_SET | cbo_site.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (mont…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66eb360a | this.Load [try] 외 6 | FP00618_PlanBy_Model_PreMix.cs:417 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1c5c2e0 | this.Load [try] 외 6 | FP00618_PlanBy_Model_PreMix.cs:418 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SetTotalColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09e53cff | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00618_PlanBy_Model_PreMix.cs:2926 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00618_PlanBy_Model_PreMix.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d87fcfd | this.spdMain.CellClick | FP00618_PlanBy_Model_PreMix.cs:1959 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-5c6c1e45 | this.spdMain.CellClick | FP00618_PlanBy_Model_PreMix.cs:1960 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-1881ef29 | this.spdMain.CellClick | FP00618_PlanBy_Model_PreMix.cs:1962 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e903899 | this.spdMain.CellClick | FP00618_PlanBy_Model_PreMix.cs:1970 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00618_PlanBy_Model_PreMix.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5eae68ce | this.spdMain.CellDoubleClick | FP00618_PlanBy_Model_PreMix.cs:1924 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-57b826d8 | this.spdMain.CellDoubleClick | FP00618_PlanBy_Model_PreMix.cs:1931 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00618_PlanBy_Model_PreMix.SwitchMemo

진입점: memo_menu.Click [try ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd44f517 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00618_PlanBy_Model_PreMix.cs:1789 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-298cb444 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00618_PlanBy_Model_PreMix.cs:1806 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-ee106cde | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00618_PlanBy_Model_PreMix.cs:1837 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-267712e0 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00618_PlanBy_Model_PreMix.cs:1838 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-98e86f24 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00618_PlanBy_Model_PreMix.cs:1840 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-029da869 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00618_PlanBy_Model_PreMix.cs:1871 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-8e28925b | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00618_PlanBy_Model_PreMix.cs:1872 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-031f0270 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00618_PlanBy_Model_PreMix.cs:1874 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00618_PlanBy_Model_PreMix.UIFindData

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bf1f5ed | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:437 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4326c61c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:438 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d76b4f52 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:441 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4e573a49 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:444 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-57cd850b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:457 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-87dcabfb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:458 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19771ce5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:461 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-055f9af8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:464 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7fa30e38 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:465 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dfb76e95 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:473 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | Find_Data_Amend("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-52095a35 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:481 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3886d36 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:483 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-36f50df3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:484 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-92c4444d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:493 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a2f58a0c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:495 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-432cfbe3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:502 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-fb67453e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:504 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-978fc5c3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:508 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ebb3aec5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:512 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c334066b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:513 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c9b0bbb6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:521 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5d5939c8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:525 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c4907d9c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:530 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8aee182c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:531 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-469f2467 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:538 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d2f034a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:543 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-b2ccf1c8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00618_PlanBy_Model_PreMix.cs:547 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

