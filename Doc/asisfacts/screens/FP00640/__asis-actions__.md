# AS-IS 액션 대조표 — FP00640

> 원천: `Doc/asisfacts/screens/FP00640/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1508행 · 메서드 166 · 종류 DATA_OP 644 · RETURN 161 · UI_PROP 146 · FLAG 143 · VALUE_SET 63 · UI_MISC 55 · CALL_EXT 53 · MESSAGE 48 · ENDPOINT 38 · COMBO_DATA 37 · POPUP 28 · GRID_INIT 23 · GRID_SET 16 · STATE 11 · GRID_LOCK 8 · GRID_STYLE 6 · THROW 6 · CALL_BASE 5 · LIST_REBIND 5 · LIST_CLEAR 3 · FOCUS 2 · EXCEL 2 · VALUE_CLEAR 2 · STATE_RESET 1 · GRID_BIND 1 · LIST_BIND 1 · ⚠ 의미 확인 필요 58


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d2ba6e6 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6113 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-50c43405 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6119 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f4843ed2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6127 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-8d552284 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6128 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-c1798603 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6129 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-749f2292 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6130 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-9be5b239 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6132 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-15b6a6a0 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6133 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-30a2108b | (진입점 미연결) | FP00640_ILT_MODULE.cs:6134 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b2913ee | (진입점 미연결) | FP00640_ILT_MODULE.cs:6135 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-541f777b | (진입점 미연결) | FP00640_ILT_MODULE.cs:6136 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-a239b472 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6137 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-c49b56fc | (진입점 미연결) | FP00640_ILT_MODULE.cs:6138 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb8ac70b | (진입점 미연결) | FP00640_ILT_MODULE.cs:6139 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-6fd18b3a | (진입점 미연결) | FP00640_ILT_MODULE.cs:6142 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-467f3637 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6327 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-81f9edef | (진입점 미연결) | FP00640_ILT_MODULE.cs:6328 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-8249114d | (진입점 미연결) | FP00640_ILT_MODULE.cs:6329 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-4e3d15b8 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6330 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-7b3ff841 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6332 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd20442c | (진입점 미연결) | FP00640_ILT_MODULE.cs:6333 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-b46a2628 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6334 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-98e01ba9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6335 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-f8675cd6 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6336 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-79289a7e | (진입점 미연결) | FP00640_ILT_MODULE.cs:6337 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-d868bb1f | (진입점 미연결) | FP00640_ILT_MODULE.cs:6338 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-a148e7d7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6339 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-c218e823 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6341 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6c40c90 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6246 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9151196e | (진입점 미연결) | FP00640_ILT_MODULE.cs:6247 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e420347 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6248 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-80b19f77 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6249 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0612a941 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6250 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2fba16f | (진입점 미연결) | FP00640_ILT_MODULE.cs:6253 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-05b82d74 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6257 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a0ed37d | (진입점 미연결) | FP00640_ILT_MODULE.cs:6258 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-032309bf | (진입점 미연결) | FP00640_ILT_MODULE.cs:6244 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-14ac6968 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6274 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-a83d1d9c | (진입점 미연결) | FP00640_ILT_MODULE.cs:6277 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd8e0621 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6280 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-74b3ebf2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6283 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8ca9968 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6286 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-489fb837 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6289 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-60085d74 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6295 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-2e79bbaa | (진입점 미연결) | FP00640_ILT_MODULE.cs:6297 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-236e37d2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6218 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45adb4cd | (진입점 미연결) | FP00640_ILT_MODULE.cs:6182 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e30b0c75 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6183 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d232f81f | (진입점 미연결) | FP00640_ILT_MODULE.cs:6184 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-df76f710 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6185 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5be7a215 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6186 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-84d48500 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6187 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3308ed5 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6189 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-501044cd | (진입점 미연결) | FP00640_ILT_MODULE.cs:6190 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6db3d08d | (진입점 미연결) | FP00640_ILT_MODULE.cs:6193 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-71045402 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6194 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bbb72d50 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6195 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5cc5d2a | (진입점 미연결) | FP00640_ILT_MODULE.cs:6180 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-f87f27ce | (진입점 미연결) | FP00640_ILT_MODULE.cs:6203 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-464d1038 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6204 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-cda1a711 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6209 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1ec0a8f | (진입점 미연결) | FP00640_ILT_MODULE.cs:6155 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00640_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb72028a | .ctor | FP00640_BucketSetForm_Popup.cs:70 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-a2bf2b63 | .ctor | FP00640_BucketSetForm_Popup.cs:71 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-48fdbc23 | .ctor | FP00640_BucketSetForm_Popup.cs:72 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-f805b75f | .ctor | FP00640_BucketSetForm_Popup.cs:74 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00640_BucketSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9481ff51 | this.btnOK.Click | FP00640_BucketSetForm_Popup.cs:184 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-7514eb24 | this.btnOK.Click | FP00640_BucketSetForm_Popup.cs:184 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-b3c046a4 | this.btnOK.Click | FP00640_BucketSetForm_Popup.cs:186 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-b58ed10e | this.btnOK.Click | FP00640_BucketSetForm_Popup.cs:190 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-c6b28f97 | this.btnOK.Click | FP00640_BucketSetForm_Popup.cs:191 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-514488e0 | this.btnOK.Click | FP00640_BucketSetForm_Popup.cs:192 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-832a1437 | this.btnOK.Click | FP00640_BucketSetForm_Popup.cs:193 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00640_BucketSetForm_Popup.btnSet_Click

진입점: this.btbSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a582913 | this.btbSet.Click | FP00640_BucketSetForm_Popup.cs:207 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-29946316 | this.btbSet.Click | FP00640_BucketSetForm_Popup.cs:207 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-63f09224 | this.btbSet.Click | FP00640_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-0b090bcb | this.btbSet.Click | FP00640_BucketSetForm_Popup.cs:213 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-a59e7fc6 | this.btbSet.Click | FP00640_BucketSetForm_Popup.cs:214 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-b1a4e3a0 | this.btbSet.Click | FP00640_BucketSetForm_Popup.cs:216 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e7d9a1e | this.btbSet.Click | FP00640_BucketSetForm_Popup.cs:218 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-6fafcca1 | this.btbSet.Click | FP00640_BucketSetForm_Popup.cs:220 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-cbd882af | this.btbSet.Click | FP00640_BucketSetForm_Popup.cs:221 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00640_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af767d41 | Dispose | FP00640_BucketSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00640_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5fc8509 | this.Load | FP00640_BucketSetForm_Popup.cs:98 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00640_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12ea779b | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:144 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c9b1619 | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:145 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-262510a5 | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:146 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0623a16 | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:148 |  | VALUE_SET | chk_week.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-e7427b5e | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:150 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-a9c76f0d | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:150 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-1d8e726e | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:158 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-68c83400 | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:162 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-889a266f | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:166 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00640_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12f8df73 | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:115 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6519dc1c | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-18ec235b | this.Load 외 1 | FP00640_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00640_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef20f50a | (진입점 미연결) | FP00640_BucketSetForm_Popup.cs:231 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-f8f1020b | (진입점 미연결) | FP00640_BucketSetForm_Popup.cs:242 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7090cffe | (진입점 미연결) | FP00640_BucketSetForm_Popup.cs:253 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00640_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccd6b722 | this.Load | FP00640_BucketSetForm_Popup.cs:85 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6cd3a54c | this.Load | FP00640_BucketSetForm_Popup.cs:93 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00640_ILT_MODULE..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be21f63e | .ctor | FP00640_ILT_MODULE.cs:244 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-bfff0095 | .ctor | FP00640_ILT_MODULE.cs:245 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00640_ILT_MODULE.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸ try] / this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-718b79de | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1136 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0035c8b4 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1137 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0aa3916f | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1138 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6b4db373 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1139 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f6573418 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1140 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-03144cfb | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1143 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9ecf9528 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1147 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ef2c9a3a | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1149 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cd5ab577 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1150 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-490235c6 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1151 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ce4547dc | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1152 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-72adb149 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1153 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-00a53ef1 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1154 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-36a1930e | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1169 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b2ecdd58 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1170 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-acfd55c9 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1171 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dcbd2c1b | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1172 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c7146f10 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1197 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-a7522239 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1198 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-d44dd7ce | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1199 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-d750617b | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1200 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-c7b284c0 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE") ▸… 외 7 | FP00640_ILT_MODULE.cs:1201 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00640_ILT_MODULE.ApplyAmendCalendarCondition_ForExcel

진입점: popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd0411b9 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5102 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cfb81d15 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5103 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-40b342ff | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5104 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3e5d8029 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5105 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-194580fd | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5106 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6a03512d | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5120 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8b45b81e | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5124 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-fda65faf | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5126 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f37d511c | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5127 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4831b947 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5128 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89a7d293 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5129 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-46c101ad | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5130 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f468155 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5131 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1b29e0d1 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5136 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00640_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5f9851d2 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5138 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a07c4e85 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5139 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b37c137 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5140 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d0e951e | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5141 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e64662d1 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5142 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-daaa0db4 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5143 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-39a2d745 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5144 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ed0fa13a | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5147 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-d3dc0e09 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5148 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-2595bf65 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5149 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-8702f5cc | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5150 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-00957cf3 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5151 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-2e04ee80 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5152 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-9a79dc24 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5153 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00640_ILT_MODULE.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE")] / this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeee91ee | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1070 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //DataTable dt = null; if (GetFilter("INSTANCE_ID") == ""… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2681d3c0 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1076 | lambda ▸ if (GetFilter("INSTANCE_ID") == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { SetFilter("INSTANCE_ID", CString.GetCheckedListValue(dtIn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7346cc5 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1082 | lambda | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //set["USER_ID"] = "chkim.68"; Filter["PLAN_DATE"] = drpP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4abb0d80 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1085 | lambda ▸ lambda | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b059641d | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1086 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-d09fb9da | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1087 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-262ec93a | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1103 | lambda ▸ lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-de56099d | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1108 | lambda | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_P_FORM_R" | 행/컬럼 값 대입 |  |  |  |
| AC-fe85d97e | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1109 | lambda | DATA_OP | Filter["TOTAL_TABLE"] | "FP_AMEND_PLAN_P_FORM_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-12445b88 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1129 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00640_ILT_MODULE.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-153157bf | this.btnBucket.Click | FP00640_ILT_MODULE.cs:2410 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-03eb553b | this.btnBucket.Click | FP00640_ILT_MODULE.cs:2413 |  | POPUP | new FP00640_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-c9c59ccb | this.btnBucket.Click | FP00640_ILT_MODULE.cs:2414 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-954f1778 | this.btnBucket.Click | FP00640_ILT_MODULE.cs:2415 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-64d5bab9 | this.btnBucket.Click | FP00640_ILT_MODULE.cs:2416 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-43d73653 | this.btnBucket.Click | FP00640_ILT_MODULE.cs:2420 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-c18d48b0 | this.btnBucket.Click | FP00640_ILT_MODULE.cs:2432 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1d3709f9 | this.btnBucket.Click | FP00640_ILT_MODULE.cs:2441 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00640_ILT_MODULE.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0918216 | this.btnCatagory.Click | FP00640_ILT_MODULE.cs:2359 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-44c8070f | this.btnCatagory.Click | FP00640_ILT_MODULE.cs:2362 |  | POPUP | new FP00640_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-97e608b6 | this.btnCatagory.Click | FP00640_ILT_MODULE.cs:2363 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-5477b33b | this.btnCatagory.Click | FP00640_ILT_MODULE.cs:2364 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-542f8357 | this.btnCatagory.Click | FP00640_ILT_MODULE.cs:2365 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-533c28b9 | this.btnCatagory.Click | FP00640_ILT_MODULE.cs:2369 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-773e4d7d | this.btnCatagory.Click | FP00640_ILT_MODULE.cs:2381 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c806c316 | this.btnCatagory.Click | FP00640_ILT_MODULE.cs:2390 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-40080c7b | this.btnCatagory.Click | FP00640_ILT_MODULE.cs:2395 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-5e1ab278 | this.btnCatagory.Click | FP00640_ILT_MODULE.cs:2401 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00640_ILT_MODULE.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddc253a5 | this.btnColumn.Click | FP00640_ILT_MODULE.cs:2332 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a760701e | this.btnColumn.Click | FP00640_ILT_MODULE.cs:2335 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-cdc76e95 | this.btnColumn.Click | FP00640_ILT_MODULE.cs:2336 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-63a56bdc | this.btnColumn.Click | FP00640_ILT_MODULE.cs:2337 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-430ac852 | this.btnColumn.Click | FP00640_ILT_MODULE.cs:2343 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-e8c8124b | this.btnColumn.Click | FP00640_ILT_MODULE.cs:2343 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c426b36 | this.btnColumn.Click | FP00640_ILT_MODULE.cs:2344 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-bfe363db | this.btnColumn.Click | FP00640_ILT_MODULE.cs:2350 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00640_ILT_MODULE.btnCopyDischarging_Click

진입점: this.btnCopyDischarging.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b273181 | this.btnCopyDischarging.Click | FP00640_ILT_MODULE.cs:3063 |  | MESSAGE | MessageBox.Show | ("Copy [charging plan] to [discharging plan]. Will you proceed?", "Excute", MessageBoxButt… | 메시지 표시 |  |  |  |
| AC-c3748c96 | this.btnCopyDischarging.Click | FP00640_ILT_MODULE.cs:3065 | if (MessageBox.Show("Copy [charging plan] to [discharging plan]. Will you proceed?", "Excute", MessageBoxButtons.YesNo) == D…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b202af7 | this.btnCopyDischarging.Click | FP00640_ILT_MODULE.cs:3070 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "[FP Plan ID]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38f3feb5 | this.btnCopyDischarging.Click | FP00640_ILT_MODULE.cs:3071 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e46620b1 | this.btnCopyDischarging.Click | FP00640_ILT_MODULE.cs:3077 | try | DATA_OP | input["P_MASTER_ID"] | Filter["ILT_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-47201211 | this.btnCopyDischarging.Click | FP00640_ILT_MODULE.cs:3078 | try | DATA_OP | input["P_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2b47631a | this.btnCopyDischarging.Click | FP00640_ILT_MODULE.cs:3082 | try | ENDPOINT | DataService.FP_RunProcedure | ("FP00640", "PR_SCM_PACK_FORM_PLAN_DCP_UPDATE", input.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=PR_SCM_PACK_FORM_PLAN_DCP_UPD… | 엔드포인트 호출 |  |  |  |
| AC-7f49a5a1 | this.btnCopyDischarging.Click | FP00640_ILT_MODULE.cs:3085 | try | MESSAGE | MessageBox.Show | ("Data saved.") | 메시지 표시 |  |  |  |
| AC-df5ef62f | this.btnCopyDischarging.Click | FP00640_ILT_MODULE.cs:3093 | catch ((Exception ee)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { ee.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00640_ILT_MODULE.btnCreatePlan_Click

진입점: this.btnCreatePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-400a2a7b | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2537 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6ce1feb | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2538 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3145ddfb | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2560 |  | POPUP | new FP00640_planOptionSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-07c07d22 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2561 |  | CALL_EXT | select_popup.SetOption | (0, "Fix") | ⚠ 의미 확인 필요 |  |  |  |
| AC-356ce8fe | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2562 |  | CALL_EXT | select_popup.SetOption | (1, "Charging Result") | ⚠ 의미 확인 필요 |  |  |  |
| AC-21ef84df | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2564 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e55bb287 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2570 | else of (select_popup.ShowDialog() == DialogResult.OK) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a0f157c | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2575 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_refInfo" , CString.GetCheckedListValue(dtSite, mcbo_site.Co… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-70437be5 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2587 | if (dtRefInfo != null) ▸ if (dtRefInfo.Rows.Count > 0) ▸ if (sEnableFlag != "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "The engine can not be started before the reference data(open … | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-09385f26 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2588 | if (dtRefInfo != null) ▸ if (dtRefInfo.Rows.Count > 0) ▸ if (sEnableFlag != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.btnModelCondition_Click

진입점: this.btnModelCondition.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f6f98fd | this.btnModelCondition.Click | FP00640_ILT_MODULE.cs:2469 | if (floModel != null) | UI_MISC | floModel.Hide | () | 창 닫기/해제 |  |  |  |
| AC-e4cd7160 | this.btnModelCondition.Click | FP00640_ILT_MODULE.cs:2470 |  | FLAG | floModel | MenuFloater.GoPanel(this, btnModelCondition, modelPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-d1dd3f0e | this.btnModelCondition.Click | FP00640_ILT_MODULE.cs:2470 |  | CALL_EXT | MenuFloater.GoPanel | (this, btnModelCondition, modelPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP00640_ILT_MODULE.btnRelease_Click

진입점: this.btnRelease.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16c0bfc4 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:3028 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d35d0de4 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:3029 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7c43904 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:3040 | if (string.IsNullOrWhiteSpace(sPlanID)) | MESSAGE | MessageBox.Show | ("You need to select one plan ID to proceed") | 메시지 표시 |  |  |  |
| AC-85d411eb | this.btnRelease.Click | FP00640_ILT_MODULE.cs:3041 | if (string.IsNullOrWhiteSpace(sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9dbd39e2 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:3045 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff2409a4 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:3048 | if (sPlanDate != dtmp.Rows[0][0].ToString()) | MESSAGE | MessageBox.Show | ("Past plans cannot be confirmed.") | 메시지 표시 |  |  |  |
| AC-8298d7bd | this.btnRelease.Click | FP00640_ILT_MODULE.cs:3049 | if (sPlanDate != dtmp.Rows[0][0].ToString()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6318db7 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:3052 |  | MESSAGE | MessageBox.Show | ("Confirm the plan. Will you proceed?", "Excute", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-717ebe88 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:3054 | if (MessageBox.Show("Confirm the plan. Will you proceed?", "Excute", MessageBoxButtons.YesNo) == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f0f2e55 | this.btnSql.Click | FP00640_ILT_MODULE.cs:3305 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-78a0c444 | this.btnSql.Click | FP00640_ILT_MODULE.cs:3308 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-472d1981 | this.btnSql.Click | FP00640_ILT_MODULE.cs:3309 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a66a0593 | this.btnSql.Click | FP00640_ILT_MODULE.cs:3311 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00640_ILT_MODULE") | 데이터 객체 조작/조회 |  |  |  |
| AC-92953bbe | this.btnSql.Click | FP00640_ILT_MODULE.cs:3312 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00640_AMEND_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e67c374 | this.btnSql.Click | FP00640_ILT_MODULE.cs:3314 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00640_ILT_MODULE.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bce5f8d | this.btnToggleSave.Click | FP00640_ILT_MODULE.cs:2449 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00640_ILT_MODULE.btnUpdateSSP_Click

진입점: this.btnUpdateSSP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3168919b | this.btnUpdateSSP.Click | FP00640_ILT_MODULE.cs:2485 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8ea2a1b2 | this.btnUpdateSSP.Click | FP00640_ILT_MODULE.cs:2486 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47cbad7e | this.btnUpdateSSP.Click | FP00640_ILT_MODULE.cs:2492 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan ID to proceed") | 메시지 표시 |  |  |  |
| AC-3b97a601 | this.btnUpdateSSP.Click | FP00640_ILT_MODULE.cs:2493 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae9156f3 | this.btnUpdateSSP.Click | FP00640_ILT_MODULE.cs:2496 |  | MESSAGE | MessageBox.Show | ("Update SSP data. Will you proceed?", "Excute", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-878c4102 | this.btnUpdateSSP.Click | FP00640_ILT_MODULE.cs:2498 | if (MessageBox.Show("Update SSP data. Will you proceed?", "Excute", MessageBoxButtons.YesNo) == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab887da1 | this.btnUpdateSSP.Click | FP00640_ILT_MODULE.cs:2502 |  | DATA_OP | input["P_MASTER_ID"] | Filter["ILT_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-480d46a7 | this.btnUpdateSSP.Click | FP00640_ILT_MODULE.cs:2503 |  | DATA_OP | input["P_PLAN_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aaf530b8 | this.btnUpdateSSP.Click | FP00640_ILT_MODULE.cs:2507 |  | ENDPOINT | DataService.FP_RunProcedure | ("FP00640", "PR_SCM_PACK_FORM_PLAN_UPDATE", input.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=PR_SCM_PACK_FORM_PLAN_UPDATE]… | 엔드포인트 호출 |  |  |  |
| AC-bc447afe | this.btnUpdateSSP.Click | FP00640_ILT_MODULE.cs:2510 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "SSP" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00640_ILT_MODULE.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9e2518d | this.button1.Click | FP00640_ILT_MODULE.cs:3099 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00640_ILT_MODULE.button2_Click

진입점: this.button2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41025e8f | this.button2.Click | FP00640_ILT_MODULE.cs:2474 |  | UI_MISC | floModel.Hide | () | 창 닫기/해제 |  |  |  |
| AC-0d387b41 | this.button2.Click | FP00640_ILT_MODULE.cs:2475 |  | FOCUS | btnModelCondition.Focus | () | 포커스 이동 |  |  |  |

## FP00640_ILT_MODULE.cbo_fpplanid_changed

진입점: cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa36f09e | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2214 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[selected]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-be2b663c | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2215 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[selected]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-8db82b01 | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2216 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[selected]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-0a13dd65 | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2217 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[selected]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-f2066b82 | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2218 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[selected]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-bb217193 | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2220 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-db951c23 | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2221 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-303a493c | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2222 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-5d0e787c | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2223 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-1c9489d7 | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2228 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-e7fc1b4b | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2229 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-f52a8818 | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2230 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-0c36bf7d | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2231 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-bab84e71 | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2232 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-a6d1deb3 | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2234 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-8a8672bf | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2235 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-eed49d77 | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2236 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-abcc3ed7 | cbo_fpplanid.SelectedIndexChanged | FP00640_ILT_MODULE.cs:2237 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |

## FP00640_ILT_MODULE.cbo_fpplanid_DropDown

진입점: this.cbo_fpplanid.DropDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8e61d0e | this.cbo_fpplanid.DropDown | FP00640_ILT_MODULE.cs:6700 |  | FLAG | _planString | (_tmp == null ? "" : _tmp.ToString()) | 화면 필드/플래그 변경 |  |  |  |

## FP00640_ILT_MODULE.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65aa20d7 | this.Load | FP00640_ILT_MODULE.cs:1431 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-e453d527 | this.Load | FP00640_ILT_MODULE.cs:1431 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-0a021141 | this.Load | FP00640_ILT_MODULE.cs:1433 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00640_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7bdca4ec | this.Load | FP00640_ILT_MODULE.cs:1433 |  | POPUP | new FP00640_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-dff79d13 | this.Load | FP00640_ILT_MODULE.cs:1434 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00640_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1e9c3c0 | this.Load | FP00640_ILT_MODULE.cs:1434 |  | POPUP | new FP00640_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP00640_ILT_MODULE.chk_confirmPlan_CheckedChanged

진입점: this.chk_confirmPlan.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8838846 | this.chk_confirmPlan.CheckedChanged | FP00640_ILT_MODULE.cs:6917 | if (chk_confirmPlan.Checked) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "REF_PLAN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ab2e26e7 | this.chk_confirmPlan.CheckedChanged | FP00640_ILT_MODULE.cs:6929 | if (chk_confirmPlan.Checked) ▸ if (dtRef.Rows.Count > 0) | VALUE_SET | drpPlanDate.DateTime | DateTime.ParseExact(sDate, "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None) | 컨트롤 값 설정 |  |  |  |
| AC-818ba213 | this.chk_confirmPlan.CheckedChanged | FP00640_ILT_MODULE.cs:6940 | if (chk_confirmPlan.Checked) ▸ if (dtRef.Rows.Count > 0) | VALUE_SET | cbo_fpplanid.SelectedValue | sPlan | 컨트롤 값 설정 |  |  |  |
| AC-5eb9d93d | this.chk_confirmPlan.CheckedChanged | FP00640_ILT_MODULE.cs:6943 | if (chk_confirmPlan.Checked) | STATE | drpPlanDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6b380eb5 | this.chk_confirmPlan.CheckedChanged | FP00640_ILT_MODULE.cs:6944 | if (chk_confirmPlan.Checked) | STATE | cbo_fpplanid.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8dac4979 | this.chk_confirmPlan.CheckedChanged | FP00640_ILT_MODULE.cs:6948 | else of (chk_confirmPlan.Checked) | STATE | drpPlanDate.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b1acb7fd | this.chk_confirmPlan.CheckedChanged | FP00640_ILT_MODULE.cs:6949 | else of (chk_confirmPlan.Checked) | STATE | cbo_fpplanid.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00640_ILT_MODULE.chk_Info_CheckedChanged_1

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b69e590 | this.chk_Info.CheckedChanged | FP00640_ILT_MODULE.cs:7046 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6edfd1c | this.chk_Info.CheckedChanged | FP00640_ILT_MODULE.cs:7046 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8178f3a5 | this.chk_Info.CheckedChanged | FP00640_ILT_MODULE.cs:7052 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-3a90dda1 | this.chk_Info.CheckedChanged | FP00640_ILT_MODULE.cs:7053 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00640_ILT_MODULE.Confirm_Plan

진입점: this.btnRelease.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ec094b1 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2689 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-03efeb74 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2690 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1af4ef8c | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2693 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-22c1e26e | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2697 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-25e973b6 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2788 | try ▸ try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00640_AMEND_SAVE") ⇒ FP_Planning.PR_UI_FP00640_AMEND_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-b45cb916 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2789 | try ▸ try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2580472f | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2791 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-5489e8e5 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2792 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1a103539 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2793 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-e327cb62 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2794 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b4198af2 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2795 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-6a402d10 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2796 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-2ae177ae | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2797 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-10401468 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2798 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-70829fc9 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2799 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f01b2c86 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2800 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-773022dc | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2801 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_item_id"] | p_model_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5d0b1830 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2802 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_module_item_id"] | p_module_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-273e6983 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2803 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_item_id"] | p_cell_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d4a65a2 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2804 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-9840a735 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2805 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-47ef76f6 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2806 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-161b226d | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2807 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-6dfbf5a1 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2808 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-f7789598 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2809 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-fdfe3a1f | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2810 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-c05f93fb | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2811 | try ▸ try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e3cfccdc | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2813 | try ▸ try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e351a7e9 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2831 | try ▸ try ▸ if (iCount > 0) ▸ if (rtn.Rows.Count > 0) ▸ try | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { rtn.Rows[0][0].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a8f7e620 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2834 | try ▸ try ▸ if (iCount > 0) ▸ if (rtn.Rows.Count > 0) ▸ catch ((Exception ee)) | POPUP | FoxMessageBox.Show | (ee.Message) | 팝업/폼 열기 |  |  |  |
| AC-6fc81b6a | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2842 | try ▸ try ▸ else of (iCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5869b43 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2847 | try ▸ catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b55dbf0 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2850 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1b3cb061 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2854 | catch () | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3cf8b858 | this.btnRelease.Click | FP00640_ILT_MODULE.cs:2859 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00640_ILT_MODULE.CreateEditSeqDataTable

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if ((row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_04" \|\| row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_09") // Di…) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (true) ▸ if (sCateID.Equals("CATEGORY_04")) ▸ if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Cou…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3622d312 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4968 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-d4d028b0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4969 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2419eed | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4970 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7b6c394 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4971 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e443712 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4972 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b4a96db | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4973 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ccfe37c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4974 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f40074b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4975 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MODEL_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7adfc76f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4976 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MODULE_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f93611b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4977 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CELL_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-38aa6680 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4978 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7c55033 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4979 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9f15b5c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4980 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-deb6f7ff | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4981 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4c458cb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4982 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-98c2350b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4983 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfcc8f31 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4984 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0df0b161 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4985 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7beda9d9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4987 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.CreateExelBufferDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-841eec8a | (진입점 미연결) | FP00640_ILT_MODULE.cs:5159 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-875fcd44 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5160 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-89d5ca17 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5161 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6580b0c2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5162 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab1882db | (진입점 미연결) | FP00640_ILT_MODULE.cs:5163 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7041c76 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5164 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-01e9f860 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5165 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3764cf4b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5166 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a92a9b0 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5167 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-20e6163f | (진입점 미연결) | FP00640_ILT_MODULE.cs:5168 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-60d15f05 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5169 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b7cd9ce | (진입점 미연결) | FP00640_ILT_MODULE.cs:5170 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1365d80 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5171 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EQUIPMENT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d0b10d3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5172 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a76a9e0a | (진입점 미연결) | FP00640_ILT_MODULE.cs:5173 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-14de005b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5174 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-147041a7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5175 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-37411c3d | (진입점 미연결) | FP00640_ILT_MODULE.cs:5176 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b210485d | (진입점 미연결) | FP00640_ILT_MODULE.cs:5177 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ccc4358 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5178 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e53177c7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5179 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_IN_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a068589f | (진입점 미연결) | FP00640_ILT_MODULE.cs:5180 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_BATCH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc5c7a82 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5181 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ADJUST_OUT_QTY_KG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9dee9ed3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5182 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-44f25080 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5183 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JOB_ORDER", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce424f09 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5185 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.CreateFilterDataSet

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b69cf53a | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1440 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ce9981a9 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1451 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-a86d43b4 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1452 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-1a1fd3f5 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1462 | if (measure["chk_ssp"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_01")) | 데이터 객체 조작/조회 |  |  |  |
| AC-39956f88 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1466 | if (measure["chk_sspResult"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_15")) | 데이터 객체 조작/조회 |  |  |  |
| AC-84ecf759 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1470 | if (measure["chk_cmaPkg"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_02")) | 데이터 객체 조작/조회 |  |  |  |
| AC-96f5a0d9 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1474 | if (measure["chk_dischargingPlan"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_04")) | 데이터 객체 조작/조회 |  |  |  |
| AC-13cdcf99 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1478 | if (measure["chk_dischargingResult"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_05")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b83d66af | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1482 | if (measure["chk_waitingDischarge"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_06")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a30ae299 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1486 | if (measure["chk_estimatedAgingCompleted"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_07")) | 데이터 객체 조작/조회 |  |  |  |
| AC-76485736 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1490 | if (measure["chk_agingStock"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_08")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c1ebc42 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1494 | if (measure["chk_chargingPlan"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_09")) | 데이터 객체 조작/조회 |  |  |  |
| AC-71010d80 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1498 | if (measure["chk_chargingResult"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_10")) | 데이터 객체 조작/조회 |  |  |  |
| AC-03964f1d | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1502 | if (measure["chk_waitingCharge"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_11")) | 데이터 객체 조작/조회 |  |  |  |
| AC-531f6e99 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1506 | if (measure["chk_InHouseInventory"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_12")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4620459b | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1510 | if (measure["chk_exWarehouse"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_13")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b8c14c2 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1514 | if (measure["chk_cmaAssyPlan"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CATEGORY_14")) | 데이터 객체 조작/조회 |  |  |  |
| AC-65c8eb4b | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1566 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c8e093e | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1573 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd82ba16 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1578 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-625c4625 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1582 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ff3c3c8 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1584 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d433d82 | this.Load | FP00640_ILT_MODULE.cs:408 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9e9772d9 | this.Load | FP00640_ILT_MODULE.cs:409 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-118fc4c4 | this.Load | FP00640_ILT_MODULE.cs:410 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00640_ILT_MODULE.dCalendarPlanrange_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d830072 | drpPeriod.ValueChanged | FP00640_ILT_MODULE.cs:2292 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca0e3721 | drpPeriod.ValueChanged | FP00640_ILT_MODULE.cs:2298 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-c56e2718 | drpPeriod.ValueChanged | FP00640_ILT_MODULE.cs:2299 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |
| AC-639cd22e | drpPeriod.ValueChanged | FP00640_ILT_MODULE.cs:2303 |  | CALL_EXT | strPlanDate.ToSafeInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-04e0eb16 | drpPeriod.ValueChanged | FP00640_ILT_MODULE.cs:2303 |  | CALL_EXT | arrRetStart.ToSafeInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e03d5e0 | drpPeriod.ValueChanged | FP00640_ILT_MODULE.cs:2305 | if (strPlanDate.ToSafeInt() < arrRetStart.ToSafeInt()) | MESSAGE | MessageBox.Show | ("Select a start date that is the same as or earlier than the plan date.") | 메시지 표시 |  |  |  |
| AC-55f02ce6 | drpPeriod.ValueChanged | FP00640_ILT_MODULE.cs:2306 | if (strPlanDate.ToSafeInt() < arrRetStart.ToSafeInt()) | UI_PROP | drpPeriod.Value1 | drpPlanDate.Value | 속성 Value1 설정 |  |  |  |

## FP00640_ILT_MODULE.Delete_buffer_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0843dfa3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1807 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Delete_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c12aa86c | (진입점 미연결) | FP00640_ILT_MODULE.cs:5894 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-0ba83a62 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5895 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3501262b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5897 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-0a1695dc | (진입점 미연결) | FP00640_ILT_MODULE.cs:5898 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a3096bca | (진입점 미연결) | FP00640_ILT_MODULE.cs:5899 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-1d2d7e18 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5900 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e4fea94c | (진입점 미연결) | FP00640_ILT_MODULE.cs:5901 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a64ebbcb | (진입점 미연결) | FP00640_ILT_MODULE.cs:5902 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-275cfb70 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5903 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bc0cf08b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5904 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-03dedd6f | (진입점 미연결) | FP00640_ILT_MODULE.cs:5905 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f0387b9b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5906 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1698acb3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5908 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f5ba5c1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5916 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-222e4ee5 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5920 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-f0101db1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5921 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61063391 | DeleteButton | FP00640_ILT_MODULE.cs:878 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00640_ILT_MODULE.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77ee6842 | Dispose | FP00640_ILT_MODULE.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00640_ILT_MODULE.DrawHeader

진입점: this.Load / this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c19e5d29 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6426 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-2a8d715a | this.Load 외 8 | FP00640_ILT_MODULE.cs:6430 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-727b5d0f | this.Load 외 8 | FP00640_ILT_MODULE.cs:6431 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-190e958d | this.Load 외 8 | FP00640_ILT_MODULE.cs:6432 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd3207e6 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6433 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-697c3c0f | this.Load 외 8 | FP00640_ILT_MODULE.cs:6434 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-c0010567 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6438 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-890c193c | this.Load 외 8 | FP00640_ILT_MODULE.cs:6439 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-d6790f9c | this.Load 외 8 | FP00640_ILT_MODULE.cs:6440 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-cda29a88 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6441 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-a6c98856 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6453 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-51eb790f | this.Load 외 8 | FP00640_ILT_MODULE.cs:6454 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0f40a86 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6460 | else of (with_day_part == false) ▸ if (sdate != measure.StartDate) | VALUE_SET | measure.StartDate | sdate | 컨트롤 값 설정 |  |  |  |
| AC-a60bd3ba | this.Load 외 8 | FP00640_ILT_MODULE.cs:6487 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba016018 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6493 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-95cbe779 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6495 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94a7ae49 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6496 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b61c3615 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6497 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-13907e8e | this.Load 외 8 | FP00640_ILT_MODULE.cs:6499 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-c872ec88 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6501 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-5a754a76 | this.Load 외 8 | FP00640_ILT_MODULE.cs:6502 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |

## FP00640_ILT_MODULE.DrawSheet

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5bc9e01 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6511 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ddecb00e | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6514 | if (!in_Dataset.Good()) | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e91d843c | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6515 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8728f323 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6522 |  | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41ae6188 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6524 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00640_ILT_MODULE.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fd13724 | EditButton | FP00640_ILT_MODULE.cs:886 | if (spdMain != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00640_ILT_MODULE.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0c5a717 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00640_ILT_MODULE.cs:3407 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1e3e830 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00640_ILT_MODULE.cs:3408 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-ed0d2af8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00640_ILT_MODULE.cs:3409 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-9d164d27 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00640_ILT_MODULE.cs:3411 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49d7bb97 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00640_ILT_MODULE.cs:3422 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-fedb53ef | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00640_ILT_MODULE.cs:3423 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db20675d | (진입점 미연결) | FP00640_ILT_MODULE.cs:3464 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78ceb9ab | (진입점 미연결) | FP00640_ILT_MODULE.cs:3465 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-c0611be2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3466 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-80f8d14a | (진입점 미연결) | FP00640_ILT_MODULE.cs:3468 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6968e38e | (진입점 미연결) | FP00640_ILT_MODULE.cs:3476 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-4536de22 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3477 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21865214 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3483 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.EditByFunc

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if ((row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_04" \|\| row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_09") // Di…) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ff3d2e4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00640_ILT_MODULE.cs:3433 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22095b4e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00640_ILT_MODULE.cs:3435 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d69b6c7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00640_ILT_MODULE.cs:3436 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-0c11057d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00640_ILT_MODULE.cs:3438 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7cead146 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00640_ILT_MODULE.cs:3448 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-390f35ac | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00640_ILT_MODULE.cs:3454 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-85dd3952 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00640_ILT_MODULE.cs:3456 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00640_ILT_MODULE.EditCommon

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if ((row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_04" \|\| row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_09") // Di…) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24957707 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:3491 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-63ff36b0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:3536 |  | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00640_ILT_MODULE.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ca84603 | ExcelButton | FP00640_ILT_MODULE.cs:2092 |  | EXCEL | ExportExcel | (0,true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00640_ILT_MODULE.ExcelPopup_BufferValidation_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06d7ddc1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5418 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-adf66c87 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5442 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0d11917b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5444 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1de3c0b4 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5445 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-38d0746e | (진입점 미연결) | FP00640_ILT_MODULE.cs:5446 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-051d86f1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5447 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e404e612 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5448 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5b39781 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5449 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54e4ec76 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5450 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-949852d2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5451 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54a41c3e | (진입점 미연결) | FP00640_ILT_MODULE.cs:5452 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b2e62dc2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5453 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6ad96eb1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5454 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ceefbd66 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5455 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["EQUIPMENT_ID"] | data.Tables[0].Rows[i]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-94dc4d4e | (진입점 미연결) | FP00640_ILT_MODULE.cs:5456 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d03daa7e | (진입점 미연결) | FP00640_ILT_MODULE.cs:5457 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6176e25d | (진입점 미연결) | FP00640_ILT_MODULE.cs:5458 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6d9ff448 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5459 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29e9cb6c | (진입점 미연결) | FP00640_ILT_MODULE.cs:5460 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sQtyCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2de74600 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5461 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SEQ"] | data.Tables[0].Rows[i][sSeqCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e0b3a4d3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5470 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | data.Tables[0].Rows[i][sQtyCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-52cfa822 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5471 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | nIn_KG | 행/컬럼 값 대입 |  |  |  |
| AC-172fa295 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5472 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Math.Round(Convert.ToUInt32(data.Tables[0].Rows[i][sQtyCol].ToString()) * nYield, 2) | 행/컬럼 값 대입 |  |  |  |
| AC-78f05c70 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5472 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | CALL_EXT | Convert.ToUInt32 | (data.Tables[0].Rows[i][sQtyCol].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5941c122 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5473 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Math.Ceiling(nIn_KG * nYield) | 행/컬럼 값 대입 |  |  |  |
| AC-9cde98c4 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5475 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1deeecde | (진입점 미연결) | FP00640_ILT_MODULE.cs:5476 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-34bec8b3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5479 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-706be9b9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5488 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2b8daa2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5512 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-60d2daf3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5517 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-98001bae | (진입점 미연결) | FP00640_ILT_MODULE.cs:5519 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-6185d5e7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5522 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-fa75672c | (진입점 미연결) | FP00640_ILT_MODULE.cs:5533 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a42d1b23 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5538 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-069a32bf | (진입점 미연결) | FP00640_ILT_MODULE.cs:5543 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b56b0ba3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5544 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.ExcelPopup_BufferValidation_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f5eca6a | (진입점 미연결) | FP00640_ILT_MODULE.cs:5591 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a9199a6a | (진입점 미연결) | FP00640_ILT_MODULE.cs:5593 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1bb9998f | (진입점 미연결) | FP00640_ILT_MODULE.cs:5594 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | data.Tables[0].Rows[i]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57a2416d | (진입점 미연결) | FP00640_ILT_MODULE.cs:5595 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-42fc130a | (진입점 미연결) | FP00640_ILT_MODULE.cs:5596 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6d33b19b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5597 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8ac7075b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5598 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5352e657 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5599 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c6d03596 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5600 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3874bd4d | (진입점 미연결) | FP00640_ILT_MODULE.cs:5601 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4357019b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5602 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3a125345 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5603 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ae0fadc9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5604 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["EQUIPMENT_ID"] | data.Tables[0].Rows[i]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6c140172 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5605 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7b38de28 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5606 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-30758cd3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5607 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d4c64481 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5608 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1e76778e | (진입점 미연결) | FP00640_ILT_MODULE.cs:5609 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-341731aa | (진입점 미연결) | FP00640_ILT_MODULE.cs:5610 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SEQ"] | data.Tables[0].Rows[i]["SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-79981eff | (진입점 미연결) | FP00640_ILT_MODULE.cs:5619 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7ff408f9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5620 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | nIn_KG | 행/컬럼 값 대입 |  |  |  |
| AC-c03fddae | (진입점 미연결) | FP00640_ILT_MODULE.cs:5621 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Math.Round(Convert.ToUInt32(data.Tables[0].Rows[i]["QTY"].ToString()) * nYield, 2) | 행/컬럼 값 대입 |  |  |  |
| AC-1079ddc2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5621 | try ▸ for (i < data.Tables[0].Rows.Count) | CALL_EXT | Convert.ToUInt32 | (data.Tables[0].Rows[i]["QTY"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e04320fc | (진입점 미연결) | FP00640_ILT_MODULE.cs:5622 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Math.Ceiling(nIn_KG * nYield) | 행/컬럼 값 대입 |  |  |  |
| AC-a114b961 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5624 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3375e2d4 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5625 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d500dac | (진입점 미연결) | FP00640_ILT_MODULE.cs:5628 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-d81eace1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5631 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3303f3e | (진입점 미연결) | FP00640_ILT_MODULE.cs:5651 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ lambda | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7edb7101 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5656 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-19cc452f | (진입점 미연결) | FP00640_ILT_MODULE.cs:5658 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba94c312 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5661 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) ▸ if (d… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-1c90d9bd | (진입점 미연결) | FP00640_ILT_MODULE.cs:5669 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-179a627a | (진입점 미연결) | FP00640_ILT_MODULE.cs:5674 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-d40b9c4b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5679 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a077a392 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5680 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.ExcelPopup_CheckBeforSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e7ba75b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5198 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Save cannot proceed Release.!") | 메시지 표시 |  |  |  |
| AC-58fb32eb | (진입점 미연결) | FP00640_ILT_MODULE.cs:5199 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4dc15123 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5204 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c0f47d0f | (진입점 미연결) | FP00640_ILT_MODULE.cs:5209 | try ▸ if (dtChk.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-4b7413fc | (진입점 미연결) | FP00640_ILT_MODULE.cs:5210 | try ▸ if (dtChk.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-18ad36d9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5215 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-5216fd2b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5219 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.ExcelPopup_SaveExcel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dabb231c | (진입점 미연결) | FP00640_ILT_MODULE.cs:5773 | if (data.Tables[0].Rows.Count > 0) | DATA_OP | Filter["MPP_WPP"] | filter["MPP_WPP"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9f4f63f1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5783 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.ExcelPopup_SaveExcel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9513459d | (진입점 미연결) | FP00640_ILT_MODULE.cs:5832 | if (data.Tables[0].Rows.Count > 0) | DATA_OP | Filter["MPP_WPP"] | filter["MPP_WPP"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9c920a54 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5842 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.ExcelPopup_Search_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c590cc7e | (진입점 미연결) | FP00640_ILT_MODULE.cs:5283 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.ExcelPopup_Search_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5462988d | (진입점 미연결) | FP00640_ILT_MODULE.cs:5332 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Exec_Procedure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9175af89 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2041 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00640_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00640_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-da85c93e | (진입점 미연결) | FP00640_ILT_MODULE.cs:2042 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-dab916b4 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2044 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-78e237c6 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2045 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-fd2c0d75 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2046 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-95e8c272 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2047 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7946b95d | (진입점 미연결) | FP00640_ILT_MODULE.cs:2049 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-6f57f92c | (진입점 미연결) | FP00640_ILT_MODULE.cs:2050 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e891aa9f | (진입점 미연결) | FP00640_ILT_MODULE.cs:2051 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-a2cfe15a | (진입점 미연결) | FP00640_ILT_MODULE.cs:2052 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-50ff4059 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2053 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-42cff7c3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2054 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b563fe26 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2055 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9c0e1c98 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2056 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b00eb75c | (진입점 미연결) | FP00640_ILT_MODULE.cs:2057 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-621ad526 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2058 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fce581cf | (진입점 미연결) | FP00640_ILT_MODULE.cs:2059 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6f25ac53 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2060 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-175611e7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2061 | try | DATA_OP | req.Parameters["p_equipment_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a22f4ce7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2062 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9cc3b551 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2063 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a4a20036 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2064 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-495392d2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2065 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8ca3c531 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2066 | try | DATA_OP | req.Parameters["p_seq"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6479ee60 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2068 | try | DATA_OP | req.Parameters["p_adjust_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9041d2ea | (진입점 미연결) | FP00640_ILT_MODULE.cs:2069 | try | DATA_OP | req.Parameters["p_adjust_in_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8effab5f | (진입점 미연결) | FP00640_ILT_MODULE.cs:2070 | try | DATA_OP | req.Parameters["p_adjust_in_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-205942d7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2071 | try | DATA_OP | req.Parameters["p_adjust_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b0bcac34 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2072 | try | DATA_OP | req.Parameters["p_adjust_out_qty_batch"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d893a7f9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2073 | try | DATA_OP | req.Parameters["p_adjust_out_qty_kg"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-352b2845 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2075 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-77598cb0 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2082 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-8293606f | (진입점 미연결) | FP00640_ILT_MODULE.cs:2086 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] / this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33a2cd9a | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1015 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00640_ILT_MODULE") ⇒ FP_Planning.PR_UI_FP00640_ILT_MODULE | 엔드포인트 요청 생성 |  |  |  |
| AC-6530bead | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1016 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1a9df1e8 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1017 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-7c9de905 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1018 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-1cfb50c3 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1019 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7885b2a9 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1020 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-534abb20 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1022 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["ILT_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-16e771c4 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1023 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3d847f11 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1024 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d46f2a9c | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1025 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6099b56b | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1026 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-18d31059 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1027 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3b2447a0 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1028 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-15c71a3a | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1029 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a4dcdbd4 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1030 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ebbf39b2 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1031 | try | DATA_OP | request.Parameters["p_model"] | Filter["MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f2604069 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1032 | try | DATA_OP | request.Parameters["p_module"] | Filter["MODULE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1260067e | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1033 | try | DATA_OP | request.Parameters["p_cell"] | Filter["CELL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-756bc74b | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1034 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-60d1a358 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1035 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-77da7810 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1036 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-8bf17e6b | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1037 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-32a68655 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1038 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-4aa8d24c | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1039 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-56d4f21d | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1040 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-d936f5c8 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1041 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-efdeede2 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1042 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-30628b62 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1044 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-527327e8 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1045 | try | DATA_OP | request.Parameters["p_total_table"] | Filter["TOTAL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2a987bc4 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1047 | try | DATA_OP | request.Parameters["p_attribute_1"] | chk_ref.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-8e3efadf | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1048 | try | DATA_OP | request.Parameters["p_attribute_2"] | chk_cma.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-09d154ef | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1049 | try | DATA_OP | request.Parameters["p_attribute_3"] | chk_waitChar.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-b208fd6c | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1050 | try | DATA_OP | request.Parameters["p_attribute_4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fea4779a | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1051 | try | DATA_OP | request.Parameters["p_attribute_5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-825a720d | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1052 | try | DATA_OP | request.Parameters["p_attribute_6"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9083571a | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1053 | try | DATA_OP | request.Parameters["p_attribute_7"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-64efaf45 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1054 | try | DATA_OP | request.Parameters["p_attribute_8"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d5191241 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1055 | try | DATA_OP | request.Parameters["p_attribute_9"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ded26ddd | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1056 | try | DATA_OP | request.Parameters["p_attribute_10"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-423ad265 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1058 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-23575215 | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1059 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b8e89b1e | popSql.OnSql [if (programID == "PR_UI_FP00640_ILT_MODULE")] 외 7 | FP00640_ILT_MODULE.cs:1064 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Find_Data_Excel_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-588ffd1c | (진입점 미연결) | FP00640_ILT_MODULE.cs:5736 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-af7e7863 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5737 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-35a8cf70 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5739 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-fb8ea20e | (진입점 미연결) | FP00640_ILT_MODULE.cs:5740 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e063a656 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5741 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b9353480 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5742 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-817cd879 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5743 | try | DATA_OP | request.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-e41831fa | (진입점 미연결) | FP00640_ILT_MODULE.cs:5744 | try | DATA_OP | request.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-9ff173b1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5745 | try | DATA_OP | request.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-e70c6e40 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5746 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-45c1bc56 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5747 | try | DATA_OP | request.Parameters["p_site_id"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-72299e73 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5748 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a8b34549 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5750 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b3e3afc7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5752 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-979e8ae4 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5757 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Find_Data_Excel_Import

진입점: popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE") ▸ if (popup != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7ca4c2d | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5348 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL") ⇒ FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL | 엔드포인트 요청 생성 |  |  |  |
| AC-6c816b5c | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5349 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-aeec3d59 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5351 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-1e53b9d1 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5352 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1b29d30e | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5353 | try | DATA_OP | request.Parameters["p_sys_gubun"] | gubun | 행/컬럼 값 대입 |  |  |  |
| AC-aafaf827 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5354 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-147cf2ec | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5355 | try | DATA_OP | request.Parameters["p_proc_name"] | procedure_name.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-d16a26d7 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5364 | try ▸ if (dsParameter != null && dsParameter.Rows != null && dsParameter.Rows.Count > 0) | CALL_EXT | param.Keys | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce6241c9 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5378 | try | DATA_OP | request.Parameters["in_columns"] | keys | 행/컬럼 값 대입 |  |  |  |
| AC-a6435a1c | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5379 | try | DATA_OP | request.Parameters["in_row"] | values | 행/컬럼 값 대입 |  |  |  |
| AC-69796b50 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5380 | try | DATA_OP | request.Parameters["opt_none"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c27da11 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5382 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3f2f406c | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5384 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-2f9a59e9 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5389 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-f6e5c3b3 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… | FP00640_ILT_MODULE.cs:5391 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Find_Save_Valid

진입점: popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SELECT")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6abe44b | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1869 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00640_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP00640_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-e4de1a77 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1870 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-af697cdf | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1871 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-30cc5da1 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1872 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-13588525 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1873 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f2fee051 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1875 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7842fcbb | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1876 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-10f5f359 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1877 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b5eafc66 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1878 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f143da9d | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1879 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a041b881 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1880 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b099f72b | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1881 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4c6b13f7 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1882 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c8429933 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1883 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8b5f4d2c | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1884 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b436c99d | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1885 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9fb70114 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1886 | try | DATA_OP | request.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f6e0b5f0 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1887 | try | DATA_OP | request.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-058f8bad | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1888 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f5cf01f7 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1889 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b62e7e85 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1890 | try | DATA_OP | request.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-54d86a32 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1891 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9e9d1bf7 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1892 | try | DATA_OP | request.Parameters["p_bucket_from"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-04bf5f76 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1893 | try | DATA_OP | request.Parameters["p_bucket_to"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-645cf3a8 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1894 | try | DATA_OP | request.Parameters["p_day_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2a0aa51d | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1895 | try | DATA_OP | request.Parameters["p_week_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5429449f | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1896 | try | DATA_OP | request.Parameters["p_month_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3001d37d | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1897 | try | DATA_OP | request.Parameters["p_cate_info"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-246c4391 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1898 | try | DATA_OP | request.Parameters["p_cate_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-00abefc4 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1899 | try | DATA_OP | request.Parameters["p_cate_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-22b69c0c | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1900 | try | DATA_OP | request.Parameters["p_amend_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f2d9fbfa | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1901 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f1eea63e | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1902 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-00ae957d | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1903 | try | DATA_OP | request.Parameters["p_amend_boh_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2f137f5a | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1904 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a65457fb | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1905 | try | DATA_OP | request.Parameters["p_amend_util_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8e21aa21 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1906 | try | DATA_OP | request.Parameters["p_amend_capa_table"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5fcc13ae | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1908 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a3189219 | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1910 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6624daea | popSql.OnSql [if (programID == "PR_UI_FP00640_SAVE_VALID_SEL… | FP00640_ILT_MODULE.cs:1916 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.FindTotalColorStart

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (Da…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7f7614a | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1607 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4640f99 | this.Load | FP00640_ILT_MODULE.cs:260 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00640_ILT_MODULE.GetDayColNameOfType_Local

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55ae7a29 | (진입점 미연결) | FP00640_ILT_MODULE.cs:554 |  | RETURN | return day.Value + date_append_name; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE") ▸ lambda] / this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAm…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3db60b29 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:4011 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.GetListDataSet

진입점: popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE")] / this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db803b16 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1236 |  | FLAG | dsListData | Data_FP.CallGeneralProcedure(("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-b64c66cf | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1236 |  | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "LIST_DATA") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00640_ILT_MODULE.GetMonthColNameOfType_Local

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93af1bdc | (진입점 미연결) | FP00640_ILT_MODULE.cs:558 |  | RETURN | return month.Value + month_append_name; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.GetToDay

진입점: drpPlanDate.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e326fc7 | drpPlanDate.DateTimeChanged | FP00640_ILT_MODULE.cs:4218 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-492fc484 | drpPlanDate.DateTimeChanged | FP00640_ILT_MODULE.cs:4219 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.GetWeekColNameOfType_Local

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65bca436 | (진입점 미연결) | FP00640_ILT_MODULE.cs:550 |  | RETURN | return week.Value + week_append_name; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.GoEditMode

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-991d0ed7 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1272 |  | CALL_EXT | FPExtensions.ColorFromName | ("yellow") | ⚠ 의미 확인 필요 |  |  |  |
| AC-acc697c6 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1273 |  | CALL_EXT | FPExtensions.ColorFromName | ("lightgray") | ⚠ 의미 확인 필요 |  |  |  |
| AC-64e9984b | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1305 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolnames[k] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-7ec03fda | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1306 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolidxs[k] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-c796bd3f | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1335 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeNoColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89c6d6af | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1337 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, editColor) | 그리드 표시 설정 |  |  |  |
| AC-8acc2861 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1350 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeNoColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8307842e | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1352 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, editColor) | 그리드 표시 설정 |  |  |  |
| AC-0e3bb5af | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1404 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, grayColor) | 그리드 표시 설정 |  |  |  |
| AC-6242da5d | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:1419 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00640_ILT_MODULE.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a87df4ed | this.Load | FP00640_ILT_MODULE.cs:330 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4ebf8c34 | this.Load | FP00640_ILT_MODULE.cs:334 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ba1d84ab | this.Load | FP00640_ILT_MODULE.cs:335 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-95dfae10 | this.Load | FP00640_ILT_MODULE.cs:339 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-09bc1d86 | this.Load | FP00640_ILT_MODULE.cs:341 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-ed876817 | this.Load | FP00640_ILT_MODULE.cs:345 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b25e2a1b | this.Load | FP00640_ILT_MODULE.cs:349 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7ff21d16 | this.Load | FP00640_ILT_MODULE.cs:354 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-d04fdced | this.Load | FP00640_ILT_MODULE.cs:360 | try | FLAG | _sToDay | drpPlanDate.DateTime.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-60920f3d | this.Load | FP00640_ILT_MODULE.cs:370 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-59495b10 | this.Load | FP00640_ILT_MODULE.cs:371 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-985992ff | this.Load | FP00640_ILT_MODULE.cs:372 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ebfb47a6 | this.Load | FP00640_ILT_MODULE.cs:373 | try ▸ if (adminAuth == false) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7c041047 | this.Load | FP00640_ILT_MODULE.cs:380 | try ▸ if (!_sSaveAuth.Equals("Y")) | VALUE_SET | chk_ref.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-3158a2c3 | this.Load | FP00640_ILT_MODULE.cs:381 | try ▸ if (!_sSaveAuth.Equals("Y")) | VALUE_SET | chk_confirmPlan.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-372e3f61 | this.Load | FP00640_ILT_MODULE.cs:388 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00640_ILT_MODULE.InitEditingBuf

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6e7946f | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:4224 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-15158c9e | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:4227 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b3eebcf8 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:4231 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |

## FP00640_ILT_MODULE.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dec9d7f | this.Load | FP00640_ILT_MODULE.cs:301 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-c2c93bb6 | this.Load | FP00640_ILT_MODULE.cs:302 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-b8c640db | this.Load | FP00640_ILT_MODULE.cs:303 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00640_ILT_MODULE.InitSpread

진입점: this.Load / this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82937292 | this.Load 외 8 | FP00640_ILT_MODULE.cs:423 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-514deb4d | this.Load 외 8 | FP00640_ILT_MODULE.cs:424 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e1e5f550 | this.Load 외 8 | FP00640_ILT_MODULE.cs:426 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6820d33e | this.Load 외 8 | FP00640_ILT_MODULE.cs:430 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00640_ILT_MODULE.Insert_Buffer_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a6430d1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1821 | for (i < data.Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-34e87782 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1823 | for (i < data.Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-581dd8c6 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1824 | for (i < data.Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | data.Rows[i]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-12b9cea9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1825 | for (i < data.Rows.Count) | DATA_OP | newrow["FP_PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-22fef2d7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1826 | for (i < data.Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-118ef65d | (진입점 미연결) | FP00640_ILT_MODULE.cs:1827 | for (i < data.Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d0713380 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1828 | for (i < data.Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-855c68f8 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1829 | for (i < data.Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d9df523f | (진입점 미연결) | FP00640_ILT_MODULE.cs:1830 | for (i < data.Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc8b96d5 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1831 | for (i < data.Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8b27ef34 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1832 | for (i < data.Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2207bc38 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1833 | for (i < data.Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2a005cfe | (진입점 미연결) | FP00640_ILT_MODULE.cs:1834 | for (i < data.Rows.Count) | DATA_OP | newrow["EQUIPMENT_ID"] | data.Rows[i]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d256e7f9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1835 | for (i < data.Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7e90bf5a | (진입점 미연결) | FP00640_ILT_MODULE.cs:1836 | for (i < data.Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c00321c1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1837 | for (i < data.Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d63edd51 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1838 | for (i < data.Rows.Count) | DATA_OP | newrow["MARKET"] | data.Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f9b9402b | (진입점 미연결) | FP00640_ILT_MODULE.cs:1839 | for (i < data.Rows.Count) | DATA_OP | newrow["QTY"] | data.Rows[i]["ADJUST_OUT_QTY_BATCH"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dab329c1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1840 | for (i < data.Rows.Count) | DATA_OP | newrow["SEQ"] | data.Rows[i]["SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1995e413 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1842 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_BATCH"] | Convert.ToDouble(data.Rows[i]["ADJUST_IN_QTY_BATCH"]) | 행/컬럼 값 대입 |  |  |  |
| AC-5ebd08a7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1843 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_IN_QTY_KG"] | Convert.ToDouble(data.Rows[i]["ADJUST_IN_QTY_KG"]) | 행/컬럼 값 대입 |  |  |  |
| AC-e68e17ff | (진입점 미연결) | FP00640_ILT_MODULE.cs:1844 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_BATCH"] | Convert.ToDouble(data.Rows[i]["ADJUST_OUT_QTY_BATCH"]) | 행/컬럼 값 대입 |  |  |  |
| AC-b40bfd8f | (진입점 미연결) | FP00640_ILT_MODULE.cs:1845 | for (i < data.Rows.Count) | DATA_OP | newrow["ADJUST_OUT_QTY_KG"] | Convert.ToDouble(data.Rows[i]["ADJUST_OUT_QTY_KG"]) | 행/컬럼 값 대입 |  |  |  |
| AC-e7f4fc8b | (진입점 미연결) | FP00640_ILT_MODULE.cs:1849 | for (i < data.Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8f72d8ae | (진입점 미연결) | FP00640_ILT_MODULE.cs:1850 | for (i < data.Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fa112f03 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1853 | for (i < data.Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e343df51 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1856 |  | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-94be2738 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1860 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Insert_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-233f9ddb | (진입점 미연결) | FP00640_ILT_MODULE.cs:5693 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00640_EXCELIMPORT", "insert_Excel_buffer", dsData) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\{?def… | 엔드포인트 호출 |  |  |  |
| AC-f4d31b3d | (진입점 미연결) | FP00640_ILT_MODULE.cs:5697 | try ▸ if (result.Good()) | DATA_OP | result.Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3d23d09 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5709 | try ▸ if (result.Good()) ▸ if (result.Columns.Contains("RESULT")) ▸ else of (result.Rows[0]["RESULT"].ToString().ToUpper() == "SUCCESS") ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e872c3ee | (진입점 미연결) | FP00640_ILT_MODULE.cs:5717 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-0ccb1427 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5721 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-5f1a04ed | (진입점 미연결) | FP00640_ILT_MODULE.cs:5722 | catch ((Exception ex)) | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-933de5f9 | InsertButton | FP00640_ILT_MODULE.cs:818 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8988f4f2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:2099 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00640_ILT_MODULE.lfn_getYieldInfo_Excel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5496eaea | (진입점 미연결) | FP00640_ILT_MODULE.cs:6030 | if (!string.IsNullOrEmpty(sColName) && sDay == "") ▸ lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a20f209 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6046 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e5c7c9e | (진입점 미연결) | FP00640_ILT_MODULE.cs:6047 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-618a932e | (진입점 미연결) | FP00640_ILT_MODULE.cs:6048 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dedece1c | (진입점 미연결) | FP00640_ILT_MODULE.cs:6049 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c021ff8e | (진입점 미연결) | FP00640_ILT_MODULE.cs:6050 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e376c1ed | (진입점 미연결) | FP00640_ILT_MODULE.cs:6051 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b4b6a5f | (진입점 미연결) | FP00640_ILT_MODULE.cs:6051 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c4489a7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6066 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.lfn_setExchangeBatch_Excel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bbcec5e | (진입점 미연결) | FP00640_ILT_MODULE.cs:5941 | if (!string.IsNullOrEmpty(sColName) && sDay == "") ▸ lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-daf41304 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5963 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-550d4858 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5970 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a3448d1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5971 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-620db272 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5972 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d1cc87a | (진입점 미연결) | FP00640_ILT_MODULE.cs:5973 | lambda | DATA_OP | each_row.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-3281019c | (진입점 미연결) | FP00640_ILT_MODULE.cs:5990 | lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-839d921a | (진입점 미연결) | FP00640_ILT_MODULE.cs:5991 | lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbd60d32 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5992 | lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a6e5366 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5993 | lambda | DATA_OP | each_row.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc97d9da | (진입점 미연결) | FP00640_ILT_MODULE.cs:5994 | lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c874af4 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5995 | lambda | DATA_OP | each_row.Field | ("START_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5829f21b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5995 | lambda | DATA_OP | each_row.Field | ("END_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d8f2d0f | (진입점 미연결) | FP00640_ILT_MODULE.cs:6013 |  | RETURN | return nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.lfn_setReleaseProcess

진입점: popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE")] / this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ccb1f89 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1210 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a4df9c1c | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1224 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ if (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCurrDate… | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-77762f9a | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1226 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ else of (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCur… | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-d8817d45 | popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_C… 외 7 | FP00640_ILT_MODULE.cs:1230 |  | RETURN | return dtMapData; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.onMemoMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22cf0a03 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3916 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-394184c7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3919 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-925a0499 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3938 | if (day != null) | POPUP | new FPC0096_MemoEditPopup | (row, day, arg.Row, arg.Column) | 팝업/폼 생성 |  |  |  |
| AC-9ebd7ca2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3939 | if (day != null) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-0b948af4 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3939 | if (day != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8544164c | (진입점 미연결) | FP00640_ILT_MODULE.cs:3940 | if (day != null) | DATA_OP | frm.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9fa6b40c | (진입점 미연결) | FP00640_ILT_MODULE.cs:3941 | if (day != null) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-42f4694d | (진입점 미연결) | FP00640_ILT_MODULE.cs:3943 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7515fb40 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3944 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c082016d | (진입점 미연결) | FP00640_ILT_MODULE.cs:3948 | if (day != null) ▸ if (frm.DialogResult == DialogResult.OK) | GRID_SET | siMain.ActiveSheet.Cells[arg.Row, arg.Column].Font | new Font(FontFamily.GenericSansSerif, 10.0F, FontStyle.Bold) | 그리드 속성/값 설정 |  |  |  |
| AC-0709f880 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3950 | if (day != null) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP00640_ILT_MODULE.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a255577a | (진입점 미연결) | FP00640_ILT_MODULE.cs:3960 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b39afdb | (진입점 미연결) | FP00640_ILT_MODULE.cs:3963 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60045648 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3981 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-595a3010 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3982 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-87e82c9c | (진입점 미연결) | FP00640_ILT_MODULE.cs:3983 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-620d5188 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3984 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-25928677 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3985 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-ac965e44 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3986 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-f85fad39 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3987 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e1e5a304 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3988 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1417872d | (진입점 미연결) | FP00640_ILT_MODULE.cs:3989 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00640_ILT_MODULE.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e8688b5 | bucke_menu.Click | FP00640_ILT_MODULE.cs:3652 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7c4d9c9c | bucke_menu.Click | FP00640_ILT_MODULE.cs:3655 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.onZeroLineMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b682ae9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3697 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c1c65bb | (진입점 미연결) | FP00640_ILT_MODULE.cs:3711 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da8cb4c6 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3714 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c130998 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3765 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da2c0cd7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3820 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fe8f06b | (진입점 미연결) | FP00640_ILT_MODULE.cs:3823 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01b8f423 | (진입점 미연결) | FP00640_ILT_MODULE.cs:3868 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.planday_changed

진입점: drpPlanDate.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84938a63 | drpPlanDate.DateTimeChanged | FP00640_ILT_MODULE.cs:2139 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6ab5c9d | drpPlanDate.DateTimeChanged | FP00640_ILT_MODULE.cs:2141 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | VALUE_SET | drpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-d97840bb | drpPlanDate.DateTimeChanged | FP00640_ILT_MODULE.cs:2148 | else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00640_ILT_MODULE.rdo_uom_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a612e7a | (진입점 미연결) | FP00640_ILT_MODULE.cs:6712 |  | DATA_OP | Filter["UOM"] | radioGroup.Text | 행/컬럼 값 대입 |  |  |  |

## FP00640_ILT_MODULE.RefreshHeadAndBody

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cee6e88e | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6392 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-546716ba | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6407 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-72b3bbc8 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6411 | finally | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-37d3d282 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6412 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00640_ILT_MODULE.RefreshSpreadSheet

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae15fe49 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6365 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-2bb10dbc | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6365 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-f8308a9d | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6372 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b4c5a38 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6377 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00640_ILT_MODULE.RoundValue

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if ((row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_04" \|\| row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_09") // Di…) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (true) ▸ if (sCateID.Equals("CATEGORY_04"))] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8d874c4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:6867 | if (_RoundPoint < 1 \|\| _RoundPoint > 11) | FLAG | _RoundPoint | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-6c503581 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:6868 | if (_RoundPoint < 1 \|\| _RoundPoint > 11) | FLAG | _RoundTen | 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-085f4e3c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:6872 | try | CALL_EXT | Math.Truncate | ((double)((decimal)ori * (decimal)_RoundTen)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b5a6dbc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:6873 | try | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-c32c62ec | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:6876 |  | RETURN | return ori; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b76d38c8 | popSql.OnSql | FP00640_ILT_MODULE.cs:4995 | if (programID == "PR_UI_FP00640_ILT_MODULE") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-a7f8b285 | popSql.OnSql | FP00640_ILT_MODULE.cs:5000 | if (programID == "PR_UI_FP00640_SAVE_VALID_SELECT") | RETURN | return Find_Save_Valid("SQL", "FIND_AMEND_VALIDATION_PMIX"); |  | 처리 중단/반환 |  |  |  |
| AC-7163d43e | popSql.OnSql | FP00640_ILT_MODULE.cs:5012 | if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("there can't Veiw Query[Relase].") | 메시지 표시 |  |  |  |
| AC-4983d02f | popSql.OnSql | FP00640_ILT_MODULE.cs:5013 | if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c0351c4e | popSql.OnSql | FP00640_ILT_MODULE.cs:5017 | if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | dtData.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-21039656 | popSql.OnSql | FP00640_ILT_MODULE.cs:5019 | if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return Save_Data_Amend(dtSaveTmp, "MERGE_DATA", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-4a21ab99 | popSql.OnSql | FP00640_ILT_MODULE.cs:5024 | if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("there is no Edit Value of Plan(Out).") | 메시지 표시 |  |  |  |
| AC-e897cc5d | popSql.OnSql | FP00640_ILT_MODULE.cs:5025 | if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1df36d67 | popSql.OnSql | FP00640_ILT_MODULE.cs:5030 | if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸ else of (dtData != null) | MESSAGE | MessageBox.Show | ("there is no Edit Value of of Plan(Out).") | 메시지 표시 |  |  |  |
| AC-bab5a042 | popSql.OnSql | FP00640_ILT_MODULE.cs:5031 | if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸ else of (dtData != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b865d01b | popSql.OnSql | FP00640_ILT_MODULE.cs:5042 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE") | POPUP | new FP00607_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-16d4af11 | popSql.OnSql | FP00640_ILT_MODULE.cs:5046 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.DateColumnType | FPExtensions.DateColumnType.CELL | 속성 DateColumnType 설정 |  |  |  |
| AC-94a7cdda | popSql.OnSql | FP00640_ILT_MODULE.cs:5048 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-facfe956 | popSql.OnSql | FP00640_ILT_MODULE.cs:5049 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-063c065d | popSql.OnSql | FP00640_ILT_MODULE.cs:5050 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-b7a60347 | popSql.OnSql | FP00640_ILT_MODULE.cs:5052 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-1e793419 | popSql.OnSql | FP00640_ILT_MODULE.cs:5059 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00640_AMEND_LINE_EXCEL", Filter,… |  | 처리 중단/반환 |  |  |  |
| AC-d2736e48 | popSql.OnSql | FP00640_ILT_MODULE.cs:5071 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_ROWTYPE") | POPUP | new FP00607_RowExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fd5ce587 | popSql.OnSql | FP00640_ILT_MODULE.cs:5076 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-f92289f7 | popSql.OnSql | FP00640_ILT_MODULE.cs:5077 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-0674ebfa | popSql.OnSql | FP00640_ILT_MODULE.cs:5078 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-3967a14f | popSql.OnSql | FP00640_ILT_MODULE.cs:5080 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-2e9d73d7 | popSql.OnSql | FP00640_ILT_MODULE.cs:5086 | if (programID == "PR_UI_FP00640_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00640_AMEND_LINE_EXCEL", Filter,… |  | 처리 중단/반환 |  |  |  |
| AC-f70a128a | popSql.OnSql | FP00640_ILT_MODULE.cs:5092 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Save_Create_Plan

진입점: this.btnCreatePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c722be1e | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2601 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3a223cd9 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2602 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0de4f700 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2605 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f28b3853 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2611 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4f959930 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2612 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ff56b3a | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2620 | try ▸ if (ds.Rows.Count > 0) ▸ try | DATA_OP | input["P_MASTER_ID"] | Filter["ILT_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2bdc785c | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2621 | try ▸ if (ds.Rows.Count > 0) ▸ try | DATA_OP | input["P_PLAN_ID"] | ds.Rows[0][0].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c8faeaf3 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2622 | try ▸ if (ds.Rows.Count > 0) ▸ try | DATA_OP | input["P_FIX_OPTION"] | (selected == 0 ? "Y" : "N") | 행/컬럼 값 대입 |  |  |  |
| AC-b2bd6d89 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2626 | try ▸ if (ds.Rows.Count > 0) ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP00640", "PR_SCM_PACK_FORM_PLAN", input.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=PR_SCM_PACK_FORM_PLAN] \| FP\… | 엔드포인트 호출 |  |  |  |
| AC-6457c8db | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2630 | try ▸ if (ds.Rows.Count > 0) ▸ try | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Rows[0][0].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ec656de | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2638 | try ▸ if (ds.Rows.Count > 0) ▸ catch ((Exception ee)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { ee.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4167eb92 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2668 | try ▸ else of (ds.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-248c3e83 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2671 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-61884eb7 | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2675 | catch () | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5e39861a | this.btnCreatePlan.Click | FP00640_ILT_MODULE.cs:2680 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00640_ILT_MODULE.Save_Create_PlanData

진입점: this.btnCreatePlan.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a80165f4 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2902 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findNewPlan", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fbae1f4b | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2908 | try ▸ if (dtNewPlanID.Rows.Count > 0) | FLAG | this._NewPlanId | sNewPlanID | 화면 필드/플래그 변경 |  |  |  |
| AC-69abaceb | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2913 | try ▸ if (dtNewPlanID.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sNewPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e450a2ef | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2914 | try ▸ if (dtNewPlanID.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sNewPlanID)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c4e53a11 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2918 | try | UI_PROP | DsinData.PLAN_ID | sNewPlanID | 속성 PLAN_ID 설정 |  |  |  |
| AC-eb51ec49 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2922 | try ▸ if (DsinData.PLAN_TYPE.Equals("PRE")) | UI_PROP | DsinData.BASIS_PLAN_ID | sNewPlanID | 속성 BASIS_PLAN_ID 설정 |  |  |  |
| AC-b45b207d | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2949 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00590_PLAN_CONTROL") ⇒ FP_Planning.PR_UI_FP00590_PLAN_CONTROL | 엔드포인트 요청 생성 |  |  |  |
| AC-fa41cb54 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2950 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-de34f7c7 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2952 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-c2208af5 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2953 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-451084f9 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2954 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-dd9955d5 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2955 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a29fa14e | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2957 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e2a035b | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2958 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-402d12c2 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2959 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-3aa06a2b | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2960 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-179c52de | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2962 | try | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-7b5b8360 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2963 | try | DATA_OP | req.Parameters["p_plan_horizon"] | p_plan_horizon | 행/컬럼 값 대입 |  |  |  |
| AC-5ce97dd3 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2964 | try | DATA_OP | req.Parameters["p_demand_horizon"] | p_demand_horizon | 행/컬럼 값 대입 |  |  |  |
| AC-27efb7e9 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2965 | try | DATA_OP | req.Parameters["p_basis_plan_id"] | p_basis_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-8cd672c9 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2966 | try | DATA_OP | req.Parameters["p_pre_fix_flag"] | p_pre_fix_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c549c25a | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2967 | try | DATA_OP | req.Parameters["p_pre_fix_target_id"] | p_pre_fix_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-f3956257 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2968 | try | DATA_OP | req.Parameters["p_sync_operation"] | p_sync_operation | 행/컬럼 값 대입 |  |  |  |
| AC-ea82b1b2 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2969 | try | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-c05768d9 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2970 | try | DATA_OP | req.Parameters["p_pre_fix_type"] | p_pre_fix_type | 행/컬럼 값 대입 |  |  |  |
| AC-e6910850 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2971 | try | DATA_OP | req.Parameters["p_pre_fix_date"] | p_pre_fix_date | 행/컬럼 값 대입 |  |  |  |
| AC-49e57985 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2972 | try | DATA_OP | req.Parameters["p_pre_fix_2_flag"] | p_pre_fix_2_flag | 행/컬럼 값 대입 |  |  |  |
| AC-381b53b8 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2973 | try | DATA_OP | req.Parameters["p_pre_fix_date2"] | p_pre_fix_date2 | 행/컬럼 값 대입 |  |  |  |
| AC-4579e3ba | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2974 | try | DATA_OP | req.Parameters["p_pre_fix_type2"] | p_pre_fix_type2 | 행/컬럼 값 대입 |  |  |  |
| AC-019a594f | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2975 | try | DATA_OP | req.Parameters["p_wow_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5369dd5d | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2977 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8a09c9ed | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2980 | try | RETURN | return dtNewPlanID; |  | 처리 중단/반환 |  |  |  |
| AC-80c17487 | this.btnCreatePlan.Click [try] | FP00640_ILT_MODULE.cs:2987 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Save_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE")] / SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53d0f906 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:1988 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00640_AMEND_SAVE") ⇒ FP_Planning.PR_UI_FP00640_AMEND_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-12e84c87 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:1989 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e11790d1 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:1991 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-8ad3deec | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:1992 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-851d9545 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:1993 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-f8a293ad | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:1994 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f73b555b | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:1995 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-d9739951 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:1996 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-bc9d5004 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:1997 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-34bbf067 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:1998 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4c483db2 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:1999 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-38326a03 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2000 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-50c4f079 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2001 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_item_id"] | p_model_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-925fd701 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2002 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_module_item_id"] | p_module_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ebe8f33e | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2003 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_item_id"] | p_cell_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-baa4be97 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2004 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-57938544 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2005 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-9c08e3b3 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2006 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-ce0e3ba8 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2007 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-92b5f4c4 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2008 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-b30c4266 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2009 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-ce4ee6b8 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2010 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-1e4739ef | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2011 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-53837075 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2013 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3fa2c6f6 | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2014 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-bb04553c | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2019 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2a36399d | popSql.OnSql [if (programID == "PR_UI_FP00640_AMEND_SAVE") ▸… 외 1 | FP00640_ILT_MODULE.cs:2024 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Save_Data_Excel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed882011 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5795 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-396e059e | (진입점 미연결) | FP00640_ILT_MODULE.cs:5796 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-613fb94b | (진입점 미연결) | FP00640_ILT_MODULE.cs:5798 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-c5de6085 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5799 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-97de1a66 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5800 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-84e578a9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5801 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5a646d2d | (진입점 미연결) | FP00640_ILT_MODULE.cs:5802 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-73b7f66c | (진입점 미연결) | FP00640_ILT_MODULE.cs:5803 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-13327695 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5804 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-60bc28ec | (진입점 미연결) | FP00640_ILT_MODULE.cs:5805 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-038a9ad1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5806 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-c919cac9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5807 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | pMppWpp | 행/컬럼 값 대입 |  |  |  |
| AC-cb234182 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5809 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ed8c00e7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5811 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-96eb8bb2 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5816 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-eeca5939 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5818 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Save_Data_Excel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29e481d9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5854 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00640_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-4a9ca48c | (진입점 미연결) | FP00640_ILT_MODULE.cs:5855 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d5f0ff6a | (진입점 미연결) | FP00640_ILT_MODULE.cs:5857 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-ef4550dc | (진입점 미연결) | FP00640_ILT_MODULE.cs:5858 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0650897f | (진입점 미연결) | FP00640_ILT_MODULE.cs:5859 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-54d36f89 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5860 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0bb85e84 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5861 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-b35fd043 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5862 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-635603fc | (진입점 미연결) | FP00640_ILT_MODULE.cs:5863 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d9caa5f4 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5864 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-09480641 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5865 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-1d817149 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5866 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f0236ff | (진입점 미연결) | FP00640_ILT_MODULE.cs:5868 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-078b1448 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5870 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-a4c909cc | (진입점 미연결) | FP00640_ILT_MODULE.cs:5875 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-e43c69a9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5877 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.Save_PIn_Data

진입점: SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-708f9c0b | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1656 | if (siMain == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1142cb7a | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1658 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-acb1c6d1 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1663 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f059c72 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1664 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a6ab1e53 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1669 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-05fee540 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1680 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d339c00e | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1693 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9a525ac7 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1694 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-41d9b95d | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1697 | try | CALL_EXT | dtData.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b62a43e | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1738 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("It can not be PLAN_TYPE[RELEASE]", "FP", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-58c72871 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1739 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6b4203d2 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1746 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-de8f9a7d | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1777 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-350aa8aa | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1778 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2e7c7a44 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1783 | try ▸ if (!string.IsNullOrEmpty(sError) \|\| ds2 == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-246366c2 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1786 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-67fd36a5 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1788 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-48cc8290 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1792 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-00b57ef9 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1793 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c18eec40 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1794 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-6746b974 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1795 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0721cce0 | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1799 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e475b09e | SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsList… | FP00640_ILT_MODULE.cs:1800 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00640_ILT_MODULE.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7d5118c | SaveButton | FP00640_ILT_MODULE.cs:897 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a45ddd1 | SaveButton | FP00640_ILT_MODULE.cs:921 | try ▸ if (dsListData != null) ▸ catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-cbdd2657 | SaveButton | FP00640_ILT_MODULE.cs:956 | try ▸ if (bSaveChk == true) | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-af508654 | SaveButton | FP00640_ILT_MODULE.cs:957 | try ▸ if (bSaveChk == true) | STATE_RESET | dsListData.Tables[0].Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-769e201f | SaveButton | FP00640_ILT_MODULE.cs:967 | try ▸ if (!string.IsNullOrEmpty(sMsg)) | MESSAGE | MessageBox.Show | (sMsg) | 메시지 표시 |  |  |  |
| AC-745b2751 | SaveButton | FP00640_ILT_MODULE.cs:969 | try ▸ if (!string.IsNullOrEmpty(sMsg)) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a783ac0 | SaveButton | FP00640_ILT_MODULE.cs:971 | try ▸ if (!string.IsNullOrEmpty(sMsg)) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-90ca5e31 | SaveButton | FP00640_ILT_MODULE.cs:976 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## FP00640_ILT_MODULE.SearchListInfoAll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63cbe5d3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5233 |  | FLAG | dtDimension | siMain.GetSpdTitle(sProgramID, sUserID, sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-9595ca8e | (진입점 미연결) | FP00640_ILT_MODULE.cs:5233 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc07a580 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5236 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "UOM_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b9d0202f | (진입점 미연결) | FP00640_ILT_MODULE.cs:5237 |  | FLAG | dsUomInfoAll | dtUomAll.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-fe33b123 | (진입점 미연결) | FP00640_ILT_MODULE.cs:5237 |  | DATA_OP | dtUomAll.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP00640_ILT_MODULE.Set_ChargingPlan

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if ((row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_04" \|\| row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_09") // Di…) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (true) ▸ else of (sCateID.Equals("CATEGORY_04")) ▸ if (sCateID.Equals("CATEGORY_09"))] / this.spdMain.Chang…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f24a988e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4440 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | nRoundVal | 그리드 속성/값 설정 |  |  |  |
| AC-acebd031 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4484 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-f5e975d2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4485 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-e7c14895 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4486 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-073bc2f4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4487 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-b7f238c3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4500 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3dd22d67 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4512 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "LIST_DATA") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b8a1db97 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4513 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | FLAG | dsListData | dtList2.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-66d97319 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4513 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | DATA_OP | dtList2.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-37459124 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4524 | if (dsMainFiltered.Good()) ▸ if (measure["chk_estimatedAgingCompleted"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e5752644 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4525 | if (dsMainFiltered.Good()) ▸ if (measure["chk_estimatedAgingCompleted"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f893529 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4526 | if (dsMainFiltered.Good()) ▸ if (measure["chk_estimatedAgingCompleted"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb5d2788 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4527 | if (dsMainFiltered.Good()) ▸ if (measure["chk_estimatedAgingCompleted"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1b07f4c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4528 | if (dsMainFiltered.Good()) ▸ if (measure["chk_estimatedAgingCompleted"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed817264 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4529 | if (dsMainFiltered.Good()) ▸ if (measure["chk_estimatedAgingCompleted"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-01d9e774 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4531 | if (dsMainFiltered.Good()) ▸ if (measure["chk_estimatedAgingCompleted"].Value.Equals("true")) ▸ lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-a4e7e471 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4540 | if (dsMainFiltered.Good()) ▸ if (measure["chk_estimatedAgingCompleted"].Value.Equals("true")) ▸ for (nCol <= nColEnd) | DATA_OP | dr_CMA[sCol] | dr_CMA[sCol].SafeDouble() + gap | 행/컬럼 값 대입 |  |  |  |
| AC-9da75f81 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4552 | if (dsMainFiltered.Good()) ▸ if (measure["chk_agingStock"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d3e3897 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4553 | if (dsMainFiltered.Good()) ▸ if (measure["chk_agingStock"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a057e7f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4554 | if (dsMainFiltered.Good()) ▸ if (measure["chk_agingStock"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-32a6b243 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4555 | if (dsMainFiltered.Good()) ▸ if (measure["chk_agingStock"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3298324c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4556 | if (dsMainFiltered.Good()) ▸ if (measure["chk_agingStock"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0684a2e3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4557 | if (dsMainFiltered.Good()) ▸ if (measure["chk_agingStock"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d42b1239 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4559 | if (dsMainFiltered.Good()) ▸ if (measure["chk_agingStock"].Value.Equals("true")) ▸ lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-20e56fe9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4569 | if (dsMainFiltered.Good()) ▸ if (measure["chk_agingStock"].Value.Equals("true")) ▸ for (nCol <= nColEnd) | DATA_OP | dr_CMA[sCol] | dr_CMA[sCol].SafeDouble() + gap | 행/컬럼 값 대입 |  |  |  |
| AC-b99e38cb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4575 | if (dsMainFiltered.Good()) ▸ if (measure["chk_agingStock"].Value.Equals("true")) ▸ for (nCol <= nColEnd) | DATA_OP | dr_CMA[sCol] | dr_CMA[sCol].SafeDouble() - gap | 행/컬럼 값 대입 |  |  |  |
| AC-fabbe8b3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4586 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-18f333d0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4587 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-46588f33 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4588 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c47fb8d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4589 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1a162ed | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4590 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee89112b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4591 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-158d1087 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4593 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-d68864b5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4601 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ for (nCol <= nColEnd) | DATA_OP | dr_CMA[sCol] | dr_CMA[sCol].SafeDouble() + gap | 행/컬럼 값 대입 |  |  |  |
| AC-a6d2e0f8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4612 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingCharge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c777098 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4613 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingCharge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e89c59f7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4614 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingCharge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-99f65138 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4615 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingCharge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-10a37e08 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4616 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingCharge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-395dd9e7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4617 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingCharge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b26e1b72 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4619 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingCharge"].Value.Equals("true")) ▸ lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-0fd38239 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4627 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingCharge"].Value.Equals("true")) ▸ for (nCol <= nColEnd) | DATA_OP | dr_CMA[sCol] | dr_CMA[sCol].SafeDouble() - gap | 행/컬럼 값 대입 |  |  |  |
| AC-37ec5750 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4648 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0fa9adb5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4649 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ac90cd7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4650 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9396402d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4651 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-13e76e27 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4652 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-61bc970d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4653 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ccc31b1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4655 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-c7c837b4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4662 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc1f9430 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4663 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8ebb613 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4664 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2e9e2dd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4665 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b928519 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4666 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0e5a9b7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4667 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-500c1279 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4669 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-4476bfd1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4676 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a082f190 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4677 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea11349f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4678 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-32452d67 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4679 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c08522e0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4680 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b86b53c5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4681 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c49cf16 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4683 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-ffc38b6b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4690 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a64d587 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4691 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea142d18 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4692 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bcc8e76e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4693 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e6b1106 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4694 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9420eea3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4695 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-77962a21 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4697 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-493f329e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4704 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | CALL_EXT | dateMap.Tables[0].Lookup | ("D_VALUE", sCol, "_DATE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4cceddba | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4747 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | dr_exWare[sCol] | __BEF_EX | 행/컬럼 값 대입 |  |  |  |
| AC-ac6d31dd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4794 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | dr_inHouse[sCol] | __BEF_IN | 행/컬럼 값 대입 |  |  |  |
| AC-33abe3a2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4840 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | dr_exWare[sCol] | __CUR_EX | 행/컬럼 값 대입 |  |  |  |
| AC-d2810e65 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4888 | if (dsMainFiltered.Good()) ▸ if (measure["chk_InHouseInventory"].Value.Equals("true") && measure["chk_exWarehouse"].Value.Equals("true") && … | DATA_OP | dr_inHouse[sCol] | __CUR_IN | 행/컬럼 값 대입 |  |  |  |
| AC-c2bcfdb6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4905 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd8bcb1f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4906 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-578d0c32 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4907 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-55707e24 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4908 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-76cf022e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4909 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3bdce3c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4910 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe6a0cfd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4905 | if (dsMainFiltered.Good()) ▸ lambda | RETURN | return (x.Field<string>("PLANT_ID") == sPlat && x.Field<string>("MODEL_ITEM_ID")… |  | 처리 중단/반환 |  |  |  |
| AC-770c431d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4920 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["QTY"] | Math.Round(Convert.ToDecimal(nOutValue)) | 행/컬럼 값 대입 |  |  |  |
| AC-a052dade | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4929 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bf87f578 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4931 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | Filter2["ILT_INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a2bf95f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4932 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | Filter2["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-86be61b0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4933 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | sComp | 행/컬럼 값 대입 |  |  |  |
| AC-fc8a5a81 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4934 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | sDivi | 행/컬럼 값 대입 |  |  |  |
| AC-08bcbe15 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4935 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-a9a11cb4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4936 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | sPlat | 행/컬럼 값 대입 |  |  |  |
| AC-46ebc473 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4937 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["MODEL_ITEM_ID"] | sModel | 행/컬럼 값 대입 |  |  |  |
| AC-0f2d658a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4938 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["MODULE_ITEM_ID"] | sModul | 행/컬럼 값 대입 |  |  |  |
| AC-3f26ec70 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4939 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["CELL_ITEM_ID"] | sCell | 행/컬럼 값 대입 |  |  |  |
| AC-07b569cf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4940 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["CATEGORY_ID"] | sCate | 행/컬럼 값 대입 |  |  |  |
| AC-95bc745b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4941 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-8e36357d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4942 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PRODUCTION_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-d50c2c64 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4943 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["MARKET"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-14504aba | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4944 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LINE_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-a178a3b9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4945 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-e01f335b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4946 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c6dcd4e8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4947 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["QTY"] | Math.Round(Convert.ToDecimal(nOutValue)) | 행/컬럼 값 대입 |  |  |  |
| AC-2ccac3cb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4950 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e1df143 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4953 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (dsListData == null) | FLAG | dsListData | dtList.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ca8b9289 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4956 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ else of (dsListData == null) | DATA_OP | dsListData.Tables["Table"].ImportRow | (dtList.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |

## FP00640_ILT_MODULE.Set_DischargingPlan

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if ((row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_04" \|\| row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_09") // Di…) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (true) ▸ if (sCateID.Equals("CATEGORY_04"))] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9c545ba | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4240 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | nRoundVal | 그리드 속성/값 설정 |  |  |  |
| AC-bc4350c5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4279 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-1e971dce | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4280 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-77f953e8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4281 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-80faf0da | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4282 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-9e537dc2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4295 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a04371cd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4307 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "LIST_DATA") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4e1f8acb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4308 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | FLAG | dsListData | dtList2.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-d18d4569 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4308 | if (dsMainFiltered.Good()) ▸ if (dsListData == null) | DATA_OP | dtList2.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3c3f0745 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4323 | if (dsMainFiltered.Good()) ▸ if (measure["chk_cmaPkg"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-06cbb6d0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4324 | if (dsMainFiltered.Good()) ▸ if (measure["chk_cmaPkg"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2363434 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4325 | if (dsMainFiltered.Good()) ▸ if (measure["chk_cmaPkg"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9dc43c4f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4326 | if (dsMainFiltered.Good()) ▸ if (measure["chk_cmaPkg"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c5e3564 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4327 | if (dsMainFiltered.Good()) ▸ if (measure["chk_cmaPkg"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb0159de | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4328 | if (dsMainFiltered.Good()) ▸ if (measure["chk_cmaPkg"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-16609afb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4330 | if (dsMainFiltered.Good()) ▸ if (measure["chk_cmaPkg"].Value.Equals("true")) ▸ lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-e944a9a5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4338 | if (dsMainFiltered.Good()) ▸ if (measure["chk_cmaPkg"].Value.Equals("true")) ▸ for (nCol <= nColEnd) | DATA_OP | dr_CMA[sCol] | dr_CMA[sCol].SafeDouble() + gap | 행/컬럼 값 대입 |  |  |  |
| AC-07ec5222 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4349 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2bc814fb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4350 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3168fd3e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4351 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dba8fb39 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4352 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4492e541 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4353 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3751f276 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4354 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fdc4618e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4356 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-5325fd88 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4364 | if (dsMainFiltered.Good()) ▸ if (measure["chk_waitingDischarge"].Value.Equals("true")) ▸ for (nCol <= nColEnd) | DATA_OP | dr_CMA[sCol] | dr_CMA[sCol].SafeDouble() - gap | 행/컬럼 값 대입 |  |  |  |
| AC-f09ec002 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4373 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a8a2999 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4374 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("MODEL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-26c19764 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4375 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("MODULE_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e743a08f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4376 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-22cda0e4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4377 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-750b4464 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4378 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc1e5f2f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4373 | if (dsMainFiltered.Good()) ▸ lambda | RETURN | return (x.Field<string>("PLANT_ID") == sPlat && x.Field<string>("MODEL_ITEM_ID")… |  | 처리 중단/반환 |  |  |  |
| AC-effd4d96 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4388 | if (dsMainFiltered.Good()) ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["QTY"] | Math.Round(Convert.ToDecimal(nOutValue)) | 행/컬럼 값 대입 |  |  |  |
| AC-182eaf1c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4397 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-428c54ab | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4399 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | Filter2["ILT_INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4cd0f16d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4400 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | Filter2["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-979dc69a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4401 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | sComp | 행/컬럼 값 대입 |  |  |  |
| AC-c4392f90 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4402 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | sDivi | 행/컬럼 값 대입 |  |  |  |
| AC-90860cab | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4403 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-b6d76ecc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4404 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | sPlat | 행/컬럼 값 대입 |  |  |  |
| AC-ce3e1654 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4405 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["MODEL_ITEM_ID"] | sModel | 행/컬럼 값 대입 |  |  |  |
| AC-7fdf03b2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4406 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["MODULE_ITEM_ID"] | sModul | 행/컬럼 값 대입 |  |  |  |
| AC-aac8540e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4407 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["CELL_ITEM_ID"] | sCell | 행/컬럼 값 대입 |  |  |  |
| AC-0987d3dc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4408 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["CATEGORY_ID"] | sCate | 행/컬럼 값 대입 |  |  |  |
| AC-b44bf443 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4409 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-9ec31a61 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4410 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PRODUCTION_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-7076c275 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4411 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["MARKET"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-8191ba8b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4412 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LINE_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-1a0b80c0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4413 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-2d93b518 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4414 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7e795a20 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4415 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["QTY"] | Math.Round(Convert.ToDecimal(nOutValue)) | 행/컬럼 값 대입 |  |  |  |
| AC-1751c867 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4418 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtList.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e5bfd09 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4421 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (dsListData == null) | FLAG | dsListData | dtList.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-2eb705bb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 2 | FP00640_ILT_MODULE.cs:4424 | if (dsMainFiltered.Good()) ▸ else of (MatchingEditRowData.Count() > 0) ▸ else of (dsListData == null) | DATA_OP | dsListData.Tables["Table"].ImportRow | (dtList.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |

## FP00640_ILT_MODULE.SetAmendHeaderColumn_FP_Local

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbf51d90 | (진입점 미연결) | FP00640_ILT_MODULE.cs:444 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-42fa11c8 | (진입점 미연결) | FP00640_ILT_MODULE.cs:450 |  | CALL_EXT | siMain.GetSpdTitle | (sProgramID, sUserID, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-65e31607 | (진입점 미연결) | FP00640_ILT_MODULE.cs:453 | if (!dtSheetColumnConfig.Good()) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-095cf75f | (진입점 미연결) | FP00640_ILT_MODULE.cs:454 | if (!dtSheetColumnConfig.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53a536e3 | (진입점 미연결) | FP00640_ILT_MODULE.cs:467 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ecf8819b | (진입점 미연결) | FP00640_ILT_MODULE.cs:468 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) | CALL_EXT | MenuService.SetMenuColumn | (dateRowWeek, new MenuOption { program = sProgramID, sheet = sSheetName, //column_string =… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c98d9ab5 | (진입점 미연결) | FP00640_ILT_MODULE.cs:479 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowWeek) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac3a3391 | (진입점 미연결) | FP00640_ILT_MODULE.cs:480 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (weekOn) | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-1fc27d53 | (진입점 미연결) | FP00640_ILT_MODULE.cs:488 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b51f77a6 | (진입점 미연결) | FP00640_ILT_MODULE.cs:489 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) | CALL_EXT | MenuService.SetMenuColumn | (dateRwoDay, new MenuOption { program = sProgramID, sheet = sSheetName, //column_string = … | ⚠ 의미 확인 필요 |  |  |  |
| AC-96a327f4 | (진입점 미연결) | FP00640_ILT_MODULE.cs:501 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRwoDay) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b9cb1ac | (진입점 미연결) | FP00640_ILT_MODULE.cs:502 | foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ foreach (AmendDate date in week.Dates) ▸ if (dayOn) | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-25b8d2e6 | (진입점 미연결) | FP00640_ILT_MODULE.cs:517 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) | DATA_OP | dtSheetColumnConfig.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-335c75e5 | (진입점 미연결) | FP00640_ILT_MODULE.cs:518 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) | CALL_EXT | MenuService.SetMenuColumn | (dateRowmonth, new MenuOption { program = sProgramID, sheet = sSheetName, //column_string … | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e26ab68 | (진입점 미연결) | FP00640_ILT_MODULE.cs:530 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) | DATA_OP | dtSheetColumnConfig.Rows.Add | (dateRowmonth) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d65d1f9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:531 | foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (monthOn) | FLAG | DayColumnCount | DayColumnCount++ | 화면 필드 증감 |  |  |  |
| AC-95dbebfb | (진입점 미연결) | FP00640_ILT_MODULE.cs:538 | if (dtSheetColumnConfig.Rows.Count == 0) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-96b6c681 | (진입점 미연결) | FP00640_ILT_MODULE.cs:539 | if (dtSheetColumnConfig.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79bb83d6 | (진입점 미연결) | FP00640_ILT_MODULE.cs:542 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, iColumnHeaderRowCount, dtSheetColumnConfig) | 그리드 재구성/초기화 |  |  |  |
| AC-05a51b74 | (진입점 미연결) | FP00640_ILT_MODULE.cs:543 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00640_ILT_MODULE.SetBohTotalQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efa13867 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1620 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-338b50cf | (진입점 미연결) | FP00640_ILT_MODULE.cs:1625 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-9d0da519 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1630 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ffb02c86 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1631 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-427680f1 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1632 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d0cb9d3b | (진입점 미연결) | FP00640_ILT_MODULE.cs:1633 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2954d38 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1634 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ceaa2b05 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1635 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-626edbd9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1636 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0085bb5 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1637 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6908ca38 | (진입점 미연결) | FP00640_ILT_MODULE.cs:1641 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00640_ILT_MODULE.SetCalendarFormat

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbbb51b8 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6774 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ if (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-247e578a | (진입점 미연결) | FP00640_ILT_MODULE.cs:6777 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ else of (omitZ… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-06abe48e | (진입점 미연결) | FP00640_ILT_MODULE.cs:6809 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ if (omitZero… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7de4cd1a | (진입점 미연결) | FP00640_ILT_MODULE.cs:6812 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ else of (omi… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1db28ba0 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6845 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ if (omitZe… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-54b6c114 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6848 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ for (i < 3) ▸ if (colindex > -1) ▸ else of (o… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, _Mask, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP00640_ILT_MODULE.SetCalenderColor

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Goo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0443c6c9 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6637 | if (calendar != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-97b8fbf4 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6641 | if (calendar != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (date.isSatureDay()) ▸ if (i… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-baeb63f8 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6643 | if (calendar != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of (date.isSatureDay()) | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe7221d0 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6647 | if (calendar != null) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of (date.isSatureDay()) ▸ … | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-3a964117 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6671 | if (calendar != null) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (index > -1) | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-a6309373 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6686 | if (calendar != null) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ if (index > -1) | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00640_ILT_MODULE.SetColMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4401c5cb | (진입점 미연결) | FP00640_ILT_MODULE.cs:6542 |  | FLAG | sv | siMain.ActiveSheet | 화면 필드/플래그 변경 |  |  |  |
| AC-089c7c3d | (진입점 미연결) | FP00640_ILT_MODULE.cs:6554 | if (measure["chk_Shift_1"].Value.Equals("true") && measure["chk_Shift_2"].Value.Equals("true")) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-214076a4 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6566 | if (measure["chk_Shift_1"].Value.Equals("true") && measure["chk_Shift_2"].Value.Equals("true")) ▸ for (j < sv.RowCount) ▸ if (sCateVal == "T… | GRID_SET | sv.Cells[j, i].ColumnSpan | 2 | 그리드 속성/값 설정 |  |  |  |
| AC-e7da5af7 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6571 | if (measure["chk_Shift_1"].Value.Equals("true") && measure["chk_Shift_2"].Value.Equals("true")) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00640_ILT_MODULE.SetColumnChangeByText

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee9cd2fd | (진입점 미연결) | FP00640_ILT_MODULE.cs:580 | if (iColMinStartIndex <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6631e51d | (진입점 미연결) | FP00640_ILT_MODULE.cs:585 | try | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-ecee55bc | (진입점 미연결) | FP00640_ILT_MODULE.cs:587 | try | FLAG | DateCellType | new FarPoint.Win.Spread.CellType.DateTimeCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-f4ce8aed | (진입점 미연결) | FP00640_ILT_MODULE.cs:589 | try | FLAG | MaskcellType | new FarPoint.Win.Spread.CellType.MaskCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-116a2e3a | (진입점 미연결) | FP00640_ILT_MODULE.cs:590 | try | UI_PROP | MaskcellType.Mask | "####-##-##" | 속성 Mask 설정 |  |  |  |
| AC-83f40f90 | (진입점 미연결) | FP00640_ILT_MODULE.cs:594 | try | UI_PROP | DateCellType.DateTimeFormat | FarPoint.Win.Spread.CellType.DateTimeFormat.UserDefined | 속성 DateTimeFormat 설정 |  |  |  |
| AC-ce87b237 | (진입점 미연결) | FP00640_ILT_MODULE.cs:595 | try | UI_PROP | DateCellType.UserDefinedFormat | "yyyy-MM-dd" | 속성 UserDefinedFormat 설정 |  |  |  |
| AC-5884a37f | (진입점 미연결) | FP00640_ILT_MODULE.cs:605 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d1f010a | (진입점 미연결) | FP00640_ILT_MODULE.cs:607 | try | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |
| AC-769d00d9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:625 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k,i].CellType | MaskcellType | 그리드 속성/값 설정 |  |  |  |
| AC-5d746d6a | (진입점 미연결) | FP00640_ILT_MODULE.cs:627 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].Value | sData | 그리드 속성/값 설정 |  |  |  |
| AC-3d7da1e4 | (진입점 미연결) | FP00640_ILT_MODULE.cs:631 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-afea3e18 | (진입점 미연결) | FP00640_ILT_MODULE.cs:632 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") && sCategoryDetail.Equals("P_PKGPLANDATE")) ▸ for (i <= iColMax… | GRID_SET | siMain.ActiveSheet.Cells[k, i].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-932593b9 | (진입점 미연결) | FP00640_ILT_MODULE.cs:642 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00640_ILT_MODULE.SetColumnsFormat

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f4c6a94 | (진입점 미연결) | FP00640_ILT_MODULE.cs:6721 | if (siMain != null) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00640_ILT_MODULE.SetDesc2

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try] / this.btnCopyDischarging.Click [try ▸ try] / this.btnUpdateSSP.Click [try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try] / FindButton [try] / SaveButton [try ▸ if (!string.IsNullOrEmpty(sMsg)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f77172c1 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:2517 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "SSP_ASSY_TIME") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b18568f1 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:2521 | if (dtDesc2.Rows.Count > 0) | VALUE_SET | txtDesc2.Text | "SSP : " + dtDesc2.Rows[0]["SSP_TIME"].ToString() + "\r\n" + "Assy : " + dtDesc2.Rows[0]["… | 컨트롤 값 설정 |  |  |  |
| AC-3cdf5a05 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:2526 | else of (dtDesc2.Rows.Count > 0) | VALUE_CLEAR | txtDesc2.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00640_ILT_MODULE.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7c0300f | this.Load | FP00640_ILT_MODULE.cs:280 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-67063fdd | this.Load | FP00640_ILT_MODULE.cs:282 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-e0e5f55f | this.Load | FP00640_ILT_MODULE.cs:286 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-166174bb | this.Load | FP00640_ILT_MODULE.cs:288 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-4704c246 | this.Load | FP00640_ILT_MODULE.cs:289 |  | CALL_EXT | UserService.HasSuperRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f2443c52 | this.Load | FP00640_ILT_MODULE.cs:291 | if (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-6204ca82 | this.Load | FP00640_ILT_MODULE.cs:295 | else of (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00640_ILT_MODULE.SetDirty

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if ((row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_04" \|\| row_to_test["CATEGORY_ID"].ToString() == "CATEGORY_09") // Di…) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally] / this.spdMain.ClipboardPasting…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30fb9ab4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 11 | FP00640_ILT_MODULE.cs:4204 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00640_ILT_MODULE.SetDivision

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7429276d | this.Load [try] 외 1 | FP00640_ILT_MODULE.cs:4033 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-987f774c | this.Load [try] 외 1 | FP00640_ILT_MODULE.cs:4033 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-db247227 | this.Load [try] 외 1 | FP00640_ILT_MODULE.cs:4034 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00640_ILT_MODULE.SetDsinDataByControl

진입점: this.btnCreatePlan.Click [try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60d42819 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:2993 |  | FLAG | dtLookupByInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_lookupByInstance", _s… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-5ef497ad | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:2993 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_lookupByInstance", _sPlanGroup, _sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d8b15671 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:2994 |  | FLAG | dtfixDateInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00590_find_fixDateInfo", _sPlanG… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3a253680 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:2994 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_fixDateInfo", _sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ea21666 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:2996 |  | UI_PROP | DsinData.PLAN_HORIZON | dtLookupByInstance.Rows[0]["PLAN_HORIZON"].ToString() | 속성 PLAN_HORIZON 설정 |  |  |  |
| AC-8454fe41 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:2997 |  | UI_PROP | DsinData.DEMAND_HORIZON | dtLookupByInstance.Rows[0]["DEMAND_HORIZON"].ToString() | 속성 DEMAND_HORIZON 설정 |  |  |  |
| AC-d5e31822 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3000 |  | UI_PROP | DsinData.ALLOWFIXDATENULL | dtfixDateInfo.Rows[0]["ALLOWED_FIX_DATE_NULL"].ToString() | 속성 ALLOWFIXDATENULL 설정 |  |  |  |
| AC-55ad9ca0 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3002 |  | UI_PROP | DsinData.SITE_ID | dtSite.Rows[0]["CODE"].ToString() | 속성 SITE_ID 설정 |  |  |  |
| AC-99701dc5 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3003 |  | UI_PROP | DsinData.INSTANCE_ID | _sPlanGroup | 속성 INSTANCE_ID 설정 |  |  |  |
| AC-5c53ef35 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3004 |  | UI_PROP | DsinData.PLAN_DATE | _sPlanDate | 속성 PLAN_DATE 설정 |  |  |  |
| AC-241113ea | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3005 |  | UI_PROP | DsinData.PLAN_END_TIME | drpPeriod.Text2.Replace("-", "").Replace("/", "").Replace(".", "") | 속성 PLAN_END_TIME 설정 |  |  |  |
| AC-04b0144f | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3006 |  | UI_PROP | DsinData.DESCRIPTION | "" | 속성 DESCRIPTION 설정 |  |  |  |
| AC-0a5e2e3c | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3008 |  | UI_PROP | DsinData.PLAN_TYPE | "PRE" | 속성 PLAN_TYPE 설정 |  |  |  |
| AC-210f5a4f | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3009 |  | UI_PROP | DsinData.SYNC_OPERATION_ID | "" | 속성 SYNC_OPERATION_ID 설정 |  |  |  |
| AC-8448b514 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3010 |  | UI_PROP | DsinData.PRE_FIX_TARGET_ID | "" | 속성 PRE_FIX_TARGET_ID 설정 |  |  |  |
| AC-dee46d50 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3012 |  | UI_PROP | DsinData.PRE_FIX_FLAG | "N" | 속성 PRE_FIX_FLAG 설정 |  |  |  |
| AC-e3e10e16 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3013 |  | UI_PROP | DsinData.PRE_FIX_TYPE | "QTY_FIX" | 속성 PRE_FIX_TYPE 설정 |  |  |  |
| AC-4a25683f | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3014 |  | UI_PROP | DsinData.PRE_FIX_2_FLAG | "N" | 속성 PRE_FIX_2_FLAG 설정 |  |  |  |
| AC-5bbe34ce | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3015 |  | UI_PROP | DsinData.PRE_FIX_TYPE2 | "" | 속성 PRE_FIX_TYPE2 설정 |  |  |  |
| AC-be40cce2 | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3016 |  | UI_PROP | DsinData.PRE_FIX_DATE | "" | 속성 PRE_FIX_DATE 설정 |  |  |  |
| AC-d28735bb | this.btnCreatePlan.Click [try ▸ try] | FP00640_ILT_MODULE.cs:3017 |  | UI_PROP | DsinData.PRE_FIX_DATE2 | "" | 속성 PRE_FIX_DATE2 설정 |  |  |  |

## FP00640_ILT_MODULE.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (dtInstance.Good())] / drpPlanDate.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / cbo_fpplanid.SelectedIndexChanged [if (cbo_fpplanid.Items.Count > 0)] / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / txtModel.TextChanged / txtModule.TextChanged / txtCell.TextChanged / txtNickName.TextChanged / drpPeriod.ValueChanged / popSql.OnSql [if (programID == "PR_UI_FP00640_EXCEL_SELECT_COLTYPE") ▸ lambda ▸ if (GetFilter("INSTANCE_ID") == "") ▸ lambda]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b89a22a | this.Load [try] 외 22 | FP00640_ILT_MODULE.cs:4006 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00640_ILT_MODULE.SetFpPlanId

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / drpPlanDate.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.chk_confirmPlan.CheckedChanged [if (chk_confirmPlan.Checked) ▸ if (dtRef.Rows.Count > 0)] / this.cbo_fpplanid.DropDown / this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6889494 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4090 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELE… | 화면 필드/플래그 변경 |  |  |  |
| AC-56ee16a9 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4090 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "FP_PLAN_ID") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-296ce34c | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4092 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f8f822a2 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4096 | if (_planString != "") | VALUE_SET | cbo_fpplanid.SelectedValue | _planString | 컨트롤 값 설정 |  |  |  |
| AC-ac1b35d3 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4097 | if (_planString != "") | FLAG | _planString | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4d6392fc | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4102 | else of (_planString != "") ▸ if (dtPlanId.Rows.Count > 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-c82864c9 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4104 | else of (_planString != "") ▸ else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | cbo_fpplanid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-1af7f85b | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4137 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[0]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-f89e2b5f | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4138 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[0]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-1ee84b3d | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4139 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[0]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-1491f8cc | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4140 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[0]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-2d08d7b7 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4141 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[0]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-36157935 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4143 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-aed70907 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4144 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-7d29f85c | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4145 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-207f5cf2 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4146 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-4ebdd0f1 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4161 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-4d407a52 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4162 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-904343e2 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4163 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-ec4a3365 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4164 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-fc5e80c8 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4165 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-3e730403 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4167 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-91ad05ee | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4168 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-9a4bb5a2 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4169 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-e85f4ec8 | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4170 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-4ad8c6eb | this.Load [try] 외 5 | FP00640_ILT_MODULE.cs:4174 |  | STATE | cbo_fpplanid.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00640_ILT_MODULE.SetPlanDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbc2281b | this.Load [try] | FP00640_ILT_MODULE.cs:4022 | if (!string.IsNullOrEmpty(inst)) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", inst) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8415fc94 | this.Load [try] | FP00640_ILT_MODULE.cs:4027 |  | VALUE_SET | drpPlanDate.DateTime | dt | 컨트롤 값 설정 |  |  |  |

## FP00640_ILT_MODULE.SetPlanGroup

진입점: this.Load [try] / SaveButton [try ▸ if (dsListData != null) ▸ try ▸ if (dsListData.Tables[0].Rows.Count > 0) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-617c6182 | this.Load [try] 외 1 | FP00640_ILT_MODULE.cs:4058 |  | FLAG | dtInstance | Data_FP.CallGeneralProcedure2(("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELE… | 화면 필드/플래그 변경 |  |  |  |
| AC-c37f948a | this.Load [try] 외 1 | FP00640_ILT_MODULE.cs:4058 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "INSTANCE_ID") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3b8ca2c1 | this.Load [try] 외 1 | FP00640_ILT_MODULE.cs:4060 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00640_ILT_MODULE.SetPlanPeriod

진입점: this.Load [try] / drpPlanDate.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.chk_confirmPlan.CheckedChanged [if (chk_confirmPlan.Checked) ▸ if (dtRef.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dafe6775 | this.Load [try] 외 2 | FP00640_ILT_MODULE.cs:4183 |  | FLAG | dDefaultDatePeriod | Data_FP.CallGeneralProcedure2(("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELE… | 화면 필드/플래그 변경 |  |  |  |
| AC-929ad529 | this.Load [try] 외 2 | FP00640_ILT_MODULE.cs:4183 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00640_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "PLAN_PERIOD") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-14a2e739 | this.Load [try] 외 2 | FP00640_ILT_MODULE.cs:4188 |  | FLAG | dDefalultStartDate | DateTime.ParseExact(dDefaultDatePeriod.Rows[0]["START_DATE"].ToString(), "yyyyMMdd", Cultu… | 화면 필드/플래그 변경 |  |  |  |
| AC-559061dc | this.Load [try] 외 2 | FP00640_ILT_MODULE.cs:4189 |  | FLAG | dDefalultEndDate | DateTime.ParseExact(dDefaultDatePeriod.Rows[0]["END_DATE"].ToString(), "yyyyMMdd", Culture… | 화면 필드/플래그 변경 |  |  |  |
| AC-0079f4f7 | this.Load [try] 외 2 | FP00640_ILT_MODULE.cs:4191 |  | UI_PROP | drpPeriod.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-d0748b0e | this.Load [try] 외 2 | FP00640_ILT_MODULE.cs:4192 |  | UI_PROP | drpPeriod.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-7803e986 | this.Load [try] 외 2 | FP00640_ILT_MODULE.cs:4194 |  | DATA_OP | Filter["BUCKET_FROM"] | dDefaultDatePeriod.Rows[0]["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-222c0563 | this.Load [try] 외 2 | FP00640_ILT_MODULE.cs:4195 |  | DATA_OP | Filter["BUCKET_TO"] | dDefaultDatePeriod.Rows[0]["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00640_ILT_MODULE.SetPlant

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1860c13c | this.Load [try] 외 3 | FP00640_ILT_MODULE.cs:4048 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-b932a5da | this.Load [try] 외 3 | FP00640_ILT_MODULE.cs:4048 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3c03ae46 | this.Load [try] 외 3 | FP00640_ILT_MODULE.cs:4050 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00640_ILT_MODULE.SetSite

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19bc2f62 | this.Load [try] 외 1 | FP00640_ILT_MODULE.cs:4041 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-8866346f | this.Load [try] 외 1 | FP00640_ILT_MODULE.cs:4041 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e1bbb12d | this.Load [try] 외 1 | FP00640_ILT_MODULE.cs:4042 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00640_ILT_MODULE.SetSpreadInit

진입점: this.Load [try] / this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c5b28ac | this.Load [try] 외 8 | FP00640_ILT_MODULE.cs:438 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5bb8f4ec | this.Load [try] 외 8 | FP00640_ILT_MODULE.cs:439 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00640_ILT_MODULE.SetTotalColor

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnCopyDischarging.Click [try ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnUpdateSSP.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Goo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e22c8077 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 7 | FP00640_ILT_MODULE.cs:6616 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00640_ILT_MODULE.SheetChanged

진입점: dsdmAmend.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-568f21ea | dsdmAmend.Changed | FP00640_ILT_MODULE.cs:3553 | if (!this.CanModelChange \|\| e.Row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_ILT_MODULE.spdMain_CellClick2

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbd135ba | spdMain.CellClick | FP00640_ILT_MODULE.cs:6974 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-211816ad | spdMain.CellClick | FP00640_ILT_MODULE.cs:6975 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-78f3efbe | spdMain.CellClick | FP00640_ILT_MODULE.cs:6977 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-941c8343 | spdMain.CellClick | FP00640_ILT_MODULE.cs:7035 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00640_ILT_MODULE.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3432c720 | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3559 | if (e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da54d624 | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3561 | if (e.Column > measure.ServerColumns.Rows.Count) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9dda8c4 | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3574 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | DATA_OP | inputFilter["PLAN_DATE"] | Filter2["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7b873efd | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3575 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | DATA_OP | inputFilter["DIVISION_ID"] | clicked_row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0e1b3ff7 | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3576 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | DATA_OP | inputFilter["SITE_ID"] | clicked_row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-81807e4e | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3577 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | DATA_OP | inputFilter["PLANT_ID"] | clicked_row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bfc31135 | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3578 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | DATA_OP | inputFilter["MODEL_ID"] | clicked_row["MODEL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dbd2ef8a | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3579 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | DATA_OP | inputFilter["MODULE_ID"] | clicked_row["MODULE_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b00f8043 | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3580 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | DATA_OP | inputFilter["CELL_ID"] | clicked_row["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d746a34f | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3581 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | DATA_OP | inputFilter["CATEGORY_ID"] | clicked_row["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29ecc1c7 | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3582 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | DATA_OP | inputFilter["ILT_INSTANCE_ID"] | Filter2["ILT_INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-958d1620 | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3585 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | POPUP | new FP00640_InvDetail_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-897543a3 | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3586 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | UI_PROP | popup.Filter | inputFilter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-da87e53f | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3586 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | DATA_OP | inputFilter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6878a584 | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3587 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-fa16be3b | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3588 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-60c64c25 | this.spdMain.CellDoubleClick | FP00640_ILT_MODULE.cs:3589 | if (cateTmp == "CATEGORY_12" \|\| cateTmp == "CATEGORY_08" \|\| cateTmp == "CATEGORY_07" \|\| cateTmp == "CATEGORY_06" \|\| cateTmp …) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00640_ILT_MODULE.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e29d2822 | this.spdMain.ClipboardPasted | FP00640_ILT_MODULE.cs:3609 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18fbff89 | this.spdMain.ClipboardPasted | FP00640_ILT_MODULE.cs:3617 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c5f6a518 | this.spdMain.ClipboardPasted | FP00640_ILT_MODULE.cs:3618 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-09cdb54d | this.spdMain.ClipboardPasted | FP00640_ILT_MODULE.cs:3620 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00640_ILT_MODULE.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe6d3977 | this.spdMain.ClipboardPasting | FP00640_ILT_MODULE.cs:3627 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-8be53b44 | this.spdMain.ClipboardPasting | FP00640_ILT_MODULE.cs:3628 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-5b6d90cd | this.spdMain.ClipboardPasting | FP00640_ILT_MODULE.cs:3628 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-33ef83c7 | this.spdMain.ClipboardPasting | FP00640_ILT_MODULE.cs:3632 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-8b647dc6 | this.spdMain.ClipboardPasting | FP00640_ILT_MODULE.cs:3632 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8d8d1bc | this.spdMain.ClipboardPasting | FP00640_ILT_MODULE.cs:3636 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d26a5319 | this.spdMain.ClipboardPasting | FP00640_ILT_MODULE.cs:3638 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00640_ILT_MODULE.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9176f4b | this.spdMain.EditModeOn | FP00640_ILT_MODULE.cs:3400 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00640_ILT_MODULE.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39e696e3 | this.spdMain.KeyDown | FP00640_ILT_MODULE.cs:3338 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-25cd10be | this.spdMain.KeyDown | FP00640_ILT_MODULE.cs:3342 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1df2965 | this.spdMain.KeyDown | FP00640_ILT_MODULE.cs:3343 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00640_ILT_MODULE.UIFindData

진입점: this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try] / this.btnCopyDischarging.Click [try] / this.btnUpdateSSP.Click / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton / SaveButton [try ▸ if (!string.IsNullOrEmpty(sMsg))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86ef79ba | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:661 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1ae2b590 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:662 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a2499bca | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:665 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-faf38deb | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:668 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-6597f3c6 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:673 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan ID to proceed") | 메시지 표시 |  |  |  |
| AC-89f64282 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:674 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50d577e0 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:682 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | Filter2 | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-9f50c021 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:682 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2bc58908 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:696 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7742e559 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:697 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f5e08c9 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:700 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2a2bec59 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:703 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2e3a659c | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:704 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5bb0df72 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:707 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-43dd5d82 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:716 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a510fdea | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:718 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-1a6bd481 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:718 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-12283730 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:733 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1089c4f7 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:740 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-4d5cf715 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:746 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-a4b8ae1c | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:747 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-eb30c8a6 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:754 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-7b7abe82 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:756 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-fe3d9f41 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:760 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff834a13 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:773 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-65f0c28c | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:782 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7e8181d5 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:783 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-14b725e9 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:787 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dea11326 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:799 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-86e9b270 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:801 | try ▸ if (floModel != null) | UI_MISC | floModel.Hide | () | 창 닫기/해제 |  |  |  |
| AC-ff3a1651 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:807 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-bd5448c5 | this.btnCreatePlan.Click [try ▸ if (ds.Rows.Count > 0) ▸ try… 외 6 | FP00640_ILT_MODULE.cs:811 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00640_InvDetail_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95e25e4f | (진입점 미연결) | FP00640_InvDetail_Popup.cs:333 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-9cba9b54 | (진입점 미연결) | FP00640_InvDetail_Popup.cs:336 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8b5a077d | (진입점 미연결) | FP00640_InvDetail_Popup.cs:337 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00640_InvDetail_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dd7b3ea | this.Load | FP00640_InvDetail_Popup.cs:143 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bc4a9705 | this.Load | FP00640_InvDetail_Popup.cs:144 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e85772af | this.Load | FP00640_InvDetail_Popup.cs:145 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00640_InvDetail_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7829d54 | this.Load | FP00640_InvDetail_Popup.cs:138 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00640_InvDetail_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35e001cd | Dispose | FP00640_InvDetail_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00640_InvDetail_Popup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4df6f6e | ExcelButton | FP00640_InvDetail_Popup.cs:207 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00640_InvDetail_Popup.Find_Data_Line

진입점: this.Load [try ▸ lambda] / FindButton [try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f874c06 | this.Load [try ▸ lambda] 외 2 | FP00640_InvDetail_Popup.cs:266 | try | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP00640_ETC").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "INV_D… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f88930ab | this.Load [try ▸ lambda] 외 2 | FP00640_InvDetail_Popup.cs:298 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-e3513d60 | this.Load [try ▸ lambda] 외 2 | FP00640_InvDetail_Popup.cs:302 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00640_InvDetail_Popup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-512ba878 | this.Load 외 2 | FP00640_InvDetail_Popup.cs:222 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-11a6a224 | this.Load 외 2 | FP00640_InvDetail_Popup.cs:228 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e5f3dff4 | this.Load 외 2 | FP00640_InvDetail_Popup.cs:235 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-57eddcfa | this.Load 외 2 | FP00640_InvDetail_Popup.cs:238 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3ff51b08 | this.Load 외 2 | FP00640_InvDetail_Popup.cs:242 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-5a74e346 | this.Load 외 2 | FP00640_InvDetail_Popup.cs:250 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-dc6dcfb8 | this.Load 외 2 | FP00640_InvDetail_Popup.cs:256 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00640_InvDetail_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b93e2afc | this.Load | FP00640_InvDetail_Popup.cs:115 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3e5c3979 | this.Load | FP00640_InvDetail_Popup.cs:117 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00640_InvDetail_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1008de14 | this.Load | FP00640_InvDetail_Popup.cs:155 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf8a4d0b | this.Load | FP00640_InvDetail_Popup.cs:156 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00640_InvDetail_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-368027e3 | (진입점 미연결) | FP00640_InvDetail_Popup.cs:177 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00640_InvDetail_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5af41edf | this.Load | FP00640_InvDetail_Popup.cs:162 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74fac4a5 | this.Load | FP00640_InvDetail_Popup.cs:163 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-1c408b78 | this.Load | FP00640_InvDetail_Popup.cs:167 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00640_InvDetail_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-697a2988 | this.spdMain.CellClick | FP00640_InvDetail_Popup.cs:348 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b3ecc542 | this.spdMain.CellClick | FP00640_InvDetail_Popup.cs:349 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0b512c00 | this.spdMain.CellClick | FP00640_InvDetail_Popup.cs:352 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00640_InvDetail_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-996f2260 | this.spdMain.CellDoubleClick | FP00640_InvDetail_Popup.cs:358 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b75686bb | this.spdMain.CellDoubleClick | FP00640_InvDetail_Popup.cs:359 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a8751e2d | this.spdMain.CellDoubleClick | FP00640_InvDetail_Popup.cs:362 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-9bb3c301 | this.spdMain.CellDoubleClick | FP00640_InvDetail_Popup.cs:365 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_InvDetail_Popup.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c3a7cee | this.spdMain.EditChange | FP00640_InvDetail_Popup.cs:492 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00640_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21a3226a | .ctor | FP00640_MeasureSetForm_Popup.cs:103 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-8ea1b323 | .ctor | FP00640_MeasureSetForm_Popup.cs:104 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-aa92c59c | .ctor | FP00640_MeasureSetForm_Popup.cs:105 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-2f542701 | .ctor | FP00640_MeasureSetForm_Popup.cs:107 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00640_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c82c238 | this.btnOK.Click | FP00640_MeasureSetForm_Popup.cs:310 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-92c36b78 | this.btnOK.Click | FP00640_MeasureSetForm_Popup.cs:311 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-1abbf138 | this.btnOK.Click | FP00640_MeasureSetForm_Popup.cs:318 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-13393f52 | this.btnOK.Click | FP00640_MeasureSetForm_Popup.cs:319 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00640_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4768f15 | this.btnSet.Click | FP00640_MeasureSetForm_Popup.cs:282 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-23e1220a | this.btnSet.Click | FP00640_MeasureSetForm_Popup.cs:283 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-cd290a42 | this.btnSet.Click | FP00640_MeasureSetForm_Popup.cs:285 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c71553c5 | this.btnSet.Click | FP00640_MeasureSetForm_Popup.cs:286 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bfd664e6 | this.btnSet.Click | FP00640_MeasureSetForm_Popup.cs:288 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-f80727b8 | this.btnSet.Click | FP00640_MeasureSetForm_Popup.cs:289 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-497f95d0 | this.btnSet.Click | FP00640_MeasureSetForm_Popup.cs:290 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00640_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a4da559 | Dispose | FP00640_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00640_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6edd2f33 | this.Load | FP00640_MeasureSetForm_Popup.cs:130 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00640_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3db36172 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:183 |  | FLAG | dtCategory | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "select_measure", "FP00640_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-52455cf6 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:183 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00640_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5c7c285b | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:185 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-e20de5f2 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:186 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-5b10a4bf | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:192 |  | DATA_OP | ctrls.Add | (chk_ssp) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bddd598 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:193 |  | DATA_OP | ctrls.Add | (chk_cmaPkg) | 데이터 객체 조작/조회 |  |  |  |
| AC-31ca8953 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:194 |  | DATA_OP | ctrls.Add | (chk_dischargedCma) | 데이터 객체 조작/조회 |  |  |  |
| AC-16915786 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:195 |  | DATA_OP | ctrls.Add | (chk_dischargingPlan) | 데이터 객체 조작/조회 |  |  |  |
| AC-59c7ea03 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:196 |  | DATA_OP | ctrls.Add | (chk_dischargingResult) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe0924db | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:197 |  | DATA_OP | ctrls.Add | (chk_waitingDischarge) | 데이터 객체 조작/조회 |  |  |  |
| AC-f85b65c5 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:198 |  | DATA_OP | ctrls.Add | (chk_estimatedAgingCompleted) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b8c26c8 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:199 |  | DATA_OP | ctrls.Add | (chk_agingStock) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d3a325e | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:200 |  | DATA_OP | ctrls.Add | (chk_chargingPlan) | 데이터 객체 조작/조회 |  |  |  |
| AC-291ba66a | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:201 |  | DATA_OP | ctrls.Add | (chk_chargingResult) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7928724 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:202 |  | DATA_OP | ctrls.Add | (chk_waitingCharge) | 데이터 객체 조작/조회 |  |  |  |
| AC-165540e7 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:203 |  | DATA_OP | ctrls.Add | (chk_InHouseInventory) | 데이터 객체 조작/조회 |  |  |  |
| AC-03a35848 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:204 |  | DATA_OP | ctrls.Add | (chk_exWarehouse) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed0df90e | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:205 |  | DATA_OP | ctrls.Add | (chk_cmaAssyPlan) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d6d29af | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:206 |  | DATA_OP | ctrls.Add | (chk_sspResult) | 데이터 객체 조작/조회 |  |  |  |
| AC-366c846a | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:209 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-a83d3bdf | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:210 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-013ccfe2 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:214 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-191c5a61 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:214 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-7974779b | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:222 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-dbe503af | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:226 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-5770f6ae | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:230 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00640_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac443034 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_ssp.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8f687bb9 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_cmaPkg.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-10bd3cbf | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_dischargedCma.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6ff97f19 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_dischargingPlan.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c132fe60 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_dischargingResult.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c5af6494 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_waitingDischarge.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-253ac6a5 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_estimatedAgingCompleted.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8934cb73 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_agingStock.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f81d78b0 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_chargingPlan.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-15660932 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_chargingResult.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8f9083cb | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_waitingCharge.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-40772014 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_InHouseInventory.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e3cb5b4e | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_exWarehouse.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6794afeb | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_cmaAssyPlan.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-730cc598 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_sspResult.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-63833526 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6014fcf7 | this.Load 외 1 | FP00640_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00640_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82168a30 | (진입점 미연결) | FP00640_MeasureSetForm_Popup.cs:372 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-f217ba75 | (진입점 미연결) | FP00640_MeasureSetForm_Popup.cs:383 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44964cf0 | (진입점 미연결) | FP00640_MeasureSetForm_Popup.cs:394 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00640_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f22aa47 | this.Load | FP00640_MeasureSetForm_Popup.cs:117 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e03a6055 | this.Load | FP00640_MeasureSetForm_Popup.cs:125 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00640_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13e35ef9 | this.btnSet.Click 외 1 | FP00640_MeasureSetForm_Popup.cs:329 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f033c028 | this.btnSet.Click 외 1 | FP00640_MeasureSetForm_Popup.cs:337 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-a5e6f112 | this.btnSet.Click 외 1 | FP00640_MeasureSetForm_Popup.cs:337 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-a1ec217c | this.btnSet.Click 외 1 | FP00640_MeasureSetForm_Popup.cs:354 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cb848e19 | this.btnSet.Click 외 1 | FP00640_MeasureSetForm_Popup.cs:365 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00640_planOptionSelect_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea3ca128 | .ctor | FP00640_planOptionSelect_Popup.cs:62 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-fab39f10 | .ctor | FP00640_planOptionSelect_Popup.cs:63 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-0f76691d | .ctor | FP00640_planOptionSelect_Popup.cs:64 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-df73a517 | .ctor | FP00640_planOptionSelect_Popup.cs:66 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00640_planOptionSelect_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c06f1d4a | Dispose | FP00640_planOptionSelect_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00640_planOptionSelect_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c90ebf8 | this.Load | FP00640_planOptionSelect_Popup.cs:93 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00640_planOptionSelect_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaa0bca9 | this.Load | FP00640_planOptionSelect_Popup.cs:77 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-584f1317 | this.Load | FP00640_planOptionSelect_Popup.cs:85 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-c4b38aed | this.Load | FP00640_planOptionSelect_Popup.cs:88 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## FP00640_planOptionSelect_Popup.rbOpt1_Click

진입점: rbOpt1.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e4f66f2 | rbOpt1.CheckedChanged | FP00640_planOptionSelect_Popup.cs:122 | if (loaded) | FLAG | Selection | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-a3076f5c | rbOpt1.CheckedChanged | FP00640_planOptionSelect_Popup.cs:123 | if (loaded) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-dd0b5adc | rbOpt1.CheckedChanged | FP00640_planOptionSelect_Popup.cs:124 | if (loaded) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-08ec5ba6 | rbOpt1.CheckedChanged | FP00640_planOptionSelect_Popup.cs:126 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## FP00640_planOptionSelect_Popup.rbOpt2_Click

진입점: rbOpt2.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-364fbd07 | rbOpt2.CheckedChanged | FP00640_planOptionSelect_Popup.cs:133 | if (loaded) | FLAG | Selection | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-a9f966e3 | rbOpt2.CheckedChanged | FP00640_planOptionSelect_Popup.cs:134 | if (loaded) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-ba58ba62 | rbOpt2.CheckedChanged | FP00640_planOptionSelect_Popup.cs:135 | if (loaded) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00640_planOptionSelect_Popup.SetOption

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a63d9467 | (진입점 미연결) | FP00640_planOptionSelect_Popup.cs:100 | if (index == 0) | VALUE_SET | rbOpt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-3009dd18 | (진입점 미연결) | FP00640_planOptionSelect_Popup.cs:102 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rbOpt2.Text | option_name | 컨트롤 값 설정 |  |  |  |

