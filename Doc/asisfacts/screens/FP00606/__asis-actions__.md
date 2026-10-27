# AS-IS 액션 대조표 — FP00606

> 원천: `Doc/asisfacts/screens/FP00606/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 790행 · 메서드 91 · 종류 DATA_OP 272 · UI_PROP 95 · FLAG 88 · RETURN 49 · VALUE_SET 48 · CALL_EXT 39 · COMBO_DATA 38 · UI_MISC 37 · POPUP 29 · GRID_SET 18 · MESSAGE 17 · GRID_INIT 13 · LIST_REBIND 13 · THROW 8 · ENDPOINT 7 · GRID_STYLE 7 · STATE 6 · CALL_BASE 3 · STATE_RESET 1 · GRID_LOCK 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 42


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b28dd5cf | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3969 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-b542c2c5 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3975 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-91e44c20 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3983 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-aabd9dcc | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3984 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-2fd60d7b | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3985 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-3128bc32 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3986 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-242140f4 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3988 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-77e78c22 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3989 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-d54af9f4 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3990 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-dddaa1e6 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3991 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-a259365b | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3992 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-0636bea5 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3993 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-37e7489d | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3994 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-a74cca3c | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3995 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-1a338908 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3998 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-a72a71d0 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4183 |  | UI_PROP | dlLine.P_OUT_CELL | line_savings.P_OUT_CELL | 속성 P_OUT_CELL 설정 |  |  |  |
| AC-e1234f4e | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4184 |  | UI_PROP | dlLine._I_CELL | line_savings.I_CELL | 속성 _I_CELL 설정 |  |  |  |
| AC-f11f0f4f | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4185 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-397cb688 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4186 |  | UI_PROP | dlLine.S_CELL | line_savings.S_CELL | 속성 S_CELL 설정 |  |  |  |
| AC-f87e9bc5 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4188 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-6bde03f0 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4189 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-5d98d4c8 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4190 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-32c36cfd | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4191 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-f73a0e92 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4192 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-1baaecf9 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4193 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-0821728b | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4194 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-b180e08a | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4195 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-4f943bd3 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4197 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51dba509 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4102 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf16f188 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4103 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-29770528 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4104 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1a4ceae | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4105 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c100963f | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4106 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-666abc19 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4109 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f080902 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4113 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2bd1e46b | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4114 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6fdc4d25 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4100 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-6368dd91 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4130 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S_CELL": | DATA_OP | loc.S_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e9d9536 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4133 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c9edf51 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4136 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT_CELL": | DATA_OP | loc.P_OUT_CELL.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-d79ed881 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4139 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-01cdb7ff | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4142 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-0af8fae9 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4145 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_CELL": | UI_PROP | loc.I_CELL | row_index | 속성 I_CELL 설정 |  |  |  |
| AC-824e20de | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4151 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-5bb0c66b | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4153 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ed2931c | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4074 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-644f8667 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4038 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d491c47 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4039 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-81c79bce | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4040 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3457a3dc | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4041 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2737c41a | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4042 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa7ca7a2 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4043 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b3466c9 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4045 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e81cd78 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4046 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6613cd6a | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4049 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a2bfa837 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4050 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4535ee54 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4051 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-11d684f2 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4036 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-3c64420b | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4059 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-00353cc6 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4060 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-7464c2c0 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4065 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9efd0c9 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:4011 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00606_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d05ec71f | .ctor | FP00606_BucketSetForm_Popup.cs:70 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-58a10c1a | .ctor | FP00606_BucketSetForm_Popup.cs:71 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-c9e0bf98 | .ctor | FP00606_BucketSetForm_Popup.cs:72 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-53aa3865 | .ctor | FP00606_BucketSetForm_Popup.cs:74 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00606_BucketSetForm_Popup.chk_week_CheckedChanged

진입점: this.chk_week.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b9466fc | this.chk_week.CheckedChanged | FP00606_BucketSetForm_Popup.cs:232 | if (chk_week.Checked) | STATE | chk_week_sun.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-21e77ebb | this.chk_week.CheckedChanged | FP00606_BucketSetForm_Popup.cs:234 | else of (chk_week.Checked) | STATE | chk_week_sun.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00606_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49d7a637 | Dispose | FP00606_BucketSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00606_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-532a076a | this.Load | FP00606_BucketSetForm_Popup.cs:98 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00606_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0f66e93 | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:144 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-95344d5c | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:145 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-28ecefb1 | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:147 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1a1c427 | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:148 |  | DATA_OP | ctrls.Add | (chk_totalBatch) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f417b9d | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:149 |  | DATA_OP | ctrls.Add | (chk_week_sun) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fc04ecb | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:153 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef6ac752 | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:153 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-a1841932 | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:160 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-0e759d09 | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:164 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-80db64f9 | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:168 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00606_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aab7a4f8 | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:115 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-fd2d94e5 | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3e9514e2 | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ecb1892d | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_totalBatch.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-75d345ed | this.Load 외 1 | FP00606_BucketSetForm_Popup.cs:119 |  | VALUE_SET | chk_week_sun.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00606_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b566d185 | (진입점 미연결) | FP00606_BucketSetForm_Popup.cs:239 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-8670f7d6 | (진입점 미연결) | FP00606_BucketSetForm_Popup.cs:241 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00606_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3a42a92 | this.Load | FP00606_BucketSetForm_Popup.cs:85 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4a1f2627 | this.Load | FP00606_BucketSetForm_Popup.cs:93 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00606_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6be12483 | this.usrButton1.Click | FP00606_BucketSetForm_Popup.cs:212 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-77d8330d | this.usrButton1.Click | FP00606_BucketSetForm_Popup.cs:212 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-31f8adae | this.usrButton1.Click | FP00606_BucketSetForm_Popup.cs:214 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-00646acc | this.usrButton1.Click | FP00606_BucketSetForm_Popup.cs:218 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-83c5e905 | this.usrButton1.Click | FP00606_BucketSetForm_Popup.cs:219 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-368004c2 | this.usrButton1.Click | FP00606_BucketSetForm_Popup.cs:221 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-439bd0e0 | this.usrButton1.Click | FP00606_BucketSetForm_Popup.cs:223 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-40dd8e51 | this.usrButton1.Click | FP00606_BucketSetForm_Popup.cs:225 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-39e0d9a8 | this.usrButton1.Click | FP00606_BucketSetForm_Popup.cs:226 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00606_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-397385f8 | this.usrButton2.Click | FP00606_BucketSetForm_Popup.cs:186 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-8a53e6f3 | this.usrButton2.Click | FP00606_BucketSetForm_Popup.cs:186 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-1fceaf3f | this.usrButton2.Click | FP00606_BucketSetForm_Popup.cs:188 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-96e6d094 | this.usrButton2.Click | FP00606_BucketSetForm_Popup.cs:192 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-de903034 | this.usrButton2.Click | FP00606_BucketSetForm_Popup.cs:193 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-ca7dac52 | this.usrButton2.Click | FP00606_BucketSetForm_Popup.cs:194 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-1ee15ec7 | this.usrButton2.Click | FP00606_BucketSetForm_Popup.cs:195 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00606_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-513dae9c | .ctor | FP00606_MeasureSetForm_Popup.cs:77 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-c225ccf3 | .ctor | FP00606_MeasureSetForm_Popup.cs:78 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-31723813 | .ctor | FP00606_MeasureSetForm_Popup.cs:79 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-0747cfe6 | .ctor | FP00606_MeasureSetForm_Popup.cs:81 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00606_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02a36852 | this.btnOK.Click | FP00606_MeasureSetForm_Popup.cs:350 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-958a6912 | this.btnOK.Click | FP00606_MeasureSetForm_Popup.cs:351 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-fde0c6c7 | this.btnOK.Click | FP00606_MeasureSetForm_Popup.cs:358 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-1ff9fa36 | this.btnOK.Click | FP00606_MeasureSetForm_Popup.cs:359 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00606_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc6f5c32 | this.btnSet.Click | FP00606_MeasureSetForm_Popup.cs:290 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-d71405bb | this.btnSet.Click | FP00606_MeasureSetForm_Popup.cs:291 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-ffb20ca9 | this.btnSet.Click | FP00606_MeasureSetForm_Popup.cs:293 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-71ff6a0f | this.btnSet.Click | FP00606_MeasureSetForm_Popup.cs:294 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7535d678 | this.btnSet.Click | FP00606_MeasureSetForm_Popup.cs:296 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-09f26755 | this.btnSet.Click | FP00606_MeasureSetForm_Popup.cs:298 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-710f0553 | this.btnSet.Click | FP00606_MeasureSetForm_Popup.cs:299 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00606_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca5ff119 | Dispose | FP00606_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00606_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae68a25b | this.Load | FP00606_MeasureSetForm_Popup.cs:105 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00606_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb795c20 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:205 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-0f90429f | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:206 |  | FLAG | measure_val | new bool[uom_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-8d4078dd | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:207 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-f6c45e22 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:213 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7ce6223 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:214 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-118bcfab | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:215 |  | DATA_OP | ctrls.Add | (chk_result_in) | 데이터 객체 조작/조회 |  |  |  |
| AC-98ecc49d | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:217 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c6eea2e | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:218 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-5bf0ce56 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:219 |  | DATA_OP | ctrls.Add | (chk_result_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-148d358f | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:221 |  | DATA_OP | ctrls.Add | (chk_gap_in) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca51960f | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:222 |  | DATA_OP | ctrls.Add | (chk_gap_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-fee9dcd5 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:225 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-83454dcf | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:226 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-51421b21 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:228 |  | DATA_OP | ctrls.Add | (chk_seq) | 데이터 객체 조작/조회 |  |  |  |
| AC-31e9c49e | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:229 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-b310ee40 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_offtime) | 데이터 객체 조작/조회 |  |  |  |
| AC-b35afd10 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9c32914 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9c0d27b | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_result_in_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-096d296b | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:238 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b0d3815 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab744598 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_result_out_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-49dc8372 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:242 |  | DATA_OP | ctrls.Add | (chk_gap_in_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-e71b933f | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_gap_out_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-83f0a1b8 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:245 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c7864e1 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:246 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-3195edaa | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:248 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-dab9a023 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:249 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-be83539f | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:252 |  | DATA_OP | ctrls.Add | (chk_pc) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0cc1de2 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:253 |  | DATA_OP | ctrls.Add | (chk_jr) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab7082f0 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:254 |  | DATA_OP | ctrls.Add | (chk_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e8b62a2 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-da03b8b7 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:259 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e2ec621 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:259 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-b7ef3521 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:266 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-4e63c486 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:270 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-39e94fe6 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:274 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00606_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3e90769 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e228e1fd | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2de845a3 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_result_in.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-caaa061f | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ee676a0a | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1bdacd5f | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_result_out.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9f3bdcb6 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_gap_in.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7584b429 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_gap_out.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d5f6ba7f | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-21d702a5 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-696698a5 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_seq.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2e9f87d4 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_pc.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-996e6ad4 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_jr.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-84b68b6e | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_cell.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3ad5d9aa | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_batch.Text | uom_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-922509fd | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:168 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-435d578f | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-cadf3204 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_result_in_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9a82e330 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:172 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8dbceec5 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:173 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8b2b8437 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:174 |  | VALUE_SET | chk_result_out_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ede0ba27 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:176 |  | VALUE_SET | chk_gap_in_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ca987586 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:177 |  | VALUE_SET | chk_gap_out_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-dd9f2b8d | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:179 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ccb70fad | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:180 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2b58c0e3 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:183 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c1f75d94 | this.Load 외 1 | FP00606_MeasureSetForm_Popup.cs:184 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00606_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52837de8 | (진입점 미연결) | FP00606_MeasureSetForm_Popup.cs:369 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-f2b1fc54 | (진입점 미연결) | FP00606_MeasureSetForm_Popup.cs:371 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00606_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ac182a3 | this.Load | FP00606_MeasureSetForm_Popup.cs:92 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c034417c | this.Load | FP00606_MeasureSetForm_Popup.cs:100 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00606_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45235e3c | this.btnSet.Click 외 1 | FP00606_MeasureSetForm_Popup.cs:305 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-70bfe6da | this.btnSet.Click 외 1 | FP00606_MeasureSetForm_Popup.cs:313 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-7f94e006 | this.btnSet.Click 외 1 | FP00606_MeasureSetForm_Popup.cs:313 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-5402b0b4 | this.btnSet.Click 외 1 | FP00606_MeasureSetForm_Popup.cs:330 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-224e6a3e | this.btnSet.Click 외 1 | FP00606_MeasureSetForm_Popup.cs:341 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d771a99 | .ctor | FP00606_PlanBy_Model_Electrode.cs:199 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00606_PlanBy_Model_Electrode.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92bd48a3 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:759 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c2c41c4f | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:760 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-90c2e508 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:761 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e58e2064 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:762 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e9256f3a | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:763 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9584091b | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:764 |  | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-da8e8373 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:772 | if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d662b8b | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:773 | if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c79cb885 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:774 | if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f8f8e8e3 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:778 | else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8ec0333c | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:779 | else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dd83817a | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:780 | else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c85b2dc1 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:783 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-02613e84 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:785 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b9a2e752 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:786 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-eaa0ec03 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:787 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-cf6885ee | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:788 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c45a21b8 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:790 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00606_" + SpdSheet.shtPlanByModelElectrode) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e7666121 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:791 |  | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-2fbd47d9 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:795 |  | CALL_EXT | DataService.ToLoopParam2 | ("", Data_FP.CallGeneralProcedure2(("PR_UI_FP00612_ETC").ToUpper(), Filter, _CurrentUser, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f4b9af8 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:795 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00612_ETC").ToUpper(), Filter, _CurrentUser, "SELECT", "CURR_DATE_COL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d379f238 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:802 | if (string.IsNullOrEmpty(D_COL[0])) | DATA_OP | Filter["CURR_DATE_COL"] | "-999" | 행/컬럼 값 대입 |  |  |  |
| AC-0a3eadae | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:806 | else of (string.IsNullOrEmpty(D_COL[0])) | DATA_OP | Filter["CURR_DATE_COL"] | D_COL_DATA[1] | 행/컬럼 값 대입 |  |  |  |
| AC-f5d9d008 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:819 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtMap, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8a7510df | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:820 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeek, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e2ace50d | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:821 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH", dtMonth, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0ea415e7 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:824 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("_DATE", dtBuk, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54456284 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:836 | if (measure != null) ▸ foreach (DataRow row in dtCategory.Rows) ▸ for (m < measure.items.Count) ▸ if (sMeasurkName.Equals(measure[sMeasurkNa… | DATA_OP | row["MEA_VALUE"] | measure[sMeasurkName].On.ToString().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-05f96fbb | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:843 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_ID", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-171c70f1 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:844 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MEA_VALUE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-61bde3d8 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:845 |  | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("TYPE", dtCategory, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ad5a1195 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:847 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-42fd5465 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:848 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-4e920dc4 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:849 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-76f437bb | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:850 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-c821e9fe | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:851 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-48b64501 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:852 |  | DATA_OP | Filter["CATE_VALUE"] | cate_value | 행/컬럼 값 대입 |  |  |  |
| AC-641daa4e | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:853 |  | DATA_OP | Filter["CATE_TYPE"] | cate_type | 행/컬럼 값 대입 |  |  |  |

## FP00606_PlanBy_Model_Electrode.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2efad310 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:859 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; DataTable dtWeekMonth = null; string… | ⚠ 의미 확인 필요 |  |  |  |
| AC-011a26a8 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:873 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a71cd926 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:874 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-7514ad67 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:883 | lambda ▸ if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_day2WeekAndMonth", Filter["BUCKET_FROM"], Filter["BUCKET_TO… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e25d6b74 | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:887 | lambda ▸ else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_day2WeekAndMonth", Filter["BUCKET_FROM"], Filter["BUCKET_TO… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-219e087c | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:950 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_currDateCol", Filter["INSTANCE_ID"], Filter["BUCKET_FROM"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00606_PlanBy_Model_Electrode.btn_setupinfo_Click

진입점: this.btnSetupColor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9072abf | this.btnSetupColor.Click | FP00606_PlanBy_Model_Electrode.cs:3158 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-97b0bc0d | this.btnSetupColor.Click | FP00606_PlanBy_Model_Electrode.cs:3159 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93f09211 | this.btnSetupColor.Click | FP00606_PlanBy_Model_Electrode.cs:3165 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-3341414b | this.btnSetupColor.Click | FP00606_PlanBy_Model_Electrode.cs:3168 |  | POPUP | new FPC0108_btn_setupinfoPopup | (Filter["INSTANCE_ID"]) | 팝업/폼 생성 |  |  |  |
| AC-c2448b5a | this.btnSetupColor.Click | FP00606_PlanBy_Model_Electrode.cs:3176 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4d9a505a | this.btnSetupColor.Click | FP00606_PlanBy_Model_Electrode.cs:3177 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00606_PlanBy_Model_Electrode.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eb33518 | this.btnBucket.Click | FP00606_PlanBy_Model_Electrode.cs:3086 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-469187ae | this.btnBucket.Click | FP00606_PlanBy_Model_Electrode.cs:3089 |  | FLAG | weekSunChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-405a2812 | this.btnBucket.Click | FP00606_PlanBy_Model_Electrode.cs:3094 |  | POPUP | new FP00606_BucketSetForm_Popup | ("FP00606", SpdSheet.shtPlanByModelElectrode, false, "") | 팝업/폼 생성 |  |  |  |
| AC-d6c00b69 | this.btnBucket.Click | FP00606_PlanBy_Model_Electrode.cs:3095 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-69b6b4d0 | this.btnBucket.Click | FP00606_PlanBy_Model_Electrode.cs:3096 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-cb5b8c09 | this.btnBucket.Click | FP00606_PlanBy_Model_Electrode.cs:3097 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f395b0ff | this.btnBucket.Click | FP00606_PlanBy_Model_Electrode.cs:3102 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-651539bb | this.btnBucket.Click | FP00606_PlanBy_Model_Electrode.cs:3104 | if (frm.DialogResult == DialogResult.OK) ▸ if (measure["chk_week_sun"] != null && week_sun != measure["chk_week_sun"].On) | FLAG | weekSunChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-340ff8cf | this.btnBucket.Click | FP00606_PlanBy_Model_Electrode.cs:3128 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ i… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-56144aa3 | this.btnBucket.Click | FP00606_PlanBy_Model_Electrode.cs:3137 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-90d3b3ac | this.btnBucket.Click | FP00606_PlanBy_Model_Electrode.cs:3147 | if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00606_PlanBy_Model_Electrode.btnCatagory_Click

진입점: this.btnCatagory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5027522 | this.btnCatagory.Click | FP00606_PlanBy_Model_Electrode.cs:3028 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-0e63e3b9 | this.btnCatagory.Click | FP00606_PlanBy_Model_Electrode.cs:3031 |  | POPUP | new FP00606_MeasureSetForm_Popup | ("FP00606", SpdSheet.shtPlanByModelElectrode, false, "") | 팝업/폼 생성 |  |  |  |
| AC-9166672d | this.btnCatagory.Click | FP00606_PlanBy_Model_Electrode.cs:3032 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-9e9f3d71 | this.btnCatagory.Click | FP00606_PlanBy_Model_Electrode.cs:3033 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d2c9ae05 | this.btnCatagory.Click | FP00606_PlanBy_Model_Electrode.cs:3034 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-656769e5 | this.btnCatagory.Click | FP00606_PlanBy_Model_Electrode.cs:3039 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-0cbae168 | this.btnCatagory.Click | FP00606_PlanBy_Model_Electrode.cs:3051 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-274e5ded | this.btnCatagory.Click | FP00606_PlanBy_Model_Electrode.cs:3060 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c4241dba | this.btnCatagory.Click | FP00606_PlanBy_Model_Electrode.cs:3065 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-2b3a21bc | this.btnCatagory.Click | FP00606_PlanBy_Model_Electrode.cs:3071 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00606_PlanBy_Model_Electrode.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-945f5285 | this.btnColumn.Click | FP00606_PlanBy_Model_Electrode.cs:2983 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a2afd7b5 | this.btnColumn.Click | FP00606_PlanBy_Model_Electrode.cs:2986 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00606", SpdSheet.shtPlanByModelElectrode, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-bdd9112e | this.btnColumn.Click | FP00606_PlanBy_Model_Electrode.cs:2987 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-afdc304d | this.btnColumn.Click | FP00606_PlanBy_Model_Electrode.cs:2988 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-803ada62 | this.btnColumn.Click | FP00606_PlanBy_Model_Electrode.cs:2991 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5f542637 | this.btnColumn.Click | FP00606_PlanBy_Model_Electrode.cs:2996 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-c0b61434 | this.btnColumn.Click | FP00606_PlanBy_Model_Electrode.cs:2996 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanByModelElectrode) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3107aeda | this.btnColumn.Click | FP00606_PlanBy_Model_Electrode.cs:2997 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-dffeaab6 | this.btnColumn.Click | FP00606_PlanBy_Model_Electrode.cs:3003 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-dc7e8790 | this.btnColumn.Click | FP00606_PlanBy_Model_Electrode.cs:3004 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00606_PlanBy_Model_Electrode.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52bbac13 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3213 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-f7241870 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3214 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d12e7f19 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3217 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-78030b31 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3219 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-2ddd256d | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3220 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cf8ba058 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3221 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-fa5cc164 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3222 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-ed27362b | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3223 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6fecfdbb | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3223 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-79c346d0 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3224 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-43daaaec | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3225 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1664b2f0 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3226 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-0a98982a | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3227 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3e21e9af | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3228 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ed8eb088 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3229 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-35a49746 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3230 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-007189f3 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3231 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-556d711e | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3232 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6bb63dba | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3234 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1f554d68 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3235 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-b66ce983 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3236 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-f8203878 | this.btnMemo.Click | FP00606_PlanBy_Model_Electrode.cs:3237 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00606_PlanBy_Model_Electrode.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2541ddf6 | this.btnPlanInfo.Click | FP00606_PlanBy_Model_Electrode.cs:3187 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-e6962c34 | this.btnPlanInfo.Click | FP00606_PlanBy_Model_Electrode.cs:3188 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0579c026 | this.btnPlanInfo.Click | FP00606_PlanBy_Model_Electrode.cs:3194 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-e0cb627b | this.btnPlanInfo.Click | FP00606_PlanBy_Model_Electrode.cs:3197 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-98c5a909 | this.btnPlanInfo.Click | FP00606_PlanBy_Model_Electrode.cs:3198 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-055c05c4 | this.btnPlanInfo.Click | FP00606_PlanBy_Model_Electrode.cs:3198 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a85f2754 | this.btnPlanInfo.Click | FP00606_PlanBy_Model_Electrode.cs:3199 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-7b1df5e5 | this.btnPlanInfo.Click | FP00606_PlanBy_Model_Electrode.cs:3200 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-22c06810 | this.btnPlanInfo.Click | FP00606_PlanBy_Model_Electrode.cs:3202 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cc7bc5d0 | this.btnPlanInfo.Click | FP00606_PlanBy_Model_Electrode.cs:3203 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00606_PlanBy_Model_Electrode.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb894897 | this.btnSql.Click | FP00606_PlanBy_Model_Electrode.cs:3248 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-026f1634 | this.btnSql.Click | FP00606_PlanBy_Model_Electrode.cs:3251 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d43087b6 | this.btnSql.Click | FP00606_PlanBy_Model_Electrode.cs:3252 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-42243409 | this.btnSql.Click | FP00606_PlanBy_Model_Electrode.cs:3254 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00606_FIND_FP00606") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f7a03dd | this.btnSql.Click | FP00606_PlanBy_Model_Electrode.cs:3257 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00606_PlanBy_Model_Electrode.CheckAndGetMeasure

진입점: this.Load / popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a4fd756 | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2243 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-84135ed2 | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2243 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-6eb2ecf1 | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2245 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00606_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3594c4e2 | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2245 |  | POPUP | new FP00606_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-5ce38adc | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2246 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00606_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-15843737 | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2246 |  | POPUP | new FP00606_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-a000f5ac | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2250 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-13b67b32 | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2251 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-a3fa69cd | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2252 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab6b9436 | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2253 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-b2762f6c | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2254 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd10a7d4 | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2255 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |
| AC-e15be771 | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2256 |  | DATA_OP | measure.Data.ContainsKey | ("chk_totalBatch") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb9e596b | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2257 | if (measure.Data.ContainsKey("chk_totalBatch")) | FLAG | weekTOT_measure | measure.Data["chk_totalBatch"] | 화면 필드/플래그 변경 |  |  |  |
| AC-9e8ba94b | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2258 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week_sun") | 데이터 객체 조작/조회 |  |  |  |
| AC-85af40d9 | this.Load 외 4 | FP00606_PlanBy_Model_Electrode.cs:2259 | if (measure.Data.ContainsKey("chk_week_sun")) | FLAG | week_measure_sun | measure.Data["chk_week_sun"] | 화면 필드/플래그 변경 |  |  |  |

## FP00606_PlanBy_Model_Electrode.CreateFilterDataSet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afe5667e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1427 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8e009b9e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1439 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-43c6127d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1440 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-775957a3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1468 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d786a35 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1473 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-efededab | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1478 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9f732b7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1483 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-453f4f52 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1491 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f38aafbf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1496 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b036fcc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1501 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8890aecf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1506 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aaea7158 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1514 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8664b05 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1519 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9826d8d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1524 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-779e3e07 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1529 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8dda02ac | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1537 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-96b8da20 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1542 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aca98b07 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1547 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8dd1e542 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1552 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5bfb874 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1560 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-66e7b946 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1565 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-770e6183 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1570 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec83893c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1575 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c320308 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1583 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d48b99a6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1588 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a534460 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1593 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9906a963 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1598 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e98cb58 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1606 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6659cfad | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1611 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-db591119 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1616 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7219b3b6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1621 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6039c78 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1629 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5139cec7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1634 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-83495fce | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1639 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-224451a5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1644 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-54b5f717 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1652 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7c36ab4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1657 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c117c83 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1662 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-39122f37 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1667 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff6f2e2d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1675 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-42726681 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1680 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd6289c1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1685 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-137b82aa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1690 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-465d21e5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1700 | if (measure["chk_seq"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_SEQ")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6706fbee | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1706 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d42a5ae | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1712 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe6b146c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1725 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-663731ed | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1730 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac934945 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1735 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee610a50 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1740 | if (measure["chk_mpp_inqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d7bd946 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1748 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4be8c6a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1753 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9afa439f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1758 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-59233cd8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1763 | if (measure["chk_mpp_outqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-abb343bb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1771 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-de70f6e1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1776 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2500ae60 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1781 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7d2de9d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1786 | if (measure["chk_wpp_inqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e78e09f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1794 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-65ac47b2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1799 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-639fd381 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1804 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ffeea28 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1809 | if (measure["chk_wpp_outqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6de11d0d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1817 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-85897814 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1822 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-516a99aa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1827 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5567fede | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1832 | if (measure["chk_inqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a95763ec | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1840 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6153f94f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1845 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e230ee6c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1850 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-71fdf950 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1855 | if (measure["chk_outqty"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb17b563 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1864 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-502043e8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1869 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-698a2f74 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1874 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee8ac017 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1879 | if (measure["chk_result_in"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0416506d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1888 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f112d9b2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1893 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-203a781f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1898 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a399876a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1903 | if (measure["chk_result_out"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-287c17d3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1912 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-82b225fd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1917 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e552393 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1922 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b475daf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1927 | if (measure["chk_gap_in"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cc50bf3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1935 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a49a0f79 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1940 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5640c100 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1945 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6fdeea8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1950 | if (measure["chk_gap_out"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2066dc4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1964 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f11c829b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1969 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-65571ccc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1974 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c64ab46a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1979 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-378193a6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1987 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true"… | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c88dc546 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1992 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-35be4350 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1997 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-775520e2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2002 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-71e52901 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2010 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c992541 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2015 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c34e079d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2020 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c21e6f81 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2025 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e040b59a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2033 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true"… | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-544520fc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2038 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3645ab5a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2043 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1d8d5b6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2048 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3123d414 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2056 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca9b482f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2061 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9dcce2eb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2066 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c10a536b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2071 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-13382994 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2079 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c77ced8e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2084 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-feed2935 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2089 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8208a7a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2094 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd7a706c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2102 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-525a92d9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2107 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d8c750f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2112 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e19c5b7a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2117 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e92dc9ee | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2125 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true"… | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8904fbf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2130 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-30526915 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2135 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4481b6f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2140 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-00a9d028 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2148 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ddce554 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2153 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-328d1675 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2158 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0cf7184 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2163 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_in_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_IN_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f25911c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2171 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_batch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6553883b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2176 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_JR")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a3ecd38 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2181 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_M")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fb59a1b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2186 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_out_tot"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_OUT_CELL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c22ef13 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2213 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40ad925a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2216 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-31163422 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2220 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-c943da14 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2225 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2593627a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2229 | else of (m != null && m.Count() > 0) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9082c13c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2229 | else of (m != null && m.Count() > 0) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-ff2933ac | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2234 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-a39c00fc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2236 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19eb1367 | this.Load | FP00606_PlanBy_Model_Electrode.cs:428 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanByModelElectrode, SpdSheet.shtPlanByModelElectrode, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2cba1171 | this.Load | FP00606_PlanBy_Model_Electrode.cs:429 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanByModelElectrode) | 화면 필드/플래그 변경 |  |  |  |
| AC-bc352695 | this.Load | FP00606_PlanBy_Model_Electrode.cs:430 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanByModelElectrode) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00606_PlanBy_Model_Electrode.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged / this.dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29a9402c | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2876 | if (sender == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4910d1f4 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2882 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-68b064ff | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2889 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | MESSAGE | MessageBox.Show | ("The End date can not be later than the Start date.") | 메시지 표시 |  |  |  |
| AC-3d8c6906 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2890 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-e0d48adf | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2894 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0dbb8f7 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2908 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | FLAG | dtPeriod | Data_FP.Common_FP(Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-f2d35148 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2908 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd1138c3 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2924 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(s… | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(Undefined!") | 메시지 표시 |  |  |  |
| AC-79d0a7b1 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2925 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(s… | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-9747b0d8 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2926 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(s… | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-ffe4ea21 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2947 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(Undefined!") | 메시지 표시 |  |  |  |
| AC-9db312ec | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2948 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-6d2b57c0 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2949 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-2ec7a236 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2959 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod != null) | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(Undefined!") | 메시지 표시 |  |  |  |
| AC-5534a2e1 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2960 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod != null) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-963484b5 | dCalendar_planrange.ValueChanged 외 1 | FP00606_PlanBy_Model_Electrode.cs:2961 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod != null) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8355224c | DeleteButton | FP00606_PlanBy_Model_Electrode.cs:636 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf5ac45f | DeleteButton | FP00606_PlanBy_Model_Electrode.cs:637 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27eba319 | Dispose | FP00606_PlanBy_Model_Electrode.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00606_PlanBy_Model_Electrode.DrawHeader

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82df4934 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1033 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-21a3ad2c | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1037 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-78315aa9 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1038 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-466b108f | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1039 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a49b7f4 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1040 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b08e69a0 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1041 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-51bb6fbe | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1045 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-d49809a7 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1046 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-cba27243 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1047 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-311897df | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1048 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-436b0520 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1060 | else of (with_day_part == false) | CALL_EXT | measure.Data.TryGetValue | ("chk_totalBatch", out total_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d30eab3 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1070 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(bUse_month, bUse_week, bUse_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-6ef8abb9 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1075 | else of (with_day_part == false) ▸ if (bUse_total) | FLAG | DayColumnCount | += (calendar.weeks.Count + 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-55162b55 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1080 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3f613de | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1137 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanByModelElectrode, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9feda727 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1143 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) | CALL_EXT | measure.Data.TryGetValue | ("chk_totalBatch", out tmpMeasure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-24e65684 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1147 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) ▸ if (measure.Data.TryGetValue("chk_totalBatch", o… | FLAG | _amendColumnsCnt | measure.AmendColumns.Rows.Count + calendar.weeks.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-b8069f72 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1151 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) ▸ if (measure.Data.TryGetValue("chk_totalBatch", o… | FLAG | _amendColumnsCnt | measure.AmendColumns.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-f5d57c09 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1156 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (measure.AmendColumns != null) ▸ else of (measure.Data.TryGetValue("chk_totalBatc… | FLAG | _amendColumnsCnt | measure.AmendColumns.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-a6cdcf09 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1163 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | DayColumnCount | siMain.SetAmendHeaderColumnWithTotal_FP(calendar, bUse_month, bUse_week, bUse_day, bUse_to… | 화면 필드/플래그 변경 |  |  |  |
| AC-78ba66a1 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1163 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumnWithTotal_FP | (calendar, bUse_month, bUse_week, bUse_day, bUse_total, 2, FPExtensions.DateColumnType.TYP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e16f2739 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1166 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d0704882 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1167 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3bea4e70 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1168 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-9055ee91 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1173 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-0c972336 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1175 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-bd54cadf | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1176 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd731291 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:1181 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP00606_PlanBy_Model_Electrode.DrawSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d90e2ae | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1222 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3e2ba113 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1224 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-735661e1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1249 |  | CALL_EXT | MemoService.ShowMemo | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3dbd1ab | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1250 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-085854ae | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1252 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00606_PlanBy_Model_Electrode.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38ac42fb | EditButton | FP00606_PlanBy_Model_Electrode.cs:643 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-10c11b05 | EditButton | FP00606_PlanBy_Model_Electrode.cs:644 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc3ac32b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00606_PlanBy_Model_Electrode.cs:688 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24205b44 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00606_PlanBy_Model_Electrode.cs:692 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dbed89e9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00606_PlanBy_Model_Electrode.cs:696 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-2c814bb6 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00606_PlanBy_Model_Electrode.cs:700 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00606_PlanBy_Model_Electrode.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e591d45 | ExcelButton | FP00606_PlanBy_Model_Electrode.cs:658 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-263dc4d2 | ExcelButton | FP00606_PlanBy_Model_Electrode.cs:659 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-9bbe8fe0 | ExcelButton | FP00606_PlanBy_Model_Electrode.cs:661 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5eea7f56 | ExcelButton | FP00606_PlanBy_Model_Electrode.cs:665 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-cf5aae4c | ExcelButton | FP00606_PlanBy_Model_Electrode.cs:666 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-5639a61f | ExcelButton | FP00606_PlanBy_Model_Electrode.cs:667 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-e15bdce7 | ExcelButton | FP00606_PlanBy_Model_Electrode.cs:670 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-fc079ed0 | ExcelButton | FP00606_PlanBy_Model_Electrode.cs:671 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-4aa135c3 | ExcelButton | FP00606_PlanBy_Model_Electrode.cs:672 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-56a40f1d | ExcelButton | FP00606_PlanBy_Model_Electrode.cs:674 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-411ef7b3 | ExcelButton | FP00606_PlanBy_Model_Electrode.cs:675 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0f3653b | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:747 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00606_FIND_FP00606", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-dfa8baab | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:749 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-d00eb7be | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:753 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.Find_Data_Memo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8a58783 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:2421 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00606_FIND_FP00606", Filter, _CurrentUser, pSysType, "SELECT_MEA_MEMO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-91c4ba1a | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:2424 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-55a887e6 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:2428 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.FindTotalColorStart

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a69e745 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1421 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16c4c6f5 | this.Load | FP00606_PlanBy_Model_Electrode.cs:221 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00606_PlanBy_Model_Electrode.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606") ▸ try ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c418649f | popSql.OnSql [if (programID == "PR_UI_FP00606_FIND_FP00606")… 외 3 | FP00606_PlanBy_Model_Electrode.cs:3656 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.GetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d0c0d8e | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3664 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3227d7d3 | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3665 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9049015 | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3665 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-301965c9 | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3667 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-dcfe33f6 | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3669 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-492a4b39 | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3672 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-e971a920 | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3673 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-12c3c578 | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3673 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-3a29c865 | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3674 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-71c3f983 | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3675 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4ad1ed15 | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3676 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0aba9a1a | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3680 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00606_PlanBy_Model_Electrode.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1b65d9c | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3919 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-9496f42f | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3920 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.GetToDay

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a232b06c | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3868 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-84304724 | this.Load [try] | FP00606_PlanBy_Model_Electrode.cs:3869 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.GoDrawCellColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c215ed9d | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2265 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50981f42 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2329 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3de7d293 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:2330 | if (current_src != null && calendar != null) ▸ if (measure.Day.On) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-703e677b | this.Load | FP00606_PlanBy_Model_Electrode.cs:289 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7e941148 | this.Load | FP00606_PlanBy_Model_Electrode.cs:292 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanByModelElectrode) | 데이터 객체 조작/조회 |  |  |  |
| AC-4050a1e8 | this.Load | FP00606_PlanBy_Model_Electrode.cs:294 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-cb6b3427 | this.Load | FP00606_PlanBy_Model_Electrode.cs:295 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4168e676 | this.Load | FP00606_PlanBy_Model_Electrode.cs:298 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-043f1319 | this.Load | FP00606_PlanBy_Model_Electrode.cs:302 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a51be96f | this.Load | FP00606_PlanBy_Model_Electrode.cs:326 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-bcf7a965 | this.Load | FP00606_PlanBy_Model_Electrode.cs:327 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-96940b5a | this.Load | FP00606_PlanBy_Model_Electrode.cs:328 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-61e979ea | this.Load | FP00606_PlanBy_Model_Electrode.cs:334 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00606_PlanBy_Model_Electrode.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84d57005 | this.Load | FP00606_PlanBy_Model_Electrode.cs:256 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f41d7f77 | this.Load | FP00606_PlanBy_Model_Electrode.cs:257 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-7fa5f00d | this.Load | FP00606_PlanBy_Model_Electrode.cs:258 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-53e7405b | this.Load | FP00606_PlanBy_Model_Electrode.cs:259 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5a85bf47 | this.Load | FP00606_PlanBy_Model_Electrode.cs:260 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ed74ce4a | this.Load | FP00606_PlanBy_Model_Electrode.cs:261 |  | UI_PROP | mcbo_prod_type.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.InitSpread

진입점: this.Load / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-390b3bc6 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:443 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8222838b | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:444 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanByModelElectrode) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c159e8e7 | this.Load 외 6 | FP00606_PlanBy_Model_Electrode.cs:448 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00606_PlanBy_Model_Electrode.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2e985e8 | InsertButton | FP00606_PlanBy_Model_Electrode.cs:628 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-66a5788f | InsertButton | FP00606_PlanBy_Model_Electrode.cs:629 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a82c8fe0 | memo_menu.Click | FP00606_PlanBy_Model_Electrode.cs:3583 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a28995f7 | memo_menu.Click | FP00606_PlanBy_Model_Electrode.cs:3586 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2e82f50 | memo_menu.Click | FP00606_PlanBy_Model_Electrode.cs:3590 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00606_PlanBy_Model_Electrode.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4143fb10 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3605 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5f0a576 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3608 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da56d74e | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3626 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-9e8a128c | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3627 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8c9ed2a4 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3628 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-10168119 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3629 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-49ca96f8 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3630 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-b0094cd2 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3631 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-b2f76a67 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3632 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6dbf8fe0 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3633 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fa5cc3a3 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3634 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00606_PlanBy_Model_Electrode.onZeroBucketMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2255c10 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3501 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56529cba | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3504 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4ec75ad | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3528 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.onZeroMaterialMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-012f269e | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3542 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-974b0593 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3545 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8b22785 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3569 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.OpenLineMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-207f4c9c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3267 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-74511723 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3268 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-b7d79e3a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3269 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-0d985a53 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3269 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8619084c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3270 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-1bf9b1db | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3271 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c6ef3368 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3272 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ebd08de6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3277 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e22f06c4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3280 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.OpenMaterialMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f396d5b4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3286 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-39074c6b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3287 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-1a1fa156 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3288 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-2e87b65a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3288 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f6138c69 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3289 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-a51a18f5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3290 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-85605194 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3291 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-eae2bbe6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3295 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3f1434f8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00606_PlanBy_Model_Electrode.cs:3297 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00606_PlanBy_Model_Electrode.Query

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnBucket.Click [if (frm.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2767a09 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1195 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-040784e3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1195 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6e0cd549 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1196 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-1dff1351 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1196 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-be3a54ec | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1197 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-9847ad2b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1197 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1ede85b5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1200 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-907c6486 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1207 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-efe1ce38 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1212 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-23190377 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1213 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7fdbbed | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1215 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00606_PlanBy_Model_Electrode.RefreshHeadAndBody

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8623bc74 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1002 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-489be5bf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1019 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-92f088fa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1023 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00606_PlanBy_Model_Electrode.RefreshSpreadSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb709b9f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:978 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f5989ac | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:978 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-e3fc1b68 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:990 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-27c2ace2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:995 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00606_PlanBy_Model_Electrode.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd60de53 | popSql.OnSql | FP00606_PlanBy_Model_Electrode.cs:3888 | if (programID == "PR_UI_FP00606_FIND_FP00606") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-a3802769 | popSql.OnSql | FP00606_PlanBy_Model_Electrode.cs:3901 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0069ae62 | SaveButton | FP00606_PlanBy_Model_Electrode.cs:650 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6baedc3d | SaveButton | FP00606_PlanBy_Model_Electrode.cs:651 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetCalenderColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74ac7967 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1330 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-87aba33c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1334 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (da… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-ccd4aba5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1336 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b10498fc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1340 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Day.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else o… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-32134c8b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1356 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |
| AC-8e373a0c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1371 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Month.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-52bc0c42 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1388 | if (calendar != null && dsMainFiltered.Good()) ▸ if (measure.Week.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen… | 그리드 표시 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetChangeControl

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / cbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / mcbo_prod_type.SelectedIndexChanged / chk_allLine.CheckedChanged / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.chkInAct.CheckedChanged / this.chk_allLine.CheckedChanged / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbca1ff7 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:345 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5efc441c | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:345 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-76e03279 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:354 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-dd6e6ce9 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:355 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-79326bc7 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:355 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-17ca455f | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:356 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-87a760b4 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:362 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8d6bfac9 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:363 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d6c95da5 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:363 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ba484822 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:364 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b8ea4ac3 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:370 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8cc899e9 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:371 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2658d747 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:371 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8f468bd1 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:372 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-70a7b497 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:378 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-d8b9a639 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:379 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-cb787113 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:379 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c7b0cc0c | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:380 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ec444d95 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:387 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-6ef8e597 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:389 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-ab454798 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:390 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa84dbfd | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:391 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-24afafc3 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:392 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fc88c078 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:393 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | GRID_SET | dtOperation.Rows[0]["CODE"] | "E2000" | 그리드 속성/값 설정 |  |  |  |
| AC-a673cc16 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:394 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | GRID_SET | dtOperation.Rows[0]["NAME"] | "(E2000)Coating" | 그리드 속성/값 설정 |  |  |  |
| AC-50c5f586 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:396 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bfe815c2 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:402 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-cd503a0b | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:403 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9137383a | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:403 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ba337929 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:404 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5787fd03 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:410 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-038d1f3e | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:414 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, mcbo_prod_type.ControlValues… | 행/컬럼 값 대입 |  |  |  |
| AC-150219c0 | this.Load [try] 외 13 | FP00606_PlanBy_Model_Electrode.cs:414 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PROD_TYPE"] | CString.GetCheckedListValue(dtProdType, mcbo_prod_type.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetColumnsFormat

진입점: this.Load [if (!with_day_part)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ if (!with_day_part)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49a8e60c | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2452 | if (siMain != null) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (om… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c4805fc | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2455 | if (siMain != null) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else o… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d07f7bea | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2478 | if (siMain != null) ▸ if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99257a8c | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2481 | if (siMain != null) ▸ if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bdd153b8 | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2506 | if (siMain != null) ▸ if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d678afc | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2509 | if (siMain != null) ▸ if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ el… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46390beb | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2528 | if (siMain != null) ▸ if (calendar.Days != null) ▸ if (colindex != -1) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-90ae3086 | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2535 | if (siMain != null) ▸ if (calendar.Days != null) ▸ if (colindex != -1) ▸ for (i < weekCnt) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c82334f3 | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2550 | if (siMain != null) | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-27e5079b | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2567 | if (siMain != null) ▸ if (iLV1_NAME == -1 \|\| iCATEGORY_NAME == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3c4ccd6 | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2574 | if (siMain != null) | DATA_OP | listBatchInx.Add | (batchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-5010db1a | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2602 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.ActiveSh… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-3734253b | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2603 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.ActiveSh… | DATA_OP | siMain.ActiveSheet.Cells[i, j].Value.ToString().Contains | ("-") | 데이터 객체 조작/조회 |  |  |  |
| AC-85059201 | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2605 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ if (indexCollection) ▸ for (j < siMain.ActiveSh… | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-84775b9a | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2625 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.Act… | DATA_OP | listBatchInx.Add | (batchIndex) | 데이터 객체 조작/조회 |  |  |  |
| AC-06a803af | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2632 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.Act… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-9b4d1689 | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2633 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.Act… | DATA_OP | siMain.ActiveSheet.Cells[i, j].Value.ToString().Contains | ("-") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc21b18a | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2635 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (measure_name == "Batch") ▸ else of (indexCollection) ▸ for (j < siMain.Act… | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-b411d459 | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2664 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (category_name == "Plan(In)") ▸ if (measure_name == "Batch") ▸ for (j < siM… | GRID_SET | siMain.ActiveSheet.Cells[i, j].Value | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-a0ea02f9 | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2665 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (category_name == "Plan(In)") ▸ if (measure_name == "Batch") ▸ for (j < siM… | GRID_SET | siMain.ActiveSheet.Cells[i, j].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-e5f5b321 | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2666 | if (siMain != null) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (category_name == "Plan(In)") ▸ if (measure_name == "Batch") ▸ for (j < siM… | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-bbffada5 | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2686 | if (siMain != null) ▸ if (ippm != -1) | UI_PROP | num_ppm.DecimalPlaces | place_ppm | 속성 DecimalPlaces 설정 |  |  |  |
| AC-d3e64c1b | this.Load [if (!with_day_part)] 외 6 | FP00606_PlanBy_Model_Electrode.cs:2687 | if (siMain != null) ▸ if (ippm != -1) | GRID_SET | siMain.ActiveSheet.Columns[ippm].CellType | num_ppm | 그리드 속성/값 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ff393f7 | this.Load | FP00606_PlanBy_Model_Electrode.cs:241 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e1b2c79 | this.Load | FP00606_PlanBy_Model_Electrode.cs:243 | if (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-871438dc | this.Load | FP00606_PlanBy_Model_Electrode.cs:244 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-a37d17b9 | this.Load | FP00606_PlanBy_Model_Electrode.cs:248 | else of (UserService.HasExtraRole(_CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-213fd57f | this.Load | FP00606_PlanBy_Model_Electrode.cs:249 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetDirty

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ finally] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ finally] / this.btnBucket.Click / this.btnCatagory.Click / this.btnColumn.Click / FindButton [try ▸ if (siMain.ActiveSheet.SheetName ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2163b1e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:3014 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9ba7937 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3686 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa77c4be | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3686 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4e1698de | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3687 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e920154 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3713 |  | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-bf44f1c0 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3713 |  | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0862b46e | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3714 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_factory.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6c167d8 | this.Load [try] 외 24 | FP00606_PlanBy_Model_Electrode.cs:3651 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetModelLT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b208f9ba | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3759 |  | FLAG | dtModelLT | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00619_find_Model_List", Filter["… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-4358d790 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3759 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00619_find_Model_List", Filter["BUCKET_FROM"], Filter["BUCKET_TO"] , F… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetNickNameLT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c433885 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3769 |  | FLAG | dtNickNameLT | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00619_find_NickName_List", Filte… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-5010f6e5 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3769 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00619_find_NickName_List", Filter["BUCKET_FROM"], Filter["BUCKET_TO"] … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b8639de | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3720 |  | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa3f060a | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3720 |  | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-340488b2 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3721 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetPlanPeriod

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df6736f4 | this.Load [try] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3790 |  | FLAG | dtPeriod | Data_FP.Common_FP(Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-3173879c | this.Load [try] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3790 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-35c277fa | this.Load [try] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3805 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-be03b807 | this.Load [try] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3806 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-632b9a05 | this.Load [try] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3810 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-14c139e8 | this.Load [try] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3811 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-dfc79558 | this.Load [try] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3817 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-5d58c9bd | this.Load [try] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3818 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cab03780 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3706 |  | FLAG | dtSite | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ae477864 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3706 |  | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1daaca8c | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3707 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetProdType

진입점: this.Load [try] / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94325d38 | this.Load [try] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3733 |  | FLAG | dtProdType | DataService.GetProdType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b78cbfed | this.Load [try] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3733 |  | CALL_EXT | DataService.GetProdType | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-138abeed | this.Load [try] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3735 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prod_type, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f794df0 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3695 |  | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-85995dc2 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3695 |  | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e26b4342 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3696 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d7c632d1 | (진입점 미연결) | FP00606_PlanBy_Model_Electrode.cs:3699 | if (dtSite.Rows.Count == 1) | VALUE_SET | cbo_site.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (mont…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df78c46e | this.Load [try] 외 6 | FP00606_PlanBy_Model_Electrode.cs:456 | if (sheetName.Equals(SpdSheet.shtPlanByModelElectrode)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e74a35d2 | this.Load [try] 외 6 | FP00606_PlanBy_Model_Electrode.cs:457 | if (sheetName.Equals(SpdSheet.shtPlanByModelElectrode)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SetTotalColor

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d186da3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1298 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "DATA": ▸ if… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_version, line, idx_version, Color.Orange) | 그리드 표시 설정 |  |  |  |
| AC-623fdd60 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00606_PlanBy_Model_Electrode.cs:1307 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |

## FP00606_PlanBy_Model_Electrode.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1839d482 | this.spdMain.CellClick | FP00606_PlanBy_Model_Electrode.cs:3477 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-ab2be208 | this.spdMain.CellClick | FP00606_PlanBy_Model_Electrode.cs:3478 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-88c1d8d8 | this.spdMain.CellClick | FP00606_PlanBy_Model_Electrode.cs:3480 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-828cd7e0 | this.spdMain.CellClick | FP00606_PlanBy_Model_Electrode.cs:3488 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00606_PlanBy_Model_Electrode.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23e4c194 | this.spdMain.CellDoubleClick | FP00606_PlanBy_Model_Electrode.cs:3442 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-1475cf64 | this.spdMain.CellDoubleClick | FP00606_PlanBy_Model_Electrode.cs:3449 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00606_PlanBy_Model_Electrode.SwitchMemo

진입점: memo_menu.Click [try ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb2c4106 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3307 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab628834 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3324 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-f990251f | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3355 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-2817ae0b | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3356 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-da2111da | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3358 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5e930c93 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3389 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-f4b2eb58 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3390 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-c1fdb2c7 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00606_PlanBy_Model_Electrode.cs:3392 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00606_PlanBy_Model_Electrode.UIFindData

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged)] / this.btnCatagory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6c9856a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:486 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce79427a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:487 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea247852 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:490 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-746e376f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:500 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-458d2bd0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:515 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f58e4a86 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:516 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88b5abf2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:519 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8a6242b1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:523 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-23690c1c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:524 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0194666a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:534 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fdbe13a0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:536 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-801ba52a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:536 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f023d090 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:549 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > … | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3066311f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:560 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Cou… | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ef5579fe | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:562 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Cou… | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-38644e2c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:564 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Cou… | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-ffdbd03e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:570 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-f2fb48e9 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:572 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-0bb3f19d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:575 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3cf2cc6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:588 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f4982123 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:596 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f40090ce | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:601 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b29f08a9 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:602 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7194596e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:610 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanByModelElectrode) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-113894b5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:615 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-681014ea | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00606_PlanBy_Model_Electrode.cs:619 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

