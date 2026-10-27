# AS-IS 액션 대조표 — FP00597

> 원천: `Doc/asisfacts/screens/FP00597/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2009행 · 메서드 192 · 종류 DATA_OP 746 · UI_PROP 190 · RETURN 188 · FLAG 179 · UI_MISC 97 · STATE 81 · MESSAGE 79 · VALUE_SET 71 · POPUP 64 · GRID_SET 63 · COMBO_DATA 62 · CALL_EXT 60 · GRID_INIT 29 · ENDPOINT 29 · CALL_BASE 15 · THROW 12 · GRID_LOCK 11 · LIST_REBIND 9 · FOCUS 7 · GRID_STYLE 5 · EXCEL 3 · LIST_CLEAR 3 · STATE_RESET 3 · GRID_BIND 2 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 75


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1067e70c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5917 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-95de31cd | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5923 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-596c0c0b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5931 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-28567a03 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5932 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-2a8957be | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5933 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-cf641b00 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5934 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-087239d2 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5936 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-062aef5c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5937 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-7d9ca2ee | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5938 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-7814f503 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5939 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-951c43e0 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5940 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-6dd3c21c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5941 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-8dbe3033 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5942 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7068852 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5943 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-44bd04fc | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5946 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-9c77748a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6131 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-cc6b559b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6132 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-7512adb4 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6133 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-d5184ab2 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6134 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-541f777b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6136 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf14d155 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6137 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-c49b56fc | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6138 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-07f89b0b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6139 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-bd728223 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6140 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6f85c38 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6141 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-dcc250c5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6142 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-73f7f636 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6143 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-cd18d436 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6145 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02f2e054 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6050 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f3c218d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6051 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-63afab03 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6052 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5cf44283 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6053 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5529b8f3 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6054 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-73ab6b1b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6057 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-acd4db7c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6061 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4530b2b9 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6062 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-889875bf | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6048 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-ebe689a6 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6078 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-04cbe569 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6081 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-632257d1 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6084 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-119b93b9 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6087 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-e004c51f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6090 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-f695c21b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6093 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-4ed530c9 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6099 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-85e13cd0 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6101 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33e2d80d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6022 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63b9a646 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5986 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c4ce5a5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5987 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d3112524 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5988 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-429d5a26 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5989 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c76557a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5990 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8fd1f49d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5991 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c1cf602 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5993 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1d88fe7 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5994 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a23144e | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5997 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-10807e77 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5998 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea6f9c0f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5999 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a47b503d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5984 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-f0971112 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6007 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2123519 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6008 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-85b01b2b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:6013 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46a11f3f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5959 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00597_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-707a4724 | .ctor | FP00597_BucketSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-52ef71e4 | .ctor | FP00597_BucketSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-16e9fd0f | .ctor | FP00597_BucketSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-9705f72a | .ctor | FP00597_BucketSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00597_BucketSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72c04170 | this.btnOK.Click | FP00597_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-3d048a1f | this.btnOK.Click | FP00597_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-915daa72 | this.btnOK.Click | FP00597_BucketSetForm_Popup.cs:187 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-f8e46b6d | this.btnOK.Click | FP00597_BucketSetForm_Popup.cs:191 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-80524fd4 | this.btnOK.Click | FP00597_BucketSetForm_Popup.cs:192 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-dedbeaea | this.btnOK.Click | FP00597_BucketSetForm_Popup.cs:193 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-5cb90469 | this.btnOK.Click | FP00597_BucketSetForm_Popup.cs:194 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00597_BucketSetForm_Popup.btnSet_Click

진입점: this.btbSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8954fc6 | this.btbSet.Click | FP00597_BucketSetForm_Popup.cs:208 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-5170ead3 | this.btbSet.Click | FP00597_BucketSetForm_Popup.cs:208 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-141e6567 | this.btbSet.Click | FP00597_BucketSetForm_Popup.cs:210 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-d81fbfb4 | this.btbSet.Click | FP00597_BucketSetForm_Popup.cs:214 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-79d08544 | this.btbSet.Click | FP00597_BucketSetForm_Popup.cs:215 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-06ff32c7 | this.btbSet.Click | FP00597_BucketSetForm_Popup.cs:217 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f186f00 | this.btbSet.Click | FP00597_BucketSetForm_Popup.cs:219 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-0bc649b2 | this.btbSet.Click | FP00597_BucketSetForm_Popup.cs:221 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-7dfc4679 | this.btbSet.Click | FP00597_BucketSetForm_Popup.cs:222 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00597_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a545f33 | Dispose | FP00597_BucketSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00597_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b7161ae | this.Load | FP00597_BucketSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00597_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96ed846b | this.Load 외 1 | FP00597_BucketSetForm_Popup.cs:145 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf469c1f | this.Load 외 1 | FP00597_BucketSetForm_Popup.cs:146 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-501417e6 | this.Load 외 1 | FP00597_BucketSetForm_Popup.cs:147 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-eea3f718 | this.Load 외 1 | FP00597_BucketSetForm_Popup.cs:151 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-961ecff3 | this.Load 외 1 | FP00597_BucketSetForm_Popup.cs:151 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-38f846e4 | this.Load 외 1 | FP00597_BucketSetForm_Popup.cs:159 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-ab4ee4d2 | this.Load 외 1 | FP00597_BucketSetForm_Popup.cs:163 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-d6853a8c | this.Load 외 1 | FP00597_BucketSetForm_Popup.cs:167 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00597_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-147846b1 | this.Load 외 1 | FP00597_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c3bc45c7 | this.Load 외 1 | FP00597_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6d48edb1 | this.Load 외 1 | FP00597_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00597_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8a83e18 | (진입점 미연결) | FP00597_BucketSetForm_Popup.cs:233 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-df6500bf | (진입점 미연결) | FP00597_BucketSetForm_Popup.cs:244 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-36af465c | (진입점 미연결) | FP00597_BucketSetForm_Popup.cs:255 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00597_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efb0121c | this.Load | FP00597_BucketSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-20efb9fe | this.Load | FP00597_BucketSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00597_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cdf6638 | .ctor | FP00597_ExcelPopup.cs:153 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-2599fd79 | .ctor | FP00597_ExcelPopup.cs:154 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4ed1421b | .ctor | FP00597_ExcelPopup.cs:156 |  | FLAG | HeaderLineCount | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-c30db98b | .ctor | FP00597_ExcelPopup.cs:157 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |

## FP00597_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5455346e | this.btnClose.Click | FP00597_ExcelPopup.cs:1003 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00597_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ffe10b7 | this.btnDownload.Click | FP00597_ExcelPopup.cs:977 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-2fdaa878 | this.btnDownload.Click | FP00597_ExcelPopup.cs:978 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00597_ExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61f7f26a | this.btnUpload.Click | FP00597_ExcelPopup.cs:990 | if (bUpload) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-12745e44 | this.btnUpload.Click | FP00597_ExcelPopup.cs:991 | if (bUpload) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |

## FP00597_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-274987a0 | this.Load | FP00597_ExcelPopup.cs:250 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7c641f0a | this.Load | FP00597_ExcelPopup.cs:251 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-04762b2a | this.Load | FP00597_ExcelPopup.cs:252 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00597_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82069217 | (진입점 미연결) | FP00597_ExcelPopup.cs:961 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e579c396 | (진입점 미연결) | FP00597_ExcelPopup.cs:961 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00597_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90d412e5 | this.Load | FP00597_ExcelPopup.cs:245 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00597_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc63a01e | Dispose | FP00597_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00597_ExcelPopup.dtpPeriod_ValueChanged

진입점: this.dtpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05b5e9bf | this.dtpPeriod.ValueChanged | FP00597_ExcelPopup.cs:1019 | if (bFirst == true) | FLAG | bFirst | false | 화면 필드/플래그 변경 |  |  |  |
| AC-31cff60d | this.dtpPeriod.ValueChanged | FP00597_ExcelPopup.cs:1020 | if (bFirst == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-494014be | this.dtpPeriod.ValueChanged | FP00597_ExcelPopup.cs:1035 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bac58673 | this.dtpPeriod.ValueChanged | FP00597_ExcelPopup.cs:1038 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | VALUE_SET | dtpPeriod.InitValue | sStartDate + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8688c7c0 | this.dtpPeriod.ValueChanged | FP00597_ExcelPopup.cs:1039 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b2046c3c | this.dtpPeriod.ValueChanged | FP00597_ExcelPopup.cs:1044 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25afeabd | this.dtpPeriod.ValueChanged | FP00597_ExcelPopup.cs:1052 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-599d7da9 | this.dtpPeriod.ValueChanged | FP00597_ExcelPopup.cs:1054 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b9c5bdb | this.dtpPeriod.ValueChanged | FP00597_ExcelPopup.cs:1057 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-3767844c | this.dtpPeriod.ValueChanged | FP00597_ExcelPopup.cs:1058 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |

## FP00597_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9c9f31c | (진입점 미연결) | FP00597_ExcelPopup.cs:951 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00597_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4a64ac5 | FindButton | FP00597_ExcelPopup.cs:292 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-717a253f | FindButton | FP00597_ExcelPopup.cs:293 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-93010260 | FindButton | FP00597_ExcelPopup.cs:295 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00597_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80536220 | this.Load 외 2 | FP00597_ExcelPopup.cs:324 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4c13e93f | this.Load 외 2 | FP00597_ExcelPopup.cs:330 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-786c567c | this.Load 외 2 | FP00597_ExcelPopup.cs:332 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3586e5c0 | this.Load 외 2 | FP00597_ExcelPopup.cs:337 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f194701 | this.Load 외 2 | FP00597_ExcelPopup.cs:338 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49744c62 | this.Load 외 2 | FP00597_ExcelPopup.cs:340 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-d67f63e2 | this.Load 외 2 | FP00597_ExcelPopup.cs:341 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-9a55cd65 | this.Load 외 2 | FP00597_ExcelPopup.cs:343 |  | DATA_OP | Filter["BUCKET_FROM"] | _BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-0f77936b | this.Load 외 2 | FP00597_ExcelPopup.cs:344 |  | DATA_OP | Filter["BUCKET_TO"] | _BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-7c0f8001 | this.Load 외 2 | FP00597_ExcelPopup.cs:349 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-a00ea7b9 | this.Load 외 2 | FP00597_ExcelPopup.cs:351 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rdoGroup1.SelectedIndex == 0) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-db8a4a49 | this.Load 외 2 | FP00597_ExcelPopup.cs:355 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d341e7a2 | this.Load 외 2 | FP00597_ExcelPopup.cs:360 | if (OnSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e8b89699 | this.Load 외 2 | FP00597_ExcelPopup.cs:361 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-694bdb06 | this.Load 외 2 | FP00597_ExcelPopup.cs:361 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb264064 | this.Load 외 2 | FP00597_ExcelPopup.cs:366 | if (OnSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1b2cefac | this.Load 외 2 | FP00597_ExcelPopup.cs:367 | if (OnSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-97d97541 | this.Load 외 2 | FP00597_ExcelPopup.cs:369 | if (OnSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2e934924 | this.Load 외 2 | FP00597_ExcelPopup.cs:370 | if (OnSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-80d91bc0 | this.Load 외 2 | FP00597_ExcelPopup.cs:371 | if (OnSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-62759070 | this.Load 외 2 | FP00597_ExcelPopup.cs:372 | if (OnSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-908be18f | this.Load 외 2 | FP00597_ExcelPopup.cs:373 | if (OnSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e521754f | this.Load 외 2 | FP00597_ExcelPopup.cs:374 | if (OnSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6b901d86 | this.Load 외 2 | FP00597_ExcelPopup.cs:375 | if (OnSearchData != null) | STATE | this.dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6d6fc19f | this.Load 외 2 | FP00597_ExcelPopup.cs:381 | if (OnSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-75510070 | this.Load 외 2 | FP00597_ExcelPopup.cs:385 | if (OnSearchData != null) ▸ try | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-080210f0 | this.Load 외 2 | FP00597_ExcelPopup.cs:387 | if (OnSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da816139 | this.Load 외 2 | FP00597_ExcelPopup.cs:389 | if (OnSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar, Dat… | ⚠ 의미 확인 필요 |  |  |  |
| AC-81dbb5b7 | this.Load 외 2 | FP00597_ExcelPopup.cs:394 | if (OnSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, set, ColumnWidth.Data, Colum… | 화면 필드/플래그 변경 |  |  |  |
| AC-99918cb4 | this.Load 외 2 | FP00597_ExcelPopup.cs:394 | if (OnSearchData != null) ▸ try ▸ lambda | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, set, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data, Heade… | ⚠ 의미 확인 필요 |  |  |  |
| AC-43ae684c | this.Load 외 2 | FP00597_ExcelPopup.cs:399 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-e9af4e2f | this.Load 외 2 | FP00597_ExcelPopup.cs:400 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-5d9835ec | this.Load 외 2 | FP00597_ExcelPopup.cs:401 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-781a9635 | this.Load 외 2 | FP00597_ExcelPopup.cs:406 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e971fdd8 | this.Load 외 2 | FP00597_ExcelPopup.cs:407 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e8fc32d | this.Load 외 2 | FP00597_ExcelPopup.cs:410 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ec4d71e4 | this.Load 외 2 | FP00597_ExcelPopup.cs:411 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-28bb3bea | this.Load 외 2 | FP00597_ExcelPopup.cs:420 | if (OnSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-034cb12a | this.Load 외 2 | FP00597_ExcelPopup.cs:423 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-de3c0716 | this.Load 외 2 | FP00597_ExcelPopup.cs:424 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-209d96cd | this.Load 외 2 | FP00597_ExcelPopup.cs:425 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1675a273 | this.Load 외 2 | FP00597_ExcelPopup.cs:426 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-25661e1d | this.Load 외 2 | FP00597_ExcelPopup.cs:427 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1fea52bc | this.Load 외 2 | FP00597_ExcelPopup.cs:428 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-51aa37dd | this.Load 외 2 | FP00597_ExcelPopup.cs:429 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00597_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5df6fc2c | this.Load | FP00597_ExcelPopup.cs:166 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-94cca927 | this.Load | FP00597_ExcelPopup.cs:168 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00597_ExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab0d5415 | (진입점 미연결) | FP00597_ExcelPopup.cs:688 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-c4b7070a | (진입점 미연결) | FP00597_ExcelPopup.cs:689 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-bfbd6759 | (진입점 미연결) | FP00597_ExcelPopup.cs:690 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-a43f0f39 | (진입점 미연결) | FP00597_ExcelPopup.cs:691 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-9f81bc61 | (진입점 미연결) | FP00597_ExcelPopup.cs:692 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-ac0d4c14 | (진입점 미연결) | FP00597_ExcelPopup.cs:693 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-e327cf66 | (진입점 미연결) | FP00597_ExcelPopup.cs:694 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1c1db721 | (진입점 미연결) | FP00597_ExcelPopup.cs:696 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-379da245 | (진입점 미연결) | FP00597_ExcelPopup.cs:697 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-04180576 | (진입점 미연결) | FP00597_ExcelPopup.cs:701 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-b3e561cb | (진입점 미연결) | FP00597_ExcelPopup.cs:702 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00597_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9022cc5 | this.Load | FP00597_ExcelPopup.cs:203 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_FROM"].ToString()) < Convert.ToDecimal(thi… | DATA_OP | Filter["BUCKET_FROM"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-88cd4bc5 | this.Load | FP00597_ExcelPopup.cs:208 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | sEndDay | 행/컬럼 값 대입 |  |  |  |
| AC-6cd18da4 | this.Load | FP00597_ExcelPopup.cs:211 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | Filter["BUCKET_FROM"] | 화면 필드/플래그 변경 |  |  |  |
| AC-899e49ba | this.Load | FP00597_ExcelPopup.cs:212 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | Filter["BUCKET_TO"] | 화면 필드/플래그 변경 |  |  |  |
| AC-0ae38294 | this.Load | FP00597_ExcelPopup.cs:214 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | _BucketFromDate.ToString() + ":" + _BucketToDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ea080dde | this.Load | FP00597_ExcelPopup.cs:216 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d7cc3d3b | this.Load | FP00597_ExcelPopup.cs:218 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-9485451f | this.Load | FP00597_ExcelPopup.cs:222 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-c35d9933 | this.Load | FP00597_ExcelPopup.cs:224 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-acd1e652 | this.Load | FP00597_ExcelPopup.cs:225 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-5ce05786 | this.Load | FP00597_ExcelPopup.cs:226 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | UI_PROP | lblMPPWPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9a0b5d3c | this.Load | FP00597_ExcelPopup.cs:234 | for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-c37862cd | this.Load | FP00597_ExcelPopup.cs:237 |  | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-520fcc07 | this.Load | FP00597_ExcelPopup.cs:239 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |

## FP00597_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5376913e | this.Load | FP00597_ExcelPopup.cs:262 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-18efc18e | this.Load | FP00597_ExcelPopup.cs:263 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00597_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9435b7e8 | (진입점 미연결) | FP00597_ExcelPopup.cs:283 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00597_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c18b56e3 | this.btnUpload.Click | FP00597_ExcelPopup.cs:711 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-c02e82e7 | this.btnUpload.Click | FP00597_ExcelPopup.cs:711 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-34c6a5dd | this.btnUpload.Click | FP00597_ExcelPopup.cs:713 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d6d412d6 | this.btnUpload.Click | FP00597_ExcelPopup.cs:714 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c02b9978 | this.btnUpload.Click | FP00597_ExcelPopup.cs:715 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9cb77f20 | this.btnUpload.Click | FP00597_ExcelPopup.cs:717 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9b7b7fcc | this.btnUpload.Click | FP00597_ExcelPopup.cs:719 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-35dd0cd4 | this.btnUpload.Click | FP00597_ExcelPopup.cs:720 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-36cb2c31 | this.btnUpload.Click | FP00597_ExcelPopup.cs:720 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-86e20560 | this.btnUpload.Click | FP00597_ExcelPopup.cs:727 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3dc67a75 | this.btnUpload.Click | FP00597_ExcelPopup.cs:728 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-86ac4e41 | this.btnUpload.Click | FP00597_ExcelPopup.cs:940 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00597_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-932626a7 | this.btnSave.Click | FP00597_ExcelPopup.cs:442 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-1f0aedb8 | this.btnSave.Click | FP00597_ExcelPopup.cs:443 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60e93a1d | this.btnSave.Click | FP00597_ExcelPopup.cs:447 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix! After once seach, Try agagin.!") | 메시지 표시 |  |  |  |
| AC-f2aedd02 | this.btnSave.Click | FP00597_ExcelPopup.cs:448 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-382a61fb | this.btnSave.Click | FP00597_ExcelPopup.cs:459 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (!String.IsNullOrEmpty(dsMain.Tables[0].Rows[i]["MESSAGE"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46e0ee64 | this.btnSave.Click | FP00597_ExcelPopup.cs:460 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (!String.IsNullOrEmpty(dsMain.Tables[0].Rows[i]["MESSAGE"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab5efb90 | this.btnSave.Click | FP00597_ExcelPopup.cs:464 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-17afbe9f | this.btnSave.Click | FP00597_ExcelPopup.cs:464 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-edc2bbca | this.btnSave.Click | FP00597_ExcelPopup.cs:470 | if (OnBeforeCheckData != null) | CALL_BASE | OnBeforeCheckData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c092d8c | this.btnSave.Click | FP00597_ExcelPopup.cs:472 | if (OnBeforeCheckData != null) ▸ if (bCheck == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e50d661 | this.btnSave.Click | FP00597_ExcelPopup.cs:483 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b1e63dfa | this.btnSave.Click | FP00597_ExcelPopup.cs:484 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-33017e42 | this.btnSave.Click | FP00597_ExcelPopup.cs:485 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3c38a273 | this.btnSave.Click | FP00597_ExcelPopup.cs:486 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e3da415b | this.btnSave.Click | FP00597_ExcelPopup.cs:487 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1f5a9cd3 | this.btnSave.Click | FP00597_ExcelPopup.cs:488 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-31a77bb8 | this.btnSave.Click | FP00597_ExcelPopup.cs:496 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-849b7473 | this.btnSave.Click | FP00597_ExcelPopup.cs:497 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-700edd22 | this.btnSave.Click | FP00597_ExcelPopup.cs:498 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1f4c2a04 | this.btnSave.Click | FP00597_ExcelPopup.cs:499 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-22f20944 | this.btnSave.Click | FP00597_ExcelPopup.cs:500 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fa3fb5d0 | this.btnSave.Click | FP00597_ExcelPopup.cs:501 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-509fde5d | this.btnSave.Click | FP00597_ExcelPopup.cs:502 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1f704f1f | this.btnSave.Click | FP00597_ExcelPopup.cs:503 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89a32612 | this.btnSave.Click | FP00597_ExcelPopup.cs:509 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-46e4f7b8 | this.btnSave.Click | FP00597_ExcelPopup.cs:512 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ad99aa5 | this.btnSave.Click | FP00597_ExcelPopup.cs:514 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-20dbd101 | this.btnSave.Click | FP00597_ExcelPopup.cs:517 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d630466 | this.btnSave.Click | FP00597_ExcelPopup.cs:522 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-3d2d1b51 | this.btnSave.Click | FP00597_ExcelPopup.cs:523 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-d97b06c6 | this.btnSave.Click | FP00597_ExcelPopup.cs:533 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (rdoGrou… | DATA_OP | this.Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-73c00e8d | this.btnSave.Click | FP00597_ExcelPopup.cs:535 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (rd… | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-68c10994 | this.btnSave.Click | FP00597_ExcelPopup.cs:539 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cb39657a | this.btnSave.Click | FP00597_ExcelPopup.cs:544 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-641f434d | this.btnSave.Click | FP00597_ExcelPopup.cs:567 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-0b09804a | this.btnSave.Click | FP00597_ExcelPopup.cs:570 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | POPUP | new Planning.UIL.FP00594_InValidationExcelPopup | ("InvalidExcelPopup", dsValidation, "") | 팝업/폼 생성 |  |  |  |
| AC-d87a2b12 | this.btnSave.Click | FP00597_ExcelPopup.cs:571 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-617a7a23 | this.btnSave.Click | FP00597_ExcelPopup.cs:572 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) ▸ else of (dsValidation == null) ▸ if (dsValidation.Tables.Count > 0)… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f35287df | this.btnSave.Click | FP00597_ExcelPopup.cs:589 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-66d161cc | this.btnSave.Click | FP00597_ExcelPopup.cs:601 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a552b524 | this.btnSave.Click | FP00597_ExcelPopup.cs:605 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | FLAG | bUploadSaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cc5a510e | this.btnSave.Click | FP00597_ExcelPopup.cs:606 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-40e361df | this.btnSave.Click | FP00597_ExcelPopup.cs:611 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-97518c22 | this.btnSave.Click | FP00597_ExcelPopup.cs:612 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e322fe00 | this.btnSave.Click | FP00597_ExcelPopup.cs:618 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-5b8512e1 | this.btnSave.Click | FP00597_ExcelPopup.cs:655 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-1d35c70f | this.btnSave.Click | FP00597_ExcelPopup.cs:657 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c277f449 | this.btnSave.Click | FP00597_ExcelPopup.cs:658 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-86004e2d | this.btnSave.Click | FP00597_ExcelPopup.cs:668 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a279e229 | this.btnSave.Click | FP00597_ExcelPopup.cs:669 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f87d7791 | this.btnSave.Click | FP00597_ExcelPopup.cs:673 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-569bb6fb | this.btnSave.Click | FP00597_ExcelPopup.cs:674 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e1e26b07 | this.btnSave.Click | FP00597_ExcelPopup.cs:675 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fc50c614 | this.btnSave.Click | FP00597_ExcelPopup.cs:676 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-14e95474 | this.btnSave.Click | FP00597_ExcelPopup.cs:677 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0c867829 | this.btnSave.Click | FP00597_ExcelPopup.cs:678 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00597_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b088fb4f | this.Load | FP00597_ExcelPopup.cs:275 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64669641 | this.Load | FP00597_ExcelPopup.cs:276 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00597_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21a930e6 | .ctor | FP00597_MeasureSetForm_Popup.cs:94 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-930494f9 | .ctor | FP00597_MeasureSetForm_Popup.cs:95 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-cfcdd536 | .ctor | FP00597_MeasureSetForm_Popup.cs:96 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-b608d732 | .ctor | FP00597_MeasureSetForm_Popup.cs:98 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00597_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4eb3c493 | this.btnOK.Click | FP00597_MeasureSetForm_Popup.cs:310 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-3daaa136 | this.btnOK.Click | FP00597_MeasureSetForm_Popup.cs:311 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-b3a1e868 | this.btnOK.Click | FP00597_MeasureSetForm_Popup.cs:318 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-7e93e36f | this.btnOK.Click | FP00597_MeasureSetForm_Popup.cs:319 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00597_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e3a066f | this.btnSet.Click | FP00597_MeasureSetForm_Popup.cs:282 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-05cf6c87 | this.btnSet.Click | FP00597_MeasureSetForm_Popup.cs:283 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-b82cf223 | this.btnSet.Click | FP00597_MeasureSetForm_Popup.cs:285 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cd416b1f | this.btnSet.Click | FP00597_MeasureSetForm_Popup.cs:286 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32d44f4c | this.btnSet.Click | FP00597_MeasureSetForm_Popup.cs:288 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-09556d83 | this.btnSet.Click | FP00597_MeasureSetForm_Popup.cs:289 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-b8b38766 | this.btnSet.Click | FP00597_MeasureSetForm_Popup.cs:290 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00597_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-193ffc6d | Dispose | FP00597_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00597_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89d75657 | this.Load | FP00597_MeasureSetForm_Popup.cs:121 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00597_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4981e84 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:168 |  | FLAG | dtCategory | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "select_measure", "FP00597_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-0851aeb7 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:168 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00597_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-748470a0 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:199 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-0903fa83 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:200 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-54893422 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:201 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-737daa93 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:202 |  | DATA_OP | ctrls.Add | (chk_s) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef69c808 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:203 |  | DATA_OP | ctrls.Add | (chk_i) | 데이터 객체 조작/조회 |  |  |  |
| AC-19cf3c2e | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:204 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-86183cc1 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:207 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcc964b1 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:208 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fd88bf9 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:211 |  | DATA_OP | ctrls.Add | (chk_kg) | 데이터 객체 조작/조회 |  |  |  |
| AC-92f0afdf | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:212 |  | DATA_OP | ctrls.Add | (chk_batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-54e12477 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:215 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-7414d9b5 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:215 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-a59cb853 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:222 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-adda23a3 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:226 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-d2d8eb0f | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:230 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00597_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd04fe27 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:134 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b5179775 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:135 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-79d952bd | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7fc8fb38 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_s.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-38503810 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_i.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0e3e0f1c | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-307ee03b | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3f8048f9 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-74b6987a | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_kg.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-857294d1 | this.Load 외 1 | FP00597_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_batch.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00597_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6690fe7 | (진입점 미연결) | FP00597_MeasureSetForm_Popup.cs:374 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-e1afc043 | (진입점 미연결) | FP00597_MeasureSetForm_Popup.cs:385 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42cd65e5 | (진입점 미연결) | FP00597_MeasureSetForm_Popup.cs:396 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00597_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00fbd207 | this.Load | FP00597_MeasureSetForm_Popup.cs:108 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-546a34f2 | this.Load | FP00597_MeasureSetForm_Popup.cs:116 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00597_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98fe40f5 | this.btnSet.Click 외 1 | FP00597_MeasureSetForm_Popup.cs:330 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ddf8a2a0 | this.btnSet.Click 외 1 | FP00597_MeasureSetForm_Popup.cs:338 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-e9a2fd95 | this.btnSet.Click 외 1 | FP00597_MeasureSetForm_Popup.cs:338 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-8ec215f8 | this.btnSet.Click 외 1 | FP00597_MeasureSetForm_Popup.cs:355 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8aa86fc7 | this.btnSet.Click 외 1 | FP00597_MeasureSetForm_Popup.cs:366 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50827b68 | .ctor | FP00597_PlanAmend_Model_PreMix.cs:207 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-8aadc311 | .ctor | FP00597_PlanAmend_Model_PreMix.cs:208 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SELECT") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec6472b7 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1052 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6d430a79 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1053 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-09798910 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1054 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3fcdac32 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1055 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cf62bf3c | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1056 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fe76430c | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1059 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-485e8665 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1063 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-7b0e4ff3 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1065 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c8f4aced | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1066 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-090e16dc | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1067 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a2b983b | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1068 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-f9c58ddb | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1069 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c9de5647 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1070 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-0bba311e | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1072 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00597_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-36a01053 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1078 | if (dtCategory != null) ▸ if (dtCategory.Rows.Count == 0) | MESSAGE | MessageBox.Show | ("Set the your column or Category popup!") | 메시지 표시 |  |  |  |
| AC-5b855910 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1082 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95ec5e21 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1083 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8d56d4a8 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1084 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2250931c | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1085 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-48f0a39f | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1097 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-13a86387 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1104 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7a12cd21 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1105 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95a3102d | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1106 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0fc9583b | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1118 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-8a66cc12 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1119 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-ea3d2649 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1120 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-6aff7f16 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1121 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-80bca4cf | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1122 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-18b71e2a | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1123 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-cb2389a8 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:1124 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.ApplyAmendCalendarCondition_ForExcel

진입점: popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8904f250 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4904 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4cd7919f | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4905 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-efe4e134 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4906 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5722f56a | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4907 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1df22b14 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4908 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3762739b | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4922 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f5c3a2f | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4926 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-854beb46 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4928 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-83758b4c | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4929 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-6820eed9 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4930 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-78f23848 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4931 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-d08d54af | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4932 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-50b0e4dd | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4933 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-09d9df6a | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4938 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00596_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c977c14d | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4940 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7548f234 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4941 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9800ba8d | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4942 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb8f4b9e | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4943 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6243d994 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4944 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b9b2ff5f | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4945 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c0c552c1 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4946 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d91012c9 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4949 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-8e40f2ef | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4950 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-d4445ab8 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4951 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-12081b4c | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4952 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-b481f7eb | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4953 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-50ffc01b | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4954 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-efaca654 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4955 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93f99498 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:995 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; if (GetFilter("INSTANCE_ID") == "") … | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c7ea4e9 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1005 | lambda | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-6845936c | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1006 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-cb430106 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1007 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-cb5d357e | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1015 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8a756238 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1023 | lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-93392193 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1026 | lambda | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_R" | 행/컬럼 값 대입 |  |  |  |
| AC-765973f2 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1027 | lambda | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-c5fa05f8 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1028 | lambda | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_R" | 행/컬럼 값 대입 |  |  |  |
| AC-3508a642 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1029 | lambda | DATA_OP | Filter["AMEND_BOH_TABLE"] | "FP_AMEND_DAILY_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-bb7fe494 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1030 | lambda | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_DAILY_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-6da25b36 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1031 | lambda | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_DAILY_UTIL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-d8c6c723 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1032 | lambda | DATA_OP | Filter["AMEND_CAPA_TABLE"] | "FP_AMEND_DAILY_CAPA_R" | 행/컬럼 값 대입 |  |  |  |
| AC-460175c2 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1036 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_H" | 행/컬럼 값 대입 |  |  |  |
| AC-8cb56f82 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1037 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H" | 행/컬럼 값 대입 |  |  |  |
| AC-4ce58ada | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1038 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_R" | 행/컬럼 값 대입 |  |  |  |
| AC-43452eed | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1039 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_BOH_TABLE"] | "FP_AMEND_DAILY_BOH_H" | 행/컬럼 값 대입 |  |  |  |
| AC-3c9dc11c | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1040 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_DAILY_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-9d13c65d | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1041 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_DAILY_UTIL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-be366ab3 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1042 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_CAPA_TABLE"] | "FP_AMEND_DAILY_CAPA_H" | 행/컬럼 값 대입 |  |  |  |
| AC-099dbeeb | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1045 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45ffa5ec | this.btnBucket.Click | FP00597_PlanAmend_Model_PreMix.cs:2438 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-4c91ff24 | this.btnBucket.Click | FP00597_PlanAmend_Model_PreMix.cs:2441 |  | POPUP | new FP00597_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-ab0721af | this.btnBucket.Click | FP00597_PlanAmend_Model_PreMix.cs:2442 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-68dace71 | this.btnBucket.Click | FP00597_PlanAmend_Model_PreMix.cs:2443 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-f174eaaf | this.btnBucket.Click | FP00597_PlanAmend_Model_PreMix.cs:2444 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dbe4dfb9 | this.btnBucket.Click | FP00597_PlanAmend_Model_PreMix.cs:2448 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-09a341ad | this.btnBucket.Click | FP00597_PlanAmend_Model_PreMix.cs:2457 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c372102c | this.btnBucket.Click | FP00597_PlanAmend_Model_PreMix.cs:2459 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f7d43500 | this.btnBucket.Click | FP00597_PlanAmend_Model_PreMix.cs:2462 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-522c7a5e | this.btnBucket.Click | FP00597_PlanAmend_Model_PreMix.cs:2471 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b728d5a | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2382 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-9394cb17 | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2385 |  | POPUP | new FP00597_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-2e9a5f4c | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2386 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-079226bd | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2387 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c062d5e0 | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2388 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-c8b66b44 | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2389 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-110cc386 | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2393 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-82c7092d | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2402 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5de06d69 | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2404 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a76e200c | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2407 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-404da34c | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2416 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7a102b55 | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2421 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-020755b6 | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2424 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c23b61c1 | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2426 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-94fc017c | this.btnCatagory.Click | FP00597_PlanAmend_Model_PreMix.cs:2429 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40c9260c | this.btnColumn.Click | FP00597_PlanAmend_Model_PreMix.cs:2355 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-b35d4bf3 | this.btnColumn.Click | FP00597_PlanAmend_Model_PreMix.cs:2358 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-41d6b2ea | this.btnColumn.Click | FP00597_PlanAmend_Model_PreMix.cs:2359 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3fca15cc | this.btnColumn.Click | FP00597_PlanAmend_Model_PreMix.cs:2360 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1567b3ff | this.btnColumn.Click | FP00597_PlanAmend_Model_PreMix.cs:2366 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-ae47190d | this.btnColumn.Click | FP00597_PlanAmend_Model_PreMix.cs:2366 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70b3726d | this.btnColumn.Click | FP00597_PlanAmend_Model_PreMix.cs:2367 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-966d5719 | this.btnColumn.Click | FP00597_PlanAmend_Model_PreMix.cs:2373 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.btnCreatePlan_Click

진입점: this.btnCreatePlan2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e4adf55 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2539 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-6e79a9d2 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2540 | if (flo != null) | FOCUS | btnMenu2.Focus | () | 포커스 이동 |  |  |  |
| AC-8fe43bbd | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2548 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ef94563 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2549 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bcd1f961 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2559 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d462aaba | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2561 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1248baf8 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2567 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c351a9e6 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2568 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95bebf08 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2573 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8edfc8a | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2574 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9b328877 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2577 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3b9e322 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2578 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-748f7795 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2579 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2623a1f | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2585 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-acdc6d08 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2588 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-e35c2e28 | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2589 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6a379b1a | this.btnCreatePlan2.Click | FP00597_PlanAmend_Model_PreMix.cs:2590 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fd90813 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2800 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a515b2c3 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2801 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3705a75 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2807 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-1edd365b | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2808 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2bf17af4 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2814 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not be uploaded.") | 메시지 표시 |  |  |  |
| AC-8c3f65a3 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2815 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf8ea5fd | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2821 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-ceb8be6d | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2824 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-047631d6 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2830 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-00b2a70c | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2831 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-97361aed | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2832 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8344dab5 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2834 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9700a954 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2841 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP00596_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-6f626f60 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2843 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | this.Filter | 화면 필드/플래그 변경 |  |  |  |
| AC-77861b6d | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2846 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.TYPEZERO | 속성 DateColumnType 설정 |  |  |  |
| AC-c0366fd9 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2849 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-909d3372 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2850 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f30e7d8b | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2851 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c3a51bee | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2852 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3f729dc2 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2853 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-bf361865 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2854 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ded52e06 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2855 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-782eb921 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2856 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5ee98052 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2857 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ecd87d86 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2858 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-12c26f21 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2859 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5dee4c95 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2861 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-5a533a0c | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2862 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-e87d7734 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2863 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-74de4aa8 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2864 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-43c62d11 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2865 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-6e637018 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2866 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Operateion." | 행/컬럼 값 대입 |  |  |  |
| AC-fca1b67a | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2867 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-96baf6bb | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2868 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-f5cd510e | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2869 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-051cd0a2 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2870 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-89041122 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2871 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-9159a8db | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2872 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-408b9ed2 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2873 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-be8d6a85 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2874 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-d04d9dde | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2878 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnSearchData | ExcelPopup_Search_Column | 속성 OnSearchData 설정 |  |  |  |
| AC-5fe62318 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2879 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Column | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-d9082ea1 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2880 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Column | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-b9c29579 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2881 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-5d293c56 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2883 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-7ca064bf | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2885 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e6f4cfb5 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2895 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cede8215 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2899 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0226c510 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2902 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | MESSAGE | MessageBox.Show | ("ERROR: EXEC_PSICALCUL Excution occur Error!") | 메시지 표시 |  |  |  |
| AC-ba3b886e | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2912 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP00596_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-94e72c1c | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2914 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | this.Filter | 화면 필드/플래그 변경 |  |  |  |
| AC-462c1b00 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2918 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a02a8518 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2919 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-860491b1 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2920 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d83f59e2 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2921 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ed81e7bd | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2922 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c6c1c629 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2923 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3886fbe2 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2924 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-984a21a3 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2925 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-49362fec | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2926 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e897e373 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2927 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d4eb45fc | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2928 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1143768e | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2929 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f60a87ee | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2930 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a8c51e5e | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2931 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SEQ"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8183f463 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2934 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-d9c14037 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2935 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-f85893d9 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2936 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-24eca0cb | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2937 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-8600ee9e | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2938 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Operateion" | 행/컬럼 값 대입 |  |  |  |
| AC-ebbf4526 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2939 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-0d796721 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2940 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-dd6790ec | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2941 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-7d2878bd | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2942 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-fc3db7fa | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2943 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-72622475 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2944 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-5b72f3dd | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2945 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-6f5005e4 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2946 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-e7f9573d | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2947 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-0c36df75 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2948 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_KG"] | "KG" | 행/컬럼 값 대입 |  |  |  |
| AC-a01a3f96 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2949 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["QTY"] | "Batch" | 행/컬럼 값 대입 |  |  |  |
| AC-a18324e5 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2950 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SEQ"] | "Seq" | 행/컬럼 값 대입 |  |  |  |
| AC-b1f1a30f | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2954 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnSearchData | ExcelPopup_Search_Row | 속성 OnSearchData 설정 |  |  |  |
| AC-dc9dfe95 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2955 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Row | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-8e7b3386 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2956 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Row | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-11950830 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2957 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-d55c46c6 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2959 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-34ebcebf | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2961 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cac97307 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2971 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3c4d92e4 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2975 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-14e23010 | this.btnExcelImport.Click | FP00597_PlanAmend_Model_PreMix.cs:2978 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | MESSAGE | MessageBox.Show | ("ERROR: EXEC_PSICALCUL Excution occur Error!") | 메시지 표시 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c4e1860 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2741 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-5367a130 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2742 | if (flo != null) | FOCUS | btnMenu2.Focus | () | 포커스 이동 |  |  |  |
| AC-a53f814f | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2750 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-141a9672 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2751 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61dd390e | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2756 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-b3a1e65e | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2757 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4461227 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2762 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-888b63f6 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2763 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-6a14e3eb | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2764 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-681f74f7 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2764 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bf1166da | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2765 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-b1c93e1a | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2766 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-c62a841b | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2767 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-421d6c3a | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2767 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0392a193 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2768 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c2b6b0e3 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2769 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-76cc54a1 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2770 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-864bcf45 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2771 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-946680a1 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2772 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-633fc92b | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2773 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-00e7eba9 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2774 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-71870f55 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2775 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7ddeec48 | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2776 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f129176f | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2778 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ef2fe8fc | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2779 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-586173da | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2780 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-5a48934d | this.btnMemo.Click | FP00597_PlanAmend_Model_PreMix.cs:2781 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.btnMenu_Click

진입점: this.btnMenu2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d0da191 | this.btnMenu2.Click | FP00597_PlanAmend_Model_PreMix.cs:2993 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnMenu2, menuPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-434ce4a2 | this.btnMenu2.Click | FP00597_PlanAmend_Model_PreMix.cs:2993 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnMenu2, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.btnMRP_Click

진입점: this.btnMRP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5945899 | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2487 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-00dfa249 | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2488 | if (flo != null) | FOCUS | btnMenu2.Focus | () | 포커스 이동 |  |  |  |
| AC-5316a2b9 | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2496 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-712f93f8 | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2497 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae9bc86a | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2501 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37e929c8 | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2507 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-d181d9bf | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2508 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9ec9635 | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2514 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-7d971074 | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2515 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b6e34b2 | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2520 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-733a4e2d | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2521 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c32d424 | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2525 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-e7b8e351 | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2526 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd66a2ac | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2527 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3983125b | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2529 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-e5e8d8c0 | this.btnMRP.Click | FP00597_PlanAmend_Model_PreMix.cs:2531 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.btnRelease_Click

진입점: this.btnRelease2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae9411f3 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2606 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-6be0358a | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2607 | if (flo != null) | FOCUS | btnMenu2.Focus | () | 포커스 이동 |  |  |  |
| AC-b01c8909 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2615 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06a7b9ad | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2616 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63ba362b | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2636 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc919576 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2637 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-017f2361 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2640 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_instanceInfo", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-687a4a4e | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2641 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_planInfo", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8236f5bc | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2645 | if (dtPlanInfo != null) | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3a41fd83 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2652 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ec4b0fbc | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2656 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a9f277a3 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2657 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea6afb2d | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2664 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a548cff1 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2665 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf455c44 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2672 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a2ab7d9c | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2675 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4474007 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2677 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c91c9959 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2683 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-549a214e | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2684 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c34f9464 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2697 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d469811 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2698 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-795c8c23 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2710 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-aa3d7ed0 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2713 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-e4e9bc99 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2714 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-05fee419 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2715 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3a375a40 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2725 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-9866d2f5 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2728 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-16da0234 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2729 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-465872b0 | this.btnRelease2.Click | FP00597_PlanAmend_Model_PreMix.cs:2730 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a8ae2de | this.btnSql.Click | FP00597_PlanAmend_Model_PreMix.cs:3001 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-0d66e4b0 | this.btnSql.Click | FP00597_PlanAmend_Model_PreMix.cs:3004 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d57eb4c2 | this.btnSql.Click | FP00597_PlanAmend_Model_PreMix.cs:3005 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-99fd8ded | this.btnSql.Click | FP00597_PlanAmend_Model_PreMix.cs:3007 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00597_AMEND_MODEL_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-51891133 | this.btnSql.Click | FP00597_PlanAmend_Model_PreMix.cs:3008 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00597_TOTAL_VALUE_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0adaaa8 | this.btnSql.Click | FP00597_PlanAmend_Model_PreMix.cs:3009 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00597_SAVE_VALID_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d47d6f8 | this.btnSql.Click | FP00597_PlanAmend_Model_PreMix.cs:3010 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00597_AMEND_MODEL_DATA_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c3e6c62 | this.btnSql.Click | FP00597_PlanAmend_Model_PreMix.cs:3011 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00597_EXCEL_SELECT_COLTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6196b054 | this.btnSql.Click | FP00597_PlanAmend_Model_PreMix.cs:3012 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00597_EXCEL_SELECT_ROWTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-caa82bd3 | this.btnSql.Click | FP00597_PlanAmend_Model_PreMix.cs:3013 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ff81d70 | this.btnToggleSave.Click | FP00597_PlanAmend_Model_PreMix.cs:2479 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8dc3149 | this.button1.Click | FP00597_PlanAmend_Model_PreMix.cs:2789 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.cbo_fpplanid_changed

진입점: cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a5c9308 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2177 | if (cbo_fpplanid.Items.Count > 0) ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-fee9738e | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2178 | if (cbo_fpplanid.Items.Count > 0) ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-4dd1d4ff | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2185 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-3498bb82 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2186 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-b1b0b067 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2212 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[selected]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-18d75092 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2213 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[selected]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-434e0c72 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2214 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[selected]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-d73101ed | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2215 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[selected]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-b0f6f86b | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2216 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[selected]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-66cb0665 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2218 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-94f2047a | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2219 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-4048a678 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2220 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-f2eeb627 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2221 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-695f58f0 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2222 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-81a09464 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2226 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-a89347c7 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2227 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-57e359c1 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2228 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-599df4f8 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2229 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-551d19de | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2230 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-3db0cb43 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2232 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-d937cbfa | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2233 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-f2fb7f4f | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2234 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-426d9092 | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2235 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-b9a0c67a | cbo_fpplanid.SelectedIndexChanged | FP00597_PlanAmend_Model_PreMix.cs:2236 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6d32259 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:1414 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-3468f27f | this.Load | FP00597_PlanAmend_Model_PreMix.cs:1414 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-8603a645 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:1415 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00597_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-42f268db | this.Load | FP00597_PlanAmend_Model_PreMix.cs:1415 |  | POPUP | new FP00597_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-79b6a9e6 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:1416 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00597_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ad2c158 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:1416 |  | POPUP | new FP00597_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.chk_includeSubOp_onchanged

진입점: this.chk_includeSubOp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51d4fe0c | this.chk_includeSubOp.CheckedChanged | FP00597_PlanAmend_Model_PreMix.cs:2339 | if (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-2071e017 | this.chk_includeSubOp.CheckedChanged | FP00597_PlanAmend_Model_PreMix.cs:2341 | else of (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.chk_Info_CheckedChanged

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6367398a | this.chk_Info.CheckedChanged | FP00597_PlanAmend_Model_PreMix.cs:6536 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c60aca7 | this.chk_Info.CheckedChanged | FP00597_PlanAmend_Model_PreMix.cs:6536 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-792ddef5 | this.chk_Info.CheckedChanged | FP00597_PlanAmend_Model_PreMix.cs:6542 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-83c5e7ed | this.chk_Info.CheckedChanged | FP00597_PlanAmend_Model_PreMix.cs:6543 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.CreateEditPlanBatchDataTable

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN_BATCH" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("BOH_QTY")) ▸ if (dsMainFiltered.Good()) ▸ if (dsPlanSave == null)] / menu_line.Click [if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fdc0e60 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4606 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-0e651eea | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4608 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c4bf15e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4609 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c3ca40b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4610 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-12424cce | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4611 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfd4ea6a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4612 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6be2caa7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4613 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5165d03f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4614 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a357e47f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4615 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8a790bd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4616 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b839f521 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4617 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4eecbb5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4618 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-402569b1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4619 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EQUIPMENT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e16ccee9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4620 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-beaaf807 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4621 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-534eea07 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4622 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e42df796 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4623 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7ef83f1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4624 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-96f15f8c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4625 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CUSTOMER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-62323b7e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4626 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ceffeb3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4627 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae178dd1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4628 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-257caa46 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4629 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a324ce0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4630 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-17527633 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4631 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6bdd419a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4632 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ccf2be44 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4634 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.CreateExelBufferDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b4f4a89 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4962 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-c7faafe5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4963 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb541ed2 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4964 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-64b24a7e | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4965 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8d73c50 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4966 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e93bd176 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4967 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f188b2c9 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4968 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-33512a82 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4969 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-531ce953 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4970 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d203748 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4971 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea2fb035 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4972 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f363212 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4973 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0c81b80 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4974 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EQUIPMENT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-122af2ce | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4975 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-42536642 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4976 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-963af76c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4977 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4495da37 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4978 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1390b58e | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4979 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6985e153 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4980 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3811584 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4981 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-03ee31fa | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4982 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3c706ff | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4983 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a307273d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4984 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-762df40f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4985 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca563e66 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4986 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JOB_ORDER", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ccd6b890 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4989 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bf93e76 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1422 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-3984261c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1433 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-fa66d221 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1434 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-06105375 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1446 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-33795649 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1447 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-288e54fc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1451 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8039030 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1452 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d00e3998 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1456 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f506cc3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1457 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-05066683 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1461 | if (measure["chk_s"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2786298 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1465 | if (measure["chk_i"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "INVENTORY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9e1b363 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1469 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5cdefd5a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1477 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-98fc575d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1478 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-377a7b69 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1482 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0c86c3f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1483 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cf2dd20 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1487 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9f5f56d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1488 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1654d68f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1492 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_s"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f759f2d9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1496 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_i"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "INVENTORY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e3fa00a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1505 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-42f5eef0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1506 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1320f35 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1510 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9250d935 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1511 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c68b75cf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1515 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4693a70 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1516 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-35606cc4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1520 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_s"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c3c2eb0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1524 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_i"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "INVENTORY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd6d3cd1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1533 | if (measure["chk_kg"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("CATE", "KG")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e62e8ea6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1538 | if (measure["chk_batch"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("CATE", "Batch")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d203be3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1542 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d117610 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1545 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-13ada766 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1549 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d6344d7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1554 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2a6b2f79 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1558 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a32bdf3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1560 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76be59af | this.Load | FP00597_PlanAmend_Model_PreMix.cs:412 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e1e2f319 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:413 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb238895 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:414 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-560cc532 | dCalendar_planrange.ValueChanged | FP00597_PlanAmend_Model_PreMix.cs:2313 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d6ff73e | dCalendar_planrange.ValueChanged | FP00597_PlanAmend_Model_PreMix.cs:2319 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-851f563d | dCalendar_planrange.ValueChanged | FP00597_PlanAmend_Model_PreMix.cs:2320 | if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Delete_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c9654f8 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5698 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-23fd83d5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5699 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0d48b5de | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5701 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-71f8918e | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5702 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-fff550e6 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5703 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-c8765873 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5704 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4ebae300 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5705 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ed51cb0b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5706 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7739a076 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5707 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c94a1e32 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5708 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89c4a4f2 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5709 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8a2eb3c3 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5710 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-15050cd0 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5712 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96a20ebe | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5720 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-8a034172 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5724 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-08a55d87 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5725 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9db6fb3 | DeleteButton | FP00597_PlanAmend_Model_PreMix.cs:741 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2cf4b90 | Dispose | FP00597_PlanAmend_Model_PreMix.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.DrawHeader

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day !=…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3111818 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6228 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-364c878a | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6232 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-1c5acaff | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6233 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b57d0f8e | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6234 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11d0950a | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6235 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac5fb1a7 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6236 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-03493a08 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6240 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-ac715993 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6241 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-3de46022 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6242 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-5da95e92 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6243 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-55d71e2a | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6249 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-253b19f8 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6250 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a90d0c0c | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6283 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33daf311 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6288 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6729d551 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6290 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6f11050 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6291 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50727c53 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6292 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-81ea2858 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6294 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-6ce710e2 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6296 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-415b3ebe | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6297 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b10c09fd | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:6302 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.DrawSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0bd5b02 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6309 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-35212572 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6311 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c368eaab | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6321 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-480c858c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6329 | if (dsMainFiltered.Good()) | CALL_EXT | MemoService.ShowMemo | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a56a9fee | EditButton | FP00597_PlanAmend_Model_PreMix.cs:749 | if (spdMain != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0edccd2a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00597_PlanAmend_Model_PreMix.cs:3191 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67300491 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00597_PlanAmend_Model_PreMix.cs:3192 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-44ba7ca8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00597_PlanAmend_Model_PreMix.cs:3193 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-3018d08a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00597_PlanAmend_Model_PreMix.cs:3195 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e00ed57 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00597_PlanAmend_Model_PreMix.cs:3206 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-89d34faa | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00597_PlanAmend_Model_PreMix.cs:3207 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c90ec3c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3248 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32ee1ec1 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3249 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f537bf7 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3250 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-feaac9ff | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3252 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bdb84f3e | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3260 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-4f475fe5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3261 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26adf526 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3266 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.EditByFunc

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN_BATCH" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / menu_line.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equals("Y") && …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-826b2422 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3217 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27e68db4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3219 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb3e4d65 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3220 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-a27e6da3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3222 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-894f53e7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3232 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dcf50156 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3238 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77aeb961 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3240 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.EditCommon

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN_BATCH" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / menu_line.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equals("Y") && …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4377141 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3295 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("BOH_QTY")) ▸ if (new_value < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd46cc66 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3298 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("BOH_QTY")) ▸ if (new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-55ff16f3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3299 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("BOH_QTY")) ▸ if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62838e25 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3304 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("BOH_QTY")) ▸ else of (new_value < 0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7aaabb41 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3307 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("BOH_QTY")) ▸ else of (new_value < 0… | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-bfb6eb98 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3308 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("BOH_QTY")) ▸ else of (new_value < 0… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c44b1fcc | ExcelButton | FP00597_PlanAmend_Model_PreMix.cs:2039 |  | EXCEL | ExportExcel | (0,true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.ExcelPopup_BufferValidation_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd3d64fb | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5221 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8eeeab11 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5246 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1a14e4c0 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5248 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f7b7db46 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5249 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ba610727 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5250 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2d2b83ae | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5251 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-869a284b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5252 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a35d487 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5253 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd24dcf2 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5254 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3acd7f42 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5255 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5cf37118 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5256 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-149b3378 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5257 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05348f1d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5258 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d812dcea | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5259 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["EQUIPMENT_ID"] | data.Tables[0].Rows[i]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a16a0692 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5260 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-49297dc6 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5261 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-230ae0a3 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5262 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bfb20431 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5263 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d125e812 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5264 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sQtyCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ede3ee89 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5265 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SEQ"] | data.Tables[0].Rows[i][sSeqCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f8b113c6 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5274 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | data.Tables[0].Rows[i][sQtyCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cd1d95d8 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5275 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | nIn_KG | 행/컬럼 값 대입 |  |  |  |
| AC-b2054bca | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5276 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Math.Round(Convert.ToUInt32(data.Tables[0].Rows[i][sQtyCol].ToString()) * nYield, 2) | 행/컬럼 값 대입 |  |  |  |
| AC-3dcbfca9 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5276 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | CALL_EXT | Convert.ToUInt32 | (data.Tables[0].Rows[i][sQtyCol].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3af8521 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5277 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Math.Ceiling(nIn_KG * nYield) | 행/컬럼 값 대입 |  |  |  |
| AC-91cb8310 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5279 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7b3be0ea | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5280 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9a583970 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5283 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-34a094c6 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5292 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ff37a81 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5316 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-78dfdfd9 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5321 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0e244e47 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5323 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4ad642c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5326 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-7c3a7158 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5337 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-d5883cf7 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5342 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-a8841bfa | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5347 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1ceb17d1 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5348 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.ExcelPopup_BufferValidation_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8808a58b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5395 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-922ea910 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5397 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-567bc36d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5398 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | data.Tables[0].Rows[i]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-255c330a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5399 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ac20d312 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5400 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b4bd7d59 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5401 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5a9847c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5402 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-665d38b1 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5403 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-79110fe5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5404 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ebe095d5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5405 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b817fba | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5406 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ce776c14 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5407 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-30811e1d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5408 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["EQUIPMENT_ID"] | data.Tables[0].Rows[i]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ba3fbfe9 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5409 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1b830023 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5410 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-88c4f82a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5411 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-928a3e5e | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5412 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9231d304 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5413 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1c51cb08 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5414 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SEQ"] | data.Tables[0].Rows[i]["SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-480d9a79 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5423 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-41c98d6e | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5424 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | nIn_KG | 행/컬럼 값 대입 |  |  |  |
| AC-955db577 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5425 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Math.Round(Convert.ToUInt32(data.Tables[0].Rows[i]["QTY"].ToString()) * nYield, 2) | 행/컬럼 값 대입 |  |  |  |
| AC-f13834c7 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5425 | try ▸ for (i < data.Tables[0].Rows.Count) | CALL_EXT | Convert.ToUInt32 | (data.Tables[0].Rows[i]["QTY"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdd272eb | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5426 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Math.Ceiling(nIn_KG * nYield) | 행/컬럼 값 대입 |  |  |  |
| AC-496cdef2 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5428 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-18433d1f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5429 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8b703aa5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5432 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-19a7cd74 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5435 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fafb3e3 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5455 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ lambda | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-abdb6b2d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5460 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1a86de6d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5462 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfc5ee8a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5465 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) ▸ if (d… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-f60dce8c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5473 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e4cf0707 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5478 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-449a138b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5483 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d1098afe | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5484 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.ExcelPopup_CheckBeforSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cbeefbf | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5002 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Save cannot proceed Release.!") | 메시지 표시 |  |  |  |
| AC-d0ce42eb | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5003 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fa6fc92d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5008 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-286bd764 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5013 | try ▸ if (dtChk.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-138b4e4a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5014 | try ▸ if (dtChk.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0b9a8295 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5017 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-1c72b264 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5021 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.ExcelPopup_SaveExcel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9150a403 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5577 | if (data.Tables[0].Rows.Count > 0) | DATA_OP | Filter["MPP_WPP"] | filter["MPP_WPP"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5f5e42d9 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5587 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.ExcelPopup_SaveExcel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a000edc8 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5636 | if (data.Tables[0].Rows.Count > 0) | DATA_OP | Filter["MPP_WPP"] | filter["MPP_WPP"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7617b058 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5646 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.ExcelPopup_Search_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8d1b4d5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5056 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-5a7b222f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5057 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-8efe9712 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5072 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-6e462de5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5073 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-7c311e0f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5074 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-309f3825 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5076 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-c92ab482 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5086 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-29a68ae0 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5088 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.ExcelPopup_Search_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7ad706d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5101 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-1a9c8a76 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5102 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-1f571bba | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5118 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-6c4a7da1 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5119 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-8b5e6b53 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5120 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-f5d67e3f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5122 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-901aa8fd | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5133 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-68a11232 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5135 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Exec_Procedure

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE")] / SaveButton [try ▸ if (bSaveChk == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f1a8d30 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1988 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00597_AMEND_MODEL_SAVE") ⇒ FP_Planning.PR_UI_FP00597_AMEND_MODEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-d17742bc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1989 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7105f8a7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1991 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-5c383581 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1992 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-774656e7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1993 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b2fb2f69 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1994 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4d69ddbb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1996 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-338a54d1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1997 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1b9274b0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1998 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc333ba3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1999 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ccd15716 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2000 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f1fe47c8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2001 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-acd81edc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2002 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ceec8361 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2003 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-99b7a3f2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2004 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-51c8e8b5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2005 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3b4b4356 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2006 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f81e2ae2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2007 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c554014f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2008 | try | DATA_OP | req.Parameters["p_equipment_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e334529e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2009 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f4836e9d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2010 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8c906eb3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2011 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-924bed82 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2012 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d5a73cd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2013 | try | DATA_OP | req.Parameters["p_seq"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6213fa70 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2015 | try | DATA_OP | req.Parameters["p_adjust_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ea30cd62 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2016 | try | DATA_OP | req.Parameters["p_adjust_in_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3b992e30 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2017 | try | DATA_OP | req.Parameters["p_adjust_in_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6853db54 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2018 | try | DATA_OP | req.Parameters["p_adjust_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-675473c4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2019 | try | DATA_OP | req.Parameters["p_adjust_out_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-22fa892e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2020 | try | DATA_OP | req.Parameters["p_adjust_out_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0242f60f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2022 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-30a1bb49 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2029 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-9b3d36df | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 1 | FP00597_PlanAmend_Model_PreMix.cs:2033 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SELECT")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.Nee…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10f5219b | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:944 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00597_AMEND_MODEL") ⇒ FP_Planning.PR_UI_FP00597_AMEND_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-4e12357f | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:945 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d3517765 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:946 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-82894482 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:947 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-ac439f40 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:948 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-56bd88db | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:949 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b6646e53 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:951 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cc5a16ad | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:952 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5f210b3f | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:953 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-98fcdd0a | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:954 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d63329a2 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:955 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3d958daf | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:956 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0766ae57 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:957 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b3fc65a4 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:958 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f0fc8e61 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:959 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d220d11b | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:960 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-aa0a7979 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:961 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-01e74de9 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:962 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8c742e30 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:963 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f251d425 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:964 | try | DATA_OP | request.Parameters["p_top_item_id"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d9f830ca | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:965 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f2baa443 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:966 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-d8a3b61e | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:967 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-22f99e4f | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:968 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-43aa8e51 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:969 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-6df6f1e3 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:970 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-9d205d63 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:971 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-0ee01d8c | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:972 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-7d2b5268 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:973 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-be28f8af | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:974 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a4632615 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:975 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b197d05f | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:976 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4b70de3c | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:977 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-73166759 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:978 | try | DATA_OP | request.Parameters["p_amend_boh_table"] | Filter["AMEND_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e2ed3c8b | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:979 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-20fc8d00 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:980 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-35b8ea5c | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:981 | try | DATA_OP | request.Parameters["p_amend_capa_table"] | Filter["AMEND_CAPA_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-aa848854 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:983 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-36a4de77 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:984 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e286411f | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:989 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Find_Data_Excel_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9912e154 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5540 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-a5f42593 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5541 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-79489b99 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5543 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-4553e4d1 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5544 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2a61c172 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5545 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4111a212 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5546 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-14407fb0 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5547 | try | DATA_OP | request.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-09e3d5af | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5548 | try | DATA_OP | request.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-8123f972 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5549 | try | DATA_OP | request.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-650ce9e4 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5550 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3b0e62c9 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5551 | try | DATA_OP | request.Parameters["p_site_id"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-3112415f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5552 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-16f7bf93 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5554 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-63359b79 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5556 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-4fdef22d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5561 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Find_Data_Excel_Import

진입점: popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE") ▸ if (popup != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e6a0277 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5151 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL | 엔드포인트 요청 생성 |  |  |  |
| AC-c56a7c8a | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5152 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5ba6f3bd | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5154 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-217accea | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5155 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f7ed76dd | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5156 | try | DATA_OP | request.Parameters["p_sys_gubun"] | gubun | 행/컬럼 값 대입 |  |  |  |
| AC-472104be | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5157 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e71e49a5 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5158 | try | DATA_OP | request.Parameters["p_proc_name"] | procedure_name.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-aa9dcb4e | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5167 | try ▸ if (dsParameter != null && dsParameter.Rows != null && dsParameter.Rows.Count > 0) | CALL_EXT | param.Keys | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7bf1aff | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5181 | try | DATA_OP | request.Parameters["in_columns"] | keys | 행/컬럼 값 대입 |  |  |  |
| AC-b83a1e11 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5182 | try | DATA_OP | request.Parameters["in_row"] | values | 행/컬럼 값 대입 |  |  |  |
| AC-08dfddc9 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5183 | try | DATA_OP | request.Parameters["opt_none"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-469f7c87 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5185 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bb6b5554 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5187 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-e4bdff68 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5192 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-b28aa999 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:5194 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Find_Save_Valid

진입점: popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SELECT")] / SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlanSave.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-364e8e12 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1788 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00597_AMEND_MODEL") ⇒ FP_Planning.PR_UI_FP00597_AMEND_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-60c938e4 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1789 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-5a874b76 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1790 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-c48f40ce | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1791 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ee868552 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1792 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1962c3cf | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1794 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c157e0e6 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1795 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e41033c8 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1796 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-83d50ce4 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1797 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-df6cc650 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1798 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-42268b13 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1799 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d9f7952d | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1800 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4a9618c9 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1801 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f2d0ae80 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1802 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-020c02fd | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1803 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-17043ed1 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1804 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9c9f2ccc | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1805 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-256ec516 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1806 | try | DATA_OP | request.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3434d8e8 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1807 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c98f6fd8 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1808 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b91b8063 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1809 | try | DATA_OP | request.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1635dd17 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1810 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0e54a5ea | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1811 | try | DATA_OP | request.Parameters["p_bucket_from"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-202c4891 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1812 | try | DATA_OP | request.Parameters["p_bucket_to"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0403c6bf | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1813 | try | DATA_OP | request.Parameters["p_day_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6301b6ac | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1814 | try | DATA_OP | request.Parameters["p_week_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9b1c26a8 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1815 | try | DATA_OP | request.Parameters["p_month_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4939cdad | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1816 | try | DATA_OP | request.Parameters["p_cate_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e209dc4c | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1817 | try | DATA_OP | request.Parameters["p_cate_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bd6a176d | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1818 | try | DATA_OP | request.Parameters["p_cate_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ac1bf227 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1819 | try | DATA_OP | request.Parameters["p_amend_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-60bd47ee | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1820 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e553e89d | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1821 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-552da2d0 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1822 | try | DATA_OP | request.Parameters["p_amend_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-999486d2 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1823 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c5f8b62a | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1824 | try | DATA_OP | request.Parameters["p_amend_util_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec49bd36 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1825 | try | DATA_OP | request.Parameters["p_amend_capa_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-73cdccef | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1827 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f27f1f09 | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1829 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-da4fc34b | popSql.OnSql [if (programID == "PR_UI_FP00597_SAVE_VALID_SEL… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1835 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.FindTotalColorStart

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtP…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-612a2f3d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1585 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.FindTotalValue

진입점: popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SELECT")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Table…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c664a581 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:865 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00597_AMEND_MODEL") ⇒ FP_Planning.PR_UI_FP00597_AMEND_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-5ed0c0d4 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:866 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-118abbcb | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:867 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_TOTAL_VALUE" | 행/컬럼 값 대입 |  |  |  |
| AC-8dc55db2 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:868 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0af2cb82 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:869 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-913e4a3f | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:871 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d8afe321 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:872 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a3fc7bdf | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:873 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-710fe879 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:874 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-62406f33 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:875 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9da76aab | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:876 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e5346d72 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:877 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-63be6162 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:878 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cbd83477 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:879 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-afb9b9f4 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:880 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ae9d6857 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:881 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b9845a43 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:882 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e0afc5a6 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:883 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d487a39e | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:884 | try | DATA_OP | request.Parameters["p_top_item_id"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5905653c | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:885 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2d842419 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:886 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-5010fce7 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:887 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-b94f50ec | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:888 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-1f9461fa | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:889 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-ca0271f2 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:890 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-0a103e0c | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:891 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-912eed53 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:892 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-a53ada70 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:893 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ea02fd19 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:894 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-5d9bc869 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:895 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8acfb931 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:896 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b6cf273f | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:897 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-50361b32 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:898 | try | DATA_OP | request.Parameters["p_amend_boh_table"] | Filter["AMEND_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-680e8c6b | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:899 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f7d2f604 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:900 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-95903224 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:901 | try | DATA_OP | request.Parameters["p_amend_capa_table"] | Filter["AMEND_CAPA_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ec9e52d1 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:903 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2877d787 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:906 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-1f1a8065 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 7 | FP00597_PlanAmend_Model_PreMix.cs:914 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-112af0f4 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:223 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SELECT") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09063bd8 | popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SE… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:3743 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.GetListDataSet

진입점: popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tab…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df4a1abb | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1160 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00597_find_ListData", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-94975506 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1162 | try | FLAG | dsListData | dtList.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-031f1341 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1162 | try | DATA_OP | dtList.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9c4511fa | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1163 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_UOMInfo", Filter["DIVISION_ID"].ToString(), Filter["SITE_ID… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-93b69b77 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1165 | try | FLAG | dsUomInfo | dtUom.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-39bf3d08 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1165 | try | DATA_OP | dtUom.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6955064d | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1167 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_YieldInfo_Child", Filter["INSTANCE_ID"].ToString(), Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-492eeece | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1170 | try | FLAG | dsYieldInfo | dtYield.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-3f6fcb60 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1170 | try | DATA_OP | dtYield.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-233505fb | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1174 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-db6d402c | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1175 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.GetOperation

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-845b53a1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6798 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-e60b7af5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6798 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-689a9e49 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6800 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5c7e90a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4733 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-7fabb0cf | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:4734 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.GetToDay

진입점: sCalendar_planday.DateTimeChanged / popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE") ▸ lambda ▸ else of (dt != null)] / this.btnExcelImport.Click [else of (dt != null)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda ▸ else of (dt != null)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56e1ca6a | sCalendar_planday.DateTimeChanged 외 9 | FP00597_PlanAmend_Model_PreMix.cs:4068 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-063b6731 | sCalendar_planday.DateTimeChanged 외 9 | FP00597_PlanAmend_Model_PreMix.cs:4069 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-874ffa0d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1280 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (colindex_batch … | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex_batch, rowindex, colindex_batch, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-689cc868 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1282 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (colindex_batch … | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex_seq, rowindex, colindex_seq, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d39be85 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1298 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-adb7100b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1300 | if (do_edit_mode) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0ca9d40e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1310 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.LockRange | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1cc5a41b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1311 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-115d829f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1325 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (calendar != null) ▸ foreach (var week_item in calendar.Weeks) ▸ if (wee… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-f3ca7efc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1342 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (m… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16b52d28 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:308 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff50f7b9 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:312 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-93e1a438 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:313 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-faa85571 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:317 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-5ddbad50 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:319 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-3055b1c4 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:323 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a8f2922 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:331 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a0dea9b1 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:336 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-c907d7f6 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:338 | try | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9cb2013d | this.Load | FP00597_PlanAmend_Model_PreMix.cs:350 | try | FLAG | _sToDay | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-902d5ad0 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:359 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-5b495ffd | this.Load | FP00597_PlanAmend_Model_PreMix.cs:360 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c4009038 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:361 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-02432e74 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:362 | try ▸ if (adminAuth == false) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dfee2a75 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:365 | try | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9ff5f7d4 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:371 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.InitEditingBuf

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmen…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26b85c03 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:4074 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f359d807 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:4077 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-edd8c043 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:4081 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-c237987e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:4091 | if (dsPlanSave.Good()) | STATE_RESET | dsPlanSave.Tables[0].Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99b5517a | this.Load | FP00597_PlanAmend_Model_PreMix.cs:272 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-29b422dc | this.Load | FP00597_PlanAmend_Model_PreMix.cs:273 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d2d89151 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:275 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-0908cdff | this.Load | FP00597_PlanAmend_Model_PreMix.cs:276 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-17a749e2 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:277 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-128e6564 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:278 |  | UI_PROP | mcbo_planner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-05831a8a | this.Load | FP00597_PlanAmend_Model_PreMix.cs:279 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.InitSpread

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5541470 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:427 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-878d9b06 | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:428 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-41320a0a | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:430 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1c4090ee | this.Load 외 11 | FP00597_PlanAmend_Model_PreMix.cs:434 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Insert_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faaa12c5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5497 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00596_EXCELIMPORT", "insert_Excel_buffer", dsData) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-38697f8a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5501 | try ▸ if (result.Good()) | DATA_OP | result.Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b7ec170c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5513 | try ▸ if (result.Good()) ▸ if (result.Columns.Contains("RESULT")) ▸ else of (result.Rows[0]["RESULT"].ToString().ToUpper() == "SUCCESS") ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d817c2c1 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5521 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-9d5ebdfa | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5525 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-1005a57a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5526 | catch ((Exception ex)) | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c7a4776 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:696 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8a650e7d | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:701 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | MESSAGE | MessageBox.Show | ("Can not be selected [Total] Row.!") | 메시지 표시 |  |  |  |
| AC-945e55f9 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:702 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5967b6c9 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:706 | if (row != null) | POPUP | new FP00596_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-7a4cb202 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:707 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-978af0b9 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:707 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4063dba6 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:709 | if (row != null) | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a457516 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:710 | if (row != null) | DATA_OP | popup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-48c7a273 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:711 | if (row != null) | DATA_OP | popup.Filter["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fc0467f6 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:712 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-635d966a | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:713 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-55c49fde | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:714 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-31d8d494 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:715 | if (row != null) | DATA_OP | popup.Filter["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5bf29f8a | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:716 | if (row != null) | DATA_OP | popup.Filter["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bbf87e08 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:717 | if (row != null) | DATA_OP | popup.Filter["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-45dfb562 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:718 | if (row != null) | DATA_OP | popup.Filter["NICK_NAME"] | row["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bf23d5b3 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:719 | if (row != null) | DATA_OP | popup.Filter["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6c8765a7 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:720 | if (row != null) | DATA_OP | popup.Filter["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-daac6a59 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:721 | if (row != null) | DATA_OP | popup.Filter["MARKET"] | row["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a76c8da8 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:723 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e2cb1ba8 | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:725 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a7884a1f | InsertButton | FP00597_PlanAmend_Model_PreMix.cs:733 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c92a5ae2 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:2046 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00597_PlanAmend_Model_PreMix.lfn_getYieldInfo

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN_BATCH" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("BOH_QTY")) ▸ if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0)] / menu_li…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ad7f117 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4651 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_YieldInfo", pDivision, pSite, pPlant, pFactory, pOperation,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-94f7d366 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4657 | if (dtYieldOut != null) ▸ if (dtYieldOut.Rows.Count == 0) | RETURN | return nVal; |  | 처리 중단/반환 |  |  |  |
| AC-2da13b55 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4666 |  | RETURN | return nVal; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.lfn_getYieldInfo_Excel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-227f8393 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5834 | if (!string.IsNullOrEmpty(sColName) && sDay == "") ▸ lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a5f1217 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5850 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e9cb55a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5851 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4e0dbc4 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5852 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e03c6b7 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5853 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-354716da | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5854 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f01a75e3 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5855 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f800b1c5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5855 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2594b855 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5870 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.lfn_setExchangeBatch

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN_BATCH" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("BOH_QTY")) ▸ if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0)] / menu_li…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c12f0067 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4680 | else of (sAppendex.Equals("KG")) | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-822a8f21 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4689 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-56333731 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4690 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7dbc6938 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4691 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-aee70ea4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4692 | lambda | DATA_OP | x.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1f8591e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4689 | lambda | RETURN | return (x.Field<string>("FACTORY_ID") == row["FACTORY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-b2ecea0a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4714 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.lfn_setExchangeBatch_Excel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeee58e6 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5745 | if (!string.IsNullOrEmpty(sColName) && sDay == "") ▸ lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8c999b5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5767 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-b88bda23 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5774 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-594bb076 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5775 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f2d5617c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5776 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e3f616e | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5777 | lambda | DATA_OP | each_row.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2d7b953 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5794 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3404021c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5795 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f251dd2 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5796 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0b13a27 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5797 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3090697a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5798 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d6ab4da | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5799 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4d10e56f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5799 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d681aa8c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5817 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.lfn_setReleaseProcess

진입점: popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cda05b51 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1132 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-be43c762 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1146 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ if (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCurrDate… | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d8e55185 | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1148 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ else of (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCur… | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-f7a1d5cd | popSql.OnSql [if (programID == "PR_UI_FP00597_EXCEL_SELECT_C… 외 8 | FP00597_PlanAmend_Model_PreMix.cs:1152 |  | RETURN | return dtMapData; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.MakeMemoFontBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2edd880 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:1393 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-36486dd1 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:1397 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.onAlarmMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-288bd0dd | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3656 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f457372b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3659 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e817579 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3663 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-450b5a8c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3667 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-2377e9b9 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3667 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b33717d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3669 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-0f546bb9 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3670 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-6a68b708 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3670 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0c50c167 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3671 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-cc5cea72 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3672 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ff5eb68a | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3673 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-67b049c7 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3677 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2331ef4c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3679 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1ff9b995 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3684 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45fae18a | memo_menu.Click | FP00597_PlanAmend_Model_PreMix.cs:3638 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd6ba400 | memo_menu.Click | FP00597_PlanAmend_Model_PreMix.cs:3641 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2583d237 | memo_menu.Click | FP00597_PlanAmend_Model_PreMix.cs:3645 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d096c90 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3692 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8e00cf0 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3695 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3bf7930 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3713 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-2792850b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3714 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0ac48531 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3715 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ec60a289 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3716 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-50f01361 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3717 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-77081205 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3718 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-4061d9a6 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3719 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f9ecb82b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3720 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b0ebfbdd | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:3721 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bcf40fb | bucke_menu.Click | FP00597_PlanAmend_Model_PreMix.cs:3378 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-323a94cb | bucke_menu.Click | FP00597_PlanAmend_Model_PreMix.cs:3381 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.onZeroLineMenu

진입점: menu_line.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf92b9c1 | menu_line.Click | FP00597_PlanAmend_Model_PreMix.cs:3434 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33249c31 | menu_line.Click | FP00597_PlanAmend_Model_PreMix.cs:3437 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb6c1739 | menu_line.Click | FP00597_PlanAmend_Model_PreMix.cs:3488 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.onZeroMaterialMenu

진입점: menu_material.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a510ada | menu_material.Click | FP00597_PlanAmend_Model_PreMix.cs:3543 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0da8aefe | menu_material.Click | FP00597_PlanAmend_Model_PreMix.cs:3546 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0932f99f | menu_material.Click | FP00597_PlanAmend_Model_PreMix.cs:3591 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-290fbc75 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6774 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-e55961b5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6774 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2a645421 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6776 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-64d27348 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6777 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-84536113 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6777 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7abe27b7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6778 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-04e9e68b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6779 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ddd907cb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6780 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9a6e82e9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6784 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e0e033e0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6786 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b919f718 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6791 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d93a830 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6734 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-f6821c9e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6735 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-110944e2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6736 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-9cee6b58 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6736 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3a66b6e0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6737 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-d56af949 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6738 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-467e04eb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6739 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-50dc820c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6743 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f86d1662 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6745 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c649e175 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6751 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-48963ff2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6752 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-fc195cb0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6753 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-5b78db89 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6753 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c9882d09 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6754 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-aaeca68f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6755 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5e82daa0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6756 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e80dbcad | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6760 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4b5c2441 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6762 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.planday_changed

진입점: sCalendar_planday.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bfef298 | sCalendar_planday.DateTimeChanged | FP00597_PlanAmend_Model_PreMix.cs:2132 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c5cefcb | sCalendar_planday.DateTimeChanged | FP00597_PlanAmend_Model_PreMix.cs:2136 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-c5b6c52b | sCalendar_planday.DateTimeChanged | FP00597_PlanAmend_Model_PreMix.cs:2143 | else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Query

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f6cf796 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6352 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-e088a1e2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6352 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e8a6ea8d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6353 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f73f740b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6358 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-81081c67 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6381 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-f0b5f398 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6387 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-56e8deb1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6387 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6f7bda85 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6388 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-09b59a74 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6388 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5d43b7c0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6391 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f1748c28 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6398 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-f6032423 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6403 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e0a6de9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6404 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1a5e109 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6406 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.RefreshHeadAndBody

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1249e97 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6193 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b49f520c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6209 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-28f1e389 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6213 | finally | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5d8250be | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6214 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afed71bd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6169 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-3d83574a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6169 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-d2b845ac | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6181 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-4846210d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6186 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8391351 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4795 | if (programID == "PR_UI_FP00597_AMEND_MODEL_SELECT") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-c540e1b0 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4799 | if (programID == "PR_UI_FP00597_TOTAL_VALUE_SELECT") | RETURN | return FindTotalValue("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-8e9623c9 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4803 | if (programID == "PR_UI_FP00597_SAVE_VALID_SELECT") | RETURN | return Find_Save_Valid("SQL", "FIND_AMEND_VALIDATION_PMIX"); |  | 처리 중단/반환 |  |  |  |
| AC-53ef38d3 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4818 | if (programID == "PR_UI_FP00597_AMEND_MODEL_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "REL… | MESSAGE | MessageBox.Show | ("there can't Veiw Query[Relase].") | 메시지 표시 |  |  |  |
| AC-50ec7006 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4819 | if (programID == "PR_UI_FP00597_AMEND_MODEL_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "REL… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-07162427 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4822 | if (programID == "PR_UI_FP00597_AMEND_MODEL_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] ==… | RETURN | return Save_Data_Amend(dtData, "MERGE_DATA", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-8ebb185f | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4826 | if (programID == "PR_UI_FP00597_AMEND_MODEL_DATA_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_IN_BATCH.") | 메시지 표시 |  |  |  |
| AC-b3a908b5 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4827 | if (programID == "PR_UI_FP00597_AMEND_MODEL_DATA_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-fd5288bd | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4832 | if (programID == "PR_UI_FP00597_AMEND_MODEL_DATA_SAVE") ▸ else of (dtData != null) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_IN_BATCH.") | 메시지 표시 |  |  |  |
| AC-847cb47a | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4833 | if (programID == "PR_UI_FP00597_AMEND_MODEL_DATA_SAVE") ▸ else of (dtData != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8abfb237 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4844 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE") | POPUP | new FP00607_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e505afa6 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4848 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.DateColumnType | FPExtensions.DateColumnType.CELL | 속성 DateColumnType 설정 |  |  |  |
| AC-6ac21202 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4850 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-1871fa7c | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4851 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-06660085 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4852 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-90b4a4b0 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4854 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-f06ea5a0 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4861 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00597_AMEND_MODEL_EXCEL", Filter… |  | 처리 중단/반환 |  |  |  |
| AC-bf0561b0 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4873 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_ROWTYPE") | POPUP | new FP00607_RowExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0acb1b7a | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4878 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-154ccc00 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4879 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-e841b1fe | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4880 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-6c1b93f4 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4882 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-a647ca52 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4888 | if (programID == "PR_UI_FP00597_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00597_AMEND_MODEL_EXCEL", Filter… |  | 처리 중단/반환 |  |  |  |
| AC-2e1d8ba6 | popSql.OnSql | FP00597_PlanAmend_Model_PreMix.cs:4894 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Save_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE")] / SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlanSave.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9eea417 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1926 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00597_AMEND_MODEL_SAVE") ⇒ FP_Planning.PR_UI_FP00597_AMEND_MODEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-84313ba2 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1927 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5670733f | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1929 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b079780e | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1930 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f2143809 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1931 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-6323cf76 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1932 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-62e319ba | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1933 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-66cc3668 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1934 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-71e63648 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1935 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-5dd04138 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1936 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-f048a729 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1937 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f97ebd26 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1938 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-8821c907 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1939 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-87d76705 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1940 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-14318b11 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1941 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-b7b6d9d6 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1942 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-60c7565e | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1943 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-b211001b | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1944 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-ca08d6ad | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1945 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_equipment_id"] | p_equipment_id | 행/컬럼 값 대입 |  |  |  |
| AC-4cc4c601 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1946 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0a09f0a3 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1947 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-76b9e9f0 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1948 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-f875ab8b | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1949 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-4068eda0 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1950 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-c09e236a | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1951 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_in_qty"] | p_adjust_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-25f14b8c | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1952 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_in_qty_batch"] | p_adjust_in_qty_batch | 행/컬럼 값 대입 |  |  |  |
| AC-4fc7cd19 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1953 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_in_qty_kg"] | p_adjust_in_qty_kg | 행/컬럼 값 대입 |  |  |  |
| AC-d5893b73 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1954 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_out_qty"] | p_adjust_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-54f94040 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1955 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_out_qty_batch"] | p_adjust_out_qty_batch | 행/컬럼 값 대입 |  |  |  |
| AC-a421ab2d | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1956 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_adjust_out_qty_kg"] | p_adjust_out_qty_kg | 행/컬럼 값 대입 |  |  |  |
| AC-ba52baa0 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1958 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bb8e6e91 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1959 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e9e15a88 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1965 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2cb87214 | popSql.OnSql [if (programID == "PR_UI_FP00597_AMEND_MODEL_DA… 외 1 | FP00597_PlanAmend_Model_PreMix.cs:1971 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Save_Data_Excel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d4d9418 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5599 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-bf69e685 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5600 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-809f9552 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5602 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-7c866936 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5603 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-935760d0 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5604 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-61f7d8c0 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5605 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c2968f8e | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5606 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-fe09b60c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5607 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-976e9a78 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5608 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c80cabc6 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5609 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f572584 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5610 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-888ba95c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5611 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | pMppWpp | 행/컬럼 값 대입 |  |  |  |
| AC-726603ea | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5613 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0db46c80 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5615 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-88e4cb75 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5620 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-3de4ab77 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5622 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Save_Data_Excel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ece08988 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5658 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-ca218a40 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5659 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f1eafdda | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5661 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-e10eead5 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5662 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-799c6b91 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5663 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-27f30535 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5664 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0d629264 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5665 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-e028d24f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5666 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-01a7b363 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5667 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f943154b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5668 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-255af64c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5669 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-bdfea596 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5670 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ae9d90bf | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5672 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-23283fcc | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5674 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-c28aa216 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5679 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-65656d61 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5681 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.Save_PIanBatch_Data

진입점: SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlanSave.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85cca456 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1632 | if (siMain == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-72546997 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1634 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d5c0756a | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1639 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-36330226 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1640 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-47d4988f | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1645 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-50fa843d | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1656 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b0942f2a | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1669 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93c04075 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1670 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8c10e34f | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1681 | try ▸ if (dsValidation != null) ▸ lambda | DATA_OP | x.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0bf8027f | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1681 | try ▸ if (dsValidation != null) ▸ lambda | RETURN | return (x.Field<string>("_VALID") == "N"); |  | 처리 중단/반환 |  |  |  |
| AC-565e8597 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1690 | try ▸ if (dsValidation != null) ▸ if (valid.Count() > 0) ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-1c0ae252 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1694 | try ▸ if (dsValidation != null) ▸ if (valid.Count() > 0) | POPUP | new FP00596_InValidationPopup | ("InValidationPopup", dsValidation, sMsg) | 팝업/폼 생성 |  |  |  |
| AC-58486c20 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1695 | try ▸ if (dsValidation != null) ▸ if (valid.Count() > 0) | UI_PROP | popPreMixValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5fe657e1 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1696 | try ▸ if (dsValidation != null) ▸ if (valid.Count() > 0) | POPUP | popPreMixValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ee41c564 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1698 | try ▸ if (dsValidation != null) ▸ if (valid.Count() > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4f595557 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1706 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("It can not be PLAN_TYPE[RELEASE]", "FP", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-3a3cd351 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1707 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-44034983 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1714 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4492701a | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1754 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-14572bcd | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1755 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-92bae845 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1760 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c0668460 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1763 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-42bb47c2 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1765 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-1b4e47be | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1769 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8ab22d18 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1770 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8f9a02f7 | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1771 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-17b74ccb | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1772 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a5a68e9a | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1776 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4feb011e | SaveButton [try ▸ if (dsPlanSave != null) ▸ try ▸ if (dsPlan… | FP00597_PlanAmend_Model_PreMix.cs:1777 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-009dd9e2 | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:760 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c80b146 | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:764 | try | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d8a3470d | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:786 | try ▸ if (dsPlanSave != null) ▸ catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-daf126c7 | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:794 | try ▸ if (bSaveChk == true) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fcd4ccbb | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:799 | try ▸ if (bSaveChk == true) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f860db82 | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:802 | try ▸ if (bSaveChk == true) ▸ try ▸ if (!bRtn1) | MESSAGE | MessageBox.Show | ("EXEC_PSICALCUL is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informat… | 메시지 표시 |  |  |  |
| AC-a454e269 | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:807 | try ▸ if (bSaveChk == true) ▸ catch () | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4fb8ef5d | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:808 | try ▸ if (bSaveChk == true) ▸ catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-78f099ca | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:815 | try ▸ if (bSaveChk == true) | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-6789a9bf | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:816 | try ▸ if (bSaveChk == true) | STATE_RESET | dsPlanSave.Tables[0].Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e3a165be | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:830 | try | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3dd6ddfc | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:834 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1ebf811d | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:835 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a912913b | SaveButton | FP00597_PlanAmend_Model_PreMix.cs:839 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SearchListInfoAll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b566ec0e | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5035 |  | FLAG | dtDimension | siMain.GetSpdTitle(sProgramID, sUserID, sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b493ca3 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5035 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-473899bf | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5038 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_UOMInfo_ALL") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-849754cf | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5039 |  | FLAG | dsUomInfoAll | dtUomAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-fdfbaec2 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5039 |  | DATA_OP | dtUomAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d36b348f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5041 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_find_YieldInfo_Child", Filter["INSTANCE_ID"].ToString(), Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-20ff6ed4 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5042 |  | FLAG | dsYieldInfoAll | dtYieldAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a2fc7c10 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:5042 |  | DATA_OP | dtYieldAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetBasisTime

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.btnRelease2.Click [if (sConfirmArea == "PLAN GROUP")] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ad9e79e | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3759 |  | FLAG | dtBaseTime | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findBasisTime", sInstance,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4d967378 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3759 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findBasisTime", sInstance, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetBohTotalQty

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (le…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db17ccab | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1597 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c3a46762 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1602 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-b9187661 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1607 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-558b0cd8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1608 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-84fc0494 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1610 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-418d3f9a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1612 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3f366ec | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1613 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bdc7dbdd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1614 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-084d2b6a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:1618 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetCalenderColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aea5c90e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6473 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-844e4d1b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6477 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-88c53485 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6479 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6662cfa | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6483 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-4cb3a82f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6499 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-0a2998b0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6514 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetColumnChangeByText

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71541fb4 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:465 | if (iColMinStartIndex <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61c22c3c | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:470 | try | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-bdcbd56d | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:472 | try | FLAG | DateCellType | new FarPoint.Win.Spread.CellType.DateTimeCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-c49c150e | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:474 | try | FLAG | MaskcellType | new FarPoint.Win.Spread.CellType.MaskCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-329bfb6f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:475 | try | UI_PROP | MaskcellType.Mask | "####-##-##" | 속성 Mask 설정 |  |  |  |
| AC-77a08137 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:479 | try | UI_PROP | DateCellType.DateTimeFormat | FarPoint.Win.Spread.CellType.DateTimeFormat.UserDefined | 속성 DateTimeFormat 설정 |  |  |  |
| AC-0d2f73a4 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:480 | try | UI_PROP | DateCellType.UserDefinedFormat | "yyyy-MM-dd" | 속성 UserDefinedFormat 설정 |  |  |  |
| AC-0a362043 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:490 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36c5dd3b | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:492 | try | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-c76a65d0 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:510 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k,i].CellType | MaskcellType | 그리드 속성/값 설정 |  |  |  |
| AC-e36cb8ec | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:512 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].Value | sData | 그리드 속성/값 설정 |  |  |  |
| AC-fb821aa4 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:516 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-8d9e938f | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:517 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-b11aee13 | (진입점 미연결) | FP00597_PlanAmend_Model_PreMix.cs:527 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0873f16 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:243 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b8d265b | this.Load | FP00597_PlanAmend_Model_PreMix.cs:245 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-50dce714 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:246 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fb17665d | this.Load | FP00597_PlanAmend_Model_PreMix.cs:247 | if (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e20a4a01 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:251 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-285ba499 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:252 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cf74016f | this.Load | FP00597_PlanAmend_Model_PreMix.cs:253 | else of (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-91deb4a9 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:255 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-bbde2b6e | this.Load | FP00597_PlanAmend_Model_PreMix.cs:256 |  | CALL_EXT | UserService.HasSuperRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-64fa0d12 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:258 | if (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-5bd391f6 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:259 | if (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-68ae46f9 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:260 | if (UserService.HasSuperRole(_CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9c20cefe | this.Load | FP00597_PlanAmend_Model_PreMix.cs:264 | else of (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-818ece88 | this.Load | FP00597_PlanAmend_Model_PreMix.cs:265 | else of (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-32e624fd | this.Load | FP00597_PlanAmend_Model_PreMix.cs:266 | else of (UserService.HasSuperRole(_CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetDirty

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN_BATCH" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / menu_line.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equals("Y") && …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e070ccf6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:4054 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetDivision

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba43b10f | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3769 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-54f85b8a | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3769 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e1f05201 | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3770 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetFactory

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / cbo_fpplanid.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc722c96 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3960 |  | FLAG | dtFactoryAmend | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findFactoryCode_amend_common", Fil… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-99a7ad13 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3960 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findFactoryCode_amend_common", Filter["INSTANCE_ID"], Filter["PLAN_ID"] … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a09db7ef | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3963 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (dtInstance.Good())] / mcbo_planner.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) ▸ if (dtPlanId.Rows.Count > 0)] / cbo_fpplanid.SelectedIndexChanged [if (cbo_fpplanid.Items.Count > 0)] / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / mcbo_line.SelectedIndexChanged / txtItem.TextChanged / dCalendar_planrange.ValueChanged / ch…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a612fcde | this.Load [try] 외 24 | FP00597_PlanAmend_Model_PreMix.cs:3738 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetFpPlanId

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.btnRelease2.Click [if (sConfirmArea == "PLAN GROUP")] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e59427ae | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3875 |  | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00597_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-cda3bca1 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3875 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00597_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d19cc18 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3876 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-cb7245fb | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3879 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-7be70af9 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3881 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | cbo_fpplanid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-02ccf1fa | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3899 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[0]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-43b42cf4 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3900 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[0]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-9e6a1249 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3901 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[0]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-de40f65c | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3902 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[0]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-ab604388 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3903 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[0]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-c968b5aa | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3905 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-bb98dd99 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3906 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-66449626 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3907 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-d884d7a0 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3908 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-c793a5de | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3909 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-1bb11fd3 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3924 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-d00d65ca | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3925 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-1fc955c4 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3926 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-2b5968d8 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3927 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-1a2f96b2 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3928 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-a1d2f533 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3930 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-6e54cadd | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3931 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-e94ef17e | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3932 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-f61c8d11 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3933 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-31e4e342 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3934 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetLine

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_planner.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / chk_allLine.CheckedChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85ed6294 | this.Load [try] 외 5 | FP00597_PlanAmend_Model_PreMix.cs:3982 |  | DATA_OP | Filter["ALL_LINE"] | chk_allLine.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-763c187a | this.Load [try] 외 5 | FP00597_PlanAmend_Model_PreMix.cs:3985 |  | FLAG | dtLine | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00596_findLineCode_List", Filter… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-70d1a555 | this.Load [try] 외 5 | FP00597_PlanAmend_Model_PreMix.cs:3985 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00596_findLineCode_List", Filter["INSTANCE_ID"], Filter["PLAN_ID"] , F… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-00c039b8 | this.Load [try] 외 5 | FP00597_PlanAmend_Model_PreMix.cs:3989 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetOperation

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / this.chk_includeSubOp.CheckedChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acb4d6d3 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3971 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-cba08787 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3971 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-911e9d22 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3973 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetPlanDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78e90b3e | this.Load [try] | FP00597_PlanAmend_Model_PreMix.cs:3749 |  | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetPlanGroup

진입점: this.Load [try] / popSql.OnSql [if (programID == "PR_UI_FP00597_TOTAL_VALUE_SELECT") ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3acc2e9f | this.Load [try] 외 8 | FP00597_PlanAmend_Model_PreMix.cs:3843 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findAmendInstanceList_common", lv_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-420effb5 | this.Load [try] 외 8 | FP00597_PlanAmend_Model_PreMix.cs:3843 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findAmendInstanceList_common", lv_amendInstance, _sSaveAuth) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33d89f19 | this.Load [try] 외 8 | FP00597_PlanAmend_Model_PreMix.cs:3845 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-8c02a011 | this.Load [try] 외 8 | FP00597_PlanAmend_Model_PreMix.cs:3847 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetPlanInBatch_DataSet

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_IN_BATCH" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (ColumnName_Buf.ToUpper().Equals("BOH_QTY"))] / menu_line.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ forea…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f9b2160 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4118 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-577e8ecb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4119 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-0a5ebedf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4120 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-2ce41dd6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4121 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-61fc3315 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4134 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dbf05e1c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4144 | if (dsMainFiltered.Good()) ▸ if (org_value == new_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-85985985 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4148 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00597_find_ListData", Filter["INSTANCE_ID"].ToString(), Filter["PLANT_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45a5d6a7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4149 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | FLAG | dsListData | dtListData.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-66ea62a3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4149 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | DATA_OP | dtListData.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bc10964e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4159 | if (dsMainFiltered.Good()) ▸ if (dsPlanSave == null) | FLAG | dsPlanSave | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-2a7e6510 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4160 | if (dsMainFiltered.Good()) ▸ if (dsPlanSave == null) | DATA_OP | dsPlanSave.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c968690 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4277 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-37f350be | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4278 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d5b6c70e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4279 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-62bc050f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4280 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6c2ca51 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4281 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d75cd431 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4282 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1083b47 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4283 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-671ec2d1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4284 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-caea4d8e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4285 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bcf92bae | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4286 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dcbf5ce0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4287 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-73e8738c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4288 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-d230e89f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4289 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6e2e227 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4290 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fae364f4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4277 | if (dsMainFiltered.Good()) ▸ lambda | RETURN | return (x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString() … |  | 처리 중단/반환 |  |  |  |
| AC-c84ebcae | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4313 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | row1["ADJUST_IN_QTY"] | Math.Round(Convert.ToDecimal(nInValue), 2) | 행/컬럼 값 대입 |  |  |  |
| AC-a8a09f5d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4314 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | row1["ADJUST_OUT_QTY_BATCH"] | Math.Round(Convert.ToDecimal(nOutValue), 2) | 행/컬럼 값 대입 |  |  |  |
| AC-d063a578 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4315 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | row1["ADJUST_IN_QTY_KG"] | Math.Round(Convert.ToDecimal(nIn_KG)) | 행/컬럼 값 대입 |  |  |  |
| AC-4358ba9b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4317 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | row1["ADJUST_OUT_QTY"] | Math.Round(Convert.ToDecimal(nOutValue), 2) | 행/컬럼 값 대입 |  |  |  |
| AC-1f97834a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4318 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | row1["ADJUST_IN_QTY_BATCH"] | Math.Round(Convert.ToDecimal(nInValue), 2) | 행/컬럼 값 대입 |  |  |  |
| AC-f36f78d1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4319 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | row1["ADJUST_OUT_QTY_KG"] | Math.Round(Convert.ToDecimal(nOut_KG)) | 행/컬럼 값 대입 |  |  |  |
| AC-d11ad364 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4329 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-821fb77d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4330 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-708f001a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4331 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4409c77 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4332 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f01e707 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4333 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b3c9e82 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4334 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e800773 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4335 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7bbbae5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4336 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c83c407d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4337 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a616164 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4338 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4a8d433 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4329 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ lambda | RETURN | return (x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString() … |  | 처리 중단/반환 |  |  |  |
| AC-5029d8cf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4374 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtNew.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1fb47ce5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4376 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-55e0daf7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4377 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c55ddb6f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4378 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | clicked_row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1d6bcfff | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4379 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | clicked_row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-397ac174 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4380 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SITE_ID"] | clicked_row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e2a63be7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4381 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | clicked_row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7329d464 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4382 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | clicked_row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-045c1457 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4383 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LOCATION"] | clicked_row["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-817253c2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4384 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | clicked_row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-926e5c77 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4385 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LINE_ID"] | clicked_row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-091035ef | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4386 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ELECTRODE_TYPE"] | clicked_row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-64f49dad | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4387 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["EQUIPMENT_ID"] | clicked_row["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3610e0fa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4388 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-773050ce | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4389 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["TOP_ITEM_ID"] | clicked_row["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7e39f531 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4390 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd6e7105 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4391 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PRODUCTION_TYPE"] | clicked_row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d65d2ac | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4392 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["MARKET"] | clicked_row["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-9e82eeb2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4393 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["CUSTOMER_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1bf3084f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4394 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SEQ"] | nSeqTmp | 행/컬럼 값 대입 |  |  |  |
| AC-9c5d2d71 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4396 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_IN_QTY"] | Math.Round(Convert.ToDecimal(nInValue), 2) | 행/컬럼 값 대입 |  |  |  |
| AC-74772db5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4397 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | Math.Round(Convert.ToDecimal(nInValue), 2) | 행/컬럼 값 대입 |  |  |  |
| AC-362fb0da | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4398 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | Math.Round(Convert.ToDecimal(nIn_KG)) | 행/컬럼 값 대입 |  |  |  |
| AC-d9288fe2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4399 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_OUT_QTY"] | Math.Round(Convert.ToDecimal(nOutValue), 2) | 행/컬럼 값 대입 |  |  |  |
| AC-46fec77c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4400 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Math.Round(Convert.ToDecimal(nOutValue), 2) | 행/컬럼 값 대입 |  |  |  |
| AC-b34a17c3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4401 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Math.Round(Convert.ToDecimal(nOut_KG)) | 행/컬럼 값 대입 |  |  |  |
| AC-6383ac41 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4405 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtNew.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c627389 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4408 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (dsPlanSave == null) | FLAG | dsPlanSave | dtNew.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-49841a11 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4411 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ else of (dsPlanSave == null) | DATA_OP | dsPlanSave.Tables["Table"].ImportRow | (dtNew.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9411b3c5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4445 | if (dsMainFiltered.Good()) ▸ if (measure["chk_inqty"].Value == "true" && measure["chk_kg"].Value == "true") | GRID_SET | siMain.ActiveSheet.Cells[cRow-1, cCol].Value | Math.Round(nIn_KG) | 그리드 속성/값 설정 |  |  |  |
| AC-b8272f4e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4450 | if (dsMainFiltered.Good()) ▸ if (measure["chk_outqty"].Value == "true" && measure["chk_kg"].Value == "true") | GRID_SET | siMain.ActiveSheet.Cells[cRow + 1, cCol].Value | Math.Round(nOut_KG) | 그리드 속성/값 설정 |  |  |  |
| AC-ab149bca | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4455 | if (dsMainFiltered.Good()) ▸ if (measure["chk_outqty"].Value == "true" && measure["chk_batch"].Value == "true") | GRID_SET | siMain.ActiveSheet.Cells[cRow + 2, cCol].Value | Math.Round(nOutValue) | 그리드 속성/값 설정 |  |  |  |
| AC-550cf4e6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4495 | if (dsMainFiltered.Good()) ▸ for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sCate == "P_OUT_KG") ▸ else of (sCate == "SALES" && sCateOd … | GRID_SET | siMain.ActiveSheet.Cells[i , cCol+cnt].Value | nI_tmp | 그리드 속성/값 설정 |  |  |  |
| AC-1b5afd32 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4583 | if (dsMainFiltered.Good()) ▸ for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDType == "DATA") ▸ if (sDType == "TOTAL") ▸ if (sCate == "P… | GRID_SET | siMain.ActiveSheet.Cells[i, j].Value | nP_I_Kg | 그리드 속성/값 설정 |  |  |  |
| AC-bd28045d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4585 | if (dsMainFiltered.Good()) ▸ for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDType == "DATA") ▸ if (sDType == "TOTAL") ▸ else of (sCate … | GRID_SET | siMain.ActiveSheet.Cells[i, j].Value | nP_I_BT | 그리드 속성/값 설정 |  |  |  |
| AC-00122009 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4587 | if (dsMainFiltered.Good()) ▸ for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDType == "DATA") ▸ if (sDType == "TOTAL") ▸ else of (sCate … | GRID_SET | siMain.ActiveSheet.Cells[i, j].Value | nP_O_Kg | 그리드 속성/값 설정 |  |  |  |
| AC-3cf1d56b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4589 | if (dsMainFiltered.Good()) ▸ for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDType == "DATA") ▸ if (sDType == "TOTAL") ▸ else of (sCate … | GRID_SET | siMain.ActiveSheet.Cells[i, j].Value | nP_O_BT | 그리드 속성/값 설정 |  |  |  |
| AC-d03636e9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4591 | if (dsMainFiltered.Good()) ▸ for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDType == "DATA") ▸ if (sDType == "TOTAL") ▸ else of (sCate … | GRID_SET | siMain.ActiveSheet.Cells[i, j].Value | nI_tmp | 그리드 속성/값 설정 |  |  |  |
| AC-b7f206bc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4597 | if (dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-75d297ec | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00597_PlanAmend_Model_PreMix.cs:4598 | if (dsMainFiltered.Good()) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetPlanner

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36be40b0 | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3782 |  | FLAG | dtPlanner | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findPlanner_List", sInstan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b26a1cba | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3782 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findPlanner_List", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-662ccc0c | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3784 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, mcbo_planner, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-955c4935 | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3794 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row[… | CALL_EXT | mcbo_planner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-432bde4d | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3798 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of … | CALL_EXT | mcbo_planner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c95d8e8a | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3814 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-28ee9cea | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3815 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-5101d5a4 | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3819 | if (dtPlanner != null) ▸ else of (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-1ee9dc45 | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3820 | if (dtPlanner != null) ▸ else of (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-da1ab89b | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3830 | if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner.Items.Count) ▸ if (mcbo_planner.Items[k].ToString() == sValueName.ToString()) | CALL_EXT | mcbo_planner.SetItemChecked | (k, true) | ⚠ 의미 확인 필요 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetPlanPeriod

진입점: this.Load [try] / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae80f3e1 | this.Load [try] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4032 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-bd65b4bb | this.Load [try] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4033 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-919e2dee | this.Load [try] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4037 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-25d32891 | this.Load [try] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4038 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-6bbbfd5c | this.Load [try] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4044 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-baf5b5f8 | this.Load [try] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:4045 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetPlant

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-416edd5b | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3949 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-cf7160e9 | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3949 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a80085e | this.Load [try] 외 4 | FP00597_PlanAmend_Model_PreMix.cs:3951 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetSite

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d236f33 | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3942 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-526c3ab5 | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3942 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-79fe4b79 | this.Load [try] 외 2 | FP00597_PlanAmend_Model_PreMix.cs:3943 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27f0cc76 | this.Load [try] 외 11 | FP00597_PlanAmend_Model_PreMix.cs:442 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77ececd0 | this.Load [try] 외 11 | FP00597_PlanAmend_Model_PreMix.cs:443 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SetTotalColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e40dd4f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 10 | FP00597_PlanAmend_Model_PreMix.cs:6451 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47e3fc57 | this.spdMain.ButtonClicked | FP00597_PlanAmend_Model_PreMix.cs:3330 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1dbea76 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3041 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe02a23f | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3042 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a01fee9 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3064 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-61d227ac | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3065 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-fdf1a221 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3067 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4569a86 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3076 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-20be7816 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3077 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-ae6831e6 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3079 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-9246c841 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3089 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | menu_line.Text | "Zero Setting(Line)" | 컨트롤 값 설정 |  |  |  |
| AC-dbcc19b2 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3090 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | menu_line.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-4c0b6b74 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3092 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (menu_line) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d2e62b5 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3098 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | menu_material.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-0f4f6176 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3099 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | menu_material.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-2871a0a3 | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3101 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (menu_material) | 데이터 객체 조작/조회 |  |  |  |
| AC-2076fc8f | this.spdMain.CellClick | FP00597_PlanAmend_Model_PreMix.cs:3108 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cd5f175 | this.spdMain.CellDoubleClick | FP00597_PlanAmend_Model_PreMix.cs:6585 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-5e557db9 | this.spdMain.CellDoubleClick | FP00597_PlanAmend_Model_PreMix.cs:6592 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b10f4d0 | this.spdMain.ClipboardPasted | FP00597_PlanAmend_Model_PreMix.cs:3337 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a562552 | this.spdMain.ClipboardPasted | FP00597_PlanAmend_Model_PreMix.cs:3345 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a1b2cb91 | this.spdMain.ClipboardPasted | FP00597_PlanAmend_Model_PreMix.cs:3346 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0477cd4 | this.spdMain.ClipboardPasted | FP00597_PlanAmend_Model_PreMix.cs:3348 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28a722df | this.spdMain.ClipboardPasting | FP00597_PlanAmend_Model_PreMix.cs:3354 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-e8538214 | this.spdMain.ClipboardPasting | FP00597_PlanAmend_Model_PreMix.cs:3355 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-f767964f | this.spdMain.ClipboardPasting | FP00597_PlanAmend_Model_PreMix.cs:3355 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-08780f17 | this.spdMain.ClipboardPasting | FP00597_PlanAmend_Model_PreMix.cs:3359 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0d9a7bf | this.spdMain.ClipboardPasting | FP00597_PlanAmend_Model_PreMix.cs:3359 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b761de3 | this.spdMain.ClipboardPasting | FP00597_PlanAmend_Model_PreMix.cs:3363 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f20931c3 | this.spdMain.ClipboardPasting | FP00597_PlanAmend_Model_PreMix.cs:3365 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a40394ba | this.spdMain.EditModeOff | FP00597_PlanAmend_Model_PreMix.cs:3177 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c040abe | this.spdMain.EditModeOn | FP00597_PlanAmend_Model_PreMix.cs:3183 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-7bfb7d0c | this.spdMain.EditModeOn | FP00597_PlanAmend_Model_PreMix.cs:3184 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e3753d9 | this.spdMain.EditorFocused | FP00597_PlanAmend_Model_PreMix.cs:3171 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e5c0318 | this.spdMain.KeyDown | FP00597_PlanAmend_Model_PreMix.cs:3120 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-19d00f8c | this.spdMain.KeyDown | FP00597_PlanAmend_Model_PreMix.cs:3124 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4894f17f | this.spdMain.KeyDown | FP00597_PlanAmend_Model_PreMix.cs:3125 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.SwitchMemo

진입점: memo_menu.Click [if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ca1d357 | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6603 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-295e6cc5 | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6620 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-9a12a591 | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6645 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-53d60885 | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6671 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-0a8bb250 | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6673 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-a7521a94 | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6676 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ebd7a70 | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6678 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6667781 | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6678 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f52ed11 | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6679 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-123a861f | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6681 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-6476c67c | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6683 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ec2a8f5b | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6695 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c96f08c | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6695 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-5699191a | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6715 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-dd721ccb | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6716 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-4667ea8b | memo_menu.Click [if (day != null)] 외 1 | FP00597_PlanAmend_Model_PreMix.cs:6718 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00597_PlanAmend_Model_PreMix.UIFindData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK)] / SaveButton…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-135847df | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:545 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e853b946 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:546 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-757986ac | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:549 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bf1d2fa6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:553 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-670824da | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:557 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan ID to proceed") | 메시지 표시 |  |  |  |
| AC-b1829934 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:558 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f380522 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:579 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba26a083 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:580 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8129590 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:583 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4a042e92 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:586 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-188c171f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:587 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-188be8bb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:590 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-9384aad3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:598 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8d8cd86c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:600 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-32fbba62 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:600 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cb91fce4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:610 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | LastTotalRaw | FindTotalValue("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-4d4345cf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:612 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7555c75 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:616 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a562ecfc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:617 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-143e8f9c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:619 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-e6953e64 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:621 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c5cf13f6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:625 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-4c54029c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:626 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-3fb0bf45 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:628 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c069cc2d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:633 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-4698a1b4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:634 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8cf31b8c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:635 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-0d8bac84 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:639 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e466720f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:643 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4f51f014 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:644 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-81e251bc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:652 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2f868fef | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:656 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-618913f1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:661 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-52193103 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:662 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2729c590 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:666 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8537ae20 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:674 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ca2a693d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:677 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-05c325d3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:681 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-46013f1c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP00597_PlanAmend_Model_PreMix.cs:685 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00597_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5071fc9 | .ctor | FP00597_RowExcelPopup.cs:164 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-c87ed334 | .ctor | FP00597_RowExcelPopup.cs:165 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00597_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-108ee2ab | this.btnClose.Click | FP00597_RowExcelPopup.cs:926 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00597_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8c52f7d | this.btnDownload.Click | FP00597_RowExcelPopup.cs:834 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-e7f4e06c | this.btnDownload.Click | FP00597_RowExcelPopup.cs:835 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |
| AC-cca6ffb3 | this.btnDownload.Click | FP00597_RowExcelPopup.cs:837 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00597_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1635e3f | this.btnFind.Click | FP00597_RowExcelPopup.cs:829 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00597_RowExcelPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0a7f411 | this.btnSave.Click | FP00597_RowExcelPopup.cs:921 |  | STATE | dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00597_RowExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cc18e8b | this.btnUpload.Click | FP00597_RowExcelPopup.cs:851 | if (bUpload) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2d6c7125 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:852 | if (bUpload) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8821021f | this.btnUpload.Click | FP00597_RowExcelPopup.cs:854 | if (bUpload) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3f865b13 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:855 | if (bUpload) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-84f99130 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:861 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | DATA_OP | dsSource.Tables[0].Columns.Contains | ("APPLIED_MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-892def29 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:864 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (!dsSource.Tables[0].Columns.Contains("APPLIED_MODEL")) | DATA_OP | dsSource.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-49f754dd | this.btnUpload.Click | FP00597_RowExcelPopup.cs:872 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8f1ca1c | this.btnUpload.Click | FP00597_RowExcelPopup.cs:873 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a5af3fb | this.btnUpload.Click | FP00597_RowExcelPopup.cs:874 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f440a2ee | this.btnUpload.Click | FP00597_RowExcelPopup.cs:878 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | row["APPLIED_MODEL"] | UomResult.First()["VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-92cab0cb | this.btnUpload.Click | FP00597_RowExcelPopup.cs:882 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in… | DATA_OP | row["APPLIED_MODEL"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7e0e578a | this.btnUpload.Click | FP00597_RowExcelPopup.cs:899 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ for (iRow < dsSource.Ta… | GRID_SET | dsSource.Tables[0].Rows[iRow]["ADJUST_IN_QTY_KG"] | "" | 그리드 속성/값 설정 |  |  |  |
| AC-199bed9d | this.btnUpload.Click | FP00597_RowExcelPopup.cs:903 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ for (iRow < dsSource.Ta… | GRID_SET | dsSource.Tables[0].Rows[iRow]["ADJUST_IN_QTY_KG"] | rVal.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-9cfe1d06 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:909 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d18cfdf3 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:910 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-6720efa2 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:912 | if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00597_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05bc7e41 | this.Load | FP00597_RowExcelPopup.cs:254 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-581f6b22 | this.Load | FP00597_RowExcelPopup.cs:255 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-04e4fa85 | this.Load | FP00597_RowExcelPopup.cs:256 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00597_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cb7b1a1 | (진입점 미연결) | FP00597_RowExcelPopup.cs:757 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8011c80b | (진입점 미연결) | FP00597_RowExcelPopup.cs:757 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00597_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-428c85fc | this.Load | FP00597_RowExcelPopup.cs:249 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00597_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8ed06ac | Dispose | FP00597_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00597_RowExcelPopup.dtpPeriod_ValueChanged

진입점: this.dtpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc02e12d | this.dtpPeriod.ValueChanged | FP00597_RowExcelPopup.cs:1035 | if (bFirst == true) | FLAG | bFirst | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cc026bf6 | this.dtpPeriod.ValueChanged | FP00597_RowExcelPopup.cs:1036 | if (bFirst == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b2f10e3 | this.dtpPeriod.ValueChanged | FP00597_RowExcelPopup.cs:1050 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5fd0798c | this.dtpPeriod.ValueChanged | FP00597_RowExcelPopup.cs:1052 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | VALUE_SET | dtpPeriod.InitValue | sStartDate + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ce25d634 | this.dtpPeriod.ValueChanged | FP00597_RowExcelPopup.cs:1053 | if (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92912aec | this.dtpPeriod.ValueChanged | FP00597_RowExcelPopup.cs:1058 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c1fe24a1 | this.dtpPeriod.ValueChanged | FP00597_RowExcelPopup.cs:1066 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-475cb30b | this.dtpPeriod.ValueChanged | FP00597_RowExcelPopup.cs:1068 | else of (Convert.ToDecimal(sStartDate) > Convert.ToDecimal(sNewDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) > Conver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81cf96dc | this.dtpPeriod.ValueChanged | FP00597_RowExcelPopup.cs:1071 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-f216d189 | this.dtpPeriod.ValueChanged | FP00597_RowExcelPopup.cs:1072 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |

## FP00597_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e50624a4 | (진입점 미연결) | FP00597_RowExcelPopup.cs:721 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00597_RowExcelPopup.Exec_Procedure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a443e1fd | (진입점 미연결) | FP00597_RowExcelPopup.cs:773 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-33f190c7 | (진입점 미연결) | FP00597_RowExcelPopup.cs:774 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b6643fc3 | (진입점 미연결) | FP00597_RowExcelPopup.cs:776 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-633ff756 | (진입점 미연결) | FP00597_RowExcelPopup.cs:777 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-c245b3f6 | (진입점 미연결) | FP00597_RowExcelPopup.cs:778 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c4685140 | (진입점 미연결) | FP00597_RowExcelPopup.cs:779 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-50a2fe8c | (진입점 미연결) | FP00597_RowExcelPopup.cs:780 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-c11af6f0 | (진입점 미연결) | FP00597_RowExcelPopup.cs:781 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5e91b132 | (진입점 미연결) | FP00597_RowExcelPopup.cs:782 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-ffc22e36 | (진입점 미연결) | FP00597_RowExcelPopup.cs:783 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f6566c62 | (진입점 미연결) | FP00597_RowExcelPopup.cs:784 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65d66802 | (진입점 미연결) | FP00597_RowExcelPopup.cs:785 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-09063d58 | (진입점 미연결) | FP00597_RowExcelPopup.cs:786 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-548b7625 | (진입점 미연결) | FP00597_RowExcelPopup.cs:787 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-23a6de47 | (진입점 미연결) | FP00597_RowExcelPopup.cs:788 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fb532766 | (진입점 미연결) | FP00597_RowExcelPopup.cs:789 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c235ab2a | (진입점 미연결) | FP00597_RowExcelPopup.cs:790 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-26de81ed | (진입점 미연결) | FP00597_RowExcelPopup.cs:791 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f8a7d817 | (진입점 미연결) | FP00597_RowExcelPopup.cs:792 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c096d797 | (진입점 미연결) | FP00597_RowExcelPopup.cs:793 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e90bc89d | (진입점 미연결) | FP00597_RowExcelPopup.cs:794 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4ed9da2d | (진입점 미연결) | FP00597_RowExcelPopup.cs:795 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a2275e52 | (진입점 미연결) | FP00597_RowExcelPopup.cs:796 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-efd44725 | (진입점 미연결) | FP00597_RowExcelPopup.cs:797 | try | DATA_OP | req.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d7a4c843 | (진입점 미연결) | FP00597_RowExcelPopup.cs:798 | try | DATA_OP | req.Parameters["p_p_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-98d93724 | (진입점 미연결) | FP00597_RowExcelPopup.cs:799 | try | DATA_OP | req.Parameters["p_p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3f3de3a5 | (진입점 미연결) | FP00597_RowExcelPopup.cs:800 | try | DATA_OP | req.Parameters["p_mpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-374b2973 | (진입점 미연결) | FP00597_RowExcelPopup.cs:801 | try | DATA_OP | req.Parameters["p_mpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f09e6d87 | (진입점 미연결) | FP00597_RowExcelPopup.cs:802 | try | DATA_OP | req.Parameters["p_wpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5bc35411 | (진입점 미연결) | FP00597_RowExcelPopup.cs:803 | try | DATA_OP | req.Parameters["p_wpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-800c1fb1 | (진입점 미연결) | FP00597_RowExcelPopup.cs:804 | try | DATA_OP | req.Parameters["p_boh_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5baa5875 | (진입점 미연결) | FP00597_RowExcelPopup.cs:806 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-56db9805 | (진입점 미연결) | FP00597_RowExcelPopup.cs:813 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-2a632a86 | (진입점 미연결) | FP00597_RowExcelPopup.cs:817 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00597_RowExcelPopup.Find_Data

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-882bf613 | this.Load 외 2 | FP00597_RowExcelPopup.cs:328 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8b0b4e54 | this.Load 외 2 | FP00597_RowExcelPopup.cs:334 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba331181 | this.Load 외 2 | FP00597_RowExcelPopup.cs:336 | if (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b98ca780 | this.Load 외 2 | FP00597_RowExcelPopup.cs:341 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e42df1f | this.Load 외 2 | FP00597_RowExcelPopup.cs:342 | else of (Convert.ToDecimal(dtpPeriod.Value1.ToString("yyyMMdd")) < Convert.ToDecimal(_PlanDate)) ▸ if (Convert.ToDecimal(dtpPeriod.Value1.To… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-080cf425 | this.Load 외 2 | FP00597_RowExcelPopup.cs:345 |  | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-d7c8bb8d | this.Load 외 2 | FP00597_RowExcelPopup.cs:346 |  | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-a1994bae | this.Load 외 2 | FP00597_RowExcelPopup.cs:348 |  | DATA_OP | Filter["BUCKET_FROM"] | _BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-016c937e | this.Load 외 2 | FP00597_RowExcelPopup.cs:349 |  | DATA_OP | Filter["BUCKET_TO"] | _BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-09764cf1 | this.Load 외 2 | FP00597_RowExcelPopup.cs:352 |  | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b987e231 | this.Load 외 2 | FP00597_RowExcelPopup.cs:355 | if (OnSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f68fcd83 | this.Load 외 2 | FP00597_RowExcelPopup.cs:356 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-ec3de864 | this.Load 외 2 | FP00597_RowExcelPopup.cs:356 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7e25f0c | this.Load 외 2 | FP00597_RowExcelPopup.cs:360 | if (OnSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-71758e8b | this.Load 외 2 | FP00597_RowExcelPopup.cs:361 | if (OnSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c056fc5d | this.Load 외 2 | FP00597_RowExcelPopup.cs:363 | if (OnSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2c03e23b | this.Load 외 2 | FP00597_RowExcelPopup.cs:364 | if (OnSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-952d0d0e | this.Load 외 2 | FP00597_RowExcelPopup.cs:365 | if (OnSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3452aab8 | this.Load 외 2 | FP00597_RowExcelPopup.cs:366 | if (OnSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7aaf3428 | this.Load 외 2 | FP00597_RowExcelPopup.cs:367 | if (OnSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d576a5a7 | this.Load 외 2 | FP00597_RowExcelPopup.cs:368 | if (OnSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2b782808 | this.Load 외 2 | FP00597_RowExcelPopup.cs:369 | if (OnSearchData != null) | STATE | this.dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a95a0102 | this.Load 외 2 | FP00597_RowExcelPopup.cs:375 | if (OnSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f8bdb0e | this.Load 외 2 | FP00597_RowExcelPopup.cs:378 | if (OnSearchData != null) ▸ try | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8cd9750d | this.Load 외 2 | FP00597_RowExcelPopup.cs:380 | if (OnSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f3f9c08 | this.Load 외 2 | FP00597_RowExcelPopup.cs:382 | if (OnSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar,set,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9061bc34 | this.Load 외 2 | FP00597_RowExcelPopup.cs:387 | if (OnSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-1c06b3f6 | this.Load 외 2 | FP00597_RowExcelPopup.cs:387 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, null, 1, IgnoreColumnsNotInTi… | 그리드 재구성/초기화 |  |  |  |
| AC-fdd638d2 | this.Load 외 2 | FP00597_RowExcelPopup.cs:392 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-2be6ef9a | this.Load 외 2 | FP00597_RowExcelPopup.cs:393 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-94774b40 | this.Load 외 2 | FP00597_RowExcelPopup.cs:394 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-9ba9eac8 | this.Load 외 2 | FP00597_RowExcelPopup.cs:399 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-39c4b72d | this.Load 외 2 | FP00597_RowExcelPopup.cs:400 | if (OnSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c3f67b0 | this.Load 외 2 | FP00597_RowExcelPopup.cs:405 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-66861aa6 | this.Load 외 2 | FP00597_RowExcelPopup.cs:406 | if (OnSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e1a20f12 | this.Load 외 2 | FP00597_RowExcelPopup.cs:417 | if (OnSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-adeca506 | this.Load 외 2 | FP00597_RowExcelPopup.cs:420 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8e5db959 | this.Load 외 2 | FP00597_RowExcelPopup.cs:421 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ee5cffb1 | this.Load 외 2 | FP00597_RowExcelPopup.cs:422 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2c3a4a27 | this.Load 외 2 | FP00597_RowExcelPopup.cs:423 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ae8b0c81 | this.Load 외 2 | FP00597_RowExcelPopup.cs:424 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-13b48620 | this.Load 외 2 | FP00597_RowExcelPopup.cs:425 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a8f5ff5d | this.Load 외 2 | FP00597_RowExcelPopup.cs:426 | if (OnSearchData != null) ▸ finally ▸ lambda | STATE | this.dtpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00597_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-819b3cc5 | FindButton | FP00597_RowExcelPopup.cs:296 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-438b7724 | FindButton | FP00597_RowExcelPopup.cs:297 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6fb90c85 | FindButton | FP00597_RowExcelPopup.cs:299 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00597_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0052e549 | this.Load | FP00597_RowExcelPopup.cs:173 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ac201e8e | this.Load | FP00597_RowExcelPopup.cs:175 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00597_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2da9a6f | (진입점 미연결) | FP00597_RowExcelPopup.cs:695 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-9e41d7e3 | (진입점 미연결) | FP00597_RowExcelPopup.cs:696 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-cfa38174 | (진입점 미연결) | FP00597_RowExcelPopup.cs:697 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-bf8f9909 | (진입점 미연결) | FP00597_RowExcelPopup.cs:698 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-bfae42bc | (진입점 미연결) | FP00597_RowExcelPopup.cs:699 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-970a6b30 | (진입점 미연결) | FP00597_RowExcelPopup.cs:700 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-ad2b6c7a | (진입점 미연결) | FP00597_RowExcelPopup.cs:701 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c65404a7 | (진입점 미연결) | FP00597_RowExcelPopup.cs:703 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-e8a142d5 | (진입점 미연결) | FP00597_RowExcelPopup.cs:704 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-4776fd05 | (진입점 미연결) | FP00597_RowExcelPopup.cs:708 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-87760df3 | (진입점 미연결) | FP00597_RowExcelPopup.cs:709 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00597_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0800e81d | this.Load | FP00597_RowExcelPopup.cs:208 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_FROM"].ToString()) < Convert.ToDecimal(thi… | DATA_OP | Filter["BUCKET_FROM"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4ac2bbfe | this.Load | FP00597_RowExcelPopup.cs:212 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ae762b18 | this.Load | FP00597_RowExcelPopup.cs:213 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (Convert.ToDecimal(this.Filter["BUCKET_TO"].ToString()) < Convert.ToDecimal(this.… | DATA_OP | Filter["BUCKET_TO"] | sEndDay | 행/컬럼 값 대입 |  |  |  |
| AC-4a292132 | this.Load | FP00597_RowExcelPopup.cs:216 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | Filter["BUCKET_FROM"] | 화면 필드/플래그 변경 |  |  |  |
| AC-0dab46c2 | this.Load | FP00597_RowExcelPopup.cs:217 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | Filter["BUCKET_TO"] | 화면 필드/플래그 변경 |  |  |  |
| AC-b466f66e | this.Load | FP00597_RowExcelPopup.cs:218 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | _BucketFromDate.ToString() + ":" + _BucketToDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-65680097 | this.Load | FP00597_RowExcelPopup.cs:222 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9e136862 | this.Load | FP00597_RowExcelPopup.cs:226 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | VALUE_SET | dtpPeriod.InitValue | sStartDay.ToString() + ":" + sEndDay.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-191d3d3f | this.Load | FP00597_RowExcelPopup.cs:228 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketFromDate | dtpPeriod.Value1.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-581b8671 | this.Load | FP00597_RowExcelPopup.cs:229 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | FLAG | _BucketToDate | dtpPeriod.Value2.ToString("yyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-15a3a053 | this.Load | FP00597_RowExcelPopup.cs:243 |  | FLAG | bUploadSaveFlag | false | 화면 필드/플래그 변경 |  |  |  |

## FP00597_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc87d67c | this.Load | FP00597_RowExcelPopup.cs:266 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04264816 | this.Load | FP00597_RowExcelPopup.cs:267 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00597_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1234f84 | (진입점 미연결) | FP00597_RowExcelPopup.cs:287 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00597_RowExcelPopup.lfn_setExchangeBatch_Excel

진입점: this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null && dsSource.Tables[0].Rows.Count > 0) ▸ if (dsSource.Tables[0].Rows.Count > 0) ▸ for (iRow < dsSource.Tables[0].Rows.Count) ▸ if (!string.IsNullOrEmpty(dsSource.Tables[0].Rows[iRow]["QTY"].ToString()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48e1b44e | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:957 | lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f51d77d | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:971 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-298a80cd | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:978 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f106dbf6 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:979 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-679c1906 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:980 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9056f1a2 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:981 | lambda | DATA_OP | each_row.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-89d91546 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:998 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e7445eb4 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:999 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d87e1afa | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:1000 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3ed160a | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:1001 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-309e7759 | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:1002 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebfd447d | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:1003 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8bdc990a | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:1003 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-feaec92e | this.btnUpload.Click [if (bUpload) ▸ if (dsSource != null &&… | FP00597_RowExcelPopup.cs:1021 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00597_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3020f7d7 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:729 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-070e6401 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:729 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-236033b0 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:731 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-455937e5 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:732 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-80d2823d | this.btnUpload.Click | FP00597_RowExcelPopup.cs:733 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-125b3163 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:735 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-513fb60c | this.btnUpload.Click | FP00597_RowExcelPopup.cs:737 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-09ef2830 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:738 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-8a0c0b07 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:738 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-9783911e | this.btnUpload.Click | FP00597_RowExcelPopup.cs:745 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dtpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d69b8c30 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:746 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-a2628493 | this.btnUpload.Click | FP00597_RowExcelPopup.cs:748 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00597_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69a78ca3 | this.btnSave.Click | FP00597_RowExcelPopup.cs:476 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-d2b0e401 | this.btnSave.Click | FP00597_RowExcelPopup.cs:477 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e78d3980 | this.btnSave.Click | FP00597_RowExcelPopup.cs:481 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix! After once seach, Try agagin.!") | 메시지 표시 |  |  |  |
| AC-fff8b4a6 | this.btnSave.Click | FP00597_RowExcelPopup.cs:482 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73888d3c | this.btnSave.Click | FP00597_RowExcelPopup.cs:493 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].Rows[i]["MESSAGE"].ToString().Equals("Y")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-269d5a44 | this.btnSave.Click | FP00597_RowExcelPopup.cs:494 | for (i < dsMain.Tables[0].Rows.Count) ▸ if (dsMain.Tables[0].Rows[i]["MESSAGE"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d087bd5 | this.btnSave.Click | FP00597_RowExcelPopup.cs:498 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-ed9832cf | this.btnSave.Click | FP00597_RowExcelPopup.cs:498 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fe4d4e6 | this.btnSave.Click | FP00597_RowExcelPopup.cs:503 | if (OnBeforeCheckData != null) | CALL_BASE | OnBeforeCheckData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b99a67d | this.btnSave.Click | FP00597_RowExcelPopup.cs:505 | if (OnBeforeCheckData != null) ▸ if (bCheck == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6bc8a9f8 | this.btnSave.Click | FP00597_RowExcelPopup.cs:514 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cd87ab75 | this.btnSave.Click | FP00597_RowExcelPopup.cs:515 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d19cd006 | this.btnSave.Click | FP00597_RowExcelPopup.cs:516 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-de029090 | this.btnSave.Click | FP00597_RowExcelPopup.cs:517 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-92679499 | this.btnSave.Click | FP00597_RowExcelPopup.cs:518 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2c642dbc | this.btnSave.Click | FP00597_RowExcelPopup.cs:519 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f82d20c6 | this.btnSave.Click | FP00597_RowExcelPopup.cs:527 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-cc349f10 | this.btnSave.Click | FP00597_RowExcelPopup.cs:528 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-20ed8559 | this.btnSave.Click | FP00597_RowExcelPopup.cs:529 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ad2c09a5 | this.btnSave.Click | FP00597_RowExcelPopup.cs:530 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0f56faa9 | this.btnSave.Click | FP00597_RowExcelPopup.cs:531 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-99c828ae | this.btnSave.Click | FP00597_RowExcelPopup.cs:532 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-955ae9a1 | this.btnSave.Click | FP00597_RowExcelPopup.cs:533 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6ced63ba | this.btnSave.Click | FP00597_RowExcelPopup.cs:534 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80e452b2 | this.btnSave.Click | FP00597_RowExcelPopup.cs:539 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-702df314 | this.btnSave.Click | FP00597_RowExcelPopup.cs:542 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-3101f23f | this.btnSave.Click | FP00597_RowExcelPopup.cs:544 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-57d34784 | this.btnSave.Click | FP00597_RowExcelPopup.cs:547 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c695ee8 | this.btnSave.Click | FP00597_RowExcelPopup.cs:552 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-488fbdd4 | this.btnSave.Click | FP00597_RowExcelPopup.cs:553 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-e882d8ea | this.btnSave.Click | FP00597_RowExcelPopup.cs:560 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d065b6bb | this.btnSave.Click | FP00597_RowExcelPopup.cs:563 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-88fee202 | this.btnSave.Click | FP00597_RowExcelPopup.cs:598 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb800db3 | this.btnSave.Click | FP00597_RowExcelPopup.cs:609 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2bc98faa | this.btnSave.Click | FP00597_RowExcelPopup.cs:612 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | FLAG | bUploadSaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4db6badf | this.btnSave.Click | FP00597_RowExcelPopup.cs:613 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-76c48e55 | this.btnSave.Click | FP00597_RowExcelPopup.cs:618 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-4224192d | this.btnSave.Click | FP00597_RowExcelPopup.cs:619 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c1dd4ce4 | this.btnSave.Click | FP00597_RowExcelPopup.cs:625 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-5ad1acbd | this.btnSave.Click | FP00597_RowExcelPopup.cs:662 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-d64617e2 | this.btnSave.Click | FP00597_RowExcelPopup.cs:664 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-174d2b5e | this.btnSave.Click | FP00597_RowExcelPopup.cs:665 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-59e4550a | this.btnSave.Click | FP00597_RowExcelPopup.cs:675 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-722a6087 | this.btnSave.Click | FP00597_RowExcelPopup.cs:676 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-4cbbf445 | this.btnSave.Click | FP00597_RowExcelPopup.cs:680 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bb15cb67 | this.btnSave.Click | FP00597_RowExcelPopup.cs:681 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f9f6de4f | this.btnSave.Click | FP00597_RowExcelPopup.cs:682 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5ce5151c | this.btnSave.Click | FP00597_RowExcelPopup.cs:683 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-46e34856 | this.btnSave.Click | FP00597_RowExcelPopup.cs:684 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3bd4b3f9 | this.btnSave.Click | FP00597_RowExcelPopup.cs:685 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00597_RowExcelPopup.SearchListInfoAll

진입점: this.btnUpload.Click [if (bUpload)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb881d84 | this.btnUpload.Click [if (bUpload)] | FP00597_RowExcelPopup.cs:935 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1c3bbf29 | this.btnUpload.Click [if (bUpload)] | FP00597_RowExcelPopup.cs:936 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ed4bc2f1 | this.btnUpload.Click [if (bUpload)] | FP00597_RowExcelPopup.cs:939 |  | FLAG | dtDimension | siMain.GetSpdTitle(sProgramID, sUserID, sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-e7fc4321 | this.btnUpload.Click [if (bUpload)] | FP00597_RowExcelPopup.cs:939 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7deceed7 | this.btnUpload.Click [if (bUpload)] | FP00597_RowExcelPopup.cs:942 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00597_find_UOMInfo_ALL") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-717bb90d | this.btnUpload.Click [if (bUpload)] | FP00597_RowExcelPopup.cs:943 |  | FLAG | dsUomInfoAll | dtUomAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-31ba6bb5 | this.btnUpload.Click [if (bUpload)] | FP00597_RowExcelPopup.cs:943 |  | DATA_OP | dtUomAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-58375ad2 | this.btnUpload.Click [if (bUpload)] | FP00597_RowExcelPopup.cs:945 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00597_find_YieldInfo_Child", Filter["INSTANCE_ID"].ToString(), Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f4c340c3 | this.btnUpload.Click [if (bUpload)] | FP00597_RowExcelPopup.cs:946 |  | FLAG | dsYieldInfoAll | dtYieldAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-78e18a09 | this.btnUpload.Click [if (bUpload)] | FP00597_RowExcelPopup.cs:946 |  | DATA_OP | dtYieldAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP00597_RowExcelPopup.SetSheetColor

진입점: this.Load [if (OnSearchData != null) ▸ try] / this.btnFind.Click [if (OnSearchData != null) ▸ try] / FindButton [if (OnSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05ee6720 | this.Load [if (OnSearchData != null) ▸ try] 외 2 | FP00597_RowExcelPopup.cs:442 | for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*Batch") != -1) | GRID_SET | siMain.ActiveSheet.Cells[0, idx, siMain.GetMaxRowIndex(), idx].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |
| AC-46c4cd3a | this.Load [if (OnSearchData != null) ▸ try] 외 2 | FP00597_RowExcelPopup.cs:446 | for (idx < siMain.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*Seq") != -1) | GRID_SET | siMain.ActiveSheet.Cells[0, idx, siMain.GetMaxRowIndex(), idx].BackColor | System.Drawing.Color.FromArgb(253, 252, 150) | 그리드 속성/값 설정 |  |  |  |

## FP00597_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccae79cd | this.Load | FP00597_RowExcelPopup.cs:279 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-45c7f1ee | this.Load | FP00597_RowExcelPopup.cs:280 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

