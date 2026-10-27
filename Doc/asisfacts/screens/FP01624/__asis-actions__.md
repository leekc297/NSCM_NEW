# AS-IS 액션 대조표 — FP01624

> 원천: `Doc/asisfacts/screens/FP01624/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2269행 · 메서드 233 · 종류 DATA_OP 837 · FLAG 248 · STATE 233 · UI_PROP 186 · RETURN 127 · CALL_EXT 92 · ENDPOINT 77 · POPUP 72 · VALUE_SET 57 · MESSAGE 52 · GRID_INIT 51 · UI_MISC 50 · GRID_SET 48 · CALL_BASE 31 · VALUE_CLEAR 24 · LIST_REBIND 21 · COMBO_DATA 15 · THROW 14 · GRID_LOCK 9 · FOCUS 8 · GRID_BIND 7 · EXCEL 5 · LIST_BIND 3 · STATE_RESET 2 · ⚠ 의미 확인 필요 123


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25543b23 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4191 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-d22eddb7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4197 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-517b6740 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4205 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-04e683f2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4206 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-3c6b9c2d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4207 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-0beea985 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4208 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-3652463d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4209 |  | UI_PROP | dlLine._M_OUT_CELL | line_savings.M_OUT_CELL | 속성 _M_OUT_CELL 설정 |  |  |  |
| AC-9e497e58 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4210 |  | UI_PROP | dlLine._W_OUT_CELL | line_savings.W_OUT_CELL | 속성 _W_OUT_CELL 설정 |  |  |  |
| AC-865a78b8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4212 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbe67483 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4213 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-217c9b75 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4214 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae4764ab | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4215 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-ea02675d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4216 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b45f069d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4217 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-9bbf6261 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4218 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab717157 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4219 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-d94abf2f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4222 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-fdef3e3e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4440 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-693d5682 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4441 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-e8436c39 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4442 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-628e050e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4443 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-ef53024d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4444 |  | UI_PROP | dlLine._M_OUT_CELL | line_savings.M_OUT_CELL | 속성 _M_OUT_CELL 설정 |  |  |  |
| AC-a87367a1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4445 |  | UI_PROP | dlLine._W_OUT_CELL | line_savings.W_OUT_CELL | 속성 _W_OUT_CELL 설정 |  |  |  |
| AC-cdf27bf0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4446 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-c4b9049a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4447 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-993de80b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4448 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b221fff | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4449 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-5dfb1d90 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4450 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-55f392bc | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4451 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-6eb4b33b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4452 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-103c7194 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4453 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-086cfdb4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4455 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.DO_INC_P_RESULT_CELL

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d23304e3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4550 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## DataLines.Do_SET_P_OUT_CELL

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9732205b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4554 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-578639cb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4337 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a0bc48e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4338 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-be347606 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4339 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-508c5d0b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4340 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3eca12f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4341 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-580793fb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4342 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a951533 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4343 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd8ab427 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4344 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b746da7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4345 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-df469882 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4346 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-61d8f239 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4347 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8ad4436 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4348 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-20ce35db | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4349 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-66c228ab | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4335 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-28862496 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4367 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": ▸ if (cell_uom == "CELL") | UI_PROP | loc.M_OUT_CELL | row_index | 속성 M_OUT_CELL 설정 |  |  |  |
| AC-2840f84c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4369 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": ▸ else of (cell_uom == "CELL"… | UI_PROP | loc.M_OUT | row_index | 속성 M_OUT 설정 |  |  |  |
| AC-3b466ff8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4373 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": ▸ if (cell_uom == "CELL") | UI_PROP | loc.W_OUT_CELL | row_index | 속성 W_OUT_CELL 설정 |  |  |  |
| AC-cc7a6c9c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4375 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": ▸ else of (cell_uom == "CELL"… | UI_PROP | loc.W_OUT | row_index | 속성 W_OUT 설정 |  |  |  |
| AC-af32b213 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4382 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": ▸ if (cell_uom == "CELL") | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-868a5918 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4384 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": ▸ else of (cell_uom == "CELL") | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f43c5e4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4391 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": ▸ if (cell_uom == "CELL") | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3da7c4f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4393 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": ▸ else of (cell_uom == "CELL"… | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-35a7dbc4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4397 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": ▸ if (cell_uom == "CELL") | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-a2a0c49a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4399 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": ▸ else of (cell_uom == "CELL") | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-5830ec28 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4408 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-25b0fcbe | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4410 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33e33178 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4309 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-935299af | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4262 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca67a7bf | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4263 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f309d996 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4264 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9af54f42 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4265 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6e193a7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4266 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8918051b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4267 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ddf67a9f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4268 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-f79a2a90 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4269 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-63753108 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4270 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0483b4c0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4271 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b7b0c4ca | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4272 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-4959e991 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4273 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef721e58 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4274 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4bc0df1d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4275 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b099b8aa | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4260 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-b128eaee | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4288 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (uom == "CELL") | DATA_OP | dict.ContainsKey | (category_id + "_" + uom) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a925e10 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4289 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (uom == "CELL") ▸ if (!dict.ContainsKey(category_id + "_" + u… | DATA_OP | dict.Add | (category_id + "_" + uom, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-d53a1f7b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4293 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ else of (uom == "CELL") | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-f04ec9cf | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4294 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ else of (uom == "CELL") ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c3de326 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4300 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6e8716f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4235 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP01624_Apply_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d181a7a | .ctor | FP01624_Apply_Popup.cs:156 |  | FLAG | filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-dde9f6e6 | .ctor | FP01624_Apply_Popup.cs:157 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP01624_Apply_Popup.ApplyAmendCalendarCondition

진입점: this.btnFind.Click / this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-247e91de | this.btnFind.Click 외 3 | FP01624_Apply_Popup.cs:281 |  | FLAG | Calendar | AmendService.ApplyAmendCalendarCondition(Filter, dtDimensionInfo, null) | 화면 필드/플래그 변경 |  |  |  |
| AC-6096f213 | this.btnFind.Click 외 3 | FP01624_Apply_Popup.cs:281 |  | CALL_EXT | AmendService.ApplyAmendCalendarCondition | (Filter, dtDimensionInfo, null) | ⚠ 의미 확인 필요 |  |  |  |

## FP01624_Apply_Popup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-430093cf | this.btnClose.Click | FP01624_Apply_Popup.cs:615 |  | UI_PROP | this.DialogResult | DialogResult.Cancel | 속성 DialogResult 설정 |  |  |  |
| AC-7852cae2 | this.btnClose.Click | FP01624_Apply_Popup.cs:616 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_Apply_Popup.btnConfirm_Click

진입점: this.btnConfirm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e460028 | this.btnConfirm.Click | FP01624_Apply_Popup.cs:621 |  | MESSAGE | MessageBox.Show | ("Do you want to run the Confirm", "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-db24e616 | this.btnConfirm.Click | FP01624_Apply_Popup.cs:623 | if (MessageBox.Show("Do you want to run the Confirm", "Confirm", MessageBoxButtons.YesNo) == DialogResult.Yes) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-91a5ea5d | this.btnConfirm.Click | FP01624_Apply_Popup.cs:624 | if (MessageBox.Show("Do you want to run the Confirm", "Confirm", MessageBoxButtons.YesNo) == DialogResult.Yes) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_Apply_Popup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1939c26a | this.btnDownload.Click | FP01624_Apply_Popup.cs:603 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-32716d55 | this.btnDownload.Click | FP01624_Apply_Popup.cs:604 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP01624_Apply_Popup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-896c4bf2 | this.btnFind.Click | FP01624_Apply_Popup.cs:598 |  | STATE | drpPlanPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Apply_Popup.ClearGrid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a56c55a9 | (진입점 미연결) | FP01624_Apply_Popup.cs:291 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cb055dc6 | (진입점 미연결) | FP01624_Apply_Popup.cs:292 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a5699bb0 | (진입점 미연결) | FP01624_Apply_Popup.cs:293 |  | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-45bbdb51 | (진입점 미연결) | FP01624_Apply_Popup.cs:294 |  | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9be3f54d | (진입점 미연결) | FP01624_Apply_Popup.cs:302 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e86e1293 | (진입점 미연결) | FP01624_Apply_Popup.cs:315 | try ▸ if (dtDimensionInfo!=null) ▸ foreach (DataRow row in dtDimensionInfo.Rows) | DATA_OP | table.Columns.Add | (new DataColumn(colname, typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-33290435 | (진입점 미연결) | FP01624_Apply_Popup.cs:317 | try ▸ if (dtDimensionInfo!=null) | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, table, ColumnWidth.Data, Col… | 화면 필드/플래그 변경 |  |  |  |
| AC-e85df506 | (진입점 미연결) | FP01624_Apply_Popup.cs:317 | try ▸ if (dtDimensionInfo!=null) | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, table, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data, 2, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6d597dd | (진입점 미연결) | FP01624_Apply_Popup.cs:323 | try ▸ if (dtDimensionInfo!=null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-2c230ab3 | (진입점 미연결) | FP01624_Apply_Popup.cs:324 | try ▸ if (dtDimensionInfo!=null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-8fe4cb95 | (진입점 미연결) | FP01624_Apply_Popup.cs:325 | try ▸ if (dtDimensionInfo!=null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-a11a2280 | (진입점 미연결) | FP01624_Apply_Popup.cs:328 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a48bb2e | (진입점 미연결) | FP01624_Apply_Popup.cs:338 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-155f9552 | (진입점 미연결) | FP01624_Apply_Popup.cs:341 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6f183d3f | (진입점 미연결) | FP01624_Apply_Popup.cs:342 | finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-44e952fd | (진입점 미연결) | FP01624_Apply_Popup.cs:343 | finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d3e3204a | (진입점 미연결) | FP01624_Apply_Popup.cs:344 | finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Apply_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6de9042 | this.Load | FP01624_Apply_Popup.cs:209 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f4c611b7 | this.Load | FP01624_Apply_Popup.cs:210 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-675f92a1 | this.Load | FP01624_Apply_Popup.cs:211 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e0b23549 | this.Load | FP01624_Apply_Popup.cs:213 |  | FLAG | dtDimensionInfo | siMain.GetSpdTitle(SpdSheet.ownerProgram, UserInfoContext.Current.UserId, SpdSheet.shtMain… | 화면 필드/플래그 변경 |  |  |  |
| AC-82f5552e | this.Load | FP01624_Apply_Popup.cs:213 |  | CALL_EXT | siMain.GetSpdTitle | (SpdSheet.ownerProgram, UserInfoContext.Current.UserId, SpdSheet.shtMain) | ⚠ 의미 확인 필요 |  |  |  |

## FP01624_Apply_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f4c68bb | this.Load | FP01624_Apply_Popup.cs:204 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01624_Apply_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30efd791 | Dispose | FP01624_Apply_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01624_Apply_Popup.DrpPlanPeriod_ValueChanged

진입점: drpPlanPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d7f3ffe | drpPlanPeriod.ValueChanged | FP01624_Apply_Popup.cs:196 | if (start != Filter["BUCKET_FROM"]) | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-cfa677e4 | drpPlanPeriod.ValueChanged | FP01624_Apply_Popup.cs:198 |  | DATA_OP | Filter["BUCKET_TO"] | drpPlanPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP01624_Apply_Popup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2157ccaf | FindButton | FP01624_Apply_Popup.cs:251 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f639c9c1 | FindButton | FP01624_Apply_Popup.cs:252 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-594a453d | FindButton | FP01624_Apply_Popup.cs:254 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_Apply_Popup.FindData

진입점: this.btnFind.Click / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e853239 | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:355 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-021af67f | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:357 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-ce2c0fdf | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:357 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7be79b5c | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:364 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8dd3cfac | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:365 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3746e241 | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:366 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-abc2010f | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:367 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-07e7e9d9 | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:374 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc39ccac | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:377 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1cbe73d6 | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:379 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-730a05df | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:380 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = true; //if (init) { DictColumn = siMain.SetAmen… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e486c5aa | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:386 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, set, ColumnWidth.Data, Colum… | 화면 필드/플래그 변경 |  |  |  |
| AC-42290122 | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:386 | if (DoSearchData != null) ▸ try ▸ lambda | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, set, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data,2, Aut… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c71e69f9 | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:392 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-ae767409 | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:393 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-202fd93c | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:394 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-bb097ab7 | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:398 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee742c0a | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:401 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-201ed56d | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:402 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-131cfefe | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:411 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-92ff380e | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:414 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-edbe67e9 | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:415 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c5cbc588 | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:416 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e67c3e2c | this.btnFind.Click 외 2 | FP01624_Apply_Popup.cs:417 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Apply_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a17fd044 | this.Load | FP01624_Apply_Popup.cs:165 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb4327ee | this.Load | FP01624_Apply_Popup.cs:167 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01624_Apply_Popup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34c5fe0a | (진입점 미연결) | FP01624_Apply_Popup.cs:554 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-0c81e31d | (진입점 미연결) | FP01624_Apply_Popup.cs:555 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-0b6ba88d | (진입점 미연결) | FP01624_Apply_Popup.cs:556 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-9fc8ec4b | (진입점 미연결) | FP01624_Apply_Popup.cs:557 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-ca8fb925 | (진입점 미연결) | FP01624_Apply_Popup.cs:558 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-c072424d | (진입점 미연결) | FP01624_Apply_Popup.cs:559 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-34a17136 | (진입점 미연결) | FP01624_Apply_Popup.cs:560 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-58f8e2a1 | (진입점 미연결) | FP01624_Apply_Popup.cs:562 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-e27577b2 | (진입점 미연결) | FP01624_Apply_Popup.cs:563 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-6ea57699 | (진입점 미연결) | FP01624_Apply_Popup.cs:567 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f7a1f1d6 | (진입점 미연결) | FP01624_Apply_Popup.cs:568 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP01624_Apply_Popup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37839387 | this.Load | FP01624_Apply_Popup.cs:184 |  | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-db42c0c8 | this.Load | FP01624_Apply_Popup.cs:185 |  | UI_PROP | drpPlanPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |

## FP01624_Apply_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9644b4f5 | this.Load | FP01624_Apply_Popup.cs:223 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10305798 | this.Load | FP01624_Apply_Popup.cs:224 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01624_Apply_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25273505 | (진입점 미연결) | FP01624_Apply_Popup.cs:242 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01624_Apply_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-475358c1 | this.Load | FP01624_Apply_Popup.cs:236 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-235e4f4e | this.Load | FP01624_Apply_Popup.cs:237 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP01624_Apply_Popup.WO_PastDayCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f55c52e5 | (진입점 미연결) | FP01624_Apply_Popup.cs:520 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01624_MPPWPP", "find_SiteDate", ds_siteDate_in.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SiteDate] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a1e171ed | (진입점 미연결) | FP01624_Apply_Popup.cs:521 |  | DATA_OP | dtSiteDate.getColumn | (0, "SITE_DATE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-694b2f6b | (진입점 미연결) | FP01624_Apply_Popup.cs:526 | foreach (KeyValuePair<string, AmendDate> kvp in Calendar.Days) | CALL_BASE | GetDayColNameOfType | (day, DateColumnType) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e419b6f3 | (진입점 미연결) | FP01624_Apply_Popup.cs:537 | foreach (KeyValuePair<string, AmendDate> kvp in Calendar.Days) ▸ if (dtLoopDay < dtBaseDay) ▸ foreach (DataRow row in dsCheckExcel.Tables[0]… | MESSAGE | MessageBox.Show | (msg) | 메시지 표시 |  |  |  |
| AC-2f5f81c7 | (진입점 미연결) | FP01624_Apply_Popup.cs:538 | foreach (KeyValuePair<string, AmendDate> kvp in Calendar.Days) ▸ if (dtLoopDay < dtBaseDay) ▸ foreach (DataRow row in dsCheckExcel.Tables[0]… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-4474dec8 | (진입점 미연결) | FP01624_Apply_Popup.cs:543 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01624_Column_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a8c7a58 | .ctor | FP01624_Column_ExcelPopup.cs:155 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-c0a7fa49 | .ctor | FP01624_Column_ExcelPopup.cs:156 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-456e6ad2 | .ctor | FP01624_Column_ExcelPopup.cs:157 |  | FLAG | HeaderLineCount | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-ee00c5c6 | .ctor | FP01624_Column_ExcelPopup.cs:158 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f8024638 | .ctor | FP01624_Column_ExcelPopup.cs:159 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP01624_Column_ExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load / radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try] / radioWPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try] / radioWO.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try] / drpPlanPeriod.ValueChanged [if (Clear)] / this.btnFind.Click / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd1c9717 | this.Load 외 7 | FP01624_Column_ExcelPopup.cs:425 |  | FLAG | Calendar | AmendService.ApplyAmendCalendarCondition(Filter, dtDimensionInfo, null) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ec6ddc1 | this.Load 외 7 | FP01624_Column_ExcelPopup.cs:425 |  | CALL_EXT | AmendService.ApplyAmendCalendarCondition | (Filter, dtDimensionInfo, null) | ⚠ 의미 확인 필요 |  |  |  |

## FP01624_Column_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aac3c5e3 | this.btnClose.Click | FP01624_Column_ExcelPopup.cs:1206 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_Column_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b1ed39f | this.btnDownload.Click | FP01624_Column_ExcelPopup.cs:1186 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-02a5ef10 | this.btnDownload.Click | FP01624_Column_ExcelPopup.cs:1187 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP01624_Column_ExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41317406 | this.btnFind.Click | FP01624_Column_ExcelPopup.cs:1175 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | STATE | cmbMppMonth.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-364917cf | this.btnFind.Click | FP01624_Column_ExcelPopup.cs:1177 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | STATE | cmbWppWeek.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ccf71c18 | this.btnFind.Click | FP01624_Column_ExcelPopup.cs:1178 |  | STATE | drpPlanPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-413e2f3e | this.btnFind.Click | FP01624_Column_ExcelPopup.cs:1179 |  | STATE | radioMPP.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-477e4b0a | this.btnFind.Click | FP01624_Column_ExcelPopup.cs:1180 |  | STATE | radioWPP.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1324511b | this.btnFind.Click | FP01624_Column_ExcelPopup.cs:1181 |  | STATE | radioWO.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Column_ExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48919698 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1192 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-1e59ee10 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1193 |  | STATE | radioMPP.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-809daab8 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1194 |  | STATE | radioWPP.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2ff79948 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1195 |  | STATE | radioWO.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Column_ExcelPopup.ClearGrid

진입점: radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try] / radioWPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try] / radioWO.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try] / drpPlanPeriod.ValueChanged [if (Clear)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a945ac8e | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:432 |  | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b5dfeccd | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:433 |  | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2bbf523b | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:435 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d537a17f | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:436 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ccab7ea0 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:437 |  | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-58d6fff0 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:438 |  | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-222e38e0 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:439 |  | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0a2e0b4c | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:440 |  | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-27a09715 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:447 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-30aaf11e | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:460 | try ▸ if (dtDimensionInfo!=null) ▸ foreach (DataRow row in dtDimensionInfo.Rows) | DATA_OP | table.Columns.Add | (new DataColumn(colname, typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5252c71d | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:462 | try ▸ if (dtDimensionInfo!=null) | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, table, ColumnWidth.Data, Col… | 화면 필드/플래그 변경 |  |  |  |
| AC-6e62041f | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:462 | try ▸ if (dtDimensionInfo!=null) | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, table, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data, 2, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-4264448e | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:468 | try ▸ if (dtDimensionInfo!=null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-11fb5f83 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:469 | try ▸ if (dtDimensionInfo!=null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-93eb3752 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:470 | try ▸ if (dtDimensionInfo!=null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-99f90b4e | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:473 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e6f437f | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:483 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-60a63372 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:486 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-00a30d05 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:487 | finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cc4d3698 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:488 | finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-38436024 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:489 | finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ee1585d4 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:490 | finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dd17aaeb | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:491 | finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-40ce873b | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:497 | finally | UI_PROP | dtSaveExcelData.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-337f1e24 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:498 | finally | DATA_OP | dsTmp.Tables.Add | (dtSaveExcelData) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d8cb5e3 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:504 | finally ▸ foreach (KeyValuePair<string,string> eN in DictColumn) | DATA_OP | dtSaveExcelData.Columns.Contains | (key) | 데이터 객체 조작/조회 |  |  |  |
| AC-5518863c | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:506 | finally ▸ foreach (KeyValuePair<string,string> eN in DictColumn) ▸ if (!dtSaveExcelData.Columns.Contains(key)) | DATA_OP | dtSaveExcelData.Columns.Add | (key, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-856aa77b | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 3 | FP01624_Column_ExcelPopup.cs:509 | finally | GRID_BIND | siMain.Query | (dsTmp, true) | 그리드에 조회 결과 바인딩 |  |  |  |

## FP01624_Column_ExcelPopup.CmbMppMonth_SelectedIndexChanged

진입점: cmbMppMonth.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9802dfbf | cmbMppMonth.SelectedIndexChanged | FP01624_Column_ExcelPopup.cs:340 |  | DATA_OP | Filter["PLAN_MONTH"] | selected_month | 행/컬럼 값 대입 |  |  |  |

## FP01624_Column_ExcelPopup.CmbWppWeek_SelectedIndexChanged

진입점: cmbWppWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20c7cf58 | cmbWppWeek.SelectedIndexChanged | FP01624_Column_ExcelPopup.cs:327 | try | DATA_OP | dtWeek.Select | ("CODE='" + selected_week + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-43e749be | cmbWppWeek.SelectedIndexChanged | FP01624_Column_ExcelPopup.cs:328 | try | DATA_OP | Filter["MAIN_PLAN_WEEK"] | Filter["PLAN_WEEK"] = selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-7cf4f84b | cmbWppWeek.SelectedIndexChanged | FP01624_Column_ExcelPopup.cs:328 | try | DATA_OP | Filter["PLAN_WEEK"] | selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-0479a9f8 | cmbWppWeek.SelectedIndexChanged | FP01624_Column_ExcelPopup.cs:329 | try | DATA_OP | Filter["BUCKET_FROM"] | week_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4d6e54db | cmbWppWeek.SelectedIndexChanged | FP01624_Column_ExcelPopup.cs:331 | try | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-599282ff | cmbWppWeek.SelectedIndexChanged | FP01624_Column_ExcelPopup.cs:332 | try | UI_PROP | drpPlanPeriod.Value2 | DateTime.ParseExact(week_row["END_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |

## FP01624_Column_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb5103b3 | this.Load | FP01624_Column_ExcelPopup.cs:351 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f4407c8c | this.Load | FP01624_Column_ExcelPopup.cs:352 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-388dfdd3 | this.Load | FP01624_Column_ExcelPopup.cs:353 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d4a12ed1 | this.Load | FP01624_Column_ExcelPopup.cs:355 |  | FLAG | dtDimensionInfo | siMain.GetSpdTitle(SpdSheet.ownerProgram, UserInfoContext.Current.UserId, SpdSheet.shtMain… | 화면 필드/플래그 변경 |  |  |  |
| AC-b19a71ed | this.Load | FP01624_Column_ExcelPopup.cs:355 |  | CALL_EXT | siMain.GetSpdTitle | (SpdSheet.ownerProgram, UserInfoContext.Current.UserId, SpdSheet.shtMain) | ⚠ 의미 확인 필요 |  |  |  |

## FP01624_Column_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fcd1988 | (진입점 미연결) | FP01624_Column_ExcelPopup.cs:1145 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7848b36f | (진입점 미연결) | FP01624_Column_ExcelPopup.cs:1145 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP01624_Column_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa341b4f | this.Load | FP01624_Column_ExcelPopup.cs:346 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01624_Column_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33b9dec3 | Dispose | FP01624_Column_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01624_Column_ExcelPopup.DrpPlanPeriod_ValueChanged

진입점: drpPlanPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a94273e3 | drpPlanPeriod.ValueChanged | FP01624_Column_ExcelPopup.cs:298 | if (Filter["MPP_WPP_PLAN_TYPE"] == "WPP" \|\| Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (start != Filter["BUCKET_FROM"]) | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-85989ac2 | drpPlanPeriod.ValueChanged | FP01624_Column_ExcelPopup.cs:305 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "WPP" \|\| Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (start != Filter["BUCKET_FROM"]) | DATA_OP | Filter["BUCKET_FROM"] | drpPlanPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-c1443228 | drpPlanPeriod.ValueChanged | FP01624_Column_ExcelPopup.cs:312 | if (end != Filter["BUCKET_TO"]) | DATA_OP | Filter["BUCKET_TO"] | end | 행/컬럼 값 대입 |  |  |  |

## FP01624_Column_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c14d94e9 | (진입점 미연결) | FP01624_Column_ExcelPopup.cs:1102 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP01624_Column_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fff26e1 | FindButton | FP01624_Column_ExcelPopup.cs:395 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-37d7139a | FindButton | FP01624_Column_ExcelPopup.cs:396 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8bf30348 | FindButton | FP01624_Column_ExcelPopup.cs:398 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_Column_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09564384 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:549 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a7b2f39 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:551 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-af284861 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:551 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-97e8d13d | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:555 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7d739786 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:556 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7dac2d93 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:558 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bcce265b | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:559 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b2eaafcf | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:560 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-991dd239 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:561 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-254ed206 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:562 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-730dab4a | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:563 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-834832c4 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:570 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5721829 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:573 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51d3b44e | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:575 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b9f6b1e | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:576 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = true; if (init) { DictColumn = siMain.SetAmendE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1907a50 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:582 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, set, ColumnWidth.Data, Colum… | 화면 필드/플래그 변경 |  |  |  |
| AC-c6777cf5 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:582 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, set, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data,Header… | ⚠ 의미 확인 필요 |  |  |  |
| AC-11c334e5 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:588 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-67540db1 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:589 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-812c9730 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:590 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-fe58dc80 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:595 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6a61b7b | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:596 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3170de1f | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:600 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2930e55a | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:601 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e59bee09 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:610 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-02f45daa | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:613 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e7a7d15f | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:614 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0732d2a9 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:615 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-082da660 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:616 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5e891320 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:617 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fd79adb4 | this.Load 외 2 | FP01624_Column_ExcelPopup.cs:618 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Column_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39e835e0 | this.Load | FP01624_Column_ExcelPopup.cs:167 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cc4b0b26 | this.Load | FP01624_Column_ExcelPopup.cs:169 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01624_Column_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b840fca | this.Load | FP01624_Column_ExcelPopup.cs:187 |  | DATA_OP | Filter["MAIN_PLAN_WEEK"] | Filter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-49fda94c | this.Load | FP01624_Column_ExcelPopup.cs:188 |  | DATA_OP | Filter["TODAY"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-9566da3b | this.Load | FP01624_Column_ExcelPopup.cs:189 |  | FLAG | dtWeek | DataService.FP_ExecuteQuery2("FP01624_MPPWPP", "find_excel_week", Filter.Dictionary, "Plan… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_excel_week] \| FP\Planning… | 화면 필드/플래그 변경 |  |  |  |
| AC-427e7ad8 | this.Load | FP01624_Column_ExcelPopup.cs:189 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_excel_week", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_excel_week] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e0d379c3 | this.Load | FP01624_Column_ExcelPopup.cs:190 |  | LIST_REBIND | clsCtrl.setListBox | (dtWeek, cmbWppWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c4b4d4d5 | this.Load | FP01624_Column_ExcelPopup.cs:191 |  | VALUE_SET | cmbWppWeek.SelectedValue | Filter["PLAN_WEEK"] | 컨트롤 값 설정 |  |  |  |
| AC-c983e0f1 | this.Load | FP01624_Column_ExcelPopup.cs:192 |  | DATA_OP | Filter["PLAN_WEEK"] | CString.GetCheckedListValue(dtWeek, cmbWppWeek.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-4986aefc | this.Load | FP01624_Column_ExcelPopup.cs:195 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) | VALUE_SET | cmbWppWeek.SelectedValue | Filter["PLAN_WEEK"] | 컨트롤 값 설정 |  |  |  |
| AC-916bd3c2 | this.Load | FP01624_Column_ExcelPopup.cs:198 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (cmbWppWeek.SelectedIndex == -1) | VALUE_SET | cmbWppWeek.SelectedIndex | (int)( Math.Ceiling((decimal)(dtWeek.Rows.Count - 1)) / 2) | 컨트롤 값 설정 |  |  |  |
| AC-3e75b826 | this.Load | FP01624_Column_ExcelPopup.cs:203 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | Filter["PLAN_WEEK"] | selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-1bd43854 | this.Load | FP01624_Column_ExcelPopup.cs:204 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | dtWeek.Select | ("CODE='" + selected_week + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-a2e3ea28 | this.Load | FP01624_Column_ExcelPopup.cs:205 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | week_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-674d7993 | this.Load | FP01624_Column_ExcelPopup.cs:206 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | Filter["BUCKET_TO"] | week_row["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2e91b8e6 | this.Load | FP01624_Column_ExcelPopup.cs:214 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ else of (cmbWppWeek.SelectedIndex == -1) | DATA_OP | Filter["PLAN_WEEK"] | selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-f2d7b36e | this.Load | FP01624_Column_ExcelPopup.cs:218 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ else of (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | dtWeek.Select | ("CODE='" + selected_week + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-545f4d6e | this.Load | FP01624_Column_ExcelPopup.cs:219 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ else of (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | week_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-63c434fd | this.Load | FP01624_Column_ExcelPopup.cs:220 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ else of (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | Filter["BUCKET_TO"] | week_row["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bcd57ead | this.Load | FP01624_Column_ExcelPopup.cs:228 | else of (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (dtWeek.Good()) | VALUE_SET | cmbWppWeek.SelectedIndex | dtWeek.Rows.Count / 2 | 컨트롤 값 설정 |  |  |  |
| AC-c97ba443 | this.Load | FP01624_Column_ExcelPopup.cs:232 | else of (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (!string.IsNullOrWhiteSpace(selected_week)) | DATA_OP | Filter["PLAN_WEEK"] | selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-7a431133 | this.Load | FP01624_Column_ExcelPopup.cs:236 | else of (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (!string.IsNullOrWhiteSpace(selected_week)) ▸ try | DATA_OP | dtWeek.Select | ("CODE='" + selected_week + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-f9b2d4ab | this.Load | FP01624_Column_ExcelPopup.cs:237 | else of (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (!string.IsNullOrWhiteSpace(selected_week)) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | week_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-864b7d97 | this.Load | FP01624_Column_ExcelPopup.cs:238 | else of (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (!string.IsNullOrWhiteSpace(selected_week)) ▸ try | DATA_OP | Filter["BUCKET_TO"] | week_row["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a32e066c | this.Load | FP01624_Column_ExcelPopup.cs:243 |  | FLAG | dtMonth | DataService.FP_ExecuteQuery2("FP01624_MPPWPP", "find_excel_month", Filter.Dictionary, "Pla… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_excel_month] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-3d3722e2 | this.Load | FP01624_Column_ExcelPopup.cs:243 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_excel_month", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_excel_month] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-31a17046 | this.Load | FP01624_Column_ExcelPopup.cs:244 |  | LIST_REBIND | clsCtrl.setListBox | (dtMonth, cmbMppMonth, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1df0ba6b | this.Load | FP01624_Column_ExcelPopup.cs:245 |  | VALUE_SET | cmbMppMonth.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-121d63dd | this.Load | FP01624_Column_ExcelPopup.cs:247 |  | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-dd9c7a4d | this.Load | FP01624_Column_ExcelPopup.cs:248 |  | UI_PROP | drpPlanPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-caeae309 | this.Load | FP01624_Column_ExcelPopup.cs:251 | if (Filter["MPP_WPP_PLAN_TYPE"]=="") | DATA_OP | Filter["MPP_WPP_PLAN_TYPE"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-f1fe6163 | this.Load | FP01624_Column_ExcelPopup.cs:255 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | STATE | cmbMppMonth.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-226ab952 | this.Load | FP01624_Column_ExcelPopup.cs:256 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | STATE | cmbWppWeek.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-03fdb4a5 | this.Load | FP01624_Column_ExcelPopup.cs:257 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | VALUE_SET | radioMPP.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-1633eefc | this.Load | FP01624_Column_ExcelPopup.cs:260 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | STATE | cmbMppMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8bddfad1 | this.Load | FP01624_Column_ExcelPopup.cs:261 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | STATE | cmbWppWeek.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-17fe2b59 | this.Load | FP01624_Column_ExcelPopup.cs:262 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | VALUE_SET | radioWO.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-ff452f4f | this.Load | FP01624_Column_ExcelPopup.cs:266 | switch (Filter["MPP_WPP_PLAN_TYPE"]) default: case "WPP": | STATE | cmbMppMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6a6564ca | this.Load | FP01624_Column_ExcelPopup.cs:267 | switch (Filter["MPP_WPP_PLAN_TYPE"]) default: case "WPP": | STATE | cmbWppWeek.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-eb566188 | this.Load | FP01624_Column_ExcelPopup.cs:268 | switch (Filter["MPP_WPP_PLAN_TYPE"]) default: case "WPP": | VALUE_SET | radioWPP.Checked | true | 컨트롤 값 설정 |  |  |  |

## FP01624_Column_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f09416e | this.Load | FP01624_Column_ExcelPopup.cs:365 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-066b421d | this.Load | FP01624_Column_ExcelPopup.cs:366 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01624_Column_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba8f0858 | (진입점 미연결) | FP01624_Column_ExcelPopup.cs:386 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01624_Column_ExcelPopup.NullData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ede6254b | (진입점 미연결) | FP01624_Column_ExcelPopup.cs:523 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-831b1928 | (진입점 미연결) | FP01624_Column_ExcelPopup.cs:523 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-83eeb486 | (진입점 미연결) | FP01624_Column_ExcelPopup.cs:531 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-25da7bce | (진입점 미연결) | FP01624_Column_ExcelPopup.cs:534 | try | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, null, ColumnWidth.Data, Colu… | 화면 필드/플래그 변경 |  |  |  |
| AC-881013b1 | (진입점 미연결) | FP01624_Column_ExcelPopup.cs:534 | try | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, null, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data, 2, A… | ⚠ 의미 확인 필요 |  |  |  |

## FP01624_Column_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-145757fa | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1110 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-825cd306 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1110 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2764b3d5 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1113 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a7fcea9c | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1114 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0753bda3 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1115 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39092989 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1117 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1071d54b | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1119 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5f75ee54 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1120 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-886a9c36 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1120 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain,prg, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a89f02cc | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1127 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | cmbMppMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-06aa8615 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1128 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | cmbWppWeek.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8ec413f3 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1129 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | drpPlanPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4b73053d | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1131 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | radioMPP.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f0edab2c | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1132 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | radioWPP.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-70d8b12e | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1133 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | radioWO.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ba0190ae | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1134 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-7d889252 | this.btnUpload.Click | FP01624_Column_ExcelPopup.cs:1136 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01624_Column_ExcelPopup.radio_Changed

진입점: radioMPP.CheckedChanged / radioWPP.CheckedChanged / radioWO.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3da1fcf3 | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1213 | if (radioMPP.Checked) | STATE | cmbMppMonth.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4f8797da | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1214 | if (radioMPP.Checked) | STATE | cmbWppWeek.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-43059f2e | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1217 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") | DATA_OP | Filter["MPP_WPP_PLAN_TYPE"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-befcf976 | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1222 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | DATA_OP | dtMonth.Select | ("CODE='" + selected_month + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-2585842c | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1223 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | DATA_OP | Filter["MAIN_PLAN_WEEK"] | Filter["PLAN_WEEK"] = selected_month | 행/컬럼 값 대입 |  |  |  |
| AC-16bebbb8 | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1223 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | DATA_OP | Filter["PLAN_WEEK"] | selected_month | 행/컬럼 값 대입 |  |  |  |
| AC-4f818ca6 | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1224 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | DATA_OP | Filter["BUCKET_FROM"] | month_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-73098eaa | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1225 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | DATA_OP | Filter["BUCKET_TO"] | month_row["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6cd63a33 | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1228 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-861bf4a4 | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1229 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | UI_PROP | drpPlanPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-82b20d38 | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1241 | else of (radioMPP.Checked) ▸ if (radioWO.Checked) | STATE | cmbMppMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-89d122ae | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1242 | else of (radioMPP.Checked) ▸ if (radioWO.Checked) | STATE | cmbWppWeek.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4e5b09f2 | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1245 | else of (radioMPP.Checked) ▸ if (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WO") | DATA_OP | Filter["MPP_WPP_PLAN_TYPE"] | "WO" | 행/컬럼 값 대입 |  |  |  |
| AC-6b3c407d | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1253 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) | STATE | cmbMppMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f9f60e8a | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1254 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) | STATE | cmbWppWeek.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c48e30a9 | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1257 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") | DATA_OP | Filter["MPP_WPP_PLAN_TYPE"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-6b49227b | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1262 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | DATA_OP | dtWeek.Select | ("CODE='" + selected_week + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a9a210b | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1263 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | DATA_OP | Filter["MAIN_PLAN_WEEK"] | Filter["PLAN_WEEK"] = selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-9573bd2b | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1263 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | DATA_OP | Filter["PLAN_WEEK"] | selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-cb29949b | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1264 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | DATA_OP | Filter["BUCKET_FROM"] | week_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e1d00ed5 | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1265 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | DATA_OP | Filter["BUCKET_TO"] | week_row["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-51dbbf4d | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1268 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-2804b028 | radioMPP.CheckedChanged 외 2 | FP01624_Column_ExcelPopup.cs:1269 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | UI_PROP | drpPlanPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |

## FP01624_Column_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa56f7a9 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:750 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-a5ee0b39 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:751 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ec0c102 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:755 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-7c0be772 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:756 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a06b402 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:760 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-6c9b5df5 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:760 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9bac698a | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:765 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-96b9dd1d | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:766 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f64a7364 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:767 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4e1428f5 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:768 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b68eb9a4 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:769 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-52a1b05f | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:770 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bb89d638 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:778 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-268d63c2 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:781 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d2a0322 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:783 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-791dcbb9 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:786 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd03c7c1 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:791 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-d12f32a8 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:792 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-0fdaeaf0 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:799 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-3d347c40 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:800 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-517ff7eb | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:801 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-de7cd807 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:802 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9e460fa5 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:803 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4ff06b39 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:804 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ce3d9f7d | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:805 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0c97b7da | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:806 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-faa581a3 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:810 | if (DoSaveData != null) ▸ try | DATA_OP | Filter["PLAN_DESCRIPTION"] | description | 행/컬럼 값 대입 |  |  |  |
| AC-15dcdc96 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:813 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | MESSAGE | MessageBox.Show | ("You need description data to proceed") | 메시지 표시 |  |  |  |
| AC-7b584388 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:814 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c5141522 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:815 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8705e010 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:816 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-439b23c5 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:817 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fa19ef5d | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:818 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2742548d | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:819 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-eb2dab54 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:820 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a1b18ba | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:826 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO") | CALL_EXT | HardCodeService.MatchCodeFp | ("FP01624_Column_ExcelPopup","WO_CHINA_CASE",main.getColumn(0, "SITE_ID")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-11506a17 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:826 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO") | DATA_OP | main.getColumn | (0, "SITE_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b8650f61 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:835 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO") | MESSAGE | MessageBox.Show | (sMsgWO, "WO Data Check", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-151db048 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:837 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO") ▸ if (MessageBox.Show(sMsgWO, "WO Data Check", MessageBoxButtons.Ye… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7957b565 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:845 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WPP" \|\| Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | CALL_BASE | GetDayColNameOfType | (Calendar.Days.FirstOrDefault().Value, DateColumnType) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dec8ef5a | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:858 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WPP" \|\| Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (emptyInStart) | MESSAGE | MessageBox.Show | (sMsgWO, "MPP/WPP Start Data Check", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-d708c41c | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:860 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WPP" \|\| Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (emptyInStart) ▸ if… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c25972dd | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:867 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WPP": | DATA_OP | Filter["WPP"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-2261fc93 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:868 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WPP": | DATA_OP | Filter["MPP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-f3abb051 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:869 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WPP": | DATA_OP | Filter["WO"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-0d916290 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:870 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WPP": | DATA_OP | Filter["MRP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d251a7b2 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:873 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | DATA_OP | Filter["WPP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-0d98f1aa | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:874 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | DATA_OP | Filter["MPP"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-f0d18ed2 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:875 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | DATA_OP | Filter["WO"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-53aaf8a3 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:876 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | DATA_OP | Filter["MRP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-bfdfd1b7 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:879 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | DATA_OP | Filter["WPP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-e4c6b530 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:880 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | DATA_OP | Filter["MPP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-f52aca67 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:881 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | DATA_OP | Filter["WO"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-33aa70b2 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:882 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | DATA_OP | Filter["MRP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-f777b3f4 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:889 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO") ▸ if (WO_PastDayCheck(main) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6196649 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:897 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9e7dbf8 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:906 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | mainRow["COMPANY_ID"] | valRow["COMPANY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-65fabacb | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:907 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | mainRow["DIVISION_ID"] | valRow["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b58869e2 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:908 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | mainRow["SITE_ID"] | valRow["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-611ba355 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:909 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | mainRow["PLANT_ID"] | valRow["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e2253693 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:910 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | mainRow["EQUIPMENT_ID"] | valRow["EQUIPMENT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3edd76d0 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:913 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | main.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5979845a | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:924 | if (DoSaveData != null) ▸ try ▸ if (validation == null) | FLAG | valid | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9f99a7f1 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:931 | if (DoSaveData != null) ▸ try ▸ else of (validation == null) ▸ if (validation.Tables!=null) ▸ if (validation.Tables.Count > 0 && validation.… | FLAG | valid | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d9e0b8be | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:935 | if (DoSaveData != null) ▸ try ▸ else of (validation == null) ▸ if (validation.Tables!=null) ▸ else of (validation.Tables.Count > 0 && valida… | FLAG | valid | true | 화면 필드/플래그 변경 |  |  |  |
| AC-35324ab3 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:941 | if (DoSaveData != null) ▸ try ▸ else of (validation == null) ▸ if (validation.Tables!=null) ▸ else of (validation.Tables.Count > 0 && valida… | FLAG | valid | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8e607d8f | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:950 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0903c27 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:962 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4993381 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:964 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e1c3425 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:966 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-457c1942 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:970 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-a11ad78d | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:985 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-8405432b | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:986 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-85934e49 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:992 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | ("Data Saved") | 메시지 표시 |  |  |  |
| AC-5e42bf19 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:999 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-e4c9649c | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1004 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-27168edf | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1023 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (main != null && validation != null && validation.Tables.Count > 0) ▸ foreach (… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-8ede3499 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1025 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (main != null && validation != null && validation.Tables.Count > 0) ▸ foreach (… | CALL_EXT | siMain.SetRowColor | (row_index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c16201c | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1026 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (main != null && validation != null && validation.Tables.Count > 0) ▸ foreach (… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-eb525795 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1030 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (main != null && validation != null && validation.Tables.Count > 0) ▸ foreach (… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-68c4a9f6 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1037 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ else of (main != null && validation != null && validation.Tables.Count > 0) | THROW | throw new Exception("Validation Fail"); |  | 예외 발생 |  |  |  |
| AC-112e7478 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1075 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f720f5e6 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1076 | if (DoSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-0a06e87c | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1080 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-29051d65 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1081 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c395326e | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1082 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8a6d0bcc | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1083 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a775ad05 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1084 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fb126a53 | this.btnSave.Click | FP01624_Column_ExcelPopup.cs:1085 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Column_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8f42b6b | this.Load | FP01624_Column_ExcelPopup.cs:378 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fafed669 | this.Load | FP01624_Column_ExcelPopup.cs:379 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP01624_Column_ExcelPopup.TxtPlanDescription_TextChanged

진입점: txtPlanDescription.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e6542ae | txtPlanDescription.TextChanged | FP01624_Column_ExcelPopup.cs:284 |  | DATA_OP | Filter["PLAN_DESCRIPTION"] | txtPlanDescription.Text | 행/컬럼 값 대입 |  |  |  |

## FP01624_Column_ExcelPopup.WO_PastDayCheck

진입점: this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5335cf93 | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Column_ExcelPopup.cs:720 |  | DATA_OP | ds_siteDate_in["FACTORY_ID"] | dsCheckExcel.Tables[0].Rows[0]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fbcbc160 | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Column_ExcelPopup.cs:721 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01624_MPPWPP", "find_SiteDate", ds_siteDate_in.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SiteDate] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5d9eebf6 | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Column_ExcelPopup.cs:722 |  | DATA_OP | dtSiteDate.getColumn | (0, "SITE_DATE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d5826173 | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Column_ExcelPopup.cs:727 | foreach (KeyValuePair<string, AmendDate> kvp in Calendar.Days) | CALL_BASE | GetDayColNameOfType | (day, DateColumnType) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe1302e9 | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Column_ExcelPopup.cs:738 | foreach (KeyValuePair<string, AmendDate> kvp in Calendar.Days) ▸ if (dtLoopDay < dtBaseDay) ▸ foreach (DataRow row in dsCheckExcel.Tables[0]… | MESSAGE | MessageBox.Show | (msg) | 메시지 표시 |  |  |  |
| AC-d6491b24 | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Column_ExcelPopup.cs:739 | foreach (KeyValuePair<string, AmendDate> kvp in Calendar.Days) ▸ if (dtLoopDay < dtBaseDay) ▸ foreach (DataRow row in dsCheckExcel.Tables[0]… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-5021747b | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Column_ExcelPopup.cs:744 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01624_MemoAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69f880e5 | .ctor | FP01624_MemoAddPopup.cs:98 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-022f465b | .ctor | FP01624_MemoAddPopup.cs:99 |  | FLAG | _sMemoType | sMemoType | 화면 필드/플래그 변경 |  |  |  |

## FP01624_MemoAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35609988 | this.btnClose.Click | FP01624_MemoAddPopup.cs:196 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_MemoAddPopup.btnEquipment_Click

진입점: this.btnEquipment.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59edfc38 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:658 | if (string.IsNullOrEmpty(txtLine.Text)) | MESSAGE | MessageBox.Show | ("Please insert Line value") | 메시지 표시 |  |  |  |
| AC-bf3de23d | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:659 | if (string.IsNullOrEmpty(txtLine.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e2a686f | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:663 |  | FLAG | _sFactory | txtBuilding.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-694b3764 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:664 |  | FLAG | _sOperation | txtOperation.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-c22c3565 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:665 |  | FLAG | _sItem | txtItem.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-f676b5fe | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:666 |  | FLAG | _sLine | txtLine.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-96ee37f0 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:667 |  | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-d9dce29a | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:668 |  | FLAG | _sElectrodeType | txtElectrodType.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-ca1292d6 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:674 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-12d9af19 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:676 |  | POPUP | new FP00595_EquipmentPopup | () | 팝업/폼 생성 |  |  |  |
| AC-74c4de50 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:677 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-951a7697 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:679 |  | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-98a45b46 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:680 |  | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-f9f49a14 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:681 |  | DATA_OP | popup.Filter["PLANT_ID"] | _sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-02c5f749 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:682 |  | DATA_OP | popup.Filter["FACTORY_ID"] | _sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-51947060 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:683 |  | DATA_OP | popup.Filter["OPERATION_ID"] | _sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-9e4bc74e | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:684 |  | DATA_OP | popup.Filter["LINE_ID"] | _sLine | 행/컬럼 값 대입 |  |  |  |
| AC-a77b921d | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:686 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-39a394e9 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:688 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c4d8c614 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:693 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sEquipment | txtEquipment.Text = data["EQUIPMENT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ba22feb7 | this.btnEquipment.Click | FP01624_MemoAddPopup.cs:693 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtEquipment.Text | data["EQUIPMENT_ID"].ToString() | 컨트롤 값 설정 |  |  |  |

## FP01624_MemoAddPopup.btnLine_Click

진입점: this.btnLine.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06db1b51 | this.btnLine.Click | FP01624_MemoAddPopup.cs:612 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert material value") | 메시지 표시 |  |  |  |
| AC-8c8813b9 | this.btnLine.Click | FP01624_MemoAddPopup.cs:613 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5a6c6d3 | this.btnLine.Click | FP01624_MemoAddPopup.cs:617 |  | FLAG | _sItem | txtItem.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-577e3ce5 | this.btnLine.Click | FP01624_MemoAddPopup.cs:618 |  | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-ffa75612 | this.btnLine.Click | FP01624_MemoAddPopup.cs:624 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-86eb689f | this.btnLine.Click | FP01624_MemoAddPopup.cs:626 |  | POPUP | new FP00596_LinePopup | () | 팝업/폼 생성 |  |  |  |
| AC-af2378c1 | this.btnLine.Click | FP01624_MemoAddPopup.cs:627 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-43982b5a | this.btnLine.Click | FP01624_MemoAddPopup.cs:628 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-faff8043 | this.btnLine.Click | FP01624_MemoAddPopup.cs:629 |  | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-f3006d92 | this.btnLine.Click | FP01624_MemoAddPopup.cs:630 |  | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-0fa6ee03 | this.btnLine.Click | FP01624_MemoAddPopup.cs:631 |  | DATA_OP | popup.Filter["ITEM_ID"] | _sItem | 행/컬럼 값 대입 |  |  |  |
| AC-e1107800 | this.btnLine.Click | FP01624_MemoAddPopup.cs:633 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a3ff9726 | this.btnLine.Click | FP01624_MemoAddPopup.cs:635 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b2560195 | this.btnLine.Click | FP01624_MemoAddPopup.cs:640 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sPlant | data["PLANT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c65f2fef | this.btnLine.Click | FP01624_MemoAddPopup.cs:641 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sFactory | txtBuilding.Text = data["FACTORY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c1ea0205 | this.btnLine.Click | FP01624_MemoAddPopup.cs:641 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtBuilding.Text | data["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-20fd0f2a | this.btnLine.Click | FP01624_MemoAddPopup.cs:642 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sOperation | txtOperation.Text = data["OPERATION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-451e1305 | this.btnLine.Click | FP01624_MemoAddPopup.cs:642 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtOperation.Text | data["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-7f5a32f6 | this.btnLine.Click | FP01624_MemoAddPopup.cs:643 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sLine | txtLine.Text = data["LINE_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-13c08dbf | this.btnLine.Click | FP01624_MemoAddPopup.cs:643 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtLine.Text | data["LINE_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-7095c3d9 | this.btnLine.Click | FP01624_MemoAddPopup.cs:644 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | FLAG | _sElectrodeType | txtElectrodType.Text = data["ELECTRODE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cf30199c | this.btnLine.Click | FP01624_MemoAddPopup.cs:644 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtElectrodType.Text | data["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-63ee25f9 | this.btnLine.Click | FP01624_MemoAddPopup.cs:648 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-ad0bb641 | this.btnLine.Click | FP01624_MemoAddPopup.cs:648 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_SET | txtEquipment.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-b943c747 | this.btnLine.Click | FP01624_MemoAddPopup.cs:650 | if (popup.ShowDialog() == DialogResult.OK) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-22bfdd55 | this.btnLine.Click | FP01624_MemoAddPopup.cs:650 | if (popup.ShowDialog() == DialogResult.OK) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_CLEAR | txtEquipment.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP01624_MemoAddPopup.btnMaterial_Click

진입점: this.btnMaterial.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea9bbfdb | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:385 |  | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-15b46122 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:390 | if (string.IsNullOrEmpty(_sInstance)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-073418a2 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:391 | if (string.IsNullOrEmpty(_sInstance)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dbb1bb78 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:395 |  | DATA_OP | dtResult.Columns.Add | ("INSTANCE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8055096f | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:398 |  | DATA_OP | dRow.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-77244e81 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:402 | foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff36e102 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:405 | if (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | dtResult.Rows[0]["INSTANCE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f3eae833 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:407 | else of (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-be23c196 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:414 | if (_sInstanceType == "E3") | POPUP | new FP00596_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-71d45cba | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:415 | if (_sInstanceType == "E3") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-9259cc6a | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:416 | if (_sInstanceType == "E3") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-d0044788 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:417 | if (_sInstanceType == "E3") | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d1f8ce19 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:418 | if (_sInstanceType == "E3") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-4984d3f8 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:420 | if (_sInstanceType == "E3") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-79b0650b | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:422 | if (_sInstanceType == "E3") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2a6b01e8 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:435 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | POPUP | new FP00595_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9f3cbf56 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:436 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-6df55322 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:437 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-e78c45b1 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:438 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | DATA_OP | popup.Filter["DIVISION_ID"] | _sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-78e58392 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:439 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-5fc8e2c4 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:441 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fb92a3f9 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:443 | else of (_sInstanceType == "E3") ▸ if (_sInstanceType == "E1") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a6342660 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:454 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | FLAG | _sModel | txtModel.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-cc298650 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:461 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-7f739eb7 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:464 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | POPUP | new FP00602_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-88baa86e | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:465 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-18042bc9 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:466 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-dccbef1e | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:467 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-17646630 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:468 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["TOP_ITEM_ID"] | _sModel | 행/컬럼 값 대입 |  |  |  |
| AC-c623185e | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:469 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | DATA_OP | popup.Filter["DATE"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e3ea95f7 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:471 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-407c5191 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:473 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ if (_sInstanceType == "A") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-41d276ad | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:485 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | FLAG | _sModel | txtModel.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-5e4226dc | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:491 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") ▸ if (fc … | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-6b88e57d | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:493 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | POPUP | new FP00601_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b39de9bf | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:494 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-0d58c19a | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:495 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-b5dda563 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:496 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["SITE_ID"] | _sSite | 행/컬럼 값 대입 |  |  |  |
| AC-b5ee3d5e | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:497 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["TOP_ITEM_ID"] | _sModel | 행/컬럼 값 대입 |  |  |  |
| AC-4e62ea01 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:498 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | DATA_OP | popup.Filter["DATE"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-d75ce966 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:500 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0ef26c22 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:502 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ if (_sInstanceType == "P") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-90320069 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:515 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | FLAG | _sFormOperation | "F6000" | 화면 필드/플래그 변경 |  |  |  |
| AC-da30b1e9 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:521 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-67f60fea | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:523 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | POPUP | new FP00621_LineCN2ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f3c5a21b | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:524 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-a0339be1 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:525 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | DATA_OP | popup.Filter["INSTANCE_ID"] | _sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-083c6330 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:526 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | DATA_OP | popup.Filter["FORM_OPERATION_ID"] | _sFormOperation | 행/컬럼 값 대입 |  |  |  |
| AC-3cb16052 | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:528 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-71c63ead | this.btnMaterial.Click | FP01624_MemoAddPopup.cs:530 | else of (_sInstanceType == "E3") ▸ else of (_sInstanceType == "E1") ▸ else of (_sInstanceType == "A") ▸ else of (_sInstanceType == "P") ▸ if… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01624_MemoAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be44c1a1 | this.btnSave.Click | FP01624_MemoAddPopup.cs:186 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8784e3b6 | this.btnSave.Click | FP01624_MemoAddPopup.cs:190 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_MemoAddPopup.cboInstance_changed

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c6d6091 | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:289 | if (dtInstance.Rows.Count >0) | FLAG | _sInstance | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-387e6a63 | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:291 | if (dtInstance.Rows.Count >0) | DATA_OP | dtResult.Columns.Add | ("INSTANCE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-55dbd1d0 | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:294 | if (dtInstance.Rows.Count >0) | DATA_OP | dRow.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d68425c | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:298 | if (dtInstance.Rows.Count >0) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-14390988 | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:301 | if (dtInstance.Rows.Count >0) ▸ if (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | dtResult.Rows[0]["INSTANCE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-66b747f9 | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:303 | if (dtInstance.Rows.Count >0) ▸ else of (dtResult.Rows.Count > 0) | FLAG | _sInstanceType | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7ad0637f | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:307 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | FLAG | _sEquipment | txtEquipment.Text = "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-25d1816b | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:307 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | VALUE_SET | txtEquipment.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-8135ac6a | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:308 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | txtEquipment.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f2d4f862 | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:309 | if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | btnEquipment.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b13832a5 | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:313 | else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | VALUE_CLEAR | txtEquipment.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-490b1a55 | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:314 | else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | txtEquipment.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6a2412fb | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:315 | else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F" \|\| _sInstanceType == "") | STATE | btnEquipment.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-172ed078 | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:320 | if (_sInstanceType == "F") | VALUE_SET | cboProdType.SelectedValue | "-" | 컨트롤 값 설정 |  |  |  |
| AC-6633fab3 | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:321 | if (_sInstanceType == "F") | FLAG | _sProductionType | "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-fc45c89c | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:323 | if (_sInstanceType == "F") | STATE | cboProdType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ecf0f571 | cboInstance.SelectedIndexChanged | FP01624_MemoAddPopup.cs:327 | else of (_sInstanceType == "F") | STATE | cboProdType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_MemoAddPopup.cboMarket_changed

진입점: cboMarket.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fce8a02 | cboMarket.SelectedIndexChanged | FP01624_MemoAddPopup.cs:334 |  | FLAG | _sMarket | CString.GetCheckedListValue(dtMarket, cboMarket.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |

## FP01624_MemoAddPopup.cboProdtype_changed

진입점: cboProdType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1889773b | cboProdType.SelectedIndexChanged | FP01624_MemoAddPopup.cs:339 |  | FLAG | _sProductionType | CString.GetCheckedListValue(dtProdType, cboProdType.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |

## FP01624_MemoAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc64eb3a | this.btnSave.Click | FP01624_MemoAddPopup.cs:207 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("You need to select Item") | 메시지 표시 |  |  |  |
| AC-6e406bf0 | this.btnSave.Click | FP01624_MemoAddPopup.cs:208 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-aa629aa7 | this.btnSave.Click | FP01624_MemoAddPopup.cs:212 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | MESSAGE | MessageBox.Show | ("You need to select line") | 메시지 표시 |  |  |  |
| AC-39093fee | this.btnSave.Click | FP01624_MemoAddPopup.cs:213 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-992a2202 | this.btnSave.Click | FP01624_MemoAddPopup.cs:217 | if (string.IsNullOrWhiteSpace(txtEquipment.Text)) | MESSAGE | MessageBox.Show | ("You need to select Equipment") | 메시지 표시 |  |  |  |
| AC-693ab5c1 | this.btnSave.Click | FP01624_MemoAddPopup.cs:218 | if (string.IsNullOrWhiteSpace(txtEquipment.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-82758c95 | this.btnSave.Click | FP01624_MemoAddPopup.cs:220 |  | FLAG | _sProductionType | CString.GetCheckedListValue(dtProdType, cboProdType.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-6fd76136 | this.btnSave.Click | FP01624_MemoAddPopup.cs:223 | if (string.IsNullOrWhiteSpace(_sProductionType)) | MESSAGE | MessageBox.Show | ("You need to select Production Type") | 메시지 표시 |  |  |  |
| AC-34bae047 | this.btnSave.Click | FP01624_MemoAddPopup.cs:224 | if (string.IsNullOrWhiteSpace(_sProductionType)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-328317a1 | this.btnSave.Click | FP01624_MemoAddPopup.cs:227 |  | FLAG | _sMarket | CString.GetCheckedListValue(dtMarket, cboMarket.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-a232e90d | this.btnSave.Click | FP01624_MemoAddPopup.cs:230 | if (string.IsNullOrWhiteSpace(_sMarket)) | MESSAGE | MessageBox.Show | ("You need to Market") | 메시지 표시 |  |  |  |
| AC-e07ca5ac | this.btnSave.Click | FP01624_MemoAddPopup.cs:231 | if (string.IsNullOrWhiteSpace(_sMarket)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b9e4c87a | this.btnSave.Click | FP01624_MemoAddPopup.cs:243 | if (string.IsNullOrWhiteSpace(txtModel.Text) \|\| string.IsNullOrWhiteSpace(txtItem.Text) \|\| string.IsNullOrWhiteSpace(txtEqui…) | MESSAGE | MessageBox.Show | ("Select Material") | 메시지 표시 |  |  |  |
| AC-0ad1cafd | this.btnSave.Click | FP01624_MemoAddPopup.cs:244 | if (string.IsNullOrWhiteSpace(txtModel.Text) \|\| string.IsNullOrWhiteSpace(txtItem.Text) \|\| string.IsNullOrWhiteSpace(txtEqui…) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d4f78577 | this.btnSave.Click | FP01624_MemoAddPopup.cs:247 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01624_MemoAddPopup.ClearVariable

진입점: this.drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15ab100e | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:361 |  | FLAG | _sCompany | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c1648d5d | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:362 |  | FLAG | _sDivision | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-e6ff3341 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:363 |  | FLAG | _sSite | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-377c509b | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:364 |  | FLAG | _sPlant | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-842097ae | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:365 |  | FLAG | _sFactory | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-9d196127 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:366 |  | FLAG | _sOperation | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c8b5a5ff | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:367 |  | FLAG | _sLine | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-f2325b9a | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:368 |  | FLAG | _sEquipment | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-fe29aa07 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:369 |  | FLAG | _sModel | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-713f72a5 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:370 |  | FLAG | _sItem | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-87e1cbd8 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:371 |  | FLAG | _sNickName | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-a08ae9e0 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:372 |  | FLAG | _sMarket | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-dd444aaa | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:373 |  | FLAG | _sProductionType | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-43ec54d3 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:374 |  | FLAG | _sMemo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-e926bb24 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:375 |  | FLAG | _sElectrodeType | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## FP01624_MemoAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b63625e | Dispose | FP01624_MemoAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01624_MemoAddPopup.drpPeriod_ValueChanged

진입점: this.drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3694d79b | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:347 |  | VALUE_CLEAR | txtModel.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-1ce9c1c1 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:348 |  | VALUE_CLEAR | txtItem.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-88b6a7dc | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:349 |  | VALUE_CLEAR | txtEquipment.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-15d6fd01 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:350 |  | VALUE_CLEAR | txtBuilding.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-829a5fcb | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:351 |  | VALUE_CLEAR | txtOperation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-a910da67 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:352 |  | VALUE_CLEAR | txtLine.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-5fe0c356 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:353 |  | VALUE_CLEAR | txtElectrodType.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-417deda6 | this.drpPeriod.ValueChanged | FP01624_MemoAddPopup.cs:354 |  | VALUE_CLEAR | txtMemo.Text | string.Empty | 컨트롤 값 비움 |  |  |  |

## FP01624_MemoAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ead0adf | this.Load | FP01624_MemoAddPopup.cs:112 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4b5a1221 | this.Load | FP01624_MemoAddPopup.cs:114 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01624_MemoAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fd5c6ad | this.Load | FP01624_MemoAddPopup.cs:127 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a3263147 | this.Load | FP01624_MemoAddPopup.cs:131 |  | FLAG | dtInstance | DataCommon.GetUserFormCodeData(_FormProcedure, "FP00608_find_instance_add") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-87f37279 | this.Load | FP01624_MemoAddPopup.cs:131 |  | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP00608_find_instance_add") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-446d1faa | this.Load | FP01624_MemoAddPopup.cs:132 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c6598ab2 | this.Load | FP01624_MemoAddPopup.cs:133 |  | VALUE_CLEAR | cboInstance.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-108ea70f | this.Load | FP01624_MemoAddPopup.cs:135 |  | FLAG | dtProdType | Data_FP.Common_FP(Data_FP.Type.DIVISION_DEMAND_TYPE, false, UserInfoContext.Current.UserId… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-c0845fb6 | this.Load | FP01624_MemoAddPopup.cs:135 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION_DEMAND_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSa… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-963b327d | this.Load | FP01624_MemoAddPopup.cs:137 |  | DATA_OP | dtProdType.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d57bbab9 | this.Load | FP01624_MemoAddPopup.cs:138 |  | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-55a99a79 | this.Load | FP01624_MemoAddPopup.cs:143 | foreach (DataColumn dc in dtCombo.Columns) ▸ if (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-f24d1a5f | this.Load | FP01624_MemoAddPopup.cs:147 | foreach (DataColumn dc in dtCombo.Columns) ▸ else of (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-398b2130 | this.Load | FP01624_MemoAddPopup.cs:150 |  | CALL_EXT | dtCombo.Rows.InsertAt | (dr, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c22d88b2 | this.Load | FP01624_MemoAddPopup.cs:151 |  | LIST_BIND | cboProdType.DataSource | dtCombo | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-51731ded | this.Load | FP01624_MemoAddPopup.cs:153 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cboProdType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2f22a656 | this.Load | FP01624_MemoAddPopup.cs:154 |  | VALUE_CLEAR | cboProdType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-0310b0c7 | this.Load | FP01624_MemoAddPopup.cs:156 |  | FLAG | dtMarket | Data_FP.Common_FP(Data_FP.Type.DEMAND_MARKET_TYPE, false, UserInfoContext.Current.UserId, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-ffdb3d2a | this.Load | FP01624_MemoAddPopup.cs:156 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DEMAND_MARKET_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSave… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dd02f3d2 | this.Load | FP01624_MemoAddPopup.cs:157 |  | LIST_REBIND | clsCtrl.setListBox | (dtMarket, cboMarket, false, "CODE", "CODE") | 목록 컨트롤 재구성 |  |  |  |
| AC-df73c8f0 | this.Load | FP01624_MemoAddPopup.cs:158 |  | VALUE_CLEAR | cboMarket.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-47903303 | this.Load | FP01624_MemoAddPopup.cs:164 |  | VALUE_SET | drpPeriod.InitValue | sStartday.ToString() + ":" + sStartday.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-288abe93 | this.Load | FP01624_MemoAddPopup.cs:167 |  | VALUE_CLEAR | txtMemo.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP01624_MemoAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-716dd194 | this.btnSave.Click | FP01624_MemoAddPopup.cs:255 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_DateMap", sStartDate, sStartDate, sEndDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7d6190b8 | this.btnSave.Click | FP01624_MemoAddPopup.cs:261 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | Filter["PLAN_DATE"] | dtRange.Rows[i]["_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-00def8ea | this.btnSave.Click | FP01624_MemoAddPopup.cs:262 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP01624_MPPWPP", "merge_FP01624_MEMO_P", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=merge_FP01624_MEMO_P] \| FP\… | 엔드포인트 호출 |  |  |  |
| AC-57aa37fe | this.btnSave.Click | FP01624_MemoAddPopup.cs:263 | if (dtRange != null) ▸ for (i < dtRange.Rows.Count) | DATA_OP | Filter["PLAN_DATE"] | prev_plan | 행/컬럼 값 대입 |  |  |  |
| AC-f9da5246 | this.btnSave.Click | FP01624_MemoAddPopup.cs:273 | if (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01624_MemoAddPopup.SetValueByPopupData

진입점: this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50623223 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:546 | if (data != null) | FLAG | _sDivision | data["DIVISION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ad0d8d76 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:547 | if (data != null) | FLAG | _sSite | data["SITE_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2a1e0f6c | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:548 | if (data != null) | FLAG | _sItem | txtItem.Text = data["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-985cf994 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:548 | if (data != null) | VALUE_SET | txtItem.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f41dbee4 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:552 | if (data != null) ▸ if (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | FLAG | _sModel | txtModel.Text = data["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0db61cff | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:552 | if (data != null) ▸ if (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | VALUE_SET | txtModel.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3b4bedf9 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:556 | if (data != null) ▸ else of (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | FLAG | _sModel | txtModel.Text = data["MODEL_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-57d86928 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:556 | if (data != null) ▸ else of (_sInstanceType == "E3" \|\| _sInstanceType == "E1" \|\| _sInstanceType == "F") | VALUE_SET | txtModel.Text | data["MODEL_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8d1bf5e2 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:559 | if (data != null) | FLAG | dtProdType | DataCommon.GetUserFormCodeData(_FormProcedure, "findLookUpCode_ProdType", _sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ed886b4d | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:559 | if (data != null) | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "findLookUpCode_ProdType", _sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a85b98b | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:560 | if (data != null) | DATA_OP | dtProdType.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9e7fd4dc | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:561 | if (data != null) | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0c7acf02 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:565 | if (data != null) ▸ foreach (DataColumn dc in dtCombo.Columns) ▸ if (dc.ColumnName == "CODE") | DATA_OP | dr[dc] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-d2a06c00 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:567 | if (data != null) ▸ foreach (DataColumn dc in dtCombo.Columns) ▸ else of (dc.ColumnName == "CODE") ▸ if (dc.ColumnName == "SORT_ORDER") | DATA_OP | dr[dc] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-cc6ee278 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:569 | if (data != null) ▸ foreach (DataColumn dc in dtCombo.Columns) ▸ else of (dc.ColumnName == "CODE") ▸ else of (dc.ColumnName == "SORT_ORDER") | DATA_OP | dr[dc] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ad80f94f | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:571 | if (data != null) | CALL_EXT | dtCombo.Rows.InsertAt | (dr, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-833c011d | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:572 | if (data != null) | LIST_BIND | cboProdType.DataSource | dtCombo | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-265cb021 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:573 | if (data != null) | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cboProdType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8fed52f8 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:574 | if (data != null) | VALUE_CLEAR | cboProdType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-50b3fe95 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:578 | if (data != null) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sPlant | data["PLANT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e5333d54 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:580 | if (data != null) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sPlant | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6a9866e8 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:584 | if (data != null) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-b915e353 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:584 | if (data != null) ▸ if (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_SET | txtEquipment.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-f613402b | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:586 | if (data != null) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | FLAG | _sEquipment | txtEquipment.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ed0fb9e0 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:586 | if (data != null) ▸ else of (_sInstanceType == "A" \|\| _sInstanceType == "P" \|\| _sInstanceType == "F") | VALUE_CLEAR | txtEquipment.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-4fee6959 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:588 | if (data != null) | FLAG | _sFactory | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f6a4a922 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:589 | if (data != null) | FLAG | _sOperation | txtOperation.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fb851b3b | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:589 | if (data != null) | VALUE_CLEAR | txtOperation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9e179850 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:590 | if (data != null) | FLAG | _sLine | txtLine.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4552c373 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:590 | if (data != null) | VALUE_CLEAR | txtLine.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-12004fb3 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:591 | if (data != null) | FLAG | _sElectrodeType | txtElectrodType.Text = "" | 화면 필드/플래그 변경 |  |  |  |
| AC-eaeb2b0f | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:591 | if (data != null) | VALUE_CLEAR | txtElectrodType.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0264fbf4 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:595 | if (data != null) ▸ if (_sInstanceType == "F") | VALUE_SET | cboProdType.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-656ec307 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:596 | if (data != null) ▸ if (_sInstanceType == "F") | FLAG | _sProductionType | "-" | 화면 필드/플래그 변경 |  |  |  |
| AC-35d32f79 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:600 | if (data != null) ▸ else of (_sInstanceType == "F") | VALUE_CLEAR | cboProdType.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-bf949856 | this.btnMaterial.Click [if (_sInstanceType == "E3") ▸ if (po… | FP01624_MemoAddPopup.cs:601 | if (data != null) ▸ else of (_sInstanceType == "F") | FLAG | _sProductionType | "" | 화면 필드/플래그 변경 |  |  |  |

## FP01624_MemoEditPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe7f5ca0 | .ctor | FP01624_MemoEditPopup.cs:108 |  | FLAG | SrcRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-9ba9019f | .ctor | FP01624_MemoEditPopup.cs:109 |  | FLAG | iColumn | colindex | 화면 필드/플래그 변경 |  |  |  |
| AC-9756a562 | .ctor | FP01624_MemoEditPopup.cs:110 |  | FLAG | iRow | rowindex | 화면 필드/플래그 변경 |  |  |  |
| AC-03c92e4a | .ctor | FP01624_MemoEditPopup.cs:111 |  | FLAG | Day | date | 화면 필드/플래그 변경 |  |  |  |

## FP01624_MemoEditPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da4de78e | this.btnClose.Click | FP01624_MemoEditPopup.cs:231 | try | DATA_OP | Filter["BUCKET_FROM"] | usrDateRangePicker1.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f5e67a64 | this.btnClose.Click | FP01624_MemoEditPopup.cs:232 | try | DATA_OP | Filter["BUCKET_TO"] | usrDateRangePicker1.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f28e33d5 | this.btnClose.Click | FP01624_MemoEditPopup.cs:233 | try | DATA_OP | Filter["MEMO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6daaa2b5 | this.btnClose.Click | FP01624_MemoEditPopup.cs:234 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e97e102c | this.btnClose.Click | FP01624_MemoEditPopup.cs:235 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "delete_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] \| FP\Common\Am… | 엔드포인트 호출 |  |  |  |
| AC-f318ceb9 | this.btnClose.Click | FP01624_MemoEditPopup.cs:236 | try | FLAG | Operation | "Delete" | 화면 필드/플래그 변경 |  |  |  |
| AC-7d9ce3a2 | this.btnClose.Click | FP01624_MemoEditPopup.cs:240 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Delete Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-d43fed84 | this.btnClose.Click | FP01624_MemoEditPopup.cs:244 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-04579a1f | this.btnClose.Click | FP01624_MemoEditPopup.cs:245 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_MemoEditPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2193d0c | this.btnSave.Click | FP01624_MemoEditPopup.cs:208 | try | DATA_OP | Filter["BUCKET_FROM"] | usrDateRangePicker1.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f21aad7b | this.btnSave.Click | FP01624_MemoEditPopup.cs:209 | try | DATA_OP | Filter["BUCKET_TO"] | usrDateRangePicker1.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0be04293 | this.btnSave.Click | FP01624_MemoEditPopup.cs:210 | try | DATA_OP | Filter["MEMO"] | usrTextBox1.Text | 행/컬럼 값 대입 |  |  |  |
| AC-5de90c98 | this.btnSave.Click | FP01624_MemoEditPopup.cs:211 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e9db623e | this.btnSave.Click | FP01624_MemoEditPopup.cs:212 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("AmendMemo", "save_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] \| FP\Common\Amen… | 엔드포인트 호출 |  |  |  |
| AC-8cf53fa6 | this.btnSave.Click | FP01624_MemoEditPopup.cs:213 | try | FLAG | Operation | "Save" | 화면 필드/플래그 변경 |  |  |  |
| AC-42b3ebeb | this.btnSave.Click | FP01624_MemoEditPopup.cs:217 | catch ((Exception xe)) | MESSAGE | MessageBox.Show | ("Save Error: " + xe.Message) | 메시지 표시 |  |  |  |
| AC-4cfe4724 | this.btnSave.Click | FP01624_MemoEditPopup.cs:221 | finally | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-85de844c | this.btnSave.Click | FP01624_MemoEditPopup.cs:222 | finally | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_MemoEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77cd4a60 | Dispose | FP01624_MemoEditPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01624_MemoEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dfb9b34 | this.Load | FP01624_MemoEditPopup.cs:121 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b1ca147 | this.Load | FP01624_MemoEditPopup.cs:123 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01624_MemoEditPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c8b9df1 | this.Load | FP01624_MemoEditPopup.cs:133 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-94d3c070 | this.Load | FP01624_MemoEditPopup.cs:135 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f60a01e | this.Load | FP01624_MemoEditPopup.cs:138 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | usrTextBox1.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-ce161251 | this.Load | FP01624_MemoEditPopup.cs:139 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | usrTextBox1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c9a0507e | this.Load | FP01624_MemoEditPopup.cs:140 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-93333ef1 | this.Load | FP01624_MemoEditPopup.cs:141 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2e69ac63 | this.Load | FP01624_MemoEditPopup.cs:145 | if (SrcRow != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d309f844 | this.Load | FP01624_MemoEditPopup.cs:146 | if (SrcRow != null) | DATA_OP | Filter["INSTANCE_ID"] | SrcRow["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-07ec4ce8 | this.Load | FP01624_MemoEditPopup.cs:147 | if (SrcRow != null) | DATA_OP | Filter["COMPANY_ID"] | SrcRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e1ee60bd | this.Load | FP01624_MemoEditPopup.cs:148 | if (SrcRow != null) | DATA_OP | Filter["DIVISION_ID"] | SrcRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b99043fa | this.Load | FP01624_MemoEditPopup.cs:149 | if (SrcRow != null) | DATA_OP | Filter["SITE_ID"] | SrcRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-937c7214 | this.Load | FP01624_MemoEditPopup.cs:150 | if (SrcRow != null) | DATA_OP | Filter["LINE_ID"] | SrcRow["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cceb74ee | this.Load | FP01624_MemoEditPopup.cs:151 | if (SrcRow != null) | DATA_OP | Filter["PLANT_ID"] | SrcRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1c2d362d | this.Load | FP01624_MemoEditPopup.cs:152 | if (SrcRow != null) | DATA_OP | Filter["FACTORY_ID"] | SrcRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e968e2f6 | this.Load | FP01624_MemoEditPopup.cs:153 | if (SrcRow != null) | DATA_OP | Filter["OPERATION_ID"] | SrcRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd7dfd01 | this.Load | FP01624_MemoEditPopup.cs:154 | if (SrcRow != null) | DATA_OP | Filter["TOP_ITEM_ID"] | Filter["ITEM_ID"] = SrcRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-553cdd7e | this.Load | FP01624_MemoEditPopup.cs:154 | if (SrcRow != null) | DATA_OP | Filter["ITEM_ID"] | SrcRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-527d5750 | this.Load | FP01624_MemoEditPopup.cs:155 | if (SrcRow != null) | DATA_OP | Filter["PRODUCTION_TYPE"] | SrcRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e472e7a9 | this.Load | FP01624_MemoEditPopup.cs:156 | if (SrcRow != null) | DATA_OP | Filter["MARKET"] | SrcRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a57d7839 | this.Load | FP01624_MemoEditPopup.cs:157 | if (SrcRow != null) | DATA_OP | Filter["PLAN_DATE"] | Day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-6c10dcc0 | this.Load | FP01624_MemoEditPopup.cs:158 | if (SrcRow != null) | DATA_OP | Filter["EQUIPMENT_ID"] | SrcRow["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-adcb5561 | this.Load | FP01624_MemoEditPopup.cs:159 | if (SrcRow != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-5ca735ec | this.Load | FP01624_MemoEditPopup.cs:162 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_FROM"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-95d55852 | this.Load | FP01624_MemoEditPopup.cs:163 | if (SrcRow != null) | DATA_OP | Filter["BUCKET_TO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0637ba0c | this.Load | FP01624_MemoEditPopup.cs:165 | if (SrcRow != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fabab90a | this.Load | FP01624_MemoEditPopup.cs:169 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo_user | memoInfo.Tables[0].Rows[0]["CREATOR"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5ce64300 | this.Load | FP01624_MemoEditPopup.cs:170 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo_date | memoInfo.Tables[0].Rows[0]["CREATION"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c979e30d | this.Load | FP01624_MemoEditPopup.cs:171 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | memo | memoInfo.Tables[0].Rows[0]["MEMO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-11fc226f | this.Load | FP01624_MemoEditPopup.cs:172 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | bucket_from | memoInfo.Tables[0].Rows[0]["BUCKET_FROM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ea1a5c39 | this.Load | FP01624_MemoEditPopup.cs:173 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | FLAG | bucket_to | memoInfo.Tables[0].Rows[0]["BUCKET_TO"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-784307c8 | this.Load | FP01624_MemoEditPopup.cs:175 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | txtCreator.Text | memo_user | 컨트롤 값 설정 |  |  |  |
| AC-0e33278d | this.Load | FP01624_MemoEditPopup.cs:176 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | txtCreation.Text | memo_date | 컨트롤 값 설정 |  |  |  |
| AC-84dc0f5f | this.Load | FP01624_MemoEditPopup.cs:177 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | VALUE_SET | usrTextBox1.Text | memo | 컨트롤 값 설정 |  |  |  |
| AC-f9369346 | this.Load | FP01624_MemoEditPopup.cs:178 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | UI_PROP | usrDateRangePicker1.Value1 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(bucket_from).DateTime | 속성 Value1 설정 |  |  |  |
| AC-ead70f41 | this.Load | FP01624_MemoEditPopup.cs:178 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (bucket_from) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eefe3cd6 | this.Load | FP01624_MemoEditPopup.cs:179 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | UI_PROP | usrDateRangePicker1.Value2 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(bucket_to).DateTime | 속성 Value2 설정 |  |  |  |
| AC-f4344363 | this.Load | FP01624_MemoEditPopup.cs:179 | if (SrcRow != null) ▸ if (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0) | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (bucket_to) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a5d7f78 | this.Load | FP01624_MemoEditPopup.cs:185 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | MESSAGE | MessageBox.Show | ("You have no right to add memo") | 메시지 표시 |  |  |  |
| AC-0e7afed2 | this.Load | FP01624_MemoEditPopup.cs:186 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-d0900b47 | this.Load | FP01624_MemoEditPopup.cs:187 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-810974cf | this.Load | FP01624_MemoEditPopup.cs:189 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7766f98b | this.Load | FP01624_MemoEditPopup.cs:190 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-16c3ad43 | this.Load | FP01624_MemoEditPopup.cs:191 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | VALUE_CLEAR | usrTextBox1.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-bec5a50f | this.Load | FP01624_MemoEditPopup.cs:192 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | UI_PROP | usrDateRangePicker1.Value1 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(Filter["PLAN_DATE"]).DateTime | 속성 Value1 설정 |  |  |  |
| AC-912a7561 | this.Load | FP01624_MemoEditPopup.cs:192 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ebf79f2 | this.Load | FP01624_MemoEditPopup.cs:193 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | UI_PROP | usrDateRangePicker1.Value2 | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date(Filter["PLAN_DATE"]).DateTime | 속성 Value2 설정 |  |  |  |
| AC-103550e4 | this.Load | FP01624_MemoEditPopup.cs:193 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | CALL_EXT | GSCM.FP.Common.UIL.Class.DateUtil_FP.gfn_str2Date | (Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ae9a4b9 | this.Load | FP01624_MemoEditPopup.cs:194 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | DATA_OP | Filter["BUCKET_FROM"] | usrDateRangePicker1.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-17ce3fd3 | this.Load | FP01624_MemoEditPopup.cs:195 | if (SrcRow != null) ▸ else of (memoInfo != null && memoInfo.Tables != null && memoInfo.Tables.Count > 0 && memoInfo.Tables[0].Rows.Count > 0… | DATA_OP | Filter["BUCKET_TO"] | usrDateRangePicker1.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP01624_MemoPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e04bc1c | .ctor | FP01624_MemoPopup.cs:164 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-d5d6882b | .ctor | FP01624_MemoPopup.cs:165 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP01624_MemoPopup.btnAdd_Click

진입점: this.btnPlus.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-492ae6fc | this.btnPlus.Click | FP01624_MemoPopup.cs:597 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |

## FP01624_MemoPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2caa39d9 | this.btnClose.Click | FP01624_MemoPopup.cs:627 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_MemoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0caa1831 | this.Load | FP01624_MemoPopup.cs:226 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5c812bd3 | this.Load | FP01624_MemoPopup.cs:227 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d96da4d1 | this.Load | FP01624_MemoPopup.cs:228 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01624_MemoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7bf05ed | this.Load | FP01624_MemoPopup.cs:221 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01624_MemoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1175e534 | Dispose | FP01624_MemoPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01624_MemoPopup.EnableButton

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eafd872 | (진입점 미연결) | FP01624_MemoPopup.cs:51 | switch (button) case MemoPopupButton.Add: | STATE | btnPlus.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-3536c2c7 | (진입점 미연결) | FP01624_MemoPopup.cs:52 | switch (button) case MemoPopupButton.Add: | FLAG | enableBtnPlus | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-dba5c70e | (진입점 미연결) | FP01624_MemoPopup.cs:55 | switch (button) case MemoPopupButton.Save: | STATE | btnSave.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-a6b9a40e | (진입점 미연결) | FP01624_MemoPopup.cs:56 | switch (button) case MemoPopupButton.Save: | FLAG | enableBtnSave | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-585e0f33 | (진입점 미연결) | FP01624_MemoPopup.cs:59 | switch (button) case MemoPopupButton.Find: | STATE | btnFind.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-81a7700f | (진입점 미연결) | FP01624_MemoPopup.cs:60 | switch (button) case MemoPopupButton.Find: | FLAG | enableBtnFind | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-3baaf474 | (진입점 미연결) | FP01624_MemoPopup.cs:63 | switch (button) case MemoPopupButton.Close: | STATE | btnClose.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-c79a63c4 | (진입점 미연결) | FP01624_MemoPopup.cs:64 | switch (button) case MemoPopupButton.Close: | FLAG | enableBtnClose | t_f | 화면 필드/플래그 변경 |  |  |  |

## FP01624_MemoPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d509d5f | FindButton | FP01624_MemoPopup.cs:265 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-be2f67bd | FindButton | FP01624_MemoPopup.cs:266 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e6e37b10 | FindButton | FP01624_MemoPopup.cs:268 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_MemoPopup.FindData

진입점: this.Load / this.btnSave.Click / this.btnFind.Click / this.btnPlus.Click [if (memoPopup.ShowDialog() == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49f95534 | this.Load 외 4 | FP01624_MemoPopup.cs:302 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-f199b9d5 | this.Load 외 4 | FP01624_MemoPopup.cs:302 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8fed769f | this.Load 외 4 | FP01624_MemoPopup.cs:309 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6e8b430f | this.Load 외 4 | FP01624_MemoPopup.cs:310 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bca2e43c | this.Load 외 4 | FP01624_MemoPopup.cs:311 |  | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ed6fb08d | this.Load 외 4 | FP01624_MemoPopup.cs:312 |  | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-91f893c8 | this.Load 외 4 | FP01624_MemoPopup.cs:313 |  | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6d593988 | this.Load 외 4 | FP01624_MemoPopup.cs:320 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3160b693 | this.Load 외 4 | FP01624_MemoPopup.cs:324 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP01624_MEMO_P_FIND_FP01624_MEMO_P", Filter, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-446c1f6c | this.Load 외 4 | FP01624_MemoPopup.cs:327 | try | CALL_BASE | this.Invoke | (new Action(delegate () { siMain.Query(set, true); siMain.LockColumn(0, siMain.GetMaxColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-71b7c3fc | this.Load 외 4 | FP01624_MemoPopup.cs:329 | try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-86607f0b | this.Load 외 4 | FP01624_MemoPopup.cs:330 | try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fd0a961a | this.Load 외 4 | FP01624_MemoPopup.cs:332 | try ▸ lambda ▸ if (canSave) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("MEMO"), siMain.GetColumnIndex("MEMO"), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bc1cc9c6 | this.Load 외 4 | FP01624_MemoPopup.cs:334 | try ▸ lambda ▸ else of (canSave) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("MEMO"), siMain.GetColumnIndex("MEMO"), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1be95d1e | this.Load 외 4 | FP01624_MemoPopup.cs:343 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ea33d86 | this.Load 외 4 | FP01624_MemoPopup.cs:346 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1a152cc3 | this.Load 외 4 | FP01624_MemoPopup.cs:347 | finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4b4d2323 | this.Load 외 4 | FP01624_MemoPopup.cs:348 | finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-baeac59a | this.Load 외 4 | FP01624_MemoPopup.cs:351 | finally ▸ lambda ▸ if (canSave) | STATE | this.btnPlus.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-74a7e10c | this.Load 외 4 | FP01624_MemoPopup.cs:352 | finally ▸ lambda ▸ if (canSave) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9d42c084 | this.Load 외 4 | FP01624_MemoPopup.cs:353 | finally ▸ lambda ▸ if (canSave) | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d21c0237 | this.Load 외 4 | FP01624_MemoPopup.cs:355 | finally ▸ lambda ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8a0e7904 | this.Load 외 4 | FP01624_MemoPopup.cs:356 | finally ▸ lambda ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-631d839b | this.Load 외 4 | FP01624_MemoPopup.cs:362 | finally ▸ lambda ▸ else of (canSave) | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-51ecf183 | this.Load 외 4 | FP01624_MemoPopup.cs:363 | finally ▸ lambda ▸ else of (canSave) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP01624_MemoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d77e351f | this.Load | FP01624_MemoPopup.cs:173 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-49bd9a60 | this.Load | FP01624_MemoPopup.cs:175 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01624_MemoPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e434a5d | (진입점 미연결) | FP01624_MemoPopup.cs:550 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-f33592a0 | (진입점 미연결) | FP01624_MemoPopup.cs:551 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-254a407a | (진입점 미연결) | FP01624_MemoPopup.cs:552 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-25e2eaf5 | (진입점 미연결) | FP01624_MemoPopup.cs:553 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-d456e507 | (진입점 미연결) | FP01624_MemoPopup.cs:554 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-d9eeb36c | (진입점 미연결) | FP01624_MemoPopup.cs:555 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-57de13ba | (진입점 미연결) | FP01624_MemoPopup.cs:556 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fa0d39be | (진입점 미연결) | FP01624_MemoPopup.cs:558 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-faab46da | (진입점 미연결) | FP01624_MemoPopup.cs:559 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-77585aec | (진입점 미연결) | FP01624_MemoPopup.cs:563 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-c9606063 | (진입점 미연결) | FP01624_MemoPopup.cs:564 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP01624_MemoPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c0e2cbe | this.Load | FP01624_MemoPopup.cs:199 | if (canSave == true) | STATE | btnPlus.Enabled | enableBtnPlus | 컨트롤 상태 Enabled |  |  |  |
| AC-fba15962 | this.Load | FP01624_MemoPopup.cs:200 | if (canSave == true) | STATE | btnSave.Enabled | enableBtnSave | 컨트롤 상태 Enabled |  |  |  |
| AC-dadfa81c | this.Load | FP01624_MemoPopup.cs:204 | else of (canSave == true) | STATE | btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-95c0fb9b | this.Load | FP01624_MemoPopup.cs:205 | else of (canSave == true) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-44686a96 | this.Load | FP01624_MemoPopup.cs:208 |  | STATE | btnFind.Enabled | enableBtnFind | 컨트롤 상태 Enabled |  |  |  |
| AC-b514cfd9 | this.Load | FP01624_MemoPopup.cs:209 |  | STATE | btnClose.Enabled | enableBtnClose | 컨트롤 상태 Enabled |  |  |  |
| AC-d56e24ef | this.Load | FP01624_MemoPopup.cs:211 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8aca3ae5 | this.Load | FP01624_MemoPopup.cs:213 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fc3f56cc | this.Load | FP01624_MemoPopup.cs:214 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP01624_MemoPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63d60a05 | this.Load | FP01624_MemoPopup.cs:237 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01624_MemoPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8894eab | (진입점 미연결) | FP01624_MemoPopup.cs:256 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01624_MemoPopup.Insert_Row

진입점: this.btnPlus.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79a42e4a | this.btnPlus.Click | FP01624_MemoPopup.cs:608 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-91328c51 | this.btnPlus.Click | FP01624_MemoPopup.cs:611 |  | POPUP | new FP01624_MemoAddPopup | (Filter["MEMO_TYPE"]) | 팝업/폼 생성 |  |  |  |
| AC-3bf6e801 | this.btnPlus.Click | FP01624_MemoPopup.cs:612 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-9511d902 | this.btnPlus.Click | FP01624_MemoPopup.cs:613 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01624_MemoPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8dd0e1d | this.btnSave.Click | FP01624_MemoPopup.cs:475 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-e88bcdc1 | this.btnSave.Click | FP01624_MemoPopup.cs:475 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-db4f36e6 | this.btnSave.Click | FP01624_MemoPopup.cs:480 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e15ecedc | this.btnSave.Click | FP01624_MemoPopup.cs:481 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1c0f2a3d | this.btnSave.Click | FP01624_MemoPopup.cs:482 |  | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3dedb5b5 | this.btnSave.Click | FP01624_MemoPopup.cs:483 |  | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b9186805 | this.btnSave.Click | FP01624_MemoPopup.cs:484 |  | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-af12af91 | this.btnSave.Click | FP01624_MemoPopup.cs:492 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-70173a64 | this.btnSave.Click | FP01624_MemoPopup.cs:493 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("USER_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-32cbfd34 | this.btnSave.Click | FP01624_MemoPopup.cs:494 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d6c2cc08 | this.btnSave.Click | FP01624_MemoPopup.cs:497 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | ro["USER_ID"] | ctx.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2263702a | this.btnSave.Click | FP01624_MemoPopup.cs:498 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | m2.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7768da87 | this.btnSave.Click | FP01624_MemoPopup.cs:502 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) ▸ foreach (DataColumn … | DATA_OP | nn[colname] | ro[colname] | 행/컬럼 값 대입 |  |  |  |
| AC-2cb94e85 | this.btnSave.Click | FP01624_MemoPopup.cs:504 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | m2.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0b73168 | this.btnSave.Click | FP01624_MemoPopup.cs:507 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("PlanAmendMemo", "saveAll_planAmendMemoP", m2) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_planAmendMemoP] \| FP\Co… | 엔드포인트 호출 |  |  |  |
| AC-42466496 | this.btnSave.Click | FP01624_MemoPopup.cs:518 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f8ea24ed | this.btnSave.Click | FP01624_MemoPopup.cs:522 | finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-57e647d7 | this.btnSave.Click | FP01624_MemoPopup.cs:523 | finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-433cec9b | this.btnSave.Click | FP01624_MemoPopup.cs:524 | finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-833110bf | this.btnSave.Click | FP01624_MemoPopup.cs:527 | finally ▸ if (canSave) | STATE | this.btnPlus.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d34f79d3 | this.btnSave.Click | FP01624_MemoPopup.cs:528 | finally ▸ if (canSave) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-119ddaae | this.btnSave.Click | FP01624_MemoPopup.cs:529 | finally ▸ if (canSave) | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d09dffb | this.btnSave.Click | FP01624_MemoPopup.cs:531 | finally ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bd37a7bd | this.btnSave.Click | FP01624_MemoPopup.cs:532 | finally ▸ if (canSave) ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-85144a44 | this.btnSave.Click | FP01624_MemoPopup.cs:537 | finally ▸ else of (canSave) | STATE | this.btnPlus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-82412f3f | this.btnSave.Click | FP01624_MemoPopup.cs:538 | finally ▸ else of (canSave) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP01624_MemoPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10186e92 | this.Load | FP01624_MemoPopup.cs:248 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-89d0bf57 | this.Load | FP01624_MemoPopup.cs:249 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP01624_Mpp_Wpp..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0136af1 | .ctor | FP01624_Mpp_Wpp.cs:170 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP01624_Mpp_Wpp.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == FindProcedure) ▸ try] / this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ lambda ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d003e3f7 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1120 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b3dd0248 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1121 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4579eeee | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1122 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b7cf3584 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1123 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-763b61fb | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1125 |  | FLAG | calendar | AmendService.ApplyAmendCalendarCondition(Filter, dtDimensionInfo, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fd14f0e | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1125 |  | CALL_EXT | AmendService.ApplyAmendCalendarCondition | (Filter, dtDimensionInfo, measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-284d905a | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1126 |  | FLAG | weekInfo | calendar.WeekInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-e2ae816a | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1127 |  | FLAG | dateMap | calendar.DateMap | 화면 필드/플래그 변경 |  |  |  |
| AC-704f5e16 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1128 |  | FLAG | monthInfo | calendar.MonthInfo | 화면 필드/플래그 변경 |  |  |  |

## FP01624_Mpp_Wpp.ApplySearchCondition

진입점: popSql.OnSql [if (programID == FindProcedure) ▸ try] / this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ lambda ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8a73f06 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1132 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["BUCKET_FROM"] = drpPlanPeriod.Value1.ToString("yy… | ⚠ 의미 확인 필요 |  |  |  |
| AC-94b2b2e5 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1135 | lambda | DATA_OP | Filter["BUCKET_FROM"] | drpPlanPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-660bd0a3 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1136 | lambda | DATA_OP | Filter["BUCKET_TO"] | drpPlanPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-efd26017 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 3 | FP01624_Mpp_Wpp.cs:1153 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP01624_Mpp_Wpp.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7333d737 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1190 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-aba279cb | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1191 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4aa495c | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1193 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-742bca5b | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1194 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0602e1f | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1195 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b87c884f | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1196 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3006342c | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1203 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP01624_Column_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-59a73383 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1204 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.Filter | this.Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-1e334f65 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1204 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | this.Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8b2f840f | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1205 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.DMPP | 속성 DateColumnType 설정 |  |  |  |
| AC-c00c2f1d | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1211 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-847e7792 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1212 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2000d3a8 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1213 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a5b3e2a7 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1215 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e32c62aa | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1216 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c6383aca | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1217 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-805fe41b | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1220 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-78fd9570 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1221 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-1e534413 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1222 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-003ad093 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1223 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-e83439a1 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1224 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-1aaf42b9 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1225 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-4a08408a | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1226 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-6e933704 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1227 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-be284204 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1228 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Production Type" | 행/컬럼 값 대입 |  |  |  |
| AC-6247f843 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1229 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-c5b6e7be | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1230 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-6be3a96b | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1231 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-abeb18f9 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1233 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSearchData | ExcelColumnPopup_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-3431b52c | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1234 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | ExcelColumnPopup_LineCheck | 속성 DoLineCheck 설정 |  |  |  |
| AC-f397b54d | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1235 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSaveData | ExcelColumnPopup_SaveData | 속성 DoSaveData 설정 |  |  |  |
| AC-4542c594 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1236 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoValidationData | ExcelColumnPopup_ValidationData | 속성 DoValidationData 설정 |  |  |  |
| AC-de15e67e | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1237 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-985d6629 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1247 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP01624_Row_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-916d6bbf | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1248 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | colPopup.Filter | this.Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-6fbc800c | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1248 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | this.Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-48e936b4 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1249 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.DMPP | 속성 DateColumnType 설정 |  |  |  |
| AC-bc1e47b6 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1255 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ea731eea | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1256 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e10ea28a | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1257 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-bd3f27ec | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1259 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2a9e0433 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1260 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | colPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-879191c0 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1261 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-bcd67b98 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1263 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | colPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e144e7f9 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1264 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | colPopup.KeyColumns["PLAN_QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9180b340 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1266 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-6f6182c7 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1267 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-c3980d97 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1268 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-48df7c9e | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1269 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-88ae9c0e | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1270 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-f45b6449 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1271 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-ac700fde | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1272 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-e254399a | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1273 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-31d86be1 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1274 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Production Type" | 행/컬럼 값 대입 |  |  |  |
| AC-773204f2 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1275 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-ebb234eb | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1276 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-9898ac9b | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1277 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-b958e477 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1278 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-941e8626 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1279 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-2fdc960a | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1280 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | colPopup.ColumnTitle["PLAN_QTY"] | "QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-829b2059 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1284 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | colPopup.DoSearchData | ExcelPopup_SearchRow | 속성 DoSearchData 설정 |  |  |  |
| AC-460d97b9 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1285 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | colPopup.DoLineCheck | null | 속성 DoLineCheck 설정 |  |  |  |
| AC-da8b4044 | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1286 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | colPopup.DoSaveData | ExcelPopup_SaveRow | 속성 DoSaveData 설정 |  |  |  |
| AC-6dbfe02c | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1287 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | colPopup.DoValidationData | ExcelPopup_ImportValidationRow | 속성 DoValidationData 설정 |  |  |  |
| AC-ae6f69db | this.btnExcelImport.Click | FP01624_Mpp_Wpp.cs:1288 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01624_Mpp_Wpp.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e57b978 | this.btnMemo.Click | FP01624_Mpp_Wpp.cs:5131 |  | POPUP | new FP01624_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9ccd0daf | this.btnMemo.Click | FP01624_Mpp_Wpp.cs:5132 |  | VALUE_SET | memoPopup.Text | "Memo " + Filter["MPP_WPP_PLAN_TYPE"] | 컨트롤 값 설정 |  |  |  |
| AC-6e829e12 | this.btnMemo.Click | FP01624_Mpp_Wpp.cs:5134 |  | UI_PROP | memoPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-e1ead21c | this.btnMemo.Click | FP01624_Mpp_Wpp.cs:5134 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d948e99e | this.btnMemo.Click | FP01624_Mpp_Wpp.cs:5135 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-001bc7f8 | this.btnMemo.Click | FP01624_Mpp_Wpp.cs:5136 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3b502c68 | this.btnMemo.Click | FP01624_Mpp_Wpp.cs:5137 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f299159b | this.btnMemo.Click | FP01624_Mpp_Wpp.cs:5138 |  | DATA_OP | memoPopup.Filter["MEMO_TYPE"] | memoPopup.Filter["MPP_WPP_PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-09314154 | this.btnMemo.Click | FP01624_Mpp_Wpp.cs:5140 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-a7d41372 | this.btnMemo.Click | FP01624_Mpp_Wpp.cs:5141 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-43fd90b7 | this.btnMemo.Click | FP01624_Mpp_Wpp.cs:5142 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01624_Mpp_Wpp.btnReportConfig_Click

진입점: this.btnReportConfig.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bac23c6d | this.btnReportConfig.Click | FP01624_Mpp_Wpp.cs:5209 |  | POPUP | new FPC0105_ReportConfig_Popup | (SpdSheet.ownerProgram, SpdSheet.shtMppWpp) | 팝업/폼 생성 |  |  |  |
| AC-743f2d8d | this.btnReportConfig.Click | FP01624_Mpp_Wpp.cs:5210 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7b5598ee | this.btnReportConfig.Click | FP01624_Mpp_Wpp.cs:5213 | if (res == DialogResult.OK) | FLAG | dtDimensionInfo | popup.dtDimension | 화면 필드/플래그 변경 |  |  |  |
| AC-9e387116 | this.btnReportConfig.Click | FP01624_Mpp_Wpp.cs:5215 | if (res == DialogResult.OK) | CALL_EXT | siMain.GetSpdTitle | (SpdSheet.ownerProgram, UserInfoContext.Current.UserId, SpdSheet.shtMppWpp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc01dec0 | this.btnReportConfig.Click | FP01624_Mpp_Wpp.cs:5217 | if (res == DialogResult.OK) | DATA_OP | dtDimensionInfo.Select("VISIBLE_FLAG='Y'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b8514ec1 | this.btnReportConfig.Click | FP01624_Mpp_Wpp.cs:5217 | if (res == DialogResult.OK) | DATA_OP | dtDimensionInfo.Select | ("VISIBLE_FLAG='Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-0213edc1 | this.btnReportConfig.Click | FP01624_Mpp_Wpp.cs:5221 | if (res == DialogResult.OK) ▸ foreach (DataRow colHeader in tborgReal.Rows) | DATA_OP | filterNN.Select | ("COLUMN_NAME='" + colname + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4937c04 | this.btnReportConfig.Click | FP01624_Mpp_Wpp.cs:5226 | if (res == DialogResult.OK) ▸ foreach (DataRow colHeader in tborgReal.Rows) ▸ if (selected == null \|\| selected.Length == 0) ▸ if (colindex… | DATA_OP | siMain.ActiveSheet.ColumnHeader.Columns.Remove | (colindex, 1) | 데이터 객체 조작/조회 |  |  |  |

## FP01624_Mpp_Wpp.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-befda18a | this.btnSql.Click | FP01624_Mpp_Wpp.cs:856 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8e266937 | this.btnSql.Click | FP01624_Mpp_Wpp.cs:857 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4f4c5efb | this.btnSql.Click | FP01624_Mpp_Wpp.cs:859 |  | DATA_OP | popSql.Services.Add | (FindProcedure) | 데이터 객체 조작/조회 |  |  |  |
| AC-eabef000 | this.btnSql.Click | FP01624_Mpp_Wpp.cs:860 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01624_FIND_FP01624_REVISIONINFO") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d038b76 | this.btnSql.Click | FP01624_Mpp_Wpp.cs:861 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01624_Mpp_Wpp.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1554ec2 | this.btnToggleSave.Click | FP01624_Mpp_Wpp.cs:5040 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP01624_Mpp_Wpp.btnWO_Click

진입점: this.btnWO.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dceec34f | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5249 |  | POPUP | new FP01624_WoDataPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6cf30dee | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5250 |  | VALUE_SET | woPopup.Text | "WO Data" | 컨트롤 값 설정 |  |  |  |
| AC-5c886db8 | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5252 |  | UI_PROP | woPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-c58b4505 | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5252 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1a2b50a7 | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5253 |  | DATA_OP | woPopup.Filter["PLAN_TYPE"] | "ROLLING" | 행/컬럼 값 대입 |  |  |  |
| AC-21be7d2f | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5254 |  | DATA_OP | woPopup.Filter["OPERATION_ID"] | "E2000" | 행/컬럼 값 대입 |  |  |  |
| AC-730efe75 | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5255 |  | DATA_OP | woPopup.Filter["BUCKET"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-6a3ebef6 | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5256 |  | DATA_OP | woPopup.Filter["BUCKET_FROM"] | DateTime.Today.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-5e2ee575 | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5257 |  | DATA_OP | woPopup.Filter["BUCKET_TO"] | DateTime.Today.AddDays(13).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-fdf99a1f | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5258 |  | UI_PROP | woPopup.Calendar | AmendService.ApplyAmendCalendarCondition(woPopup.Filter, dtDimensionInfo, measure) | 속성 Calendar 설정 |  |  |  |
| AC-f2c8b1c3 | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5258 |  | CALL_EXT | AmendService.ApplyAmendCalendarCondition | (woPopup.Filter, dtDimensionInfo, measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5930b87b | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5261 |  | UI_PROP | woPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-bb25b7fe | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5262 |  | UI_PROP | woPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-83af170c | this.btnWO.Click | FP01624_Mpp_Wpp.cs:5263 |  | POPUP | woPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01624_Mpp_Wpp.cbLast_changed

진입점: cbLast.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8954f1f9 | cbLast.CheckedChanged | FP01624_Mpp_Wpp.cs:5201 | if (cbLast.Checked) | DATA_OP | Filter["LAST_REVISION"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-498231e9 | cbLast.CheckedChanged | FP01624_Mpp_Wpp.cs:5203 | else of (cbLast.Checked) | DATA_OP | Filter["LAST_REVISION"] | "N" | 행/컬럼 값 대입 |  |  |  |

## FP01624_Mpp_Wpp.cboPlanWeek_changed

진입점: this.Load / cboPlanWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b065f52 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5190 | if (cboPlanWeek.SelectedIndex >= 0) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | DATA_OP | Filter["PLAN_MONTH"] | cboPlanWeek.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d17672ae | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5192 | if (cboPlanWeek.SelectedIndex >= 0) ▸ else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | DATA_OP | Filter["PLAN_WEEK"] | cboPlanWeek.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |

## FP01624_Mpp_Wpp.cboType_changed

진입점: this.Load / cboType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-034394f0 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5158 |  | DATA_OP | Filter["MPP_WPP_PLAN_TYPE"] | CString.GetCheckedListValue(dtPlanType, cboType.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-db45c2e7 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5162 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | VALUE_SET | lcPlanWeek.Text | "MPP Month" | 컨트롤 값 설정 |  |  |  |
| AC-eab38239 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5163 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | VALUE_SET | radioMPP.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-5b7f8f49 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5166 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WPP": | VALUE_SET | lcPlanWeek.Text | "WPP Week" | 컨트롤 값 설정 |  |  |  |
| AC-30317b76 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5167 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WPP": | VALUE_SET | radioWPP.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-9456adb7 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5170 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MRP": | VALUE_SET | lcPlanWeek.Text | "WPP Week" | 컨트롤 값 설정 |  |  |  |
| AC-0c410ec9 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5171 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MRP": | VALUE_SET | radioMRP.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-b3dabff0 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5174 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | VALUE_SET | lcPlanWeek.Text | "WPP Week" | 컨트롤 값 설정 |  |  |  |
| AC-aa25524f | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5175 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | VALUE_SET | radioWO.Checked | true | 컨트롤 값 설정 |  |  |  |

## FP01624_Mpp_Wpp.cboUOM_changed

진입점: this.Load / cboUOM.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bebd962 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:5154 |  | DATA_OP | Filter["UOM_TYPE"] | CString.GetCheckedListValue(dtUOMType, cboUOM.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01624_Mpp_Wpp.Close

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2d7f707 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2336 |  | FLAG | PlanWeek | plan_week | 화면 필드/플래그 변경 |  |  |  |

## FP01624_Mpp_Wpp.CreateEditDataGridDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a37ab4c5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4656 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-b993366a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4657 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f0b9ba1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4658 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-868af5d8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4659 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-62b8bfb1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4660 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf944100 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4663 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-67f70bd2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4664 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8031570e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4665 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7a02b4c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4666 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1d1fcd8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4667 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8baa3645 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4668 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c48ffe89 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4669 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-07a1fe60 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4670 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-347c2de9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4671 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0118473 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4672 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac14459c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4673 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-674d9712 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4674 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f472a5d0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4675 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8940a2fc | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4676 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb00ed65 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4677 |  | DATA_OP | dt.Columns.Add | (new DataColumn("BOH_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-55832910 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4678 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd801731 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4679 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-07d5cb75 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4680 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SALES_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb8978de | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4681 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EOH_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c822351 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4682 |  | DATA_OP | dt.Columns.Add | (new DataColumn("YIELD", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-53a44cf9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4684 |  | DATA_OP | dt.Columns.Add | (new DataColumn("WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb55eaef | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4685 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a01a1bb0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4689 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5d02e8a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4690 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a68dcb96 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4692 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-17d115fa | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4693 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-40eb5c7d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4695 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-95ef3ef1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4696 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-77d358af | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4698 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-098ce0ce | this.Load | FP01624_Mpp_Wpp.cs:502 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMppWpp, SpdSheet.shtMppWpp, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5c215e68 | this.Load | FP01624_Mpp_Wpp.cs:503 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMppWpp) | 화면 필드/플래그 변경 |  |  |  |
| AC-970ae471 | this.Load | FP01624_Mpp_Wpp.cs:504 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMppWpp) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-19f554a3 | this.Load | FP01624_Mpp_Wpp.cs:506 |  | FLAG | dtDimensionInfo | siMain.GetSpdTitle(SpdSheet.ownerProgram, UserInfoContext.Current.UserId, SpdSheet.shtMppW… | 화면 필드/플래그 변경 |  |  |  |
| AC-ba6f46c3 | this.Load | FP01624_Mpp_Wpp.cs:506 |  | CALL_EXT | siMain.GetSpdTitle | (SpdSheet.ownerProgram, UserInfoContext.Current.UserId, SpdSheet.shtMppWpp) | ⚠ 의미 확인 필요 |  |  |  |

## FP01624_Mpp_Wpp.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-940b6050 | DeleteButton | FP01624_Mpp_Wpp.cs:813 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01624_Mpp_Wpp.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55c68d36 | Dispose | FP01624_Mpp_Wpp.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01624_Mpp_Wpp.drpPlanPeriod_changed

진입점: drpPlanPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6eb86a77 | drpPlanPeriod.ValueChanged | FP01624_Mpp_Wpp.cs:4977 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PlanControl", "check_plan_date_limit", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=check_plan_date_limit] \| FP\Pl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-005d59a7 | drpPlanPeriod.ValueChanged | FP01624_Mpp_Wpp.cs:4983 | if (dtCheckPlanDate.Good()) | CALL_EXT | DateTime.TryParseExact | (nn, "yyyyMMdd", enUS, System.Globalization.DateTimeStyles.None, out fixDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-27bbb3cb | drpPlanPeriod.ValueChanged | FP01624_Mpp_Wpp.cs:4989 | if (dtCheckPlanDate.Good()) ▸ if (drpPlanPeriod.Value1 < fixDate) | MESSAGE | MessageBox.Show | (string.Format("Instance Fix Limit is applied. You cannot change data before {0}", fixDate… | 메시지 표시 |  |  |  |
| AC-ea20542d | drpPlanPeriod.ValueChanged | FP01624_Mpp_Wpp.cs:4990 | if (dtCheckPlanDate.Good()) ▸ if (drpPlanPeriod.Value1 < fixDate) | UI_PROP | drpPlanPeriod.Value1 | fixDate | 속성 Value1 설정 |  |  |  |
| AC-14bf7bef | drpPlanPeriod.ValueChanged | FP01624_Mpp_Wpp.cs:5003 | if (!Cancel) | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39486f81 | drpPlanPeriod.ValueChanged | FP01624_Mpp_Wpp.cs:5010 | if (!Cancel) ▸ if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-b5f8f3a9 | drpPlanPeriod.ValueChanged | FP01624_Mpp_Wpp.cs:5011 | if (!Cancel) ▸ if (dayCount > 366) | UI_PROP | drpPlanPeriod.Value2 | drpPlanPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP01624_Mpp_Wpp.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-613c2888 | EditButton | FP01624_Mpp_Wpp.cs:821 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("Read Only") | 메시지 표시 |  |  |  |

## FP01624_Mpp_Wpp.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86d9c69f | ExcelButton | FP01624_Mpp_Wpp.cs:900 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP01624_Mpp_Wpp.ExcelColumnPopup_LineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db00b3e0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3352 | if (string.IsNullOrWhiteSpace(row["MARKET"].ToString())) | DATA_OP | row["MARKET"] | "E" | 행/컬럼 값 대입 |  |  |  |
| AC-e3fab122 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3355 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.ExcelColumnPopup_SaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e97e4f3e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1375 |  | FLAG | dsExcelData | data.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4e2e1223 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1396 | if (popup.DialogResult == DialogResult.OK) | CALL_EXT | DataService.CreateResultDataSet | (true, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-02aaf837 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1396 | if (popup.DialogResult == DialogResult.OK) | RETURN | return DataService.CreateResultDataSet(true, 0, ""); |  | 처리 중단/반환 |  |  |  |
| AC-6bd20cce | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1397 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.ExcelColumnPopup_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72470ac1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1306 | if (popup == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-3212e09a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1335 | if (mpp_wpp_plan_type == "MPP") | DATA_OP | popup.Filter["PLAN_REVISON2"] | rev_week_query | 행/컬럼 값 대입 |  |  |  |
| AC-30461c92 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1341 | if (popup != null) | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP01624_FIND_FP01624_IMPORT", popup.Filter, "SQL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3fcc01bb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1342 | if (popup != null) | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP01624_FIND_FP01624_IMPORT", popup.Filter, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2f569b65 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1348 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID" , "FACTORY_ID", "OPERATION_ID" , "LINE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-58a85a6c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1351 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("A", "PLAN_WEEK", "PLAN_REVISION", "TOTAL", "GRID_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a400d57a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1355 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) ▸ try | DATA_OP | popup.Filter["SITE_ID"] | m.Tables[0].Rows[0]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4a1c19fa | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1359 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) ▸ catch () | DATA_OP | popup.Filter["SITE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e8ea0bb8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1363 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-2c484672 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1365 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.ExcelColumnPopup_ValidationData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4a3712f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3258 | if (popup == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-fe48c841 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3262 |  | DATA_OP | column_params.Add | ("USER_ID", CurrentUser) | 데이터 객체 조작/조회 |  |  |  |
| AC-957f13ec | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3263 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP01624_MPPWPP", "delete_Excel_buffer", column_params, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-650bb94c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3268 |  | DATA_OP | data.Tables[0].Columns.Contains | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-c63a54da | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3269 | if (!data.Tables[0].Columns.Contains("PLAN_WEEK")) | DATA_OP | data.Tables[0].Columns.Add | (new DataColumn("PLAN_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a68a30c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3270 |  | DATA_OP | data.Tables[0].Columns.Contains | ("PLAN_REVISION") | 데이터 객체 조작/조회 |  |  |  |
| AC-235a9837 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3271 | if (!data.Tables[0].Columns.Contains("PLAN_REVISION")) | DATA_OP | data.Tables[0].Columns.Add | (new DataColumn("PLAN_REVISION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea922527 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3272 |  | DATA_OP | data.Tables[0].Columns.Contains | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-adc5fdd2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3273 | if (!data.Tables[0].Columns.Contains("PLAN_DATE")) | DATA_OP | data.Tables[0].Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbff0395 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3274 |  | DATA_OP | data.Tables[0].Columns.Contains | ("PLAN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea0717e6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3275 | if (!data.Tables[0].Columns.Contains("PLAN_QTY")) | DATA_OP | data.Tables[0].Columns.Add | (new DataColumn("PLAN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-31f364c6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3278 | foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["PLAN_WEEK"] | popup.Filter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-1c23ee90 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3279 | foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["PLAN_REVISION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-93be255c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3280 | foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["PLAN_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7d7657b3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3281 | foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["PLAN_QTY"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3aa89eff | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3284 |  | DATA_OP | data.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ed8ca869 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3285 |  | UI_PROP | data2.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-19632801 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3292 | if (popup.Filter["WO"] == "Y") ▸ if (data2.Good()) ▸ foreach (DataRow row in data2.Rows) | DATA_OP | row["PLAN_WEEK"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-5284ba2a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3293 | if (popup.Filter["WO"] == "Y") ▸ if (data2.Good()) ▸ foreach (DataRow row in data2.Rows) | DATA_OP | row["PLAN_REVISION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-6a91578d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3294 | if (popup.Filter["WO"] == "Y") ▸ if (data2.Good()) ▸ foreach (DataRow row in data2.Rows) | DATA_OP | row["COMPANY_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-511042c2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3295 | if (popup.Filter["WO"] == "Y") ▸ if (data2.Good()) ▸ foreach (DataRow row in data2.Rows) | DATA_OP | row["DIVISION_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-b119d9bf | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3296 | if (popup.Filter["WO"] == "Y") ▸ if (data2.Good()) ▸ foreach (DataRow row in data2.Rows) | DATA_OP | row["SITE_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-fc0f34b9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3297 | if (popup.Filter["WO"] == "Y") ▸ if (data2.Good()) ▸ foreach (DataRow row in data2.Rows) | DATA_OP | row["PLANT_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-28cdc691 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3298 | if (popup.Filter["WO"] == "Y") ▸ if (data2.Good()) ▸ foreach (DataRow row in data2.Rows) | DATA_OP | row["EQUIPMENT_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-557643da | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3299 | if (popup.Filter["WO"] == "Y") ▸ if (data2.Good()) ▸ foreach (DataRow row in data2.Rows) | DATA_OP | row["PLAN_DATE"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-d1faa9cb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3300 | if (popup.Filter["WO"] == "Y") ▸ if (data2.Good()) ▸ foreach (DataRow row in data2.Rows) | DATA_OP | row["PLAN_QTY"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-b5913294 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3304 | if (popup.Filter["WO"] == "Y") | ENDPOINT | DataService.FP_UpdateBatch2 | ( "FP01624_MPPWPP", "insert_Excel_buffer", data2, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-0d773b7d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3312 | else of (popup.Filter["WO"] == "Y") | ENDPOINT | DataService.FP_UpdateBatch | ( "FP01624_MPPWPP", "insert_Excel_buffer", data, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-938a0e9e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3321 | if (popup.Filter["WO"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01624_MPPWPP", "find_Excel_buffer_validation_WO", column_params, "Planning", 60 * 60 *… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation_WO… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c6f02dc0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3322 | if (popup.Filter["WO"] == "Y") | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-832eef75 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3328 | if (popup.Filter["WO"] == "Y") ▸ if (validation.Good() && data.Good()) ▸ for (i< data.Tables[0].Rows.Count) ▸ if (validation.Tables[0].Rows.… | GRID_SET | data.Tables[0].Rows[i]["COMPANY_ID"] | validation.Tables[0].Rows[i]["COMPANY_ID"] | 그리드 속성/값 설정 |  |  |  |
| AC-b824c4e9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3329 | if (popup.Filter["WO"] == "Y") ▸ if (validation.Good() && data.Good()) ▸ for (i< data.Tables[0].Rows.Count) ▸ if (validation.Tables[0].Rows.… | GRID_SET | data.Tables[0].Rows[i]["DIVISION_ID"] | validation.Tables[0].Rows[i]["DIVISION_ID"] | 그리드 속성/값 설정 |  |  |  |
| AC-6655e2c4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3330 | if (popup.Filter["WO"] == "Y") ▸ if (validation.Good() && data.Good()) ▸ for (i< data.Tables[0].Rows.Count) ▸ if (validation.Tables[0].Rows.… | GRID_SET | data.Tables[0].Rows[i]["SITE_ID"] | validation.Tables[0].Rows[i]["SITE_ID"] | 그리드 속성/값 설정 |  |  |  |
| AC-f4c33411 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3331 | if (popup.Filter["WO"] == "Y") ▸ if (validation.Good() && data.Good()) ▸ for (i< data.Tables[0].Rows.Count) ▸ if (validation.Tables[0].Rows.… | GRID_SET | data.Tables[0].Rows[i]["PLANT_ID"] | validation.Tables[0].Rows[i]["PLANT_ID"] | 그리드 속성/값 설정 |  |  |  |
| AC-7a19001d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3332 | if (popup.Filter["WO"] == "Y") ▸ if (validation.Good() && data.Good()) ▸ for (i< data.Tables[0].Rows.Count) ▸ if (validation.Tables[0].Rows.… | GRID_SET | data.Tables[0].Rows[i]["EQUIPMENT_ID"] | validation.Tables[0].Rows[i]["EQUIPMENT_ID"] | 그리드 속성/값 설정 |  |  |  |
| AC-14318c8a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3340 | else of (popup.Filter["WO"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01624_MPPWPP", "find_Excel_buffer_validation", column_params, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-217fdaa8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3343 |  | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.ExcelPopup_ImportValidationRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d540ecf | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3446 |  | DATA_OP | column_params.Add | ("USER_ID", CurrentUser) | 데이터 객체 조작/조회 |  |  |  |
| AC-22b60d16 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3447 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP01624_MPPWPP2", "excel2_delete_Excel_buffer", column_params, "PLANNING") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=excel2_delete_Excel_buffer] … | 엔드포인트 호출 |  |  |  |
| AC-b939f595 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3451 |  | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-19b53406 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3453 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-397fb8d5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3454 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("JOB_ORDER")) | DATA_OP | data.Tables[0].Columns.Add | (new DataColumn("JOB_ORDER", typeof(int))) | 데이터 객체 조작/조회 |  |  |  |
| AC-35bc02bb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3458 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-3d52b563 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3468 |  | DATA_OP | data.Tables[0].Columns.Contains | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-a2d84d71 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3469 | if (!data.Tables[0].Columns.Contains("PLAN_WEEK")) | DATA_OP | data.Tables[0].Columns.Add | ("PLAN_WEEK", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-af5d0fac | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3470 |  | DATA_OP | data.Tables[0].Columns.Contains | ("PLAN_REVISION") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c9a1128 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3471 | if (!data.Tables[0].Columns.Contains("PLAN_REVISION")) | DATA_OP | data.Tables[0].Columns.Add | ("PLAN_REVISION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8ce2d59 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3474 | foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["PLAN_WEEK"] | popup.Filter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-17b3048f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3475 | foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["PLAN_REVISION"] | popup.Filter["PLAN_REVISION"] | 행/컬럼 값 대입 |  |  |  |
| AC-12a7e249 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3478 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP01624_MPPWPP2", "excel2_insert_Excel_buffer", data, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=excel2_insert_Excel_buffer] \| F… | 엔드포인트 호출 |  |  |  |
| AC-daa7bab2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3490 | if (popup.Filter["WO"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01624_MPPWPP2", "excel2_find_Excel_buffer_validation_WO", column_params, "Planning", 6… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=excel2_find_Excel_buffer_valida… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f5c9977e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3494 | else of (popup.Filter["WO"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01624_MPPWPP2", "excel2_find_Excel_buffer_validation", column_params, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=excel2_find_Excel_buffer_valida… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-de785dcd | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3498 |  | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.ExcelPopup_SaveRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-202c649a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3418 |  | FLAG | dsExcelData | data.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-a28a2df4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3439 |  | CALL_EXT | DataService.CreateResultDataSet | (true, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4fa83d74 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3439 |  | RETURN | return DataService.CreateResultDataSet(true, 0, ""); |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.ExcelPopup_SearchRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7f75ebe | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3390 | if (mpp_wpp_plan_type == "MPP") | DATA_OP | popup.Filter["PLAN_REVISON2"] | rev_week_query | 행/컬럼 값 대입 |  |  |  |
| AC-2ac85e73 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3395 | if (popup != null) | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP01624_EXCEL_2_FIND_FP01624_IMPORT", popup.Filter, "SQL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-36696ef3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3396 | if (popup != null) | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP01624_EXCEL_2_FIND_FP01624_IMPORT", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-28e9b4ff | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3399 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID" , "FACTORY_ID", "OPERATION_ID" , "LINE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b300f343 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3404 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-004b3e69 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3406 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.FindData

진입점: popSql.OnSql [if (programID == FindProcedure)] / this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0097e294 | popSql.OnSql [if (programID == FindProcedure)] 외 3 | FP01624_Mpp_Wpp.cs:1108 | try | ENDPOINT | DataService.FP_ExecuteProcedure | (FindProcedure, Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-29e84110 | popSql.OnSql [if (programID == FindProcedure)] 외 3 | FP01624_Mpp_Wpp.cs:1110 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-4ffc35ce | popSql.OnSql [if (programID == FindProcedure)] 외 3 | FP01624_Mpp_Wpp.cs:1114 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP01624_Mpp_Wpp.FindPlanRevision

진입점: popSql.OnSql [else of (programID == FindProcedure) ▸ if (programID == "PR_UI_FP01624_FIND_FP01624_REVISIONINFO")] / this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfc3d6e3 | popSql.OnSql [else of (programID == FindProcedure) ▸ if (pro… 외 3 | FP01624_Mpp_Wpp.cs:1065 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | DATA_OP | Filter["PLAN_REVISION2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6f2efddf | popSql.OnSql [else of (programID == FindProcedure) ▸ if (pro… 외 3 | FP01624_Mpp_Wpp.cs:1076 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (split != null && split.Length > 0) ▸ for (i < split.Length) ▸ if (split2 != null && split2.L… | DATA_OP | split2[0] | split2[0].Replace("'", "") | 행/컬럼 값 대입 |  |  |  |
| AC-17415454 | popSql.OnSql [else of (programID == FindProcedure) ▸ if (pro… 외 3 | FP01624_Mpp_Wpp.cs:1077 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (split != null && split.Length > 0) ▸ for (i < split.Length) ▸ if (split2 != null && split2.L… | DATA_OP | split2[1] | split2[1].Replace("'", "") | 행/컬럼 값 대입 |  |  |  |
| AC-cdb5098c | popSql.OnSql [else of (programID == FindProcedure) ▸ if (pro… 외 3 | FP01624_Mpp_Wpp.cs:1090 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (split != null && split.Length > 0) | DATA_OP | Filter["PLAN_REVISION2"] | sRev | 행/컬럼 값 대입 |  |  |  |
| AC-fe627e6d | popSql.OnSql [else of (programID == FindProcedure) ▸ if (pro… 외 3 | FP01624_Mpp_Wpp.cs:1093 |  | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP01624_FIND_FP01624_REVISIONINFO", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-62befadd | popSql.OnSql [else of (programID == FindProcedure) ▸ if (pro… 외 3 | FP01624_Mpp_Wpp.cs:1094 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77f7b36f | this.Load | FP01624_Mpp_Wpp.cs:205 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01624_Mpp_Wpp.GetCurMonthWeek

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac83e36a | this.Load | FP01624_Mpp_Wpp.cs:972 | if (dtCurMonthWeek == null) | FLAG | dtCurMonthWeek | DataService.FP_ExecuteQuery2("FP01624_MPPWPP", "find_CurMonthWeek", Filter.Dictionary, "Pl… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_CurMonthWeek] \| FP\Planni… | 화면 필드/플래그 변경 |  |  |  |
| AC-4ea1f173 | this.Load | FP01624_Mpp_Wpp.cs:972 | if (dtCurMonthWeek == null) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_CurMonthWeek", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_CurMonthWeek] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP01624_Mpp_Wpp.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85c868a6 | this.Load | FP01624_Mpp_Wpp.cs:940 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bf278e31 | this.Load | FP01624_Mpp_Wpp.cs:941 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2b3d8bb | this.Load | FP01624_Mpp_Wpp.cs:941 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1b4f22fe | this.Load | FP01624_Mpp_Wpp.cs:942 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01624_Mpp_Wpp.GetFilter

진입점: this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86adab08 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:935 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.GetFpPlanId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dd24e40 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:956 | if (dtPlanRevision.Good()) | DATA_OP | Filter["PLAN_ID"] | dtPlanRevision.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-165a0032 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:957 | if (dtPlanRevision.Good()) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanRevision.Rows[0]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8d7456ed | (진입점 미연결) | FP01624_Mpp_Wpp.cs:961 | else of (dtPlanRevision.Good()) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e5f48f21 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:962 | else of (dtPlanRevision.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP01624_Mpp_Wpp.GetPlanPeriod

진입점: this.Load / clbPlanRevision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-570d55c4 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:376 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cbf183c5 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:379 | if (!dtPlanWeek.Good()) | FLAG | dtPlanWeek | DataService.FP_ExecuteQuery2("FP01624_MPPWPP", "find_PlanWeek", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanWeek] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-7ccde8e4 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:379 | if (!dtPlanWeek.Good()) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_PlanWeek", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanWeek] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-71b83e7b | this.Load 외 1 | FP01624_Mpp_Wpp.cs:391 | else of (string.IsNullOrWhiteSpace(selweek) \|\| selweek.Length != 6) | DATA_OP | dtPlanWeek.Select | ("CODE=" + selweek) | 데이터 객체 조작/조회 |  |  |  |
| AC-258b5a45 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:398 |  | DATA_OP | Filter["INSTANCE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-16d05487 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:399 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PlanControl", "check_plan_date_limit", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=check_plan_date_limit] \| FP\Pl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b1931af0 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:405 | if (dtCheckPlanDate.Good()) | CALL_EXT | DateTime.TryParseExact | (nn, "yyyyMMdd", enUS, System.Globalization.DateTimeStyles.None, out fixDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a41c2d1 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:410 | if (dtCheckPlanDate.Good()) ▸ if (startDate < fixDate) | UI_PROP | drpPlanPeriod.Value1 | fixDate | 속성 Value1 설정 |  |  |  |
| AC-f2fcd3ff | this.Load 외 1 | FP01624_Mpp_Wpp.cs:411 | if (dtCheckPlanDate.Good()) ▸ if (startDate < fixDate) | UI_PROP | drpPlanPeriod.Value2 | fixDate.AddDays(PLAN_PERIOD_LEN) | 속성 Value2 설정 |  |  |  |
| AC-ab2659d0 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:415 | if (dtCheckPlanDate.Good()) ▸ else of (startDate < fixDate) | UI_PROP | drpPlanPeriod.Value1 | startDate | 속성 Value1 설정 |  |  |  |
| AC-32ade5b4 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:416 | if (dtCheckPlanDate.Good()) ▸ else of (startDate < fixDate) | UI_PROP | drpPlanPeriod.Value2 | startDate.AddDays(PLAN_PERIOD_LEN) | 속성 Value2 설정 |  |  |  |
| AC-211f35bb | this.Load 외 1 | FP01624_Mpp_Wpp.cs:421 | else of (dtCheckPlanDate.Good()) | UI_PROP | drpPlanPeriod.Value1 | startDate | 속성 Value1 설정 |  |  |  |
| AC-7ff45c6c | this.Load 외 1 | FP01624_Mpp_Wpp.cs:422 | else of (dtCheckPlanDate.Good()) | UI_PROP | drpPlanPeriod.Value2 | startDate.AddDays(PLAN_PERIOD_LEN) | 속성 Value2 설정 |  |  |  |

## FP01624_Mpp_Wpp.GetPlanRevision

진입점: this.Load / cboPlanWeek.SelectedIndexChanged / cbLast.CheckedChanged / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdda8f73 | this.Load 외 3 | FP01624_Mpp_Wpp.cs:360 | if (cboPlanWeek.SelectedIndex >= 0) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | DATA_OP | Filter["PLAN_MONTH"] | cboPlanWeek.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6d81e97e | this.Load 외 3 | FP01624_Mpp_Wpp.cs:362 | if (cboPlanWeek.SelectedIndex >= 0) ▸ else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | DATA_OP | Filter["PLAN_WEEK"] | cboPlanWeek.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3a0326a5 | this.Load 외 3 | FP01624_Mpp_Wpp.cs:366 |  | FLAG | dtPlanRevision | DataService.FP_ExecuteProcedure2("PR_UI_FP01624_FIND_PLANREVISION", Filter, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-f6b2cbba | this.Load 외 3 | FP01624_Mpp_Wpp.cs:366 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_FP01624_FIND_PLANREVISION", Filter, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ecf07eaf | this.Load 외 3 | FP01624_Mpp_Wpp.cs:367 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanRevision, clbPlanRevision, true) | 목록 컨트롤 재구성 |  |  |  |

## FP01624_Mpp_Wpp.GetPlanWeekOrMonth

진입점: this.Load / cboType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fa98285 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:982 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (dtPlanMonth == null) | FLAG | dtPlanMonth | DataService.FP_ExecuteQuery2("FP01624_MPPWPP", "find_PlanMonth", Filter.Dictionary, "Plann… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanMonth] \| FP\Planning\… | 화면 필드/플래그 변경 |  |  |  |
| AC-4cb6e667 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:982 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (dtPlanMonth == null) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_PlanMonth", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanMonth] \| FP\Planning\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3349721a | this.Load 외 1 | FP01624_Mpp_Wpp.cs:983 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (dtPlanMonth == null) | LIST_REBIND | clsCtrl.setListBox | (dtPlanMonth, cboPlanWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-dabc363d | this.Load 외 1 | FP01624_Mpp_Wpp.cs:985 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (dtPlanMonth == null) | VALUE_SET | cboPlanWeek.SelectedValue | dtCurMonthWeek.Rows[0][0].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-aa3fe06a | this.Load 외 1 | FP01624_Mpp_Wpp.cs:991 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ else of (dtPlanMonth == null) | LIST_REBIND | clsCtrl.setListBox | (dtPlanMonth, cboPlanWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-918f8b7f | this.Load 외 1 | FP01624_Mpp_Wpp.cs:992 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ else of (dtPlanMonth == null) | VALUE_SET | cboPlanWeek.SelectedValue | Filter["PLAN_MONTH"] | 컨트롤 값 설정 |  |  |  |
| AC-1c79d90f | this.Load 외 1 | FP01624_Mpp_Wpp.cs:999 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (dtPlanWeek == null) | FLAG | dtPlanWeek | DataService.FP_ExecuteQuery2("FP01624_MPPWPP", "find_PlanWeek", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanWeek] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-27969c26 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:999 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (dtPlanWeek == null) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_PlanWeek", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PlanWeek] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-dc8a0d56 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:1000 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (dtPlanWeek == null) | LIST_REBIND | clsCtrl.setListBox | (dtPlanWeek, cboPlanWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9562663b | this.Load 외 1 | FP01624_Mpp_Wpp.cs:1002 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (dtPlanWeek == null) | VALUE_SET | cboPlanWeek.SelectedValue | dtCurMonthWeek.Rows[0][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-22232ef4 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:1008 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ else of (dtPlanWeek == null) | LIST_REBIND | clsCtrl.setListBox | (dtPlanWeek, cboPlanWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7fdfdd73 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:1009 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ else of (dtPlanWeek == null) | VALUE_CLEAR | cboPlanWeek.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-d3a40053 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:1021 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ else of (dtPlanWeek == null) ▸ foreach (var vRow in cboPlanWeek.Items) ▸ if (v != null && v… | VALUE_SET | cboPlanWeek.SelectedIndex | index | 컨트롤 값 설정 |  |  |  |
| AC-9db57006 | this.Load 외 1 | FP01624_Mpp_Wpp.cs:1028 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ else of (dtPlanWeek == null) ▸ if (index < 0) | VALUE_SET | cboPlanWeek.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP01624_Mpp_Wpp.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c35ecad6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4158 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-542f49f8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4159 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-463eeebf | (진입점 미연결) | FP01624_Mpp_Wpp.cs:828 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfdc8f91 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:830 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c594d784 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:841 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP01624_Mpp_Wpp.InitComponents

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15ab5431 | this.Load | FP01624_Mpp_Wpp.cs:247 |  | VALUE_SET | lcPlanWeek.Text | "WPP Week" | 컨트롤 값 설정 |  |  |  |
| AC-9d9c58ab | this.Load | FP01624_Mpp_Wpp.cs:248 |  | DATA_OP | Filter["MPP_WPP_PLAN_TYPE"] | CString.GetCheckedListValue(dtPlanType, cboType.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-a10887ea | this.Load | FP01624_Mpp_Wpp.cs:249 |  | DATA_OP | Filter["UOM_TYPE"] | CString.GetCheckedListValue(dtUOMType, cboUOM.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-496d1c39 | this.Load | FP01624_Mpp_Wpp.cs:254 |  | DATA_OP | Filter["PLAN_WEEK"] | CString.GetCheckedListValue(dtPlanWeek, cboPlanWeek.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-c4cd2a2b | this.Load | FP01624_Mpp_Wpp.cs:255 |  | DATA_OP | Filter["PLAN_MONTH"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0fa0f401 | this.Load | FP01624_Mpp_Wpp.cs:257 |  | DATA_OP | Filter["LAST_REVISION"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-91e8817c | this.Load | FP01624_Mpp_Wpp.cs:264 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPlanPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-4f529fd5 | this.Load | FP01624_Mpp_Wpp.cs:265 |  | DATA_OP | Filter["BUCKET_TO"] | drpPlanPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP01624_Mpp_Wpp.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a076e073 | this.Load | FP01624_Mpp_Wpp.cs:219 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5588b397 | this.Load | FP01624_Mpp_Wpp.cs:221 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMppWpp) | 데이터 객체 조작/조회 |  |  |  |
| AC-8eb4a4ac | this.Load | FP01624_Mpp_Wpp.cs:223 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c9247619 | this.Load | FP01624_Mpp_Wpp.cs:224 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-00bf38f0 | this.Load | FP01624_Mpp_Wpp.cs:228 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-438e4fb1 | this.Load | FP01624_Mpp_Wpp.cs:231 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |

## FP01624_Mpp_Wpp.InitEditingBuf

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2da6784 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3708 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-082abe65 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3709 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-e71cf11b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3710 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-e9cc87a2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3711 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f3d10dfe | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3712 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-c4577a41 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3713 |  | FLAG | dlData | null | 화면 필드/플래그 변경 |  |  |  |
| AC-53af9770 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3714 |  | FLAG | dlView | null | 화면 필드/플래그 변경 |  |  |  |

## FP01624_Mpp_Wpp.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0be533ad | this.Load | FP01624_Mpp_Wpp.cs:474 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-0be1dd24 | this.Load | FP01624_Mpp_Wpp.cs:475 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f21fb338 | this.Load | FP01624_Mpp_Wpp.cs:476 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f3c7b410 | this.Load | FP01624_Mpp_Wpp.cs:477 |  | UI_PROP | clbPlanRevision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01624_Mpp_Wpp.InitHeader

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbc64ee1 | this.Load | FP01624_Mpp_Wpp.cs:650 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-94cca93c | this.Load | FP01624_Mpp_Wpp.cs:652 |  | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-865cb64c | this.Load | FP01624_Mpp_Wpp.cs:653 |  | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c823852 | this.Load | FP01624_Mpp_Wpp.cs:654 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01624_Mpp_Wpp.InitPlanType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-800103c2 | this.Load | FP01624_Mpp_Wpp.cs:428 |  | FLAG | dtPlanType | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-1c1090ae | this.Load | FP01624_Mpp_Wpp.cs:429 |  | DATA_OP | dtPlanType.Columns.Add | (new DataColumn("CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-45d155fb | this.Load | FP01624_Mpp_Wpp.cs:430 |  | DATA_OP | dtPlanType.Columns.Add | (new DataColumn("NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-02863349 | this.Load | FP01624_Mpp_Wpp.cs:432 |  | DATA_OP | dtPlanType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-698be5a6 | this.Load | FP01624_Mpp_Wpp.cs:433 |  | DATA_OP | wpp["CODE"] | wpp["NAME"] = "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-a06bffc4 | this.Load | FP01624_Mpp_Wpp.cs:433 |  | DATA_OP | wpp["NAME"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-6428f63f | this.Load | FP01624_Mpp_Wpp.cs:434 |  | DATA_OP | dtPlanType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b0682812 | this.Load | FP01624_Mpp_Wpp.cs:435 |  | DATA_OP | mpp["CODE"] | mpp["NAME"] = "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-a9261c0b | this.Load | FP01624_Mpp_Wpp.cs:435 |  | DATA_OP | mpp["NAME"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-764ecadc | this.Load | FP01624_Mpp_Wpp.cs:436 |  | DATA_OP | dtPlanType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c60d7058 | this.Load | FP01624_Mpp_Wpp.cs:437 |  | DATA_OP | mrp["CODE"] | mrp["NAME"] = "MRP" | 행/컬럼 값 대입 |  |  |  |
| AC-2e2fad28 | this.Load | FP01624_Mpp_Wpp.cs:437 |  | DATA_OP | mrp["NAME"] | "MRP" | 행/컬럼 값 대입 |  |  |  |
| AC-5c635a2c | this.Load | FP01624_Mpp_Wpp.cs:438 |  | DATA_OP | dtPlanType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-99253cf7 | this.Load | FP01624_Mpp_Wpp.cs:439 |  | DATA_OP | wo["CODE"] | wo["NAME"] = "WO" | 행/컬럼 값 대입 |  |  |  |
| AC-91a05fce | this.Load | FP01624_Mpp_Wpp.cs:439 |  | DATA_OP | wo["NAME"] | "WO" | 행/컬럼 값 대입 |  |  |  |
| AC-77661563 | this.Load | FP01624_Mpp_Wpp.cs:441 |  | DATA_OP | dtPlanType.Rows.Add | (wpp) | 데이터 객체 조작/조회 |  |  |  |
| AC-af534ac2 | this.Load | FP01624_Mpp_Wpp.cs:442 |  | DATA_OP | dtPlanType.Rows.Add | (mpp) | 데이터 객체 조작/조회 |  |  |  |
| AC-45df0a76 | this.Load | FP01624_Mpp_Wpp.cs:443 |  | DATA_OP | dtPlanType.Rows.Add | (mrp) | 데이터 객체 조작/조회 |  |  |  |
| AC-74959df2 | this.Load | FP01624_Mpp_Wpp.cs:444 |  | DATA_OP | dtPlanType.Rows.Add | (wo) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d5f6feb | this.Load | FP01624_Mpp_Wpp.cs:445 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01624_Mpp_Wpp.InitSpread

진입점: this.Load / this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5527cd4c | this.Load 외 3 | FP01624_Mpp_Wpp.cs:519 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a0e3d2f | this.Load 외 3 | FP01624_Mpp_Wpp.cs:520 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMppWpp) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b9391422 | this.Load 외 3 | FP01624_Mpp_Wpp.cs:524 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP01624_Mpp_Wpp.initUOMType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d9472e3 | this.Load | FP01624_Mpp_Wpp.cs:450 |  | FLAG | dtUOMType | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-8b4bbe2f | this.Load | FP01624_Mpp_Wpp.cs:451 |  | DATA_OP | dtUOMType.Columns.Add | (new DataColumn("CODE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-35b8d086 | this.Load | FP01624_Mpp_Wpp.cs:452 |  | DATA_OP | dtUOMType.Columns.Add | (new DataColumn("NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bc28ba6 | this.Load | FP01624_Mpp_Wpp.cs:454 |  | DATA_OP | dtUOMType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7ddc34d7 | this.Load | FP01624_Mpp_Wpp.cs:455 |  | DATA_OP | item_uom["CODE"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-7867545f | this.Load | FP01624_Mpp_Wpp.cs:455 |  | DATA_OP | item_uom["NAME"] | "Item UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-8fc5746b | this.Load | FP01624_Mpp_Wpp.cs:456 |  | DATA_OP | dtUOMType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-29ccc1bf | this.Load | FP01624_Mpp_Wpp.cs:457 |  | DATA_OP | batch["CODE"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-2090ab0f | this.Load | FP01624_Mpp_Wpp.cs:457 |  | DATA_OP | batch["NAME"] | "Batch" | 행/컬럼 값 대입 |  |  |  |
| AC-916f85fa | this.Load | FP01624_Mpp_Wpp.cs:458 |  | DATA_OP | dtUOMType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e2d5cb2a | this.Load | FP01624_Mpp_Wpp.cs:459 |  | DATA_OP | pancake["CODE"] | "R" | 행/컬럼 값 대입 |  |  |  |
| AC-8f188df3 | this.Load | FP01624_Mpp_Wpp.cs:459 |  | DATA_OP | pancake["NAME"] | "Pancake" | 행/컬럼 값 대입 |  |  |  |
| AC-7252408b | this.Load | FP01624_Mpp_Wpp.cs:460 |  | DATA_OP | dtUOMType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-38ebdf91 | this.Load | FP01624_Mpp_Wpp.cs:461 |  | DATA_OP | jumboroll["CODE"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-74e4c2e9 | this.Load | FP01624_Mpp_Wpp.cs:461 |  | DATA_OP | jumboroll["NAME"] | "JimboRoll" | 행/컬럼 값 대입 |  |  |  |
| AC-27964823 | this.Load | FP01624_Mpp_Wpp.cs:463 |  | DATA_OP | dtUOMType.Rows.Add | (item_uom) | 데이터 객체 조작/조회 |  |  |  |
| AC-f88e3238 | this.Load | FP01624_Mpp_Wpp.cs:464 |  | DATA_OP | dtUOMType.Rows.Add | (batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1527b2d | this.Load | FP01624_Mpp_Wpp.cs:465 |  | DATA_OP | dtUOMType.Rows.Add | (pancake) | 데이터 객체 조작/조회 |  |  |  |
| AC-0dda87e4 | this.Load | FP01624_Mpp_Wpp.cs:466 |  | DATA_OP | dtUOMType.Rows.Add | (jumboroll) | 데이터 객체 조작/조회 |  |  |  |
| AC-aed269f9 | this.Load | FP01624_Mpp_Wpp.cs:467 |  | LIST_REBIND | clsCtrl.setListBox | (dtUOMType, cboUOM, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01624_Mpp_Wpp.MakeMemoBold

진입점: this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ if (monthInfo != null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ if (monthInfo != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ if (monthInfo != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a96f6ee7 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:633 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-f81abb12 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:637 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP01624_Mpp_Wpp.onMemoMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-434309d3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3589 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-02e1ea8b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3592 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a294d4a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3610 | if (day != null) | POPUP | new FPC0096_MemoEditPopup | (row, day, arg.Row, arg.Column) | 팝업/폼 생성 |  |  |  |
| AC-2c5b6475 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3611 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5a138d43 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3612 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01624_Mpp_Wpp.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f9ad412 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3625 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd536eaa | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3628 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0878b6e2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3646 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-632b8e34 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3647 | if (day != null) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-cefe3fa6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3647 | if (day != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a9dc6aa1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3648 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-de94ba57 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3649 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-454674e4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3650 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b549026d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3651 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01624_Mpp_Wpp.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaa63511 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3507 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4462faa3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3510 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1ff09bb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3534 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP01624_Mpp_Wpp.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42b00a96 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3548 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d51324bb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3551 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83002c9a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3575 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP01624_Mpp_Wpp.RefreshHeader

진입점: this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fdac5b0 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:558 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-9af00fe4 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:560 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79c76716 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:561 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0daa29c | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:562 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6403db1 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:567 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-8ae9a271 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:568 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-fcc638a5 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:569 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-7404003e | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:570 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-6b25b332 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:583 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, DateColumnType.DMPP, DateColumnType.DMPP, Date… | ⚠ 의미 확인 필요 |  |  |  |
| AC-90f9c344 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:591 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b73cc0ca | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:592 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8005488d | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:593 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-a6940685 | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:596 | if (monthInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1320d1ca | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:597 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01624_Mpp_Wpp.RefreshSpreadSheet

진입점: this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a488715b | this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ tr… 외 2 | FP01624_Mpp_Wpp.cs:881 |  | FLAG | dsMainFiltered | dsMain | 화면 필드/플래그 변경 |  |  |  |

## FP01624_Mpp_Wpp.ReleaseValidation2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-461f8928 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2749 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00590_RELEASE_P", "findReleaseValidtion_2", filterValidation.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findReleaseValidtion_2] \| FP\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fff99427 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2755 | if (ds_validation_out2.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("수량 적합성이 맞지 않습니다.") | 메시지 표시 |  |  |  |
| AC-75108482 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2769 |  | RETURN | return rtn; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.Run_execute_MES_ERP_WO_MASTER

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90440d7e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2723 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_confirmArea", filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_confirmArea] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7fd063c4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2733 |  | DATA_OP | filter["SITE_ID"] | popFilter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fbc7ec60 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2736 | if (objCA.Good() && objCA.Rows[0]["CONFIRM_AREA"].ToString() == "PLAN GROUP") | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP01624_MPPWPP", "update_hisDetail2", filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=update_hisDetail2] \| FP\Pla… | 엔드포인트 호출 |  |  |  |
| AC-c926aa26 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2738 | else of (objCA.Good() && objCA.Rows[0]["CONFIRM_AREA"].ToString() == "PLAN GROUP") | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP01624_MPPWPP", "update_hisDetail", filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=update_hisDetail] \| FP\Plan… | 엔드포인트 호출 |  |  |  |

## FP01624_Mpp_Wpp.Run_execute_MPPWPP_ACCUM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b39c0982 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2704 | if (dtHead.Good()) ▸ foreach (DataRow ro in dtHead.Rows) | ENDPOINT | DataService.FP_RunProcedure2 | ("FP01624_MPPWPP", "execute_MPPWPP_ACCUM", ro.Dictionary(), null, "Planning", 900 * 2, "P_… ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_MPPWPP_ACCUM] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-0c8c145d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2704 | if (dtHead.Good()) ▸ foreach (DataRow ro in dtHead.Rows) | ENDPOINT | ro.Dictionary | () ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_MPPWPP_ACCUM] \| FP\P… | 엔드포인트 호출 |  |  |  |

## FP01624_Mpp_Wpp.Run_getListNewRev

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dca7707 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2159 |  | FLAG | ds_newRev | DataService.FP_ExecuteProcedure2("PR_UI_FP01624_FIND_FP01624_NEWREVISION", ds_inRev, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-fc70561c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2159 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_FP01624_FIND_FP01624_NEWREVISION", ds_inRev, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP01624_Mpp_Wpp.Run_getListReleaseValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05d65fb2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2849 |  | DATA_OP | ds_releaseValidation["FACTORY_LT"] | ds_releaseValidation["FACTORY_LT"].Replace("'", "") | 행/컬럼 값 대입 |  |  |  |
| AC-1dbd73e6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2850 |  | FLAG | ds_releaseValidation_Out | DataService.FP_ExecuteProcedure2("PR_UI_FP01624_FINDRELEASEVALIDATION", ds_releaseValidati… | 화면 필드/플래그 변경 |  |  |  |
| AC-47f7526f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2851 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_FP01624_FINDRELEASEVALIDATION", ds_releaseValidation) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP01624_Mpp_Wpp.Run_getListReleaseValidation_or_getListReleaseValidation_planGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ca32cd5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2860 |  | DATA_OP | ds_head.getColumn | (0, "INSTANCE_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1a565e44 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2874 | for (i < ds_relPlan_out.Rows.Count) ▸ if (string.IsNullOrWhiteSpace(sPlan)) | DATA_OP | ds_relPlan_out.getColumn | (i, "PLAN_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a34be572 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2878 | for (i < ds_relPlan_out.Rows.Count) ▸ else of (string.IsNullOrWhiteSpace(sPlan)) | DATA_OP | ds_relPlan_out.getColumn | (i, "PLAN_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-db539e1a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2885 |  | CALL_EXT | ds_xif.setColumn | (0, "INSTANCE_ID", ds_head.getColumn(0, "INSTANCE_ID").ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-03d7fe27 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2885 |  | DATA_OP | ds_head.getColumn | (0, "INSTANCE_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-89b8e03c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2886 |  | CALL_EXT | ds_xif.setColumn | (0, "PLAN_DATE", ds_relPlan_out.getColumn(0, "PLAN_DATE").ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b22c0d1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2886 |  | DATA_OP | ds_relPlan_out.getColumn | (0, "PLAN_DATE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-132f08cc | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2887 |  | CALL_EXT | ds_xif.setColumn | (0, "PLAN_LT", sPlan) | ⚠ 의미 확인 필요 |  |  |  |
| AC-85d48a3e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2892 | if (!ReleaseValidation2(popup, ds_xif)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.Run_getListReleaseValidation_planGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45ce8880 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2836 |  | DATA_OP | ds_releaseValidation["FACTORY_LT"] | ds_releaseValidation["FACTORY_LT"].Replace("'", "") | 행/컬럼 값 대입 |  |  |  |
| AC-1869ee9f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2838 |  | FLAG | ds_releaseValidation_Out | DataService.FP_ExecuteProcedure2("PR_UI_FP01624_FINDRELEASEVALIDATION_PLANGROUP", ds_relea… | 화면 필드/플래그 변경 |  |  |  |
| AC-af652a39 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2839 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_FP01624_FINDRELEASEVALIDATION_PLANGROUP", ds_releaseValidation, "SQL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1126b274 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2841 |  | FLAG | ds_releaseValidation_Out | DataService.FP_ExecuteProcedure2("PR_UI_FP01624_FINDRELEASEVALIDATION_PLANGROUP", ds_relea… | 화면 필드/플래그 변경 |  |  |  |
| AC-95c30ebf | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2842 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_FP01624_FINDRELEASEVALIDATION_PLANGROUP", ds_releaseValidation) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP01624_Mpp_Wpp.Run_getListValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8bcc5c0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1404 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-81e4af16 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1405 | if (!dsExcelData.Columns.Contains("PLAN_DATE")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-edcd3aa4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1406 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f97a10a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1407 | if (!dsExcelData.Columns.Contains("PLAN_QTY")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-db28300d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1408 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-df7fb374 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1409 | if (!dsExcelData.Columns.Contains("PLAN_WEEK")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b271876 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1410 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_REVISION") | 데이터 객체 조작/조회 |  |  |  |
| AC-762e404d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1411 | if (!dsExcelData.Columns.Contains("PLAN_REVISION")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_REVISION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f51a6c6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1434 |  | DATA_OP | dsExcelData.Columns.Contains | ("_MSG") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb4137a0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1435 | if (!dsExcelData.Columns.Contains("_MSG")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("_MSG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-756dde17 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1436 |  | DATA_OP | dsExcelData.Columns.Contains | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b7d3fe8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1437 | if (!dsExcelData.Columns.Contains("_VALID")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("_VALID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-752d0f72 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1439 |  | DATA_OP | dsExcelData.Select | ("_VALID = 'N'") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba52dbe6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1442 | if (sels != null && sels.Length > 0) | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8ef21191 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1443 | if (sels != null && sels.Length > 0) | VALUE_SET | p.Text | "Invalid Data" | 컨트롤 값 설정 |  |  |  |
| AC-44262b24 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1444 | if (sels != null && sels.Length > 0) | UI_PROP | p.Filter | null | 속성 Filter 설정 |  |  |  |
| AC-ab51ef25 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1450 | if (sels != null && sels.Length > 0) | UI_PROP | p.DoSearchData | (a) => { DataSet l = new DataSet(); l.Tables.Add(dsExcelData.Select("_VALID = 'N'").CopyTo… | 속성 DoSearchData 설정 |  |  |  |
| AC-db62f91a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1453 | if (sels != null && sels.Length > 0) ▸ lambda | DATA_OP | l.Tables.Add | (dsExcelData.Select("_VALID = 'N'").CopyToDataTable<DataRow>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b534da1b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1453 | if (sels != null && sels.Length > 0) ▸ lambda | DATA_OP | dsExcelData.Select("_VALID = 'N'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-de86e5d3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1453 | if (sels != null && sels.Length > 0) ▸ lambda | DATA_OP | dsExcelData.Select | ("_VALID = 'N'") | 데이터 객체 조작/조회 |  |  |  |
| AC-31e64705 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1454 | if (sels != null && sels.Length > 0) ▸ lambda | RETURN | return l; |  | 처리 중단/반환 |  |  |  |
| AC-cac2bd2a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1456 | if (sels != null && sels.Length > 0) | UI_PROP | p.DoLineCheck | null | 속성 DoLineCheck 설정 |  |  |  |
| AC-dcc39f39 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1457 | if (sels != null && sels.Length > 0) | UI_PROP | p.DoSaveData | null | 속성 DoSaveData 설정 |  |  |  |
| AC-8d025316 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1458 | if (sels != null && sels.Length > 0) | UI_PROP | p.DoValidationData | null | 속성 DoValidationData 설정 |  |  |  |
| AC-70d5ec60 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1459 | if (sels != null && sels.Length > 0) | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a2a9cbee | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1460 | if (sels != null && sels.Length > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9410e43a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1471 | if (popFilter["WO"] == "Y") ▸ if (!Run_setValidation_LineAssign(popup)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ce00996 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1476 |  | UI_PROP | popup.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-17be3e64 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1485 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b653bef3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1486 | if (!dsExcelData.Columns.Contains("PLAN_DATE")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fad28494 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1487 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-680dfdf3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1488 | if (!dsExcelData.Columns.Contains("PLAN_QTY")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-054ffa82 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1489 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-03d56482 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1490 | if (!dsExcelData.Columns.Contains("PLAN_WEEK")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ee99fad | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1491 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_REVISION") | 데이터 객체 조작/조회 |  |  |  |
| AC-a68e9c6a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1492 | if (!dsExcelData.Columns.Contains("PLAN_REVISION")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_REVISION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-331fb48b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1494 |  | DATA_OP | dsExcelData.Columns.Contains | ("_MSG") | 데이터 객체 조작/조회 |  |  |  |
| AC-90af0d79 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1495 | if (!dsExcelData.Columns.Contains("_MSG")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("_MSG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fbe0ef33 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1496 |  | DATA_OP | dsExcelData.Columns.Contains | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-567c5cee | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1497 | if (!dsExcelData.Columns.Contains("_VALID")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("_VALID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c5e2302 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1499 |  | DATA_OP | dsExcelData.Select | ("_VALID = 'N'") | 데이터 객체 조작/조회 |  |  |  |
| AC-25dcd981 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1502 | if (sels != null && sels.Length > 0) | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-efe8903d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1503 | if (sels != null && sels.Length > 0) | VALUE_SET | p.Text | "Invalid Data" | 컨트롤 값 설정 |  |  |  |
| AC-3e0e5326 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1504 | if (sels != null && sels.Length > 0) | UI_PROP | p.Filter | null | 속성 Filter 설정 |  |  |  |
| AC-0a1942e5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1510 | if (sels != null && sels.Length > 0) | UI_PROP | p.DoSearchData | (a) => { DataSet l = new DataSet(); l.Tables.Add(dsExcelData.Select("_VALID = 'N'").CopyTo… | 속성 DoSearchData 설정 |  |  |  |
| AC-f686e59e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1513 | if (sels != null && sels.Length > 0) ▸ lambda | DATA_OP | l.Tables.Add | (dsExcelData.Select("_VALID = 'N'").CopyToDataTable<DataRow>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-5cbe79cd | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1513 | if (sels != null && sels.Length > 0) ▸ lambda | DATA_OP | dsExcelData.Select("_VALID = 'N'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3e6097d3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1513 | if (sels != null && sels.Length > 0) ▸ lambda | DATA_OP | dsExcelData.Select | ("_VALID = 'N'") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee5db524 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1514 | if (sels != null && sels.Length > 0) ▸ lambda | RETURN | return l; |  | 처리 중단/반환 |  |  |  |
| AC-68da0fab | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1516 | if (sels != null && sels.Length > 0) | UI_PROP | p.DoLineCheck | null | 속성 DoLineCheck 설정 |  |  |  |
| AC-8220c1be | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1517 | if (sels != null && sels.Length > 0) | UI_PROP | p.DoSaveData | null | 속성 DoSaveData 설정 |  |  |  |
| AC-233de7a7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1518 | if (sels != null && sels.Length > 0) | UI_PROP | p.DoValidationData | null | 속성 DoValidationData 설정 |  |  |  |
| AC-07033b5a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1519 | if (sels != null && sels.Length > 0) | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-57bc6a50 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1520 | if (sels != null && sels.Length > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f4f6b22 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1530 | if (popFilter["WO"] == "Y") | CALL_EXT | HardCodeService.MatchCodeFp | ("FP0164_Mpp_Wpp", "CHINA_WARNING", dsExcelData.Rows[0]["SITE_ID"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a14f7f1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1532 | if (popFilter["WO"] == "Y") ▸ if (HardCodeService.MatchCodeFp("FP0164_Mpp_Wpp", "CHINA_WARNING", dsExcelData.Rows[0]["SITE_ID"])) | MESSAGE | MessageBox.Show | ("Are you sure to upload plan?", "Waring upload plan", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-a453e759 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1534 | if (popFilter["WO"] == "Y") ▸ if (HardCodeService.MatchCodeFp("FP0164_Mpp_Wpp", "CHINA_WARNING", dsExcelData.Rows[0]["SITE_ID"])) ▸ if (Mess… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26145894 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1538 | if (popFilter["WO"] == "Y") ▸ if (!Run_setValidation_LineAssign(popup)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.Run_getListValidation_Apply

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43308092 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3104 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP01624_MPPWPP", "delete_Excel_buffer", popFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-61c0fa06 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3112 | foreach (DataRow row in saveData.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | CALL_BASE | GetDayColNameOfType | (day, popup.DateColumnType) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a81549d9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3114 | foreach (DataRow row in saveData.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | DATA_OP | row["PLAN_DATE"] | day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-3cce9482 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3115 | foreach (DataRow row in saveData.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | DATA_OP | row["PLAN_QTY"] | row[colname] | 행/컬럼 값 대입 |  |  |  |
| AC-878f5a5d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3116 | foreach (DataRow row in saveData.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | DATA_OP | row["PLAN_WEEK"] | popup.Filter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-65cb4fa2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3118 | foreach (DataRow row in saveData.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) ▸ if (string.IsNullOrWhiteSpac… | DATA_OP | row["PLAN_REVISION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e4ea6b54 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3131 | foreach (DataRow row in saveData.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP01624_MPPWPP", "insert_Excel_buffer", row.Dictionary(), "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=insert_Excel_buffer] \| FP\Plan… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c96a525f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3133 | foreach (DataRow row in saveData.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | CALL_EXT | row.Dictionary | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b14fbb22 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3142 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ try | DATA_OP | dtPlanWeek.Select | ("CODE ='" + popFilter["PLAN_WEEK"] + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8bd2ca53 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3143 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ try | DATA_OP | popFilter["_MIN_DATE_REAL"] | sMinDate2 | 행/컬럼 값 대입 |  |  |  |
| AC-1933a82d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3152 | else of (popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ try | DATA_OP | dtPlanMonth.Select | ("CODE ='" + popFilter["PLAN_MONTH"] + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-17e143f0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3153 | else of (popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ try | DATA_OP | popFilter["_MIN_DATE_REAL"] | sMinDate2 | 행/컬럼 값 대입 |  |  |  |
| AC-91ee80bb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3158 |  | POPUP | new FP01624_Apply_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-cdd2a653 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3159 |  | UI_PROP | applyPopup.Filter | popFilter | 속성 Filter 설정 |  |  |  |
| AC-6f979d26 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3160 |  | UI_PROP | applyPopup.Title | "Confirm" | 속성 Title 설정 |  |  |  |
| AC-f23470e5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3161 |  | DATA_OP | applyPopup.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-22fad098 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3162 |  | DATA_OP | applyPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-c14f8cc3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3163 |  | DATA_OP | applyPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-b11ce180 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3164 |  | DATA_OP | applyPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-55ffbdde | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3165 |  | DATA_OP | applyPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-9263c424 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3166 |  | DATA_OP | applyPopup.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-9d11d3d6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3167 |  | DATA_OP | applyPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-90fd6799 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3168 |  | DATA_OP | applyPopup.ColumnTitle["LINE"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-562697e8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3169 |  | DATA_OP | applyPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-a42eb83f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3170 |  | DATA_OP | applyPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-d852cfc7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3171 |  | DATA_OP | applyPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-69fa7af7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3172 |  | DATA_OP | applyPopup.ColumnTitle["PRODUCTION_TYPE"] | "Production Type" | 행/컬럼 값 대입 |  |  |  |
| AC-2c913f31 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3173 |  | DATA_OP | applyPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-001fe298 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3174 |  | UI_PROP | applyPopup.DateColumnType | DateColumnType.DMPP | 속성 DateColumnType 설정 |  |  |  |
| AC-52d3d89e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3175 |  | UI_PROP | applyPopup.DoSearchData | (f, a) => { { DataTable dtBucket = DataService.FP_ExecuteQuery2("FP00602_PlanAmendLineAssy… | 속성 DoSearchData 설정 |  |  |  |
| AC-82359242 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3179 | lambda | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00602_PlanAmendLineAssy", "find_bukInfo", popFilter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5415ff2a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3191 | lambda | DATA_OP | popFilter["BUCKET_SQL"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-53d03555 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3203 | lambda ▸ if (ds_newRev.Good()) ▸ foreach (DataRow row in ds_newRev.Rows) ▸ else of (first) | DATA_OP | revList.Contains | (revLine) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bb637b9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3208 | lambda | DATA_OP | popFilter["REV_LIST"] | revList | 행/컬럼 값 대입 |  |  |  |
| AC-e5c1a633 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3209 | lambda | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01624_MPPWPP", "find_saveConfirm", popFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveConfirm] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c9264fd6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3210 | lambda | FLAG | dt_pastInfo | DataService.FP_ExecuteQuery2("FP01624_MPPWPP", "find_saveConfirm_Data", popFilter.Dictiona… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveConfirm_Data] \| FP\Pl… | 화면 필드/플래그 변경 |  |  |  |
| AC-25d4c99c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3210 | lambda | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_saveConfirm_Data", popFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveConfirm_Data] \| FP\Pl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-73546e38 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3211 | lambda | RETURN | return s; |  | 처리 중단/반환 |  |  |  |
| AC-f697d63e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3213 |  | POPUP | applyPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1fc4cb9d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3217 | if (applyPopup.DialogResult != DialogResult.OK) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-772c5ed1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3222 | if (ds_newRev.Good()) | DATA_OP | ds_newRev.Columns.Contains | ("SELECT_LIST") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed7922c1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3223 | if (ds_newRev.Good()) ▸ if (!ds_newRev.Columns.Contains("SELECT_LIST")) | DATA_OP | ds_newRev.Columns.Add | (new DataColumn("SELECT_LIST", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |

## FP01624_Mpp_Wpp.Run_getListValidation_LineAssign

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74a35ad6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1552 |  | DATA_OP | column_params.Add | ("USER_ID", CurrentUser) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e309e20 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1555 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP01624_MPPWPP", "delete_Excel_buffer_lineAssign", column_params, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer_lineAssi… | 엔드포인트 호출 |  |  |  |
| AC-e65f0342 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1559 |  | DATA_OP | ds_assignValid_in.Columns.Contains | ("PLAN_MONTH") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f62a6f6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1560 | if (!ds_assignValid_in.Columns.Contains("PLAN_MONTH")) | DATA_OP | ds_assignValid_in.Columns.Add | ("PLAN_MONTH") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d1a1e28 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1567 |  | ENDPOINT | DataService.FP_UpdateBatch2 | ( "FP01624_MPPWPP", "insert_Excel_buffer_lineAssign", ds_assignValid_in, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer_lineAssign] … | 엔드포인트 호출 |  |  |  |
| AC-af6d15a8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1572 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_Excel_buffer_validation_lineAssign", column_params, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation_li… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-636cc292 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1574 |  | RETURN | return ds_assignValid; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.Run_saveAll_PostInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fb50e94 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2921 | if (!ds_newRev.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30f08118 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2922 |  | DATA_OP | ds_newRev.Columns.Contains | ("SELECT_LIST") | 데이터 객체 조작/조회 |  |  |  |
| AC-7aab6400 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2923 | if (!ds_newRev.Columns.Contains("SELECT_LIST")) | DATA_OP | ds_newRev.Columns.Add | (new DataColumn("SELECT_LIST", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-53100e3c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2951 | if (!ds_newRev.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a142a466 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2955 |  | DATA_OP | set["SELECT_LIST"] | slist | 행/컬럼 값 대입 |  |  |  |
| AC-2de04a07 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2956 |  | DATA_OP | set["PLAN_WEEK"] | popup.Filter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-a9f72460 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2957 |  | DATA_OP | set["REV_TYPE"] | popup.Filter["REV_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2e3a86ae | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2958 |  | DATA_OP | set["BUCKET_TO"] | popup.Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-c325a926 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2959 |  | DATA_OP | set["USER_ID"] | popup.Filter["USER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6119de21 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2960 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP01624_MPPWPP", "insert_PostInfo", set.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=insert_PostInfo] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-58f55d12 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2967 | if (!ds_newRev.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b90ee10b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2968 |  | DATA_OP | ds_newRev.Columns.Contains | ("SELECT_LIST") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf1aea99 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2969 | if (!ds_newRev.Columns.Contains("SELECT_LIST")) | DATA_OP | ds_newRev.Columns.Add | (new DataColumn("SELECT_LIST", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c934a64 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2997 | if (!ds_newRev.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10382533 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3001 |  | DATA_OP | set["SELECT_LIST"] | slist | 행/컬럼 값 대입 |  |  |  |
| AC-64eb89ce | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3002 |  | DATA_OP | set["PLAN_WEEK"] | popup.Filter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-92883609 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3003 |  | DATA_OP | set["REV_TYPE"] | popup.Filter["REV_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f175d31d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3004 |  | DATA_OP | set["BUCKET_TO"] | popup.Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-c2c1982b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3005 |  | DATA_OP | set["USER_ID"] | popup.Filter["USER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-365ce1fb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3006 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP01624_MPPWPP", "insert_PostInfo", set.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=insert_PostInfo] \| FP\Plann… | 엔드포인트 호출 |  |  |  |

## FP01624_Mpp_Wpp.Run_saveAll_UOM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ce21426 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2353 | if (popFilter == null) | THROW | throw new Exception("error"); |  | 예외 발생 |  |  |  |
| AC-449c5284 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2358 | if (ds_newRev.Good()) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01624_MPPWPP", "update_UOM", ds_newRev, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_UOM] \| FP\Planning\FP016… | 엔드포인트 호출 |  |  |  |
| AC-1481d627 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2368 | if (popFilter["WO"] == "Y") ▸ if (ds_release == null) | FLAG | ds_release | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-bb23d9f4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2369 | if (popFilter["WO"] == "Y") ▸ if (ds_release == null) | UI_PROP | ds_release.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-265eebe0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2373 | if (popFilter["WO"] == "Y") ▸ else of (ds_release == null) | STATE_RESET | ds_release.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-d7928f8f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2375 | if (popFilter["WO"] == "Y") | DATA_OP | ds_release.Columns.Contains | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e2f4b81 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2376 | if (popFilter["WO"] == "Y") ▸ if (!ds_release.Columns.Contains("PLAN_WEEK")) | DATA_OP | ds_release.Columns.Add | (new DataColumn("PLAN_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0955d6cc | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2377 | if (popFilter["WO"] == "Y") | DATA_OP | ds_release.Columns.Contains | ("PLAN_REVISION") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ffd54b2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2378 | if (popFilter["WO"] == "Y") ▸ if (!ds_release.Columns.Contains("PLAN_REVISION")) | DATA_OP | ds_release.Columns.Add | (new DataColumn("PLAN_REVISION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-661aa9e0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2379 | if (popFilter["WO"] == "Y") | DATA_OP | ds_release.Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dfb0f08d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2380 | if (popFilter["WO"] == "Y") ▸ if (!ds_release.Columns.Contains("INSTANCE_ID")) | DATA_OP | ds_release.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e392ce50 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2381 | if (popFilter["WO"] == "Y") | DATA_OP | ds_release.Columns.Contains | ("PLAN_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e5219d8f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2382 | if (popFilter["WO"] == "Y") ▸ if (!ds_release.Columns.Contains("PLAN_GROUP_ID")) | DATA_OP | ds_release.Columns.Add | (new DataColumn("PLAN_GROUP_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d8d53bb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2383 | if (popFilter["WO"] == "Y") | DATA_OP | ds_release.Columns.Contains | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2dc1ac4b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2384 | if (popFilter["WO"] == "Y") ▸ if (!ds_release.Columns.Contains("FACTORY_ID")) | DATA_OP | ds_release.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bbc3bda | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2392 | if (popFilter["WO"] == "Y") ▸ foreach (DataRow hRow in ds_head.Rows) | DATA_OP | ds_release.Select | (find_cond) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d04d9c1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2398 | if (popFilter["WO"] == "Y") ▸ foreach (DataRow hRow in ds_head.Rows) ▸ if (find_res == null \|\| find_res.Length < 1) | DATA_OP | ds_release.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a898ce02 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2399 | if (popFilter["WO"] == "Y") ▸ foreach (DataRow hRow in ds_head.Rows) ▸ if (find_res == null \|\| find_res.Length < 1) | DATA_OP | nRowTmp["PLAN_WEEK"] | hRow["PLAN_WEEK"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a01fb26d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2400 | if (popFilter["WO"] == "Y") ▸ foreach (DataRow hRow in ds_head.Rows) ▸ if (find_res == null \|\| find_res.Length < 1) | DATA_OP | nRowTmp["PLAN_REVISION"] | hRow["PLAN_REVISION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f1ab377e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2401 | if (popFilter["WO"] == "Y") ▸ foreach (DataRow hRow in ds_head.Rows) ▸ if (find_res == null \|\| find_res.Length < 1) | DATA_OP | nRowTmp["INSTANCE_ID"] | instance | 행/컬럼 값 대입 |  |  |  |
| AC-18f68a12 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2402 | if (popFilter["WO"] == "Y") ▸ foreach (DataRow hRow in ds_head.Rows) ▸ if (find_res == null \|\| find_res.Length < 1) | DATA_OP | nRowTmp["PLAN_GROUP_ID"] | hRow["PLAN_GROUP_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d51271e5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2403 | if (popFilter["WO"] == "Y") ▸ foreach (DataRow hRow in ds_head.Rows) ▸ if (find_res == null \|\| find_res.Length < 1) | DATA_OP | nRowTmp["FACTORY_ID"] | hRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aedd9539 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2407 | if (popFilter["WO"] == "Y") ▸ foreach (DataRow hRow in ds_head.Rows) ▸ if (find_res == null \|\| find_res.Length < 1) ▸ if (hRow["PLAN_GROUP… | DATA_OP | nRowTmp["PLAN_GROUP_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-ab5b31db | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2409 | if (popFilter["WO"] == "Y") ▸ foreach (DataRow hRow in ds_head.Rows) ▸ if (find_res == null \|\| find_res.Length < 1) ▸ else of (hRow["PLAN_… | DATA_OP | nRowTmp["FACTORY_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-4d49d26b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2410 | if (popFilter["WO"] == "Y") ▸ foreach (DataRow hRow in ds_head.Rows) ▸ if (find_res == null \|\| find_res.Length < 1) | DATA_OP | ds_release.Rows.Add | (nRowTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9bdbd40 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2418 | if (popFilter["WO"] == "Y") | DATA_OP | ds_release.Columns.Contains | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd799110 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2419 | if (popFilter["WO"] == "Y") ▸ if (!ds_release.Columns.Contains("PLAN_DATE")) | DATA_OP | ds_release.Columns.Add | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-296b8a6d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2420 | if (popFilter["WO"] == "Y") | DATA_OP | ds_release.Columns.Contains | ("INSTANCE_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2704dd23 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2421 | if (popFilter["WO"] == "Y") ▸ if (!ds_release.Columns.Contains("INSTANCE_DATE")) | DATA_OP | ds_release.Columns.Add | ("INSTANCE_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab816bbf | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2422 | if (popFilter["WO"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_toDayValue", nullFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_toDayValue] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0b7b16ad | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2434 | if (popFilter["WO"] == "Y") ▸ if (popFilter !=null) | DATA_OP | RevFilter["PLAN_WEEK"] | popFilter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-ce70b26c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2445 | if (popFilter["WO"] == "Y") ▸ if (ds_release.Good()) ▸ foreach (DataRow eachRelease in ds_release.Rows) | DATA_OP | eachRelease["PLAN_DATE"] | today | 행/컬럼 값 대입 |  |  |  |
| AC-3c16f538 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2447 | if (popFilter["WO"] == "Y") ▸ if (ds_release.Good()) ▸ foreach (DataRow eachRelease in ds_release.Rows) ▸ if (RevFilter["PLAN_WEEK"] == "") | DATA_OP | RevFilter["PLAN_WEEK"] | eachRelease["PLAN_WEEK"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0c70bf13 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2449 | if (popFilter["WO"] == "Y") ▸ if (ds_release.Good()) ▸ foreach (DataRow eachRelease in ds_release.Rows) ▸ if (RevFilter["FACTORY_ID"] == "") | DATA_OP | RevFilter["FACTORY_ID"] | eachRelease["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2cb54fe5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2451 | if (popFilter["WO"] == "Y") ▸ if (ds_release.Good()) ▸ foreach (DataRow eachRelease in ds_release.Rows) ▸ if (RevFilter["INSTANCE_DATE"] == … | DATA_OP | RevFilter["INSTANCE_DATE"] | eachRelease["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ec0047f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2453 | if (popFilter["WO"] == "Y") ▸ if (ds_release.Good()) ▸ foreach (DataRow eachRelease in ds_release.Rows) | DATA_OP | eachRelease["INSTANCE_DATE"] | eachRelease["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-42279ead | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2458 | if (popFilter["WO"] == "Y") ▸ if (ds_release.Good()) ▸ foreach (DataRow eachRelease in ds_release.Rows) ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP01624_MPPWPP", "executeReleaseProcess_WO", eachRelease.Dictionary(), null, "Planning",… ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeReleaseProcess_WO] \| … | 엔드포인트 호출 |  |  |  |
| AC-288ed6d7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2458 | if (popFilter["WO"] == "Y") ▸ if (ds_release.Good()) ▸ foreach (DataRow eachRelease in ds_release.Rows) ▸ try | ENDPOINT | eachRelease.Dictionary | () ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeReleaseProcess_WO] \| … | 엔드포인트 호출 |  |  |  |
| AC-458bbff0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2459 | if (popFilter["WO"] == "Y") ▸ if (ds_release.Good()) ▸ foreach (DataRow eachRelease in ds_release.Rows) ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP01624_MPPWPP", "executeSendResult_WO", eachRelease.Dictionary(), null, "Planning", 60 … ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeSendResult_WO] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-ac2aa448 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2459 | if (popFilter["WO"] == "Y") ▸ if (ds_release.Good()) ▸ foreach (DataRow eachRelease in ds_release.Rows) ▸ try | ENDPOINT | eachRelease.Dictionary | () ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeSendResult_WO] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-bdd7916f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2464 | if (popFilter["WO"] == "Y") ▸ if (ds_release.Good()) ▸ foreach (DataRow eachRelease in ds_release.Rows) ▸ catch ((Exception eee)) | THROW | throw new Exception("error"); |  | 예외 발생 |  |  |  |
| AC-93092747 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2483 | if (popFilter["WO"] == "Y") | DATA_OP | RevFilter["PLAN_REVISION"] | sRel | 행/컬럼 값 대입 |  |  |  |
| AC-e387ec79 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2486 | if (popFilter["WO"] == "Y") | FLAG | ds_relPlan_out | DataService.FP_ExecuteQuery2("FP01624_MPPWPP", "find_ReleasePlanList", RevFilter.Dictionar… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ReleasePlanList] \| FP\Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-e14fff8e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2486 | if (popFilter["WO"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_ReleasePlanList", RevFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ReleasePlanList] \| FP\Pla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cf3cc15c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2492 | if (popFilter["WO"] == "Y") ▸ if (!ds_relPlan_out.Good()) | THROW | throw new Exception("Plan revision not registered normaly"); |  | 예외 발생 |  |  |  |

## FP01624_Mpp_Wpp.Run_saveAllHead

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98e2bdb3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2164 |  | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01624_MPPWPP", "insert_FP01624_head", ds_head, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_FP01624_head] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-ccc7900e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2171 |  | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01624_MPPWPP", "saveAll_FP01624_head_row", ds_head, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP01624_head_row] \| FP\… | 엔드포인트 호출 |  |  |  |

## FP01624_Mpp_Wpp.Run_setReleaseValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc4dc8ac | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2778 | if (ds_newRev.Good()) ▸ for (i < ds_newRev.Rows.Count) | DATA_OP | ds_newRev.getColumn | (i, "FACTORY_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0ad683ff | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2780 | if (ds_newRev.Good()) ▸ for (i < ds_newRev.Rows.Count) | DATA_OP | sFac.Contains | (sFacTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-9eaca1f4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2790 |  | DATA_OP | ds_head.getColumn | (0, "INSTANCE_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-98be9136 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2797 |  | CALL_EXT | ds_releaseValidation.setColumn | (0, "INSTANCE_ID", sInst) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78413c82 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2798 |  | CALL_EXT | ds_releaseValidation.setColumn | (0, "PLAN_DATE", ds_relPlan_out.getColumn(0, "PLAN_DATE").ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4774030 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2798 |  | DATA_OP | ds_relPlan_out.getColumn | (0, "PLAN_DATE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-18757296 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2800 |  | CALL_EXT | ds_releaseValidation.setColumn | (0, "FACTORY_LT", sFac) | ⚠ 의미 확인 필요 |  |  |  |
| AC-21ddfaa5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2803 |  | DATA_OP | ds_head.getColumn | (0, "FACTORY_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3247b779 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2810 | if (ds_head.getColumn(0, "FACTORY_ID").ToString() == "-") ▸ if (ds_newRev.Good()) ▸ for (i < ds_newRev.Rows.Count) | DATA_OP | ds_newRev.getColumn | (i, "PLAN_GROUP_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-de059b02 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2812 | if (ds_head.getColumn(0, "FACTORY_ID").ToString() == "-") ▸ if (ds_newRev.Good()) ▸ for (i < ds_newRev.Rows.Count) | DATA_OP | sFac.Contains | (sFacTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c2d5c52 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2828 |  | RETURN | return ds_releaseValidation_Out; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.Run_setSaveProcess

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3add3cd | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1695 |  | DATA_OP | ds_facList.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f42ecb51 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1696 |  | DATA_OP | ds_facList.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-702b8938 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1697 |  | DATA_OP | ds_facList.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-aabd967d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1710 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ if (idx == 0) | DATA_OP | ds_facList.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cf46a853 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1711 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ if (idx == 0) | DATA_OP | factRow["FACTORY_ID"] | factTmp | 행/컬럼 값 대입 |  |  |  |
| AC-6a213fb6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1712 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ if (idx == 0) | DATA_OP | factRow["OPERATION_ID"] | OprTmp | 행/컬럼 값 대입 |  |  |  |
| AC-65a0c02a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1713 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ if (idx == 0) | DATA_OP | factRow["LINE_ID"] | LineTmp | 행/컬럼 값 대입 |  |  |  |
| AC-d984c434 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1714 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ if (idx == 0) | DATA_OP | ds_facList.Rows.Add | (factRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3266b341 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1719 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) | DATA_OP | ds_facList.Select | (find_cond) | 데이터 객체 조작/조회 |  |  |  |
| AC-b760cd03 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1722 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) ▸ if (finder == null \|\| finder.Length < 1) | DATA_OP | ds_facList.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-777f03d8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1723 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) ▸ if (finder == null \|\| finder.Length < 1) | DATA_OP | factRow["FACTORY_ID"] | factTmp | 행/컬럼 값 대입 |  |  |  |
| AC-00d150e6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1724 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) ▸ if (finder == null \|\| finder.Length < 1) | DATA_OP | factRow["OPERATION_ID"] | OprTmp | 행/컬럼 값 대입 |  |  |  |
| AC-3717d6f7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1725 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) ▸ if (finder == null \|\| finder.Length < 1) | DATA_OP | factRow["LINE_ID"] | LineTmp | 행/컬럼 값 대입 |  |  |  |
| AC-1924f2b2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1726 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) ▸ if (finder == null \|\| finder.Length < 1) | DATA_OP | ds_facList.Rows.Add | (factRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ccacf13 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1765 |  | DATA_OP | ds_inRev["PLAN_WEEK"] | popFilter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-7ba3b0ee | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1766 |  | DATA_OP | ds_inRev["PLAN_REVISION"] | sRevType | 행/컬럼 값 대입 |  |  |  |
| AC-aad1b096 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1767 |  | DATA_OP | ds_inRev["FACTORY_ID"] | sFac | 행/컬럼 값 대입 |  |  |  |
| AC-ca18846d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1768 |  | DATA_OP | ds_inRev["OPERATION_ID"] | sOpr | 행/컬럼 값 대입 |  |  |  |
| AC-06246c42 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1769 |  | DATA_OP | ds_inRev["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-c9facb6e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1770 |  | DATA_OP | ds_inRev["SUB_INFO"] | subInfo | 행/컬럼 값 대입 |  |  |  |
| AC-d4a5a183 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1776 |  | FLAG | ds_head | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-37169925 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1777 |  | UI_PROP | ds_head.TableName | "Table1" | 속성 TableName 설정 |  |  |  |
| AC-b6f1edf0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1778 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLAN_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-69c0a6e4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1779 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLAN_REVISION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-df727de1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1780 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2209591c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1781 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7258329a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1782 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6cb35af6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1783 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5b6d81d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1784 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c3df8b4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1785 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ddf733f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1786 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("WPP", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d67269fc | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1787 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("MPP", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-99e4f908 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1788 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("MRP", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a7ffea4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1789 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("WO", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-53e3f250 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1790 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLAN_DESCRIPTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-973fd378 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1791 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLAN_MONTH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1860356b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1792 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLAN_GROUP_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-680dc6e2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1803 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (idx == 0) | DATA_OP | ds_head.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a6f7eb9b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1808 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ else of (idx == 0) | CALL_EXT | ds_head.findRow | ("PLAN_REVISION", newRevRow["NEW_PLAN_REVISION"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e9801bc | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1810 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ else of (idx == 0) ▸ if (finded == null \|\| finded.Length < 1) | DATA_OP | ds_head.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7fe56c1a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1817 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLAN_WEEK"] | popFilter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-32806a0d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1818 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLAN_REVISION"] | newRevRow["NEW_PLAN_REVISION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eaa1f9cd | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1819 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["COMPANY_ID"] | newRevRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ec52732b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1820 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["DIVISION_ID"] | newRevRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8f4d2b42 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1821 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["SITE_ID"] | newRevRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b5275ae2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1822 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLANT_ID"] | newRevRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-79dd0da7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1823 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["FACTORY_ID"] | newRevRow["PLAN_GROUP_ID"].ToString() == "-" ? newRevRow["FACTORY_ID"].ToString() : "-" | 행/컬럼 값 대입 |  |  |  |
| AC-f1a79ffe | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1824 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["INSTANCE_ID"] | newRevRow["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a401be59 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1825 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["WPP"] | popFilter["WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-cc3a70cd | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1826 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["MPP"] | popFilter["MPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-2831c8d3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1827 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["MRP"] | popFilter["MRP"] | 행/컬럼 값 대입 |  |  |  |
| AC-36e84616 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1828 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["WO"] | popFilter["WO"] | 행/컬럼 값 대입 |  |  |  |
| AC-e1e9e47c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1829 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLAN_DESCRIPTION"] | popFilter["PLAN_DESCRIPTION"] | 행/컬럼 값 대입 |  |  |  |
| AC-8556a81b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1830 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLAN_MONTH"] | popFilter["PLAN_MONTH"] | 행/컬럼 값 대입 |  |  |  |
| AC-403a772e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1831 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLAN_GROUP_ID"] | newRevRow["PLAN_GROUP_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1e26a0e4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1832 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | ds_head.Rows.Add | (nHeadRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd79ec5c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1838 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0d6217f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1839 | if (!dsExcelData.Columns.Contains("PLAN_WEEK")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-474ff0d3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1840 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_REVISION") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e0ea7c7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1841 | if (!dsExcelData.Columns.Contains("PLAN_REVISION")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_REVISION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ade361b4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1850 | foreach (DataRow mRow in dsExcelData.Rows) ▸ if (ds_newRev.Good()) | DATA_OP | ds_newRev.Select | (findRowExpor) | 데이터 객체 조작/조회 |  |  |  |
| AC-f34b1a60 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1859 | foreach (DataRow mRow in dsExcelData.Rows) ▸ if (!string.IsNullOrWhiteSpace(sRev)) | DATA_OP | mRow["PLAN_WEEK"] | popFilter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-0c74c1c2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1860 | foreach (DataRow mRow in dsExcelData.Rows) ▸ if (!string.IsNullOrWhiteSpace(sRev)) | DATA_OP | mRow["PLAN_REVISION"] | sRev | 행/컬럼 값 대입 |  |  |  |
| AC-53ad2c14 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1871 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ for (i < ds_head.Rows.Count) ▸ if (sFacList == "… | DATA_OP | ds_head.getColumn | (i, "FACTORY_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4a7a9f7e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1872 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ for (i < ds_head.Rows.Count) ▸ else of (sFacList… | DATA_OP | ds_head.getColumn | (i, "FACTORY_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-95a652f2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1875 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | popFilter["REV_TYPE"] | sRevType | 행/컬럼 값 대입 |  |  |  |
| AC-ec535743 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1876 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | popFilter["TARGET_FACTORY"] | sFacList | 행/컬럼 값 대입 |  |  |  |
| AC-d2014ebb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1877 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | popFilter["TARGET_FAC"] | popFilter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-77e4400e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1878 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | popFilter["_MIN_DATE"] | popFilter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-12ce1616 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1900 |  | DATA_OP | ds_facList.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b840e728 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1901 |  | DATA_OP | ds_facList.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb011d32 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1902 |  | DATA_OP | ds_facList.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3be31b2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1915 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ if (idx == 0) | DATA_OP | ds_facList.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e407fa21 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1916 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ if (idx == 0) | DATA_OP | factRow["FACTORY_ID"] | factTmp | 행/컬럼 값 대입 |  |  |  |
| AC-ac4d2ca2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1917 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ if (idx == 0) | DATA_OP | factRow["OPERATION_ID"] | OprTmp | 행/컬럼 값 대입 |  |  |  |
| AC-a0c6c4ff | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1918 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ if (idx == 0) | DATA_OP | factRow["LINE_ID"] | LineTmp | 행/컬럼 값 대입 |  |  |  |
| AC-fc4a18f2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1919 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ if (idx == 0) | DATA_OP | ds_facList.Rows.Add | (factRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cd29b68 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1924 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) | DATA_OP | ds_facList.Select | (find_cond) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd7be082 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1927 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) ▸ if (finder == null \|\| finder.Length < 1) | DATA_OP | ds_facList.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-353fa0e1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1928 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) ▸ if (finder == null \|\| finder.Length < 1) | DATA_OP | factRow["FACTORY_ID"] | factTmp | 행/컬럼 값 대입 |  |  |  |
| AC-b2b02c59 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1929 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) ▸ if (finder == null \|\| finder.Length < 1) | DATA_OP | factRow["OPERATION_ID"] | OprTmp | 행/컬럼 값 대입 |  |  |  |
| AC-8ee0f722 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1930 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) ▸ if (finder == null \|\| finder.Length < 1) | DATA_OP | factRow["LINE_ID"] | LineTmp | 행/컬럼 값 대입 |  |  |  |
| AC-f16e8ee1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1931 | foreach (DataRow mainRow in dsExcelData.Rows) ▸ else of (idx == 0) ▸ if (finder == null \|\| finder.Length < 1) | DATA_OP | ds_facList.Rows.Add | (factRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-54a9408f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1970 |  | DATA_OP | ds_inRev["PLAN_WEEK"] | popFilter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-270b5b74 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1971 |  | DATA_OP | ds_inRev["PLAN_REVISION"] | sRevType | 행/컬럼 값 대입 |  |  |  |
| AC-da5683b5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1972 |  | DATA_OP | ds_inRev["FACTORY_ID"] | sFac | 행/컬럼 값 대입 |  |  |  |
| AC-9d436bd7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1973 |  | DATA_OP | ds_inRev["OPERATION_ID"] | sOpr | 행/컬럼 값 대입 |  |  |  |
| AC-dcd7abab | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1974 |  | DATA_OP | ds_inRev["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-0ab7a6c2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1975 |  | DATA_OP | ds_inRev["SUB_INFO"] | subInfo | 행/컬럼 값 대입 |  |  |  |
| AC-623f17ce | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1981 |  | FLAG | ds_head | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-fb433156 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1982 |  | UI_PROP | ds_head.TableName | "Table1" | 속성 TableName 설정 |  |  |  |
| AC-6d1ac5dc | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1983 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLAN_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-84029933 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1984 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLAN_REVISION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bea2d163 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1985 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-936d060d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1986 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-41767ea0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1987 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2218853 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1988 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8e67522 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1989 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f00e60d9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1990 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1089c50a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1991 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("WPP", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-af571d61 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1992 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("MPP", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-18bff364 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1993 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("MRP", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-22ad2dfa | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1994 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("WO", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-44ddfe94 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1995 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLAN_DESCRIPTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f5619ef | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1996 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLAN_MONTH", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-64b0846e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1997 |  | DATA_OP | ds_head.Columns.Add | (new DataColumn("PLAN_GROUP_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-08d267ba | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2008 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (idx == 0) | DATA_OP | ds_head.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f63f395 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2013 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ else of (idx == 0) | CALL_EXT | ds_head.findRow | ("PLAN_REVISION", newRevRow["NEW_PLAN_REVISION"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a64ea61d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2015 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ else of (idx == 0) ▸ if (finded == null \|\| finded.Length < 1) | DATA_OP | ds_head.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6012b4f7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2022 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLAN_WEEK"] | popFilter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-bb55b513 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2023 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLAN_REVISION"] | newRevRow["NEW_PLAN_REVISION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d730968 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2024 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["COMPANY_ID"] | newRevRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3480415a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2025 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["DIVISION_ID"] | newRevRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dac9aeb5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2026 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["SITE_ID"] | newRevRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c7ddb32c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2027 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLANT_ID"] | newRevRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4cea1a19 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2028 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["FACTORY_ID"] | newRevRow["PLAN_GROUP_ID"].ToString() == "-" ? newRevRow["FACTORY_ID"].ToString() : "-" | 행/컬럼 값 대입 |  |  |  |
| AC-b6355d87 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2029 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["INSTANCE_ID"] | newRevRow["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9a2a30a2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2030 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["WPP"] | popFilter["WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-50221b09 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2031 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["MPP"] | popFilter["MPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-a9a3d2d5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2032 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["MRP"] | popFilter["MRP"] | 행/컬럼 값 대입 |  |  |  |
| AC-5e06e8a9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2033 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["WO"] | popFilter["WO"] | 행/컬럼 값 대입 |  |  |  |
| AC-fea8c7cc | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2034 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLAN_DESCRIPTION"] | popFilter["PLAN_DESCRIPTION"] | 행/컬럼 값 대입 |  |  |  |
| AC-26e43e4a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2035 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLAN_MONTH"] | popFilter["PLAN_MONTH"] | 행/컬럼 값 대입 |  |  |  |
| AC-26ee22a0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2036 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | nHeadRow["PLAN_GROUP_ID"] | newRevRow["PLAN_GROUP_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0e87c93e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2037 | if (ds_newRev.Good()) ▸ foreach (DataRow newRevRow in ds_newRev.Rows) ▸ if (nHeadRow != null) | DATA_OP | ds_head.Rows.Add | (nHeadRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7b8518a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2043 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-133106cf | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2044 | if (!dsExcelData.Columns.Contains("PLAN_WEEK")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-af636655 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2045 |  | DATA_OP | dsExcelData.Columns.Contains | ("PLAN_REVISION") | 데이터 객체 조작/조회 |  |  |  |
| AC-c990e9a1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2046 | if (!dsExcelData.Columns.Contains("PLAN_REVISION")) | DATA_OP | dsExcelData.Columns.Add | (new DataColumn("PLAN_REVISION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a618045b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2055 | foreach (DataRow mRow in dsExcelData.Rows) ▸ if (ds_newRev.Good()) | DATA_OP | ds_newRev.Select | (findRowExpor) | 데이터 객체 조작/조회 |  |  |  |
| AC-9247e83c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2064 | foreach (DataRow mRow in dsExcelData.Rows) ▸ if (!string.IsNullOrWhiteSpace(sRev)) | DATA_OP | mRow["PLAN_WEEK"] | popFilter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-d4a67d3f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2065 | foreach (DataRow mRow in dsExcelData.Rows) ▸ if (!string.IsNullOrWhiteSpace(sRev)) | DATA_OP | mRow["PLAN_REVISION"] | sRev | 행/컬럼 값 대입 |  |  |  |
| AC-37a58aef | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2076 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ for (i < ds_head.Rows.Count) ▸ if (sFacList == "… | DATA_OP | ds_head.getColumn | (i, "FACTORY_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-99ec6388 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2077 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ for (i < ds_head.Rows.Count) ▸ else of (sFacList… | DATA_OP | ds_head.getColumn | (i, "FACTORY_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f4a30cf7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2080 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | popFilter["REV_TYPE"] | sRevType | 행/컬럼 값 대입 |  |  |  |
| AC-80b2ecfa | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2081 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | popFilter["TARGET_FACTORY"] | sFacList | 행/컬럼 값 대입 |  |  |  |
| AC-8d97508c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2082 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | popFilter["TARGET_FAC"] | popFilter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-016c736d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2083 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | popFilter["_MIN_DATE"] | popFilter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-ad65aa22 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2086 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | POPUP | new FP01624_Apply_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4a1fcaff | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2087 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | UI_PROP | applyPopup.Filter | popFilter | 속성 Filter 설정 |  |  |  |
| AC-1efaf567 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2088 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | UI_PROP | applyPopup.Title | "Confirm" | 속성 Title 설정 |  |  |  |
| AC-b1a950c2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2089 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-b98aba9d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2090 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-01ad91b1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2091 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-78f02e42 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2092 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-9e569f42 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2093 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-89bad97b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2094 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-5b6aa58a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2095 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-3a9a97eb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2096 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["LINE"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-29e991a9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2097 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-fc465566 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2098 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-b5de317a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2099 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-c22ea888 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2100 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["PRODUCTION_TYPE"] | "Production Type" | 행/컬럼 값 대입 |  |  |  |
| AC-b0eccc61 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2101 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | DATA_OP | applyPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-a1ffec50 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2102 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | UI_PROP | applyPopup.DateColumnType | DateColumnType.DMPP | 속성 DateColumnType 설정 |  |  |  |
| AC-a9ba0c0b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2103 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | UI_PROP | applyPopup.DoSearchData | (f, a) => { { DataTable dtBucket = DataService.FP_ExecuteQuery2("FP00602_PlanAmendLineAssy… | 속성 DoSearchData 설정 |  |  |  |
| AC-4940c78c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2107 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ lambda | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00602_PlanAmendLineAssy", "find_bukInfo", popFilter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c46dfddf | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2119 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ lambda | DATA_OP | popFilter["BUCKET_SQL"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-390ecab3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2131 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ lambda ▸ if (ds_newRev.Good()) ▸ foreach (DataRo… | DATA_OP | revList.Contains | (revLine) | 데이터 객체 조작/조회 |  |  |  |
| AC-12c7c019 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2136 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ lambda | DATA_OP | popFilter["REV_LIST"] | revList | 행/컬럼 값 대입 |  |  |  |
| AC-c58ce60a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2137 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ lambda | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01624_MPPWPP", "find_saveConfirm", popFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveConfirm] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a4d20a5e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2138 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ lambda | FLAG | dt_pastInfo | DataService.FP_ExecuteQuery2("FP01624_MPPWPP", "find_saveConfirm_Data", popFilter.Dictiona… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveConfirm_Data] \| FP\Pl… | 화면 필드/플래그 변경 |  |  |  |
| AC-ddcb101e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2138 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ lambda | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_saveConfirm_Data", popFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveConfirm_Data] \| FP\Pl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-08285613 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2139 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ lambda | RETURN | return s; |  | 처리 중단/반환 |  |  |  |
| AC-81bd75ba | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2141 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") | POPUP | applyPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e97f849c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2143 | if (popFilter["MPP_WPP_PLAN_TYPE"] == "MPP" \|\| popFilter["MPP_WPP_PLAN_TYPE"] == "WPP") ▸ if (applyPopup.DialogResult != DialogResult.OK) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.Run_setSMS_MRP

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c851c3b4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2686 | if (ds_head.Good()) ▸ foreach (DataRow ro in ds_head.Rows) | ENDPOINT | DataService.FP_RunProcedure2 | ("FP01624_MPPWPP", "executeSMS_ERP", ro.Dictionary(), null, "Planning", 900, "P_") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeSMS_ERP] \| FP\Plannin… | 엔드포인트 호출 |  |  |  |
| AC-dd8df218 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2686 | if (ds_head.Good()) ▸ foreach (DataRow ro in ds_head.Rows) | ENDPOINT | ro.Dictionary | () ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeSMS_ERP] \| FP\Plannin… | 엔드포인트 호출 |  |  |  |

## FP01624_Mpp_Wpp.Run_setValidation_LineAssign

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f0894a4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1581 |  | DATA_OP | dsExcelData.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e798292f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1588 | for (k < dsExcelData.Rows.Count) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | CALL_BASE | GetDayColNameOfType | (day, popup.DateColumnType) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9bf28821 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1598 | for (k < dsExcelData.Rows.Count) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | CALL_EXT | dsExcelData.copyRow | (k, ds_assignValid_in, j++) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac675169 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1599 | for (k < dsExcelData.Rows.Count) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | GRID_SET | ds_assignValid_in.Rows[j - 1]["PLAN_DATE"] | day.Date.ToString("yyyyMMdd") | 그리드 속성/값 설정 |  |  |  |
| AC-d44fe8c5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1600 | for (k < dsExcelData.Rows.Count) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | GRID_SET | ds_assignValid_in.Rows[j - 1]["PLAN_QTY"] | val.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-ea948683 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1603 |  | FLAG | this.ds_assignValid_in | ds_assignValid_in | 화면 필드/플래그 변경 |  |  |  |
| AC-10aee7a0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1606 |  | CALL_EXT | ds_assignValid.findRow | ("_VALID", "_N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-019628e0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1609 | if (error != null && error.Length > 0) | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-83a83fe4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1610 | if (error != null && error.Length > 0) | VALUE_SET | p.Text | "Excel Import - Line Assign Priority" | 컨트롤 값 설정 |  |  |  |
| AC-7e09b8c7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1611 | if (error != null && error.Length > 0) | UI_PROP | p.Filter | null | 속성 Filter 설정 |  |  |  |
| AC-a9ace4c1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1617 | if (error != null && error.Length > 0) | UI_PROP | p.DoSearchData | (a) => { DataSet l = new DataSet(); l.Tables.Add(ds_assignValid_in); return l; } | 속성 DoSearchData 설정 |  |  |  |
| AC-a2d120f9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1620 | if (error != null && error.Length > 0) ▸ lambda | DATA_OP | l.Tables.Add | (ds_assignValid_in) | 데이터 객체 조작/조회 |  |  |  |
| AC-2916f999 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1621 | if (error != null && error.Length > 0) ▸ lambda | RETURN | return l; |  | 처리 중단/반환 |  |  |  |
| AC-90e8ddb2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1623 | if (error != null && error.Length > 0) | UI_PROP | p.DoLineCheck | null | 속성 DoLineCheck 설정 |  |  |  |
| AC-6cd377b6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1624 | if (error != null && error.Length > 0) | UI_PROP | p.DoSaveData | null | 속성 DoSaveData 설정 |  |  |  |
| AC-d5650995 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1625 | if (error != null && error.Length > 0) | UI_PROP | p.DoValidationData | null | 속성 DoValidationData 설정 |  |  |  |
| AC-9f5fd8bf | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1626 | if (error != null && error.Length > 0) | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-65676449 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1627 | if (error != null && error.Length > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-bd0cee2a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1629 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-4a367d2b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1637 |  | DATA_OP | dsExcelData.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d83ea9b0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1659 |  | FLAG | this.ds_assignValid_in | ds_assignValid_in | 화면 필드/플래그 변경 |  |  |  |
| AC-a15363e5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1662 |  | CALL_EXT | ds_assignValid.findRow | ("_VALID", "_N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d83f3f0b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1665 | if (error != null && error.Length > 0) | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9bb4f1bd | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1666 | if (error != null && error.Length > 0) | VALUE_SET | p.Text | "Excel Import - Line Assign Priority" | 컨트롤 값 설정 |  |  |  |
| AC-da495f06 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1667 | if (error != null && error.Length > 0) | UI_PROP | p.Filter | null | 속성 Filter 설정 |  |  |  |
| AC-190d6959 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1673 | if (error != null && error.Length > 0) | UI_PROP | p.DoSearchData | (a) => { DataSet l = new DataSet(); l.Tables.Add(ds_assignValid_in); return l; } | 속성 DoSearchData 설정 |  |  |  |
| AC-3577e860 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1676 | if (error != null && error.Length > 0) ▸ lambda | DATA_OP | l.Tables.Add | (ds_assignValid_in) | 데이터 객체 조작/조회 |  |  |  |
| AC-5197f102 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1677 | if (error != null && error.Length > 0) ▸ lambda | RETURN | return l; |  | 처리 중단/반환 |  |  |  |
| AC-346510f0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1679 | if (error != null && error.Length > 0) | UI_PROP | p.DoLineCheck | null | 속성 DoLineCheck 설정 |  |  |  |
| AC-762cb1c7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1680 | if (error != null && error.Length > 0) | UI_PROP | p.DoSaveData | null | 속성 DoSaveData 설정 |  |  |  |
| AC-a8c1b6b7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1681 | if (error != null && error.Length > 0) | UI_PROP | p.DoValidationData | null | 속성 DoValidationData 설정 |  |  |  |
| AC-77788df1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1682 | if (error != null && error.Length > 0) | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f70cd8c2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1683 | if (error != null && error.Length > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-04b0df95 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:1685 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.Run_updateReleaseFlag

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb39bf77 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2903 | if (UserInfoContext.Current != null) | DATA_OP | ds_xif["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5e205be4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2907 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP01624_MPPWPP", "updateReleaseFlag", ds_xif.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=updateReleaseFlag] \| FP\Pla… | 엔드포인트 호출 |  |  |  |

## FP01624_Mpp_Wpp.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b8b95c6 | popSql.OnSql | FP01624_Mpp_Wpp.cs:1048 | if (programID == FindProcedure) | RETURN | return FindData(false); |  | 처리 중단/반환 |  |  |  |
| AC-74c9de42 | popSql.OnSql | FP01624_Mpp_Wpp.cs:1052 | else of (programID == FindProcedure) ▸ if (programID == "PR_UI_FP01624_FIND_FP01624_REVISIONINFO") | RETURN | return FindPlanRevision(false); |  | 처리 중단/반환 |  |  |  |
| AC-5800c927 | popSql.OnSql | FP01624_Mpp_Wpp.cs:1054 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.SaveAll_Past

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d69c08d6 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3013 |  | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01624_MPPWPP", "excel2_merge_FP01624", dt_pastInfo, 0, "Planning", true, 120 * 60) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=excel2_merge_FP01624] \| FP\Plan… | 엔드포인트 호출 |  |  |  |
| AC-d4fa4b91 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3035 |  | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01624_MPPWPP", "excel2_merge_FP01624", dt_pastInfo, 0, "Planning", true, 120 * 60) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=excel2_merge_FP01624] \| FP\Plan… | 엔드포인트 호출 |  |  |  |

## FP01624_Mpp_Wpp.SaveAllBody

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc9b76c0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2185 | foreach (DataRow row in ds_to_save.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | CALL_BASE | GetDayColNameOfType | (day, popup.DateColumnType) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac7cdd29 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2187 | foreach (DataRow row in ds_to_save.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | DATA_OP | row["PLAN_DATE"] | day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-8e58627e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2188 | foreach (DataRow row in ds_to_save.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | DATA_OP | row["PLAN_QTY"] | row[colname] | 행/컬럼 값 대입 |  |  |  |
| AC-d98e01dd | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2205 | foreach (DataRow row in ds_to_save.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | CALL_BASE | GetDayColNameOfType | (day, popup.DateColumnType) | ⚠ 의미 확인 필요 |  |  |  |
| AC-266ce375 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2207 | foreach (DataRow row in ds_to_save.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | DATA_OP | row["PLAN_DATE"] | day.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-6da1b56b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2208 | foreach (DataRow row in ds_to_save.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | DATA_OP | row["PLAN_QTY"] | row[colname] | 행/컬럼 값 대입 |  |  |  |
| AC-398b64ca | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2212 | foreach (DataRow row in ds_to_save.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP01624_MPPWPP", "merge_FP01624", row.Dictionary(), "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=merge_FP01624] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-76157763 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2214 | foreach (DataRow row in ds_to_save.Rows) ▸ foreach (KeyValuePair<string, AmendDate> kvp in popup.Calendar.Days) | CALL_EXT | row.Dictionary | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-014d3b07 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2219 | if (ds_newRev.Good()) | DATA_OP | ds_newRev.Columns.Contains | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-958b3263 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2221 | if (ds_newRev.Good()) ▸ if (!ds_newRev.Columns.Contains("PLAN_WEEK")) | DATA_OP | ds_newRev.Columns.Add | (new DataColumn("PLAN_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-35896e4b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2223 | if (ds_newRev.Good()) | DATA_OP | ds_newRev.Columns.Contains | ("BUCKET_TO") | 데이터 객체 조작/조회 |  |  |  |
| AC-09013e94 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2225 | if (ds_newRev.Good()) ▸ if (!ds_newRev.Columns.Contains("BUCKET_TO")) | DATA_OP | ds_newRev.Columns.Add | (new DataColumn("BUCKET_TO", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a9cd3f4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2230 | if (ds_newRev.Good()) ▸ foreach (DataRow nrRow in ds_newRev.Rows) | DATA_OP | nrRow["PLAN_WEEK"] | popFilter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-b25040a9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2231 | if (ds_newRev.Good()) ▸ foreach (DataRow nrRow in ds_newRev.Rows) | DATA_OP | nrRow["BUCKET_TO"] | popFilter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-6cca881c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2260 |  | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01624_MPPWPP2", "excel2_merge_FP01624", ds_to_save, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=excel2_merge_FP01624] \| FP\Plan… | 엔드포인트 호출 |  |  |  |
| AC-47571481 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2300 | if (ds_newRev.Good()) | DATA_OP | ds_newRev.Columns.Contains | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-acc6e48e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2302 | if (ds_newRev.Good()) ▸ if (!ds_newRev.Columns.Contains("PLAN_WEEK")) | DATA_OP | ds_newRev.Columns.Add | (new DataColumn("PLAN_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9627260b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2304 | if (ds_newRev.Good()) | DATA_OP | ds_newRev.Columns.Contains | ("BUCKET_TO") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2f13ed1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2306 | if (ds_newRev.Good()) ▸ if (!ds_newRev.Columns.Contains("BUCKET_TO")) | DATA_OP | ds_newRev.Columns.Add | (new DataColumn("BUCKET_TO", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c58650e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2311 | if (ds_newRev.Good()) ▸ foreach (DataRow nrRow in ds_newRev.Rows) | DATA_OP | nrRow["PLAN_WEEK"] | popFilter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-7a55518c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:2312 | if (ds_newRev.Good()) ▸ foreach (DataRow nrRow in ds_newRev.Rows) | DATA_OP | nrRow["BUCKET_TO"] | popFilter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |

## FP01624_Mpp_Wpp.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f675b922 | SaveButton | FP01624_Mpp_Wpp.cs:849 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("Read Only") | 메시지 표시 |  |  |  |

## FP01624_Mpp_Wpp.SavePastInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a0ad5c2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3066 | foreach (DataRow pstRow in dt_pastInfo.Rows) | DATA_OP | ds_head.Select | (cond) | 데이터 객체 조작/조회 |  |  |  |
| AC-373a766e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3070 | foreach (DataRow pstRow in dt_pastInfo.Rows) ▸ if (pastRows != null && pastRows.Length > 0) | DATA_OP | pstRow["PLAN_WEEK"] | popFilter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-d81ba1b1 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3071 | foreach (DataRow pstRow in dt_pastInfo.Rows) ▸ if (pastRows != null && pastRows.Length > 0) | DATA_OP | pstRow["PLAN_REVISION"] | pastRow["PLAN_REVSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e54b6f3c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3079 |  | DATA_OP | dt_pastInfo.Columns.Contains | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-400bfcfa | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3080 | if (!dt_pastInfo.Columns.Contains("PLAN_WEEK")) | DATA_OP | dt_pastInfo.Columns.Add | ("PLAN_WEEK", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b19f690f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3081 |  | DATA_OP | dt_pastInfo.Columns.Contains | ("PLAN_REVSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-d94bbf44 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3082 | if (!dt_pastInfo.Columns.Contains("PLAN_REVSION")) | DATA_OP | dt_pastInfo.Columns.Add | ("PLAN_REVSION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a67eaba | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3090 | foreach (DataRow pstRow in dt_pastInfo.Rows) | DATA_OP | ds_head.Select | (cond) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa03c7a2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3094 | foreach (DataRow pstRow in dt_pastInfo.Rows) ▸ if (pastRows != null && pastRows.Length > 0) | DATA_OP | pstRow["PLAN_WEEK"] | popFilter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-02e4fa7b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3095 | foreach (DataRow pstRow in dt_pastInfo.Rows) ▸ if (pastRows != null && pastRows.Length > 0) | DATA_OP | pstRow["PLAN_REVISION"] | pastRow["PLAN_REVSION"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP01624_Mpp_Wpp.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / cboOperation.SelectedIndexChanged / cboLine.SelectedIndexChanged / cboPlanWeek.SelectedIndexChanged / cbLast.CheckedChanged / this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK)] / FindButton [try ▸ if (siMain.ActiveSheet.Shee…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-473269cf | this.Load 외 11 | FP01624_Mpp_Wpp.cs:289 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-547d07b8 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:289 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5e90e5bc | this.Load 외 11 | FP01624_Mpp_Wpp.cs:298 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-42a5893f | this.Load 외 11 | FP01624_Mpp_Wpp.cs:298 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e9facad8 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:299 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0089a756 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:305 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues, "ALL") | 행/컬럼 값 대입 |  |  |  |
| AC-2627836f | this.Load 외 11 | FP01624_Mpp_Wpp.cs:306 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-94f4937c | this.Load 외 11 | FP01624_Mpp_Wpp.cs:306 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4641d91a | this.Load 외 11 | FP01624_Mpp_Wpp.cs:307 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-beeffcb9 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:313 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-bde26790 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:314 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-45b9c0db | this.Load 외 11 | FP01624_Mpp_Wpp.cs:314 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-89b76681 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:315 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a94b0df4 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:322 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-ed84ab4e | this.Load 외 11 | FP01624_Mpp_Wpp.cs:323 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e128738b | this.Load 외 11 | FP01624_Mpp_Wpp.cs:323 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a6b4368b | this.Load 외 11 | FP01624_Mpp_Wpp.cs:324 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a2f19f00 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:330 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues, "ALL") | 행/컬럼 값 대입 |  |  |  |
| AC-771cc1a5 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:331 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f519b09 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:331 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8196b3e3 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:332 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, cboLine, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a423981d | this.Load 외 11 | FP01624_Mpp_Wpp.cs:338 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, cboLine.ControlValues, "ALL") | 행/컬럼 값 대입 |  |  |  |
| AC-315538f7 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:339 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | FLAG | dtPlanWeek | DataService.GetInnerTable("PLAN_WEEK ", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-329991be | this.Load 외 11 | FP01624_Mpp_Wpp.cs:339 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLAN_WEEK ", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a061de75 | this.Load 외 11 | FP01624_Mpp_Wpp.cs:349 | switch (triggerControl) case DefColumns.PLAN_REVISION: | DATA_OP | Filter["PLAN_REVISION"] | CString.GetCheckedListValue(dtPlanRevision, clbPlanRevision.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01624_Mpp_Wpp.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02d600df | this.Load | FP01624_Mpp_Wpp.cs:181 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f40e15b | this.Load | FP01624_Mpp_Wpp.cs:183 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f6ef5d16 | this.Load | FP01624_Mpp_Wpp.cs:187 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ad095d73 | this.Load | FP01624_Mpp_Wpp.cs:189 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-ae11c444 | this.Load | FP01624_Mpp_Wpp.cs:190 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ac7d347 | this.Load | FP01624_Mpp_Wpp.cs:192 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-073bb263 | this.Load | FP01624_Mpp_Wpp.cs:196 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP01624_Mpp_Wpp.SetFilter

진입점: this.Load [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / cboSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbFactory.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / cboOperation.SelectedIndexChanged [switch (triggerContro…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6d2ce22 | this.Load [switch (triggerControl) case DefColumns.DIVISION_… 외 13 | FP01624_Mpp_Wpp.cs:930 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP01624_Mpp_Wpp.SetMemoCell

진입점: this.spdMain.CellDoubleClick [if (dsMain.Good()) ▸ if (day != null) ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (frm.Operation.ToLower() == "save")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93c0a1cf | this.spdMain.CellDoubleClick [if (dsMain.Good()) ▸ if (day !… | FP01624_Mpp_Wpp.cs:4790 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) | UI_PROP | acell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-d9623e6c | this.spdMain.CellDoubleClick [if (dsMain.Good()) ▸ if (day !… | FP01624_Mpp_Wpp.cs:4799 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-d580951c | this.spdMain.CellDoubleClick [if (dsMain.Good()) ▸ if (day !… | FP01624_Mpp_Wpp.cs:4803 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP01624_Mpp_Wpp.SetPlanOutCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6abc5f14 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3721 | if (EditingCol != cCol) | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-8f770bff | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3726 | if (EditingRow != cRow) | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-8c5a8c88 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3731 | if (EditingCol != cCol) | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-259ee576 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3739 | if (EditingCol != cCol) ▸ try | FLAG | UOMRate | AmendService.FindCellRate( clicked_row["PLANT_ID"].ToString(), clicked_row["TOP_ITEM_ID"].… | 화면 필드/플래그 변경 |  |  |  |
| AC-2122711c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3739 | if (EditingCol != cCol) ▸ try | CALL_EXT | AmendService.FindCellRate | ( clicked_row["PLANT_ID"].ToString(), clicked_row["TOP_ITEM_ID"].ToString(), clicked_row["… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1d5b5d7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3745 | if (EditingCol != cCol) ▸ try | FLAG | YieldRate | AmendService.FindYieldInfo( clicked_row["DIVISION_ID"].ToString(), clicked_row["SITE_ID"].… | 화면 필드/플래그 변경 |  |  |  |
| AC-0a8cafff | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3745 | if (EditingCol != cCol) ▸ try | CALL_EXT | AmendService.FindYieldInfo | ( clicked_row["DIVISION_ID"].ToString(), clicked_row["SITE_ID"].ToString(), clicked_row["P… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9dd297e9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3757 | if (EditingCol != cCol) ▸ try ▸ if (dlData != null) | UI_PROP | dlData.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-2207c8f3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3758 | if (EditingCol != cCol) ▸ try ▸ if (dlData != null) | UI_PROP | dlData.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-c2440388 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3762 | if (EditingCol != cCol) ▸ try ▸ if (dlView != null) | UI_PROP | dlView.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-59621784 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3763 | if (EditingCol != cCol) ▸ try ▸ if (dlView != null) | UI_PROP | dlView.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-05e0181b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3772 | if (EditingRow != cRow) | FLAG | EditingRow | cRow | 화면 필드/플래그 변경 |  |  |  |
| AC-8f7f63c0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3775 | if (EditingRow != cRow) ▸ if (dsMainFiltered.Good()) | FLAG | dlData | DataLines.CreateDataLine(siMain, calendar, cRow, cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ab2c8eb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3775 | if (EditingRow != cRow) ▸ if (dsMainFiltered.Good()) | CALL_EXT | DataLines.CreateDataLine | (siMain, calendar, cRow, cCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32a916e8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3779 | if (EditingRow != cRow) ▸ if (dsMain.Good()) | FLAG | dlView | DataLines.CreateDataLine(dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | 화면 필드/플래그 변경 |  |  |  |
| AC-18ccd53e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3779 | if (EditingRow != cRow) ▸ if (dsMain.Good()) | CALL_EXT | DataLines.CreateDataLine | (dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | ⚠ 의미 확인 필요 |  |  |  |
| AC-108ccb51 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3785 | if (dlData == null \|\| dlView == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-942f591a | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3821 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5444b964 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3827 | if (dsMainFiltered.Good()) ▸ if (dt == null) | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-2301d8bd | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3828 | if (dsMainFiltered.Good()) ▸ if (dt == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0223039 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3833 | if (dsMainFiltered.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5387bb62 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3841 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2894df9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3842 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-26496146 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3843 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ab2e1a0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3845 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ec47213 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3846 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f9fc4a4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3847 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4130339 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3848 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-949bf2eb | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3849 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-214a7ec9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3850 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3bfae3c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3851 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd23232b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3852 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a55e6a40 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3853 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-467b2a3d | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3854 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-98f2ee01 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3855 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ad50c01 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3856 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0261e06c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3857 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7bae046c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3858 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dac9cb0f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3859 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f030984 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3839 | if (dsMainFiltered.Good()) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("FP_PL… |  | 처리 중단/반환 |  |  |  |
| AC-88b1ae66 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3894 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "W_OUT") ▸ if (org_Mpp == Mpp && org_Wpp … | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-2335c00f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3900 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "W_OUT") ▸ else of (org_Mpp == Mpp && org… | DATA_OP | selected["WPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-18f6af47 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3927 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "W_OUT") ▸ if (current_catagory == "… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-801f13f7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3933 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "W_OUT") ▸ if (current_catagory == "… | DATA_OP | selected["MPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-a7843095 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3950 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "W_OUT") ▸ else of (current_catagory… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-81ee7394 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3955 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "W_OUT") ▸ else of (current_catagory… | DATA_OP | selected["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-23a546a2 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3956 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "W_OUT") ▸ else of (current_catagory… | DATA_OP | selected["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-b45b7881 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3957 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "W_OUT") ▸ else of (current_catagory… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-d7cf9acf | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3969 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2ffbfb36 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3973 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (Filter["PLAN_TYPE"] != "RELEASE") | DATA_OP | newrow["CATEGORY_ID"] | row["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b0b5f75b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3975 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-33ad88c3 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3976 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-4d28501b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3977 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-47b07623 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3978 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-63285247 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3980 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d02b16b8 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3981 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-25a7045c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3982 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ff37b23f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3983 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-64680075 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3984 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["MARKET"] | row["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04881a0c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3985 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a14f936c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3986 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f4b70eb5 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3987 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cbffba3f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3988 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["LOCATION"] | row["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-677ccf1c | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3989 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-79ae5424 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3990 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["TOP_ITEM_ID"] | row["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-597af37e | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3991 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-90ac5008 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3992 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["ITEM_TYPE"] | row["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0b801259 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3995 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "M_OUT") | DATA_OP | newrow["MPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-044026c7 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:3996 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "M_OUT") | DATA_OP | newrow["ORG_MPP_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-c67061cc | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4002 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "M_OUT") ▸ if (w_out_cell != null) | DATA_OP | newrow["ORG_WPP_OUT_QTY"] | newrow["WPP_OUT_QTY"] = w_out_cell[day.Value + appendix] | 행/컬럼 값 대입 |  |  |  |
| AC-8806a12b | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4002 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "M_OUT") ▸ if (w_out_cell != null) | DATA_OP | newrow["WPP_OUT_QTY"] | w_out_cell[day.Value + appendix] | 행/컬럼 값 대입 |  |  |  |
| AC-9fc2c7f0 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4007 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "M_OUT") ▸ if (current_catagory… | DATA_OP | newrow["WPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-3c9f2750 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4008 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "M_OUT") ▸ if (current_catagory… | DATA_OP | newrow["ORG_WPP_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-87c67961 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4015 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "M_OUT") ▸ if (current_catagory… | DATA_OP | newrow["ORG_MPP_OUT_QTY"] | newrow["MPP_OUT_QTY"] = m_out_cell[day.Value + appendix] | 행/컬럼 값 대입 |  |  |  |
| AC-29a8555f | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4015 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "M_OUT") ▸ if (current_catagory… | DATA_OP | newrow["MPP_OUT_QTY"] | m_out_cell[day.Value + appendix] | 행/컬럼 값 대입 |  |  |  |
| AC-57112a74 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4020 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "M_OUT") ▸ else of (current_cat… | DATA_OP | newrow["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-391e97c4 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4021 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "M_OUT") ▸ else of (current_cat… | DATA_OP | newrow["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-9871ab63 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4022 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "M_OUT") ▸ else of (current_cat… | DATA_OP | newrow["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-5cc2e535 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4023 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "M_OUT") ▸ else of (current_cat… | DATA_OP | newrow["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-ddff3485 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4025 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-a75d6455 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4026 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d5529527 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4028 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1ca72f9 | (진입점 미연결) | FP01624_Mpp_Wpp.cs:4139 | if (dsMainFiltered.Good()) | LIST_BIND | dgEdit.DataSource | dt | 목록/그리드 데이터 원천 연결 |  |  |  |

## FP01624_Mpp_Wpp.SetSpreadInit

진입점: this.Load [try] / this.btnReportConfig.Click [if (res == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-361b33b9 | this.Load [try] 외 3 | FP01624_Mpp_Wpp.cs:532 | if (sheetName.Equals(SpdSheet.shtMppWpp)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b2ef180 | this.Load [try] 외 3 | FP01624_Mpp_Wpp.cs:533 | if (sheetName.Equals(SpdSheet.shtMppWpp)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP01624_Mpp_Wpp.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed174023 | this.spdMain.CellClick | FP01624_Mpp_Wpp.cs:4821 | if (dsMain.Good()) ▸ if (dsRevinfo.Good()) | DATA_OP | dsRevinfo.Tables[0].Select | ("PLAN_REVISION='" + plan_revision + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-32d0a4b3 | this.spdMain.CellClick | FP01624_Mpp_Wpp.cs:4824 | if (dsMain.Good()) ▸ if (dsRevinfo.Good()) ▸ if (rev_row != null) | VALUE_SET | labelDescription.Text | rev_row["PLAN_DESCRIPTION"].ToString() + " (" + rev_row["INSERT_ID"].ToString() + " - " + … | 컨트롤 값 설정 |  |  |  |

## FP01624_Mpp_Wpp.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c935a9e | this.spdMain.CellDoubleClick | FP01624_Mpp_Wpp.cs:4726 | if (dsMain.Good()) ▸ if (day != null) | POPUP | new FP01624_MemoEditPopup | (current, day, e.Row, e.Column) | 팝업/폼 생성 |  |  |  |
| AC-da3cb123 | this.spdMain.CellDoubleClick | FP01624_Mpp_Wpp.cs:4727 | if (dsMain.Good()) ▸ if (day != null) | UI_PROP | frm.Filter | this.Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-7db7c646 | this.spdMain.CellDoubleClick | FP01624_Mpp_Wpp.cs:4727 | if (dsMain.Good()) ▸ if (day != null) | DATA_OP | this.Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3df7b974 | this.spdMain.CellDoubleClick | FP01624_Mpp_Wpp.cs:4728 | if (dsMain.Good()) ▸ if (day != null) | DATA_OP | frm.Filter["MEMO_TYPE"] | Filter["MPP_WPP_PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-10fa210b | this.spdMain.CellDoubleClick | FP01624_Mpp_Wpp.cs:4729 | if (dsMain.Good()) ▸ if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f6700ac8 | this.spdMain.CellDoubleClick | FP01624_Mpp_Wpp.cs:4730 | if (dsMain.Good()) ▸ if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01624_Mpp_Wpp.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-887ffe0d | this.spdMain.Change | FP01624_Mpp_Wpp.cs:5106 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8a9fcde | this.spdMain.EditChange | FP01624_Mpp_Wpp.cs:3695 |  | VALUE_SET | tbLog.Text | "spdMain_EditChange" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01624_Mpp_Wpp.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc9bfb90 | this.spdMain.EditModeOn | FP01624_Mpp_Wpp.cs:5100 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP01624_Mpp_Wpp.spdMain_TableChanged

진입점: this.spdMain.TableChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c88039f | this.spdMain.TableChanged | FP01624_Mpp_Wpp.cs:3683 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca801e06 | this.spdMain.TableChanged | FP01624_Mpp_Wpp.cs:3685 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowCount … | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.spdMain_TextChanged

진입점: this.spdMain.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-482f3544 | this.spdMain.TextChanged | FP01624_Mpp_Wpp.cs:3666 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-50c0f383 | this.spdMain.TextChanged | FP01624_Mpp_Wpp.cs:3668 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowCount … | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01624_Mpp_Wpp.UIFindData

진입점: this.btnReportConfig.Click [if (res == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.DialogResult == DialogResult.OK)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39d3bfa6 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:673 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-218668ad | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:674 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-878a5b33 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:677 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-252950ff | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:684 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f9f3a4a1 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:694 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d176984a | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:695 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe047452 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:698 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a4004f9a | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:702 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-94fd406f | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:703 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2530c244 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:713 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ if (dtDimensionInfo == null) | THROW | throw new Exception("Cannot Find Column Info"); |  | 예외 발생 |  |  |  |
| AC-7481f299 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:719 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try | FLAG | dsRevinfo | FindPlanRevision(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-63bd7470 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:722 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2e8af613 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:724 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-1a99cf83 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:724 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-529511e3 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:732 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ if (dsMain == null) | THROW | throw new Exception("Cannot Find Result"); |  | 예외 발생 |  |  |  |
| AC-b7aaef35 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:736 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2f7bfb67 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:748 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ if (siMain.ActiveRow != null && siMain.ActiveSheet.RowCount > 0) ▸ if … | DATA_OP | dsRevinfo.Tables[0].Select | ("PLAN_REVISION='" + plan_revision + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e4deacb | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:751 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ if (siMain.ActiveRow != null && siMain.ActiveSheet.RowCount > 0) ▸ if … | VALUE_SET | labelDescription.Text | rev_row["PLAN_DESCRIPTION"].ToString() + " (" + rev_row["INSERT_ID"].ToString() + " - " + … | 컨트롤 값 설정 |  |  |  |
| AC-2e7f1022 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:764 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ else of (siMain.ActiveRow != null && siMain.ActiveSheet.RowCount > 0) … | DATA_OP | dsRevinfo.Tables[0].Select | ("PLAN_REVISION='" + plan_revision + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-aeeee399 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:767 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try ▸ else of (siMain.ActiveRow != null && siMain.ActiveSheet.RowCount > 0) … | VALUE_SET | labelDescription.Text | rev_row["PLAN_DESCRIPTION"].ToString() + " (" + rev_row["INSERT_ID"].ToString() + " - " + … | 컨트롤 값 설정 |  |  |  |
| AC-5928a48e | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:776 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b79ad61f | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:780 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e97a29b6 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:786 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-23e216fe | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:788 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMppWpp) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5586b090 | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:795 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-27e0ae3d | this.btnReportConfig.Click [if (res == DialogResult.OK)] 외 2 | FP01624_Mpp_Wpp.cs:799 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01624_MppWpp.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac14d205 | Dispose | FP01624_MppWpp.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01624_Row_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1883d796 | .ctor | FP01624_Row_ExcelPopup.cs:164 |  | FLAG | filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-096743f0 | .ctor | FP01624_Row_ExcelPopup.cs:165 |  | FLAG | HeaderLineCount | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-9069c2e8 | .ctor | FP01624_Row_ExcelPopup.cs:166 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9aaff1ae | .ctor | FP01624_Row_ExcelPopup.cs:167 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP01624_Row_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af0b2744 | this.btnClose.Click | FP01624_Row_ExcelPopup.cs:1215 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_Row_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e8a7a4e | this.btnDownload.Click | FP01624_Row_ExcelPopup.cs:1195 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-9ff3c3ec | this.btnDownload.Click | FP01624_Row_ExcelPopup.cs:1196 |  | EXCEL | ExportExcel | (0,true) | 엑셀 내보내기/올리기 |  |  |  |

## FP01624_Row_ExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b496965d | this.btnFind.Click | FP01624_Row_ExcelPopup.cs:1184 | if (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | STATE | cmbMppMonth.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b52cad4f | this.btnFind.Click | FP01624_Row_ExcelPopup.cs:1186 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | STATE | cmbWppWeek.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8431a4bc | this.btnFind.Click | FP01624_Row_ExcelPopup.cs:1187 |  | STATE | drpPlanPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4c597f9c | this.btnFind.Click | FP01624_Row_ExcelPopup.cs:1188 |  | STATE | radioMPP.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f3fe3892 | this.btnFind.Click | FP01624_Row_ExcelPopup.cs:1189 |  | STATE | radioWPP.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7dbc46e3 | this.btnFind.Click | FP01624_Row_ExcelPopup.cs:1190 |  | STATE | radioWO.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Row_ExcelPopup.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-665fe094 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1201 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-0d6a4324 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1202 |  | STATE | radioMPP.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-74ace708 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1203 |  | STATE | radioWPP.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a11927a7 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1204 |  | STATE | radioWO.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Row_ExcelPopup.ClearGrid

진입점: radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try] / radioWPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try] / radioWO.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try] / drpPlanPeriod.ValueChanged [if (Clear)] / drpPlanPeriod.VisibleChanged [if (Clear)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f50d6db | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:440 |  | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8a6a02c2 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:441 |  | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ba9d991a | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:443 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-154a4a9c | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:444 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-36f7e5ed | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:445 |  | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1ada4982 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:446 |  | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-eb7e43d3 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:447 |  | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cb73a7d8 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:448 |  | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e75c7da2 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:455 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e665212 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:468 | try ▸ if (dtDimensionInfo!=null) ▸ foreach (DataRow row in dtDimensionInfo.Rows) | DATA_OP | table.Columns.Add | (new DataColumn(colname, typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca49cea9 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:476 | try ▸ if (dtDimensionInfo!=null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-4f9f7cf2 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:477 | try ▸ if (dtDimensionInfo!=null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-cf52ca01 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:478 | try ▸ if (dtDimensionInfo!=null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-f2ce61fe | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:481 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9da34690 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:491 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ecb0781 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:494 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-311de7a0 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:495 | finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cdcb4fb9 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:496 | finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9b25e864 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:497 | finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cd12b6ab | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:498 | finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e2f72811 | radioMPP.CheckedChanged [if (radioMPP.Checked) ▸ if (Filter[… 외 4 | FP01624_Row_ExcelPopup.cs:499 | finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Row_ExcelPopup.CmbMppMonth_SelectedIndexChanged

진입점: cmbMppMonth.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcbcbb53 | cmbMppMonth.SelectedIndexChanged | FP01624_Row_ExcelPopup.cs:348 |  | DATA_OP | Filter["PLAN_MONTH"] | selected_month | 행/컬럼 값 대입 |  |  |  |

## FP01624_Row_ExcelPopup.CmbWppWeek_SelectedIndexChanged

진입점: cmbWppWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46f8cdab | cmbWppWeek.SelectedIndexChanged | FP01624_Row_ExcelPopup.cs:335 | try | DATA_OP | dtWeek.Select | ("CODE='" + selected_week + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-edb25444 | cmbWppWeek.SelectedIndexChanged | FP01624_Row_ExcelPopup.cs:336 | try | DATA_OP | Filter["MAIN_PLAN_WEEK"] | Filter["PLAN_WEEK"] = selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-48e2c3b7 | cmbWppWeek.SelectedIndexChanged | FP01624_Row_ExcelPopup.cs:336 | try | DATA_OP | Filter["PLAN_WEEK"] | selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-66635f7e | cmbWppWeek.SelectedIndexChanged | FP01624_Row_ExcelPopup.cs:337 | try | DATA_OP | Filter["BUCKET_FROM"] | week_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-131886ad | cmbWppWeek.SelectedIndexChanged | FP01624_Row_ExcelPopup.cs:339 | try | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-88b683db | cmbWppWeek.SelectedIndexChanged | FP01624_Row_ExcelPopup.cs:340 | try | UI_PROP | drpPlanPeriod.Value2 | DateTime.ParseExact(week_row["END_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |

## FP01624_Row_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d9ffa6a | this.Load | FP01624_Row_ExcelPopup.cs:359 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-257c4857 | this.Load | FP01624_Row_ExcelPopup.cs:360 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4241de15 | this.Load | FP01624_Row_ExcelPopup.cs:361 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d770f8a | this.Load | FP01624_Row_ExcelPopup.cs:363 |  | FLAG | dtDimensionInfo | siMain.GetSpdTitle(SpdSheet.ownerProgram, UserInfoContext.Current.UserId, SpdSheet.shtMain… | 화면 필드/플래그 변경 |  |  |  |
| AC-050b76bf | this.Load | FP01624_Row_ExcelPopup.cs:363 |  | CALL_EXT | siMain.GetSpdTitle | (SpdSheet.ownerProgram, UserInfoContext.Current.UserId, SpdSheet.shtMain) | ⚠ 의미 확인 필요 |  |  |  |

## FP01624_Row_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d6530ba | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1154 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6c592be | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1154 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP01624_Row_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dd8d5b0 | this.Load | FP01624_Row_ExcelPopup.cs:354 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01624_Row_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-279eef1a | Dispose | FP01624_Row_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01624_Row_ExcelPopup.DrpPlanPeriod_ValueChanged

진입점: drpPlanPeriod.ValueChanged / drpPlanPeriod.VisibleChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a307125 | drpPlanPeriod.ValueChanged 외 1 | FP01624_Row_ExcelPopup.cs:306 | if (Filter["MPP_WPP_PLAN_TYPE"] == "WPP" \|\| Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (start != Filter["BUCKET_FROM"]) | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-2e9a4c1a | drpPlanPeriod.ValueChanged 외 1 | FP01624_Row_ExcelPopup.cs:313 | else of (Filter["MPP_WPP_PLAN_TYPE"] == "WPP" \|\| Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (start != Filter["BUCKET_FROM"]) | DATA_OP | Filter["BUCKET_FROM"] | drpPlanPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-716f9b4f | drpPlanPeriod.ValueChanged 외 1 | FP01624_Row_ExcelPopup.cs:320 | if (end != Filter["BUCKET_TO"]) | DATA_OP | Filter["BUCKET_TO"] | end | 행/컬럼 값 대입 |  |  |  |

## FP01624_Row_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d706566 | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1108 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP01624_Row_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a66e27e3 | FindButton | FP01624_Row_ExcelPopup.cs:403 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5a6974ff | FindButton | FP01624_Row_ExcelPopup.cs:404 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-46624ade | FindButton | FP01624_Row_ExcelPopup.cs:406 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_Row_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59b45960 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:536 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67fbbb2a | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:538 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-8bc29826 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:538 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-50a2b036 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:542 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7cb88216 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:543 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ab950ec2 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:545 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-700ee5c7 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:546 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cd5feef0 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:547 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e2d91ec9 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:548 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9407bd0a | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:549 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6957d3b4 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:550 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f16d1a3e | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:557 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c60fc17 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:560 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41965e12 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:562 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f892aa0b | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:563 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = true; if (init) { DictColumn = siMain.SetSheetH… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9739c574 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:569 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-b8d38ed0 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:569 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, null, 1, IgnoreColumnsNotInTi… | 그리드 재구성/초기화 |  |  |  |
| AC-f6f940be | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:575 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-f52d8b28 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:576 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-6218f6c0 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:577 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-2ad640c1 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:582 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-faa8834a | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:583 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca1f742d | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:587 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7cefb552 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:588 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb77ec2c | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:597 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0c8bde8 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:600 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c9e7eef6 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:601 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bf5f9b94 | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:602 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fddb8dae | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:603 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-148854af | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:604 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-751b30df | this.Load 외 2 | FP01624_Row_ExcelPopup.cs:605 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Row_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-540eb228 | this.Load | FP01624_Row_ExcelPopup.cs:175 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-96a401e1 | this.Load | FP01624_Row_ExcelPopup.cs:177 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01624_Row_ExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2949b3d | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1082 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-269c770f | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1083 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-bca9ca57 | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1084 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-826e9656 | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1085 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-ab2ed02c | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1086 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-4ca42272 | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1087 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-c92cb149 | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1088 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dd3a93f6 | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1090 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-a241740d | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1091 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-54d32d97 | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1095 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-8fa94104 | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:1096 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP01624_Row_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db52fd01 | this.Load | FP01624_Row_ExcelPopup.cs:195 |  | DATA_OP | Filter["MAIN_PLAN_WEEK"] | Filter["PLAN_WEEK"] | 행/컬럼 값 대입 |  |  |  |
| AC-70c26bf0 | this.Load | FP01624_Row_ExcelPopup.cs:196 |  | DATA_OP | Filter["TODAY"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e51c5753 | this.Load | FP01624_Row_ExcelPopup.cs:197 |  | FLAG | dtWeek | DataService.FP_ExecuteQuery2("FP01624_MPPWPP", "find_excel_week", Filter.Dictionary, "Plan… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_excel_week] \| FP\Planning… | 화면 필드/플래그 변경 |  |  |  |
| AC-38488248 | this.Load | FP01624_Row_ExcelPopup.cs:197 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_excel_week", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_excel_week] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2658049d | this.Load | FP01624_Row_ExcelPopup.cs:198 |  | LIST_REBIND | clsCtrl.setListBox | (dtWeek, cmbWppWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4e74a558 | this.Load | FP01624_Row_ExcelPopup.cs:199 |  | VALUE_SET | cmbWppWeek.SelectedValue | Filter["PLAN_WEEK"] | 컨트롤 값 설정 |  |  |  |
| AC-b0da0fd7 | this.Load | FP01624_Row_ExcelPopup.cs:200 |  | DATA_OP | Filter["PLAN_WEEK"] | CString.GetCheckedListValue(dtWeek, cmbWppWeek.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-df5ed971 | this.Load | FP01624_Row_ExcelPopup.cs:203 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) | VALUE_SET | cmbWppWeek.SelectedValue | Filter["PLAN_WEEK"] | 컨트롤 값 설정 |  |  |  |
| AC-0ee11bcb | this.Load | FP01624_Row_ExcelPopup.cs:206 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (cmbWppWeek.SelectedIndex == -1) | VALUE_SET | cmbWppWeek.SelectedIndex | (int)( Math.Ceiling((decimal)(dtWeek.Rows.Count - 1)) / 2) | 컨트롤 값 설정 |  |  |  |
| AC-f5a3994d | this.Load | FP01624_Row_ExcelPopup.cs:211 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | Filter["PLAN_WEEK"] | selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-d50d34bb | this.Load | FP01624_Row_ExcelPopup.cs:212 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | dtWeek.Select | ("CODE='" + selected_week + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-2cb8f9ba | this.Load | FP01624_Row_ExcelPopup.cs:213 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | week_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a16b0f5 | this.Load | FP01624_Row_ExcelPopup.cs:214 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | Filter["BUCKET_TO"] | week_row["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6ea93c40 | this.Load | FP01624_Row_ExcelPopup.cs:222 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ else of (cmbWppWeek.SelectedIndex == -1) | DATA_OP | Filter["PLAN_WEEK"] | selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-69fcdf00 | this.Load | FP01624_Row_ExcelPopup.cs:226 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ else of (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | dtWeek.Select | ("CODE='" + selected_week + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd2ee831 | this.Load | FP01624_Row_ExcelPopup.cs:227 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ else of (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | week_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c050fefb | this.Load | FP01624_Row_ExcelPopup.cs:228 | if (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ else of (cmbWppWeek.SelectedIndex == -1) ▸ try | DATA_OP | Filter["BUCKET_TO"] | week_row["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9772530a | this.Load | FP01624_Row_ExcelPopup.cs:236 | else of (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (dtWeek.Good()) | VALUE_SET | cmbWppWeek.SelectedIndex | dtWeek.Rows.Count / 2 | 컨트롤 값 설정 |  |  |  |
| AC-7788ebce | this.Load | FP01624_Row_ExcelPopup.cs:240 | else of (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (!string.IsNullOrWhiteSpace(selected_week)) | DATA_OP | Filter["PLAN_WEEK"] | selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-33342dc0 | this.Load | FP01624_Row_ExcelPopup.cs:244 | else of (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (!string.IsNullOrWhiteSpace(selected_week)) ▸ try | DATA_OP | dtWeek.Select | ("CODE='" + selected_week + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e49419c9 | this.Load | FP01624_Row_ExcelPopup.cs:245 | else of (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (!string.IsNullOrWhiteSpace(selected_week)) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | week_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-86aec513 | this.Load | FP01624_Row_ExcelPopup.cs:246 | else of (!string.IsNullOrWhiteSpace(Filter["PLAN_WEEK"])) ▸ if (!string.IsNullOrWhiteSpace(selected_week)) ▸ try | DATA_OP | Filter["BUCKET_TO"] | week_row["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e92e177b | this.Load | FP01624_Row_ExcelPopup.cs:251 |  | FLAG | dtMonth | DataService.FP_ExecuteQuery2("FP01624_MPPWPP", "find_excel_month", Filter.Dictionary, "Pla… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_excel_month] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-3ee77880 | this.Load | FP01624_Row_ExcelPopup.cs:251 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01624_MPPWPP", "find_excel_month", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_excel_month] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-33fa76d6 | this.Load | FP01624_Row_ExcelPopup.cs:252 |  | LIST_REBIND | clsCtrl.setListBox | (dtMonth, cmbMppMonth, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4cb214b7 | this.Load | FP01624_Row_ExcelPopup.cs:253 |  | VALUE_SET | cmbMppMonth.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-6ca4fab2 | this.Load | FP01624_Row_ExcelPopup.cs:255 |  | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-739b8282 | this.Load | FP01624_Row_ExcelPopup.cs:256 |  | UI_PROP | drpPlanPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-ab816a7e | this.Load | FP01624_Row_ExcelPopup.cs:259 | if (Filter["MPP_WPP_PLAN_TYPE"] == "") | DATA_OP | Filter["MPP_WPP_PLAN_TYPE"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-0cee2538 | this.Load | FP01624_Row_ExcelPopup.cs:263 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | STATE | cmbMppMonth.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d7512411 | this.Load | FP01624_Row_ExcelPopup.cs:264 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | STATE | cmbWppWeek.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-74289ce1 | this.Load | FP01624_Row_ExcelPopup.cs:265 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | VALUE_SET | radioMPP.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-9d72c074 | this.Load | FP01624_Row_ExcelPopup.cs:268 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | STATE | cmbMppMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9545e3dd | this.Load | FP01624_Row_ExcelPopup.cs:269 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | STATE | cmbWppWeek.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-04c16eee | this.Load | FP01624_Row_ExcelPopup.cs:270 | switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | VALUE_SET | radioWO.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-bbdf4241 | this.Load | FP01624_Row_ExcelPopup.cs:274 | switch (Filter["MPP_WPP_PLAN_TYPE"]) default: case "WPP": | STATE | cmbMppMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e570b8b9 | this.Load | FP01624_Row_ExcelPopup.cs:275 | switch (Filter["MPP_WPP_PLAN_TYPE"]) default: case "WPP": | STATE | cmbWppWeek.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cd8f76c0 | this.Load | FP01624_Row_ExcelPopup.cs:276 | switch (Filter["MPP_WPP_PLAN_TYPE"]) default: case "WPP": | VALUE_SET | radioWPP.Checked | true | 컨트롤 값 설정 |  |  |  |

## FP01624_Row_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03ac98e7 | this.Load | FP01624_Row_ExcelPopup.cs:373 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c793ee2b | this.Load | FP01624_Row_ExcelPopup.cs:374 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01624_Row_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-089be0e2 | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:394 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01624_Row_ExcelPopup.NullData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a92f65b3 | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:510 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-03fbb898 | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:510 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-842fbb5a | (진입점 미연결) | FP01624_Row_ExcelPopup.cs:518 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |

## FP01624_Row_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28cea61a | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1116 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-c7003f53 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1116 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33bc973c | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1118 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-be252549 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1119 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c43cb200 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1120 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0af8b69b | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1122 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-21ba3974 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1124 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-79468885 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1125 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-867b5c35 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1125 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-c955c252 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1133 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-b3c51e4e | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1135 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc38aba6 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1138 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cfb5413d | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1139 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ea241ac1 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1140 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ede64c2f | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1141 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-170bc668 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1142 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9b84942c | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1143 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a67ebe16 | this.btnUpload.Click | FP01624_Row_ExcelPopup.cs:1146 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01624_Row_ExcelPopup.radio_Changed

진입점: radioMPP.CheckedChanged / radioWPP.CheckedChanged / radioWO.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d52ea536 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1222 | if (radioMPP.Checked) | STATE | cmbMppMonth.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-60879b23 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1223 | if (radioMPP.Checked) | STATE | cmbWppWeek.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e1ba5b4b | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1226 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") | DATA_OP | Filter["MPP_WPP_PLAN_TYPE"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-bfdef9c7 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1231 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | DATA_OP | dtMonth.Select | ("CODE='" + selected_month + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0f2e0f7 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1232 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | DATA_OP | Filter["MAIN_PLAN_WEEK"] | Filter["PLAN_WEEK"] = selected_month | 행/컬럼 값 대입 |  |  |  |
| AC-65915b46 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1232 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | DATA_OP | Filter["PLAN_WEEK"] | selected_month | 행/컬럼 값 대입 |  |  |  |
| AC-768f18e9 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1233 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | DATA_OP | Filter["BUCKET_FROM"] | month_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b294083 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1234 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | DATA_OP | Filter["BUCKET_TO"] | month_row["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f43a1ee8 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1237 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-440ca7a5 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1238 | if (radioMPP.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "MPP") ▸ try | UI_PROP | drpPlanPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-4f7eedf6 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1250 | else of (radioMPP.Checked) ▸ if (radioWO.Checked) | STATE | cmbMppMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bcdb10b1 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1251 | else of (radioMPP.Checked) ▸ if (radioWO.Checked) | STATE | cmbWppWeek.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-60cbb5a1 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1254 | else of (radioMPP.Checked) ▸ if (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WO") | DATA_OP | Filter["MPP_WPP_PLAN_TYPE"] | "WO" | 행/컬럼 값 대입 |  |  |  |
| AC-945ea563 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1262 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) | STATE | cmbMppMonth.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ae55bb88 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1263 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) | STATE | cmbWppWeek.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d92932b5 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1266 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") | DATA_OP | Filter["MPP_WPP_PLAN_TYPE"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-8109d12e | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1271 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | DATA_OP | dtWeek.Select | ("CODE='" + selected_week + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-5804e923 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1272 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | DATA_OP | Filter["MAIN_PLAN_WEEK"] | Filter["PLAN_WEEK"] = selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-6eb7bb22 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1272 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | DATA_OP | Filter["PLAN_WEEK"] | selected_week | 행/컬럼 값 대입 |  |  |  |
| AC-9bdb3455 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1273 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | DATA_OP | Filter["BUCKET_FROM"] | week_row["START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-88544a1a | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1274 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | DATA_OP | Filter["BUCKET_TO"] | week_row["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6fb06293 | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1277 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | UI_PROP | drpPlanPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-3c38d1cb | radioMPP.CheckedChanged 외 2 | FP01624_Row_ExcelPopup.cs:1278 | else of (radioMPP.Checked) ▸ else of (radioWO.Checked) ▸ if (Filter["MPP_WPP_PLAN_TYPE"] != "WPP") ▸ try | UI_PROP | drpPlanPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |

## FP01624_Row_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d7b3ba0 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:749 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-d726baae | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:750 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca7217d7 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:754 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-40b20917 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:755 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dacf6f37 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:759 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-604fd2c8 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:759 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec5daaaa | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:764 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1d9b9503 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:765 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-37d107ad | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:766 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8983334a | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:767 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0ec56d94 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:768 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8c07f445 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:769 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9330b3e0 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:777 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b03fd72d | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:780 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ad1d260 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:782 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b705a4a | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:785 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-d936cf11 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:790 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-76791472 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:791 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-f868df25 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:798 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-abbaff02 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:799 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-159d58a5 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:800 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e1488946 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:801 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a3907b0e | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:802 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6fd88ca6 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:803 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5310a5ae | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:804 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d1dcac5a | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:805 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78a7cd80 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:809 | if (DoSaveData != null) ▸ try | DATA_OP | Filter["PLAN_DESCRIPTION"] | description | 행/컬럼 값 대입 |  |  |  |
| AC-44752129 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:812 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | MESSAGE | MessageBox.Show | ("You need description data to proceed") | 메시지 표시 |  |  |  |
| AC-3fedefb9 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:813 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8da91931 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:814 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ccb7dc78 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:815 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8bb13937 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:816 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3595a9fb | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:817 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-83cc65d5 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:818 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5b430542 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:819 | if (DoSaveData != null) ▸ try ▸ if (string.IsNullOrWhiteSpace(description)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04cda04d | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:825 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO") | CALL_EXT | HardCodeService.MatchCodeFp | ("FP01624_Row_ExcelPopup", "WO_CHINA_CASE", main.getColumn(0, "SITE_ID")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e61814f6 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:825 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO") | DATA_OP | main.getColumn | (0, "SITE_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3b110335 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:834 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO") | MESSAGE | MessageBox.Show | (sMsgWO, "WO Data Check", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-efc17bfa | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:836 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO") ▸ if (MessageBox.Show(sMsgWO, "WO Data Check", MessageBoxButtons.Ye… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6322ca85 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:839 | if (DoSaveData != null) ▸ try | FLAG | dsSaveExcelData | main | 화면 필드/플래그 변경 |  |  |  |
| AC-22316d23 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:843 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WPP" \|\| Filter["MPP_WPP_PLAN_TYPE"] == "MPP") | CALL_EXT | dsSaveExcelData.Tables[0].findRow | ("PLAN_DATE", Filter["BUCKET_FROM"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-782623e9 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:847 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WPP" \|\| Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (row==null) | MESSAGE | MessageBox.Show | (sMsgWO, "MPP/WPP Start Data Check", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-1220d5de | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:849 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WPP" \|\| Filter["MPP_WPP_PLAN_TYPE"] == "MPP") ▸ if (row==null) ▸ if (M… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd4471bd | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:856 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WPP": | DATA_OP | Filter["WPP"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-2623c369 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:857 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WPP": | DATA_OP | Filter["MPP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-e4f75133 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:858 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WPP": | DATA_OP | Filter["WO"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-196c3a28 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:859 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WPP": | DATA_OP | Filter["MRP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-b466c329 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:862 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | DATA_OP | Filter["WPP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-52067b22 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:863 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | DATA_OP | Filter["MPP"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-0159bc78 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:864 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | DATA_OP | Filter["WO"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-3ecabbf5 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:865 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "MPP": | DATA_OP | Filter["MRP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-0639a9fe | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:868 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | DATA_OP | Filter["WPP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-c4105426 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:869 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | DATA_OP | Filter["MPP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-586d01f6 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:870 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | DATA_OP | Filter["WO"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-b7c46fc6 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:871 | if (DoSaveData != null) ▸ try ▸ switch (Filter["MPP_WPP_PLAN_TYPE"]) case "WO": | DATA_OP | Filter["MRP"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-7aea1d9e | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:878 | if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO") ▸ if (WO_PastDayCheck(dsSaveExcelData) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d320620 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:887 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (dsSaveExcelData, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4dd9552 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:899 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | mainRow["COMPANY_ID"] | valRow["COMPANY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6940bbc0 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:900 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | mainRow["DIVISION_ID"] | valRow["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c62117f8 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:901 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | mainRow["SITE_ID"] | valRow["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f38e9731 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:902 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | mainRow["PLANT_ID"] | valRow["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-90836033 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:903 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | mainRow["EQUIPMENT_ID"] | valRow["EQUIPMENT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9fc8df92 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:906 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) ▸ if (validation.Good() && main.Good()) ▸ if (validation.Tables[0].Rows.Count … | DATA_OP | main.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-46d4b86d | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:917 | if (DoSaveData != null) ▸ try ▸ if (validation == null \|\| !validation.Good()) | FLAG | valid | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6db788f9 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:924 | if (DoSaveData != null) ▸ try ▸ else of (validation == null \|\| !validation.Good()) ▸ if (validation.Tables!=null) ▸ if (validation.Tables.… | FLAG | valid | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2d625724 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:928 | if (DoSaveData != null) ▸ try ▸ else of (validation == null \|\| !validation.Good()) ▸ if (validation.Tables!=null) ▸ else of (validation.Ta… | FLAG | valid | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7201886d | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:934 | if (DoSaveData != null) ▸ try ▸ else of (validation == null \|\| !validation.Good()) ▸ if (validation.Tables!=null) ▸ else of (validation.Ta… | FLAG | valid | false | 화면 필드/플래그 변경 |  |  |  |
| AC-89855920 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:943 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3948049a | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:955 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-7195d7ce | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:957 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-bfbee948 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:959 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e3e76a6 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:963 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-6cec573d | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:978 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-2f40c376 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:979 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1106d959 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:985 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | ("Data Saved ...") | 메시지 표시 |  |  |  |
| AC-95c5141f | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:992 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-89e47e5a | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:997 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-3f9bf98c | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1014 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (xlsSrc.Rows.Count > row_index && val… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-7983b3f4 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1016 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (xlsSrc.Rows.Count > row_index && val… | CALL_EXT | siMain.SetRowColor | (row_index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-abb60cd5 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1017 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (xlsSrc.Rows.Count > row_index && val… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5c4b2116 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1021 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ else of (xlsSrc.Rows.Count > row_index &… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-35c17a26 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1061 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d9ce76c4 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1062 | if (DoSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-4c72e0a7 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1066 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b2546b94 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1067 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-211c2f99 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1068 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-73ccdf58 | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1069 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bb7eec3e | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1070 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-566e00cc | this.btnSave.Click | FP01624_Row_ExcelPopup.cs:1071 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_Row_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4e343ac | this.Load | FP01624_Row_ExcelPopup.cs:386 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9e32a88 | this.Load | FP01624_Row_ExcelPopup.cs:387 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP01624_Row_ExcelPopup.TxtPlanDescription_TextChanged

진입점: txtPlanDescription.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8064890f | txtPlanDescription.TextChanged | FP01624_Row_ExcelPopup.cs:292 |  | DATA_OP | Filter["PLAN_DESCRIPTION"] | txtPlanDescription.Text | 행/컬럼 값 대입 |  |  |  |

## FP01624_Row_ExcelPopup.WO_PastDayCheck

진입점: this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filter["MPP_WPP_PLAN_TYPE"] == "WO")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05dcb032 | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Row_ExcelPopup.cs:707 |  | DATA_OP | ds_siteDate_in["FACTORY_ID"] | dsCheckExcel.Tables[0].Rows[0]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9e4a6dbe | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Row_ExcelPopup.cs:708 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01624_MPPWPP", "find_SiteDate", ds_siteDate_in.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SiteDate] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-95f7630e | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Row_ExcelPopup.cs:709 |  | DATA_OP | dtSiteDate.getColumn | (0, "SITE_DATE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-80fd88cd | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Row_ExcelPopup.cs:718 | foreach (DataRow row in dsCheckExcel.Tables[0].Rows) ▸ if (dtBaseDay > rDate) | MESSAGE | MessageBox.Show | (msg) | 메시지 표시 |  |  |  |
| AC-bc665575 | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Row_ExcelPopup.cs:719 | foreach (DataRow row in dsCheckExcel.Tables[0].Rows) ▸ if (dtBaseDay > rDate) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-be01375a | this.btnSave.Click [if (DoSaveData != null) ▸ try ▸ if (Filt… | FP01624_Row_ExcelPopup.cs:743 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP01624_WoDataPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51bb93e0 | .ctor | FP01624_WoDataPopup.cs:170 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-732ef23b | .ctor | FP01624_WoDataPopup.cs:171 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP01624_WoDataPopup.btnAdd_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3dc58ef | (진입점 미연결) | FP01624_WoDataPopup.cs:651 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |

## FP01624_WoDataPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1a0fcb0 | this.btnClose.Click | FP01624_WoDataPopup.cs:665 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_WoDataPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0c949e3 | this.btnSave.Click | FP01624_WoDataPopup.cs:657 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-8ca471ce | this.btnSave.Click | FP01624_WoDataPopup.cs:658 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP01624_WoDataPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b13719f | this.Load | FP01624_WoDataPopup.cs:226 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b6b228f3 | this.Load | FP01624_WoDataPopup.cs:227 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7423803c | this.Load | FP01624_WoDataPopup.cs:228 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01624_WoDataPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-682a935b | this.Load | FP01624_WoDataPopup.cs:221 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01624_WoDataPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3311841b | Dispose | FP01624_WoDataPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01624_WoDataPopup.EnableButton

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04d981cb | (진입점 미연결) | FP01624_WoDataPopup.cs:58 | switch (button) case MemoPopupButton.Add: | FLAG | enableBtnPlus | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-f791eca5 | (진입점 미연결) | FP01624_WoDataPopup.cs:61 | switch (button) case MemoPopupButton.Save: | STATE | btnSave.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-7bb32450 | (진입점 미연결) | FP01624_WoDataPopup.cs:62 | switch (button) case MemoPopupButton.Save: | FLAG | enableBtnSave | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-223b4295 | (진입점 미연결) | FP01624_WoDataPopup.cs:66 | switch (button) case MemoPopupButton.Find: | FLAG | enableBtnFind | t_f | 화면 필드/플래그 변경 |  |  |  |
| AC-b04d385a | (진입점 미연결) | FP01624_WoDataPopup.cs:69 | switch (button) case MemoPopupButton.Close: | STATE | btnClose.Enabled | t_f | 컨트롤 상태 Enabled |  |  |  |
| AC-53041176 | (진입점 미연결) | FP01624_WoDataPopup.cs:70 | switch (button) case MemoPopupButton.Close: | FLAG | enableBtnClose | t_f | 화면 필드/플래그 변경 |  |  |  |

## FP01624_WoDataPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53448b99 | FindButton | FP01624_WoDataPopup.cs:265 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ab879faa | FindButton | FP01624_WoDataPopup.cs:266 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f7e6a852 | FindButton | FP01624_WoDataPopup.cs:268 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP01624_WoDataPopup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82f38c0c | this.Load 외 2 | FP01624_WoDataPopup.cs:302 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-c3e5bf4b | this.Load 외 2 | FP01624_WoDataPopup.cs:302 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-aca2ab9b | this.Load 외 2 | FP01624_WoDataPopup.cs:309 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a9f08fc3 | this.Load 외 2 | FP01624_WoDataPopup.cs:310 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a14dce87 | this.Load 외 2 | FP01624_WoDataPopup.cs:313 |  | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-06cf0658 | this.Load 외 2 | FP01624_WoDataPopup.cs:320 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb91ca83 | this.Load 외 2 | FP01624_WoDataPopup.cs:340 | try | DATA_OP | Filter["LIST_BUCKET"] | list_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-231b4dcd | this.Load 외 2 | FP01624_WoDataPopup.cs:346 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01624_MPPWPP", "find_WOData_List", Filter.Dictionary, "PLANNING") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WOData_List] \| FP\PLANNIN… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ac3591eb | this.Load 외 2 | FP01624_WoDataPopup.cs:348 | try | CALL_BASE | this.Invoke | (new Action(delegate () { siMain.SpreadObject.SuspendLayout(); siMain.SetAmendHeaderColumn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ace1f5b1 | this.Load 외 2 | FP01624_WoDataPopup.cs:350 | try ▸ lambda | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e3949aee | this.Load 외 2 | FP01624_WoDataPopup.cs:351 | try ▸ lambda | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (Calendar, false, false, true, 2, GSCM.FP.Common.UIL.FPExtensions.DateColumnType.DMPP, GSC… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c8f8f80 | this.Load 외 2 | FP01624_WoDataPopup.cs:361 | try ▸ lambda | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-a52240fb | this.Load 외 2 | FP01624_WoDataPopup.cs:365 | try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a2149f6b | this.Load 외 2 | FP01624_WoDataPopup.cs:381 | try ▸ lambda ▸ if (set.Good()) ▸ foreach (KeyValuePair<string, AmendDate> da in Calendar.days) ▸ for (i<rowcount) ▸ if (row["F"+dateval.ToSt… | GRID_SET | siMain.ActiveSheet.Cells[i, colindex].BackColor | System.Drawing.Color.Orange | 그리드 속성/값 설정 |  |  |  |
| AC-ae96992b | this.Load 외 2 | FP01624_WoDataPopup.cs:386 | try ▸ lambda | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-83966f4f | this.Load 외 2 | FP01624_WoDataPopup.cs:400 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-86dff4b9 | this.Load 외 2 | FP01624_WoDataPopup.cs:403 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7b0fed57 | this.Load 외 2 | FP01624_WoDataPopup.cs:404 | finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-68a2f0ca | this.Load 외 2 | FP01624_WoDataPopup.cs:410 | finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_WoDataPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12c09849 | this.Load | FP01624_WoDataPopup.cs:179 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-03f96c4c | this.Load | FP01624_WoDataPopup.cs:181 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01624_WoDataPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-495c4f02 | (진입점 미연결) | FP01624_WoDataPopup.cs:598 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-21e16540 | (진입점 미연결) | FP01624_WoDataPopup.cs:599 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-b893e470 | (진입점 미연결) | FP01624_WoDataPopup.cs:600 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-ca7c5faf | (진입점 미연결) | FP01624_WoDataPopup.cs:601 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-e83b785a | (진입점 미연결) | FP01624_WoDataPopup.cs:602 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-77bc42d1 | (진입점 미연결) | FP01624_WoDataPopup.cs:603 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-e623568a | (진입점 미연결) | FP01624_WoDataPopup.cs:604 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cdeddc20 | (진입점 미연결) | FP01624_WoDataPopup.cs:606 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-3cfe4dd8 | (진입점 미연결) | FP01624_WoDataPopup.cs:607 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-4d8ac1ad | (진입점 미연결) | FP01624_WoDataPopup.cs:611 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d3a6e5ee | (진입점 미연결) | FP01624_WoDataPopup.cs:612 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP01624_WoDataPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c18d018c | this.Load | FP01624_WoDataPopup.cs:206 | if (canSave == true) | STATE | btnSave.Enabled | enableBtnSave | 컨트롤 상태 Enabled |  |  |  |
| AC-6967a087 | this.Load | FP01624_WoDataPopup.cs:211 | else of (canSave == true) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a3398546 | this.Load | FP01624_WoDataPopup.cs:215 |  | STATE | btnClose.Enabled | enableBtnClose | 컨트롤 상태 Enabled |  |  |  |

## FP01624_WoDataPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe8a5c7b | this.Load | FP01624_WoDataPopup.cs:237 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |

## FP01624_WoDataPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bbb3ebe | (진입점 미연결) | FP01624_WoDataPopup.cs:256 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01624_WoDataPopup.SaveToDB

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca37710b | (진입점 미연결) | FP01624_WoDataPopup.cs:528 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-71aceec2 | (진입점 미연결) | FP01624_WoDataPopup.cs:528 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-372d2a87 | (진입점 미연결) | FP01624_WoDataPopup.cs:533 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f62e464e | (진입점 미연결) | FP01624_WoDataPopup.cs:534 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c80eb820 | (진입점 미연결) | FP01624_WoDataPopup.cs:537 |  | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-427b09a4 | (진입점 미연결) | FP01624_WoDataPopup.cs:545 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-00bcc10a | (진입점 미연결) | FP01624_WoDataPopup.cs:546 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("USER_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f1b14c6 | (진입점 미연결) | FP01624_WoDataPopup.cs:547 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3822161a | (진입점 미연결) | FP01624_WoDataPopup.cs:550 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | ro["USER_ID"] | ctx.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5d7fa36e | (진입점 미연결) | FP01624_WoDataPopup.cs:551 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | m2.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e9b3ac48 | (진입점 미연결) | FP01624_WoDataPopup.cs:555 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) ▸ foreach (DataColumn … | DATA_OP | nn[colname] | ro[colname] | 행/컬럼 값 대입 |  |  |  |
| AC-00b57e2f | (진입점 미연결) | FP01624_WoDataPopup.cs:557 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ foreach (DataRow ro in main.Tables[0].Rows) | DATA_OP | m2.Rows.Add | (nn) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c9f7c73 | (진입점 미연결) | FP01624_WoDataPopup.cs:560 | try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | ENDPOINT | DataService.FP_UpdateBatch2 | ("PlanAmendMemo", "saveAll_planAmendMemoP", m2) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_planAmendMemoP] \| FP\Co… | 엔드포인트 호출 |  |  |  |
| AC-2097daee | (진입점 미연결) | FP01624_WoDataPopup.cs:571 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-5de7d9dc | (진입점 미연결) | FP01624_WoDataPopup.cs:575 | finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6c582094 | (진입점 미연결) | FP01624_WoDataPopup.cs:576 | finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01624_WoDataPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-430d566a | this.Load | FP01624_WoDataPopup.cs:248 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-589dd8b0 | this.Load | FP01624_WoDataPopup.cs:249 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

