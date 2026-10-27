# AS-IS 액션 대조표 — FP00620

> 원천: `Doc/asisfacts/screens/FP00620/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 911행 · 메서드 97 · 종류 DATA_OP 197 · CALL_EXT 117 · UI_PROP 111 · FLAG 107 · GRID_SET 87 · RETURN 62 · UI_MISC 47 · VALUE_SET 36 · POPUP 33 · COMBO_DATA 29 · MESSAGE 17 · GRID_INIT 15 · ENDPOINT 12 · GRID_LOCK 8 · THROW 8 · LIST_REBIND 7 · GRID_STYLE 7 · STATE 6 · GRID_BIND 3 · CALL_BASE 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 118


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1725c31d | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5104 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a5aef7e | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5110 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-27ef4203 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5118 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-3b0e6cd5 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5119 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-e35db30c | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5120 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-a77f3020 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5121 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-84252b90 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5123 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ad92e64 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5124 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-e086a5d1 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5125 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee0fd12f | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5126 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-99d047a0 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5127 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b61ba08 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5128 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-c6d67f8b | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5129 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe635a35 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5130 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-b45b2a3f | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5133 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-40745097 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5318 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-1d29766d | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5319 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-375c0d1f | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5320 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-0aa01392 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5321 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-7daf283d | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5323 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-e5c018ad | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5324 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-45920279 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5325 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-41ed66bf | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5326 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-7dd1e239 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5327 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-02ae6bc0 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5328 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-df4365c4 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5329 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-d16f20c4 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5330 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-a7b4259c | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5332 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a79ec7b | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5237 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dbd10248 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5238 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a517e5d7 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5239 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-99698ee4 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5240 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c412da62 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5241 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd160518 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5244 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-244ef1a6 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5248 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-22a763fd | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5249 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-46f8147a | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5235 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-2181acaf | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5265 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-7104db46 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5268 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-56f6f9cf | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5271 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a06cdd2 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5274 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a21d512 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5277 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-46549362 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5280 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-f5f1e834 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5286 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-a2bf1b35 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5288 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbcbbbb7 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5209 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9aede1ac | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5173 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd5a126d | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5174 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cec4a0b0 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5175 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d266101 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5176 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2090ee34 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5177 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2ae8d7b | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5178 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2006c3ec | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5180 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c895a467 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5181 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ed9d564 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5184 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b925c849 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5185 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-605fed7f | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5186 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c75331a | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5171 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-47e51efd | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5194 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1211424 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5195 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-26bdd6ce | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5200 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d6e06d0 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5146 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00620_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93193141 | .ctor | FP00620_BucketSetForm_Popup.cs:76 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-6eaac5bc | .ctor | FP00620_BucketSetForm_Popup.cs:77 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-6ddea9f7 | .ctor | FP00620_BucketSetForm_Popup.cs:78 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-e745b5f1 | .ctor | FP00620_BucketSetForm_Popup.cs:80 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00620_BucketSetForm_Popup.chk_week_CheckedChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b88bc23 | (진입점 미연결) | FP00620_BucketSetForm_Popup.cs:239 | if (chk_week.Checked) | STATE | chk_week_sun.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-238dc50e | (진입점 미연결) | FP00620_BucketSetForm_Popup.cs:241 | else of (chk_week.Checked) | STATE | chk_week_sun.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00620_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d6dd1d5 | Dispose | FP00620_BucketSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00620_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5715d2ed | this.Load | FP00620_BucketSetForm_Popup.cs:104 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00620_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91c080f2 | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:150 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-7570bd47 | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:151 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-eeeef1c6 | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:153 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-f04b49bf | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:154 |  | DATA_OP | ctrls.Add | (chk_totalBatch) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a90f44e | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:155 |  | DATA_OP | ctrls.Add | (chk_week_sun) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a6ea404 | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:159 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-f02adc3e | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:159 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-8bbf4082 | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:166 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-6f18e76f | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:170 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-3bea237e | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:174 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00620_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c42e1ae | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:121 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-82fa1d57 | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:122 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b15e20c5 | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:123 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b296875b | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:124 |  | VALUE_SET | chk_totalBatch.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d99a8e62 | this.Load 외 1 | FP00620_BucketSetForm_Popup.cs:125 |  | VALUE_SET | chk_week_sun.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00620_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-619b03cd | (진입점 미연결) | FP00620_BucketSetForm_Popup.cs:247 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-3a9690cb | (진입점 미연결) | FP00620_BucketSetForm_Popup.cs:249 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00620_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-745b1748 | this.Load | FP00620_BucketSetForm_Popup.cs:91 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a729fe93 | this.Load | FP00620_BucketSetForm_Popup.cs:99 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00620_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51d75ada | this.usrButton1.Click | FP00620_BucketSetForm_Popup.cs:219 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-6ff12da4 | this.usrButton1.Click | FP00620_BucketSetForm_Popup.cs:219 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-447a8389 | this.usrButton1.Click | FP00620_BucketSetForm_Popup.cs:221 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-8042e02b | this.usrButton1.Click | FP00620_BucketSetForm_Popup.cs:225 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-f64b28cf | this.usrButton1.Click | FP00620_BucketSetForm_Popup.cs:226 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-2fe8618f | this.usrButton1.Click | FP00620_BucketSetForm_Popup.cs:228 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-91a4df17 | this.usrButton1.Click | FP00620_BucketSetForm_Popup.cs:230 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-4ccf78db | this.usrButton1.Click | FP00620_BucketSetForm_Popup.cs:232 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-bbc5db61 | this.usrButton1.Click | FP00620_BucketSetForm_Popup.cs:233 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00620_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-497ab257 | this.usrButton2.Click | FP00620_BucketSetForm_Popup.cs:192 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-6b913fdc | this.usrButton2.Click | FP00620_BucketSetForm_Popup.cs:192 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-bca1416c | this.usrButton2.Click | FP00620_BucketSetForm_Popup.cs:194 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-a68f2877 | this.usrButton2.Click | FP00620_BucketSetForm_Popup.cs:198 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-7a718fbb | this.usrButton2.Click | FP00620_BucketSetForm_Popup.cs:199 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-28279a7f | this.usrButton2.Click | FP00620_BucketSetForm_Popup.cs:200 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-e13f8741 | this.usrButton2.Click | FP00620_BucketSetForm_Popup.cs:201 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00620_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e65bef1 | .ctor | FP00620_MeasureSetForm_Popup.cs:79 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-b569ea2b | .ctor | FP00620_MeasureSetForm_Popup.cs:80 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-a51528d4 | .ctor | FP00620_MeasureSetForm_Popup.cs:81 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-b542266c | .ctor | FP00620_MeasureSetForm_Popup.cs:83 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00620_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ba8ca7a | this.btnOK.Click | FP00620_MeasureSetForm_Popup.cs:329 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-f816410d | this.btnOK.Click | FP00620_MeasureSetForm_Popup.cs:330 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-ee4180bb | this.btnOK.Click | FP00620_MeasureSetForm_Popup.cs:337 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-91c95454 | this.btnOK.Click | FP00620_MeasureSetForm_Popup.cs:338 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00620_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-521910d8 | this.btnSet.Click | FP00620_MeasureSetForm_Popup.cs:299 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-f60501cd | this.btnSet.Click | FP00620_MeasureSetForm_Popup.cs:300 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-e09bf30d | this.btnSet.Click | FP00620_MeasureSetForm_Popup.cs:302 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-413241e1 | this.btnSet.Click | FP00620_MeasureSetForm_Popup.cs:303 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-887cfcdd | this.btnSet.Click | FP00620_MeasureSetForm_Popup.cs:305 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-48175970 | this.btnSet.Click | FP00620_MeasureSetForm_Popup.cs:307 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-ff561381 | this.btnSet.Click | FP00620_MeasureSetForm_Popup.cs:308 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00620_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6eda4dac | Dispose | FP00620_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00620_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eed49ad | this.Load | FP00620_MeasureSetForm_Popup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00620_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1412c729 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:208 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-a36d934c | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:209 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ad9115a | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:212 |  | DATA_OP | ctrls.Add | (chk_seq) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6fe7517 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:213 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-a60655e1 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:218 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-add67040 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:219 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-152b28a1 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:220 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea4ce458 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:222 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-12dc258d | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:223 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-77d6df6f | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:226 |  | DATA_OP | ctrls.Add | (chk_pc) | 데이터 객체 조작/조회 |  |  |  |
| AC-94ceec1d | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:227 |  | DATA_OP | ctrls.Add | (chk_jr) | 데이터 객체 조작/조회 |  |  |  |
| AC-aeb939c3 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:228 |  | DATA_OP | ctrls.Add | (chk_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a8c7336 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:229 |  | DATA_OP | ctrls.Add | (chk_batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-75765af5 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:232 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-447d28f4 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:232 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-04f6ae23 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:239 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-08914854 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:243 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |

## FP00620_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6169f3d0 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8c3799e5 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a584ba83 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_seq.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-799dc0bc | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c4e344ee | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-84bcac27 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b77f22b7 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_memo_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-98e17e69 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2f61c358 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f1724e81 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_pc.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f00212c4 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_jr.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d1c89870 | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_cell.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ca9a5ade | this.Load 외 1 | FP00620_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_batch.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00620_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a85d2412 | (진입점 미연결) | FP00620_MeasureSetForm_Popup.cs:391 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-3c3c3d66 | (진입점 미연결) | FP00620_MeasureSetForm_Popup.cs:393 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00620_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a78c384 | this.Load | FP00620_MeasureSetForm_Popup.cs:94 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-79bd4a9a | this.Load | FP00620_MeasureSetForm_Popup.cs:102 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00620_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e88ab9f6 | this.btnSet.Click 외 1 | FP00620_MeasureSetForm_Popup.cs:344 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ed1e75e4 | this.btnSet.Click 외 1 | FP00620_MeasureSetForm_Popup.cs:352 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-72e3e9b8 | this.btnSet.Click 외 1 | FP00620_MeasureSetForm_Popup.cs:352 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-0acb040d | this.btnSet.Click 외 1 | FP00620_MeasureSetForm_Popup.cs:369 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-363925b1 | this.btnSet.Click 외 1 | FP00620_MeasureSetForm_Popup.cs:380 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea6bf610 | .ctor | FP00620_PlanBy_Line_Electrode_Production.cs:213 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-cff9a1da | .ctor | FP00620_PlanBy_Line_Electrode_Production.cs:218 |  | VALUE_SET | chk_totalBatch.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.ActiveSheet_CellChanged

진입점: spdMain.ActiveSheet.CellChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7544176 | spdMain.ActiveSheet.CellChanged | FP00620_PlanBy_Line_Electrode_Production.cs:5350 | if (e.Column == -1 \|\| e.Column == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bbe38ad7 | spdMain.ActiveSheet.CellChanged | FP00620_PlanBy_Line_Electrode_Production.cs:5355 | if (initchk_totalBatch == true && check_cell_chg == false) | DATA_OP | saveTotalBatch.Contains | (new Tuple<int, int>(e.Row, e.Column)) | 데이터 객체 조작/조회 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_Electrode_Production_MEMO")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0980f0b | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2298 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; //this.Invoke(new MethodInvoker(dele… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6916308f | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2311 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-eaf691ea | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2312 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a25286f5 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2320 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ed960857 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2344 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8ecefa5a | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2347 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_currDateCol", Filter["INSTANCE_ID"], Filter["BUCKET_FROM"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.btn_setupinfo_Click

진입점: this.btnSetupColor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f90dbd99 | this.btnSetupColor.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4046 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-fdf7296f | this.btnSetupColor.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4047 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e9d354c | this.btnSetupColor.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4053 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-f2e289d6 | this.btnSetupColor.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4056 |  | POPUP | new FPC0108_btn_setupinfoPopup | (Filter["INSTANCE_ID"]) | 팝업/폼 생성 |  |  |  |
| AC-dde7e284 | this.btnSetupColor.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4058 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-71215015 | this.btnSetupColor.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4059 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9016974 | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3934 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a18bae67 | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3937 |  | FLAG | weekSunChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-258f6ad2 | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3942 |  | POPUP | new FP00620_BucketSetForm_Popup | ("FP00620", SpdSheet.shtPlanByLineElectrodeProduction, false, "") | 팝업/폼 생성 |  |  |  |
| AC-0bce75af | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3943 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-356f6220 | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3944 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-d76bd75e | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3945 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a4a13b32 | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3949 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-dbef2fd0 | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3951 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-17b46d33 | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3953 | if (frm.DialogResult == DialogResult.OK) ▸ if (measure["chk_week_sun"] != null && week_sun != measure["chk_week_sun"].On) | FLAG | weekSunChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2a5e5edc | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3976 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ i… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bcd899e1 | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3985 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a5037209 | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3992 | if (frm.DialogResult == DialogResult.OK) ▸ if (initchk_totalBatch) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanByLineElectrodeProduction, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-aad9da33 | this.btnBucket.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3994 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96b60a73 | this.btnCatagory.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3712 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-1d6be6cf | this.btnCatagory.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3715 |  | POPUP | new FP00620_MeasureSetForm_Popup | ("FP00620", SpdSheet.shtPlanByLineElectrodeProduction, false, "") | 팝업/폼 생성 |  |  |  |
| AC-6d6e2fd0 | this.btnCatagory.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3716 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-122e520e | this.btnCatagory.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3717 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2a82acaf | this.btnCatagory.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3718 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3cb81343 | this.btnCatagory.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3723 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-233dbf95 | this.btnCatagory.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3735 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0545ea49 | this.btnCatagory.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3744 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0ea5eaf9 | this.btnCatagory.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3749 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-9e22866e | this.btnCatagory.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3755 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-657f7ad2 | this.btnCatagory.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3764 | if (initchk_totalBatch) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanByLineElectrodeProduction, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d09bbae4 | this.btnColumn.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3672 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-1162e32f | this.btnColumn.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3675 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00620", SpdSheet.shtPlanByLineElectrodeProduction, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-e53674fd | this.btnColumn.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3676 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-451e5b10 | this.btnColumn.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3677 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7ac2206e | this.btnColumn.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3684 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-e30d4b1c | this.btnColumn.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3684 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanByLineElectrodeProductio… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f352fd80 | this.btnColumn.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3685 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-b9068b84 | this.btnColumn.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3691 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-df9bf0b1 | this.btnColumn.Click | FP00620_PlanBy_Line_Electrode_Production.cs:3700 | if (initchk_totalBatch) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanByLineElectrodeProduction, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72e79821 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4069 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-3fa3fb93 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4070 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b37e2c4e | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4073 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-09e07c5b | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4074 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-c0ab37f9 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4075 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-c6d0ffed | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4076 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4bc29c34 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4077 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-c959a39e | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4078 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-5e4ba613 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4079 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fa93bec9 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4079 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e2e0c1a6 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4080 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d9c9af51 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4081 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2d485e46 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4082 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1b608c73 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4083 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-470d4514 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4084 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7b610df2 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4085 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ad8ddbcf | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4086 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d57af5cb | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4087 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6f4583ab | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4088 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-720a5654 | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4090 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cd04dcbf | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4091 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-797abe3f | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4092 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-5c6db94f | this.btnMemo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4093 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af47a0ef | this.btnPlanInfo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4020 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-22db2a7b | this.btnPlanInfo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4021 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c4f01e5 | this.btnPlanInfo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4027 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-da7eca64 | this.btnPlanInfo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4030 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3cf93ea4 | this.btnPlanInfo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4031 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6543c35a | this.btnPlanInfo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4031 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1557455c | this.btnPlanInfo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4032 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-080547a7 | this.btnPlanInfo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4033 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5e66acab | this.btnPlanInfo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4035 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-67c80761 | this.btnPlanInfo.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4036 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01563c07 | this.btnSql.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4104 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-7bf2e341 | this.btnSql.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4107 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a552fd7b | this.btnSql.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4108 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a94cb743 | this.btnSql.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4110 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00620_PlanBy_Line_Electrode_Production_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-ecdf9e94 | this.btnSql.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4111 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00620_PlanBy_Line_Electrode_Production_MEMO") | 데이터 객체 조작/조회 |  |  |  |
| AC-41fbd193 | this.btnSql.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4113 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.CheckAndGetMeasure

진입점: this.Load / popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_Electrode_Production_MAIN") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineEle…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe2ce408 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3215 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-678a5d67 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3215 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-be288235 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3216 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00620_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fad3f1ed | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3216 |  | POPUP | new FP00620_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-b0786187 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3217 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00620_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b7b8d56 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3217 |  | POPUP | new FP00620_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-d4d1b09b | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3220 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-500b6232 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3221 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-832fe950 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3222 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-a43f9414 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3223 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-67bd90d6 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3224 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-a9d2dc26 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3225 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |
| AC-3e156203 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3226 |  | DATA_OP | measure.Data.ContainsKey | ("chk_totalBatch") | 데이터 객체 조작/조회 |  |  |  |
| AC-2239f533 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3227 | if (measure.Data.ContainsKey("chk_totalBatch")) | FLAG | weekTOT_measure | measure.Data["chk_totalBatch"] | 화면 필드/플래그 변경 |  |  |  |
| AC-593ab379 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3228 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week_sun") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7c0dca1 | this.Load 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:3229 | if (measure.Data.ContainsKey("chk_week_sun")) | FLAG | week_measure_sun | measure.Data["chk_week_sun"] | 화면 필드/플래그 변경 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.checkTotalBatch

진입점: spdMain.ActiveSheet.CellChanged [if (initchk_totalBatch == true && check_cell_chg == false) ▸ if (!saveTotalBatch.Contains(new Tuple<int, int>(e.Row, e.Column)))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b268486b | spdMain.ActiveSheet.CellChanged [if (initchk_totalBatch == t… | FP00620_PlanBy_Line_Electrode_Production.cs:4644 |  | FLAG | check_cell_chg | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a1462b35 | spdMain.ActiveSheet.CellChanged [if (initchk_totalBatch == t… | FP00620_PlanBy_Line_Electrode_Production.cs:4668 | if (initchk_totalBatch) ▸ if (select_measure == "Batch") ▸ if (sHeadNameLevel2.Equals("Total Batch")) | DATA_OP | saveTotalBatch.Contains | (new Tuple<int, int>(e.Row, e.Column)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a9e6060 | spdMain.ActiveSheet.CellChanged [if (initchk_totalBatch == t… | FP00620_PlanBy_Line_Electrode_Production.cs:4670 | if (initchk_totalBatch) ▸ if (select_measure == "Batch") ▸ if (sHeadNameLevel2.Equals("Total Batch")) ▸ if (saveTotalBatch.Contains(new Tupl… | DATA_OP | saveTotalBatch.Remove | (new Tuple<int, int>(e.Row, e.Column)) | 데이터 객체 조작/조회 |  |  |  |
| AC-747c3b4b | spdMain.ActiveSheet.CellChanged [if (initchk_totalBatch == t… | FP00620_PlanBy_Line_Electrode_Production.cs:4672 | if (initchk_totalBatch) ▸ if (select_measure == "Batch") ▸ if (sHeadNameLevel2.Equals("Total Batch")) | DATA_OP | saveTotalBatch.Add | (new Tuple<int, int>(e.Row, e.Column)) | 데이터 객체 조작/조회 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.Chk_totalBatch_CheckedChanged

진입점: chk_totalBatch.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8579d801 | chk_totalBatch.CheckedChanged | FP00620_PlanBy_Line_Electrode_Production.cs:335 | if (!initchk_totalBatch) | VALUE_SET | chk_totalBatch.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.CreateFilterDataSet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eabdd66 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2980 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-852ca2c4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2992 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-3ac60082 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2993 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-e502dcba | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3011 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e38d407 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3016 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7412391d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3021 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4631660 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3026 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d6224d9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3034 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e3678d2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3039 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-eeeaeed9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3044 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0291f3e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3049 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd4dd001 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3062 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e6727be | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3067 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3486e7c5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3072 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e1a8f88 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3077 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-04809a7a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3085 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c081cf5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3090 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-30b1bf79 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3095 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-af04ee92 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3100 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5af73cb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3107 | if (measure["chk_seq"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_SEQ")) | 데이터 객체 조작/조회 |  |  |  |
| AC-75e22190 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3113 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d288d78c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3119 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e77e33f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3128 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_memo_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d2b46f2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3135 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-704d2239 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3140 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6314d75e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3145 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d74acbe | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3150 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-43f631d3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3158 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a493121d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3163 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9088789d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3168 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6b4b381 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3173 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d9c1f9a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3185 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2e92505 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3188 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d23529a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3192 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-29a72695 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3197 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-580e9bc3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3201 | else of (m != null && m.Count() > 0) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ff1b28d9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3201 | else of (m != null && m.Count() > 0) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-8b06c2c4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3206 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-09c42791 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3208 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aeb85d93 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:618 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanByLineElectrodeProduction, SpdSheet.shtPlanByLineElectrodeProduc… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4e2756c0 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:619 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanByLineElectrodeProduction) | 화면 필드/플래그 변경 |  |  |  |
| AC-3705af1b | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:620 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanByLineElectrodeProduction) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged / this.dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-670abbc7 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3496 | if (sender == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f9875dc | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3503 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17844c07 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3507 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dayCount > 1000) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb49c9c4 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3511 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | FLAG | dtBlock_enddate | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "find_Block_End_Date", sInstance, s… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b878b05e | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3511 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Block_End_Date", sInstance, sPlanDate, UserInfoContext.Current.User… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-534ac521 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3515 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | FLAG | dtPeriod | DataService.FP_ExecuteQuery2("FP00620", "find_PlanPeriod", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanPeriod] \| FP\Planning… | 화면 필드/플래그 변경 |  |  |  |
| AC-a10e2d6c | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3515 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00620", "find_PlanPeriod", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanPeriod] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-81a1a6f5 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3519 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dayCount > 84) | MESSAGE | MessageBox.Show | ("Period MAX 84 days.") | 메시지 표시 |  |  |  |
| AC-6d98a193 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3543 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dayCount > 84) ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, dDefalultEndDateAdd.ToString("yyyyMMdd")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db885654 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3553 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dayCount > 84) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDateAdd | 속성 Value2 설정 |  |  |  |
| AC-24eaa1b4 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3557 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dayCount > 84) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4c6d90f | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3563 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date.") | 메시지 표시 |  |  |  |
| AC-46edf432 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3564 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-92190ae8 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3582 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (Convert.ToDecimal(arrRetEnd) > Convert.ToDecimal(sPlanEndDate)) | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(" + sPlanEndDate + ")!") | 메시지 표시 |  |  |  |
| AC-74acb9c1 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3585 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (Convert.ToDecimal(arrRetEnd) > Convert.ToDecimal(sPlanEndDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-037f1f10 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3601 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (checkCnt == 2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-362c27d3 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3603 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) | FLAG | d1 | DateTime.ParseExact(dCalendar_planrange.Text1, "yyyyMMdd", System.Globalization.CultureInf… | 화면 필드/플래그 변경 |  |  |  |
| AC-79480652 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3604 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) | FLAG | d2 | DateTime.ParseExact(dCalendar_planrange.Text2, "yyyyMMdd", System.Globalization.CultureInf… | 화면 필드/플래그 변경 |  |  |  |
| AC-3b34f5db | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3608 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | POPUP | FoxMessageBox.Show | ("Start Date is only available on Monday.\n End Date is only available on Sunday.") | 팝업/폼 열기 |  |  |  |
| AC-e012a345 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3612 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d1 | d1.AddDays(-1) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd295a20 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3613 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d1 | d1.AddDays(-2) | 화면 필드/플래그 변경 |  |  |  |
| AC-2678f2dc | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3614 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d1 | d1.AddDays(-3) | 화면 필드/플래그 변경 |  |  |  |
| AC-df849f91 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3615 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d1 | d1.AddDays(-4) | 화면 필드/플래그 변경 |  |  |  |
| AC-a5a2144b | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3616 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d1 | d1.AddDays(-5) | 화면 필드/플래그 변경 |  |  |  |
| AC-f72509ee | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3617 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d1 | d1.AddDays(-6) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc6bc66f | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3621 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d1 | d1.AddDays(-7) | 화면 필드/플래그 변경 |  |  |  |
| AC-757c929a | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3623 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | UI_PROP | dCalendar_planrange.ValueStart | d1 | 속성 ValueStart 설정 |  |  |  |
| AC-9364d0b9 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3624 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | UI_PROP | dCalendar_planrange.Value1 | d1 | 속성 Value1 설정 |  |  |  |
| AC-3359d427 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3631 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d2 | d2.AddDays(+6) | 화면 필드/플래그 변경 |  |  |  |
| AC-24e7da4f | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3632 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d2 | d2.AddDays(+5) | 화면 필드/플래그 변경 |  |  |  |
| AC-b38e6492 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3633 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d2 | d2.AddDays(+4) | 화면 필드/플래그 변경 |  |  |  |
| AC-433759a2 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3634 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d2 | d2.AddDays(+3) | 화면 필드/플래그 변경 |  |  |  |
| AC-e0acfb08 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3635 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d2 | d2.AddDays(+2) | 화면 필드/플래그 변경 |  |  |  |
| AC-89bdc770 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3636 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d2 | d2.AddDays(+1) | 화면 필드/플래그 변경 |  |  |  |
| AC-88c769c0 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3642 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | FLAG | d2 | d2.AddDays(-7) | 화면 필드/플래그 변경 |  |  |  |
| AC-3df87326 | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3645 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | UI_PROP | dCalendar_planrange.ValueEnd | d2 | 속성 ValueEnd 설정 |  |  |  |
| AC-4721f7ab | dCalendar_planrange.ValueChanged 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:3646 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (bFormLoad == true && chk_totalBatch.Checked == true) ▸ if (d1.DayOfWeek != Da… | UI_PROP | dCalendar_planrange.Value2 | d2 | 속성 Value2 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb3400b8 | DeleteButton | FP00620_PlanBy_Line_Electrode_Production.cs:896 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07e32e9f | Dispose | FP00620_PlanBy_Line_Electrode_Production.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.DrawHeader

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-daa550d7 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3778 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-81159822 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3782 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-a5187ebc | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3783 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78a6d66e | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3784 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-424b3f73 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3785 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa305817 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3786 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-e238dca4 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3790 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-d22b8080 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3791 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-c7cac849 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3792 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-3937ea76 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3793 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-7a2aa69d | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3805 | else of (with_day_part == false) | CALL_EXT | measure.Data.TryGetValue | ("chk_totalBatch", out total_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-123aa978 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3815 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(bUse_month, bUse_week, bUse_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-b03bbee8 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3819 | else of (with_day_part == false) ▸ if (bUse_total) | FLAG | DayColumnCount | += (calendar.weeks.Count + 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-46a1a2ed | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3822 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d934ce1e | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3878 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanByLineElectrodeProduction, app… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0bc34b4e | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3884 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) | CALL_EXT | measure.Data.TryGetValue | ("chk_totalBatch", out tmpMeasure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a6fef1e | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3888 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) ▸ if (measure.Data.TryGetValue("chk_totalBatch", o… | FLAG | _amendColumnsCnt | measure.AmendColumns.Rows.Count + calendar.weeks.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-0a95f54b | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3892 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) ▸ if (measure.Data.TryGetValue("chk_totalBatch", o… | FLAG | _amendColumnsCnt | measure.AmendColumns.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-789bd277 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3897 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) ▸ else of (measure.Data.TryGetValue("chk_totalBatc… | FLAG | _amendColumnsCnt | measure.AmendColumns.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-2e832e6e | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3904 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | DayColumnCount | siMain.SetAmendHeaderColumn_00620_FP(calendar, bUse_month, bUse_week, bUse_day, bUse_total… | 화면 필드/플래그 변경 |  |  |  |
| AC-9dda87ca | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3904 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_00620_FP | (calendar, bUse_month, bUse_week, bUse_day, bUse_total, 2, FPExtensions.DateColumnType.TYP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e463dfc1 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3907 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1efc17c8 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3908 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a26dc87 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3909 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-6e1056f2 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3911 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-6ca6a8d1 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3913 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-490014fe | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3914 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f8660e8b | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:3919 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.DrawSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-130bbe02 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2474 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4d31447a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2476 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5c9ffab | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2501 |  | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1fa3f40 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2502 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51aefaeb | EditButton | FP00620_PlanBy_Line_Electrode_Production.cs:904 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e09f464 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:948 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04feccb9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:952 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-65633593 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:956 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-4b511c36 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:960 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20501916 | ExcelButton | FP00620_PlanBy_Line_Electrode_Production.cs:919 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-18ccc5d7 | ExcelButton | FP00620_PlanBy_Line_Electrode_Production.cs:920 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-7703c511 | ExcelButton | FP00620_PlanBy_Line_Electrode_Production.cs:922 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5a87c1c8 | ExcelButton | FP00620_PlanBy_Line_Electrode_Production.cs:926 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-de666064 | ExcelButton | FP00620_PlanBy_Line_Electrode_Production.cs:927 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-89d5df06 | ExcelButton | FP00620_PlanBy_Line_Electrode_Production.cs:928 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-834693b8 | ExcelButton | FP00620_PlanBy_Line_Electrode_Production.cs:931 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-33728c76 | ExcelButton | FP00620_PlanBy_Line_Electrode_Production.cs:932 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-187d7fd6 | ExcelButton | FP00620_PlanBy_Line_Electrode_Production.cs:933 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-4315c860 | ExcelButton | FP00620_PlanBy_Line_Electrode_Production.cs:935 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-47d57bc2 | ExcelButton | FP00620_PlanBy_Line_Electrode_Production.cs:936 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.ExportExcelSimple

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b2b4246 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:980 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fc05e911 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:983 | try ▸ if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd13cfbc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:989 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9d16910a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:997 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1757c7c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1001 | try ▸ if (myarray.Length == 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3d5277c6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1002 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ab1ddf2 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1006 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-39a056e0 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1048 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.LoadObjectXml | (typeof(FarPoint.Win.Spread.SheetView), FarPoint.Win.Serializer.GetObjectXml(sv, "CopyShee… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca371205 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1048 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.GetObjectXml | (sv, "CopySheet") | ⚠ 의미 확인 필요 |  |  |  |
| AC-904f41b8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1054 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-65ef4411 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1068 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-9aa93ede | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1072 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (RemoveActionCell == tr… | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-02aff008 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1076 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd93de68 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1088 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-057387c2 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1089 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-bbd28859 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1098 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-a14d9777 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1099 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-1f214a39 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1105 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-2e2110a7 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1114 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-59b5f3f8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1116 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-57220033 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1119 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.FrozenColumnCount | FrozenColumnCount | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-be965a84 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1128 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (ignoreDepth > 0) ▸ for (i < newSheet.RowCount) ▸ for (j < collen) ▸ if (newSheet.Cells… | GRID_SET | newSheet.Cells[i, j].Value | null | 그리드 속성/값 설정 |  |  |  |
| AC-8b40b264 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1139 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-e576ed2d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1148 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-c72c50f7 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1157 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a025a76 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1164 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | UI_PROP | si.MaxRightMerge | 50 | 속성 MaxRightMerge 설정 |  |  |  |
| AC-8779e55f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1165 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | CALL_EXT | si.RightColMerge | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-033daae8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1170 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.SeperatedRows: case ExcelExp… | CALL_EXT | si.UnMerge | (newSheet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-435f7b9c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1177 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 0, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-131b4a9c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1179 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-3d2d67bf | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1183 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-2ec6f0af | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1185 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-f82a238a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1188 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-4e3d399c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1190 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-14556699 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1195 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-6ea9a89d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1210 | try | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-56030b0f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1216 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ca862db8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1220 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.Find_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79901ce2 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2075 | if (siMain.ActiveSheet.Columns[0].DataField.ToUpper() == "ACTION") ▸ if (siMain.ActiveSheet.Columns[0].Visible) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-864b8913 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2081 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-eeccff02 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2091 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b2ab0431 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2092 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9796340c | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2096 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fef01c99 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2097 | try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cd67c596 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2105 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanByLineElectrodeProduction) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-47a891b8 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2112 | try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-88617971 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2112 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c6f34859 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2123 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8fb6cc2 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2137 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0c19b619 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2139 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7ca52d58 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2141 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-f2f34379 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2146 | try ▸ else of (dsMain != null) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f905d886 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2148 | try ▸ else of (dsMain != null) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1f2ffbca | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2150 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-84e11a61 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2156 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-936a1a3d | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2162 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c17ed744 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2164 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3a13ffe6 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2165 | finally | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c7838de | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2174 |  | FLAG | initchk_totalBatch | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e05ad837 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:2175 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanByLineElectrodeProduction, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_Electrode_Production_MAIN")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ lambda] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ lamb…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a43eb99e | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2190 | try | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0969b2f7 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2191 | try | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b224eb88 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2192 | try | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-04feb5f1 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2193 | try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9ac970f3 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2194 | try | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5adb8a49 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2195 | try | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dc20aca4 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2202 | try ▸ if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca3f9053 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2203 | try ▸ if (week_measure_sun != null && week_measure_sun.On) | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b272d742 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2204 | try ▸ if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ee859f22 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2205 | try ▸ if (week_measure_sun != null && week_measure_sun.On) | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-49abf985 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2209 | try ▸ else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4795fc1c | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2210 | try ▸ else of (week_measure_sun != null && week_measure_sun.On) | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-76a75f16 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2211 | try ▸ else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a25c52d | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2212 | try ▸ else of (week_measure_sun != null && week_measure_sun.On) | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-f3ce314a | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2214 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e773f104 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2215 | try | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-6a711ab9 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2220 | try ▸ if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-854a5bdd | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2224 | try ▸ else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fef3edab | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2226 | try | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-a03ad598 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2228 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00620_" + SpdSheet.shtPlanByLineElectrodeProduction) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c6e57f8 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2229 | try | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-f4ce7031 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2231 | try | CALL_EXT | DataService.ToLoopParam2 | ("", Data_FP.CallGeneralProcedure2(("PR_UI_FP00612_ETC").ToUpper(), Filter, _CurrentUser, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-d07b40f7 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2231 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00612_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "CURR_DATE_COL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-db66b6d2 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2237 | try ▸ if (tmpDate != "") | DATA_OP | Filter["CURR_DATE_COL"] | D_COL_DATA[1] | 행/컬럼 값 대입 |  |  |  |
| AC-41ee8e0c | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2246 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3b5c2de4 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2247 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-57cf007f | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2248 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f5855947 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2249 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2e85532c | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2261 | try ▸ if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMea… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-8135f9b5 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2267 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-24804131 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2268 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7dea1819 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2269 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3470d908 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2271 | try | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-bf9b66cd | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2272 | try | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-c167c8b2 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2273 | try | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-84cd30d1 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2274 | try | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-4b63b2f6 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2275 | try | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-b2879e9e | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2276 | try | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-9331ec37 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2277 | try | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |
| AC-01d7c93d | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2280 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00620_FIND_FP00620", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7b52a4b1 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2282 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-40aa5824 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:2286 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.Find_Data_Memo

진입점: popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_Electrode_Production_MEMO")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1172e2f1 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… | FP00620_PlanBy_Line_Electrode_Production.cs:3391 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00620_FIND_FP00620", Filter, _CurrentUser, pSysType, "SELECT_MEA_MEMO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-aeb94ae7 | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… | FP00620_PlanBy_Line_Electrode_Production.cs:3393 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-17d12f7d | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… | FP00620_PlanBy_Line_Electrode_Production.cs:3397 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.FindTotalColorStart

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff7d70a6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2974 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb662051 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:2009 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-660b5a97 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:229 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-057112d8 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:242 |  | FLAG | bFormLoad | true | 화면 필드/플래그 변경 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_Electrode_Production_MEMO") ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try] / SaveButton […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98a4088c | popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_El… 외 4 | FP00620_PlanBy_Line_Electrode_Production.cs:4843 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.GetFilterBatch

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0193c314 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4853 |  | RETURN | return FilterBatch[key]; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.GetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-125d9579 | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4861 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-88a99b59 | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4862 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ec07e7c0 | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4862 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6be027d8 | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4864 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-7554c352 | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4866 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e326cbc0 | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4869 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-9723b87a | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4870 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-bf8dc9ff | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4870 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-1cce03a4 | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4871 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8984d92 | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4872 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-560acbc8 | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4873 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8c47213a | this.Load [try] | FP00620_PlanBy_Line_Electrode_Production.cs:4877 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31749e6a | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5054 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-76fbaa52 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:5055 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.GetToDay

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / dCalendar_planrange.ValueChanged [if (getTypeName == "System.Windows.Forms.MaskedTextBox")] / popSql.OnSql [if (programID == "PR_UI_FP00620_PlanBy_Line_Electrode_Production_MEMO") ▸ lambda ▸ if (dt != null) ▸ else of (dt.Rows.Count > 0)] / this.dCalendar_planrange.ValueChanged [if (getTypeName == "System.Windows.Forms.MaskedTextBox")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ lambda ▸ try ▸ lambda ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a2ca998 | this.Load [try] 외 8 | FP00620_PlanBy_Line_Electrode_Production.cs:5003 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-f216e325 | this.Load [try] 외 8 | FP00620_PlanBy_Line_Electrode_Production.cs:5004 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.GoDrawCellColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e2234fd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3235 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cf789bc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3299 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d77e1f7a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:3300 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-875769d3 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:440 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-55a8f279 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:443 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanByLineElectrodeProduction) | 데이터 객체 조작/조회 |  |  |  |
| AC-0baef2af | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:445 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-76085499 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:446 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b3bce3dc | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:449 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dda68b97 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:452 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-afd6059f | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:477 | try | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-a56386de | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:478 | try | FLAG | colorInfo | DataService.FP_ExecuteQuery("AmendMemo", "find_SetupColor_P", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P] \| FP\Common… | 화면 필드/플래그 변경 |  |  |  |
| AC-6586d30f | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:478 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_SetupColor_P", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-81645031 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:483 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-cd33b831 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:484 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-17c1c4e3 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:485 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7de73bb5 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:491 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46c7f89c | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:291 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-3f5240da | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:292 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-53b3fa29 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:293 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5450606b | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:294 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ce6304bd | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:295 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-7edfe4bb | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:317 |  | VALUE_SET | usrCombo_Zoom.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.InitSpread

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-011af788 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:633 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e4f63a4 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:634 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanByLineElectrodeProduction) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-825d9a63 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:635 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanByLineElectrodeProduction, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e70eac06 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:639 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-948b1444 | InsertButton | FP00620_PlanBy_Line_Electrode_Production.cs:888 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee38fe85 | memo_menu.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4770 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-680b6659 | memo_menu.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4773 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3ce61a0 | memo_menu.Click | FP00620_PlanBy_Line_Electrode_Production.cs:4777 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b236d4b | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4792 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c004d1a | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4795 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-590fb0d5 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4813 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-429d1ee7 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4814 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9ef04e6b | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4815 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-85d249f8 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4816 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c8dc41d9 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4817 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-9fa20026 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4818 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-9c4c065a | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4819 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-518358d0 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4820 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6c2aefba | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4821 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bc49cf0 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4688 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6a792bf | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4691 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45424633 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4715 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79771d70 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4729 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8726d2b8 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4732 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b32dfbc | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:4756 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.OpenLineMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cee3ebe4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4415 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-929e2471 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4416 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-f7a6111d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4417 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-41376acd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4417 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-538610aa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4418 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-9bdce0f6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4419 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6d3146f7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4420 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dc1fabb4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4425 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80bde6bb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4428 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.OpenMaterialMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-411ce897 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4434 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-f4815dd9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4435 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-20728584 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4436 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-dd144c38 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4436 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-61d5cb87 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4437 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-4ac55dfd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4438 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-88bbbee0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4439 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fd983946 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4443 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b0bbe064 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4445 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.Query

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-043b7f09 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2419 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-c151d43e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2419 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d3df8f79 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2420 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-b5795995 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2420 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bc124b82 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2421 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-22f062bc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2421 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-231ea9cf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2424 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b7c52acf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2431 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-e29ecca6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2436 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0cae6cb6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2459 | foreach (AmendWeek a in calendar.Weeks.Values) ▸ if (!string.IsNullOrWhiteSpace(weekName)) ▸ for (row_idx < data.Tables[0].Rows.Count) ▸ if … | DATA_OP | row[sColName] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-61167ec1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2465 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b2716ab | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2467 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.RefreshHeadAndBody

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbb5df77 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2388 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a743f7f4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2404 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-21ed1699 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2408 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.RefreshSpreadSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab866922 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2364 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b8388ed | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2364 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-b3034a56 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2376 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fcadebc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2381 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b13c2df | popSql.OnSql | FP00620_PlanBy_Line_Electrode_Production.cs:5023 | if (programID == "PR_UI_FP00620_PlanBy_Line_Electrode_Production_MAIN") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-361c8e0c | popSql.OnSql | FP00620_PlanBy_Line_Electrode_Production.cs:5032 | if (programID == "PR_UI_FP00620_PlanBy_Line_Electrode_Production_MEMO") | RETURN | return Find_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-b454b7f9 | popSql.OnSql | FP00620_PlanBy_Line_Electrode_Production.cs:5036 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adf72b3d | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:912 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c706755 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:1612 |  | DATA_OP | saveTotalBatch.Sort | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c23248b2 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:1685 | for (i < saveTotalBatch.Count) ▸ for (k < end) ▸ if (SP_DataSource.Tables[0].Rows[iRow][dayIndex] != DBNull.Value) ▸ if (value != "0.00000" … | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00620_FIND_FP00620", FilterBatch, _CurrentUser, "merge_batch", "merge_batch") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6a27b375 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:1686 | for (i < saveTotalBatch.Count) ▸ for (k < end) ▸ if (SP_DataSource.Tables[0].Rows[iRow][dayIndex] != DBNull.Value) ▸ if (value != "0.00000" … | CALL_EXT | Task.Delay | (10) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1126e804 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:1694 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1cdddd98 | SaveButton | FP00620_PlanBy_Line_Electrode_Production.cs:1699 |  | CALL_EXT | saveTotalBatch.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SaveSimplexcel

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fa6be84 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1246 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < spSheet.Columns.Count) | DATA_OP | spSheet.Columns[i].DataField.ToUpper().Contains | ("W0") | 데이터 객체 조작/조회 |  |  |  |
| AC-068380df | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1251 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < spSheet.Columns.Count) | DATA_OP | spSheet.Columns[i].DataField.ToUpper().Contains | ("D0") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e8e87ca | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1267 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (i == 0) | DATA_OP | xSheet.ColumnWidths[j] | spSheet.ColumnHeader.Columns[j].Width / 9 | 행/컬럼 값 대입 |  |  |  |
| AC-3b4c06bf | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1269 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j] | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-a4f1aae6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1274 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Bottom | 그리드 속성/값 설정 |  |  |  |
| AC-ad357884 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1277 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-cd18b467 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1280 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-44ff033b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1283 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-b362baff | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1286 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Justify | 그리드 속성/값 설정 |  |  |  |
| AC-1294176e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1289 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-565d68fc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1292 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-7cb459b2 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1299 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Left | 그리드 속성/값 설정 |  |  |  |
| AC-97e84299 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1302 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Center | 그리드 속성/값 설정 |  |  |  |
| AC-e50917f1 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1305 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.None | 그리드 속성/값 설정 |  |  |  |
| AC-4c7aa5a4 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1308 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.General | 그리드 속성/값 설정 |  |  |  |
| AC-7ea707ad | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1311 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Justify | 그리드 속성/값 설정 |  |  |  |
| AC-3cf4bcd6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1314 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Right | 그리드 속성/값 설정 |  |  |  |
| AC-a4ca5ed9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1318 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].ColSpan | cell.ColumnSpan | 그리드 속성/값 설정 |  |  |  |
| AC-2e036a71 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1319 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].RowSpan | cell.RowSpan | 그리드 속성/값 설정 |  |  |  |
| AC-fb6972aa | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1320 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Border | Simplexcel.CellBorder.All | 그리드 속성/값 설정 |  |  |  |
| AC-2ec356f1 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1322 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-e6e63a10 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1328 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (!fg.IsEmpty) | GRID_SET | xSheet.Cells[i, j].TextColor | Simplexcel.Color.FromArgb(fg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-2b43c2c2 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1328 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (!fg.IsEmpty) | CALL_EXT | fg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c58f1e08 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1334 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Fill.BackgroundColor | Simplexcel.Color.FromArgb(0, 240, 240, 240) | 그리드 속성/값 설정 |  |  |  |
| AC-00559096 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1337 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (cell.Font != null) | GRID_SET | xSheet.Cells[i, j].FontSize | (int)cell.Font.Size | 그리드 속성/값 설정 |  |  |  |
| AC-2de50270 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1340 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ else of (cell.Font != n… | GRID_SET | xSheet.Cells[i, j].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-2bacc791 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1362 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-7ec0aa3d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1363 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-732e4c5e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1371 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-5f7743be | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1372 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-42f74814 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1377 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-e900c49e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1378 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-a3e30882 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1384 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | ss | 그리드 속성/값 설정 |  |  |  |
| AC-f069ce96 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1390 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-7198d29a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1400 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-e29191a1 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1401 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-a0561f81 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1407 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-954c841e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1408 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-663ebb97 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1413 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-bb8ea7bf | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1417 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-00a8b3bd | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1424 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!fg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].TextColor | Simplexcel.Color.FromArgb(fg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-dbb4b28b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1424 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!fg.IsEmpty) | CALL_EXT | fg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f8223778 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1428 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!bg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.FromArgb(bg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-a70a45e6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1428 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!bg.IsEmpty) | CALL_EXT | bg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-652de620 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1432 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ else of (!bg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-e678b3d9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1437 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].FontSize | (int)spSheet.Cells[i, j].Font.Size | 그리드 속성/값 설정 |  |  |  |
| AC-77e1385d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1439 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].Bold | true | 그리드 속성/값 설정 |  |  |  |
| AC-c6f6455e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1441 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].Italic | true | 그리드 속성/값 설정 |  |  |  |
| AC-5e70b29b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1444 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ else of (spSheet.Cells[i, j].Font !… | GRID_SET | xSheet.Cells[id, jd].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-730a55ee | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1446 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) | GRID_SET | xSheet.Cells[id, jd].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-7f83dea3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1458 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (j < colcount) ▸ if (xSheet.Cells[0, j].Value != null) | DATA_OP | xSheet.Cells[0, j].Value.ToString().ToUpper().Contains | ("PPM") | 데이터 객체 조작/조회 |  |  |  |
| AC-61d27152 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1478 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ if (ppm != -1) ▸ for (i < rowcount) ▸ if (xSheet.Cells[i, ppm].Value != null … | GRID_SET | xSheet.Cells[i, ppm].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-744e44bc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1484 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ if (ppm != -1) ▸ for (i < rowcount) ▸ if (xSheet.Cells[i, ppm].Value != null … | GRID_SET | xSheet.Cells[i, ppm].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-0d63cc70 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1485 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ if (ppm != -1) ▸ for (i < rowcount) ▸ if (xSheet.Cells[i, ppm].Value != null … | GRID_SET | xSheet.Cells[i, ppm].HorizontalAlignment | Simplexcel.HorizontalAlign.Right | 그리드 속성/값 설정 |  |  |  |
| AC-7551c8df | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1489 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ if (ppm != -1) ▸ for (i < rowcount) ▸ if (xSheet.Cells[i, ppm].Value != null … | GRID_SET | xSheet.Cells[i, ppm].Value | String.Format("{0}", m) | 그리드 속성/값 설정 |  |  |  |
| AC-436bd8e8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1490 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ if (ppm != -1) ▸ for (i < rowcount) ▸ if (xSheet.Cells[i, ppm].Value != null … | GRID_SET | xSheet.Cells[i, ppm].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-91e64d70 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1491 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ if (ppm != -1) ▸ for (i < rowcount) ▸ if (xSheet.Cells[i, ppm].Value != null … | GRID_SET | xSheet.Cells[i, ppm].HorizontalAlignment | Simplexcel.HorizontalAlign.Right | 그리드 속성/값 설정 |  |  |  |
| AC-b537c86e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1501 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ if (ppm != -1) ▸ for (i < rowcount) ▸ else of (xSheet.Cells[i, ppm].Value != … | GRID_SET | xSheet.Cells[i, ppm].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-1c3e81f5 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1502 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ if (ppm != -1) ▸ for (i < rowcount) ▸ else of (xSheet.Cells[i, ppm].Value != … | GRID_SET | xSheet.Cells[i, ppm].HorizontalAlignment | Simplexcel.HorizontalAlign.Right | 그리드 속성/값 설정 |  |  |  |
| AC-01ab17bb | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1516 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (j < colcount) ▸ if (xSheet.Cells[0, j].Value != null) | DATA_OP | xSheet.Cells[0, j].Value.ToString().ToUpper().Contains | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a020729 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1529 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (j < colcount) ▸ if (xSheet.Cells[0, j].Value != null) | DATA_OP | xSheet.Cells[0, j].Value.ToString().ToUpper().Contains | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebd7f7ff | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1545 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ if (i_MEASURE != -1) ▸ for (i < rowcount) | DATA_OP | xSheet.Cells[i, i_MEASURE].Value.ToString().ToUpper().Contains | ("BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0908b07 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1559 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ if (i_MEASURE != -1) ▸ for (i < rowcount) ▸ if (xSheet.Cells[i, i_MEASURE].Va… | GRID_SET | xSheet.Cells[i, j].Format | numformat_zero | 그리드 속성/값 설정 |  |  |  |
| AC-595e3e94 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1570 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) | GRID_INIT | xSheet.FreezeTopLeft | (spSheet.ColumnHeader.RowCount, froz) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-784da02b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1571 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) | DATA_OP | workbook.Add | (xSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-e99bff8d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1585 |  | UI_PROP | workbook.Title | name | 속성 Title 설정 |  |  |  |
| AC-900c7e63 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1586 |  | UI_PROP | workbook.Author | "GSCM,FP, logged as " + this.UserInfo.UserId | 속성 Author 설정 |  |  |  |
| AC-5ac73f25 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00620_PlanBy_Line_Electrode_Production.cs:1588 |  | CALL_EXT | workbook.Save | (fileName) | ⚠ 의미 확인 필요 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SetCalenderColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0570bfa9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2579 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-698e25d3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2583 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-001655fd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2585 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0a3214e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2589 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-8f92d45f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2605 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-06c3a9f2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2620 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-5acb4b48 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2637 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SetChangeControl

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / cbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / chk_allLine.CheckedChanged / chk_IncludeSubOp.CheckedChanged / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.chk_IncludeSubOp.CheckedChanged / this.chkInAct.CheckedChanged / this.chk_allLine.CheckedChanged / this.spdMain.CellDoubleClick […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e54cf0a3 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:539 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4c88bdef | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:539 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9be7b22a | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:548 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6331e81a | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:549 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6316acb3 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:549 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3aaffabe | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:550 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-de0e58b5 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:556 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-0f055ad7 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:557 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e00d8489 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:557 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-442d44f1 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:558 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1cd22deb | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:564 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-1cbd7a74 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:565 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a4f3c73 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:565 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d00bed3a | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:566 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fcb14633 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:572 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-4288bebf | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:573 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-9d5ae61c | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:573 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ebcb4816 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:574 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2741612b | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:581 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-491f9a33 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:583 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-08f4d38c | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:584 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fb69db6 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:585 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8428a91 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:586 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-37aaa48b | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:587 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | GRID_SET | dtOperation.Rows[0]["CODE"] | "E2000" | 그리드 속성/값 설정 |  |  |  |
| AC-29398c35 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:588 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | GRID_SET | dtOperation.Rows[0]["NAME"] | "(E2000)Coating" | 그리드 속성/값 설정 |  |  |  |
| AC-5cf6d66c | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:590 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e66a6085 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:596 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-76e8a522 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:597 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ddb2606a | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:597 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-448a5a61 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:598 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e0309e10 | this.Load [try] 외 14 | FP00620_PlanBy_Line_Electrode_Production.cs:604 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SetColumnsFormat

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e679941d | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2665 | if (siMain != null) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (om… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###;[red]-#,##0.###;;", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3819dd7 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2668 | if (siMain != null) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else o… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###;[red]-#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-239f488b | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2691 | if (siMain != null) ▸ if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###;[red]-#,##0.###;;", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7bef97f3 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2694 | if (siMain != null) ▸ if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###;[red]-#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-442e229a | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2719 | if (siMain != null) ▸ if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###;[red]-#,##0.###;;", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57c8603f | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2722 | if (siMain != null) ▸ if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ el… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###;[red]-#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f34a16b | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2740 | if (siMain != null) ▸ if (calendar.Days != null) ▸ if (colindex != -1) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##;[red]-#,##0.#####", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f0906e0 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2747 | if (siMain != null) ▸ if (calendar.Days != null) ▸ if (colindex != -1) ▸ for (i < weekCnt) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##;[red]-#,##0.#####", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-15a91f02 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2762 | if (siMain != null) | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-41fc3f43 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2771 | if (siMain != null) ▸ if (SP_DataSource == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-266c4124 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2784 | if (siMain != null) | DATA_OP | listBatchInx.Add | (batchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc929be1 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2820 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (select_measure == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.Active… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-c108addf | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2821 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (select_measure == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.Active… | DATA_OP | siMain.ActiveSheet.Cells[i, j].Value.ToString().Contains | ("-") | 데이터 객체 조작/조회 |  |  |  |
| AC-89b640ae | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2823 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (select_measure == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.Active… | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-1bc521b9 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2844 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (select_measure == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.A… | DATA_OP | listBatchInx.Add | (batchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-703e304b | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2858 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (select_measure == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.A… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-d48b1d04 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2859 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (select_measure == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.A… | DATA_OP | siMain.ActiveSheet.Cells[i, j].Value.ToString().Contains | ("-") | 데이터 객체 조작/조회 |  |  |  |
| AC-77bd8d50 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2861 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (select_measure == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.A… | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-25f5c685 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2895 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (select_category == "Plan(In)") ▸ if (select_measure == "Batch") ▸ for (j <… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-df03fcd1 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2902 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (select_category == "Plan(In)") ▸ if (select_measure == "Batch") ▸ for (j <… | GRID_SET | siMain.ActiveSheet.Cells[i, j].Value | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-941aa34b | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2903 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (select_category == "Plan(In)") ▸ if (select_measure == "Batch") ▸ for (j <… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-3034c759 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2904 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (select_category == "Plan(In)") ▸ if (select_measure == "Batch") ▸ for (j <… | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-e2631b38 | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2924 | if (siMain != null) ▸ if (ippm != -1) | UI_PROP | num_ppm.DecimalPlaces | place_ppm | 속성 DecimalPlaces 설정 |  |  |  |
| AC-737677fe | this.Load 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:2925 | if (siMain != null) ▸ if (ippm != -1) | GRID_SET | siMain.ActiveSheet.Columns[ippm].CellType | num_ppm | 그리드 속성/값 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b1a9268 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:278 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79995451 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:280 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-66b7ca61 | this.Load | FP00620_PlanBy_Line_Electrode_Production.cs:284 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SetDirty

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ finally] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ finally] / this.btnBucket.Click / this.btnCatagory.Click / this.btnColumn.Click / FindButton [try ▸ if (siMain.ActiveSheet.SheetName ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fddd2d27 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:878 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SetEditMode

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (initchk_totalBatch)] / this.btnCatagory.Click [if (initchk_totalBatch)] / this.btnColumn.Click [if (initchk_totalBatch)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ if (chk_totalBatch.Checked)] / SaveButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d34b946 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1727 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a4a439a7 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1787 | if (spdMain != null) ▸ if (isEdit) ▸ for (i < siMain.GetMaxColumnIndex()) ▸ if (si_totalBatchIndex != -1) | DATA_OP | si_TotalBatch_List.Contains | (si_totalBatchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-8310719d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1789 | if (spdMain != null) ▸ if (isEdit) ▸ for (i < siMain.GetMaxColumnIndex()) ▸ if (si_totalBatchIndex != -1) ▸ if (!si_TotalBatch_List.Contains… | DATA_OP | si_TotalBatch_List.Add | (si_totalBatchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3d057d8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1801 | if (spdMain != null) ▸ if (isEdit) | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-c353c4bb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1818 | if (spdMain != null) ▸ if (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (d < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].Rows[… | DATA_OP | ds_WeekSum_bool.Add | (false) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0ee6d80 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1825 | if (spdMain != null) ▸ if (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (d < dsMain.Tables[0].Rows.Count) ▸ else of (dsMain.Tables[0].… | DATA_OP | ds_WeekSum_bool.Add | (true) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1a15cd6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1829 | if (spdMain != null) ▸ if (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (d < dsMain.Tables[0].Rows.Count) ▸ else of (dsMain.Tables[0].… | DATA_OP | ds_WeekSum_bool.Add | (false) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae4ca608 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1851 | if (spdMain != null) ▸ if (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (j < siMain.ActiveSheet.RowCount) ▸ if (maesureName == "Batch"… | DATA_OP | s_line_name.ToUpper().Contains | ("TOTAL") | 데이터 객체 조작/조회 |  |  |  |
| AC-520d5365 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1853 | if (spdMain != null) ▸ if (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (j < siMain.ActiveSheet.RowCount) ▸ if (maesureName == "Batch"… | DATA_OP | si_Batch_row.Add | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-08e184a1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1869 | if (spdMain != null) ▸ if (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (k < si_Batch_row.Count) ▸ if (ds_WeekSum_bool[k]) | GRID_SET | siMain.ActiveSheet.Cells[si_Batch_row[k], siColumInx].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-9bad7064 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1870 | if (spdMain != null) ▸ if (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (k < si_Batch_row.Count) ▸ if (ds_WeekSum_bool[k]) | GRID_SET | siMain.ActiveSheet.Cells[si_Batch_row[k], siColumInx].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-e875370a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1909 | if (spdMain != null) ▸ else of (isEdit) ▸ for (i < siMain.GetMaxColumnIndex()) ▸ if (si_totalBatchIndex != -1) | DATA_OP | si_TotalBatch_List.Contains | (si_totalBatchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-39161016 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1911 | if (spdMain != null) ▸ else of (isEdit) ▸ for (i < siMain.GetMaxColumnIndex()) ▸ if (si_totalBatchIndex != -1) ▸ if (!si_TotalBatch_List.Con… | DATA_OP | si_TotalBatch_List.Add | (si_totalBatchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-a71fde52 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1923 | if (spdMain != null) ▸ else of (isEdit) | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-7922816c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1940 | if (spdMain != null) ▸ else of (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (d < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].… | DATA_OP | ds_WeekSum_bool.Add | (false) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c174b03 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1947 | if (spdMain != null) ▸ else of (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (d < dsMain.Tables[0].Rows.Count) ▸ else of (dsMain.Table… | DATA_OP | ds_WeekSum_bool.Add | (true) | 데이터 객체 조작/조회 |  |  |  |
| AC-db0f31d6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1951 | if (spdMain != null) ▸ else of (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (d < dsMain.Tables[0].Rows.Count) ▸ else of (dsMain.Table… | DATA_OP | ds_WeekSum_bool.Add | (false) | 데이터 객체 조작/조회 |  |  |  |
| AC-9671d830 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1972 | if (spdMain != null) ▸ else of (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (j < siMain.ActiveSheet.RowCount) ▸ if (maesureName == "B… | DATA_OP | s_line_name.ToUpper().Contains | ("TOTAL") | 데이터 객체 조작/조회 |  |  |  |
| AC-92d27a68 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1974 | if (spdMain != null) ▸ else of (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (j < siMain.ActiveSheet.RowCount) ▸ if (maesureName == "B… | DATA_OP | si_Batch_row.Add | (j) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c6e89d3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1989 | if (spdMain != null) ▸ else of (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (k < si_Batch_row.Count) ▸ if (ds_WeekSum_bool[k]) | GRID_SET | siMain.ActiveSheet.Cells[si_Batch_row[k], siColumInx].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-737604cf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1990 | if (spdMain != null) ▸ else of (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (k < si_Batch_row.Count) ▸ if (ds_WeekSum_bool[k]) | GRID_SET | siMain.ActiveSheet.Cells[si_Batch_row[k], siColumInx].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-2153e849 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00620_PlanBy_Line_Electrode_Production.cs:1991 | if (spdMain != null) ▸ else of (isEdit) ▸ for (i < si_TotalBatch_List.Count) ▸ for (k < si_Batch_row.Count) ▸ if (ds_WeekSum_bool[k]) | GRID_SET | siMain.ActiveSheet.Cells[si_Batch_row[k], siColumInx].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_factory.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57face5d | this.Load [try] 외 21 | FP00620_PlanBy_Line_Electrode_Production.cs:4838 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SetFilterBatch

진입점: SaveButton [for (i < saveTotalBatch.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcd1a334 | SaveButton [for (i < saveTotalBatch.Count)] | FP00620_PlanBy_Line_Electrode_Production.cs:4848 |  | DATA_OP | FilterBatch[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SetPlanPeriod

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e3b374a | this.Load [try] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4921 |  | FLAG | dtPeriod | DataService.FP_ExecuteQuery2("FP00620", "find_PlanPeriod", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanPeriod] \| FP\Planning… | 화면 필드/플래그 변경 |  |  |  |
| AC-5b3bc83c | this.Load [try] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4921 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00620", "find_PlanPeriod", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanPeriod] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-aff45254 | this.Load [try] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4938 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-82b6655e | this.Load [try] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4939 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-bac44240 | this.Load [try] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4945 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-92646e99 | this.Load [try] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4946 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-a06daf28 | this.Load [try] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4952 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-b6480aef | this.Load [try] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4953 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (mont…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf2ff04c | this.Load [try] 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:647 | if (sheetName.Equals(SpdSheet.shtPlanByLineElectrodeProduction)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0fce8ee7 | this.Load [try] 외 7 | FP00620_PlanBy_Line_Electrode_Production.cs:648 | if (sheetName.Equals(SpdSheet.shtPlanByLineElectrodeProduction)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SetTotalColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03cce2d8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2548 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "DATA": ▸ if… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_version, line, idx_version, Color.Orange) | 그리드 표시 설정 |  |  |  |
| AC-d6a41ae2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 6 | FP00620_PlanBy_Line_Electrode_Production.cs:2557 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9caf8567 | this.spdMain.CellClick | FP00620_PlanBy_Line_Electrode_Production.cs:4625 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-837d5117 | this.spdMain.CellClick | FP00620_PlanBy_Line_Electrode_Production.cs:4626 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-74422a82 | this.spdMain.CellClick | FP00620_PlanBy_Line_Electrode_Production.cs:4628 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e829619 | this.spdMain.CellClick | FP00620_PlanBy_Line_Electrode_Production.cs:4636 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3291adf | this.spdMain.CellDoubleClick | FP00620_PlanBy_Line_Electrode_Production.cs:4590 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx > e.Column - 1 - 7) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-f6b042c2 | this.spdMain.CellDoubleClick | FP00620_PlanBy_Line_Electrode_Production.cs:4597 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SpdMain_Changed

진입점: dsdmLine.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3246ef8 | dsdmLine.Changed | FP00620_PlanBy_Line_Electrode_Production.cs:249 | if (!this.CanModelChange \|\| e.Row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-258a3a73 | dsdmLine.Changed | FP00620_PlanBy_Line_Electrode_Production.cs:256 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72caf398 | dsdmLine.Changed | FP00620_PlanBy_Line_Electrode_Production.cs:265 | if (strColName == "Action") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51fca237 | this.spdMain.LeaveCell | FP00620_PlanBy_Line_Electrode_Production.cs:5364 |  | FLAG | check_cell_chg | false | 화면 필드/플래그 변경 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SwitchEdit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9178a9e8 | (진입점 미연결) | FP00620_PlanBy_Line_Electrode_Production.cs:1704 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.SwitchMemo

진입점: memo_menu.Click [try ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d0478d3 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4455 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f869aa3b | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4472 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-47f4f1c3 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4503 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-17141284 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4504 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-3646c4a9 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4506 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0a46d1d4 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4537 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-b7bda47b | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4538 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-89d8a7cf | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00620_PlanBy_Line_Electrode_Production.cs:4540 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.UIFindData

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87169731 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:677 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b9e892f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:678 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f94003f2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:681 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-610e0651 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:700 | try ▸ if (chk_totalBatch.Checked) ▸ if (Find_d1.DayOfWeek != DayOfWeek.Monday \|\| Find_d2.DayOfWeek != DayOfWeek.Sunday) ▸ if (Find_d1.DayO… | UI_PROP | dCalendar_planrange.ValueStart | Find_d1 | 속성 ValueStart 설정 |  |  |  |
| AC-ffdc53d2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:701 | try ▸ if (chk_totalBatch.Checked) ▸ if (Find_d1.DayOfWeek != DayOfWeek.Monday \|\| Find_d2.DayOfWeek != DayOfWeek.Sunday) ▸ if (Find_d1.DayO… | UI_PROP | dCalendar_planrange.Value1 | Find_d1 | 속성 Value1 설정 |  |  |  |
| AC-e62c8f25 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:717 | try ▸ if (chk_totalBatch.Checked) ▸ if (Find_d1.DayOfWeek != DayOfWeek.Monday \|\| Find_d2.DayOfWeek != DayOfWeek.Sunday) ▸ if (Find_d2.DayO… | UI_PROP | dCalendar_planrange.ValueEnd | Find_d2 | 속성 ValueEnd 설정 |  |  |  |
| AC-5e741c56 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:718 | try ▸ if (chk_totalBatch.Checked) ▸ if (Find_d1.DayOfWeek != DayOfWeek.Monday \|\| Find_d2.DayOfWeek != DayOfWeek.Sunday) ▸ if (Find_d2.DayO… | UI_PROP | dCalendar_planrange.Value2 | Find_d2 | 속성 Value2 설정 |  |  |  |
| AC-15f25e2f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:720 | try ▸ if (chk_totalBatch.Checked) ▸ if (Find_d1.DayOfWeek != DayOfWeek.Monday \|\| Find_d2.DayOfWeek != DayOfWeek.Sunday) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48d90b07 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:726 | try | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-fd1ce14a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:727 | try | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f1f51f50 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:731 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1f81cf4b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:746 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93e23efc | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:747 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-322478d6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:750 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-13a73b4f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:754 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2efda7c6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:755 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c9d5bf2d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:765 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a860f4fd | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:767 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-05d6518b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:767 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-70a9a987 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:780 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows… | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-83ead01d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:782 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-becf9c30 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:783 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6b6dfb7b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:791 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0]… | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-402fc942 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:793 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0]… | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9b1eea15 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:795 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0]… | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-f5446347 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:801 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-971aa1e8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:803 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-c5be6a8d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:806 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7c52be6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:810 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d6f86c25 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:811 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-69fefe67 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:819 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c5a3aed3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:827 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fa659ad6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:832 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9ab3e04c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:833 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ec759139 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:841 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f0799f71 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:846 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ if (chk_totalBatch.Checked) | FLAG | initchk_totalBatch | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5af66385 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:847 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ if (chk_totalBatch.Checked) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanByLineElectrodeProduction, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7924ab12 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:848 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ if (chk_totalBatch.Checked) | CALL_EXT | saveTotalBatch.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-393fc107 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:853 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ else of (chk_totalBatch.Checked) | FLAG | initchk_totalBatch | false | 화면 필드/플래그 변경 |  |  |  |
| AC-36ccbf62 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:855 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrodeProduction) ▸ else of (chk_totalBatch.Checked) | CALL_EXT | saveTotalBatch.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a36d050 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:861 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-6b1d3528 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00620_PlanBy_Line_Electrode_Production.cs:865 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00620_PlanBy_Line_Electrode_Production.usrCombo_Zoom_SelectedIndexChanged

진입점: usrCombo_Zoom.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6ed6380 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:345 | if (usrCombo_Zoom.SelectedItem.ToString() == "100%") | CALL_EXT | siMain.Zoom100 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0159b20 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:361 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ if (usrCombo_Zoom.SelectedItem.ToString() == "50%") | CALL_EXT | siMain.Zoom100 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-57cd811a | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:362 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ if (usrCombo_Zoom.SelectedItem.ToString() == "50%") | CALL_EXT | siMain.ZoomOut | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-75258ed8 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:363 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ if (usrCombo_Zoom.SelectedItem.ToString() == "50%") | CALL_EXT | siMain.ZoomOut | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f10f954 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:364 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ if (usrCombo_Zoom.SelectedItem.ToString() == "50%") | CALL_EXT | siMain.ZoomOut | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4415f441 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:365 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ if (usrCombo_Zoom.SelectedItem.ToString() == "50%") | CALL_EXT | siMain.ZoomOut | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce8d3c1c | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:366 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ if (usrCombo_Zoom.SelectedItem.ToString() == "50%") | CALL_EXT | siMain.ZoomOut | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f0fb5d2 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:370 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ if (usrCombo_Zoom.Sel… | CALL_EXT | siMain.Zoom100 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bfea0503 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:371 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ if (usrCombo_Zoom.Sel… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d60d4513 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:372 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ if (usrCombo_Zoom.Sel… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8496214d | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:373 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ if (usrCombo_Zoom.Sel… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e5780f2 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:374 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ if (usrCombo_Zoom.Sel… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d280827c | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:375 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ if (usrCombo_Zoom.Sel… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ab9b8123 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:379 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.Zoom100 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-594c0330 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:380 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2344ad7b | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:381 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2dd7836d | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:382 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b676b53 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:383 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0eba4feb | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:384 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-093db995 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:385 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-47941d6a | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:386 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1d91b05 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:387 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b449d429 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:388 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ddbbee1 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:389 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-53294162 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:393 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.Zoom100 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd67c39a | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:394 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3a059a9 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:395 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-69b1fb46 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:396 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eac0bfb7 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:397 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-700547bc | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:398 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d275c89 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:399 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1120e5c | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:400 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d22ef709 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:401 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-05df844e | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:402 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-080102e4 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:403 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5004b313 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:404 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f932fba1 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:405 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a7f4258 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:406 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-af698249 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:407 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a57161b | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:408 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-89c8f8ba | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:412 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.Zoom100 | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-59f8846d | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:413 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1bcee5c | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:414 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0904eb9e | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:415 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-057d918b | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:416 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fae3c7a4 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:417 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ee269c6 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:418 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-72897ab0 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:419 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a5558ce | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:420 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-98ac3ff4 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:421 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e53ba2e5 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:422 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c02ad30e | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:423 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-928cbd4e | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:424 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-427db16c | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:425 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-37b90d6f | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:426 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7e9008d | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:427 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3dfd626 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:428 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-505c8d52 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:429 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a05e454 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:430 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8328d870 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:431 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0db1e995 | usrCombo_Zoom.SelectedIndexChanged | FP00620_PlanBy_Line_Electrode_Production.cs:432 | else of (usrCombo_Zoom.SelectedItem.ToString() == "100%") ▸ else of (usrCombo_Zoom.SelectedItem.ToString() == "50%") ▸ else of (usrCombo_Zoo… | CALL_EXT | siMain.ZoomIn | () | ⚠ 의미 확인 필요 |  |  |  |

