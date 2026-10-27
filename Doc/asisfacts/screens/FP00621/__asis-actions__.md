# AS-IS 액션 대조표 — FP00621

> 원천: `Doc/asisfacts/screens/FP00621/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2086행 · 메서드 186 · 종류 DATA_OP 893 · RETURN 190 · UI_PROP 184 · FLAG 145 · UI_MISC 103 · MESSAGE 84 · VALUE_SET 80 · COMBO_DATA 72 · POPUP 61 · CALL_EXT 49 · GRID_SET 40 · ENDPOINT 39 · GRID_INIT 37 · STATE 36 · LIST_REBIND 16 · THROW 11 · FOCUS 10 · GRID_LOCK 9 · CALL_BASE 8 · GRID_STYLE 5 · GRID_BIND 4 · LIST_CLEAR 4 · EXCEL 3 · STATE_RESET 2 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 57


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b383a48 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7270 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fb06048 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7276 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f0390dc9 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7284 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-3f65c573 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7285 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-976d5b68 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7286 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-3aab9ba4 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7287 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-818d516b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7289 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-773b92db | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7290 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-50f2d5f2 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7291 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-56f4f836 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7292 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-86befd2d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7293 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a78ddda | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7294 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-db6f705b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7295 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-23be23ea | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7296 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-072a3b67 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7299 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-76b23066 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7484 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-80982b6b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7485 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-881f8338 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7486 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-d621b80d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7487 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-7eaa1e1c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7489 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-44da36b9 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7490 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-1345f10c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7491 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-738cb3f0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7492 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-827b4313 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7493 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-51fb9ac6 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7494 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-dc17dc1b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7495 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b3c8b31 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7496 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-8fef0f0b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7498 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4909e11 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7403 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b67c68c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7404 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b24f9388 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7405 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5237e327 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7406 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d96775f2 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7407 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a5c62bf | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7410 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-26ebac81 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7414 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1208ae03 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7415 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-03f4619d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7401 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-c8d502e0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7431 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-15aeafd2 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7434 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9119c72 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7437 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-210a8d67 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7440 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-b34c7742 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7443 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-e9f8e4c8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7446 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-99c21044 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7452 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-c7c6594c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7454 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26dc8c7f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7375 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cc63b9f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7339 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebc0e76b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7340 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f80502a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7341 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec4e456d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7342 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5fb2d884 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7343 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-47811800 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7344 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-47356296 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7346 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ecc35ec | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7347 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2e04e0e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7350 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbcdd7b3 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7351 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3fb673cc | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7352 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f741635 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7337 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-d36d2997 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7360 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c2d1875 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7361 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5735ad9 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7366 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa294032 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7312 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00621_InValidationExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe643938 | .ctor | FP00621_InValidationExcelPopup.cs:100 |  | UI_PROP | SpdSheet.shtMain | sSheetName | 속성 shtMain 설정 |  |  |  |
| AC-57d3f752 | .ctor | FP00621_InValidationExcelPopup.cs:101 |  | FLAG | _dsSheet | dsSheet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-13c1c882 | .ctor | FP00621_InValidationExcelPopup.cs:101 |  | DATA_OP | dsSheet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a765899c | .ctor | FP00621_InValidationExcelPopup.cs:102 |  | FLAG | _sMessage | sMessage | 화면 필드/플래그 변경 |  |  |  |

## FP00621_InValidationExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04d65416 | this.btnClose.Click | FP00621_InValidationExcelPopup.cs:210 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00621_InValidationExcelPopup.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6aa4922d | this.btnExport.Click | FP00621_InValidationExcelPopup.cs:258 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-a22c4237 | this.btnExport.Click | FP00621_InValidationExcelPopup.cs:259 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00621_InValidationExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3e84a70 | this.Load | FP00621_InValidationExcelPopup.cs:156 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f87a0803 | this.Load | FP00621_InValidationExcelPopup.cs:157 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a525c225 | this.Load | FP00621_InValidationExcelPopup.cs:158 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00621_InValidationExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8443c568 | this.Load | FP00621_InValidationExcelPopup.cs:150 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00621_InValidationExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f19271c7 | Dispose | FP00621_InValidationExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00621_InValidationExcelPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7b2eb1c | ExcelButton | FP00621_InValidationExcelPopup.cs:219 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00621_InValidationExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-217a59d8 | this.Load | FP00621_InValidationExcelPopup.cs:112 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-75321804 | this.Load | FP00621_InValidationExcelPopup.cs:114 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-96ecd986 | this.Load | FP00621_InValidationExcelPopup.cs:128 | if (!string.IsNullOrEmpty(_sMessage)) | MESSAGE | MessageBox.Show | (_sMessage, "Validation", MessageBoxButtons.OK, MessageBoxIcon.Information) | 메시지 표시 |  |  |  |

## FP00621_InValidationExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-067c696e | this.Load | FP00621_InValidationExcelPopup.cs:142 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-b64ed1d0 | this.Load | FP00621_InValidationExcelPopup.cs:144 |  | VALUE_SET | lblTitle.Text | " Validtion Info - CWS Minus Activated" | 컨트롤 값 설정 |  |  |  |

## FP00621_InValidationExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da0e37e1 | this.Load | FP00621_InValidationExcelPopup.cs:170 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f8cdac35 | this.Load | FP00621_InValidationExcelPopup.cs:171 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00621_InValidationExcelPopup.SetGrid_Data

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fb5ecef | this.Load | FP00621_InValidationExcelPopup.cs:228 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-723c432f | this.Load | FP00621_InValidationExcelPopup.cs:232 | try | GRID_BIND | siMain.Query | (_dsSheet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-038d5e0e | this.Load | FP00621_InValidationExcelPopup.cs:237 | try ▸ if (_dsSheet.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2b567466 | this.Load | FP00621_InValidationExcelPopup.cs:242 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00621_InValidationExcelPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14752324 | this.Load [try] | FP00621_InValidationExcelPopup.cs:182 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0825c93c | this.Load [try] | FP00621_InValidationExcelPopup.cs:183 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-9834dac6 | this.Load [try] | FP00621_InValidationExcelPopup.cs:187 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-532c5c10 | this.Load [try] | FP00621_InValidationExcelPopup.cs:188 |  | GRID_INIT | siMain.Freeze | (0, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00621_LineCN2ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09ba03a9 | this.btnButtonList.UsrButtonList_Click_Detected | FP00621_LineCN2ItemPopup.cs:255 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-0aa44827 | this.btnButtonList.UsrButtonList_Click_Detected | FP00621_LineCN2ItemPopup.cs:258 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9093c285 | this.btnButtonList.UsrButtonList_Click_Detected | FP00621_LineCN2ItemPopup.cs:259 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00621_LineCN2ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b94d63a | this.Load | FP00621_LineCN2ItemPopup.cs:131 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-37b2c6e6 | this.Load | FP00621_LineCN2ItemPopup.cs:132 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-50e39949 | this.Load | FP00621_LineCN2ItemPopup.cs:133 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00621_LineCN2ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62783d6f | this.Load | FP00621_LineCN2ItemPopup.cs:126 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00621_LineCN2ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b74d9c9 | Dispose | FP00621_LineCN2ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00621_LineCN2ItemPopup.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f20a56ad | this.Load 외 2 | FP00621_LineCN2ItemPopup.cs:202 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2c65c8b7 | this.Load 외 2 | FP00621_LineCN2ItemPopup.cs:205 |  | DATA_OP | Filter["CELL_GROUP_CODE"] | txtCellGroup.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c7ca607a | this.Load 외 2 | FP00621_LineCN2ItemPopup.cs:206 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1146b524 | this.Load 외 2 | FP00621_LineCN2ItemPopup.cs:207 |  | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-18a5338a | this.Load 외 2 | FP00621_LineCN2ItemPopup.cs:210 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => Data_FP.CallGeneralProcedure("PR_UI_FP00621_LINE_CN2_ITEM", Filter, UserInfoContext… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c7466918 | this.Load 외 2 | FP00621_LineCN2ItemPopup.cs:211 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00621_LINE_CN2_ITEM", Filter, UserInfoContext.Current.UserId, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d22a8c07 | this.Load 외 2 | FP00621_LineCN2ItemPopup.cs:218 | if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fffaf16d | this.Load 외 2 | FP00621_LineCN2ItemPopup.cs:221 | if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fef732f3 | this.Load 외 2 | FP00621_LineCN2ItemPopup.cs:223 | if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-d9c2ad6c | this.Load 외 2 | FP00621_LineCN2ItemPopup.cs:227 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00621_LineCN2ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56d99e73 | this.Load | FP00621_LineCN2ItemPopup.cs:102 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7d5de764 | this.Load | FP00621_LineCN2ItemPopup.cs:104 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_LineCN2ItemPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46cbb873 | this.Load | FP00621_LineCN2ItemPopup.cs:120 |  | VALUE_SET | txtCellGroup.Text | Filter["CELL_GROUP_CODE"] | 컨트롤 값 설정 |  |  |  |

## FP00621_LineCN2ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0131a97 | this.Load | FP00621_LineCN2ItemPopup.cs:143 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ca0b5eb | this.Load | FP00621_LineCN2ItemPopup.cs:144 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00621_LineCN2ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72f5c94e | (진입점 미연결) | FP00621_LineCN2ItemPopup.cs:163 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00621_LineCN2ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b925c2e | this.Load | FP00621_LineCN2ItemPopup.cs:150 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fe2acf59 | this.Load | FP00621_LineCN2ItemPopup.cs:151 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-9a895427 | this.Load | FP00621_LineCN2ItemPopup.cs:155 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00621_LineCN2ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-654e007e | this.spdMain.CellClick | FP00621_LineCN2ItemPopup.cs:270 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b2bf0b69 | this.spdMain.CellClick | FP00621_LineCN2ItemPopup.cs:271 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e1a1b5ed | this.spdMain.CellClick | FP00621_LineCN2ItemPopup.cs:274 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00621_LineCN2ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3490afb2 | this.spdMain.CellDoubleClick | FP00621_LineCN2ItemPopup.cs:280 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-0edb2f01 | this.spdMain.CellDoubleClick | FP00621_LineCN2ItemPopup.cs:281 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ce237725 | this.spdMain.CellDoubleClick | FP00621_LineCN2ItemPopup.cs:284 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-aeba3dbd | this.spdMain.CellDoubleClick | FP00621_LineCN2ItemPopup.cs:287 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b818b5a | this.spdMain.CellDoubleClick | FP00621_LineCN2ItemPopup.cs:297 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00621_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71d126b4 | .ctor | FP00621_MeasureSetForm_Popup.cs:95 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-2717c6f5 | .ctor | FP00621_MeasureSetForm_Popup.cs:96 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-859722d6 | .ctor | FP00621_MeasureSetForm_Popup.cs:97 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-bf41982f | .ctor | FP00621_MeasureSetForm_Popup.cs:99 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00621_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f19eb75 | this.btnOK.Click | FP00621_MeasureSetForm_Popup.cs:353 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-96b8a9a0 | this.btnOK.Click | FP00621_MeasureSetForm_Popup.cs:354 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-9758a53a | this.btnOK.Click | FP00621_MeasureSetForm_Popup.cs:361 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-180c10b3 | this.btnOK.Click | FP00621_MeasureSetForm_Popup.cs:362 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00621_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0836fc21 | this.btnSet.Click | FP00621_MeasureSetForm_Popup.cs:325 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-21041107 | this.btnSet.Click | FP00621_MeasureSetForm_Popup.cs:326 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-463c8d12 | this.btnSet.Click | FP00621_MeasureSetForm_Popup.cs:328 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a64d1269 | this.btnSet.Click | FP00621_MeasureSetForm_Popup.cs:329 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb997573 | this.btnSet.Click | FP00621_MeasureSetForm_Popup.cs:331 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-25c3c80f | this.btnSet.Click | FP00621_MeasureSetForm_Popup.cs:332 |  | UI_PROP | this.DialogResult | DialogResult.Yes | 속성 DialogResult 설정 |  |  |  |
| AC-f2524170 | this.btnSet.Click | FP00621_MeasureSetForm_Popup.cs:333 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00621_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b6ddb77 | Dispose | FP00621_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00621_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bbdda18 | this.Load | FP00621_MeasureSetForm_Popup.cs:122 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00621_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f6a7d31 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:192 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-f5461a8f | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:193 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-2a0d8ecd | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:222 |  | DATA_OP | ctrls.Add | (chk_target) | 데이터 객체 조작/조회 |  |  |  |
| AC-2416eecb | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:224 |  | DATA_OP | ctrls.Add | (chk_mppIn) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cdcf22b | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:225 |  | DATA_OP | ctrls.Add | (chk_mppOut) | 데이터 객체 조작/조회 |  |  |  |
| AC-d74085a6 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:226 |  | DATA_OP | ctrls.Add | (chk_wppIn) | 데이터 객체 조작/조회 |  |  |  |
| AC-08b1b1a5 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:227 |  | DATA_OP | ctrls.Add | (chk_wppOut) | 데이터 객체 조작/조회 |  |  |  |
| AC-34be76ca | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:229 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-c12b2e69 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-81c8e6cb | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_wip) | 데이터 객체 조작/조회 |  |  |  |
| AC-44330f3d | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_wipBD) | 데이터 객체 조작/조회 |  |  |  |
| AC-10bd897f | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_wipAD) | 데이터 객체 조작/조회 |  |  |  |
| AC-d934f3aa | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_act) | 데이터 객체 조작/조회 |  |  |  |
| AC-a10ed826 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:237 |  | DATA_OP | ctrls.Add | (chk_wipSim) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9ad5f5d | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_wipSimBD) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2feac24 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_wipSimAD) | 데이터 객체 조작/조회 |  |  |  |
| AC-55671fa7 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_pkgProcDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce82a77f | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_pkgQty) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd53e302 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_actSim) | 데이터 객체 조작/조회 |  |  |  |
| AC-28e5dd6a | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:245 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-6016a4d4 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:249 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a616b59 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_setup) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9aa42ee | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:251 |  | DATA_OP | ctrls.Add | (chk_capa) | 데이터 객체 조작/조회 |  |  |  |
| AC-124180e3 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:252 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-3faad513 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:254 |  | DATA_OP | ctrls.Add | (chk_off) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a80d9b9 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_total_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bea0dcd | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:258 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-cc0e0323 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:258 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-ce101a06 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:265 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-8fd2c599 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:269 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-7bb493d0 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:273 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00621_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0bd7d12 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_target.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f0301bdd | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_mppIn.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b5918f3a | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_mppOut.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-fbc73d6b | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_wppIn.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ab9b9681 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_wppOut.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a3086da1 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6b767255 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-068f2d08 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_wip.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-56321a34 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_wipBD.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e2204eef | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_wipAD.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a8a0b8c5 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_act.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-26f40de4 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_wipSim.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ca2bd9bd | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_wipSimBD.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e0780e1d | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_wipSimAD.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2094adba | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_pkgProcDate.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-581b5fa8 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_pkgQty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-fe43f01f | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_actSim.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3cc65c48 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-dd4add72 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_off.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-777deb9e | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_setup.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6ad8d7b1 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_capa.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b121c93b | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:167 |  | VALUE_SET | chk_memo_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7cd78d26 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ae38d204 | this.Load 외 1 | FP00621_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_total_2.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00621_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ac4a47e | (진입점 미연결) | FP00621_MeasureSetForm_Popup.cs:417 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-bb009bf5 | (진입점 미연결) | FP00621_MeasureSetForm_Popup.cs:428 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30d51935 | (진입점 미연결) | FP00621_MeasureSetForm_Popup.cs:439 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00621_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55fed28d | this.Load | FP00621_MeasureSetForm_Popup.cs:109 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6cc1f529 | this.Load | FP00621_MeasureSetForm_Popup.cs:117 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00621_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab2059ea | this.btnSet.Click 외 1 | FP00621_MeasureSetForm_Popup.cs:373 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-da945189 | this.btnSet.Click 외 1 | FP00621_MeasureSetForm_Popup.cs:381 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-d376b868 | this.btnSet.Click 외 1 | FP00621_MeasureSetForm_Popup.cs:381 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-121a791d | this.btnSet.Click 외 1 | FP00621_MeasureSetForm_Popup.cs:409 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac9988a1 | .ctor | FP00621_PlanAmend_Line_Formation.cs:214 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-9f755c87 | .ctor | FP00621_PlanAmend_Line_Formation.cs:215 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00621_PlanAmend_Line_Formation.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SELECT") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda ▸ try] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ lambda ▸ try] / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be8286e3 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1479 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-df9760c3 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1480 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-625cbb87 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1481 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d93c6551 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1482 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2c154a8f | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1483 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c7ab5801 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1484 |  | FLAG | dsBoh | null | 화면 필드/플래그 변경 |  |  |  |
| AC-29885bdc | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1486 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9cd7414b | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1490 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ea950d6c | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1492 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bebea035 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1493 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c58dda47 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1494 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-93e009a9 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1495 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-fdf2823b | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1496 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca7e2770 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1497 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b8ed48cc | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1499 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00621_Amend") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-383e30c3 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1503 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5011a701 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1504 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-380a4ea4 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1505 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a8685283 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1506 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c652f718 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1518 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-8ecd0b76 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1525 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-be5bcff6 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1526 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-966e4696 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1527 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7955e381 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1539 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-cd87e7b9 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1540 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-620d4486 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1541 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-6300bcbb | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1542 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-f714a890 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1543 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-8ff43847 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1544 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-82ff528e | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1545 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00621_PlanAmend_Line_Formation.ApplyAmendCalendarCondition_ForExcel

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff084f33 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6203 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fc0b9d83 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6204 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7f5d4825 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6205 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-786e20a4 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6206 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-62f9d063 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6207 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-99221810 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6208 |  | FLAG | dsShorterLT | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6e5efd73 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6221 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2bd62c40 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6225 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8c737b34 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6227 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-96cd9386 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6228 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-88d393dc | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6229 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8da292e1 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6230 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-33313c14 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6231 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dd927512 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6232 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-63f04052 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6237 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00621_Amend") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a4df5d8d | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6239 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54338404 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6240 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-845f08c2 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6241 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1cf25635 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6242 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89c183ca | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6243 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-901864d5 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6244 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-890dbd3f | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6245 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b267f742 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6248 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-51946264 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6249 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-6c24d1ac | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6250 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-90d67b33 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6251 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-f2c96884 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6252 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-67ec17ff | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6253 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-599ad094 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6254 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00621_PlanAmend_Line_Formation.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda ▸ try] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ lambda ▸ try] / thi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94444835 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1414 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; if (GetFilter("INSTANCE_ID") == "") … | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf9aeab7 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1420 | lambda ▸ if (GetFilter("INSTANCE_ID") == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { SetFilter("INSTANCE_ID", CString.GetCheckedListValue(dtIn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-10f8f3de | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1428 | lambda | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["PLAN_DATE"] = sCalendar_planday.DateTime.ToString… | ⚠ 의미 확인 필요 |  |  |  |
| AC-77d5381a | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1430 | lambda ▸ lambda | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-4de4b1cb | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1431 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-47c99689 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1432 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-36894600 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1442 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5d07f774 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1448 | lambda | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cbo_fpplanid.SelectedIndex >= 0) { Filter["PLAN_ID"] … | ⚠ 의미 확인 필요 |  |  |  |
| AC-32c1c7fa | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1452 | lambda ▸ lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-0df60e26 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1457 | lambda | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_R" | 행/컬럼 값 대입 |  |  |  |
| AC-d34a2a56 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1458 | lambda | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-743e47f0 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1459 | lambda | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_FORM_BOR_R" | 행/컬럼 값 대입 |  |  |  |
| AC-57c612d5 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1460 | lambda | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_FORM_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-17b2536a | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1461 | lambda | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_FORM_UTIL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-5bbef96f | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1465 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_H" | 행/컬럼 값 대입 |  |  |  |
| AC-3f558037 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1466 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H" | 행/컬럼 값 대입 |  |  |  |
| AC-8921a3f1 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1467 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_FORM_BOR_H" | 행/컬럼 값 대입 |  |  |  |
| AC-f10f25df | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1468 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_FORM_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-a866dfad | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1469 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_FORM_UTIL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-d639b077 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1472 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a64441ec | this.btnBucket.Click | FP00621_PlanAmend_Line_Formation.cs:3374 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-8363d466 | this.btnBucket.Click | FP00621_PlanAmend_Line_Formation.cs:3376 |  | POPUP | new FP00599_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-62f826c3 | this.btnBucket.Click | FP00621_PlanAmend_Line_Formation.cs:3377 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fa41a4ad | this.btnBucket.Click | FP00621_PlanAmend_Line_Formation.cs:3378 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-ccda58f9 | this.btnBucket.Click | FP00621_PlanAmend_Line_Formation.cs:3379 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1b290dfc | this.btnBucket.Click | FP00621_PlanAmend_Line_Formation.cs:3383 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-2cfc933f | this.btnBucket.Click | FP00621_PlanAmend_Line_Formation.cs:3392 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bb92c291 | this.btnBucket.Click | FP00621_PlanAmend_Line_Formation.cs:3394 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6edd885f | this.btnBucket.Click | FP00621_PlanAmend_Line_Formation.cs:3397 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6589a29e | this.btnBucket.Click | FP00621_PlanAmend_Line_Formation.cs:3406 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f15abbc6 | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3319 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-15efdc1b | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3321 |  | POPUP | new FP00621_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-89c1a93f | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3322 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-59f93074 | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3323 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c5d66c6a | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3324 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-133400f5 | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3328 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-acce26a3 | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3337 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bbcb641c | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3339 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-09a2a4d7 | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3342 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b126c295 | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3351 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8d6096f2 | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3356 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-5a5863a6 | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3359 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2bbbb361 | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3361 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-25100bd2 | this.btnCatagory.Click | FP00621_PlanAmend_Line_Formation.cs:3364 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e392fdc9 | this.btnColumn.Click | FP00621_PlanAmend_Line_Formation.cs:3293 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a44f0abe | this.btnColumn.Click | FP00621_PlanAmend_Line_Formation.cs:3295 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-7209cce5 | this.btnColumn.Click | FP00621_PlanAmend_Line_Formation.cs:3296 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-37c24b41 | this.btnColumn.Click | FP00621_PlanAmend_Line_Formation.cs:3297 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-69d02371 | this.btnColumn.Click | FP00621_PlanAmend_Line_Formation.cs:3303 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-b5e1f545 | this.btnColumn.Click | FP00621_PlanAmend_Line_Formation.cs:3303 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-adfc187c | this.btnColumn.Click | FP00621_PlanAmend_Line_Formation.cs:3304 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-b0a15616 | this.btnColumn.Click | FP00621_PlanAmend_Line_Formation.cs:3310 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnCreatePlan_Click

진입점: this.btnCreatePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48d11aa1 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3553 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-ef60a0e2 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3554 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-d5101594 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3562 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b56fae23 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3563 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e80f909 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3573 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-858fdfe4 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3575 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-67555f5e | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3581 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c7f4ad5 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3582 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b420a3ee | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3587 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7809274 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3588 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b2192114 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3591 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2099cf43 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3592 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f124415b | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3593 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb1acfa5 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3599 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-aeb25a53 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3602 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-f1ca6dc5 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3603 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ab222149 | this.btnCreatePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3604 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnDppWppCopyDwSubmit_Click

진입점: this.btnDppWppCopyDwSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f429bb12 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4024 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-8c892be1 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4025 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-acab15d8 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4033 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-664d3350 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4034 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bab9a600 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4038 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ed946062 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4044 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-e91804fa | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4045 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58462872 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4052 | if (string.IsNullOrEmpty(Filter["PLAN_ID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3cf29e55 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4053 | if (string.IsNullOrEmpty(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af9c564b | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4059 | if (Filter["PLAN_TYPE"].ToString() != "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0dd84325 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4060 | if (Filter["PLAN_TYPE"].ToString() != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60031a54 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4063 |  | POPUP | new FPC0125_MWPPCopyDWSubmitPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5a14cc1d | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4064 |  | UI_PROP | CopySubmit.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-6e15bc56 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4064 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3bbb0ac5 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4065 |  | DATA_OP | CopySubmit.Filter["SUBMIT_TYPE"] | "FORM" | 행/컬럼 값 대입 |  |  |  |
| AC-2a1ed7b2 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4066 |  | DATA_OP | CopySubmit.Filter["MASTER_ID"] | CopySubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d154b8da | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4066 |  | DATA_OP | CopySubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6e85025f | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4067 |  | DATA_OP | CopySubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-62dfea40 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4068 |  | DATA_OP | CopySubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-5dbff642 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4069 |  | DATA_OP | CopySubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9f319ec5 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4070 |  | DATA_OP | CopySubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-157abb5b | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4071 |  | DATA_OP | CopySubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-da24c6c6 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4072 |  | DATA_OP | CopySubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-acd14c3d | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4073 |  | DATA_OP | CopySubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d5b5c26a | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4074 |  | DATA_OP | CopySubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-45d7dfb0 | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4075 |  | DATA_OP | CopySubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b57f2bcd | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4077 |  | UI_PROP | CopySubmit.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-177621dd | this.btnDppWppCopyDwSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4078 |  | POPUP | CopySubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnDWSubmit_Click

진입점: this.btnDWSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8618033 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3956 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-27ed71a1 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3957 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-d9ae96f1 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3965 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a66ab5d3 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3966 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd537e58 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3970 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a8486ba7 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3976 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-0b69eb97 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3977 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce924efa | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3984 | if (string.IsNullOrEmpty(Filter["PLAN_ID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-881e2d10 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3985 | if (string.IsNullOrEmpty(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d914e23e | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3991 | if (Filter["PLAN_TYPE"].ToString() != "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b203739b | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3992 | if (Filter["PLAN_TYPE"].ToString() != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1cb7699 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3996 |  | DATA_OP | DwSubmit.Filter["SUBMIT_TYPE"] | "FORM" | 행/컬럼 값 대입 |  |  |  |
| AC-82061d4d | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3997 |  | DATA_OP | DwSubmit.Filter["MASTER_ID"] | DwSubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ff937fde | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3997 |  | DATA_OP | DwSubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-031e0b39 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3998 |  | DATA_OP | DwSubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-2e946349 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:3999 |  | DATA_OP | DwSubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-8ce5ac98 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4000 |  | DATA_OP | DwSubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7bde44ab | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4001 |  | DATA_OP | DwSubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ef758165 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4002 |  | DATA_OP | DwSubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-caecbea7 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4003 |  | DATA_OP | DwSubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6cb839b1 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4004 |  | DATA_OP | DwSubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7516d8ce | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4005 |  | DATA_OP | DwSubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5d071e7b | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4006 |  | DATA_OP | DwSubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-36f899a7 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4007 |  | DATA_OP | DwSubmit.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c69b7ef7 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4008 |  | DATA_OP | DwSubmit.Filter["CONFIRM_TYPE"] | DwSubmit.Filter["CONFIRM_AREA"] = Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-df8bfa3e | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4008 |  | DATA_OP | DwSubmit.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-80a4fe4d | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4010 |  | UI_PROP | DwSubmit.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a727dc37 | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4012 |  | POPUP | DwSubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4b0a382e | this.btnDWSubmit.Click | FP00621_PlanAmend_Line_Formation.cs:4015 | if (DwSubmit.ShowDialog() == DialogResult.OK) | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64d91733 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4097 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d33ec9d5 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4098 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-655f1cc7 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4104 | if (FindDone == false) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-2adda909 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4105 | if (FindDone == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40e64c22 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4118 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-7b80ffb7 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4123 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_isCurrWeek", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] \| FP\Common\X… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6e62b444 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4124 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["CURR_DATE"] | ds_isCurrWeek.Tables[0].Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8fce187 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4129 | else of (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_CurrUTDate", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-36973de7 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4136 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-bf9b2155 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4137 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bfd1115c | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4138 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-838beafe | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4140 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4692b91c | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4147 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP00607_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-d10cc7b1 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4149 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | this.Filter | 화면 필드/플래그 변경 |  |  |  |
| AC-431ec0ab | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4152 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.CELL | 속성 DateColumnType 설정 |  |  |  |
| AC-fd9e206f | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4155 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d50204e6 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4156 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-bad5c94b | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4157 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9f2e307f | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4158 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-006bd67c | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4159 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ceefd4d5 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4160 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2bb1ff16 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4161 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-141c0173 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4166 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-7f8ed32e | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4167 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-16257b25 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4168 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-03135669 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4169 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["CELL_GROUP_CODE"] | "Cell Group" | 행/컬럼 값 대입 |  |  |  |
| AC-ad379a5a | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4170 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-185fb9ee | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4172 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-ae3348db | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4173 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-f1a2e0f1 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4175 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-16a4b51c | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4176 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-e502ba6d | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4177 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-6729578e | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4178 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-e44be2bf | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4179 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-751b13fe | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4180 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-6119cebe | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4181 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-1c573bb5 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4182 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-7896efd5 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4187 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnSearchData | ExcelPopup_Search_Column | 속성 OnSearchData 설정 |  |  |  |
| AC-ef785c92 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4188 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Column | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-746611b0 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4189 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Column | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-c5863207 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4190 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-ab5171e2 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4191 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | FP00599_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-8f4d7a40 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4193 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | colPopup._PlanDate | Filter["CURR_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-f5e0908c | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4194 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | colPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-18c2e4c8 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4196 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a332d602 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4206 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-53e741e8 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4222 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | POPUP | new Planning.UIL.FP00621_InValidationExcelPopup | ("InvalidationCWSPopup", dsCWAActive, sMsg2) | 팝업/폼 생성 |  |  |  |
| AC-26e9bcdd | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4223 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-336b74b3 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4224 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dfe5002a | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4229 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ece611ba | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4239 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP00607_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-f281921e | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4241 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | this.Filter | 화면 필드/플래그 변경 |  |  |  |
| AC-9d60c6ca | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4245 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-471631c6 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4246 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ae2f46cc | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4247 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-01003249 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4248 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-23708cdb | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4249 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-99577610 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4250 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4f7f9c7e | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4251 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f3ec7a9d | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4252 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f4376123 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4253 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1d7f60ec | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4257 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-69f67656 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4258 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-ce3debe8 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4259 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-f9a2da55 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4260 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["CELL_GROUP_CODE"] | "Cell Group" | 행/컬럼 값 대입 |  |  |  |
| AC-b9cac7e0 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4261 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-4ef3691d | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4263 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-79dc66b1 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4264 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-a1723385 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4266 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-c42c2dd0 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4267 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-e7341d2c | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4268 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-df0f8c83 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4269 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-84e253fd | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4270 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-908310b6 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4271 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-f95e8a66 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4272 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-3f291d4c | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4273 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-c25f3224 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4274 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-19b3fc25 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4275 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["QTY"] | "QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-9554475d | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4276 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-22b3eb81 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4280 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnSearchData | ExcelPopup_Search_Row | 속성 OnSearchData 설정 |  |  |  |
| AC-d3bfecb7 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4281 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Row | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-82d97e9d | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4282 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Row | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-906f0cff | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4283 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-3f703fde | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4285 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | rowPopup._PlanDate | Filter["CURR_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-dbdcd8f6 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4286 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | rowPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-7b32e039 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4288 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e2c709d0 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4298 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cb80be40 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4314 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | POPUP | new Planning.UIL.FP00621_InValidationExcelPopup | ("InvalidationCWSPopup", dsCWAActive, sMsg2) | 팝업/폼 생성 |  |  |  |
| AC-1b8ca559 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4315 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3251f87a | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4316 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1c0df149 | this.btnExcelImport.Click | FP00621_PlanAmend_Line_Formation.cs:4321 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (rowPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLA… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a1d6744 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3755 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-548f42fa | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3756 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-c8660a84 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3764 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd152c16 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3765 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-41348b6c | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3771 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-fa0bdd2a | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3772 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c626b88 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3777 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4f1c519e | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3778 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-ba34a555 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3779 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-df1d22b2 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3779 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-18833d09 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3780 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-236ecd3a | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3781 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-00c0d5b8 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3782 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2d3cde53 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3782 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4bb3fb18 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3783 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4f14ad1b | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3784 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-21d3f9d9 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3785 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-71529fee | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3786 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5451bea8 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3787 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7ff6f397 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3788 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-989adbe3 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3789 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-364af751 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3790 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e3367c97 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3791 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2f1c7a9c | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3793 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-99407804 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3794 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-135da4df | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3795 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-c71f64c5 | this.btnMemo.Click | FP00621_PlanAmend_Line_Formation.cs:3796 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnMenu_Click

진입점: this.btnMenu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84aaa3f8 | this.btnMenu.Click | FP00621_PlanAmend_Line_Formation.cs:4337 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnMenu, menuPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f67c2ea | this.btnMenu.Click | FP00621_PlanAmend_Line_Formation.cs:4337 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnMRP_Click

진입점: this.btnMRP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76e0c6a1 | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3500 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-c868da15 | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3501 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-019e4ae3 | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3509 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c7c5bf4 | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3510 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-582b0a4c | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3515 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3e895558 | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3521 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-e13f1866 | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3522 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f308a7a3 | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3528 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-aeae52aa | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3529 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13cdd31e | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3534 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-bf4627f6 | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3535 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a391d691 | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3539 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-fccf8e2d | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3540 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04d47a3e | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3541 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5dd7b250 | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3543 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-0f6828b2 | this.btnMRP.Click | FP00621_PlanAmend_Line_Formation.cs:3545 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnRelease_Click

진입점: this.btnRelease.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca06ac07 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3620 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-33db2b2a | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3621 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-78bbda07 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3629 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9a8e20cf | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3630 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b724e8be | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3650 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4eb4085d | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3651 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6c5d2d1 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3654 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_instanceInfo", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0e656fa7 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3655 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_planInfo", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c65773f8 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3659 | if (dtPlanInfo != null) | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b33aa0e | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3666 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3fd3a13 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3670 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c8b741ec | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3671 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7fdc4f2 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3678 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7e3d978e | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3679 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16ab18f0 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3686 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-64ddf986 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3689 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9b278533 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3691 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-06867706 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3697 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b1a51b5 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3698 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9556b6f3 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3711 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bad279aa | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3712 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-080cfa6a | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3724 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-eba29214 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3727 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-fef33509 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3728 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f7a21869 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3729 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2bc6d2ea | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3739 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-11ea08b3 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3742 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-eac8ef85 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3743 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fd175309 | this.btnRelease.Click | FP00621_PlanAmend_Line_Formation.cs:3744 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnRePlan_Click

진입점: this.btnRePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3369f9ed | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3421 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-0a66fcd7 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3422 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-4bf999a3 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3430 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de791f87 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3431 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db82c0af | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3440 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9fb6b0c8 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3441 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cbb540a4 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3447 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release Plan cant't Re-Release.!") | 메시지 표시 |  |  |  |
| AC-f909f587 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3448 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6cfbcbe7 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3453 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-908a92f8 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3458 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0bce436a | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3465 | if (Convert.ToInt32(dtPlanRunFlag.Rows[0]["CNT"].ToString()) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9231c08c | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3466 | if (Convert.ToInt32(dtPlanRunFlag.Rows[0]["CNT"].ToString()) > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b2b8ac03 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3481 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-b59d5898 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3484 |  | POPUP | new FP00590_RePlanTotalPopup | (pSite, pInstance, pPlanDate, pPlanID, pPlanType, pComfirmArea, pIsSamePlanID, pUseWoWStat… | 팝업/폼 생성 |  |  |  |
| AC-35af82f3 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3485 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-faff4ee3 | this.btnRePlan.Click | FP00621_PlanAmend_Line_Formation.cs:3486 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnSimulation_Click

진입점: this.btnSimulation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1080604 | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3806 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-461f9ad5 | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3807 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-e5f2ac7a | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3815 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2ae868f | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3816 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-767942df | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3822 | if (_sSaveAuth != "Y") | MESSAGE | MessageBox.Show | ("Save Authority not have.!") | 메시지 표시 |  |  |  |
| AC-462829a7 | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3823 | if (_sSaveAuth != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d0cc0ff | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3827 | if (Filter["READ_ONLY"].ToString() == "Y") | MESSAGE | MessageBox.Show | ("Release plan can not be calculated.!") | 메시지 표시 |  |  |  |
| AC-8d3d1fc5 | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3828 | if (Filter["READ_ONLY"].ToString() == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a80f233e | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3833 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "FP Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a7caac40 | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3834 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e9f531e4 | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3837 |  | MESSAGE | MessageBox.Show | ("do you Excution?", "Excute", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-2b400a5f | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3842 | if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a51b66ad | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3847 | if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtChk.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-7026877b | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3848 | if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtChk.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b741aeed | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3863 | if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (bRtn1) | MESSAGE | MessageBox.Show | ("PSI Calculation Excution Completed.!") | 메시지 표시 |  |  |  |
| AC-f18bac5d | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3879 | if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (bRtn1) ▸ if (Filter["INSTANCE_ID"].ToS… | POPUP | new Planning.UIL.FP00621_InValidationExcelPopup | ("InvalidationCWSPopup", dsCWAActive, "Activated Stock < 0") | 팝업/폼 생성 |  |  |  |
| AC-831291df | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3880 | if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (bRtn1) ▸ if (Filter["INSTANCE_ID"].ToS… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7802302e | this.btnSimulation.Click | FP00621_PlanAmend_Line_Formation.cs:3881 | if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (bRtn1) ▸ if (Filter["INSTANCE_ID"].ToS… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55778edc | this.btnSql.Click | FP00621_PlanAmend_Line_Formation.cs:4345 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-c214f4a8 | this.btnSql.Click | FP00621_PlanAmend_Line_Formation.cs:4348 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-96a9d24c | this.btnSql.Click | FP00621_PlanAmend_Line_Formation.cs:4349 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-22fdaa64 | this.btnSql.Click | FP00621_PlanAmend_Line_Formation.cs:4351 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00621_AMEND_LINE_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-60eb54d9 | this.btnSql.Click | FP00621_PlanAmend_Line_Formation.cs:4352 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00621_AMEND_LINE_TOTAL_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-bded786f | this.btnSql.Click | FP00621_PlanAmend_Line_Formation.cs:4353 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00621_AMEND_LINE_DATA_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-84f781d5 | this.btnSql.Click | FP00621_PlanAmend_Line_Formation.cs:4354 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00621_AMEND_LINE_BOH_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6d0ca65 | this.btnSql.Click | FP00621_PlanAmend_Line_Formation.cs:4355 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00621_EXCEL_SELECT_COLTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-49f5ce89 | this.btnSql.Click | FP00621_PlanAmend_Line_Formation.cs:4356 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00621_EXCEL_SELECT_ROWTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5b9350f | this.btnSql.Click | FP00621_PlanAmend_Line_Formation.cs:4357 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00621_SELECT_CWA_MINUS_ACTIVED") | 데이터 객체 조작/조회 |  |  |  |
| AC-83fa00a0 | this.btnSql.Click | FP00621_PlanAmend_Line_Formation.cs:4358 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00621_PlanAmend_Line_Formation.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8ae7bb1 | this.btnToggleSave.Click | FP00621_PlanAmend_Line_Formation.cs:3414 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12371ae7 | this.button1.Click | FP00621_PlanAmend_Line_Formation.cs:4086 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.cbo_fpplanid_changed

진입점: this.Load [try] / cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87847e32 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3105 | if (cbo_fpplanid.Items.Count > 0) ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-8b055e3b | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3106 | if (cbo_fpplanid.Items.Count > 0) ▸ if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-335fbf8f | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3113 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-5fd3243b | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3114 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-91041f5e | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3133 | if (cbo_fpplanid.Items.Count > 0) ▸ if (sReadyOnly.Equals("Y")) | FLAG | bReadOnly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c739ad80 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3134 | if (cbo_fpplanid.Items.Count > 0) ▸ if (sReadyOnly.Equals("Y")) | STATE | btnSimulation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6be4062a | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3138 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (sReadyOnly.Equals("Y")) | FLAG | bReadOnly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-89287b07 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3139 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (sReadyOnly.Equals("Y")) | STATE | btnSimulation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2c76a089 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3143 | if (cbo_fpplanid.Items.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRePlan.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3788bc0c | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3145 | if (cbo_fpplanid.Items.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRePlan.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6c924bec | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3148 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[selected]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-9c225820 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3149 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[selected]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-c9abeb23 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3150 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[selected]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-ae86c289 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3151 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[selected]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-6d7840d3 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3152 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[selected]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-25ab403d | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3154 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-4d90995a | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3155 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-07dd8d43 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3156 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-1f1cf268 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3157 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-df90caa4 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3158 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-7da2a3e9 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3162 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-73c83bd7 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3163 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-4f76fd18 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3164 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-83b025c0 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3165 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-3c522f6a | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3166 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-e1ffa9fd | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3168 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-ae8c06f4 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3169 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-49d84dae | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3170 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-06ed9f4a | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3171 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-bcf460af | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:3172 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Cbo_fpplanid_MouseClick

진입점: cbo_fpplanid.MouseClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27cd30af | cbo_fpplanid.MouseClick | FP00621_PlanAmend_Line_Formation.cs:317 | if (!Cbo_fpplanid_ClickChk) | UI_PROP | cbo_fpplanid.Cursor | Cursors.WaitCursor | 속성 Cursor 설정 |  |  |  |
| AC-b163a8af | cbo_fpplanid.MouseClick | FP00621_PlanAmend_Line_Formation.cs:318 | if (!Cbo_fpplanid_ClickChk) | FLAG | Cbo_fpplanid_ClickChk | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a3747019 | cbo_fpplanid.MouseClick | FP00621_PlanAmend_Line_Formation.cs:323 | if (!Cbo_fpplanid_ClickChk) | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00607_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d870feea | cbo_fpplanid.MouseClick | FP00621_PlanAmend_Line_Formation.cs:323 | if (!Cbo_fpplanid_ClickChk) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4e4a8df0 | cbo_fpplanid.MouseClick | FP00621_PlanAmend_Line_Formation.cs:324 | if (!Cbo_fpplanid_ClickChk) | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-78630e2f | cbo_fpplanid.MouseClick | FP00621_PlanAmend_Line_Formation.cs:325 | if (!Cbo_fpplanid_ClickChk) | UI_PROP | cbo_fpplanid.Cursor | Cursors.Arrow | 속성 Cursor 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Cbo_fpplanid_MouseDown

진입점: cbo_fpplanid.MouseDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-753faaae | cbo_fpplanid.MouseDown | FP00621_PlanAmend_Line_Formation.cs:309 |  | FLAG | Cbo_fpplanid_ClickChk | false | 화면 필드/플래그 변경 |  |  |  |

## FP00621_PlanAmend_Line_Formation.CheckAndGetMeasure

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y") ▸ if (do_edit_mode)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y") ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43336d06 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:1628 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa617599 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:1628 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-f426f43a | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:1630 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00621_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc94ab5b | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:1630 |  | POPUP | new FP00621_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-91e853fc | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:1631 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c181dd3c | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:1631 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP00621_PlanAmend_Line_Formation.chk_includeSubOp_onchanged

진입점: this.chk_includeSubOp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b8f080b | this.chk_includeSubOp.CheckedChanged | FP00621_PlanAmend_Line_Formation.cs:3276 | if (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-01be11a9 | this.chk_includeSubOp.CheckedChanged | FP00621_PlanAmend_Line_Formation.cs:3278 | else of (chk_includeSubOp.Checked == true) | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |

## FP00621_PlanAmend_Line_Formation.chk_Info_CheckedChanged

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a4a42c0 | this.chk_Info.CheckedChanged | FP00621_PlanAmend_Line_Formation.cs:8212 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-c9dfe1d5 | this.chk_Info.CheckedChanged | FP00621_PlanAmend_Line_Formation.cs:8212 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d39d4445 | this.chk_Info.CheckedChanged | FP00621_PlanAmend_Line_Formation.cs:8218 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-4ba1db29 | this.chk_Info.CheckedChanged | FP00621_PlanAmend_Line_Formation.cs:8219 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00621_PlanAmend_Line_Formation.CreateEditDataGridDataSet

진입점: SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a814a14 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6030 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-fd21610a | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6031 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1304ed35 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6032 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d78b67b8 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6033 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6348dcbd | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6034 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1531808 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6035 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9145602 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6036 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-84b126e4 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6037 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb911c1a | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6038 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c923e92 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6039 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-77a03739 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6040 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6689d24 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6041 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1c4a4f2 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6042 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a19356c | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6043 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd9ffc70 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6044 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e91faa60 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6045 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d64e5d0 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6046 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-20f22df8 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6047 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-da1b005a | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6048 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CUSTOMER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-019e16ab | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6049 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc1f1cde | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6050 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8ffd3ee | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6051 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-123e91db | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6052 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-625a5720 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6053 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5867943e | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6054 |  | DATA_OP | dt.Columns.Add | (new DataColumn("WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-69c21e9b | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6056 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c29cc630 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6057 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-afa247ab | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6058 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-65e17934 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6059 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5d46893 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6060 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8eacfce6 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6062 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ACTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2948dd84 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6063 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e15d6bde | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6069 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-92812177 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ if (dt ==… | FP00621_PlanAmend_Line_Formation.cs:6072 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.CreateEditShorterLTDataTable

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ try ▸ if (dtShorter == null)] / menu_line.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == t…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0b12b6f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:6012 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-012ceef3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:6014 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1694488f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:6015 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-673aa2b8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:6016 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d495fbdc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:6017 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b0ec3c0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:6018 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-23c96fdc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:6019 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddc62f9c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:6020 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9caacb4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:6021 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-02392213 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:6022 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SHORTER_LT", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-40b36fdf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:6024 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.CreateExelBufferDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b9d0b14 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6261 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-7c907e07 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6262 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb63d683 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6263 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce52c4be | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6264 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e61fcc0f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6265 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-21f0711d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6266 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a93792e4 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6267 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-04a64a2c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6268 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a1bec29 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6269 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4893645 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6270 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-19e92e9f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6271 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c57df826 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6272 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff95ab85 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6273 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-85f842d6 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6274 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b7b28d0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6275 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a1a4d37 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6276 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-28070eb0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6277 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a28f21cf | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6278 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4d74398 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6279 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JOB_ORDER", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-62f29d35 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6281 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83079556 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1637 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-fa057971 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1648 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-a7c490c1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1649 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-dd4704cc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1660 | if (measure["chk_target"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "TARGET")) | 데이터 객체 조작/조회 |  |  |  |
| AC-63681466 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1665 | if (measure["chk_mppIn"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-65ac9517 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1669 | if (measure["chk_mppOut"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bff26ed9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1673 | if (measure["chk_wppIn"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-66fd7c18 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1677 | if (measure["chk_wppOut"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-adec0a65 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1683 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4183503 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1687 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9c2fb6a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1691 | if (measure["chk_wip"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f67945e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1697 | if (measure["chk_wipBD"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WIP_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-899858c6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1701 | if (measure["chk_wipAD"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WIP_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3b434d1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1705 | if (measure["chk_act"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_ACT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffaa1c4d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1709 | if (measure["chk_wipSim"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_AGINGWIPSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5cbf046 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1715 | if (measure["chk_wipSimBD"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_AGINGWIPSIM_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3f9be8e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1719 | if (measure["chk_wipSimAD"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_AGINGWIPSIM_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aef58715 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1723 | if (measure["chk_pkgProcDate"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_PKGPLANDATE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-74ea2273 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1729 | if (measure["chk_pkgQty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_PKGQTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1524fa1f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1733 | if (measure["chk_actSim"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_ACTSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4273279 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1737 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", MEMO_COLUMN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-68c90ce5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1744 | if (measure["chk_setup"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SETUP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2576a82d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1748 | if (measure["chk_capa"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CAPA")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6a32da3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1752 | if (measure["chk_off"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "OFF")) | 데이터 객체 조작/조회 |  |  |  |
| AC-69ccb30f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1760 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_memo_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", MEMO_COLUMN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6c457b7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1762 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TARGET")) | 데이터 객체 조작/조회 |  |  |  |
| AC-708023aa | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1763 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-69015eb2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1764 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6525d3e8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1765 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7484376 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1766 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-81bbd632 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1767 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff38558e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1768 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3b43f9f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1769 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WIP_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8c92857 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1770 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WIP_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e2e6d56 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1771 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_ACT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-29f14187 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1772 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_AGINGWIPSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-608edd3f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1773 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_AGINGWIPSIM_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-364a5b12 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1774 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_AGINGWIPSIM_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-06397067 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1775 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_PKGPLANDATE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3dc22b87 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1776 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_PKGQTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-42fa711d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1777 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_ACTSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5824bca | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1778 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SETUP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1dc2e67d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1779 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "CAPA")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8f1d085 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1780 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "OFF")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4453a394 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1785 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "TARGET")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c45b1284 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1786 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-936d6cae | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1787 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4902e670 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1788 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9104cefd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1789 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d45a180 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1790 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec5b6395 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1791 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7adb57f8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1792 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WIP_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e56bc92 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1793 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WIP_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3dd024e1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1794 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_ACT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-07a4641b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1795 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_AGINGWIPSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0572c2b8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1796 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_AGINGWIPSIM_BD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3753489d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1797 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_AGINGWIPSIM_AD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c652927b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1798 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_PKGPLANDATE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a51fa44 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1799 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_PKGQTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6731bbb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1800 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_ACTSIM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-43299de2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1801 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SETUP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a9db727 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1802 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "CAPA")) | 데이터 객체 조작/조회 |  |  |  |
| AC-15e0c321 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1803 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "OFF")) | 데이터 객체 조작/조회 |  |  |  |
| AC-457ea9e1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1819 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-404c317c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1826 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ff12065 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1831 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-556b97ed | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1835 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-627a97c2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1837 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37301d23 | this.Load | FP00621_PlanAmend_Line_Formation.cs:497 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9401911f | this.Load | FP00621_PlanAmend_Line_Formation.cs:498 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea879a5e | this.Load | FP00621_PlanAmend_Line_Formation.cs:499 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00621_PlanAmend_Line_Formation.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab58dae4 | dCalendar_planrange.ValueChanged | FP00621_PlanAmend_Line_Formation.cs:3250 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-745ce1b1 | dCalendar_planrange.ValueChanged | FP00621_PlanAmend_Line_Formation.cs:3256 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-306cc2e8 | dCalendar_planrange.ValueChanged | FP00621_PlanAmend_Line_Formation.cs:3257 | if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Delete_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b4695ab | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7188 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-864deeb9 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7189 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7c5ef4bb | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7191 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b4cb0546 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7192 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c0034737 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7193 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-989a7b55 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7194 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f83ee50e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7195 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7e896967 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7196 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-03e63c72 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7197 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c6494f81 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7198 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1feb78d1 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7199 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-19e4a93c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7200 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f334662a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7201 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d013fd87 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7203 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b6631338 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7211 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-94a6e7a7 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7215 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-1161a06f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7216 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d59b1bb | DeleteButton | FP00621_PlanAmend_Line_Formation.cs:871 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00621_PlanAmend_Line_Formation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae89d0f9 | Dispose | FP00621_PlanAmend_Line_Formation.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00621_PlanAmend_Line_Formation.DrawHeader

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81213b39 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7579 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-dc23fe45 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7583 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-8965a929 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7584 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7606953 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7585 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2313f3f9 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7586 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-404cda89 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7587 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-63ae7e3c | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7591 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-ff376b2e | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7592 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-8e1a71c1 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7593 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-2e331f3f | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7594 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-63341441 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7600 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-c4a04236 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7601 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d18eff4d | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7634 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-904b9735 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7639 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, FPExtensions.DateColumnT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0ef6ce4 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7641 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cbc977c9 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7642 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c19e8426 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7643 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-9de6d4bd | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7645 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-a5fe30bd | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7647 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-a77a763a | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7648 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-43accc1c | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:7653 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP00621_PlanAmend_Line_Formation.DrawSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (l…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b661d289 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7660 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f4fe6fae | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7662 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f139a5b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7670 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b7a81e2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7676 | if (dsMainFiltered.Good()) ▸ if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-466b1271 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7684 | if (dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-90247480 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7687 | if (dsMainFiltered.Good()) | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |

## FP00621_PlanAmend_Line_Formation.dwCheck

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try] / this.btnCatagory.Click…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1dad7a60 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:8186 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["DW_TABLE"] | "HIS_AMEND_PLAN_FORM_R" | 행/컬럼 값 대입 |  |  |  |
| AC-62bb74b6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:8189 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_dwSubmit_check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-14bfd6b3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:8193 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsTmp.Tables[0].Rows[0]["IS_SUBMIT"].ToString() == "Y") | STATE | txtReleaseAlert.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-3b8e019c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:8197 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (dsTmp.Tables[0].Rows[0]["IS_SUBMIT"].ToString() == "Y") | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-b5f6995b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:8202 | else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00621_PlanAmend_Line_Formation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1da07ed8 | EditButton | FP00621_PlanAmend_Line_Formation.cs:880 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-ba6fd276 | EditButton | FP00621_PlanAmend_Line_Formation.cs:882 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00621_PlanAmend_Line_Formation.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37724596 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00621_PlanAmend_Line_Formation.cs:4546 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d27308c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00621_PlanAmend_Line_Formation.cs:4547 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-6bb4efa6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00621_PlanAmend_Line_Formation.cs:4548 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-5cf30625 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00621_PlanAmend_Line_Formation.cs:4550 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1bcf7adc | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00621_PlanAmend_Line_Formation.cs:4569 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _editing_input_value | 그리드 속성/값 설정 |  |  |  |
| AC-2e3b8022 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00621_PlanAmend_Line_Formation.cs:4570 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1296bdf | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:4619 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d01b83d2 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:4620 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-778edb3c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:4621 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-5b277d88 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:4623 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8120b54a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:4638 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-098ab2f0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:4639 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3bfa270 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:4644 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.EditByFunc

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / menu_line.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equals("Y") && sPlanIDTag != "00") ▸ for (j <= nRowEnd) ▸ if (row_to_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b0a0e71 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4580 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80db15ce | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4582 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-98f0d221 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4583 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-1320320b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4585 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e592685 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4602 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa02cdc7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4609 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aded3fee | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4611 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.EditCommon

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / menu_line.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equals("Y") && sPlanIDTag != "00") ▸ for (j <= nRowEnd) ▸ if (row_to_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cd5ed49 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4675 | if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_AfterDegasLT" , pDivision, pSite, pPlant, pFactory, pLine, … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4fff3ef | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4684 | if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (new_value < nAfterVal) ▸ if (org_table_value.SafeDouble() == org_value) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_table_value | 그리드 속성/값 설정 |  |  |  |
| AC-49aed6d5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4686 | if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (new_value < nAfterVal) ▸ else of (org_table_value.SafeDouble() == org_value) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-e3e2ada6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4689 | if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (new_value < nAfterVal) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0be5d051 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4690 | if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (new_value < nAfterVal) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d712db8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4694 | if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6428477e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4702 | else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (new_value < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b60817d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:4706 | else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cf23406 | ExcelButton | FP00621_PlanAmend_Line_Formation.cs:3014 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00621_PlanAmend_Line_Formation.ExcelPopup_BufferValidation_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fae16b21 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6535 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-09e8d0f6 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6538 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aa7f6a6e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6539 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-86cc57ad | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6540 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-94dd3096 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6541 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e70c88ff | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6542 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2f71477e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6543 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ffea84da | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6544 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-359d3e6c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6545 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54a32235 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6546 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-08f833e4 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6547 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e5567102 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6548 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e68e79f0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6549 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bab02007 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6550 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9df520ed | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6551 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-62b2688d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6552 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fc6e3f73 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6553 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9052a17a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6554 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-43a781dd | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6555 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c534f7ac | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6557 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-95d91f18 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6566 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-3cf6b843 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6582 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) | CALL_EXT | dtPlanId.Lookup | ("PLAN_ID", Filter["PLAN_ID"], "FACTORY_LT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-db786997 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6588 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5824de28 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6593 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-95aec466 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6595 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-7dba7a2a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6598 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-41636525 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6606 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-84637b64 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6628 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-37210167 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6631 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a3b2a0e4 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6632 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fb97c037 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6633 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-51b051e0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6634 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ac5cee7e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6635 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4b008324 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6636 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f08f6280 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6637 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4a6c9721 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6638 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8179da3 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6639 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e56b6f0b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6640 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc90947a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6641 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-de86ed71 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6642 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cf81449a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6643 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ee87a98 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6644 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8493e17b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6645 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a281d178 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6646 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b3569cf | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6647 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4ed10de1 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6648 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0767c2a8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6651 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5e7466c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6660 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1cca99b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6684 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce4b1c51 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6689 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8b752279 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6691 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c6c390f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6694 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation != null) ▸ if … | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-caeed445 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6705 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-0221dc69 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6710 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-8c308fd5 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6715 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-039aa004 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6716 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.ExcelPopup_BufferValidation_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-265bdc5a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6774 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-272c9dda | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6777 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f8ebf4a8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6778 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | data.Tables[0].Rows[i]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-993c401b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6779 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef98696d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6780 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-894801b1 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6781 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5bd3a0fd | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6782 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-19c38cf6 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6783 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aedcac64 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6784 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c84be497 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6785 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-80ff4c80 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6786 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-50d12592 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6787 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ee3d49ae | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6788 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9744cbb9 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6789 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57bca425 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6790 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0cfe43cf | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6791 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-85d2fb74 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6792 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-66a729fe | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6793 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-19f8fe78 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6794 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b548dec | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6797 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1a81945 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6800 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a1a8093 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6820 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ lambda | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-27501ad8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6825 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-39c83ebb | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6827 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-460cd5b6 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6830 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) ▸ if (d… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-5ec3c165 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6838 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-427e2932 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6843 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-da0971db | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6848 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2557ed5 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6849 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.ExcelPopup_CheckBeforSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a711589 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6295 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-183c3c2a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6303 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ca1172ad | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6305 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-407d1029 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6313 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c0c0c505 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6318 | try ▸ if (dtChk.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-8ff60896 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6319 | try ▸ if (dtChk.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c847a9ba | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6324 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-5c9b7e49 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6328 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.ExcelPopup_SaveExcel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44fbcf06 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7062 | if (data.Tables[0].Rows.Count > 0) | DATA_OP | Filter["MPP_WPP"] | filter["MPP_WPP"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6526c2cd | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7072 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.ExcelPopup_SaveExcel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2e71c5a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7122 | if (data.Tables[0].Rows.Count > 0) | DATA_OP | Filter["MPP_WPP"] | filter["MPP_WPP"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ffa6adfa | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7135 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.ExcelPopup_Search_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31920640 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6343 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-690f7273 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6344 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-8f2de9d8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6359 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-2172f610 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6360 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-a76e13b8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6361 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-c5f796ea | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6363 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-7af0d6a5 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6372 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-3208413f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6374 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.ExcelPopup_Search_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ea12aec | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6384 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-639506b0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6385 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-285baf44 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6401 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-414a34e8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6402 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-1544a120 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6403 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-c78f20d0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6405 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-6e7b9e05 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6415 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-3d7119e2 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6417 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Exec_Procedure

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ lambda] / this.btnSimulation.Click [if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes)] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ lambda] / SaveButton [try ▸ if (bSaveChk == true) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2932a95a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2964 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-759692ae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2965 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ace8ed81 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2967 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-dd622893 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2968 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-a4c0042f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2969 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-820abfc3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2970 | try | DATA_OP | req.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e7b29eaf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2971 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-46120e6b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2972 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-953c343e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2973 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-6b59b9a5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2974 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d1053ffb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2975 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0fad95f1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2976 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e004899e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2977 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0c3291b7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2978 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a133a975 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2979 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9526c209 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2980 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c5c4d9cf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2981 | try | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5a4dd877 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2982 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b1483e1f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2983 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fdd970c6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2984 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b9bead9c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2985 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-79c5c4bd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2986 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ecb7528f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2987 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d847a8d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2988 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2b246626 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2989 | try | DATA_OP | req.Parameters["p_customer_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2129e632 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2990 | try | DATA_OP | req.Parameters["p_cell_group"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a4c80212 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2991 | try | DATA_OP | req.Parameters["p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d9554ea | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2992 | try | DATA_OP | req.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-10d77bae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2993 | try | DATA_OP | req.Parameters["p_shorter_lt_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4eea4ffc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2994 | try | DATA_OP | req.Parameters["p_mpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d4dc1e93 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2995 | try | DATA_OP | req.Parameters["p_wpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fb611a13 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:2997 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9109273f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:3004 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-93dc70f9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 3 | FP00621_PlanAmend_Line_Formation.cs:3008 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Exec_PSI_Calculation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be2e0c92 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2903 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-0e6451f3 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2904 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-267f1d80 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2906 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-1c7d5b82 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2907 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-d256f18d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2908 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4e1b7d86 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2909 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-833cc418 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2910 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-b08857b7 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2911 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-83efc284 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2912 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-b0d27a61 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2913 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b87d0a08 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2914 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8dc3ccf0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2915 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5f467503 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2916 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-065d56ff | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2917 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c92ecb98 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2918 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5c0f1679 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2919 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eda57337 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2920 | try | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c225e920 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2921 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7acfb49c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2922 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d0bf945b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2923 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fc13c180 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2924 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c5843c97 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2925 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f18dbb7 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2926 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f02547f5 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2927 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-808a2184 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2928 | try | DATA_OP | req.Parameters["p_customer_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a342b289 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2929 | try | DATA_OP | req.Parameters["p_cell_group"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0139d15c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2930 | try | DATA_OP | req.Parameters["p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ff4fc463 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2931 | try | DATA_OP | req.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-57e5a92f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2932 | try | DATA_OP | req.Parameters["p_shorter_lt_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ab0be320 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2933 | try | DATA_OP | req.Parameters["p_mpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-adb384ad | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2934 | try | DATA_OP | req.Parameters["p_wpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa1eb435 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2936 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ec387603 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2943 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-5a306a7b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2947 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SELECT")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ lambda] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ lambda] / this.btnBucket.Click [if (frm.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd09110d | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1306 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-f0508206 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1307 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cd38d486 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1308 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-eb2771c7 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1309 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-bc43e1b5 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1310 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-53483d16 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1311 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-09defb09 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1313 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a218cb2c | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1314 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e35b4e60 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1315 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-51cf3f8e | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1316 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5b9d75f3 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1317 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-83e61a85 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1318 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7a2da603 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1319 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3e03bd65 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1320 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0afa2432 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1321 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fa11f45f | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1322 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-38a4f10e | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1323 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8e1a40ed | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1324 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2d596c76 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1325 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-98dc8b74 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1326 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-87402b55 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1327 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-e249533a | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1328 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | Filter["NICK_NAME_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-92e299a6 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1329 | try | DATA_OP | request.Parameters["p_cell_group"] | Filter["CELL_GROUP"] | 행/컬럼 값 대입 |  |  |  |
| AC-98286ab5 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1330 | try | DATA_OP | request.Parameters["p_cell_group_code"] | Filter["CELL_GROUP_CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c933da28 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1331 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-40cfa650 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1332 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-ba617fee | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1333 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-a7a212ce | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1334 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-c59955b1 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1335 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-8a6a2dca | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1336 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-04209cfe | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1337 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f3cad382 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1338 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1361dc53 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1339 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-35870671 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1340 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7cf3e706 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1341 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c41f6a02 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1342 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-faa2cd6e | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1343 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-9379126c | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1345 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0d73ede8 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1346 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-749a73ef | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SEL… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1351 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Find_Data_CWA_Minus_Activated

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MINUS_ACTIVED")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1)] / this.btnSimulation.Click [if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (bRtn1) ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1)] / SaveButton [try ▸ if (bSaveChk == true) ▸ try ▸ if (Filter["INS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbe4d576 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1363 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-6b689a78 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1364 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-dff6a481 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1365 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-cac1e187 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1366 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_CWA_MINUS_ACTIVED" | 행/컬럼 값 대입 |  |  |  |
| AC-e090016e | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1367 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec4e3852 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1368 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-11ef1809 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1370 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3719e9e9 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1371 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-50bed898 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1372 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7e7ed74b | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1373 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e6ae7138 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1374 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6c85156c | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1375 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a33d229c | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1376 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d742bf11 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1377 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ee949bb4 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1378 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e1ca108c | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1379 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-04adafe8 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1380 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-518eb027 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1381 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c31f9817 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1382 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-0397eceb | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1383 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3c7a1653 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1384 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-dd231e9c | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1385 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | Filter["NICK_NAME_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-e7923eae | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1386 | try | DATA_OP | request.Parameters["p_cell_group"] | Filter["CELL_GROUP"] | 행/컬럼 값 대입 |  |  |  |
| AC-90991fe7 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1387 | try | DATA_OP | request.Parameters["p_cell_group_code"] | Filter["CELL_GROUP_CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8a8910bf | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1388 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-72195e79 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1389 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-8bf25ec8 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1390 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-6ffb6a8d | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1391 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-9d0608f4 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1392 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-10841bc0 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1393 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-1da5610f | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1394 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-10942e0b | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1395 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-01a6359e | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1396 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a21d738d | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1397 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ac01f937 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1398 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-76618fb4 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1399 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-cc960340 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1400 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c76baa04 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1402 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8b8d8442 | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1403 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9a8e1f7b | popSql.OnSql [if (programID == "PR_UI_FP00621_SELECT_CWA_MIN… 외 3 | FP00621_PlanAmend_Line_Formation.cs:1408 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Find_Data_Excel_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f82b866 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7022 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-f532e577 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7023 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e3225fa8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7025 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-9049a965 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7026 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e134d14c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7027 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8aec0055 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7028 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d6f8357e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7029 | try | DATA_OP | request.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-49d044a3 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7030 | try | DATA_OP | request.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-48bd7b8c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7031 | try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-adb249d9 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7032 | try | DATA_OP | request.Parameters["p_site_id"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-7579c29d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7033 | try | DATA_OP | request.Parameters["p_confirm_area"] | sConfirmArea | 행/컬럼 값 대입 |  |  |  |
| AC-ea137920 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7034 | try | DATA_OP | request.Parameters["p_release_value"] | sreleaseValue | 행/컬럼 값 대입 |  |  |  |
| AC-8d36c73a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7035 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-62a822ac | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7037 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-81afb4a8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7039 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-760997ea | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7044 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Find_Data_Excel_Import

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE") ▸ if (popup != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f9c59b3 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6433 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL | 엔드포인트 요청 생성 |  |  |  |
| AC-3bb48a00 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6434 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-27e53c21 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6436 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-bbdd8fe7 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6437 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-53c823cd | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6438 | try | DATA_OP | request.Parameters["p_sys_gubun"] | gubun | 행/컬럼 값 대입 |  |  |  |
| AC-06375fc0 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6439 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-38e897f7 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6440 | try | DATA_OP | request.Parameters["p_proc_name"] | procedure_name.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-257a4c7e | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6449 | try ▸ if (dsParameter != null && dsParameter.Rows != null && dsParameter.Rows.Count > 0) | CALL_EXT | param.Keys | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9af216c5 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6463 | try | DATA_OP | request.Parameters["in_columns"] | keys | 행/컬럼 값 대입 |  |  |  |
| AC-fd373804 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6464 | try | DATA_OP | request.Parameters["in_row"] | values | 행/컬럼 값 대입 |  |  |  |
| AC-d3e78f57 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6465 | try | DATA_OP | request.Parameters["opt_none"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-09779237 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6467 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-39c8a210 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6469 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-c96c3766 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6474 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-e4ddb28f | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 1 | FP00621_PlanAmend_Line_Formation.cs:6476 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-045e8bfe | FindButton | FP00621_PlanAmend_Line_Formation.cs:786 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d9417601 | FindButton | FP00621_PlanAmend_Line_Formation.cs:787 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d0499d7 | FindButton | FP00621_PlanAmend_Line_Formation.cs:790 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-be691ba4 | FindButton | FP00621_PlanAmend_Line_Formation.cs:793 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-a4efb1f1 | FindButton | FP00621_PlanAmend_Line_Formation.cs:797 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan ID to proceed") | 메시지 표시 |  |  |  |
| AC-577a1d4d | FindButton | FP00621_PlanAmend_Line_Formation.cs:798 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91f5579a | FindButton | FP00621_PlanAmend_Line_Formation.cs:804 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7440f7f | FindButton | FP00621_PlanAmend_Line_Formation.cs:806 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-56452863 | FindButton | FP00621_PlanAmend_Line_Formation.cs:809 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d89228de | FindButton | FP00621_PlanAmend_Line_Formation.cs:813 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f58350a2 | FindButton | FP00621_PlanAmend_Line_Formation.cs:817 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00621_PlanAmend_Line_Formation.FindTotalColorStart

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5fbb5b5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 12 | FP00621_PlanAmend_Line_Formation.cs:1856 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.FindTotalValue

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOTAL_SELECT")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCreatePl…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2de30f87 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1089 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-1f1b8545 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1090 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-049c2820 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1091 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_TOTAL_VALUE" | 행/컬럼 값 대입 |  |  |  |
| AC-da16c312 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1092 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eb9bc312 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1093 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e35cfd7d | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1095 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-acd29f00 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1096 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-49bacbec | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1097 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6f84a554 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1098 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e5ea8aa0 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1099 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-413ae145 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1100 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-30bdc24f | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1101 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-875f802d | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1102 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-92f4414a | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1103 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-411d714f | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1104 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b08ae4bd | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1105 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6433e741 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1106 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-32cb9cbd | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1107 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-39668448 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1108 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c6bd4457 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1109 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-67e8e56a | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1110 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | Filter["NICK_NAME_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-92986779 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1111 | try | DATA_OP | request.Parameters["p_cell_group"] | Filter["CELL_GROUP"] | 행/컬럼 값 대입 |  |  |  |
| AC-dad0d254 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1112 | try | DATA_OP | request.Parameters["p_cell_group_code"] | Filter["CELL_GROUP_CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-48dd0867 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1113 | try | DATA_OP | request.Parameters["p_bucket_from"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-dfec8cf2 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1114 | try | DATA_OP | request.Parameters["p_bucket_to"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-17908f4b | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1115 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-7d0b3a41 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1116 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-dc31e1d4 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1117 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-166b6fd4 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1118 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-11f19b3b | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1119 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-9a7cbc67 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1120 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-fff54dc1 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1121 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-945c985d | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1122 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b13fcb43 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1123 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-20370315 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1124 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-9a70b765 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1125 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-901f3c49 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1127 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0ff8cf39 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1130 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-23f0d104 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 9 | FP00621_PlanAmend_Line_Formation.cs:1138 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a37ab12c | this.Load | FP00621_PlanAmend_Line_Formation.cs:231 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_PlanAmend_Line_Formation.FP00599_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-492f64d3 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7225 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOTAL_SELECT") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try] / this.btnSimulation.Click [if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) ▸ try] / this.btnCreatePlan…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae823b86 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOT… 외 11 | FP00621_PlanAmend_Line_Formation.cs:5140 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.GetListDataSet

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCreatePlan.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96b1140e | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1578 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00621_find_ListData", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e649906b | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1580 |  | FLAG | dsListData | dtList.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-673ab88c | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1580 |  | DATA_OP | dtList.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0998c840 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1582 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00621_find_ListData_BOH", Filter["INSTANCE_ID"].ToString(), Filter["PL… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f08b38ed | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1584 |  | FLAG | dsBoh | dtBoh.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1a976bb3 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1584 |  | DATA_OP | dtBoh.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a80b1fe8 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1586 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_ListData_LT", Filter["DIVISION_ID"].ToString(), Filter["SIT… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0067ad90 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1588 |  | FLAG | dsShorterLT | dtShorter.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6923842a | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1588 |  | DATA_OP | dtShorter.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-940d4550 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1590 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_accumQTY") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-483b1c87 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1591 |  | FLAG | dsAccumQty | dtAccum.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-d75fc8ca | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1591 |  | DATA_OP | dtAccum.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## FP00621_PlanAmend_Line_Formation.GetMppWpp

진입점: SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory == "M_OUT")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c34feb9f | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2711 | if (!ds.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e64b9a88 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2722 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0f9d8a0 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2723 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a26b53a | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2724 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-674e8826 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2725 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bede7c67 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2726 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-15a8085a | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2727 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd433651 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2728 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d5b23659 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2729 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6efc3c32 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2730 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b9bb9a3 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2731 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("CUSTOMER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-67926dc9 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2719 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-7d0ad540 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2746 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": | DATA_OP | ret[order_MPP_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-a74f69ac | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2749 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": | DATA_OP | ret[order_WPP_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-a87496e0 | SaveButton [try ▸ try ▸ try ▸ if (editDs.Good()) ▸ foreach (… | FP00621_PlanAmend_Line_Formation.cs:2754 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.GetPlanGroup

진입점: this.Load [try] / popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_TOTAL_SELECT") ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98c4eb95 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5242 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-15ca35b0 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5243 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4009e90 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5243 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ac74a7f6 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5245 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-25bc3a67 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5247 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-85b0a96c | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5250 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-d538ec02 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5251 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-a3f3fee8 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5251 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-028de30c | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5252 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2cf0c157 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5253 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e6c2afb9 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5254 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8f0213d9 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:5258 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00621_PlanAmend_Line_Formation.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-561860fa | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6004 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-0a97d938 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6005 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.GetToDay

진입점: sCalendar_planday.DateTimeChanged / popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE") ▸ lambda ▸ else of (dt.Good())] / this.btnExcelImport.Click [else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (dt != null)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda ▸ try ▸ lambda ▸ else of (dt.Good())] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ lambda ▸ try ▸ lambda ▸ else of (dt.Good())] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4864cf3 | sCalendar_planday.DateTimeChanged 외 11 | FP00621_PlanAmend_Line_Formation.cs:5474 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-a0693bb6 | sCalendar_planday.DateTimeChanged 외 11 | FP00621_PlanAmend_Line_Formation.cs:5475 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.spdMain.CellDoubleClick [try …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-556cccba | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7868 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolnames[k] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-3af29d12 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7869 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolidxs[k] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-a8ff996c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7903 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94190757 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7917 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-205af6cb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7923 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b75ecae | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7936 | if (do_edit_mode) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc1d038b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7946 | else of (do_edit_mode) ▸ if (c != null) | CALL_EXT | siMain.LockRangeColor | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a292a39d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7947 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2882238f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7963 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (calendar != null) ▸ foreach (var week_item in calendar.Weeks) ▸ if (wee… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-0b0ab2de | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7980 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (m… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.GoEditModeShortLT

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-155cc8a8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:8000 | if (bReadOnly == true \|\| sPlanIDTag == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-02d5d6a6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:8097 | if (current_src != null) ▸ if (colindex != -1) ▸ foreach (DataRow row in current_src.Rows) ▸ if (sDataType == "DATA") ▸ if (nEndRow >= 0 && … | CALL_EXT | siMain.LockRangeColor | (nStartRow, colindex, nEndRow, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00621_PlanAmend_Line_Formation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-110bb79a | this.Load | FP00621_PlanAmend_Line_Formation.cs:337 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-344abe4a | this.Load | FP00621_PlanAmend_Line_Formation.cs:341 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-67a5bcd4 | this.Load | FP00621_PlanAmend_Line_Formation.cs:342 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-448fc961 | this.Load | FP00621_PlanAmend_Line_Formation.cs:346 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-b1b0dcdd | this.Load | FP00621_PlanAmend_Line_Formation.cs:348 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-7da37537 | this.Load | FP00621_PlanAmend_Line_Formation.cs:352 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cba6b01d | this.Load | FP00621_PlanAmend_Line_Formation.cs:355 | try | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-32de23e9 | this.Load | FP00621_PlanAmend_Line_Formation.cs:361 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c803bef3 | this.Load | FP00621_PlanAmend_Line_Formation.cs:368 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-87cf48c2 | this.Load | FP00621_PlanAmend_Line_Formation.cs:370 | try | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-86637206 | this.Load | FP00621_PlanAmend_Line_Formation.cs:381 | try | FLAG | _sToDay | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-458c1e4b | this.Load | FP00621_PlanAmend_Line_Formation.cs:390 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-691af9f7 | this.Load | FP00621_PlanAmend_Line_Formation.cs:391 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-90ec542c | this.Load | FP00621_PlanAmend_Line_Formation.cs:392 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-71867a26 | this.Load | FP00621_PlanAmend_Line_Formation.cs:393 | try ▸ if (adminAuth == false) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-eef38c52 | this.Load | FP00621_PlanAmend_Line_Formation.cs:409 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00621_PlanAmend_Line_Formation.InitEditingBuf

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4c303f0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5480 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-641de493 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5483 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1e7b2384 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5487 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-3ff1e2d6 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5488 |  | FLAG | dsShorterLT | null | 화면 필드/플래그 변경 |  |  |  |

## FP00621_PlanAmend_Line_Formation.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53e77dd1 | this.Load | FP00621_PlanAmend_Line_Formation.cs:272 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-c65b8253 | this.Load | FP00621_PlanAmend_Line_Formation.cs:273 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-76bdb014 | this.Load | FP00621_PlanAmend_Line_Formation.cs:275 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-637e696e | this.Load | FP00621_PlanAmend_Line_Formation.cs:276 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-9ee5b820 | this.Load | FP00621_PlanAmend_Line_Formation.cs:277 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-6c8158e8 | this.Load | FP00621_PlanAmend_Line_Formation.cs:278 |  | UI_PROP | mcbo_planner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ba138f86 | this.Load | FP00621_PlanAmend_Line_Formation.cs:279 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.InitSpread

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.spdMain.CellDoubleClick [try ▸ if (!sHead…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03bfbe3e | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:512 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4be55809 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:513 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-19cb0bf3 | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:515 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-803b04ed | this.Load 외 12 | FP00621_PlanAmend_Line_Formation.cs:519 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Insert_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a81bdb1f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6861 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00621_EXCELIMPORT", "insert_Excel_buffer", dsData) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-355acac8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6865 | try ▸ if (result.Good()) | DATA_OP | result.Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a51b81c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6877 | try ▸ if (result.Good()) ▸ if (result.Columns.Contains("RESULT")) ▸ else of (result.Rows[0]["RESULT"].ToString().ToUpper() == "SUCCESS") ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-74c8ed04 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6885 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-671a0d23 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6889 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-fbb00488 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6890 | catch ((Exception ex)) | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Insert_Data_Excel_Buffer_Old

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaa2e0fc | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6969 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-6122164b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6970 | try ▸ if (iCount > 0) | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7f5fbf7d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6972 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b0b9a6e4 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6973 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-31b22ba5 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6974 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-9e2096d8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6975 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-94e2ef60 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6976 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-9a316e41 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6977 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-a4bd2ad8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6978 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-f2885d91 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6979 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-d4f7042e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6980 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-17404c25 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6981 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b8f99910 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6982 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-10744bf0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6983 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-16d79f16 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6984 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-d865315a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6985 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce31f53a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6986 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e8197c2b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6987 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e936657b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6988 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-78d72263 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6989 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-8e8a6a1f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6990 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-e58efc32 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6991 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-2ca53ad3 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6992 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-77f8bc87 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6993 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_cell_qty"] | p_cell_qty | 행/컬럼 값 대입 |  |  |  |
| AC-72b2cf4d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6994 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-23507722 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6995 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_seq_no"] | p_new_seq_no | 행/컬럼 값 대입 |  |  |  |
| AC-15f092e8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6996 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_mpp_wpp"] | p_mpp_wpp | 행/컬럼 값 대입 |  |  |  |
| AC-a31eaea0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:6998 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-db7499f1 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7003 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-b2beda49 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7007 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-d9395705 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7009 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd99d11a | InsertButton | FP00621_PlanAmend_Line_Formation.cs:834 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1aeddc9b | InsertButton | FP00621_PlanAmend_Line_Formation.cs:839 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | MESSAGE | MessageBox.Show | ("Can not be selected [Total] Row.!") | 메시지 표시 |  |  |  |
| AC-10b2d96c | InsertButton | FP00621_PlanAmend_Line_Formation.cs:840 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00afa800 | InsertButton | FP00621_PlanAmend_Line_Formation.cs:844 | if (row != null) | POPUP | new FP00607_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-7fddcdb9 | InsertButton | FP00621_PlanAmend_Line_Formation.cs:845 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-29337918 | InsertButton | FP00621_PlanAmend_Line_Formation.cs:845 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e26a114b | InsertButton | FP00621_PlanAmend_Line_Formation.cs:847 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bbc45fc4 | InsertButton | FP00621_PlanAmend_Line_Formation.cs:848 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dc26d8a7 | InsertButton | FP00621_PlanAmend_Line_Formation.cs:849 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-46eb036c | InsertButton | FP00621_PlanAmend_Line_Formation.cs:850 | if (row != null) | DATA_OP | popup.Filter["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-169afde2 | InsertButton | FP00621_PlanAmend_Line_Formation.cs:852 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-db9ce351 | InsertButton | FP00621_PlanAmend_Line_Formation.cs:854 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f34946fa | InsertButton | FP00621_PlanAmend_Line_Formation.cs:863 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00621_PlanAmend_Line_Formation.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b580a54 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:3021 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00621_PlanAmend_Line_Formation.lfn_setAvailability

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (sCateID.Equals("P_OUT") \|\| sCateID.Equals("M_OUT") \|\| sCateID.Equals("W_OUT")) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (current_catagory == "P_OUT")] / menu_line.Click [if (ds…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7915540c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5901 | try ▸ if (!(measure["chk_act"].Value == "true" \|\| measure["chk_actSim"].Value == "true") \|\| !(measure["chk_outqty"].Value == "true…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9fc9a91 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5964 | try ▸ for (i < nEndTmp) ▸ if (nRow_Act != -1) | GRID_SET | siMain.ActiveSheet.Cells[nRow_Act, siMain.GetColumnIndex(sCol)].Value | Math.Round(dValue) | 그리드 속성/값 설정 |  |  |  |
| AC-67eb8291 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5977 | try ▸ for (i < nEndTmp) ▸ if (nRow_ActSim != -1) | GRID_SET | siMain.ActiveSheet.Cells[nRow_ActSim, siMain.GetColumnIndex(sCol)].Value | Math.Round(dValue) | 그리드 속성/값 설정 |  |  |  |
| AC-c123c3bc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5984 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |

## FP00621_PlanAmend_Line_Formation.lfn_setReleaseProcess

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ lambda ▸ try] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ try ▸ lambda ▸ try] / thi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32882208 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1552 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b0ddeda9 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1566 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ if (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCurrDate… | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-2daacf3d | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1568 | if (!string.IsNullOrEmpty(sCurrDate)) ▸ foreach (DataRow row in dtMapData.Rows) ▸ else of (Convert.ToDecimal(sDate) < Convert.ToDecimal(sCur… | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-3bb6fb93 | popSql.OnSql [if (programID == "PR_UI_FP00621_EXCEL_SELECT_C… 외 10 | FP00621_PlanAmend_Line_Formation.cs:1572 |  | RETURN | return dtMapData; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.MakeMemoFontBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58ac2ed8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:8150 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-cdf67a28 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:8154 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |
| AC-3e78438f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:8165 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-db4fe83c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:8169 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d464b176 | memo_menu.Click | FP00621_PlanAmend_Line_Formation.cs:5071 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46c01dd0 | memo_menu.Click | FP00621_PlanAmend_Line_Formation.cs:5074 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98541a3b | memo_menu.Click | FP00621_PlanAmend_Line_Formation.cs:5078 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00621_PlanAmend_Line_Formation.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b7c1dd9 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5089 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1093d78f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5092 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1ad030a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5110 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-9dbeb300 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5111 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cd1fd107 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5112 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6008f609 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5113 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-832d850d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5114 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-4891270c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5115 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-43bd9c1e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5116 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-46731593 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5117 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-32e7336c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5118 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00621_PlanAmend_Line_Formation.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd3ee422 | bucke_menu.Click | FP00621_PlanAmend_Line_Formation.cs:4784 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c27d9872 | bucke_menu.Click | FP00621_PlanAmend_Line_Formation.cs:4787 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.onZeroLineMenu

진입점: menu_line.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f5670fa | menu_line.Click | FP00621_PlanAmend_Line_Formation.cs:4846 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ba78f0c | menu_line.Click | FP00621_PlanAmend_Line_Formation.cs:4849 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-202afefb | menu_line.Click | FP00621_PlanAmend_Line_Formation.cs:4900 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d94cee54 | menu_line.Click | FP00621_PlanAmend_Line_Formation.cs:4938 | if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == tr… | GRID_SET | siMain.ActiveSheet.Cells[j, iCol].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.onZeroMaterialMenu

진입점: menu_material.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94bb9cbf | menu_material.Click | FP00621_PlanAmend_Line_Formation.cs:4966 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3bfdd2bf | menu_material.Click | FP00621_PlanAmend_Line_Formation.cs:4969 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6a3efe9 | menu_material.Click | FP00621_PlanAmend_Line_Formation.cs:5014 | if (dsMainFiltered.Good()) ▸ if (nRowEnd == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c63ff2a0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8451 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-60ed951f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8451 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ad5cda1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8453 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-3cff1003 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8454 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-8fc3e59e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8454 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-23f2620e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8455 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-e9709b8a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8456 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d0721cf7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8457 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ff15f6b3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8461 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a4445966 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8463 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8abb8c81 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8468 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00621_PlanAmend_Line_Formation.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ecc1e03 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8410 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-68e2c2ab | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8411 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-025fe29a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8412 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-4d1f9a40 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8412 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cb4b1f00 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8413 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-a5191135 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8414 |  | DATA_OP | frm.Filter["COMPANY_ID"] | row["COMPANY_ID"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-cad2e531 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8415 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8df6e1b9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8416 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ecbfef72 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8420 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0fb32c36 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8422 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_PlanAmend_Line_Formation.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80fdce4b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8428 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-eb1c074f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8429 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-acb94de8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8430 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-45a19c1e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8430 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b62657c4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8431 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-f6f9589b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8432 |  | DATA_OP | frm.Filter["COMPANY_ID"] | row["COMPANY_ID"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-7615bdf9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8433 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4d4c0481 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8434 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5fa6485d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8438 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d48f15ff | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00621_PlanAmend_Line_Formation.cs:8440 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_PlanAmend_Line_Formation.planday_changed

진입점: sCalendar_planday.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ab9b387 | sCalendar_planday.DateTimeChanged | FP00621_PlanAmend_Line_Formation.cs:3060 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad50877d | sCalendar_planday.DateTimeChanged | FP00621_PlanAmend_Line_Formation.cs:3061 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | CALL_EXT | sCalendar_planday.Undo | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd5727d9 | sCalendar_planday.DateTimeChanged | FP00621_PlanAmend_Line_Formation.cs:3064 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-9ad41878 | sCalendar_planday.DateTimeChanged | FP00621_PlanAmend_Line_Formation.cs:3071 | else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Query

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (l…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c10d0fd2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7703 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-ad3522a3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7703 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fda482db | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7704 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-49a84469 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7709 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-6487cd79 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7732 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-72a8d3c0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7738 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-82328d6f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7738 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1e9aa423 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7739 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-af5e0e8b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7739 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-da4fa69f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7742 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-16110539 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7749 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-725c0ce0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7754 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e051b6f9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7755 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4995698 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7757 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00621_PlanAmend_Line_Formation.RefreshHeadAndBody

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f89111e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7545 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2c427b6e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7561 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-67ab64b9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7565 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00621_PlanAmend_Line_Formation.RefreshHeader

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-513a7b49 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:588 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-63c894e4 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:589 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-2cfe06c5 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:590 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-203db1d8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:591 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-87870b5c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:596 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, bUse_month, bUse_week, bUse_day, 2, FPExtensions.DateColumnType.QTY, FPExtensio… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e527af24 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:598 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-ff4b8d30 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:602 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-15d8aee8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:604 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-77969e48 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:605 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c6bb23f8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:606 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0ae856b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:607 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21467d5f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:609 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dbaec0de | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:610 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c28b5f34 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:612 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b80a8aa5 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:615 | if (monthInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b37d9266 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:617 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00621_PlanAmend_Line_Formation.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-081b1710 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7519 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-713319f0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7519 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-47cf1ecc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7524 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-42ce99d5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7525 |  | FLAG | dsShorterLT | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2041e83c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7532 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-ebb6b512 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:7538 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Run_Parallels

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE")] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK)] / SaveButton [try ▸ if (bSaveChk == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90d3ea5c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00621_PlanAmend_Line_Formation.cs:893 | lambda ▸ if (!bRtn1) | CALL_BASE | this.Invoke | (new System.Action(delegate () { MessageService.CloseProgress(); })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-19c75412 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00621_PlanAmend_Line_Formation.cs:895 | lambda ▸ if (!bRtn1) ▸ lambda | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8c7c0f6a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00621_PlanAmend_Line_Formation.cs:897 | lambda ▸ if (!bRtn1) | MESSAGE | MessageBox.Show | ("EXEC_PR_PARALLEL_A is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Info… | 메시지 표시 |  |  |  |
| AC-a81439e1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00621_PlanAmend_Line_Formation.cs:904 |  | CALL_EXT | modalThread.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4261e908 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00621_PlanAmend_Line_Formation.cs:905 |  | CALL_EXT | System.Threading.Thread.Sleep | (500) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46fc1e4b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00621_PlanAmend_Line_Formation.cs:911 | lambda ▸ if (!bRtn2) | CALL_BASE | this.Invoke | (new System.Action(delegate () { MessageService.CloseProgress(); })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd4cb23b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00621_PlanAmend_Line_Formation.cs:913 | lambda ▸ if (!bRtn2) ▸ lambda | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d94349e3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00621_PlanAmend_Line_Formation.cs:915 | lambda ▸ if (!bRtn2) | MESSAGE | MessageBox.Show | ("EXEC_PR_PARALLEL_B is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Info… | 메시지 표시 |  |  |  |
| AC-1f06bf7a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00621_PlanAmend_Line_Formation.cs:922 |  | CALL_EXT | modalThread2.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-998ec6b1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00621_PlanAmend_Line_Formation.cs:923 |  | CALL_EXT | modalThread2.Wait | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1cce9ba5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 2 | FP00621_PlanAmend_Line_Formation.cs:924 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48877dd1 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6080 | if (programID == "PR_UI_FP00621_AMEND_LINE_SELECT") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-02595e98 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6086 | if (programID == "PR_UI_FP00621_AMEND_LINE_TOTAL_SELECT") | RETURN | return FindTotalValue("", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-f5c05728 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6098 | if (programID == "PR_UI_FP00621_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELE… | RETURN | return Save_Data_Amend(dtData, "MERGE_DATA_MPPWPP", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-19a882b8 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6100 | if (programID == "PR_UI_FP00621_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == … | RETURN | return Save_Data_Amend(dtData, "MERGE_DATA", "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-ac440f63 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6104 | if (programID == "PR_UI_FP00621_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_OUT_CELL.") | 메시지 표시 |  |  |  |
| AC-df9cca82 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6105 | if (programID == "PR_UI_FP00621_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ else of (dtData.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-68e69e7e | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6110 | if (programID == "PR_UI_FP00621_AMEND_LINE_DATA_SAVE") ▸ else of (dtData != null) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_OUT_CELL.") | 메시지 표시 |  |  |  |
| AC-452d53ff | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6111 | if (programID == "PR_UI_FP00621_AMEND_LINE_DATA_SAVE") ▸ else of (dtData != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e0ba8181 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6120 | if (programID == "PR_UI_FP00621_AMEND_LINE_SHORTER_LT_SAVE") ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) | DATA_OP | dsShorterLT.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-298c4f0f | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6122 | if (programID == "PR_UI_FP00621_AMEND_LINE_SHORTER_LT_SAVE") ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) | RETURN | return Save_Data_Shorter(dtData, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-0f4ed7c7 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6126 | if (programID == "PR_UI_FP00621_AMEND_LINE_SHORTER_LT_SAVE") ▸ else of (dsShorterLT.Tables[0].Rows.Count > 0) | MESSAGE | MessageBox.Show | ("there is no Edit Value of BOH QTY .") | 메시지 표시 |  |  |  |
| AC-ba4e05f2 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6127 | if (programID == "PR_UI_FP00621_AMEND_LINE_SHORTER_LT_SAVE") ▸ else of (dsShorterLT.Tables[0].Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-37c5fbfe | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6138 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE") | POPUP | new FP00607_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-653956aa | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6142 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.DateColumnType | FPExtensions.DateColumnType.CELL | 속성 DateColumnType 설정 |  |  |  |
| AC-a3cebbae | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6144 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-54585767 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6145 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-12074b81 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6146 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-05e2994f | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6148 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-8b7fb956 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6155 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00621_AMEND_LINE_EXCEL", Filter,… |  | 처리 중단/반환 |  |  |  |
| AC-4655e06a | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6167 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_ROWTYPE") | POPUP | new FP00607_RowExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0440a446 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6172 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-90d3a210 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6173 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-670ba7f3 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6174 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-6dc75470 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6176 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-92a4fd13 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6182 | if (programID == "PR_UI_FP00621_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00621_AMEND_LINE_EXCEL", Filter,… |  | 처리 중단/반환 |  |  |  |
| AC-243b4c48 | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6190 | if (programID == "PR_UI_FP00621_SELECT_CWA_MINUS_ACTIVED") | RETURN | return Find_Data_CWA_Minus_Activated("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-f5266eef | popSql.OnSql | FP00621_PlanAmend_Line_Formation.cs:6193 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Save_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DATA_SAVE") ▸ if (dtData != null) ▸ if (dtData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE")] / SaveButton [try ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-625455aa | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2840 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-14a5ffdc | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2841 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0ed3e931 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2843 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-a8109684 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2844 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0fa7a17a | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2845 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-633dd379 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2846 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-919fdba2 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2847 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-59c796a2 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2848 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-837478b4 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2849 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-6b6ff2a2 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2850 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-aedf7298 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2851 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-97a9d1f5 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2852 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-0e12e882 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2853 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-f0f79edd | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2854 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-103149e6 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2855 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-f8895508 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2856 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-3eeec6d3 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2857 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-0c21ddad | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2858 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-640e39b0 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2859 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e4b57b41 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2860 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-77b71e64 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2861 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-4ccb70a8 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2862 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-5f3e693f | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2863 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-fc8a05c6 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2864 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-76ca8884 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2865 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_customer_id"] | p_customer_id | 행/컬럼 값 대입 |  |  |  |
| AC-9e41a00a | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2866 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-34b3e227 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2867 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-9f1e1ca0 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2868 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-af466418 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2869 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shorter_lt_qty"] | p_shorter_lt_qty | 행/컬럼 값 대입 |  |  |  |
| AC-bfcfe08d | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2870 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mpp_out_qty"] | p_mpp_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-a89398bb | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2871 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_out_qty"] | p_wpp_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-6dc2334b | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2873 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-007fe44c | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2874 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5a8a8b5a | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2880 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e894ba17 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_DAT… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2886 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Save_Data_Excel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70a4b24f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7084 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-01090231 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7085 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-34fa034c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7087 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-efbd19b1 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7088 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c89f3033 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7089 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-3a74d12c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7090 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bc8789ea | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7091 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5f2d3e84 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7092 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-97639487 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7093 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-74fc1d0f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7094 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-75399408 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7095 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1543e3d6 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7096 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f4fd406d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7097 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | pMppWpp | 행/컬럼 값 대입 |  |  |  |
| AC-8914d42b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7099 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-29c4480f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7101 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-7ef0dec7 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7106 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-fe89d7bb | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7108 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Save_Data_Excel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f9b941b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7147 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-e0a793f4 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7148 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-844475e9 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7150 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-e5cdb1be | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7151 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9e499454 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7152 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-945f5c8d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7153 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-72c056a3 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7154 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-50428b5f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7155 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b799449f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7156 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-48bf7ce0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7157 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0cf3fdce | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7158 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8bbbb741 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7159 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-81cf6b8c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7160 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | pMppWpp | 행/컬럼 값 대입 |  |  |  |
| AC-995bc5f4 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7162 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a739941f | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7164 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-0a084d9a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7169 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-f868a286 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:7171 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Save_Data_ShipPlan

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8038bf66 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2084 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-e0084366 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2085 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cf21bb20 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2087 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-a3f4920c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2088 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-97f6ad21 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2089 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-a79cc4a5 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2090 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2313a6b2 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2091 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-15956b1b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2092 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-3b0e8117 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2093 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-1cd2b524 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2094 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-47837a5e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2095 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8250d105 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2096 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-135d8a64 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2097 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-40d94c22 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2098 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-a468d171 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2099 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-4a290907 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2100 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-e0a67569 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2101 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-1b8c009b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2102 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-727de483 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2103 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-808f493c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2104 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-487a7ca7 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2105 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-4824b766 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2106 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-8ecadaec | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2107 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-c7488d6d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2108 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-36fb07a9 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2109 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_customer_id"] | p_customer_id | 행/컬럼 값 대입 |  |  |  |
| AC-5c30a238 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2110 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-c50d93de | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2111 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-131b47ab | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2112 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-8107b3b5 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2113 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shorter_lt_qty"] | p_shorter_lt_qty | 행/컬럼 값 대입 |  |  |  |
| AC-f025be69 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2114 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1bea8540 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2115 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-17bc509c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2117 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-335aa440 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2118 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8adb9274 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2124 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e943f09e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:2130 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Save_Data_Shorter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHORTER_LT_SAVE") ▸ if (dsShorterLT.Tables[0].Rows.Count > 0)] / this.btnSimulation.Click [if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) ▸ try] / SaveButton [try ▸ if (dsShorterLT != null) ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8087c230 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2324 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-e0a6aa62 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2325 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-297f64ed | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2327 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-87314b82 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2328 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-81722ad5 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2329 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-d10f96b1 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2330 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8030f501 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2331 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-e02aa4b3 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2332 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-bba909b7 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2333 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-6439a2cc | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2334 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-8c6f611e | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2335 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-10a044f9 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2336 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-104262b6 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2337 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-827f52cb | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2338 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-93a73754 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2339 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-1a51e5c0 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2340 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-b54b3e26 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2341 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-8ba8ed7b | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2342 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-84576cc8 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2343 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c722d3da | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2344 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7a2f1c16 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2345 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-3b3f2603 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2346 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-ac09de59 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2347 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-99122e16 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2348 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-38374f78 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2349 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_customer_id"] | p_customer_id | 행/컬럼 값 대입 |  |  |  |
| AC-f0b251a5 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2350 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-3131979c | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2351 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-16d04d2f | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2352 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-753b843f | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2353 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shorter_lt_qty"] | p_shorter_lt_qty | 행/컬럼 값 대입 |  |  |  |
| AC-27989d0f | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2354 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mpp_out_qty"] | p_mpp_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-4505bd7a | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2355 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_out_qty"] | p_wpp_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-d795a192 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2357 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-357a8ba9 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2358 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9f3de097 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2364 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-74ab1044 | popSql.OnSql [if (programID == "PR_UI_FP00621_AMEND_LINE_SHO… 외 2 | FP00621_PlanAmend_Line_Formation.cs:2370 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Save_Out_Data

진입점: SaveButton [try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b9f3087 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2383 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-501b7d0b | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2391 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e02f128 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2392 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab54cb83 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2397 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a75a0a28 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2410 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf9cdea3 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2422 | try ▸ if (editDs.Good()) ▸ for (i< cnt) ▸ if ((string)row["CATEGORY_ID"] == "P_PKGPLANDATE") | DATA_OP | editDs.Tables[0].Rows.RemoveAt | (cnt-i - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3af2c473 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2431 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-14f356e9 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2432 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b53bf009 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2433 | try ▸ if (!editDs.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8337d5c | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2466 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2fafc550 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2467 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-179af32a | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2468 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9bd161f3 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2469 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a36ce7b | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2470 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9cde332d | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2471 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b666afbb | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2472 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-37fb4aff | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2473 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0ce0de5 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2474 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6922c06 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2475 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d966caeb | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2476 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c08cd0aa | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2477 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8df67f5 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2478 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CUSTOMER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1678eb8 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2464 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("PLAN_… |  | 처리 중단/반환 |  |  |  |
| AC-54787247 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2492 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["IN_QTY"] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-d6429460 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2493 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-4b86d8da | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2494 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-8a4c27dc | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2495 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-5d510c43 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2496 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["ORIG_OUT_QTY"] | selected["ORIG_OUT_QTY"].ToString().SafeZeroDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-7327a354 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2497 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["ORIG_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-44888bf4 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2498 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["ACTION"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-078fc7e5 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2503 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["MPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-007ee697 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2504 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["ORIG_MPP_OUT_QTY"] | selected["ORIG_MPP_OUT_QTY"].ToString().SafeZeroDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-43608739 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2505 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["ACTION"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-eb831cd4 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2509 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["WPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-05ce1907 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2510 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["ORIG_WPP_OUT_QTY"] | selected["ORIG_WPP_OUT_QTY"].ToString().SafeZeroDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-fb9edc82 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2511 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ e… | DATA_OP | selected["ACTION"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-ab7197e5 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2518 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-181fc3a1 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2520 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-2502c515 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2521 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-de44f2ca | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2522 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-55433a2f | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2523 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-581f49cd | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2524 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d84ba78b | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2525 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7f5339a3 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2526 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e80d26df | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2527 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FACTORY_ID"] | enum_row_from_Saving["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7edbb290 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2528 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LINE_ID"] | enum_row_from_Saving["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-89f36cb3 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2529 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OPERATION_ID"] | enum_row_from_Saving["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-00b88f98 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2530 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["TOP_ITEM_ID"] | enum_row_from_Saving["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e6e44111 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2531 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_ID"] | enum_row_from_Saving["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-08c3691d | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2532 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_TYPE"] | enum_row_from_Saving["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fd00b73f | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2533 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LOCATION"] | enum_row_from_Saving["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e53d123b | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2534 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PRODUCTION_TYPE"] | enum_row_from_Saving["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8991e73 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2535 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MARKET"] | enum_row_from_Saving["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-39bfb5f3 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2536 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ELECTRODE_TYPE"] | enum_row_from_Saving["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8019a684 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2537 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CUSTOMER_ID"] | enum_row_from_Saving["CUSTOMER_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2fedfca7 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2538 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c8d55436 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2557 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-78686f31 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2558 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-fb109c3e | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2576 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-94dea51e | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2584 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["WPP_OUT_QTY"] | mpp_wpp[order_WPP_OUT][day_string] | 행/컬럼 값 대입 |  |  |  |
| AC-60fe9410 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2602 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["WPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-41888643 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2610 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MPP_OUT_QTY"] | mpp_wpp[order_MPP_OUT][day_string] | 행/컬럼 값 대입 |  |  |  |
| AC-e2ed71fe | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2613 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ACTION"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-7cc2a774 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2614 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ba197ce7 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2617 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1216cd1 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2627 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-09173e54 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2640 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-91df7848 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2641 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fad6bd1a | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2653 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a2604b52 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2682 | try ▸ if (!string.IsNullOrEmpty(sError)) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-cf2b5a09 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2686 | try ▸ if (!string.IsNullOrEmpty(sError)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b92213ec | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2689 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e3d3d630 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2693 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-47dd4606 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2694 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2dc1590f | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2695 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2bda2a7d | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2696 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-285e7189 | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2700 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c4b3eb9b | SaveButton [try ▸ try] | FP00621_PlanAmend_Line_Formation.cs:2701 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Save_ShipPlan

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04780e3a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1903 | if (siMain == null \|\| dtData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4e3718d | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1905 | if (dtData.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b33544c8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1909 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a1895477 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1910 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57e2b2be | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1915 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6abe02e4 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1927 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("this data can't save! , Plan type is Release!") | 메시지 표시 |  |  |  |
| AC-cd7b0de2 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1928 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0ef8e1a3 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1929 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-956ef7ab | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1932 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6b8392b1 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1945 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9a55adf9 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1946 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45b325be | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1949 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-39eb27f0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1961 | try ▸ if (dtData.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf3eec1b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1979 | try ▸ if (!string.IsNullOrEmpty(sError)) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-71599e59 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1983 | try ▸ if (!string.IsNullOrEmpty(sError)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9611db9c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1986 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0f6e93e5 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1990 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2879a8b8 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1991 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bec3ad2a | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1992 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-e26a86a4 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1993 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-996d2e24 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1997 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f56d68a4 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:1998 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_PlanAmend_Line_Formation.Save_Shorter

진입점: this.btnSimulation.Click [if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dsShorterLT.Tables[0].Rows.Count > 0)] / SaveButton [try ▸ if (dsShorterLT != null) ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db65abcb | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2141 | if (siMain == null \|\| dtData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2391b891 | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2143 | if (dtData.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7cb07db8 | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2147 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d01aa9af | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2148 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e3eb1ab | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2153 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b1efff3e | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2165 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("this data can't save! , Plan type is Release!") | 메시지 표시 |  |  |  |
| AC-26d0f577 | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2166 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6a679e74 | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2167 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a452c4a | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2170 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-30356d2a | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2183 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8ce9804 | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2184 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a732f9b1 | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2187 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c0c0c51b | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2199 | try ▸ if (dtData.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e15420b8 | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2217 | try ▸ if (!string.IsNullOrEmpty(sError)) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-c989f260 | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2221 | try ▸ if (!string.IsNullOrEmpty(sError)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-32e9ea6f | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2224 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-df10ba2a | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2228 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5343ea3b | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2229 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-60a9793f | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2230 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-db8abea5 | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2231 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a2f3fd2e | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2235 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-17366385 | this.btnSimulation.Click [if (MessageBox.Show("do you Excuti… 외 1 | FP00621_PlanAmend_Line_Formation.cs:2236 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4917ccd | SaveButton | FP00621_PlanAmend_Line_Formation.cs:935 | if (!IsChange) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b189f26e | SaveButton | FP00621_PlanAmend_Line_Formation.cs:936 | if (!IsChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-336a373e | SaveButton | FP00621_PlanAmend_Line_Formation.cs:940 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8828a357 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:941 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fa84e1db | SaveButton | FP00621_PlanAmend_Line_Formation.cs:967 | try ▸ catch ((Exception)) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-79e6b5c0 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:968 | try ▸ catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-cac58dd0 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:988 | try ▸ if (dsShorterLT != null) ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) ▸ catch ((Exception)) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9e68ee54 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:989 | try ▸ if (dsShorterLT != null) ▸ if (dsShorterLT.Tables[0].Rows.Count > 0) ▸ catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-6fc07bd8 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:998 | try ▸ if (bSaveChk == true) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a15d06e0 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1012 | try ▸ if (bSaveChk == true) ▸ try ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1) ▸ if (dsCWAActive != null) ▸ if (dsCWAAct… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ce164e36 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1016 | try ▸ if (bSaveChk == true) ▸ try ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1) ▸ if (dsCWAActive != null) ▸ if (dsCWAAct… | POPUP | new Planning.UIL.FP00621_InValidationExcelPopup | ("InvalidationCWSPopup", dsCWAActive, sMsg2) | 팝업/폼 생성 |  |  |  |
| AC-255be117 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1017 | try ▸ if (bSaveChk == true) ▸ try ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1) ▸ if (dsCWAActive != null) ▸ if (dsCWAAct… | UI_PROP | popValid.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-246456ee | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1018 | try ▸ if (bSaveChk == true) ▸ try ▸ if (Filter["INSTANCE_ID"].ToString().IndexOf("PL_FORM") != -1) ▸ if (dsCWAActive != null) ▸ if (dsCWAAct… | POPUP | popValid.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8309f1bf | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1026 | try ▸ if (bSaveChk == true) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5aff1e13 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1031 | try ▸ if (bSaveChk == true) ▸ try ▸ if (bShortSaveChk == true) | GRID_SET | siMain.ActiveSheet.Cells[0, iCol, siMain.GetMaxRowIndex(), iCol].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-d72cc780 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1038 | try ▸ if (bSaveChk == true) ▸ catch () | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d8f5d285 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1039 | try ▸ if (bSaveChk == true) ▸ catch () | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1ac76d64 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1040 | try ▸ if (bSaveChk == true) ▸ catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-392776de | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1045 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-49cd5ae0 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1049 | try ▸ if (dsShorterLT != null) | STATE_RESET | dsShorterLT.Tables[0].Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-04f213c4 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1057 | try ▸ if (!string.IsNullOrEmpty(sMsg)) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8b7ecf76 | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1062 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-c777190f | SaveButton | FP00621_PlanAmend_Line_Formation.cs:1064 |  | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetBasisTime

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.btnRelease.Click [if (sConfirmArea == "PLAN GROUP")] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-696a42ea | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5156 |  | FLAG | dtBaseTime | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findBasisTime", sInstance,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-cefdeab0 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5156 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findBasisTime", sInstance, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetBohTotalQty

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (dsMain.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95118a87 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1869 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a61ff64 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1874 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-306005e0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1879 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1847788c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1880 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd776ee5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1881 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-971e1c6e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1882 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0dc6d02a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1883 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e75b304 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1884 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7fe322a6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1885 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c9273ab9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1886 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbb3b886 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:1890 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetCalenderColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04c54f11 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 12 | FP00621_PlanAmend_Line_Formation.cs:7776 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-84132230 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 12 | FP00621_PlanAmend_Line_Formation.cs:7780 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-08182e5e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 12 | FP00621_PlanAmend_Line_Formation.cs:7782 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-50e28acc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 12 | FP00621_PlanAmend_Line_Formation.cs:7786 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-a25d785f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 12 | FP00621_PlanAmend_Line_Formation.cs:7802 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-8f351a36 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 12 | FP00621_PlanAmend_Line_Formation.cs:7817 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetChangeControl

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / cbo_fpplanid.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / mcbo_line.SelectedIndexChanged / chk_allLine.CheckedChanged / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClic…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94302fee | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:420 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-585c3834 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:420 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0d5f308c | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:429 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-40a728a9 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:429 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c540f5e7 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:430 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-48803c2a | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:436 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-86764952 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:437 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-89d12c1d | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:437 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-824d5ec9 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:438 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-78a5e022 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:444 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, mcbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-65226d5f | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:445 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5dd9a529 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:445 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-48f5ad18 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:446 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4aaf9db1 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:452 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-51e76e0c | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:453 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-42d59c6c | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:453 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8ac1c3b2 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:454 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2820124f | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:461 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-d003303c | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:462 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b926fb65 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:462 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-01c3585e | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:463 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-34de860d | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:469 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-1f34955e | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:470 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-54b28182 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:470 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c2e0dd17 | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:471 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-88ca484b | this.Load [try] 외 14 | FP00621_PlanAmend_Line_Formation.cs:477 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetColumnChangeByText

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ac7a757 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:627 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2d5c2063 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:644 | if (iColMinStartIndex <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74585867 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:649 | try | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-6810be7b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:651 | try | FLAG | DateCellType | new FarPoint.Win.Spread.CellType.DateTimeCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-b224dfab | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:653 | try | FLAG | MaskcellType | new FarPoint.Win.Spread.CellType.MaskCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e108a066 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:654 | try | UI_PROP | MaskcellType.Mask | "####-##-##" | 속성 Mask 설정 |  |  |  |
| AC-0b94125e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:658 | try | UI_PROP | DateCellType.DateTimeFormat | FarPoint.Win.Spread.CellType.DateTimeFormat.UserDefined | 속성 DateTimeFormat 설정 |  |  |  |
| AC-78f4ba8f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:659 | try | UI_PROP | DateCellType.UserDefinedFormat | "yyyy-MM-dd" | 속성 UserDefinedFormat 설정 |  |  |  |
| AC-6169d243 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:661 | try | FLAG | NumcellType | new FarPoint.Win.Spread.CellType.NumberCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-c3a60a31 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:663 | try | UI_PROP | NumcellType.DecimalPlaces | 2 | 속성 DecimalPlaces 설정 |  |  |  |
| AC-b0c40469 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:664 | try | UI_PROP | NumcellType.Separator | "," | 속성 Separator 설정 |  |  |  |
| AC-efff9982 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:665 | try | UI_PROP | NumcellType.ShowSeparator | true | 속성 ShowSeparator 설정 |  |  |  |
| AC-1e397744 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:676 | try ▸ if (LTidx > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) | GRID_SET | siMain.ActiveSheet.Cells[k, LTidx].CellType | NumcellType | 그리드 속성/값 설정 |  |  |  |
| AC-514ef3a4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:690 | try ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolnames[i] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-62c95902 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:691 | try ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolidxs[i] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-fc692e74 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:712 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a8019295 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:718 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-4917693e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:719 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-aee924e2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:720 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e1113547 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:724 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].CellType | MaskcellType | 그리드 속성/값 설정 |  |  |  |
| AC-a690a0e6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:726 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].Value | sData | 그리드 속성/값 설정 |  |  |  |
| AC-4d79c3b7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:727 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-33de664d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:731 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-1e543d10 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:732 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | GRID_SET | siMain.ActiveSheet.Cells[k, colindex].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-b768fff2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:733 | try ▸ foreach (var each_day in calendar.days) ▸ if (colindex > -1) ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType.Equals("DATA") … | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b7900dc6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00621_PlanAmend_Line_Formation.cs:772 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc12115c | this.Load | FP00621_PlanAmend_Line_Formation.cs:251 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-75c3f2a4 | this.Load | FP00621_PlanAmend_Line_Formation.cs:253 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-206149f7 | this.Load | FP00621_PlanAmend_Line_Formation.cs:257 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-40338525 | this.Load | FP00621_PlanAmend_Line_Formation.cs:259 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-57b26236 | this.Load | FP00621_PlanAmend_Line_Formation.cs:260 |  | CALL_EXT | UserService.HasSuperRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99bf6840 | this.Load | FP00621_PlanAmend_Line_Formation.cs:262 | if (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-33de9bc3 | this.Load | FP00621_PlanAmend_Line_Formation.cs:266 | else of (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetDirty

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / menu_line.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equals("Y") && sPlanIDTag != "00") ▸ for (j <= nRowEnd) ▸ if (row_to_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef0126b9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 15 | FP00621_PlanAmend_Line_Formation.cs:5460 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d32bf56 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5166 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-dc8ec0a6 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5166 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f37d9915 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5167 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetEnabledButton

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.I…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9e43657 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1599 | if (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-15e35a6a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1604 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek != null) ▸ if (dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-313b4f8f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1606 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek != null) ▸ if (dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-912a69df | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1610 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek != null) ▸ else of (dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-83ab8cca | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1612 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek != null) ▸ else of (dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a76f3423 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1617 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (dtIsCurrWeek != null) | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7ea0c77f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1619 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (dtIsCurrWeek != null) | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a430ed0 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5373 |  | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-df206ed3 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5373 |  | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f017e82e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5374 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_planner.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) ▸ if (dtPlanId.Rows.Count > 0)] / cbo_fpplanid.SelectedIndexChanged [if (cbo_fpplanid.Items.Count > 0)] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Go…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e18dd4db | this.Load [try] 외 30 | FP00621_PlanAmend_Line_Formation.cs:5135 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetFpPlanId

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.btnRelease.Click [if (sConfirmArea == "PLAN GROUP")] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-021ec93e | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5268 |  | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00621_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-925d1427 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5268 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00621_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fbb5b6cb | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5269 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4bf277b5 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5272 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-4aa5b392 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5274 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | cbo_fpplanid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-3c41620d | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5293 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[0]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-4a6f3a48 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5294 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[0]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-125a26e1 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5295 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[0]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-3f9f4112 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5296 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[0]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-2d93c690 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5297 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[0]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-aec0f5c0 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5299 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-c7066c4e | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5300 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-8d001b07 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5301 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-46e2bbca | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5302 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-424a10e0 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5303 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-b401985e | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5308 | if (dtPlanId.Rows.Count > 0) ▸ if (dtPlanId.Rows[iDx]["READ_ONLY"].ToString().Equals("Y")) | FLAG | bReadOnly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9fb1dfa8 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5309 | if (dtPlanId.Rows.Count > 0) ▸ if (dtPlanId.Rows[iDx]["READ_ONLY"].ToString().Equals("Y")) | STATE | btnSimulation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c172a63d | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5313 | if (dtPlanId.Rows.Count > 0) ▸ else of (dtPlanId.Rows[iDx]["READ_ONLY"].ToString().Equals("Y")) | FLAG | bReadOnly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-86f4e4af | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5314 | if (dtPlanId.Rows.Count > 0) ▸ else of (dtPlanId.Rows[iDx]["READ_ONLY"].ToString().Equals("Y")) | STATE | btnSimulation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-788b1663 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5320 | if (dtPlanId.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE") | STATE | btnRePlan.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d11eea8e | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5322 | if (dtPlanId.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-26033c35 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5324 | if (dtPlanId.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7b71ef38 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5328 | if (dtPlanId.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"].ToString() == "RELEASE") | STATE | btnRePlan.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1e83e660 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5330 | if (dtPlanId.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"].ToString() == "RELEASE") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-734bba20 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5332 | if (dtPlanId.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"].ToString() == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8b49a417 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5337 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-83f197e7 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5338 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-2c204610 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5339 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-157c1b6c | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5340 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-0992de24 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5341 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-ee88ed67 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5343 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-8ed8fb44 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5344 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-1ff466cf | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5345 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-1b1e3d62 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5346 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-ffba8a74 | this.Load [try] 외 4 | FP00621_PlanAmend_Line_Formation.cs:5347 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetLine

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner.Items.Count) ▸ if (mcbo_planner.Items[k].ToString() == sValueName.ToString())] / mcbo_planner.SelectedIndexChanged / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner.Items.Count) ▸ if (mcbo_planner.Items[k].ToString() == sValueName.ToString())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23200555 | this.Load [try] 외 3 | FP00621_PlanAmend_Line_Formation.cs:5408 |  | DATA_OP | Filter["ALL_LINE"] | chk_allLine.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-a1b2fc4d | this.Load [try] 외 3 | FP00621_PlanAmend_Line_Formation.cs:5411 |  | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-95849871 | this.Load [try] 외 3 | FP00621_PlanAmend_Line_Formation.cs:5411 |  | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6471b2d3 | this.Load [try] 외 3 | FP00621_PlanAmend_Line_Formation.cs:5413 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetOperation

진입점: this.chk_includeSubOp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80570449 | this.chk_includeSubOp.CheckedChanged | FP00621_PlanAmend_Line_Formation.cs:5382 |  | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-73c40397 | this.chk_includeSubOp.CheckedChanged | FP00621_PlanAmend_Line_Formation.cs:5382 |  | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-dd725540 | this.chk_includeSubOp.CheckedChanged | FP00621_PlanAmend_Line_Formation.cs:5383 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetPlanDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-540fb705 | this.Load [try] | FP00621_PlanAmend_Line_Formation.cs:5146 |  | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetPlanner

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdc992c4 | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5180 | if (sInstance.Equals("PL_FORM_A")) | FLAG | dtPlanner | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00607_findPlanner_List_exception… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-8161f3ed | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5180 | if (sInstance.Equals("PL_FORM_A")) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_findPlanner_List_exception", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-deceea60 | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5182 | else of (sInstance.Equals("PL_FORM_A")) | FLAG | dtPlanner | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findPlanner_List", sInstan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-fd7a86cc | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5182 | else of (sInstance.Equals("PL_FORM_A")) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findPlanner_List", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8d3f5efd | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5184 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, mcbo_planner, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-9015d424 | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5194 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row[… | CALL_EXT | mcbo_planner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-765182b7 | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5198 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of … | CALL_EXT | mcbo_planner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-27fb3b3c | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5214 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-047d30d7 | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5215 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-e1e80dcb | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5219 | if (dtPlanner != null) ▸ else of (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-6476d4ed | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5220 | if (dtPlanner != null) ▸ else of (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-cd830e3c | this.Load [try] 외 2 | FP00621_PlanAmend_Line_Formation.cs:5230 | if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner.Items.Count) ▸ if (mcbo_planner.Items[k].ToString() == sValueName.ToString()) | CALL_EXT | mcbo_planner.SetItemChecked | (k, true) | ⚠ 의미 확인 필요 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetPlanOut_DataSet

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ else of (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME")) ▸ if (sCateID.Equals("P_OUT") \|\| sCateID.Equals("M_OUT") \|\| sCateID.Equals("W_OUT"))] / menu_line.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7d6ba0d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5590 | try ▸ if (dsMainFiltered.Good()) ▸ if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-08dce5de | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5591 | try ▸ if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-69568bb3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5592 | try ▸ if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-ceab3904 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5593 | try ▸ if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-94f589a9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5606 | try ▸ if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ebe7bb3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5615 | try ▸ if (dsMainFiltered.Good()) ▸ if (org_value == new_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-abd003bf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5689 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("SetPlanOut_DataSet:" + ex.Message.ToString()) | 메시지 표시 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetPlanPeriod

진입점: this.Load [try] / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51342309 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:5438 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-bc712b74 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:5439 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-e3e29fb4 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:5443 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-5b1929b4 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:5444 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-a2d62ba3 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:5450 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-168c2dd4 | this.Load [try] 외 1 | FP00621_PlanAmend_Line_Formation.cs:5451 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5793e4ed | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5363 |  | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-320d08e9 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5363 |  | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-233ef978 | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5364 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetShortLT_DataSet

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT") ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (ColumnName_Buf.ToUpper().Equals("SHORTER_LEAD_TIME"))] / menu_line.Click [if (dsMainFiltered.Good()) ▸ if (calendar != null) ▸ foreach (AmendDate day in calendar.Days.Values) ▸ if (iCol > -1) ▸ if (day.IsPlan == true) ▸ if (_sSaveAuth.Equals("Y…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b74554c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5713 | try ▸ if (dsShorterLT == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00607_find_ListData_LT", Filter["DIVISION_ID"].ToString(), Filter["SIT… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b25b86d4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5716 | try ▸ if (dsShorterLT == null) | FLAG | dsShorterLT | dtShorter.DataSet.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-275a5d28 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5716 | try ▸ if (dsShorterLT == null) | DATA_OP | dtShorter.DataSet.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d86ebc4c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5732 | try ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3e0148d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5733 | try ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-167f63a0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5734 | try ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc827c63 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5735 | try ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-942c6234 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5736 | try ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc36c47f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5737 | try ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-227a6158 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5738 | try ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2e5ab2c9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5732 | try ▸ lambda | RETURN | return (x.Field<string>("DIVISION_ID") == row["DIVISION_ID"].ToString() && x.Fie… |  | 처리 중단/반환 |  |  |  |
| AC-23f22b3e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5749 | try ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | selected["SHORTER_LT"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-812a8c81 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5750 | try ▸ if (MatchingEditRowData.Count() > 0) | DATA_OP | dtShorter.ImportRow | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-220656bd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5754 | try ▸ if (MatchingEditRowData.Count() > 0) ▸ if (dsShorterLT == null) | FLAG | dsShorterLT | dtShorter.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-3ce5c4d4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5764 | try ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtShorter.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bf4644ea | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5766 | try ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aa4b8854 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5767 | try ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8ea66fa3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5768 | try ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4ee0d8f6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5769 | try ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd31343b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5770 | try ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04f5687d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5771 | try ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-351d044b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5772 | try ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-70ac62e7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5773 | try ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-503c011b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5774 | try ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SHORTER_LT"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-dd536cac | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5777 | try ▸ else of (MatchingEditRowData.Count() > 0) | DATA_OP | dtShorter.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-2962cf86 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5780 | try ▸ else of (MatchingEditRowData.Count() > 0) ▸ if (dsShorterLT == null) | FLAG | dsShorterLT | dtShorter.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c158a67f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5783 | try ▸ else of (MatchingEditRowData.Count() > 0) ▸ else of (dsShorterLT == null) | DATA_OP | dsShorterLT.Tables["Table"].ImportRow | (dtShorter.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b174b73 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5864 | try ▸ for (i <= nRowEnd) | GRID_SET | siMain.ActiveSheet.Cells[i, cCol].Value | new_value | 그리드 속성/값 설정 |  |  |  |
| AC-b7996da2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 4 | FP00621_PlanAmend_Line_Formation.cs:5873 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5604f4b | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5356 |  | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f97f449c | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5356 |  | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4e8de14e | (진입점 미연결) | FP00621_PlanAmend_Line_Formation.cs:5357 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.spdMain.CellDoubleClick…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63d395b9 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:527 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2fdc700 | this.Load [try] 외 12 | FP00621_PlanAmend_Line_Formation.cs:528 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SetTotalColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b664dcd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 12 | FP00621_PlanAmend_Line_Formation.cs:572 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81771cf1 | this.spdMain.ButtonClicked | FP00621_PlanAmend_Line_Formation.cs:4735 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff22b745 | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4388 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f2c6c98a | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4389 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34434d8e | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4412 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-b8edf9dc | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4413 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-90d37542 | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4415 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-602b0448 | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4424 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-d837bcfb | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4425 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-ea2c9caf | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4427 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-a89a552b | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4436 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | menu_line.Text | "Zero Setting(Line)" | 컨트롤 값 설정 |  |  |  |
| AC-0ba3ba08 | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4437 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | menu_line.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-990506ed | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4439 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (menu_line) | 데이터 객체 조작/조회 |  |  |  |
| AC-185c5036 | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4445 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | menu_material.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-15da5196 | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4446 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | menu_material.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-e037acfb | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4448 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (menu_material) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ec5f1fb | this.spdMain.CellClick | FP00621_PlanAmend_Line_Formation.cs:4455 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c756b20 | this.spdMain.CellDoubleClick | FP00621_PlanAmend_Line_Formation.cs:8261 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-ca8daea5 | this.spdMain.CellDoubleClick | FP00621_PlanAmend_Line_Formation.cs:8268 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1e682bb | this.spdMain.ChildControlDeactivated | FP00621_PlanAmend_Line_Formation.cs:4503 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9280c32b | this.spdMain.ClipboardPasted | FP00621_PlanAmend_Line_Formation.cs:4743 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e447ebd0 | this.spdMain.ClipboardPasted | FP00621_PlanAmend_Line_Formation.cs:4751 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6162af67 | this.spdMain.ClipboardPasted | FP00621_PlanAmend_Line_Formation.cs:4752 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-250b2409 | this.spdMain.ClipboardPasted | FP00621_PlanAmend_Line_Formation.cs:4754 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9d7486f | this.spdMain.ClipboardPasting | FP00621_PlanAmend_Line_Formation.cs:4760 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-0757a959 | this.spdMain.ClipboardPasting | FP00621_PlanAmend_Line_Formation.cs:4761 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-8cc34c98 | this.spdMain.ClipboardPasting | FP00621_PlanAmend_Line_Formation.cs:4761 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-723a106a | this.spdMain.ClipboardPasting | FP00621_PlanAmend_Line_Formation.cs:4765 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-a37dea05 | this.spdMain.ClipboardPasting | FP00621_PlanAmend_Line_Formation.cs:4765 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-da05bf7e | this.spdMain.ClipboardPasting | FP00621_PlanAmend_Line_Formation.cs:4769 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39e118d6 | this.spdMain.ClipboardPasting | FP00621_PlanAmend_Line_Formation.cs:4771 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9e5ffd7 | this.spdMain.DragFillBlockCompleted | FP00621_PlanAmend_Line_Formation.cs:4513 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd93a0f1 | this.spdMain.EditModeOff | FP00621_PlanAmend_Line_Formation.cs:4531 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6508ee5b | this.spdMain.EditModeOn | FP00621_PlanAmend_Line_Formation.cs:4537 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-a755dfb4 | this.spdMain.EditModeOn | FP00621_PlanAmend_Line_Formation.cs:4538 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b61db28 | this.spdMain.EditorFocused | FP00621_PlanAmend_Line_Formation.cs:4525 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98cf8e44 | this.spdMain.Enter | FP00621_PlanAmend_Line_Formation.cs:4488 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ca54c88 | this.spdMain.KeyDown | FP00621_PlanAmend_Line_Formation.cs:4469 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-3813fd77 | this.spdMain.KeyDown | FP00621_PlanAmend_Line_Formation.cs:4473 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_PROP | this.DeleteOperation | DeleteOperationKind.Nothing | 속성 DeleteOperation 설정 |  |  |  |
| AC-dc58c65f | this.spdMain.KeyDown | FP00621_PlanAmend_Line_Formation.cs:4474 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2fb720c7 | this.spdMain.KeyDown | FP00621_PlanAmend_Line_Formation.cs:4476 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-198a0503 | this.spdMain.KeyDown | FP00621_PlanAmend_Line_Formation.cs:4477 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09711063 | this.spdMain.Leave | FP00621_PlanAmend_Line_Formation.cs:4483 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-385fc57b | this.spdMain.SubEditorClosed | FP00621_PlanAmend_Line_Formation.cs:4519 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7009e8f | this.spdMain.SubEditorOpening | FP00621_PlanAmend_Line_Formation.cs:4508 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fa379c6 | this.spdMain.Validated | FP00621_PlanAmend_Line_Formation.cs:4493 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-981997e9 | this.spdMain.Validating | FP00621_PlanAmend_Line_Formation.cs:4498 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00621_PlanAmend_Line_Formation.SwitchMemo

진입점: memo_menu.Click [if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55998584 | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8279 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f09191df | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8296 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-1b519f0d | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8321 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-58bd7f59 | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8347 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-88786432 | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8349 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-07137e4a | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8352 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-55ee63b9 | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8354 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8881680 | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8354 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-19701f42 | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8355 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-37c2fc22 | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8357 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-161cd799 | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8359 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-acbd550d | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8371 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-32f5a0a5 | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8371 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-b04b6a81 | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8391 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-452dd889 | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8392 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-c42c031b | memo_menu.Click [if (day != null)] 외 1 | FP00621_PlanAmend_Line_Formation.cs:8394 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00621_PlanAmend_Line_Formation.UIFindData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.bUploadSaveFlag == true)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK)] / this.btnRePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK)] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCatagory.Click [if (frm.DialogResult == Dial…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69ca357d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1155 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f21e6d56 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1156 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83336b92 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1159 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-13ae86c0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1163 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2862ee46 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1164 | try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ab6b7a99 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1166 | try | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fb5bbd6b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1169 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-69e0a3a2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1171 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-c564ae9e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1176 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fd8f54a5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1178 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-119b936c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1178 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d1189ed8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1188 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | LastTotalRaw | FindTotalValue("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-70c90dac | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1190 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9945b948 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1198 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cda5c8ae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1200 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1749943c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1204 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-92789294 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1206 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-73fea32b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1209 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-555f6a40 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1212 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f1d6bc7a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1216 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-078e162d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1217 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-e2f5e0f3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1221 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dd8b0c2e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1223 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-47347f71 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1227 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-20a4b421 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1229 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-383c9676 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1232 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-59d96f46 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1237 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-dd7898d8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1238 | try ▸ else of (dsMain != null) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7035572d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1239 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-acdb2bab | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1242 | try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f15db3f0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1251 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-74502598 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1254 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e4a5859a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1261 | try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-756c6ebc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1268 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3343be2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1274 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b257ef3c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00621_PlanAmend_Line_Formation.cs:1275 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

