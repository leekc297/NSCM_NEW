# AS-IS 액션 대조표 — FP00614

> 원천: `Doc/asisfacts/screens/FP00614/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 770행 · 메서드 87 · 종류 DATA_OP 277 · UI_PROP 87 · FLAG 81 · RETURN 50 · VALUE_SET 50 · CALL_EXT 40 · UI_MISC 37 · COMBO_DATA 32 · POPUP 29 · GRID_SET 17 · MESSAGE 14 · GRID_INIT 13 · LIST_REBIND 9 · THROW 8 · ENDPOINT 7 · STATE 6 · GRID_STYLE 6 · CALL_BASE 4 · STATE_RESET 1 · GRID_LOCK 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 44


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46bd39eb | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3919 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-f793578c | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3925 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e10a88b4 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3933 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-2350601d | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3934 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-6689a122 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3935 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-f27c4d3a | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3936 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-8e6fd60f | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3938 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-2870958d | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3939 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-60edd855 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3940 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-df4cbd69 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3941 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-a5b27f9a | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3942 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-f2a44a85 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3943 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-9473c969 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3944 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0c525a1 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3945 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-fc725da1 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3948 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-9f472439 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4133 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-8fbbf19f | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4134 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-97a14683 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4135 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-fc801fad | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4136 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-d6f1c2bd | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4138 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf87a7ef | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4139 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-58959744 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4140 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-63d3afc7 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4141 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-b62673a2 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4142 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-c663556d | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4143 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-3f727866 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4144 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-1cc5f7f4 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4145 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-69636403 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4147 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4107b4e | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4052 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-276ebfee | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4053 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ca9f597 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4054 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-356a9eeb | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4055 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-38b0cb09 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4056 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-22c53feb | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4059 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9e67a37 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4063 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4fe1e18 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4064 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6dffe3ab | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4050 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-1f308186 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4080 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-89a507ad | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4083 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c9003da | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4086 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-96a07dc6 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4089 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-c31b1570 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4092 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-f20b62c7 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4095 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-4c51bd64 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4101 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-301bd25b | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4103 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b73b3452 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4024 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95b315be | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3988 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f0759d5 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3989 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ab40bd0 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3990 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-46619553 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3991 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d3328650 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3992 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-53c3521a | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3993 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0212bf47 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3995 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-78840cf0 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3996 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-44a0717c | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3999 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8012cb4b | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4000 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-27952dc5 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4001 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c3d4889d | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3986 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-c4419c11 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4009 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4c670df | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4010 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fbcf828 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:4015 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c84e0ebe | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3961 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00614_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8eea865d | .ctor | FP00614_BucketSetForm_Popup.cs:70 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-60c12c47 | .ctor | FP00614_BucketSetForm_Popup.cs:71 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-b9b5c595 | .ctor | FP00614_BucketSetForm_Popup.cs:72 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-9fe50b78 | .ctor | FP00614_BucketSetForm_Popup.cs:74 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00614_BucketSetForm_Popup.chk_week_CheckedChanged

진입점: this.chk_week.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0972012a | this.chk_week.CheckedChanged | FP00614_BucketSetForm_Popup.cs:232 | if (chk_week.Checked) | STATE | chk_week_sun.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f9ff106a | this.chk_week.CheckedChanged | FP00614_BucketSetForm_Popup.cs:234 | else of (chk_week.Checked) | STATE | chk_week_sun.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00614_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63a59ae4 | Dispose | FP00614_BucketSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00614_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa141a71 | this.Load | FP00614_BucketSetForm_Popup.cs:98 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00614_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d634ecea | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:144 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-865db7c2 | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:145 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae956aa9 | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:147 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-6eab6fdf | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:148 |  | DATA_OP | ctrls.Add | (chk_totalBatch) | 데이터 객체 조작/조회 |  |  |  |
| AC-890a1b1b | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:149 |  | DATA_OP | ctrls.Add | (chk_week_sun) | 데이터 객체 조작/조회 |  |  |  |
| AC-09f31ee8 | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:153 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-4a0bf536 | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:153 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-f51af397 | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:160 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-a7161e1e | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:164 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-8e20d57d | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:168 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00614_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a6c0f5d | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:115 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7a97fff6 | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-41a7e5c5 | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e9ec5de0 | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_totalBatch.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-40f77e2b | this.Load 외 1 | FP00614_BucketSetForm_Popup.cs:119 |  | VALUE_SET | chk_week_sun.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00614_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2608985c | (진입점 미연결) | FP00614_BucketSetForm_Popup.cs:239 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-92803346 | (진입점 미연결) | FP00614_BucketSetForm_Popup.cs:241 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00614_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e6dc356 | this.Load | FP00614_BucketSetForm_Popup.cs:85 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-341b3ecb | this.Load | FP00614_BucketSetForm_Popup.cs:93 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00614_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cf03784 | this.usrButton1.Click | FP00614_BucketSetForm_Popup.cs:212 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-afdeeac4 | this.usrButton1.Click | FP00614_BucketSetForm_Popup.cs:212 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-a5672547 | this.usrButton1.Click | FP00614_BucketSetForm_Popup.cs:214 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-0809be09 | this.usrButton1.Click | FP00614_BucketSetForm_Popup.cs:218 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-9a8e4c27 | this.usrButton1.Click | FP00614_BucketSetForm_Popup.cs:219 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-1afd4f00 | this.usrButton1.Click | FP00614_BucketSetForm_Popup.cs:221 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d2f54fa | this.usrButton1.Click | FP00614_BucketSetForm_Popup.cs:223 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-4c6a3da5 | this.usrButton1.Click | FP00614_BucketSetForm_Popup.cs:225 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-e5199506 | this.usrButton1.Click | FP00614_BucketSetForm_Popup.cs:226 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00614_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72bb95a9 | this.usrButton2.Click | FP00614_BucketSetForm_Popup.cs:186 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-ca5aa2e5 | this.usrButton2.Click | FP00614_BucketSetForm_Popup.cs:186 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-e225e384 | this.usrButton2.Click | FP00614_BucketSetForm_Popup.cs:188 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-0f71f541 | this.usrButton2.Click | FP00614_BucketSetForm_Popup.cs:192 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-a80390ce | this.usrButton2.Click | FP00614_BucketSetForm_Popup.cs:193 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-26d7ad8e | this.usrButton2.Click | FP00614_BucketSetForm_Popup.cs:194 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-b9953dc9 | this.usrButton2.Click | FP00614_BucketSetForm_Popup.cs:195 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00614_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33c6a172 | .ctor | FP00614_MeasureSetForm_Popup.cs:79 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-7e5b8e43 | .ctor | FP00614_MeasureSetForm_Popup.cs:80 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-2584db4c | .ctor | FP00614_MeasureSetForm_Popup.cs:81 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-f0822fa1 | .ctor | FP00614_MeasureSetForm_Popup.cs:83 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00614_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efba8dd6 | this.btnOK.Click | FP00614_MeasureSetForm_Popup.cs:388 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-a762193a | this.btnOK.Click | FP00614_MeasureSetForm_Popup.cs:389 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-e3298ef2 | this.btnOK.Click | FP00614_MeasureSetForm_Popup.cs:396 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-0084627c | this.btnOK.Click | FP00614_MeasureSetForm_Popup.cs:397 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00614_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-851f0a2e | this.btnSet.Click | FP00614_MeasureSetForm_Popup.cs:358 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-4061a030 | this.btnSet.Click | FP00614_MeasureSetForm_Popup.cs:359 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-c28a3397 | this.btnSet.Click | FP00614_MeasureSetForm_Popup.cs:361 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-862b549e | this.btnSet.Click | FP00614_MeasureSetForm_Popup.cs:362 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5014af5 | this.btnSet.Click | FP00614_MeasureSetForm_Popup.cs:364 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-3199baf8 | this.btnSet.Click | FP00614_MeasureSetForm_Popup.cs:366 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-df363b0f | this.btnSet.Click | FP00614_MeasureSetForm_Popup.cs:367 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00614_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b5a44e6 | Dispose | FP00614_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00614_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4676dbb8 | this.Load | FP00614_MeasureSetForm_Popup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00614_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f08714bd | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d8871d2 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:242 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-15acb59c | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_result_in) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cac07e6 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_result_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0c095eb | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:246 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-25eedb55 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-ebc6f0f8 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:249 |  | DATA_OP | ctrls.Add | (chk_gap_in) | 데이터 객체 조작/조회 |  |  |  |
| AC-50bdda56 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_gap_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca40c523 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:252 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5c44196 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:253 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f69d05d | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:256 |  | DATA_OP | ctrls.Add | (chk_seq) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6f617e5 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:257 |  | DATA_OP | ctrls.Add | (chk_offtime) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ee620b8 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:258 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-689c0891 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:263 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce538882 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:264 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-75811c8e | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:265 |  | DATA_OP | ctrls.Add | (chk_result_in_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-77934f6e | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:266 |  | DATA_OP | ctrls.Add | (chk_result_out_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-3dfbdcaf | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:268 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3add7e3 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:269 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-77f20021 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:272 |  | DATA_OP | ctrls.Add | (chk_gap_in_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e174dc2 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:273 |  | DATA_OP | ctrls.Add | (chk_gap_out_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c69a6eb | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:275 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a4707e0 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:276 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-749b1ab4 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:277 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-50539fbe | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:279 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-8587e3af | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:280 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-685c9b67 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:283 |  | DATA_OP | ctrls.Add | (chk_pc) | 데이터 객체 조작/조회 |  |  |  |
| AC-379b1c6c | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:284 |  | DATA_OP | ctrls.Add | (chk_jr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c87629f2 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:285 |  | DATA_OP | ctrls.Add | (chk_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-6650cee0 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:286 |  | DATA_OP | ctrls.Add | (chk_batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6a49d65 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:289 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d891670 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:289 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-65c003d1 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:298 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-ae9372de | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:302 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |

## FP00614_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c77abb1 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-696281d5 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7cc51895 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_result_in.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0f9db9bc | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_result_out.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c81eca2e | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-537471ca | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6a04b183 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_gap_in.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-829dedac | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_gap_out.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e98fb597 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d5f346d9 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-37596e55 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_seq.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-61e1b836 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_offtime.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b707b78e | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6661b45c | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-67f383b3 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3d3d4447 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:168 |  | VALUE_SET | chk_result_in_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3f09eb67 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_result_out_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a388637f | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:171 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-09b45b2d | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:172 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4e1904d5 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:176 |  | VALUE_SET | chk_gap_in_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-77402e10 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:177 |  | VALUE_SET | chk_gap_out_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-837663d0 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:179 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f864933a | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:180 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bec3de5e | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:181 |  | VALUE_SET | chk_memo_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-62af4f1c | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:183 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f98b66af | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:184 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ed6b5fbd | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:188 |  | VALUE_SET | chk_pc.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3a577ab3 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:189 |  | VALUE_SET | chk_jr.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5f348759 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:190 |  | VALUE_SET | chk_cell.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-cfffa2c2 | this.Load 외 1 | FP00614_MeasureSetForm_Popup.cs:191 |  | VALUE_SET | chk_batch.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00614_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62d94160 | (진입점 미연결) | FP00614_MeasureSetForm_Popup.cs:451 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-cc052621 | (진입점 미연결) | FP00614_MeasureSetForm_Popup.cs:453 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00614_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4729e69c | this.Load | FP00614_MeasureSetForm_Popup.cs:94 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-03283226 | this.Load | FP00614_MeasureSetForm_Popup.cs:102 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00614_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d777a2dc | this.btnSet.Click 외 1 | FP00614_MeasureSetForm_Popup.cs:403 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c281f462 | this.btnSet.Click 외 1 | FP00614_MeasureSetForm_Popup.cs:411 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-a51a7230 | this.btnSet.Click 외 1 | FP00614_MeasureSetForm_Popup.cs:411 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-083b110e | this.btnSet.Click 외 1 | FP00614_MeasureSetForm_Popup.cs:428 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7bb1741c | this.btnSet.Click 외 1 | FP00614_MeasureSetForm_Popup.cs:439 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad025744 | .ctor | FP00614_PlanBy_Line_Electrode.cs:202 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00614_PlanBy_Line_Electrode.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "FP00614_Amend") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67afcb37 | popSql.OnSql [if (programID == "FP00614_Amend") ▸ try] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1135 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; DataTable dtWeekMonth = null; string… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e869b47 | popSql.OnSql [if (programID == "FP00614_Amend") ▸ try] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1142 | lambda | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (GetFilter("INSTANCE_ID") == "") { SetFilter("INSTANCE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-54912286 | popSql.OnSql [if (programID == "FP00614_Amend") ▸ try] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1151 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-c831653a | popSql.OnSql [if (programID == "FP00614_Amend") ▸ try] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1152 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-1cd5cf72 | popSql.OnSql [if (programID == "FP00614_Amend") ▸ try] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1162 | lambda ▸ if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_day2WeekAndMonth", Filter["BUCKET_FROM"], Filter["BUCKET_TO… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bca3f34d | popSql.OnSql [if (programID == "FP00614_Amend") ▸ try] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1166 | lambda ▸ else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_day2WeekAndMonth", Filter["BUCKET_FROM"], Filter["BUCKET_TO… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a8f03c36 | popSql.OnSql [if (programID == "FP00614_Amend") ▸ try] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1230 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_currDateCol", Filter["INSTANCE_ID"], Filter["BUCKET_FROM"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00614_PlanBy_Line_Electrode.btn_setupinfo_Click

진입점: this.brnSetupColor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd58d631 | this.brnSetupColor.Click | FP00614_PlanBy_Line_Electrode.cs:3152 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-83980af3 | this.brnSetupColor.Click | FP00614_PlanBy_Line_Electrode.cs:3153 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a2eeca34 | this.brnSetupColor.Click | FP00614_PlanBy_Line_Electrode.cs:3159 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-968cda3e | this.brnSetupColor.Click | FP00614_PlanBy_Line_Electrode.cs:3162 |  | POPUP | new FPC0108_btn_setupinfoPopup | (Filter["INSTANCE_ID"]) | 팝업/폼 생성 |  |  |  |
| AC-c6919988 | this.brnSetupColor.Click | FP00614_PlanBy_Line_Electrode.cs:3164 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-85f8a457 | this.brnSetupColor.Click | FP00614_PlanBy_Line_Electrode.cs:3165 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00614_PlanBy_Line_Electrode.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a04b15bd | this.btnBucket.Click | FP00614_PlanBy_Line_Electrode.cs:3067 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-cfae5bf0 | this.btnBucket.Click | FP00614_PlanBy_Line_Electrode.cs:3070 |  | FLAG | weekSunChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9a8fc356 | this.btnBucket.Click | FP00614_PlanBy_Line_Electrode.cs:3075 |  | POPUP | new FP00614_BucketSetForm_Popup | ("FP00614", SpdSheet.shtPlanByLineElectrode, false, "") | 팝업/폼 생성 |  |  |  |
| AC-263cd411 | this.btnBucket.Click | FP00614_PlanBy_Line_Electrode.cs:3076 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9c052f5f | this.btnBucket.Click | FP00614_PlanBy_Line_Electrode.cs:3077 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-0160a746 | this.btnBucket.Click | FP00614_PlanBy_Line_Electrode.cs:3078 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6d092d47 | this.btnBucket.Click | FP00614_PlanBy_Line_Electrode.cs:3083 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-68e44e93 | this.btnBucket.Click | FP00614_PlanBy_Line_Electrode.cs:3085 | if (frm.DialogResult == DialogResult.OK) ▸ if (measure["chk_week_sun"]!=null && week_sun != measure["chk_week_sun"].On) | FLAG | weekSunChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-365f8412 | this.btnBucket.Click | FP00614_PlanBy_Line_Electrode.cs:3107 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ i… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4e724c89 | this.btnBucket.Click | FP00614_PlanBy_Line_Electrode.cs:3116 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00614_PlanBy_Line_Electrode.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5da3ec1 | this.btnCatagory.Click | FP00614_PlanBy_Line_Electrode.cs:3007 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-041d0014 | this.btnCatagory.Click | FP00614_PlanBy_Line_Electrode.cs:3010 |  | POPUP | new FP00614_MeasureSetForm_Popup | ("FP00614", SpdSheet.shtPlanByLineElectrode, false, "") | 팝업/폼 생성 |  |  |  |
| AC-7aff3ceb | this.btnCatagory.Click | FP00614_PlanBy_Line_Electrode.cs:3011 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-5f148f86 | this.btnCatagory.Click | FP00614_PlanBy_Line_Electrode.cs:3012 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ec9859e5 | this.btnCatagory.Click | FP00614_PlanBy_Line_Electrode.cs:3013 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-77eb64a7 | this.btnCatagory.Click | FP00614_PlanBy_Line_Electrode.cs:3018 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-400b0771 | this.btnCatagory.Click | FP00614_PlanBy_Line_Electrode.cs:3030 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e1d09cf1 | this.btnCatagory.Click | FP00614_PlanBy_Line_Electrode.cs:3039 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d1f4ca6d | this.btnCatagory.Click | FP00614_PlanBy_Line_Electrode.cs:3044 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-d0cb9e19 | this.btnCatagory.Click | FP00614_PlanBy_Line_Electrode.cs:3050 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00614_PlanBy_Line_Electrode.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-908d4c4f | this.btnColumn.Click | FP00614_PlanBy_Line_Electrode.cs:2976 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-3093b6c8 | this.btnColumn.Click | FP00614_PlanBy_Line_Electrode.cs:2979 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00614", SpdSheet.shtPlanByLineElectrode, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-1190353f | this.btnColumn.Click | FP00614_PlanBy_Line_Electrode.cs:2980 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-64662072 | this.btnColumn.Click | FP00614_PlanBy_Line_Electrode.cs:2981 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-077987b1 | this.btnColumn.Click | FP00614_PlanBy_Line_Electrode.cs:2988 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-c6214300 | this.btnColumn.Click | FP00614_PlanBy_Line_Electrode.cs:2988 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanByLineElectrode) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c824781e | this.btnColumn.Click | FP00614_PlanBy_Line_Electrode.cs:2989 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-61841ae3 | this.btnColumn.Click | FP00614_PlanBy_Line_Electrode.cs:2995 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00614_PlanBy_Line_Electrode.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0aa87972 | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3175 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-5ef1761a | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3176 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b6e7b25 | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3179 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-705c31c1 | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3181 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-9f959b47 | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3182 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-adac44cd | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3183 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-1acb8a95 | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3184 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-922c2c6f | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3185 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d8733f9c | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3185 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6dbb25ae | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3186 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a537110e | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3187 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2c53f091 | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3188 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-0342788b | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3189 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f046ddd8 | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3190 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-17f74f1a | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3191 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-656944e2 | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3192 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a90653ab | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3193 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-77f48a00 | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3194 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3f2ba744 | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3196 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-93d5d43d | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3197 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-e55c3f8c | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3198 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-717cbb79 | this.btnMemo.Click | FP00614_PlanBy_Line_Electrode.cs:3199 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00614_PlanBy_Line_Electrode.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-679737d3 | this.btnPlanInfo.Click | FP00614_PlanBy_Line_Electrode.cs:3126 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-756f6e4e | this.btnPlanInfo.Click | FP00614_PlanBy_Line_Electrode.cs:3127 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a69f3db | this.btnPlanInfo.Click | FP00614_PlanBy_Line_Electrode.cs:3133 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-9e20f1f1 | this.btnPlanInfo.Click | FP00614_PlanBy_Line_Electrode.cs:3136 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b3410647 | this.btnPlanInfo.Click | FP00614_PlanBy_Line_Electrode.cs:3137 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-74b473cd | this.btnPlanInfo.Click | FP00614_PlanBy_Line_Electrode.cs:3137 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0632ae4d | this.btnPlanInfo.Click | FP00614_PlanBy_Line_Electrode.cs:3138 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-ad394ae1 | this.btnPlanInfo.Click | FP00614_PlanBy_Line_Electrode.cs:3139 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-362f53b0 | this.btnPlanInfo.Click | FP00614_PlanBy_Line_Electrode.cs:3141 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-78604054 | this.btnPlanInfo.Click | FP00614_PlanBy_Line_Electrode.cs:3142 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00614_PlanBy_Line_Electrode.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-375899be | this.btnSql.Click | FP00614_PlanBy_Line_Electrode.cs:3210 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-4b7b56aa | this.btnSql.Click | FP00614_PlanBy_Line_Electrode.cs:3213 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e3acca52 | this.btnSql.Click | FP00614_PlanBy_Line_Electrode.cs:3214 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6bd1029e | this.btnSql.Click | FP00614_PlanBy_Line_Electrode.cs:3216 |  | DATA_OP | popSql.Services.Add | ("FP00614_" + SpdSheet.shtPlanByLineElectrode) | 데이터 객체 조작/조회 |  |  |  |
| AC-af4c4882 | this.btnSql.Click | FP00614_PlanBy_Line_Electrode.cs:3219 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00614_PlanBy_Line_Electrode.CheckAndGetMeasure

진입점: this.Load / popSql.OnSql [if (programID == "FP00614_Amend") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5eccb5e7 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2644 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-4af87e24 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2644 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-fd4c6590 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2646 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00614_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cbe975c8 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2646 |  | POPUP | new FP00614_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-d5b2113e | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2647 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00614_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f19e61ac | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2647 |  | POPUP | new FP00614_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4bc45860 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2651 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-55a3986d | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2652 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-0f018055 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2653 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d760b8c | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2654 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-d65c6166 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2655 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-27afa3d8 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2656 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |
| AC-9917f1c0 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2657 |  | DATA_OP | measure.Data.ContainsKey | ("chk_totalBatch") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd5ff4a6 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2658 | if (measure.Data.ContainsKey("chk_totalBatch")) | FLAG | weekTOT_measure | measure.Data["chk_totalBatch"] | 화면 필드/플래그 변경 |  |  |  |
| AC-b2595090 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2659 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week_sun") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b8d6f63 | this.Load 외 4 | FP00614_PlanBy_Line_Electrode.cs:2660 | if (measure.Data.ContainsKey("chk_week_sun")) | FLAG | week_measure_sun | measure.Data["chk_week_sun"] | 화면 필드/플래그 변경 |  |  |  |

## FP00614_PlanBy_Line_Electrode.CreateFilterDataSet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain.Good())] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (m…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f636d3c4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1820 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f2a7a0d0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1832 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-76f3d008 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1833 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-1142a565 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1861 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-70ff3533 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1866 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-286cc42c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1871 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-42b361b1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1876 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc1f34c7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1884 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-70f04484 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1889 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c60f5c6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1894 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a4f5ca8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1899 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-46071c31 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1907 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-517a8fe0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1912 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b651a11e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1917 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c30711a1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1922 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c4391f4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1930 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b28627e6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1935 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-04d8aba5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1940 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-846d1bde | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1945 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e636b05e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1953 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8fc5e28c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1958 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c481595c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1963 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-01215d0d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1968 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-42027a0a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1976 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-46c5f84c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1981 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fdc61fe6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1986 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8adb1db8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1991 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5ff7126 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1999 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2e015c8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2004 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1025fe90 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2009 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-762fe515 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2014 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a713fe9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2022 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-74fb61f8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2027 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-43f96d76 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2032 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ba02908 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2037 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-32b8314d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2045 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-81006d69 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2050 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3592cafd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2055 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b962305e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2060 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-298c0023 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2068 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bdd09cb8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2073 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a08faa9e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2078 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ccbaf0ba | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2083 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-19613c0a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2094 | if (measure["chk_seq"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_SEQ")) | 데이터 객체 조작/조회 |  |  |  |
| AC-84cfc6cb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2100 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4ad44bd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2106 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4bd0abe | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2119 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a66ebed | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2124 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-83a9ef71 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2129 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-82f0328a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2134 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9dc0bdfd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2142 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-774bac94 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2147 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-eeb0dd49 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2152 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-22382bf0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2157 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e16b3dfe | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2165 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-982ef274 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2170 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2036ada | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2175 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b90a1bf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2180 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6faaf5ba | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2188 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e784d8d3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2193 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc9a86e1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2198 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ede7adb0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2203 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-397621f0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2211 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-af0c913c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2216 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef9488e7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2221 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a09191f5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2226 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-547ae187 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2234 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ebf16a8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2239 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-77360bab | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2244 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3bdbd532 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2249 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c983666 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2258 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d654e2cd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2263 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd782909 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2268 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f368bc48 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2273 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb2da0f9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2282 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b1be1d2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2287 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7709a70c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2292 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4b32d8d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2297 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-305a7818 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2306 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6ea0f85 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2311 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f9c6533 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2316 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3043b61 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2321 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-533fbd90 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2329 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5bd5472c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2334 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc518be3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2339 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-66fcfbba | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2344 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d03a8cb5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2356 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_memo_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", MEMO_COLUMN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0cd26201 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2364 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-83baaf91 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2369 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-85e02ada | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2374 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6589ccdb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2379 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e76b86dc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2387 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true"… | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e989b492 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2392 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9555330 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2397 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e15143b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2402 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c84c886 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2410 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b73623c3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2415 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c842db2f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2420 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aebd200f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2425 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-34a2091d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2433 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true"… | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd97f84a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2438 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc2f0869 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2443 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7c755e2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2448 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce6655c9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2456 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ff71d68 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2461 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5ac12fb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2466 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7df6f059 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2471 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e19db40 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2479 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-10fdccf0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2484 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c11df097 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2489 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0815df8e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2494 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3180927 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2502 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a188bb4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2507 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a532005 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2512 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-edc1cd11 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2517 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ff37653 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2525 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true"… | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3a82182 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2530 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a2261cf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2535 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb80838a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2540 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-329ce08d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2548 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-28aba4c2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2553 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec32d7f8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2558 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-426d420c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2563 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f06ec97 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2571 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2ef7407 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2576 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e76ece56 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2581 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-86c139c7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2586 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f7c3e6a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2614 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f9474155 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2617 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-403f37cf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2621 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-f10269f5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2626 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8c9e9098 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2630 | else of (m != null && m.Count() > 0) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-71beab7e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2630 | else of (m != null && m.Count() > 0) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-9f659869 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2635 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e549d24 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2637 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e937be92 | this.Load | FP00614_PlanBy_Line_Electrode.cs:427 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanByLineElectrode, SpdSheet.shtPlanByLineElectrode, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-292f89c9 | this.Load | FP00614_PlanBy_Line_Electrode.cs:428 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanByLineElectrode) | 화면 필드/플래그 변경 |  |  |  |
| AC-8ba63762 | this.Load | FP00614_PlanBy_Line_Electrode.cs:429 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanByLineElectrode) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9111c724 | this.Load | FP00614_PlanBy_Line_Electrode.cs:432 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e7ae69ac | this.Load | FP00614_PlanBy_Line_Electrode.cs:434 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00614_PlanBy_Line_Electrode.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-116efd0e | dCalendar_planrange.ValueChanged | FP00614_PlanBy_Line_Electrode.cs:2924 | if (sender == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7da3b1b2 | dCalendar_planrange.ValueChanged | FP00614_PlanBy_Line_Electrode.cs:2934 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-54c66cfb | dCalendar_planrange.ValueChanged | FP00614_PlanBy_Line_Electrode.cs:2938 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date.") | 메시지 표시 |  |  |  |
| AC-130371bf | dCalendar_planrange.ValueChanged | FP00614_PlanBy_Line_Electrode.cs:2939 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51ec5386 | DeleteButton | FP00614_PlanBy_Line_Electrode.cs:636 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3495c78b | DeleteButton | FP00614_PlanBy_Line_Electrode.cs:637 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dca428d4 | Dispose | FP00614_PlanBy_Line_Electrode.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00614_PlanBy_Line_Electrode.DoColumnFormat

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ac383a7 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:716 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.DrawHeader

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-758b390b | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1621 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-aceb1d5b | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1625 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-3ab7b37e | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1626 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9392b49f | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1627 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b28ef12 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1629 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-b16f0ca0 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1633 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-2e9d8b8f | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1634 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-9b17fe90 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1635 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-939ebaea | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1636 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-14520cbf | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1648 | else of (with_day_part == false) | CALL_EXT | measure.Data.TryGetValue | ("chk_totalBatch", out total_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa4f168a | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1662 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(bUse_month, bUse_week, bUse_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-458a8f5a | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1666 | else of (with_day_part == false) ▸ if (bUse_total) | FLAG | DayColumnCount | += (calendar.weeks.Count) | 화면 필드/플래그 변경 |  |  |  |
| AC-97f14d37 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1671 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bab258e4 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1730 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanByLineElectrode, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f9ab2a0e | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1736 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) | CALL_EXT | measure.Data.TryGetValue | ("chk_totalBatch", out tmpMeasure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-76101c86 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1740 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) ▸ if (measure.Data.TryGetValue("chk_totalBatch", o… | FLAG | _amendColumnsCnt | measure.AmendColumns.Rows.Count + calendar.weeks.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-f8187219 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1744 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) ▸ if (measure.Data.TryGetValue("chk_totalBatch", o… | FLAG | _amendColumnsCnt | measure.AmendColumns.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-287d417f | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1749 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) ▸ else of (measure.Data.TryGetValue("chk_totalBatc… | FLAG | _amendColumnsCnt | measure.AmendColumns.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-5cd751ad | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1759 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | DayColumnCount | siMain.SetAmendHeaderColumnWithTotal_FP(calendar, bUse_month, bUse_week, bUse_day, bUse_to… | 화면 필드/플래그 변경 |  |  |  |
| AC-23316a3b | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1759 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumnWithTotal_FP | (calendar, bUse_month, bUse_week, bUse_day, bUse_total, 2, FPExtensions.DateColumnType.TYP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-176d28e7 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1763 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1f61525 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1765 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-402dd8f5 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1766 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-923749a7 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1769 | else of (with_day_part == false) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-605d41d6 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1777 | else of (with_day_part == false) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | froz | 그리드 속성/값 설정 |  |  |  |
| AC-5f2a2db2 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1779 | else of (with_day_part == false) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-8c0770b1 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1780 | else of (with_day_part == false) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-27f4e895 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1785 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-c813186f | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1791 | if (!with_day_part) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c2e2d58 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:1792 | if (!with_day_part) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00614_PlanBy_Line_Electrode.DrawSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c33e3158 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1401 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fbe2820a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1403 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7f94918 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1418 | while (found) | DATA_OP | in_Dataset.Tables[0].Columns.Contains | (candidate) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e66f1c6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1434 | foreach (DataRow row in in_Dataset.Tables[0].Rows) | DATA_OP | category_name.Contains | ("Accu.") | 데이터 객체 조작/조회 |  |  |  |
| AC-7750651e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1440 | foreach (DataRow row in in_Dataset.Tables[0].Rows) ▸ if (category_name.Contains("Accu.") && measure_name == "Batch") ▸ for (k<batchCnt) ▸ if… | DATA_OP | row[total_batch_column] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-fc2073d9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1466 |  | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c3e28b8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1468 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00614_PlanBy_Line_Electrode.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4888d516 | EditButton | FP00614_PlanBy_Line_Electrode.cs:643 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6359acf | EditButton | FP00614_PlanBy_Line_Electrode.cs:644 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fe42f7d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00614_PlanBy_Line_Electrode.cs:689 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7246d22 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00614_PlanBy_Line_Electrode.cs:693 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-74127cf6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00614_PlanBy_Line_Electrode.cs:697 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-78d0d630 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00614_PlanBy_Line_Electrode.cs:701 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00614_PlanBy_Line_Electrode.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee598885 | ExcelButton | FP00614_PlanBy_Line_Electrode.cs:658 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-b3be5fdb | ExcelButton | FP00614_PlanBy_Line_Electrode.cs:659 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-56a9c040 | ExcelButton | FP00614_PlanBy_Line_Electrode.cs:661 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6c74f502 | ExcelButton | FP00614_PlanBy_Line_Electrode.cs:665 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-cf322250 | ExcelButton | FP00614_PlanBy_Line_Electrode.cs:666 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-019c4bc6 | ExcelButton | FP00614_PlanBy_Line_Electrode.cs:667 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-d84ccace | ExcelButton | FP00614_PlanBy_Line_Electrode.cs:671 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-96edc58d | ExcelButton | FP00614_PlanBy_Line_Electrode.cs:672 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-6c636634 | ExcelButton | FP00614_PlanBy_Line_Electrode.cs:673 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-b8416b30 | ExcelButton | FP00614_PlanBy_Line_Electrode.cs:675 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-c206a933 | ExcelButton | FP00614_PlanBy_Line_Electrode.cs:676 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "FP00614_Amend")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ lambda] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32fbcbe1 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1018 | try | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e06dea7f | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1019 | try | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-09bb3291 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1021 | try | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7cf1bfc5 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1022 | try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5166e63a | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1023 | try | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5edc2d8e | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1024 | try | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-aeb8b628 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1031 | try ▸ if (week_measure_sun!=null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ec2b4528 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1032 | try ▸ if (week_measure_sun!=null && week_measure_sun.On) | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-e099a6e2 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1033 | try ▸ if (week_measure_sun!=null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3107a8b6 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1034 | try ▸ if (week_measure_sun!=null && week_measure_sun.On) | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b78ada4a | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1038 | try ▸ else of (week_measure_sun!=null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4fcc1977 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1039 | try ▸ else of (week_measure_sun!=null && week_measure_sun.On) | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-0939ca29 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1040 | try ▸ else of (week_measure_sun!=null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-976c2627 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1041 | try ▸ else of (week_measure_sun!=null && week_measure_sun.On) | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-06ec3dee | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1043 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7c958cee | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1044 | try | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-dbb15b69 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1049 | try ▸ if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a8a30ff | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1053 | try ▸ else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-611579b7 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1056 | try | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-125a8390 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1058 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00614_" + SpdSheet.shtPlanByLineElectrode) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aec6f7ad | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1059 | try | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-20c374c9 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1061 | try | CALL_EXT | DataService.ToLoopParam2 | ("", Data_FP.CallGeneralProcedure2(("PR_UI_FP00612_ETC").ToUpper(), Filter, _CurrentUser, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c061d1b | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1061 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00612_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "CURR_DATE_COL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-acbe6bb5 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1069 | try ▸ if (D_COL[0] != "") ▸ if (D_COL_DATA[1] != "") | DATA_OP | Filter["CURR_DATE_COL"] | D_COL_DATA[1] | 행/컬럼 값 대입 |  |  |  |
| AC-b1489272 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1079 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c81ea395 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1080 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-da9975ce | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1082 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e78ae8ae | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1083 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8224654b | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1095 | try ▸ if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMea… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-c3d3b78f | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1101 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e80003a1 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1102 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b677c81d | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1103 | try | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8ac0bdac | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1105 | try | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-0ac57c5b | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1106 | try | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-f9fee101 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1107 | try | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-ea2c170d | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1108 | try | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-1f196216 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1109 | try | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-418d5e16 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1110 | try | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-3d9d8864 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1111 | try | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |
| AC-2a42b7d1 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1117 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00614_FIND_FP00614", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f247a8c2 | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1119 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-e7f6f1da | popSql.OnSql [if (programID == "FP00614_Amend")] 외 3 | FP00614_PlanBy_Line_Electrode.cs:1123 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.Find_Data_Memo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41221a77 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:2822 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00614_FIND_FP00614", Filter, _CurrentUser, pSysType, "SELECT_MEA_MEMO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c0fc8da1 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:2824 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-4efb31e4 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:2828 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.FindTotalColorStart

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5d12670 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1814 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08e3b220 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:725 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c5a3b4c | this.Load | FP00614_PlanBy_Line_Electrode.cs:217 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00614_PlanBy_Line_Electrode.GetFilter

진입점: popSql.OnSql [if (programID == "FP00614_Amend") ▸ try ▸ lambda ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c10f254b | popSql.OnSql [if (programID == "FP00614_Amend") ▸ try ▸ lamb… 외 3 | FP00614_PlanBy_Line_Electrode.cs:3616 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.GetFpPlanInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1daa4279 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3737 |  | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00614_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-e624203d | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3737 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00614_findFpPlan_info", sInstance, Filter["PLAN_DATE"].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00614_PlanBy_Line_Electrode.GetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2f2daeb | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3624 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c37600a0 | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3625 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a506bf6 | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3625 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-cef7d9a9 | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3627 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-3b389dd8 | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3629 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2c8fc32a | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3632 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-7a67d0fd | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3633 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-1e66be65 | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3633 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-be573a2c | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3634 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-079e0274 | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3635 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d9e72704 | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3636 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-83496073 | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3640 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00614_PlanBy_Line_Electrode.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7200f379 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3869 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-4fd367ec | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3870 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.GetToDay

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cbdd0af | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3818 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-4e7ca72e | this.Load [try] | FP00614_PlanBy_Line_Electrode.cs:3819 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.GoDrawCellColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3330186a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2666 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79349fe9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2730 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef5907e1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:2731 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d5eaca3 | this.Load | FP00614_PlanBy_Line_Electrode.cs:288 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a21dec1 | this.Load | FP00614_PlanBy_Line_Electrode.cs:291 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanByLineElectrode) | 데이터 객체 조작/조회 |  |  |  |
| AC-10739f82 | this.Load | FP00614_PlanBy_Line_Electrode.cs:293 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-bef2581f | this.Load | FP00614_PlanBy_Line_Electrode.cs:294 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-eacd5a80 | this.Load | FP00614_PlanBy_Line_Electrode.cs:297 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-13f2cd87 | this.Load | FP00614_PlanBy_Line_Electrode.cs:300 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-96064a21 | this.Load | FP00614_PlanBy_Line_Electrode.cs:322 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-b0451e4e | this.Load | FP00614_PlanBy_Line_Electrode.cs:323 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e7cf8083 | this.Load | FP00614_PlanBy_Line_Electrode.cs:324 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f18b5b1b | this.Load | FP00614_PlanBy_Line_Electrode.cs:330 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00614_PlanBy_Line_Electrode.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62e7de77 | this.Load | FP00614_PlanBy_Line_Electrode.cs:250 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f16bd055 | this.Load | FP00614_PlanBy_Line_Electrode.cs:251 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ac9b1651 | this.Load | FP00614_PlanBy_Line_Electrode.cs:252 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-bc1780e3 | this.Load | FP00614_PlanBy_Line_Electrode.cs:253 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-58e01310 | this.Load | FP00614_PlanBy_Line_Electrode.cs:254 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-feef5802 | this.Load | FP00614_PlanBy_Line_Electrode.cs:255 |  | UI_PROP | mcbo_prod_type.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-866f6333 | this.Load | FP00614_PlanBy_Line_Electrode.cs:276 |  | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode.InitSpread

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0cb9c60 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:444 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-db12a090 | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:445 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanByLineElectrode) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e46a7fea | this.Load 외 6 | FP00614_PlanBy_Line_Electrode.cs:449 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00614_PlanBy_Line_Electrode.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68334314 | InsertButton | FP00614_PlanBy_Line_Electrode.cs:628 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2695ba83 | InsertButton | FP00614_PlanBy_Line_Electrode.cs:629 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0e3fdc2 | memo_menu.Click | FP00614_PlanBy_Line_Electrode.cs:3543 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aaad45a0 | memo_menu.Click | FP00614_PlanBy_Line_Electrode.cs:3546 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63edc0ed | memo_menu.Click | FP00614_PlanBy_Line_Electrode.cs:3550 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00614_PlanBy_Line_Electrode.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70995e4a | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3565 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94e24b2f | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3568 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d00f8564 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3586 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-6096f90e | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3587 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-28f997bc | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3588 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fed60758 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3589 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-5a6733b4 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3590 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-c7867096 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3591 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-a733c85a | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3592 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-bfd0e02e | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3593 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-51a3e0e0 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3594 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00614_PlanBy_Line_Electrode.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37460a30 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3461 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9610e820 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3464 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-323984ed | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3488 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-826bdc00 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3502 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19731d3d | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3505 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c7bb9a0 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3529 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode.OpenLineMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d3a4320 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3228 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-e2afbc12 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3229 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-27c099f6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3230 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-fc80303b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3230 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bed83217 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3231 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-4429fe0f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3232 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-958f7f86 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3233 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2b373393 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3238 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c714e672 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3241 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode.OpenMaterialMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d096e537 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3247 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-4d1a3509 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3248 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-3b3f0b12 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3249 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-35309f87 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3249 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0a2b968a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3250 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-d6fc528d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3251 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9aa533a6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3252 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-26f2abb3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3256 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ec6b7eac | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00614_PlanBy_Line_Electrode.cs:3258 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00614_PlanBy_Line_Electrode.Query

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a00d3cc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1374 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-eb8bb1fa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1374 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c11653fd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1375 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-fbbb8111 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1375 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5ae9a458 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1376 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-c5d1174b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1376 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-07c5d9de | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1379 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f838ee3b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1386 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-59a48725 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1391 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0080a590 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1392 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9887704b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1394 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00614_PlanBy_Line_Electrode.RefreshHeadAndBody

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-902b022d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1343 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-44f08a5a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1359 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-be9d57ca | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1363 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00614_PlanBy_Line_Electrode.RefreshSpreadSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80eadcb9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1316 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-b7634b66 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1316 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-ef5860e8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1330 | if (dsMain.Good()) | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-de469f8a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1336 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00614_PlanBy_Line_Electrode.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cab6d84 | popSql.OnSql | FP00614_PlanBy_Line_Electrode.cs:3838 | if (programID == "FP00614_Amend") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-73dc97c9 | popSql.OnSql | FP00614_PlanBy_Line_Electrode.cs:3851 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dde028e | SaveButton | FP00614_PlanBy_Line_Electrode.cs:650 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6fa74fb7 | SaveButton | FP00614_PlanBy_Line_Electrode.cs:651 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SetCalenderColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23db67d7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1551 | if (calendar != null && dsMainFiltered.Good()) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On)… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e79e7ac | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1555 | if (calendar != null && dsMainFiltered.Good()) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On)… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | colorBlue | 그리드 속성/값 설정 |  |  |  |
| AC-c1b3e7c9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1557 | if (calendar != null && dsMainFiltered.Good()) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On)… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-be06ed90 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1561 | if (calendar != null && dsMainFiltered.Good()) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On)… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | colorRed | 그리드 속성/값 설정 |  |  |  |
| AC-86dadbab | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1577 | if (calendar != null && dsMainFiltered.Good()) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.O… | GRID_STYLE | siMain.SetBGColor2 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, colorLightGreen) | 그리드 표시 설정 |  |  |  |
| AC-02b7fe4f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1609 | if (calendar != null && dsMainFiltered.Good()) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure… | GRID_STYLE | siMain.SetBGColor2 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, colorLightPink) | 그리드 표시 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SetChangeControl

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / cbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / mcbo_prod_type.SelectedIndexChanged / chk_allLine.CheckedChanged / chk_IncludeSubOp.CheckedChanged / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.chk_IncludeSubOp.CheckedChanged / this.chkInAct.CheckedChanged / this.spdMain.CellDoubleCli…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-338f6491 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:341 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c7305c6d | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:341 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1c984947 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:350 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-703b589a | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:351 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-379c0ca5 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:351 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-eaa4cfef | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:352 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3bb7b354 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:358 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-19edba16 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:359 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a027e3ab | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:359 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a2c3e70d | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:360 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e610dbb2 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:366 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-714e12ea | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:367 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-628e097e | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:367 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ffc77533 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:368 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7b27f822 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:374 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c16d047c | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:375 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-2ed52bcc | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:375 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5a0e7e7c | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:376 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-80834d91 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:383 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-5600bc50 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:385 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-6f0409fb | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:386 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6216092d | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:387 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d90d8a26 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:388 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4dbe9810 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:389 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | GRID_SET | dtOperation.Rows[0]["CODE"] | "E2000" | 그리드 속성/값 설정 |  |  |  |
| AC-f450d3cd | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:390 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | GRID_SET | dtOperation.Rows[0]["NAME"] | "(E2000)Coating" | 그리드 속성/값 설정 |  |  |  |
| AC-b773f90d | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:392 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation,mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-446fc199 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:398 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-1a550542 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:399 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-29539d40 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:399 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-208a31bc | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:400 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2955de77 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:406 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-d1690728 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:413 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, mcbo_prod_type.ControlValues… | 행/컬럼 값 대입 |  |  |  |
| AC-1e67a330 | this.Load [try] 외 14 | FP00614_PlanBy_Line_Electrode.cs:413 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PROD_TYPE"] | CString.GetCheckedListValue(dtProdType, mcbo_prod_type.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SetColumnsFormat

진입점: this.Load [if (!with_day_part)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ if (!with_day_part)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df671d77 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:742 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dbce529b | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:763 | if (siMain != null) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (om… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b9c92f1 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:766 | if (siMain != null) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else o… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe757a6b | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:789 | if (siMain != null) ▸ if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20db5395 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:792 | if (siMain != null) ▸ if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e223820 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:817 | if (siMain != null) ▸ if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33255ef1 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:820 | if (siMain != null) ▸ if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ el… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e451e8e0 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:838 | if (siMain != null) ▸ if (calendar.Days != null) ▸ if (colindex != -1) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fabb9632 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:845 | if (siMain != null) ▸ if (calendar.Days != null) ▸ if (colindex != -1) ▸ for (i < weekCnt) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ac3e39a | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:860 | if (siMain != null) | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-1cf06468 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:876 | if (siMain != null) ▸ if (iFrozenIndex == -1 \|\| iCATEGORY_NAME == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9eefe6d | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:882 | if (siMain != null) | DATA_OP | listBatchInx.Add | (batchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-04c5f53d | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:910 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.ActiveSh… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-66365f16 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:911 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.ActiveSh… | DATA_OP | siMain.ActiveSheet.Cells[i, j].Value.ToString().Contains | ("-") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6f3f8bf | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:913 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.ActiveSh… | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d41b2c10 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:934 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ if (siMain.ActiveSh… | DATA_OP | listBatchInx.Add | (batchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-551f1735 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:941 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ if (siMain.ActiveSh… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-e2ab04ca | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:942 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ if (siMain.ActiveSh… | DATA_OP | siMain.ActiveSheet.Cells[i, j].Value.ToString().Contains | ("-") | 데이터 객체 조작/조회 |  |  |  |
| AC-1549cae7 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:944 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ if (siMain.ActiveSh… | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-a2ff547c | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:962 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) | DATA_OP | category_name.Contains | ("Accu.") | 데이터 객체 조작/조회 |  |  |  |
| AC-846f1dcf | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:974 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (category_name.Contains("Accu.")) ▸ if (measure_name == "Batch") ▸ for (j <… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-4c8e6e42 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:975 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (category_name.Contains("Accu.")) ▸ if (measure_name == "Batch") ▸ for (j <… | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-2daa661b | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:994 | if (siMain != null) ▸ if (ippm != -1) | UI_PROP | num_ppm.DecimalPlaces | place_ppm | 속성 DecimalPlaces 설정 |  |  |  |
| AC-6f612e36 | this.Load [if (!with_day_part)] 외 6 | FP00614_PlanBy_Line_Electrode.cs:995 | if (siMain != null) ▸ if (ippm != -1) | GRID_SET | siMain.ActiveSheet.Columns[ippm].CellType | num_ppm | 그리드 속성/값 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec69aa93 | this.Load | FP00614_PlanBy_Line_Electrode.cs:237 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9d127745 | this.Load | FP00614_PlanBy_Line_Electrode.cs:239 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-24c1e6fc | this.Load | FP00614_PlanBy_Line_Electrode.cs:243 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00614_PlanBy_Line_Electrode.SetDirty

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ finally] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ finally] / this.btnBucket.Click / this.btnCatagory.Click / this.btnColumn.Click / FindButton [try ▸ if (siMain.ActiveSheet.SheetName ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab0036fb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:731 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e821a18 | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3646 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2250e6ec | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3646 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4709584d | (진입점 미연결) | FP00614_PlanBy_Line_Electrode.cs:3647 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_factory.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9565886 | this.Load [try] 외 22 | FP00614_PlanBy_Line_Electrode.cs:3611 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SetPlanPeriod

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44dbef8f | this.Load [try] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3683 |  | FLAG | dtPeriod | Data_FP.Common_FP(Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-be8118c7 | this.Load [try] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3683 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fd04aecd | this.Load [try] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3698 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-4a950b44 | this.Load [try] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3699 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-fb8f34f0 | this.Load [try] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3703 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-ea59b591 | this.Load [try] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3704 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-9c04d2d5 | this.Load [try] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3710 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-9d6b8ebf | this.Load [try] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3711 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SetProdType

진입점: this.Load [try] / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42c10aee | this.Load [try] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3656 |  | FLAG | dtProdType | DataService.GetProdType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf7bf5f0 | this.Load [try] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3656 |  | CALL_EXT | DataService.GetProdType | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b19d6c2 | this.Load [try] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3658 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prod_type, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (mont…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56926cc1 | this.Load [try] 외 6 | FP00614_PlanBy_Line_Electrode.cs:457 | if (sheetName.Equals(SpdSheet.shtPlanByLineElectrode)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-88a24872 | this.Load [try] 외 6 | FP00614_PlanBy_Line_Electrode.cs:458 | if (sheetName.Equals(SpdSheet.shtPlanByLineElectrode)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SetTotalColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8646f97 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1513 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "DATA": ▸ if… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_version, line, idx_version, Color.Orange) | 그리드 표시 설정 |  |  |  |
| AC-bcf84c57 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00614_PlanBy_Line_Electrode.cs:1522 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00614_PlanBy_Line_Electrode.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbc93c57 | this.spdMain.CellClick | FP00614_PlanBy_Line_Electrode.cs:3438 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-eb2e3c52 | this.spdMain.CellClick | FP00614_PlanBy_Line_Electrode.cs:3439 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-2d2e1a55 | this.spdMain.CellClick | FP00614_PlanBy_Line_Electrode.cs:3441 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8d30c8b | this.spdMain.CellClick | FP00614_PlanBy_Line_Electrode.cs:3449 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00614_PlanBy_Line_Electrode.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ac61e70 | this.spdMain.CellDoubleClick | FP00614_PlanBy_Line_Electrode.cs:3403 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-706bf150 | this.spdMain.CellDoubleClick | FP00614_PlanBy_Line_Electrode.cs:3410 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00614_PlanBy_Line_Electrode.SwitchMemo

진입점: memo_menu.Click [try ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f867b486 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3268 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d79d43b | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3285 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-14ac5728 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3316 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-2e8edb8e | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3317 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-d77939e7 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3319 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-51be0e92 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3350 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-fd4b8bf2 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3351 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-88956661 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00614_PlanBy_Line_Electrode.cs:3353 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00614_PlanBy_Line_Electrode.UIFindData

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be8d38b4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:488 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f9751ea | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:489 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2568eaa6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:492 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-18aef971 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:501 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-baf13b7a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:516 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-957c6dcf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:517 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cdf6ff96 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:520 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e4ab56ea | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:524 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3bacc511 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:525 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1359be11 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:535 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-eca23f46 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:537 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-5a52c320 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:537 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-586bc838 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:550 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0… | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4726afd5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:561 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Coun… | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7a32df47 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:563 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Coun… | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ebd36d0e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:565 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Coun… | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-16100cd5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:571 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-d2d3fcf8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:573 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-467aa385 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:576 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0bfd7877 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:589 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-95c6a8a0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:594 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5ad8d9f2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:599 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-adefb565 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:600 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0cc78a2b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:608 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByLineElectrode) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-05d9d5ad | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:615 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-7bc68f17 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00614_PlanBy_Line_Electrode.cs:619 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

