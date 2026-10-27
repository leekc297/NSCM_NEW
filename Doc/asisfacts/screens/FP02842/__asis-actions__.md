# AS-IS 액션 대조표 — FP02842

> 원천: `Doc/asisfacts/screens/FP02842/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2034행 · 메서드 205 · 종류 DATA_OP 727 · FLAG 210 · RETURN 200 · UI_PROP 184 · UI_MISC 91 · CALL_EXT 78 · STATE 77 · VALUE_SET 70 · MESSAGE 66 · GRID_SET 63 · POPUP 58 · COMBO_DATA 53 · ENDPOINT 49 · GRID_INIT 35 · CALL_BASE 16 · THROW 11 · GRID_STYLE 11 · LIST_REBIND 11 · GRID_LOCK 9 · FOCUS 3 · EXCEL 3 · GRID_BIND 3 · LIST_CLEAR 3 · STATE_RESET 2 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 94


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0add0bf1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5873 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-77ed6823 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5879 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-af6f4446 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5887 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-d35222d0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5888 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-bdcd4e23 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5889 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-9ff453ca | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5890 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-8f90c3e0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5892 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-b99a16b2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5893 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-a8ce79f4 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5894 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a558cec | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5895 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-58e57653 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5896 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-90a290b7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5897 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-59634578 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5898 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c57d51b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5899 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-89554ac2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5902 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-77bfaa8d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6087 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-459fc465 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6088 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-50348941 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6089 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-4cc2e985 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6090 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-1fea247a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6092 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f15b655 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6093 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-18dfb9d0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6094 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f46ff21 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6095 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-7e4856bf | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6096 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-2cfe1b76 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6097 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-0fcab319 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6098 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-66315977 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6099 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-000c2c24 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6101 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6611e50 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6006 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-410edb56 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6007 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-30153a54 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6008 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc601855 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6009 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0624bb34 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6010 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-526992de | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6013 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d7393f8 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6017 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a08dcdaf | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6018 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-67729913 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6004 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-f93b38bd | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6034 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-aecb3c19 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6037 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd0a59d6 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6040 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-be304afa | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6043 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-5dca67e8 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6046 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-7ac15bff | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6049 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-e49ccac9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6055 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-072e91da | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6057 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f4d5ffd | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5978 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14838d97 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5942 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-26b64a1f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5943 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-107cc6d3 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5944 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d977e4ee | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5945 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5eabd14a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5946 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-64a56000 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5947 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-447a1b73 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5949 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f13e735d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5950 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-16172db2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5953 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-497878ca | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5954 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5edbe869 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5955 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e50f717c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5940 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-d8128ce1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5963 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-388f7c19 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5964 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0323533 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5969 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d4bc47a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5915 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP02842_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08c012c9 | .ctor | FP02842_BucketSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-d3afd776 | .ctor | FP02842_BucketSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-d0d8aa45 | .ctor | FP02842_BucketSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-02eb7b04 | .ctor | FP02842_BucketSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP02842_BucketSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-737a0c6f | this.btnOK.Click | FP02842_BucketSetForm_Popup.cs:190 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-54e5a988 | this.btnOK.Click | FP02842_BucketSetForm_Popup.cs:190 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-92f558b4 | this.btnOK.Click | FP02842_BucketSetForm_Popup.cs:192 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-37fff44c | this.btnOK.Click | FP02842_BucketSetForm_Popup.cs:196 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-236ba947 | this.btnOK.Click | FP02842_BucketSetForm_Popup.cs:197 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-06fbfb80 | this.btnOK.Click | FP02842_BucketSetForm_Popup.cs:198 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-5bd10375 | this.btnOK.Click | FP02842_BucketSetForm_Popup.cs:199 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02842_BucketSetForm_Popup.btnSet_Click

진입점: this.btbSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2d87ab9 | this.btbSet.Click | FP02842_BucketSetForm_Popup.cs:213 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-e69d6f18 | this.btbSet.Click | FP02842_BucketSetForm_Popup.cs:213 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-0fd73024 | this.btbSet.Click | FP02842_BucketSetForm_Popup.cs:215 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-d4dc405e | this.btbSet.Click | FP02842_BucketSetForm_Popup.cs:219 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-0bbd9085 | this.btbSet.Click | FP02842_BucketSetForm_Popup.cs:220 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-929ef20f | this.btbSet.Click | FP02842_BucketSetForm_Popup.cs:222 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f86d02f2 | this.btbSet.Click | FP02842_BucketSetForm_Popup.cs:224 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-3afbc7e0 | this.btbSet.Click | FP02842_BucketSetForm_Popup.cs:226 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-f7fc847e | this.btbSet.Click | FP02842_BucketSetForm_Popup.cs:227 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02842_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a5bc98f | Dispose | FP02842_BucketSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02842_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0482d9b | this.Load | FP02842_BucketSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP02842_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee59e09a | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:147 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-a587bd37 | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:148 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3a61c04 | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:149 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-14f6c243 | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:151 |  | DATA_OP | ctrls.Add | (chk_Shift_1) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f69497f | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:152 |  | DATA_OP | ctrls.Add | (chk_Shift_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-67c457da | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:154 |  | VALUE_SET | chk_week.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-f6c9196d | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:156 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-86770cbd | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:156 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-07112a18 | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:164 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-3791d8de | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:168 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-b8014804 | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:172 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP02842_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-774b7fc6 | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-62988bc9 | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b37fd139 | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-056c8232 | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:120 |  | VALUE_SET | chk_Shift_1.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5ac9d868 | this.Load 외 1 | FP02842_BucketSetForm_Popup.cs:121 |  | VALUE_SET | chk_Shift_2.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP02842_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa72bdc5 | (진입점 미연결) | FP02842_BucketSetForm_Popup.cs:237 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-da01fcd1 | (진입점 미연결) | FP02842_BucketSetForm_Popup.cs:248 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fedcba85 | (진입점 미연결) | FP02842_BucketSetForm_Popup.cs:259 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP02842_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-befc9f7f | this.Load | FP02842_BucketSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a8f84cf5 | this.Load | FP02842_BucketSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02842_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbd7d788 | .ctor | FP02842_ExcelPopup.cs:166 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-c040bd7f | .ctor | FP02842_ExcelPopup.cs:167 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-54b93488 | .ctor | FP02842_ExcelPopup.cs:169 |  | FLAG | HeaderLineCount | 3 | 화면 필드/플래그 변경 |  |  |  |
| AC-ad58024e | .ctor | FP02842_ExcelPopup.cs:170 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |

## FP02842_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95c137ae | this.btnClose.Click | FP02842_ExcelPopup.cs:1302 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02842_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cb620b5 | this.btnDownload.Click | FP02842_ExcelPopup.cs:1259 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-8df58459 | this.btnDownload.Click | FP02842_ExcelPopup.cs:1260 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP02842_ExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58961f30 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1281 | if (bUpload) ▸ for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("Batch") != -1 && sHeadName.Length == 5) | GRID_SET | siMain.ActiveSheet.Cells[0, idx, siMain.GetMaxRowIndex(), idx].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-e8d61116 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1285 | if (bUpload) ▸ for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("Seq") != -1 && sHeadName.Length == 3) | GRID_SET | siMain.ActiveSheet.Cells[0, idx, siMain.GetMaxRowIndex(), idx].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-18c2f8db | this.btnUpload.Click | FP02842_ExcelPopup.cs:1289 | if (bUpload) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-875eb27b | this.btnUpload.Click | FP02842_ExcelPopup.cs:1290 | if (bUpload) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |

## FP02842_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc002b01 | this.Load | FP02842_ExcelPopup.cs:263 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-39617591 | this.Load | FP02842_ExcelPopup.cs:264 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4bb65b9 | this.Load | FP02842_ExcelPopup.cs:265 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02842_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8ca6180 | (진입점 미연결) | FP02842_ExcelPopup.cs:1243 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf69d651 | (진입점 미연결) | FP02842_ExcelPopup.cs:1243 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP02842_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4561483c | this.Load | FP02842_ExcelPopup.cs:258 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02842_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d980f736 | Dispose | FP02842_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02842_ExcelPopup.dtpPeriod_ValueChanged

진입점: this.dtpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f62582c5 | this.dtpPeriod.ValueChanged | FP02842_ExcelPopup.cs:1318 | if (bFirst == true) | FLAG | bFirst | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7225c422 | this.dtpPeriod.ValueChanged | FP02842_ExcelPopup.cs:1319 | if (bFirst == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c38fc035 | this.dtpPeriod.ValueChanged | FP02842_ExcelPopup.cs:1334 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51084bb8 | this.dtpPeriod.ValueChanged | FP02842_ExcelPopup.cs:1337 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | VALUE_SET | dtpPeriod.InitValue | sStartDate + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-edcd69c4 | this.dtpPeriod.ValueChanged | FP02842_ExcelPopup.cs:1338 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60a9a8e5 | this.dtpPeriod.ValueChanged | FP02842_ExcelPopup.cs:1343 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee4b1b1d | this.dtpPeriod.ValueChanged | FP02842_ExcelPopup.cs:1351 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d3b98a09 | this.dtpPeriod.ValueChanged | FP02842_ExcelPopup.cs:1353 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46380a24 | this.dtpPeriod.ValueChanged | FP02842_ExcelPopup.cs:1356 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-c0f3b87b | this.dtpPeriod.ValueChanged | FP02842_ExcelPopup.cs:1357 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |

## FP02842_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63948636 | (진입점 미연결) | FP02842_ExcelPopup.cs:1233 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP02842_ExcelPopup.Find_Data

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aff06b10 | this.Load 외 2 | FP02842_ExcelPopup.cs:337 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-28eff7aa | this.Load 외 2 | FP02842_ExcelPopup.cs:343 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6684e128 | this.Load 외 2 | FP02842_ExcelPopup.cs:345 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7c124b1 | this.Load 외 2 | FP02842_ExcelPopup.cs:350 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-790b169d | this.Load 외 2 | FP02842_ExcelPopup.cs:351 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4935cea | this.Load 외 2 | FP02842_ExcelPopup.cs:353 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-dd82224c | this.Load 외 2 | FP02842_ExcelPopup.cs:354 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-4a722a12 | this.Load 외 2 | FP02842_ExcelPopup.cs:356 |  | DATA_OP | Filter["BUCKET_FROM"] | _BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-554060fb | this.Load 외 2 | FP02842_ExcelPopup.cs:357 |  | DATA_OP | Filter["BUCKET_TO"] | _BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-392c0c53 | this.Load 외 2 | FP02842_ExcelPopup.cs:362 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-11baf12e | this.Load 외 2 | FP02842_ExcelPopup.cs:364 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-223ef8e4 | this.Load 외 2 | FP02842_ExcelPopup.cs:368 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5af44f42 | this.Load 외 2 | FP02842_ExcelPopup.cs:373 | if (OnSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4866ce7 | this.Load 외 2 | FP02842_ExcelPopup.cs:374 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-a957e314 | this.Load 외 2 | FP02842_ExcelPopup.cs:374 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-576e709a | this.Load 외 2 | FP02842_ExcelPopup.cs:379 | if (OnSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-48312d2a | this.Load 외 2 | FP02842_ExcelPopup.cs:380 | if (OnSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3e0b47f0 | this.Load 외 2 | FP02842_ExcelPopup.cs:382 | if (OnSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-831086ee | this.Load 외 2 | FP02842_ExcelPopup.cs:383 | if (OnSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-79c60277 | this.Load 외 2 | FP02842_ExcelPopup.cs:384 | if (OnSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-64ddbe84 | this.Load 외 2 | FP02842_ExcelPopup.cs:385 | if (OnSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f473bc10 | this.Load 외 2 | FP02842_ExcelPopup.cs:386 | if (OnSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-35011abb | this.Load 외 2 | FP02842_ExcelPopup.cs:387 | if (OnSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-593d12d5 | this.Load 외 2 | FP02842_ExcelPopup.cs:388 | if (OnSearchData != null) | STATE | this.dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-739587be | this.Load 외 2 | FP02842_ExcelPopup.cs:394 | if (OnSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f27da094 | this.Load 외 2 | FP02842_ExcelPopup.cs:398 | if (OnSearchData != null) ▸ try | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ce83417 | this.Load 외 2 | FP02842_ExcelPopup.cs:400 | if (OnSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0bde656f | this.Load 외 2 | FP02842_ExcelPopup.cs:402 | if (OnSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { if (Calendar == null) { Calendar = new AmendCalendar(); DataTabl… | ⚠ 의미 확인 필요 |  |  |  |
| AC-3dea171f | this.Load 외 2 | FP02842_ExcelPopup.cs:406 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-b3627bd9 | this.Load 외 2 | FP02842_ExcelPopup.cs:407 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-38676374 | this.Load 외 2 | FP02842_ExcelPopup.cs:409 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-13e227f5 | this.Load 외 2 | FP02842_ExcelPopup.cs:411 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff20f764 | this.Load 외 2 | FP02842_ExcelPopup.cs:414 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-6aacfd5a | this.Load 외 2 | FP02842_ExcelPopup.cs:415 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-85442be2 | this.Load 외 2 | FP02842_ExcelPopup.cs:416 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar == null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-a2a4a92d | this.Load 외 2 | FP02842_ExcelPopup.cs:422 | if (OnSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | SetAmendHeaderColumn_FP_Local(Calendar, 3) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d6e30b7 | this.Load 외 2 | FP02842_ExcelPopup.cs:426 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c259f47b | this.Load 외 2 | FP02842_ExcelPopup.cs:427 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c481675 | this.Load 외 2 | FP02842_ExcelPopup.cs:428 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.ColumnHeaderHeight | (2, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d0e7857 | this.Load 외 2 | FP02842_ExcelPopup.cs:441 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f483e9f1 | this.Load 외 2 | FP02842_ExcelPopup.cs:442 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-964844b5 | this.Load 외 2 | FP02842_ExcelPopup.cs:445 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-afaf40e1 | this.Load 외 2 | FP02842_ExcelPopup.cs:464 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd272ad8 | this.Load 외 2 | FP02842_ExcelPopup.cs:468 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-3db767a8 | this.Load 외 2 | FP02842_ExcelPopup.cs:473 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-7c990d75 | this.Load 외 2 | FP02842_ExcelPopup.cs:474 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.Cells[0, index, siMain.GetMaxRowIndex(), index].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-909ad8fa | this.Load 외 2 | FP02842_ExcelPopup.cs:485 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b395a3ec | this.Load 외 2 | FP02842_ExcelPopup.cs:489 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-df44763c | this.Load 외 2 | FP02842_ExcelPopup.cs:494 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ca851403 | this.Load 외 2 | FP02842_ExcelPopup.cs:495 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.Cells[0, index, siMain.GetMaxRowIndex(), index].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-9f47ed49 | this.Load 외 2 | FP02842_ExcelPopup.cs:511 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.Cells[0, index, siMain.GetMaxRowIndex(), index].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-cf90e73c | this.Load 외 2 | FP02842_ExcelPopup.cs:517 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (Calendar != null && set.Good()) ▸ foreach (var date_item in Calendar.Days) ▸ if (date != null… | GRID_SET | siMain.ActiveSheet.Cells[0, index, siMain.GetMaxRowIndex(), index].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-31c75a63 | this.Load 외 2 | FP02842_ExcelPopup.cs:525 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-15193b12 | this.Load 외 2 | FP02842_ExcelPopup.cs:534 | if (OnSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd683c00 | this.Load 외 2 | FP02842_ExcelPopup.cs:537 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a4905a7d | this.Load 외 2 | FP02842_ExcelPopup.cs:538 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-59ed8b1d | this.Load 외 2 | FP02842_ExcelPopup.cs:539 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-00aa1e83 | this.Load 외 2 | FP02842_ExcelPopup.cs:540 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-33c23b4d | this.Load 외 2 | FP02842_ExcelPopup.cs:541 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-188d6456 | this.Load 외 2 | FP02842_ExcelPopup.cs:542 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f1bdedb5 | this.Load 외 2 | FP02842_ExcelPopup.cs:543 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02842_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ef28499 | FindButton | FP02842_ExcelPopup.cs:305 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c8266bed | FindButton | FP02842_ExcelPopup.cs:306 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-29804dc8 | FindButton | FP02842_ExcelPopup.cs:308 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02842_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9067d79a | this.Load | FP02842_ExcelPopup.cs:179 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-965737fd | this.Load | FP02842_ExcelPopup.cs:181 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02842_ExcelPopup.GetDayColNameOfType_Local

진입점: this.Load [if (OnSearchData != null) ▸ try ▸ lambda ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Length)] / this.btnFind.Click [if (OnSearchData != null) ▸ try ▸ lambda ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Length)] / FindButton [if (OnSearchData != null) ▸ try ▸ lambda ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppend…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d818e46 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda ▸ foreac… 외 2 | FP02842_ExcelPopup.cs:692 |  | RETURN | return day.Value + date_append_name; |  | 처리 중단/반환 |  |  |  |

## FP02842_ExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-124c68de | (진입점 미연결) | FP02842_ExcelPopup.cs:948 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-3a166f4e | (진입점 미연결) | FP02842_ExcelPopup.cs:949 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-e9986967 | (진입점 미연결) | FP02842_ExcelPopup.cs:950 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-c9b65002 | (진입점 미연결) | FP02842_ExcelPopup.cs:951 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-069d1106 | (진입점 미연결) | FP02842_ExcelPopup.cs:952 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-24dcdd90 | (진입점 미연결) | FP02842_ExcelPopup.cs:953 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-004727ce | (진입점 미연결) | FP02842_ExcelPopup.cs:954 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3bc7e8ed | (진입점 미연결) | FP02842_ExcelPopup.cs:956 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-bf102f35 | (진입점 미연결) | FP02842_ExcelPopup.cs:957 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-ca787c83 | (진입점 미연결) | FP02842_ExcelPopup.cs:961 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-89144f1d | (진입점 미연결) | FP02842_ExcelPopup.cs:962 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP02842_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-780e6a10 | this.Load | FP02842_ExcelPopup.cs:216 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_FROM"].ToString()) < Convert.ToDecimal(thi… | DATA_OP | Filter["BUCKET_FROM"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e6e6892b | this.Load | FP02842_ExcelPopup.cs:221 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | sEndDay | 행/컬럼 값 대입 |  |  |  |
| AC-cfe235b4 | this.Load | FP02842_ExcelPopup.cs:224 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | Filter["BUCKET_FROM"] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee4216c9 | this.Load | FP02842_ExcelPopup.cs:225 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | Filter["BUCKET_TO"] | 화면 필드/플래그 변경 |  |  |  |
| AC-4c813df9 | this.Load | FP02842_ExcelPopup.cs:227 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | _BucketFromDate.ToString() + ":" + _BucketToDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f396e2db | this.Load | FP02842_ExcelPopup.cs:229 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6256e728 | this.Load | FP02842_ExcelPopup.cs:231 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-6d52f5d7 | this.Load | FP02842_ExcelPopup.cs:235 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-c7f6286a | this.Load | FP02842_ExcelPopup.cs:237 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-f6305e6f | this.Load | FP02842_ExcelPopup.cs:238 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-5594c90a | this.Load | FP02842_ExcelPopup.cs:239 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-79d06545 | this.Load | FP02842_ExcelPopup.cs:247 | for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-0098a303 | this.Load | FP02842_ExcelPopup.cs:250 |  | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-b7190d07 | this.Load | FP02842_ExcelPopup.cs:252 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |

## FP02842_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c28afc10 | this.Load | FP02842_ExcelPopup.cs:275 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1781b486 | this.Load | FP02842_ExcelPopup.cs:276 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02842_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-884d3441 | (진입점 미연결) | FP02842_ExcelPopup.cs:296 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02842_ExcelPopup.lfn_setExchangeBatch_Excel

진입점: this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ for (iRow < dtData.Rows.Count) ▸ for (iCol < nEnd) ▸ if (bIsKGCol && !string.IsNullOrEmpty(dtData.Rows[iRow][iCol + cnt].ToString()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a36d37ab | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1158 | lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-95a32bcd | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1172 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-4ac521d9 | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1179 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-37b1558f | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1180 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f281c64 | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1181 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2481a0da | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1182 | lambda | DATA_OP | each_row.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd68f348 | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1199 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe4b3fee | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1200 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d944143 | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1201 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f14d552e | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1202 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd538b53 | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1203 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fff5f4f0 | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1204 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f48a5a5 | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1204 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ceaae02 | this.btnUpload.Click [try ▸ if (dtData != null) ▸ if (dtData… | FP02842_ExcelPopup.cs:1222 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP02842_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b5ed54b | this.btnUpload.Click | FP02842_ExcelPopup.cs:999 | try | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-6ea2dccd | this.btnUpload.Click | FP02842_ExcelPopup.cs:999 | try | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1675d3ec | this.btnUpload.Click | FP02842_ExcelPopup.cs:1001 | try | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dd4f762c | this.btnUpload.Click | FP02842_ExcelPopup.cs:1002 | try | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0ef69fb5 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1004 | try | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd184f85 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1006 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c0e4191a | this.btnUpload.Click | FP02842_ExcelPopup.cs:1008 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-81dad91d | this.btnUpload.Click | FP02842_ExcelPopup.cs:1010 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile_Third | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-23096fc1 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1018 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | res.Item2 | 화면 필드/플래그 변경 |  |  |  |
| AC-a06670ac | this.btnUpload.Click | FP02842_ExcelPopup.cs:1019 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-482c64a3 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1020 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-4b037abe | this.btnUpload.Click | FP02842_ExcelPopup.cs:1021 | try ▸ if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1afd3685 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1024 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a1d96038 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1025 | try | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-1525bbd2 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1037 | try ▸ if (dtData != null) | DATA_OP | dtData.Columns.Contains | ("APPLIED_MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-638d4610 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1040 | try ▸ if (dtData != null) ▸ if (!dtData.Columns.Contains("APPLIED_MODEL")) | DATA_OP | dtData.Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3c5548d | this.btnUpload.Click | FP02842_ExcelPopup.cs:1048 | try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ foreach (DataRow row in dtData.Rows) ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a629ca26 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1049 | try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ foreach (DataRow row in dtData.Rows) ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8361708 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1050 | try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ foreach (DataRow row in dtData.Rows) ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-46f1f1a3 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1054 | try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ foreach (DataRow row in dtData.Rows) ▸ if (UomResult.Count() > 0) | DATA_OP | row["APPLIED_MODEL"] | UomResult.First()["VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a5e179cf | this.btnUpload.Click | FP02842_ExcelPopup.cs:1058 | try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ foreach (DataRow row in dtData.Rows) ▸ else of (UomResult.Count() > 0) | DATA_OP | row["APPLIED_MODEL"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-68dc79c6 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1082 | try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ if (nStart == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8274ea51 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1106 | try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ for (iRow < dtData.Rows.Count) ▸ for (iCol < nEnd) ▸ if (bIsKGCol && !string.IsNull… | GRID_SET | dtData.Rows[iRow][sColName] | "" | 그리드 속성/값 설정 |  |  |  |
| AC-0cc7dc0e | this.btnUpload.Click | FP02842_ExcelPopup.cs:1110 | try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ for (iRow < dtData.Rows.Count) ▸ for (iCol < nEnd) ▸ if (bIsKGCol && !string.IsNull… | GRID_SET | dtData.Rows[iRow][sColName] | rVal.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-f9367ff9 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1119 | try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) | GRID_BIND | siMain.Query | (dtData, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f6e04ccb | this.btnUpload.Click | FP02842_ExcelPopup.cs:1120 | try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3d4ac71e | this.btnUpload.Click | FP02842_ExcelPopup.cs:1121 | try ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-e022add2 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1130 | try ▸ if (dtData != null) | RETURN | return rtnValue; |  | 처리 중단/반환 |  |  |  |
| AC-66564a46 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1134 | try ▸ else of (dtData != null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-be341121 | this.btnUpload.Click | FP02842_ExcelPopup.cs:1140 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02842_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3c1a8a9 | this.btnSave.Click | FP02842_ExcelPopup.cs:701 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-89de8410 | this.btnSave.Click | FP02842_ExcelPopup.cs:702 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05fdae22 | this.btnSave.Click | FP02842_ExcelPopup.cs:706 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix! After once seach, Try agagin.!") | 메시지 표시 |  |  |  |
| AC-b33d860a | this.btnSave.Click | FP02842_ExcelPopup.cs:707 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-733d9dbd | this.btnSave.Click | FP02842_ExcelPopup.cs:718 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (!String.IsNullOrEmpty(dsMain.Tables[0].Rows[i]["MESSAGE"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0e56507 | this.btnSave.Click | FP02842_ExcelPopup.cs:719 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (!String.IsNullOrEmpty(dsMain.Tables[0].Rows[i]["MESSAGE"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4566aa0d | this.btnSave.Click | FP02842_ExcelPopup.cs:723 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-c01829c9 | this.btnSave.Click | FP02842_ExcelPopup.cs:723 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6dbe26a6 | this.btnSave.Click | FP02842_ExcelPopup.cs:729 | if (OnBeforeCheckData != null) | CALL_BASE | OnBeforeCheckData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d914a2d4 | this.btnSave.Click | FP02842_ExcelPopup.cs:731 | if (OnBeforeCheckData != null) ▸ if (bCheck == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ebe0a09a | this.btnSave.Click | FP02842_ExcelPopup.cs:742 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8d9b29e4 | this.btnSave.Click | FP02842_ExcelPopup.cs:743 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-701825ee | this.btnSave.Click | FP02842_ExcelPopup.cs:744 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-db0f0d03 | this.btnSave.Click | FP02842_ExcelPopup.cs:745 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8dab630c | this.btnSave.Click | FP02842_ExcelPopup.cs:746 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9e7fc78b | this.btnSave.Click | FP02842_ExcelPopup.cs:747 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e0e4e8f9 | this.btnSave.Click | FP02842_ExcelPopup.cs:755 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-73c03c10 | this.btnSave.Click | FP02842_ExcelPopup.cs:756 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5bf5bc68 | this.btnSave.Click | FP02842_ExcelPopup.cs:757 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e578b2aa | this.btnSave.Click | FP02842_ExcelPopup.cs:758 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1733f4c0 | this.btnSave.Click | FP02842_ExcelPopup.cs:759 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e77ab43b | this.btnSave.Click | FP02842_ExcelPopup.cs:760 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-026584e4 | this.btnSave.Click | FP02842_ExcelPopup.cs:761 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3ddf916d | this.btnSave.Click | FP02842_ExcelPopup.cs:762 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d76108e | this.btnSave.Click | FP02842_ExcelPopup.cs:768 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a08a7762 | this.btnSave.Click | FP02842_ExcelPopup.cs:771 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1319d5a | this.btnSave.Click | FP02842_ExcelPopup.cs:773 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad186dad | this.btnSave.Click | FP02842_ExcelPopup.cs:776 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-db1d0da1 | this.btnSave.Click | FP02842_ExcelPopup.cs:781 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-e11a8410 | this.btnSave.Click | FP02842_ExcelPopup.cs:782 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-ea90b629 | this.btnSave.Click | FP02842_ExcelPopup.cs:793 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGrou… | DATA_OP | this.Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-7d04df69 | this.btnSave.Click | FP02842_ExcelPopup.cs:795 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rd… | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-8aa8e31f | this.btnSave.Click | FP02842_ExcelPopup.cs:799 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0d253b76 | this.btnSave.Click | FP02842_ExcelPopup.cs:804 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d04dad88 | this.btnSave.Click | FP02842_ExcelPopup.cs:827 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-68af5709 | this.btnSave.Click | FP02842_ExcelPopup.cs:830 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | POPUP | new Planning.UIL.FP00594_InValidationExcelPopup | ("InvalidExcelPopup", dsValidation, "") | 팝업/폼 생성 |  |  |  |
| AC-fca15edc | this.btnSave.Click | FP02842_ExcelPopup.cs:831 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-485bbdc4 | this.btnSave.Click | FP02842_ExcelPopup.cs:832 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-95934d69 | this.btnSave.Click | FP02842_ExcelPopup.cs:849 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb0ab0ee | this.btnSave.Click | FP02842_ExcelPopup.cs:861 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-169c44a6 | this.btnSave.Click | FP02842_ExcelPopup.cs:865 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | FLAG | bUploadSaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-293dc9bf | this.btnSave.Click | FP02842_ExcelPopup.cs:866 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ecae4d0f | this.btnSave.Click | FP02842_ExcelPopup.cs:871 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-177eb7d4 | this.btnSave.Click | FP02842_ExcelPopup.cs:872 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5bd012cb | this.btnSave.Click | FP02842_ExcelPopup.cs:878 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-3c4194c5 | this.btnSave.Click | FP02842_ExcelPopup.cs:915 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-0459b636 | this.btnSave.Click | FP02842_ExcelPopup.cs:917 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bfcb8ecc | this.btnSave.Click | FP02842_ExcelPopup.cs:918 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-75118d58 | this.btnSave.Click | FP02842_ExcelPopup.cs:928 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3b2fcdc8 | this.btnSave.Click | FP02842_ExcelPopup.cs:929 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-03e578fc | this.btnSave.Click | FP02842_ExcelPopup.cs:933 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-65e795d0 | this.btnSave.Click | FP02842_ExcelPopup.cs:934 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bddad3cb | this.btnSave.Click | FP02842_ExcelPopup.cs:935 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9b357faf | this.btnSave.Click | FP02842_ExcelPopup.cs:936 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3357d36f | this.btnSave.Click | FP02842_ExcelPopup.cs:937 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1a34d4fa | this.btnSave.Click | FP02842_ExcelPopup.cs:938 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02842_ExcelPopup.SearchListInfoAll

진입점: this.btnUpload.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9610a224 | this.btnUpload.Click [try] | FP02842_ExcelPopup.cs:972 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-50d2ae23 | this.btnUpload.Click [try] | FP02842_ExcelPopup.cs:973 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-24c9565d | this.btnUpload.Click [try] | FP02842_ExcelPopup.cs:976 |  | FLAG | dtDimension | siMain.GetSpdTitle(sProgramID, sUserID, sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-4abc4299 | this.btnUpload.Click [try] | FP02842_ExcelPopup.cs:976 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-905a15e3 | this.btnUpload.Click [try] | FP02842_ExcelPopup.cs:979 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP02842_find_UOMInfo_ALL") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6b1eb293 | this.btnUpload.Click [try] | FP02842_ExcelPopup.cs:980 |  | FLAG | dsUomInfoAll | dtUomAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-055fe6f2 | this.btnUpload.Click [try] | FP02842_ExcelPopup.cs:980 |  | DATA_OP | dtUomAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ccea94aa | this.btnUpload.Click [try] | FP02842_ExcelPopup.cs:982 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP02842_find_YieldInfo_Child", Filter["INSTANCE_ID"].ToString(), Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0c12a588 | this.btnUpload.Click [try] | FP02842_ExcelPopup.cs:983 |  | FLAG | dsYieldInfoAll | dtYieldAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-77408160 | this.btnUpload.Click [try] | FP02842_ExcelPopup.cs:983 |  | DATA_OP | dtYieldAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP02842_ExcelPopup.SetAmendHeaderColumn_FP_Local

진입점: this.Load [if (OnSearchData != null) ▸ try ▸ lambda] / this.btnFind.Click [if (OnSearchData != null) ▸ try ▸ lambda] / FindButton [if (OnSearchData != null) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a259634e | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:603 |  | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-12a1fcd1 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:609 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78f4ff97 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:613 | if (!dtSheetColumnConfig.Good()) | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-15d6e7f9 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:614 | if (!dtSheetColumnConfig.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-d9a40d74 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:631 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Len… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1403e31d | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:632 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Len… | CALL_EXT | MenuService.SetMenuColumn | (dateRowDay, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = _s… | ⚠ 의미 확인 필요 |  |  |  |
| AC-faa20fbf | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:643 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Len… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowDay) | 데이터 객체 조작/조회 |  |  |  |
| AC-fffbe8e9 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:644 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ for (i < _sDateColumnAppendName.Len… | FLAG | added_columns_count | added_columns_count++ | 화면 필드 증감 |  |  |  |
| AC-1e70870e | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:652 |  | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e112c9cf | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:653 |  | CALL_EXT | MenuService.SetMenuColumn | (dateRowMessage, new MenuOption { program = sProgramID, sheet = sSheetName, cell_object = … | ⚠ 의미 확인 필요 |  |  |  |
| AC-afb76046 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:664 |  | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowMessage) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbafba1c | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:665 |  | FLAG | added_columns_count | added_columns_count++ | 화면 필드 증감 |  |  |  |
| AC-ed34e1d3 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:669 | if (dtSheetColumnConfig.Rows.Count == 0) | FLAG | added_columns_count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-19e8bff1 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:670 | if (dtSheetColumnConfig.Rows.Count == 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-53b34330 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:673 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, iColumnHeaderRowCount, dtSheetColumnConfig) | 그리드 재구성/초기화 |  |  |  |
| AC-9888e843 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:678 | foreach (DataRow row in dtSheetColumnConfig.Rows) | DATA_OP | DictColumn.ContainsKey | (row["COLUMN_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-624475fa | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:679 | foreach (DataRow row in dtSheetColumnConfig.Rows) ▸ if (!DictColumn.ContainsKey(row["COLUMN_NAME"].ToString())) | DATA_OP | DictColumn.Add | (row["COLUMN_NAME"].ToString(), row["COLUMN_LABEL_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a891fef | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:683 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-aa90a8dd | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:684 |  | RETURN | return DictColumn; |  | 처리 중단/반환 |  |  |  |

## FP02842_ExcelPopup.SetSheetHeadColor

진입점: this.Load [if (OnSearchData != null) ▸ try ▸ lambda] / this.btnFind.Click [if (OnSearchData != null) ▸ try ▸ lambda] / FindButton [if (OnSearchData != null) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5348e05 | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:562 | try ▸ for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*") >= 0) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, idx].ForeColor | System.Drawing.Color.FromArgb(0, 113, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-f9fbceda | this.Load [if (OnSearchData != null) ▸ try ▸ lambda] 외 2 | FP02842_ExcelPopup.cs:570 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02842_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bddc4d5 | this.Load | FP02842_ExcelPopup.cs:288 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d32e1f52 | this.Load | FP02842_ExcelPopup.cs:289 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP02842_ExcelPopup.SetValidationResultSheetColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa1cc610 | (진입점 미연결) | FP02842_ExcelPopup.cs:589 | try ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValid.Equals("N")) | GRID_SET | siMain.ActiveSheet.Cells[i, 0, i, siMain.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-5e7c5df3 | (진입점 미연결) | FP02842_ExcelPopup.cs:596 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-368ddab4 | (진입점 미연결) | FP02842_ExcelPopup.cs:599 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP02842_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d87c7559 | .ctor | FP02842_MeasureSetForm_Popup.cs:90 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-f265046f | .ctor | FP02842_MeasureSetForm_Popup.cs:91 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-4bcc561c | .ctor | FP02842_MeasureSetForm_Popup.cs:92 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-87137757 | .ctor | FP02842_MeasureSetForm_Popup.cs:94 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP02842_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cdb857d | this.btnOK.Click | FP02842_MeasureSetForm_Popup.cs:278 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-a410f9e0 | this.btnOK.Click | FP02842_MeasureSetForm_Popup.cs:279 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-9874b4d0 | this.btnOK.Click | FP02842_MeasureSetForm_Popup.cs:286 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-fc94f73f | this.btnOK.Click | FP02842_MeasureSetForm_Popup.cs:287 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02842_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46225d30 | this.btnSet.Click | FP02842_MeasureSetForm_Popup.cs:250 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-b989688a | this.btnSet.Click | FP02842_MeasureSetForm_Popup.cs:251 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-a8b745f6 | this.btnSet.Click | FP02842_MeasureSetForm_Popup.cs:253 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-dc91f130 | this.btnSet.Click | FP02842_MeasureSetForm_Popup.cs:254 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a25600b | this.btnSet.Click | FP02842_MeasureSetForm_Popup.cs:256 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-d2c63757 | this.btnSet.Click | FP02842_MeasureSetForm_Popup.cs:257 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-def68386 | this.btnSet.Click | FP02842_MeasureSetForm_Popup.cs:258 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02842_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd26dce2 | Dispose | FP02842_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02842_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5da9d880 | this.Load | FP02842_MeasureSetForm_Popup.cs:117 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP02842_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b8747ac | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:160 |  | FLAG | dtCategory | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "select_measure", "FP02842_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-8ff0719e | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:160 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP02842_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1a9f2dbd | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:162 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-450ec11f | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:163 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-88bf5c53 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:169 |  | DATA_OP | ctrls.Add | (chk_total_d) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7631188 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:170 |  | DATA_OP | ctrls.Add | (chk_roll) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2c8f05e | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:171 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f87136c | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:172 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-72993a5d | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:173 |  | DATA_OP | ctrls.Add | (chk_load) | 데이터 객체 조작/조회 |  |  |  |
| AC-727bad54 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:174 |  | DATA_OP | ctrls.Add | (chk_remain) | 데이터 객체 조작/조회 |  |  |  |
| AC-649f974a | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:177 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-8dc45602 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:178 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-739f8aa5 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:182 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-bdf46724 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:182 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-91187260 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:190 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-2d693fbd | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:194 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-c6d00994 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:198 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP02842_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5de2dd85 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:130 |  | VALUE_SET | chk_total_d.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3eae974f | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:131 |  | VALUE_SET | chk_roll.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-44599900 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:132 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e92b9774 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:133 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-946685dc | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:134 |  | VALUE_SET | chk_load.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5fb96caf | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:135 |  | VALUE_SET | chk_remain.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-10139d8a | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d7c4fd06 | this.Load 외 1 | FP02842_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP02842_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0018c44 | (진입점 미연결) | FP02842_MeasureSetForm_Popup.cs:340 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-9724c3db | (진입점 미연결) | FP02842_MeasureSetForm_Popup.cs:351 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9692d4fe | (진입점 미연결) | FP02842_MeasureSetForm_Popup.cs:362 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP02842_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bd03006 | this.Load | FP02842_MeasureSetForm_Popup.cs:104 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9993da9f | this.Load | FP02842_MeasureSetForm_Popup.cs:112 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02842_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd5d180f | this.btnSet.Click 외 1 | FP02842_MeasureSetForm_Popup.cs:297 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-087f7e7a | this.btnSet.Click 외 1 | FP02842_MeasureSetForm_Popup.cs:305 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-d5c7cc43 | this.btnSet.Click 외 1 | FP02842_MeasureSetForm_Popup.cs:305 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-021ced6a | this.btnSet.Click 외 1 | FP02842_MeasureSetForm_Popup.cs:322 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b036bba8 | this.btnSet.Click 외 1 | FP02842_MeasureSetForm_Popup.cs:333 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1394d59e | .ctor | FP02842_PlanAmend_Elec_Post_Shift.cs:217 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-e0967b5a | .ctor | FP02842_PlanAmend_Elec_Post_Shift.cs:218 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.usrButton6.Click [if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.usrButton5.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47bc06ce | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1182 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4b871778 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1183 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4a26c7f4 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1184 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-830606e6 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1185 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-04c8e60c | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1186 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b1b9084b | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1189 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-544e4afe | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1193 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-cc012c05 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1195 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-88122b8b | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1196 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-19def058 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1197 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54770e96 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1198 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-d502af6f | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1199 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4912370 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1200 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-850417e5 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1215 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cdd7be5c | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1216 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e89a62a7 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1217 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-429e127a | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1218 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-129aeb94 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1243 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-646c1a36 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1244 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-70b00d0d | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1245 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-966b9c03 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1246 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-7c8d83d6 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1247 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.ApplyAmendCalendarCondition_ForExcel

진입점: popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a1d69f3 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4866 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fec10b69 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4867 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0be4c36d | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4868 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d0e9fa99 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4869 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c8f67d12 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4870 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-de37ee90 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4884 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1a394a7b | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4888 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-26b36092 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4890 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-94ad5827 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4891 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-9c170c2c | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4892 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-24ae3c4a | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4893 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-19304f22 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4894 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5a91f977 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4895 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-aa43be6e | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4900 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP02842_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ad8663bb | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4902 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-36971843 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4903 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5a68f429 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4904 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f7811cb | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4905 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4b43d7d | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4906 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2ea9123b | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4907 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d64c9c8a | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4908 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a9675e39 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4911 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-f8a6c02f | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4912 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-f9a4a34a | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4913 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-dbde662b | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4914 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-4b246ca0 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4915 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-e1e5a0ed | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4916 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-c4cfc707 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4917 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.usrButton6.Click [if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.usrButton5.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e66fb598 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1123 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //DataTable dt = null; if (GetFilter("INSTANCE_ID") == ""… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b859af76 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1133 | lambda | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-9af5d546 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1134 | lambda | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b4fe29cc | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1135 | lambda | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f30b87f0 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1151 | lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-b32ec6b8 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1154 | lambda | DATA_OP | Filter["AMEND_TABLE"] | "FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R" | 행/컬럼 값 대입 |  |  |  |
| AC-2f1cf1d2 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1155 | lambda | DATA_OP | Filter["TOTAL_TABLE"] | "FP_ELECTRODE_POST_PLAN_H" | 행/컬럼 값 대입 |  |  |  |
| AC-9cb683c8 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1175 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c9d65fa | this.btnBucket.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2643 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-1b197ffd | this.btnBucket.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2646 |  | POPUP | new FP02842_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-f7f8dafb | this.btnBucket.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2647 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0cba5903 | this.btnBucket.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2648 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-8e0c03e3 | this.btnBucket.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2649 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-da817fa1 | this.btnBucket.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2653 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-157f73bd | this.btnBucket.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2662 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b8c86ccb | this.btnBucket.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2664 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d5a6b5cc | this.btnBucket.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2667 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-610f0b27 | this.btnBucket.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2676 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1eac8470 | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2588 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a6df3a82 | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2591 |  | POPUP | new FP02842_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-4197ee5b | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2592 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-231877a5 | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2593 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1c10cc67 | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2594 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fd13d08f | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2598 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-cc81b3a4 | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2607 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9e95e3d6 | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2609 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ca871f6f | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2612 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e4b47d38 | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2621 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b5410bd2 | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2626 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-20a2bb9d | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2629 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f036784c | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2631 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-187af22a | this.btnCatagory.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2634 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f52d849f | this.btnColumn.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2561 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a861e701 | this.btnColumn.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2564 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-06bd16e3 | this.btnColumn.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2565 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3e1bab6e | this.btnColumn.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2566 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4282b34b | this.btnColumn.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2572 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-42b39d25 | this.btnColumn.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2572 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4c0229c | this.btnColumn.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2573 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-b682b854 | this.btnColumn.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2579 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.btnCreatePlan_Click

진입점: this.usrButton5.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6523c99b | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2697 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f0bbdce2 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2698 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b9d30d2 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2713 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-71a762d0 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2715 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a107173a | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2721 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f3a3c86 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2722 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2491bbfd | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2727 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-07e22bb8 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2728 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6cf73277 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2731 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6f937dc | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2732 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-faa85e1f | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2733 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8e06d75 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2739 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-6c8a2b83 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2742 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-e2ea191e | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2743 |  | VALUE_SET | popPlanTotal.Text | "Create Plan" | 컨트롤 값 설정 |  |  |  |
| AC-aaaf09d7 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2744 |  | UI_PROP | popPlanTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-b38c475d | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2745 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5a0ee0b5 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2746 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e2edbb65 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2761 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] = popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-52ceb974 | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2761 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["PLAN_ID"] | popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-6205665f | this.usrButton5.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2768 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | VALUE_SET | cboPlanId.SelectedValue | new_plan | 컨트롤 값 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-435b5d2e | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2952 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-17df4943 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2953 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55ee9386 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2959 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not be uploaded.") | 메시지 표시 |  |  |  |
| AC-21dda3fa | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2960 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27a279ae | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2966 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-36f5866e | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2969 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d71dac9f | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2975 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4d9822c7 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2976 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf744728 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2977 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fac8c464 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2979 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-18f16842 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2986 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP02842_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-1e190b9f | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2988 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | this.Filter | 화면 필드/플래그 변경 |  |  |  |
| AC-4a3ee03a | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2991 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.TYPEZERO | 속성 DateColumnType 설정 |  |  |  |
| AC-1b1bb0a6 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2994 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e7c84247 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2995 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5d750f63 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2996 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-91d5b07e | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2997 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9b16654f | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2998 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9c6bf042 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2999 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-983ff4c9 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3000 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4f6bda67 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3001 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5035b89f | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3002 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-cb5b9146 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3006 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-993dd856 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3007 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-9e23ff35 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3008 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-bbe05e3a | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3009 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-0fb57b9a | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3010 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-8f8c97b6 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3011 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Operateion." | 행/컬럼 값 대입 |  |  |  |
| AC-7e08422b | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3012 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-5a39fe66 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3013 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-c3faca52 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3014 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-ad817f49 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3015 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-c8c80bf9 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3016 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-a93dc3f2 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3017 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-f784a06c | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3023 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnSearchData | ExcelPopup_Search_Column | 속성 OnSearchData 설정 |  |  |  |
| AC-6232f040 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3024 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Column | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-e06fd78e | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3025 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Column | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-0a80bdaa | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3026 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-f97fc947 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3028 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-a8c01311 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3030 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8dd5c7eb | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3040 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cff05f0a | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3043 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8730b53d | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3046 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | MESSAGE | MessageBox.Show | ("ERROR: EXEC_PSICALCUL Excution occur Error!") | 메시지 표시 |  |  |  |
| AC-89a6b91d | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3059 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP02842_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-65916d13 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3061 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | this.Filter | 화면 필드/플래그 변경 |  |  |  |
| AC-dac19b29 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3065 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9247368c | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3066 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2a0166aa | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3067 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-32673897 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3068 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-87aac52c | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3069 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3977342d | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3070 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-863ee3d5 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3071 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e331cbf3 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3072 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a66b8824 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3073 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c4a6e4fa | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3076 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-251b3230 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3077 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ba1ecb65 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3080 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-8eff5fd8 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3081 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-0f427579 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3082 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-77658059 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3083 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-ffed0d35 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3084 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Operateion" | 행/컬럼 값 대입 |  |  |  |
| AC-5958ce3f | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3085 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-ff16296a | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3086 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-dbfdd286 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3087 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-28ebf356 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3088 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-43454ea6 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3089 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-7e787d7d | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3090 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-feb5fd51 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3093 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-4f9c5540 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3094 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PC_OUT_QTY"] | "M(P/C)" | 행/컬럼 값 대입 |  |  |  |
| AC-a262ec53 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3095 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["JR_OUTQTY"] | "M(J/R)" | 행/컬럼 값 대입 |  |  |  |
| AC-15e50ed3 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3099 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnSearchData | ExcelPopup_Search_Row | 속성 OnSearchData 설정 |  |  |  |
| AC-db4b0c7d | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3100 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Row | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-d772d513 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3101 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Row | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-2823aff3 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3102 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-50fc4f4a | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3104 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-95af6d22 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3106 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2bfdd386 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3116 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8eac6e2c | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3122 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | MESSAGE | MessageBox.Show | ("ERROR: EXEC_PSICALCUL Excution occur Error!") | 메시지 표시 |  |  |  |
| AC-1fa68ad4 | this.btnExcelImport.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3124 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.btnRelease_Click

진입점: this.usrButton6.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1a0cd2c | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2791 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33a88375 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2792 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-354a0338 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2796 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bbbc31a6 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2797 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e59b6731 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2800 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-4dc9511a | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2801 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1595dca | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2815 | if (string.IsNullOrEmpty(sPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e903d2e8 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2816 | if (string.IsNullOrEmpty(sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d524480 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2822 | if (sPlanID == "-") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb77ab60 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2823 | if (sPlanID == "-") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20c0ca7c | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2830 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "00 Plan cant not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae388369 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2831 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eca43102 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2834 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_instanceInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7d7be190 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2835 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_planInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-34129aed | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2837 |  | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2eeb00aa | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2843 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Release type plan can not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ed6f4b0a | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2844 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e539cc48 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2849 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-605fae51 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2853 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-468d4bbe | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2854 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e5b5cc4 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2861 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00eb4f08 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2862 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-924d1f2a | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2869 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4bdac60f | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2872 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-edf691b1 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2874 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4a86c8c4 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2880 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ddeb097e | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2881 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec8412db | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2894 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4f85318 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2895 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-965ad184 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2907 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-4a19e53e | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2910 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-5d5bf208 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2911 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-20a3031c | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2912 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4f94666f | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2913 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0ef28cf5 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2926 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-47e3d40e | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2929 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-1149b7a5 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2930 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-57f6ecf1 | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2931 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5182dabc | this.usrButton6.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2932 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59bbac1b | this.btnSql.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3144 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-d5083fe0 | this.btnSql.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3147 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bd1a1db1 | this.btnSql.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3148 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1e03c621 | this.btnSql.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3150 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT") | 데이터 객체 조작/조회 |  |  |  |
| AC-f16fced9 | this.btnSql.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3152 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02842_AMEND_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-113a4151 | this.btnSql.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3155 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-250f5f5b | this.btnToggleSave.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2684 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-182fa930 | this.button1.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:2944 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.cbo_fpplanid_changed

진입점: cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dab20590 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2413 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[selected]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-a5de520a | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2414 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[selected]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-a9d997ea | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2415 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[selected]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-d339db84 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2416 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[selected]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-3a9bd367 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2417 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[selected]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-c0957b3d | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2419 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-cd196f33 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2420 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-f6f5faf4 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2421 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-1b64fdfd | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2422 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-e661a793 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2423 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-20f5d3b7 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2427 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-31fd4e36 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2428 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-7f7c11d7 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2429 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-489c4af3 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2430 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-b3e44580 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2431 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-58ceffbe | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2433 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-7c190172 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2434 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-859ec77f | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2435 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-e4d92be5 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2436 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-d4548482 | cbo_fpplanid.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2437 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f6aa361 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:1612 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0393ccb | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:1612 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-5b4c4d1d | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:1614 |  | CALL_EXT | MeasureService.MakeDefault | (new FP02842_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca4f45d7 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:1614 |  | POPUP | new FP02842_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-dad4cb63 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:1615 |  | CALL_EXT | MeasureService.MakeDefault | (new FP02842_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57dd4449 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:1615 |  | POPUP | new FP02842_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.chk_includeSubOp_onchanged

진입점: this.chk_includeSubOp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-636f8a0b | this.chk_includeSubOp.CheckedChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2544 | if (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-f9deb9ce | this.chk_includeSubOp.CheckedChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2546 | else of (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.chk_Info_CheckedChanged

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a98bc24 | this.chk_Info.CheckedChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:6742 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-2828426c | this.chk_Info.CheckedChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:6742 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2654cfc | this.chk_Info.CheckedChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:6748 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-efba7e97 | this.chk_Info.CheckedChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:6749 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.CreateEditDataGridDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3351f270 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4659 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-7f3b19a8 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4660 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4fa7b8e1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4661 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-82728bac | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4662 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-db38249d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4663 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7be733ee | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4664 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-15332b85 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4665 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-adbd0a9c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4666 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-368352d4 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4667 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-70be0a77 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4668 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea86a225 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4669 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e736d0d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4670 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a49d3095 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4671 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-db452fb7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4672 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-181a9f4a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4673 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6cea7421 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4674 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d25f1e96 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4675 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-44791003 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4676 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca610f2f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4677 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CUSTOMER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a21a8bbb | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4678 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eab6347e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4679 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca54b575 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4680 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5a743e0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4681 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5c7c656 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4682 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4391b5c7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4683 |  | DATA_OP | dt.Columns.Add | (new DataColumn("WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7edf48bf | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4685 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6987459c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4686 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4d511c1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4687 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-226da80c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4688 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8dd77b74 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4689 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-71911ccc | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4691 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ACTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-158ee1d1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4693 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.CreateEditSeqDataTable

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sColumnName.IndexOf("_SHIFT_") >= 0) ▸ if (sCateID.Equals("P_OUT")) ▸ if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (dtList ==null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dbe514e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4630 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-72ccf65b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4631 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1ae21a2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4632 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1dcbc018 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4633 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c702675f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4634 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ecdab38 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4635 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9084c8a9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4636 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbfa234c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4637 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3af60aea | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4638 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ee090a8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4639 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-23da1770 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4640 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-187068d3 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4641 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d824d6e7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4642 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EQUIPMENT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-89ee7be2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4643 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e1661b2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4644 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SHIFT", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d700eb7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4646 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PC_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7420968 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4647 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PC_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0c9be69 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4648 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JR_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-073f77e1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4649 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JR_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f25e94f2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4651 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0de39fab | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4653 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.CreateExelBufferDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce697872 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4923 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-48dcdb2f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4924 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-23bcd105 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4925 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dbecca44 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4926 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-48c3498a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4927 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd4afccb | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4928 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c65d66c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4929 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ece9146 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4930 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3de2199b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4931 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d339426 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4932 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ca7d782 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4933 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f123a069 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4934 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ed5aacf | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4935 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EQUIPMENT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f1d3356 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4936 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9eb8850 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4937 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d66b19e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4938 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6d2ec57 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4939 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c67e5d8 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4940 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-69a563d4 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4941 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a95b074e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4942 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-08ae4f68 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4943 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e9a30ed | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4944 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4769ac0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4945 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-191e2c05 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4946 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e95e4c5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4947 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JOB_ORDER", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-555c4c8b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4949 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acb4803b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1621 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c73189f6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1632 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-48b1dc2a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1633 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-058029f8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1643 | if (measure["chk_total_d"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "TOTAL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b31a62e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1647 | if (measure["chk_roll"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_ROLL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c31e2a4a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1651 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b61e259 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1655 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-08c4477f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1659 | if (measure["chk_load"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "LOAD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-64a67082 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1663 | if (measure["chk_remain"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "REMAIN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-afaae987 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1715 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f003a1b7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1722 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-78ae4d2c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1727 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-76e7d625 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1731 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b3c8582 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1733 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b885afe1 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:449 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-42ae64cf | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:450 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4c42404 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:451 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.dCalendarPlanrange_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e506f886 | drpPeriod.ValueChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2518 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae97d2af | drpPeriod.ValueChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2524 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-c53c7c27 | drpPeriod.ValueChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2525 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Delete_buffer_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-423674a8 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1957 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Delete_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7925f464 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5654 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-6fc559c2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5655 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b6543708 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5657 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b2522867 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5658 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e49e4ca6 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5659 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-b18d0bf6 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5660 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fcd53ba6 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5661 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4f2d55bb | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5662 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6af7efbd | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5663 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e1e2cfee | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5664 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-10f2fec1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5665 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-841d414b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5666 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4ada7234 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5668 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c8fc83c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5676 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-2dbf32ac | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5680 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-e2c87b79 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5681 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20e59f9e | DeleteButton | FP02842_PlanAmend_Elec_Post_Shift.cs:903 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ad3298d | Dispose | FP02842_PlanAmend_Elec_Post_Shift.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.DrawHeader

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day !=…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-594da0b0 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6186 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-d7ea2c62 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6190 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-47dd12f7 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6191 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad25a142 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6192 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9ae93b6 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6193 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (2, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eaad3a04 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6194 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c7cc02f | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6195 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-4a42b25f | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6199 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-e408ab84 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6200 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-292a6e03 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6201 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-59d5ff75 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6202 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-55521591 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6208 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-eec965e2 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6209 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-77fce69a | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6249 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac452acc | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6256 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae68e433 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6257 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d0abc9ee | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6258 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-deaeca50 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6260 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-d34f1d73 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6262 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-fda72a91 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6263 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-937eddf4 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:6268 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.DrawSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9fc88f1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6274 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-90731313 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6277 | if (!in_Dataset.Good()) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-bf71d3a5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6278 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a63e1dd0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6287 |  | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-72502114 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6290 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f2a32a2 | EditButton | FP02842_PlanAmend_Elec_Post_Shift.cs:911 | if (spdMain != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ced0d111 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP02842_PlanAmend_Elec_Post_Shift.cs:3249 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87877540 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP02842_PlanAmend_Elec_Post_Shift.cs:3250 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f0c56f0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP02842_PlanAmend_Elec_Post_Shift.cs:3251 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-f6dbf169 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP02842_PlanAmend_Elec_Post_Shift.cs:3253 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20914a3b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP02842_PlanAmend_Elec_Post_Shift.cs:3264 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-47631fab | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP02842_PlanAmend_Elec_Post_Shift.cs:3265 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e299ccdd | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3306 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c127873 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3307 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-07a6d0dd | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3308 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-fabeee01 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3310 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9111abde | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3318 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-220ff9c5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3319 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca718d78 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3325 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.EditByFunc

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7baa461 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3275 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7eb0b879 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3277 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-5aa2ed78 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3278 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-ff6995ff | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3280 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10a3d9a4 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3290 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0258b02 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3296 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae710be3 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3298 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.EditCommon

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7607c1ed | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3370 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SHIFT_") >= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57c9f33e | ExcelButton | FP02842_PlanAmend_Elec_Post_Shift.cs:2243 |  | EXCEL | ExportExcel | (0,true) | 엑셀 내보내기/올리기 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.ExcelPopup_BufferValidation_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e775f0c2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5178 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-3b714776 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5202 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-205f9c3b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5204 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-21b18dc7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5205 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54d214e2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5206 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a198a9d9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5207 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-379a44a6 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5208 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-19d5a0df | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5209 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-550aef7d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5210 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-81b7b7b2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5211 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e277b973 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5212 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-27a29dd4 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5213 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c611221f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5214 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4ded896c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5215 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["EQUIPMENT_ID"] | data.Tables[0].Rows[i]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f211407b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5216 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-892da88d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5217 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0eb52f4f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5218 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d7aedde7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5219 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b73cb92 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5220 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sQtyCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-32558c88 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5221 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SEQ"] | data.Tables[0].Rows[i][sSeqCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7ef91f21 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5230 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | data.Tables[0].Rows[i][sQtyCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d39a417 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5231 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | nIn_KG | 행/컬럼 값 대입 |  |  |  |
| AC-61b123dc | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5232 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Math.Round(Convert.ToUInt32(data.Tables[0].Rows[i][sQtyCol].ToString()) * nYield, 2) | 행/컬럼 값 대입 |  |  |  |
| AC-f9b3d65a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5232 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | CALL_EXT | Convert.ToUInt32 | (data.Tables[0].Rows[i][sQtyCol].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe4038a6 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5233 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Math.Ceiling(nIn_KG * nYield) | 행/컬럼 값 대입 |  |  |  |
| AC-d8932195 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5235 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1f18a2d6 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5236 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2ff67c7e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5239 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffda7e97 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5248 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-c773ac9f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5272 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-85df10a4 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5277 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ecf5f8d3 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5279 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4305eb3 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5282 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-d3e20444 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5293 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-9093768c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5298 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-b471783e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5303 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-161776d9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5304 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.ExcelPopup_BufferValidation_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c08100cb | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5351 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ac389b6a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5353 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d3036131 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5354 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | data.Tables[0].Rows[i]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a885af67 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5355 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e18a2af3 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5356 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54d0996b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5357 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-865d4044 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5358 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5521bbf9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5359 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6500ae4c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5360 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0b4590af | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5361 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-694e8d9c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5362 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-94d6a25e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5363 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b2c8fde0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5364 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["EQUIPMENT_ID"] | data.Tables[0].Rows[i]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-379cf6c1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5365 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b6bfc09b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5366 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-edf0e8ba | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5367 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ac2ad20 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5368 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3f2dd768 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5369 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5124366b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5370 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SEQ"] | data.Tables[0].Rows[i]["SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-56ae8c10 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5379 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-522dede1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5380 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | nIn_KG | 행/컬럼 값 대입 |  |  |  |
| AC-7cb49e47 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5381 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Math.Round(Convert.ToUInt32(data.Tables[0].Rows[i]["QTY"].ToString()) * nYield, 2) | 행/컬럼 값 대입 |  |  |  |
| AC-96003fe9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5381 | try ▸ for (i < data.Tables[0].Rows.Count) | CALL_EXT | Convert.ToUInt32 | (data.Tables[0].Rows[i]["QTY"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c82edb5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5382 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Math.Ceiling(nIn_KG * nYield) | 행/컬럼 값 대입 |  |  |  |
| AC-63ba9c4c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5384 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bdb2c378 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5385 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-56a2f516 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5388 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-5221cb0a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5391 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-32213d28 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5411 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ lambda | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2892d4b0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5416 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5df001a9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5418 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c94b5a5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5421 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) ▸ if (d… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-2c13809a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5429 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8d89c931 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5434 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-5e677d6a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5439 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-95dee049 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5440 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.ExcelPopup_CheckBeforSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-019284dd | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4962 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Save cannot proceed Release.!") | 메시지 표시 |  |  |  |
| AC-cfd3a48f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4963 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c50e1114 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4968 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0d5de116 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4973 | try ▸ if (dtChk.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-444b39e9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4974 | try ▸ if (dtChk.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-73a561bd | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4979 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-f73d8842 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4983 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.ExcelPopup_SaveExcel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4512ecf8 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5533 | if (data.Tables[0].Rows.Count > 0) | DATA_OP | Filter["MPP_WPP"] | filter["MPP_WPP"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c3a773d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5543 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.ExcelPopup_SaveExcel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4605480 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5592 | if (data.Tables[0].Rows.Count > 0) | DATA_OP | Filter["MPP_WPP"] | filter["MPP_WPP"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-96428d76 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5602 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.ExcelPopup_Search_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ceb02411 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5015 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-216a8810 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5016 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-0926561e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5031 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-8d6389c5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5032 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-a280438d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5033 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-bf9c1eed | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5035 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-a17607fc | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5044 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-615f1fec | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5046 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.ExcelPopup_Search_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6ce54ad | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5059 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-f2163f44 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5060 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-6fd39836 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5076 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-1c9400d0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5077 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-e3af6114 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5078 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-daf63484 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5080 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-ecad1633 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5090 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-67f9f773 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5092 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Exec_Procedure

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c37c594 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2192 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02842_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP02842_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-6eb114ac | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2193 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cf1359f2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2195 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-ece027a9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2196 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-b515eed7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2197 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89f7a681 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2198 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-97927173 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2200 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-cdfbbd40 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2201 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a92d26c5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2202 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-1af1c90c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2203 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0dce47b4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2204 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-61ba9f39 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2205 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9ccf4460 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2206 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-06bd86ea | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2207 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e5fb90ad | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2208 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d21627ad | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2209 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6282c514 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2210 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c90d4d1b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2211 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-49ec5c3c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2212 | try | DATA_OP | req.Parameters["p_equipment_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c64dd4d0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2213 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7cfd5f30 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2214 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c593cd26 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2215 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4d4af44d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2216 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6ab6d8cb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2217 | try | DATA_OP | req.Parameters["p_seq"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b52ecb33 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2219 | try | DATA_OP | req.Parameters["p_adjust_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aeafe1e1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2220 | try | DATA_OP | req.Parameters["p_adjust_in_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c6d67fcc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2221 | try | DATA_OP | req.Parameters["p_adjust_in_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8a4305fa | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2222 | try | DATA_OP | req.Parameters["p_adjust_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-afa2e959 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2223 | try | DATA_OP | req.Parameters["p_adjust_out_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0376e913 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2224 | try | DATA_OP | req.Parameters["p_adjust_out_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-67c2b732 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2226 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c9b33ebe | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2233 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-5242bd80 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … | FP02842_PlanAmend_Elec_Post_Shift.cs:2237 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.usrButton6.Click [if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.usrButton5.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNull…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8356691c | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1031 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_rdo_Unit = rdo_Unit.Text; p_cbo_RoundPoint = cbo_RoundP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-06416dad | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1049 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT") ⇒ FP_Planning.PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT | 엔드포인트 요청 생성 |  |  |  |
| AC-c765f10e | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1050 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bf82ed52 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1051 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-788d597e | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1052 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-bc6a5ed1 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1053 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c34def4a | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1054 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-115fbd2c | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1056 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a40bf8d3 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1057 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-37f90cc8 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1058 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d1cd437c | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1059 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2f1078fe | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1060 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f942d18b | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1061 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a882e6b8 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1062 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b53f5331 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1063 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3a341b76 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1064 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f32b7a40 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1065 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-eca6ae1c | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1066 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a5884ba0 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1067 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-25f73ba7 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1068 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ad25eae3 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1069 | try | DATA_OP | request.Parameters["p_top_item_id"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-46e5b6e5 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1070 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a05655c1 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1071 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-5ceed206 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1073 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | (chk_plannedline.Checked ? "Y" : "N") | 행/컬럼 값 대입 |  |  |  |
| AC-7dad03ea | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1074 | try | DATA_OP | request.Parameters["p_uom"] | Filter["UOM"] | 행/컬럼 값 대입 |  |  |  |
| AC-ee2d6ab4 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1075 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-baaedab2 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1076 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-b6b318b6 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1077 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-940c8143 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1078 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-6d35498c | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1079 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-d4cb7b06 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1080 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-0625935b | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1081 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-882aee1e | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1082 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6e0de776 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1083 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7962047f | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1084 | try | DATA_OP | request.Parameters["p_total_table"] | Filter["TOTAL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e68d393d | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1086 | try | DATA_OP | request.Parameters["p_attribute_1"] | p_rdo_Unit | 행/컬럼 값 대입 |  |  |  |
| AC-76d47065 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1087 | try | DATA_OP | request.Parameters["p_attribute_2"] | p_cbo_RoundPoint | 행/컬럼 값 대입 |  |  |  |
| AC-757fb3a6 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1088 | try | DATA_OP | request.Parameters["p_attribute_3"] | Filter["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-08ce0b42 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1089 | try | DATA_OP | request.Parameters["p_attribute_4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-74e90523 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1090 | try | DATA_OP | request.Parameters["p_attribute_5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b818c39d | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1091 | try | DATA_OP | request.Parameters["p_attribute_6"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d05ae5a | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1092 | try | DATA_OP | request.Parameters["p_attribute_7"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-812b5e74 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1093 | try | DATA_OP | request.Parameters["p_attribute_8"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c0b7e35f | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1094 | try | DATA_OP | request.Parameters["p_attribute_9"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-41dcc14c | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1095 | try | DATA_OP | request.Parameters["p_attribute_10"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-622bcee6 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1099 | try ▸ if (pSysType == "SELECT") | FLAG | _Unit | ((string)p_rdo_Unit).ToSafeInt() | 화면 필드/플래그 변경 |  |  |  |
| AC-65ee7c36 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1099 | try ▸ if (pSysType == "SELECT") | CALL_EXT | ((string)p_rdo_Unit).ToSafeInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-063d2593 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1101 | try ▸ if (pSysType == "SELECT") | FLAG | _RoundPoint | ((string)p_cbo_RoundPoint).ToSafeInt() | 화면 필드/플래그 변경 |  |  |  |
| AC-90d68ac3 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1101 | try ▸ if (pSysType == "SELECT") | CALL_EXT | ((string)p_cbo_RoundPoint).ToSafeInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e00c7fa | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1102 | try ▸ if (pSysType == "SELECT") | FLAG | _RoundTen | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-719cd58f | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1106 | try ▸ if (pSysType == "SELECT") ▸ while (rwork > 0) | FLAG | _RoundTen | *= 10 | 화면 필드/플래그 변경 |  |  |  |
| AC-9be03dd5 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1111 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-69dbabb5 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1112 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1f3eba14 | popSql.OnSql [if (programID == "PR_UI_FP02842_PLAN_AMEND_ELE… 외 7 | FP02842_PlanAmend_Elec_Post_Shift.cs:1117 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Find_Data_Excel_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-161b7ac2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5496 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-28545bcd | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5497 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-951df858 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5499 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-35de5a0d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5500 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-85029429 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5501 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f1e1b7d1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5502 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b90420d0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5503 | try | DATA_OP | request.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-4365cc39 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5504 | try | DATA_OP | request.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-7a87ead5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5505 | try | DATA_OP | request.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-7f152898 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5506 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ef5b621d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5507 | try | DATA_OP | request.Parameters["p_site_id"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-c897afbf | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5508 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-855fc2bc | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5510 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-78d03337 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5512 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-fbd09595 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5517 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Find_Data_Excel_Import

진입점: popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE") ▸ if (popup != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f81f9b13 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5108 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL") ⇒ FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL | 엔드포인트 요청 생성 |  |  |  |
| AC-55ecdf2c | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5109 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-180e6c9f | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5111 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-57434e6d | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5112 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d7dbc23e | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5113 | try | DATA_OP | request.Parameters["p_sys_gubun"] | gubun | 행/컬럼 값 대입 |  |  |  |
| AC-4880da9c | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5114 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-10d56c1c | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5115 | try | DATA_OP | request.Parameters["p_proc_name"] | procedure_name.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-a4e41887 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5124 | try ▸ if (dsParameter != null && dsParameter.Rows != null && dsParameter.Rows.Count > 0) | CALL_EXT | param.Keys | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfdb2c56 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5138 | try | DATA_OP | request.Parameters["in_columns"] | keys | 행/컬럼 값 대입 |  |  |  |
| AC-720ab79b | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5139 | try | DATA_OP | request.Parameters["in_row"] | values | 행/컬럼 값 대입 |  |  |  |
| AC-5dbda2ea | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5140 | try | DATA_OP | request.Parameters["opt_none"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6df2c105 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5142 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e0cd9db | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5144 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-8304b329 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5149 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-7d3e49f4 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:5151 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Find_Save_Valid

진입점: popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SELECT")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b581ed71 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2019 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02842_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP02842_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-555f8eef | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2020 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-0596eba5 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2021 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-30ff3d65 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2022 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f9467caf | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2023 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-22781635 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2025 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-25aadfc0 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2026 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aaaf212c | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2027 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cfe0af63 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2028 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-06275fec | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2029 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-211f9b5a | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2030 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ae6d981d | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2031 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-867c608e | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2032 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ece275a6 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2033 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f5185b49 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2034 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d50c65d5 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2035 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6e9701ec | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2036 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-94d8d543 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2037 | try | DATA_OP | request.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-625ce8a7 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2038 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cfdaca65 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2039 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-08d59c42 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2040 | try | DATA_OP | request.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ed370ebf | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2041 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-039b8a39 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2042 | try | DATA_OP | request.Parameters["p_bucket_from"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0d03c9fb | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2043 | try | DATA_OP | request.Parameters["p_bucket_to"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-58c48791 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2044 | try | DATA_OP | request.Parameters["p_day_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f77fdbf5 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2045 | try | DATA_OP | request.Parameters["p_week_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bb6a2935 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2046 | try | DATA_OP | request.Parameters["p_month_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2156b4a0 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2047 | try | DATA_OP | request.Parameters["p_cate_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-73bb1d47 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2048 | try | DATA_OP | request.Parameters["p_cate_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1b2f32b5 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2049 | try | DATA_OP | request.Parameters["p_cate_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5008d9fe | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2050 | try | DATA_OP | request.Parameters["p_amend_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6ddd3ed8 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2051 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c77ec024 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2052 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a64eaedb | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2053 | try | DATA_OP | request.Parameters["p_amend_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3d0db742 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2054 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-19d63b96 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2055 | try | DATA_OP | request.Parameters["p_amend_util_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5e0c2b80 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2056 | try | DATA_OP | request.Parameters["p_amend_capa_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7da51f51 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2058 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-454dafee | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2060 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4c4a5864 | popSql.OnSql [if (programID == "PR_UI_FP02842_SAVE_VALID_SEL… | FP02842_PlanAmend_Elec_Post_Shift.cs:2066 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.FindTotalColorStart

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtP…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e88a175 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1756 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e60b875 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:233 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.GetDayColNameOfType_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasureName[i]].Value.Equals("true"))] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Wee…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8db76eb | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:611 |  | RETURN | return day.Value + date_append_name; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE") ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.usrButton6.Click [if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.usrButton5.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlan…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a339f932 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:3776 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.GetListDataSet

진입점: popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0572f25 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1282 |  | UI_PROP | asyncProxy_ListData.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-51a41d88 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1283 |  | FLAG | dsListData | await asyncProxy_ListData.ExecuteAsync<DataSet>(() => Data_FP.CallGeneralProcedure(("PR_UI… | 화면 필드/플래그 변경 |  |  |  |
| AC-419b836a | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1283 |  | ENDPOINT | asyncProxy_ListData.ExecuteAsync | (() => Data_FP.CallGeneralProcedure(("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser,… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ddaac091 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1284 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "LIST_DATA") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2e06f8a3 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1289 |  | UI_PROP | asyncProxy_UomInfo.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a4d4c131 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1290 |  | FLAG | dsUomInfo | await asyncProxy_UomInfo.ExecuteAsync<DataSet>(() => Data_FP.CallGeneralProcedure(("PR_UI_… | 화면 필드/플래그 변경 |  |  |  |
| AC-f1de2ff6 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1290 |  | ENDPOINT | asyncProxy_UomInfo.ExecuteAsync | (() => Data_FP.CallGeneralProcedure(("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser,… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-620f40fa | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1291 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "UOM_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e27c3da9 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1295 |  | UI_PROP | asyncProxy_RoleInfo.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-62d45a1a | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1296 |  | FLAG | dsRoleInfo | await asyncProxy_RoleInfo.ExecuteAsync<DataSet>(() => Data_FP.CallGeneralProcedure(("PR_UI… | 화면 필드/플래그 변경 |  |  |  |
| AC-71673eab | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1296 |  | ENDPOINT | asyncProxy_RoleInfo.ExecuteAsync | (() => Data_FP.CallGeneralProcedure(("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser,… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b1818601 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1297 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "ROLL_DATA") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-42f74849 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1301 |  | UI_PROP | asyncProxy_LoadInfo.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-655319f8 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1302 |  | FLAG | dsLoadInfo | await asyncProxy_LoadInfo.ExecuteAsync<DataSet>(() => Data_FP.CallGeneralProcedure(("PR_UI… | 화면 필드/플래그 변경 |  |  |  |
| AC-64319149 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1302 |  | ENDPOINT | asyncProxy_LoadInfo.ExecuteAsync | (() => Data_FP.CallGeneralProcedure(("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser,… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a6fa577c | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:1303 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "LOAD_DATA") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.GetMonthColNameOfType_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasureName[i]].Value.Equals("true"))] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (mon…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b159cbf | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:615 |  | RETURN | return month.Value + month_append_name; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.GetOperation

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17e3e494 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:7005 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-94b4dc84 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:7005 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-81055897 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:7007 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.GetToDay

진입점: drpPlanDate.DateTimeChanged / this.btnExcelImport.Click [else of (dt != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70d5180f | drpPlanDate.DateTimeChanged 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4168 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-817fe122 | drpPlanDate.DateTimeChanged 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4169 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.GetWeekColNameOfType_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasureName[i]].Value.Equals("true"))] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b5d1655 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:607 |  | RETURN | return week.Value + week_append_name; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b58faf5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1400 | if (do_edit_mode) ▸ if (current_src != null) ▸ for (i < current_src.Rows.Count) ▸ if (isRemain) | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex_Category, rowindex, colindex_Category, System.Drawing.Color.LightGray) | 그리드 표시 설정 |  |  |  |
| AC-340c0261 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1401 | if (do_edit_mode) ▸ if (current_src != null) ▸ for (i < current_src.Rows.Count) ▸ if (isRemain) | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex_Uom , rowindex, colindex_Uom , System.Drawing.Color.LightGray) | 그리드 표시 설정 |  |  |  |
| AC-037c782f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1464 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ for (i < current_sr… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex_shift_1, rowindex, colindex_shift_1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9da3991 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1466 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ for (i < current_sr… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex_shift_2, rowindex, colindex_shift_2, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-24a56e3f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1480 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ for (i < current_sr… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex_shift_1, rowindex, colindex_shift_1, System.Drawing.Color.LightGray) | 그리드 표시 설정 |  |  |  |
| AC-c6a3ad0d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1482 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ for (i < current_sr… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex_shift_2, rowindex, colindex_shift_2, System.Drawing.Color.LightGray) | 그리드 표시 설정 |  |  |  |
| AC-b08a5d1a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1498 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.LockRange | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7c00faee | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1499 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a83468ff | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1513 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (calendar != null) ▸ foreach (var week_item in calendar.Weeks) ▸ if (wee… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-a8b2727f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:1530 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (m… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3a32238 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:313 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e242d96a | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:317 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fba9882f | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:318 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5a8f55f7 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:322 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-2e7ff92e | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:324 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-59a81bb4 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:332 | try ▸ for (i < itemValues.Length) | DATA_OP | rdo_uom.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ee9e7da | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:335 | try | VALUE_SET | rdo_uom.EditValue | "JR" | 컨트롤 값 설정 |  |  |  |
| AC-1f3473f4 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:338 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa133a35 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:346 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5569b707 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:351 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-40661e3a | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:353 | try | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8aef7de0 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:363 | try | FLAG | _sToDay | drpPlanDate.DateTime.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-0e9347fa | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:373 | try ▸ for (i < itemValues.Length) | DATA_OP | rdo_Unit.Properties.Items.Add | (new RadioGroupItem(itemUnits[i], itemUnitDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-f305800a | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:375 | try | VALUE_SET | rdo_Unit.EditValue | "1000" | 컨트롤 값 설정 |  |  |  |
| AC-60fdc825 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:378 | try | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP02842_PLANAMEND_ELEC_POST_SHIFT", "ROUND_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-39d400bb | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:388 | try | LIST_REBIND | clsCtrl.setListBox | (dtRound, cbo_RoundPoint, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-abbd75e1 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:390 | try | VALUE_SET | cbo_RoundPoint.Text | "3" | 컨트롤 값 설정 |  |  |  |
| AC-ed04a19f | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:397 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e826b6c7 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:398 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-07a3ced9 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:399 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-508ac9d1 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:400 | try ▸ if (adminAuth == false) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c4e48265 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:409 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.InitEditingBuf

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.usrButton6.Click [if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.usrButton5.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c24c8d5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:4174 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fb1aef9b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:4177 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-dabcd624 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:4181 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37056b8e | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:274 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a4f65654 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:275 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-2129caa9 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:277 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-1878c46b | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:278 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-9cbcc561 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:279 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-1c2e38f1 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:280 |  | UI_PROP | mcbo_planner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5699ec27 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:281 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.InitSpread

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9dcfa3ca | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:464 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3b117e6 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:465 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-58822db7 | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:467 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a2e4889e | this.Load 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:471 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Insert_Buffer_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89ba87d9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1971 | for (i < data.Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ea2aee12 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1973 | for (i < data.Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ac07f60 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1974 | for (i < data.Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | data.Rows[i]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-72143583 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1975 | for (i < data.Rows.Count) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-285e2811 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1976 | for (i < data.Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04c068af | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1977 | for (i < data.Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e5506234 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1978 | for (i < data.Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a18988d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1979 | for (i < data.Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-18a3d08f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1980 | for (i < data.Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b27351f1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1981 | for (i < data.Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e90661b1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1982 | for (i < data.Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f94685d2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1983 | for (i < data.Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f342fa91 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1984 | for (i < data.Rows.Count) | DATA_OP | newrow["EQUIPMENT_ID"] | data.Rows[i]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d2c8030b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1985 | for (i < data.Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-66fca1a3 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1986 | for (i < data.Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f93e335a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1987 | for (i < data.Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-94568edd | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1988 | for (i < data.Rows.Count) | DATA_OP | newrow["MARKET"] | data.Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bfd3d376 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1989 | for (i < data.Rows.Count) | DATA_OP | newrow["QTY"] | data.Rows[i]["ADJUST_OUT_QTY_BATCH"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-adebd5a5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1990 | for (i < data.Rows.Count) | DATA_OP | newrow["SEQ"] | data.Rows[i]["SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9218125b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1992 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | Convert.ToDouble(data.Rows[i]["ADJUST_IN_QTY_BATCH"]) | 행/컬럼 값 대입 |  |  |  |
| AC-9e12a862 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1993 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | Convert.ToDouble(data.Rows[i]["ADJUST_IN_QTY_KG"]) | 행/컬럼 값 대입 |  |  |  |
| AC-ec1376f3 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1994 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Convert.ToDouble(data.Rows[i]["ADJUST_OUT_QTY_BATCH"]) | 행/컬럼 값 대입 |  |  |  |
| AC-ce6db39f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1995 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Convert.ToDouble(data.Rows[i]["ADJUST_OUT_QTY_KG"]) | 행/컬럼 값 대입 |  |  |  |
| AC-a5b7fc36 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1999 | for (i < data.Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6e0204b4 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:2000 | for (i < data.Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-417c8d25 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:2003 | for (i < data.Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-4abf52cc | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:2006 |  | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a89873f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:2010 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Insert_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e53c4e7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5453 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP02842_EXCELIMPORT", "insert_Excel_buffer", dsData) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\{?def… | 엔드포인트 호출 |  |  |  |
| AC-1f6d64a7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5457 | try ▸ if (result.Good()) | DATA_OP | result.Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-2805ba39 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5469 | try ▸ if (result.Good()) ▸ if (result.Columns.Contains("RESULT")) ▸ else of (result.Rows[0]["RESULT"].ToString().ToUpper() == "SUCCESS") ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9faec277 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5477 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-34c24148 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5481 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-02ae0c0c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5482 | catch ((Exception ex)) | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1ab386c | InsertButton | FP02842_PlanAmend_Elec_Post_Shift.cs:894 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d8a670e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:2250 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.lfn_getYieldInfo_Excel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9aa2004 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5790 | if (!string.IsNullOrEmpty(sColName) && sDay == "") ▸ lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1545429c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5806 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-54516e18 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5807 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-70cc0019 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5808 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1066dd8e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5809 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-173c9cf5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5810 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-48bcfa8c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5811 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-95b56366 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5811 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-88d4a927 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5826 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.lfn_setExchangeBatch

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sColumnName.IndexOf("_SHIFT_") >= 0) ▸ if (sCateID.Equals("P_OUT")) ▸ if (dsMainFiltered.Good())] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-186b08e4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4469 | else of (sAppendex.Equals("PC")) | RETURN | return nInValue; |  | 처리 중단/반환 |  |  |  |
| AC-61e86dce | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4479 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9e45a66 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4480 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-aec9f297 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4479 | lambda | RETURN | return (x.Field<string>("FACTORY_ID") == row["FACTORY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-38417fb6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4503 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.lfn_setExchangeBatch_Excel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2327c56a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5701 | if (!string.IsNullOrEmpty(sColName) && sDay == "") ▸ lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-954228e9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5723 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-7ed0952b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5730 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-63fce298 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5731 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fff0fae | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5732 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff49c6ba | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5733 | lambda | DATA_OP | each_row.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c18d393 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5750 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1cbea2b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5751 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-feb76c57 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5752 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-68a77fb0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5753 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-072fd3a7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5754 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-711487d1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5755 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c076b038 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5755 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b00f4a35 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5773 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.lfn_setExchangeLoad

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sColumnName.IndexOf("_SHIFT_") >= 0) ▸ if (sCateID.Equals("P_OUT")) ▸ if (dsMainFiltered.Good()) ▸ if (measure["chk_load"].Value == "true")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff7b400b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4563 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc43e84f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4564 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2a2562b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4565 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ea052c8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4566 | lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c63da4d7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4567 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-66fbb4d7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4568 | lambda | DATA_OP | x.Field | ("PLAN_DT") | 데이터 객체 조작/조회 |  |  |  |
| AC-737f98a5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4569 | lambda | DATA_OP | x.Field | ("SHIFT") | 데이터 객체 조작/조회 |  |  |  |
| AC-dbdd7fb5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4563 | lambda | RETURN | return (x.Field<string>("FACTORY_ID") == row["FACTORY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-b77adea5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4588 | if (MatchingUmoData.Count() > 0) | DATA_OP | selected["JR_OUT_QTY"] | nJrOutQty | 행/컬럼 값 대입 |  |  |  |
| AC-9c3b4965 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4589 | if (MatchingUmoData.Count() > 0) | DATA_OP | selected["LOAD"] | nLoad | 행/컬럼 값 대입 |  |  |  |
| AC-7073cc49 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4596 | if (MatchingUmoData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-166343e9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4597 | if (MatchingUmoData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b000d3d5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4598 | if (MatchingUmoData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d191d15 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4599 | if (MatchingUmoData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d1903f0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4600 | if (MatchingUmoData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("PLAN_DT") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c521db8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4601 | if (MatchingUmoData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("SHIFT") | 데이터 객체 조작/조회 |  |  |  |
| AC-c30f705e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4596 | if (MatchingUmoData.Count() > 0) ▸ lambda | RETURN | return (x.Field<string>("FACTORY_ID") == row["FACTORY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-c22bac2e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4623 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.lfn_setExchangeRoll

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sColumnName.IndexOf("_SHIFT_") >= 0) ▸ if (sCateID.Equals("P_OUT")) ▸ if (dsMainFiltered.Good()) ▸ if (measure["chk_roll"].Value == "true")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-400a9dc1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4518 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f687a727 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4519 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-03e2e295 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4518 | lambda | RETURN | return (x.Field<string>("FACTORY_ID") == row["FACTORY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-d22181a1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4542 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.lfn_setReleaseProcess

진입점: popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.usrButton6.Click [if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.usrButton5.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85a1fb08 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1256 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f0ee9d81 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1270 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ if (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCurrDate… | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-05966270 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1272 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ else of (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCur… | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-7a37f175 | popSql.OnSql [if (programID == "PR_UI_FP02842_EXCEL_SELECT_C… 외 8 | FP02842_PlanAmend_Elec_Post_Shift.cs:1276 |  | RETURN | return dtMapData; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.MakeMemoFontBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-269d5425 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1576 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-8b08f8d2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1580 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |
| AC-6de3289c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1591 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-305b7ea9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1595 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-042c1338 | memo_menu.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3707 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b321fa0 | memo_menu.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3710 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8787c964 | memo_menu.Click | FP02842_PlanAmend_Elec_Post_Shift.cs:3714 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a8fe380 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3725 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c689fced | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3728 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72924ae7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3746 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-3d20d2d2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3747 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4559d0b1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3748 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bde5af61 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3749 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-be5d1072 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3750 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-149cfe6f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3751 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-2cae71ab | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3752 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ae3d793e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3753 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dfec0b1b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3754 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-291d9e6a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3446 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b1dfd14 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3449 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.onZeroLineMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aec552c8 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3503 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3bd4412b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3506 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75a0287e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3557 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4851a7a8 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3612 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b53e18e | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3615 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7a60b1f | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:3660 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-533275b0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6981 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-b78e7ad1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6981 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e67306f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6983 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-5545721b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6984 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-2bdd1ee3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6984 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2d4e6b43 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6985 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-62a991c8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6986 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2584c949 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6987 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9b28e7fd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6991 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a84df876 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6993 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-82ea2e65 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6998 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c681c71f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6941 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-414ee951 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6942 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-84e29b88 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6943 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-5b2cf900 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6943 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-270e22f3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6944 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-84993fd1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6945 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-aee7b6b4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6946 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-96607c32 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6950 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ed2bf64f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6952 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa860156 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6958 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-6bccec66 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6959 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-5ab4094f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6960 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-3d1e811e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6960 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3e0cd2bc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6961 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-d437279d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6962 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9f27544f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6963 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-905e360b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6967 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-101ed312 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6969 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.planday_changed

진입점: drpPlanDate.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1584c86 | drpPlanDate.DateTimeChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2333 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2590167f | drpPlanDate.DateTimeChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2335 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | VALUE_SET | drpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-b2239f9f | drpPlanDate.DateTimeChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2337 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | VALUE_SET | drpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-d5b10ba6 | drpPlanDate.DateTimeChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:2344 | else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Query

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d466e93 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6320 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-7e4fb538 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6320 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8540a2d3 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6321 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1283dc21 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6326 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-4a9757b5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6349 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-6062f027 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6355 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-0f9cf1dd | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6355 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-48217c04 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6356 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-723073a0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6356 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8000e167 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6359 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-a39aaf26 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6366 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-c176007d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6371 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c42bf55 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6372 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e1a6704 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:6374 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.rdo_uom_SelectedIndexChanged

진입점: this.rdo_uom.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c377612a | this.rdo_uom.SelectedIndexChanged | FP02842_PlanAmend_Elec_Post_Shift.cs:6571 |  | DATA_OP | Filter["UOM"] | radioGroup.Text | 행/컬럼 값 대입 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.RefreshHeadAndBody

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02df2c82 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6152 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6c6f6295 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6167 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-b2c1f3e7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6171 | finally | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cc7d8eba | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6172 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a21eca2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6125 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9c7cb66 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6125 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-8d92dca5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6132 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-e71ef0d9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6137 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.RoundValue

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sColumnName.IndexOf("_SHIFT_") >= 0) ▸ if (sCateID.Equals("P_OUT"))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ce098af | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6726 | if (_RoundPoint < 1 \|\| _RoundPoint > 11) | FLAG | _RoundPoint | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-5d8e1817 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6727 | if (_RoundPoint < 1 \|\| _RoundPoint > 11) | FLAG | _RoundTen | 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-9438a120 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6731 | try | CALL_EXT | Math.Truncate | ((double)((decimal)ori * (decimal)_RoundTen)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe347291 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6732 | try | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-cd6d85ec | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6735 |  | RETURN | return ori; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a895920 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4759 | if (programID == "PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-f926cb73 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4764 | if (programID == "PR_UI_FP02842_SAVE_VALID_SELECT") | RETURN | return Find_Save_Valid("SQL", "FIND_AMEND_VALIDATION_PMIX"); |  | 처리 중단/반환 |  |  |  |
| AC-06ec4578 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4776 | if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("there can't Veiw Query[Relase].") | 메시지 표시 |  |  |  |
| AC-dbb18a62 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4777 | if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-dcea9944 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4781 | if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | dtData.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-72d64386 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4783 | if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return Save_Data_Amend(dtSaveTmp, "MERGE_DATA", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-daffb730 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4788 | if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("there is no Edit Value of Plan(Out).") | 메시지 표시 |  |  |  |
| AC-907725c7 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4789 | if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-cdd58030 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4794 | if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸ else of (dtData != null) | MESSAGE | MessageBox.Show | ("there is no Edit Value of of Plan(Out).") | 메시지 표시 |  |  |  |
| AC-5ff3b1ad | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4795 | if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸ else of (dtData != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-30d77338 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4806 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE") | POPUP | new FP00607_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ece77999 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4810 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.DateColumnType | FPExtensions.DateColumnType.CELL | 속성 DateColumnType 설정 |  |  |  |
| AC-3e61e70a | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4812 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-e184169d | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4813 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-c08fa729 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4814 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-8b298bcd | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4816 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-e0a67a2c | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4823 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP02842_AMEND_LINE_EXCEL", Filter,… |  | 처리 중단/반환 |  |  |  |
| AC-28e16231 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4835 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_ROWTYPE") | POPUP | new FP00607_RowExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-faacd715 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4840 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-922c093f | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4841 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-12500ed9 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4842 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-81790ba7 | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4844 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-3145d29a | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4850 | if (programID == "PR_UI_FP02842_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP02842_AMEND_LINE_EXCEL", Filter,… |  | 처리 중단/반환 |  |  |  |
| AC-d1a75bbb | popSql.OnSql | FP02842_PlanAmend_Elec_Post_Shift.cs:4856 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Save_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE")] / SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8db4c698 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2139 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02842_AMEND_SAVE") ⇒ FP_Planning.PR_UI_FP02842_AMEND_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-78e01990 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2140 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9853a0c0 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2142 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-1d63cd82 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2143 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-66f873c6 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2144 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-9506afeb | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2145 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-50a8bee3 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2146 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-8c1342cc | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2147 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-53def822 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2148 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-e0413595 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2149 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-895a6a48 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2150 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-2842c6ab | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2151 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-07f10cec | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2152 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-85c25876 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2153 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-400d01bc | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2154 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-78c70b97 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2155 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-7de749cb | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2156 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-73873be2 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2157 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_equipment_id"] | p_equipment_id | 행/컬럼 값 대입 |  |  |  |
| AC-0e3c6aa5 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2158 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-b7ca0904 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2159 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shift"] | p_shift | 행/컬럼 값 대입 |  |  |  |
| AC-bf7c3ec9 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2160 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_jr_out_qty"] | p_jr_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-2a68d760 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2161 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pc_out_qty"] | p_pc_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-c93f06af | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2162 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-f8e74908 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2164 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d0c7d1e8 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2165 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4d21f720 | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2170 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-231e43ca | popSql.OnSql [if (programID == "PR_UI_FP02842_AMEND_SAVE") ▸… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:2175 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Save_Data_Excel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26185408 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5555 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-a75ecf8c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5556 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-623b15d3 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5558 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-58427fcc | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5559 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d6b44618 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5560 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-7343085c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5561 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b62f8fc5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5562 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-49f003aa | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5563 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ebd03ca1 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5564 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65091467 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5565 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a21edbee | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5566 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-afdc2014 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5567 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | pMppWpp | 행/컬럼 값 대입 |  |  |  |
| AC-8dc2be7b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5569 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-26d6f4a0 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5571 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-4cea3d2a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5576 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-d6ba26c4 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5578 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Save_Data_Excel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62dfc855 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5614 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP02842_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-ee999301 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5615 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-454361d5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5617 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-09aa2598 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5618 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0f52144b | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5619 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-91c805a8 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5620 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d7dfff8a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5621 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-99fd3eb2 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5622 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2903d708 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5623 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-66df1770 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5624 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3666b0e3 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5625 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-92a0a9f7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5626 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-979addea | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5628 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3bb04d43 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5630 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-a717a8b9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5635 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-8af61d92 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5637 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.Save_PIn_Data

진입점: SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70a4156b | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1805 | if (siMain == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-89dc3922 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1807 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b44553b0 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1812 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4fc34d59 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1813 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3a6a8e56 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1818 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-97171a05 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1829 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e2da9bb9 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1842 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b370a996 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1843 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-af0616e5 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1846 | try | CALL_EXT | dtData.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd133657 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1887 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("It can not be PLAN_TYPE[RELEASE]", "FP", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-65fd4400 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1888 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d46d8411 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1895 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6dad801a | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1926 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-52fa8e32 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1927 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-7ee099f5 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1933 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9b73ab0e | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1936 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f9c1d205 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1938 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-4ff254c6 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1942 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-faceb97a | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1943 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d240b10e | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1944 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-94d07c41 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1945 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0b6707d4 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1949 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-908a80c7 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP02842_PlanAmend_Elec_Post_Shift.cs:1950 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d7035fe | SaveButton | FP02842_PlanAmend_Elec_Post_Shift.cs:924 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dab289d0 | SaveButton | FP02842_PlanAmend_Elec_Post_Shift.cs:925 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-38098742 | SaveButton | FP02842_PlanAmend_Elec_Post_Shift.cs:947 | try ▸ if (dsListData != null) ▸ catch ((Exception)) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ac18f8f7 | SaveButton | FP02842_PlanAmend_Elec_Post_Shift.cs:948 | try ▸ if (dsListData != null) ▸ catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-37930337 | SaveButton | FP02842_PlanAmend_Elec_Post_Shift.cs:983 | try ▸ if (bSaveChk == true) | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-2c682926 | SaveButton | FP02842_PlanAmend_Elec_Post_Shift.cs:984 | try ▸ if (bSaveChk == true) | STATE_RESET | dsListData.Tables[0].Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e22b8876 | SaveButton | FP02842_PlanAmend_Elec_Post_Shift.cs:994 | try ▸ if (!string.IsNullOrEmpty(sMsg)) | MESSAGE | MessageBox.Show | (sMsg + " Is Saved.! ") | 메시지 표시 |  |  |  |
| AC-066af3a6 | SaveButton | FP02842_PlanAmend_Elec_Post_Shift.cs:1001 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-abc132a8 | SaveButton | FP02842_PlanAmend_Elec_Post_Shift.cs:1003 |  | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SearchListInfoAll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca03a24a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4997 |  | FLAG | dtDimension | siMain.GetSpdTitle(sProgramID, sUserID, sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-49d558cf | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4997 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3584c28a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5000 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "UOM_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d1306b73 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5001 |  | FLAG | dsUomInfoAll | dtUomAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-422b75e5 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:5001 |  | DATA_OP | dtUomAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetAmendHeaderColumn_FP_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e1400b8 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:485 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-0400155d | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:491 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d4ea2f6 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:494 | if (!dtSheetColumnConfig.Good()) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-87efc95d | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:495 | if (!dtSheetColumnConfig.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-902915de | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:514 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasur… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8832393c | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:515 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasur… | CALL_EXT | MenuService.SetMenuColumn | (dateRowWeek, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = _… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b66e6ede | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:525 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasur… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowWeek) | 데이터 객체 조작/조회 |  |  |  |
| AC-04927131 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:526 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasur… | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-4d66048c | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:539 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dfca8873 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:540 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | CALL_EXT | MenuService.SetMenuColumn | (dateRwoDay, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = _s… | ⚠ 의미 확인 필요 |  |  |  |
| AC-565e03a0 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:551 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRwoDay) | 데이터 객체 조작/조회 |  |  |  |
| AC-46ca3731 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:552 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-4e239562 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:573 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMe… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6c0c958d | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:574 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMe… | CALL_EXT | MenuService.SetMenuColumn | (dateRowmonth, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = … | ⚠ 의미 확인 필요 |  |  |  |
| AC-1dc56e0f | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:585 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMe… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowmonth) | 데이터 객체 조작/조회 |  |  |  |
| AC-4761de01 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:586 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMe… | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-23fc05f7 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:595 | if (dtSheetColumnConfig.Rows.Count == 0) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-beccca76 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:596 | if (dtSheetColumnConfig.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6364d66 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:599 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, iColumnHeaderRowCount, dtSheetColumnConfig) | 그리드 재구성/초기화 |  |  |  |
| AC-f778f11a | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:600 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetBasisTime

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / drpPlanDate.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.cbo_fpplanid.DropDown / this.usrButton6.Click [if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK)] / this.usrButton5.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d494317 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3790 |  | FLAG | dtBaseTime | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findBasisTime", sInstance,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-81bbe4df | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3790 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findBasisTime", sInstance, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetBohTotalQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f49e1ae7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1769 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3c1fd91d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1774 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-6aaca9e3 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1779 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a709f141 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1780 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c820913c | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1781 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-08b87216 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1782 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8cdfe02d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1783 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a69f4932 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1784 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-86db3646 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1785 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0057fef9 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1786 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-11ab8a4d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:1790 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetCalendarFormat

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (siMain != null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (siMain != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadN…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ea74f45 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6633 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ if (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ffabbae | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6636 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ else of (omitZ… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7c60fcd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6668 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ if (omitZero… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a0d4a20 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6671 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ else of (omi… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b3cd100 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6704 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ if (omitZe… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc4abe25 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6707 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ else of (o… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetCalenderColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d1364bf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6483 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-334b5874 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6487 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-6be68abf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6491 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-de6cc9b0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6494 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1557ab1a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6498 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-157c74f1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6501 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-9bee8f3a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6522 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week != null) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-86a9a0b0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6525 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week != null) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-e2c918a0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6545 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month != null) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Mo… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-240d6564 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6548 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month != null) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Mo… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetColMerge

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07679848 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6382 |  | FLAG | sv | siMain.ActiveSheet | 화면 필드/플래그 변경 |  |  |  |
| AC-461abcbc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6394 | if (measure["chk_Shift_1"].Value.Equals("true") && measure["chk_Shift_2"].Value.Equals("true")) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d9a55e4a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6406 | if (measure["chk_Shift_1"].Value.Equals("true") && measure["chk_Shift_2"].Value.Equals("true")) ▸ for (j < sv.RowCount) ▸ if (sCateVal == "T… | GRID_SET | sv.Cells[j, i].ColumnSpan | 2 | 그리드 속성/값 설정 |  |  |  |
| AC-84fc7510 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6411 | if (measure["chk_Shift_1"].Value.Equals("true") && measure["chk_Shift_2"].Value.Equals("true")) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetColumnChangeByText

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8404f5fc | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:637 | if (iColMinStartIndex <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bdbd4e62 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:642 | try | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-dcf4c177 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:644 | try | FLAG | DateCellType | new FarPoint.Win.Spread.CellType.DateTimeCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-8f1ee57a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:646 | try | FLAG | MaskcellType | new FarPoint.Win.Spread.CellType.MaskCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-5833345a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:647 | try | UI_PROP | MaskcellType.Mask | "####-##-##" | 속성 Mask 설정 |  |  |  |
| AC-f76a946d | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:651 | try | UI_PROP | DateCellType.DateTimeFormat | FarPoint.Win.Spread.CellType.DateTimeFormat.UserDefined | 속성 DateTimeFormat 설정 |  |  |  |
| AC-1f94b339 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:652 | try | UI_PROP | DateCellType.UserDefinedFormat | "yyyy-MM-dd" | 속성 UserDefinedFormat 설정 |  |  |  |
| AC-7cd60037 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:662 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e03aa15a | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:664 | try | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-1bc12f46 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:682 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k,i].CellType | MaskcellType | 그리드 속성/값 설정 |  |  |  |
| AC-1454be54 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:684 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].Value | sData | 그리드 속성/값 설정 |  |  |  |
| AC-7cc9df49 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:688 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-0ababb89 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:689 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-f56bfef7 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:698 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetColumnsFormat

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-434f2462 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6580 | if (siMain != null) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9cf5d26 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:253 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d65415f5 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:255 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-211d48f6 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:259 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-c2e87d6d | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:261 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-8d7be2fc | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:262 |  | CALL_EXT | UserService.HasSuperRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-92d1ff15 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:264 | if (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-b4125a56 | this.Load | FP02842_PlanAmend_Elec_Post_Shift.cs:268 | else of (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetDirty

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / this.usrButton6.Click [if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.Dial…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8ee52e6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:4154 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetDivision

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b433f16 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3800 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-95365bc0 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3800 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5ab14b74 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3801 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetFactory

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / cbo_fpplanid.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8582901 | this.Load [try] 외 3 | FP02842_PlanAmend_Elec_Post_Shift.cs:4000 |  | FLAG | dtFactoryAmend | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findFactoryCode_amend_common", Fil… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-c911af80 | this.Load [try] 외 3 | FP02842_PlanAmend_Elec_Post_Shift.cs:4000 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findFactoryCode_amend_common", Filter["INSTANCE_ID"], Filter["PLAN_ID"] … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9342d749 | this.Load [try] 외 3 | FP02842_PlanAmend_Elec_Post_Shift.cs:4003 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (dtInstance.Good())] / mcbo_planner.SelectedIndexChanged / drpPlanDate.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / cbo_fpplanid.SelectedIndexChanged [if (cbo_fpplanid.Items.Count > 0)] / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / mcbo_line.SelectedIndexChanged / mcbo_prodtype.SelectedIndexChanged / txtItem.TextChanged / drpPeriod.ValueChanged / chk_allLine.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-116055f2 | this.Load [try] 외 25 | FP02842_PlanAmend_Elec_Post_Shift.cs:3771 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetFpPlanId

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / drpPlanDate.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.cbo_fpplanid.DropDown / this.usrButton6.Click [if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK)] / this.usrButton5.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4802206f | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3903 |  | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00621_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4ad99823 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3903 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00621_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fa94d508 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3904 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0a9abfd1 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3907 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-4832c72d | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3909 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | cbo_fpplanid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-9b641d35 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3940 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[0]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-c5b20aa7 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3941 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[0]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-22fc505e | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3942 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[0]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-2eb6a411 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3943 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[0]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-073ea0d3 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3944 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[0]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-ef88a8ee | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3946 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-58eda4b5 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3947 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-27701529 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3948 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-0866a205 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3949 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-eebb0631 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3950 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-da7b614f | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3964 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-335cfdc2 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3965 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-419270d8 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3966 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-6ce3f4e1 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3967 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-81d19198 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3968 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-ef28059e | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3970 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-40e593cd | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3971 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-83478352 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3972 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-d97ddb10 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3973 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-30376af8 | this.Load [try] 외 5 | FP02842_PlanAmend_Elec_Post_Shift.cs:3974 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetLine

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_planner.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / chk_allLine.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b60d1aa7 | this.Load [try] 외 4 | FP02842_PlanAmend_Elec_Post_Shift.cs:4034 |  | FLAG | dtLine | Data_FP.Common_FP(Data_FP.Type.LINE, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-b6298658 | this.Load [try] 외 4 | FP02842_PlanAmend_Elec_Post_Shift.cs:4034 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eebacf86 | this.Load [try] 외 4 | FP02842_PlanAmend_Elec_Post_Shift.cs:4044 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetNickName_LT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a9bad67 | (진입점 미연결) | FP02842_PlanAmend_Elec_Post_Shift.cs:4076 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetOperation

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / this.chk_includeSubOp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6116ebb | this.Load [try] 외 3 | FP02842_PlanAmend_Elec_Post_Shift.cs:4010 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, _CurrentUser, _sNonAuth, _sSaveAuth , Fil… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-cb76b454 | this.Load [try] 외 3 | FP02842_PlanAmend_Elec_Post_Shift.cs:4010 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3192c595 | this.Load [try] 외 3 | FP02842_PlanAmend_Elec_Post_Shift.cs:4019 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetPlanDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3913fa5 | this.Load [try] | FP02842_PlanAmend_Elec_Post_Shift.cs:3781 |  | VALUE_SET | drpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetPlanGroup

진입점: this.Load [try] / SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c2f2b0f | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3874 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findAmendInstanceList_common", lv_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ef4fb5cb | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3874 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findAmendInstanceList_common", lv_amendInstance, _sSaveAuth) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7a49b968 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3875 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetPlanInBatch_DataSet

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sColumnName.IndexOf("_SHIFT_") >= 0) ▸ if (sCateID.Equals("P_OUT"))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b99c083f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4191 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | nRoundVal | 그리드 속성/값 설정 |  |  |  |
| AC-859277ba | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4243 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-f3fe57f5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4244 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-678f385f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4245 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-cf531661 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4246 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-b83a5975 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4259 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d20931c4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4271 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "LIST_DATA") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ae47f6de | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4272 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | FLAG | dsListData | dtList2.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-0320faca | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4272 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | DATA_OP | dtList2.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0d1f4316 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4295 | if (dsMainFiltered.Good()) ▸ if (measure["chk_roll"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee715a44 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4296 | if (dsMainFiltered.Good()) ▸ if (measure["chk_roll"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c97646f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4297 | if (dsMainFiltered.Good()) ▸ if (measure["chk_roll"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c170381 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4298 | if (dsMainFiltered.Good()) ▸ if (measure["chk_roll"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-aab7abc4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4299 | if (dsMainFiltered.Good()) ▸ if (measure["chk_roll"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b32bf53 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4300 | if (dsMainFiltered.Good()) ▸ if (measure["chk_roll"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e81878c7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4301 | if (dsMainFiltered.Good()) ▸ if (measure["chk_roll"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-35390121 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4302 | if (dsMainFiltered.Good()) ▸ if (measure["chk_roll"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8deaf70 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4304 | if (dsMainFiltered.Good()) ▸ if (measure["chk_roll"].Value == "true") ▸ lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-5d50ed84 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4310 | if (dsMainFiltered.Good()) ▸ if (measure["chk_roll"].Value == "true") ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | related_row[sCol] | nOut_Roll | 행/컬럼 값 대입 |  |  |  |
| AC-4a2a5f6d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4326 | if (dsMainFiltered.Good()) ▸ if (measure["chk_load"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f19acb84 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4327 | if (dsMainFiltered.Good()) ▸ if (measure["chk_load"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ecf1a34 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4328 | if (dsMainFiltered.Good()) ▸ if (measure["chk_load"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-78010570 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4329 | if (dsMainFiltered.Good()) ▸ if (measure["chk_load"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-52fdc87f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4330 | if (dsMainFiltered.Good()) ▸ if (measure["chk_load"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-36ea205d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4331 | if (dsMainFiltered.Good()) ▸ if (measure["chk_load"].Value == "true") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9da09fd | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4326 | if (dsMainFiltered.Good()) ▸ if (measure["chk_load"].Value == "true") ▸ lambda | RETURN | return (x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &&… |  | 처리 중단/반환 |  |  |  |
| AC-73bf80bb | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4341 | if (dsMainFiltered.Good()) ▸ if (measure["chk_load"].Value == "true") ▸ foreach (DataRow related_row in MatchingLine) | DATA_OP | related_row[sTargetCol] | nLoad | 행/컬럼 값 대입 |  |  |  |
| AC-d13bdb62 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4350 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a03395bb | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4351 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3742e137 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4352 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-441a5722 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4353 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d22217b4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4354 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3305eb5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4355 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7302a9ec | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4357 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e13e946e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4358 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-64734422 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4359 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("SHIFT") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b3c4080 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4350 | if (dsMainFiltered.Good()) ▸ lambda | RETURN | return (x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &&… |  | 처리 중단/반환 |  |  |  |
| AC-950b80e9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4369 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["JR_OUT_QTY"] | Math.Round(Convert.ToDecimal(nOutValue)) | 행/컬럼 값 대입 |  |  |  |
| AC-30f93837 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4370 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["PC_OUT_QTY"] | Math.Round(Convert.ToDecimal(nOut_PC)) | 행/컬럼 값 대입 |  |  |  |
| AC-41e68b2a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4379 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4bbe2799 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4381 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-03a926da | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4382 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fc1cc70e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4383 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-072dd5ec | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4384 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9073f882 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4385 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5dc6299c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4386 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d839d835 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4387 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-25e95c43 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4388 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-55f8e5c0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4389 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ed1c43ef | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4390 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bbf896ce | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4391 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3cf63128 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4392 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["EQUIPMENT_ID"] | row["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c8d1727a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4393 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8cd3ce45 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4394 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SHIFT"] | sShiftValue | 행/컬럼 값 대입 |  |  |  |
| AC-2204b4e3 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4395 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8ff46e19 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4396 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["JR_OUT_QTY"] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-5cd612a9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4397 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PC_OUT_QTY"] | nOut_PC | 행/컬럼 값 대입 |  |  |  |
| AC-73c9ac40 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4402 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-f217ce23 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4405 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (dsListData == null) | FLAG | dsListData | dtList.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-871a11dd | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4408 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ else of (dsListData == null) | DATA_OP | dsListData.Tables["Table"].ImportRow | (dtList.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d489e00 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4424 | if (dsMainFiltered.Good()) ▸ if (measure["chk_total_d"].Value.Equals("true") && measure["chk_remain"].Value.Equals("true") && measure["chk_S… | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-560a0615 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4425 | if (dsMainFiltered.Good()) ▸ if (measure["chk_total_d"].Value.Equals("true") && measure["chk_remain"].Value.Equals("true") && measure["chk_S… | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c68adde | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4426 | if (dsMainFiltered.Good()) ▸ if (measure["chk_total_d"].Value.Equals("true") && measure["chk_remain"].Value.Equals("true") && measure["chk_S… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-22cef8ba | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4427 | if (dsMainFiltered.Good()) ▸ if (measure["chk_total_d"].Value.Equals("true") && measure["chk_remain"].Value.Equals("true") && measure["chk_S… | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed2dbb6e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4428 | if (dsMainFiltered.Good()) ▸ if (measure["chk_total_d"].Value.Equals("true") && measure["chk_remain"].Value.Equals("true") && measure["chk_S… | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-85629655 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4429 | if (dsMainFiltered.Good()) ▸ if (measure["chk_total_d"].Value.Equals("true") && measure["chk_remain"].Value.Equals("true") && measure["chk_S… | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-19a46a54 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4431 | if (dsMainFiltered.Good()) ▸ if (measure["chk_total_d"].Value.Equals("true") && measure["chk_remain"].Value.Equals("true") && measure["chk_S… | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-ff664705 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4444 | if (dsMainFiltered.Good()) ▸ if (measure["chk_total_d"].Value.Equals("true") && measure["chk_remain"].Value.Equals("true") && measure["chk_S… | DATA_OP | related_row[idx] | val | 행/컬럼 값 대입 |  |  |  |
| AC-7707b192 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4445 | if (dsMainFiltered.Good()) ▸ if (measure["chk_total_d"].Value.Equals("true") && measure["chk_remain"].Value.Equals("true") && measure["chk_S… | DATA_OP | related_row[idx + 1] | val | 행/컬럼 값 대입 |  |  |  |
| AC-c20bd735 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4450 | if (dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a5661cdf | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4451 | if (dsMainFiltered.Good()) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetPlanner

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b64d89b | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3813 |  | FLAG | dtPlanner | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findPlanner_List", sInstan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-e9a97191 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3813 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findPlanner_List", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-75a61800 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3815 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, mcbo_planner, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-6b84d2aa | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3825 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row[… | CALL_EXT | mcbo_planner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55bf5986 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3829 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of … | CALL_EXT | mcbo_planner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1d7a9733 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3845 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-c2ed5816 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3846 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-1435561b | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3850 | if (dtPlanner != null) ▸ else of (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-bc857590 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3851 | if (dtPlanner != null) ▸ else of (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-3ee65126 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3861 | if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner.Items.Count) ▸ if (mcbo_planner.Items[k].ToString() == sValueName.ToString()) | CALL_EXT | mcbo_planner.SetItemChecked | (k, true) | ⚠ 의미 확인 필요 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetPlanPeriod

진입점: this.Load [try] / drpPlanDate.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2c40ec3 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4102 |  | FLAG | dDefaultDatePeriod | Data_FP.CallGeneralProcedure2(("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELE… | 화면 필드/플래그 변경 |  |  |  |
| AC-456bde25 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4102 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "PLAN_PERIOD") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5662d018 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4107 |  | FLAG | dDefalultStartDate | DateTime.ParseExact(dDefaultDatePeriod.Rows[0]["START_DATE"].ToString(), "yyyyMMdd", Cultu… | 화면 필드/플래그 변경 |  |  |  |
| AC-e34d1922 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4108 |  | FLAG | dDefalultEndDate | DateTime.ParseExact(dDefaultDatePeriod.Rows[0]["END_DATE"].ToString(), "yyyyMMdd", Culture… | 화면 필드/플래그 변경 |  |  |  |
| AC-a3199aef | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4110 |  | UI_PROP | drpPeriod.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-d00e5fff | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4111 |  | UI_PROP | drpPeriod.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-2131e6bc | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4113 |  | DATA_OP | Filter["BUCKET_FROM"] | dDefaultDatePeriod.Rows[0]["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-77e7d1fb | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4114 |  | DATA_OP | Filter["BUCKET_TO"] | dDefaultDatePeriod.Rows[0]["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetPlant

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea8831c1 | this.Load [try] 외 3 | FP02842_PlanAmend_Elec_Post_Shift.cs:3989 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-4bdd228a | this.Load [try] 외 3 | FP02842_PlanAmend_Elec_Post_Shift.cs:3989 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5bd38cff | this.Load [try] 외 3 | FP02842_PlanAmend_Elec_Post_Shift.cs:3991 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetProdType

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94f36cfe | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4069 |  | FLAG | dtProdType | Data_FP.CallGeneralProcedure2(("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELE… | 화면 필드/플래그 변경 |  |  |  |
| AC-fdc6c512 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4069 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "PRODUCTION_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-28a2271e | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:4070 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prodtype, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetSite

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3079b7a1 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3982 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-d1a7f08b | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3982 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-32242f28 | this.Load [try] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:3983 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fcb2bd0 | this.Load [try] 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:479 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3ecbc67b | this.Load [try] 외 10 | FP02842_PlanAmend_Elec_Post_Shift.cs:480 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SetTotalColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51cceb10 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02842_PlanAmend_Elec_Post_Shift.cs:6456 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SheetChanged

진입점: dsdmAmend.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2aa2e0c2 | dsdmAmend.Changed | FP02842_PlanAmend_Elec_Post_Shift.cs:3390 | if (!this.CanModelChange \|\| e.Row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-299eede9 | this.spdMain.CellClick | FP02842_PlanAmend_Elec_Post_Shift.cs:4698 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9daf1ae2 | this.spdMain.CellClick | FP02842_PlanAmend_Elec_Post_Shift.cs:4720 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-388edfd4 | this.spdMain.CellClick | FP02842_PlanAmend_Elec_Post_Shift.cs:4721 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-660732fe | this.spdMain.CellClick | FP02842_PlanAmend_Elec_Post_Shift.cs:4723 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c5eaf71 | this.spdMain.CellClick | FP02842_PlanAmend_Elec_Post_Shift.cs:4744 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6dcbb01 | this.spdMain.CellDoubleClick | FP02842_PlanAmend_Elec_Post_Shift.cs:6792 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-1137aa6a | this.spdMain.CellDoubleClick | FP02842_PlanAmend_Elec_Post_Shift.cs:6799 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1768780 | this.spdMain.ClipboardPasted | FP02842_PlanAmend_Elec_Post_Shift.cs:3403 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7a8cd36 | this.spdMain.ClipboardPasted | FP02842_PlanAmend_Elec_Post_Shift.cs:3411 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0567f791 | this.spdMain.ClipboardPasted | FP02842_PlanAmend_Elec_Post_Shift.cs:3412 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ecc07fe5 | this.spdMain.ClipboardPasted | FP02842_PlanAmend_Elec_Post_Shift.cs:3414 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ece8ba28 | this.spdMain.ClipboardPasting | FP02842_PlanAmend_Elec_Post_Shift.cs:3421 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-d92d63a2 | this.spdMain.ClipboardPasting | FP02842_PlanAmend_Elec_Post_Shift.cs:3422 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-2002a704 | this.spdMain.ClipboardPasting | FP02842_PlanAmend_Elec_Post_Shift.cs:3422 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-95c1403d | this.spdMain.ClipboardPasting | FP02842_PlanAmend_Elec_Post_Shift.cs:3426 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd91f232 | this.spdMain.ClipboardPasting | FP02842_PlanAmend_Elec_Post_Shift.cs:3426 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a7270ef | this.spdMain.ClipboardPasting | FP02842_PlanAmend_Elec_Post_Shift.cs:3430 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-93503814 | this.spdMain.ClipboardPasting | FP02842_PlanAmend_Elec_Post_Shift.cs:3432 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07368bb3 | this.spdMain.EditModeOn | FP02842_PlanAmend_Elec_Post_Shift.cs:3242 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2cafe28 | this.spdMain.KeyDown | FP02842_PlanAmend_Elec_Post_Shift.cs:3180 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-04ed6f4e | this.spdMain.KeyDown | FP02842_PlanAmend_Elec_Post_Shift.cs:3184 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdc04131 | this.spdMain.KeyDown | FP02842_PlanAmend_Elec_Post_Shift.cs:3185 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.SwitchMemo

진입점: memo_menu.Click [if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea047777 | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6810 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19e6c787 | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6827 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-127cba6b | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6852 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb407179 | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6878 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-6efc6618 | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6880 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-38b39b25 | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6883 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c66b966 | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6885 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0f65980 | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6885 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-c08738c8 | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6886 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-60979a83 | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6888 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-930a7edf | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6890 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-22bf2a91 | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6902 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-52db7cb9 | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6902 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-1babb55a | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6922 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-45bdb34f | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6923 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-e5d902ef | memo_menu.Click [if (day != null)] 외 1 | FP02842_PlanAmend_Elec_Post_Shift.cs:6925 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02842_PlanAmend_Elec_Post_Shift.UIFindData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true)] / this.usrButton6.Click [if (sConfirmArea == "PLAN GROUP") ▸ if (popGroupTotal.DialogResult == DialogResult.OK)] / this.usrButton5.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.SelectedIndex < 0)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad &…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe4881d0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:717 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe945c3c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:718 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fa85457 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:721 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3a1ee3b7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:724 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-0ba18fac | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:729 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan ID to proceed") | 메시지 표시 |  |  |  |
| AC-fc54a1c9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:730 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5918fc2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:739 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | Filter2 | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-af00bb68 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:739 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a7047d9c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:754 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2fb57502 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:755 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05a27c02 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:758 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8758b850 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:761 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d305eb48 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:762 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-bf46387f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:765 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-2c175148 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:774 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ce396173 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:776 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-3069fa46 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:776 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6f8b0cc9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:790 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b06e6e8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:794 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_PROP | asyncProxy_ListData.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-564725df | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:795 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dsListData | await asyncProxy_ListData.ExecuteAsync<DataSet>(() => Data_FP.CallGeneralProcedure(("PR_UI… | 화면 필드/플래그 변경 |  |  |  |
| AC-9fa7f480 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:795 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | ENDPOINT | asyncProxy_ListData.ExecuteAsync | (() => Data_FP.CallGeneralProcedure(("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser,… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-71a91375 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:796 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ lamb… | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "LIST_DATA") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-20a2070d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:801 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_PROP | asyncProxy_UomInfo.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-da753a90 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:802 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dsUomInfo | await asyncProxy_UomInfo.ExecuteAsync<DataSet>(() => Data_FP.CallGeneralProcedure(("PR_UI_… | 화면 필드/플래그 변경 |  |  |  |
| AC-581532bf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:802 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | ENDPOINT | asyncProxy_UomInfo.ExecuteAsync | (() => Data_FP.CallGeneralProcedure(("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser,… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f0bbb80 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:803 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ lamb… | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "UOM_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ad5a4aae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:807 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_PROP | asyncProxy_RoleInfo.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-93ce088e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:808 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dsRoleInfo | await asyncProxy_RoleInfo.ExecuteAsync<DataSet>(() => Data_FP.CallGeneralProcedure(("PR_UI… | 화면 필드/플래그 변경 |  |  |  |
| AC-40ee3669 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:808 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | ENDPOINT | asyncProxy_RoleInfo.ExecuteAsync | (() => Data_FP.CallGeneralProcedure(("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser,… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-db8e3c3f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:809 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ lamb… | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "ROLL_DATA") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b217e042 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:813 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_PROP | asyncProxy_LoadInfo.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0102dccf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:814 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dsLoadInfo | await asyncProxy_LoadInfo.ExecuteAsync<DataSet>(() => Data_FP.CallGeneralProcedure(("PR_UI… | 화면 필드/플래그 변경 |  |  |  |
| AC-376e4704 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:814 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | ENDPOINT | asyncProxy_LoadInfo.ExecuteAsync | (() => Data_FP.CallGeneralProcedure(("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser,… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-12b17d6f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:815 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ lamb… | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "LOAD_DATA") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a2f3aa9c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:821 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-f641f0db | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:823 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7b1ff7ff | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:827 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-d8674c2e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:828 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-1ddd0737 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:830 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ad2c5fcb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:835 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-f1495c08 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:836 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-52d74909 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:837 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-a84196f3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:841 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd69a28c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:854 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ed5e04bf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:858 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-30737a6b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:862 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cb34e0bc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:864 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2c3d4778 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:868 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-24163382 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:879 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8f309a8a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:883 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-5cec7eb4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02842_PlanAmend_Elec_Post_Shift.cs:887 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02842_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d69df633 | .ctor | FP02842_RowExcelPopup.cs:164 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-079be054 | .ctor | FP02842_RowExcelPopup.cs:165 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP02842_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1fc915a | this.btnClose.Click | FP02842_RowExcelPopup.cs:916 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02842_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e73004f6 | this.btnDownload.Click | FP02842_RowExcelPopup.cs:824 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-4950fecf | this.btnDownload.Click | FP02842_RowExcelPopup.cs:825 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |
| AC-a21a43cd | this.btnDownload.Click | FP02842_RowExcelPopup.cs:827 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02842_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5d34a81 | this.btnFind.Click | FP02842_RowExcelPopup.cs:819 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02842_RowExcelPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62e2dfa9 | this.btnSave.Click | FP02842_RowExcelPopup.cs:911 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02842_RowExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51018e59 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:841 | if (bUpload) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b3aa9ea7 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:842 | if (bUpload) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a971eed2 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:844 | if (bUpload) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-31531b55 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:845 | if (bUpload) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-4774bb26 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:851 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | DATA_OP | dsSource.Tables[0].Columns.Contains | ("APPLIED_MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-99816331 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:854 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (!dsSource.Tables[0].Columns.Contains("APPLIED_MODEL")) | DATA_OP | dsSource.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-44e18a08 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:862 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f471ddae | this.btnUpload.Click | FP02842_RowExcelPopup.cs:863 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8739087b | this.btnUpload.Click | FP02842_RowExcelPopup.cs:864 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3aa3acd3 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:868 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | row["APPLIED_MODEL"] | UomResult.First()["VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ba1a072e | this.btnUpload.Click | FP02842_RowExcelPopup.cs:872 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | row["APPLIED_MODEL"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6c0180b5 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:889 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ for (iRow < dsSource.Ta… | GRID_SET | dsSource.Tables[0].Rows[iRow]["ADJUST_IN_QTY_KG"] | "" | 그리드 속성/값 설정 |  |  |  |
| AC-b48cd404 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:893 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ for (iRow < dsSource.Ta… | GRID_SET | dsSource.Tables[0].Rows[iRow]["ADJUST_IN_QTY_KG"] | rVal.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-c3b64a15 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:899 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-10145f0c | this.btnUpload.Click | FP02842_RowExcelPopup.cs:900 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-62ca201c | this.btnUpload.Click | FP02842_RowExcelPopup.cs:902 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02842_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-264dbbdb | this.Load | FP02842_RowExcelPopup.cs:254 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2f149351 | this.Load | FP02842_RowExcelPopup.cs:255 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a74e53c0 | this.Load | FP02842_RowExcelPopup.cs:256 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02842_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cb47676 | (진입점 미연결) | FP02842_RowExcelPopup.cs:747 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-18b6fba5 | (진입점 미연결) | FP02842_RowExcelPopup.cs:747 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP02842_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d171d7b5 | this.Load | FP02842_RowExcelPopup.cs:249 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02842_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e492a4c5 | Dispose | FP02842_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02842_RowExcelPopup.dtpPeriod_ValueChanged

진입점: this.dtpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45bc84bd | this.dtpPeriod.ValueChanged | FP02842_RowExcelPopup.cs:1025 | if (bFirst == true) | FLAG | bFirst | false | 화면 필드/플래그 변경 |  |  |  |
| AC-43ab563a | this.dtpPeriod.ValueChanged | FP02842_RowExcelPopup.cs:1026 | if (bFirst == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec48cbf4 | this.dtpPeriod.ValueChanged | FP02842_RowExcelPopup.cs:1040 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e40cbad5 | this.dtpPeriod.ValueChanged | FP02842_RowExcelPopup.cs:1042 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | VALUE_SET | dtpPeriod.InitValue | sStartDate + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-58b0686e | this.dtpPeriod.ValueChanged | FP02842_RowExcelPopup.cs:1043 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ecf29a6 | this.dtpPeriod.ValueChanged | FP02842_RowExcelPopup.cs:1048 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d17b4b8 | this.dtpPeriod.ValueChanged | FP02842_RowExcelPopup.cs:1056 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-02cd6363 | this.dtpPeriod.ValueChanged | FP02842_RowExcelPopup.cs:1058 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1cf964f5 | this.dtpPeriod.ValueChanged | FP02842_RowExcelPopup.cs:1061 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-842a9a82 | this.dtpPeriod.ValueChanged | FP02842_RowExcelPopup.cs:1062 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |

## FP02842_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2581d043 | (진입점 미연결) | FP02842_RowExcelPopup.cs:711 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP02842_RowExcelPopup.Exec_Procedure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30015343 | (진입점 미연결) | FP02842_RowExcelPopup.cs:763 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-e15f1c2e | (진입점 미연결) | FP02842_RowExcelPopup.cs:764 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7f19a0fc | (진입점 미연결) | FP02842_RowExcelPopup.cs:766 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-07aae21b | (진입점 미연결) | FP02842_RowExcelPopup.cs:767 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-f0cf150a | (진입점 미연결) | FP02842_RowExcelPopup.cs:768 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a96d1ebf | (진입점 미연결) | FP02842_RowExcelPopup.cs:769 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ef915e13 | (진입점 미연결) | FP02842_RowExcelPopup.cs:770 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-9386ddfc | (진입점 미연결) | FP02842_RowExcelPopup.cs:771 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9e13ac50 | (진입점 미연결) | FP02842_RowExcelPopup.cs:772 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-244f8a25 | (진입점 미연결) | FP02842_RowExcelPopup.cs:773 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-897ef3ca | (진입점 미연결) | FP02842_RowExcelPopup.cs:774 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-25ff3284 | (진입점 미연결) | FP02842_RowExcelPopup.cs:775 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3e8616dd | (진입점 미연결) | FP02842_RowExcelPopup.cs:776 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f45223a4 | (진입점 미연결) | FP02842_RowExcelPopup.cs:777 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8112e9fa | (진입점 미연결) | FP02842_RowExcelPopup.cs:778 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-340ee570 | (진입점 미연결) | FP02842_RowExcelPopup.cs:779 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7172855d | (진입점 미연결) | FP02842_RowExcelPopup.cs:780 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-42c4fbb8 | (진입점 미연결) | FP02842_RowExcelPopup.cs:781 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a0fb8ad1 | (진입점 미연결) | FP02842_RowExcelPopup.cs:782 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0f0a7cae | (진입점 미연결) | FP02842_RowExcelPopup.cs:783 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6b20e23c | (진입점 미연결) | FP02842_RowExcelPopup.cs:784 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c30dd4d5 | (진입점 미연결) | FP02842_RowExcelPopup.cs:785 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f821a3b | (진입점 미연결) | FP02842_RowExcelPopup.cs:786 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-989acc26 | (진입점 미연결) | FP02842_RowExcelPopup.cs:787 | try | DATA_OP | req.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f76c2868 | (진입점 미연결) | FP02842_RowExcelPopup.cs:788 | try | DATA_OP | req.Parameters["p_p_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cc1b79d7 | (진입점 미연결) | FP02842_RowExcelPopup.cs:789 | try | DATA_OP | req.Parameters["p_p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-46c59f4b | (진입점 미연결) | FP02842_RowExcelPopup.cs:790 | try | DATA_OP | req.Parameters["p_mpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fc16b483 | (진입점 미연결) | FP02842_RowExcelPopup.cs:791 | try | DATA_OP | req.Parameters["p_mpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fc1c4f15 | (진입점 미연결) | FP02842_RowExcelPopup.cs:792 | try | DATA_OP | req.Parameters["p_wpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa174a35 | (진입점 미연결) | FP02842_RowExcelPopup.cs:793 | try | DATA_OP | req.Parameters["p_wpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-66962f73 | (진입점 미연결) | FP02842_RowExcelPopup.cs:794 | try | DATA_OP | req.Parameters["p_boh_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3265f1cf | (진입점 미연결) | FP02842_RowExcelPopup.cs:796 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1247ea3f | (진입점 미연결) | FP02842_RowExcelPopup.cs:803 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-ce028ac3 | (진입점 미연결) | FP02842_RowExcelPopup.cs:807 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02842_RowExcelPopup.Find_Data

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-869ae4ea | this.Load 외 2 | FP02842_RowExcelPopup.cs:328 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2f3e8c9b | this.Load 외 2 | FP02842_RowExcelPopup.cs:334 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ef5d2e55 | this.Load 외 2 | FP02842_RowExcelPopup.cs:336 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc599676 | this.Load 외 2 | FP02842_RowExcelPopup.cs:341 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-89d9a35d | this.Load 외 2 | FP02842_RowExcelPopup.cs:342 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43c477dd | this.Load 외 2 | FP02842_RowExcelPopup.cs:345 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-f758c35b | this.Load 외 2 | FP02842_RowExcelPopup.cs:346 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-2189eff1 | this.Load 외 2 | FP02842_RowExcelPopup.cs:348 |  | DATA_OP | Filter["BUCKET_FROM"] | _BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-9c49bfcd | this.Load 외 2 | FP02842_RowExcelPopup.cs:349 |  | DATA_OP | Filter["BUCKET_TO"] | _BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-8c241ceb | this.Load 외 2 | FP02842_RowExcelPopup.cs:352 |  | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ee6ca3ff | this.Load 외 2 | FP02842_RowExcelPopup.cs:355 | if (OnSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8424b3a5 | this.Load 외 2 | FP02842_RowExcelPopup.cs:356 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-25ad3d61 | this.Load 외 2 | FP02842_RowExcelPopup.cs:356 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1b982bc | this.Load 외 2 | FP02842_RowExcelPopup.cs:360 | if (OnSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-445f60b5 | this.Load 외 2 | FP02842_RowExcelPopup.cs:361 | if (OnSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c81ca5a5 | this.Load 외 2 | FP02842_RowExcelPopup.cs:363 | if (OnSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-08c3b127 | this.Load 외 2 | FP02842_RowExcelPopup.cs:364 | if (OnSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bcb61593 | this.Load 외 2 | FP02842_RowExcelPopup.cs:365 | if (OnSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-326e08e6 | this.Load 외 2 | FP02842_RowExcelPopup.cs:366 | if (OnSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-09ea21d2 | this.Load 외 2 | FP02842_RowExcelPopup.cs:367 | if (OnSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6704e23a | this.Load 외 2 | FP02842_RowExcelPopup.cs:368 | if (OnSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7e3ca805 | this.Load 외 2 | FP02842_RowExcelPopup.cs:369 | if (OnSearchData != null) | STATE | this.dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7103c8cd | this.Load 외 2 | FP02842_RowExcelPopup.cs:375 | if (OnSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-671aa3d4 | this.Load 외 2 | FP02842_RowExcelPopup.cs:378 | if (OnSearchData != null) ▸ try | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4acaa67 | this.Load 외 2 | FP02842_RowExcelPopup.cs:380 | if (OnSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-906dbb9f | this.Load 외 2 | FP02842_RowExcelPopup.cs:382 | if (OnSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar,set,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e79a085b | this.Load 외 2 | FP02842_RowExcelPopup.cs:387 | if (OnSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-ab28b79c | this.Load 외 2 | FP02842_RowExcelPopup.cs:387 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, null, 1, IgnoreColumnsNotInTi… | 그리드 재구성/초기화 |  |  |  |
| AC-8b7d47a3 | this.Load 외 2 | FP02842_RowExcelPopup.cs:392 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-79ebbd29 | this.Load 외 2 | FP02842_RowExcelPopup.cs:393 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-e90a4e9e | this.Load 외 2 | FP02842_RowExcelPopup.cs:394 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-5d5e6fa9 | this.Load 외 2 | FP02842_RowExcelPopup.cs:399 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a0b1ea6 | this.Load 외 2 | FP02842_RowExcelPopup.cs:400 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1146f9f | this.Load 외 2 | FP02842_RowExcelPopup.cs:405 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-53bb6a8c | this.Load 외 2 | FP02842_RowExcelPopup.cs:406 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-63359cb5 | this.Load 외 2 | FP02842_RowExcelPopup.cs:417 | if (OnSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e9b5c3d | this.Load 외 2 | FP02842_RowExcelPopup.cs:420 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bd561b5d | this.Load 외 2 | FP02842_RowExcelPopup.cs:421 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2c620f8d | this.Load 외 2 | FP02842_RowExcelPopup.cs:422 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3105ac29 | this.Load 외 2 | FP02842_RowExcelPopup.cs:423 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-170d3259 | this.Load 외 2 | FP02842_RowExcelPopup.cs:424 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-373cd0fb | this.Load 외 2 | FP02842_RowExcelPopup.cs:425 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-474b9ea8 | this.Load 외 2 | FP02842_RowExcelPopup.cs:426 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02842_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b0d4280 | FindButton | FP02842_RowExcelPopup.cs:296 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-85f72b30 | FindButton | FP02842_RowExcelPopup.cs:297 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e80e916f | FindButton | FP02842_RowExcelPopup.cs:299 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02842_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97ac9958 | this.Load | FP02842_RowExcelPopup.cs:173 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4e8978bd | this.Load | FP02842_RowExcelPopup.cs:175 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02842_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a175609 | (진입점 미연결) | FP02842_RowExcelPopup.cs:685 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-1bec026b | (진입점 미연결) | FP02842_RowExcelPopup.cs:686 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-8b043a61 | (진입점 미연결) | FP02842_RowExcelPopup.cs:687 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-75d241b5 | (진입점 미연결) | FP02842_RowExcelPopup.cs:688 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-e79ee1c2 | (진입점 미연결) | FP02842_RowExcelPopup.cs:689 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-c7a4bc42 | (진입점 미연결) | FP02842_RowExcelPopup.cs:690 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-9e3c9af4 | (진입점 미연결) | FP02842_RowExcelPopup.cs:691 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ed24115e | (진입점 미연결) | FP02842_RowExcelPopup.cs:693 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-e8a4d135 | (진입점 미연결) | FP02842_RowExcelPopup.cs:694 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-7d2c84ac | (진입점 미연결) | FP02842_RowExcelPopup.cs:698 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-049a8ac0 | (진입점 미연결) | FP02842_RowExcelPopup.cs:699 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP02842_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74c7f815 | this.Load | FP02842_RowExcelPopup.cs:208 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_FROM"].ToString()) < Convert.ToDecimal(thi… | DATA_OP | Filter["BUCKET_FROM"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d3efb00d | this.Load | FP02842_RowExcelPopup.cs:212 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a09ea54b | this.Load | FP02842_RowExcelPopup.cs:213 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | sEndDay | 행/컬럼 값 대입 |  |  |  |
| AC-63ee7567 | this.Load | FP02842_RowExcelPopup.cs:216 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | Filter["BUCKET_FROM"] | 화면 필드/플래그 변경 |  |  |  |
| AC-619bee6e | this.Load | FP02842_RowExcelPopup.cs:217 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | Filter["BUCKET_TO"] | 화면 필드/플래그 변경 |  |  |  |
| AC-f417a85d | this.Load | FP02842_RowExcelPopup.cs:218 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | _BucketFromDate.ToString() + ":" + _BucketToDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-10767b40 | this.Load | FP02842_RowExcelPopup.cs:222 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f5850427 | this.Load | FP02842_RowExcelPopup.cs:226 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-1778b8d4 | this.Load | FP02842_RowExcelPopup.cs:228 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-02b11d97 | this.Load | FP02842_RowExcelPopup.cs:229 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-dc00758a | this.Load | FP02842_RowExcelPopup.cs:243 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |

## FP02842_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44dcaaba | this.Load | FP02842_RowExcelPopup.cs:266 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b790489b | this.Load | FP02842_RowExcelPopup.cs:267 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02842_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd5a7526 | (진입점 미연결) | FP02842_RowExcelPopup.cs:287 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02842_RowExcelPopup.lfn_setExchangeBatch_Excel

진입점: this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ for (iRow < dsSource.Tables[0].Rows.Count) ▸ if (!string.IsNullOrEmpty(dsSource.Tables[0].Rows[iRow]["QTY"].ToString()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-304ca674 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:947 | lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f48d7e6a | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:961 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-b51f93a2 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:968 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6b46849e | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:969 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ded5ee6 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:970 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-de5123be | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:971 | lambda | DATA_OP | each_row.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb24f853 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:988 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a31510d | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:989 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8763bdf4 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:990 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8be05be9 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:991 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec241e73 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:992 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-458d3084 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:993 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-322aea35 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:993 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0ffe8a0 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP02842_RowExcelPopup.cs:1011 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP02842_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9202a33a | this.btnUpload.Click | FP02842_RowExcelPopup.cs:719 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-fef2e03c | this.btnUpload.Click | FP02842_RowExcelPopup.cs:719 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-75552da9 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:721 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-271d0bcb | this.btnUpload.Click | FP02842_RowExcelPopup.cs:722 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c6ef4cd8 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:723 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-486cc115 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:725 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-df1b6e3f | this.btnUpload.Click | FP02842_RowExcelPopup.cs:727 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-23142311 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:728 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-3e596cfd | this.btnUpload.Click | FP02842_RowExcelPopup.cs:728 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-5912bf30 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:735 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-57553879 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:736 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-885940c7 | this.btnUpload.Click | FP02842_RowExcelPopup.cs:738 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02842_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75f1f65e | this.btnSave.Click | FP02842_RowExcelPopup.cs:456 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-969f1b21 | this.btnSave.Click | FP02842_RowExcelPopup.cs:457 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-abbc1811 | this.btnSave.Click | FP02842_RowExcelPopup.cs:461 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix! After once seach, Try agagin.!") | 메시지 표시 |  |  |  |
| AC-5bd79583 | this.btnSave.Click | FP02842_RowExcelPopup.cs:462 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc2b143f | this.btnSave.Click | FP02842_RowExcelPopup.cs:473 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].Rows[i]["MESSAGE"].ToString().Equals("Y")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c1368290 | this.btnSave.Click | FP02842_RowExcelPopup.cs:474 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].Rows[i]["MESSAGE"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6b6e038 | this.btnSave.Click | FP02842_RowExcelPopup.cs:478 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-58c43337 | this.btnSave.Click | FP02842_RowExcelPopup.cs:478 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-90efa7a3 | this.btnSave.Click | FP02842_RowExcelPopup.cs:483 | if (OnBeforeCheckData != null) | CALL_BASE | OnBeforeCheckData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e67d294 | this.btnSave.Click | FP02842_RowExcelPopup.cs:485 | if (OnBeforeCheckData != null) ▸ if (bCheck == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd81bd3d | this.btnSave.Click | FP02842_RowExcelPopup.cs:494 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b3e67919 | this.btnSave.Click | FP02842_RowExcelPopup.cs:495 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b6b94752 | this.btnSave.Click | FP02842_RowExcelPopup.cs:496 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a85bb2f6 | this.btnSave.Click | FP02842_RowExcelPopup.cs:497 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5276d3a8 | this.btnSave.Click | FP02842_RowExcelPopup.cs:498 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a3490976 | this.btnSave.Click | FP02842_RowExcelPopup.cs:499 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-085a721e | this.btnSave.Click | FP02842_RowExcelPopup.cs:507 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-b23565c2 | this.btnSave.Click | FP02842_RowExcelPopup.cs:508 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9e6d186b | this.btnSave.Click | FP02842_RowExcelPopup.cs:509 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7d6a3da8 | this.btnSave.Click | FP02842_RowExcelPopup.cs:510 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-acc84360 | this.btnSave.Click | FP02842_RowExcelPopup.cs:511 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8f6023b0 | this.btnSave.Click | FP02842_RowExcelPopup.cs:512 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f7369db8 | this.btnSave.Click | FP02842_RowExcelPopup.cs:513 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-afdd5264 | this.btnSave.Click | FP02842_RowExcelPopup.cs:514 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-216d92c4 | this.btnSave.Click | FP02842_RowExcelPopup.cs:519 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc67dc6f | this.btnSave.Click | FP02842_RowExcelPopup.cs:522 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd91ef94 | this.btnSave.Click | FP02842_RowExcelPopup.cs:524 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-43dd8fb4 | this.btnSave.Click | FP02842_RowExcelPopup.cs:527 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-30b196e7 | this.btnSave.Click | FP02842_RowExcelPopup.cs:532 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-545a08b5 | this.btnSave.Click | FP02842_RowExcelPopup.cs:533 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-70e991b3 | this.btnSave.Click | FP02842_RowExcelPopup.cs:540 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-274178a8 | this.btnSave.Click | FP02842_RowExcelPopup.cs:543 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-567ac36f | this.btnSave.Click | FP02842_RowExcelPopup.cs:559 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (dsValidation != null) ▸ if (dsValidation.Tables.Count > 0) ▸ if… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-f6e622f6 | this.btnSave.Click | FP02842_RowExcelPopup.cs:562 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (dsValidation != null) ▸ if (dsValidation.Tables.Count > 0) ▸ if… | POPUP | new Planning.UIL.FP00594_InValidationExcelPopup | ("InvalidExcelPopup", dsValidation, "") | 팝업/폼 생성 |  |  |  |
| AC-78157643 | this.btnSave.Click | FP02842_RowExcelPopup.cs:563 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (dsValidation != null) ▸ if (dsValidation.Tables.Count > 0) ▸ if… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c1cb1449 | this.btnSave.Click | FP02842_RowExcelPopup.cs:564 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (dsValidation != null) ▸ if (dsValidation.Tables.Count > 0) ▸ if… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fee68065 | this.btnSave.Click | FP02842_RowExcelPopup.cs:588 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a9afb1e | this.btnSave.Click | FP02842_RowExcelPopup.cs:599 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44c998f2 | this.btnSave.Click | FP02842_RowExcelPopup.cs:602 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | FLAG | bUploadSaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8be3bf61 | this.btnSave.Click | FP02842_RowExcelPopup.cs:603 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-0f51b672 | this.btnSave.Click | FP02842_RowExcelPopup.cs:608 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-e0eed944 | this.btnSave.Click | FP02842_RowExcelPopup.cs:609 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b531d655 | this.btnSave.Click | FP02842_RowExcelPopup.cs:615 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-62617de2 | this.btnSave.Click | FP02842_RowExcelPopup.cs:652 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-c910773e | this.btnSave.Click | FP02842_RowExcelPopup.cs:654 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-69f9da6f | this.btnSave.Click | FP02842_RowExcelPopup.cs:655 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7e4a5368 | this.btnSave.Click | FP02842_RowExcelPopup.cs:665 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-14be9f6e | this.btnSave.Click | FP02842_RowExcelPopup.cs:666 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-5395f869 | this.btnSave.Click | FP02842_RowExcelPopup.cs:670 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e01a6f15 | this.btnSave.Click | FP02842_RowExcelPopup.cs:671 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cbad9de9 | this.btnSave.Click | FP02842_RowExcelPopup.cs:672 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d46d4577 | this.btnSave.Click | FP02842_RowExcelPopup.cs:673 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-180bc4fb | this.btnSave.Click | FP02842_RowExcelPopup.cs:674 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f11e3587 | this.btnSave.Click | FP02842_RowExcelPopup.cs:675 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02842_RowExcelPopup.SearchListInfoAll

진입점: this.btnUpload.Click [if (bUpload)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f7ebf71 | this.btnUpload.Click [if (bUpload)] | FP02842_RowExcelPopup.cs:925 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bddc2a65 | this.btnUpload.Click [if (bUpload)] | FP02842_RowExcelPopup.cs:926 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-833aaf65 | this.btnUpload.Click [if (bUpload)] | FP02842_RowExcelPopup.cs:929 |  | FLAG | dtDimension | siMain.GetSpdTitle(sProgramID, sUserID, sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-4091529d | this.btnUpload.Click [if (bUpload)] | FP02842_RowExcelPopup.cs:929 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4495b441 | this.btnUpload.Click [if (bUpload)] | FP02842_RowExcelPopup.cs:932 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP02842_find_UOMInfo_ALL") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-06dc510a | this.btnUpload.Click [if (bUpload)] | FP02842_RowExcelPopup.cs:933 |  | FLAG | dsUomInfoAll | dtUomAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-d2bb1dd7 | this.btnUpload.Click [if (bUpload)] | FP02842_RowExcelPopup.cs:933 |  | DATA_OP | dtUomAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5448a254 | this.btnUpload.Click [if (bUpload)] | FP02842_RowExcelPopup.cs:935 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP02842_find_YieldInfo_Child", Filter["INSTANCE_ID"].ToString(), Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb5c321d | this.btnUpload.Click [if (bUpload)] | FP02842_RowExcelPopup.cs:936 |  | FLAG | dsYieldInfoAll | dtYieldAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ad9c49c1 | this.btnUpload.Click [if (bUpload)] | FP02842_RowExcelPopup.cs:936 |  | DATA_OP | dtYieldAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP02842_RowExcelPopup.SetSheetColor

진입점: this.Load [if (OnSearchData != null) ▸ try] / this.btnFind.Click [if (OnSearchData != null) ▸ try] / FindButton [if (OnSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18875953 | this.Load [if (OnSearchData != null) ▸ try] 외 2 | FP02842_RowExcelPopup.cs:442 | for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*Batch") != -1) | GRID_SET | siMain.ActiveSheet.Cells[0, idx, siMain.GetMaxRowIndex(), idx].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-3fa2c981 | this.Load [if (OnSearchData != null) ▸ try] 외 2 | FP02842_RowExcelPopup.cs:446 | for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*Seq") != -1) | GRID_SET | siMain.ActiveSheet.Cells[0, idx, siMain.GetMaxRowIndex(), idx].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |

## FP02842_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff1204bc | this.Load | FP02842_RowExcelPopup.cs:279 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1df135b7 | this.Load | FP02842_RowExcelPopup.cs:280 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

