# AS-IS 액션 대조표 — FP00622

> 원천: `Doc/asisfacts/screens/FP00622/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1936행 · 메서드 148 · 종류 DATA_OP 924 · UI_PROP 162 · RETURN 152 · FLAG 116 · VALUE_SET 84 · COMBO_DATA 78 · MESSAGE 75 · UI_MISC 51 · POPUP 50 · GRID_SET 48 · CALL_EXT 42 · ENDPOINT 36 · STATE 35 · GRID_INIT 18 · LIST_REBIND 16 · GRID_LOCK 10 · FOCUS 9 · THROW 8 · CALL_BASE 6 · GRID_STYLE 5 · LIST_CLEAR 3 · STATE_RESET 3 · GRID_BIND 2 · EXCEL 1 · VALUE_CLEAR 1 · LIST_BIND 1 · ⚠ 의미 확인 필요 48


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-935c609b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7024 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-208b2eb7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7030 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ae41e122 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7038 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-7a9e842c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7039 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-91246482 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7040 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-aa920dca | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7041 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-4c7a40d0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7043 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c838ea5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7044 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-d4c0418b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7045 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-1946b1cf | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7046 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-8b5cc26e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7047 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ebf750b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7048 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-8797eafe | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7049 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f5ffa28 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7050 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-ef03055f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7053 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-b2aa07ec | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7238 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-c236c5ba | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7239 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-0fb2dcb0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7240 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-8e314bdc | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7241 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-a23366a0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7243 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-f14f9128 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7244 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-a068fe61 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7245 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-79267168 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7246 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-1a13928b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7247 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-61a5b10c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7248 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-97d2b91c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7249 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-30c048dc | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7250 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-79bf2fca | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7252 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3809ef09 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7157 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e3f0785 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7158 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-627400ad | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7159 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d541388b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7160 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-216bafe0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7161 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-65382965 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7164 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-64eab62c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7168 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ffc01d2e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7169 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b13cfdc5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7155 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-6744a135 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7185 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-38f9609c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7188 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-81582896 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7191 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec35c7cf | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7194 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-f009173d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7197 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-7a6d93df | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7200 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-43c1dba5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7206 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-0888146d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7208 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5772b86 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7129 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-668acb2e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7093 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-19d182ed | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7094 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7db078d9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7095 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1007ce7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7096 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-70af3b7a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7097 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2a2b86c3 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7098 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-36e829d0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7100 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd253b38 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7101 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2399ffe | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7104 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-06d40160 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7105 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-42f7cd1a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7106 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e335214 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7091 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-eb145c59 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7114 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-2702ac12 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7115 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-b746c136 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7120 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0f1f9f0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7066 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00622_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5baacbc1 | .ctor | FP00622_MeasureSetForm_Popup.cs:106 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-89e8adec | .ctor | FP00622_MeasureSetForm_Popup.cs:107 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-828db928 | .ctor | FP00622_MeasureSetForm_Popup.cs:108 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-7ef698c1 | .ctor | FP00622_MeasureSetForm_Popup.cs:110 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00622_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4adf5750 | this.btnOK.Click | FP00622_MeasureSetForm_Popup.cs:387 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-a5054a65 | this.btnOK.Click | FP00622_MeasureSetForm_Popup.cs:388 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-89906c25 | this.btnOK.Click | FP00622_MeasureSetForm_Popup.cs:395 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-239b5d8d | this.btnOK.Click | FP00622_MeasureSetForm_Popup.cs:396 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00622_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-305f03e6 | this.btnSet.Click | FP00622_MeasureSetForm_Popup.cs:356 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-7c91cd52 | this.btnSet.Click | FP00622_MeasureSetForm_Popup.cs:357 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-80f569a5 | this.btnSet.Click | FP00622_MeasureSetForm_Popup.cs:359 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-46e94669 | this.btnSet.Click | FP00622_MeasureSetForm_Popup.cs:360 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-38ac3afb | this.btnSet.Click | FP00622_MeasureSetForm_Popup.cs:362 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-0426fca8 | this.btnSet.Click | FP00622_MeasureSetForm_Popup.cs:364 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-1826e952 | this.btnSet.Click | FP00622_MeasureSetForm_Popup.cs:365 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00622_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45e56594 | Dispose | FP00622_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00622_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb1df6e9 | this.Load | FP00622_MeasureSetForm_Popup.cs:135 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00622_MeasureSetForm_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1f5b916 | this.Load | FP00622_MeasureSetForm_Popup.cs:211 |  | FLAG | dtCategory | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "select_measure", "FP00622_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-7036eed5 | this.Load | FP00622_MeasureSetForm_Popup.cs:211 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00622_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c23a6cd6 | this.Load | FP00622_MeasureSetForm_Popup.cs:213 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-2e0f51d5 | this.Load | FP00622_MeasureSetForm_Popup.cs:214 |  | FLAG | measure_val | new bool[measure_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-4171e63e | this.Load | FP00622_MeasureSetForm_Popup.cs:215 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-44530dce | this.Load | FP00622_MeasureSetForm_Popup.cs:242 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-025238e9 | this.Load | FP00622_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-1885472e | this.Load | FP00622_MeasureSetForm_Popup.cs:245 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-9da473e7 | this.Load | FP00622_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-e535112d | this.Load | FP00622_MeasureSetForm_Popup.cs:248 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-da8c4f61 | this.Load | FP00622_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-6395380f | this.Load | FP00622_MeasureSetForm_Popup.cs:251 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-64544eff | this.Load | FP00622_MeasureSetForm_Popup.cs:252 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-d187b923 | this.Load | FP00622_MeasureSetForm_Popup.cs:254 |  | DATA_OP | ctrls.Add | (chk_engine_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1d2d213 | this.Load | FP00622_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_engine_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3f3e185 | this.Load | FP00622_MeasureSetForm_Popup.cs:256 |  | DATA_OP | ctrls.Add | (chk_target) | 데이터 객체 조작/조회 |  |  |  |
| AC-22e5db90 | this.Load | FP00622_MeasureSetForm_Popup.cs:259 |  | DATA_OP | ctrls.Add | (chk_uom) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0d36555 | this.Load | FP00622_MeasureSetForm_Popup.cs:260 |  | DATA_OP | ctrls.Add | (chk_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c1d4054 | this.Load | FP00622_MeasureSetForm_Popup.cs:263 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8557398 | this.Load | FP00622_MeasureSetForm_Popup.cs:264 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-6cee586a | this.Load | FP00622_MeasureSetForm_Popup.cs:265 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-797ef006 | this.Load | FP00622_MeasureSetForm_Popup.cs:267 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-8adaa657 | this.Load | FP00622_MeasureSetForm_Popup.cs:268 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-6eba166c | this.Load | FP00622_MeasureSetForm_Popup.cs:270 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-480f7bb3 | this.Load | FP00622_MeasureSetForm_Popup.cs:271 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c8b9fb9 | this.Load | FP00622_MeasureSetForm_Popup.cs:272 |  | DATA_OP | ctrls.Add | (chk_result_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-eeefbdd3 | this.Load | FP00622_MeasureSetForm_Popup.cs:274 |  | DATA_OP | ctrls.Add | (chk_engine_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7d1253e | this.Load | FP00622_MeasureSetForm_Popup.cs:275 |  | DATA_OP | ctrls.Add | (chk_engine_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-20ab2ba2 | this.Load | FP00622_MeasureSetForm_Popup.cs:276 |  | DATA_OP | ctrls.Add | (chk_target_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-171026d4 | this.Load | FP00622_MeasureSetForm_Popup.cs:278 |  | DATA_OP | ctrls.Add | (chk_off) | 데이터 객체 조작/조회 |  |  |  |
| AC-19662eec | this.Load | FP00622_MeasureSetForm_Popup.cs:279 |  | DATA_OP | ctrls.Add | (chk_setup) | 데이터 객체 조작/조회 |  |  |  |
| AC-4896cacc | this.Load | FP00622_MeasureSetForm_Popup.cs:280 |  | DATA_OP | ctrls.Add | (chk_capa) | 데이터 객체 조작/조회 |  |  |  |
| AC-a112c2a6 | this.Load | FP00622_MeasureSetForm_Popup.cs:282 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f065f8a | this.Load | FP00622_MeasureSetForm_Popup.cs:283 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-58f930ca | this.Load | FP00622_MeasureSetForm_Popup.cs:286 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-fdb00ea4 | this.Load | FP00622_MeasureSetForm_Popup.cs:286 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-b40c126c | this.Load | FP00622_MeasureSetForm_Popup.cs:293 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-ec354b04 | this.Load | FP00622_MeasureSetForm_Popup.cs:298 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-6d7c0a86 | this.Load | FP00622_MeasureSetForm_Popup.cs:302 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00622_MeasureSetForm_Popup.InitNames

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f13744ae | this.Load | FP00622_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-129eaac7 | this.Load | FP00622_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ecf5e4de | this.Load | FP00622_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d2d9cf97 | this.Load | FP00622_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-cfba2dd8 | this.Load | FP00622_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-70f66c9f | this.Load | FP00622_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6197a2ea | this.Load | FP00622_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-71363d2a | this.Load | FP00622_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5883c6e7 | this.Load | FP00622_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_engine_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4a1e64d4 | this.Load | FP00622_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_engine_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e5164c02 | this.Load | FP00622_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_target.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-32bf5300 | this.Load | FP00622_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_uom.Text | measure_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-87fe0a62 | this.Load | FP00622_MeasureSetForm_Popup.cs:167 |  | VALUE_SET | chk_cell.Text | measure_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1165c727 | this.Load | FP00622_MeasureSetForm_Popup.cs:171 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-39db39fb | this.Load | FP00622_MeasureSetForm_Popup.cs:172 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-44970ee3 | this.Load | FP00622_MeasureSetForm_Popup.cs:173 |  | VALUE_SET | chk_memo_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-38dc53fb | this.Load | FP00622_MeasureSetForm_Popup.cs:175 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3cc0544e | this.Load | FP00622_MeasureSetForm_Popup.cs:176 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-673c46d2 | this.Load | FP00622_MeasureSetForm_Popup.cs:178 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bd579cd9 | this.Load | FP00622_MeasureSetForm_Popup.cs:179 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5ba53f31 | this.Load | FP00622_MeasureSetForm_Popup.cs:180 |  | VALUE_SET | chk_result_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c57981cd | this.Load | FP00622_MeasureSetForm_Popup.cs:182 |  | VALUE_SET | chk_engine_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1ce5abfd | this.Load | FP00622_MeasureSetForm_Popup.cs:183 |  | VALUE_SET | chk_engine_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-746cfcf5 | this.Load | FP00622_MeasureSetForm_Popup.cs:184 |  | VALUE_SET | chk_target_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-84fb9a24 | this.Load | FP00622_MeasureSetForm_Popup.cs:186 |  | VALUE_SET | chk_off.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-83c18ed6 | this.Load | FP00622_MeasureSetForm_Popup.cs:187 |  | VALUE_SET | chk_setup.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-aa289184 | this.Load | FP00622_MeasureSetForm_Popup.cs:188 |  | VALUE_SET | chk_capa.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-83c2590c | this.Load | FP00622_MeasureSetForm_Popup.cs:190 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-524c43e0 | this.Load | FP00622_MeasureSetForm_Popup.cs:191 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00622_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfa7e4f3 | this.Load | FP00622_MeasureSetForm_Popup.cs:120 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-54cedb85 | this.Load | FP00622_MeasureSetForm_Popup.cs:128 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00622_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9fd66c7 | this.btnSet.Click 외 1 | FP00622_MeasureSetForm_Popup.cs:402 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-63b1409e | this.btnSet.Click 외 1 | FP00622_MeasureSetForm_Popup.cs:410 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-7b860fa0 | this.btnSet.Click 외 1 | FP00622_MeasureSetForm_Popup.cs:410 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-a5441357 | this.btnSet.Click 외 1 | FP00622_MeasureSetForm_Popup.cs:427 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9b942c8c | this.btnSet.Click 외 1 | FP00622_MeasureSetForm_Popup.cs:438 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-179f6f42 | .ctor | FP00622_PlanAmend_Line_NJ_Pouch.cs:195 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-e286f008 | .ctor | FP00622_PlanAmend_Line_NJ_Pouch.cs:196 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SELECT") ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == Spd…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9c35da9 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1094 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-06f18bd1 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1095 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-38e44c4d | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1096 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f3bee053 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1097 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-decfd68a | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1098 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8a483c49 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1099 |  | FLAG | dsBoh | null | 화면 필드/플래그 변경 |  |  |  |
| AC-21b0609e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1101 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-defae68e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1102 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1e338bdb | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1103 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-816f3928 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1104 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4218878e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1105 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f9c484d | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1106 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-5a069f6e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1107 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bc714320 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1108 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-16cf85fc | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1110 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_ListData_BOH", Filter["INSTANCE_ID"].ToString(), Filter["PL… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d0703707 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1112 |  | FLAG | dsBoh | dtBoh.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b9390e46 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1114 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_ListData", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6da6e185 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1116 |  | FLAG | dsListData | dtListData.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-880092e0 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1119 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00622_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-311fcd15 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1121 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-979d85d6 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1122 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c2ee336f | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1123 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33836186 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1124 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e7213c0f | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1137 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-b960ad6a | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1144 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca4594f5 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1145 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-caedbd79 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1146 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-66b28dfc | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1158 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-b0473cb5 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1159 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-30bea950 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1160 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-0a4720a7 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1161 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-0777ef6e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1162 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-4d93d2a0 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1163 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-20bf1f98 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1164 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.ApplyAmendCalendarCondition_ForExcel

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd8c1efe | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5817 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5ca1c5f9 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5818 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fa49536b | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5819 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6f568434 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5820 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b0c1affb | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5821 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-891995c4 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5822 |  | FLAG | dsBoh | null | 화면 필드/플래그 변경 |  |  |  |
| AC-065c8a0c | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5835 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f9df0eb | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5836 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-6724a641 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5837 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-29faa601 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5838 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-f219368c | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5839 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9a7b3f11 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5840 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-942fd39d | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5841 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5d78dee4 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5842 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1a5d7e21 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5844 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_ListData_BOH", Filter["INSTANCE_ID"].ToString(), Filter["PL… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3c4b635a | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5846 |  | FLAG | dsBoh | dtBoh.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b06d6966 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5848 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_ListData", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-04059852 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5850 |  | FLAG | dsListData | dtListData.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-bc5c33d5 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5853 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00622_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-908aa7ea | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5855 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-96163a26 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5856 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1111d313 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5857 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f1c4b66b | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5858 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-81d3c98e | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5859 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ed8d07d | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5860 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2721e491 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5861 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9bf13b76 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5864 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-5068b4f2 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5865 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-89ab6529 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5866 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-9d6776cc | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5867 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-cec4fcdb | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5868 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-893ca2b9 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5869 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-573d0f4e | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5870 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE")] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdShe…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c17ec5f | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1170 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; if (GetFilter("INSTANCE_ID") == "") … | ⚠ 의미 확인 필요 |  |  |  |
| AC-fbe65762 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1176 | lambda ▸ if (GetFilter("INSTANCE_ID") == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { SetFilter("INSTANCE_ID", CString.GetCheckedListValue(dtIn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-08b823e9 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1183 | lambda | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //set["USER_ID"] = "chkim.68"; Filter["PLAN_DATE"] = sCal… | ⚠ 의미 확인 필요 |  |  |  |
| AC-67167271 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1186 | lambda ▸ lambda | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-1de81ffd | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1187 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-3e0c0977 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1188 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-ffafb8b5 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1200 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-226b31d1 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1212 | lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["PLAN_ID"] = cbo_fpplanid.SelectedValue as string;… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b9f9829 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1214 | lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) ▸ lambda | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-1d49ea91 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1218 | lambda | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-2f6b7cff | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1219 | lambda | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_CELL_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-0f4347b3 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1220 | lambda | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R " | 행/컬럼 값 대입 |  |  |  |
| AC-3db98002 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1221 | lambda | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_CELL_BOR_R " | 행/컬럼 값 대입 |  |  |  |
| AC-2f0626d0 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1222 | lambda | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_CELL_UTIL_R " | 행/컬럼 값 대입 |  |  |  |
| AC-5f197895 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1226 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-9e5cbc49 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1227 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_CELL_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-1ee0c9ee | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1228 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H " | 행/컬럼 값 대입 |  |  |  |
| AC-352dfc63 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1229 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_CELL_BOR_H " | 행/컬럼 값 대입 |  |  |  |
| AC-748b104c | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1230 | lambda ▸ if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_CELL_UTIL_H " | 행/컬럼 값 대입 |  |  |  |
| AC-94530daf | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1233 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc6bc312 | this.btnBucket.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3000 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-63ef0037 | this.btnBucket.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3002 |  | POPUP | new FP00599_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-bc37b68d | this.btnBucket.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3003 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7e04cfc5 | this.btnBucket.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3004 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-8ec3f99b | this.btnBucket.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3005 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-40a160a7 | this.btnBucket.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3009 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-04976ec7 | this.btnBucket.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3018 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e839aa98 | this.btnBucket.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3020 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7b980f5e | this.btnBucket.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3023 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-232c2efa | this.btnBucket.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3032 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnCal_Click

진입점: this.btnCal.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eec25a3 | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3912 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ea4b584 | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3913 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72f5ad01 | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3919 | if (_sSaveAuth != "Y") | MESSAGE | MessageBox.Show | ("Save Authority not have.!") | 메시지 표시 |  |  |  |
| AC-aa8bf6d8 | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3920 | if (_sSaveAuth != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23e2d5ca | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3924 | if (Filter["PLAN_TYPE"].ToString() == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not be calculated.!") | 메시지 표시 |  |  |  |
| AC-94ccd22e | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3925 | if (Filter["PLAN_TYPE"].ToString() == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0e8c265 | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3930 |  | FLAG | dtSyncCal | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00622_find_SyncCalcul", Filter["… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-79923754 | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3930 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00622_find_SyncCalcul", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37aab44a | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3937 | if (dtSyncCal != null) ▸ if (dtSyncCal.Rows[0]["PSI_CAL_STATUS"].SafeString() == "Y") | MESSAGE | MessageBox.Show | ("Current Instance is running PSI Calculation.!") | 메시지 표시 |  |  |  |
| AC-0e7a94fd | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3938 | if (dtSyncCal != null) ▸ if (dtSyncCal.Rows[0]["PSI_CAL_STATUS"].SafeString() == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83712f95 | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3943 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "FP Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4141d565 | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3944 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-435f532c | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3947 |  | MESSAGE | MessageBox.Show | ("do you Excution?", "Excute", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-766a079a | this.btnCal.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3954 | if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.OK) == DialogResult.OK) ▸ if (bRtn1 && bRtn2) | MESSAGE | MessageBox.Show | ("PSI Calculation Excution Completed.!") | 메시지 표시 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eff2c77b | this.btnCatagory.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2957 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-3d21ccd9 | this.btnCatagory.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2959 |  | POPUP | new FP00622_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-b5f8f729 | this.btnCatagory.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2960 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-ed4ec1bc | this.btnCatagory.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2961 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9a9e6245 | this.btnCatagory.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2962 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-909c615e | this.btnCatagory.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2966 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-a373da3b | this.btnCatagory.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2975 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7cc419fe | this.btnCatagory.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2977 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-47e66c81 | this.btnCatagory.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2980 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0d2e63ba | this.btnCatagory.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2989 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8af70deb | this.btnColumn.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2930 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-4592469e | this.btnColumn.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2932 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-300b6933 | this.btnColumn.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2933 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-edcebd01 | this.btnColumn.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2934 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-16f6291a | this.btnColumn.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2940 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-47875e02 | this.btnColumn.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2940 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8f02595 | this.btnColumn.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2941 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-198ddce1 | this.btnColumn.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:2947 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnCreatePlan_Click

진입점: this.btnCreatePlan2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c640f80 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3135 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-a66fdf05 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3136 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-f6430b3f | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3144 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e53e3e30 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3145 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17fbdbd9 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3155 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-09761758 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3157 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c1576a12 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3163 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1ae357a7 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3164 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd470817 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3169 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0d98961 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3170 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2f7daf48 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3173 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-15ea5d29 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3174 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-715ee6a6 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3175 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ac2f592 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3181 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a243a726 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3184 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-28dba295 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3185 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-66af8d32 | this.btnCreatePlan2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3186 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnDppWppCopyDwSubmit_Click

진입점: this.btnDppWppCopyDwSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1076141 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3644 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-58eecc9c | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3645 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-236f4923 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3653 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-86171cd4 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3654 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-892735d0 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3658 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5f555623 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3664 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-0046762e | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3665 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5344cdea | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3672 | if (string.IsNullOrEmpty(Filter["PLAN_ID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c00a8959 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3673 | if (string.IsNullOrEmpty(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-217615a3 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3679 | if (Filter["PLAN_TYPE"].ToString() != "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-abcb1a09 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3680 | if (Filter["PLAN_TYPE"].ToString() != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b06c270 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3683 |  | POPUP | new FPC0125_MWPPCopyDWSubmitPopup | () | 팝업/폼 생성 |  |  |  |
| AC-47c8e0cd | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3684 |  | UI_PROP | CopySubmit.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-f07b37ba | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3684 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-efadea1e | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3685 |  | DATA_OP | CopySubmit.Filter["SUBMIT_TYPE"] | "CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-e14ee72a | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3686 |  | DATA_OP | CopySubmit.Filter["MASTER_ID"] | CopySubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1b209c3b | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3686 |  | DATA_OP | CopySubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c5d762aa | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3687 |  | DATA_OP | CopySubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-b1714703 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3688 |  | DATA_OP | CopySubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-6139dc9a | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3689 |  | DATA_OP | CopySubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8c7b733d | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3690 |  | DATA_OP | CopySubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-3ab424eb | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3691 |  | DATA_OP | CopySubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-71588a1e | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3692 |  | DATA_OP | CopySubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-36107c0e | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3693 |  | DATA_OP | CopySubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-62726b38 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3694 |  | DATA_OP | CopySubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-11292551 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3695 |  | DATA_OP | CopySubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-61304416 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3697 |  | UI_PROP | CopySubmit.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-56d3c4f4 | this.btnDppWppCopyDwSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3698 |  | POPUP | CopySubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnDWSubmit_Click

진입점: this.btnDWSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f988cdbf | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3577 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-b4359988 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3578 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-dc8c7f86 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3586 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7e702b3a | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3587 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20616721 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3591 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-92396dc7 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3597 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-2fa583de | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3598 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3613cb8f | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3605 | if (string.IsNullOrEmpty(Filter["PLAN_ID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fbb2574a | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3606 | if (string.IsNullOrEmpty(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6435295c | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3612 | if (Filter["PLAN_TYPE"].ToString() != "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e772be6 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3613 | if (Filter["PLAN_TYPE"].ToString() != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2474836e | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3617 |  | DATA_OP | DwSubmit.Filter["SUBMIT_TYPE"] | "CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-5af953c2 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3618 |  | DATA_OP | DwSubmit.Filter["MASTER_ID"] | DwSubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b886e45c | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3618 |  | DATA_OP | DwSubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1b48d44a | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3619 |  | DATA_OP | DwSubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-4967fd58 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3620 |  | DATA_OP | DwSubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-bcc9fa15 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3621 |  | DATA_OP | DwSubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fe2f6ea6 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3622 |  | DATA_OP | DwSubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7e1abcf1 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3623 |  | DATA_OP | DwSubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-750b3d00 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3624 |  | DATA_OP | DwSubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1ff73f08 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3625 |  | DATA_OP | DwSubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c3c72133 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3626 |  | DATA_OP | DwSubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-882b05ca | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3627 |  | DATA_OP | DwSubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-137ec74a | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3628 |  | DATA_OP | DwSubmit.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4cbee53f | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3629 |  | DATA_OP | DwSubmit.Filter["CONFIRM_TYPE"] | DwSubmit.Filter["CONFIRM_AREA"] = Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-c6496ec7 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3629 |  | DATA_OP | DwSubmit.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-186342fb | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3631 |  | UI_PROP | DwSubmit.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5a52df12 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3632 |  | POPUP | DwSubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8b2877c7 | this.btnDWSubmit.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3635 | if (DwSubmit.ShowDialog() == DialogResult.OK) | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-212e20b0 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3717 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4353eab9 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3718 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52781ded | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3724 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-42e232cb | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3725 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e8cd6c53 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3736 | if (sPlanIDTag == "99" \|\| sPlanIDTag == "98") | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-5bbe6117 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3740 | else of (sPlanIDTag == "99" \|\| sPlanIDTag == "98") | DATA_OP | Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ea28aab7 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3749 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-e8f0c2de | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3752 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-9bbc6bf7 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3753 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-52a68527 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3754 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-79fbc788 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3756 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-df720ad2 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3763 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP00594_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-8f74fa97 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3765 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-66bd48b2 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3765 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-62b405b5 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3768 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.CELL | 속성 DateColumnType 설정 |  |  |  |
| AC-7fa60fa8 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3770 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-22d7010d | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3771 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a1839bb2 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3772 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b0b31ddf | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3773 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["TOP_ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-005e0189 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3774 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d319ba73 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3775 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8bf03a95 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3776 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-26e59468 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3777 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LOCATION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2b242b67 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3778 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-aecafd28 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3779 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c561ca89 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3780 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c1708688 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3781 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7db47471 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3782 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9e326594 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3787 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-1cec0ddd | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3788 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-3cfa9534 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3789 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-a6b33d5f | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3790 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["TOP_ITEM_ID"] | "Model" | 행/컬럼 값 대입 |  |  |  |
| AC-2ba4e21c | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3791 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-d3779216 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3793 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-02f8208c | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3794 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-173bed03 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3795 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["VERSION"] | "Version" | 행/컬럼 값 대입 |  |  |  |
| AC-d403570a | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3797 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-0ccacb18 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3798 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-a4eca343 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3799 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-cf4aaa2e | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3800 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-3aada952 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3801 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-8a4d270c | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3802 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-46a61f87 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3803 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-03cde769 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3804 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-cfcc24e2 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3809 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnSearchData | ExcelPopup_Search_Column | 속성 OnSearchData 설정 |  |  |  |
| AC-af096a81 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3810 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Column | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-1b03263e | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3811 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Column | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-6b0d28c7 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3812 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-1dca842a | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3813 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | FP00599_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-55892b78 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3817 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | colPopup._PlanDate | Filter["CURR_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-19f81c8c | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3821 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | colPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-4fcc6cf2 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3824 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a60ca59b | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3830 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP00594_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-f5ae8ba7 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3832 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6f9774a0 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3832 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f474c427 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3836 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0c112cf1 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3837 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-769d4658 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3838 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7241e52c | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3839 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["TOP_ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f7d1ef94 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3840 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d553b3be | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3841 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-23cc5cf8 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3842 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-44111593 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3843 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2b58384a | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3844 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LOCATION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-900a457a | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3845 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b14ce74d | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3846 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-dfbd0d0a | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3847 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4c9cfe78 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3848 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e75a0e39 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3849 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8ff888c5 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3850 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-193aa4c5 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3853 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-749b35ba | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3854 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-e2411c36 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3855 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-56910a99 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3856 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["TOP_ITEM_ID"] | "Model" | 행/컬럼 값 대입 |  |  |  |
| AC-d29e2330 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3857 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-97de9218 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3859 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-752625ee | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3860 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-5804dd53 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3861 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["VERSION"] | "Version" | 행/컬럼 값 대입 |  |  |  |
| AC-7bb8793c | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3863 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-dce5731b | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3864 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-912ad9a9 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3865 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-5d5ddc7f | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3866 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-d3a466ef | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3867 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-57118ac2 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3868 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "LIne" | 행/컬럼 값 대입 |  |  |  |
| AC-35a3e1b8 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3869 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "LIne Name" | 행/컬럼 값 대입 |  |  |  |
| AC-13c8b942 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3870 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-fbe23da2 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3871 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-62c96b86 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3872 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["QTY"] | "QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-a1f6f0f9 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3873 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-2e95b06c | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3877 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnSearchData | ExcelPopup_Search_Row | 속성 OnSearchData 설정 |  |  |  |
| AC-1d6440e1 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3878 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnExcelSaveData | ExcelPopup_SaveExcel_Row | 속성 OnExcelSaveData 설정 |  |  |  |
| AC-8404ae51 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3879 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnValidationSaveData | ExcelPopup_BufferValidation_Row | 속성 OnValidationSaveData 설정 |  |  |  |
| AC-872dec18 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3880 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.OnBeforeCheckData | ExcelPopup_CheckBeforSave | 속성 OnBeforeCheckData 설정 |  |  |  |
| AC-11e112c1 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3884 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | rowPopup._PlanDate | Filter["CURR_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-7717b3a4 | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3888 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | rowPopup._PlanDate | Filter["PLAN_DATE"] | 속성 _PlanDate 설정 |  |  |  |
| AC-5ab0d9ca | this.btnExcelImport.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3891 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7b3d2db | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3471 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-928f6c0d | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3472 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-4fdceb63 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3480 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fb89a0b9 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3481 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7aa4871 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3487 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-cf7893e8 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3488 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf41ac35 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3491 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c92c72f1 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3492 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-89332ade | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3493 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6e753b7f | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3493 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fa6f455d | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3494 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-9e01fca4 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3495 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-90c5bf7c | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3496 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-795fb43b | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3496 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3beaf098 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3497 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-42b4c228 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3498 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-250947e4 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3499 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2eb27ce8 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3500 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-74bfdad9 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3501 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-94bea141 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3502 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d3f77f10 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3503 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ffba4902 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3504 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e2f7a0c0 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3505 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0f2b7823 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3507 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-800e02d5 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3508 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-671102d7 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3509 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-f58f03f3 | this.btnMemo.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3510 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnMenu_Click

진입점: this.btnMenu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc10aa03 | this.btnMenu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3901 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnMenu, menuPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-98e3b4c0 | this.btnMenu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3901 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnMRP_Click

진입점: this.btnMRP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1f3b21f | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3083 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-46b1e3ef | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3084 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-5b10e87c | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3092 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-89702fb8 | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3093 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c31f0f92 | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3098 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8a168f5c | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3103 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-78cc1f2b | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3104 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81c8ea14 | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3110 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-22a656b3 | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3111 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f72d976b | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3116 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-8acef0a1 | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3117 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-238c1bd9 | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3121 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-f85cc27b | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3122 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a6e3100 | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3123 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-df1a4f8c | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3125 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-0b75bd04 | this.btnMRP.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3127 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnPSICalculation_Click

진입점: this.btnPSICalculation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a6425a1 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3330 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-303e4c4b | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3331 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-cc8d51a2 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3339 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-678ed5c0 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3340 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b657fbd2 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3344 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-edf1b65e | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3350 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-417ace8e | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3351 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39a71412 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3355 |  | MESSAGE | MessageBox.Show | ("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-0a8d39d3 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3361 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (Filter["PLAN_… | MESSAGE | MessageBox.Show | ("Release plan can not be calculated.!") | 메시지 표시 |  |  |  |
| AC-06ba8df9 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3362 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (Filter["PLAN_… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a7564b2 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3366 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) | FLAG | dtSyncCalculation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_find_SyncCalcul", Filter["… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-0030798e | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3366 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_SyncCalcul", Filter["INSTANCE_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1be9a3b9 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3372 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtSyncCalcula… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "there is running PSI calculation." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9eaa5624 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3373 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtSyncCalcula… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8adcc022 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3382 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (Filter["PLAN_… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "FP Plan ID is null." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-058e7331 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3383 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (Filter["PLAN_… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6275d50 | this.btnPSICalculation.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3391 | if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (bRtn1 && bRtn… | MESSAGE | MessageBox.Show | ("PSI Calculation Excution Completed.!") | 메시지 표시 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnRelease_Click

진입점: this.btnRelease2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04c092e7 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3202 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-b0053f0d | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3203 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-bb8ab20c | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3211 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7677e28a | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3212 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12f55449 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3232 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c108b3c | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3233 | if (string.IsNullOrEmpty(sPlanID) \|\| sPlanIDTag == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa5476a6 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3236 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_instanceInfo", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-88aa958b | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3237 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_planInfo", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2cef5e20 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3241 | if (dtPlanInfo != null) | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d28e430 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3248 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-82a3908a | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3252 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fc910967 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3253 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3613dbcb | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3260 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1395db94 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3261 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d06ec48 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3266 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-474a4ceb | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3269 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-18a570ab | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3271 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e075fe4d | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3277 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62f92db6 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3278 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-079290ff | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3291 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3465c5bd | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3292 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d166a1e0 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3304 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-cdeeaf47 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3307 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-2746f370 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3308 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a341d577 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3309 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ce8d84bc | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3317 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-53d30fe2 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3320 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-05ae51ba | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3321 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a0490571 | this.btnRelease2.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3322 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.Show | () | 팝업/폼 열기 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b8a1b11 | this.btnSql.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3965 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-2d475866 | this.btnSql.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3968 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-10d79774 | this.btnSql.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3969 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-82f88d17 | this.btnSql.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3971 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00622_AMEND_LINE_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c295a21 | this.btnSql.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3972 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00622_AMEND_LINE_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b3ef541 | this.btnSql.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3973 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00594_EXCEL_SELECT_COLTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-46b48476 | this.btnSql.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3974 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ada8a107 | this.btnSql.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3975 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnSSP_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66392ff0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3047 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_chk", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-01fea04e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3052 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-8ebba5c5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3053 | if (dtAuthChk.Rows.Count > 0) ▸ if (!dtAuthChk.Rows[0]["AUTH_YN"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c359ef6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3059 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-1c5c74cf | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3060 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3760429a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3065 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-c1d3ef53 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3066 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f46b8dd | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3070 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-45b64f96 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3071 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-166afe80 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3072 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b3147479 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3073 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_SSP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_SSP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-e96e826a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:3075 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-625edba1 | this.btnToggleSave.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3041 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.btnWOWStatus_Click

진입점: this.btnWOWStatus.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-978f2541 | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3401 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-0f4814ca | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3402 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-8f4b374c | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3410 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f3c81ce | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3411 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e077bbb | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3427 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_find_instanceInfo", pInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4dd9d434 | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3433 | if (!sWoWStatus.Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8a7cee6 | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3436 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findInstance", pSite, "INSTANCE_ID") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5235a338 | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3438 |  | DATA_OP | dtLocalPlanGroup.Select | (string.Format("CODE = '{0}'", pInstance)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d27e9c5 | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3440 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-78db8cb0 | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3452 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-c3c64350 | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3455 | try | POPUP | new FP00590_WoWStatusPopup | (pSite, pInstance, pPlanDate, pPlanID, sIsSamePlanID, sConfirmArea, sWoWStatus) | 팝업/폼 생성 |  |  |  |
| AC-0117fef2 | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3456 | try | UI_PROP | popWowStatus.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-addb192a | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3457 | try | POPUP | popWowStatus.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6f774261 | this.btnWOWStatus.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3463 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26781b43 | this.button1.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:3706 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.cbo_fpplanid_changed

진입점: this.Load [try] / cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8683ff0 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2781 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[selected]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-157a7dfb | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2782 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[selected]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-351936e7 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2783 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[selected]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-8602cf25 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2784 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[selected]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-e360a7de | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2785 | if (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[selected]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-ef33e85a | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2787 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-33493b74 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2788 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-597a3cab | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2789 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-b7d9deaa | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2790 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-eb968b1e | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2791 | if (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-e366fb61 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2795 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-ea815d5f | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2796 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-cb1e0cdd | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2797 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-2895e614 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2798 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-992a8173 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2799 | else of (cbo_fpplanid.Items.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-6fdda5a1 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2801 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-6baa4d96 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2802 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-d4c59f72 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2803 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-4d2bdf30 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2804 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-60fc9013 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2805 | else of (cbo_fpplanid.Items.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44bd8eef | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:1721 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-67f000bd | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:1721 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.chk_Info_CheckedChanged

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-600530be | this.chk_Info.CheckedChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:7292 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-26635c7c | this.chk_Info.CheckedChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:7292 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b07e525 | this.chk_Info.CheckedChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:7298 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-f5486093 | this.chk_Info.CheckedChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:7299 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.CreateEditBOHDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d67eeade | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5646 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-f825500a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5647 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee427719 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5648 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea7deb0f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5649 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b37f419 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5650 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b6c1fbd | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5651 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4f787ea | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5652 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b51a7a91 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5653 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a7a2dc9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5654 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-843e576d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5655 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5263f15f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5656 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f48f7feb | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5657 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c8ee3f6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5658 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-901cee98 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5659 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e71ba2aa | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5660 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a9ec527 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5661 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ACTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1fc20a5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5663 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.CreateEditDataGridDataSet

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…) ▸ if (dsMainFiltered.Good()) ▸ if (dt == null)] / this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (dsMainFi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ae2cac5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5669 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-0af5d026 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5670 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d54362b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5671 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-18d6b7dd | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5672 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f334a555 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5673 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9b38ce0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5674 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a56347e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5675 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3b5cc76 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5676 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-48236baf | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5677 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-648a083e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5678 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-032edf66 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5679 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ced2338 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5680 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-303f9af7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5681 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-82ea3643 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5682 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-540f26fb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5683 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d631c25 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5684 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa18a2f7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5685 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f15f1bb6 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5686 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-515ab0ce | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5687 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-671352a0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5688 |  | DATA_OP | dt.Columns.Add | (new DataColumn("P_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae4873ca | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5689 |  | DATA_OP | dt.Columns.Add | (new DataColumn("P_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-64cb43fb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5690 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MPP_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1c65217 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5691 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-08d02c69 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5692 |  | DATA_OP | dt.Columns.Add | (new DataColumn("WPP_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-964ba1ec | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5693 |  | DATA_OP | dt.Columns.Add | (new DataColumn("WPP_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-17faae3c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5694 |  | DATA_OP | dt.Columns.Add | (new DataColumn("BOH_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3b707d6 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5695 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SALES_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb8b7b2a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5696 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EOH_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddacb001 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5697 |  | DATA_OP | dt.Columns.Add | (new DataColumn("YIELD", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2318da7c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5699 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLM_EC_NO", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e769656 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5700 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-56411489 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5702 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9356671d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5703 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-51a86322 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5705 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-30141257 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5707 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.CreateExelBufferDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c45b45e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5877 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-dc052815 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5878 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-27286d6c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5879 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a657b83 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5880 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d899ede8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5881 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-38277e28 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5882 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e2e2ae4 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5883 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4090e7ce | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5884 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e312c164 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5885 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-11276881 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5886 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc60beb0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5887 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f063b8b6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5888 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-09963ba5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5889 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b18dabf9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5890 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-47a9c610 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5891 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fbdcc16 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5892 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9eaead09 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5893 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddbc40e6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5894 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd3ae7bf | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5895 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CELL_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a3f9b85 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5896 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1561754b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5897 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-537eb062 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5898 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JOB_ORDER", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-945eb7da | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5899 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MPP_WPP", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-408cfd80 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5900 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLM_EC_NO", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0460c8c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5901 |  | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-876351a7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5903 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eae658dd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1788 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-93d58e33 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1800 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-ea6d6ad2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1801 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-0f85c5bf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1822 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-748ea7db | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1823 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-15c8dbff | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1828 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6ff4b5d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1829 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-13346457 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1835 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e112875 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1836 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c1ce07a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1841 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aeba0f1d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1842 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-98e3f7af | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1848 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c3690d8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1849 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d855ca3d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1853 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3abd35eb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1854 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0624aba5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1859 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-07330335 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1860 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c60370b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1866 | if (measure["chk_engine_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_ENGINE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-75a9f9d8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1867 | if (measure["chk_engine_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_ENGINE_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a936fe7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1872 | if (measure["chk_engine_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_ENGINE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-da45ac9e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1873 | if (measure["chk_engine_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_ENGINE_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbc10414 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1878 | if (measure["chk_target"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "TARGET")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1af6e645 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1883 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", MEMO_COLUMN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-37a62d89 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1891 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_memo_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL",MEMO_COLUMN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-35a96551 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1895 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-490820f0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1896 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-59193996 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1901 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-052c9b13 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1902 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9370edb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1908 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9aec8630 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1909 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aaa0487e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1914 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5707f706 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1915 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f6e058b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1921 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-240e18c6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1922 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2e1bbfd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1927 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3385e58 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1928 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f57743bf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1933 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ada20b5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1934 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d870970e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1940 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_engine_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_ENGINE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4e9c887 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1941 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_engine_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_ENGINE_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f9ddbee | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1946 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_engine_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_ENGINE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab03cd4f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1947 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_engine_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_ENGINE_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7b46532 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1952 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_target_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TARGET")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac188508 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1957 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_off"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "OFF")) | 데이터 객체 조작/조회 |  |  |  |
| AC-991b7d32 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1961 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_setup"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SETUP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c33b042 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1965 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_capa"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "CAPA")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1852c64e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1974 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fab3c3e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1975 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb8ce6c5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1980 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3561294a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1981 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-93df4552 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1987 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-30a70586 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1988 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea620df4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1993 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-82df82d3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1994 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1aae2349 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2000 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f12abaf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2001 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c81cd17 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2006 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd24f554 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2007 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-06cd3d49 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2012 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-76406dad | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2013 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "RESULT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb1a0517 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2019 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_engine_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_ENGINE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb55bf00 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2020 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_engine_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_ENGINE_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-216205df | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2025 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_engine_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_ENGINE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-800ca10c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2026 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_engine_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_ENGINE_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-daf101d0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2031 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_target_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "TARGET")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ee0aa20 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2041 | if (measure["chk_uom"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("MEASURE_ID", "UOM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3967812f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2051 | if (measure["chk_cell"].Value != "true") | DATA_OP | un_chks_measure.Add | (new Tuple<string, string>("MEASURE_ID", "CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-de2db3a2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2061 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aeb60555 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2064 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-915f43f5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2068 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-0cd231f1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2073 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4bf640bd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2077 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-dac06b22 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2079 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a41db520 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:451 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-206f02de | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:452 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-a09dd2d9 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:453 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-609a5f54 | dCalendar_planrange.ValueChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:2892 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f97ca53 | dCalendar_planrange.ValueChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:2898 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-1c31f51b | dCalendar_planrange.ValueChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:2899 | if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Delete_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baf41740 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6925 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-be647b4d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6926 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cb91e81d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6929 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-6506ac45 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6930 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-8d5def3b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6931 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-904551f5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6932 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8c8950f4 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6933 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fd1f1f6f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6934 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e4a2cb77 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6935 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8961ee2a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6936 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bf9fa8e7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6937 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cdc4d2c2 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6938 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-505a5b33 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6939 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e37f7225 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6940 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3fa494be | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6941 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-edfaf1ec | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6942 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1c1b0998 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6943 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0b30d9f8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6944 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2256a515 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6945 | try | DATA_OP | request.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c1249f0b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6946 | try | DATA_OP | request.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-86ad0891 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6947 | try | DATA_OP | request.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3127b55f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6948 | try | DATA_OP | request.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-18827e84 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6949 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0eda9029 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6950 | try | DATA_OP | request.Parameters["p_cell_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-19a09de7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6951 | try | DATA_OP | request.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-475ebd64 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6952 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-be542c7b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6953 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cd5c85bf | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6954 | try | DATA_OP | request.Parameters["p_new_seq_no"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c787cac6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6955 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1dc59704 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6957 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-61c1260d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6965 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-75e2e42c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6969 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-0173fae3 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6970 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d60ab7c4 | DeleteButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:866 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07bffe3f | Dispose | FP00622_PlanAmend_Line_NJ_Pouch.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.DrawHeader

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnDppWppCopyDwSubmit.Click [if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c3fb9dd | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1294 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-0167c1ca | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1298 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-c7f7a99b | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1299 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-017c45d9 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1300 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63023127 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1301 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0e5eb93 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1302 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-76d4fcac | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1306 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-7c9d54fb | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1307 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-9287f00c | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1308 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-ea1e9961 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1309 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-809fb00b | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1315 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-6bdbab44 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1316 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-90c987b6 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1349 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44b40983 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1354 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, FPExtensions.DateColumnT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1e0be35 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1356 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3837a2a4 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1357 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a56940c7 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1358 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-5cbde90c | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1360 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-dcb298ba | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1362 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-b371811b | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1363 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.DrawSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnDppWppCopyDwSubmit.Click [if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-307597aa | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1373 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-73d8b4db | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1375 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d77dec3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1383 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-312f2e14 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1392 | if (dsMainFiltered.Good()) | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.dwCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18456ef7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7265 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["DW_TABLE"] | "HIS_AMEND_PLAN_CELL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-47b44402 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7268 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_dwSubmit_check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-aa674952 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7272 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsTmp.Tables[0].Rows[0]["IS_SUBMIT"].ToString() == "Y") | STATE | txtReleaseAlert.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-39c7ccf9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7276 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (dsTmp.Tables[0].Rows[0]["IS_SUBMIT"].ToString() == "Y") | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-5b18d6f2 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7281 | else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ae4a41c | EditButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:874 | if (spdMain != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9978759a | ExcelButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:2670 |  | EXCEL | ExportExcel | (0,true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.ExcelPopup_BufferValidation_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91c11460 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6152 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_seq") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-585b2e87 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6156 | try ▸ if (dtSeq.Rows.Count > 0) | FLAG | _sNewSeqNo | dtSeq.Rows[0][0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b921329d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6163 | try ▸ else of (dtSeq.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d1e37c29 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6164 | try ▸ else of (dtSeq.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1c31b468 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6192 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-530815e2 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6195 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4a1450fc | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6196 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f2f4e405 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6197 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69696442 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6198 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6881df4b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6199 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5d967bc4 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6200 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef974f74 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6201 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-70077da1 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6202 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b0429e80 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6203 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b3fc5235 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6204 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0a257ecc | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6205 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b7cf8d62 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6206 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e9ebd765 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6207 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_TYPE"] | data.Tables[0].Rows[i]["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d28cde70 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6208 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-973663a0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6209 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b52a9593 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6210 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-941c631d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6211 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a2482b65 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6212 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["CELL_QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d9ae5bac | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6213 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b5415806 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6214 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["NEW_SEQ"] | Filter["NEW_SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e9bc56ca | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6215 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bf8226d5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6217 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLM_EC_NO"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-f67d9814 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6218 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["VERSION"] | data.Tables[0].Rows[i]["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8516d9c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6220 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-53f20e6f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6229 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a5fbdf0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6251 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-09e86ea3 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6256 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ef7cc3ba | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6258 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c780c46 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6261 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Coun… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-1b97601e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6269 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-37fadfb6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6294 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c522f34b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6297 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-684f2fa1 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6298 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | sDate.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9109ad8c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6299 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4246a27a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6300 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-436eb3f0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6301 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc6d3608 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6302 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6cb37a0b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6303 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-722e0a92 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6304 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-46dcf6f2 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6305 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7ac94ef6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6306 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3107141 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6307 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bda06753 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6308 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-15180637 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6309 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_TYPE"] | data.Tables[0].Rows[i]["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1d17da03 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6310 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ce7039b7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6311 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2aa8a0e6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6312 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dabc33ba | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6313 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-389d8603 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6314 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["CELL_QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c83cd46d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6315 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i][sDateCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6409ef65 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6316 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["NEW_SEQ"] | Filter["NEW_SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f9429938 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6317 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["PLM_EC_NO"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-774f47fc | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6318 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["VERSION"] | data.Tables[0].Rows[i]["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-20b4f03e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6319 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4d34ee39 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6323 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ for (i < data.Tables[0].Rows.Count) ▸ for (j < dateMap.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9c33d2a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6332 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-90ffb743 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6355 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a012cf5c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6360 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-26dc88c2 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6362 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf608a95 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6365 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-f68c3802 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6373 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8fbd2010 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6378 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-d8abd139 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6383 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57d9b4b4 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6384 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.ExcelPopup_BufferValidation_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4d84917 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6405 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_save_seq") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a2e62528 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6409 | try ▸ if (dtSeq.Rows.Count > 0) | FLAG | _sNewSeqNo | dtSeq.Rows[0][0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b1194189 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6416 | try ▸ else of (dtSeq.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3cae4c07 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6417 | try ▸ else of (dtSeq.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6838e690 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6436 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-236d349f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6439 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6567893b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6440 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_DATE"] | data.Tables[0].Rows[i]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-70537166 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6441 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bb8c188a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6442 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | Filter["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eaee361e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6443 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3cb78e80 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6444 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-46c39e0b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6445 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c9c72ac | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6446 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-999eff36 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6447 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd5aaeef | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6448 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7828b951 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6449 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["TOP_ITEM_ID"] | data.Tables[0].Rows[i]["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-805b6cac | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6450 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-583d5c55 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6451 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_TYPE"] | data.Tables[0].Rows[i]["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-40c6a14a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6452 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-201b9cff | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6453 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LOCATION"] | data.Tables[0].Rows[i]["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-70673534 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6454 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8b19190 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6455 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ELECTRODE_TYPE"] | data.Tables[0].Rows[i]["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-32d73349 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6456 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["CELL_QTY"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-62529ec9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6457 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["QTY"] | data.Tables[0].Rows[i]["QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8cf0b62 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6458 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLM_EC_NO"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-be8a1834 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6459 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["VERSION"] | data.Tables[0].Rows[i]["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b002441a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6460 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["NEW_SEQ"] | Filter["NEW_SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dacc85fd | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6461 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["JOB_ORDER"] | (m++).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8fbcaa40 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6465 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-968e520d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6468 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c8c5102 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6502 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ lambda | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2e5cfd56 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6507 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4ee8cb33 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6509 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8b92afd | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6512 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (bResult) ▸ if (dsValidation.Tables[0].Rows.Count > 0) ▸ if (result.Count() > 0) ▸ if (d… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-43b7b8ae | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6520 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (bResult) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-25f87be5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6525 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-7787662f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6530 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3da586b8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6531 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.ExcelPopup_CheckBeforSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af977452 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5916 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe4d7b84 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5923 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek != null) ▸ if (dtIsCurrWeek.Rows.Count > 0) | DATA_OP | Filter["RELEASE_VALUE"] | dtIsCurrWeek.Rows[0]["RELEASE_VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1ffe97d8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5931 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek != null) ▸ if (dtIsCurrWeek.Rows.Count > 0) ▸ if (dtIsCurrWeek.Rows[0]["IS_LA… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1b997c43 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5933 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek != null) ▸ if (dtIsCurrWeek.Rows.Count > 0) ▸ if (dtIsCurrWeek.Rows[0]["IS_LA… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5bd574f9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5944 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_AMend_Save_Check", Filter["INSTANCE_ID"].ToString(), Filter["PLAN_I… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8f18adee | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5949 | try ▸ if (dtChk.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-bfbc7c67 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5950 | try ▸ if (dtChk.Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-cfd67ead | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5953 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-bfb408fc | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5957 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.ExcelPopup_SaveExcel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af791717 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6778 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.ExcelPopup_SaveExcel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3ccabb1 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6856 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.ExcelPopup_Search_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-713446d4 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5972 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-73bb2aa4 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5973 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-3a4ddf58 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5988 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-0052a32c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5989 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-d7da16f2 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5990 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-c2e8c18b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5992 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-f9e9c4ba | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6004 | if (popup != null) ▸ if (dsData != null && dsData.Tables != null && dsData.Tables.Count > 0) | CALL_EXT | dsData.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "ITEM_TYPE", "NICK_NAME",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fcb926f5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6006 | if (popup != null) ▸ if (dsData != null && dsData.Tables != null && dsData.Tables.Count > 0) | CALL_EXT | dsData.Tables[0].RemoveColumnsEndsWith | ("_QTY") | ⚠ 의미 확인 필요 |  |  |  |
| AC-40c0e348 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6009 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-2127b6a8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6011 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.ExcelPopup_Search_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d37bed02 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6021 |  | DATA_OP | Filter["BUCKET_FROM"] | popup._BucketFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-c8eecb41 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6022 |  | DATA_OP | Filter["BUCKET_TO"] | popup._BucketToDate | 행/컬럼 값 대입 |  |  |  |
| AC-cc54c3ca | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6027 | if (filter["MPP_WPP"].ToString() == "WPP") | DATA_OP | Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8a60c84a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6029 | else of (filter["MPP_WPP"].ToString() == "WPP") | DATA_OP | Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5cef5587 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6044 | if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-48c00956 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6045 | if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-ed089c19 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6046 | if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-9b3c363e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6048 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-2539caf0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6061 | if (popup != null) ▸ if (dsData != null && dsData.Tables != null && dsData.Tables.Count > 0) | CALL_EXT | dsData.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "NICK_NAME", "ITEM_TYPE",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-11049e8a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6065 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-760b6eb7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6067 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Exec_Procedure

진입점: this.btnCal.Click [if (MessageBox.Show("do you Excution?", "Excute", MessageBoxButtons.OK) == DialogResult.OK)] / this.btnPSICalculation.Click [if (MessageBox.Show("Do you want to run the PSI Calculation?", "Excution", MessageBoxButtons.YesNo) == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08c25bc6 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2618 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-2a684ed0 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2619 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a72fc61b | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2621 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-23b16532 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2622 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-083e0d9b | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2623 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-03f03d0d | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2624 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a494da16 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2625 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-21d8b004 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2626 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-83280767 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2627 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-fe0d9d81 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2628 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d7be26c1 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2629 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-44a1f8fe | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2630 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6f590a59 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2631 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-882c2f48 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2632 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-abafb1d7 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2633 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c877141b | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2634 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5d5f0c81 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2635 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-68228fa7 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2636 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fe17e225 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2637 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-26ee329d | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2638 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-055500d5 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2639 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f94d75e3 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2640 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5f3fecab | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2641 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-13fd0fba | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2642 | try | DATA_OP | req.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dbf90d96 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2643 | try | DATA_OP | req.Parameters["p_p_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-36275d16 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2644 | try | DATA_OP | req.Parameters["p_p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c7aa8b3e | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2645 | try | DATA_OP | req.Parameters["p_mpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8aee247e | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2646 | try | DATA_OP | req.Parameters["p_mpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a0a4e423 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2647 | try | DATA_OP | req.Parameters["p_wpp_in_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7f0b6dd7 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2648 | try | DATA_OP | req.Parameters["p_wpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2abcb9a4 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2649 | try | DATA_OP | req.Parameters["p_boh_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d4475353 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2650 | try | DATA_OP | req.Parameters["p_plm_ec_no"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-55a9035b | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2651 | try | DATA_OP | req.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0b862358 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2653 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c51efbe2 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2660 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-69f00a11 | this.btnCal.Click [if (MessageBox.Show("do you Excution?", "… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2664 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SELECT")] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmend…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-563a233e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:977 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_YieldInfo", Filter["DIVISION_ID"] , Filter["SITE_ID"], Filt… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33d9a999 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:981 | try ▸ if (oYieldChild.Rows.Count > 0) | FLAG | dsYieldChild | oYieldChild.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ff245fe0 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:987 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_AMEND_LINE") ⇒ FP_Planning.PR_UI_FP00622_AMEND_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-0495c30c | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:988 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2ac3fc7e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:989 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-c7a0cfd4 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:990 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-f1d427fa | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:991 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bf80fbdc | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:992 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-aeb44b91 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:994 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-169b7495 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:995 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7ac80893 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:996 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c2c012a5 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:997 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-baa917ab | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:998 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-85fb785b | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:999 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e57f018b | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1000 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1de99cf6 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1001 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a5d94553 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1002 | try | DATA_OP | request.Parameters["p_master_id"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-739e680e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1003 | try | DATA_OP | request.Parameters["p_plan_date"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f1dd19dc | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1004 | try | DATA_OP | request.Parameters["p_plan_id"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-13589258 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1005 | try | DATA_OP | request.Parameters["p_plan_type"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-639835d0 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1006 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ea63ff55 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1007 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4f157785 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1008 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-b11ecf07 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1009 | try | DATA_OP | request.Parameters["p_nick_name_lt"] | Filter["NICK_NAME_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-28b6e490 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1010 | try | DATA_OP | request.Parameters["p_top_item_id"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-eba4b5c0 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1011 | try | DATA_OP | request.Parameters["p_bucket_from_date"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-a9b39b86 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1012 | try | DATA_OP | request.Parameters["p_bucket_to_date"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-c621e222 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1013 | try | DATA_OP | request.Parameters["p_day_info"] | Filter["DAY_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-80e9bdf4 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1014 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["WEEK_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-47abeda0 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1015 | try | DATA_OP | request.Parameters["p_month_info"] | Filter["MONTH_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-c2dc976d | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1016 | try | DATA_OP | request.Parameters["p_cate_info"] | Filter["CATE_INFO"] | 행/컬럼 값 대입 |  |  |  |
| AC-c06cb629 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1017 | try | DATA_OP | request.Parameters["p_cate_value"] | Filter["CATE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-feb65fbe | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1018 | try | DATA_OP | request.Parameters["p_cate_type"] | Filter["CATE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c80daa61 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1019 | try | DATA_OP | request.Parameters["p_amend_table"] | Filter["AMEND_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6f10246a | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1020 | try | DATA_OP | request.Parameters["p_amend_cutoff_boh_table"] | Filter["AMEND_CUTOFF_BOH_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-72826a9b | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1021 | try | DATA_OP | request.Parameters["p_amend_bor_table"] | Filter["AMEND_BOR_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6c47e2dc | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1022 | try | DATA_OP | request.Parameters["p_amend_sales_table"] | Filter["AMEND_SALES_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f17f1712 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1023 | try | DATA_OP | request.Parameters["p_amend_util_table"] | Filter["AMEND_UTIL_TABLE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f470559f | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1025 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dc57cbf5 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1026 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-39098ac0 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SEL… 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1031 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Find_Data_Excel_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-222c30ac | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6714 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-b89b2617 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6715 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-32c96d72 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6717 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-645df2ec | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6718 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c8421ecc | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6719 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-e654588d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6720 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7d8c1700 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6721 | try | DATA_OP | request.Parameters["p_instance_id"] | sInstance | 행/컬럼 값 대입 |  |  |  |
| AC-8cb0db71 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6722 | try | DATA_OP | request.Parameters["p_plan_date"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-22dbfecd | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6723 | try | DATA_OP | request.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-f65e6656 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6724 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dc56a193 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6725 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a2032f38 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6726 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f8587126 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6727 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c83aa06f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6728 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-57dfe110 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6729 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fb1fc051 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6730 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9baad66c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6731 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-98ba1eeb | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6732 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a96f6a50 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6733 | try | DATA_OP | request.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-22f35874 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6734 | try | DATA_OP | request.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d1176fce | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6735 | try | DATA_OP | request.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bb6327a7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6736 | try | DATA_OP | request.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a70a6264 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6737 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6947960b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6738 | try | DATA_OP | request.Parameters["p_cell_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f1373983 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6739 | try | DATA_OP | request.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8b5c1563 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6740 | try | DATA_OP | request.Parameters["p_confirm_area"] | sConfirmArea | 행/컬럼 값 대입 |  |  |  |
| AC-062db7c3 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6741 | try | DATA_OP | request.Parameters["p_release_value"] | sReleaseValue | 행/컬럼 값 대입 |  |  |  |
| AC-5e1e458f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6742 | try | DATA_OP | request.Parameters["p_new_seq_no"] | sNewSeqNo | 행/컬럼 값 대입 |  |  |  |
| AC-44e60299 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6743 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f95bbd36 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6746 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5b202865 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6748 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-30815361 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6753 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Find_Data_Excel_Import

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0a508f9 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6083 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL | 엔드포인트 요청 생성 |  |  |  |
| AC-7b9470df | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6084 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b38136af | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6086 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-44a45f3f | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6087 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9376097d | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6088 | try | DATA_OP | request.Parameters["p_sys_gubun"] | gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5975fe05 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6089 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ee0c245f | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6090 | try | DATA_OP | request.Parameters["p_proc_name"] | procedure_name.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-9aae8c29 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6099 | try ▸ if (dsParameter != null && dsParameter.Rows != null && dsParameter.Rows.Count > 0) | CALL_EXT | param.Keys | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-aca5d8fe | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6113 | try | DATA_OP | request.Parameters["in_columns"] | keys | 행/컬럼 값 대입 |  |  |  |
| AC-a2a63751 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6114 | try | DATA_OP | request.Parameters["in_row"] | values | 행/컬럼 값 대입 |  |  |  |
| AC-6fd8e2aa | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6115 | try | DATA_OP | request.Parameters["opt_none"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d8b8157 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6117 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d10e3f6 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6119 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-53d054d8 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6124 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-9567b69a | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:6126 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.FindTotalColorStart

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-760de1f4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1744 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ecb5621 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:900 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afa947ce | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:213 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.FP00599_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-915db105 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6979 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ lambda] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…) ▸ if (dsMainFiltered.Good()) ▸ try] / this.spdMain.Change [if (this.IsEditMode == true) ▸ if (si…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4104ea2 | popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_C… 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4534 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.GetOperation

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a24e5f5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7555 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-cfa276d4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7555 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-32ac72cd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7557 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.GetPlanGroup

진입점: this.Load [try] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…) ▸ if (dsMainFiltered.Good()) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetNam…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2419829d | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4623 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2cd08f37 | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4624 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ab725777 | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4624 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-34e2ace4 | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4626 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-8066fd52 | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4627 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8abab5d0 | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4630 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-1993699a | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4631 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-96d6bee0 | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4631 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-5db5b82c | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4632 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f62923ed | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4633 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-93e27348 | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4634 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-729c2ddb | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4638 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e80f2033 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5639 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-3ac4555d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5640 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.GetToDay

진입점: sCalendar_planday.DateTimeChanged / popSql.OnSql [if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ lambda ▸ if (dt != null) ▸ else of (dt.Rows.Count > 0)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda ▸ if (dt != null) ▸ else of (dt.Rows.Count > 0)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f29850e | sCalendar_planday.DateTimeChanged 외 7 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4844 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-4ef59b22 | sCalendar_planday.DateTimeChanged 외 7 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4845 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaf347d1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1533 |  | UI_PROP | this.IsEditMode | do_edit_mode | 속성 IsEditMode 설정 |  |  |  |
| AC-f13076d3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1577 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolnames[k] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-6750d3a7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1578 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolidxs[k] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-a74421f5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1619 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_LOCK | siMain.LockRange2 | (rowindex, colindex, rowindex, colindex, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-2cf3de40 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1636 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_LOCK | siMain.LockRange2 | (rowindex, colindex, rowindex, colindex, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-d4f0564a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1638 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_LOCK | siMain.LockRange2 | (rowindex, colindex, rowindex, colindex, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-3b8b9104 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1649 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_LOCK | siMain.LockRange | (0, colindex, current_src.Rows.Count-1, colindex, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e1e310a0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1664 | if (do_edit_mode) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d92d23b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1674 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.LockRange2 | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-b12de6b4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1691 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (calendar != null) ▸ foreach (var week_item in calendar.Weeks) ▸ if (wee… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-137c3c49 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1708 | else of (do_edit_mode) ▸ if (c != null) ▸ if (measure.Week.On) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (m… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a77913a | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:292 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a9fbbe8c | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:296 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-020d54de | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:297 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-87ebaf7b | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:301 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-db622ce2 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:303 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-bf7bb2b8 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:307 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a478631 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:311 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-27a2911e | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:317 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-c393c246 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:319 | try | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0a7b62a1 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:330 | try | FLAG | _sToDay | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-c956792d | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:339 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-38b24958 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:340 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fe8c2cb1 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:341 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d4b5f51b | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:342 | try ▸ if (adminAuth == false) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a87d9fe2 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:345 | try | STATE | lblSummitInfo.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-aaa34647 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:346 | try | UI_PROP | lblCal.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-76f63414 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:362 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.InitEditingBuf

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f1a35d3 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4850 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c57ec793 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4853 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ba5e4da6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4857 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7327a47 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:254 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-8205299c | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:255 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-397b2610 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:256 |  | UI_PROP | mcbo_prodtype.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ad2198eb | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:257 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a7a7f67a | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:258 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-dad31c36 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:259 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-b79317cb | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:260 |  | UI_PROP | mcbo_planner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d728c1ea | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:261 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.InitSpread

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\|…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f15b98b5 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:466 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7759098 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:467 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f5125d0e | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:469 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c715b336 | this.Load 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:473 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Insert_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-733f029c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6545 | try | ENDPOINT | DataService.FP_PseudoBatch | ("FP00594_EXCELIMPORT", "insert_Excel_buffer", dsData) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-8b17d6de | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6549 | try ▸ if (result.Good()) | DATA_OP | result.Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-667bd3ef | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6561 | try ▸ if (result.Good()) ▸ if (result.Columns.Contains("RESULT")) ▸ else of (result.Rows[0]["RESULT"].ToString().ToUpper() == "SUCCESS") ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fdfcd848 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6569 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-9badbd7d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6573 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-9eb1f60c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6574 | catch ((Exception ex)) | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Insert_Data_Excel_Buffer_old

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a390837e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6660 | try ▸ if (iCount >0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-3d9f2a51 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6661 | try ▸ if (iCount >0) | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-08050c5e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6663 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-1e2dfffc | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6664 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f99d7870 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6665 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-059e03b3 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6666 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-41e89b07 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6667 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-2abc8516 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6668 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-718d7711 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6669 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-fafc667c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6670 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-46fdc1d1 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6671 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-01692f6a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6672 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-761b5f5c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6673 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-e42f6312 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6674 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-6998189a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6675 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-78ff1f0f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6676 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-bae67cd8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6677 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a6dda1d3 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6678 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5ff5e168 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6679 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-5bb50879 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6680 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-1d0ef83b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6681 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-82e31d81 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6682 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-8863a55c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6683 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-35ed9285 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6684 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_cell_qty"] | p_cell_qty | 행/컬럼 값 대입 |  |  |  |
| AC-df256f5d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6685 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1eb7c8a6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6686 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_confirm_area"] | p_confirm_area | 행/컬럼 값 대입 |  |  |  |
| AC-e62b643a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6687 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_release_value"] | p_release_value | 행/컬럼 값 대입 |  |  |  |
| AC-f3bc5dec | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6688 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_new_seq_no"] | p_new_seq_no | 행/컬럼 값 대입 |  |  |  |
| AC-bc23b3de | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6689 | try ▸ if (iCount >0) | DATA_OP | request.Parameters["p_mpp_wpp"] | p_mpp_wpp | 행/컬럼 값 대입 |  |  |  |
| AC-09ecc396 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6691 | try ▸ if (iCount >0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cb200b0f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6696 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-2633aaa2 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6700 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-d9622f7b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6702 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe996be0 | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:832 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6e0b085e | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:837 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | MESSAGE | MessageBox.Show | ("Can not be selected [Total] Row.!") | 메시지 표시 |  |  |  |
| AC-12579777 | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:838 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e32619e3 | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:841 | if (row != null) | POPUP | new FP00594_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-85d2d331 | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:842 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-54234e57 | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:842 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-67b4d868 | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:844 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2968b564 | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:845 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e7c65928 | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:846 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a0e202a8 | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:848 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-864e492d | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:850 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c83eaef6 | InsertButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:858 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f242afb0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2677 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2aadc0d1 | memo_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4461 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a45c8d98 | memo_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4464 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7e5363d | memo_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4472 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.onNLFAmendMenu

진입점: nlfamend_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75ed4617 | nlfamend_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4483 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-acbdb3b3 | nlfamend_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4486 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a76b18cc | nlfamend_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4504 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-21612f24 | nlfamend_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4505 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5090f5d7 | nlfamend_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4506 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-36980d1c | nlfamend_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4507 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b64f724c | nlfamend_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4508 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-351aafbd | nlfamend_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4509 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-745627f9 | nlfamend_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4510 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-26695818 | nlfamend_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4511 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8777d9c1 | nlfamend_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4512 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dc7a701 | bucke_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4379 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7ec7215 | bucke_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4382 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f99e7e9 | bucke_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4406 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.onZeroMaterialMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7aa05fc9 | bucke_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4420 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7cb240ba | bucke_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4423 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b299a512 | bucke_menu.Click | FP00622_PlanAmend_Line_NJ_Pouch.cs:4447 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.OpenAlarmMemo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b1929db | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7531 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-18f98aad | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7531 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0881aa96 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7533 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-650731a4 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7534 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-f6cf4926 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7534 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6ba694cb | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7535 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-d5f88147 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7536 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8cd503fb | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7537 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d34fa31e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7541 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4457231a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7543 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-feae3268 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:7548 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-706f5392 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7491 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-d0636a90 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7492 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-06d898fe | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7493 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-e27ec330 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7493 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e67c24a8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7494 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-9b5b3dcc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7495 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-33896baa | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7496 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4ca8f35e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7500 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-56219ed5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7502 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d0df476 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7508 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-64837415 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7509 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-8adff29e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7510 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-fa320eea | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7510 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f4196a25 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7511 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-e91f29d3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7512 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ed702a58 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7513 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fada8d99 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7517 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c514ec51 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7519 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.planday_changed

진입점: sCalendar_planday.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93649fd3 | sCalendar_planday.DateTimeChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:2717 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05343e51 | sCalendar_planday.DateTimeChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:2718 | if (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | CALL_EXT | sCalendar_planday.Undo | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6dc7177b | sCalendar_planday.DateTimeChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:2724 | else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Query

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnDppWppCopyDwSubmit.Click [if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51e1d51c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1409 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-b3f8fe1a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1409 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4abbbedd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1410 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2349917b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1415 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-e9e603f9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1438 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-63ce1c8a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1444 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-61ebe7f1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1444 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4b2af857 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1445 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-60867ba1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1445 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-17ca979e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1448 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b6164e4b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1455 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-585ba2c6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1460 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce9166b6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1461 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a56dde0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1463 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.RefreshHeadAndBody

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6aa9dfe9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1261 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2eaa28ff | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1277 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-772c4d85 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1281 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.RefreshHeader

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d721a4d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:541 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-6389d7b1 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:542 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-b09e961d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:543 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-9995c50c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:544 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-72295115 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:551 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, bUse_month, bUse_week, bUse_day, 2, FPExtensions.DateColumnType.QTY, FPExtensio… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d180f23c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:553 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-32645480 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:557 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-38cee270 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:559 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1cd05471 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:560 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4379628a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:561 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-027de357 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:562 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96e90ff8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:564 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04710078 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:565 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-379fe314 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:567 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-acdf3fd3 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:570 | if (monthInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cb996003 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:572 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e3e07de | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1241 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-f69a206c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1241 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-0b4d5008 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1243 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-34e90a44 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1248 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-b14ce085 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1254 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dcce3e3 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5715 | if (programID == "PR_UI_FP00622_AMEND_LINE_SELECT") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-aadb562e | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5728 | if (programID == "PR_UI_FP00622_AMEND_LINE_SAVE") ▸ if (dtListData != null) ▸ if (dtListData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "R… | RETURN | return Save_Data_Amend_MPPWPP(dtListData, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-6bd3d9ae | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5732 | if (programID == "PR_UI_FP00622_AMEND_LINE_SAVE") ▸ if (dtListData != null) ▸ if (dtListData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] … | RETURN | return Save_Data_Amend(dtListData, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-e13b0ad8 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5739 | if (programID == "PR_UI_FP00622_AMEND_LINE_SAVE") ▸ if (dtListData != null) ▸ else of (dtListData.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_OUT_CELL.") | 메시지 표시 |  |  |  |
| AC-24a85526 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5740 | if (programID == "PR_UI_FP00622_AMEND_LINE_SAVE") ▸ if (dtListData != null) ▸ else of (dtListData.Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-166094a2 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5745 | if (programID == "PR_UI_FP00622_AMEND_LINE_SAVE") ▸ else of (dtListData != null) | MESSAGE | MessageBox.Show | ("there is no Edit Value of P_OUT_CELL.") | 메시지 표시 |  |  |  |
| AC-87e4f997 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5746 | if (programID == "PR_UI_FP00622_AMEND_LINE_SAVE") ▸ else of (dtListData != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2fb74866 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5756 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") | POPUP | new FP00594_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-76d1981e | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5761 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-578795ea | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5762 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-5110c9b5 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5763 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-c192da39 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5765 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-62110153 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5772 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_COLTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00594_AMEND_MODEL_EXCEL", Filter… |  | 처리 중단/반환 |  |  |  |
| AC-90346b34 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5785 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") | POPUP | new FP00594_RowExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a4689bdd | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5790 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-faca8f51 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5791 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-bb2d92de | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5792 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-021a5069 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5794 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-5aa6e669 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5803 | if (programID == "PR_UI_FP00594_EXCEL_SELECT_ROWTYPE") ▸ if (popup != null) | RETURN | return dsData = Find_Data_Excel_Import("PR_UI_FP00594_AMEND_MODEL_EXCEL", Filter… |  | 처리 중단/반환 |  |  |  |
| AC-c933d144 | popSql.OnSql | FP00622_PlanAmend_Line_NJ_Pouch.cs:5809 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Save_Data

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…) ▸ if (dsMainFiltered.Good())] / this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (dsMainFiltered.Good())] / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-384f819e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2092 | if (siMain == null && (dgEdit.DataSource == null \|\| dsBoh == null)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd51e515 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2094 | if (dtData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27420d45 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2095 | if (dtData.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-506b10e5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2100 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-68ef23a5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2101 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62f2face | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2106 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3043a878 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2116 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check" , Filter["INSTANCE_ID"], Filter["FP_PLAN_ID"], Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-527d45da | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2129 | try ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e4a8038 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2130 | try ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09255db0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2133 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ca7ca1f1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2172 | try ▸ if (!string.IsNullOrEmpty(errorMsg)) | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-247339db | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2182 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4609f266 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2183 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d4d9b289 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2184 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-b7b03c58 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2185 | catch ((Exception ex)) | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-9959a924 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2189 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2c792235 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2190 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Save_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAVE") ▸ if (dtListData != null) ▸ if (dtListData.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE")] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-248a65d7 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2410 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-ace35a0d | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2411 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-36830345 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2413 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-f088ccdb | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2414 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-014a0790 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2415 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-2bfbe9e8 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2416 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e23be82d | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2417 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-f9f41800 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2418 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-972e7ff3 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2419 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-ecac8a10 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2420 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce4791e3 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2421 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-dcc29929 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2422 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-62c44d97 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2423 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd9fd481 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2424 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-f57d6eb2 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2425 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-7015779f | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2426 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-1c0ba20e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2427 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c11b55b1 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2428 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-b51ec7c1 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2429 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-747d9233 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2430 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-e2053c16 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2431 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-a9de795e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2432 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-9c40f02b | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2433 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-a6fbdd82 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2434 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-f9af581a | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2435 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_p_in_qty"] | p_p_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-c037469b | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2436 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_p_out_qty"] | p_p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-9deb1b6e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2437 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mpp_in_qty"] | p_mpp_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-a0ae5363 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2438 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mpp_out_qty"] | p_mpp_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-2f8250b4 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2439 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_in_qty"] | p_wpp_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-f51a6a1c | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2440 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_out_qty"] | p_wpp_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-c5c31f3a | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2441 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_boh_qty"] | p_boh_qty | 행/컬럼 값 대입 |  |  |  |
| AC-eb6913a4 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2443 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plm_ec_no"] | p_plm_ec_no | 행/컬럼 값 대입 |  |  |  |
| AC-49a7f56b | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2444 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version"] | p_version | 행/컬럼 값 대입 |  |  |  |
| AC-c3eb4865 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2446 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ba4d982c | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2447 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2617735c | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2453 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-794e1938 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2459 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Save_Data_Amend_MPPWPP

진입점: popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAVE") ▸ if (dtListData != null) ▸ if (dtListData.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"] == "RELEASE")] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…) ▸ if (dsMai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-809f7e0f | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2552 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-56fc9a35 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2553 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ae02045c | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2555 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-601fc4ba | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2556 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2685b605 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2557 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-e735251c | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2558 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-26d059d6 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2559 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-d8fe8ef7 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2560 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-4937c3ad | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2561 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e25bfb5 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2562 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-ecc5f00c | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2563 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d83baddf | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2564 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b6fb9a94 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2565 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-d485eac8 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2566 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-69baa80a | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2567 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-4869f57d | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2568 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d92d8c3 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2569 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a5dc0195 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2570 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-47ac651e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2571 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-b720d3fd | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2572 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-a38c64ef | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2573 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-5e54a9c3 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2574 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-4b2a5741 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2575 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-adb1b087 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2576 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-0a5b49cb | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2577 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_p_in_qty"] | p_p_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-8868300f | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2578 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_p_out_qty"] | p_p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-a0a7574e | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2579 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mpp_in_qty"] | p_mpp_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e90131f9 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2580 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mpp_out_qty"] | p_mpp_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-245bd296 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2581 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_in_qty"] | p_wpp_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-bcbfdd1b | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2582 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_out_qty"] | p_wpp_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-2e81b9de | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2583 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_boh_qty"] | p_boh_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e13ee964 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2585 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plm_ec_no"] | p_plm_ec_no | 행/컬럼 값 대입 |  |  |  |
| AC-8e2fa9b2 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2586 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_version"] | p_version | 행/컬럼 값 대입 |  |  |  |
| AC-91062113 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2588 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-42186c22 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2589 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b9372c03 | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2595 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-392e5a5a | popSql.OnSql [if (programID == "PR_UI_FP00622_AMEND_LINE_SAV… 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:2601 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Save_Data_Boh

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e3c0086 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2273 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00622_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-a1ff32ce | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2274 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8af5dd02 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2276 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b18a0016 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2277 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6af1e4f1 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2278 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-5b0a70f8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2279 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6aea6c52 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2280 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-36af73b9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2281 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-16a47029 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2282 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc56cbbd | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2283 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-4542ac67 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2284 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-682446a0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2285 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-ece9f4f9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2286 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-1ab8d7ec | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2287 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-c80f9056 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2288 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-be18114c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2289 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-f58c65a8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2290 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-b73b9a14 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2291 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a6131640 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2292 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-0330dcbe | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2293 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-c15f63d5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2294 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-97b8b740 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2295 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-cb6b41b2 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2296 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-ef1e7db8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2297 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-39a67adf | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2298 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_in_qty"] | p_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-d501a706 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2299 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-f6dc5a2a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2300 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_in_qty"] | p_cell_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-652bae63 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2301 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_out_qty"] | p_cell_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e30fb6a5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2302 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_boh_qty"] | p_boh_qty | 행/컬럼 값 대입 |  |  |  |
| AC-cf636585 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2304 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-06edc78f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2305 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-98de238b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2311 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e3c53c16 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:2317 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Save_Data_Excel_Column

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5297d1e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6790 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-6aae7279 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6791 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7135add4 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6793 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-4adfd81d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6794 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1473d2b9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6795 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-d71d9cee | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6796 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6a207a9d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6797 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8dbafc2e | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6798 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eef4bd40 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6799 | try | DATA_OP | request.Parameters["p_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5ae290b5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6800 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e048eeec | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6801 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-025b57a3 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6802 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-af1fd129 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6803 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a3c936ab | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6804 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9c03b712 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6805 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-38bd9c75 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6806 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ce404967 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6807 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d228594 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6808 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c64aad8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6809 | try | DATA_OP | request.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-00bf49cc | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6810 | try | DATA_OP | request.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0bbb59e1 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6811 | try | DATA_OP | request.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f4d6dacd | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6812 | try | DATA_OP | request.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dae07ea9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6813 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e9c081d8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6814 | try | DATA_OP | request.Parameters["p_cell_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6dfeaa7d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6815 | try | DATA_OP | request.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a3d36707 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6816 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-93e541fa | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6817 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a24d75e6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6818 | try | DATA_OP | request.Parameters["p_new_seq_no"] | sNewSeqNo | 행/컬럼 값 대입 |  |  |  |
| AC-602d95b2 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6819 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | sMppWpp | 행/컬럼 값 대입 |  |  |  |
| AC-214a082f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6821 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dca39a48 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6823 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-c86971e9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6828 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-59600774 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6830 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.Save_Data_Excel_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-909adce7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6868 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE") ⇒ FP_Planning.PR_UI_FP00594_AMEND_MODEL_EXCEL_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-e43be531 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6869 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3ee934d8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6871 | try | DATA_OP | request.Parameters["p_sys_type"] | sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-60ff31a8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6872 | try | DATA_OP | request.Parameters["p_sys_flag"] | sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-80bd48a1 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6873 | try | DATA_OP | request.Parameters["p_sys_gubun"] | sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-56f7a4d1 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6874 | try | DATA_OP | request.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a8687927 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6875 | try | DATA_OP | request.Parameters["p_instance_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d94cde14 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6876 | try | DATA_OP | request.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3d0b0d47 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6877 | try | DATA_OP | request.Parameters["p_plan_id"] | sPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-467752c6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6878 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-171c6f21 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6879 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2acc4351 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6880 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1d6c885a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6881 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-149da568 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6882 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-12105772 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6883 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-00aa9196 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6884 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3aa4124c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6885 | try | DATA_OP | request.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-330cb44f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6886 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6e3c2a6f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6887 | try | DATA_OP | request.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f5244fa | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6888 | try | DATA_OP | request.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-07cb25da | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6889 | try | DATA_OP | request.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-55384201 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6890 | try | DATA_OP | request.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b3159426 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6891 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0e3a132a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6892 | try | DATA_OP | request.Parameters["p_cell_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-48222a53 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6893 | try | DATA_OP | request.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-53ce7345 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6894 | try | DATA_OP | request.Parameters["p_confirm_area"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1b854f8d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6895 | try | DATA_OP | request.Parameters["p_release_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7e6d176d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6896 | try | DATA_OP | request.Parameters["p_new_seq_no"] | sNewSeqNo | 행/컬럼 값 대입 |  |  |  |
| AC-754793cd | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6897 | try | DATA_OP | request.Parameters["p_mpp_wpp"] | sMppWpp | 행/컬럼 값 대입 |  |  |  |
| AC-1cff12a0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6899 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-81fed14b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6901 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-aadbc40b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6906 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-c8197b86 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:6908 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a46c1dd8 | SaveButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:882 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6cb1f074 | SaveButton | FP00622_PlanAmend_Line_NJ_Pouch.cs:883 |  | MESSAGE | MessageBox.Show | ("Save button[F7] can't use!") | 메시지 표시 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetBasisTime

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9ec34c6 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4550 |  | FLAG | dtBaseTime | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findBasisTime", sInstance,… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-6ad7bcd1 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4550 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findBasisTime", sInstance, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetBohQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee730009 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1757 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-822dade0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1758 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d6e2741 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1763 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-f9cba069 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1768 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8dd993a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1769 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-817e9c7d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1770 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b55d1af | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1771 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e4c6268 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1772 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8e6040f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1773 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-512733fa | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1774 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-31947d82 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1775 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b97cd377 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:1779 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetBohQtyByEditCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a4d811a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4878 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b8aa574 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4879 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-49142aad | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4883 | lambda | DATA_OP | each_row.Field | ("IS_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-8cc43dda | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4885 |  | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6d8fc989 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4901 | if (nColStart == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57545004 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4935 | for (i <= nRowEnd) | GRID_SET | siMain.SetValue | (i, cCol, nBoh) | 그리드 값 설정 |  |  |  |
| AC-9f3f84c0 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4978 | for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ if (sPSI == "I") | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nI_tmp) | 그리드 값 설정 |  |  |  |
| AC-f930e0e7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5034 | for (i <= nRowEnd) ▸ else of (sDTyp == "DATA") | GRID_SET | siMain.SetValue | (i, cCol, nBoh_tmp) | 그리드 값 설정 |  |  |  |
| AC-5f23b9e9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5086 | for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDTyp == "DATA") ▸ if (dsMainFiltered.Tables[0].Rows[i]["DATA_TYPE"].ToString() == "TOTAL… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nPI_tmp) | 그리드 값 설정 |  |  |  |
| AC-71b2bb4c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5091 | for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDTyp == "DATA") ▸ if (dsMainFiltered.Tables[0].Rows[i]["DATA_TYPE"].ToString() == "TOTAL… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nPO_tmp) | 그리드 값 설정 |  |  |  |
| AC-d5562fe9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5097 | for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDTyp == "DATA") ▸ if (dsMainFiltered.Tables[0].Rows[i]["DATA_TYPE"].ToString() == "TOTAL… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nS_tmp) | 그리드 값 설정 |  |  |  |
| AC-328de4f7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5102 | for (j <= nColEnd) ▸ for (i <= nRowEnd) ▸ else of (sDTyp == "DATA") ▸ if (dsMainFiltered.Tables[0].Rows[i]["DATA_TYPE"].ToString() == "TOTAL… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nI_tmp) | 그리드 값 설정 |  |  |  |
| AC-75406221 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5111 | if (dsBoh == null) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_find_ListData_BOH", Filter["INSTANCE_ID"].ToString(), Filter["PL… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-242d6772 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5113 | if (dsBoh == null) | FLAG | dsBoh | dtBoh.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-a8b394d7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5123 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6135f9e3 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5124 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-06851db2 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5125 | lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb4667d4 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5126 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-88a1b846 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5127 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-509fb464 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5128 | lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe86302d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5129 | lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fef8e520 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5130 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6538c212 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5123 | lambda | RETURN | return (x.Field<string>("DIVISION_ID") == row["DIVISION_ID"].ToString() && x.Fie… |  | 처리 중단/반환 |  |  |  |
| AC-f26e0e2d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5148 | if (MatchingEditRowData.Count() > 0) ▸ if (orgQty == Convert.ToDecimal(newEditingValue)) | DATA_OP | selected["ACTION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8a9c8379 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5152 | if (MatchingEditRowData.Count() > 0) ▸ else of (orgQty == Convert.ToDecimal(newEditingValue)) | DATA_OP | selected["QTY"] | Convert.ToDecimal(newEditingValue) | 행/컬럼 값 대입 |  |  |  |
| AC-7f2268a7 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5153 | if (MatchingEditRowData.Count() > 0) ▸ else of (orgQty == Convert.ToDecimal(newEditingValue)) | DATA_OP | selected["ACTION"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-683c7e1a | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5162 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2e7cf3eb | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5164 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | row["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a77a3818 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5165 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | sPlanDate | 행/컬럼 값 대입 |  |  |  |
| AC-cf21243c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5166 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | row["FP_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8901d37b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5167 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d4fb6a77 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5168 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1bff7ade | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5169 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ce3d7f90 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5170 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0420000c | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5171 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-23bb43dc | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5172 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-44767b90 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5173 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69eb2a70 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5174 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["TOP_ITEM_ID"] | row["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ba454b98 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5175 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["LOCATION"] | row["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f8875070 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5176 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["QTY"] | Convert.ToDecimal(newEditingValue) | 행/컬럼 값 대입 |  |  |  |
| AC-ef2fc494 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5177 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ORIG_QTY"] | Convert.ToDecimal(newEditingValue) | 행/컬럼 값 대입 |  |  |  |
| AC-fa5536b9 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5178 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | newrow["ACTION"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-3430d84f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5180 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-7dfcb0cf | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:5181 | else of (MatchingEditRowData.Count() > 0) | DATA_OP | dsBoh.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetCalenderColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMain…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bde683e6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1482 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d190811e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1486 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-136ab84e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1488 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f4eb821 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1492 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ae3f292b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1508 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-44106699 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1523 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetChangeControl

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / cbo_fpplanid.SelectedIndexChanged [if (sender !=null)] / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged [try] / mcbo_line.SelectedIndexChanged / mcbo_prodtype.SelectedIndexChanged / chk_allLine.CheckedChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76628290 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:373 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-39b1f379 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:373 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b0ba110b | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:378 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-a3217408 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:378 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-be0a0f46 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:382 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-14bd17d7 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:382 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-000acaf3 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:383 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9e1ffba5 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:389 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-a69e6c28 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:390 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ffbd2e4 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:390 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-165369fd | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:391 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-aaee0517 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:397 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, mcbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-88b8762b | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:398 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-01e3fca2 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:398 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e1093ba1 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:399 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-aa4974b2 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:405 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-87e0e13f | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:406 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-723724a3 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:406 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-19658af2 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:407 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0b4ef27b | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:414 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-ac24c442 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:415 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d1a3615 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:415 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8f6f6688 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:416 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a06337de | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:422 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-978cfec1 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:423 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d180aa3 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:423 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d170ff3e | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:424 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-81a15fc8 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:430 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-277e52bf | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:439 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODTYPE_ID"] | Filter["PRODUCTION_TYPE"] = Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, … | 행/컬럼 값 대입 |  |  |  |
| AC-a367ba28 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:439 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-f3667e53 | this.Load [try] 외 11 | FP00622_PlanAmend_Line_NJ_Pouch.cs:439 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PROD_TYPE"] | CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-789bbea9 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:233 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39a3a21d | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:235 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-4158aa6f | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:239 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-af14464e | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:241 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-9f348035 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:242 |  | CALL_EXT | UserService.HasSuperRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-311e43d4 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:244 | if (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-ce4fcaa4 | this.Load | FP00622_PlanAmend_Line_NJ_Pouch.cs:248 | else of (UserService.HasSuperRole(_CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetDirty

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…)] / this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (Convert.ToInt32(newEditingValue) < 0)] / this.btnDppWpp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07c3029b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 6 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4834 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f113552d | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4560 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-6d99bfb5 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4560 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-640d2d07 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4561 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetFactory

진입점: sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbd4083f | sCalendar_planday.DateTimeChanged [else of (Convert.ToDecima… | FP00622_PlanAmend_Line_NJ_Pouch.cs:4742 |  | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-ffb42613 | sCalendar_planday.DateTimeChanged [else of (Convert.ToDecima… | FP00622_PlanAmend_Line_NJ_Pouch.cs:4742 |  | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-20a39b21 | sCalendar_planday.DateTimeChanged [else of (Convert.ToDecima… | FP00622_PlanAmend_Line_NJ_Pouch.cs:4744 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_planner.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay())) ▸ if (dtPlanId.Rows.Count > 0)] / cbo_fpplanid.SelectedIndexChanged [if (cbo_fpplanid.Items.Count > 0)] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Go…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d1e7d90 | this.Load [try] 외 27 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4529 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetFpPlanId

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / this.cbo_fpplanid.Click / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dad88c9f | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4648 |  | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d80f14d2 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4648 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-05f4a7c2 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4649 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0ba7b3e4 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4652 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-45ee4114 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4654 | else of (dtPlanId.Rows.Count > 0) | VALUE_CLEAR | cbo_fpplanid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-c7f34954 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4670 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | dtPlanId.Rows[0]["INSERT_ID"].ToString() | 속성 _sInsertID 설정 |  |  |  |
| AC-7e9a8e1a | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4671 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | dtPlanId.Rows[0]["INSERT_TIME"].ToString() | 속성 _sInsertTime 설정 |  |  |  |
| AC-852488d9 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4672 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | dtPlanId.Rows[0]["DESCS"].ToString() | 속성 _sDescription 설정 |  |  |  |
| AC-bd1d8b4d | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4673 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | dtPlanId.Rows[0]["BASIC_VERSION"].ToString() | 속성 _sBasicVersion 설정 |  |  |  |
| AC-f7c9c9cd | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4674 | if (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | dtPlanId.Rows[0]["FACTORY_LT"].ToString() | 속성 _sFactoryID 설정 |  |  |  |
| AC-7798129a | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4676 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-79b42e13 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4677 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-dc544018 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4678 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-1143f6e9 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4679 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-dbae65cc | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4680 | if (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |
| AC-859bb872 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4695 | if (dtPlanId.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4467af82 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4697 | if (dtPlanId.Rows.Count > 0) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f154731d | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4701 | if (dtPlanId.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"].ToString() == "RELEASE") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-59ac9a2b | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4703 | if (dtPlanId.Rows.Count > 0) ▸ else of (Filter["PLAN_TYPE"].ToString() == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-40e07754 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4708 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertID | "" | 속성 _sInsertID 설정 |  |  |  |
| AC-5c8265c6 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4709 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sInsertTime | "" | 속성 _sInsertTime 설정 |  |  |  |
| AC-9b49fbeb | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4710 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sDescription | "" | 속성 _sDescription 설정 |  |  |  |
| AC-29e7f433 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4711 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sBasicVersion | "" | 속성 _sBasicVersion 설정 |  |  |  |
| AC-4b02dcbf | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4712 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | stPlanInfo._sFactoryID | "" | 속성 _sFactoryID 설정 |  |  |  |
| AC-37519abf | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4714 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreator.Text | stPlanInfo._sInsertID | 컨트롤 값 설정 |  |  |  |
| AC-90dfe8db | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4715 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtCreation.Text | stPlanInfo._sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-4d41da39 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4716 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtDesc.Text | stPlanInfo._sDescription | 컨트롤 값 설정 |  |  |  |
| AC-7fa2279e | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4717 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBasic.Text | stPlanInfo._sBasicVersion | 컨트롤 값 설정 |  |  |  |
| AC-2944d55f | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4718 | else of (dtPlanId.Rows.Count > 0) | VALUE_SET | txtBuilding.Text | stPlanInfo._sFactoryID | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetLine

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner.Items.Count) ▸ if (mcbo_planner.Items[k].ToString() == sValueName.ToString())] / mcbo_planner.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner.Items.Count) ▸ if (mcbo_planner.Items[k].ToString() == sValueName.ToString())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1b0fd21 | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4786 |  | DATA_OP | Filter["ALL_LINE"] | chk_allLine.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-cc05a5aa | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4788 |  | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-43f98d64 | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4788 |  | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b1f05fc3 | this.Load [try] 외 3 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4790 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetNickName_LT

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))] / mcbo_line.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d593207f | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4767 |  | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-badfcaeb | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4768 |  | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_CELL_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-cd0711b1 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4772 | if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-c4afa8a0 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4773 | if (Filter["PLAN_TYPE"].ToString().Equals("RELEASE")) | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_CELL_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-e337df97 | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4776 |  | FLAG | dtNickName | DataService.GetInnerTable("NICK_NAME_LT", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4a70144a | this.Load [try] 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4776 |  | COMBO_DATA | DataService.GetInnerTable | ("NICK_NAME_LT", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9099260 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4752 |  | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-74073911 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4752 |  | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a8243b3f | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4753 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetPlanDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81eff146 | this.Load [try] | FP00622_PlanAmend_Line_NJ_Pouch.cs:4540 |  | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetPlanner

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98e2f2c9 | this.Load [try] 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4573 |  | FLAG | dtPlanner | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findPlanner_List", sInstan… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-9cb7e0e3 | this.Load [try] 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4573 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findPlanner_List", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89986c6a | this.Load [try] 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4574 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, mcbo_planner, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-a345a8cf | this.Load [try] 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4584 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row[… | CALL_EXT | mcbo_planner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-397cba51 | this.Load [try] 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4588 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of … | CALL_EXT | mcbo_planner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-27f6d61e | this.Load [try] 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4602 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-5aa89cfc | this.Load [try] 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4603 | if (dtPlanner != null) ▸ if (dtPlanner.Rows.Count == 0) | DATA_OP | Filter["ALL_LINE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-20111b6a | this.Load [try] 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4612 | if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner.Items.Count) ▸ if (mcbo_planner.Items[k].ToString() == sValueName.ToString()) | CALL_EXT | mcbo_planner.SetItemChecked | (k, true) | ⚠ 의미 확인 필요 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetPlanOutQty

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…)] / this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / this.spdMain.KeyDown [else of (e.Control && e.KeyCode == K…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a467527d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5199 | if (dsMainFiltered.Good()) | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-ab495eaf | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5200 | if (dsMainFiltered.Good()) | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-4f868b0c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5223 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-3de9aa22 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5224 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-7b939066 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5225 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-9bda93fe | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5226 | if (dsMainFiltered.Good()) ▸ if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-3d7713fc | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5241 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05f70f27 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5248 | if (dsMainFiltered.Good()) ▸ if (dt == null) | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f4d3f123 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5249 | if (dsMainFiltered.Good()) ▸ if (dt == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e350437 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5252 | if (dsMainFiltered.Good()) | DATA_OP | dt.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-54c55d03 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5258 | if (dsMainFiltered.Good()) ▸ if (current_catagory.Equals("P_OUT") \|\| current_catagory.Equals("M_OUT") \|\| current_catagory.Equals("W_OUT"… | DATA_OP | each_row.Field | ("IS_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-529a1e63 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5260 | if (dsMainFiltered.Good()) ▸ if (current_catagory.Equals("P_OUT") \|\| current_catagory.Equals("M_OUT") \|\| current_catagory.Equals("W_OUT"… | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b4fe2896 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5270 | if (dsMainFiltered.Good()) ▸ if (current_catagory.Equals("P_OUT") \|\| current_catagory.Equals("M_OUT") \|\| current_catagory.Equals("W_OUT"… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d6f79fe | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5337 | if (dsMainFiltered.Good()) ▸ if (current_catagory.Equals("P_OUT") \|\| current_catagory.Equals("M_OUT") \|\| current_catagory.Equals("W_OUT"… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nPI_tmp) | 그리드 값 설정 |  |  |  |
| AC-23ac1cac | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5342 | if (dsMainFiltered.Good()) ▸ if (current_catagory.Equals("P_OUT") \|\| current_catagory.Equals("M_OUT") \|\| current_catagory.Equals("W_OUT"… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(sColName), nPO_tmp) | 그리드 값 설정 |  |  |  |
| AC-09078970 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5360 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a846e14 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5361 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f28a7ea7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5362 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d483b22 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5363 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-93448aa6 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5364 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b7ecb716 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5365 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ce6722c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5366 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2edd113d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5367 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd0823d7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5370 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-870c5c94 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5373 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-ddb2476a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5374 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bed265cc | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5375 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-540000ef | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5376 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4eb0323 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5377 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d296168 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5378 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("PLM_EC_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a76067d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5379 | if (dsMainFiltered.Good()) ▸ lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-0899af49 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5358 | if (dsMainFiltered.Good()) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("FP_PL… |  | 처리 중단/반환 |  |  |  |
| AC-4bcbab60 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5393 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT") | DATA_OP | selected["P_IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-f651273b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5394 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT") | DATA_OP | selected["P_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-3730a4bf | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5395 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT") | DATA_OP | selected["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-285222de | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5396 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT") | DATA_OP | selected["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-0631a6d5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5397 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT") | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-ba6a8b83 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5421 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT") | DATA_OP | dtSave.ImportRow | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6300c81 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5425 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory == "… | DATA_OP | selected["MPP_IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-4ad1ea37 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5426 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory == "… | DATA_OP | selected["MPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-18793d3e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5427 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory == "… | DATA_OP | selected["WPP_IN_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-dd576f43 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5428 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory == "… | DATA_OP | selected["WPP_OUT_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-0d31fdfb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5429 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory == "… | DATA_OP | selected["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-1c70f0f8 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5430 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory == "… | DATA_OP | selected["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-c8e596a1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5431 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory == "… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-ced76089 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5457 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory == "… | DATA_OP | dtSave.ImportRow | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9e66bd1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5461 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ else of (current_catagory… | DATA_OP | selected["WPP_IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-8c62b93c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5462 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ else of (current_catagory… | DATA_OP | selected["WPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-af8c8929 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5463 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ else of (current_catagory… | DATA_OP | selected["MPP_IN_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-b8c24997 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5464 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ else of (current_catagory… | DATA_OP | selected["MPP_OUT_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-5ae5bfcc | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5465 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ else of (current_catagory… | DATA_OP | selected["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-8cf6b184 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5466 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ else of (current_catagory… | DATA_OP | selected["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-be63efb8 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5467 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ else of (current_catagory… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-f9f1b025 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5494 | if (dsMainFiltered.Good()) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ else of (current_catagory… | DATA_OP | dtSave.ImportRow | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8179776 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5501 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b413b91a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5503 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-85a7b67f | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5504 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e3c4eca | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5505 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a9fd234 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5506 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a04aad75 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5507 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["CATEGORY_ID"] | row["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5da5408 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5508 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3119be30 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5509 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1c245d97 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5510 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-49ebefc7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5511 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e029f7e7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5512 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["MARKET"] | row["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6508ab4d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5513 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-63e0a27c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5514 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b17d8d97 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5515 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5eb21dc1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5516 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["LOCATION"] | row["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1380a219 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5517 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-33b2cbed | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5518 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["TOP_ITEM_ID"] | row["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-34b16cc7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5519 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cd232b67 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5520 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["ITEM_TYPE"] | row["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5d42f50b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5521 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["PLM_EC_NO"] | row["PLM_EC_NO"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d9e467fb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5522 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["VERSION"] | row["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f6071d49 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5526 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT") | DATA_OP | newrow["P_IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-6b2c9725 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5527 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT") | DATA_OP | newrow["P_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-086aee6f | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5528 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT") | DATA_OP | newrow["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-d188a2f8 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5529 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "P_OUT") | DATA_OP | newrow["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-85ebc3f6 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5533 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory… | DATA_OP | newrow["MPP_IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-387e0f9a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5534 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory… | DATA_OP | newrow["MPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-61f82332 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5535 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory… | DATA_OP | newrow["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-76e0ec4a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5536 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory… | DATA_OP | newrow["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-0db728d1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5537 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory… | DATA_OP | newrow["WPP_IN_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-5bf768b4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5538 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ else of (current_catagory == "P_OUT") ▸ if (current_catagory… | DATA_OP | newrow["WPP_OUT_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-03a05427 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5542 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "W_OUT") | DATA_OP | newrow["WPP_IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-09f26344 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5543 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "W_OUT") | DATA_OP | newrow["WPP_OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-432e3224 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5544 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "W_OUT") | DATA_OP | newrow["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-8fe2a12a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5545 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "W_OUT") | DATA_OP | newrow["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-f39a573d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5546 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "W_OUT") | DATA_OP | newrow["MPP_IN_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-16e98ccd | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5547 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) ▸ if (current_catagory == "W_OUT") | DATA_OP | newrow["MPP_OUT_QTY"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-2871c8d5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5549 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-5b9e624e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5551 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-037e441b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5552 | if (dsMainFiltered.Good()) ▸ else of (matching_row_from_EditGrid.Count() > 0) | DATA_OP | dtSave.ImportRow | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-f75405e0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5614 | if (dsMainFiltered.Good()) | LIST_BIND | dgEdit.DataSource | dt | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-796510d7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00622_PlanAmend_Line_NJ_Pouch.cs:5620 | if (dsMainFiltered.Good()) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetPlanPeriod

진입점: this.Load [try] / sCalendar_planday.DateTimeChanged [else of (Convert.ToDecimal(sDay) > Convert.ToDecimal(GetToDay()))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6421898 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4812 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-afa6831e | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4813 | if (dtPlanId.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-1381807d | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4817 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-dc6f51a0 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4818 | if (dtPlanId.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-5b6cd767 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4824 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-7efd40a6 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4825 | else of (dtPlanId.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc1559f8 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4732 |  | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-009d7963 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4732 |  | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ef8ea73b | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4733 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetProdType

진입점: this.Load [try] / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55147b44 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4761 |  | FLAG | dtProdType | DataService.GetProdType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-59cb1910 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4761 |  | CALL_EXT | DataService.GetProdType | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b842b3c9 | this.Load [try] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:4762 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prodtype, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetReleaseProcess

진입점: this.btnExcelImport.Click / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4bed8aa | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1038 |  | STATE | lblSummitInfo.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-c8206391 | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1039 |  | UI_PROP | lblCal.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-cf32238f | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1045 | if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | dtIsCurrWeek | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "find_isCurrWeek", Filter["INSTANCE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-84aedc9f | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1045 | if (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d3c3cf58 | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1056 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ if (row_Date < curr_Date) | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-6a61191e | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1060 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ else of (row_Date < curr_Date) | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-0e36f4cc | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1068 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-654d725a | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1070 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ad7fd208 | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1071 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | UI_PROP | lblCal.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ca7a0aaf | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1074 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["IS_LATEST_PLAN"] | dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-68cf56e3 | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1075 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["CURR_DATE"] | dtIsCurrWeek.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-58e6c811 | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1076 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["RELEASE_VALUE"] | dtIsCurrWeek.Rows[0]["RELEASE_VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9dcea9b9 | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1080 | if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | dtLastestSubmitInfo | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "find_lastestSubmit_info", Filter["… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-28d97897 | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1080 | if (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_lastestSubmit_info", Filter["INSTANCE_ID"], Filter["PLAN_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-63443cb6 | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1085 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtLastestSubmitInfo != null) ▸ if (dtLastestSubmitInfo.Rows.Count > 0) | VALUE_SET | lblSummitInfo.Text | "* Latest DW Plan : " + dtLastestSubmitInfo.Rows[0]["FP_PLAN_ID"].ToString() + " (" + dtLa… | 컨트롤 값 설정 |  |  |  |
| AC-7a09dd95 | this.btnExcelImport.Click 외 5 | FP00622_PlanAmend_Line_NJ_Pouch.cs:1086 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dtLastestSubmitInfo != null) ▸ if (dtLastestSubmitInfo.Rows.Count > 0) | STATE | lblSummitInfo.Visible | true | 컨트롤 상태 Visible |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87b5d552 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4725 |  | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-91e16060 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4725 |  | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3bb486a1 | (진입점 미연결) | FP00622_PlanAmend_Line_NJ_Pouch.cs:4726 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa1aec22 | this.Load [try] 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:481 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7fd34bac | this.Load [try] 외 9 | FP00622_PlanAmend_Line_NJ_Pouch.cs:482 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SetTotalColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMain…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ede35ef | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 8 | FP00622_PlanAmend_Line_NJ_Pouch.cs:523 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cca2cf3a | this.spdMain.ButtonClicked | FP00622_PlanAmend_Line_NJ_Pouch.cs:4279 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9f7b3d5 | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4025 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b81615e6 | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4026 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0dfdae4d | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4047 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-adb968fa | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4048 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-10b70d0e | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4050 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5a89f4e | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4059 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-af6816b3 | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4060 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-b469d2cf | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4062 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c7fdef2 | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4074 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-8a2ac63b | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4075 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-db6ecd86 | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4077 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8322025 | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4086 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-0802c1bc | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4087 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-fc211119 | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4089 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-432e3d39 | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4093 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | nlfamend_menu.Text | "NLF Amend" | 컨트롤 값 설정 |  |  |  |
| AC-809eb361 | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4094 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | nlfamend_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-c3e322be | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4096 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (nlfamend_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d7110b4 | this.spdMain.CellClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:4104 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-463b1c75 | this.spdMain.CellDoubleClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:7342 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-1861d05a | this.spdMain.CellDoubleClick | FP00622_PlanAmend_Line_NJ_Pouch.cs:7349 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9de9d1da | this.spdMain.Change | FP00622_PlanAmend_Line_NJ_Pouch.cs:4239 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE… | FLAG | dtIsCurrWeek | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "find_isCurrWeek", Filter["INSTANCE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-692cb91c | this.spdMain.Change | FP00622_PlanAmend_Line_NJ_Pouch.cs:4239 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-602ed99b | this.spdMain.Change | FP00622_PlanAmend_Line_NJ_Pouch.cs:4247 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5165d25d | this.spdMain.Change | FP00622_PlanAmend_Line_NJ_Pouch.cs:4249 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (Filter["PLAN_TYPE"].ToString() == "RELEASE… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-caf28fa3 | this.spdMain.Change | FP00622_PlanAmend_Line_NJ_Pouch.cs:4260 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (Convert.ToInt32(newEditingValue) < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-638f04a8 | this.spdMain.Change | FP00622_PlanAmend_Line_NJ_Pouch.cs:4262 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (Convert.ToInt32(newEditingValue) < 0) | GRID_SET | siMain.SetValue | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-67d445e4 | this.spdMain.Change | FP00622_PlanAmend_Line_NJ_Pouch.cs:4264 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (Convert.ToInt32(newEditingValue) < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1317459c | this.spdMain.Change | FP00622_PlanAmend_Line_NJ_Pouch.cs:4270 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | STATE | txtReleaseAlert.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-c57ab5f3 | this.spdMain.Change | FP00622_PlanAmend_Line_NJ_Pouch.cs:4273 |  | VALUE_SET | tbLog.Text | "spdMain_Change" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18da7f4b | this.spdMain.ChildControlDeactivated | FP00622_PlanAmend_Line_NJ_Pouch.cs:4185 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d152ae28 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4284 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-505619b1 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4285 |  | ENDPOINT | Clipboard.GetDataObject | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-67ac7fa1 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4287 |  | COMBO_DATA | data.GetFormats | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-08d58d54 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4291 |  | ENDPOINT | data.GetDataPresent | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-658602d1 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4293 | if (data.GetDataPresent(typeof(System.String))) | ENDPOINT | data.GetData | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-31386d4e | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4297 | if (data.GetDataPresent(typeof(System.String))) | CALL_EXT | src_string.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6213d37 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4313 | if (data.GetDataPresent(typeof(System.String))) ▸ if (MaxColCount > 0 && ClipRowCount > 0) | FLAG | ClipData | new string[ClipRowCount, MaxColCount] | 화면 필드/플래그 변경 |  |  |  |
| AC-66703170 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4324 | if (data.GetDataPresent(typeof(System.String))) ▸ if (MaxColCount > 0 && ClipRowCount > 0) ▸ for (i < ClipRowCount) ▸ for (j < cells.Length) | DATA_OP | ClipData[i, j] | cell | 행/컬럼 값 대입 |  |  |  |
| AC-b3533153 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4336 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a93a36c | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4337 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd0f1d48 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4342 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-65354f51 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4355 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | GRID_SET | siMain.ActiveSheet.Cells[startrow, startcol].Value | src_copy | 그리드 속성/값 설정 |  |  |  |
| AC-762c5522 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4362 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-098d92f7 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4365 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1603bb39 | this.spdMain.ClipboardPasting | FP00622_PlanAmend_Line_NJ_Pouch.cs:4367 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f43f659 | this.spdMain.DragFillBlockCompleted | FP00622_PlanAmend_Line_NJ_Pouch.cs:4195 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb1edb1e | this.spdMain.EditChange | FP00622_PlanAmend_Line_NJ_Pouch.cs:4012 |  | VALUE_SET | tbLog.Text | "spdMain_EditChange" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48fff388 | this.spdMain.EditModeOff | FP00622_PlanAmend_Line_NJ_Pouch.cs:4213 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea09ab82 | this.spdMain.EditModeOn | FP00622_PlanAmend_Line_NJ_Pouch.cs:4219 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-58ec7bc9 | this.spdMain.EditModeOn | FP00622_PlanAmend_Line_NJ_Pouch.cs:4220 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b094b44e | this.spdMain.EditorFocused | FP00622_PlanAmend_Line_NJ_Pouch.cs:4207 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26fbdb7b | this.spdMain.Enter | FP00622_PlanAmend_Line_NJ_Pouch.cs:4170 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f6be77a | this.spdMain.KeyDown | FP00622_PlanAmend_Line_NJ_Pouch.cs:4118 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be16a32c | this.spdMain.Leave | FP00622_PlanAmend_Line_NJ_Pouch.cs:4165 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35621808 | this.spdMain.SubEditorClosed | FP00622_PlanAmend_Line_NJ_Pouch.cs:4201 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31d6d47c | this.spdMain.SubEditorOpening | FP00622_PlanAmend_Line_NJ_Pouch.cs:4190 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_TableChanged

진입점: this.spdMain.TableChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64610712 | this.spdMain.TableChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:4002 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7fb168f | this.spdMain.TableChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:4005 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_TextChanged

진입점: this.spdMain.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33781db6 | this.spdMain.TextChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:3987 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a3fb41b | this.spdMain.TextChanged | FP00622_PlanAmend_Line_NJ_Pouch.cs:3990 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f51a979 | this.spdMain.Validated | FP00622_PlanAmend_Line_NJ_Pouch.cs:4175 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9d843c0 | this.spdMain.Validating | FP00622_PlanAmend_Line_NJ_Pouch.cs:4180 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.SwitchMemo

진입점: memo_menu.Click [if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af7a1675 | memo_menu.Click [if (day != null)] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7360 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e2db738 | memo_menu.Click [if (day != null)] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7377 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-98722414 | memo_menu.Click [if (day != null)] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7402 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6613cd5 | memo_menu.Click [if (day != null)] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7428 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-df4f67ac | memo_menu.Click [if (day != null)] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7430 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-cdbb7c06 | memo_menu.Click [if (day != null)] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7433 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-96e2edf0 | memo_menu.Click [if (day != null)] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7438 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-393023e0 | memo_menu.Click [if (day != null)] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7440 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4b398099 | memo_menu.Click [if (day != null)] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7472 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-be102598 | memo_menu.Click [if (day != null)] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7473 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-58998115 | memo_menu.Click [if (day != null)] 외 1 | FP00622_PlanAmend_Line_NJ_Pouch.cs:7475 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00622_PlanAmend_Line_NJ_Pouch.UIFindData

진입점: this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a86262e1 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:605 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd6986c5 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:606 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21195773 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:609 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-98063ee0 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:612 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-5d350bea | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:616 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan ID to proceed") | 메시지 표시 |  |  |  |
| AC-2bdb51f9 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:617 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e11773f | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:622 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f774fd94 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:635 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8307023d | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:636 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39aa02cb | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:639 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2c57aecb | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:643 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c5fdf6c1 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:644 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f50553a6 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:646 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f80796f | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:648 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-fe7a4efb | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:659 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1dd5a659 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:661 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-d8321646 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:661 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c928f616 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:674 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-330f05a2 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:676 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | Filter["COMPANY_ID"] | dsMain.Tables[0].Rows[0]["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-14a6077b | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:683 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… | STATE | btnWOWStatus.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-77e68890 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:685 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ else… | STATE | btnWOWStatus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b7c9de24 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:689 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b97a6ba7 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:691 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-916d9646 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:695 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ else… | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-34e2ea2d | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:697 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ else… | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fdbdc421 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:702 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-ce8e3360 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:706 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-c09f7ab8 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:707 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-84feaef1 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:710 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) ▸… | STATE | btnWOWStatus.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-243ff6ec | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:712 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) ▸… | STATE | btnWOWStatus.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-348e9e01 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:716 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) ▸… | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-14e4b376 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:718 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) ▸… | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-41bfc4cf | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:722 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) ▸… | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-44ada189 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:724 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) ▸… | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7c2e6710 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:726 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | " Plan ID: " + Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-c88b64fa | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:727 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6d2bbaf8 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:732 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-8dc254c0 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:733 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f0a58e45 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:734 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-2394ebea | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:737 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fde3ad79 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:751 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["DW_TABLE"] | "HIS_AMEND_PLAN_CELL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-6affe725 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:755 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | asyncProxy_dsTmp.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fe473188 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:757 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | asyncProxy_dsTmp.ExecuteAsync | (() => DataService.FP_ExecuteQuery("XpCommonAmend", "find_dwSubmit_check", Filter.Dictiona… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-157e674c | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:759 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ lambda | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_dwSubmit_check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6c762d26 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:764 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsTmp.Tables[0].Rows[… | STATE | txtReleaseAlert.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-1a2335ba | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:768 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (dsTmp.Tables[0].… | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-0210ada5 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:773 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-45d1bc1f | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:782 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-64610126 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:786 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-71ef9b6e | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:792 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-01bceef9 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:797 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8fc53d0b | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:798 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-13728f54 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:805 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e4cc9d2 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:808 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f7b522e | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:812 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-b4499e10 | this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog(… 외 4 | FP00622_PlanAmend_Line_NJ_Pouch.cs:816 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

