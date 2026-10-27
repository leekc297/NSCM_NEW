# AS-IS 액션 대조표 — FP00601

> 원천: `Doc/asisfacts/screens/FP00601/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2152행 · 메서드 230 · 종류 DATA_OP 786 · UI_PROP 205 · FLAG 180 · RETURN 164 · MESSAGE 96 · CALL_EXT 95 · UI_MISC 94 · VALUE_SET 89 · STATE 78 · ENDPOINT 69 · POPUP 64 · GRID_INIT 62 · GRID_SET 45 · COMBO_DATA 20 · VALUE_CLEAR 20 · CALL_BASE 15 · GRID_LOCK 14 · LIST_REBIND 13 · FOCUS 11 · THROW 10 · GRID_STYLE 8 · GRID_BIND 5 · EXCEL 4 · LIST_CLEAR 2 · STATE_RESET 2 · LIST_BIND 1 · ⚠ 의미 확인 필요 110


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f06ae89d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4001 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-75ec5138 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4007 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-eb4a0308 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4015 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-2f6afe52 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4016 |  | UI_PROP | dlLine._M_OUT | line_savings.M_OUT | 속성 _M_OUT 설정 |  |  |  |
| AC-ca1daa84 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4017 |  | UI_PROP | dlLine._W_OUT | line_savings.W_OUT | 속성 _W_OUT 설정 |  |  |  |
| AC-42c412ec | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4019 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-efded85b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4020 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-9ab20629 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4021 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-3998ba87 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4022 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-741bdb2e | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4025 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-7da1fd42 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4219 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-18250758 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4220 |  | UI_PROP | dlLine._M_OUT | line_savings.M_OUT | 속성 _M_OUT 설정 |  |  |  |
| AC-c6dee074 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4221 |  | UI_PROP | dlLine._W_OUT | line_savings.W_OUT | 속성 _W_OUT 설정 |  |  |  |
| AC-0e44506d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4223 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-233f914c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4224 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-84f04f11 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4225 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-811efb81 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4226 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-6ef8e67f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4228 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d09b686 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4131 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e74a673e | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4132 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-add6fb50 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4133 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-73199763 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4134 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b154d34 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4135 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a9e2a1fb | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4136 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ccbc1569 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4137 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-3550944f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4138 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ef2f81d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4139 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a9e5c10b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4140 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-92a7df32 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4141 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-0be331bc | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4142 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5fe9427b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4143 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fde5f543 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4129 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-2b8888c7 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4160 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": | UI_PROP | loc.M_OUT | row_index | 속성 M_OUT 설정 |  |  |  |
| AC-8b769360 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4163 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": | UI_PROP | loc.W_OUT | row_index | 속성 W_OUT 설정 |  |  |  |
| AC-078468df | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4169 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f1d8532 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4175 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-95cdc590 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4178 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-30b117c4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4187 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-d486f37a | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4189 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8493f3d8 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4104 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3902303 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4058 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9cac7f6 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4059 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7e9b085 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4060 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-10658ff5 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4061 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6c26ffc | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4062 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b4ff0322 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4063 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6b3dac4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4064 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-c09e4e4c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4065 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1c6a0ec | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4066 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-19d7def6 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4067 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7313e184 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4068 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-eda91df2 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4069 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1da44d4a | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4070 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e30f0c43 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4071 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2eff0d28 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4056 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-a67fa1ec | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4089 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-478648b4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4090 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-975f2790 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4096 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbaca016 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4032 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00601_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9255461 | .ctor | FP00601_BucketSetForm_Popup.cs:70 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-0545d1b2 | .ctor | FP00601_BucketSetForm_Popup.cs:71 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-c084a296 | .ctor | FP00601_BucketSetForm_Popup.cs:72 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-7e40b83e | .ctor | FP00601_BucketSetForm_Popup.cs:74 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00601_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6afffd98 | Dispose | FP00601_BucketSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00601_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5e734b7 | this.Load | FP00601_BucketSetForm_Popup.cs:98 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00601_BucketSetForm_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebc3948e | this.Load | FP00601_BucketSetForm_Popup.cs:137 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-66b0d115 | this.Load | FP00601_BucketSetForm_Popup.cs:143 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3319ea8 | this.Load | FP00601_BucketSetForm_Popup.cs:144 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8373418 | this.Load | FP00601_BucketSetForm_Popup.cs:146 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-101fee3d | this.Load | FP00601_BucketSetForm_Popup.cs:150 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-9794f020 | this.Load | FP00601_BucketSetForm_Popup.cs:150 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-697923b9 | this.Load | FP00601_BucketSetForm_Popup.cs:157 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-3ab7d4f5 | this.Load | FP00601_BucketSetForm_Popup.cs:161 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-d538d9b7 | this.Load | FP00601_BucketSetForm_Popup.cs:165 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00601_BucketSetForm_Popup.InitNames

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e464bfd | this.Load | FP00601_BucketSetForm_Popup.cs:115 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d7788f76 | this.Load | FP00601_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3806ca2f | this.Load | FP00601_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00601_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fdf53e7 | this.Load | FP00601_BucketSetForm_Popup.cs:85 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cd53246a | this.Load | FP00601_BucketSetForm_Popup.cs:93 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00601_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-849b8537 | this.usrButton1.Click | FP00601_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-65c9a3c0 | this.usrButton1.Click | FP00601_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-b2600e82 | this.usrButton1.Click | FP00601_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-3e811477 | this.usrButton1.Click | FP00601_BucketSetForm_Popup.cs:215 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-42bf6855 | this.usrButton1.Click | FP00601_BucketSetForm_Popup.cs:216 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-6f77a0a7 | this.usrButton1.Click | FP00601_BucketSetForm_Popup.cs:218 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a3e827a | this.usrButton1.Click | FP00601_BucketSetForm_Popup.cs:220 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00601_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-847e5d28 | this.usrButton2.Click | FP00601_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-b2133504 | this.usrButton2.Click | FP00601_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-d7c54bf7 | this.usrButton2.Click | FP00601_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-a49a7558 | this.usrButton2.Click | FP00601_BucketSetForm_Popup.cs:189 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-57a380cd | this.usrButton2.Click | FP00601_BucketSetForm_Popup.cs:190 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-bff37593 | this.usrButton2.Click | FP00601_BucketSetForm_Popup.cs:191 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-f20a9c55 | this.usrButton2.Click | FP00601_BucketSetForm_Popup.cs:192 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98a6d61b | .ctor | FP00601_ExcelPopup.cs:145 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4582798a | .ctor | FP00601_ExcelPopup.cs:148 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-00660a53 | .ctor | FP00601_ExcelPopup.cs:149 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00601_ExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e807b997 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:229 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dd19ef6d | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:230 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8d38d734 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:231 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-91182614 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:232 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-65d87090 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:234 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-d5889a66 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:234 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-232d5915 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:235 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-04614d47 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:235 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0678ec45 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:236 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-f2d575f0 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:236 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-649bb603 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:237 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-48bcbd3c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:237 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1a2112c4 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:246 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-ee9641b9 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:247 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-0914437c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:248 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-32fd2217 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_ExcelPopup.cs:249 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP00601_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee2230cd | this.btnClose.Click | FP00601_ExcelPopup.cs:903 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54258acb | this.btnDownload.Click | FP00601_ExcelPopup.cs:887 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-95271c42 | this.btnDownload.Click | FP00601_ExcelPopup.cs:888 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00601_ExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9709078 | this.btnFind.Click | FP00601_ExcelPopup.cs:878 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date." ) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0515477f | this.btnFind.Click | FP00601_ExcelPopup.cs:879 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00601_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ddef51e | this.Load | FP00601_ExcelPopup.cs:277 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-52512b46 | this.Load | FP00601_ExcelPopup.cs:278 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-de434cbd | this.Load | FP00601_ExcelPopup.cs:279 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00601_ExcelPopup.dateRange_ValueChanged

진입점: this.dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f67dae24 | this.dateRange.ValueChanged | FP00601_ExcelPopup.cs:911 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-5cf514a8 | this.dateRange.ValueChanged | FP00601_ExcelPopup.cs:912 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00601_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4318fc7a | (진입점 미연결) | FP00601_ExcelPopup.cs:841 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-acb3d50f | (진입점 미연결) | FP00601_ExcelPopup.cs:841 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00601_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfd7b7a0 | this.Load | FP00601_ExcelPopup.cs:272 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00601_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cd32504 | Dispose | FP00601_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00601_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0ca8172 | (진입점 미연결) | FP00601_ExcelPopup.cs:803 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00601_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b57c0466 | FindButton | FP00601_ExcelPopup.cs:321 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1f244fb8 | FindButton | FP00601_ExcelPopup.cs:322 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e7dca52f | FindButton | FP00601_ExcelPopup.cs:324 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-573f128b | this.Load 외 2 | FP00601_ExcelPopup.cs:352 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91be24b3 | this.Load 외 2 | FP00601_ExcelPopup.cs:353 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-75402d5d | this.Load 외 2 | FP00601_ExcelPopup.cs:353 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cad0b006 | this.Load 외 2 | FP00601_ExcelPopup.cs:357 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b178621f | this.Load 외 2 | FP00601_ExcelPopup.cs:358 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d04d07cf | this.Load 외 2 | FP00601_ExcelPopup.cs:360 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-47fbbd96 | this.Load 외 2 | FP00601_ExcelPopup.cs:361 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-186e4809 | this.Load 외 2 | FP00601_ExcelPopup.cs:362 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6f752121 | this.Load 외 2 | FP00601_ExcelPopup.cs:363 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-21d05250 | this.Load 외 2 | FP00601_ExcelPopup.cs:364 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-927df438 | this.Load 외 2 | FP00601_ExcelPopup.cs:365 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-71d36f3c | this.Load 외 2 | FP00601_ExcelPopup.cs:372 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44fddea9 | this.Load 외 2 | FP00601_ExcelPopup.cs:377 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-d48a8dda | this.Load 외 2 | FP00601_ExcelPopup.cs:379 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-c69e1358 | this.Load 외 2 | FP00601_ExcelPopup.cs:380 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-7561e7ea | this.Load 외 2 | FP00601_ExcelPopup.cs:381 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-ae2a2af9 | this.Load 외 2 | FP00601_ExcelPopup.cs:383 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-68accf38 | this.Load 외 2 | FP00601_ExcelPopup.cs:386 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cc65eed | this.Load 외 2 | FP00601_ExcelPopup.cs:387 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = true; //if (init) //{ // DictColumn = siMain.Se… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b421eb45 | this.Load 외 2 | FP00601_ExcelPopup.cs:406 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, set, ColumnWidth.Data, Colum… | 화면 필드/플래그 변경 |  |  |  |
| AC-72d4ff1d | this.Load 외 2 | FP00601_ExcelPopup.cs:406 | if (DoSearchData != null) ▸ try ▸ lambda | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, set, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data, 2, Au… | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc85bb5e | this.Load 외 2 | FP00601_ExcelPopup.cs:412 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-7047b7ae | this.Load 외 2 | FP00601_ExcelPopup.cs:413 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-1c205682 | this.Load 외 2 | FP00601_ExcelPopup.cs:414 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-4f121ef5 | this.Load 외 2 | FP00601_ExcelPopup.cs:419 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1959da8 | this.Load 외 2 | FP00601_ExcelPopup.cs:422 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b8e9c385 | this.Load 외 2 | FP00601_ExcelPopup.cs:423 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9566a12b | this.Load 외 2 | FP00601_ExcelPopup.cs:432 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0be2694 | this.Load 외 2 | FP00601_ExcelPopup.cs:435 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-20a6bf6d | this.Load 외 2 | FP00601_ExcelPopup.cs:436 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0325ef2d | this.Load 외 2 | FP00601_ExcelPopup.cs:437 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-42963cee | this.Load 외 2 | FP00601_ExcelPopup.cs:438 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5ef70c3b | this.Load 외 2 | FP00601_ExcelPopup.cs:439 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-25f42f20 | this.Load 외 2 | FP00601_ExcelPopup.cs:440 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00601_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aba54f18 | this.Load | FP00601_ExcelPopup.cs:157 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-064e0424 | this.Load | FP00601_ExcelPopup.cs:159 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_ExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-137ee2f6 | (진입점 미연결) | FP00601_ExcelPopup.cs:777 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-451abb28 | (진입점 미연결) | FP00601_ExcelPopup.cs:778 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-d159f56d | (진입점 미연결) | FP00601_ExcelPopup.cs:779 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-2908ad02 | (진입점 미연결) | FP00601_ExcelPopup.cs:780 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-6c770bf4 | (진입점 미연결) | FP00601_ExcelPopup.cs:781 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-590983b6 | (진입점 미연결) | FP00601_ExcelPopup.cs:782 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-b9d16160 | (진입점 미연결) | FP00601_ExcelPopup.cs:783 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2655e923 | (진입점 미연결) | FP00601_ExcelPopup.cs:785 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-8c2b1f1b | (진입점 미연결) | FP00601_ExcelPopup.cs:786 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-d9fc38f6 | (진입점 미연결) | FP00601_ExcelPopup.cs:790 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a484b4d6 | (진입점 미연결) | FP00601_ExcelPopup.cs:791 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00601_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3605d9db | this.Load | FP00601_ExcelPopup.cs:205 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-20cac5c9 | this.Load | FP00601_ExcelPopup.cs:206 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-684047dd | this.Load | FP00601_ExcelPopup.cs:210 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-19edae13 | this.Load | FP00601_ExcelPopup.cs:211 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-5ddd64ec | this.Load | FP00601_ExcelPopup.cs:214 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-cd6219e6 | this.Load | FP00601_ExcelPopup.cs:215 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-372fcdd9 | this.Load | FP00601_ExcelPopup.cs:219 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00601_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0f8fbdc | this.Load | FP00601_ExcelPopup.cs:290 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e9a7aad4 | this.Load | FP00601_ExcelPopup.cs:291 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00601_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0237d60c | (진입점 미연결) | FP00601_ExcelPopup.cs:311 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00601_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afeae78a | this.btnUpload.Click | FP00601_ExcelPopup.cs:813 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-2bfe0612 | this.btnUpload.Click | FP00601_ExcelPopup.cs:813 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-256c9b55 | this.btnUpload.Click | FP00601_ExcelPopup.cs:815 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a59479d8 | this.btnUpload.Click | FP00601_ExcelPopup.cs:816 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-418b01c1 | this.btnUpload.Click | FP00601_ExcelPopup.cs:817 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf3b833a | this.btnUpload.Click | FP00601_ExcelPopup.cs:819 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1d124542 | this.btnUpload.Click | FP00601_ExcelPopup.cs:821 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e526ff21 | this.btnUpload.Click | FP00601_ExcelPopup.cs:822 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-d1b567be | this.btnUpload.Click | FP00601_ExcelPopup.cs:822 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0420240 | this.btnUpload.Click | FP00601_ExcelPopup.cs:829 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d3b8889f | this.btnUpload.Click | FP00601_ExcelPopup.cs:830 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-0d977976 | this.btnUpload.Click | FP00601_ExcelPopup.cs:832 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00601_ExcelPopup.rdoMpp_CheckedChanged

진입점: this.rdoMpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-892b774a | this.rdoMpp.CheckedChanged | FP00601_ExcelPopup.cs:918 | if (rdoMpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-c9342a62 | this.rdoMpp.CheckedChanged | FP00601_ExcelPopup.cs:920 | else of (rdoMpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00601_ExcelPopup.rdoWpp_CheckedChanged

진입점: this.rdoWpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e952c794 | this.rdoWpp.CheckedChanged | FP00601_ExcelPopup.cs:927 | if (rdoWpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-c51b70fe | this.rdoWpp.CheckedChanged | FP00601_ExcelPopup.cs:929 | else of (rdoWpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00601_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69708521 | this.btnSave.Click | FP00601_ExcelPopup.cs:541 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-336f4564 | this.btnSave.Click | FP00601_ExcelPopup.cs:542 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed69e7c9 | this.btnSave.Click | FP00601_ExcelPopup.cs:546 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-602c1d86 | this.btnSave.Click | FP00601_ExcelPopup.cs:547 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30225bf9 | this.btnSave.Click | FP00601_ExcelPopup.cs:551 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-16d1df5e | this.btnSave.Click | FP00601_ExcelPopup.cs:551 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-88d3c558 | this.btnSave.Click | FP00601_ExcelPopup.cs:556 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-899dc241 | this.btnSave.Click | FP00601_ExcelPopup.cs:557 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5fc45d72 | this.btnSave.Click | FP00601_ExcelPopup.cs:558 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f584e3fb | this.btnSave.Click | FP00601_ExcelPopup.cs:559 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-215191ae | this.btnSave.Click | FP00601_ExcelPopup.cs:560 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fe889f5f | this.btnSave.Click | FP00601_ExcelPopup.cs:561 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4a64b830 | this.btnSave.Click | FP00601_ExcelPopup.cs:569 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c20d3524 | this.btnSave.Click | FP00601_ExcelPopup.cs:572 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-7dc42215 | this.btnSave.Click | FP00601_ExcelPopup.cs:574 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-41a0d4ca | this.btnSave.Click | FP00601_ExcelPopup.cs:577 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-f196292b | this.btnSave.Click | FP00601_ExcelPopup.cs:582 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-f0a32432 | this.btnSave.Click | FP00601_ExcelPopup.cs:583 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-ef72449d | this.btnSave.Click | FP00601_ExcelPopup.cs:590 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-b2f698e0 | this.btnSave.Click | FP00601_ExcelPopup.cs:591 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3593a53a | this.btnSave.Click | FP00601_ExcelPopup.cs:592 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-df70034f | this.btnSave.Click | FP00601_ExcelPopup.cs:593 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4c4795ff | this.btnSave.Click | FP00601_ExcelPopup.cs:594 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ec34348b | this.btnSave.Click | FP00601_ExcelPopup.cs:595 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5421d056 | this.btnSave.Click | FP00601_ExcelPopup.cs:596 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6030e1e6 | this.btnSave.Click | FP00601_ExcelPopup.cs:597 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01909aaf | this.btnSave.Click | FP00601_ExcelPopup.cs:603 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-050a6c04 | this.btnSave.Click | FP00601_ExcelPopup.cs:636 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-554ec417 | this.btnSave.Click | FP00601_ExcelPopup.cs:638 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a284a223 | this.btnSave.Click | FP00601_ExcelPopup.cs:641 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | dr["NEW_SEQ"] | Filter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-f51b9827 | this.btnSave.Click | FP00601_ExcelPopup.cs:646 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1b56c64 | this.btnSave.Click | FP00601_ExcelPopup.cs:648 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a103031f | this.btnSave.Click | FP00601_ExcelPopup.cs:651 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-42bc7d17 | this.btnSave.Click | FP00601_ExcelPopup.cs:655 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b227ed36 | this.btnSave.Click | FP00601_ExcelPopup.cs:657 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fa92732 | this.btnSave.Click | FP00601_ExcelPopup.cs:660 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d05775b0 | this.btnSave.Click | FP00601_ExcelPopup.cs:664 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-96978bdc | this.btnSave.Click | FP00601_ExcelPopup.cs:676 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-cecb4b7f | this.btnSave.Click | FP00601_ExcelPopup.cs:678 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b2be49b4 | this.btnSave.Click | FP00601_ExcelPopup.cs:680 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-215f4620 | this.btnSave.Click | FP00601_ExcelPopup.cs:684 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-4a8d08f8 | this.btnSave.Click | FP00601_ExcelPopup.cs:699 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-27650be7 | this.btnSave.Click | FP00601_ExcelPopup.cs:700 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-27e11846 | this.btnSave.Click | FP00601_ExcelPopup.cs:704 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("{0} data Saved", expect_count)) | 메시지 표시 |  |  |  |
| AC-7f77db88 | this.btnSave.Click | FP00601_ExcelPopup.cs:705 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-47a17508 | this.btnSave.Click | FP00601_ExcelPopup.cs:710 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-e82615c5 | this.btnSave.Click | FP00601_ExcelPopup.cs:743 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-e7c2e8bc | this.btnSave.Click | FP00601_ExcelPopup.cs:745 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f770ac0a | this.btnSave.Click | FP00601_ExcelPopup.cs:746 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-99447b36 | this.btnSave.Click | FP00601_ExcelPopup.cs:756 | if (DoSaveData != null) ▸ catch () | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bb8236c2 | this.btnSave.Click | FP00601_ExcelPopup.cs:761 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-18cdf184 | this.btnSave.Click | FP00601_ExcelPopup.cs:762 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-aa0c2a7b | this.btnSave.Click | FP00601_ExcelPopup.cs:763 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-72704eb2 | this.btnSave.Click | FP00601_ExcelPopup.cs:764 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6ff8506a | this.btnSave.Click | FP00601_ExcelPopup.cs:765 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9f47d42d | this.btnSave.Click | FP00601_ExcelPopup.cs:766 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00601_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bbe945b | this.Load | FP00601_ExcelPopup.cs:303 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92a05657 | this.Load | FP00601_ExcelPopup.cs:304 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00601_ExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96f57580 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_ExcelPopup.cs:257 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c5983965 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_ExcelPopup.cs:258 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1202906d | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_ExcelPopup.cs:259 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-37a58211 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_ExcelPopup.cs:263 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-258dd7ed | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_ExcelPopup.cs:264 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-600290d8 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_ExcelPopup.cs:265 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00601_InvalidExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f05fcf6 | .ctor | FP00601_InvalidExcelPopup.cs:151 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ef499ff5 | .ctor | FP00601_InvalidExcelPopup.cs:154 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-ca28a701 | .ctor | FP00601_InvalidExcelPopup.cs:155 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00601_InvalidExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89cca4b1 | this.btnClose.Click | FP00601_InvalidExcelPopup.cs:300 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_InvalidExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fed7696 | this.btnDownload.Click | FP00601_InvalidExcelPopup.cs:293 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-71bafc2e | this.btnDownload.Click | FP00601_InvalidExcelPopup.cs:294 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00601_InvalidExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a48b726 | this.Load | FP00601_InvalidExcelPopup.cs:198 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bc30738d | this.Load | FP00601_InvalidExcelPopup.cs:199 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-809530b0 | this.Load | FP00601_InvalidExcelPopup.cs:200 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00601_InvalidExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b854991 | this.Load | FP00601_InvalidExcelPopup.cs:193 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00601_InvalidExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ec42580 | Dispose | FP00601_InvalidExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00601_InvalidExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dadb268 | FindButton | FP00601_InvalidExcelPopup.cs:240 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-55b81945 | FindButton | FP00601_InvalidExcelPopup.cs:241 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1052f2e0 | FindButton | FP00601_InvalidExcelPopup.cs:243 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_InvalidExcelPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36e4c484 | this.Load 외 1 | FP00601_InvalidExcelPopup.cs:273 | if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd31cf25 | this.Load 외 1 | FP00601_InvalidExcelPopup.cs:275 | if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-53712de3 | this.Load 외 1 | FP00601_InvalidExcelPopup.cs:278 |  | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3c8cf127 | this.Load 외 1 | FP00601_InvalidExcelPopup.cs:279 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00601_InvalidExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c306844d | this.Load | FP00601_InvalidExcelPopup.cs:163 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-dee718d7 | this.Load | FP00601_InvalidExcelPopup.cs:165 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_InvalidExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bd52c79 | this.Load | FP00601_InvalidExcelPopup.cs:210 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-57547162 | this.Load | FP00601_InvalidExcelPopup.cs:211 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00601_InvalidExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-665ac3db | (진입점 미연결) | FP00601_InvalidExcelPopup.cs:231 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00601_InvalidExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9aaecd03 | this.Load | FP00601_InvalidExcelPopup.cs:223 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e062de69 | this.Load | FP00601_InvalidExcelPopup.cs:224 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-0a12d391 | this.Load | FP00601_InvalidExcelPopup.cs:225 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00601_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d74d4a8a | this.btnButtonList.UsrButtonList_Click_Detected | FP00601_ItemPopup.cs:296 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-321ca1b6 | this.btnButtonList.UsrButtonList_Click_Detected | FP00601_ItemPopup.cs:299 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a414cd78 | this.btnButtonList.UsrButtonList_Click_Detected | FP00601_ItemPopup.cs:300 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-293c13ad | this.Load | FP00601_ItemPopup.cs:139 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4c0d9b7d | this.Load | FP00601_ItemPopup.cs:140 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8c487126 | this.Load | FP00601_ItemPopup.cs:141 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00601_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f586b5c | this.Load | FP00601_ItemPopup.cs:134 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00601_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c7b0193 | Dispose | FP00601_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00601_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca18b75f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:210 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d15ab158 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:211 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3e5a081c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:213 |  | DATA_OP | Filter["MODEL_ID"] | txtModel.Text | 행/컬럼 값 대입 |  |  |  |
| AC-9df404da | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:214 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c064520c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:215 |  | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-219aea62 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:222 | if (string.IsNullOrWhiteSpace(Filter["MODEL_ID"]) && string.IsNullOrWhiteSpace(Filter["ITEM_ID"]) && string.IsNullOrWhiteSpa…) | MESSAGE | MessageBox.Show | ("It is required at least one of these : Model, Item, Nick Name") | 메시지 표시 |  |  |  |
| AC-1365d946 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:223 | if (string.IsNullOrWhiteSpace(Filter["MODEL_ID"]) && string.IsNullOrWhiteSpace(Filter["ITEM_ID"]) && string.IsNullOrWhiteSpa…) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-61acb25e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:224 | if (string.IsNullOrWhiteSpace(Filter["MODEL_ID"]) && string.IsNullOrWhiteSpace(Filter["ITEM_ID"]) && string.IsNullOrWhiteSpa…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6d2f733 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:228 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1a6e847c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:230 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { //DataSet dtInstType = DataService.FP_ExecuteQuery("FP00601_LineAdd", "find_Insta… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4dbb6c8c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:247 | lambda ▸ if (Filter["PRODUCTION_TYPE"] == "TEST" \|\| Filter["PRODUCTION_TYPE"] == "D-TEST" \|\| Filter["PRODUCTION_TYPE"]=="E-TEST") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SQL", "ITEM_LIST_TEST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-73f4c75e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:248 | lambda ▸ if (Filter["PRODUCTION_TYPE"] == "TEST" \|\| Filter["PRODUCTION_TYPE"] == "D-TEST" \|\| Filter["PRODUCTION_TYPE"]=="E-TEST") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SELECT", "ITEM_LIST_TES… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a4fdd9a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:252 | lambda ▸ else of (Filter["PRODUCTION_TYPE"] == "TEST" \|\| Filter["PRODUCTION_TYPE"] == "D-TEST" \|\| Filter["PRODUCTION_TYPE"]=="E-TEST") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SQL", "ITEM_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-29126d47 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:253 | lambda ▸ else of (Filter["PRODUCTION_TYPE"] == "TEST" \|\| Filter["PRODUCTION_TYPE"] == "D-TEST" \|\| Filter["PRODUCTION_TYPE"]=="E-TEST") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SELECT", "ITEM_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-122cd7e0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:255 | lambda | RETURN | return itemList; |  | 처리 중단/반환 |  |  |  |
| AC-31b6ff92 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:259 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2c25e3ac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:262 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0777d8d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:264 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-3cef58e3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00601_ItemPopup.cs:268 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26f77d32 | this.Load | FP00601_ItemPopup.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-028dea3a | this.Load | FP00601_ItemPopup.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_ItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-856eb2f5 | this.Load | FP00601_ItemPopup.cs:128 |  | VALUE_SET | txtModel.Text | Filter["TOP_ITEM_ID"] | 컨트롤 값 설정 |  |  |  |

## FP00601_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-728c7adc | this.Load | FP00601_ItemPopup.cs:151 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a82f5eac | this.Load | FP00601_ItemPopup.cs:152 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00601_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08fb761e | (진입점 미연결) | FP00601_ItemPopup.cs:171 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00601_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6702c23f | this.Load | FP00601_ItemPopup.cs:158 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-26abf3cb | this.Load | FP00601_ItemPopup.cs:159 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-218738a4 | this.Load | FP00601_ItemPopup.cs:163 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00601_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-083eab36 | this.spdMain.CellClick | FP00601_ItemPopup.cs:311 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-fde39d67 | this.spdMain.CellClick | FP00601_ItemPopup.cs:312 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8be94994 | this.spdMain.CellClick | FP00601_ItemPopup.cs:315 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00601_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bc70747 | this.spdMain.CellDoubleClick | FP00601_ItemPopup.cs:321 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b5d32bb2 | this.spdMain.CellDoubleClick | FP00601_ItemPopup.cs:322 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ca53d4ef | this.spdMain.CellDoubleClick | FP00601_ItemPopup.cs:325 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-c5f1c22c | this.spdMain.CellDoubleClick | FP00601_ItemPopup.cs:328 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a0915b2 | this.spdMain.CellDoubleClick | FP00601_ItemPopup.cs:338 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_LineAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aee08d8d | .ctor | FP00601_LineAddPopup.cs:104 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-d194f103 | .ctor | FP00601_LineAddPopup.cs:105 |  | FLAG | this.InitRow | initRow | 화면 필드/플래그 변경 |  |  |  |

## FP00601_LineAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49729b48 | this.btnClose.Click | FP00601_LineAddPopup.cs:346 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_LineAddPopup.btnItem_Click

진입점: this.btnItem.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12bdbb28 | this.btnItem.Click | FP00601_LineAddPopup.cs:671 |  | POPUP | new FP00601_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c8862f8d | this.btnItem.Click | FP00601_LineAddPopup.cs:672 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-8f19ede9 | this.btnItem.Click | FP00601_LineAddPopup.cs:674 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-18f3f9cc | this.btnItem.Click | FP00601_LineAddPopup.cs:675 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cd4c63c4 | this.btnItem.Click | FP00601_LineAddPopup.cs:677 |  | DATA_OP | popup.Filter["TOP_ITEM_ID"] | txtModel.Text | 행/컬럼 값 대입 |  |  |  |
| AC-5ee57d02 | this.btnItem.Click | FP00601_LineAddPopup.cs:678 |  | DATA_OP | popup.Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8bb76481 | this.btnItem.Click | FP00601_LineAddPopup.cs:679 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-26b7e5ad | this.btnItem.Click | FP00601_LineAddPopup.cs:681 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ae1999b3 | this.btnItem.Click | FP00601_LineAddPopup.cs:686 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["MODEL_ID"] | Filter["TOP_ITEM_ID"] = txtModel.Text = data["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aa63b27a | this.btnItem.Click | FP00601_LineAddPopup.cs:686 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["TOP_ITEM_ID"] | txtModel.Text = data["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57eaddb0 | this.btnItem.Click | FP00601_LineAddPopup.cs:686 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtModel.Text | data["MODEL_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f5d12e2a | this.btnItem.Click | FP00601_LineAddPopup.cs:687 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ITEM_ID"] | txtItem.Text = data["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9a52d695 | this.btnItem.Click | FP00601_LineAddPopup.cs:687 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItem.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-27f1c54d | this.btnItem.Click | FP00601_LineAddPopup.cs:688 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text = data["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-128dae13 | this.btnItem.Click | FP00601_LineAddPopup.cs:688 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtNickName.Text | data["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ba0e35b4 | this.btnItem.Click | FP00601_LineAddPopup.cs:689 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ITEM_TYPE"] | txtItemType.Text = data["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9273d934 | this.btnItem.Click | FP00601_LineAddPopup.cs:689 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItemType.Text | data["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ef204371 | this.btnItem.Click | FP00601_LineAddPopup.cs:690 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["PLANT_ID"] | data["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7b357614 | this.btnItem.Click | FP00601_LineAddPopup.cs:692 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtBuilding.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-c5d3122b | this.btnItem.Click | FP00601_LineAddPopup.cs:693 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtOperation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-a9432ee4 | this.btnItem.Click | FP00601_LineAddPopup.cs:694 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtLine.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-56668a37 | this.btnItem.Click | FP00601_LineAddPopup.cs:696 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtLocation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-7c394d95 | this.btnItem.Click | FP00601_LineAddPopup.cs:698 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2b3d06e9 | this.btnItem.Click | FP00601_LineAddPopup.cs:699 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e0226587 | this.btnItem.Click | FP00601_LineAddPopup.cs:700 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("LINE_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-dfcde448 | this.btnItem.Click | FP00601_LineAddPopup.cs:701 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d118ddbf | this.btnItem.Click | FP00601_LineAddPopup.cs:702 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("LOCATION", "") | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00601_LineAddPopup.btnLine_Click

진입점: this.btnLine.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f24d76a | this.btnLine.Click | FP00601_LineAddPopup.cs:716 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert material value") | 메시지 표시 |  |  |  |
| AC-e19b01a5 | this.btnLine.Click | FP00601_LineAddPopup.cs:717 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1bb8917e | this.btnLine.Click | FP00601_LineAddPopup.cs:719 |  | POPUP | new FP00601_LinePopup | () | 팝업/폼 생성 |  |  |  |
| AC-8c2fbcf5 | this.btnLine.Click | FP00601_LineAddPopup.cs:720 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-fbcd1a1b | this.btnLine.Click | FP00601_LineAddPopup.cs:722 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0a1170e1 | this.btnLine.Click | FP00601_LineAddPopup.cs:723 |  | DATA_OP | popup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ca90ef73 | this.btnLine.Click | FP00601_LineAddPopup.cs:724 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-08e68f15 | this.btnLine.Click | FP00601_LineAddPopup.cs:725 |  | DATA_OP | popup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8651bba7 | this.btnLine.Click | FP00601_LineAddPopup.cs:726 |  | DATA_OP | popup.Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a94d0c2b | this.btnLine.Click | FP00601_LineAddPopup.cs:727 |  | DATA_OP | popup.Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-40bd85d0 | this.btnLine.Click | FP00601_LineAddPopup.cs:728 |  | DATA_OP | popup.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1958927c | this.btnLine.Click | FP00601_LineAddPopup.cs:729 |  | DATA_OP | popup.Filter["RELEASE_VALUE"] | Filter["RELEASE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a41bbbd5 | this.btnLine.Click | FP00601_LineAddPopup.cs:730 |  | DATA_OP | popup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-8811ac21 | this.btnLine.Click | FP00601_LineAddPopup.cs:732 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a61a6af6 | this.btnLine.Click | FP00601_LineAddPopup.cs:734 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7cde14e6 | this.btnLine.Click | FP00601_LineAddPopup.cs:739 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["PLANT_ID"] | data["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1ea669a0 | this.btnLine.Click | FP00601_LineAddPopup.cs:740 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["FACTORY_ID"] | txtBuilding.Text = data["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-65daf6c3 | this.btnLine.Click | FP00601_LineAddPopup.cs:740 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtBuilding.Text | data["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b6ceb617 | this.btnLine.Click | FP00601_LineAddPopup.cs:741 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["OPERATION_ID"] | txtOperation.Text = data["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c8e21695 | this.btnLine.Click | FP00601_LineAddPopup.cs:741 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtOperation.Text | data["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-640cdbe9 | this.btnLine.Click | FP00601_LineAddPopup.cs:742 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["LINE_ID"] | txtLine.Text = data["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6c3e0fb8 | this.btnLine.Click | FP00601_LineAddPopup.cs:742 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtLine.Text | data["LINE_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-edf87519 | this.btnLine.Click | FP00601_LineAddPopup.cs:744 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | data["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3e7439a | this.btnLine.Click | FP00601_LineAddPopup.cs:745 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["LOCATION"] | txtLocation.Text = data["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f8a1e6b | this.btnLine.Click | FP00601_LineAddPopup.cs:745 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtLocation.Text | data["LOCATION"].ToString() | 컨트롤 값 설정 |  |  |  |

## FP00601_LineAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ed7c1d2 | this.btnSave.Click | FP00601_LineAddPopup.cs:339 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00601_LineAddPopup.cbo_market_changed

진입점: cbo_market.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d694679 | cbo_market.SelectedIndexChanged | FP00601_LineAddPopup.cs:298 |  | DATA_OP | Filter["MARKET"] | CString.GetCheckedListValue(dtMarket, cbo_market.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00601_LineAddPopup.cbo_prodtype_changed

진입점: cbo_prodtype.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab966a65 | cbo_prodtype.SelectedIndexChanged | FP00601_LineAddPopup.cs:303 |  | DATA_OP | Filter["PRODTYPE_ID"] | CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00601_LineAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71cb0248 | this.btnSave.Click | FP00601_LineAddPopup.cs:356 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | MESSAGE | MessageBox.Show | ("You need to select line data") | 메시지 표시 |  |  |  |
| AC-4995af2e | this.btnSave.Click | FP00601_LineAddPopup.cs:357 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0cdd4af1 | this.btnSave.Click | FP00601_LineAddPopup.cs:361 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | MESSAGE | MessageBox.Show | ("You need to specify quantity") | 메시지 표시 |  |  |  |
| AC-91e46157 | this.btnSave.Click | FP00601_LineAddPopup.cs:362 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f22271ee | this.btnSave.Click | FP00601_LineAddPopup.cs:370 | catch () | MESSAGE | MessageBox.Show | ("You shoud insert quantity as number") | 메시지 표시 |  |  |  |
| AC-836d6fcd | this.btnSave.Click | FP00601_LineAddPopup.cs:371 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-bbbe222c | this.btnSave.Click | FP00601_LineAddPopup.cs:376 | if (string.IsNullOrWhiteSpace(cbo_prodtype.ControlValues.ToString())) | MESSAGE | MessageBox.Show | ("You need to Production data") | 메시지 표시 |  |  |  |
| AC-a9f25818 | this.btnSave.Click | FP00601_LineAddPopup.cs:377 | if (string.IsNullOrWhiteSpace(cbo_prodtype.ControlValues.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c5414550 | this.btnSave.Click | FP00601_LineAddPopup.cs:382 | if (string.IsNullOrWhiteSpace(cbo_market.ControlValues.ToString())) | MESSAGE | MessageBox.Show | ("You need to Market data") | 메시지 표시 |  |  |  |
| AC-bda0b431 | this.btnSave.Click | FP00601_LineAddPopup.cs:383 | if (string.IsNullOrWhiteSpace(cbo_market.ControlValues.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-57d4d032 | this.btnSave.Click | FP00601_LineAddPopup.cs:389 | if (string.IsNullOrWhiteSpace(txtLocation.Text)) | MESSAGE | MessageBox.Show | ("You need to Location data") | 메시지 표시 |  |  |  |
| AC-04f65677 | this.btnSave.Click | FP00601_LineAddPopup.cs:390 | if (string.IsNullOrWhiteSpace(txtLocation.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-86ed91f0 | this.btnSave.Click | FP00601_LineAddPopup.cs:397 | if (string.IsNullOrWhiteSpace(txtModel.Text) \|\| string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Select Material") | 메시지 표시 |  |  |  |
| AC-dd4cb49c | this.btnSave.Click | FP00601_LineAddPopup.cs:398 | if (string.IsNullOrWhiteSpace(txtModel.Text) \|\| string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ec85e675 | this.btnSave.Click | FP00601_LineAddPopup.cs:401 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00601_LineAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0bcdb71 | Dispose | FP00601_LineAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00601_LineAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaa2b988 | this.Load | FP00601_LineAddPopup.cs:118 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6002c85a | this.Load | FP00601_LineAddPopup.cs:120 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aa480612 | this.Load | FP00601_LineAddPopup.cs:127 |  | FLAG | dtSave | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-83834fdc | this.Load | FP00601_LineAddPopup.cs:129 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3402d39c | this.Load | FP00601_LineAddPopup.cs:130 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a3e8eac | this.Load | FP00601_LineAddPopup.cs:131 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f8a72d4 | this.Load | FP00601_LineAddPopup.cs:132 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc363938 | this.Load | FP00601_LineAddPopup.cs:133 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7fbc47f | this.Load | FP00601_LineAddPopup.cs:134 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1797e62d | this.Load | FP00601_LineAddPopup.cs:135 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e46c6ca3 | this.Load | FP00601_LineAddPopup.cs:136 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c77305c | this.Load | FP00601_LineAddPopup.cs:137 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-805b852a | this.Load | FP00601_LineAddPopup.cs:138 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-49617242 | this.Load | FP00601_LineAddPopup.cs:139 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-564bc035 | this.Load | FP00601_LineAddPopup.cs:140 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2b42980 | this.Load | FP00601_LineAddPopup.cs:141 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8387f427 | this.Load | FP00601_LineAddPopup.cs:142 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8747b088 | this.Load | FP00601_LineAddPopup.cs:143 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("NICK_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-581f00d2 | this.Load | FP00601_LineAddPopup.cs:144 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbe78a38 | this.Load | FP00601_LineAddPopup.cs:145 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3087aef | this.Load | FP00601_LineAddPopup.cs:146 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6496236a | this.Load | FP00601_LineAddPopup.cs:147 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb2869ed | this.Load | FP00601_LineAddPopup.cs:150 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-633e4ddf | this.Load | FP00601_LineAddPopup.cs:151 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-760cc715 | this.Load | FP00601_LineAddPopup.cs:152 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("CELL_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-170f7100 | this.Load | FP00601_LineAddPopup.cs:153 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("CELL_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a8f661a | this.Load | FP00601_LineAddPopup.cs:155 |  | DATA_OP | dtSave.Rows.Add | (dtSave.NewRow()) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ca13f26 | this.Load | FP00601_LineAddPopup.cs:155 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |

## FP00601_LineAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4e05d35 | this.Load | FP00601_LineAddPopup.cs:171 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d57070c | this.Load | FP00601_LineAddPopup.cs:175 | if (InitRow== null) | MESSAGE | MessageBox.Show | ("Please select any row before add line") | 메시지 표시 |  |  |  |
| AC-28f401c4 | this.Load | FP00601_LineAddPopup.cs:176 | if (InitRow== null) | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-f644e073 | this.Load | FP00601_LineAddPopup.cs:177 | if (InitRow== null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca8a7e8e | this.Load | FP00601_LineAddPopup.cs:180 |  | DATA_OP | Filter["CURR_DATE"] | "20210715" | 행/컬럼 값 대입 |  |  |  |
| AC-83aba381 | this.Load | FP00601_LineAddPopup.cs:184 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-fa6bab56 | this.Load | FP00601_LineAddPopup.cs:186 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lbMppWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f17d9852 | this.Load | FP00601_LineAddPopup.cs:187 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lbMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-fd4ebc07 | this.Load | FP00601_LineAddPopup.cs:188 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lbWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ac671d28 | this.Load | FP00601_LineAddPopup.cs:191 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lbMppWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-06f4ccda | this.Load | FP00601_LineAddPopup.cs:192 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lbMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f0e17312 | this.Load | FP00601_LineAddPopup.cs:193 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lbWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-461fac98 | this.Load | FP00601_LineAddPopup.cs:198 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["FP_PLAN_DATE"] | Filter["PLAN_DATE"] = DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-cd0ba72b | this.Load | FP00601_LineAddPopup.cs:198 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["PLAN_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-408e6a26 | this.Load | FP00601_LineAddPopup.cs:200 |  | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-6d3cdbe3 | this.Load | FP00601_LineAddPopup.cs:207 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(Filter["PLAN_DATE"].ToString()) < int.Parse(Filter["CURR_DATE"].ToString())) | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["CURR_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-1479221b | this.Load | FP00601_LineAddPopup.cs:212 | else of (Filter["PLAN_TYPE"] == "RELEASE") | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-23944fd1 | this.Load | FP00601_LineAddPopup.cs:216 |  | VALUE_SET | txtNickName.Text | Filter["NICK_NAME"] = InitRow["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b9e60442 | this.Load | FP00601_LineAddPopup.cs:216 |  | DATA_OP | Filter["NICK_NAME"] | InitRow["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-de2e9861 | this.Load | FP00601_LineAddPopup.cs:218 |  | VALUE_SET | txtOperation.Text | Filter["OPERATON_ID"] = InitRow["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f2acbd2e | this.Load | FP00601_LineAddPopup.cs:218 |  | DATA_OP | Filter["OPERATON_ID"] | InitRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-98b29baa | this.Load | FP00601_LineAddPopup.cs:220 |  | VALUE_SET | txtQty.Text | "0" | 컨트롤 값 설정 |  |  |  |
| AC-05daf83d | this.Load | FP00601_LineAddPopup.cs:222 |  | FLAG | dtProdType | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE_PRODTYPE, false, UserInfoContext.Current.UserId… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_PRODTYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-462f2202 | this.Load | FP00601_LineAddPopup.cs:222 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE_PRODTYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSa… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_PRODTYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-05985e2d | this.Load | FP00601_LineAddPopup.cs:227 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cbo_prodtype, false, "CODE", "CODE") | 목록 컨트롤 재구성 |  |  |  |
| AC-e0ca6441 | this.Load | FP00601_LineAddPopup.cs:230 |  | VALUE_SET | cbo_prodtype.SelectedValue | Filter["PRODTYPE_ID"]= InitRow["PRODUCTION_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-e910ece7 | this.Load | FP00601_LineAddPopup.cs:230 |  | DATA_OP | Filter["PRODTYPE_ID"] | InitRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f80f61cd | this.Load | FP00601_LineAddPopup.cs:232 |  | VALUE_SET | txtItemType.Text | Filter["ITEM_TYPE"] = InitRow["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-136ac8df | this.Load | FP00601_LineAddPopup.cs:232 |  | DATA_OP | Filter["ITEM_TYPE"] | InitRow["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-08bf1538 | this.Load | FP00601_LineAddPopup.cs:234 |  | VALUE_SET | txtModel.Text | Filter["TOP_ITEM_ID"] = InitRow["TOP_ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a6a3a9fb | this.Load | FP00601_LineAddPopup.cs:234 |  | DATA_OP | Filter["TOP_ITEM_ID"] | InitRow["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d84b9a5e | this.Load | FP00601_LineAddPopup.cs:236 |  | VALUE_SET | txtItem.Text | Filter["ITEM_ID"] = InitRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b78dd738 | this.Load | FP00601_LineAddPopup.cs:236 |  | DATA_OP | Filter["ITEM_ID"] | InitRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cd339b19 | this.Load | FP00601_LineAddPopup.cs:238 |  | VALUE_SET | txtBuilding.Text | Filter["FACTORY_ID"] = InitRow["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-133bd99f | this.Load | FP00601_LineAddPopup.cs:238 |  | DATA_OP | Filter["FACTORY_ID"] | InitRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef444230 | this.Load | FP00601_LineAddPopup.cs:241 |  | DATA_OP | Filter["ELECTRODE_TYPE"] | InitRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c2066ba0 | this.Load | FP00601_LineAddPopup.cs:243 |  | VALUE_SET | txtLocation.Text | Filter["LOCATION"] = InitRow["LOCATION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-945a2f27 | this.Load | FP00601_LineAddPopup.cs:243 |  | DATA_OP | Filter["LOCATION"] | InitRow["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9dac59a7 | this.Load | FP00601_LineAddPopup.cs:245 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-90bb46ad | this.Load | FP00601_LineAddPopup.cs:246 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-924cc19e | this.Load | FP00601_LineAddPopup.cs:247 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-297e6fe5 | this.Load | FP00601_LineAddPopup.cs:248 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6632030a | this.Load | FP00601_LineAddPopup.cs:249 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ef4ae693 | this.Load | FP00601_LineAddPopup.cs:250 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-58e2c73e | this.Load | FP00601_LineAddPopup.cs:251 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5e6937da | this.Load | FP00601_LineAddPopup.cs:252 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9307ba82 | this.Load | FP00601_LineAddPopup.cs:253 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-72568531 | this.Load | FP00601_LineAddPopup.cs:254 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", Filter["OPERATION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6b5fe271 | this.Load | FP00601_LineAddPopup.cs:255 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", Filter["LINE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5419cd22 | this.Load | FP00601_LineAddPopup.cs:256 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", Filter["ELECTRODE_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e5ee5115 | this.Load | FP00601_LineAddPopup.cs:257 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", Filter["LOCATION"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-62e82765 | this.Load | FP00601_LineAddPopup.cs:273 |  | FLAG | dtMarket | Data_FP.Common_FP(Data_FP.Type.DEMAND_MARKET_TYPE, false, UserInfoContext.Current.UserId, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-076661d2 | this.Load | FP00601_LineAddPopup.cs:273 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DEMAND_MARKET_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSave… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d17b3996 | this.Load | FP00601_LineAddPopup.cs:277 |  | LIST_REBIND | clsCtrl.setListBox | (dtMarket, cbo_market, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6671bd1f | this.Load | FP00601_LineAddPopup.cs:279 |  | VALUE_SET | cbo_market.SelectedValue | Filter["MARKET"] = InitRow["MARKET"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-4328536d | this.Load | FP00601_LineAddPopup.cs:279 |  | DATA_OP | Filter["MARKET"] | InitRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00601_LineAddPopup.radio_Changed

진입점: rdoMPP.CheckedChanged / rdoWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-909111e8 | rdoMPP.CheckedChanged 외 1 | FP00601_LineAddPopup.cs:611 | if (rdoMPP.Checked) ▸ if (Filter["MPP_WPP"] != "MPP") | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-a70e57ba | rdoMPP.CheckedChanged 외 1 | FP00601_LineAddPopup.cs:618 | else of (rdoMPP.Checked) ▸ if (rdoWPP.Checked) ▸ if (Filter["MPP_WPP"] != "WPP") | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00601_LineAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25ad2d34 | this.btnSave.Click | FP00601_LineAddPopup.cs:409 |  | DATA_OP | dtDateMap.Select | ("_DATE = '" + dpPlanDate.Value.ToString("yyyyMMdd") + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-c265a972 | this.btnSave.Click | FP00601_LineAddPopup.cs:421 | if (rowDay.Length < 1) | MESSAGE | MessageBox.Show | ("Out of plan period : " + sFromDate + " ~ " + sToDate ) | 메시지 표시 |  |  |  |
| AC-e054313f | this.btnSave.Click | FP00601_LineAddPopup.cs:422 | if (rowDay.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6072f90 | this.btnSave.Click | FP00601_LineAddPopup.cs:425 |  | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PRODTYPE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cc2bd427 | this.btnSave.Click | FP00601_LineAddPopup.cs:426 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f53f2ad5 | this.btnSave.Click | FP00601_LineAddPopup.cs:430 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-32e6afdc | this.btnSave.Click | FP00601_LineAddPopup.cs:431 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dtSave.SetFirst | ("IN_QTY", "WPP_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-008b604a | this.btnSave.Click | FP00601_LineAddPopup.cs:432 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dtSave.SetFirst | ("OUT_QTY", "WPP_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3087b539 | this.btnSave.Click | FP00601_LineAddPopup.cs:433 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dtSave.SetFirst | ("CELL_IN_QTY", "WPP_CELL_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-92c8c44e | this.btnSave.Click | FP00601_LineAddPopup.cs:434 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dtSave.SetFirst | ("CELL_OUT_QTY", "WPP_CELL_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a1ebe0ef | this.btnSave.Click | FP00601_LineAddPopup.cs:438 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | DATA_OP | Filter["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-f3df1605 | this.btnSave.Click | FP00601_LineAddPopup.cs:439 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("IN_QTY", "MPP_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-675dac00 | this.btnSave.Click | FP00601_LineAddPopup.cs:440 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("OUT_QTY", "MPP_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2b8ccb42 | this.btnSave.Click | FP00601_LineAddPopup.cs:441 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_IN_QTY", "MPP_CELL_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f62ac9e2 | this.btnSave.Click | FP00601_LineAddPopup.cs:442 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_OUT_QTY", "MPP_CELL_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-06697013 | this.btnSave.Click | FP00601_LineAddPopup.cs:444 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["DATE"] | dpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-6a3c7ed4 | this.btnSave.Click | FP00601_LineAddPopup.cs:448 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SELECT", "LINE_DUP") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-64113ffc | this.btnSave.Click | FP00601_LineAddPopup.cs:452 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PRODTYPE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0accae99 | this.btnSave.Click | FP00601_LineAddPopup.cs:453 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-19afa17d | this.btnSave.Click | FP00601_LineAddPopup.cs:454 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c23fc294 | this.btnSave.Click | FP00601_LineAddPopup.cs:456 | else of (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SELECT", "DUP") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cbc03ada | this.btnSave.Click | FP00601_LineAddPopup.cs:464 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | MESSAGE | MessageBox.Show | ("The Line or detail information is already exists.") | 메시지 표시 |  |  |  |
| AC-2a3747b8 | this.btnSave.Click | FP00601_LineAddPopup.cs:465 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b2084eea | this.btnSave.Click | FP00601_LineAddPopup.cs:480 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b0e6908e | this.btnSave.Click | FP00601_LineAddPopup.cs:484 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-913f52de | this.btnSave.Click | FP00601_LineAddPopup.cs:485 | if (checkSave.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc55af74 | this.btnSave.Click | FP00601_LineAddPopup.cs:488 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-874137a0 | this.btnSave.Click | FP00601_LineAddPopup.cs:489 |  | DATA_OP | dtSave.SetFirst | ("FP_PLAN_ID", Filter["FP_PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cc924983 | this.btnSave.Click | FP00601_LineAddPopup.cs:490 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", Filter["PLAN_DATE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c4c0831f | this.btnSave.Click | FP00601_LineAddPopup.cs:491 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ee5d5adb | this.btnSave.Click | FP00601_LineAddPopup.cs:492 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-04396a63 | this.btnSave.Click | FP00601_LineAddPopup.cs:493 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3c348819 | this.btnSave.Click | FP00601_LineAddPopup.cs:494 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a908c11e | this.btnSave.Click | FP00601_LineAddPopup.cs:495 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", txtOperation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8991d624 | this.btnSave.Click | FP00601_LineAddPopup.cs:496 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", txtLine.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ded26f92 | this.btnSave.Click | FP00601_LineAddPopup.cs:497 |  | DATA_OP | dtSave.SetFirst | ("MARKET", cbo_market.ControlValues.ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d4f13374 | this.btnSave.Click | FP00601_LineAddPopup.cs:498 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", txtLocation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-111547ca | this.btnSave.Click | FP00601_LineAddPopup.cs:499 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", "-") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1d829e51 | this.btnSave.Click | FP00601_LineAddPopup.cs:500 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", cbo_prodtype.ControlValues.ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a21e44b9 | this.btnSave.Click | FP00601_LineAddPopup.cs:501 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4331dbb6 | this.btnSave.Click | FP00601_LineAddPopup.cs:502 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f30c938b | this.btnSave.Click | FP00601_LineAddPopup.cs:503 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3bf52eea | this.btnSave.Click | FP00601_LineAddPopup.cs:504 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-bd6a88d6 | this.btnSave.Click | FP00601_LineAddPopup.cs:505 |  | DATA_OP | dtSave.SetFirst | ("DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b87e01bd | this.btnSave.Click | FP00601_LineAddPopup.cs:506 |  | DATA_OP | dtSave.SetFirst | ("USER_ID", Filter["USER_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-36ebd7a7 | this.btnSave.Click | FP00601_LineAddPopup.cs:517 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-83bc0f0f | this.btnSave.Click | FP00601_LineAddPopup.cs:518 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-51e7f579 | this.btnSave.Click | FP00601_LineAddPopup.cs:520 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b68c8670 | this.btnSave.Click | FP00601_LineAddPopup.cs:526 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | src.Tables.Add | (dtSave) | 데이터 객체 조작/조회 |  |  |  |
| AC-72f2d8dd | this.btnSave.Click | FP00601_LineAddPopup.cs:527 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_LineAdd", "saveAll_MPPWPP", src) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_MPPWPP] \| FP\Common\FP0… | 엔드포인트 호출 |  |  |  |
| AC-7f102956 | this.btnSave.Click | FP00601_LineAddPopup.cs:528 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_LineAdd", "saveAll_MPPWPP_log", src) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_MPPWPP_log] \| FP\{?defa… | 엔드포인트 호출 |  |  |  |
| AC-195987fd | this.btnSave.Click | FP00601_LineAddPopup.cs:534 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | src.Tables.Add | (dtSave) | 데이터 객체 조작/조회 |  |  |  |
| AC-63ea64d4 | this.btnSave.Click | FP00601_LineAddPopup.cs:535 | else of (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_LineAdd", "save_all", src) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_all] \| FP\Common\FP00601_L… | 엔드포인트 호출 |  |  |  |
| AC-c3d5565c | this.btnSave.Click | FP00601_LineAddPopup.cs:544 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ lambda ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP00600_PlanAmend", "execute_psiCalcul_2", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul_2] \| FP\Co… | 엔드포인트 호출 |  |  |  |
| AC-f60c00bb | this.btnSave.Click | FP00601_LineAddPopup.cs:548 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ lambda ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (e.Message) | 메시지 표시 |  |  |  |
| AC-ee6932f5 | this.btnSave.Click | FP00601_LineAddPopup.cs:551 | else of (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | runnerPack.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-611a43eb | this.btnSave.Click | FP00601_LineAddPopup.cs:552 | else of (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | Thread.Sleep | (100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c02e9b0 | this.btnSave.Click | FP00601_LineAddPopup.cs:554 | else of (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_RunProcedure | ("FP00600_PlanAmend", "execute_psiCalcul", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Comm… | 엔드포인트 호출 |  |  |  |
| AC-735c1ef9 | this.btnSave.Click | FP00601_LineAddPopup.cs:567 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-ac014a0d | this.btnSave.Click | FP00601_LineAddPopup.cs:568 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_LinePopup.btnButtonList_UsrButtonList_Click_Detected_1

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4bfb09a | this.btnButtonList.UsrButtonList_Click_Detected | FP00601_LinePopup.cs:320 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-07c74442 | this.btnButtonList.UsrButtonList_Click_Detected | FP00601_LinePopup.cs:323 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f0f1404f | this.btnButtonList.UsrButtonList_Click_Detected | FP00601_LinePopup.cs:324 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_LinePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11a35a23 | this.Load | FP00601_LinePopup.cs:139 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-258184e3 | this.Load | FP00601_LinePopup.cs:140 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eadbaa9e | this.Load | FP00601_LinePopup.cs:141 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00601_LinePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5291d90b | this.Load | FP00601_LinePopup.cs:134 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00601_LinePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3802f3c3 | Dispose | FP00601_LinePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00601_LinePopup.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f20becb0 | this.Load 외 2 | FP00601_LinePopup.cs:210 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-708e737d | this.Load 외 2 | FP00601_LinePopup.cs:211 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5b123078 | this.Load 외 2 | FP00601_LinePopup.cs:214 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-eb0900e2 | this.Load 외 2 | FP00601_LinePopup.cs:216 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { //DataSet dtInstType = DataService.FP_ExecuteQuery("FP00601_LineAdd", "find_Insta… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0b6ea7b9 | this.Load 외 2 | FP00601_LinePopup.cs:219 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SELECT", "INSTANCE_TYPE… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0d01abee | this.Load 외 2 | FP00601_LinePopup.cs:222 | lambda ▸ if (dtInstType.Good()) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstType.Tables[0].Rows[0]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1ed3a625 | this.Load 외 2 | FP00601_LinePopup.cs:225 | lambda | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-5ddda034 | this.Load 외 2 | FP00601_LinePopup.cs:226 | lambda | DATA_OP | Filter["LINE_ID"] | txtLine.Text | 행/컬럼 값 대입 |  |  |  |
| AC-5b78d88f | this.Load 외 2 | FP00601_LinePopup.cs:229 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SELECT", "LINE_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3b4348f1 | this.Load 외 2 | FP00601_LinePopup.cs:230 | lambda | RETURN | return lineList; |  | 처리 중단/반환 |  |  |  |
| AC-1839804a | this.Load 외 2 | FP00601_LinePopup.cs:234 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9565e1c8 | this.Load 외 2 | FP00601_LinePopup.cs:237 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fb4362dc | this.Load 외 2 | FP00601_LinePopup.cs:239 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-81f30bfd | this.Load 외 2 | FP00601_LinePopup.cs:243 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_LinePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d471f6fa | this.Load | FP00601_LinePopup.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d3acb4b | this.Load | FP00601_LinePopup.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_LinePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd56b8e5 | this.Load | FP00601_LinePopup.cs:128 |  | VALUE_SET | txtMaterial.Text | Filter["ITEM_ID"] | 컨트롤 값 설정 |  |  |  |

## FP00601_LinePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-931e2d80 | this.Load | FP00601_LinePopup.cs:151 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5eaae31c | this.Load | FP00601_LinePopup.cs:152 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00601_LinePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e00d27d0 | (진입점 미연결) | FP00601_LinePopup.cs:171 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00601_LinePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72ad0b06 | this.Load | FP00601_LinePopup.cs:158 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dad63c49 | this.Load | FP00601_LinePopup.cs:159 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-4af4181e | this.Load | FP00601_LinePopup.cs:163 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00601_LinePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee57675a | this.spdMain.CellClick | FP00601_LinePopup.cs:268 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-d07e3e05 | this.spdMain.CellClick | FP00601_LinePopup.cs:269 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3321d669 | this.spdMain.CellClick | FP00601_LinePopup.cs:272 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00601_LinePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c26413df | this.spdMain.CellDoubleClick | FP00601_LinePopup.cs:278 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-1efd47a5 | this.spdMain.CellDoubleClick | FP00601_LinePopup.cs:279 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6087e212 | this.spdMain.CellDoubleClick | FP00601_LinePopup.cs:282 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-7c1389af | this.spdMain.CellDoubleClick | FP00601_LinePopup.cs:285 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c224c6f | this.spdMain.CellDoubleClick | FP00601_LinePopup.cs:295 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fe9924b | .ctor | FP00601_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-05db96dd | .ctor | FP00601_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-c826f5c3 | .ctor | FP00601_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-001c90e7 | .ctor | FP00601_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00601_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98ff15f0 | Dispose | FP00601_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00601_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-471fd819 | this.Load | FP00601_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00601_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f41e45b2 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:183 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-0544fe95 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:184 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-281eac10 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:212 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-301bc94d | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:213 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-a26de308 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:214 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e872bc5 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:216 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-01a7af4c | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:217 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-dab9a0fd | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:218 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-97930155 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:219 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-a521e4f3 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:221 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-b91b3bfa | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:223 |  | DATA_OP | ctrls.Add | (chk_BOH_2nd) | 데이터 객체 조작/조회 |  |  |  |
| AC-26f32698 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:224 |  | DATA_OP | ctrls.Add | (chk_activated) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f24121a | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:228 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-920e09f0 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:229 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a42dee3 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e03219c | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-af20dac1 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:233 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-07c9809c | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-47f3b70b | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a7532b7 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:237 |  | DATA_OP | ctrls.Add | (chk_result_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0a18d7b | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_off) | 데이터 객체 조작/조회 |  |  |  |
| AC-6afa2d4d | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_setup) | 데이터 객체 조작/조회 |  |  |  |
| AC-3320594e | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_capa) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d124cf9 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-28ac356a | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_total_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-c36e32bc | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:248 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-92351182 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:248 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-ebfb59e0 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:255 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-8b84266b | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:259 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-543a4b33 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:263 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00601_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-371fc1cb | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:129 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2542d8a2 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:130 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8f98c62f | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:131 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-98e0e54f | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:133 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ea9a65b5 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:134 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7a8002d2 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:135 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-983e86aa | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-657fb323 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bc7a5f26 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_BOH_2nd.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ac7fe480 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_activated.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6c46afe1 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-de6569bf | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6b9d0281 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5742b549 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ff6d51d3 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_memo_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-777fec74 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2e4da110 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a471a1f6 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_result_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a07b9318 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_off.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-740eebbd | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_setup.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f0fee28e | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_capa.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-439c5858 | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c825186e | this.Load 외 1 | FP00601_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_total_2.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00601_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ce058d4 | (진입점 미연결) | FP00601_MeasureSetForm_Popup.cs:328 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-713a0eeb | (진입점 미연결) | FP00601_MeasureSetForm_Popup.cs:339 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b37e912 | (진입점 미연결) | FP00601_MeasureSetForm_Popup.cs:350 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00601_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-093aa0d5 | this.Load | FP00601_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d7b77fba | this.Load | FP00601_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00601_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cccdf8d0 | this.usrButton1.Click | FP00601_MeasureSetForm_Popup.cs:312 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-bb64458e | this.usrButton1.Click | FP00601_MeasureSetForm_Popup.cs:312 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-199910cb | this.usrButton1.Click | FP00601_MeasureSetForm_Popup.cs:314 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-dfd8ea7a | this.usrButton1.Click | FP00601_MeasureSetForm_Popup.cs:318 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-ce5058af | this.usrButton1.Click | FP00601_MeasureSetForm_Popup.cs:319 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-022c3a58 | this.usrButton1.Click | FP00601_MeasureSetForm_Popup.cs:321 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-22a020dc | this.usrButton1.Click | FP00601_MeasureSetForm_Popup.cs:323 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00601_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb6be814 | this.usrButton2.Click | FP00601_MeasureSetForm_Popup.cs:281 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-2488040f | this.usrButton2.Click | FP00601_MeasureSetForm_Popup.cs:281 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-e959219b | this.usrButton2.Click | FP00601_MeasureSetForm_Popup.cs:283 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-6bf8e7fc | this.usrButton2.Click | FP00601_MeasureSetForm_Popup.cs:287 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-dd9fb8e2 | this.usrButton2.Click | FP00601_MeasureSetForm_Popup.cs:288 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-abbf18ad | this.usrButton2.Click | FP00601_MeasureSetForm_Popup.cs:289 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-7e5c7777 | this.usrButton2.Click | FP00601_MeasureSetForm_Popup.cs:290 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_PlanAmend_Line_Pack..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28631408 | .ctor | FP00601_PlanAmend_Line_Pack.cs:135 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-c2b2cb64 | .ctor | FP00601_PlanAmend_Line_Pack.cs:136 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00601_PlanAmend_Line_Pack.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPla…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46781ba6 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2467 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7dac53d5 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2468 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a4f67ed6 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2469 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f6bd96a1 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2470 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3b648657 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2471 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5c83797c | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2472 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-0831b01c | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2472 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-41df69f3 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2473 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-89f2e9b4 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2473 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e82fcd13 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2474 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-171a9e7c | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2474 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ec108f45 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2475 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-79637cb2 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2475 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-646a79bd | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2501 | if (measure != null && measure.Data != null && measure.Data.Keys != null) ▸ foreach (string key in measure.Data.Keys) ▸ if (measure != null)… | UI_PROP | measure_chk.ForceQuery | true | 속성 ForceQuery 설정 |  |  |  |
| AC-ffc675e6 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2510 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-b2ac1a92 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2511 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-3e22b8e3 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2512 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-fb499d4d | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2513 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-c46cbd7e | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2514 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00601_PlanAmend_Line_Pack.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPla…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17f6fbca | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2520 | if (GetFilter("INSTANCE_ID") == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { SetFilter("INSTANCE_ID", CString.GetCheckedListValue(dtIn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-aaf89ad8 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2528 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["BUCKET_FROM"] = dCalendar_planrange.Value1.ToStri… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f6e2875 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2530 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b40a36a6 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2531 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-00215d12 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2532 | lambda | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-28ca9206 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2536 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cbo_fpplanid.SelectedIndex >= 0) { Filter["PLAN_ID"] … | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f9ec705 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2540 | lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-f8692098 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2546 |  | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-2afc3e2b | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2547 |  | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R " | 행/컬럼 값 대입 |  |  |  |
| AC-439b5a6a | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2548 |  | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_PACK_BOR_R " | 행/컬럼 값 대입 |  |  |  |
| AC-df6540ec | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2549 |  | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-3940cc74 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2550 |  | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_PACK_UTIL_R " | 행/컬럼 값 대입 |  |  |  |
| AC-b674124b | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2554 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-7569f071 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2555 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H " | 행/컬럼 값 대입 |  |  |  |
| AC-44195587 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2556 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_PACK_BOR_H " | 행/컬럼 값 대입 |  |  |  |
| AC-ba6d568b | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2557 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-230e81e9 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2558 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_PACK_UTIL_H " | 행/컬럼 값 대입 |  |  |  |
| AC-fa5e08ff | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2562 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnBucket_Click

진입점: this.btn_bucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a27db27d | this.btn_bucket.Click | FP00601_PlanAmend_Line_Pack.cs:4736 |  | POPUP | new FP00601_BucketSetForm_Popup | ("FP00601", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-7bdfab49 | this.btn_bucket.Click | FP00601_PlanAmend_Line_Pack.cs:4738 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-ee575e51 | this.btn_bucket.Click | FP00601_PlanAmend_Line_Pack.cs:4740 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e8c722e0 | this.btn_bucket.Click | FP00601_PlanAmend_Line_Pack.cs:4741 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cb9973df | this.btn_bucket.Click | FP00601_PlanAmend_Line_Pack.cs:4745 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-f121cef5 | this.btn_bucket.Click | FP00601_PlanAmend_Line_Pack.cs:4754 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c87ee999 | this.btn_bucket.Click | FP00601_PlanAmend_Line_Pack.cs:4756 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnCatagory_Click

진입점: this.btn_category.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f089f2e | this.btn_category.Click | FP00601_PlanAmend_Line_Pack.cs:4701 |  | POPUP | new FP00601_MeasureSetForm_Popup | ("FP00601", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-20906457 | this.btn_category.Click | FP00601_PlanAmend_Line_Pack.cs:4702 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-0fb8e74f | this.btn_category.Click | FP00601_PlanAmend_Line_Pack.cs:4703 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d521167e | this.btn_category.Click | FP00601_PlanAmend_Line_Pack.cs:4704 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-445e5703 | this.btn_category.Click | FP00601_PlanAmend_Line_Pack.cs:4708 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-de124458 | this.btn_category.Click | FP00601_PlanAmend_Line_Pack.cs:4717 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-895ab06a | this.btn_category.Click | FP00601_PlanAmend_Line_Pack.cs:4719 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnColumn_Click

진입점: this.btn_column.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-953fe531 | this.btn_column.Click | FP00601_PlanAmend_Line_Pack.cs:4681 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00601", SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-24d38f07 | this.btn_column.Click | FP00601_PlanAmend_Line_Pack.cs:4682 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8a14bece | this.btn_column.Click | FP00601_PlanAmend_Line_Pack.cs:4683 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnCreatePlan_Click

진입점: this.btnCreatePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f95b442b | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5067 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-5db94969 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5068 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-b564281d | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5075 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe704520 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5076 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ec471d8 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5086 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Master.PR_UI_FP00601_FIND_FP0060 | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cd952c20 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5088 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-52c46886 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5094 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56a349b3 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5095 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a513513d | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5100 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1585a4ab | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5101 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-05cc0d74 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5104 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb434c85 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5105 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-74ef4348 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5106 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-85440127 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5112 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-c3da4785 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5121 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-0b532101 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5122 |  | VALUE_SET | popPlanTotal.Text | "Create Plan" | 컨트롤 값 설정 |  |  |  |
| AC-87963413 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5123 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a7e9ddc1 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5124 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-82eee7c2 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5133 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] = popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-229f95ff | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5133 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["PLAN_ID"] | popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-87a87291 | this.btnCreatePlan.Click | FP00601_PlanAmend_Line_Pack.cs:5141 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | VALUE_SET | cbo_fpplanid.SelectedValue | new_plan | 컨트롤 값 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnDppWppCopyDwSubmit_Click

진입점: this.btnDppWppCopyDwSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca633874 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5528 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-30a61aec | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5529 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-9fd23858 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5537 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b992ba2f | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5538 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-506de0f4 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5542 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-36159497 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5543 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-65b1d622 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5547 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-f8e40928 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5548 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8a0a30b | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5553 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-7f45dbdb | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5554 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e937c66 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5559 | if (Filter["PLAN_TYPE"] != "RELEASE") | MESSAGE | MessageBox.Show | ("Only Release plan can proceed.") | 메시지 표시 |  |  |  |
| AC-2b522657 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5560 | if (Filter["PLAN_TYPE"] != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18176439 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5563 |  | POPUP | new FPC0125_MWPPCopyDWSubmitPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6512e27c | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5564 |  | UI_PROP | CopySubmit.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-1129cb24 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5564 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-33baba49 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5565 |  | DATA_OP | CopySubmit.Filter["SUBMIT_TYPE"] | "PACK" | 행/컬럼 값 대입 |  |  |  |
| AC-c13b6204 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5566 |  | DATA_OP | CopySubmit.Filter["MASTER_ID"] | CopySubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-82341f85 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5566 |  | DATA_OP | CopySubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-11162003 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5567 |  | DATA_OP | CopySubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-e2458101 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5568 |  | DATA_OP | CopySubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-cf1418cc | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5569 |  | DATA_OP | CopySubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3ff537d5 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5570 |  | DATA_OP | CopySubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e3d019b2 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5571 |  | DATA_OP | CopySubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c9abae86 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5572 |  | DATA_OP | CopySubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-15ab5506 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5573 |  | DATA_OP | CopySubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f0cb2f94 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5574 |  | DATA_OP | CopySubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6b26e55a | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5575 |  | DATA_OP | CopySubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3b2bd4f0 | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5577 |  | UI_PROP | CopySubmit.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6ee67b7d | this.btnDppWppCopyDwSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5578 |  | POPUP | CopySubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnDwSubmit_Click

진입점: this.btnDWSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74fcbaab | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5465 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-2ad8fa7b | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5466 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-a145302f | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5474 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d5e348c | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5475 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99dd6e39 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5479 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d4eb410a | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5480 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c50d8fbf | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5483 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-afe8751a | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5484 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b38271f4 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5489 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-f29c0669 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5490 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e3e775b | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5495 | if (Filter["PLAN_TYPE"] != "RELEASE") | MESSAGE | MessageBox.Show | ("Only Release plan can proceed.") | 메시지 표시 |  |  |  |
| AC-c3ee916d | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5496 | if (Filter["PLAN_TYPE"] != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc2ab141 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5501 |  | DATA_OP | DwSubmit.Filter["SUBMIT_TYPE"] | "PACK" | 행/컬럼 값 대입 |  |  |  |
| AC-f9d6206a | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5502 |  | DATA_OP | DwSubmit.Filter["MASTER_ID"] | DwSubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7e807693 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5502 |  | DATA_OP | DwSubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1ba21854 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5503 |  | DATA_OP | DwSubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-5164b6e5 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5504 |  | DATA_OP | DwSubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-2a519b05 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5505 |  | DATA_OP | DwSubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d559d9b8 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5506 |  | DATA_OP | DwSubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1fec5c1f | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5507 |  | DATA_OP | DwSubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f27ef87b | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5508 |  | DATA_OP | DwSubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-16ce9fea | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5509 |  | DATA_OP | DwSubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-072c47b3 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5510 |  | DATA_OP | DwSubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-edd61337 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5511 |  | DATA_OP | DwSubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-79ddd7dc | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5512 |  | DATA_OP | DwSubmit.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-fac31f74 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5513 |  | DATA_OP | DwSubmit.Filter["CONFIRM_TYPE"] | DwSubmit.Filter["CONFIRM_AREA"] = Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-e0559ce6 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5513 |  | DATA_OP | DwSubmit.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-2adb5d52 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5515 |  | UI_PROP | DwSubmit.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-75a48301 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5516 |  | POPUP | DwSubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fdc95db3 | this.btnDWSubmit.Click | FP00601_PlanAmend_Line_Pack.cs:5519 | if (DwSubmit.ShowDialog() == DialogResult.OK) | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14eb307b | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2572 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c4ed082 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2573 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d219949 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2579 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-96291741 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2580 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-36945098 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2585 | if (Filter["PLAN_TYPE"] == "RELEASE" && Filter["IS_LATEST_PLAN"] != "Y") | MESSAGE | MessageHelper.GMessageBox | ("Current not Plan ID !!") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ef9f417e | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2586 | if (Filter["PLAN_TYPE"] == "RELEASE" && Filter["IS_LATEST_PLAN"] != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57a52407 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2589 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-8f2984e8 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2590 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-287c8504 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2591 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-231bc49a | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2592 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0660eca5 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2599 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP00601_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-391dfe55 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2602 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-773cc566 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2602 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-56b417f0 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2604 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.QTY | 속성 DateColumnType 설정 |  |  |  |
| AC-43608b73 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2606 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c04bf072 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2607 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f7aff28d | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2608 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-59ebdafd | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2609 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["TOP_ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-46ee55b7 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2610 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3e48654e | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2611 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-14fad63a | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2612 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c9c26eed | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2613 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LOCATION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ce5190ff | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2614 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-211e14b9 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2615 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-125aa74a | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2616 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-66cc13a4 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2619 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-407b0fb4 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2620 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-88c52295 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2621 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-c61ff737 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2622 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["TOP_ITEM_ID"] | "Model" | 행/컬럼 값 대입 |  |  |  |
| AC-fe1f2f90 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2623 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-24c9c00e | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2625 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-dcd12e9c | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2626 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-08fb39b1 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2628 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-024672ce | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2629 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-7d5c8d82 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2630 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-734f523d | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2631 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-5540c368 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2632 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-c5e8b98e | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2633 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-041bae42 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2634 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-4aa3fec7 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2635 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTROD_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-82c0b03d | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2637 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSearchData | call_Excel_Col_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-a27da458 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2638 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | call_Excel_Col_LineCheck | 속성 DoLineCheck 설정 |  |  |  |
| AC-56ff1091 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2639 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSaveData | call_Excel_Col_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-53c29aa9 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2640 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoValidationData | call_Excel_Col_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-8cf7abd3 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2641 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ccdaa23d | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2650 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP00601_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-2918e9b8 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2653 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-b0610590 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2653 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7ea98337 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2657 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3aa240df | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2658 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e6d77145 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2659 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f00f12dd | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2660 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["TOP_ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1da47a13 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2661 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-59cd7f18 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2662 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-48c1bae8 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2663 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6fa1611e | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2664 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LOCATION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-bb3f3d43 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2665 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0a944045 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2666 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a7f4f206 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2667 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4f337a59 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2669 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6c8c71f1 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2670 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-72b773d5 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2672 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-182f2725 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2673 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-9ca8aef6 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2674 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-a953d501 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2675 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["TOP_ITEM_ID"] | "Model" | 행/컬럼 값 대입 |  |  |  |
| AC-a4af8510 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2676 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-db22db22 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2677 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-945c1990 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2678 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-5d174250 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2679 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-f35e24cb | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2680 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-7593f4d6 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2681 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-f726aa07 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2682 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-75503eaf | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2683 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-07b3641b | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2684 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-472f56c6 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2685 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-f46ff898 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2686 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTROD_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-5d5c7712 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2687 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-37ff5723 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2688 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["QTY"] | "QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-b44ef178 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2689 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-94719271 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2691 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["DIVISION_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-39986f28 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2692 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["SITE_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-46e9cd1d | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2693 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["PLANT_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-1a192137 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2694 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["TOP_ITEM_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-c99d1742 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2695 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["ITEM_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-6c4c7143 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2696 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["OPERATION_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-c2acdf0e | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2697 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["FACTORY_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-38c18f78 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2698 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["LOCATION"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-b0cd51a8 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2699 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["PRODUCTION_TYPE"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-332e4e8e | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2700 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["MARKET"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-e85d5985 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2701 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["LINE_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-82a962f3 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2702 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["ELECTRODE_TYPE"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-00a6fb7c | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2703 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["PLAN_DATE"] | "DATE_YYYYMMDD" | 행/컬럼 값 대입 |  |  |  |
| AC-db6938ad | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2704 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["QTY"] | "NUMBER" | 행/컬럼 값 대입 |  |  |  |
| AC-2614694d | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2705 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["SEQ"] | "NUMBER" | 행/컬럼 값 대입 |  |  |  |
| AC-9678350a | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2707 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["DIVISION_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-6ebe1ede | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2708 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["SITE_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-2548b124 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2709 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["PLANT_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-915692de | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2710 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["TOP_ITEM_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-b67c37e8 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2711 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["ITEM_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-2cfdad4b | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2712 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["OPERATION_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-5b35ab26 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2713 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["FACTORY_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-13a27df8 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2714 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["LOCATION"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-234f6cea | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2715 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["PRODUCTION_TYPE"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-37c49a21 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2716 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["MARKET"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-e627946f | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2717 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["LINE_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-e9cf4fdf | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2718 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["ELECTRODE_TYPE"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-b7134ec0 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2719 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["PLAN_DATE"] | 8 | 행/컬럼 값 대입 |  |  |  |
| AC-880801df | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2720 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["QTY"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-116b9e89 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2721 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["SEQ"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-d85c3ed1 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2723 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-bcbcb739 | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2725 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-732f881a | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2726 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-14d934fb | this.btnExcelImport.Click | FP00601_PlanAmend_Line_Pack.cs:2727 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d376788 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5366 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-a81442c7 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5367 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-a914970d | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5375 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6899ae9 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5376 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b88c761b | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5382 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-dfaa4bfd | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5383 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71d2fc9b | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5386 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d2f02c3f | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5387 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-dac347e9 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5387 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-10eaf10c | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5388 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-fd4eb4ea | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5389 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-f042bfa2 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5390 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b923a4c7 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5390 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-dce6c03b | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5391 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0d7c3af1 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5392 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8b94a7cd | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5393 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6870012b | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5394 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a0160c82 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5395 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f43ebe45 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5396 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-25ddafdd | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5397 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f5d7cb0b | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5398 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4aefc487 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5399 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-90b99c46 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5401 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-89245105 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5403 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d656b7d3 | this.btnMemo.Click | FP00601_PlanAmend_Line_Pack.cs:5404 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnMenu_Click

진입점: this.btnMenu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccf8689a | this.btnMenu.Click | FP00601_PlanAmend_Line_Pack.cs:5587 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnMenu, menuPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-7104efe5 | this.btnMenu.Click | FP00601_PlanAmend_Line_Pack.cs:5587 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnMRP_Click

진입점: this.btnMRP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ff48add | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5017 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-c55773ac | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5018 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-031e8a33 | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5026 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-32333b51 | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5027 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba49a887 | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5032 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-33e89cc6 | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5033 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8ae4f33e | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5036 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-868150ff | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5037 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0306ea5c | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5042 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-ee7db11f | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5043 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db80f8c8 | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5048 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-0eb3db83 | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5049 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce9153d3 | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5053 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-aca65e08 | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5054 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bfde8339 | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5055 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0abbf8fe | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5056 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-0e5654a0 | this.btnMRP.Click | FP00601_PlanAmend_Line_Pack.cs:5058 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnRelease_Click

진입점: this.btnRelease.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4a65bdd | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5180 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-6ba53263 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5181 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-ade18024 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5188 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b9c36e6 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5189 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6dd75124 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5193 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-032ef6b2 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5194 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-eff8cc10 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5197 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-fbb3ff11 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5198 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-634acb3f | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5211 | if (string.IsNullOrEmpty(sPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d22c991 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5212 | if (string.IsNullOrEmpty(sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4e991e7 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5218 | if (sPlanID == "-") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d69516e | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5219 | if (sPlanID == "-") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48fb74af | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5226 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "00 Plan cant not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0af7687e | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5227 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-292b0016 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5230 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_instanceInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8a3b02da | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5231 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_planInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-08d491ba | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5233 |  | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9352dca9 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5239 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Release type plan can not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-152e8eeb | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5240 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-702fac1b | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5244 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-400cce60 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5248 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b8fec8aa | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5249 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a366c3ee | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5256 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56febcb4 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5257 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92a540ae | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5270 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-80144a1d | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5273 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-002ead25 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5275 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-dd800e78 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5281 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-27f2f209 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5282 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c17f30e | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5295 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c5a589d | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5296 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-99e0fcde | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5307 | if (sConfirmArea == "PLAN GROUP") ▸ if (sUseWoWStatus == "Y") ▸ if (!fn_getStepValid()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5bd4384f | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5313 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-8d3547bb | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5316 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-537a0a80 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5317 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-1b749bae | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5318 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9262b18b | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5319 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e0d54063 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5327 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-47ee94f7 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5330 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-2ac8c416 | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5331 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-ec11001a | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5332 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-67218b6c | this.btnRelease.Click | FP00601_PlanAmend_Line_Pack.cs:5333 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.Show | () | 팝업/폼 열기 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnReplan_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f58d30b9 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:5171 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-bbd09641 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:5172 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1f847fa | this.btnSql.Click | FP00601_PlanAmend_Line_Pack.cs:1749 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f4f8f5c8 | this.btnSql.Click | FP00601_PlanAmend_Line_Pack.cs:1750 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a0bae157 | this.btnSql.Click | FP00601_PlanAmend_Line_Pack.cs:1752 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef74084b | this.btnSql.Click | FP00601_PlanAmend_Line_Pack.cs:1753 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00601_PlanAmend_Line_Pack.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cd96fa7 | this.btnToggleSave.Click | FP00601_PlanAmend_Line_Pack.cs:4773 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1cdd956 | this.button1.Click | FP00601_PlanAmend_Line_Pack.cs:5648 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.call_Excel_Col_LineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24098d39 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3209 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.call_Excel_Col_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3289ebe | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2813 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0b6fa058 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2817 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-9d9a223d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2818 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-fc1b8c2d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2836 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("MPP_WPP") | 데이터 객체 조작/조회 |  |  |  |
| AC-88ddfb23 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2837 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("MPP_WPP")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("MPP_WPP", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-afaa6e03 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2838 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-7fc14898 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2839 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-33b5bb8d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2840 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("IN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-6935abe9 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2841 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("IN_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b19ba928 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2842 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c16a5f8 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2843 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("OUT_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-19dc07de | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2844 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("CELL_OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-229ccd23 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2845 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("CELL_OUT_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3257bcc2 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2846 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("CELL_IN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c20382f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2847 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("CELL_IN_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("CELL_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4533ff6c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2848 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-f2b11c90 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2849 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e942b3ee | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2858 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-ad686af4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2859 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["MPP_WPP"] | popup.Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-938611fa | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2860 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | popup.Filter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-16165e68 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2863 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-1005cd4f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2864 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-dda3b867 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2865 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["CELL_IN_QTY"] | "WPP_CELL_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-b47f2b0a | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2866 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["CELL_OUT_QTY"] | "WPP_CELL_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-c2217e62 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2870 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-3510a040 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2871 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-27d70566 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2872 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["CELL_IN_QTY"] | "MPP_CELL_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-cc2f9208 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2873 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["CELL_OUT_QTY"] | "MPP_CELL_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-a87626e3 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2878 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(qty)) | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-56eefc84 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2884 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-557328a7 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2886 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | copyDt.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-85a89deb | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2887 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | copyDt.copyInsert | (dataLocal.Tables[0].Rows[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-31402bde | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2889 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | copyDs.Tables.Add | (copyDt) | 데이터 객체 조작/조회 |  |  |  |
| AC-323153cb | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2892 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_MPPWPP", "merge_Excel_import", copyDs, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_Excel_import] \| FP\Common… | 엔드포인트 호출 |  |  |  |
| AC-a7669e29 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2900 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-ac775247 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2901 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | UI_MISC | popup.Close | () | 창 닫기/해제 |  |  |  |
| AC-3bf27a67 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2907 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (do_save) | MESSAGE | MessageBox.Show | ("Cannot save data : Unknown reason") | 메시지 표시 |  |  |  |
| AC-cf972501 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2910 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return result.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-10f21212 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2917 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | data.Copy | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-67a334c3 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2922 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsMerge.Good()) ▸ while (dsMerge.Tables[0].Rows.Count > 1) | DATA_OP | dsMerge.Tables[0].Rows.RemoveAt | (dsMerge.Tables[0].Rows.Count - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ce9c894 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2929 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_EXCEL_IMPORT", "merge_ExcelImport", dsMerge, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_ExcelImport] \| FP\Common\… | 엔드포인트 호출 |  |  |  |
| AC-df0e0cc4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2937 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-095bf31e | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2938 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | UI_MISC | popup.Close | () | 창 닫기/해제 |  |  |  |
| AC-4d68124e | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2948 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ lambda ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP00600_PlanAmend", "execute_psiCalcul_2", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul_2] \| FP\Co… | 엔드포인트 호출 |  |  |  |
| AC-c9d5771b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2952 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ lambda ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (e.Message) | 메시지 표시 |  |  |  |
| AC-201e73f1 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2955 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) | CALL_EXT | runnerPack.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c4d8ac7 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2956 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) | CALL_EXT | Thread.Sleep | (100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e154156b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2958 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) | ENDPOINT | DataService.FP_RunProcedure | ("FP00600_PlanAmend", "execute_psiCalcul", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Comm… | 엔드포인트 호출 |  |  |  |
| AC-bb349668 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2962 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) | RETURN | return result.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-81df4f7b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2966 | else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (do_save) | MESSAGE | MessageBox.Show | ("Cannot save data : Unknown reason") | 메시지 표시 |  |  |  |
| AC-ff520c8b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3017 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.call_Excel_Col_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-579a6d49 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2753 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_MPPWPP", popup.Filter, CurrentUser, "SELECT", "EXCEL_COLUMN_IMPORT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d6a43c3d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2757 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ( "INSTANCE_ID", "FP_PLAN_ID", "COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_IT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-443830f7 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2764 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("INSTANCE_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fcb24e78 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2765 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("FP_PLAN_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bcc3e67c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2766 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("COMPANY_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-37fdf00b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2767 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("ELECTRODE_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f016fba | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2768 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("EQUIPMENT_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6f4b2d6 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2769 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumnsEndsWith | ("_SEQ") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a881711 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2770 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumnsEndsWith | ("_CELL") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ce4ecfe | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2773 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-939e2c39 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2782 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_COLUMN_IMPORT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-845fa6c7 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2785 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ( "INSTANCE_ID", "FP_PLAN_ID", "COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_IT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d2b73b9 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2792 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("INSTANCE_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6306d58 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2793 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("FP_PLAN_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-518d223f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2794 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("COMPANY_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-902ed4e4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2795 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("ELECTRODE_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa08d2c5 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2796 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("EQUIPMENT_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-40a8bfce | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2797 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumnsEndsWith | ("_SEQ") | ⚠ 의미 확인 필요 |  |  |  |
| AC-839ac654 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2798 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumnsEndsWith | ("_CELL") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f179311 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2800 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-52211f65 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2804 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.call_Excel_Col_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f456a8e | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3026 |  | UI_PROP | popup.dsSaveExcelData | new DataSet() | 속성 dsSaveExcelData 설정 |  |  |  |
| AC-c6850c94 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3027 |  | DATA_OP | popup.dsSaveExcelData.Tables.Add | (data.Tables[0].Clone()) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b1babd3 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3027 |  | DATA_OP | data.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-07359546 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3030 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b4bf1f4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3031 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("PLAN_DATE")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-327b2066 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3032 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-2cac4189 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3033 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("QTY")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb8b7012 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3034 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7615c535 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3035 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("ELECTRODE_TYPE")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a19b5d2f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3036 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9da22674 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3037 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("ELECTRODE_TYPE")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ebf2a04 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3038 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-106d8ffc | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3039 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-34f23e96 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3040 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b53e88cf | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3041 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-117a6c8d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3042 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5da765e2 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3043 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("COMPANY_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-de136509 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3064 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3518ed1c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3067 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["INSTANCE_ID"] | popup.Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1609b67d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3068 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-20c589c1 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3069 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["COMPANY_ID"] | popup.Filter["COMPANY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1fba1095 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3071 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLAN_DATE"] | aDate.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-c5fda952 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3073 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["QTY"] | rowval | 행/컬럼 값 대입 |  |  |  |
| AC-6271fa40 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3075 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["DIVISION_ID"] | row["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f962d707 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3076 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["SITE_ID"] | row["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5a421cfc | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3077 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLANT_ID"] | row["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-45ed73a5 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3078 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ITEM_ID"] | row["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3c533de2 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3079 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["OPERATION_ID"] | row["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7c2d0f64 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3080 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FACTORY_ID"] | row["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a6566deb | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3081 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LOCATION"] | row["LOCATION"] | 행/컬럼 값 대입 |  |  |  |
| AC-f3853343 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3082 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a012897b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3083 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["MARKET"] | row["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-bffb29e4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3084 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LINE_ID"] | row["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bb27200e | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3086 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-34d194a7 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3088 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["TOP_ITEM_ID"] | row["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1d2d5d2a | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3089 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ITEM_TYPE"] | row["ITEM_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-fd49cd5b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3093 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].Rows.Add | (pivotLine) | 데이터 객체 조작/조회 |  |  |  |
| AC-f29e4fa5 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3113 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-991c023f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3117 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (nSeq.Good()) | DATA_OP | popup.Filter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-cde08cb8 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3121 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("MPP_WPP") | 데이터 객체 조작/조회 |  |  |  |
| AC-01bc1277 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3122 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("MPP_WPP")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("MPP_WPP", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2c376d6 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3123 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-476e33fd | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3124 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4eaa0b59 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3125 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("CELL_OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-5641e107 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3126 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("CELL_OUT_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-edda5bb4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3127 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4d3d9a17 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3128 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e278f4cb | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3129 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-139dce14 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3130 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-996d472d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3139 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-b054379c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3140 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["MPP_WPP"] | popup.Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-0576906f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3142 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-9e68e3ba | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3143 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b48cd34f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3144 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-15da7a57 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3149 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (string.IsNullOrWh… | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-a7121118 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3154 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_MPPWPP", "insert_Excel_buffer", dataLocal) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-7f2e7446 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3156 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_MPPWPP_VALIDATION") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3c8d7131 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3158 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |
| AC-17049f32 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3176 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ShopType | ShopType.PACK | 속성 ShopType 설정 |  |  |  |
| AC-ea65fa1c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3177 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-282d3a5d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3178 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dtSaveData | popup.dsSaveExcelData.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-805a44f4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3179 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.Filter | popup.Filter | 속성 Filter 설정 |  |  |  |
| AC-6ab10bce | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3180 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.PlanId | Filter["PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-81294a48 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3181 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.sInstanceId | Filter["INSTANCE_ID"] | 속성 sInstanceId 설정 |  |  |  |
| AC-bba5b02b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3183 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-85b0d295 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3198 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return amend.dsValidationReturn; |  | 처리 중단/반환 |  |  |  |
| AC-7266917c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3201 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a98220b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3264 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("MPP_WPP") | 데이터 객체 조작/조회 |  |  |  |
| AC-acc94043 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3265 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("MPP_WPP")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("MPP_WPP", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1317a937 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3266 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ea7b673 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3267 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca6a2e3d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3268 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("IN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c23365b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3269 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("IN_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6036643c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3270 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-4bfe6df2 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3271 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("OUT_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2f4e95c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3272 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("CELL_OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-796c0f4e | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3273 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("CELL_OUT_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc3ab5b6 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3274 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("CELL_IN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-139b187c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3275 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("CELL_IN_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("CELL_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe53f8ab | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3283 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-1c56a679 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3284 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["MPP_WPP"] | popup.Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-71e89373 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3285 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | popup.Filter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-7f958d02 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3288 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-f236b005 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3289 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-d82d191a | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3290 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["CELL_IN_QTY"] | "WPP_CELL_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-e4bc9e33 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3291 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["CELL_OUT_QTY"] | "WPP_CELL_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-8b55b346 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3295 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-46a5a3ee | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3296 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-9a3df56c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3297 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["CELL_IN_QTY"] | "MPP_CELL_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-06643623 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3298 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["CELL_OUT_QTY"] | "MPP_CELL_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-9684c3b7 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3303 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (string.IsNullOrWh… | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-08bca501 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3307 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_MPPWPP", "merge_Excel_import", dataLocal, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_Excel_import] \| FP\Common… | 엔드포인트 호출 |  |  |  |
| AC-fd07d823 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3315 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-cae34a22 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3316 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | UI_MISC | popup.Close | () | 창 닫기/해제 |  |  |  |
| AC-3014dec4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3322 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (do_save) | MESSAGE | MessageBox.Show | ("Cannot save data : Unknown reason") | 메시지 표시 |  |  |  |
| AC-8fcdfdcc | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3325 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return result.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a975d6c3 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3358 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | data.Copy | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07625eae | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3363 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsMerge.Good()) ▸ while (dsMerge.Tables[0].Rows.Count > 1) | DATA_OP | dsMerge.Tables[0].Rows.RemoveAt | (dsMerge.Tables[0].Rows.Count - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f19088df | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3370 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_EXCEL_IMPORT", "merge_ExcelImport", dsMerge, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_ExcelImport] \| FP\Common\… | 엔드포인트 호출 |  |  |  |
| AC-46944729 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3379 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-d732cfd1 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3380 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | UI_MISC | popup.Close | () | 창 닫기/해제 |  |  |  |
| AC-9603eb7a | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3390 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ lambda ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP00600_PlanAmend", "execute_psiCalcul_2", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul_2] \| FP\Co… | 엔드포인트 호출 |  |  |  |
| AC-68b2a373 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3394 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ lambda ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (e.Message) | 메시지 표시 |  |  |  |
| AC-cf91bb7f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3397 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) | CALL_EXT | runnerPack.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3f285906 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3398 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) | CALL_EXT | Thread.Sleep | (100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-63655d2b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3400 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) | ENDPOINT | DataService.FP_RunProcedure | ("FP00600_PlanAmend", "execute_psiCalcul", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Comm… | 엔드포인트 호출 |  |  |  |
| AC-d7a1312c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3404 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) | RETURN | return result.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e80e39f4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3408 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (do_save) | MESSAGE | MessageBox.Show | ("Cannot save data : Unknown reason") | 메시지 표시 |  |  |  |
| AC-b5088f18 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3416 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c5317c8 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3226 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_MPPWPP", popup.Filter, CurrentUser, "SELECT", "EXCEL_ROW_IMPORT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-98dbb1df | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3228 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-92db141c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3238 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_ROW_IMPORT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-aeaa5457 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3240 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-2e03945c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3243 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6de03d3e | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3422 |  | DATA_OP | column_params.Add | ("USER_ID", CurrentUser) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9013c1c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3436 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-38729b72 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3440 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (nSeq.Good()) | DATA_OP | popup.Filter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-8eff1b39 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3444 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("MPP_WPP") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1f9c585 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3445 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("MPP_WPP")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("MPP_WPP", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b365ab9 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3446 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3ad3de5 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3447 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-988c18dd | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3448 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("CELL_OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d2ea9e2 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3449 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("CELL_OUT_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf492a6a | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3450 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6358c8ce | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3451 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6dc78ec8 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3452 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3456c98 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3453 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dataLocal.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed6c5055 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3462 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-118f80cc | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3463 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["MPP_WPP"] | popup.Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-bd2f068d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3465 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-ffbc2b21 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3466 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1e6b5e91 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3467 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8f2ed05d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3472 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (string.IsNu… | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-b471acd4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3477 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_MPPWPP", "insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-9313e45a | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3479 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_MPPWPP_VALIDATION") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-43fca9cd | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3481 | if (popup != null) ▸ try ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |
| AC-df49f656 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3486 | if (popup != null) ▸ try ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ShopType | ShopType.PACK | 속성 ShopType 설정 |  |  |  |
| AC-0d55c88f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3487 | if (popup != null) ▸ try ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-0d374137 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3488 | if (popup != null) ▸ try ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dtSaveData | data.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-b9a481ed | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3489 | if (popup != null) ▸ try ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.Filter | popup.Filter | 속성 Filter 설정 |  |  |  |
| AC-0a6bc6e7 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3490 | if (popup != null) ▸ try ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.PlanId | Filter["PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-f4db3c16 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3491 | if (popup != null) ▸ try ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.sInstanceId | Filter["INSTANCE_ID"] | 속성 sInstanceId 설정 |  |  |  |
| AC-d4c1e612 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3493 | if (popup != null) ▸ try ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa87f81d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3508 | if (popup != null) ▸ try ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return amend.dsValidationReturn; |  | 처리 중단/반환 |  |  |  |
| AC-7d4ca5a4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3524 | if (popup != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-698e4af2 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3527 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.cbo_fpplanid_changed

진입점: this.Load / cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08027054 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4460 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-5da52f2c | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4462 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1f45cbf4 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4463 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-21e9318c | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4464 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-db8f0466 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4465 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-8274c907 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4466 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9f4731c2 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4469 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2918ae9d | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4505 | if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-584b2178 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4507 | if (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-46ea4117 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4508 | if (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-51bce688 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4511 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-7551603b | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4512 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-64583d3d | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4513 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-baa0a8ad | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4514 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-7a68b1c9 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4515 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-400cbf2d | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4520 | else of (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-c3974ff6 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4521 | else of (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-db1bbbd6 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4526 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-865568a0 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4527 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0b08049f | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4528 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-8a6ce1b7 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4529 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-23770293 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4530 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00601_PlanAmend_Line_Pack.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10af26d1 | this.Load | FP00601_PlanAmend_Line_Pack.cs:442 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-0228b0ae | this.Load | FP00601_PlanAmend_Line_Pack.cs:442 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-2652ce63 | this.Load | FP00601_PlanAmend_Line_Pack.cs:444 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00601_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7ad2013 | this.Load | FP00601_PlanAmend_Line_Pack.cs:444 |  | POPUP | new FP00601_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-1f0dcf47 | this.Load | FP00601_PlanAmend_Line_Pack.cs:445 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ba74faf | this.Load | FP00601_PlanAmend_Line_Pack.cs:445 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-5f28d46b | this.Load | FP00601_PlanAmend_Line_Pack.cs:448 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-91f493eb | this.Load | FP00601_PlanAmend_Line_Pack.cs:449 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-2e208359 | this.Load | FP00601_PlanAmend_Line_Pack.cs:450 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-848ea121 | this.Load | FP00601_PlanAmend_Line_Pack.cs:451 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-c1e11a9d | this.Load | FP00601_PlanAmend_Line_Pack.cs:452 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-70cc32cb | this.Load | FP00601_PlanAmend_Line_Pack.cs:453 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00601_PlanAmend_Line_Pack.chk_Info_CheckedChanged

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-685d4fcf | this.chk_Info.CheckedChanged | FP00601_PlanAmend_Line_Pack.cs:5595 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-892d5dd7 | this.chk_Info.CheckedChanged | FP00601_PlanAmend_Line_Pack.cs:5595 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5731d96 | this.chk_Info.CheckedChanged | FP00601_PlanAmend_Line_Pack.cs:5601 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-f6a2d593 | this.chk_Info.CheckedChanged | FP00601_PlanAmend_Line_Pack.cs:5602 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00601_PlanAmend_Line_Pack.CreateEditDataGridDataSet

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (editDs.Good()) ▸ if (dt == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b88731f9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4257 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-5fc85ad8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4258 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6edb263d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4259 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-457d6328 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4260 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c05ede5c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4261 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2ea9b17 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4264 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6dd570f1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4265 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c508b1ce | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4266 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd4201b6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4267 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a9494e0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4268 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e418768b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4269 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f1b7498 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4270 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb7ecf2e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4271 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0f588cf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4272 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5306a28d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4273 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-563a3cf7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4274 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3a789ef | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4275 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcce3cd7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4276 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fdbdb419 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4277 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ba9b88a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4278 |  | DATA_OP | dt.Columns.Add | (new DataColumn("BOH_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2455d379 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4279 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2728d0c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4280 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-227120bd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4281 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SALES_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-887c5b23 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4282 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EOH_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-21daf6d2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4283 |  | DATA_OP | dt.Columns.Add | (new DataColumn("YIELD", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-24b0756d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4285 |  | DATA_OP | dt.Columns.Add | (new DataColumn("WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7ab4dd8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4286 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8e85ab4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4290 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a335c26 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4291 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1ec56d2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4293 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e36924d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4294 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a47c2b51 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4296 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e06c7e0f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4297 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-de6f1831 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4303 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-062f4fc7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:4306 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d0c7621 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1805 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-71f4b2b4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1816 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-ab8ac943 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1817 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-92837721 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1846 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-13cafbb8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1850 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-550b03da | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1854 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5224f3b1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1858 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a9b7a51 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1862 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-62c360e0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1866 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4bca6bd4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1870 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9818fdcb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1874 | if (measure["chk_BOH_2nd"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "BOH_2ND_EXPECT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c04b18d5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1878 | if (measure["chk_activated"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "BOH_2ND_ACTIVATED")) | 데이터 객체 조작/조회 |  |  |  |
| AC-deb2892d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1882 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-023c34f6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1889 | if (measure["chk_total_2"].Value == "true") ▸ if (measure["chk_off"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "OFF")) | 데이터 객체 조작/조회 |  |  |  |
| AC-19934161 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1891 | if (measure["chk_total_2"].Value == "true") ▸ if (measure["chk_setup"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SETUP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-85b2bc4e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1893 | if (measure["chk_total_2"].Value == "true") ▸ if (measure["chk_capa"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "CAPA")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e17f5307 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1896 | if (measure["chk_total_2"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-109e0b20 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1898 | if (measure["chk_total_2"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-45c9e83c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1900 | if (measure["chk_total_2"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f89c70d9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1902 | if (measure["chk_total_2"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-92b7d55b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1904 | if (measure["chk_total_2"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1be11dfd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1906 | if (measure["chk_total_2"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e8f9495 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1908 | if (measure["chk_total_2"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0339656c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1915 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_memo_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1e54405 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1918 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_off"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "OFF")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b01fa663 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1920 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_setup"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SETUP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea8e1a40 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1922 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_capa"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "CAPA")) | 데이터 객체 조작/조회 |  |  |  |
| AC-70cdce7f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1925 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-09e12843 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1927 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4832c18e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1929 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c069ee02 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1931 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-123acbb0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1933 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-106127d5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1935 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f215d17 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1937 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2812cf9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1941 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f3da2d0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1945 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe83cb53 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1949 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a8e55f4f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1952 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-021cafb6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1954 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e389f3e | this.Load | FP00601_PlanAmend_Line_Pack.cs:400 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-054d1a0b | this.Load | FP00601_PlanAmend_Line_Pack.cs:401 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-b3cea5c0 | this.Load | FP00601_PlanAmend_Line_Pack.cs:402 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00601_PlanAmend_Line_Pack.dCalendar_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95c8ea5c | dCalendar_planrange.ValueChanged | FP00601_PlanAmend_Line_Pack.cs:4610 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fed90b6 | dCalendar_planrange.ValueChanged | FP00601_PlanAmend_Line_Pack.cs:4617 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-2963ec5e | dCalendar_planrange.ValueChanged | FP00601_PlanAmend_Line_Pack.cs:4618 | if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edda3bb8 | DeleteButton | FP00601_PlanAmend_Line_Pack.cs:975 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00601_PlanAmend_Line_Pack.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c13aab97 | Dispose | FP00601_PlanAmend_Line_Pack.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00601_PlanAmend_Line_Pack.dwCheck

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f10f34b1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:5626 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["DW_TABLE"] | "HIS_AMEND_PLAN_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-56c6ddc9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:5629 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_dwSubmit_check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-eb6dc0c2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:5633 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsTmp.Tables[0].Rows[0]["IS_SUBMIT"].ToString() == "Y") | STATE | txtReleaseAlert.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-55bce3f6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:5637 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (dsTmp.Tables[0].Rows[0]["IS_SUBMIT"].ToString() == "Y") | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-ce02d721 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:5642 | else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00601_PlanAmend_Line_Pack.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40ba6bdb | EditButton | FP00601_PlanAmend_Line_Pack.cs:983 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-82dc8852 | EditButton | FP00601_PlanAmend_Line_Pack.cs:985 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00601_PlanAmend_Line_Pack.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59c9bae5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00601_PlanAmend_Line_Pack.cs:4876 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-edb14afb | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00601_PlanAmend_Line_Pack.cs:4877 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-da2c3f5a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00601_PlanAmend_Line_Pack.cs:4878 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-c738197a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00601_PlanAmend_Line_Pack.cs:4880 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5c7d7d9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00601_PlanAmend_Line_Pack.cs:4899 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-46f84097 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00601_PlanAmend_Line_Pack.cs:4900 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec52b7cf | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4950 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca93b80e | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4951 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f578c5c | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4952 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-352782df | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4954 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ad9fd82 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4971 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-6e991e0e | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4972 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf0474f6 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:4977 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.EditByFunc

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA" && row_to_test["ZERO_Y…) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].SafeString() == "M")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4820948 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … | FP00601_PlanAmend_Line_Pack.cs:4910 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a31b6575 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … | FP00601_PlanAmend_Line_Pack.cs:4912 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f9ba9a7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … | FP00601_PlanAmend_Line_Pack.cs:4913 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-cbe0f038 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … | FP00601_PlanAmend_Line_Pack.cs:4915 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-273331e0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … | FP00601_PlanAmend_Line_Pack.cs:4934 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e36c056 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … | FP00601_PlanAmend_Line_Pack.cs:4940 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1ba81fa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … | FP00601_PlanAmend_Line_Pack.cs:4942 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.Excel_Export

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95d7d9d0 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2059 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00601_PlanAmend_Line_Pack.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4024c4b8 | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2019 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-94f531ca | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2020 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-7bf4a36b | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2022 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7c89d58c | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2026 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-c70ef0ba | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2027 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-e61d22aa | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2028 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-cc885462 | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2031 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-85ed309b | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2032 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-d2f77dd7 | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2033 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-a97bd4ad | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2035 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-3f6177b6 | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2036 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-dd074ac6 | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2043 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-499cf566 | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2047 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-ddb32f91 | ExcelButton | FP00601_PlanAmend_Line_Pack.cs:2051 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_PlanAmend_Line_Pack.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e13ed1e | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2436 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-6b4c99e7 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2440 | try | FLAG | dsYieldChild | AmendService.FindYieldInfoChild(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-96f68d29 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2440 | try | CALL_EXT | AmendService.FindYieldInfoChild | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b900777 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2442 | try | FLAG | dtOcv2Lt | Data_FP.CallGeneralProcedure2(("PR_UI_FP00601_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-05dd7c39 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2442 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00601_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "OCV2_LT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a1ec941a | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2444 | try | STATE_RESET | stopwatch.Reset | () | 저장/작업 상태 초기화 |  |  |  |
| AC-72a15a7f | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2448 | try | CALL_EXT | stopwatch.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c964ef7c | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2450 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-934e7a0b | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2453 | try | CALL_EXT | stopwatch.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dcf4cbf5 | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2457 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-d343af8a | popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_… 외 8 | FP00601_PlanAmend_Line_Pack.cs:2461 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00601_PlanAmend_Line_Pack.FindTotalColorStart

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnExcelImport.C…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-540e55cb | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:755 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60abf21d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2405 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ETC", Filter, CurrentUser, p_sys_type, "TOTAL_VALUE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-035a3bb9 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2406 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-ab8c6523 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2412 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00601_PlanAmend_Line_Pack.fn_getStepValid

진입점: this.btnRelease.Click [if (sConfirmArea == "PLAN GROUP") ▸ if (sUseWoWStatus == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b253657 | this.btnRelease.Click [if (sConfirmArea == "PLAN GROUP") ▸ i… | FP00601_PlanAmend_Line_Pack.cs:5339 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_find_getStepValid", Filter["INSTANCE_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2689aa24 | this.btnRelease.Click [if (sConfirmArea == "PLAN GROUP") ▸ i… | FP00601_PlanAmend_Line_Pack.cs:5345 | if (UserInfoContext.Current.UserId == "pangaowei") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-eb4f07b3 | this.btnRelease.Click [if (sConfirmArea == "PLAN GROUP") ▸ i… | FP00601_PlanAmend_Line_Pack.cs:5355 | if (sStepValid.Equals("N")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-571ed5ed | this.btnRelease.Click [if (sConfirmArea == "PLAN GROUP") ▸ i… | FP00601_PlanAmend_Line_Pack.cs:5360 |  | RETURN | return bValid; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13ce3d1b | this.Load | FP00601_PlanAmend_Line_Pack.cs:179 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_PlanAmend_Line_Pack.GetBasisTime

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fa6b19b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:262 |  | FLAG | dtPeriod | Data_FP.CallGeneralProcedure2(("PR_UI_" + "PR_AMEND_PLANAMEND" + "_" + "findBasisTime").To… | 화면 필드/플래그 변경 |  |  |  |
| AC-f535fc15 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:262 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_" + "PR_AMEND_PLANAMEND" + "_" + "findBasisTime").ToUpper(), Filter, CurrentUser) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00601_PlanAmend_Line_Pack.GetFilter

진입점: this.Load [if (dtPlanId.Good())] / cbo_plan_group.SelectedIndexChanged [if (dtPlanId.Good())] / sCalendar_planday.DateTimeChanged [if (dtPlanId.Good())] / cbo_fpplanid.SelectedIndexChanged [if (dtPlanId.Good())] / popSql.OnSql [if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK") ▸ try] / this.cbo_fpplanid.DropDown [if (dtPlanId.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnDppWppCopyDwSubmit.Click […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49ff9055 | this.Load [if (dtPlanId.Good())] 외 14 | FP00601_PlanAmend_Line_Pack.cs:2137 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.GetFpPlanId

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged / this.cbo_fpplanid.DropDown / this.btnCreatePlan.Click / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a05db9bb | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2216 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00601_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-b7ed0bd8 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2216 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00601_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d3073ea7 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2217 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-142e1d39 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2221 | if (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-952a182f | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2222 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9878a394 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2223 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[0]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-432d12d7 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2224 | if (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | dtPlanId.Rows[0]["UI_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a370e502 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2234 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-3295d861 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2235 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-a25872a9 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2236 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-49a714a5 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2237 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-5ba3c920 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2238 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-ebb61bb7 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2241 | if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-26f3a010 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2243 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_FROM"] | dtPlanId.Rows[0]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f8b97a79 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2244 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_TO"] | dtPlanId.Rows[0]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bdcb5f30 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2248 | if (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-bd254150 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2249 | if (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-84a37576 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2256 | else of (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-733dfa2e | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2257 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3f09cee5 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2258 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5a5287dc | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2259 | else of (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a1795633 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2263 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-07ece23c | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2264 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-79c9a796 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2265 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c3647b53 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2266 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-8c2b7693 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2267 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-8a5afa80 | this.Load 외 5 | FP00601_PlanAmend_Line_Pack.cs:2270 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtPlanId.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00601_PlanAmend_Line_Pack.GetMppWpp

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "M_OUT")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d51ad353 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1688 | if (!ds.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-12f3bc38 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1700 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-edb93bdd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1701 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b42869e9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1702 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7370e568 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1703 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-12b3354c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1704 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2e93ad77 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1705 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-81d834d1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1706 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0926993 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1707 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4182e949 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1708 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-974e5dd9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1709 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-66a60dc0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1710 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-c01ade3c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1711 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e00b1460 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1712 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba151f90 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1698 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-c42b57b5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1732 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": | DATA_OP | ret[order_MPP_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-5bb3deea | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1739 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": | DATA_OP | ret[order_WPP_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-74bd3315 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1744 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.GetPlanGroup

진입점: this.Load / SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3677c993 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2195 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2f9873c0 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2196 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-8c9823d4 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2196 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-32a381d7 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2198 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-b5d01d69 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2199 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9e15f2b2 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2202 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-206b6d37 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2203 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-fa25ac51 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2203 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-e5850399 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2204 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d2e234c5 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2205 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c9758af7 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2206 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-512df0ae | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:2210 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00601_PlanAmend_Line_Pack.GetPlanner

진입점: this.Load / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4465799 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:2142 |  | FLAG | dtPlanner | Data_FP.CallGeneralProcedure2(("PR_UI_FP00601_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-7d8aa6bd | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:2142 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00601_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLANNER_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-aa5a0937 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:2143 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, mcbo_planner, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-bc57f9ff | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:2155 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row[… | CALL_EXT | mcbo_planner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-23574f5b | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:2159 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of … | CALL_EXT | mcbo_planner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc31e0a3 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:2174 | if (!dtPlanner.Good()) | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-0fddcd9f | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:2179 | else of (!dtPlanner.Good()) | VALUE_SET | chk_allLine.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.GetProdType

진입점: this.Load / mcbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ded4d007 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:2277 |  | FLAG | dtProdType | DataService.GetProdType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c66b0390 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:2277 |  | CALL_EXT | DataService.GetProdType | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6f85a57 | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:2278 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prodtype, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00601_PlanAmend_Line_Pack.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78c7c52f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2291 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00601_PlanAmend_Line_Pack.GoDrawCellColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a23c7489 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:991 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a119b017 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:993 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-818a44b9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1056 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09ffb9f7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1057 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-5f8e369f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1086 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b7bcbff | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1087 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-11026078 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1116 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e8328d8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1117 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-7f8aea61 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1132 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00601_PlanAmend_Line_Pack.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9073198 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1155 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4a6a2aef | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1165 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolnames[i] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-7ab1b23c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1166 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolidxs[i] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-a3518fd0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1202 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9887d6d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1220 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eccc7f2a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1231 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dd735ae6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1232 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8ba20b26 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1282 | else of (do_edit_mode) ▸ if (c != null) | CALL_EXT | siMain.LockRangeColor | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-62162844 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1283 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-71ab39ec | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1299 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar != null) ▸ foreach (var week_item in c… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(242, 255, 237)… | 그리드 표시 설정 |  |  |  |
| AC-daceb693 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:1316 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (month_measure != null && month_measure.On) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da00abc9 | this.Load | FP00601_PlanAmend_Line_Pack.cs:194 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e010e7aa | this.Load | FP00601_PlanAmend_Line_Pack.cs:198 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-387f33cd | this.Load | FP00601_PlanAmend_Line_Pack.cs:199 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a22eb08a | this.Load | FP00601_PlanAmend_Line_Pack.cs:203 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-22c0844b | this.Load | FP00601_PlanAmend_Line_Pack.cs:207 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-528e620b | this.Load | FP00601_PlanAmend_Line_Pack.cs:218 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-1f5ad11f | this.Load | FP00601_PlanAmend_Line_Pack.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a9dcdd0d | this.Load | FP00601_PlanAmend_Line_Pack.cs:222 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-1c228a3d | this.Load | FP00601_PlanAmend_Line_Pack.cs:224 |  | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-4408e136 | this.Load | FP00601_PlanAmend_Line_Pack.cs:225 |  | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-5a820105 | this.Load | FP00601_PlanAmend_Line_Pack.cs:226 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-ba3194a1 | this.Load | FP00601_PlanAmend_Line_Pack.cs:226 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-9734b781 | this.Load | FP00601_PlanAmend_Line_Pack.cs:234 |  | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-5d14b435 | this.Load | FP00601_PlanAmend_Line_Pack.cs:235 |  | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(27) | 속성 Value2 설정 |  |  |  |
| AC-a1f5bcac | this.Load | FP00601_PlanAmend_Line_Pack.cs:237 |  | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-66517828 | this.Load | FP00601_PlanAmend_Line_Pack.cs:238 |  | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00601_PlanAmend_Line_Pack.InitEditingBuf

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df9119ea | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:3755 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2c31a2ec | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:3757 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-3b1af61f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:3758 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d8433afb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:3759 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-90fcea60 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:3760 |  | FLAG | dlData | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fe6f5b8e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:3761 |  | FLAG | dlView | null | 화면 필드/플래그 변경 |  |  |  |

## FP00601_PlanAmend_Line_Pack.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5758c57f | this.Load | FP00601_PlanAmend_Line_Pack.cs:352 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f29fbed1 | this.Load | FP00601_PlanAmend_Line_Pack.cs:353 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-433ca632 | this.Load | FP00601_PlanAmend_Line_Pack.cs:354 |  | UI_PROP | mcbo_prodtype.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-2258bb9e | this.Load | FP00601_PlanAmend_Line_Pack.cs:355 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-1f35e9ec | this.Load | FP00601_PlanAmend_Line_Pack.cs:356 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-473a356e | this.Load | FP00601_PlanAmend_Line_Pack.cs:357 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5ba3a100 | this.Load | FP00601_PlanAmend_Line_Pack.cs:358 |  | UI_PROP | mcbo_planner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-21962c95 | this.Load | FP00601_PlanAmend_Line_Pack.cs:359 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.InitSpread

진입점: this.Load / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good(…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c6b3bfb | this.Load 외 8 | FP00601_PlanAmend_Line_Pack.cs:414 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c55275bf | this.Load 외 8 | FP00601_PlanAmend_Line_Pack.cs:415 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-62ddfd4d | this.Load 외 8 | FP00601_PlanAmend_Line_Pack.cs:417 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-61de4bb0 | this.Load 외 8 | FP00601_PlanAmend_Line_Pack.cs:421 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00601_PlanAmend_Line_Pack.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be5e93b2 | InsertButton | FP00601_PlanAmend_Line_Pack.cs:927 | if (Filter["PLAN_TYPE"] == "RELEASE" && Filter["IS_LATEST_PLAN"] != "Y") | MESSAGE | MessageHelper.GMessageBox | ("This Plan ID cannot be entered.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-21562e56 | InsertButton | FP00601_PlanAmend_Line_Pack.cs:928 | if (Filter["PLAN_TYPE"] == "RELEASE" && Filter["IS_LATEST_PLAN"] != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77f71fc9 | InsertButton | FP00601_PlanAmend_Line_Pack.cs:931 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0845f7b3 | InsertButton | FP00601_PlanAmend_Line_Pack.cs:939 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | MESSAGE | MessageBox.Show | ("Can not be selected [Total] Row.") | 메시지 표시 |  |  |  |
| AC-6f5e17d1 | InsertButton | FP00601_PlanAmend_Line_Pack.cs:940 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0080a1a2 | InsertButton | FP00601_PlanAmend_Line_Pack.cs:944 | if (row != null) | POPUP | new FP00601_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-2e72ad0b | InsertButton | FP00601_PlanAmend_Line_Pack.cs:945 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-67f78c12 | InsertButton | FP00601_PlanAmend_Line_Pack.cs:945 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c35e74de | InsertButton | FP00601_PlanAmend_Line_Pack.cs:946 | if (row != null) | UI_PROP | popup.DateMap | dateMap.Tables[0].Copy() | 속성 DateMap 설정 |  |  |  |
| AC-0c9d50ae | InsertButton | FP00601_PlanAmend_Line_Pack.cs:946 | if (row != null) | DATA_OP | dateMap.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-789a07e5 | InsertButton | FP00601_PlanAmend_Line_Pack.cs:949 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8eaa235e | InsertButton | FP00601_PlanAmend_Line_Pack.cs:950 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a562db0f | InsertButton | FP00601_PlanAmend_Line_Pack.cs:951 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6175c69d | InsertButton | FP00601_PlanAmend_Line_Pack.cs:953 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c9679e07 | InsertButton | FP00601_PlanAmend_Line_Pack.cs:954 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-59e5d1e9 | InsertButton | FP00601_PlanAmend_Line_Pack.cs:967 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00601_PlanAmend_Line_Pack.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f172592f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:2102 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00601_PlanAmend_Line_Pack.MakeMemoBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-629d0186 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:701 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-c18ec92a | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:705 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.mcbo_planner_changed

진입점: this.Load / mcbo_planner.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bc0bf1e | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4425 | if (!dtPlanner.Good()) | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-e939100f | this.Load 외 1 | FP00601_PlanAmend_Line_Pack.cs:4427 | else of (!dtPlanner.Good()) | VALUE_SET | chk_allLine.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28e27d01 | memo_menu.Click | FP00601_PlanAmend_Line_Pack.cs:3657 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e591e79 | memo_menu.Click | FP00601_PlanAmend_Line_Pack.cs:3660 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc106f6c | memo_menu.Click | FP00601_PlanAmend_Line_Pack.cs:3664 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00601_PlanAmend_Line_Pack.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31e1e5c4 | bucke_menu.Click | FP00601_PlanAmend_Line_Pack.cs:3538 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e3f492d | bucke_menu.Click | FP00601_PlanAmend_Line_Pack.cs:3541 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f604edc | bucke_menu.Click | FP00601_PlanAmend_Line_Pack.cs:3554 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e4e77bea | bucke_menu.Click | FP00601_PlanAmend_Line_Pack.cs:3587 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00601_PlanAmend_Line_Pack.onZeroMaterialMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-016c6159 | bucke_menu.Click | FP00601_PlanAmend_Line_Pack.cs:3596 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80a6f113 | bucke_menu.Click | FP00601_PlanAmend_Line_Pack.cs:3599 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86507337 | bucke_menu.Click | FP00601_PlanAmend_Line_Pack.cs:3606 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4716c14b | bucke_menu.Click | FP00601_PlanAmend_Line_Pack.cs:3647 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00601_PlanAmend_Line_Pack.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1abf2f7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5879 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-75977459 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5879 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7732801f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5881 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-4767247e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5882 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-e99bb0ca | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5882 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-de999889 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5883 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-3e1ae899 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5884 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e5a2bcc2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5885 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-abf244a8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5889 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-49aa355f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5891 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b84b14d1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5896 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00601_PlanAmend_Line_Pack.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e8fd067 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5840 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-78e3568e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5841 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-1d680723 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5842 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-b960d09c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5842 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-208493f9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5843 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-6a1f08e6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5844 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8bdbef33 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5845 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-36454bff | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5849 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-99d88508 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5851 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_PlanAmend_Line_Pack.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e510e3c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5857 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-bbe78dcd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5858 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-4a1464b1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5859 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-351c40a8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5859 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e5e430a1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5860 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-7d0c7aba | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5861 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9b0cee7e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5862 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-70133086 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5866 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7c89d32d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00601_PlanAmend_Line_Pack.cs:5868 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_PlanAmend_Line_Pack.planday_changed

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc81b6a5 | this.Load 외 2 | FP00601_PlanAmend_Line_Pack.cs:4571 |  | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00601_PlanAmend_Line_Pack.Query

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.spdMain.CellDoubleCli…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1579bab | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:609 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-ce0ce8f2 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:609 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-91f56e3c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:610 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-92e42444 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:615 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-480e8448 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:638 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-bea4577e | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:644 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-a06e3c08 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:644 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2f3dbcf9 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:645 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-727e13a6 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:645 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c69f304c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:648 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c944a086 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:655 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-70dcf77d | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:660 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2b05e93 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:661 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ab978838 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 11 | FP00601_PlanAmend_Line_Pack.cs:663 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00601_PlanAmend_Line_Pack.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c65f1eac | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:460 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-e358abcc | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:461 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-669ffd7c | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:462 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-f1c8912d | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:463 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-c0c1fbc8 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:477 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "_QTY") | ⚠ 의미 확인 필요 |  |  |  |
| AC-315f1114 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:480 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-0fc9282b | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:481 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fbed5b8 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:482 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca6cf51f | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:483 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94a4e59c | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:486 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15a2f514 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:487 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-046ed4b7 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:489 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-78eaf555 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:491 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55eb1723 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:492 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c1c1767 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:495 | if (monthInfo != null) | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2a78195 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:531 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-aa25e89a | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:550 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd554f36 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:554 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-4fe0e5d5 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:556 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-984cb191 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:560 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-23a69c12 | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:575 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-526e927f | this.Load [try ▸ else of (monthInfo == null)] 외 11 | FP00601_PlanAmend_Line_Pack.cs:590 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.RefreshHeaderOnly

진입점: this.Load [try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5a0661d | this.Load [try] 외 9 | FP00601_PlanAmend_Line_Pack.cs:722 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-4e96b47a | this.Load [try] 외 9 | FP00601_PlanAmend_Line_Pack.cs:723 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-e63837ef | this.Load [try] 외 9 | FP00601_PlanAmend_Line_Pack.cs:724 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c8e2b1f | this.Load [try] 외 9 | FP00601_PlanAmend_Line_Pack.cs:725 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6cbf40a7 | this.Load [try] 외 9 | FP00601_PlanAmend_Line_Pack.cs:726 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00601_PlanAmend_Line_Pack.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d570d877 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:2002 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-4a6ad844 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:2004 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-f4911f9f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00601_PlanAmend_Line_Pack.cs:2010 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00601_PlanAmend_Line_Pack.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f00a27e | popSql.OnSql | FP00601_PlanAmend_Line_Pack.cs:2388 | if (programID == "PR_UI_FP00601_PLAN_AMEND_BY_LINE_PACK") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-bae041eb | popSql.OnSql | FP00601_PlanAmend_Line_Pack.cs:2390 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ea74f9f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1341 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f65faa99 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1364 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-64788da9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1365 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b1ef0621 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1371 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-47ee7db0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1374 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "_QTY") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5be834d4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1380 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-7f350735 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1381 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-23b750c9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1382 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5ee4744a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1401 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-520cfd29 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1410 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-16c46a81 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1411 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c9c8e60b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1412 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b52cb6f5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1414 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e616e67 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1415 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4d5c6fc7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1416 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2b87126 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1417 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b4500415 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1418 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2ee9bfa | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1419 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0680b6d1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1420 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f6e36a0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1421 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e120646 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1422 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-de98dc2c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1423 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c6217b6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1424 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-f33cfcba | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1425 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-57556c19 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1426 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-71d3be18 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1427 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-30aec10f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1428 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-558a71f5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1408 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("FP_PL… |  | 처리 중단/반환 |  |  |  |
| AC-eb264d12 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1469 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["WPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-c7381448 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1503 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["MPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-3995d929 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1521 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-833d202c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1526 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-eabb0207 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1527 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-4b71f85f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1528 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-f54255a0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1540 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43b8948f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1544 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3688012b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1546 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce0b7d9e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1547 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd4d3093 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1548 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ccb3fe3e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1549 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b7e0bf70 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1551 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bedac1c5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1552 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-788885ac | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1553 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OPERATION_ID"] | enum_row_from_Saving["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ad532c58 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1554 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PRODUCTION_TYPE"] | enum_row_from_Saving["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d3aca53 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1555 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MARKET"] | enum_row_from_Saving["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-840472d9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1556 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FACTORY_ID"] | enum_row_from_Saving["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1b63298a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1557 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LINE_ID"] | enum_row_from_Saving["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d9309ad7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1558 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ELECTRODE_TYPE"] | enum_row_from_Saving["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-440f7226 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1559 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LOCATION"] | enum_row_from_Saving["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-21facd47 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1560 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-dae321c9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1561 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["TOP_ITEM_ID"] | enum_row_from_Saving["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-edc8afd8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1562 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_ID"] | enum_row_from_Saving["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bdd42441 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1563 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_TYPE"] | enum_row_from_Saving["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-09116b98 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1567 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-451d3240 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1575 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["WPP_OUT_QTY"] | mpp_wpp[order_WPP_OUT][day_string] | 행/컬럼 값 대입 |  |  |  |
| AC-8b7dc20b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1580 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["WPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-ca80c9d4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1588 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MPP_OUT_QTY"] | mpp_wpp[order_MPP_OUT][day_string] | 행/컬럼 값 대입 |  |  |  |
| AC-8754cd95 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1593 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-f0b922a9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1594 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-bcb4252a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1597 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-c6bb2a8b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1598 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b8c98f4d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1600 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c030801d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1619 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-814d38fb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1623 | try ▸ if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-678d96e0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1624 | try ▸ if (checkSave.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5c845e47 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1628 | try | DATA_OP | BohSet["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d749e0bc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1629 | try | DATA_OP | BohSet["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b95d93c8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1630 | try | DATA_OP | BohSet["PLAN_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9e5ecc11 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1631 | try | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-1ef0aa7c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1638 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_MPPWPP", "saveAll_MPPWPP", objDs.DataSet) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_MPPWPP] \| FP\Common\FP0… | 엔드포인트 호출 |  |  |  |
| AC-01615c68 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1641 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (res.Good() && res.Rows[0]["RESULT"].ToString() == "SUCCESS" && res.Rows[0]["COUNT"].SafeZe… | MESSAGE | MessageBox.Show | (string.Format("{0} Data Saved", res.Rows[0]["COUNT"].SafeZeroInt())) | 메시지 표시 |  |  |  |
| AC-9443e983 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1649 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ShopType | ShopType.PACK | 속성 ShopType 설정 |  |  |  |
| AC-7c1f2b58 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1650 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-0d8f5d00 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1651 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.SaveType | SaveType.SAVE | 속성 SaveType 설정 |  |  |  |
| AC-1945f1e9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1652 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dtSaveData | objDs | 속성 dtSaveData 설정 |  |  |  |
| AC-9266e3f7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1653 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-c9c02203 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1654 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.Filter | Filter | 속성 Filter 설정 |  |  |  |
| AC-1b67fe4a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1655 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.PlanId | GetFilter("FP_PLAN_ID") | 속성 PlanId 설정 |  |  |  |
| AC-8b2a69b7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1656 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc2fb1c3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1657 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |
| AC-58ee27ea | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1663 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a500a629 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1664 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9d989702 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1668 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-54f197a0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00601_PlanAmend_Line_Pack.cs:1670 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.Save_Data_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67e3fc6f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1675 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00601_PlanAmend_Line_Pack.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fafda06 | SaveButton | FP00601_PlanAmend_Line_Pack.cs:1329 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2c477a4 | SaveButton | FP00601_PlanAmend_Line_Pack.cs:1330 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e2175dee | SaveButton | FP00601_PlanAmend_Line_Pack.cs:1332 |  | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3e6b3154 | SaveButton | FP00601_PlanAmend_Line_Pack.cs:1334 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00601_PlanAmend_Line_Pack.SetBohQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48faaa28 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1773 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-63493d60 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1774 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-89fa5879 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1779 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-3a2e1246 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1785 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bde71bb8 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1786 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1eaaf284 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1787 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0613ddd4 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1788 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-75f18e0f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1789 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-26c8193f | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1790 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1346ba3d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1791 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7cad3ab2 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1792 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8025a7af | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:1796 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00601_PlanAmend_Line_Pack.SetChangeControl

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / mcbo_planner.SelectedIndexChanged / cbo_fpplanid.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / mcbo_prodtype.SelectedIndexChanged / chk_allLine.CheckedChanged / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99085796 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:280 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-930bce0e | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:280 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-815d6a6d | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:285 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-ee94bded | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:285 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-0985fa8a | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:289 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2226c4d0 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:289 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d1405211 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:290 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f82fa582 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:296 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-e67c17fb | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:297 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-72a82b7e | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:297 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-2153156b | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:298 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9c0aa173 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:304 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, mcbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-cbe5b38b | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:305 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-681d227b | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:305 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4ff22b5e | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:306 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-113f0978 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:312 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-976a39e3 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:313 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-2a9134e1 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:313 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-db37a5e1 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:314 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-02c6c3ff | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:321 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-63299dc4 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:322 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-cb16e53b | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:322 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3c4e94a0 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:323 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ea26732b | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:329 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-e16df1ba | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:330 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-99effd64 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:330 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0d8b9646 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:331 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fadfe98b | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:337 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-6045aadf | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:343 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODTYPE_ID"] | Filter["PRODUCTION_TYPE"] = Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, … | 행/컬럼 값 대입 |  |  |  |
| AC-c9902db6 | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:343 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-86cda8ca | this.Load 외 14 | FP00601_PlanAmend_Line_Pack.cs:343 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PROD_TYPE"] | CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00601_PlanAmend_Line_Pack.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b37c98e | this.Load | FP00601_PlanAmend_Line_Pack.cs:146 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-07e9d791 | this.Load | FP00601_PlanAmend_Line_Pack.cs:148 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-52b387bc | this.Load | FP00601_PlanAmend_Line_Pack.cs:149 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9d468878 | this.Load | FP00601_PlanAmend_Line_Pack.cs:150 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a110c5a3 | this.Load | FP00601_PlanAmend_Line_Pack.cs:154 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-0a13eb72 | this.Load | FP00601_PlanAmend_Line_Pack.cs:155 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4a6543de | this.Load | FP00601_PlanAmend_Line_Pack.cs:156 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2effa6a4 | this.Load | FP00601_PlanAmend_Line_Pack.cs:158 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-c65fd367 | this.Load | FP00601_PlanAmend_Line_Pack.cs:159 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e57eaf45 | this.Load | FP00601_PlanAmend_Line_Pack.cs:161 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-00c213c0 | this.Load | FP00601_PlanAmend_Line_Pack.cs:162 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9d96de64 | this.Load | FP00601_PlanAmend_Line_Pack.cs:163 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e9aa28d1 | this.Load | FP00601_PlanAmend_Line_Pack.cs:167 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e0f25e1b | this.Load | FP00601_PlanAmend_Line_Pack.cs:168 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-eff63238 | this.Load | FP00601_PlanAmend_Line_Pack.cs:169 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.SetDirty

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA" && row_to_test["ZERO_Y…) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].SafeString() == "M")] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Clipb…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7563b082 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00601_PlanAmend_Line_Pack.cs:5615 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00601_PlanAmend_Line_Pack.SetFilter

진입점: this.Load / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_planner.SelectedIndexChanged / cbo_fpplanid.SelectedIndexChanged [if (dtPlanId.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_factory.SelectedIndexChang…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41b8b76a | this.Load 외 27 | FP00601_PlanAmend_Line_Pack.cs:2132 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00601_PlanAmend_Line_Pack.SetMemoCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-567b7ca7 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3690 | if (dsMainFiltered.Good()) | FLAG | dlData | DataLines.CreateDataLine(siMain, calendar, cRow, cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-ed3c4d8b | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3690 | if (dsMainFiltered.Good()) | CALL_EXT | DataLines.CreateDataLine | (siMain, calendar, cRow, cCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-633cdd5d | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3694 | if (dlData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-08e0e9cd | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3710 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | acell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-9f60e318 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3719 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-f3cc84f8 | (진입점 미연결) | FP00601_PlanAmend_Line_Pack.cs:3723 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.SetPlanOutCell

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA" && row_to_test["ZERO_Y…) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].SafeString() == "M") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] /…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1961b7d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3771 | if (dsMainFiltered.Good()) | FLAG | dlData | DataLines.CreateDataLine(siMain, calendar, cRow, cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-c8f5c62d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3771 | if (dsMainFiltered.Good()) | CALL_EXT | DataLines.CreateDataLine | (siMain, calendar, cRow, cCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6baa2b8a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3775 | if (dsMain.Good()) | FLAG | dlView | DataLines.CreateDataLine(dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | 화면 필드/플래그 변경 |  |  |  |
| AC-93930f4f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3775 | if (dsMain.Good()) | CALL_EXT | DataLines.CreateDataLine | (dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40a0d681 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3778 |  | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-24c1979b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3786 | try | FLAG | UOMRate | AmendService.FindCellRate( clicked_row["PLANT_ID"].ToString(), clicked_row["TOP_ITEM_ID"].… | 화면 필드/플래그 변경 |  |  |  |
| AC-8e02c01e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3786 | try | CALL_EXT | AmendService.FindCellRate | ( clicked_row["PLANT_ID"].ToString(), clicked_row["TOP_ITEM_ID"].ToString(), clicked_row["… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6cebb780 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3792 | try | FLAG | YieldRate | AmendService.FindYieldInfo( clicked_row["DIVISION_ID"].ToString(), clicked_row["SITE_ID"].… | 화면 필드/플래그 변경 |  |  |  |
| AC-fc80e3c1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3792 | try | CALL_EXT | AmendService.FindYieldInfo | ( clicked_row["DIVISION_ID"].ToString(), clicked_row["SITE_ID"].ToString(), clicked_row["P… | ⚠ 의미 확인 필요 |  |  |  |
| AC-26d1c1d3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3804 | try ▸ if (dlData != null) | UI_PROP | dlData.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-c97729b2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3805 | try ▸ if (dlData != null) | UI_PROP | dlData.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-05e00c1d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3809 | try ▸ if (dlView != null) | UI_PROP | dlView.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-c170789b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3810 | try ▸ if (dlView != null) | UI_PROP | dlView.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-157a57c6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3820 | if (dsMainFiltered.Good()) ▸ if (org_value == new_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01504674 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3846 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1f52dae | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3851 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_outqty") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0f69942 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3852 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_BOH_2nd") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6e11154 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3857 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | DATA_OP | ocvlt.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ad64687 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3858 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | DATA_OP | ocvlt.Field | ("KEEP_DAYS") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f0f97ce | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3861 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | CALL_EXT | Convert.ToInt16 | (Ocv2Lt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17c4e454 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3865 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '" + sOcv + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e930c3d4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3870 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | DATA_OP | dsMainFiltered.Tables[0].Select | ("LV3 = '" + row["LV3"].ToString() + "' AND CATEGORY_ID = 'BOH_2ND_EXPECT' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-08781217 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3877 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | GRID_SET | siMain.ActiveSheet.Cells[nRow, nColumn].Value | Convert.ToDouble(rowOcv[0][(sOcv + "_QTY")]) + delta | 그리드 속성/값 설정 |  |  |  |
| AC-4aa7fefe | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3884 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_inqty") | 데이터 객체 조작/조회 |  |  |  |
| AC-6fa8f540 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3885 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_outqty") | 데이터 객체 조작/조회 |  |  |  |
| AC-d741feda | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3886 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_BOH_2nd") | 데이터 객체 조작/조회 |  |  |  |
| AC-32a39ab8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3887 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_activated") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6b713ce | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3895 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | DATA_OP | ocvlt.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-272feabd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3896 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | DATA_OP | ocvlt.Field | ("KEEP_DAYS") | 데이터 객체 조작/조회 |  |  |  |
| AC-16e7ab69 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3899 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | CALL_EXT | Convert.ToInt16 | (Ocv2Lt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d471a63 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3903 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '" + sOcv + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd746d3e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3908 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | DATA_OP | dsMainFiltered.Tables[0].Select | ("LV3 = '" + row["LV3"].ToString() + "' AND CATEGORY_ID = 'BOH_2ND_ACTIVATED' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d10e37a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3946 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing + delta | 그리드 속성/값 설정 |  |  |  |
| AC-a05738e2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3950 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | (existing + delta) | 그리드 속성/값 설정 |  |  |  |
| AC-4d6fcc02 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3974 | if (dsMainFiltered.Good()) | LIST_BIND | dgEdit.DataSource | dt | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-b84da244 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00601_PlanAmend_Line_Pack.cs:3975 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00601_PlanAmend_Line_Pack.SetReleaseProcess

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b4bad68 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:1966 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_isCurrWeek", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] \| FP\Common\X… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0b075540 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:1975 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ if (row_Date < curr_Date) | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-3128f5e0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:1979 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ else of (row_Date < curr_Date) | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-e6531e9a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:1983 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["IS_LATEST_PLAN"] | ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-86231599 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:1984 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["CURR_DATE"] | ds_isCurrWeek.Tables[0].Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ca2964cf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:1985 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["RELEASE_VALUE"] | ds_isCurrWeek.Tables[0].Rows[0]["RELEASE_VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00601_PlanAmend_Line_Pack.SetSpreadInit

진입점: this.Load [try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-888b7ddf | this.Load [try] 외 8 | FP00601_PlanAmend_Line_Pack.cs:429 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bda752c4 | this.Load [try] 외 8 | FP00601_PlanAmend_Line_Pack.cs:430 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00601_PlanAmend_Line_Pack.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d95fc362 | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4317 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f98802b | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4318 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89bf1ba4 | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4323 | if (e.Button == MouseButtons.Right) ▸ if (!dsMainFiltered.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05587f6f | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4343 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-a135eb6b | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4344 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-09c19f68 | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4346 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4a7fadc | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4355 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-9d83cf98 | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4356 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-de7ff011 | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4358 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3eb5842 | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4364 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd76cfd1 | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4369 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-d5be8ccb | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4370 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-ff0c3d2e | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4372 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2b8fbc6 | this.spdMain.CellClick | FP00601_PlanAmend_Line_Pack.cs:4382 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00601_PlanAmend_Line_Pack.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b373a88 | this.spdMain.CellDoubleClick | FP00601_PlanAmend_Line_Pack.cs:5655 | if (e.ColumnHeader) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fba60587 | this.spdMain.CellDoubleClick | FP00601_PlanAmend_Line_Pack.cs:5691 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-7fa62a65 | this.spdMain.CellDoubleClick | FP00601_PlanAmend_Line_Pack.cs:5698 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00601_PlanAmend_Line_Pack.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c73cdbad | this.spdMain.ClipboardPasted | FP00601_PlanAmend_Line_Pack.cs:4801 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96895c52 | this.spdMain.ClipboardPasted | FP00601_PlanAmend_Line_Pack.cs:4809 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2f9173e6 | this.spdMain.ClipboardPasted | FP00601_PlanAmend_Line_Pack.cs:4810 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-93dc860a | this.spdMain.ClipboardPasted | FP00601_PlanAmend_Line_Pack.cs:4812 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00601_PlanAmend_Line_Pack.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2be4867 | this.spdMain.ClipboardPasting | FP00601_PlanAmend_Line_Pack.cs:4782 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-53f76f52 | this.spdMain.ClipboardPasting | FP00601_PlanAmend_Line_Pack.cs:4783 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-fe1cddec | this.spdMain.ClipboardPasting | FP00601_PlanAmend_Line_Pack.cs:4783 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2cd32da1 | this.spdMain.ClipboardPasting | FP00601_PlanAmend_Line_Pack.cs:4787 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-3595ce06 | this.spdMain.ClipboardPasting | FP00601_PlanAmend_Line_Pack.cs:4787 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-06e3fa8a | this.spdMain.ClipboardPasting | FP00601_PlanAmend_Line_Pack.cs:4791 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8de25ed | this.spdMain.ClipboardPasting | FP00601_PlanAmend_Line_Pack.cs:4793 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00601_PlanAmend_Line_Pack.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-532d5298 | this.spdMain.EditModeOn | FP00601_PlanAmend_Line_Pack.cs:4867 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-87d4994b | this.spdMain.EditModeOn | FP00601_PlanAmend_Line_Pack.cs:4868 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00601_PlanAmend_Line_Pack.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b02e8f34 | this.spdMain.KeyDown | FP00601_PlanAmend_Line_Pack.cs:4397 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-508a1821 | this.spdMain.KeyDown | FP00601_PlanAmend_Line_Pack.cs:4401 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5dc8f730 | this.spdMain.KeyDown | FP00601_PlanAmend_Line_Pack.cs:4402 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00601_PlanAmend_Line_Pack.SwitchMemo

진입점: memo_menu.Click [if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2720abba | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5709 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1668cc39 | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5726 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-f2d360f1 | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5751 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbdc4ccf | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5777 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-fbeaff4a | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5779 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-7e281213 | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5782 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fc0d004 | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5784 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-28a52752 | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5784 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-508c3abb | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5785 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-f3209a5b | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5787 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-843cc608 | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5789 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5c0b2934 | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5801 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1513367 | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5801 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-03511b65 | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5821 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-d6023fe7 | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5822 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-cc5dff13 | memo_menu.Click [if (day != null)] 외 1 | FP00601_PlanAmend_Line_Pack.cs:5824 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00601_PlanAmend_Line_Pack.tbNickName_BeforeOpenSearch

진입점: tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-769e6c3c | tbNickName.BeforeOpenSearch | FP00601_PlanAmend_Line_Pack.cs:4629 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17a768f2 | tbNickName.BeforeOpenSearch | FP00601_PlanAmend_Line_Pack.cs:4633 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-47a6bf52 | tbNickName.BeforeOpenSearch | FP00601_PlanAmend_Line_Pack.cs:4634 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 65) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd7f7ed9 | tbNickName.BeforeOpenSearch | FP00601_PlanAmend_Line_Pack.cs:4635 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b633f85 | tbNickName.BeforeOpenSearch | FP00601_PlanAmend_Line_Pack.cs:4636 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 50) | 데이터 객체 조작/조회 |  |  |  |
| AC-68a4c4db | tbNickName.BeforeOpenSearch | FP00601_PlanAmend_Line_Pack.cs:4637 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 120) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcedc85c | tbNickName.BeforeOpenSearch | FP00601_PlanAmend_Line_Pack.cs:4638 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 10) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b5c092a | tbNickName.BeforeOpenSearch | FP00601_PlanAmend_Line_Pack.cs:4643 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-f90d37ec | tbNickName.BeforeOpenSearch | FP00601_PlanAmend_Line_Pack.cs:4644 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP00601_PlanAmend_Line_Pack.tbNickName_OnSearchConditionChanged

진입점: tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f8342cc | tbNickName.OnSearchConditionChanged | FP00601_PlanAmend_Line_Pack.cs:4653 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "NICK_NAME_LT", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd37cb3c | tbNickName.OnSearchConditionChanged | FP00601_PlanAmend_Line_Pack.cs:4654 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a87676a9 | tbNickName.OnSearchConditionChanged | FP00601_PlanAmend_Line_Pack.cs:4660 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-bc99a87e | tbNickName.OnSearchConditionChanged | FP00601_PlanAmend_Line_Pack.cs:4663 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2888b66e | tbNickName.OnSearchConditionChanged | FP00601_PlanAmend_Line_Pack.cs:4665 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00601_PlanAmend_Line_Pack.UIFindData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK)] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cbo_fpplanid.SelectedIndex < 0)] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f9272c0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:781 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d9a85f0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:782 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a25e2571 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:785 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ff368c54 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:789 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-3c89df3d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:789 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["FP_PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-ab1d0189 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:793 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-7a55876c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:795 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-406278bf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:799 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d2afd2e5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:816 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3db913a4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:817 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-071d5e54 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:821 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-756cb1ce | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:825 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-85c4595a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:826 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-94ca1db1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:830 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7c006e6c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:842 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-764d7ec8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:844 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-dc36ac08 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:844 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5808b26f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:849 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-96dc2374 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:856 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-18ad2869 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:862 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c90a31f6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:864 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1dc5b582 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:868 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-df61e9ed | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:870 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c7979875 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:883 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b837e779 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:887 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44aa851b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:893 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-255c0ab1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:896 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b72dc9bf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:904 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a7e727df | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:909 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-afbe44a8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00601_PlanAmend_Line_Pack.cs:913 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00601_PlanAmend_Line_Pack.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0a27406 | SaveButton | FP00601_PlanAmend_Line_Pack.cs:2065 | if (Filter["PLAN_TYPE"] == "RELEASE" && Filter["IS_LATEST_PLAN"] != "Y") | MESSAGE | MessageHelper.GMessageBox | ("Current not Plan ID !!") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-34735653 | SaveButton | FP00601_PlanAmend_Line_Pack.cs:2066 | if (Filter["PLAN_TYPE"] == "RELEASE" && Filter["IS_LATEST_PLAN"] != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfaaf25c | SaveButton | FP00601_PlanAmend_Line_Pack.cs:2075 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-c29fec8b | SaveButton | FP00601_PlanAmend_Line_Pack.cs:2078 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9ff39034 | SaveButton | FP00601_PlanAmend_Line_Pack.cs:2080 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2601b0d0 | SaveButton | FP00601_PlanAmend_Line_Pack.cs:2087 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-42d00e48 | SaveButton | FP00601_PlanAmend_Line_Pack.cs:2092 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b4b3806 | .ctor | FP00601_RowExcelPopup.cs:133 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-13c8890b | .ctor | FP00601_RowExcelPopup.cs:136 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-ee9e651a | .ctor | FP00601_RowExcelPopup.cs:137 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00601_RowExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a236c8bc | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:212 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-35a868fc | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:213 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e825796e | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:214 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-153f35a0 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:215 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-09de6531 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:217 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-dabf0c9e | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:217 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e21255fd | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:218 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-203eb82f | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:218 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-94c889a3 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:219 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-95623f1a | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:219 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-84023411 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:220 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-ac224a09 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:220 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-54f860ff | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:229 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-f185a17b | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:230 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-fdccebb8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:231 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-21dbedd3 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00601_RowExcelPopup.cs:232 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP00601_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9985024 | this.btnClose.Click | FP00601_RowExcelPopup.cs:815 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ac6ed58 | this.btnDownload.Click | FP00601_RowExcelPopup.cs:797 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-24dba47c | this.btnDownload.Click | FP00601_RowExcelPopup.cs:798 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00601_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4647645 | this.btnFind.Click | FP00601_RowExcelPopup.cs:788 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e363a711 | this.btnFind.Click | FP00601_RowExcelPopup.cs:789 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00601_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b5dcfec | this.Load | FP00601_RowExcelPopup.cs:260 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2cb56307 | this.Load | FP00601_RowExcelPopup.cs:261 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4814ce44 | this.Load | FP00601_RowExcelPopup.cs:262 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00601_RowExcelPopup.dateRange_ValueChanged

진입점: this.dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c7e0f65 | this.dateRange.ValueChanged | FP00601_RowExcelPopup.cs:820 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-237bb5ff | this.dateRange.ValueChanged | FP00601_RowExcelPopup.cs:821 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00601_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-260a1295 | (진입점 미연결) | FP00601_RowExcelPopup.cs:751 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d94ab799 | (진입점 미연결) | FP00601_RowExcelPopup.cs:751 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00601_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f04ee68 | this.Load | FP00601_RowExcelPopup.cs:255 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00601_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-037338c1 | Dispose | FP00601_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00601_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc47694b | (진입점 미연결) | FP00601_RowExcelPopup.cs:716 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00601_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5090d7b | FindButton | FP00601_RowExcelPopup.cs:302 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7505aef7 | FindButton | FP00601_RowExcelPopup.cs:303 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-321265fe | FindButton | FP00601_RowExcelPopup.cs:305 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00601_RowExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9a29956 | this.Load 외 2 | FP00601_RowExcelPopup.cs:344 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8216abd | this.Load 외 2 | FP00601_RowExcelPopup.cs:345 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-e2a20daa | this.Load 외 2 | FP00601_RowExcelPopup.cs:345 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cfc3a591 | this.Load 외 2 | FP00601_RowExcelPopup.cs:349 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-780d6513 | this.Load 외 2 | FP00601_RowExcelPopup.cs:350 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b04545f4 | this.Load 외 2 | FP00601_RowExcelPopup.cs:352 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2e10d7bd | this.Load 외 2 | FP00601_RowExcelPopup.cs:353 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7973691a | this.Load 외 2 | FP00601_RowExcelPopup.cs:354 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-338f0383 | this.Load 외 2 | FP00601_RowExcelPopup.cs:355 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5509e3cf | this.Load 외 2 | FP00601_RowExcelPopup.cs:356 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1467273f | this.Load 외 2 | FP00601_RowExcelPopup.cs:357 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f6ca9036 | this.Load 외 2 | FP00601_RowExcelPopup.cs:364 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-469d8131 | this.Load 외 2 | FP00601_RowExcelPopup.cs:369 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-e297a3c6 | this.Load 외 2 | FP00601_RowExcelPopup.cs:371 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-a13cc88a | this.Load 외 2 | FP00601_RowExcelPopup.cs:372 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-15832650 | this.Load 외 2 | FP00601_RowExcelPopup.cs:373 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-e7173f96 | this.Load 외 2 | FP00601_RowExcelPopup.cs:375 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2b85a09 | this.Load 외 2 | FP00601_RowExcelPopup.cs:377 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e82624c6 | this.Load 외 2 | FP00601_RowExcelPopup.cs:378 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = true; //if (init) //{ // //DictColumn = siMain.… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9eae7005 | this.Load 외 2 | FP00601_RowExcelPopup.cs:399 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-192fb91b | this.Load 외 2 | FP00601_RowExcelPopup.cs:399 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK) | 그리드 재구성/초기화 |  |  |  |
| AC-728ffafa | this.Load 외 2 | FP00601_RowExcelPopup.cs:405 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-17e5a70c | this.Load 외 2 | FP00601_RowExcelPopup.cs:406 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-b9f21488 | this.Load 외 2 | FP00601_RowExcelPopup.cs:407 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-397917d2 | this.Load 외 2 | FP00601_RowExcelPopup.cs:411 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-52369084 | this.Load 외 2 | FP00601_RowExcelPopup.cs:414 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-07a96809 | this.Load 외 2 | FP00601_RowExcelPopup.cs:415 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f6a01f7e | this.Load 외 2 | FP00601_RowExcelPopup.cs:424 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6ec46c2 | this.Load 외 2 | FP00601_RowExcelPopup.cs:427 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-19802c0d | this.Load 외 2 | FP00601_RowExcelPopup.cs:428 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0f16753a | this.Load 외 2 | FP00601_RowExcelPopup.cs:429 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b62a7c35 | this.Load 외 2 | FP00601_RowExcelPopup.cs:430 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e5b9c307 | this.Load 외 2 | FP00601_RowExcelPopup.cs:431 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7626f25a | this.Load 외 2 | FP00601_RowExcelPopup.cs:432 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00601_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0f1df75 | this.Load | FP00601_RowExcelPopup.cs:145 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-28862f30 | this.Load | FP00601_RowExcelPopup.cs:147 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00601_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7844971 | (진입점 미연결) | FP00601_RowExcelPopup.cs:690 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-288108e2 | (진입점 미연결) | FP00601_RowExcelPopup.cs:691 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-540bc443 | (진입점 미연결) | FP00601_RowExcelPopup.cs:692 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-5697d7bb | (진입점 미연결) | FP00601_RowExcelPopup.cs:693 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-3a66e817 | (진입점 미연결) | FP00601_RowExcelPopup.cs:694 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-607999ce | (진입점 미연결) | FP00601_RowExcelPopup.cs:695 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-26ee6805 | (진입점 미연결) | FP00601_RowExcelPopup.cs:696 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cddc45ee | (진입점 미연결) | FP00601_RowExcelPopup.cs:698 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-cf2b62be | (진입점 미연결) | FP00601_RowExcelPopup.cs:699 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-f0674894 | (진입점 미연결) | FP00601_RowExcelPopup.cs:703 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-e79cb702 | (진입점 미연결) | FP00601_RowExcelPopup.cs:704 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00601_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18034a8b | this.Load | FP00601_RowExcelPopup.cs:190 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-a1f0f029 | this.Load | FP00601_RowExcelPopup.cs:191 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-e725aff5 | this.Load | FP00601_RowExcelPopup.cs:195 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-d844ec86 | this.Load | FP00601_RowExcelPopup.cs:196 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-c3b4f274 | this.Load | FP00601_RowExcelPopup.cs:199 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-38e9b7f1 | this.Load | FP00601_RowExcelPopup.cs:200 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-539c8a41 | this.Load | FP00601_RowExcelPopup.cs:202 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00601_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a7f1ab6 | this.Load | FP00601_RowExcelPopup.cs:272 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-588eda0c | this.Load | FP00601_RowExcelPopup.cs:273 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00601_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c81a47b | (진입점 미연결) | FP00601_RowExcelPopup.cs:293 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00601_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df452aa4 | this.btnUpload.Click | FP00601_RowExcelPopup.cs:724 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-dcea7be0 | this.btnUpload.Click | FP00601_RowExcelPopup.cs:724 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4d27365 | this.btnUpload.Click | FP00601_RowExcelPopup.cs:726 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1b8ce429 | this.btnUpload.Click | FP00601_RowExcelPopup.cs:727 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d1aa2861 | this.btnUpload.Click | FP00601_RowExcelPopup.cs:728 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6a48f92 | this.btnUpload.Click | FP00601_RowExcelPopup.cs:730 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fa989592 | this.btnUpload.Click | FP00601_RowExcelPopup.cs:732 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8cd3ed5f | this.btnUpload.Click | FP00601_RowExcelPopup.cs:733 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-9b41f618 | this.btnUpload.Click | FP00601_RowExcelPopup.cs:733 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-07e75324 | this.btnUpload.Click | FP00601_RowExcelPopup.cs:740 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ba0f2ce1 | this.btnUpload.Click | FP00601_RowExcelPopup.cs:741 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-260d1eea | this.btnUpload.Click | FP00601_RowExcelPopup.cs:743 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00601_RowExcelPopup.rdoMpp_CheckedChanged

진입점: this.rdoWpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3857c38a | this.rdoWpp.CheckedChanged | FP00601_RowExcelPopup.cs:827 | if (rdoMpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-c5ac03fb | this.rdoWpp.CheckedChanged | FP00601_RowExcelPopup.cs:829 | else of (rdoMpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00601_RowExcelPopup.rdoWpp_CheckedChanged

진입점: this.rdoMpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f66fc680 | this.rdoMpp.CheckedChanged | FP00601_RowExcelPopup.cs:836 | if (rdoWpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-d8f27c28 | this.rdoMpp.CheckedChanged | FP00601_RowExcelPopup.cs:838 | else of (rdoWpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00601_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28cd2a0a | this.btnSave.Click | FP00601_RowExcelPopup.cs:444 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-79a705dd | this.btnSave.Click | FP00601_RowExcelPopup.cs:445 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-167a13c3 | this.btnSave.Click | FP00601_RowExcelPopup.cs:449 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-54825a02 | this.btnSave.Click | FP00601_RowExcelPopup.cs:450 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6df337d8 | this.btnSave.Click | FP00601_RowExcelPopup.cs:454 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-8977108b | this.btnSave.Click | FP00601_RowExcelPopup.cs:454 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-00a208ee | this.btnSave.Click | FP00601_RowExcelPopup.cs:459 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fbd6fd9d | this.btnSave.Click | FP00601_RowExcelPopup.cs:460 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-71c3e01c | this.btnSave.Click | FP00601_RowExcelPopup.cs:461 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9ef2480e | this.btnSave.Click | FP00601_RowExcelPopup.cs:462 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6e0e98ec | this.btnSave.Click | FP00601_RowExcelPopup.cs:463 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-70440e5e | this.btnSave.Click | FP00601_RowExcelPopup.cs:464 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-35e86c79 | this.btnSave.Click | FP00601_RowExcelPopup.cs:472 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-88244d31 | this.btnSave.Click | FP00601_RowExcelPopup.cs:475 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-5cd47226 | this.btnSave.Click | FP00601_RowExcelPopup.cs:477 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ecc4a8c | this.btnSave.Click | FP00601_RowExcelPopup.cs:480 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-75ff0aa0 | this.btnSave.Click | FP00601_RowExcelPopup.cs:485 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-a4b2f21c | this.btnSave.Click | FP00601_RowExcelPopup.cs:486 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-e68a3d7a | this.btnSave.Click | FP00601_RowExcelPopup.cs:493 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-9759a2ba | this.btnSave.Click | FP00601_RowExcelPopup.cs:494 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-80500507 | this.btnSave.Click | FP00601_RowExcelPopup.cs:495 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5495db4b | this.btnSave.Click | FP00601_RowExcelPopup.cs:496 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6e7ef2bb | this.btnSave.Click | FP00601_RowExcelPopup.cs:497 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d7e5dea7 | this.btnSave.Click | FP00601_RowExcelPopup.cs:498 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d583fec1 | this.btnSave.Click | FP00601_RowExcelPopup.cs:499 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-14883048 | this.btnSave.Click | FP00601_RowExcelPopup.cs:500 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d45abe2 | this.btnSave.Click | FP00601_RowExcelPopup.cs:507 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-785d49ff | this.btnSave.Click | FP00601_RowExcelPopup.cs:541 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-452dba4e | this.btnSave.Click | FP00601_RowExcelPopup.cs:543 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-88a79308 | this.btnSave.Click | FP00601_RowExcelPopup.cs:546 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | dr["NEW_SEQ"] | validation.Tables[0].Rows[0]["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-59d25681 | this.btnSave.Click | FP00601_RowExcelPopup.cs:550 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b58e22f8 | this.btnSave.Click | FP00601_RowExcelPopup.cs:552 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c084e0fc | this.btnSave.Click | FP00601_RowExcelPopup.cs:555 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e793c5ba | this.btnSave.Click | FP00601_RowExcelPopup.cs:559 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e1f67f43 | this.btnSave.Click | FP00601_RowExcelPopup.cs:561 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-17ba1d39 | this.btnSave.Click | FP00601_RowExcelPopup.cs:564 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-697547a2 | this.btnSave.Click | FP00601_RowExcelPopup.cs:568 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc24c780 | this.btnSave.Click | FP00601_RowExcelPopup.cs:580 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-aad49cdc | this.btnSave.Click | FP00601_RowExcelPopup.cs:582 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-49d0018b | this.btnSave.Click | FP00601_RowExcelPopup.cs:584 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-8251d957 | this.btnSave.Click | FP00601_RowExcelPopup.cs:588 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-1bc157eb | this.btnSave.Click | FP00601_RowExcelPopup.cs:603 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-d66a1f35 | this.btnSave.Click | FP00601_RowExcelPopup.cs:604 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-509eb601 | this.btnSave.Click | FP00601_RowExcelPopup.cs:608 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("{0} data Saved", expect_count)) | 메시지 표시 |  |  |  |
| AC-9886ff66 | this.btnSave.Click | FP00601_RowExcelPopup.cs:609 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-72cffb09 | this.btnSave.Click | FP00601_RowExcelPopup.cs:614 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-c2bbc13b | this.btnSave.Click | FP00601_RowExcelPopup.cs:653 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-50ef1939 | this.btnSave.Click | FP00601_RowExcelPopup.cs:655 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44ad0709 | this.btnSave.Click | FP00601_RowExcelPopup.cs:656 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1946240b | this.btnSave.Click | FP00601_RowExcelPopup.cs:667 | if (DoSaveData != null) ▸ catch () | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6b2e1bd0 | this.btnSave.Click | FP00601_RowExcelPopup.cs:672 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9e755dd7 | this.btnSave.Click | FP00601_RowExcelPopup.cs:673 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1e2e71f6 | this.btnSave.Click | FP00601_RowExcelPopup.cs:674 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ce9c24b1 | this.btnSave.Click | FP00601_RowExcelPopup.cs:675 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-38306e76 | this.btnSave.Click | FP00601_RowExcelPopup.cs:676 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-961d9658 | this.btnSave.Click | FP00601_RowExcelPopup.cs:677 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00601_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ef20cfe | this.Load | FP00601_RowExcelPopup.cs:285 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74c90065 | this.Load | FP00601_RowExcelPopup.cs:286 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00601_RowExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac04ebf5 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_RowExcelPopup.cs:240 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-68e63ee7 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_RowExcelPopup.cs:241 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8a9bc311 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_RowExcelPopup.cs:242 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7dda51ba | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_RowExcelPopup.cs:246 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-28493959 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_RowExcelPopup.cs:247 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-324af6f8 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00601_RowExcelPopup.cs:248 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00602_Nlf_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cdcd170 | this.btnButtonList.UsrButtonList_Click_Detected | FP00601_Nlf_Popup.cs:269 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-86fb2fab | this.btnButtonList.UsrButtonList_Click_Detected | FP00601_Nlf_Popup.cs:272 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-eb406e65 | this.btnButtonList.UsrButtonList_Click_Detected | FP00601_Nlf_Popup.cs:273 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00602_Nlf_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8c6f646 | this.Load | FP00601_Nlf_Popup.cs:131 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ece1f565 | this.Load | FP00601_Nlf_Popup.cs:132 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-67f31561 | this.Load | FP00601_Nlf_Popup.cs:133 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00602_Nlf_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb35fcab | this.Load | FP00601_Nlf_Popup.cs:126 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00602_Nlf_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46ddb9b5 | Dispose | FP00601_Nlf_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00602_Nlf_Popup.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3805b00d | this.Load 외 2 | FP00601_Nlf_Popup.cs:197 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00602_Nlf_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a064a4e | this.Load | FP00601_Nlf_Popup.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5a342119 | this.Load | FP00601_Nlf_Popup.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-41eb3995 | this.Load | FP00601_Nlf_Popup.cs:111 |  | DATA_OP | Filter["BUCKET"] | "D" | 행/컬럼 값 대입 |  |  |  |

## FP00602_Nlf_Popup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f894199 | this.Load | FP00601_Nlf_Popup.cs:119 |  | UI_PROP | rangePlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-9da139d1 | this.Load | FP00601_Nlf_Popup.cs:120 |  | UI_PROP | rangePlanPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |

## FP00602_Nlf_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8e1c900 | this.Load | FP00601_Nlf_Popup.cs:143 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-adb25de9 | this.Load | FP00601_Nlf_Popup.cs:144 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00602_Nlf_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3df640a | (진입점 미연결) | FP00601_Nlf_Popup.cs:163 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00602_Nlf_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e45cabd4 | this.Load | FP00601_Nlf_Popup.cs:150 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d039cb8c | this.Load | FP00601_Nlf_Popup.cs:151 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-5f34e948 | this.Load | FP00601_Nlf_Popup.cs:155 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00602_Nlf_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51274a02 | this.spdMain.CellClick | FP00601_Nlf_Popup.cs:284 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-633ebf22 | this.spdMain.CellClick | FP00601_Nlf_Popup.cs:285 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b31d4257 | this.spdMain.CellClick | FP00601_Nlf_Popup.cs:288 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00602_Nlf_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-564c0572 | this.spdMain.CellDoubleClick | FP00601_Nlf_Popup.cs:294 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-910f65a1 | this.spdMain.CellDoubleClick | FP00601_Nlf_Popup.cs:295 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ed6eee5c | this.spdMain.CellDoubleClick | FP00601_Nlf_Popup.cs:298 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-1a40fe43 | this.spdMain.CellDoubleClick | FP00601_Nlf_Popup.cs:301 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0bd82cc7 | this.spdMain.CellDoubleClick | FP00601_Nlf_Popup.cs:311 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

