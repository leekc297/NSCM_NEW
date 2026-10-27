# AS-IS 액션 대조표 — FP00607

> 원천: `Doc/asisfacts/screens/FP00607/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2780행 · 메서드 229 · 종류 DATA_OP 1193 · RETURN 246 · UI_PROP 222 · FLAG 222 · VALUE_SET 124 · MESSAGE 117 · UI_MISC 113 · STATE 90 · POPUP 80 · COMBO_DATA 71 · CALL_EXT 67 · GRID_SET 51 · ENDPOINT 44 · GRID_INIT 36 · CALL_BASE 22 · VALUE_CLEAR 16 · THROW 14 · LIST_REBIND 12 · GRID_LOCK 10 · FOCUS 9 · GRID_STYLE 7 · GRID_BIND 4 · LIST_CLEAR 4 · EXCEL 3 · STATE_RESET 3 · ⚠ 의미 확인 필요 89


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a10998cd | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8519 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f9465cf | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8525 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b7b1f77b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8533 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-67bb2246 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8534 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-14e8013b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8535 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-3d92be89 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8536 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-8d1a88fc | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8538 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-613c7010 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8539 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-833a4a89 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8540 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-919afe1b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8541 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-5f6f517c | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8542 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ece7247 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8543 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-da8a1f74 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8544 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-bef74b41 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8545 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-5cba3f61 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8548 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-3937bd45 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8733 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-01c28945 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8734 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-6c868c6f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8735 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-b6d1e219 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8736 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-05aab074 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8738 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-e815b4e1 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8739 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-c4f70cfe | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8740 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-b856f31e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8741 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-da33e307 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8742 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb5b6190 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8743 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-12ad8171 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8744 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef3f58c1 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8745 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-a4be36b3 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8747 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdd53dba | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8652 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b22c3fd7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8653 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb035c61 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8654 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4d55b52f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8655 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ced1a6b3 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8656 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0165344 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8659 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5470a69 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8663 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a604ccb | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8664 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-547aabb2 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8650 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-0fbd4e4a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8680 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-aae03952 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8683 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3619e38 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8686 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd77beae | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8689 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddb2c74f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8692 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-9571c2a5 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8695 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-5affa2b4 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8701 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-6928feb7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8703 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70ec49a9 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8624 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d289daa | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8588 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b63fef04 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8589 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a23fa3a7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8590 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cdae6802 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8591 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-58145087 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8592 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d5a3ef9 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8593 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e28ec759 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8595 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab4cadb2 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8596 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec490a58 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8599 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d96d529 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8600 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3bc4b850 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8601 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b84f38e5 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8586 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-ddee5374 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8609 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f6551ea | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8610 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-305c0662 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8615 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2918cbe | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8561 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00607_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15b2aac0 | .ctor | FP00607_ExcelPopup.cs:150 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-baad7292 | .ctor | FP00607_ExcelPopup.cs:153 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-3d4a9109 | .ctor | FP00607_ExcelPopup.cs:154 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-48e2d6ca | .ctor | FP00607_ExcelPopup.cs:156 |  | FLAG | HeaderLineCount | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-a3f3f316 | .ctor | FP00607_ExcelPopup.cs:157 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |

## FP00607_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c22f6403 | this.btnClose.Click | FP00607_ExcelPopup.cs:1003 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00607_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-012090c7 | this.btnDownload.Click | FP00607_ExcelPopup.cs:977 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-99752e47 | this.btnDownload.Click | FP00607_ExcelPopup.cs:978 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00607_ExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca298e92 | this.btnUpload.Click | FP00607_ExcelPopup.cs:990 | if (bUpload) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bf85a189 | this.btnUpload.Click | FP00607_ExcelPopup.cs:991 | if (bUpload) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |

## FP00607_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cfdd3b1 | this.Load | FP00607_ExcelPopup.cs:250 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eb3db440 | this.Load | FP00607_ExcelPopup.cs:251 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b1d7f08d | this.Load | FP00607_ExcelPopup.cs:252 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00607_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2630fa1e | (진입점 미연결) | FP00607_ExcelPopup.cs:961 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8596041a | (진입점 미연결) | FP00607_ExcelPopup.cs:961 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00607_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0447f7a9 | this.Load | FP00607_ExcelPopup.cs:245 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00607_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b772c40 | Dispose | FP00607_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00607_ExcelPopup.dtpPeriod_ValueChanged

진입점: this.dtpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ac7012a | this.dtpPeriod.ValueChanged | FP00607_ExcelPopup.cs:1019 | if (bFirst == true) | FLAG | bFirst | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8f6ed86d | this.dtpPeriod.ValueChanged | FP00607_ExcelPopup.cs:1020 | if (bFirst == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8e46593 | this.dtpPeriod.ValueChanged | FP00607_ExcelPopup.cs:1035 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35f459ca | this.dtpPeriod.ValueChanged | FP00607_ExcelPopup.cs:1038 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | VALUE_SET | dtpPeriod.InitValue | sStartDate + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f5d9401e | this.dtpPeriod.ValueChanged | FP00607_ExcelPopup.cs:1039 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11b2aa3e | this.dtpPeriod.ValueChanged | FP00607_ExcelPopup.cs:1044 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-286c09e9 | this.dtpPeriod.ValueChanged | FP00607_ExcelPopup.cs:1052 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-96c7c571 | this.dtpPeriod.ValueChanged | FP00607_ExcelPopup.cs:1054 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37951877 | this.dtpPeriod.ValueChanged | FP00607_ExcelPopup.cs:1057 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-1f6fd8e7 | this.dtpPeriod.ValueChanged | FP00607_ExcelPopup.cs:1058 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |

## FP00607_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1248694f | (진입점 미연결) | FP00607_ExcelPopup.cs:951 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00607_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57ea648d | FindButton | FP00607_ExcelPopup.cs:292 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ee4ad872 | FindButton | FP00607_ExcelPopup.cs:293 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e425aaac | FindButton | FP00607_ExcelPopup.cs:295 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00607_ExcelPopup.FindData

진입점: this.btnFind.Click / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5f2298e | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:324 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-602682b8 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:330 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b8d70c2 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:332 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf4adeec | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:337 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f88eb784 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:338 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9117a97b | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:340 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-224a097f | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:341 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-e99b0d0a | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:343 |  | DATA_OP | Filter["BUCKET_FROM"] | _BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-60e28b69 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:344 |  | DATA_OP | Filter["BUCKET_TO"] | _BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-0eca4258 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:349 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-18672413 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:351 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-d3283733 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:355 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a95c9a92 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:360 | if (OnSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c4d246b | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:361 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-35a6606d | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:361 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2df7734c | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:366 | if (OnSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ff87f19e | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:367 | if (OnSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8287ae7c | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:369 | if (OnSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9359cd25 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:370 | if (OnSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-70ab57e1 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:371 | if (OnSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5f0ee4c4 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:372 | if (OnSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-16c97dfe | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:373 | if (OnSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5cdf88cd | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:374 | if (OnSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-44b298f9 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:375 | if (OnSearchData != null) | STATE | this.dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cd38da65 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:381 | if (OnSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3aa2c060 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:385 | if (OnSearchData != null) ▸ try | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bcebd0b9 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:387 | if (OnSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d11754c | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:389 | if (OnSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar, Dat… | ⚠ 의미 확인 필요 |  |  |  |
| AC-03a08049 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:394 | if (OnSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, set, ColumnWidth.Data, Colum… | 화면 필드/플래그 변경 |  |  |  |
| AC-4227f7a3 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:394 | if (OnSearchData != null) ▸ try ▸ lambda | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, set, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data, Heade… | ⚠ 의미 확인 필요 |  |  |  |
| AC-dea932bf | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:399 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-e6105ae6 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:400 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-1b97a500 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:401 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-1bdcbc97 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:406 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-931b7423 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:407 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-871764ca | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:410 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-32b24eb4 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:411 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8447fb76 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:420 | if (OnSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-67bb5d13 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:423 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dec26d9f | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:424 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-289d5ff6 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:425 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ab6734b0 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:426 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c9b60132 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:427 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-aef0b6c5 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:428 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-72de9924 | this.btnFind.Click 외 2 | FP00607_ExcelPopup.cs:429 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00607_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f79b03b | this.Load | FP00607_ExcelPopup.cs:166 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e4c7b248 | this.Load | FP00607_ExcelPopup.cs:168 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_ExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ddf9e95 | (진입점 미연결) | FP00607_ExcelPopup.cs:688 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-1bb9fc13 | (진입점 미연결) | FP00607_ExcelPopup.cs:689 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-7f2a6ca1 | (진입점 미연결) | FP00607_ExcelPopup.cs:690 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-60f66002 | (진입점 미연결) | FP00607_ExcelPopup.cs:691 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-fd1e4944 | (진입점 미연결) | FP00607_ExcelPopup.cs:692 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-5cc1462f | (진입점 미연결) | FP00607_ExcelPopup.cs:693 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-6e203fc0 | (진입점 미연결) | FP00607_ExcelPopup.cs:694 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0275f9bc | (진입점 미연결) | FP00607_ExcelPopup.cs:696 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-64ebd64c | (진입점 미연결) | FP00607_ExcelPopup.cs:697 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-3c456854 | (진입점 미연결) | FP00607_ExcelPopup.cs:701 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a177b25a | (진입점 미연결) | FP00607_ExcelPopup.cs:702 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00607_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0713c6d0 | this.Load | FP00607_ExcelPopup.cs:203 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_FROM"].ToString()) < Convert.ToDecimal(thi… | DATA_OP | Filter["BUCKET_FROM"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e7fdb15d | this.Load | FP00607_ExcelPopup.cs:208 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | sEndDay | 행/컬럼 값 대입 |  |  |  |
| AC-78ab5c64 | this.Load | FP00607_ExcelPopup.cs:211 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | Filter["BUCKET_FROM"] | 화면 필드/플래그 변경 |  |  |  |
| AC-c96c6d16 | this.Load | FP00607_ExcelPopup.cs:212 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | Filter["BUCKET_TO"] | 화면 필드/플래그 변경 |  |  |  |
| AC-b6e41729 | this.Load | FP00607_ExcelPopup.cs:214 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | _BucketFromDate.ToString() + ":" + _BucketToDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-abc17ab8 | this.Load | FP00607_ExcelPopup.cs:216 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6764e034 | this.Load | FP00607_ExcelPopup.cs:218 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-4f4e22db | this.Load | FP00607_ExcelPopup.cs:222 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-c338b727 | this.Load | FP00607_ExcelPopup.cs:224 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-784d642b | this.Load | FP00607_ExcelPopup.cs:225 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-7b319e25 | this.Load | FP00607_ExcelPopup.cs:226 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c9765c91 | this.Load | FP00607_ExcelPopup.cs:234 | for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f5401de | this.Load | FP00607_ExcelPopup.cs:237 |  | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-cf6042b3 | this.Load | FP00607_ExcelPopup.cs:239 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |

## FP00607_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3580d03d | this.Load | FP00607_ExcelPopup.cs:262 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e218caf3 | this.Load | FP00607_ExcelPopup.cs:263 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00607_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31dd0766 | (진입점 미연결) | FP00607_ExcelPopup.cs:283 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00607_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b419c2b | this.btnUpload.Click | FP00607_ExcelPopup.cs:711 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-3d87babc | this.btnUpload.Click | FP00607_ExcelPopup.cs:711 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5eff757 | this.btnUpload.Click | FP00607_ExcelPopup.cs:713 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a36c4ec2 | this.btnUpload.Click | FP00607_ExcelPopup.cs:714 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a3671567 | this.btnUpload.Click | FP00607_ExcelPopup.cs:715 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71a8fba2 | this.btnUpload.Click | FP00607_ExcelPopup.cs:717 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d8d53dc3 | this.btnUpload.Click | FP00607_ExcelPopup.cs:719 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-980048f6 | this.btnUpload.Click | FP00607_ExcelPopup.cs:720 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-200c706c | this.btnUpload.Click | FP00607_ExcelPopup.cs:720 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-613ff211 | this.btnUpload.Click | FP00607_ExcelPopup.cs:727 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9356db9e | this.btnUpload.Click | FP00607_ExcelPopup.cs:728 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-4c8bc129 | this.btnUpload.Click | FP00607_ExcelPopup.cs:940 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00607_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8a47e05 | this.btnSave.Click | FP00607_ExcelPopup.cs:442 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-666c38c3 | this.btnSave.Click | FP00607_ExcelPopup.cs:443 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5c849c3 | this.btnSave.Click | FP00607_ExcelPopup.cs:447 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix! After once seach, Try agagin.!") | 메시지 표시 |  |  |  |
| AC-618d21a3 | this.btnSave.Click | FP00607_ExcelPopup.cs:448 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8986596c | this.btnSave.Click | FP00607_ExcelPopup.cs:459 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (!String.IsNullOrEmpty(dsMain.Tables[0].Rows[i]["MESSAGE"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9a728fa3 | this.btnSave.Click | FP00607_ExcelPopup.cs:460 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (!String.IsNullOrEmpty(dsMain.Tables[0].Rows[i]["MESSAGE"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef7fa408 | this.btnSave.Click | FP00607_ExcelPopup.cs:464 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-69bb63cc | this.btnSave.Click | FP00607_ExcelPopup.cs:464 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-11e53984 | this.btnSave.Click | FP00607_ExcelPopup.cs:470 | if (OnBeforeCheckData != null) | CALL_BASE | OnBeforeCheckData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0185368 | this.btnSave.Click | FP00607_ExcelPopup.cs:472 | if (OnBeforeCheckData != null) ▸ if (bCheck == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-697472a6 | this.btnSave.Click | FP00607_ExcelPopup.cs:483 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-74172f9c | this.btnSave.Click | FP00607_ExcelPopup.cs:484 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9ebacda0 | this.btnSave.Click | FP00607_ExcelPopup.cs:485 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d95553b5 | this.btnSave.Click | FP00607_ExcelPopup.cs:486 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bd2cfdff | this.btnSave.Click | FP00607_ExcelPopup.cs:487 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-aef24686 | this.btnSave.Click | FP00607_ExcelPopup.cs:488 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d786f8a2 | this.btnSave.Click | FP00607_ExcelPopup.cs:496 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-5f32803d | this.btnSave.Click | FP00607_ExcelPopup.cs:497 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-99e9de15 | this.btnSave.Click | FP00607_ExcelPopup.cs:498 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-067f6c9b | this.btnSave.Click | FP00607_ExcelPopup.cs:499 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-80606571 | this.btnSave.Click | FP00607_ExcelPopup.cs:500 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-10b64c8d | this.btnSave.Click | FP00607_ExcelPopup.cs:501 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-102ae483 | this.btnSave.Click | FP00607_ExcelPopup.cs:502 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d57edbf6 | this.btnSave.Click | FP00607_ExcelPopup.cs:503 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93be7fb4 | this.btnSave.Click | FP00607_ExcelPopup.cs:509 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fef4ffd8 | this.btnSave.Click | FP00607_ExcelPopup.cs:512 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-163539d8 | this.btnSave.Click | FP00607_ExcelPopup.cs:514 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-eaacc0b2 | this.btnSave.Click | FP00607_ExcelPopup.cs:517 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-840b2e01 | this.btnSave.Click | FP00607_ExcelPopup.cs:522 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-82022517 | this.btnSave.Click | FP00607_ExcelPopup.cs:523 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-c3616eb2 | this.btnSave.Click | FP00607_ExcelPopup.cs:533 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGrou… | DATA_OP | this.Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-2cc046ed | this.btnSave.Click | FP00607_ExcelPopup.cs:535 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rd… | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-e1eba730 | this.btnSave.Click | FP00607_ExcelPopup.cs:539 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b2636685 | this.btnSave.Click | FP00607_ExcelPopup.cs:544 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b95f449b | this.btnSave.Click | FP00607_ExcelPopup.cs:567 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-aee1c513 | this.btnSave.Click | FP00607_ExcelPopup.cs:570 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | POPUP | new Planning.UIL.FP00594_InValidationExcelPopup | ("InvalidExcelPopup", dsValidation, "") | 팝업/폼 생성 |  |  |  |
| AC-ae7d680a | this.btnSave.Click | FP00607_ExcelPopup.cs:571 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1de33198 | this.btnSave.Click | FP00607_ExcelPopup.cs:572 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ebdd0e3e | this.btnSave.Click | FP00607_ExcelPopup.cs:589 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9517f9e1 | this.btnSave.Click | FP00607_ExcelPopup.cs:601 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40cf36dc | this.btnSave.Click | FP00607_ExcelPopup.cs:605 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | FLAG | bUploadSaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c066e1d8 | this.btnSave.Click | FP00607_ExcelPopup.cs:606 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-87645882 | this.btnSave.Click | FP00607_ExcelPopup.cs:611 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-945bf58a | this.btnSave.Click | FP00607_ExcelPopup.cs:612 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cfb89fb5 | this.btnSave.Click | FP00607_ExcelPopup.cs:618 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-2dd34278 | this.btnSave.Click | FP00607_ExcelPopup.cs:655 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-89f48e8d | this.btnSave.Click | FP00607_ExcelPopup.cs:657 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1dedd133 | this.btnSave.Click | FP00607_ExcelPopup.cs:658 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-553d3026 | this.btnSave.Click | FP00607_ExcelPopup.cs:668 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a58318fa | this.btnSave.Click | FP00607_ExcelPopup.cs:669 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d0c4cbf4 | this.btnSave.Click | FP00607_ExcelPopup.cs:673 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6bbd6562 | this.btnSave.Click | FP00607_ExcelPopup.cs:674 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ee00abd4 | this.btnSave.Click | FP00607_ExcelPopup.cs:675 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-28bc4641 | this.btnSave.Click | FP00607_ExcelPopup.cs:676 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bb33495f | this.btnSave.Click | FP00607_ExcelPopup.cs:677 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bdad69ff | this.btnSave.Click | FP00607_ExcelPopup.cs:678 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00607_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0368324b | this.Load | FP00607_ExcelPopup.cs:275 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-44c5a018 | this.Load | FP00607_ExcelPopup.cs:276 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00607_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64e379fb | this.btnButtonList.UsrButtonList_Click_Detected | FP00607_ItemPopup.cs:341 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-e3abb488 | this.btnButtonList.UsrButtonList_Click_Detected | FP00607_ItemPopup.cs:344 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5fd0ec55 | this.btnButtonList.UsrButtonList_Click_Detected | FP00607_ItemPopup.cs:345 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00607_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fd6f31c | this.Load | FP00607_ItemPopup.cs:134 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-44ab9e6a | this.Load | FP00607_ItemPopup.cs:135 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0d676531 | this.Load | FP00607_ItemPopup.cs:136 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00607_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08f214ef | this.Load | FP00607_ItemPopup.cs:129 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00607_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a377553d | Dispose | FP00607_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00607_ItemPopup.Find_Data_Item

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77695417 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:271 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_ADD_LINE") ⇒ FP_Planning.PR_UI_FP00607_ADD_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-8d89b887 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:272 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7a4ce1ad | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:274 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-fcae862f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:275 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1824f623 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:276 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-20611bf3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:277 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-be39d7ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:279 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-094f7418 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:280 | try | DATA_OP | req.Parameters["p_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0e4b6b4c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:281 | try | DATA_OP | req.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d4ef6cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:282 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c2bea18 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:283 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f500321c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:284 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5e4bf488 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:285 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-70eafc1f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:287 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c5726cd0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:288 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4d7386b6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:289 | try | DATA_OP | req.Parameters["p_from_operation_id"] | p_from_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-5b9d8814 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:290 | try | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-431226f1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:291 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4621fb48 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:292 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1981f349 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:294 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d0e0151a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:295 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-84e5b307 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:296 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-564b2541 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:297 | try | DATA_OP | req.Parameters["p_cell_group_code"] | p_cell_group_code | 행/컬럼 값 대입 |  |  |  |
| AC-10e71f7f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:298 | try | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-6a68973e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:299 | try | DATA_OP | req.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-294fe328 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:300 | try | DATA_OP | req.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c005ae9b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:302 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-71f6acc7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:303 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-70627404 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:310 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d04e357 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:208 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2e205896 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:213 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Item("SELECT", "SELECT_ITEM_POPUP") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3b3203d5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:220 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7bba32ed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:223 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6603976a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:225 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-1f3fd39f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:235 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5f5a7958 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00607_ItemPopup.cs:241 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00607_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba1003f3 | this.Load | FP00607_ItemPopup.cs:106 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7294022 | this.Load | FP00607_ItemPopup.cs:108 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_ItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c5a6c44 | this.Load | FP00607_ItemPopup.cs:123 |  | VALUE_SET | txtCellGroup.Text | Filter["TOP_ITEM_ID"] | 컨트롤 값 설정 |  |  |  |

## FP00607_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69ccc0c4 | this.Load | FP00607_ItemPopup.cs:146 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-31c0c88d | this.Load | FP00607_ItemPopup.cs:147 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00607_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0d0c8e9 | (진입점 미연결) | FP00607_ItemPopup.cs:167 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00607_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03990ff4 | this.Load | FP00607_ItemPopup.cs:153 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3839d3be | this.Load | FP00607_ItemPopup.cs:154 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-ea0cab79 | this.Load | FP00607_ItemPopup.cs:158 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-2179b7a0 | this.Load | FP00607_ItemPopup.cs:161 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-e9bea365 | this.Load | FP00607_ItemPopup.cs:162 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.SITE_ID), false) | 그리드 표시 설정 |  |  |  |

## FP00607_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9645e35b | this.spdMain.CellClick | FP00607_ItemPopup.cs:356 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e84fbfaa | this.spdMain.CellClick | FP00607_ItemPopup.cs:357 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6d16b01f | this.spdMain.CellClick | FP00607_ItemPopup.cs:360 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00607_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5659d8a9 | this.spdMain.CellDoubleClick | FP00607_ItemPopup.cs:366 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-f82b4df5 | this.spdMain.CellDoubleClick | FP00607_ItemPopup.cs:367 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d93d3725 | this.spdMain.CellDoubleClick | FP00607_ItemPopup.cs:370 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-f0b47dac | this.spdMain.CellDoubleClick | FP00607_ItemPopup.cs:373 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6367f860 | this.spdMain.CellDoubleClick | FP00607_ItemPopup.cs:383 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00607_LineAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78c784f9 | .ctor | FP00607_LineAddPopup.cs:70 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-4820f4cb | .ctor | FP00607_LineAddPopup.cs:71 |  | FLAG | this.InitRow | initRow | 화면 필드/플래그 변경 |  |  |  |

## FP00607_LineAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-727e8ab6 | this.btnClose.Click | FP00607_LineAddPopup.cs:296 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00607_LineAddPopup.btnLine_Click

진입점: this.btnLine.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3114281b | this.btnLine.Click | FP00607_LineAddPopup.cs:734 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert material value") | 메시지 표시 |  |  |  |
| AC-a35ff86d | this.btnLine.Click | FP00607_LineAddPopup.cs:735 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68cb9e26 | this.btnLine.Click | FP00607_LineAddPopup.cs:738 |  | DATA_OP | Filter["DATE"] | dpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b6082941 | this.btnLine.Click | FP00607_LineAddPopup.cs:742 | if (string.IsNullOrWhiteSpace(Filter["DATE"].ToString())) | MESSAGE | MessageBox.Show | ("Please Choose Date value") | 메시지 표시 |  |  |  |
| AC-d2983f65 | this.btnLine.Click | FP00607_LineAddPopup.cs:743 | if (string.IsNullOrWhiteSpace(Filter["DATE"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e8700e2d | this.btnLine.Click | FP00607_LineAddPopup.cs:746 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3efaec44 | this.btnLine.Click | FP00607_LineAddPopup.cs:752 | if (dtCurrWeek != null) ▸ if (dtCurrWeek.Rows.Count > 0) | DATA_OP | Filter["RELEASE_VALUE"] | dtCurrWeek.Rows[0]["RELEASE_VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ea59071 | this.btnLine.Click | FP00607_LineAddPopup.cs:757 |  | POPUP | new FP00594_LinePopup | () | 팝업/폼 생성 |  |  |  |
| AC-40ff2148 | this.btnLine.Click | FP00607_LineAddPopup.cs:758 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-a1cead61 | this.btnLine.Click | FP00607_LineAddPopup.cs:759 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-4b9e5463 | this.btnLine.Click | FP00607_LineAddPopup.cs:761 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-380b9e15 | this.btnLine.Click | FP00607_LineAddPopup.cs:762 |  | DATA_OP | popup.Filter["PLAN_DATE"] | Filter["DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-754c797c | this.btnLine.Click | FP00607_LineAddPopup.cs:763 |  | DATA_OP | popup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e2c9fe43 | this.btnLine.Click | FP00607_LineAddPopup.cs:764 |  | DATA_OP | popup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6ac08b5e | this.btnLine.Click | FP00607_LineAddPopup.cs:765 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-47ce0f37 | this.btnLine.Click | FP00607_LineAddPopup.cs:766 |  | DATA_OP | popup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-651b74a4 | this.btnLine.Click | FP00607_LineAddPopup.cs:767 |  | DATA_OP | popup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-75c6aff1 | this.btnLine.Click | FP00607_LineAddPopup.cs:768 |  | DATA_OP | popup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-47f2cd97 | this.btnLine.Click | FP00607_LineAddPopup.cs:769 |  | DATA_OP | popup.Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-3335631f | this.btnLine.Click | FP00607_LineAddPopup.cs:770 |  | DATA_OP | popup.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-bc910ebe | this.btnLine.Click | FP00607_LineAddPopup.cs:771 |  | DATA_OP | popup.Filter["RELEASE_VALUE"] | Filter["RELEASE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8c44d660 | this.btnLine.Click | FP00607_LineAddPopup.cs:772 |  | DATA_OP | popup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-0af39351 | this.btnLine.Click | FP00607_LineAddPopup.cs:773 |  | DATA_OP | popup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-be703f5c | this.btnLine.Click | FP00607_LineAddPopup.cs:774 |  | DATA_OP | popup.Filter["FORM_OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-20f3f6ca | this.btnLine.Click | FP00607_LineAddPopup.cs:775 |  | DATA_OP | popup.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c8acc0e0 | this.btnLine.Click | FP00607_LineAddPopup.cs:778 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3e05e072 | this.btnLine.Click | FP00607_LineAddPopup.cs:780 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c6d0507c | this.btnLine.Click | FP00607_LineAddPopup.cs:785 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["FACTORY_ID"] | txtBuilding.Text = data["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-14278532 | this.btnLine.Click | FP00607_LineAddPopup.cs:785 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtBuilding.Text | data["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-cd1143f7 | this.btnLine.Click | FP00607_LineAddPopup.cs:786 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["OPERATION_ID"] | txtOperation.Text = data["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef9b3ca6 | this.btnLine.Click | FP00607_LineAddPopup.cs:786 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtOperation.Text | data["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-4479e3dd | this.btnLine.Click | FP00607_LineAddPopup.cs:787 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["LINE_ID"] | txtLine.Text = data["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06ad13e1 | this.btnLine.Click | FP00607_LineAddPopup.cs:787 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtLine.Text | data["LINE_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f80162a6 | this.btnLine.Click | FP00607_LineAddPopup.cs:788 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | txtElectrodType.Text = data["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2c982b3d | this.btnLine.Click | FP00607_LineAddPopup.cs:788 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtElectrodType.Text | data["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-1e0ad3b4 | this.btnLine.Click | FP00607_LineAddPopup.cs:789 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | data["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-beaef3d9 | this.btnLine.Click | FP00607_LineAddPopup.cs:790 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["LOCATION"] | txtLocation.Text = data["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-84c17379 | this.btnLine.Click | FP00607_LineAddPopup.cs:790 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtLocation.Text | data["LOCATION"].ToString() | 컨트롤 값 설정 |  |  |  |

## FP00607_LineAddPopup.btnMaterial_Click

진입점: this.btnMaterial.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c043d20 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:676 |  | POPUP | new FP00607_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dcf32461 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:677 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-02b7b854 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:678 |  | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-d924ea1f | this.btnMaterial.Click | FP00607_LineAddPopup.cs:678 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0264491d | this.btnMaterial.Click | FP00607_LineAddPopup.cs:683 |  | DATA_OP | popup.Filter["CELL_GROUP_CODE"] | txtCellGroup.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b78fe6cb | this.btnMaterial.Click | FP00607_LineAddPopup.cs:685 |  | DATA_OP | popup.Filter["FROM_OPERATION_ID"] | "F6000" | 행/컬럼 값 대입 |  |  |  |
| AC-534efdff | this.btnMaterial.Click | FP00607_LineAddPopup.cs:691 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6192486b | this.btnMaterial.Click | FP00607_LineAddPopup.cs:693 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-690377ce | this.btnMaterial.Click | FP00607_LineAddPopup.cs:698 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["CELL_GROUP_CODE"] | txtCellGroup.Text = data["CELL_GROUP_CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ce73b24b | this.btnMaterial.Click | FP00607_LineAddPopup.cs:698 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtCellGroup.Text | data["CELL_GROUP_CODE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-4e8b9034 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:699 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ITEM_ID"] | txtItem.Text = data["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ab13528 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:699 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItem.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5d1c2a61 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:700 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text = data["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2ed36a01 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:700 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtNickName.Text | data["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-86f1c646 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:701 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ITEM_TYPE"] | txtItemType.Text = data["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-076e653d | this.btnMaterial.Click | FP00607_LineAddPopup.cs:701 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItemType.Text | data["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-c498020b | this.btnMaterial.Click | FP00607_LineAddPopup.cs:702 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["TOP_ITEM_ID"] | data["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-36aa16ac | this.btnMaterial.Click | FP00607_LineAddPopup.cs:704 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtBuilding.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-c41b52f2 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:705 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtOperation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-e4228af1 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:706 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtLine.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-f2dee467 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:707 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtElectrodType.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-a4ce06fd | this.btnMaterial.Click | FP00607_LineAddPopup.cs:708 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtLocation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-57050f57 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:710 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ce9022e7 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:711 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1eda4561 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:712 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("LINE_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-504e8b3b | this.btnMaterial.Click | FP00607_LineAddPopup.cs:713 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-19b50d9b | this.btnMaterial.Click | FP00607_LineAddPopup.cs:714 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("LOCATION", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-647b63a5 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:716 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["FACTORY_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0ae48056 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:717 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["OPERATION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0812f003 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:718 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["LINE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e63117a7 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:719 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0d157603 | this.btnMaterial.Click | FP00607_LineAddPopup.cs:720 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["LOCATION"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00607_LineAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d58dfc6a | this.btnSave.Click | FP00607_LineAddPopup.cs:289 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00607_LineAddPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1ffe61f | this.btnSql.Click | FP00607_LineAddPopup.cs:805 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-43916501 | this.btnSql.Click | FP00607_LineAddPopup.cs:808 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ed4207e3 | this.btnSql.Click | FP00607_LineAddPopup.cs:809 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-55c46e06 | this.btnSql.Click | FP00607_LineAddPopup.cs:811 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00607_ADD_LINE_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-53b914d7 | this.btnSql.Click | FP00607_LineAddPopup.cs:812 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00607_ADD_LINE_SAVE_LOG") | 데이터 객체 조작/조회 |  |  |  |
| AC-c994cd0b | this.btnSql.Click | FP00607_LineAddPopup.cs:813 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00607_LineAddPopup.CbMPP_CheckedChanged

진입점: cbMPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4753d75f | cbMPP.CheckedChanged | FP00607_LineAddPopup.cs:249 | if (cbMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-40970bf9 | cbMPP.CheckedChanged | FP00607_LineAddPopup.cs:250 | if (cbMPP.Checked == true) | VALUE_SET | cbWPP.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-4fa8734e | cbMPP.CheckedChanged | FP00607_LineAddPopup.cs:254 | else of (cbMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-5d4fb6c7 | cbMPP.CheckedChanged | FP00607_LineAddPopup.cs:255 | else of (cbMPP.Checked == true) | VALUE_SET | cbWPP.Checked | true | 컨트롤 값 설정 |  |  |  |

## FP00607_LineAddPopup.CbWPP_CheckedChanged

진입점: cbWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bc26e78 | cbWPP.CheckedChanged | FP00607_LineAddPopup.cs:269 | if (cbWPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-dfa1a57f | cbWPP.CheckedChanged | FP00607_LineAddPopup.cs:270 | if (cbWPP.Checked == true) | VALUE_SET | cbMPP.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-5bf55088 | cbWPP.CheckedChanged | FP00607_LineAddPopup.cs:274 | else of (cbWPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-847346cc | cbWPP.CheckedChanged | FP00607_LineAddPopup.cs:275 | else of (cbWPP.Checked == true) | VALUE_SET | cbMPP.Checked | true | 컨트롤 값 설정 |  |  |  |

## FP00607_LineAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce58941f | this.btnSave.Click | FP00607_LineAddPopup.cs:307 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | MESSAGE | MessageBox.Show | ("You need to select line data") | 메시지 표시 |  |  |  |
| AC-358eaa8b | this.btnSave.Click | FP00607_LineAddPopup.cs:308 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b3b7416a | this.btnSave.Click | FP00607_LineAddPopup.cs:312 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | MESSAGE | MessageBox.Show | ("You need to specify quantity") | 메시지 표시 |  |  |  |
| AC-56bba29d | this.btnSave.Click | FP00607_LineAddPopup.cs:313 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-992b77bf | this.btnSave.Click | FP00607_LineAddPopup.cs:321 | catch () | MESSAGE | MessageBox.Show | ("You shoud insert quantity as number") | 메시지 표시 |  |  |  |
| AC-949c2f62 | this.btnSave.Click | FP00607_LineAddPopup.cs:322 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-74b050c5 | this.btnSave.Click | FP00607_LineAddPopup.cs:342 | if (!string.IsNullOrEmpty(sMsg)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f3b68eb7 | this.btnSave.Click | FP00607_LineAddPopup.cs:343 | if (!string.IsNullOrEmpty(sMsg)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c288514d | this.btnSave.Click | FP00607_LineAddPopup.cs:346 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00607_LineAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11166484 | Dispose | FP00607_LineAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00607_LineAddPopup.dpPlanDate_ValueChanged

진입점: this.dpPlanDate.ValueChanged / dpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f2e3a43 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:626 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PlanControl", "check_plan_date_limit", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=check_plan_date_limit] \| FP\Pl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e391d1c2 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:632 | if (dtCheckPlanDate.Good()) | CALL_EXT | DateTime.TryParseExact | (nn, "yyyyMMdd", enUS, System.Globalization.DateTimeStyles.None, out fixDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-208b2288 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:638 | if (dtCheckPlanDate.Good()) ▸ if (dpPlanDate.Value < fixDate) | MESSAGE | MessageBox.Show | (string.Format("Instance Fix Limit is applied. You cannot change data before {0}", fixDate… | 메시지 표시 |  |  |  |
| AC-c442c488 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:639 | if (dtCheckPlanDate.Good()) ▸ if (dpPlanDate.Value < fixDate) | VALUE_SET | dpPlanDate.Value | fixDate | 컨트롤 값 설정 |  |  |  |
| AC-12022c11 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:645 | if (!Cancel) | VALUE_CLEAR | txtCellGroup.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-5cd7e09b | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:646 | if (!Cancel) | VALUE_CLEAR | txtItem.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-ecb03641 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:647 | if (!Cancel) | VALUE_CLEAR | txtNickName.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-0147a7dd | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:648 | if (!Cancel) | VALUE_CLEAR | txtItemType.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-702bfeac | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:649 | if (!Cancel) | VALUE_CLEAR | txtBuilding.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-d01cc7f9 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:650 | if (!Cancel) | VALUE_CLEAR | txtOperation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-1af69781 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:651 | if (!Cancel) | VALUE_CLEAR | txtLine.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-462e20ac | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:652 | if (!Cancel) | VALUE_CLEAR | txtElectrodType.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-f365879e | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:653 | if (!Cancel) | VALUE_CLEAR | txtLocation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-ac853bfe | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:654 | if (!Cancel) | VALUE_CLEAR | txtQty.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-fb9ec9ff | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:656 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f2a2b53b | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:657 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("SITE_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-46d3d756 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:658 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("PLANT_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c0303d65 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:659 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-955ef52b | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:660 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a30359c5 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:661 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("ITEM_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1b7c0467 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:662 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("NICK_NAME", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-832a8e02 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:663 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-058304bb | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:664 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3396b52d | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:665 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("LINE_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0d01a0c0 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:666 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8db9e600 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:667 | if (!Cancel) | DATA_OP | dtSave.SetFirst | ("LOCATION", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0d2adaa5 | this.dpPlanDate.ValueChanged 외 1 | FP00607_LineAddPopup.cs:670 |  | DATA_OP | Filter["PLAN_DATE"] | dpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00607_LineAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-291917fd | this.Load | FP00607_LineAddPopup.cs:84 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2e7eb702 | this.Load | FP00607_LineAddPopup.cs:86 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f5e4a3b9 | this.Load | FP00607_LineAddPopup.cs:94 |  | FLAG | dtSave | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-d0c80132 | this.Load | FP00607_LineAddPopup.cs:95 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7dd10689 | this.Load | FP00607_LineAddPopup.cs:96 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a06264c | this.Load | FP00607_LineAddPopup.cs:97 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-95d7cb12 | this.Load | FP00607_LineAddPopup.cs:99 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b96e3a58 | this.Load | FP00607_LineAddPopup.cs:100 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e69b566 | this.Load | FP00607_LineAddPopup.cs:101 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3c8f984 | this.Load | FP00607_LineAddPopup.cs:102 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ea07289 | this.Load | FP00607_LineAddPopup.cs:103 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bdccc886 | this.Load | FP00607_LineAddPopup.cs:104 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5423bc8e | this.Load | FP00607_LineAddPopup.cs:105 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("FROM_OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-42d847b7 | this.Load | FP00607_LineAddPopup.cs:106 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eda9a6fa | this.Load | FP00607_LineAddPopup.cs:107 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a1d2fa4 | this.Load | FP00607_LineAddPopup.cs:108 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9381819e | this.Load | FP00607_LineAddPopup.cs:109 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-47554919 | this.Load | FP00607_LineAddPopup.cs:110 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae3dc71b | this.Load | FP00607_LineAddPopup.cs:111 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-809b81b7 | this.Load | FP00607_LineAddPopup.cs:112 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("NICK_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f95efa2 | this.Load | FP00607_LineAddPopup.cs:113 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb360b40 | this.Load | FP00607_LineAddPopup.cs:114 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("MPP_WPP", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1e63671 | this.Load | FP00607_LineAddPopup.cs:116 |  | DATA_OP | dtSave.Rows.Add | (dtSave.NewRow()) | 데이터 객체 조작/조회 |  |  |  |
| AC-73941d22 | this.Load | FP00607_LineAddPopup.cs:116 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |

## FP00607_LineAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08619dfb | this.Load | FP00607_LineAddPopup.cs:132 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-fda08fa3 | this.Load | FP00607_LineAddPopup.cs:136 | if (InitRow== null) | MESSAGE | MessageBox.Show | ("Please select any row before add line") | 메시지 표시 |  |  |  |
| AC-a72209df | this.Load | FP00607_LineAddPopup.cs:137 | if (InitRow== null) | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-213d831f | this.Load | FP00607_LineAddPopup.cs:138 | if (InitRow== null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-271aa467 | this.Load | FP00607_LineAddPopup.cs:141 |  | VALUE_SET | txtCellGroup.Text | Filter["CELL_GROUP_CODE"] = InitRow["CELL_GROUP_CODE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6ff3ee08 | this.Load | FP00607_LineAddPopup.cs:141 |  | DATA_OP | Filter["CELL_GROUP_CODE"] | InitRow["CELL_GROUP_CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-07fd5438 | this.Load | FP00607_LineAddPopup.cs:144 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["PLAN_DATE"] | Filter["DATE"] = DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-2b61b2c0 | this.Load | FP00607_LineAddPopup.cs:144 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-955c9893 | this.Load | FP00607_LineAddPopup.cs:146 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PlanControl", "check_plan_date_limit", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=check_plan_date_limit] \| FP\Pl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-26066a2b | this.Load | FP00607_LineAddPopup.cs:152 | if (dtCheckPlanDate.Good()) | CALL_EXT | DateTime.TryParseExact | (nn, "yyyyMMdd", enUS, System.Globalization.DateTimeStyles.None, out fixDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04c4a365 | this.Load | FP00607_LineAddPopup.cs:153 | if (dtCheckPlanDate.Good()) | CALL_EXT | DateTime.TryParseExact | (Filter["PLAN_DATE"], "yyyyMMdd", enUS, System.Globalization.DateTimeStyles.None, out pDat… | ⚠ 의미 확인 필요 |  |  |  |
| AC-16091800 | this.Load | FP00607_LineAddPopup.cs:157 | if (dtCheckPlanDate.Good()) ▸ if (pDate < fixDate) | VALUE_SET | dpPlanDate.Value | fixDate | 컨트롤 값 설정 |  |  |  |
| AC-21199d02 | this.Load | FP00607_LineAddPopup.cs:159 | if (dtCheckPlanDate.Good()) ▸ else of (pDate < fixDate) | VALUE_SET | dpPlanDate.Value | pDate | 컨트롤 값 설정 |  |  |  |
| AC-e1f85698 | this.Load | FP00607_LineAddPopup.cs:163 | else of (dtCheckPlanDate.Good()) | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-21106f0d | this.Load | FP00607_LineAddPopup.cs:166 |  | VALUE_SET | txtNickName.Text | Filter["NICK_NAME"] = InitRow["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-325679c1 | this.Load | FP00607_LineAddPopup.cs:166 |  | DATA_OP | Filter["NICK_NAME"] | InitRow["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cabcfeb7 | this.Load | FP00607_LineAddPopup.cs:167 |  | VALUE_SET | txtOperation.Text | Filter["OPERATON_ID"] = InitRow["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-e7c11367 | this.Load | FP00607_LineAddPopup.cs:167 |  | DATA_OP | Filter["OPERATON_ID"] | InitRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54696490 | this.Load | FP00607_LineAddPopup.cs:168 |  | VALUE_SET | txtQty.Text | "0" | 컨트롤 값 설정 |  |  |  |
| AC-63793f55 | this.Load | FP00607_LineAddPopup.cs:170 |  | DATA_OP | Filter["PRODUCTION_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-3b6b540d | this.Load | FP00607_LineAddPopup.cs:172 |  | VALUE_SET | txtItemType.Text | Filter["ITEM_TYPE"] = InitRow["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d143cd9f | this.Load | FP00607_LineAddPopup.cs:172 |  | DATA_OP | Filter["ITEM_TYPE"] | InitRow["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-df2aae21 | this.Load | FP00607_LineAddPopup.cs:173 |  | VALUE_SET | txtCellGroup.Text | Filter["TOP_ITEM_ID"] = InitRow["TOP_ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-64d88004 | this.Load | FP00607_LineAddPopup.cs:173 |  | DATA_OP | Filter["TOP_ITEM_ID"] | InitRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4ed5712e | this.Load | FP00607_LineAddPopup.cs:174 |  | VALUE_SET | txtItem.Text | Filter["ITEM_ID"] = InitRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-cabfa77d | this.Load | FP00607_LineAddPopup.cs:174 |  | DATA_OP | Filter["ITEM_ID"] | InitRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-08169325 | this.Load | FP00607_LineAddPopup.cs:175 |  | VALUE_SET | txtBuilding.Text | Filter["FACTORY_ID"] = InitRow["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ff2d1862 | this.Load | FP00607_LineAddPopup.cs:175 |  | DATA_OP | Filter["FACTORY_ID"] | InitRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-931c39ab | this.Load | FP00607_LineAddPopup.cs:176 |  | VALUE_SET | txtElectrodType.Text | Filter["ELECTRODE_TYPE"] = InitRow["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-808f2821 | this.Load | FP00607_LineAddPopup.cs:176 |  | DATA_OP | Filter["ELECTRODE_TYPE"] | InitRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3ccc7887 | this.Load | FP00607_LineAddPopup.cs:177 |  | VALUE_SET | txtLocation.Text | Filter["LOCATION"] = InitRow["LOCATION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-05b6dacc | this.Load | FP00607_LineAddPopup.cs:177 |  | DATA_OP | Filter["LOCATION"] | InitRow["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b6c86821 | this.Load | FP00607_LineAddPopup.cs:182 | if (Filter["PLAN_TYPE"] == "RELEASE") | VALUE_SET | labelTitle.Text | " Add Line - MPP WPP" | 컨트롤 값 설정 |  |  |  |
| AC-89cbfd9d | this.Load | FP00607_LineAddPopup.cs:183 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | layoutControlItem36.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5f31202b | this.Load | FP00607_LineAddPopup.cs:184 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcMPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-cad6486b | this.Load | FP00607_LineAddPopup.cs:185 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-95a89cb6 | this.Load | FP00607_LineAddPopup.cs:187 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-dd6d8dc5 | this.Load | FP00607_LineAddPopup.cs:189 | if (Filter["PLAN_TYPE"] == "RELEASE") | VALUE_SET | cbWPP.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-8e661972 | this.Load | FP00607_LineAddPopup.cs:190 | if (Filter["PLAN_TYPE"] == "RELEASE") | VALUE_SET | cbMPP.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-b7ea82b7 | this.Load | FP00607_LineAddPopup.cs:195 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fd52236d | this.Load | FP00607_LineAddPopup.cs:197 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | layoutControlItem36.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-81643890 | this.Load | FP00607_LineAddPopup.cs:198 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcMPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3e54760f | this.Load | FP00607_LineAddPopup.cs:199 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e86b91a1 | this.Load | FP00607_LineAddPopup.cs:202 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-30ae44ed | this.Load | FP00607_LineAddPopup.cs:203 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cacd6d9f | this.Load | FP00607_LineAddPopup.cs:204 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", Filter["PLAN_DATE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5bbe514e | this.Load | FP00607_LineAddPopup.cs:206 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2e23cf22 | this.Load | FP00607_LineAddPopup.cs:207 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4076e73e | this.Load | FP00607_LineAddPopup.cs:208 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-905a89ed | this.Load | FP00607_LineAddPopup.cs:209 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f8e4556c | this.Load | FP00607_LineAddPopup.cs:210 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", Filter["LINE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d0c00a40 | this.Load | FP00607_LineAddPopup.cs:211 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", Filter["OPERATION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d46673fa | this.Load | FP00607_LineAddPopup.cs:212 |  | DATA_OP | dtSave.SetFirst | ("FROM_OPERATION_ID", Filter["FROM_OPERATION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9c0dab53 | this.Load | FP00607_LineAddPopup.cs:213 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d4b1fdf9 | this.Load | FP00607_LineAddPopup.cs:214 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e58b3524 | this.Load | FP00607_LineAddPopup.cs:215 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e68ebbf5 | this.Load | FP00607_LineAddPopup.cs:216 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", Filter["LOCATION"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0e9901b9 | this.Load | FP00607_LineAddPopup.cs:217 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", Filter["PRODUCTION_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-69a7ce3f | this.Load | FP00607_LineAddPopup.cs:218 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", Filter["ELECTRODE_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-14eb7460 | this.Load | FP00607_LineAddPopup.cs:219 |  | DATA_OP | dtSave.SetFirst | ("CELL_GROUP_CODE", Filter["CELL_GROUP_CODE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8ceb3a38 | this.Load | FP00607_LineAddPopup.cs:220 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2d667024 | this.Load | FP00607_LineAddPopup.cs:226 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-2aa63f18 | this.Load | FP00607_LineAddPopup.cs:227 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c14fec9e | this.Load | FP00607_LineAddPopup.cs:228 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00607_LineAddPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-696ee501 | popSql.OnSql | FP00607_LineAddPopup.cs:838 | if (programID == "PR_UI_FP00607_ADD_LINE_SAVE") ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return Save_Data_Add( "SQL", "INSERT_LINE_MPPWPP"); |  | 처리 중단/반환 |  |  |  |
| AC-b6a90bb2 | popSql.OnSql | FP00607_LineAddPopup.cs:843 | if (programID == "PR_UI_FP00607_ADD_LINE_SAVE") ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return Save_Data_Add("SQL", "INSERT_LINE"); |  | 처리 중단/반환 |  |  |  |
| AC-2a13dfe4 | popSql.OnSql | FP00607_LineAddPopup.cs:854 | if (programID == "PR_UI_FP00607_ADD_LINE_SAVE_LOG") ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return Save_Data_Add("SQL", "INSERT_LINE_MPPWPP_LOG"); |  | 처리 중단/반환 |  |  |  |
| AC-4e262102 | popSql.OnSql | FP00607_LineAddPopup.cs:859 | if (programID == "PR_UI_FP00607_ADD_LINE_SAVE_LOG") ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return Save_Data_Add("SQL", "INSERT_LINE_LOG"); |  | 처리 중단/반환 |  |  |  |
| AC-ad1762d9 | popSql.OnSql | FP00607_LineAddPopup.cs:865 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_LineAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24268e46 | this.btnSave.Click | FP00607_LineAddPopup.cs:360 | if (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_LineAdd_dup", Filter["INSTANCE_ID"], Filter["DATE"], Filter… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23df03aa | this.btnSave.Click | FP00607_LineAddPopup.cs:367 | else of (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_dup", Filter["INSTANCE_ID"], Filter["DATE"], Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-08fa8beb | this.btnSave.Click | FP00607_LineAddPopup.cs:382 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | MESSAGE | MessageBox.Show | ("The Line or detail information is already exists.") | 메시지 표시 |  |  |  |
| AC-86f06ae0 | this.btnSave.Click | FP00607_LineAddPopup.cs:383 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75b7fd82 | this.btnSave.Click | FP00607_LineAddPopup.cs:414 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ac4feec6 | this.btnSave.Click | FP00607_LineAddPopup.cs:426 | if (dtCheckSave != null) ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + strMsg) | 메시지 표시 |  |  |  |
| AC-fa5779a4 | this.btnSave.Click | FP00607_LineAddPopup.cs:427 | if (dtCheckSave != null) ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d112db71 | this.btnSave.Click | FP00607_LineAddPopup.cs:431 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-34e90097 | this.btnSave.Click | FP00607_LineAddPopup.cs:432 |  | DATA_OP | dtSave.SetFirst | ("DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9b6ae039 | this.btnSave.Click | FP00607_LineAddPopup.cs:433 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2b849a2e | this.btnSave.Click | FP00607_LineAddPopup.cs:435 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6a04aefc | this.btnSave.Click | FP00607_LineAddPopup.cs:436 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-13ddf5bc | this.btnSave.Click | FP00607_LineAddPopup.cs:437 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4737374f | this.btnSave.Click | FP00607_LineAddPopup.cs:438 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-27711ce4 | this.btnSave.Click | FP00607_LineAddPopup.cs:439 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", txtLine.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-503ab0f8 | this.btnSave.Click | FP00607_LineAddPopup.cs:440 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", txtOperation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4ff797b7 | this.btnSave.Click | FP00607_LineAddPopup.cs:441 |  | DATA_OP | dtSave.SetFirst | ("FROM_OPERATION_ID", Filter["FROM_OPERATION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a282a5c5 | this.btnSave.Click | FP00607_LineAddPopup.cs:443 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c2576dba | this.btnSave.Click | FP00607_LineAddPopup.cs:444 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ad05a852 | this.btnSave.Click | FP00607_LineAddPopup.cs:445 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-aae37427 | this.btnSave.Click | FP00607_LineAddPopup.cs:446 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e861ef09 | this.btnSave.Click | FP00607_LineAddPopup.cs:447 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", txtLocation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1cce4511 | this.btnSave.Click | FP00607_LineAddPopup.cs:448 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", Filter["PRODUCTION_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5f41dac3 | this.btnSave.Click | FP00607_LineAddPopup.cs:449 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", txtElectrodType.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d5be5bbf | this.btnSave.Click | FP00607_LineAddPopup.cs:450 |  | DATA_OP | dtSave.SetFirst | ("CELL_GROUP_CODE", txtCellGroup.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-accc7d5f | this.btnSave.Click | FP00607_LineAddPopup.cs:451 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8cf27ab3 | this.btnSave.Click | FP00607_LineAddPopup.cs:460 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-a6ef1147 | this.btnSave.Click | FP00607_LineAddPopup.cs:461 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e8ee362 | this.btnSave.Click | FP00607_LineAddPopup.cs:463 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e43c5662 | this.btnSave.Click | FP00607_LineAddPopup.cs:468 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (cbMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-5530fa07 | this.btnSave.Click | FP00607_LineAddPopup.cs:470 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (cbMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-72c69e81 | this.btnSave.Click | FP00607_LineAddPopup.cs:474 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-726662d5 | this.btnSave.Click | FP00607_LineAddPopup.cs:477 |  | DATA_OP | dtSave.SetFirst | ("MPP_WPP", Filter["MPP_WPP"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f2e77db4 | this.btnSave.Click | FP00607_LineAddPopup.cs:490 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f6bedee6 | this.btnSave.Click | FP00607_LineAddPopup.cs:491 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-007d6f8c | this.btnSave.Click | FP00607_LineAddPopup.cs:499 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-eff0047a | this.btnSave.Click | FP00607_LineAddPopup.cs:500 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d7fab8aa | this.btnSave.Click | FP00607_LineAddPopup.cs:513 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-71b638e2 | this.btnSave.Click | FP00607_LineAddPopup.cs:514 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ef12834 | this.btnSave.Click | FP00607_LineAddPopup.cs:522 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-c58887d0 | this.btnSave.Click | FP00607_LineAddPopup.cs:523 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87322dd6 | this.btnSave.Click | FP00607_LineAddPopup.cs:529 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2663e248 | this.btnSave.Click | FP00607_LineAddPopup.cs:531 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-319b8548 | this.btnSave.Click | FP00607_LineAddPopup.cs:532 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00607_LineAddPopup.Save_Data_Add

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE") ▸ if (Filter["PLAN_TYPE"] == "RELEASE")] / this.btnSave.Click [if (Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-226491c9 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:572 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_ADD_LINE") ⇒ FP_Planning.PR_UI_FP00607_ADD_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-ba01f9ac | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:573 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-61af9e93 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:575 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-ff8a3a27 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:576 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-abc1982f | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:577 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-3c4a5c1c | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:578 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-174576a8 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:580 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d16cbf2 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:581 | try | DATA_OP | req.Parameters["p_date"] | p_date | 행/컬럼 값 대입 |  |  |  |
| AC-87e72a2b | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:582 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-091acb0f | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:583 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4bad0407 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:584 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-c6e18e16 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:585 | try | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-0f3f58d2 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:586 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc651100 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:588 | try | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-9fb37b50 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:589 | try | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b7bdb55 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:590 | try | DATA_OP | req.Parameters["p_from_operation_id"] | p_from_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-1c7e6044 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:591 | try | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-06523cbb | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:592 | try | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff194e33 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:593 | try | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-a1c7bf07 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:594 | try | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-0c23c37d | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:595 | try | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-28bff713 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:597 | try | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-f7ee3f01 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:598 | try | DATA_OP | req.Parameters["p_cell_group_code"] | p_cell_group_code | 행/컬럼 값 대입 |  |  |  |
| AC-b58c72b9 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:599 | try | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-8110650b | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:600 | try | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e79b598c | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:601 | try | DATA_OP | req.Parameters["p_mpp_wpp"] | p_mpp_wpp | 행/컬럼 값 대입 |  |  |  |
| AC-66ddefb4 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:604 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3504b288 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:605 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7237605f | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… 외 1 | FP00607_LineAddPopup.cs:612 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_LineAddPopup.SetSaveDataTable

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE") ▸ if (Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b50963d | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:869 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-04d0338c | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:870 |  | DATA_OP | dtSave.SetFirst | ("DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b8304f95 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:871 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ecbf342d | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:873 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-05062c5e | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:874 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-591ac61d | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:875 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-de5d8ad7 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:876 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f103c6c5 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:877 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", txtLine.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8eb561f6 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:878 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", txtOperation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-79740cae | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:879 |  | DATA_OP | dtSave.SetFirst | ("FROM_OPERATION_ID", "F6000") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-95d59655 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:880 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-40a399fc | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:881 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c03fa1c9 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:882 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-67d083c9 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:883 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-38a3a1e6 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:884 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", txtLocation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d73952af | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:885 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", Filter["PRODUCTION_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7de305b6 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:886 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", txtElectrodType.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f9b311d8 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:887 |  | DATA_OP | dtSave.SetFirst | ("CELL_GROUP_CODE", txtCellGroup.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-708165f8 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:888 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b58f29ce | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:898 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-8a0b813e | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:899 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29376386 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:901 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9ea12196 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:906 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (cbMPP.Checked == true) | DATA_OP | dtSave.SetFirst | ("MPP_WPP", "MPP") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-26eb4047 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:908 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (cbMPP.Checked == true) | DATA_OP | dtSave.SetFirst | ("MPP_WPP", "WPP") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-12c43fc1 | popSql.OnSql [if (programID == "PR_UI_FP00607_ADD_LINE_SAVE"… | FP00607_LineAddPopup.cs:912 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dtSave.SetFirst | ("MPP_WPP", "") | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00607_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21ed7573 | .ctor | FP00607_MeasureSetForm_Popup.cs:97 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-ed885d10 | .ctor | FP00607_MeasureSetForm_Popup.cs:98 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-48a4dc23 | .ctor | FP00607_MeasureSetForm_Popup.cs:99 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-383bd72c | .ctor | FP00607_MeasureSetForm_Popup.cs:101 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00607_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9d08d75 | this.btnOK.Click | FP00607_MeasureSetForm_Popup.cs:371 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-fed39e7c | this.btnOK.Click | FP00607_MeasureSetForm_Popup.cs:372 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-39aefcb5 | this.btnOK.Click | FP00607_MeasureSetForm_Popup.cs:379 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-d74fa48b | this.btnOK.Click | FP00607_MeasureSetForm_Popup.cs:380 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00607_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e494c13 | this.btnSet.Click | FP00607_MeasureSetForm_Popup.cs:343 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-53bf72e6 | this.btnSet.Click | FP00607_MeasureSetForm_Popup.cs:344 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-80cc3bb1 | this.btnSet.Click | FP00607_MeasureSetForm_Popup.cs:346 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ace4266a | this.btnSet.Click | FP00607_MeasureSetForm_Popup.cs:347 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-37a15bf4 | this.btnSet.Click | FP00607_MeasureSetForm_Popup.cs:349 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-3bf297cd | this.btnSet.Click | FP00607_MeasureSetForm_Popup.cs:350 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-3d179090 | this.btnSet.Click | FP00607_MeasureSetForm_Popup.cs:351 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00607_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f883436 | Dispose | FP00607_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00607_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f06db07 | this.Load | FP00607_MeasureSetForm_Popup.cs:124 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00607_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd39ce57 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:197 |  | FLAG | dtCategory | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "select_measure", "FP00607_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-924a9b56 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:197 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00607_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0ddfba82 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:199 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-75e0a730 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:200 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-154e405c | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:205 |  | STATE | chk_calAgingQty.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-d414b5a2 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:206 |  | STATE | chk_inqty.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-8ff12aab | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:207 |  | STATE | chk_yield.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-62ddd738 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_past_sales) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffbc53cd | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:233 |  | DATA_OP | ctrls.Add | (chk_target) | 데이터 객체 조작/조회 |  |  |  |
| AC-186f5528 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_cellBiz) | 데이터 객체 조작/조회 |  |  |  |
| AC-7481dfdd | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_packSemi) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ea16eb1 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_shipPlanPlanner) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c6bcbf7 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:238 |  | DATA_OP | ctrls.Add | (chk_carryOver) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0ac9bc6 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_shipResult) | 데이터 객체 조작/조회 |  |  |  |
| AC-7deb1ab6 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd9a5325 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_wip) | 데이터 객체 조작/조회 |  |  |  |
| AC-571098b9 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_wipSim) | 데이터 객체 조작/조회 |  |  |  |
| AC-845aea4b | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:245 |  | DATA_OP | ctrls.Add | (chk_pkgProcDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8f46131 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_wipBD) | 데이터 객체 조작/조회 |  |  |  |
| AC-da98d776 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:248 |  | DATA_OP | ctrls.Add | (chk_wipSimBD) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbf3b884 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:249 |  | DATA_OP | ctrls.Add | (chk_pkgQty) | 데이터 객체 조작/조회 |  |  |  |
| AC-8441e46e | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:251 |  | DATA_OP | ctrls.Add | (chk_wipAD) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cb6cb01 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:252 |  | DATA_OP | ctrls.Add | (chk_wipSimAD) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a4da04f | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:253 |  | DATA_OP | ctrls.Add | (chk_actSim) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e877a7a | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_act) | 데이터 객체 조작/조회 |  |  |  |
| AC-71b832d7 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:256 |  | DATA_OP | ctrls.Add | (chk_calAgingQty) | 데이터 객체 조작/조회 |  |  |  |
| AC-67aa1f97 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:258 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-ebeae016 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:259 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-e49b28e0 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:260 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6915167 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:261 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0444d90 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:262 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-662baf5e | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:263 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-2dfb5b15 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:265 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-695ee908 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:266 |  | DATA_OP | ctrls.Add | (chk_yield) | 데이터 객체 조작/조회 |  |  |  |
| AC-21db6fd1 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:268 |  | DATA_OP | ctrls.Add | (chk_inventory) | 데이터 객체 조작/조회 |  |  |  |
| AC-609da575 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:269 |  | DATA_OP | ctrls.Add | (chk_inventory_simul) | 데이터 객체 조작/조회 |  |  |  |
| AC-80a8d7bf | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:272 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-05133d35 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:273 |  | DATA_OP | ctrls.Add | (chk_total_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-d16cea64 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:276 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-13b0f8f9 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:276 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-91a727ac | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:283 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-f536bda8 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:287 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-44e79580 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:291 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00607_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c37e6959 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_past_sales.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a73aadc6 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_target.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-37435b00 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_cellBiz.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b5f29e23 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_packSemi.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f70b4fc1 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_shipPlanPlanner.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-056320fa | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_carryOver.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-352ecc77 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_shipResult.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e0b2eb1d | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1a464a09 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_wip.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e10ab39c | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_wipSim.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d2f49c3e | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_pkgProcDate.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e9f3b36e | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_wipBD.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-17800087 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_wipSimBD.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-38980aca | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_pkgQty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-174789ed | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_wipAD.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1846b439 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_wipSimAD.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9dd6a8b4 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_actSim.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-131dfe2a | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_act.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e9cb81e2 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_calAgingQty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f2d5c8db | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-602df7a2 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-badfc083 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a320f4c7 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2d10b910 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3511b3a4 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:167 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8f6a88c3 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7e5656dc | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_yield.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-76ed4a7f | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:172 |  | VALUE_SET | chk_inventory.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-137025f8 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:173 |  | VALUE_SET | chk_inventory_simul.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-82d22dfc | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:177 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0f7862e6 | this.Load 외 1 | FP00607_MeasureSetForm_Popup.cs:178 |  | VALUE_SET | chk_total_2.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00607_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c709cd81 | (진입점 미연결) | FP00607_MeasureSetForm_Popup.cs:435 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-6407d4ed | (진입점 미연결) | FP00607_MeasureSetForm_Popup.cs:446 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a045b501 | (진입점 미연결) | FP00607_MeasureSetForm_Popup.cs:457 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00607_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47e491da | this.Load | FP00607_MeasureSetForm_Popup.cs:111 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fcd943dd | this.Load | FP00607_MeasureSetForm_Popup.cs:119 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00607_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a6b5076 | this.btnSet.Click 외 1 | FP00607_MeasureSetForm_Popup.cs:391 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5e97248f | this.btnSet.Click 외 1 | FP00607_MeasureSetForm_Popup.cs:399 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-202b6bd5 | this.btnSet.Click 외 1 | FP00607_MeasureSetForm_Popup.cs:399 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-c216bc2c | this.btnSet.Click 외 1 | FP00607_MeasureSetForm_Popup.cs:416 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-74ce701b | this.btnSet.Click 외 1 | FP00607_MeasureSetForm_Popup.cs:427 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eec30b5 | .ctor | FP00607_PlanAmend_Model_Formation.cs:220 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-583681dc | .ctor | FP00607_PlanAmend_Model_Formation.cs:221 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00607_PlanAmend_Model_Formation.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SELECT") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._Ne…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-510665b0 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1494 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f3f83adb | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1495 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6c58fb7a | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1496 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c8a7e22e | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1497 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ea078256 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1498 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-035dd7c6 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1499 |  | FLAG | dsBoh | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cc547096 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1501 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-97915ec2 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1502 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-9244f371 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1503 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd33a107 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1504 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-14b65197 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1505 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a77aa76a | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1506 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8a7bf38c | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1507 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff9d9b84 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1508 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-552af7bf | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1510 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00607_Amend") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0c54ee67 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1514 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a4956cd5 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1515 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fb5ab0d9 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1516 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d3732b1a | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1517 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4391014b | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1529 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-a602793c | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1536 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-53bc63f9 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1537 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-085e4870 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1538 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-57f36077 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1550 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-e612327c | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1551 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-f9423513 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1552 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-7f2aeac2 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1553 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-25c46e9a | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1554 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-16bb8196 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1555 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-c8e8f356 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1556 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00607_PlanAmend_Model_Formation.ApplyAmendCalendarCondition_ForExcel

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d3a1892 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7475 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cb1ebea9 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7476 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-27d61591 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7477 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d7acc8ed | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7478 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2fa00ef8 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7479 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7334bdfd | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7480 |  | FLAG | dsShorterLT | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8eaecd91 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7493 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f2badb81 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7494 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-adb26ddb | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7495 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-44eb5f7f | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7496 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-952bc186 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7497 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-67cd696d | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7498 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ea7cfeab | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7499 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-49551df0 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7500 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-01da2188 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7505 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00607_Amend") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ab8626cf | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7507 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1ca7a107 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7508 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6395d1df | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7509 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-baec95c9 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7510 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bb086b0c | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7511 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-64256fc1 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7512 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bbb241b2 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7513 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4277556c | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7516 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-70489012 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7517 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-d983ec22 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7518 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-005b95f7 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7519 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-eedd8f4e | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7520 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-8522528e | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7521 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-0cfaf7f5 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7522 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00607_PlanAmend_Model_Formation.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPla…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3140f29a | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1429 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; if (GetFilter("INSTANCE_ID") == "") … | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a361400 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1435 | lambda ▸ if (GetFilter("INSTANCE_ID") == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { SetFilter("INSTANCE_ID", CString.GetCheckedListValue(dtIn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2018d4a8 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1441 | lambda | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //set["USER_ID"] = "chkim.68"; Filter["PLAN_DATE"] = sCal… | ⚠ 의미 확인 필요 |  |  |  |
| AC-922b4eaf | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1444 | lambda ▸ lambda | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-84ba6184 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1445 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e38bbe1e | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1446 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-55a8899b | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1456 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4468934c | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1462 | lambda | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cbo_fpplanid.SelectedIndex >= 0) { Filter["PLAN_ID"] … | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7330290 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1466 | lambda ▸ lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-78abc59a | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1472 | lambda | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_R" | 행/컬럼 값 대입 |  |  |  |
| AC-2fb4891e | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1473 | lambda | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-ba036894 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1474 | lambda | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_FORM_BOR_R" | 행/컬럼 값 대입 |  |  |  |
| AC-14580652 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1475 | lambda | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_FORM_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-ccf35aa5 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1476 | lambda | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_FORM_UTIL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-23e49689 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1480 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_H" | 행/컬럼 값 대입 |  |  |  |
| AC-02548158 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1481 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H" | 행/컬럼 값 대입 |  |  |  |
| AC-912f9aa0 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1482 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_FORM_BOR_H" | 행/컬럼 값 대입 |  |  |  |
| AC-922c8ef4 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1483 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_FORM_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-34070faa | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1484 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_FORM_UTIL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-be685b75 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1487 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0fcd7a5 | this.btnBucket.Click | FP00607_PlanAmend_Model_Formation.cs:3940 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-525c9a5d | this.btnBucket.Click | FP00607_PlanAmend_Model_Formation.cs:3942 |  | POPUP | new FP00599_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-ab8c862d | this.btnBucket.Click | FP00607_PlanAmend_Model_Formation.cs:3943 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fb2d752d | this.btnBucket.Click | FP00607_PlanAmend_Model_Formation.cs:3944 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-f5a65c7b | this.btnBucket.Click | FP00607_PlanAmend_Model_Formation.cs:3945 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-df505256 | this.btnBucket.Click | FP00607_PlanAmend_Model_Formation.cs:3949 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-ccdaea74 | this.btnBucket.Click | FP00607_PlanAmend_Model_Formation.cs:3958 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-92d3217e | this.btnBucket.Click | FP00607_PlanAmend_Model_Formation.cs:3960 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6b2c705d | this.btnBucket.Click | FP00607_PlanAmend_Model_Formation.cs:3963 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7be01e65 | this.btnBucket.Click | FP00607_PlanAmend_Model_Formation.cs:3972 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a857b66d | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3883 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-975b0c4e | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3885 |  | POPUP | new FP00607_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-c3c30f91 | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3886 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-0d2377fe | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3887 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-840b6867 | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3888 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a145fd76 | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3892 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-72cc1177 | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3901 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3873709c | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3903 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9c9d3051 | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3906 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-60e2c7aa | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3915 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6f9d8ed0 | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3920 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-808dee37 | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3923 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-86c482e1 | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3925 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1f38c000 | this.btnCatagory.Click | FP00607_PlanAmend_Model_Formation.cs:3928 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b47155c4 | this.btnColumn.Click | FP00607_PlanAmend_Model_Formation.cs:3856 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-c34c9869 | this.btnColumn.Click | FP00607_PlanAmend_Model_Formation.cs:3859 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-333dc8d5 | this.btnColumn.Click | FP00607_PlanAmend_Model_Formation.cs:3860 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-152e7b4e | this.btnColumn.Click | FP00607_PlanAmend_Model_Formation.cs:3861 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-620db4f1 | this.btnColumn.Click | FP00607_PlanAmend_Model_Formation.cs:3867 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-43492418 | this.btnColumn.Click | FP00607_PlanAmend_Model_Formation.cs:3867 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e8ce4b4 | this.btnColumn.Click | FP00607_PlanAmend_Model_Formation.cs:3868 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-4ee25984 | this.btnColumn.Click | FP00607_PlanAmend_Model_Formation.cs:3874 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnCreatePlan_Click

진입점: this.btnCreatePlan2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1172892f | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4122 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-d9d14b0a | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4123 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-e145949f | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4131 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b7f428e9 | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4132 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1fbf095 | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4142 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c8e8069 | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4144 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-89c35aa9 | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4150 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae879e4e | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4151 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-613736fc | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4156 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3197f5f3 | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4157 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ad64399e | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4160 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ae6aaec | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4161 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cae3725c | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4162 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb2ffc14 | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4168 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-5604f24c | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4171 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-f9746a91 | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4172 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-643a32a3 | this.btnCreatePlan2.Click | FP00607_PlanAmend_Model_Formation.cs:4173 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f3b7098 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4470 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce09750c | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4471 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-06c86dea | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4477 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-f43e1279 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4478 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-371732f1 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4484 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not be uploaded.") | 메시지 표시 |  |  |  |
| AC-7bf22b6f | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4485 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f3783a9 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4491 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-89ccd2a2 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4494 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3c7dd710 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4500 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-01a5c5be | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4501 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b1d6eea | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4502 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd70d29b | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4504 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-822415e6 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4511 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP00607_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-af832d75 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4513 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | this.Filter | 화면 필드/플래그 변경 |  |  |  |
| AC-2732f753 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4516 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.CELL | 속성 DateColumnType 설정 |  |  |  |
| AC-c79a7be8 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4519 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b07b46c7 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4520 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-39be44e8 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4521 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0d2b4705 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4522 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2bf09a38 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4523 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3f10b387 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4524 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4b7eb47b | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4525 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-82e8eb49 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4530 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-00ef061a | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4531 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-fa658fa7 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4532 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-1f3a7127 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4533 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["CELL_GROUP_CODE"] | "Cell Group" | 행/컬럼 값 대입 |  |  |  |
| AC-b3af5a43 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4534 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-91c1079d | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4536 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-9bf2577b | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4537 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-d5665a84 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4539 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-edf31031 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4540 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-dd38d0dc | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4541 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-ba09ed6d | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4542 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-67036ac5 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4543 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-62138274 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4544 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-b57ff1f0 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4545 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-3e138e28 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4546 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-221c646c | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4551 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnSearchData | ExcelPopup_Search_Column | 속성 OnSearchData 설정 |  |  |  |
| AC-ce543a69 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4552 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Column | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-4cb360f9 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4553 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Column | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-50fd9e07 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4554 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-9f6bfec2 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4555 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | FP00599_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-8ceb46fb | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4557 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-4857bd2a | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4559 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9073a97c | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4564 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-25654978 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4579 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ if (Filter["INSTANCE… | POPUP | new Planning.UIL.FP00621_InValidationExcelPopup | ("InvalidationCWSPopup", dsCWAActive, sMsg2) | 팝업/폼 생성 |  |  |  |
| AC-d845cca6 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4580 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ if (Filter["INSTANCE… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5fc1c94d | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4581 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ if (Filter["INSTANCE… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fd7e8d56 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4586 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9c945958 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4596 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP00607_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-69d63f88 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4598 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | this.Filter | 화면 필드/플래그 변경 |  |  |  |
| AC-45f2908f | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4602 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e3f42907 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4603 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-26e222c3 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4604 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1397e343 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4605 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8b8f9458 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4606 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-015ff9a4 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4607 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fea7e0b4 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4608 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d6a15ed8 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4609 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-769a52d2 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4610 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-27db5871 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4614 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-2261dbf4 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4615 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-bec9b411 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4616 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-707e4372 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4617 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["CELL_GROUP_CODE"] | "Cell Group" | 행/컬럼 값 대입 |  |  |  |
| AC-3b90b8af | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4618 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-7d7b8b1b | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4620 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-752cc526 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4621 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-4da25dc1 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4623 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-1b7e354e | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4624 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-4e7c08eb | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4625 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-34eb361d | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4626 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-e8d75ca0 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4627 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-ddf6f5b9 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4628 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-2ee2b20b | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4629 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-1026e4b9 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4630 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-9f8ebac4 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4631 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-e10d4213 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4632 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["QTY"] | "QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-5d869007 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4633 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-61ed77ad | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4637 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnSearchData | ExcelPopup_Search_Row | 속성 OnSearchData 설정 |  |  |  |
| AC-89b5e99b | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4638 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Row | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-317286a0 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4639 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Row | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-82134d8f | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4640 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-0dab0ad4 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4642 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-59483d92 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4644 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a41ed639 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4655 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2ca60b8a | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4670 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | POPUP | new Planning.UIL.FP00621_InValidationExcelPopup | ("InvalidationCWSPopup", dsCWAActive, sMsg2) | 팝업/폼 생성 |  |  |  |
| AC-64b9c377 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4671 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-34dbd232 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4672 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ab7d5dc5 | this.btnExcelImport.Click | FP00607_PlanAmend_Model_Formation.cs:4677 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79ade12e | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4319 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-225e4ef8 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4320 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-631b80e1 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4328 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-154af0c4 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4329 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc114c04 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4335 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-45dca79c | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4336 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-821fd4cf | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4341 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8cdbb66e | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4342 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-34fcc22b | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4343 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c69fb694 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4343 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-310e0a88 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4344 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-3e644fc9 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4345 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-9b4fd83a | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4346 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7142038e | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4346 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7c3d4092 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4347 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c6ee1ae3 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4348 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9ee61de8 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4349 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c513cf72 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4350 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e63e1181 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4351 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-95873b97 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4352 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-33d1033a | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4353 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c40c7513 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4354 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-21022e9a | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4355 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fb04b960 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4357 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-43933df8 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4358 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-88d2b3a1 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4359 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-2bbea511 | this.btnMemo.Click | FP00607_PlanAmend_Model_Formation.cs:4360 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnMenu_Click

진입점: this.btnMenu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12241cd3 | this.btnMenu.Click | FP00607_PlanAmend_Model_Formation.cs:4692 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnMenu, menuPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-e459398f | this.btnMenu.Click | FP00607_PlanAmend_Model_Formation.cs:4692 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnMRP_Click

진입점: this.btnMRP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d07cbd6 | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4066 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-78669a50 | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4067 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-e7ad00f8 | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4075 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-42475282 | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4076 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d0d803ff | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4081 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23bfffec | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4087 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-8f50633c | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4088 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9a0897a | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4094 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-37660e51 | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4095 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc60fb7a | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4101 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-93a1dd69 | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4102 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4afbf129 | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4106 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-e356a7c0 | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4107 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-227f6248 | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4108 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-72ea9ccb | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4110 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-2668e1cb | this.btnMRP.Click | FP00607_PlanAmend_Model_Formation.cs:4114 | if (bExec == true) | MESSAGE | MessageBox.Show | ("MRP Transit Completed!") | 메시지 표시 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnRelease_Click

진입점: this.btnRelease2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f979cdb | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4189 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-9f5dd7c9 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4190 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-23993bd0 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4198 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b082651 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4199 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8eb11109 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4219 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79ce8a8a | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4220 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-479d8cd2 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4223 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_instanceInfo", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b00b0597 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4224 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_planInfo", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a6338995 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4228 | if (dtPlanInfo != null) | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3fad500c | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4235 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c65d45cc | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4239 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-befd64a9 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4240 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f9a59522 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4247 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db0bc727 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4248 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-975332f0 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4255 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-28c810c3 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4258 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5f04b08e | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4260 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-47eb3243 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4266 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3f62d4a | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4267 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b8aa1e42 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4280 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-52c07159 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4281 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c5fdf244 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4293 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-1724d545 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4296 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-8859fe61 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4297 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c4b7baff | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4298 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5ed01030 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4306 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-b87c1102 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4309 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-3e135f74 | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4310 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-57c2965d | this.btnRelease2.Click | FP00607_PlanAmend_Model_Formation.cs:4311 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnRePlan_Click

진입점: this.btnRePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0e3d3ee | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:3987 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-eb728037 | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:3988 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-5fa1ff88 | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:3996 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cbcd3ccc | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:3997 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a229e0df | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4006 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22dc327d | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4007 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da20f49d | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4013 | if (Filter["PLAN_TYPE"] =="RELEASE") | MESSAGE | MessageBox.Show | ("Release Plan cant't Re-Release.!") | 메시지 표시 |  |  |  |
| AC-b6f2d182 | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4014 | if (Filter["PLAN_TYPE"] =="RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c40ddf9 | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4019 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69f01795 | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4024 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4f81357c | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4031 | if (Convert.ToInt32(dtPlanRunFlag.Rows[0]["CNT"].ToString()) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c4621d7b | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4032 | if (Convert.ToInt32(dtPlanRunFlag.Rows[0]["CNT"].ToString()) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d14e5d42 | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4047 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-268c189c | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4050 |  | POPUP | new FP00590_RePlanTotalPopup | (pSite, pInstance, pPlanDate, pPlanID, pPlanType, pComfirmArea, pIsSamePlanID, pUseWoWStat… | 팝업/폼 생성 |  |  |  |
| AC-ccd7ac68 | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4051 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7ca23e98 | this.btnRePlan.Click | FP00607_PlanAmend_Model_Formation.cs:4052 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnSimulation_Click

진입점: this.btnSimulation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfc90c4e | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4370 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-476e22a1 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4371 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-acd21c10 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4379 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0c40dc8 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4380 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cbe2bbcb | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4386 | if (_sSaveAuth != "Y") | MESSAGE | MessageBox.Show | ("Save Authority not have.!") | 메시지 표시 |  |  |  |
| AC-fcc61fe4 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4387 | if (_sSaveAuth != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c62c477d | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4391 | if (Filter["READ_ONLY"].ToString() == "Y") | MESSAGE | MessageBox.Show | ("Release plan can not be calculated.!") | 메시지 표시 |  |  |  |
| AC-d72d6e7b | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4392 | if (Filter["READ_ONLY"].ToString() == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1def1a20 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4398 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "FP Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-983ff580 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4399 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5afffa4 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4403 |  | MESSAGE | MessageBox.Show | ("do you Excution?", "Excute", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-b650523b | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4408 | if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c780793f | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4413 | if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) ▸ if (dtChk.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-cc2a4aaa | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4414 | if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) ▸ if (dtChk.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15c750f4 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4426 | if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) ▸ if (bRtn1) | MESSAGE | MessageBox.Show | ("PSI Calculation Excution Completed.!") | 메시지 표시 |  |  |  |
| AC-3ba35389 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4440 | if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) ▸ if (bRtn1) ▸ if (Filter["INSTANCE_ID"].T… | MESSAGE | MessageBox.Show | ("Activated Stock < 0") | 메시지 표시 |  |  |  |
| AC-07c9c0b8 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4443 | if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) ▸ if (bRtn1) ▸ if (Filter["INSTANCE_ID"].T… | POPUP | new Planning.UIL.FP00621_InValidationExcelPopup | ("InvalidationCWSPopup", dsCWAActive, "") | 팝업/폼 생성 |  |  |  |
| AC-6c6b2ab2 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4444 | if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) ▸ if (bRtn1) ▸ if (Filter["INSTANCE_ID"].T… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-26c8eae5 | this.btnSimulation.Click | FP00607_PlanAmend_Model_Formation.cs:4445 | if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) ▸ if (bRtn1) ▸ if (Filter["INSTANCE_ID"].T… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d48392f1 | this.btnSql.Click | FP00607_PlanAmend_Model_Formation.cs:4700 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a42a44d4 | this.btnSql.Click | FP00607_PlanAmend_Model_Formation.cs:4703 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-25165274 | this.btnSql.Click | FP00607_PlanAmend_Model_Formation.cs:4704 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-da115095 | this.btnSql.Click | FP00607_PlanAmend_Model_Formation.cs:4706 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00607_AMEND_MODEL_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3baf687 | this.btnSql.Click | FP00607_PlanAmend_Model_Formation.cs:4707 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00607_AMEND_MODEL_TOTAL_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d5c7bf2 | this.btnSql.Click | FP00607_PlanAmend_Model_Formation.cs:4708 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00607_AMEND_MODEL_DATA_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1770487 | this.btnSql.Click | FP00607_PlanAmend_Model_Formation.cs:4709 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00607_AMEND_MODEL_BOH_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc76b3c6 | this.btnSql.Click | FP00607_PlanAmend_Model_Formation.cs:4710 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00607_EXCEL_SELECT_COLTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d99871c | this.btnSql.Click | FP00607_PlanAmend_Model_Formation.cs:4711 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00607_EXCEL_SELECT_ROWTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4cf8a221 | this.btnSql.Click | FP00607_PlanAmend_Model_Formation.cs:4712 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00607_SELECT_CWA_MINUS_ACTIVED") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0d95291 | this.btnSql.Click | FP00607_PlanAmend_Model_Formation.cs:4713 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00607_PlanAmend_Model_Formation.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cbbc6f6 | this.btnToggleSave.Click | FP00607_PlanAmend_Model_Formation.cs:3980 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91bbaae9 | this.button1.Click | FP00607_PlanAmend_Model_Formation.cs:4459 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.cbo_fpplanid_changed

진입점: this.Load / cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47253f87 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3669 | if (cbo_fpplanid.Items.Count > 0) ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-e90c63b4 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3670 | if (cbo_fpplanid.Items.Count > 0) ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-876ce2f2 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3677 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-94bf40f4 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3678 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-6dd01f6e | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3697 | if (cbo_fpplanid.Items.Count > 0) ▸ if (sReadyOnly.Equals("Y")) | FLAG | bReadOnly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-82b70b36 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3698 | if (cbo_fpplanid.Items.Count > 0) ▸ if (sReadyOnly.Equals("Y")) | STATE | btnSimulation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9a138379 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3702 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (sReadyOnly.Equals("Y")) | FLAG | bReadOnly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7f485226 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3703 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (sReadyOnly.Equals("Y")) | STATE | btnSimulation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9b8d3ee2 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3707 | if (cbo_fpplanid.Items.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRePlan.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ab45168f | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3709 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRePlan.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-787b339d | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3712 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[selected]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-c0321f5e | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3713 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[selected]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-58b0d6dc | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3714 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[selected]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-3bbdcfd3 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3715 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[selected]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-c7b4477a | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3716 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[selected]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-0de3d004 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3718 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-52e8f6db | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3719 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-a629b06d | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3720 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-e41a6bb3 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3721 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-6c6e81a0 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3722 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-9b319957 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3726 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-f364d265 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3727 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-ddcff71f | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3728 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-6b600fdc | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3729 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-bd8b2be6 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3730 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-b7c75fcb | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3732 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-60443fb5 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3733 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-71cd59a0 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3734 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-b0c7eee7 | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3735 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-0288e7fb | this.Load 외 1 | FP00607_PlanAmend_Model_Formation.cs:3736 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Cbo_fpplanid_MouseClick

진입점: cbo_fpplanid.MouseClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-927544ad | cbo_fpplanid.MouseClick | FP00607_PlanAmend_Model_Formation.cs:323 | if (!Cbo_fpplanid_ClickChk) | UI_PROP | cbo_fpplanid.Cursor | Cursors.WaitCursor | 속성 Cursor 설정 |  |  |  |
| AC-5568bbd2 | cbo_fpplanid.MouseClick | FP00607_PlanAmend_Model_Formation.cs:324 | if (!Cbo_fpplanid_ClickChk) | FLAG | Cbo_fpplanid_ClickChk | true | 화면 필드/플래그 변경 |  |  |  |
| AC-07faef3f | cbo_fpplanid.MouseClick | FP00607_PlanAmend_Model_Formation.cs:329 | if (!Cbo_fpplanid_ClickChk) | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00607_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-7f4b411d | cbo_fpplanid.MouseClick | FP00607_PlanAmend_Model_Formation.cs:329 | if (!Cbo_fpplanid_ClickChk) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-299a58e9 | cbo_fpplanid.MouseClick | FP00607_PlanAmend_Model_Formation.cs:330 | if (!Cbo_fpplanid_ClickChk) | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f0fd54d9 | cbo_fpplanid.MouseClick | FP00607_PlanAmend_Model_Formation.cs:331 | if (!Cbo_fpplanid_ClickChk) | UI_PROP | cbo_fpplanid.Cursor | Cursors.Arrow | 속성 Cursor 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Cbo_fpplanid_MouseDown

진입점: cbo_fpplanid.MouseDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28e00160 | cbo_fpplanid.MouseDown | FP00607_PlanAmend_Model_Formation.cs:315 |  | FLAG | Cbo_fpplanid_ClickChk | false | 화면 필드/플래그 변경 |  |  |  |

## FP00607_PlanAmend_Model_Formation.CheckAndGetMeasure

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y") ▸ if (do_edit_mode)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-386e55b1 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:2294 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-b51647d8 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:2294 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-f0f36d6c | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:2296 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00607_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-88d9719b | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:2296 |  | POPUP | new FP00607_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-3fb3b03b | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:2297 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b339d427 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:2297 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP00607_PlanAmend_Model_Formation.chk_includeSubOp_onchanged

진입점: this.chk_includeSubOp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-889b72a6 | this.chk_includeSubOp.CheckedChanged | FP00607_PlanAmend_Model_Formation.cs:3839 | if (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-185f23c5 | this.chk_includeSubOp.CheckedChanged | FP00607_PlanAmend_Model_Formation.cs:3841 | else of (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |

## FP00607_PlanAmend_Model_Formation.chk_Info_CheckChanged

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fb4807b | this.chk_Info.CheckedChanged | FP00607_PlanAmend_Model_Formation.cs:8767 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a073144 | this.chk_Info.CheckedChanged | FP00607_PlanAmend_Model_Formation.cs:8767 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-49c3de3d | this.chk_Info.CheckedChanged | FP00607_PlanAmend_Model_Formation.cs:8773 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-600576aa | this.chk_Info.CheckedChanged | FP00607_PlanAmend_Model_Formation.cs:8774 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00607_PlanAmend_Model_Formation.CreateEditDataGridDataSet

진입점: SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc2d704b | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7313 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-e900aef4 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7314 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0e67b79 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7315 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e36d250 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7316 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7ac5982 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7317 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-83d35bc9 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7318 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6985dacd | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7319 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-082df8bc | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7320 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-29dd18f2 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7321 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-66bad7bf | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7322 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cd95fb6 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7323 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0082185 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7324 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-237bde83 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7325 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-92559736 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7326 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4626263 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7327 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-20c104a5 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7328 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6429f08 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7329 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9bb494b9 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7330 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a792ac1b | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7331 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CUSTOMER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-274bb909 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7332 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a02037a | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7333 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-60f95f37 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7334 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac6203a0 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7335 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e3b47a6 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7337 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-76adc0fd | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7338 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f58c2cd | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7339 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b3d77fd | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7341 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ACTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d29b536 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7347 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fac6ded | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00607_PlanAmend_Model_Formation.cs:7350 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.CreateEditShipPlanDataTable

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ else of (sCateID.Equals("P_OUT")) ▸ if (sCateID.Equals("S_SHIP_PLAN")) ▸ if (dsMainFiltered.Good()) ▸ if (dtShipPlanSave == null)] / menu_material.Click [if (dsMainFiltere…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96a6c6b1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7266 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-7272395a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7267 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf26a7e2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7268 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-941e4920 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7269 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e032a997 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7270 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6772c0ed | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7271 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-297209a1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7272 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7972ee50 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7273 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-10bbcd1c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7274 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa2caaf2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7275 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-45e4bc53 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7276 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6bbef7c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7277 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-42c94add | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7278 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e9bae03 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7279 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-554fd8af | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7280 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a01f5c5f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7281 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-94fe9330 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7282 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b103fa15 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7283 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-98c81ee1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7284 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-30c26c30 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7285 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SALE_SIMUL_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-27fecc11 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7286 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e95f45c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7287 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ACTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-57476d87 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7289 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.CreateEditShorterLTDataTable

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (dtShorter == null)] / menu_material.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.I…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3734fdaa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7295 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-f6ac549a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7297 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b1848d6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7298 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-43f9c32a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7299 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eed3698f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7300 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c11fa16e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7301 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-59725a0d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7302 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0f965e8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7303 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8d567d3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7304 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-95df4384 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7305 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SHORTER_LT", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ad0a26c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7307 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.CreateExelBufferDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5fc7b7e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7529 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-18e2cc68 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7530 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-08be8a83 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7531 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b10d14ec | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7532 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-94b063ea | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7533 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4052efd2 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7534 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e452f8c | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7535 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a656d80 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7536 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3b9d577 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7537 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b8cfa3b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7538 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf6d008d | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7539 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9beb5f12 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7540 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-270f7516 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7541 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9c4584b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7542 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f75d7ed | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7543 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-51399e7c | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7544 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0b509c2 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7545 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f52b87d6 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7546 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e6da075 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7547 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JOB_ORDER", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f386f42f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7549 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a80300b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2306 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-0206f0a0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2317 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-de8c690c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2318 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-305ae0dd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2331 | if (measure["chk_past_sales"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "S_PAST_SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-70f555f0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2335 | if (measure["chk_target"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "S_NET")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3828b2f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2339 | if (measure["chk_cellBiz"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "S_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-55ab266a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2343 | if (measure["chk_packSemi"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "S_PACK")) | 데이터 객체 조작/조회 |  |  |  |
| AC-271939ef | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2347 | if (measure["chk_shipPlanPlanner"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "S_SHIP_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5276d05b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2352 | if (measure["chk_carryOver"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "S_CARRY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-73440095 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2356 | if (measure["chk_shipResult"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "S_SHIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-496df7f3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2361 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c04a7ea1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2366 | if (measure["chk_wip"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ff91ce4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2370 | if (measure["chk_wipSim"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_AGINGWIPSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cf10397 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2374 | if (measure["chk_pkgProcDate"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_PKGPLANDATE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7e29d8a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2379 | if (measure["chk_wipBD"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WIP_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d83295fd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2383 | if (measure["chk_wipSimBD"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_AGINGWIPSIM_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b049aec | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2387 | if (measure["chk_pkgQty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_PKGQTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e6a4a09 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2392 | if (measure["chk_wipAD"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WIP_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-84d95234 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2396 | if (measure["chk_wipSimAD"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_AGINGWIPSIM_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b26fd6b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2400 | if (measure["chk_actSim"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_ACTSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7a36c1e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2405 | if (measure["chk_act"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_ACT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8c70990 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2409 | if (measure["chk_calAgingQty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_CALAGING")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7254ca04 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2415 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d1fcdfe | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2419 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f072c39e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2423 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f231f55 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2427 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed1fec59 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2431 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-94714b27 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2435 | if (measure["chk_yield"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_YIELD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-573d1865 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2439 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b96494a8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2443 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b207bf84 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2449 | if (measure["chk_inventory"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e891ba4c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2453 | if (measure["chk_inventory_simul"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "I_SIMUL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7062f944 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2460 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "S_PAST_SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e28960f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2461 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "S_NET")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a24dd4df | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2462 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "S_SHIP_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff35c013 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2463 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "S_CARRY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac7024e5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2464 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "S_SHIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ae2e9b0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2465 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-48bcd55f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2466 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c2755b9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2467 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a546fe97 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2468 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-36abcca1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2469 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-21c6ecda | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2470 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e739c841 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2471 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-55e422f7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2472 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3be9cee9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2473 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WIP_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e17f03b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2474 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WIP_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-652d3fa6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2475 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_PKGQTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6d8aad3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2476 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_ACT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5d67407 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2477 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_ACTSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c962a59 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2478 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_AGINGWIPSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a47410d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2479 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_AGINGWIPSIM_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-813494f3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2480 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_AGINGWIPSIM_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-49504046 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2481 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_CALAGING")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b59fca29 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2482 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-77fd8777 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2483 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "I_SIMUL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ae66e9f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2488 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "S_PAST_SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f82c2a7a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2489 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "S_NET")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6519ba5e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2490 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "S_SHIP_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-de55bfb8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2491 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "S_CARRY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ecba4e5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2492 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "S_SHIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-97fcf58f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2493 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4cecdbf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2494 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cb8ae87 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2495 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1445977 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2496 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-faa2a164 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2497 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc9c0274 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2498 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9acc6e67 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2499 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-264e9cf6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2500 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-939e9fe8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2501 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WIP_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f318985 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2502 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WIP_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7817924 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2503 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_PKGQTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-46f58ea5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2504 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_ACT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b2d972e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2505 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_ACTSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-10158bde | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2506 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_AGINGWIPSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c76be9f2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2507 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_AGINGWIPSIM_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-998d3aaa | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2508 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_AGINGWIPSIM_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab2209bd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2509 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_CALAGING")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea2b4255 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2524 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-75a87256 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2531 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-40702415 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2536 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-69ea2759 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2540 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-48c18adc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2542 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54cdc32d | this.Load | FP00607_PlanAmend_Model_Formation.cs:506 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b3dac93a | this.Load | FP00607_PlanAmend_Model_Formation.cs:507 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-a67f475d | this.Load | FP00607_PlanAmend_Model_Formation.cs:508 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00607_PlanAmend_Model_Formation.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7fd7fbe | dCalendar_planrange.ValueChanged | FP00607_PlanAmend_Model_Formation.cs:3813 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9aa6e08f | dCalendar_planrange.ValueChanged | FP00607_PlanAmend_Model_Formation.cs:3819 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-5680f876 | dCalendar_planrange.ValueChanged | FP00607_PlanAmend_Model_Formation.cs:3820 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Delete_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7db572be | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8438 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-38d86652 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8439 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-58319a08 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8441 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-e54f36f0 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8442 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-81310909 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8443 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-f9f7cc40 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8444 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2d911cbe | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8445 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-97c52b87 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8446 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ddc7e874 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8447 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5291c908 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8448 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-45f1e735 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8449 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4b1737f8 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8450 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1bdfbf52 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8452 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dc53cb5a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8460 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-577092cd | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8464 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-5e942ddd | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8465 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-658ba7da | DeleteButton | FP00607_PlanAmend_Model_Formation.cs:933 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00607_PlanAmend_Model_Formation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a6ffdc2 | Dispose | FP00607_PlanAmend_Model_Formation.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00607_PlanAmend_Model_Formation.DrawHeader

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day !=…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8827bf7b | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1651 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-bdb70d17 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1655 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-31cc12e4 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1656 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-96ed1cfc | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1657 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0882f8cd | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1658 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a5e677d | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1659 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-fe3f41b6 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1663 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-027bb706 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1664 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-98203bf1 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1665 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-1b7a213c | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1666 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-f9836698 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1672 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-fca5ae90 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1673 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd4e7c77 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1706 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d1192b7 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1711 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, FPExtensions.DateColumnT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0ab6f53 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1713 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e4ca9ca | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1714 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0da6fc5 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1715 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-49e30197 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1717 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-b696d2f1 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1719 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-03106b28 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1720 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a445e0d | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:1725 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP00607_PlanAmend_Model_Formation.DrawSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-771c328e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1778 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0c31759e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1780 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2aeeb046 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1788 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-344fd955 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1800 | if (dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ed5efbcd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1803 | if (dsMainFiltered.Good()) | CALL_EXT | MemoService.ShowMemo | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |

## FP00607_PlanAmend_Model_Formation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d986961c | EditButton | FP00607_PlanAmend_Model_Formation.cs:942 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-a073f09b | EditButton | FP00607_PlanAmend_Model_Formation.cs:944 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00607_PlanAmend_Model_Formation.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86f7550e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00607_PlanAmend_Model_Formation.cs:4896 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3dba9479 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00607_PlanAmend_Model_Formation.cs:4897 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a218ee2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00607_PlanAmend_Model_Formation.cs:4898 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-06731d2d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00607_PlanAmend_Model_Formation.cs:4900 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b80826e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00607_PlanAmend_Model_Formation.cs:4919 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-d3ba0952 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00607_PlanAmend_Model_Formation.cs:4920 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea57cac8 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:4970 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b470e75d | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:4971 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c21999a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:4972 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-c54be644 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:4974 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a55e26e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:4991 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-6f3f6c40 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:4992 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4543d45e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:4997 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.EditByFunc

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT")] / menu_material.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equals("Y") && sPlanIDTag != "00") ▸ for (j <= nRowEnd) ▸ if ((row_to_test["CATEGORY_ID"].ToString() == "P_OUT" \|\|…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02f7e31a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:4930 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cdf1e642 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:4932 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-674d11ea | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:4933 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-9d97ecd5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:4935 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30f97d8e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:4954 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29f40438 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:4960 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5d60713 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:4962 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.EditCommon

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT")] / menu_material.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equals("Y") && sPlanIDTag != "00") ▸ for (j <= nRowEnd) ▸ if ((row_to_test["CATEGORY_ID"].ToString() == "P_OUT" \|\|…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37cd6c18 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5040 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_AfterDegasLT" , pDivision, pSite, pPlant, pFactory, pLine, … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d2486dcb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5050 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (new_value < n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-95e41817 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5051 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (new_value < n… | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-ff68befe | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5052 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (new_value < n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7106d59d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5057 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-36ed9b11 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5067 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (new_valu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b6d02fa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5071 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (new_valu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e50e6665 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00607_PlanAmend_Model_Formation.cs:1188 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ba6a9bc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00607_PlanAmend_Model_Formation.cs:1192 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d138683c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00607_PlanAmend_Model_Formation.cs:1196 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-78e65ccd | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00607_PlanAmend_Model_Formation.cs:1200 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d1a8b115 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00607_PlanAmend_Model_Formation.cs:3582 |  | EXCEL | ExportExcel | (0,true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00607_PlanAmend_Model_Formation.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22a46eee | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1156 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-680be9f3 | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1157 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-a95ad9e8 | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1158 |  | UI_PROP | select_popup.MergeSelection | ExcelMergeOption.Casecaded | 속성 MergeSelection 설정 |  |  |  |
| AC-d9be302b | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1159 |  | UI_PROP | select_popup.LineSelection | ExcelBorderOption.None | 속성 LineSelection 설정 |  |  |  |
| AC-f7bce569 | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1160 |  | UI_PROP | select_popup.ZeroSelection | ZeroOption.ShowZero | 속성 ZeroSelection 설정 |  |  |  |
| AC-4418e026 | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1162 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5e28f162 | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1166 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-206d1bcb | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1167 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-60aa5176 | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1168 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-d87a17f2 | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1171 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-8bc4ccf9 | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1172 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-d1616f6d | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1173 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-2c6788e0 | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1175 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-b2eb9af9 | ExcelButton | FP00607_PlanAmend_Model_Formation.cs:1176 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.ExcelPopup_BufferValidation_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b804840 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7794 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dea28195 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7797 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b2b22db0 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7798 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9729259e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7799 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d49b5189 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7800 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4d70ea0a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7801 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aea13abd | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7802 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d583b84 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7803 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dcafb035 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7804 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-700c43b3 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7805 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d13cf5a4 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7806 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5be3aa1c | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7807 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-77079c69 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7808 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-34dc74c4 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7809 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aabfbdc2 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7810 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-acc9f538 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7811 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1877375f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7812 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2a6c5b1a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7813 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-475cec9c | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7814 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4d5260ee | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7816 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0630e72 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7825 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba35ced0 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7844 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-82fd1d63 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7849 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c853def9 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7851 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5a2635a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7854 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-6aa70b56 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7862 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f40deb4e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7884 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fb68784f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7887 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9ebcefd7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7888 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b26929bd | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7889 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1eb8d6c7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7890 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-384e9453 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7891 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6e5155c4 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7892 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b48bea4e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7893 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eb60b7cf | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7894 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-048f83b9 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7895 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-665883a5 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7896 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-025dd0f0 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7897 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-30f8f005 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7898 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7dbac490 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7899 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-52212d49 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7900 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3c2dc620 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7901 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-758fd348 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7902 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f066b3dc | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7903 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7e957f5c | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7904 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-842fab77 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7907 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-eda1a400 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7916 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e6d4363 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7940 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc146f72 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7945 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d46ba107 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7947 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-030fbe99 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7950 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-3749b8a6 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7961 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b8978c59 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7966 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-d52fb85c | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7971 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f90f94b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7972 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.ExcelPopup_BufferValidation_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ce1fa5f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8030 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9f165cdd | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8033 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-118b5dd8 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8034 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | data.Tables[0].Rows[i]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-78339547 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8035 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fe8d388e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8036 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c65996ac | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8037 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8291ce07 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8038 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ae9fa8d3 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8039 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-785f732b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8040 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-42cde66f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8041 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f22bc980 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8042 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8a4aa27b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8043 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b9a5f9e8 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8044 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-70baafc3 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8045 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2d6999e8 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8046 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c0a9ff52 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8047 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f2e767cf | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8048 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3ab4cb6f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8049 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f629fd4b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8050 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c5424b36 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8053 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-48a96a97 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8056 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-26ea3677 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8076 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ lambda | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b690f45e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8081 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d229188b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8083 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c52709c | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8086 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) ▸ if (d… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-d181419f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8094 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-93819d4e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8099 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-8b919aae | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8104 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a978448a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8105 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.ExcelPopup_CheckBeforSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33e9bc0a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7563 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-69fd4457 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7571 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62564f02 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7573 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c728ed3d | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7581 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d79d367 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7586 | try ▸ if (dtChk.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-b39743bb | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7587 | try ▸ if (dtChk.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e266a9f7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7592 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-144609ce | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7596 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.ExcelPopup_SaveExcel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-918a984c | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8325 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.ExcelPopup_SaveExcel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73b49301 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8386 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.ExcelPopup_Search_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85dd89ff | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7611 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-f9f942f7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7612 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-561bf7af | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7627 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-f5a0c3e8 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7628 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-1a2c5e56 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7629 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-4ed0f20d | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7631 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-9fe6d05d | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7636 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-76508208 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7638 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.ExcelPopup_Search_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd842d1a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7648 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-de6351ea | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7649 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-535c5cb4 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7665 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-e1376616 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7666 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-c26c47b1 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7667 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-768bede7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7669 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-faf39ec0 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7674 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-b5d031c4 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7676 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Exec_Procedure

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ lambda] / this.btnSimulation.Click [if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes))] / SaveButton [try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7e02f75 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3533 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-612cdb5f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3534 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f422708c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3536 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-d89483e1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3537 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-60abb18f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3538 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6eab9edc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3539 | try | DATA_OP | req.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-9557195b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3540 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-b9029263 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3541 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-245ab475 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3542 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-5976f961 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3543 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4e4c84fb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3544 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-17c3346d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3545 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dab4ef97 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3546 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-04e926c4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3547 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-05139747 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3548 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-293feced | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3549 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c7f3959f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3550 | try | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bccac673 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3551 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-552fbd81 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3552 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6ced1600 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3553 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b6379e22 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3554 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c6d8ee9d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3555 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bbb9e73e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3556 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ce635276 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3557 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f6bbd67 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3558 | try | DATA_OP | req.Parameters["p_customer_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ad501db4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3559 | try | DATA_OP | req.Parameters["p_cell_group"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6b10548d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3560 | try | DATA_OP | req.Parameters["p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-10535e34 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3561 | try | DATA_OP | req.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0322da27 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3562 | try | DATA_OP | req.Parameters["p_shorter_lt_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-499ddb5f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3563 | try | DATA_OP | req.Parameters["p_sale_simul_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7f66447f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3565 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-206524c1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3572 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-4788c484 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00607_PlanAmend_Model_Formation.cs:3576 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Exec_PSI_Calculation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba22df4e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3474 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-583951fc | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3475 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1a2dbd0b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3477 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-71edecda | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3478 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-7c48da10 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3479 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-11f80df5 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3480 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e69c6ad7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3481 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-6e6401ef | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3482 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f2065baf | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3483 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-9c7fa789 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3484 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ce2b8c01 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3485 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-48c3653a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3486 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d1fc1cde | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3487 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f4a20546 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3488 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-54517c14 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3489 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1391d174 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3490 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1092f5b5 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3491 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-31ad6b22 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3492 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-51c7258f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3493 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c8a09de2 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3494 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ad62bf3f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3495 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f699fa10 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3496 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f53d231 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3497 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3934d645 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3498 | try | DATA_OP | req.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9fdcf9ac | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3499 | try | DATA_OP | req.Parameters["p_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-450978bc | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3500 | try | DATA_OP | req.Parameters["p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-61d4fc3e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3501 | try | DATA_OP | req.Parameters["p_cell_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-740e6f48 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3502 | try | DATA_OP | req.Parameters["p_cell_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1cde8c71 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3503 | try | DATA_OP | req.Parameters["p_boh_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c4ae89fc | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3505 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-889b0ccf | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3512 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-30ee40fa | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3516 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SELECT")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c34376a | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1355 | try | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_R" | 행/컬럼 값 대입 |  |  |  |
| AC-96e1da41 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1359 | try ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_H" | 행/컬럼 값 대입 |  |  |  |
| AC-e0a6c13d | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1378 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-0b59b48b | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1379 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1483699e | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1380 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-77903672 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1381 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-29b04bcb | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1382 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5a044b8d | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1383 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4d174b78 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1385 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-80c2f8ea | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1386 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b683f2b1 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1387 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f93eb0ae | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1388 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-95340883 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1389 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bdc71ef5 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1390 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5e367a62 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1391 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-44b0663a | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1392 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b1d503f0 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1393 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2f5b0b5b | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1394 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7b10aafa | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1395 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8163508c | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1396 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-35e6d762 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1397 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b5e32d97 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1398 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-37ecaa57 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1399 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-3afa821d | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1400 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | Filter["NICK_NAME_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-1c792fbd | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1401 | try | DATA_OP | request.Parameters["p_cell_group"] | Filter["CELL_GROUP"] | 행/컬럼 값 대입 |  |  |  |
| AC-d836d56c | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1402 | try | DATA_OP | request.Parameters["p_cell_group_code"] | Filter["CELL_GROUP_CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ba67e02d | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1403 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-a4c28923 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1404 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-7a93a835 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1405 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-e055e4f2 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1406 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-8855fc8a | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1407 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-ea2d69ed | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1408 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-42006778 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1409 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d0789b7d | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1410 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-bec52f34 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1411 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2fc4287c | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1412 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-cb96fd80 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1413 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c6079ea4 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1414 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c67c66cf | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1415 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-5cea6e92 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1417 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-147f381c | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1418 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b274acf5 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SE… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1423 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Find_Data_CWA_Minus_Activated

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MINUS_ACTIVED")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1)] / this.btnSimulation.Click [if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) ▸ if (bRtn1) ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1)] / SaveButton [try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ try ▸ if (Filter["INSTANCE_ID"].ToStr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f2f7c99 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1288 |  | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_R" | 행/컬럼 값 대입 |  |  |  |
| AC-10aa22af | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1292 | if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_H" | 행/컬럼 값 대입 |  |  |  |
| AC-7a7ba5a6 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1298 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP00607_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-ba6b73ec | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1299 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b57d481e | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1300 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-c3edd1cf | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1301 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_CWA_MINUS_ACTIVED" | 행/컬럼 값 대입 |  |  |  |
| AC-e6d659c2 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1302 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-07d9e1d7 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1303 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5785952e | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1305 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-46b4e166 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1306 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dd9ed782 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1307 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2c5fb90a | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1308 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-42823259 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1309 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4fea0f24 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1310 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e47fcd89 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1311 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e99642df | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1312 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-24e0e182 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1313 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cc45cb0f | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1314 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-bc00ca8b | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1315 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-19fcb040 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1316 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-98fbbc17 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1317 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c7c8f374 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1318 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-28d95af3 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1319 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-576d27df | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1320 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | Filter["NICK_NAME_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-54efe4c9 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1321 | try | DATA_OP | request.Parameters["p_cell_group"] | Filter["CELL_GROUP"] | 행/컬럼 값 대입 |  |  |  |
| AC-9049329d | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1322 | try | DATA_OP | request.Parameters["p_cell_group_code"] | Filter["CELL_GROUP_CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f6a5a39d | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1323 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-22826d0d | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1324 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-b72f1930 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1325 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-18cc8415 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1326 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-382a9880 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1327 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-e39d501d | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1328 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-58b3b5c0 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1329 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c65edd30 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1330 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d45276cf | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1331 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1706810d | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1332 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-322e9435 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1333 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-30ffea2f | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1334 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8afa064b | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1335 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-beae0c70 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1337 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9d203a4d | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1338 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-59d6ed95 | popSql.OnSql [if (programID == "PR_UI_FP00607_SELECT_CWA_MIN… 외 3 | FP00607_PlanAmend_Model_Formation.cs:1343 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Find_Data_Excel_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4a42843 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8277 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-6f8f7fa7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8278 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-938af38f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8280 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b9f74c10 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8281 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-530235a9 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8282 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f0a1360 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8283 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9bf73003 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8284 | try | DATA_OP | request.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-931ea895 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8285 | try | DATA_OP | request.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-1a3c1a81 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8286 | try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-f07e40ba | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8287 | try | DATA_OP | request.Parameters["p_site_id"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-d1467c12 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8288 | try | DATA_OP | request.Parameters["p_confirm_area"] | sConfirmArea | 행/컬럼 값 대입 |  |  |  |
| AC-5ad18767 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8289 | try | DATA_OP | request.Parameters["p_release_value"] | sreleaseValue | 행/컬럼 값 대입 |  |  |  |
| AC-cc6b0ad2 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8291 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0d4b58b0 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8293 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-8fb79980 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8298 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Find_Data_Excel_Import

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE") ▸ if (popup != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32a0b49a | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7692 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL | 엔드포인트 요청 생성 |  |  |  |
| AC-38076652 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7693 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6a149fc9 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7695 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-92dfba19 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7696 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ce2a92b6 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7697 | try | DATA_OP | request.Parameters["p_sys_gubun"] | gubun | 행/컬럼 값 대입 |  |  |  |
| AC-bb8be1c1 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7698 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-752a81e6 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7699 | try | DATA_OP | request.Parameters["p_proc_name"] | procedure_name.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-67e82213 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7708 | try ▸ if (dsParameter != null && dsParameter.Rows != null && dsParameter.Rows.Count > 0) | CALL_EXT | param.Keys | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f4f271a | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7722 | try | DATA_OP | request.Parameters["in_columns"] | keys | 행/컬럼 값 대입 |  |  |  |
| AC-637c50ae | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7723 | try | DATA_OP | request.Parameters["in_row"] | values | 행/컬럼 값 대입 |  |  |  |
| AC-41d3ea67 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7724 | try | DATA_OP | request.Parameters["opt_none"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0ab60003 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7726 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fcad0473 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7728 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-1ff43389 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7733 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-3d4433a3 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 1 | FP00607_PlanAmend_Model_Formation.cs:7735 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.FindTotalColorStart

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtP…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-177f45f1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2563 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.FindTotalValue

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TOTAL_SELECT")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCreatePlan2.Click [if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39af6849 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1223 | try | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_R" | 행/컬럼 값 대입 |  |  |  |
| AC-cdc44fdd | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1227 | try ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_H" | 행/컬럼 값 대입 |  |  |  |
| AC-9b3184ba | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1232 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-ae348d3d | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1233 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-76564525 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1234 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_TOTAL_VALUE" | 행/컬럼 값 대입 |  |  |  |
| AC-3ef6f885 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1235 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-976a96e0 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1236 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ae443c04 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1238 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a8f56ff5 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1239 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-52497154 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1240 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a9dfcecb | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1241 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e1116007 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1242 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f5c92261 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1243 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a8cf2989 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1244 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bb2f8f5e | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1245 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-361a4685 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1246 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b5fc19c0 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1247 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-afa8e1bf | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1248 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-39677832 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1249 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-059544ad | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1250 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6029bff6 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1251 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e96e3ec1 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1252 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-b68eefd3 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1253 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | Filter["NICK_NAME_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-168ec70b | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1254 | try | DATA_OP | request.Parameters["p_cell_group"] | Filter["CELL_GROUP"] | 행/컬럼 값 대입 |  |  |  |
| AC-d411fffb | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1255 | try | DATA_OP | request.Parameters["p_cell_group_code"] | Filter["CELL_GROUP_CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-717ea6d3 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1256 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-ba2dcfc5 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1257 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-653f15ec | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1258 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-67c1f3e6 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1259 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-d9ac6d30 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1260 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-3e743892 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1261 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-778b624d | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1262 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-dc4a4974 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1263 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-3c11cfa3 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1264 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2d7b5009 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1265 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-82df297e | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1266 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-82bed161 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1267 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ac192dc6 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1268 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-364c7e25 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1270 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1d6594b3 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1273 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-53eb1c50 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 8 | FP00607_PlanAmend_Model_Formation.cs:1281 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6df3cec | this.Load | FP00607_PlanAmend_Model_Formation.cs:237 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_PlanAmend_Model_Formation.FP00599_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fbc882b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8474 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TOTAL_SELECT") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnSimulation.Click [if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) ▸ if (dsShorterLT.Tab…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-901d55d4 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TO… 외 10 | FP00607_PlanAmend_Model_Formation.cs:5497 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.GetListDataSet

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCreatePlan2.Click [if (po…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2abe56c | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1562 |  | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_R" | 행/컬럼 값 대입 |  |  |  |
| AC-fada105e | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1566 | if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_H" | 행/컬럼 값 대입 |  |  |  |
| AC-c385346b | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1569 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_ListData", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1dc788db | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1571 |  | FLAG | dsListData | dtList.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ff90cc5c | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1571 |  | DATA_OP | dtList.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e973e31a | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1573 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_ListData_BOH", Filter["INSTANCE_ID"].ToString(), Filter["PL… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aaf34d8e | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1575 |  | FLAG | dsBoh | dtBoh.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-e1942986 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1575 |  | DATA_OP | dtBoh.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b1045b58 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1577 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_ListData_LT", Filter["DIVISION_ID"].ToString(), Filter["SIT… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0332942e | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1579 |  | FLAG | dsShorterLT | dtShorter.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6421e202 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1579 |  | DATA_OP | dtShorter.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-211f7fd7 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1581 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_accumQTY") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e575af63 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1582 |  | FLAG | dsAccumQty | dtAccum.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f86b083 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1582 |  | DATA_OP | dtAccum.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1cb6ea60 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1584 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_operationBOD", Filter["DIVISION_ID"].ToString(), Filter["SI… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f2545fee | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1586 |  | FLAG | dsBodLT | dtBod.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-720b0675 | popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_C… 외 9 | FP00607_PlanAmend_Model_Formation.cs:1586 |  | DATA_OP | dtBod.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP00607_PlanAmend_Model_Formation.GetOperation

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16a159c5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9032 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-81bbb3b4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9032 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d04dbb88 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9034 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00607_PlanAmend_Model_Formation.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97470267 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7258 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-c10e1eae | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:7259 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.GetToDay

진입점: sCalendar_planday.DateTimeChanged / popSql.OnSql [if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE") ▸ lambda ▸ else of (dt != null)] / this.btnExcelImport.Click [else of (dt != null)] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda ▸ else of (dt != null)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lamb…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f1bb15a | sCalendar_planday.DateTimeChanged 외 10 | FP00607_PlanAmend_Model_Formation.cs:5757 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-a5942191 | sCalendar_planday.DateTimeChanged 외 10 | FP00607_PlanAmend_Model_Formation.cs:5758 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70ab69fe | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1947 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8fbb8b76 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1984 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolnames[k] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-71af5721 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1985 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolidxs[k] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-d6778709 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2022 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f2f6bb2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2028 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-92dfb845 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2041 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5bcb0958 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2052 | else of (do_edit_mode) ▸ if (c != null) | CALL_EXT | siMain.LockRangeColor | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c56c436 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2069 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (calendar != null) ▸ foreach (var week_item in calendar.Weeks) ▸ if (wee… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-6d4c90cf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2086 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (m… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.GoEditModeShortLT

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71f88140 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2106 | if (Filter["PLAN_TYPE"] == "RELEASE" \|\| bReadOnly == true \|\| sPlanIDTag == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18162772 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2121 | if (current_src != null) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-536294d8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2207 | if (current_src != null) ▸ if (colindex != -1) ▸ foreach (DataRow row in current_src.Rows) ▸ if (S_ROW == "1") ▸ if (nEndRow >= 0 && nStartR… | CALL_EXT | siMain.LockRangeColor | (nStartRow, colindex, nEndRow, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e082f5c2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2218 | if (current_src != null) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP00607_PlanAmend_Model_Formation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea5efefc | this.Load | FP00607_PlanAmend_Model_Formation.cs:345 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-faa4e570 | this.Load | FP00607_PlanAmend_Model_Formation.cs:349 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-de1b9c15 | this.Load | FP00607_PlanAmend_Model_Formation.cs:350 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-47955931 | this.Load | FP00607_PlanAmend_Model_Formation.cs:354 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-0d147472 | this.Load | FP00607_PlanAmend_Model_Formation.cs:356 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-33195ddf | this.Load | FP00607_PlanAmend_Model_Formation.cs:360 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e23e15b | this.Load | FP00607_PlanAmend_Model_Formation.cs:368 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7556bebb | this.Load | FP00607_PlanAmend_Model_Formation.cs:375 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-c723fb21 | this.Load | FP00607_PlanAmend_Model_Formation.cs:377 | try | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-675d5deb | this.Load | FP00607_PlanAmend_Model_Formation.cs:388 | try | FLAG | _sToDay | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-144a8842 | this.Load | FP00607_PlanAmend_Model_Formation.cs:397 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-6faa594e | this.Load | FP00607_PlanAmend_Model_Formation.cs:398 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-170062b0 | this.Load | FP00607_PlanAmend_Model_Formation.cs:399 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bec039a4 | this.Load | FP00607_PlanAmend_Model_Formation.cs:400 | try ▸ if (adminAuth == false) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f979a0cc | this.Load | FP00607_PlanAmend_Model_Formation.cs:407 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00607_PlanAmend_Model_Formation.InitEditingBuf

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baafb80a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5763 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2b9a33b1 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5764 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-a13483f0 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5765 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-58bfd5d4 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5766 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d7ab9ea3 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5767 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-9c283c19 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5768 |  | FLAG | dlData | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ca144992 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5769 |  | FLAG | dlView | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e472d02e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5770 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-904a38a7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5771 |  | FLAG | dsShorterLT | null | 화면 필드/플래그 변경 |  |  |  |
| AC-19a447aa | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5772 |  | FLAG | dsShipPlan | null | 화면 필드/플래그 변경 |  |  |  |

## FP00607_PlanAmend_Model_Formation.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b1534e2 | this.Load | FP00607_PlanAmend_Model_Formation.cs:278 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5eb170e4 | this.Load | FP00607_PlanAmend_Model_Formation.cs:279 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-90d2cf41 | this.Load | FP00607_PlanAmend_Model_Formation.cs:281 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-8530859f | this.Load | FP00607_PlanAmend_Model_Formation.cs:282 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-05bc447a | this.Load | FP00607_PlanAmend_Model_Formation.cs:283 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-e4021a7c | this.Load | FP00607_PlanAmend_Model_Formation.cs:284 |  | UI_PROP | mcbo_planner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f31a55d7 | this.Load | FP00607_PlanAmend_Model_Formation.cs:285 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.InitSpread

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78747743 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:521 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7bdf0be8 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:522 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f06c3bad | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:524 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b31ab243 | this.Load 외 11 | FP00607_PlanAmend_Model_Formation.cs:528 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Insert_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82f2806a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8116 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00607_EXCELIMPORT", "insert_Excel_buffer", dsData) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-e17b0816 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8120 | try ▸ if (result.Good()) | DATA_OP | result.Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-762332b9 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8132 | try ▸ if (result.Good()) ▸ if (result.Columns.Contains("RESULT")) ▸ else of (result.Rows[0]["RESULT"].ToString().ToUpper() == "SUCCESS") ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9a61347b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8140 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-d0319c10 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8144 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-4d0694e0 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8145 | catch ((Exception ex)) | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Insert_Data_Excel_Buffer_Old

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e4f4557 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8224 | try ▸ if (iCount >0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-89c3599f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8225 | try ▸ if (iCount >0) | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5b3c001e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8227 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-8df45676 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8228 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ce383db4 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8229 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-317030ac | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8230 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-69519f6f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8231 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-a5866dac | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8232 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-b5049abf | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8233 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-5a8edc38 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8234 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-b78dae68 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8235 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1ebb9d29 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8236 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f45867c1 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8237 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-a7a1a565 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8238 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-05c47850 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8239 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-42d50636 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8240 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-95e7b090 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8241 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fab12864 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8242 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-17e1eff3 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8243 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-1bc857d8 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8244 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-699a7145 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8245 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-cb0f282f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8246 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-d6bcde2e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8247 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-3096f855 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8248 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_cell_qty"] | p_cell_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1d4611d7 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8249 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-293b9a4b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8250 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_new_seq_no"] | p_new_seq_no | 행/컬럼 값 대입 |  |  |  |
| AC-d9170a60 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8251 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_mpp_wpp"] | p_mpp_wpp | 행/컬럼 값 대입 |  |  |  |
| AC-a26ec721 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8253 | try ▸ if (iCount >0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d98079f9 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8258 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-b0122a1d | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8262 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-8f89a860 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8264 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77f30d0f | InsertButton | FP00607_PlanAmend_Model_Formation.cs:897 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a03a6f05 | InsertButton | FP00607_PlanAmend_Model_Formation.cs:902 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | MESSAGE | MessageBox.Show | ("Can not be selected [Total] Row.!") | 메시지 표시 |  |  |  |
| AC-d71403df | InsertButton | FP00607_PlanAmend_Model_Formation.cs:903 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9610b058 | InsertButton | FP00607_PlanAmend_Model_Formation.cs:907 | if (row != null) | POPUP | new FP00607_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-2ac5e555 | InsertButton | FP00607_PlanAmend_Model_Formation.cs:908 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-2f07c97b | InsertButton | FP00607_PlanAmend_Model_Formation.cs:908 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-826ab50a | InsertButton | FP00607_PlanAmend_Model_Formation.cs:910 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1f6ef16e | InsertButton | FP00607_PlanAmend_Model_Formation.cs:911 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b8b0c62b | InsertButton | FP00607_PlanAmend_Model_Formation.cs:912 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bceafe73 | InsertButton | FP00607_PlanAmend_Model_Formation.cs:913 | if (row != null) | DATA_OP | popup.Filter["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b26bb43b | InsertButton | FP00607_PlanAmend_Model_Formation.cs:915 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5e1c50a0 | InsertButton | FP00607_PlanAmend_Model_Formation.cs:917 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1bb4bf10 | InsertButton | FP00607_PlanAmend_Model_Formation.cs:925 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00607_PlanAmend_Model_Formation.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5ad2fb6 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:3589 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00607_PlanAmend_Model_Formation.lfn_setAvailability

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (sCateID.Equals("P_OUT")) ▸ if (dsMainFiltered.Good())] / menu_material.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.D…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfa3ae68 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6850 | if (!(measure["chk_act"].Value == "true" \|\| measure["chk_actSim"].Value == "true") \|\| !(measure["chk_outqty"].Value == "true…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-41c77dd0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6913 | for (i < nEndTmp) ▸ if (nRow_Act != -1) | GRID_SET | siMain.ActiveSheet.Cells[nRow_Act, siMain.GetColumnIndex(sCol)].Value | Math.Round(dValue) | 그리드 속성/값 설정 |  |  |  |
| AC-52b2c5fe | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6926 | for (i < nEndTmp) ▸ if (nRow_ActSim != -1) | GRID_SET | siMain.ActiveSheet.Cells[nRow_ActSim, siMain.GetColumnIndex(sCol)].Value | Math.Round(dValue) | 그리드 속성/값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.lfn_setEOH

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (sCateID.Equals("P_OUT")) ▸ if (dsMainFiltered.Good())] / menu_material.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.D…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3273bed | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6503 | if (measure["chk_inventory"].Value != "true" \|\| measure["chk_target"].Value != "true" \|\| measure["chk_carryOver"].Value != "…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5eb8a81a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6605 | while (true) | DATA_OP | arrAssy[arrAssy_idx] | nArrTmp | 행/컬럼 값 대입 |  |  |  |
| AC-52ca28dd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6677 | while (true) | DATA_OP | arrAssy_LT[arrAssy_idx] | nLT_tmp | 행/컬럼 값 대입 |  |  |  |
| AC-ab8a2f78 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6754 | if (bchkExist) | GRID_SET | siMain.ActiveSheet.Cells[nRow_Invt, siMain.GetColumnIndex(sColTmp)].Value | Math.Round(nInvt) | 그리드 속성/값 설정 |  |  |  |
| AC-10730d22 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6821 | while (nColTmp <= nEndTmp) | GRID_SET | siMain.ActiveSheet.Cells[nRow_Invt, siMain.GetColumnIndex(sColTmp)].Value | Math.Round(nInvt) | 그리드 속성/값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.lfn_setEOH_ShipmentPlan

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (sCateID.Equals("P_OUT")) ▸ if (dsMainFiltered.Good())] / menu_material.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.D…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-544b5ec4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6938 | if (measure["chk_inventory_simul"].Value != "true" \|\| measure["chk_shipPlanPlanner"].Value != "true" \|\| measure["chk_carryOv…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c224071 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7037 | while (true) | DATA_OP | arrAssy[arrAssy_idx] | nArrTmp | 행/컬럼 값 대입 |  |  |  |
| AC-d3d80990 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7101 | while (true) | DATA_OP | arrAssy_LT[arrAssy_idx] | nLT_tmp | 행/컬럼 값 대입 |  |  |  |
| AC-2c0cf82b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7172 | if (bchkExist) | GRID_SET | siMain.ActiveSheet.Cells[nRow_Invt, siMain.GetColumnIndex(sColTmp)].Value | Math.Round(nInvt) | 그리드 속성/값 설정 |  |  |  |
| AC-38c5e311 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:7235 | while (nColTmp <= nEndTmp) | GRID_SET | siMain.ActiveSheet.Cells[nRow_Invt, siMain.GetColumnIndex(sColTmp)].Value | Math.Round(nInvt) | 그리드 속성/값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.MakeMemoFontBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c81ecd7b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:2259 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-58277253 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:2263 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |
| AC-89cc9e52 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:2274 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-4f2d722e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:2278 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a25dcd2 | memo_menu.Click | FP00607_PlanAmend_Model_Formation.cs:5428 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b9a8a8d | memo_menu.Click | FP00607_PlanAmend_Model_Formation.cs:5431 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f04afe2 | memo_menu.Click | FP00607_PlanAmend_Model_Formation.cs:5435 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00607_PlanAmend_Model_Formation.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5662b7ff | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5446 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-383626db | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5449 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4976f79 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5467 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4f2247ad | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5468 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-60e38579 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5469 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b17cb0ea | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5470 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-810eedc1 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5471 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-5b6a9e48 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5472 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-626cef16 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5473 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-acb76ac3 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5474 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1468191a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5475 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00607_PlanAmend_Model_Formation.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a85cd99 | bucke_menu.Click | FP00607_PlanAmend_Model_Formation.cs:5153 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53fa1f5f | bucke_menu.Click | FP00607_PlanAmend_Model_Formation.cs:5156 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.onZeroLineMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4031101 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5321 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8191b3ae | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5324 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af88dcc9 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5375 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.onZeroMaterialMenu

진입점: menu_material.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-096a2d5a | menu_material.Click | FP00607_PlanAmend_Model_Formation.cs:5208 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-003f6958 | menu_material.Click | FP00607_PlanAmend_Model_Formation.cs:5211 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ef5f948 | menu_material.Click | FP00607_PlanAmend_Model_Formation.cs:5265 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bb9211d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9008 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-0127c447 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9008 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf55f237 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9010 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-53bfb65e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9011 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-03f72cab | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9011 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a8707bf8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9012 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-84ad3b16 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9013 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dcc55109 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9014 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4bec6a0b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9018 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7b08f4ca | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9020 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-87cf0ecb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:9025 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00607_PlanAmend_Model_Formation.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22b25f3d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8966 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-fb053901 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8967 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-ce2dbaec | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8968 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-608b5e2d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8968 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ad9c98d2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8969 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-96de087b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8970 |  | DATA_OP | frm.Filter["COMPANY_ID"] | row["COMPANY_ID"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-02efde73 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8971 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-985276f6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8972 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d3ba85a1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8976 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ebdde514 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8978 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_PlanAmend_Model_Formation.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8617c7d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8984 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-ece54b26 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8985 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-dfc4aaab | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8986 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-c2fb6042 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8986 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-600aed61 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8987 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-c0073c96 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8988 |  | DATA_OP | frm.Filter["COMPANY_ID"] | row["COMPANY_ID"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-6d0c4074 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8989 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-52fb0c36 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8990 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0067bead | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8994 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-999ce232 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00607_PlanAmend_Model_Formation.cs:8996 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_PlanAmend_Model_Formation.planday_changed

진입점: sCalendar_planday.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e69609a | sCalendar_planday.DateTimeChanged | FP00607_PlanAmend_Model_Formation.cs:3625 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b1c81772 | sCalendar_planday.DateTimeChanged | FP00607_PlanAmend_Model_Formation.cs:3628 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-0297a042 | sCalendar_planday.DateTimeChanged | FP00607_PlanAmend_Model_Formation.cs:3635 | else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Query

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-161417cf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1820 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-34acb9f1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1820 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c450293b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1821 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3cb25d97 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1826 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-657daf97 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1849 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-ca0a2cc3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1855 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-01ec2d98 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1855 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6163a41f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1856 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-c105bae7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1856 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-41144623 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1859 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-6366e735 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1866 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-0a4eaf64 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1871 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33de805c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1872 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb6186e5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1874 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00607_PlanAmend_Model_Formation.RefreshHeadAndBody

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b864dcf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1617 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7d969abb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1633 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-ae6a63df | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1637 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00607_PlanAmend_Model_Formation.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7b6ad8b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1593 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce4d6059 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1593 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-146d2cff | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1595 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-7cbb5655 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1596 |  | FLAG | dsShorterLT | null | 화면 필드/플래그 변경 |  |  |  |
| AC-67a58ad2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1597 |  | FLAG | dsShipPlan | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e8646c16 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1604 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-b5ae72df | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1610 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Run_Parallels

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true)] / SaveButton [try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-774cbe21 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00607_PlanAmend_Model_Formation.cs:955 | lambda ▸ if (!bRtn1) | CALL_BASE | this.Invoke | (new System.Action(delegate () { MessageService.CloseProgress(); })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a33003e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00607_PlanAmend_Model_Formation.cs:957 | lambda ▸ if (!bRtn1) ▸ lambda | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-823f772f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00607_PlanAmend_Model_Formation.cs:959 | lambda ▸ if (!bRtn1) | MESSAGE | MessageBox.Show | ("EXEC_PR_PARALLEL_A is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Info… | 메시지 표시 |  |  |  |
| AC-203d406b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00607_PlanAmend_Model_Formation.cs:966 |  | CALL_EXT | modalThread.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0d83c384 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00607_PlanAmend_Model_Formation.cs:967 |  | CALL_EXT | System.Threading.Thread.Sleep | (500) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8b9d446 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00607_PlanAmend_Model_Formation.cs:973 | lambda ▸ if (!bRtn2) | CALL_BASE | this.Invoke | (new System.Action(delegate () { MessageService.CloseProgress(); })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc3564ba | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00607_PlanAmend_Model_Formation.cs:975 | lambda ▸ if (!bRtn2) ▸ lambda | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ffe6cb96 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00607_PlanAmend_Model_Formation.cs:977 | lambda ▸ if (!bRtn2) | MESSAGE | MessageBox.Show | ("EXEC_PR_PARALLEL_B is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Info… | 메시지 표시 |  |  |  |
| AC-340a0fa0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00607_PlanAmend_Model_Formation.cs:984 |  | CALL_EXT | modalThread2.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-753df3c5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00607_PlanAmend_Model_Formation.cs:985 |  | CALL_EXT | modalThread2.Wait | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-39f2e9b2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00607_PlanAmend_Model_Formation.cs:986 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e054e150 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7358 | if (programID == "PR_UI_FP00607_AMEND_MODEL_SELECT") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-6c23be45 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7363 | if (programID == "PR_UI_FP00607_AMEND_MODEL_TOTAL_SELECT") | RETURN | return FindTotalValue("","SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7f6ee5aa | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7373 | if (programID == "PR_UI_FP00607_AMEND_MODEL_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) | RETURN | return Save_Data_Amend(dtData, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-63036df4 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7377 | if (programID == "PR_UI_FP00607_AMEND_MODEL_DATA_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_OUT_CELL.") | 메시지 표시 |  |  |  |
| AC-609123b3 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7378 | if (programID == "PR_UI_FP00607_AMEND_MODEL_DATA_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8a54241e | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7383 | if (programID == "PR_UI_FP00607_AMEND_MODEL_DATA_SAVE") ▸ else of (dtData != null) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_OUT_CELL.") | 메시지 표시 |  |  |  |
| AC-7a374922 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7384 | if (programID == "PR_UI_FP00607_AMEND_MODEL_DATA_SAVE") ▸ else of (dtData != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-88681e6e | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7393 | if (programID == "PR_UI_FP00607_AMEND_MODEL_SHORTER_LT_SAVE") ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) | DATA_OP | dsShorterLT.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1746b569 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7395 | if (programID == "PR_UI_FP00607_AMEND_MODEL_SHORTER_LT_SAVE") ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) | RETURN | return Save_Data_Shorter(dtData, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7365b2ae | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7399 | if (programID == "PR_UI_FP00607_AMEND_MODEL_SHORTER_LT_SAVE") ▸ else of (dsShorterLT.Tables[0].Rows.Count > 0) | MESSAGE | MessageBox.Show | ("there is no Edit Value of BOH QTY .") | 메시지 표시 |  |  |  |
| AC-a154d1c5 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7400 | if (programID == "PR_UI_FP00607_AMEND_MODEL_SHORTER_LT_SAVE") ▸ else of (dsShorterLT.Tables[0].Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-761408fd | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7411 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE") | POPUP | new FP00607_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4a60942c | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7415 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.DateColumnType | FPExtensions.DateColumnType.CELL | 속성 DateColumnType 설정 |  |  |  |
| AC-b62d74b2 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7417 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-1cffd46b | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7418 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-4c3691f5 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7419 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-a5afcb78 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7421 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-e04e4fcc | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7428 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00607_AMEND_MODEL_EXCEL", Filter… |  | 처리 중단/반환 |  |  |  |
| AC-4d44f604 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7440 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_ROWTYPE") | POPUP | new FP00607_RowExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ccc45391 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7445 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-6c357991 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7446 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-7ccfc741 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7447 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-681f95f0 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7449 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-16357904 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7455 | if (programID == "PR_UI_FP00607_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00607_AMEND_MODEL_EXCEL", Filter… |  | 처리 중단/반환 |  |  |  |
| AC-931871b6 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7462 | if (programID == "PR_UI_FP00607_SELECT_CWA_MINUS_ACTIVED") | RETURN | return Find_Data_CWA_Minus_Activated("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-dc7435e8 | popSql.OnSql | FP00607_PlanAmend_Model_Formation.cs:7465 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Save_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0)] / SaveButton [try ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4efba5a3 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3412 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-85145420 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3413 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-103bff56 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3415 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3325e015 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3416 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-66c6c839 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3417 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-c1860c52 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3418 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-92f514e0 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3419 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-52fff08a | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3420 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-5917d278 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3421 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-3e0aae67 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3422 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-a3ddd3f6 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3423 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8b446bfe | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3424 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-43d2a409 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3425 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-107097db | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3426 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2a87c1f | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3427 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-3528064f | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3428 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-3be5237e | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3429 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-a3d32699 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3430 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-0571a2a7 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3431 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-72c6a60b | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3432 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ee397fa | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3433 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-46dfbcc9 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3434 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-e76dd7bd | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3435 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-c8e4b997 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3436 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-286d7c84 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3437 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_customer_id"] | p_customer_id | 행/컬럼 값 대입 |  |  |  |
| AC-8f9ca200 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3438 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-574420d7 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3439 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-4950d168 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3440 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-0cbc8b01 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3441 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shorter_lt_qty"] | p_shorter_lt_qty | 행/컬럼 값 대입 |  |  |  |
| AC-9ce5cc24 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3442 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sale_simul_qty"] | p_sale_simul_qty | 행/컬럼 값 대입 |  |  |  |
| AC-4f9b51f0 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3444 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-92327493 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3445 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0f728b4d | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3451 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-16a9f1d7 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_DA… 외 1 | FP00607_PlanAmend_Model_Formation.cs:3457 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Save_Data_Excel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ba4a511 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8337 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-2009ce2e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8338 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-76fc0744 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8340 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-8aa0c014 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8341 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-83aa0a44 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8342 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-83fa26f9 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8343 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-897e7acf | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8344 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c2e12a5a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8345 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ccc42b5c | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8346 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-df41e76d | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8347 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-da2a94eb | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8348 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ea732175 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8349 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2e8f8af6 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8351 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5a9c66d4 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8353 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-f5fc5eaf | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8358 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-d6ce36c5 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8360 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Save_Data_Excel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71b9e792 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8398 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-dbe116f3 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8399 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5a79db18 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8401 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-50c357bf | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8402 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-fd3b57c5 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8403 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-396c264e | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8404 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e987269a | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8405 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d7343b9 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8406 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cafa8939 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8407 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f0da4f83 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8408 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d837cebe | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8409 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2013d598 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8410 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b1fdcd02 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8412 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-afb18684 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8414 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-bf1138e6 | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8419 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-b78562fd | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:8421 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Save_Data_ShipPlan

진입점: SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShipPlan.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d5de2be | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2793 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-5823545a | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2794 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ae38db5d | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2796 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-5c8cbc25 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2797 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-dfc26a60 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2798 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-79595fbd | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2799 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d407c218 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2800 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-e2644963 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2801 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-d91dae88 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2802 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-2d8c55ad | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2803 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-68aedb48 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2804 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-eabf6ae4 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2805 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-86aa5c37 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2806 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-1743f953 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2807 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-43e84841 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2808 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-9081e34d | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2809 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa0de39d | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2810 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-20f9d90f | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2811 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-fb5f14bc | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2812 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f113d138 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2813 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0120822c | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2814 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-59e5146c | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2815 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-1b0ea843 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2816 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-69e69760 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2817 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-7041c245 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2818 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_customer_id"] | p_customer_id | 행/컬럼 값 대입 |  |  |  |
| AC-a0da00b9 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2819 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-26280502 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2820 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-5c11a8fd | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2821 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1cda0e7d | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2822 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shorter_lt_qty"] | p_shorter_lt_qty | 행/컬럼 값 대입 |  |  |  |
| AC-9b234b6f | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2823 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sale_simul_qty"] | p_sale_simul_qty | 행/컬럼 값 대입 |  |  |  |
| AC-44a0b4fc | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2825 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-586cb9b0 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2826 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-22abda6e | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2832 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-37f05fb1 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2838 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Save_Data_Shorter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SHORTER_LT_SAVE") ▸ if (dsShorterLT.Tables[0].Rows.Count > 0)] / this.btnSimulation.Click [if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) ▸ try] / SaveButton [try ▸ if (dsShorterLT != null) ▸ try ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75bc1028 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3032 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE") ⇒ FP_Planning.PR_UI_FP00607_AMEND_MODEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-21b8fe60 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3033 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-342b5a14 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3035 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3ee83195 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3036 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-40f1649f | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3037 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-1e1bb577 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3038 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0b9a6b2e | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3039 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-d3a56247 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3040 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-4b674d92 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3041 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-acff2881 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3042 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-77623f87 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3043 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3f7af998 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3044 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-be113eb9 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3045 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-2d0012c1 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3046 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-fbef8c4a | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3047 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-0ce659e5 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3048 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-ccd784c0 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3049 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-ac454ebf | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3050 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-da9ed737 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3051 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-8b12f862 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3052 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ed042a2f | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3053 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-14222b57 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3054 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-2501c5ad | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3055 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-423e011d | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3056 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-b3b59221 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3057 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_customer_id"] | p_customer_id | 행/컬럼 값 대입 |  |  |  |
| AC-a69cd476 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3058 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-58a4e581 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3059 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-19c94520 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3060 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-5e12c543 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3061 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shorter_lt_qty"] | p_shorter_lt_qty | 행/컬럼 값 대입 |  |  |  |
| AC-9e6abbab | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3062 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sale_simul_qty"] | p_sale_simul_qty | 행/컬럼 값 대입 |  |  |  |
| AC-015cc8b5 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3064 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e842ee25 | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3065 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e828bfed | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3071 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2ed32b5f | popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_SH… 외 2 | FP00607_PlanAmend_Model_Formation.cs:3077 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Save_P_Out

진입점: SaveButton [try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0abbf66 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3090 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-039a9adc | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3098 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c8a8301 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3099 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e66bc1d5 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3104 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-48327518 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3116 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0fe38df6 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3128 | try ▸ if (editDs.Good()) ▸ for (i < cnt) ▸ if ((string)row["CATEGORY_ID"] == "P_PKGPLANDATE") | DATA_OP | editDs.Tables[0].Rows.RemoveAt | (cnt - i - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7733c0d | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3136 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save in daily area") | 메시지 표시 |  |  |  |
| AC-e88a8872 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3137 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dd9f5511 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3138 | try ▸ if (!editDs.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78ceb448 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3172 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-25a2cf1e | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3173 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-53a7bbe8 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3174 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a650485 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3175 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e858fe00 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3176 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-72137b15 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3177 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b5de11bb | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3178 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d0cb44d6 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3179 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6e1bf7c | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3180 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-187d79da | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3181 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1cbf31c5 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3182 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-221b46df | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3183 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-443f37ba | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3184 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CUSTOMER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9366334 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3170 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("PLAN_… |  | 처리 중단/반환 |  |  |  |
| AC-ade35eea | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3197 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["IN_QTY"] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-4444e713 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3198 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-d64f7a67 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3199 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-a64b2e68 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3200 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-06d030e7 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3202 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["ORIG_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-088db324 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3203 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["ACTION"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-7f4770c6 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3211 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9c14be37 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3213 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-3dfc69d8 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3214 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-5b688101 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3215 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-f0c21948 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3216 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04bdf76c | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3217 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-466ca816 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3218 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-52a0d786 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3219 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-07539d80 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3220 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FACTORY_ID"] | enum_row_from_Saving["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f7a7690f | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3221 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LINE_ID"] | enum_row_from_Saving["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-691cea58 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3222 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OPERATION_ID"] | enum_row_from_Saving["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fffaffc4 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3223 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["TOP_ITEM_ID"] | enum_row_from_Saving["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d0930e0d | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3224 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_ID"] | enum_row_from_Saving["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-afdb4dd3 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3225 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_TYPE"] | enum_row_from_Saving["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a638c174 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3226 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LOCATION"] | enum_row_from_Saving["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6f583ce8 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3227 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PRODUCTION_TYPE"] | enum_row_from_Saving["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bdc1d4ea | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3228 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MARKET"] | enum_row_from_Saving["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d6c793a5 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3229 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ELECTRODE_TYPE"] | enum_row_from_Saving["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a001ce81 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3230 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CUSTOMER_ID"] | enum_row_from_Saving["CUSTOMER_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-220ab906 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3231 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-038331bf | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3236 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["IN_QTY"] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-02d8f8fe | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3237 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-bc493fb8 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3238 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-c5254024 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3239 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-c8cd3b32 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3241 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORIG_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-fcfd69ab | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3242 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ACTION"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-359cb3d6 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3244 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-576fb096 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3256 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("this data can't save! , Plan type is Release!") | 메시지 표시 |  |  |  |
| AC-0b57acf3 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3257 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a1375c79 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3258 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0324759a | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3261 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6166a28e | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3274 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-60263122 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3275 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b65a00e2 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3278 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1df1ac94 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3307 | try ▸ if (!string.IsNullOrEmpty(sError)) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-b418b1a0 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3311 | try ▸ if (!string.IsNullOrEmpty(sError)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9c08371c | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3314 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-31ad970f | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3318 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aeea255b | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3319 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-628621b7 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3320 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-463320bd | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3321 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-375e676a | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3325 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1ab2d976 | SaveButton [try ▸ try] | FP00607_PlanAmend_Model_Formation.cs:3326 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Save_ShipPlan

진입점: SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShipPlan.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cdabd83 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2612 | if (siMain == null \|\| dtData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04b7f164 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2614 | if (dtData.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-742ddb63 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2618 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7beb8c0a | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2619 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-647c7b76 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2624 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1579b019 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2636 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("this data can't save! , Plan type is Release!") | 메시지 표시 |  |  |  |
| AC-92cf66f8 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2637 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0ab6829e | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2638 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e941779 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2641 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d4be2e27 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2654 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0bd7c56c | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2655 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-653dfc60 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2658 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-33206fbb | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2670 | try ▸ if (dtData.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ed09863 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2688 | try ▸ if (!string.IsNullOrEmpty(sError)) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f9c4ceb1 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2692 | try ▸ if (!string.IsNullOrEmpty(sError)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b7098b2e | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2695 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-74551046 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2699 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-79abcae3 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2700 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-dd662841 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2701 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a806902d | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2702 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-faef82aa | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2706 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6b00a392 | SaveButton [try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShip… | FP00607_PlanAmend_Model_Formation.cs:2707 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_PlanAmend_Model_Formation.Save_Shorter

진입점: this.btnSimulation.Click [if ((MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)) ▸ if (dsShorterLT.Tables[0].Rows.Count > 0)] / SaveButton [try ▸ if (dsShorterLT != null) ▸ try ▸ if (dsShorterLT.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ee896d4 | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2851 | if (siMain == null \|\| dtData == null) | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-070b3623 | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2853 | if (dtData.Rows.Count ==0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff1073c4 | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2857 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-503c481f | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2858 | if (blnWork) | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-76f5d1fa | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2863 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4e556ee6 | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2875 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("this data can't save! , Plan type is Release!") | 메시지 표시 |  |  |  |
| AC-b953577b | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2876 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-08f7abab | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2877 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad268058 | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2880 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ee7c1fff | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2893 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9ce8917b | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2894 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb5bb5c7 | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2897 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b90d9263 | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2909 | try ▸ if (dtData.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-08d19f3d | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2927 | try ▸ if (!string.IsNullOrEmpty(sError)) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-11bc8cb0 | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2931 | try ▸ if (!string.IsNullOrEmpty(sError)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0c26883e | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2934 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-405d722f | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2938 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3a7863c2 | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2939 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-73d2a5f4 | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2940 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-047a0baa | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2941 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c98e81d | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2945 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-70887d0c | this.btnSimulation.Click [if ((MessageBox.Show("do you Excut… 외 1 | FP00607_PlanAmend_Model_Formation.cs:2946 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d0e08c3 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:997 | if (!IsChange) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b97c4fe | SaveButton | FP00607_PlanAmend_Model_Formation.cs:998 | if (!IsChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40c449fc | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1002 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b9d7579 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1003 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c8b44f7e | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1019 | try ▸ try | FLAG | bSaveChk | true | 화면 필드/플래그 변경 |  |  |  |
| AC-33e6988e | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1026 | try ▸ catch ((Exception)) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e78d41a7 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1027 | try ▸ catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-0985d1bb | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1039 | try ▸ if (dsShipPlan != null) ▸ try ▸ if (dsShipPlan.Tables[0].Rows.Count > 0) | FLAG | bSaveChk | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0673b0b6 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1046 | try ▸ if (dsShipPlan != null) ▸ catch ((Exception)) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a282dcfe | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1047 | try ▸ if (dsShipPlan != null) ▸ catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-22659cdf | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1062 | try ▸ if (dsShorterLT != null) ▸ try ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) | FLAG | bSaveChk | true | 화면 필드/플래그 변경 |  |  |  |
| AC-74eff971 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1069 | try ▸ if (dsShorterLT != null) ▸ catch ((Exception)) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7a0763c0 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1070 | try ▸ if (dsShorterLT != null) ▸ catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-cd23abf2 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1080 | try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b693f080 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1094 | try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ try ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1) ▸ if (dsCWAAct… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aa940e16 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1098 | try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ try ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1) ▸ if (dsCWAAct… | POPUP | new Planning.UIL.FP00621_InValidationExcelPopup | ("InvalidationCWSPopup", dsCWAActive, sMsg2) | 팝업/폼 생성 |  |  |  |
| AC-afdd0760 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1099 | try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ try ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1) ▸ if (dsCWAAct… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b29cd2d0 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1100 | try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ try ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1) ▸ if (dsCWAAct… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fb7da86c | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1104 | try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d596929d | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1108 | try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ try ▸ if (bShortSaveChk == true) | GRID_SET | siMain.ActiveSheet.Cells[0, iCol, siMain.GetMaxRowIndex(), iCol].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-f496cf0f | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1114 | try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ catch ((Exception ex2)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-c59f0308 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1118 | try ▸ if (bSaveChk == true \|\| bShortSaveChk == true) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fbc35d8b | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1123 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-de867651 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1127 | try ▸ if (dsShipPlan != null) | STATE_RESET | dsShipPlan.Tables[0].Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-bab78848 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1131 | try ▸ if (dsShorterLT != null) | STATE_RESET | dsShorterLT.Tables[0].Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7ff8f876 | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1141 | try ▸ if (!string.IsNullOrEmpty(sMsg)) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8a63006f | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1146 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-4ac7362d | SaveButton | FP00607_PlanAmend_Model_Formation.cs:1148 |  | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetBasisTime

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cc167cb | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5513 |  | FLAG | dtBaseTime | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findBasisTime", sInstance,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3beae099 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5513 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findBasisTime", sInstance, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetBohTotalQty

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (le…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4ce5516 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2576 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0bb8d989 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2581 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-82848766 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2586 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2c55873 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2587 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2cb56fc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2588 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-310fba76 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2589 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-54885644 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2590 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ff2099a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2591 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0dccad81 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2592 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-551ebc60 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2593 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-09fdd72f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:2597 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetCalenderColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-764dc927 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1893 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3829509 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1897 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-044b3b59 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1899 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-971e5f9e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1903 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-8a216172 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1919 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-80a1eb18 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1934 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetChangeControl

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_planner.SelectedIndexChanged [if (sender !=null)] / cbo_fpplanid.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / mcbo_line.SelectedIndexChanged / chk_allLine.CheckedChanged / this.chk_includeSubOp.CheckedChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a76dac52 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:430 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-23e97873 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:430 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1f40339d | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:435 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | Filter["MASTER_ID"] = sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-9a3b316b | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:435 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-eff9751a | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:439 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-79a84fd2 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:439 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9b2c7ed7 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:440 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cae74c44 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:446 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-7ff7f5ed | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:447 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-25cec5da | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:447 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-54eda1be | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:448 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d1709450 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:454 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, mcbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-e77102a2 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:455 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-8e606487 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:455 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-031472f0 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:456 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8b36c58d | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:462 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-76030c38 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:463 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-f38e76ee | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:463 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b39c23ba | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:464 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fa83d406 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:471 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-1c3a145c | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:472 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b347309 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:472 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0c87ccac | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:473 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-77f5ea0a | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:479 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-85ff5bec | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:480 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d76f52b3 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:480 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8ea7c837 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:481 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-48187e57 | this.Load [try] 외 12 | FP00607_PlanAmend_Model_Formation.cs:487 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetColumnChangeByText

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b736621 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:590 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0fcecd06 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:608 | if (iColMinStartIndex <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f622614b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:613 | try | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-ad5418b7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:615 | try | FLAG | DateCellType | new FarPoint.Win.Spread.CellType.DateTimeCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-f2f3e74e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:617 | try | FLAG | MaskcellType | new FarPoint.Win.Spread.CellType.MaskCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-6a1aa4bd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:618 | try | UI_PROP | MaskcellType.Mask | "####-##-##" | 속성 Mask 설정 |  |  |  |
| AC-30ddc21b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:622 | try | UI_PROP | DateCellType.DateTimeFormat | FarPoint.Win.Spread.CellType.DateTimeFormat.UserDefined | 속성 DateTimeFormat 설정 |  |  |  |
| AC-9ff75baf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:623 | try | UI_PROP | DateCellType.UserDefinedFormat | "yyyy-MM-dd" | 속성 UserDefinedFormat 설정 |  |  |  |
| AC-8ec80f2a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:625 | try | FLAG | NumcellType | new FarPoint.Win.Spread.CellType.NumberCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-458a60c7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:627 | try | UI_PROP | NumcellType.DecimalPlaces | 2 | 속성 DecimalPlaces 설정 |  |  |  |
| AC-6c6ee61a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:628 | try | UI_PROP | NumcellType.Separator | "," | 속성 Separator 설정 |  |  |  |
| AC-ecc6c2f5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:629 | try | UI_PROP | NumcellType.ShowSeparator | true | 속성 ShowSeparator 설정 |  |  |  |
| AC-6807df01 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:640 | try ▸ if (LTidx > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) | GRID_SET | siMain.ActiveSheet.Cells[k, LTidx].CellType | NumcellType | 그리드 속성/값 설정 |  |  |  |
| AC-be1b2c20 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:654 | try ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolnames[i] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-9418be50 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:655 | try ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolidxs[i] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-1f4aaf50 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:681 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-3f2e2552 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:682 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-3a58790c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:686 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].CellType | MaskcellType | 그리드 속성/값 설정 |  |  |  |
| AC-89ecda60 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:688 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].Value | sData | 그리드 속성/값 설정 |  |  |  |
| AC-0fb6acc5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:692 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-2221413c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:693 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-c45b6ec6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:732 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetColumnsFormat

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25b73b4f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1732 | if (siMain != null) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-177919cf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1739 | if (siMain != null) ▸ if (froz > 1) ▸ if (omitZero) | CALL_EXT | siMain.SetColumnFormatDecimalDigit | (3, froz-1, -1, "#,###.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b62b410 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:1743 | if (siMain != null) ▸ if (froz > 1) ▸ else of (omitZero) | CALL_EXT | siMain.SetColumnFormatDecimalDigit | (3, froz - 1, -1, "#,##0.###", "0", false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8d19d36 | this.Load | FP00607_PlanAmend_Model_Formation.cs:257 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca11febc | this.Load | FP00607_PlanAmend_Model_Formation.cs:259 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-ab12f9f9 | this.Load | FP00607_PlanAmend_Model_Formation.cs:263 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-285ae0e4 | this.Load | FP00607_PlanAmend_Model_Formation.cs:265 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-46f70af4 | this.Load | FP00607_PlanAmend_Model_Formation.cs:266 |  | CALL_EXT | UserService.HasSuperRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f532014 | this.Load | FP00607_PlanAmend_Model_Formation.cs:268 | if (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-f1263568 | this.Load | FP00607_PlanAmend_Model_Formation.cs:272 | else of (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetDirty

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT")] / menu_material.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equals("Y") && sPlanIDTag != "00") ▸ for (j <= nRowEnd) ▸ if ((row_to_test["CATEGORY_ID"].ToString() == "P_OUT" \|\|…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bf5f205 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 13 | FP00607_PlanAmend_Model_Formation.cs:5743 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b35691b | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5523 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-914d14dd | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5523 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9f9d5f4f | (진입점 미연결) | FP00607_PlanAmend_Model_Formation.cs:5524 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_planner.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) ▸ if (dtPlanId.Rows.Count > 0)] / cbo_fpplanid.SelectedIndexChanged [if (cbo_fpplanid.Items.Count > 0)] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Go…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3bf3aec | this.Load [try] 외 26 | FP00607_PlanAmend_Model_Formation.cs:5492 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetFpPlanId

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8595e1c2 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5631 |  | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00607_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-92d4dbce | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5631 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd10e65c | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5632 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-226e2651 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5635 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-830a89df | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5637 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | cbo_fpplanid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-2807ee60 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5654 | if (dtPlanId.Rows.Count > 0) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b361766b | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5656 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[0]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-489cb700 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5657 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[0]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-95f39fb4 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5658 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[0]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-1ae9404d | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5659 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[0]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-f07f1e38 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5660 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[0]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-bb3e4669 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5662 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-976faa39 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5663 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-dfa86889 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5664 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-f58098a9 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5665 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-1f5a8a7a | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5666 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-a8488382 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5671 | if (dtPlanId.Rows.Count > 0) ▸ if (dtPlanId.Rows[iDx]["READ_ONLY"].ToString().Equals("Y")) | FLAG | bReadOnly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8c59ab8f | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5672 | if (dtPlanId.Rows.Count > 0) ▸ if (dtPlanId.Rows[iDx]["READ_ONLY"].ToString().Equals("Y")) | STATE | btnSimulation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-855bf455 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5676 | if (dtPlanId.Rows.Count > 0) ▸ else of (dtPlanId.Rows[iDx]["READ_ONLY"].ToString().Equals("Y")) | FLAG | bReadOnly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-14eb9622 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5677 | if (dtPlanId.Rows.Count > 0) ▸ else of (dtPlanId.Rows[iDx]["READ_ONLY"].ToString().Equals("Y")) | STATE | btnSimulation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-09166b1e | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5682 | if (dtPlanId.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRePlan.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d214c8db | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5684 | if (dtPlanId.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRePlan.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-99256337 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5689 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-8668bd5b | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5690 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-6fd9a237 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5691 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-522278e7 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5692 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-307878dd | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5693 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-a024f28d | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5695 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-877c7462 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5696 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-0f1e44b7 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5697 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-17f60d58 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5698 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-22209571 | this.Load [try] 외 3 | FP00607_PlanAmend_Model_Formation.cs:5699 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetPlanDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eea3f85b | this.Load [try] | FP00607_PlanAmend_Model_Formation.cs:5503 |  | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetPlanGroup

진입점: this.Load [try] / popSql.OnSql [if (programID == "PR_UI_FP00607_AMEND_MODEL_TOTAL_SELECT") ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAm…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b623905 | this.Load [try] 외 10 | FP00607_PlanAmend_Model_Formation.cs:5600 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f1c2b4b | this.Load [try] 외 10 | FP00607_PlanAmend_Model_Formation.cs:5600 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5be46b1e | this.Load [try] 외 10 | FP00607_PlanAmend_Model_Formation.cs:5601 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fc943415 | this.Load [try] 외 10 | FP00607_PlanAmend_Model_Formation.cs:5603 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-0864d833 | this.Load [try] 외 10 | FP00607_PlanAmend_Model_Formation.cs:5604 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetPlanner

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-256bf8cd | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5537 | if (sInstance.Equals("PL_FORM_A")) | FLAG | dtPlanner | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00607_findPlanner_List_exception… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4932904c | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5537 | if (sInstance.Equals("PL_FORM_A")) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_findPlanner_List_exception", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-02140947 | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5539 | else of (sInstance.Equals("PL_FORM_A")) | FLAG | dtPlanner | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findPlanner_List", sInstan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-205b91c9 | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5539 | else of (sInstance.Equals("PL_FORM_A")) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findPlanner_List", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6bac390a | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5541 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, mcbo_planner, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-d2c4863b | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5551 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row[… | CALL_EXT | mcbo_planner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8bf28162 | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5555 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of … | CALL_EXT | mcbo_planner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb35556f | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5571 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-2aa55080 | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5572 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-34193f5c | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5576 | if (dtPlanner != null) ▸ else of (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-7bdec570 | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5577 | if (dtPlanner != null) ▸ else of (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-f37db632 | this.Load [try] 외 2 | FP00607_PlanAmend_Model_Formation.cs:5587 | if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner.Items.Count) ▸ if (mcbo_planner.Items[k].ToString() == sValueName.ToString()) | CALL_EXT | mcbo_planner.SetItemChecked | (k, true) | ⚠ 의미 확인 필요 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetPlanOut_DataSet

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (sCateID.Equals("P_OUT"))] / menu_material.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b89bc42 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5820 | if (org_value == new_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f089368 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5917 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-32819783 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5918 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-687babd1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5919 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-897ffa57 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5920 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-4c365a0a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5933 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fc5d9ee | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:5942 | if (dsMainFiltered.Good()) ▸ if (org_value == new_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetPlanPeriod

진입점: this.Load [try] / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81fd5620 | this.Load [try] 외 1 | FP00607_PlanAmend_Model_Formation.cs:5721 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-b3752407 | this.Load [try] 외 1 | FP00607_PlanAmend_Model_Formation.cs:5722 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-b1b86710 | this.Load [try] 외 1 | FP00607_PlanAmend_Model_Formation.cs:5726 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-9484c211 | this.Load [try] 외 1 | FP00607_PlanAmend_Model_Formation.cs:5727 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-838850d4 | this.Load [try] 외 1 | FP00607_PlanAmend_Model_Formation.cs:5733 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-12fef0ee | this.Load [try] 외 1 | FP00607_PlanAmend_Model_Formation.cs:5734 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetShipPlan_DataSet

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ else of (sCateID.Equals("P_OUT")) ▸ if (sCateID.Equals("S_SHIP_PLAN"))] / menu_material.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f86026bb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6138 | if (dsMainFiltered.Good()) ▸ if (dsShipPlan == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_ShipPlanList") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0bc37197 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6139 | if (dsMainFiltered.Good()) ▸ if (dsShipPlan == null) | DATA_OP | dtShipPlanSave.Rows[0].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-011f8a93 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6140 | if (dsMainFiltered.Good()) ▸ if (dsShipPlan == null) | DATA_OP | dtShipPlanSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ea5cb590 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6141 | if (dsMainFiltered.Good()) ▸ if (dsShipPlan == null) | FLAG | dsShipPlan | dtShipPlanSave.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-57592317 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6141 | if (dsMainFiltered.Good()) ▸ if (dsShipPlan == null) | DATA_OP | dtShipPlanSave.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7683c68f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6157 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-218dc876 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6158 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-2b05e445 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6159 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-3521021f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6160 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-0e44e372 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6174 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfd2c132 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6188 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d1ef162 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6189 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0567e1d7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6190 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c76e27ab | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6191 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0f84fdf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6192 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fdca20a0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6193 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c69c19a3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6194 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3436d9cb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6195 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7dc6eedf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6196 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c08e1084 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6197 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b2a45f55 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6198 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-55bddb6f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6199 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0296dbb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6200 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-88c80cbe | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6201 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d005b59 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6202 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-c82bdbf7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6203 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc5a53db | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6204 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd9c4a6d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6186 | if (dsMainFiltered.Good()) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("PLAN_… |  | 처리 중단/반환 |  |  |  |
| AC-e348206f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6218 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_DataTable.Count() > 0) ▸ if (current_catagory == "S_SHIP_PLAN") | DATA_OP | selected["SALE_SIMUL_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-b8b75ea6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6219 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_DataTable.Count() > 0) ▸ if (current_catagory == "S_SHIP_PLAN") | DATA_OP | selected["ORIG_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-25207cb7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6220 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_DataTable.Count() > 0) ▸ if (current_catagory == "S_SHIP_PLAN") | DATA_OP | selected["ACTION"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-e30755c2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6230 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | dtShipPlanSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3db88945 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6232 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-16649a2a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6233 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-66d640e3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6234 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-838a1391 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6235 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7e8ab58a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6236 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-39201977 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6237 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57599c68 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6238 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-71f513d1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6239 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() == "" ? "-" : row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-81d0d258 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6240 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["LINE_ID"] | row["LINE_ID"].ToString() == "" ? "-" : row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2273fc7e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6241 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bed52287 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6242 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-82f90116 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6243 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["TOP_ITEM_ID"] | row["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a07f30b1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6244 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["ITEM_TYPE"] | row["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0e6ff813 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6245 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["LOCATION"] | row["LOCATION"].ToString() == "" ? "-" : row["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-78f0e858 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6246 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"].ToString() == "" ? "-" : row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9faeeb8d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6247 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["MARKET"] | row["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-381aaafc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6248 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() == "" ? "-" : row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3c99e006 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6249 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) | DATA_OP | newrow["CATEGORY_ID"] | row["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-49e2fbb1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6254 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) ▸ if (current_catagory == "S_SHIP_PLAN") | DATA_OP | newrow["SALE_SIMUL_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-700ec02d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6255 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) ▸ if (current_catagory == "S_SHIP_PLAN") | DATA_OP | newrow["ORIG_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-318f2eaa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6256 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) ▸ if (current_catagory == "S_SHIP_PLAN") | DATA_OP | newrow["ACTION"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-fd0856d2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6258 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) ▸ if (current_catagory == "S_SHIP_PLAN") | DATA_OP | dtShipPlanSave.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-0665c3d4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6261 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) ▸ if (current_catagory == "S_SHIP_PLAN") ▸ if (dsShipPlan == … | FLAG | dsShipPlan | dtShipPlanSave.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-50aac2e2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6264 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) ▸ if (current_catagory == "S_SHIP_PLAN") ▸ else of (dsShipPla… | DATA_OP | dsShipPlan.Tables["Table"].ImportRow | (dtShipPlanSave.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b501a724 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6268 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_DataTable.Count() > 0) ▸ if (dtShipPlanSave.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-136f17b6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6316 | if (dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetShortLT_DataSet

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME"))] / menu_material.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83b126b3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6339 | if (dsShorterLT == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_ListData_LT", Filter["DIVISION_ID"].ToString(), Filter["SIT… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b5719d15 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6342 | if (dsShorterLT == null) | FLAG | dsShorterLT | dtShorter.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-fff59a54 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6342 | if (dsShorterLT == null) | DATA_OP | dtShorter.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9b8dc6e6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6358 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3aeec0ec | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6359 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad4ad381 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6360 | lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee5c8130 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6361 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d47a552 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6362 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa093cdd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6363 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-685e3e65 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6364 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e832513 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6358 | lambda | RETURN | return (x.Field<string>("DIVISION_ID") == row["DIVISION_ID"].ToString() && x.Fie… |  | 처리 중단/반환 |  |  |  |
| AC-955372e6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6375 | if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["SHORTER_LT"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-c89606b1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6377 | if (MatchingEditRowData.Count() > 0) | DATA_OP | dtShorter.ImportRow | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4bdb955 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6381 | if (MatchingEditRowData.Count() > 0) ▸ if (dsShorterLT == null) | FLAG | dsShorterLT | dtShorter.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c25b9338 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6391 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtShorter.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-098cbd95 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6393 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f9804929 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6394 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e07a02df | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6395 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-72a232f4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6396 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8aa20ee9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6397 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d22c2dc7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6398 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fc32f340 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6399 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fbec429d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6400 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9cf5c500 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6401 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SHORTER_LT"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-81afd257 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6404 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtShorter.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-31cb00b1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6407 | else of (MatchingEditRowData.Count() > 0) ▸ if (dsShorterLT == null) | FLAG | dsShorterLT | dtShorter.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-9183e448 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6410 | else of (MatchingEditRowData.Count() > 0) ▸ else of (dsShorterLT == null) | DATA_OP | dsShorterLT.Tables["Table"].ImportRow | (dtShorter.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-73f6a23a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00607_PlanAmend_Model_Formation.cs:6491 | for (i <= nRowEnd) | GRID_SET | siMain.ActiveSheet.Cells[i, cCol].Value | new_value | 그리드 속성/값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3be9869 | this.Load [try] 외 11 | FP00607_PlanAmend_Model_Formation.cs:536 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0968ea6d | this.Load [try] 외 11 | FP00607_PlanAmend_Model_Formation.cs:537 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SetTotalColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb4fc39d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00607_PlanAmend_Model_Formation.cs:581 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a5089ed | this.spdMain.ButtonClicked | FP00607_PlanAmend_Model_Formation.cs:5106 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-116bda93 | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4743 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d1167a28 | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4744 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1771b222 | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4766 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-0fb2d06a | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4767 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-59d20201 | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4769 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9311917 | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4778 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-3dd533df | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4779 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-3926de1d | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4781 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1a06dbc | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4790 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | menu_material.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-8e2afd6f | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4791 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | menu_material.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-87f6b038 | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4793 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (menu_material) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfd69fba | this.spdMain.CellClick | FP00607_PlanAmend_Model_Formation.cs:4807 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c718e62e | this.spdMain.CellDoubleClick | FP00607_PlanAmend_Model_Formation.cs:8817 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-f2be8c22 | this.spdMain.CellDoubleClick | FP00607_PlanAmend_Model_Formation.cs:8824 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad326cd7 | this.spdMain.ChildControlDeactivated | FP00607_PlanAmend_Model_Formation.cs:4852 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8033758 | this.spdMain.ClipboardPasted | FP00607_PlanAmend_Model_Formation.cs:5113 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c893ce8 | this.spdMain.ClipboardPasted | FP00607_PlanAmend_Model_Formation.cs:5121 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-610a8682 | this.spdMain.ClipboardPasted | FP00607_PlanAmend_Model_Formation.cs:5122 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-307ac6ba | this.spdMain.ClipboardPasted | FP00607_PlanAmend_Model_Formation.cs:5124 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-346a748b | this.spdMain.ClipboardPasting | FP00607_PlanAmend_Model_Formation.cs:5130 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-3f09ddde | this.spdMain.ClipboardPasting | FP00607_PlanAmend_Model_Formation.cs:5131 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-e6bde232 | this.spdMain.ClipboardPasting | FP00607_PlanAmend_Model_Formation.cs:5131 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-011796ee | this.spdMain.ClipboardPasting | FP00607_PlanAmend_Model_Formation.cs:5135 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-a454e52d | this.spdMain.ClipboardPasting | FP00607_PlanAmend_Model_Formation.cs:5135 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-586e26b3 | this.spdMain.ClipboardPasting | FP00607_PlanAmend_Model_Formation.cs:5139 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, false, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f197332c | this.spdMain.ClipboardPasting | FP00607_PlanAmend_Model_Formation.cs:5141 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4fef264 | this.spdMain.DragFillBlockCompleted | FP00607_PlanAmend_Model_Formation.cs:4862 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5d1e596 | this.spdMain.EditModeOff | FP00607_PlanAmend_Model_Formation.cs:4880 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4be5682 | this.spdMain.EditModeOn | FP00607_PlanAmend_Model_Formation.cs:4886 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-a8f7882f | this.spdMain.EditModeOn | FP00607_PlanAmend_Model_Formation.cs:4887 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9befff13 | this.spdMain.EditorFocused | FP00607_PlanAmend_Model_Formation.cs:4874 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e96836d4 | this.spdMain.Enter | FP00607_PlanAmend_Model_Formation.cs:4837 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09b4e0ed | this.spdMain.KeyDown | FP00607_PlanAmend_Model_Formation.cs:4821 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-647d439f | this.spdMain.KeyDown | FP00607_PlanAmend_Model_Formation.cs:4825 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c746624 | this.spdMain.KeyDown | FP00607_PlanAmend_Model_Formation.cs:4826 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0efb661 | this.spdMain.Leave | FP00607_PlanAmend_Model_Formation.cs:4832 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d573e2e | this.spdMain.SubEditorClosed | FP00607_PlanAmend_Model_Formation.cs:4868 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ea2efbb | this.spdMain.SubEditorOpening | FP00607_PlanAmend_Model_Formation.cs:4857 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-355a651f | this.spdMain.Validated | FP00607_PlanAmend_Model_Formation.cs:4842 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ccf265a | this.spdMain.Validating | FP00607_PlanAmend_Model_Formation.cs:4847 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00607_PlanAmend_Model_Formation.SwitchMemo

진입점: memo_menu.Click [if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7efb3040 | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8835 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe8fd75a | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8852 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-8bfcfe32 | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8876 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-31189ee1 | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8902 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-1df0f640 | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8904 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-3467bfba | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8907 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-18b47d08 | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8909 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ded3cbcc | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8909 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-2060263c | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8910 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-7f51608e | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8912 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-4cd10459 | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8914 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0fee2a24 | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8926 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d20e363 | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8926 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-64af1ee6 | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8946 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-0c2ec6d0 | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8947 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-fb95c687 | memo_menu.Click [if (day != null)] 외 1 | FP00607_PlanAmend_Model_Formation.cs:8949 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00607_PlanAmend_Model_Formation.UIFindData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true)] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton / InsertButton […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e60d1b0b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:750 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-005a9595 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:751 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f543ba5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:754 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a246a6d9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:757 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-d7a47e4d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:761 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan ID to proceed") | 메시지 표시 |  |  |  |
| AC-11749a2f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:762 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14577ba6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:768 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5842c05b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:782 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-20094a6a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:783 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e1f7475 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:786 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-687abfbb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:790 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d090f52d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:791 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4c3c0f28 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:793 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-618bac42 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:796 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ffece4c8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:798 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-80394421 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:804 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-19555e50 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:806 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-6146bb4c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:806 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9573d0cd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:816 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | LastTotalRaw | FindTotalValue("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-97fb9ace | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:818 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7ee8466 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:821 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4f7e8fe3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:822 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-01affc95 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:826 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-519f8fc3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:827 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-073afe1e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:828 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b67f412a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:833 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-55835e66 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:834 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1f34e536 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:835 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-c10d8d67 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:838 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfb5c433 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:851 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5f1d878d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:856 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-64b095f3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:861 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fa4f5320 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:862 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a30fffee | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:869 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-135d959a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:872 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8f734aae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:876 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d6856e9f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00607_PlanAmend_Model_Formation.cs:880 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00607_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec06ba45 | .ctor | FP00607_RowExcelPopup.cs:155 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e08ae4f1 | .ctor | FP00607_RowExcelPopup.cs:158 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-ff69779b | .ctor | FP00607_RowExcelPopup.cs:159 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00607_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3084f1a4 | this.btnClose.Click | FP00607_RowExcelPopup.cs:1040 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00607_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e785298 | this.btnDownload.Click | FP00607_RowExcelPopup.cs:1011 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-6332873f | this.btnDownload.Click | FP00607_RowExcelPopup.cs:1012 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |
| AC-9cd8ccad | this.btnDownload.Click | FP00607_RowExcelPopup.cs:1014 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00607_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49c45ed8 | this.btnFind.Click | FP00607_RowExcelPopup.cs:1006 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00607_RowExcelPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1116b7a8 | this.btnSave.Click | FP00607_RowExcelPopup.cs:1035 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00607_RowExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7da794ec | this.btnUpload.Click | FP00607_RowExcelPopup.cs:1026 | if (bUpload) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c2d043df | this.btnUpload.Click | FP00607_RowExcelPopup.cs:1027 | if (bUpload) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |

## FP00607_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64ff723f | this.Load | FP00607_RowExcelPopup.cs:248 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bc3154a0 | this.Load | FP00607_RowExcelPopup.cs:249 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c30df2c | this.Load | FP00607_RowExcelPopup.cs:250 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00607_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e041fc4b | (진입점 미연결) | FP00607_RowExcelPopup.cs:934 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94d7c250 | (진입점 미연결) | FP00607_RowExcelPopup.cs:934 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00607_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-942ab411 | this.Load | FP00607_RowExcelPopup.cs:243 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00607_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0b4f4ee | Dispose | FP00607_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00607_RowExcelPopup.dtpPeriod_ValueChanged

진입점: this.dtpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c9efa12 | this.dtpPeriod.ValueChanged | FP00607_RowExcelPopup.cs:1054 | if (bFirst == true) | FLAG | bFirst | false | 화면 필드/플래그 변경 |  |  |  |
| AC-010597af | this.dtpPeriod.ValueChanged | FP00607_RowExcelPopup.cs:1055 | if (bFirst == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc5cb24e | this.dtpPeriod.ValueChanged | FP00607_RowExcelPopup.cs:1070 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f30e0dc7 | this.dtpPeriod.ValueChanged | FP00607_RowExcelPopup.cs:1072 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | VALUE_SET | dtpPeriod.InitValue | sStartDate + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a755b0bf | this.dtpPeriod.ValueChanged | FP00607_RowExcelPopup.cs:1073 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42afe9ae | this.dtpPeriod.ValueChanged | FP00607_RowExcelPopup.cs:1078 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7a96b60c | this.dtpPeriod.ValueChanged | FP00607_RowExcelPopup.cs:1086 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-7e75b02f | this.dtpPeriod.ValueChanged | FP00607_RowExcelPopup.cs:1088 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95122d18 | this.dtpPeriod.ValueChanged | FP00607_RowExcelPopup.cs:1091 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-9a53c93c | this.dtpPeriod.ValueChanged | FP00607_RowExcelPopup.cs:1092 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |

## FP00607_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-200c481c | (진입점 미연결) | FP00607_RowExcelPopup.cs:698 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00607_RowExcelPopup.Exec_Procedure

진입점: this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCCESS"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1057eb3 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:950 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-0f9f4b92 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:951 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1765e458 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:953 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-9e08bba1 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:954 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-44bd8656 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:955 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9547562f | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:956 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bae4995e | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:957 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-367c83d7 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:958 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-35bfc89c | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:959 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-2f29b7b7 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:960 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a6830074 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:961 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-98cd0f5a | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:962 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-794cf9a2 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:963 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6fe9ffb4 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:964 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8beaa9d9 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:965 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bee2f0fd | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:966 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cac32ac3 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:967 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9ed10a60 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:968 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b7e80a47 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:969 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6ded0d85 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:970 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7faa21fb | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:971 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-216cf241 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:972 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d7ba2923 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:973 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-804b0fd8 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:974 | try | DATA_OP | req.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3eb87f26 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:975 | try | DATA_OP | req.Parameters["p_p_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a8f4c309 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:976 | try | DATA_OP | req.Parameters["p_p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-43fbc239 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:977 | try | DATA_OP | req.Parameters["p_mpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f2d6bdc8 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:978 | try | DATA_OP | req.Parameters["p_mpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9eb334a2 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:979 | try | DATA_OP | req.Parameters["p_wpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0f0d419f | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:980 | try | DATA_OP | req.Parameters["p_wpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5a0d8e0a | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:981 | try | DATA_OP | req.Parameters["p_boh_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b04f2c4b | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:983 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3c9bfb6a | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:990 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-540a36b7 | this.btnSave.Click [if (OnExcelSaveData != null) ▸ try ▸ if … | FP00607_RowExcelPopup.cs:994 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00607_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53f3678b | FindButton | FP00607_RowExcelPopup.cs:290 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-56ca2060 | FindButton | FP00607_RowExcelPopup.cs:291 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ba4832f5 | FindButton | FP00607_RowExcelPopup.cs:293 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00607_RowExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5969a46d | this.Load 외 2 | FP00607_RowExcelPopup.cs:322 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ef8a4701 | this.Load 외 2 | FP00607_RowExcelPopup.cs:328 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f4835f6 | this.Load 외 2 | FP00607_RowExcelPopup.cs:330 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c79969b | this.Load 외 2 | FP00607_RowExcelPopup.cs:335 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ed019507 | this.Load 외 2 | FP00607_RowExcelPopup.cs:336 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c9c7b876 | this.Load 외 2 | FP00607_RowExcelPopup.cs:339 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-409577b5 | this.Load 외 2 | FP00607_RowExcelPopup.cs:340 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-e7c35eb0 | this.Load 외 2 | FP00607_RowExcelPopup.cs:342 |  | DATA_OP | Filter["BUCKET_FROM"] | _BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-9ebd9d58 | this.Load 외 2 | FP00607_RowExcelPopup.cs:343 |  | DATA_OP | Filter["BUCKET_TO"] | _BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-1b997601 | this.Load 외 2 | FP00607_RowExcelPopup.cs:348 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-ffd61b0b | this.Load 외 2 | FP00607_RowExcelPopup.cs:350 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-5f3fb06c | this.Load 외 2 | FP00607_RowExcelPopup.cs:354 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f526e8c4 | this.Load 외 2 | FP00607_RowExcelPopup.cs:358 | if (OnSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cdf27a37 | this.Load 외 2 | FP00607_RowExcelPopup.cs:359 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-37646df3 | this.Load 외 2 | FP00607_RowExcelPopup.cs:359 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-48e3464e | this.Load 외 2 | FP00607_RowExcelPopup.cs:363 | if (OnSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-00587f19 | this.Load 외 2 | FP00607_RowExcelPopup.cs:364 | if (OnSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-141e39be | this.Load 외 2 | FP00607_RowExcelPopup.cs:366 | if (OnSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-51ad007c | this.Load 외 2 | FP00607_RowExcelPopup.cs:367 | if (OnSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b16c50d9 | this.Load 외 2 | FP00607_RowExcelPopup.cs:368 | if (OnSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b9e57cfc | this.Load 외 2 | FP00607_RowExcelPopup.cs:369 | if (OnSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-12c83361 | this.Load 외 2 | FP00607_RowExcelPopup.cs:370 | if (OnSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8268919d | this.Load 외 2 | FP00607_RowExcelPopup.cs:371 | if (OnSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8a38e574 | this.Load 외 2 | FP00607_RowExcelPopup.cs:372 | if (OnSearchData != null) | STATE | this.dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c458f64d | this.Load 외 2 | FP00607_RowExcelPopup.cs:378 | if (OnSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1b77f4d | this.Load 외 2 | FP00607_RowExcelPopup.cs:381 | if (OnSearchData != null) ▸ try | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-796f8c6c | this.Load 외 2 | FP00607_RowExcelPopup.cs:383 | if (OnSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-931035c6 | this.Load 외 2 | FP00607_RowExcelPopup.cs:385 | if (OnSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar,set,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-49ffd3e2 | this.Load 외 2 | FP00607_RowExcelPopup.cs:390 | if (OnSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-090f16c4 | this.Load 외 2 | FP00607_RowExcelPopup.cs:390 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, null, 1, IgnoreColumnsNotInTi… | 그리드 재구성/초기화 |  |  |  |
| AC-360d3b42 | this.Load 외 2 | FP00607_RowExcelPopup.cs:395 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-1b9c2996 | this.Load 외 2 | FP00607_RowExcelPopup.cs:396 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-8afe8599 | this.Load 외 2 | FP00607_RowExcelPopup.cs:397 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-d9448f22 | this.Load 외 2 | FP00607_RowExcelPopup.cs:402 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-aa6fcc26 | this.Load 외 2 | FP00607_RowExcelPopup.cs:403 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dba83435 | this.Load 외 2 | FP00607_RowExcelPopup.cs:408 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b6fbea31 | this.Load 외 2 | FP00607_RowExcelPopup.cs:409 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1a64ab4f | this.Load 외 2 | FP00607_RowExcelPopup.cs:418 | if (OnSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b38d031 | this.Load 외 2 | FP00607_RowExcelPopup.cs:421 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1c91d17d | this.Load 외 2 | FP00607_RowExcelPopup.cs:422 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c94477f0 | this.Load 외 2 | FP00607_RowExcelPopup.cs:423 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a54a9db2 | this.Load 외 2 | FP00607_RowExcelPopup.cs:424 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-317563ad | this.Load 외 2 | FP00607_RowExcelPopup.cs:425 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dcaec445 | this.Load 외 2 | FP00607_RowExcelPopup.cs:426 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3ac6ccfa | this.Load 외 2 | FP00607_RowExcelPopup.cs:427 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00607_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c2636c3 | this.Load | FP00607_RowExcelPopup.cs:167 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a2b75053 | this.Load | FP00607_RowExcelPopup.cs:169 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00607_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1a15763 | (진입점 미연결) | FP00607_RowExcelPopup.cs:672 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-cab14f29 | (진입점 미연결) | FP00607_RowExcelPopup.cs:673 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-ce77d08d | (진입점 미연결) | FP00607_RowExcelPopup.cs:674 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-66b46c8a | (진입점 미연결) | FP00607_RowExcelPopup.cs:675 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-b99831e9 | (진입점 미연결) | FP00607_RowExcelPopup.cs:676 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-06356c61 | (진입점 미연결) | FP00607_RowExcelPopup.cs:677 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-9d61dd57 | (진입점 미연결) | FP00607_RowExcelPopup.cs:678 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f6c4112b | (진입점 미연결) | FP00607_RowExcelPopup.cs:680 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-6cd23d2e | (진입점 미연결) | FP00607_RowExcelPopup.cs:681 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-20c2f782 | (진입점 미연결) | FP00607_RowExcelPopup.cs:685 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-c04c9ad9 | (진입점 미연결) | FP00607_RowExcelPopup.cs:686 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00607_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-957e2e22 | this.Load | FP00607_RowExcelPopup.cs:202 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_FROM"].ToString()) < Convert.ToDecimal(thi… | DATA_OP | Filter["BUCKET_FROM"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-050771e6 | this.Load | FP00607_RowExcelPopup.cs:206 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-bd25055d | this.Load | FP00607_RowExcelPopup.cs:207 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | sEndDay | 행/컬럼 값 대입 |  |  |  |
| AC-60750db6 | this.Load | FP00607_RowExcelPopup.cs:210 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | Filter["BUCKET_FROM"] | 화면 필드/플래그 변경 |  |  |  |
| AC-e5abe57b | this.Load | FP00607_RowExcelPopup.cs:211 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | Filter["BUCKET_TO"] | 화면 필드/플래그 변경 |  |  |  |
| AC-50c3f227 | this.Load | FP00607_RowExcelPopup.cs:212 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | _BucketFromDate.ToString() + ":" + _BucketToDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-45c334ae | this.Load | FP00607_RowExcelPopup.cs:214 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f707d00d | this.Load | FP00607_RowExcelPopup.cs:216 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-1441f189 | this.Load | FP00607_RowExcelPopup.cs:220 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f1853f21 | this.Load | FP00607_RowExcelPopup.cs:222 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-c1c2dd3d | this.Load | FP00607_RowExcelPopup.cs:223 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-6ae7e1ee | this.Load | FP00607_RowExcelPopup.cs:224 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bc78f8e8 | this.Load | FP00607_RowExcelPopup.cs:232 | for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-42197ba1 | this.Load | FP00607_RowExcelPopup.cs:235 |  | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-f24bb491 | this.Load | FP00607_RowExcelPopup.cs:237 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |

## FP00607_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0527fc27 | this.Load | FP00607_RowExcelPopup.cs:260 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-895767f0 | this.Load | FP00607_RowExcelPopup.cs:261 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00607_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e9fa37a | (진입점 미연결) | FP00607_RowExcelPopup.cs:281 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00607_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-043a9705 | this.btnUpload.Click | FP00607_RowExcelPopup.cs:706 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-ed229c1d | this.btnUpload.Click | FP00607_RowExcelPopup.cs:706 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd40a405 | this.btnUpload.Click | FP00607_RowExcelPopup.cs:708 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-66e49fdf | this.btnUpload.Click | FP00607_RowExcelPopup.cs:709 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2bc6468c | this.btnUpload.Click | FP00607_RowExcelPopup.cs:710 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f930f81 | this.btnUpload.Click | FP00607_RowExcelPopup.cs:712 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-abd52035 | this.btnUpload.Click | FP00607_RowExcelPopup.cs:714 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c9873714 | this.btnUpload.Click | FP00607_RowExcelPopup.cs:715 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-14e6d923 | this.btnUpload.Click | FP00607_RowExcelPopup.cs:715 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-71ec69ef | this.btnUpload.Click | FP00607_RowExcelPopup.cs:722 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b1829408 | this.btnUpload.Click | FP00607_RowExcelPopup.cs:723 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-4111fe5d | this.btnUpload.Click | FP00607_RowExcelPopup.cs:725 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00607_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21bb50b2 | this.btnSave.Click | FP00607_RowExcelPopup.cs:440 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-61ff5d54 | this.btnSave.Click | FP00607_RowExcelPopup.cs:441 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2317c5b5 | this.btnSave.Click | FP00607_RowExcelPopup.cs:445 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix! After once seach, Try agagin.!") | 메시지 표시 |  |  |  |
| AC-4010a885 | this.btnSave.Click | FP00607_RowExcelPopup.cs:446 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-766ee1b3 | this.btnSave.Click | FP00607_RowExcelPopup.cs:457 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].Rows[i]["MESSAGE"].ToString().Equals("Y")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-785c0924 | this.btnSave.Click | FP00607_RowExcelPopup.cs:458 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].Rows[i]["MESSAGE"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd0d36b7 | this.btnSave.Click | FP00607_RowExcelPopup.cs:462 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-9834604b | this.btnSave.Click | FP00607_RowExcelPopup.cs:462 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff316b3d | this.btnSave.Click | FP00607_RowExcelPopup.cs:467 | if (OnBeforeCheckData != null) | CALL_BASE | OnBeforeCheckData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b48601c2 | this.btnSave.Click | FP00607_RowExcelPopup.cs:469 | if (OnBeforeCheckData != null) ▸ if (bCheck == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb4d311e | this.btnSave.Click | FP00607_RowExcelPopup.cs:478 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-87ee3d87 | this.btnSave.Click | FP00607_RowExcelPopup.cs:479 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3b14446a | this.btnSave.Click | FP00607_RowExcelPopup.cs:480 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fd622c67 | this.btnSave.Click | FP00607_RowExcelPopup.cs:481 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-58181c64 | this.btnSave.Click | FP00607_RowExcelPopup.cs:482 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8a2d785e | this.btnSave.Click | FP00607_RowExcelPopup.cs:483 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a32f08d9 | this.btnSave.Click | FP00607_RowExcelPopup.cs:491 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-84b1e181 | this.btnSave.Click | FP00607_RowExcelPopup.cs:492 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a29ba641 | this.btnSave.Click | FP00607_RowExcelPopup.cs:493 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6dbc4668 | this.btnSave.Click | FP00607_RowExcelPopup.cs:494 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-833ddb1d | this.btnSave.Click | FP00607_RowExcelPopup.cs:495 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b3211890 | this.btnSave.Click | FP00607_RowExcelPopup.cs:496 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-57632b7d | this.btnSave.Click | FP00607_RowExcelPopup.cs:497 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-624df8f3 | this.btnSave.Click | FP00607_RowExcelPopup.cs:498 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-02545fd5 | this.btnSave.Click | FP00607_RowExcelPopup.cs:503 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3cac87b8 | this.btnSave.Click | FP00607_RowExcelPopup.cs:506 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-4de27239 | this.btnSave.Click | FP00607_RowExcelPopup.cs:508 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-85d6dc0e | this.btnSave.Click | FP00607_RowExcelPopup.cs:511 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3c5962c | this.btnSave.Click | FP00607_RowExcelPopup.cs:516 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-a99b68cd | this.btnSave.Click | FP00607_RowExcelPopup.cs:517 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-19917c07 | this.btnSave.Click | FP00607_RowExcelPopup.cs:527 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGrou… | DATA_OP | this.Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-df6621de | this.btnSave.Click | FP00607_RowExcelPopup.cs:529 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rd… | DATA_OP | this.Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-b64f7bb5 | this.btnSave.Click | FP00607_RowExcelPopup.cs:533 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fcc5c390 | this.btnSave.Click | FP00607_RowExcelPopup.cs:537 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d40379fa | this.btnSave.Click | FP00607_RowExcelPopup.cs:572 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-38220492 | this.btnSave.Click | FP00607_RowExcelPopup.cs:586 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a15c1849 | this.btnSave.Click | FP00607_RowExcelPopup.cs:589 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | FLAG | bUploadSaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4fcfdf85 | this.btnSave.Click | FP00607_RowExcelPopup.cs:590 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ba6f3ca3 | this.btnSave.Click | FP00607_RowExcelPopup.cs:595 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-4eed0c07 | this.btnSave.Click | FP00607_RowExcelPopup.cs:596 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-aa7b75f2 | this.btnSave.Click | FP00607_RowExcelPopup.cs:602 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-02162725 | this.btnSave.Click | FP00607_RowExcelPopup.cs:639 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-778d3b18 | this.btnSave.Click | FP00607_RowExcelPopup.cs:641 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-58b4ebd5 | this.btnSave.Click | FP00607_RowExcelPopup.cs:642 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cccdb6fa | this.btnSave.Click | FP00607_RowExcelPopup.cs:652 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7f0a79fb | this.btnSave.Click | FP00607_RowExcelPopup.cs:653 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-c96e1072 | this.btnSave.Click | FP00607_RowExcelPopup.cs:657 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-04e7563b | this.btnSave.Click | FP00607_RowExcelPopup.cs:658 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-beff5da5 | this.btnSave.Click | FP00607_RowExcelPopup.cs:659 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-63b9b1e6 | this.btnSave.Click | FP00607_RowExcelPopup.cs:660 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-67beef38 | this.btnSave.Click | FP00607_RowExcelPopup.cs:661 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-be32af7c | this.btnSave.Click | FP00607_RowExcelPopup.cs:662 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00607_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c92d28a | this.Load | FP00607_RowExcelPopup.cs:273 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f2f252b | this.Load | FP00607_RowExcelPopup.cs:274 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

