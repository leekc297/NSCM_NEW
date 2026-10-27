# AS-IS 액션 대조표 — FP02845

> 원천: `Doc/asisfacts/screens/FP02845/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 875행 · 메서드 123 · 종류 DATA_OP 336 · FLAG 91 · UI_PROP 82 · RETURN 80 · UI_MISC 46 · VALUE_SET 42 · MESSAGE 33 · COMBO_DATA 32 · CALL_EXT 28 · POPUP 19 · GRID_SET 17 · ENDPOINT 16 · GRID_INIT 16 · LIST_REBIND 8 · GRID_LOCK 7 · GRID_STYLE 7 · STATE 6 · THROW 5 · LIST_CLEAR 2 · CALL_BASE 1 · EXCEL 1 · ⚠ 의미 확인 필요 29


## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c211e73 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4179 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7fc9755 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4180 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7cb2a5ae | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4181 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-29a95042 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4182 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b97207a5 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4183 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-860cd86e | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4186 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-412dac4c | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4190 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-51ed3b18 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4191 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bad892e8 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4177 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-c2daafb6 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4207 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-c02d7541 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4210 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e06f976 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4213 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-3dd43391 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4216 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1ba8052 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4219 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-f7515a8a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4222 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-6d0ffd43 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4228 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-cf82bd8d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4230 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c17a1c7a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4151 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff639532 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4115 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5fab4bda | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4116 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8d53978 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4117 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-15090dc7 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4118 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-22b23d95 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4119 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-71bffad2 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4120 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b213dcc | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4122 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f32368c7 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4123 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-df7beaba | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4126 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ebcc041 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4127 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e406adf | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4128 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8d85d65 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4113 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-bd35df66 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4136 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f31d73f | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4137 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee31157f | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4142 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08396b14 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4088 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP02845_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9462e91 | .ctor | FP02845_BucketSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-494b4f4f | .ctor | FP02845_BucketSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-262f7af7 | .ctor | FP02845_BucketSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-54fec931 | .ctor | FP02845_BucketSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP02845_BucketSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c9beefa | this.btnOK.Click | FP02845_BucketSetForm_Popup.cs:190 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-dc5f5121 | this.btnOK.Click | FP02845_BucketSetForm_Popup.cs:190 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-c30673a8 | this.btnOK.Click | FP02845_BucketSetForm_Popup.cs:192 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-bd5ba239 | this.btnOK.Click | FP02845_BucketSetForm_Popup.cs:196 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-64441bb8 | this.btnOK.Click | FP02845_BucketSetForm_Popup.cs:197 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-019f09de | this.btnOK.Click | FP02845_BucketSetForm_Popup.cs:198 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-01ace8c6 | this.btnOK.Click | FP02845_BucketSetForm_Popup.cs:199 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02845_BucketSetForm_Popup.btnSet_Click

진입점: this.btbSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38219262 | this.btbSet.Click | FP02845_BucketSetForm_Popup.cs:213 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-4926a9b8 | this.btbSet.Click | FP02845_BucketSetForm_Popup.cs:213 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-c5f68d52 | this.btbSet.Click | FP02845_BucketSetForm_Popup.cs:215 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-ecc3da23 | this.btbSet.Click | FP02845_BucketSetForm_Popup.cs:219 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-c7acb990 | this.btbSet.Click | FP02845_BucketSetForm_Popup.cs:220 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-6f575f38 | this.btbSet.Click | FP02845_BucketSetForm_Popup.cs:222 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5301621e | this.btbSet.Click | FP02845_BucketSetForm_Popup.cs:224 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-5bc836ee | this.btbSet.Click | FP02845_BucketSetForm_Popup.cs:226 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-74217ba0 | this.btbSet.Click | FP02845_BucketSetForm_Popup.cs:227 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02845_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a56c701 | Dispose | FP02845_BucketSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02845_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-161235d5 | this.Load | FP02845_BucketSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP02845_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7932221d | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:147 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3aa2239 | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:148 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4c2ffde | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:149 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-32cdca2f | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:151 |  | DATA_OP | ctrls.Add | (chk_Shift_1) | 데이터 객체 조작/조회 |  |  |  |
| AC-0436f9dc | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:152 |  | DATA_OP | ctrls.Add | (chk_Shift_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e36b9b9 | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:154 |  | VALUE_SET | chk_week.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-5a4c5889 | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:156 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-13856498 | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:156 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-f3cee364 | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:164 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-97480c8a | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:168 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-20ee2d56 | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:172 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP02845_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af427aee | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-636a57b7 | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-dc6d9534 | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d1a9ff7b | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:120 |  | VALUE_SET | chk_Shift_1.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-eff2b010 | this.Load 외 1 | FP02845_BucketSetForm_Popup.cs:121 |  | VALUE_SET | chk_Shift_2.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP02845_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67163336 | (진입점 미연결) | FP02845_BucketSetForm_Popup.cs:237 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-3128bbd9 | (진입점 미연결) | FP02845_BucketSetForm_Popup.cs:248 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c462db7 | (진입점 미연결) | FP02845_BucketSetForm_Popup.cs:259 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP02845_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19dc290d | this.Load | FP02845_BucketSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5ff9d2e1 | this.Load | FP02845_BucketSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02845_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fd92dd6 | .ctor | FP02845_MeasureSetForm_Popup.cs:89 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-dbf32152 | .ctor | FP02845_MeasureSetForm_Popup.cs:90 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-ea98abde | .ctor | FP02845_MeasureSetForm_Popup.cs:91 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-48f2cd81 | .ctor | FP02845_MeasureSetForm_Popup.cs:93 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP02845_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5abb1e1d | this.btnOK.Click | FP02845_MeasureSetForm_Popup.cs:273 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-f69ec031 | this.btnOK.Click | FP02845_MeasureSetForm_Popup.cs:274 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-7bc458a1 | this.btnOK.Click | FP02845_MeasureSetForm_Popup.cs:281 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-79ab48f5 | this.btnOK.Click | FP02845_MeasureSetForm_Popup.cs:282 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02845_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efbe3589 | this.btnSet.Click | FP02845_MeasureSetForm_Popup.cs:245 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-ad37c7df | this.btnSet.Click | FP02845_MeasureSetForm_Popup.cs:246 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-4338ce71 | this.btnSet.Click | FP02845_MeasureSetForm_Popup.cs:248 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e961f513 | this.btnSet.Click | FP02845_MeasureSetForm_Popup.cs:249 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b000bb1 | this.btnSet.Click | FP02845_MeasureSetForm_Popup.cs:251 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-dfa01206 | this.btnSet.Click | FP02845_MeasureSetForm_Popup.cs:252 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-d2eb9f37 | this.btnSet.Click | FP02845_MeasureSetForm_Popup.cs:253 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02845_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-810fbea7 | Dispose | FP02845_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02845_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9200790f | this.Load | FP02845_MeasureSetForm_Popup.cs:116 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP02845_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c381f04 | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:157 |  | FLAG | dtCategory | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "select_measure", "FP02845_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b59b8b9c | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:157 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP02845_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cd41604a | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:159 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-98a2e50c | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:160 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-c2a306e3 | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:166 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac23770d | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:167 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-10073495 | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:168 |  | DATA_OP | ctrls.Add | (chk_roll) | 데이터 객체 조작/조회 |  |  |  |
| AC-741c7b9a | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:169 |  | DATA_OP | ctrls.Add | (chk_achieve) | 데이터 객체 조작/조회 |  |  |  |
| AC-97cc3511 | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:172 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-f31522ff | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:173 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b8abc40 | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:177 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-daa7c519 | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:177 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-c3261b16 | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-557bd2f5 | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:189 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-b11eb7fc | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:193 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP02845_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2946607 | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:129 |  | VALUE_SET | chk_roll.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7de2db9a | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:130 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b6d7e910 | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:131 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-47278a9f | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:132 |  | VALUE_SET | chk_achieve.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3392a32d | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-42159331 | this.Load 외 1 | FP02845_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP02845_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ec843cd | (진입점 미연결) | FP02845_MeasureSetForm_Popup.cs:335 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-6e289a5c | (진입점 미연결) | FP02845_MeasureSetForm_Popup.cs:346 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33d105ae | (진입점 미연결) | FP02845_MeasureSetForm_Popup.cs:357 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP02845_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20de460f | this.Load | FP02845_MeasureSetForm_Popup.cs:103 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b8aa82b6 | this.Load | FP02845_MeasureSetForm_Popup.cs:111 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02845_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87b24c12 | this.btnSet.Click 외 1 | FP02845_MeasureSetForm_Popup.cs:292 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b8a95f3b | this.btnSet.Click 외 1 | FP02845_MeasureSetForm_Popup.cs:300 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-2efa5f17 | this.btnSet.Click 외 1 | FP02845_MeasureSetForm_Popup.cs:300 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-9481b733 | this.btnSet.Click 외 1 | FP02845_MeasureSetForm_Popup.cs:317 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e11fc0dd | this.btnSet.Click 외 1 | FP02845_MeasureSetForm_Popup.cs:328 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c3fb041 | .ctor | FP02845_Plan_Result_Elec_Post_Shift.cs:207 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-9de1b79f | .ctor | FP02845_Plan_Result_Elec_Post_Shift.cs:208 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d117ab8b | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:942 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d9264d51 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:943 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-207af990 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:944 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f352a195 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:945 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-64ebfcf3 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:946 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0f1cab58 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:949 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-514acaeb | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:953 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-d3dcf74a | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:955 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7b505f7f | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:956 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-582db20d | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:957 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4bdbd536 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:958 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8ffa0530 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:959 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-81eeb0e6 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:960 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-5b894e62 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:975 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d640934 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:976 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f78d4d34 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:977 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fa70d516 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:978 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf98a4db | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1003 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-4500ecd7 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1004 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-26bfb8d9 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1005 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-4ddf9b6e | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1006 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-4ac8f412 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1007 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67d6cdd5 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:906 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //DataTable dt = null; if (GetFilter("INSTANCE_ID") == ""… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f9cc20d | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:916 | lambda | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-58c711dd | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:917 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b715ed87 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:918 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-1359ade9 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:932 | lambda | DATA_OP | Filter["AMEND_TABLE"] | "FP_DAILY_SHIFT_PROD_PLAN_H" | 행/컬럼 값 대입 |  |  |  |
| AC-92743729 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:933 | lambda | DATA_OP | Filter["TOTAL_TABLE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4357c2d7 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:935 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a10cad30 | this.btnBucket.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2175 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-1722443c | this.btnBucket.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2178 |  | POPUP | new FP02845_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-08de6f6e | this.btnBucket.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2179 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-53ea97b5 | this.btnBucket.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2180 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-32c40694 | this.btnBucket.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2181 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-de1a956f | this.btnBucket.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2185 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-3319129a | this.btnBucket.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2197 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4dbd6a35 | this.btnBucket.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2206 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c68b370c | this.btnCatagory.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2124 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-e534e142 | this.btnCatagory.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2127 |  | POPUP | new FP02845_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-6ea026ff | this.btnCatagory.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2128 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-91e81075 | this.btnCatagory.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2129 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-88072921 | this.btnCatagory.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2130 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3b5f8767 | this.btnCatagory.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2134 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-b1be6094 | this.btnCatagory.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2146 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ac5b1424 | this.btnCatagory.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2155 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-85bf500f | this.btnCatagory.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2160 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-e3e11b07 | this.btnCatagory.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2166 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-140c7598 | this.btnColumn.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2097 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-583376e6 | this.btnColumn.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2100 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-c7a9877c | this.btnColumn.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2101 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-02e5d8c2 | this.btnColumn.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2102 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-353e800a | this.btnColumn.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2108 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-ca70ad17 | this.btnColumn.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2108 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d729edb | this.btnColumn.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2109 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-87bc607f | this.btnColumn.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2115 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.btnCreatePlan_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a6cf252 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2262 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d414180c | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2263 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-794cc771 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2273 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-44ff140f | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2275 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-69ca6b41 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2281 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e81108b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2282 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-990e6b1c | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2287 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b97e8607 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2288 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8751c0bc | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2291 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e7acd0e | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2292 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-11e907af | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2293 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f2d995f | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2299 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a48a63fe | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2302 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-1e89f8d7 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2303 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-894552ba | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2304 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.btnMemo_Click

진입점: this.btnMemo2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-325eff49 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2443 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-50d8316a | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2444 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13fd8366 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2449 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7a72d731 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2450 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-83913872 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2451 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0bbb59cd | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2451 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-62cc28b7 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2452 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-5a3320bf | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2453 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-bc8b30b4 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2454 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fe9e2925 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2454 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a2fbdf75 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2455 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-37ea11b2 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2456 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-20967970 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2457 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b28dfa0a | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2458 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e1837d5e | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2459 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2de802a5 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2460 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-be522907 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2461 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6867f11a | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2462 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-984b5577 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2463 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ba54d23f | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2465 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e74aa4eb | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2466 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-5363e8b7 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2467 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-54c78dc4 | this.btnMemo2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2468 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.btnMRP_Click

진입점: this.btnMRP2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38cec3aa | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2221 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-31d1c29c | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2227 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-5eaa7d08 | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2228 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1680d888 | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2234 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-98b783e8 | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2235 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6fbe9c99 | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2240 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-7b41233a | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2241 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c8bd7b0 | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2245 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-e0409c9c | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2246 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f289c159 | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2247 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3822d40f | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2249 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-1aadc787 | this.btnMRP2.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2251 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.btnRelease_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e6dfc3c | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2323 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ab3bba3f | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2324 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-922fca85 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2344 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a9a1021a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2345 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4016936 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2348 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_instanceInfo", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3eaf314 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2349 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_planInfo", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-74ff1d2b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2353 | if (dtPlanInfo != null) | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-79073829 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2360 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4645f50d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2364 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-23f6e6dd | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2365 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa47164d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2372 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-83143a38 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2373 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d33793e4 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2380 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-682553d1 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2383 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-22a8f778 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2385 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f580f196 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2391 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-290e4c97 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2392 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3cf2aef | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2405 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cee921a5 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2406 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b88186d4 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2418 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a72af69d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2421 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-c6debbcb | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2422 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a8990dd4 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2423 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a00d8046 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2430 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-36cdb7c0 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2433 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-abd79f7b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2434 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-349a32d7 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:2435 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-882edf61 | this.btnSql.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2483 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-2b783899 | this.btnSql.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2486 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a9baacc9 | this.btnSql.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2487 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b4d94a63 | this.btnSql.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2489 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT") | 데이터 객체 조작/조회 |  |  |  |
| AC-c698432f | this.btnSql.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2490 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7f0fe55 | this.btnToggleSave.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2214 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27f642b5 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:1297 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e67f0fd | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:1297 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-65b70948 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:1299 |  | CALL_EXT | MeasureService.MakeDefault | (new FP02845_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c19e332 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:1299 |  | POPUP | new FP02845_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-79605cfb | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:1300 |  | CALL_EXT | MeasureService.MakeDefault | (new FP02845_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7872fcc | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:1300 |  | POPUP | new FP02845_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.chk_includeSubOp_onchanged

진입점: this.chk_includeSubOp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b824cfb | this.chk_includeSubOp.CheckedChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2080 | if (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-f49d13d3 | this.chk_includeSubOp.CheckedChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2082 | else of (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.CreateEditDataGridDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffb9ee1b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3967 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-aef03979 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3968 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfd1d785 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3969 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-95064a9d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3970 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4a8359b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3971 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f215bfd0 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3972 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-67f60019 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3973 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a593e104 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3974 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-442c7810 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3975 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-daa32d6e | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3976 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b5ee10d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3977 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-95431f90 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3978 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7c16787 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3979 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d486e17 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3980 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3677700d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3981 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9923b608 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3982 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-56f91ff4 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3983 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-896d33f2 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3984 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8721eefd | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3985 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CUSTOMER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-829bbb0f | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3986 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a8ad27b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3987 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8fb7f24 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3988 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-99a9de41 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3989 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb635096 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3990 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9ce3cf4 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3991 |  | DATA_OP | dt.Columns.Add | (new DataColumn("WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-30d5c0dc | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3993 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3969a66d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3994 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-907f3427 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3995 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5daec3b5 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3996 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-98552ee8 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3997 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e8fd9c1 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3999 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ACTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bf32ca6 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:4001 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.CreateEditSeqDataTable

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA") && iBatch != -1) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (dtList ==null)] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && Clipb…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-000ef9a2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3938 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-184bde93 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3939 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ca4ef65 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3940 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0dd13c6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3941 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f99ad25 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3942 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-afe642f4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3943 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-551a5108 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3944 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddb4be4b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3945 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-48a32455 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3946 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b80bf052 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3947 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d74dbca | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3948 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9b38ffa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3949 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab2cd78b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3950 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EQUIPMENT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-53a23dc4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3951 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c90bfbb9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3952 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SHIFT", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3dc1c433 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3954 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PC_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-13b5d437 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3955 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PC_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd7c8a9d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3956 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JR_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9ddf5e6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3957 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JR_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e583861 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3959 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4213cb5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3961 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.CreateFilterDataSet

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04f02bb6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1306 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-99d9e43f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1317 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-ce691b15 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1318 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-7b1337c4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1328 | if (measure["chk_roll"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_ROLL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-25b14007 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1332 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6160b45f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1336 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "RESULT_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d24f5b74 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1340 | if (measure["chk_achieve"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "ACHIEVE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-351935d1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1346 | if (measure["chk_subTotal"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_P_OUT_ROLL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-eeb32c86 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1347 | if (measure["chk_subTotal"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-79d094c2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1348 | if (measure["chk_subTotal"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_RESULT_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-96be3a49 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1349 | if (measure["chk_subTotal"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_ACHIEVE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1dca6363 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1362 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "TOTAL_P_OUT_ROLL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f44e09e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1363 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "TOTAL_P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f78fb843 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1364 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "TOTAL_RESULT_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-91fbbb62 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1365 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "TOTAL_ACHIEVE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f10f3821 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1388 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd01d64f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1395 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-34e843e1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1400 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25b8ebe4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1404 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-e378b36b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1406 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34fcd34a | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:395 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-be5eb0c0 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:396 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-9c3ee11d | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:397 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-874ae3f6 | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:1983 | if (sender == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ddcdaa12 | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:1989 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3be115e | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:1991 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3993d55 | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2008 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-3337cba4 | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2009 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |
| AC-6ff9b939 | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2017 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ else of (string.… | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(" + sEndDate + ")!") | 메시지 표시 |  |  |  |
| AC-9b385222 | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2018 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ else of (string.… | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-7ec2ac5b | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2019 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ else of (string.… | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-189635ec | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2031 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-a69a6173 | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2032 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-693aa1a7 | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2039 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(undefined).") | 메시지 표시 |  |  |  |
| AC-9c7a240f | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2040 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-87970b79 | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2051 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ if (dayCount > 365) | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-01182032 | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2052 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ if (dayCount > 365) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-ce18ac03 | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2059 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ if (dayCount > 28 * … | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(undefined).") | 메시지 표시 |  |  |  |
| AC-308fed9d | dCalendar_planrange.ValueChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:2060 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ if (dayCount > 28 * … | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83b5ff5a | DeleteButton | FP02845_Plan_Result_Elec_Post_Shift.cs:809 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.DeleteZeroSetting

진입점: this.spdMain.KeyDown [else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ if (rowstart >= 0 && rowend >= 0 && colstart >= 0 && colend >= 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bfcd4a1 | this.spdMain.KeyDown [else of (e.Control && e.KeyCode == Key… | FP02845_Plan_Result_Elec_Post_Shift.cs:2968 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dff89cd5 | Dispose | FP02845_Plan_Result_Elec_Post_Shift.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.DrawHeader

진입점: this.Load / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0996639 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4304 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-3fe97636 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4308 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-577535c5 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4309 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4bad828b | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4310 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ea63e69 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4311 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (2, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-095d1d2e | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4312 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a1b38a7 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4313 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-6a6272a8 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4317 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-7ad5998a | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4318 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-ec97f8c0 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4319 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-ce10dd65 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4320 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-33d8ef81 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4326 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-15038d35 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4327 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-14cca6e5 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4367 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-83c4813d | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4374 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6533cb18 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4375 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-55648fa0 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4376 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-100b4827 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4378 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-ddcbb660 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4380 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-65a60055 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4381 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-127cc528 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:4386 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.DrawSheet

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ els…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b47b037 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4392 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1b7ab35c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4395 | if (!in_Dataset.Good()) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-2b9c575e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4396 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6095c10f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4404 |  | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99e10a55 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4407 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1f75e5f | EditButton | FP02845_Plan_Result_Elec_Post_Shift.cs:817 | if (spdMain != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b8adeac | ExcelButton | FP02845_Plan_Result_Elec_Post_Shift.cs:1845 |  | EXCEL | ExportExcel | (0,true) | 엑셀 내보내기/올리기 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.Exec_Procedure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b6dff68 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1794 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02845_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP02845_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-2d0f0a01 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1795 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6447777b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1797 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-78f1d845 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1798 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-cebff677 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1799 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bf175c4f | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1800 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-62ea7a20 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1802 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ef76e1b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1803 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-650fdefa | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1804 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-8f8a2b05 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1805 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec890ffb | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1806 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8453c6ef | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1807 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a962d9fc | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1808 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d31da454 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1809 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-90b30034 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1810 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b136fdcd | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1811 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-082e3fef | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1812 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d4978020 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1813 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6e0a91da | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1814 | try | DATA_OP | req.Parameters["p_equipment_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-32247841 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1815 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-55a39c8f | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1816 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c2c50707 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1817 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d41dbcd | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1818 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-38fcf04b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1819 | try | DATA_OP | req.Parameters["p_seq"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4c85f32a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1821 | try | DATA_OP | req.Parameters["p_adjust_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b63832c2 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1822 | try | DATA_OP | req.Parameters["p_adjust_in_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-142bb361 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1823 | try | DATA_OP | req.Parameters["p_adjust_in_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-619a278c | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1824 | try | DATA_OP | req.Parameters["p_adjust_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d0374b89 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1825 | try | DATA_OP | req.Parameters["p_adjust_out_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-00edc760 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1826 | try | DATA_OP | req.Parameters["p_adjust_out_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-edbc1174 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1828 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d9e7a351 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1835 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-e90fa902 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1839 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b867e563 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:849 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT") ⇒ FP_Planning.PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT | 엔드포인트 요청 생성 |  |  |  |
| AC-b04a45f6 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:850 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-364b8b43 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:851 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-6f609c8e | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:852 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-cf85259a | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:853 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5921e0db | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:854 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-14f5c832 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:856 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-473351e2 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:857 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c030d19f | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:858 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cc446561 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:859 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-20e08433 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:860 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-61aa5702 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:861 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f4479209 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:862 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-90525dee | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:863 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a024db8c | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:864 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b274257c | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:865 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d60e500c | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:866 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-67dc8674 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:867 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4ba50045 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:868 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6ebead3f | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:869 | try | DATA_OP | request.Parameters["p_top_item_id"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4421b766 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:870 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-56189176 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:871 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-af86041e | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:873 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | (chk_plannedline.Checked ? "Y" : "N") | 행/컬럼 값 대입 |  |  |  |
| AC-40f8ecc9 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:874 | try | DATA_OP | request.Parameters["p_uom"] | Filter["UOM"] | 행/컬럼 값 대입 |  |  |  |
| AC-51f6299b | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:875 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-d66f5094 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:876 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-af8d04c5 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:877 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-48da8f81 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:878 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-72956091 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:879 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-4ba358a8 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:880 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-d727581d | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:881 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2bc88ee5 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:882 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-fa3a5212 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:883 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-fe0ef625 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:885 | try | DATA_OP | request.Parameters["p_total_table"] | Filter["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-cccb3ae2 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:894 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ec7a4498 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:895 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a44839d9 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:900 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.Find_Save_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9356ae91 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1621 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02845_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP02845_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-fa1e5c37 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1622 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-c6bad568 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1623 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-4d16e9f9 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1624 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0092339a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1625 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0bfc890b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1627 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c6f9ed40 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1628 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-41dfd015 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1629 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-98bacae4 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1630 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dcd3db8e | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1631 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f936b56d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1632 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a0592170 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1633 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-93d805f4 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1634 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9834caf6 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1635 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-daa1701a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1636 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d187dbcd | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1637 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fa09bccf | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1638 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-69212d75 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1639 | try | DATA_OP | request.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-07f5fa28 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1640 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6e5e6db7 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1641 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6c9151b0 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1642 | try | DATA_OP | request.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f25f6a61 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1643 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1ffcc4bb | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1644 | try | DATA_OP | request.Parameters["p_bucket_from"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4d9a963b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1645 | try | DATA_OP | request.Parameters["p_bucket_to"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-18a608ad | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1646 | try | DATA_OP | request.Parameters["p_day_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-510c9c16 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1647 | try | DATA_OP | request.Parameters["p_week_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5fae5541 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1648 | try | DATA_OP | request.Parameters["p_month_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-963a5ccf | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1649 | try | DATA_OP | request.Parameters["p_cate_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-73cc47b1 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1650 | try | DATA_OP | request.Parameters["p_cate_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0d1aa5e1 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1651 | try | DATA_OP | request.Parameters["p_cate_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d08b809a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1652 | try | DATA_OP | request.Parameters["p_amend_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-95dc5cc5 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1653 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c22d9ec6 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1654 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d20c167f | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1655 | try | DATA_OP | request.Parameters["p_amend_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d30d3a44 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1656 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7cd091da | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1657 | try | DATA_OP | request.Parameters["p_amend_util_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cc1a7979 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1658 | try | DATA_OP | request.Parameters["p_amend_capa_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aae230fb | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1660 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2da09c70 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1662 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a1f6894f | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1668 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.FindTotalColorStart

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Goo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a67f972 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1419 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3217538 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:223 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.GetDayColNameOfType_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasureName[i]].Value.Equals("true"))] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-604eda22 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:557 |  | RETURN | return day.Value + date_append_name; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT") ▸ try ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d415b6e0 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:3260 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.GetMonthColNameOfType_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasureName[i]].Value.Equals("true"))] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasureName[i]].Value.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97dc1b2d | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:561 |  | RETURN | return month.Value + month_append_name; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56addf7b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3931 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-cdedd3b5 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3932 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.GetToDay

진입점: sCalendar_planday.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-173d785c | sCalendar_planday.DateTimeChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:3458 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-5161ac6a | sCalendar_planday.DateTimeChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:3459 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.GetWeekColNameOfType_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasureName[i]].Value.Equals("true"))] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasureName[i]].Value.Equals("…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-376549fd | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:553 |  | RETURN | return week.Value + week_append_name; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.GoEditMode

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01ad35c2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1183 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.LockRange | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-95b8fb6e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1184 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8ce5e94f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1198 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (calendar != null) ▸ foreach (var week_item in calendar.Weeks) ▸ if (wee… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-28ebfde1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1215 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (m… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a498ec8 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:294 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-70f0c985 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:298 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-cebd33d3 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:299 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5f04e852 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:303 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-608b2b49 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:305 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-a224138d | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:313 | try ▸ for (i < itemValues.Length) | DATA_OP | rdo_uom.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-23f0ad66 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:316 | try | VALUE_SET | rdo_uom.EditValue | "JR" | 컨트롤 값 설정 |  |  |  |
| AC-cfcc1d36 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:319 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5d9e98b | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:327 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1a562ff6 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:332 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-b8995b18 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:334 | try | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9ac6a7b4 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:341 | try | FLAG | _sToDay | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-d42812c4 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:350 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-b1aa00f1 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:351 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-225dfa0b | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:352 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b73a78be | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:353 | try ▸ if (adminAuth == false) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d710c31c | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:356 | try | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d3717619 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:362 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.InitEditingBuf

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ce0236f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3464 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-478b9c8f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3465 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-72f6892e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3466 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-f209d84b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3467 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0f3c7475 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3471 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2717281 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:264 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a8c13c38 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:265 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-c98b48bd | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:266 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-7a1d5acb | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:267 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-4026bc69 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:268 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a69865f5 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:269 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.InitSpread

진입점: this.Load / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / FindButton [try ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b274afae | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:410 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-93bffdd9 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:411 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31d87b17 | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:413 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-58c933ee | this.Load 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:417 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8c3ab48 | InsertButton | FP02845_Plan_Result_Elec_Post_Shift.cs:802 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21c912b6 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1852 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.lfn_getYieldInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d23c0fce | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3823 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP02845_find_YieldInfo", pDivision, pSite, pPlant, pFactory, pOperation,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1c26136a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3829 | if (dtYieldOut != null) ▸ if (dtYieldOut.Rows.Count ==0) | RETURN | return nVal; |  | 처리 중단/반환 |  |  |  |
| AC-d405c946 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3838 |  | RETURN | return nVal; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.lfn_setExchangeBatch

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68a0ab48 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3852 | else of (sAppendex.Equals("PC")) | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-4f510ead | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3861 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad06c408 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3862 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0d84ddb | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3863 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b56bd873 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3864 | lambda | DATA_OP | x.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-55d4d5f6 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3861 | lambda | RETURN | return (x.Field<string>("FACTORY_ID") == row["FACTORY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-3606005b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3887 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ee6ac85 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3888 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab33df4e | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3889 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-31cf133f | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3890 | lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7711903 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3891 | lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-72ce67e0 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3892 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3bd4d71 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3893 | lambda | DATA_OP | x.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-71be2fc0 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3893 | lambda | DATA_OP | x.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-73136023 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3887 | lambda | RETURN | return (x.Field<string>("FACTORY_ID") == row["FACTORY_ID"].ToString() && x.Field… |  | 처리 중단/반환 |  |  |  |
| AC-68a5e3b2 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3913 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.lfn_setReleaseProcess

진입점: popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac9033f0 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1016 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-41a3161b | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1030 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ if (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCurrDate… | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-889c92f2 | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1032 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ else of (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCur… | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-b2be6fcc | popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_EL… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:1036 |  | RETURN | return dtMapData; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.MakeMemoFontBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5accc401 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1261 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-903c229c | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1265 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |
| AC-b6dc276d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1276 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-7319e7e8 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1280 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff061517 | bucke_menu.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2979 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c606ffe | bucke_menu.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:2982 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4e3a0e1 | bucke_menu.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:3011 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.onZeroLineMenu

진입점: menu_line.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3bca244 | menu_line.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:3024 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.onZeroMaterialMenu

진입점: menu_material.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcb495f7 | menu_material.Click | FP02845_Plan_Result_Elec_Post_Shift.cs:3138 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.PasteAuto

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a81b47d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:2892 | if (ClipData != null) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad26675e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:2893 | if (ClipData != null) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0514b943 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:2931 | if (ClipData != null) ▸ for (i < row) ▸ for (j < col) ▸ if (row == 1 && col == 1) ▸ if (ClipboardRange.Length > 0) ▸ for (k < colAdds) ▸ for… | GRID_SET | siMain.ActiveSheet.Cells[startrow + l, startcol + k].Value | ClipData[0, 0] | 그리드 속성/값 설정 |  |  |  |
| AC-4de122c0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:2952 | if (ClipData != null) ▸ for (i < row) ▸ for (j < col) ▸ else of (row == 1 && col == 1) ▸ if (startrow + i < maxrow && startcol + j < maxcol)… | GRID_SET | siMain.ActiveSheet.Cells[startrow + i, startcol + j].Value | ClipData[i, j] | 그리드 속성/값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.planday_changed

진입점: sCalendar_planday.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c66f06f6 | sCalendar_planday.DateTimeChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:1892 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-29b3f7c4 | sCalendar_planday.DateTimeChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:1896 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-176873b8 | sCalendar_planday.DateTimeChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:1903 | else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.rdo_uom_SelectedIndexChanged

진입점: this.rdo_uom.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0858774 | this.rdo_uom.SelectedIndexChanged | FP02845_Plan_Result_Elec_Post_Shift.cs:4642 |  | DATA_OP | Filter["UOM"] | radioGroup.Text | 행/컬럼 값 대입 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.RefreshHeadAndBody

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46fa19e1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4270 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-181ce34d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4285 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f9e111a7 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4289 | finally | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f3ef17ec | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4290 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.RefreshSpreadSheet

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67c8a7a8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4251 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-c778356d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4251 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-25ef7eeb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4258 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-22e37a28 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4263 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87c15a8d | popSql.OnSql | FP02845_Plan_Result_Elec_Post_Shift.cs:4009 | if (programID == "PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-634019cc | popSql.OnSql | FP02845_Plan_Result_Elec_Post_Shift.cs:4048 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.Save_Data_Amend

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3fd42fb | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1741 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP02845_AMEND_SAVE") ⇒ FP_Planning.PR_UI_FP02845_AMEND_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-50fc5c17 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1742 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-16f695d3 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1744 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-8f85f5e9 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1745 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-fe0e7f20 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1746 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-9c59ad4e | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1747 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-431ede79 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1748 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-40107613 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1749 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-523d1dbe | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1750 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-5061c2c6 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1751 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-05a5b409 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1752 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-519f1188 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1753 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-d7bff53c | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1754 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-182e74f4 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1755 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-db484250 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1756 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-f2111861 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1757 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-23f02096 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1758 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-fc97ce2b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1759 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_equipment_id"] | p_equipment_id | 행/컬럼 값 대입 |  |  |  |
| AC-330d9f3a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1760 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-0604aa44 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1761 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shift"] | p_shift | 행/컬럼 값 대입 |  |  |  |
| AC-3957941d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1762 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_jr_out_qty"] | p_jr_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-0be062a6 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1763 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pc_out_qty"] | p_pc_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-44e616b7 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1764 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-8a1ec4fc | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1766 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-598d260d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1767 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-92b0d2af | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1772 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2a3d500a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1777 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.Save_PIn_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb9dae30 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1468 | if (siMain == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0db5ac91 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1470 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f98dc61a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1475 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-356fba1a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1476 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ca0ed69d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1481 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a6ceaf1e | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1492 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b8f5ca83 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1505 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0a385899 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1506 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5a468827 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1509 | try | CALL_EXT | dtData.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4aa582e3 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1552 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("It can not be PLAN_TYPE[RELEASE]", "FP", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-675e43c7 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1553 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-170d923b | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1560 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8bdcb8ed | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1587 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-600f776a | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1588 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-82343edb | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1594 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1a19becd | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1597 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a646fb29 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1599 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-43a3ada4 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1603 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2a1435eb | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1604 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6c65c1be | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1605 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-50799ca8 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1606 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6e0dd3f7 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1610 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a0d7a8ff | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1611 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-beeebd33 | SaveButton | FP02845_Plan_Result_Elec_Post_Shift.cs:824 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetAmendHeaderColumn_FP_Local

진입점: this.Load [else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part =…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b89cf0f9 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:431 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-387346b6 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:437 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d98a5c5 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:440 | if (!dtSheetColumnConfig.Good()) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-6bf45b33 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:441 | if (!dtSheetColumnConfig.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de1eb675 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:460 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasur… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-634719ba | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:461 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasur… | CALL_EXT | MenuService.SetMenuColumn | (dateRowWeek, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = _… | ⚠ 의미 확인 필요 |  |  |  |
| AC-dea8f679 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:471 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasur… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowWeek) | 데이터 객체 조작/조회 |  |  |  |
| AC-8425039e | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:472 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMeasur… | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-481c73cd | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:485 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f84615a | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:486 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | CALL_EXT | MenuService.SetMenuColumn | (dateRwoDay, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = _s… | ⚠ 의미 확인 필요 |  |  |  |
| AC-aba29843 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:497 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRwoDay) | 데이터 객체 조작/조회 |  |  |  |
| AC-40316057 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:498 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) ▸ for (i < _sDateColumnA… | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-4b4d4580 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:519 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMe… | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0a0c5eeb | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:520 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMe… | CALL_EXT | MenuService.SetMenuColumn | (dateRowmonth, new MenuOption { program = sProgramID, sheet = sSheetName, column_string = … | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ad1cb29 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:531 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMe… | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowmonth) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cd0a714 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:532 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) ▸ for (i < _sDateColumnAppendName.Length) ▸ if (measure[_sMe… | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-d86cb11c | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:541 | if (dtSheetColumnConfig.Rows.Count == 0) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-6f293397 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:542 | if (dtSheetColumnConfig.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9df4d19 | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:545 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, iColumnHeaderRowCount, dtSheetColumnConfig) | 그리드 재구성/초기화 |  |  |  |
| AC-de62b95d | this.Load [else of (with_day_part == false) ▸ if (refreshCol… 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:546 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetBohTotalQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f4c57b0 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1432 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b1ffeec | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1437 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-9ce79b9c | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1442 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-58a32ba3 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1443 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-94b947a3 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1444 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e21d85d3 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1445 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c512ac01 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1446 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f649a82 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1447 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7aee811e | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1448 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b93214f1 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1449 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1c73fec | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:1453 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetCalenderColor

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / FindButto…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff9268d2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4542 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d01e9618 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4546 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-1daba725 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4550 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-12c0968c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4553 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-934f5a19 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4557 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ef13da59 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4560 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ed762534 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4589 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week != null) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-cac95442 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4592 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week != null) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-6feeae3d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4620 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month != null) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Mo… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-4740b8f2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4623 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month != null) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Mo… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetColMerge

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / FindButto…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-238ccc57 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4429 |  | FLAG | sv | siMain.ActiveSheet | 화면 필드/플래그 변경 |  |  |  |
| AC-608ebac1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4441 | if (measure["chk_Shift_1"].Value.Equals("true") && measure["chk_Shift_2"].Value.Equals("true")) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b7ed0f7b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4457 | if (measure["chk_Shift_1"].Value.Equals("true") && measure["chk_Shift_2"].Value.Equals("true")) ▸ for (j < sv.RowCount) ▸ if (sCateVal == "T… | GRID_SET | sv.Cells[j, i].ColumnSpan | 2 | 그리드 속성/값 설정 |  |  |  |
| AC-b3af3d0a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4462 | if (measure["chk_Shift_1"].Value.Equals("true") && measure["chk_Shift_2"].Value.Equals("true")) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetColumnChangeByText

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57de4445 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:583 | if (iColMinStartIndex <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ace80df | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:588 | try | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d6a18336 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:590 | try | FLAG | DateCellType | new FarPoint.Win.Spread.CellType.DateTimeCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d80f5e37 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:592 | try | FLAG | MaskcellType | new FarPoint.Win.Spread.CellType.MaskCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-fd8db3b9 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:593 | try | UI_PROP | MaskcellType.Mask | "####-##-##" | 속성 Mask 설정 |  |  |  |
| AC-0fb255fe | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:597 | try | UI_PROP | DateCellType.DateTimeFormat | FarPoint.Win.Spread.CellType.DateTimeFormat.UserDefined | 속성 DateTimeFormat 설정 |  |  |  |
| AC-17af2fe0 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:598 | try | UI_PROP | DateCellType.UserDefinedFormat | "yyyy-MM-dd" | 속성 UserDefinedFormat 설정 |  |  |  |
| AC-71fe2744 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:608 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9445772 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:610 | try | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-b93546bd | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:628 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k,i].CellType | MaskcellType | 그리드 속성/값 설정 |  |  |  |
| AC-7b28b706 | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:630 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].Value | sData | 그리드 속성/값 설정 |  |  |  |
| AC-8db32aac | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:634 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-1622311d | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:635 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-eeb2a29c | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:645 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72380e29 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:243 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a022c955 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:245 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-08a757de | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:249 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-c4493958 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:251 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-aa3dd0de | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:252 |  | CALL_EXT | UserService.HasSuperRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2cd87975 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:254 | if (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-02c00161 | this.Load | FP02845_Plan_Result_Elec_Post_Shift.cs:258 | else of (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetDirty

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (ClipData != null) ▸ for (i < row) ▸ for (j < col) ▸ if (row == 1 && col == 1) ▸ if (ClipboardRange.Length > 0) ▸ for (k < colAdds) ▸ for (l < rowAdds) ▸ if (startrow + l < maxrow && startcol + k < maxcol) ▸ if (!siMain.ActiveSheet.Cells[startrow + l, startcol + k].Locked && siMain.ActiveSheet.Cells[startrow + l, startcol + k].Bac…)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40a11b7b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 6 | FP02845_Plan_Result_Elec_Post_Shift.cs:3444 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetDivision

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-893daebe | this.Load [try] 외 2 | FP02845_Plan_Result_Elec_Post_Shift.cs:3273 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-011c18a5 | this.Load [try] 외 2 | FP02845_Plan_Result_Elec_Post_Shift.cs:3273 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-71c47c81 | this.Load [try] 외 2 | FP02845_Plan_Result_Elec_Post_Shift.cs:3274 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetFactory

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5772f82d | this.Load [try] 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3325 |  | FLAG | dtFactoryAmend | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findFactoryCode_amend_common", Fil… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-95701e21 | this.Load [try] 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3325 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findFactoryCode_amend_common", Filter["INSTANCE_ID"], Filter["PLAN_ID"] … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2faf4edb | this.Load [try] 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3328 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (dtInstance.Good())] / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / mcbo_line.SelectedIndexChanged / mcbo_prodtype.SelectedIndexChanged / txtItem.TextChanged / dCalendar_planrange.ValueChanged [if (getTypeName == "System.Windows.Forms.MaskedTextBox")] / chk_allLine.CheckedChanged / popSql.OnSql [if (programID == "PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT") ▸ try ▸ lambda ▸ if (GetFilter("INSTANCE_ID"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40d0581b | this.Load [try] 외 17 | FP02845_Plan_Result_Elec_Post_Shift.cs:3255 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetLine

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / chk_allLine.CheckedChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76505a59 | this.Load [try] 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:3359 |  | FLAG | dtLine | Data_FP.Common_FP(Data_FP.Type.LINE, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-8d6d15b7 | this.Load [try] 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:3359 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-11939973 | this.Load [try] 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:3369 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetNickName_LT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9fdcf9e | (진입점 미연결) | FP02845_Plan_Result_Elec_Post_Shift.cs:3401 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetOperation

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / this.chk_includeSubOp.CheckedChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cef651dc | this.Load [try] 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:3335 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, _CurrentUser, _sNonAuth, _sSaveAuth , Fil… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-1918c5b1 | this.Load [try] 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:3335 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b8228f28 | this.Load [try] 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:3344 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetPlanDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1b25224 | this.Load [try] | FP02845_Plan_Result_Elec_Post_Shift.cs:3265 |  | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetPlanGroup

진입점: this.Load [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e048d8bb | this.Load [try] 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:3282 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findAmendInstanceList_common", lv_… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-824fd3d9 | this.Load [try] 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:3282 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findAmendInstanceList_common", lv_amendInstance, _sSaveAuth) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-61218f38 | this.Load [try] 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:3283 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetPlanInBatch_DataSet

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA") && iBatch != -1) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLengt…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fc3cfb4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3508 | if (EditingCol != cCol) | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b693d48 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3513 | if (EditingRow != cRow) | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-1ff05f10 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3516 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-93bf88ff | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3596 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-51c728fa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3597 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-f37086bf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3598 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-2d9d253a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3599 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-398d97c8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3612 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f537aff3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3620 | if (dsMainFiltered.Good()) ▸ if (Clipboard && org_value == new_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afec4b8a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3626 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02845_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "LIST_DATA") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bdd357e7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3627 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | FLAG | dsListData | dtList2.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-75d22512 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3627 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | DATA_OP | dtList2.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-15b037e3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3635 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d83194a9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3636 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9ede47b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3637 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab7935df | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3638 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6fd2cc0d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3639 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd1b38cf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3640 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-770cf172 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3642 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7cc16184 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3644 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("SHIFT") | 데이터 객체 조작/조회 |  |  |  |
| AC-c9594825 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3635 | if (dsMainFiltered.Good()) ▸ lambda | RETURN | return (x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &&… |  | 처리 중단/반환 |  |  |  |
| AC-c8b10425 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3673 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["JR_OUT_QTY"] | Math.Round(Convert.ToDecimal(nOutValue)) | 행/컬럼 값 대입 |  |  |  |
| AC-883c3fc9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3674 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["PC_OUT_QTY"] | Math.Round(Convert.ToDecimal(nOut_PC)) | 행/컬럼 값 대입 |  |  |  |
| AC-0548db9a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3726 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5116003a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3728 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-701dc9ae | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3729 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-355b5192 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3730 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-45a5144a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3731 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0927e8ae | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3732 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-45b18e37 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3733 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-62718ce2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3734 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-74c9c367 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3735 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2f8f778a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3736 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1d506d0f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3737 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bd763973 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3738 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-427d9f16 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3739 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["EQUIPMENT_ID"] | row["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29b08a76 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3740 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04a8e269 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3741 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SHIFT"] | sShiftValue | 행/컬럼 값 대입 |  |  |  |
| AC-93b55ad4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3742 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PRODUCTION_TYPE"] | "MASS" | 행/컬럼 값 대입 |  |  |  |
| AC-abebee8e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3745 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["JR_OUT_QTY"] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-61a85daf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3746 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PC_OUT_QTY"] | nOut_PC | 행/컬럼 값 대입 |  |  |  |
| AC-4c25a047 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3755 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-4fac02e3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3758 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (dsListData == null) | FLAG | dsListData | dtList.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-394e5682 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3761 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ else of (dsListData == null) | DATA_OP | dsListData.Tables["Table"].ImportRow | (dtList.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-efb8a55e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3804 | if (dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-13352464 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:3805 | if (dsMainFiltered.Good()) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetPlanPeriod

진입점: this.Load [try] / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b86ad1c5 | this.Load [try] 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:3427 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02845_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "PLAN_PERIOD") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-04a80a75 | this.Load [try] 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:3432 |  | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-6ca6ee62 | this.Load [try] 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:3433 |  | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-20dba4ca | this.Load [try] 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:3435 |  | DATA_OP | Filter["BUCKET_FROM"] | dtmp.Rows[0]["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-189f158d | this.Load [try] 외 1 | FP02845_Plan_Result_Elec_Post_Shift.cs:3436 |  | DATA_OP | Filter["BUCKET_TO"] | dtmp.Rows[0]["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetPlant

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da7d4abf | this.Load [try] 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:3314 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-88110b47 | this.Load [try] 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:3314 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-17e6cbdc | this.Load [try] 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:3316 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetProdType

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-439b8c4b | this.Load [try] 외 2 | FP02845_Plan_Result_Elec_Post_Shift.cs:3394 |  | FLAG | dtProdType | Data_FP.CallGeneralProcedure2(("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELE… | 화면 필드/플래그 변경 |  |  |  |
| AC-af127c10 | this.Load [try] 외 2 | FP02845_Plan_Result_Elec_Post_Shift.cs:3394 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02842_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "PRODUCTION_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-93c654bb | this.Load [try] 외 2 | FP02845_Plan_Result_Elec_Post_Shift.cs:3395 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prodtype, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetSite

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df1f2771 | this.Load [try] 외 2 | FP02845_Plan_Result_Elec_Post_Shift.cs:3307 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-07f455cb | this.Load [try] 외 2 | FP02845_Plan_Result_Elec_Post_Shift.cs:3307 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ca62690 | this.Load [try] 외 2 | FP02845_Plan_Result_Elec_Post_Shift.cs:3308 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetSpreadInit

진입점: this.Load [try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] /…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4edd99c | this.Load [try] 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:425 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e4e99833 | this.Load [try] 외 5 | FP02845_Plan_Result_Elec_Post_Shift.cs:426 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.SetTotalColor

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / FindButto…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0f686cf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 4 | FP02845_Plan_Result_Elec_Post_Shift.cs:4507 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-433bd63e | this.spdMain.ButtonClicked | FP02845_Plan_Result_Elec_Post_Shift.cs:2763 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_CellClick2

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dad23aa8 | spdMain.CellClick | FP02845_Plan_Result_Elec_Post_Shift.cs:2532 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-f5fb5cf6 | spdMain.CellClick | FP02845_Plan_Result_Elec_Post_Shift.cs:2533 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-e810ddd7 | spdMain.CellClick | FP02845_Plan_Result_Elec_Post_Shift.cs:2535 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd7ac6ee | spdMain.CellClick | FP02845_Plan_Result_Elec_Post_Shift.cs:2556 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | menu_line.Text | "Zero Setting(Line)" | 컨트롤 값 설정 |  |  |  |
| AC-aa13f6cc | spdMain.CellClick | FP02845_Plan_Result_Elec_Post_Shift.cs:2557 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | menu_line.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-d43ad2e1 | spdMain.CellClick | FP02845_Plan_Result_Elec_Post_Shift.cs:2559 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (menu_line) | 데이터 객체 조작/조회 |  |  |  |
| AC-579f01a2 | spdMain.CellClick | FP02845_Plan_Result_Elec_Post_Shift.cs:2565 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | menu_material.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-6c8ae154 | spdMain.CellClick | FP02845_Plan_Result_Elec_Post_Shift.cs:2566 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | menu_material.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-f71cdaba | spdMain.CellClick | FP02845_Plan_Result_Elec_Post_Shift.cs:2568 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (menu_material) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c4f3244 | spdMain.CellClick | FP02845_Plan_Result_Elec_Post_Shift.cs:2575 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70dbb0e0 | this.spdMain.Change | FP02845_Plan_Result_Elec_Post_Shift.cs:2688 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (inputVal == null) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].Value | inputVal | 그리드 속성/값 설정 |  |  |  |
| AC-4c62ce31 | this.spdMain.Change | FP02845_Plan_Result_Elec_Post_Shift.cs:2724 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sColumnName.IndexOf("_SHIFT_") >= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81be2e0f | this.spdMain.Change | FP02845_Plan_Result_Elec_Post_Shift.cs:2730 |  | VALUE_SET | tbLog.Text | "spdMain_Change" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25fd85f5 | this.spdMain.ChildControlDeactivated | FP02845_Plan_Result_Elec_Post_Shift.cs:2639 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82299f0f | this.spdMain.ClipboardPasted | FP02845_Plan_Result_Elec_Post_Shift.cs:2770 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-558ab213 | this.spdMain.ClipboardPasted | FP02845_Plan_Result_Elec_Post_Shift.cs:2775 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-322614ae | this.spdMain.ClipboardPasted | FP02845_Plan_Result_Elec_Post_Shift.cs:2779 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8e1c030a | this.spdMain.ClipboardPasted | FP02845_Plan_Result_Elec_Post_Shift.cs:2782 |  | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18212d45 | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2787 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-77abc8ce | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2788 |  | ENDPOINT | Clipboard.GetDataObject | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3128d68d | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2790 |  | COMBO_DATA | data.GetFormats | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-94c8d419 | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2795 |  | ENDPOINT | data.GetDataPresent | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d216613 | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2797 | if (data.GetDataPresent(typeof(System.String))) | ENDPOINT | data.GetData | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-035026ae | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2801 | if (data.GetDataPresent(typeof(System.String))) | CALL_EXT | src_string.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e56bd4b9 | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2817 | if (data.GetDataPresent(typeof(System.String))) ▸ if (MaxColCount > 0 && ClipRowCount > 0) | FLAG | ClipData | new string[ClipRowCount, MaxColCount] | 화면 필드/플래그 변경 |  |  |  |
| AC-63648bb9 | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2830 | if (data.GetDataPresent(typeof(System.String))) ▸ if (MaxColCount > 0 && ClipRowCount > 0) ▸ for (i < ClipRowCount) ▸ for (j < cells.Length) | DATA_OP | ClipData[i, j] | cell | 행/컬럼 값 대입 |  |  |  |
| AC-75357cda | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2842 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-358fb7ad | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2842 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4086d3a8 | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2879 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-c257fec1 | this.spdMain.ClipboardPasting | FP02845_Plan_Result_Elec_Post_Shift.cs:2881 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9bb9408 | this.spdMain.DragFillBlockCompleted | FP02845_Plan_Result_Elec_Post_Shift.cs:2649 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec8aa6d7 | this.spdMain.EditModeOff | FP02845_Plan_Result_Elec_Post_Shift.cs:2667 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d50ed8b0 | this.spdMain.EditModeOn | FP02845_Plan_Result_Elec_Post_Shift.cs:2673 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-dcffcab7 | this.spdMain.EditModeOn | FP02845_Plan_Result_Elec_Post_Shift.cs:2674 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cfdc20c | this.spdMain.EditorFocused | FP02845_Plan_Result_Elec_Post_Shift.cs:2661 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64d16bd1 | this.spdMain.Enter | FP02845_Plan_Result_Elec_Post_Shift.cs:2624 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42c58194 | this.spdMain.KeyDown | FP02845_Plan_Result_Elec_Post_Shift.cs:2589 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-c5f35a60 | this.spdMain.KeyDown | FP02845_Plan_Result_Elec_Post_Shift.cs:2613 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0af89912 | this.spdMain.Leave | FP02845_Plan_Result_Elec_Post_Shift.cs:2619 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fbc0a90 | this.spdMain.SubEditorClosed | FP02845_Plan_Result_Elec_Post_Shift.cs:2655 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d4bfde3 | this.spdMain.SubEditorOpening | FP02845_Plan_Result_Elec_Post_Shift.cs:2644 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8852c7d5 | this.spdMain.Validated | FP02845_Plan_Result_Elec_Post_Shift.cs:2629 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-706f278c | this.spdMain.Validating | FP02845_Plan_Result_Elec_Post_Shift.cs:2634 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02845_Plan_Result_Elec_Post_Shift.UIFindData

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b89cefc | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:665 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f561396f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:666 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80d18ab1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:669 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-359bfe1d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:676 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | Filter2 | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-dfb90f40 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:676 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-82f451c0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:690 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-75ed8934 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:691 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee9e4f46 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:694 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-95e351c2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:697 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-aa6d98d3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:698 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dcc85c5e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:701 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-9ba71839 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:710 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-237eee5e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:712 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-89c7b209 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:712 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-905f4df2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:725 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-80ca5231 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:736 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-e387a637 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:743 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b1ec9d71 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:745 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-f37b894c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:749 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0c43bf5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:762 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-78db68e3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:766 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f223eb5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:771 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-00563390 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:772 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2af69550 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:776 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d7595f8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:787 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e9999c46 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:791 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-20b6de32 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP02845_Plan_Result_Elec_Post_Shift.cs:795 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

